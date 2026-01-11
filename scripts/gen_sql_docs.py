#!/usr/bin/env python3
from __future__ import annotations

import argparse
from pathlib import Path

DEFAULT_IGNORES = {
    ".git",
    "node_modules",
    "docs",
    "site",
    ".venv",
    "venv",
    "__pycache__",
}

KNOWN_TOP_FOLDERS = ["functions", "views", "procedures", "triggers", "indexes", "users"]


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
    # "inventory_shortage_list.sql" -> "inventory_shortage_list"
    return p.stem


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=".", help="Repo root to scan (default: .)")
    ap.add_argument("--out", default="docs/sql", help="Output folder (default: docs/sql)")
    ap.add_argument("--check", action="store_true", help="Fail if any .sql file lacks a header doc")
    ap.add_argument("--no-source", action="store_true", help="Do not embed SQL source in docs pages")
    ap.add_argument("--ignore", action="append", default=[], help="Additional ignore dir names (repeatable)")
    args = ap.parse_args()

    root = Path(args.root).resolve()
    out_root = (root / args.out).resolve()
    include_source = not args.no_source
    ignores = set(DEFAULT_IGNORES) | set(args.ignore)

    out_root.mkdir(parents=True, exist_ok=True)

    # group -> list of (title, link)
    groups: dict[str, list[tuple[str, str]]] = {"(root)": []}
    for g in KNOWN_TOP_FOLDERS:
        groups[g] = []

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

        # output mirrors your tree under docs/sql/
        md_rel = rel.with_suffix(".md")
        out_path = out_root / md_rel
        out_path.parent.mkdir(parents=True, exist_ok=True)
        out_path.write_text(
            to_markdown(str(rel), title, body, sql_text, include_source),
            encoding="utf-8",
        )

        link = f"sql/{md_rel.as_posix()}"  # for MkDocs (docs_dir = docs)
        top = rel.parts[0] if len(rel.parts) > 1 else "(root)"
        group = top if top in groups else "(root)"
        groups[group].append((title, "/" + link))

    # write per-group indices
    for group, items in groups.items():
        items.sort(key=lambda x: x[0].casefold())

        if group == "(root)":
            idx_path = out_root / "root_index.md"
            heading = "Root-level SQL files"
        else:
            idx_path = out_root / group / "index.md"
            heading = f"{group}/"

        idx_path.parent.mkdir(parents=True, exist_ok=True)
        idx_path.write_text(
            f"# {heading}\n\n" + "\n".join([f"- [{t}]({u})" for t, u in items]) + "\n",
            encoding="utf-8",
        )

    # write global sql index
    sql_index = [
        "# SQL files\n",
        "## Root\n",
        "- [Root-level SQL files](/sql/root_index.md)\n",
        "## Folders\n",
    ]
    for g in KNOWN_TOP_FOLDERS:
        sql_index.append(f"- [{g}/](/sql/{g}/index.md)")
    sql_index.append("")
    (out_root / "index.md").write_text("\n".join(sql_index), encoding="utf-8")

    # Ensure docs homepage exists
    docs_index = root / "docs" / "index.md"
    if not docs_index.exists():
        docs_index.parent.mkdir(parents=True, exist_ok=True)
        docs_index.write_text("# Project SQL documentation\n\n- [SQL files](sql/index.md)\n", encoding="utf-8")

    if args.check and missing_headers:
        print("Missing SQL header docs in:")
        for f in missing_headers:
            print(f" - {f}")
        return 2

    print(f"Generated docs for {sum(len(v) for v in groups.values())} SQL files.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

