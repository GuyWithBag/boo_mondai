#!/usr/bin/env python3
"""Rename repo files and update textual references.

Examples:
  python3 scripts/rename_paths.py --dry-run \
    --move lib/pages/view_decks_online_page.dart=lib/pages/view_decks.online.page.dart \
    --move lib/controllers/view_decks_online_page_controller.dart=lib/controllers/view_decks.online.controller.dart \
    --route /online-deck-browser=/view-decks/online \
    --rename-dart-symbols

  python3 scripts/rename_paths.py \
    --move lib/database/remote/deck_remotedb.dart=lib/database/remote/decks.remote.db.dart \
    --rename-dart-symbols

By default, each --move also replaces these references in text files:
  - old relative path -> new relative path
  - old basename -> new basename
  - old path without lib/ -> new path without lib/

Use --route old=new for URL path changes.
Use --rename-dart-symbols to derive class/symbol replacements from moved
Dart basenames, e.g. deck_remotedb.dart -> decks.remote.db.dart also replaces
DeckRemoteDB -> DecksRemoteDB.
Use --replace old=new for extra symbol/class/comment replacements.
"""

from __future__ import annotations

import argparse
import os
import re
from pathlib import Path
from typing import Iterable


TEXT_EXTENSIONS = {
    ".dart",
    ".yaml",
    ".yml",
    ".json",
    ".md",
    ".sql",
    ".toml",
    ".txt",
}

SKIP_DIRS = {
    ".dart_tool",
    ".git",
    ".idea",
    ".vscode",
    "build",
    ".gradle",
}

DEFAULT_SCAN_DIRS = (
    "lib",
    "test",
    "supabase",
    "documentation",
    "references",
    "context",
    "scripts",
)


def parse_pair(value: str, flag: str) -> tuple[str, str]:
    if "=" not in value:
        raise argparse.ArgumentTypeError(f"{flag} expects old=new, got {value!r}")
    old, new = value.split("=", 1)
    old = old.strip()
    new = new.strip()
    if not old or not new:
        raise argparse.ArgumentTypeError(f"{flag} expects non-empty old=new")
    return old, new


def parse_route_pair(value: str) -> tuple[str, str]:
    old, new = parse_pair(value, "--route")
    if not old.startswith("/") or not new.startswith("/"):
        raise argparse.ArgumentTypeError("--route values must start with /")
    return old, new


def iter_text_files(roots: Iterable[Path]) -> Iterable[Path]:
    for scan_root in roots:
        if not scan_root.exists():
            continue
        if scan_root.is_file():
            if scan_root.suffix in TEXT_EXTENSIONS:
                yield scan_root
            continue

        for dirpath, dirnames, filenames in os.walk(scan_root):
            dirnames[:] = [name for name in dirnames if name not in SKIP_DIRS]
            current = Path(dirpath)
            for filename in filenames:
                path = current / filename
                if path.suffix in TEXT_EXTENSIONS:
                    yield path


def scan_roots(root: Path, requested: list[str]) -> list[Path]:
    names = requested or list(DEFAULT_SCAN_DIRS)
    return [root / name for name in names]


def package_path(path: str) -> str:
    prefix = "lib/"
    return path[len(prefix) :] if path.startswith(prefix) else path


def move_replacements(moves: list[tuple[str, str]]) -> list[tuple[str, str]]:
    replacements: list[tuple[str, str]] = []
    for old, new in moves:
        old_path = old.replace(os.sep, "/")
        new_path = new.replace(os.sep, "/")
        replacements.extend(
            [
                (old_path, new_path),
                (package_path(old_path), package_path(new_path)),
                (Path(old_path).name, Path(new_path).name),
            ],
        )
    return replacements


TOKEN_ALIASES = {
    "db": "DB",
    "dto": "DTO",
    "fsrs": "FSRS",
    "id": "ID",
    "localdb": "LocalDB",
    "remote": "Remote",
    "remotedb": "RemoteDB",
    "sql": "SQL",
}


def dart_identifier_for_path(path: str) -> str | None:
    basename = Path(path).name
    if not basename.endswith(".dart"):
        return None

    stem = basename.removesuffix(".dart")
    tokens = [token for token in re.split(r"[._-]+", stem) if token]
    if not tokens:
        return None

    parts: list[str] = []
    for token in tokens:
        lowered = token.lower()
        if lowered in TOKEN_ALIASES:
            parts.append(TOKEN_ALIASES[lowered])
        else:
            parts.append(lowered[:1].upper() + lowered[1:])

    return "".join(parts)


def dart_symbol_replacements(moves: list[tuple[str, str]]) -> list[tuple[str, str]]:
    replacements: list[tuple[str, str]] = []
    for old, new in moves:
        old_symbol = dart_identifier_for_path(old)
        new_symbol = dart_identifier_for_path(new)
        if old_symbol and new_symbol and old_symbol != new_symbol:
            replacements.append((old_symbol, new_symbol))
    return replacements


def dedupe_replacements(
    replacements: list[tuple[str, str]],
) -> list[tuple[str, str]]:
    seen: set[tuple[str, str]] = set()
    deduped: list[tuple[str, str]] = []
    for old, new in replacements:
        pair = (old, new)
        if old == new or pair in seen:
            continue
        seen.add(pair)
        deduped.append(pair)
    return sorted(deduped, key=lambda pair: len(pair[0]), reverse=True)


def apply_text_replacements(
    root: Path,
    text_roots: Iterable[Path],
    replacements: list[tuple[str, str]],
    dry_run: bool,
) -> list[Path]:
    changed: list[Path] = []
    for path in iter_text_files(text_roots):
        try:
            original = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue

        updated = original
        for old, new in replacements:
            updated = updated.replace(old, new)

        if updated != original:
            changed.append(path)
            if not dry_run:
                path.write_text(updated, encoding="utf-8")
    return changed


def apply_moves(
    root: Path,
    moves: list[tuple[str, str]],
    dry_run: bool,
    force: bool,
) -> list[tuple[Path, Path]]:
    moved: list[tuple[Path, Path]] = []
    for old, new in moves:
        old_path = root / old
        new_path = root / new

        if not old_path.exists():
            raise FileNotFoundError(f"Missing source: {old}")
        if new_path.exists() and not force:
            raise FileExistsError(f"Destination exists: {new}")

        moved.append((old_path, new_path))
        if not dry_run:
            new_path.parent.mkdir(parents=True, exist_ok=True)
            old_path.rename(new_path)
    return moved


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--move",
        action="append",
        default=[],
        type=lambda value: parse_pair(value, "--move"),
        help="File rename as old=new. Can be repeated.",
    )
    parser.add_argument(
        "--replace",
        action="append",
        default=[],
        type=lambda value: parse_pair(value, "--replace"),
        help="Extra text replacement as old=new. Can be repeated.",
    )
    parser.add_argument(
        "--route",
        action="append",
        default=[],
        type=parse_route_pair,
        help="URL route replacement as /old=/new. Can be repeated.",
    )
    parser.add_argument(
        "--rename-dart-symbols",
        action="store_true",
        help="Derive PascalCase Dart symbol replacements from each --move basename.",
    )
    parser.add_argument(
        "--root",
        default=".",
        help="Repository root. Defaults to current directory.",
    )
    parser.add_argument(
        "--scan",
        action="append",
        default=[],
        help=(
            "Directory or file to scan for text replacements. Can be repeated. "
            "Defaults to source/documentation directories."
        ),
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print planned changes without writing.",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Allow replacing an existing destination file.",
    )
    args = parser.parse_args()

    root = Path(args.root).resolve()
    text_roots = scan_roots(root, args.scan)
    moves = [(old, new) for old, new in args.move]
    routes = [(old, new) for old, new in args.route]
    symbol_replacements = dart_symbol_replacements(moves) if args.rename_dart_symbols else []
    replacements = dedupe_replacements(
        move_replacements(moves) + routes + symbol_replacements + args.replace,
    )

    if not moves and not replacements:
        parser.error("Provide at least one --move or --replace")

    moved = apply_moves(root, moves, args.dry_run, args.force)
    changed = apply_text_replacements(root, text_roots, replacements, args.dry_run)

    mode = "DRY RUN" if args.dry_run else "APPLIED"
    print(f"{mode}: {len(moved)} move(s), {len(changed)} text file(s) changed")
    for old_path, new_path in moved:
        print(f"move: {old_path.relative_to(root)} -> {new_path.relative_to(root)}")
    for path in changed:
        print(f"text: {path.relative_to(root)}")
    for old, new in symbol_replacements:
        print(f"symbol: {old} -> {new}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
