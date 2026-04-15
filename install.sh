#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE="$SCRIPT_DIR/commands/wiki.md"

if [ ! -f "$SOURCE" ]; then
  echo "Error: commands/wiki.md not found"
  exit 1
fi

case "${1:-global}" in
  global)
    TARGET="$HOME/.claude/commands/wiki.md"
    mkdir -p "$(dirname "$TARGET")"
    cp "$SOURCE" "$TARGET"
    echo "Installed globally. Use /user:wiki in any project."
    ;;
  project)
    TARGET=".claude/commands/wiki.md"
    mkdir -p "$(dirname "$TARGET")"
    cp "$SOURCE" "$TARGET"
    echo "Installed for current project. Use /project:wiki."
    ;;
  link)
    TARGET="$HOME/.claude/commands/wiki.md"
    mkdir -p "$(dirname "$TARGET")"
    ln -sf "$SOURCE" "$TARGET"
    echo "Linked globally. Pulls updates from this repo automatically."
    ;;
  *)
    echo "Usage: ./install.sh [global|project|link]"
    echo ""
    echo "  global   Copy to ~/.claude/commands/ (default)"
    echo "  project  Copy to .claude/commands/ in current directory"
    echo "  link     Symlink to ~/.claude/commands/ (auto-updates)"
    exit 1
    ;;
esac
