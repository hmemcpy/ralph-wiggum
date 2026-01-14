#!/bin/bash

# Test complex tree-like thread structure
# Creates: parent -> 2 children, each child -> 2 grandchildren

set -e

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

TEST_PROMPT="Say 'Done' and nothing else. Do not use any tools."

# Run root thread, capture session_id from JSON
run_root() {
  local name="$1"
  local tmpfile=$(mktemp)
  
  echo -e "${CYAN}Creating root '$name'${NC}" >&2
  
  echo "$TEST_PROMPT" | amp -x --dangerously-allow-all --stream-json > "$tmpfile" 2>&1
  
  local thread_id=$(jq -r 'select(.type == "system") | .session_id' "$tmpfile" 2>/dev/null | head -1)
  local duration=$(jq -r 'select(.type == "result") | .duration_ms' "$tmpfile" 2>/dev/null | tail -1)
  rm -f "$tmpfile"
  
  amp threads rename "$thread_id" "$name" >/dev/null 2>&1 || true
  echo -e "${YELLOW}  → $thread_id (${duration}ms)${NC}" >&2
  
  echo "$thread_id"
}

# Run child thread via handoff, capture session_id from JSON
run_child() {
  local name="$1"
  local parent="$2"
  local tmpfile=$(mktemp)
  
  echo -e "${CYAN}Creating '$name' ← parent $parent${NC}" >&2
  
  echo "$TEST_PROMPT" | amp threads handoff "$parent" \
    --goal "$TEST_PROMPT" \
    -x \
    --dangerously-allow-all \
    --stream-json > "$tmpfile" 2>&1
  
  local thread_id=$(jq -r 'select(.type == "system") | .session_id' "$tmpfile" 2>/dev/null | head -1)
  local duration=$(jq -r 'select(.type == "result") | .duration_ms' "$tmpfile" 2>/dev/null | tail -1)
  rm -f "$tmpfile"
  
  amp threads rename "$thread_id" "$name" >/dev/null 2>&1 || true
  echo -e "${YELLOW}  → $thread_id (${duration}ms)${NC}" >&2
  
  echo "$thread_id"
}

echo -e "${GREEN}=== Thread Tree Test ===${NC}"
echo ""
echo "Target structure:"
echo "  root"
echo "  ├── child-1"
echo "  │   ├── gc-1a"
echo "  │   └── gc-1b"
echo "  └── child-2"
echo "      ├── gc-2a"
echo "      └── gc-2b"
echo ""

# Level 0
echo -e "${GREEN}[Level 0]${NC}"
ROOT=$(run_root "tree: root")

# Level 1
echo -e "${GREEN}[Level 1]${NC}"
CHILD1=$(run_child "tree: child-1" "$ROOT")
CHILD2=$(run_child "tree: child-2" "$ROOT")

# Level 2
echo -e "${GREEN}[Level 2 from child-1]${NC}"
GC1A=$(run_child "tree: gc-1a" "$CHILD1")
GC1B=$(run_child "tree: gc-1b" "$CHILD1")

echo -e "${GREEN}[Level 2 from child-2]${NC}"
GC2A=$(run_child "tree: gc-2a" "$CHILD2")
GC2B=$(run_child "tree: gc-2b" "$CHILD2")

echo ""
echo -e "${GREEN}=== Complete ===${NC}"
echo "Root:     $ROOT"
echo "Child1:   $CHILD1"
echo "Child2:   $CHILD2"
echo "GC1a:     $GC1A"
echo "GC1b:     $GC1B"
echo "GC2a:     $GC2A"
echo "GC2b:     $GC2B"
echo ""
echo "Run 'amp threads continue' to verify tree structure"
