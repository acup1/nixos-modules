"""Local stdio tools for inspecting saved Wireshark captures."""
import os
import subprocess
from pathlib import Path

from mcp.server.fastmcp import FastMCP

server = FastMCP("wireshark")
root = Path(os.environ.get("WIRESHARK_MCP_ROOT") or ".").expanduser().resolve()
binaries = Path(os.environ["WIRESHARK_BIN"])


def analyze(tool: str, args: list[str], capture: str) -> str:
    path = (root / capture).resolve(strict=True)
    if not path.is_relative_to(root) or not path.is_file():
        raise ValueError("Choose a capture file in the configured capture directory.")
    if path.suffix.lower() not in {".pcap", ".pcapng", ".cap"}:
        raise ValueError("Expected a .pcap, .pcapng or .cap file.")
    result = subprocess.run(
        [str(binaries / tool), *args, str(path)], capture_output=True,
        text=True, errors="replace", timeout=45, check=False,
    )
    if result.returncode:
        raise ValueError(result.stderr.strip()[:2000] or f"{tool} failed")
    return result.stdout.strip()


@server.tool()
def capture_summary(capture: str) -> str:
    """Show capture format, packet count, size, duration and timestamps."""
    return analyze("capinfos", ["-M", "-t", "-E", "-c", "-s", "-u", "-a", "-e"], capture)


@server.tool()
def protocol_hierarchy(capture: str) -> str:
    """Count packets and bytes per protocol in a local capture file."""
    return analyze("tshark", ["-n", "-q", "-z", "io,phs", "-r"], capture)


if __name__ == "__main__":
    server.run(transport="stdio")
