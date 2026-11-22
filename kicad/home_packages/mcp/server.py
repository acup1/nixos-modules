"""Local KiCad project tools for the MCP stdio transport."""

import argparse
import json
import os
from pathlib import Path
import subprocess
import tempfile
from typing import Any

from mcp.server.fastmcp import FastMCP
from mcp.types import ToolAnnotations

FILE_TYPES = {
    ".kicad_pro": "project",
    ".kicad_pcb": "board",
    ".kicad_sch": "schematic",
}
READ_ONLY = ToolAnnotations(
    readOnlyHint=True, destructiveHint=False, openWorldHint=False
)
MAX_JSON_BYTES = 4 * 1024 * 1024


def within_project_tree(root: Path, relative: str) -> Path:
    path = Path(relative)
    if path.is_absolute() or ".." in path.parts:
        raise ValueError("Use a relative path within the project root")
    resolved = (root / path).resolve(strict=True)
    if not resolved.is_relative_to(root):
        raise ValueError("The path points outside the project root")
    return resolved


def design_file(root: Path, relative: str, suffix: str) -> Path:
    path = within_project_tree(root, relative)
    if path.suffix.lower() != suffix or not path.is_file():
        raise ValueError(f"Expected a regular {suffix} file")
    return path


def load_json(path: Path) -> dict[str, Any]:
    with path.open("rb") as stream:
        raw = stream.read(MAX_JSON_BYTES + 1)
    if len(raw) > MAX_JSON_BYTES:
        raise ValueError(f"{path.name} exceeds the 4 MiB JSON limit")
    document = json.loads(raw)
    if not isinstance(document, dict):
        raise ValueError(f"{path.name} does not contain a JSON object")
    return document


def run_check(cli: Path, operation: tuple[str, str], design: Path) -> dict[str, Any]:
    with tempfile.TemporaryDirectory(prefix="kicad-mcp-") as directory:
        report = Path(directory) / "report.json"
        with tempfile.TemporaryFile(mode="w+b", dir=directory) as errors:
            try:
                completed = subprocess.run(
                    [cli, *operation, "--format", "json", "--output", report, design],
                    cwd=design.parent,
                    stdin=subprocess.DEVNULL,
                    stdout=subprocess.DEVNULL,
                    stderr=errors,
                    timeout=60,
                    check=False,
                )
            except subprocess.TimeoutExpired as error:
                raise ValueError("KiCad did not finish the check within 60 seconds") from error
            if completed.returncode != 0:
                errors.seek(0)
                detail = errors.read(2048).decode("utf-8", errors="replace").strip()
                raise ValueError(detail or f"kicad-cli exited with {completed.returncode}")
        if not report.is_file():
            raise ValueError("KiCad did not generate the JSON report")
        return load_json(report)


def create_server(root: Path, cli: Path | None) -> FastMCP:
    server = FastMCP(
        "kicad",
        instructions="Inspect local KiCad projects using paths relative to the project root.",
    )

    @server.tool(annotations=READ_ONLY)
    def list_project_files(path: str = ".") -> dict[str, Any]:
        """List KiCad design files and subdirectories immediately within a directory."""
        directory = within_project_tree(root, path)
        if not directory.is_dir():
            raise ValueError("Expected a project directory")
        files = []
        for child in sorted(directory.iterdir()):
            if child.is_symlink():
                continue
            if child.is_dir():
                files.append(
                    {"path": child.relative_to(root).as_posix(), "kind": "directory"}
                )
            elif child.suffix.lower() in FILE_TYPES and child.is_file():
                files.append(
                    {
                        "path": child.relative_to(root).as_posix(),
                        "kind": FILE_TYPES[child.suffix.lower()],
                        "bytes": child.stat().st_size,
                    }
                )
            if len(files) > 200:
                break
        return {
            "directory": directory.relative_to(root).as_posix(),
            "entries": files[:200],
            "truncated": len(files) > 200,
        }

    @server.tool(annotations=READ_ONLY)
    def inspect_project_settings(path: str) -> dict[str, Any]:
        """Read metadata, named net classes and text variable names from a .kicad_pro file."""
        project = design_file(root, path, ".kicad_pro")
        document = load_json(project)
        meta = document.get("meta", {})
        net_settings = document.get("net_settings", {})
        classes = net_settings.get("classes", []) if isinstance(net_settings, dict) else []
        net_classes = []
        if isinstance(classes, list):
            net_classes = [
                item["name"]
                for item in classes
                if isinstance(item, dict) and isinstance(item.get("name"), str)
            ]
        variables = document.get("text_variables", {})
        return {
            "path": project.relative_to(root).as_posix(),
            "format_version": meta.get("version") if isinstance(meta, dict) else None,
            "net_classes": net_classes,
            "text_variable_names": sorted(variables) if isinstance(variables, dict) else [],
        }

    if cli is not None:

        @server.tool(annotations=READ_ONLY)
        def check_board_drc(path: str) -> dict[str, Any]:
            """Run KiCad's design rule check on a .kicad_pcb file and return the JSON report."""
            board = design_file(root, path, ".kicad_pcb")
            return run_check(cli, ("pcb", "drc"), board)

        @server.tool(annotations=READ_ONLY)
        def check_schematic_erc(path: str) -> dict[str, Any]:
            """Run KiCad's electrical rule check on a .kicad_sch file and return the JSON report."""
            schematic = design_file(root, path, ".kicad_sch")
            return run_check(cli, ("sch", "erc"), schematic)

    return server


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path.cwd())
    parser.add_argument("--kicad-cli", type=Path)
    args = parser.parse_args()
    try:
        root = args.root.resolve(strict=True)
    except OSError as error:
        parser.error(f"Cannot open the project root: {error}")
    if not root.is_dir():
        parser.error("--root must point to a directory")

    cli = args.kicad_cli
    if cli is not None and not (cli.is_absolute() and cli.is_file() and os.access(cli, os.X_OK)):
        parser.error("--kicad-cli must point to an absolute executable file")

    create_server(root, cli).run(transport="stdio")


if __name__ == "__main__":
    main()
