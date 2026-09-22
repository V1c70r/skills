# Customization log

Every way this fork diverges from [mattpocock/skills](https://github.com/mattpocock/skills), newest first. The rules for adding an entry live in the **Fork** section of [CLAUDE.md](./CLAUDE.md).

Each entry: `### YYYY-MM-DD: <title>`, then **Why**, **Files** (every path the change adds or edits), and **Status**: `active`, `upstreamed` (upstream now does the same), or `reverted`.

### 2026-09-22: copy-skills.sh

- **Why**: `link-skills.sh` symlinks point at this repo's path in this devcontainer, so they break in every other devcontainer that mounts the same `~/.claude`. Copies work in all of them.
- **Files**: `scripts/copy-skills.sh` (new), `CLAUDE.md` (two bullets in the **Fork** section).
- **Status**: active

### 2026-09-21: Fork rules in CLAUDE.md and this log

- **Why**: record that this repo is a fork, and keep every divergence from upstream minimal, merge-friendly, and logged.
- **Files**: `CLAUDE.md` (new **Fork** section at the top), `CUSTOMIZATIONLOG.md` (new).
- **Status**: active

### 2026-09-21: Devcontainer

- **Why**: work on the skills inside a devcontainer with Claude Code, Node, and `gh`, keeping its Claude and `gh` config apart from the host's.
- **Files**: `.devcontainer/devcontainer.json`, `.devcontainer/devcontainer-lock.json` (both new).
- **Status**: active
