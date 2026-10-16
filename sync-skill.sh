#!/usr/bin/env bash
# sync-skills.sh: pull the claude-skills repo and link every skill into Claude Code's skill directory.
#
# Usage:  ./sync-skills.sh            (uses defaults below)
#         REPO_DIR=~/dev/claude-skills ./sync-skills.sh
#
# A skill is any top-level folder in the repo that contains a SKILL.md.
# Existing correct symlinks are left alone. Real directories or files with the same
# name are never overwritten; they are reported and skipped. Links whose target
# vanished from the repo (renamed or deleted skills) are removed, but only if they
# point into this repo.

set -euo pipefail

REPO_DIR="${REPO_DIR:-$HOME/claude-skills}"
SKILLS_DIR="${SKILLS_DIR:-$HOME/.claude/skills}"

if [ ! -d "$REPO_DIR/.git" ]; then
  echo "error: $REPO_DIR is not a git repo. Clone it first:" >&2
  echo "  git clone git@github.com:vsharma2510/claude-skills.git \"$REPO_DIR\"" >&2
  exit 1
fi

# 1. pull (fast-forward only, so a diverged cluster copy never gets a surprise merge)
echo "== git pull in $REPO_DIR"
if ! git -C "$REPO_DIR" pull --ff-only; then
  echo "warning: git pull failed (offline, auth, or diverged history); linking what is already on disk" >&2
fi

mkdir -p "$SKILLS_DIR"
repo_abs="$(cd "$REPO_DIR" && pwd -P)"

added=0; kept=0; skipped=0; removed=0

# 2. link each skill folder
echo "== linking skills into $SKILLS_DIR"
for skill_md in "$repo_abs"/*/SKILL.md; do
  [ -e "$skill_md" ] || { echo "no skills found in $repo_abs"; break; }
  src="$(dirname "$skill_md")"
  name="$(basename "$src")"
  dest="$SKILLS_DIR/$name"

  if [ -L "$dest" ]; then
    if [ "$(readlink "$dest")" = "$src" ]; then
      kept=$((kept + 1))
    else
      ln -sfn "$src" "$dest"
      echo "  relinked  $name (pointed somewhere else)"
      added=$((added + 1))
    fi
  elif [ -e "$dest" ]; then
    echo "  SKIPPED   $name: $dest exists and is not a symlink (move or delete it to let the repo version take over)" >&2
    skipped=$((skipped + 1))
  else
    ln -s "$src" "$dest"
    echo "  linked    $name"
    added=$((added + 1))
  fi
done

# 3. remove dangling links that used to point into this repo
for link in "$SKILLS_DIR"/*; do
  [ -L "$link" ] || continue
  target="$(readlink "$link")"
  case "$target" in
    "$repo_abs"/*)
      if [ ! -e "$link" ]; then
        rm "$link"
        echo "  removed   $(basename "$link") (no longer in the repo)"
        removed=$((removed + 1))
      fi
      ;;
  esac
done

echo "== done: $added new/updated, $kept unchanged, $skipped skipped, $removed removed"
echo "   In a running Claude Code session, run /reload-skills (or restart it) to pick up changes."
