#!/usr/bin/env bash
set -euo pipefail

COPILOT_DIR="$HOME/.copilot"
MEMORY_DIR="$COPILOT_DIR/memory"
INSTRUCTIONS="$COPILOT_DIR/instructions.md"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing Copilot CLI Memory System..."

# Create directory structure
mkdir -p "$MEMORY_DIR"

# Copy instructions.md
if [ -f "$INSTRUCTIONS" ]; then
  echo "  ~/.copilot/instructions.md already exists — appending memory rules."
  echo "" >> "$INSTRUCTIONS"
  cat "$SCRIPT_DIR/instructions.md" >> "$INSTRUCTIONS"
else
  cp "$SCRIPT_DIR/instructions.md" "$INSTRUCTIONS"
  echo "  Created ~/.copilot/instructions.md"
fi

# Create global MEMORY.md if it doesn't exist
if [ ! -f "$MEMORY_DIR/MEMORY.md" ]; then
  cat > "$MEMORY_DIR/MEMORY.md" << 'EOF'
# Memory Index

## Global

## Project
EOF
  echo "  Created ~/.copilot/memory/MEMORY.md"
else
  echo "  ~/.copilot/memory/MEMORY.md already exists — skipping."
fi

echo ""
echo "Done. Global memory layer is ready at $MEMORY_DIR"
echo "To initialise project-level memory inside a repo, run: ./init-project.sh"
