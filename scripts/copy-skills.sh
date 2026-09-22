#!/usr/bin/env bash
set -euo pipefail

# Fork-only variant of link-skills.sh: copies instead of symlinking.
#
# Copies all skills in the repository into the local skill directories used by
# each agent harness:
#   - ~/.claude/skills: Claude Code
#   - ~/.agents/skills: Codex and other Agent Skills-compatible harnesses
# A symlink into this repo only resolves where the repo sits at the same path,
# so it breaks in every other devcontainer that shares the same ~/.claude. A
# copy works everywhere, at the price of re-running this script after every
# skill change.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DESTS=("$HOME/.claude/skills" "$HOME/.agents/skills")

# Collect the repo's skills once, copy into every destination. Same selection
# as link-skills.sh: `deprecated/` and `misc/` are skipped, everything else
# (including `in-progress/` and `custom/`) is copied.
names=()
srcs=()
while IFS= read -r -d '' skill_md; do
  src="$(dirname "$skill_md")"
  names+=("$(basename "$src")")
  srcs+=("$src")
done < <(find "$REPO/skills" -name SKILL.md -not -path '*/node_modules/*' -not -path '*/deprecated/*' -not -path '*/misc/*' -print0)

for DEST in "${DESTS[@]}"; do
  # If $DEST is a symlink that resolves into this repo, we'd end up writing the
  # per-skill copies back into the repo's own skills/ tree. Detect and bail
  # out instead of polluting the working copy.
  if [ -L "$DEST" ]; then
    resolved="$(readlink -f "$DEST")"
    case "$resolved" in
      "$REPO"|"$REPO"/*)
        echo "error: $DEST is a symlink into this repo ($resolved)." >&2
        echo "Remove it (rm \"$DEST\") and re-run; the script will recreate it as a real dir." >&2
        exit 1
        ;;
    esac
  fi

  mkdir -p "$DEST"

  for i in "${!names[@]}"; do
    name="${names[$i]}"
    src="${srcs[$i]}"
    target="$DEST/$name"

    # Replace whatever is there (an older copy, or a symlink left by
    # link-skills.sh) so the copy matches the repo exactly.
    rm -rf "$target"

    cp -R "$src" "$target"
    echo "copied $name -> $target"
  done
done
