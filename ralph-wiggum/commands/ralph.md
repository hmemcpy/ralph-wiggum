# Ralph Wiggum Loop Generator

Generate the complete Ralph Wiggum loop infrastructure for iterative AI-driven development.

Reference: https://github.com/ghuntley/how-to-ralph-wiggum

## Input

$ARGUMENTS

The argument should be a path to a feature/UX document, or a description of the feature to implement. If empty, search for relevant docs in `docs/` directory.

## What is Ralph?

An iterative AI development loop where:
- **Outer loop** (bash): `while :; do cat PROMPT.md | claude ; done`
- **Inner loop** (agent): Read plan → Pick task → Implement → Test → Commit → Exit
- **State persistence**: `IMPLEMENTATION_PLAN.md` lives on disk between iterations

Two operational modes:
- **Planning**: Gap analysis between specs and code. Output: prioritized task list. NO implementation.
- **Building**: Implement ONE task, run tests, commit, update plan. Exit.

## Core Principles (From Ralph Guidelines)

1. **Deterministic Setup**: Same files seed each loop for known starting state
2. **One Task Per Iteration**: Maximize context utilization for that task
3. **Backpressure**: Tests/lint/typecheck reject invalid outputs, forcing correction
4. **Plan Disposability**: Plans can be regenerated. One planning loop is cheap.
5. **Don't Assume Not Implemented**: Search codebase before changing code
6. **Let Ralph Ralph**: Agent determines prioritization and implementation approach

## Your Task

Generate/regenerate the complete Ralph loop infrastructure:

---

### Step 1: Discover Project Context

Read these files to understand the project:
- `CLAUDE.md` or `AGENTS.md` - project rules and commands
- `package.json`, `Cargo.toml`, `go.mod`, or equivalent - determine build system
- Existing `specs/` if any - understand current state

Extract:
- **Validation command** (e.g., `bun run check`, `npm test`, `cargo test`, `go test ./...`)
- **Code patterns** to follow
- **Path conventions** (imports, structure)

---

### Step 2: Generate Specs (`specs/*.md`)

**Topic Scope Test**: Can you describe the topic in ONE sentence WITHOUT "and" for unrelated capabilities?
- PASS: "The effect system renders CSS filters on album art backgrounds"
- FAIL: "The user system handles authentication, profiles, and billing" → Split into 3 specs

**Spec Format** (let format evolve naturally, but include these sections):

```markdown
# [Topic Name]

## Overview
One sentence describing this topic of concern.

## Requirements

### [Requirement Group]
- Requirement detail
- Another requirement

### [Another Group]
...

## State Model (if applicable)
```typescript
interface State { ... }
```

## Files to Create/Modify
- `path/to/file.ext` - what changes

## Acceptance Criteria
- [ ] Observable, verifiable outcome 1
- [ ] Observable, verifiable outcome 2
```

**Naming**: `kebab-case-topic.md` (e.g., `image-edit-mode.md`, `effects-system.md`)

**Important**: Acceptance criteria define WHAT (behavioral outcomes), not HOW (implementation details).

---

### Step 3: Generate `IMPLEMENTATION_PLAN.md`

```markdown
# [Feature Name] - Implementation Plan

Generated from specs. Tasks sorted by priority.

## Status Legend
- [ ] Not started
- [x] Completed
- [~] In progress
- [!] Blocked

---

## Phase 1: [Phase Name] (P0)

### Task 1: [Descriptive task name]
- **File**: `path/to/file.ext` (new) or (modify)
- **Description**: One sentence
- **Details**:
  - Specific implementation detail
  - Another detail
- [ ] Not started

### Task 2: ...

---

## Phase 2: [Phase Name] (P1)
...

---

## Discovered Tasks

(Tasks discovered during implementation go here)

---

## Completed Tasks

(Move completed tasks here with brief notes)

---

## Notes

- One task per loop iteration
- Search before implementing
```

**Priority**:
- P0: Core functionality (feature doesn't work without this)
- P1: Important (significantly improves feature)
- P2: Polish (nice-to-have, accessibility, edge cases)

**Task Sizing**: Each task completable in ONE loop iteration. If too big, split it.

---

### Step 4: Generate `PROMPT_plan.md`

```markdown
# Planning Mode

You are in PLANNING mode. Analyze specifications against existing code and generate a prioritized implementation plan.

## Phase 0: Orient

### 0a. Study specifications
Read all files in `specs/` directory using parallel subagents.

### 0b. Study existing implementation
Use parallel subagents to analyze relevant source directories:
- [List directories relevant to the feature]

### 0c. Study the current plan
Read `IMPLEMENTATION_PLAN.md` if it exists.

## Phase 1: Gap Analysis

Compare specs against implementation:
- What's already implemented?
- What's missing?
- What's partially done?

**CRITICAL**: Don't assume something isn't implemented. Search the codebase first. This is Ralph's Achilles' heel.

## Phase 2: Generate Plan

Update `IMPLEMENTATION_PLAN.md` with:
- Tasks sorted by priority (P0 → P1 → P2)
- Clear descriptions with file locations
- Dependencies noted where relevant
- Discoveries from gap analysis

Capture the WHY, not just the WHAT.

## Guardrails

999. NEVER implement code in planning mode
1000. Use up to 10 parallel subagents for analysis
1001. Each task must be completable in ONE loop iteration
1002. Ultrathink before finalizing priorities

## Exit

When plan is complete:
1. Commit updated `IMPLEMENTATION_PLAN.md`
2. Exit

## Context Files

- @AGENTS.md or @CLAUDE.md
- @specs/*
- @IMPLEMENTATION_PLAN.md
```

---

### Step 5: Generate `PROMPT_build.md`

```markdown
# Building Mode

You are in BUILDING mode. Implement ONE task from the plan, validate, commit, exit.

## Phase 0: Orient

### 0a. Study context
Read `@AGENTS.md` or `@CLAUDE.md` for project rules.

### 0b. Study the plan
Read `@IMPLEMENTATION_PLAN.md` to understand current state.

### 0c. Select task
Choose the highest priority incomplete task (first `[ ] Not started`).

## Phase 1: Implement

### 1a. Search first
**CRITICAL**: Search codebase to verify functionality doesn't already exist. Use up to 500 parallel subagents for searches and reads.

### 1b. Implement
Write the code for this ONE task. Use Opus subagents for complex reasoning.

### 1c. Validate
Run validation command: `[VALIDATION_COMMAND]`

Must pass before proceeding. If it fails, fix and retry.

## Phase 2: Update Plan

Mark the task complete in `IMPLEMENTATION_PLAN.md`:
- Move to Completed Tasks section
- Add any discovered tasks
- Note any relevant findings

## Phase 3: Commit

Create atomic commit:
```
feat([scope]): short description

Details if needed.

Co-Authored-By: Claude <noreply@anthropic.com>
```

## Guardrails

999. ONE task per iteration - do not batch
1000. Search before implementing - don't duplicate existing code
1001. Validation MUST pass before commit
1002. Only use 1 subagent for build/tests (bottleneck = backpressure)
1003. Up to 500 subagents for searches and reads

## Exit Conditions

**Success**: Task complete, tests pass, committed → Exit

**Blocked**: Document blocker in plan, commit plan update → Exit

## Context Files

- @AGENTS.md or @CLAUDE.md
- @IMPLEMENTATION_PLAN.md
- @specs/*
```

---

### Step 6: Generate `loop.sh`

Generate the enhanced loop script with automatic usage limit detection and recovery:

```bash
#!/bin/bash

# Ralph Wiggum Loop (Enhanced)
# Reference: https://github.com/ghuntley/how-to-ralph-wiggum
#
# Features:
#   - Automatic usage limit detection and recovery
#   - Sleep until reset with countdown
#   - Graceful retry after rate limits
#
# Usage:
#   ./loop.sh           # Build mode (default)
#   ./loop.sh plan      # Planning mode
#   ./loop.sh 10        # Max 10 iterations
#   ./loop.sh plan 5    # Planning mode, max 5 iterations

set -e

MODE="build"
MAX_ITERATIONS=0
ITERATION=0
CONSECUTIVE_FAILURES=0
MAX_CONSECUTIVE_FAILURES=3

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

for arg in "$@"; do
  if [[ "$arg" == "plan" ]]; then
    MODE="plan"
  elif [[ "$arg" =~ ^[0-9]+$ ]]; then
    MAX_ITERATIONS=$arg
  fi
done

PROMPT_FILE="PROMPT_${MODE}.md"

# Calculate seconds until next hour boundary
seconds_until_next_hour() {
  local now=$(date +%s)
  local current_minute=$(date +%M)
  local current_second=$(date +%S)
  local seconds_past_hour=$((10#$current_minute * 60 + 10#$current_second))
  local seconds_until=$((3600 - seconds_past_hour))
  echo $seconds_until
}

# Calculate seconds until specific reset time (e.g., midnight UTC, 5am local)
seconds_until_daily_reset() {
  # Assuming daily reset at 5:00 AM local time (adjust as needed)
  local reset_hour=5
  local now=$(date +%s)
  local today_reset=$(date -v${reset_hour}H -v0M -v0S +%s 2>/dev/null || date -d "today ${reset_hour}:00:00" +%s)

  if [[ $now -ge $today_reset ]]; then
    # Reset already passed today, calculate for tomorrow
    local tomorrow_reset=$((today_reset + 86400))
    echo $((tomorrow_reset - now))
  else
    echo $((today_reset - now))
  fi
}

# Display countdown timer
countdown() {
  local seconds=$1
  local message=$2

  while [[ $seconds -gt 0 ]]; do
    local hours=$((seconds / 3600))
    local minutes=$(((seconds % 3600) / 60))
    local secs=$((seconds % 60))
    printf "\r${CYAN}%s${NC} Time remaining: %02d:%02d:%02d " "$message" $hours $minutes $secs
    sleep 1
    ((seconds--))
  done
  printf "\r%-80s\r" " "  # Clear the line
}

# Check if error indicates usage limit exceeded
is_usage_limit_error() {
  local output="$1"
  local exit_code="$2"

  # Check for common rate limit / usage limit patterns
  if [[ "$output" =~ (rate.?limit|usage.?limit|quota.?exceeded|too.?many.?requests|429|exceeded.*limit|limit.*exceeded|billing|credit) ]]; then
    return 0
  fi

  # Exit code 1 with specific error patterns
  if [[ "$exit_code" == "1" && "$output" =~ (overloaded|capacity|unavailable) ]]; then
    return 0
  fi

  return 1
}

# Determine sleep duration based on error type
get_sleep_duration() {
  local output="$1"

  # Try to extract reset time from error message if present
  # Pattern: "resets at HH:MM" or "try again in X minutes/hours"
  if [[ "$output" =~ "try again in "([0-9]+)" minute" ]]; then
    echo $(( ${BASH_REMATCH[1]} * 60 + 60 ))  # Add 1 minute buffer
    return
  fi

  if [[ "$output" =~ "try again in "([0-9]+)" hour" ]]; then
    echo $(( ${BASH_REMATCH[1]} * 3600 + 60 ))
    return
  fi

  # Check for daily limit vs hourly limit
  if [[ "$output" =~ (daily|day|24.?hour) ]]; then
    seconds_until_daily_reset
    return
  fi

  # Default: wait until next hour boundary + 1 minute buffer
  local wait_time=$(seconds_until_next_hour)
  echo $((wait_time + 60))
}

# Handle usage limit - sleep and retry
handle_usage_limit() {
  local output="$1"
  local sleep_duration=$(get_sleep_duration "$output")

  echo ""
  echo -e "${YELLOW}=== Usage Limit Detected ===${NC}"
  echo -e "${YELLOW}Claude usage limit exceeded. Waiting for reset...${NC}"
  echo ""

  # Show when we expect to resume
  local resume_time=$(date -v+${sleep_duration}S "+%Y-%m-%d %H:%M:%S" 2>/dev/null || date -d "+${sleep_duration} seconds" "+%Y-%m-%d %H:%M:%S")
  echo -e "Expected resume: ${CYAN}${resume_time}${NC}"
  echo ""

  countdown $sleep_duration "Waiting for usage reset..."

  echo ""
  echo -e "${GREEN}Usage limit should be reset. Resuming...${NC}"
  echo ""

  # Reset consecutive failures after successful wait
  CONSECUTIVE_FAILURES=0
}

echo -e "${GREEN}Ralph loop: $(echo "$MODE" | tr '[:lower:]' '[:upper:]') mode${NC}"
[[ $MAX_ITERATIONS -gt 0 ]] && echo "Max iterations: $MAX_ITERATIONS"
echo "Press Ctrl+C to stop"
echo "---"

while true; do
  ITERATION=$((ITERATION + 1))
  echo ""
  echo -e "${GREEN}=== Iteration $ITERATION ===${NC}"
  echo ""

  # Capture both stdout and stderr, and exit code
  TEMP_OUTPUT=$(mktemp)
  set +e

  claude -p \
    --dangerously-skip-permissions \
    --model opus \
    --output-format stream-json \
    <<< "$(cat "$PROMPT_FILE")" 2>&1 | tee "$TEMP_OUTPUT" | jq -r 'select(.type == "assistant") | .message.content[]?.text // empty' 2>/dev/null

  EXIT_CODE=$?
  OUTPUT=$(cat "$TEMP_OUTPUT")
  rm -f "$TEMP_OUTPUT"
  set -e

  # Check for usage limit errors
  if is_usage_limit_error "$OUTPUT" "$EXIT_CODE"; then
    handle_usage_limit "$OUTPUT"
    # Don't count this as an iteration - retry the same iteration
    ITERATION=$((ITERATION - 1))
    continue
  fi

  # Check for other errors
  if [[ $EXIT_CODE -ne 0 ]]; then
    CONSECUTIVE_FAILURES=$((CONSECUTIVE_FAILURES + 1))
    echo ""
    echo -e "${RED}=== Error (exit code: $EXIT_CODE) ===${NC}"

    if [[ $CONSECUTIVE_FAILURES -ge $MAX_CONSECUTIVE_FAILURES ]]; then
      echo -e "${RED}Too many consecutive failures ($CONSECUTIVE_FAILURES). Stopping.${NC}"
      exit 1
    fi

    echo -e "${YELLOW}Retrying in 30 seconds... (failure $CONSECUTIVE_FAILURES/$MAX_CONSECUTIVE_FAILURES)${NC}"
    sleep 30
    ITERATION=$((ITERATION - 1))  # Retry same iteration
    continue
  fi

  # Success - reset failure counter
  CONSECUTIVE_FAILURES=0

  if [[ $MAX_ITERATIONS -gt 0 && $ITERATION -ge $MAX_ITERATIONS ]]; then
    echo ""
    echo -e "${GREEN}Reached max iterations ($MAX_ITERATIONS).${NC}"
    break
  fi

  sleep 2
done

echo ""
echo -e "${GREEN}Ralph loop complete. Iterations: $ITERATION${NC}"
```

---

## Execution Checklist

1. [ ] Read project context (CLAUDE.md/AGENTS.md, package.json/Cargo.toml/etc.)
2. [ ] Read feature doc from argument or find in docs/
3. [ ] Remove old specs if they belong to a different feature
4. [ ] Generate new specs (one topic per file, passes "one sentence" test)
5. [ ] Generate IMPLEMENTATION_PLAN.md with prioritized tasks
6. [ ] Generate PROMPT_plan.md (customize directories to analyze)
7. [ ] Generate PROMPT_build.md (set correct validation command)
8. [ ] Generate loop.sh (with usage limit handling)
9. [ ] Run `chmod +x loop.sh`
10. [ ] Verify all files created

## Final Notes

- **Sandbox Warning**: Ralph uses `--dangerously-skip-permissions`. Run in Docker/sandbox to protect credentials.
- **Usage Limits**: The enhanced loop.sh automatically detects rate limits and waits for reset with a countdown timer.
- **Tuning**: Observe early loops. When Ralph fails consistently, add guardrails to prompts.
- **Regenerate**: If plan goes off-track, delete and regenerate. One planning loop is cheap.
- **Let Ralph Ralph**: Don't over-specify. Agent determines approach.
