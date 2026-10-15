#!/usr/bin/env python3
"""Validate the bundled Cline integration without third-party packages."""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
CLINE_ROOT = ROOT / "integrations" / "cline"
CORE_SKILLS = (
    "brainstorming",
    "writing-plans",
    "systematic-debugging",
    "test-driven-development",
    "verification-before-completion",
    "using-git-worktrees",
    "finishing-a-development-branch",
)
CUSTOM_SKILLS_ROOT = CLINE_ROOT / "skills"


def parse_frontmatter(path: Path) -> tuple[str | None, str | None]:
    text = path.read_text(encoding="utf-8")
    match = re.match(r"^---\s*\r?\n(.*?)\r?\n---(?:\r?\n|$)", text, re.S)
    if not match:
        return None, None
    frontmatter = match.group(1)
    name_match = re.search(r"^name:\s*['\"]?([^'\"\r\n]+?)['\"]?\s*$", frontmatter, re.M)
    description_match = re.search(
        r"^description:\s*(?:['\"]([\s\S]*?)['\"]|(.+))\s*$",
        frontmatter,
        re.M,
    )
    name = name_match.group(1).strip() if name_match else None
    description = next((group.strip() for group in description_match.groups() if group), None) if description_match else None
    return name, description


def main() -> int:
    errors: list[str] = []
    seen_names: set[str] = set()
    checked = 0

    sources = [ROOT / "skills" / name for name in CORE_SKILLS]
    if CUSTOM_SKILLS_ROOT.is_dir():
        sources.extend(path for path in CUSTOM_SKILLS_ROOT.iterdir() if path.is_dir())
    else:
        errors.append(f"Missing custom Skills directory: {CUSTOM_SKILLS_ROOT.relative_to(ROOT)}")

    for skill_dir in sorted(sources, key=lambda item: str(item)):
        manifest = skill_dir / "SKILL.md"
        if not manifest.is_file():
            errors.append(f"Missing SKILL.md: {manifest.relative_to(ROOT)}")
            continue
        name, description = parse_frontmatter(manifest)
        expected = skill_dir.name
        if not name:
            errors.append(f"Missing name in frontmatter: {manifest.relative_to(ROOT)}")
        elif name != expected:
            errors.append(f"name {name!r} does not match directory {expected!r}: {manifest.relative_to(ROOT)}")
        if not description:
            errors.append(f"Missing description in frontmatter: {manifest.relative_to(ROOT)}")
        elif len(description) > 1024:
            errors.append(f"description exceeds 1024 characters ({len(description)}): {manifest.relative_to(ROOT)}")
        if name:
            if name in seen_names:
                errors.append(f"Duplicate Skill name: {name}")
            seen_names.add(name)
        checked += 1

    required_files = (
        CLINE_ROOT / "README.md",
        CLINE_ROOT / "install.ps1",
        CLINE_ROOT / "rules" / "ai-video-studio-development.md",
    )
    for path in required_files:
        if not path.is_file():
            errors.append(f"Missing integration file: {path.relative_to(ROOT)}")

    installer = CLINE_ROOT / "install.ps1"
    if installer.is_file():
        installer_text = installer.read_text(encoding="utf-8")
        for name in CORE_SKILLS:
            if f"'{name}'" not in installer_text:
                errors.append(f"Installer core Skill list is missing {name!r}")

    if errors:
        print("Cline integration validation FAILED:")
        for error in errors:
            print(f" - {error}")
        return 1

    print(f"Cline integration validation passed: {checked} Skills checked; {len(required_files)} required integration files present.")
    print("This validates bundle metadata, not behavior inside a running Cline session.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
