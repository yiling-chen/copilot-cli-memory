#!/usr/bin/env bash
set -euo pipefail

MEMORY_DIR=".copilot/memory"
INDEX="$MEMORY_DIR/MEMORY.md"

if [ -f "$INDEX" ]; then
  echo "Project memory already initialised at $INDEX — nothing to do."
  exit 0
fi

mkdir -p "$MEMORY_DIR"

cat > "$INDEX" << 'EOF'
# Memory Index

## Project
EOF

echo "Initialised project memory at $INDEX"
echo ""
echo "To share memories with your team, commit .copilot/memory/ to the repo."
echo "To keep them personal, add .copilot/memory/ to .gitignore."
