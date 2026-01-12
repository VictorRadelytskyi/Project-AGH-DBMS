#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
from pathlib import Path
from urllib.parse import quote

DEFAULT_IGNORES = {
    ".git",
    "node_modules",
    "docs",
    "site",
    ".venv",
    "venv",
    "__pycache__",
}


def parse_header(sql_text: str) -> tuple[str, str] | None:
    s = sql_text.lstrip("\ufeff").lstrip()

    # /* ... */ docblock at very top
    if s.startswith("/*"):
        end = s.find("*/")
        if end == -1:
            return None
        raw = s[2:end]

        lines: list[str] = []
        for line in raw.splitlines():
            line = line.rstrip()
            # allow leading "*" like Javadoc style
            stripped = line.lstrip()
            if stripped.startswith("*"):
                stripped = stripped[1:]
                if stripped.startswith(" "):
                    stripped = stripped[1:]
                line = stripped
            lines.append(line.rstrip())

        title = next((ln.strip() for ln in lines if ln.strip()), "")
        if not title:
            return None

        # body after the first non-empty line
        seen_title = False
        body_lines: list[str] = []
        for ln in lines:
            if not seen_title:
                if ln.strip():
                    seen_title = True
                continue
            body_lines.append(ln)
        body = "\n".join(body_lines).strip()
        return title, body

    # consecutive leading "-- ..." lines
    lines = s.splitlines()
    header: list[str] = []
    for ln in lines:
        stripped = ln.lstrip()
        if not stripped.startswith("--"):
            break
        header.append(stripped[2:].lstrip())

    if not header:
        return None

    title = next((ln.strip() for ln in header if ln.strip()), "")
    if not title:
        return None
    body = "\n".join(header).strip()
    return title, body


def to_markdown(rel_path: str, title: str, body: str, sql_text: str, include_source: bool) -> str:
    body = body.strip() if body.strip() else "_No header documentation found._"
    parts = [
        f"# {title}\n",
        f"**Source file:** `{rel_path}`\n",
        f"{body}\n",
    ]
    if include_source:
        parts += [
            "## Source\n",
            "```sql",
            sql_text.rstrip(),
            "```\n",
        ]
    return "\n".join(parts)


def should_ignore(rel_parts: tuple[str, ...], ignores: set[str]) -> bool:
    return any(part in ignores for part in rel_parts)


def title_fallback(p: Path) -> str:
    return p.stem


def _rel_link(from_md: Path, to_md: Path) -> str:
    rel = os.path.relpath(to_md, start=from_md.parent).replace(os.sep, "/")
    return quote(rel, safe="/#")


def _page_title(md_path: Path) -> str:
    try:
        for line in md_path.read_text(encoding="utf-8", errors="replace").splitlines():
            if line.startswith("# "):
                return line[2:].strip()
    except FileNotFoundError:
        pass
    return md_path.stem


def write_folder_indexes(out_root: Path, root_title: str) -> None:
    dirs = [out_root] + sorted([p for p in out_root.rglob("*") if p.is_dir()])

    for d in dirs:
        # skip hidden dirs (e.g., .foo)
        if any(part.startswith(".") for part in d.relative_to(out_root).parts):
            continue

        idx = d / "index.md"

        subdirs = sorted(
            [p for p in d.iterdir() if p.is_dir() and not p.name.startswith(".")],
            key=lambda p: p.name.casefold(),
        )
        pages = sorted(
            [p for p in d.glob("*.md") if p.name != "index.md"],
            key=lambda p: _page_title(p).casefold(),
        )

        rel_dir = d.relative_to(out_root)
        heading = root_title if rel_dir == Path(".") else f"{rel_dir.as_posix()}/"

        lines: list[str] = [f"# {heading}", ""]

        if subdirs:
            lines += ["## Sekcje", ""]
            for sd in subdirs:
                lines.append(f"- [{sd.name}/]({_rel_link(idx, sd / 'index.md')})")
            lines.append("")

        if pages:
            lines += ["## Skrypty", ""]
            for p in pages:
                lines.append(f"- [{_page_title(p)}]({_rel_link(idx, p)})")
            lines.append("")

        # Add diagram on the homepage (docs/sql/index.md)
        if rel_dir == Path("."):
            diagram = out_root / "MM_VR_JI_DBMS_diagram.png"
            if diagram.exists():
                lines += [
                    "![DBMS diagram](MM_VR_JI_DBMS_diagram.png)",
                    "",
                ]


        idx.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=".", help="Repo root to scan (default: .)")
    ap.add_argument("--out", default="docs/sql", help="Output folder (default: docs/sql)")
    ap.add_argument("--title", default="SQL documentation", help="Title for the docs root index page")
    ap.add_argument("--check", action="store_true", help="Fail if any .sql file lacks a header doc")
    ap.add_argument("--no-source", action="store_true", help="Do not embed SQL source in docs pages")
    ap.add_argument("--ignore", action="append", default=[], help="Additional ignore dir names (repeatable)")
    args = ap.parse_args()

    root = Path(args.root).resolve()
    out_root = (root / args.out).resolve()
    include_source = not args.no_source

    ignores = set(DEFAULT_IGNORES) | set(args.ignore)
    out_top = Path(args.out).parts[0] if Path(args.out).parts else None
    if out_top:
        ignores.add(out_top)

    out_root.mkdir(parents=True, exist_ok=True)

    # cleanup old artifacts from previous versions
    old_root_index = out_root / "root_index.md"
    if old_root_index.exists():
        old_root_index.unlink()

    missing_headers: list[str] = []

    for sql_path in root.rglob("*.sql"):
        rel = sql_path.relative_to(root)
        if should_ignore(rel.parts, ignores):
            continue

        sql_text = sql_path.read_text(encoding="utf-8", errors="replace")
        parsed = parse_header(sql_text)

        if parsed is None:
            title = title_fallback(sql_path)
            body = "_No header documentation found._"
            missing_headers.append(str(rel))
        else:
            title, body = parsed

        md_rel = rel.with_suffix(".md")
        out_path = out_root / md_rel
        out_path.parent.mkdir(parents=True, exist_ok=True)
        out_path.write_text(
            to_markdown(str(rel), title, body, sql_text, include_source),
            encoding="utf-8",
        )

    write_folder_indexes(out_root, args.title)

    if args.check and missing_headers:
        print("Missing SQL header docs in:")
        for f in missing_headers:
            print(f" - {f}")
        return 2

    return 0


if __name__ == "__main__":
    raise SystemExit(main())

