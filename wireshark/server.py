"""Local stdio tools for Wireshark captures."""
import os
import subprocess
from collections import Counter, defaultdict
from contextlib import contextmanager
from ipaddress import ip_address
from pathlib import Path
from tempfile import TemporaryDirectory

from mcp.server.fastmcp import FastMCP

server = FastMCP("wireshark")
root = Path(os.environ.get("WIRESHARK_MCP_ROOT") or ".").expanduser().resolve()
binaries = Path(os.environ["WIRESHARK_BIN"])
dumpcap = os.environ.get("WIRESHARK_MCP_DUMPCAP")
default_interface = os.environ.get("WIRESHARK_MCP_INTERFACE")


def capture_path(capture: str) -> Path:
    path = (root / capture).resolve(strict=True)
    if not path.is_relative_to(root) or not path.is_file():
        raise ValueError("Choose a capture file in the configured capture directory.")
    if path.suffix.lower() not in {".pcap", ".pcapng", ".cap"}:
        raise ValueError("Expected a .pcap, .pcapng or .cap file.")
    return path


def run(args: list[str], timeout: int = 45) -> str:
    try:
        result = subprocess.run(
            args, capture_output=True, text=True, errors="replace", timeout=timeout, check=False,
        )
    except (OSError, subprocess.TimeoutExpired) as error:
        raise ValueError(str(error)) from error
    if result.returncode:
        raise ValueError(result.stderr.strip()[:2000] or f"{Path(args[0]).name} failed")
    return result.stdout.strip()


def analyze(tool: str, args: list[str], capture: str) -> str:
    return run([str(binaries / tool), *args, str(capture_path(capture))])


@contextmanager
def new_capture(output: str):
    path = (root / output).resolve()
    if not path.is_relative_to(root) or path.suffix.lower() not in {".pcap", ".pcapng"}:
        raise ValueError("Choose a new .pcap or .pcapng file in the configured capture directory.")
    if path.exists():
        raise ValueError("The output capture already exists.")
    if not path.parent.is_dir():
        raise ValueError("The output directory must exist.")
    capture_format = path.suffix.lower()[1:]
    with TemporaryDirectory(dir=path.parent) as temporary:
        staged = Path(temporary) / path.name
        yield staged, capture_format, path
        staged.chmod(0o600)
        try:
            os.link(staged, path)
        except FileExistsError as error:
            raise ValueError("The output capture already exists.") from error


@server.tool()
def capture_summary(capture: str) -> str:
    """Show capture format, packet count, size, duration and timestamps."""
    return analyze("capinfos", ["-M", "-t", "-E", "-c", "-s", "-u", "-a", "-e"], capture)


@server.tool()
def protocol_hierarchy(capture: str) -> str:
    """Count packets and bytes per protocol in a local capture file."""
    return analyze("tshark", ["-n", "-q", "-z", "io,phs", "-r"], capture)


@server.tool()
def capture_dscp(
    capture: str, display_filter: str | None = None, local_address: str | None = None,
) -> dict[str, object]:
    """Count DSCP values in the outer IPv4/IPv6 header, optionally by direction."""
    local = ip_address(local_address) if local_address else None
    fields = (
        "frame.protocols", "ip.src", "ip.dst", "ip.dsfield.dscp",
        "ipv6.src", "ipv6.dst", "ipv6.tclass.dscp",
    )
    args = ["-n", "-T", "fields", "-E", "occurrence=f"]
    for field in fields:
        args.extend(["-e", field])
    if display_filter:
        args.extend(["-Y", display_filter])
    rows = analyze("tshark", [*args, "-r"], capture)
    counts = defaultdict(Counter)
    for row in rows.splitlines():
        # tshark emits empty columns for absent fields, including trailing fields.
        protocols, *columns = (row + "\t" * len(fields)).split("\t")[:len(fields)]
        network = next((layer for layer in protocols.split(":") if layer in {"ip", "ipv6"}), None)
        if network is None:
            continue
        src, dst, dscp = columns[:3] if network == "ip" else columns[3:]
        if not dscp:
            continue
        direction = "all"
        if local is not None:
            if src and ip_address(src) == local:
                direction = "outbound"
            elif dst and ip_address(dst) == local:
                direction = "inbound"
            else:
                direction = "other"
        counts[direction][int(dscp, 10)] += 1
    return {
        "packet_count": sum(sum(values.values()) for values in counts.values()),
        "dscp": {
            direction: {str(value): count for value, count in sorted(values.items())}
            for direction, values in sorted(counts.items())
        },
    }


@server.tool()
def export_capture(capture: str, output: str, display_filter: str) -> dict[str, str]:
    """Export packets matching a Wireshark display filter to a new .pcap or .pcapng file."""
    if not display_filter.strip():
        raise ValueError("Provide a Wireshark display filter.")
    source = capture_path(capture)
    with new_capture(output) as (staged, capture_format, path):
        run([
            str(binaries / "tshark"), "-n", "-r", str(source), "-Y", display_filter,
            "-F", capture_format, "-w", str(staged),
        ])
    return {"capture": str(path)}


if dumpcap:
    @server.tool()
    def capture_interfaces() -> str:
        """List interfaces available for local live capture."""
        return run([dumpcap, "-D"])

    @server.tool()
    def capture_pcap(
        output: str, duration_seconds: int = 30, interface: str | None = None,
        capture_filter: str | None = None,
    ) -> dict[str, str | int]:
        """Capture traffic to a new file for up to 45 seconds. The optional filter uses BPF."""
        if not 1 <= duration_seconds <= 45:
            raise ValueError("Capture duration must be between 1 and 45 seconds.")
        interface = interface or default_interface
        if not interface:
            raise ValueError("Choose an interface from capture_interfaces.")
        with new_capture(output) as (staged, capture_format, path):
            # dumpcap creates the capture under a private staging directory.
            args = [
                dumpcap, "-q", "-i", interface, "-a", f"duration:{duration_seconds}",
                "-F", capture_format, "-w", str(staged),
            ]
            if capture_filter:
                args.extend(["-f", capture_filter])
            run(args, timeout=duration_seconds + 8)
        return {"capture": str(path), "interface": interface, "duration_seconds": duration_seconds}


if __name__ == "__main__":
    server.run(transport="stdio")
