#!/usr/bin/env bash
# Claude Code Statusline with Context Information

# Read JSON input from stdin
input=$(cat)

# Helper functions to extract data
get_model() {
  local val=$(echo "$input" | jq -r '.model.displayName // .model.id // empty')
  [[ -n "$val" && "$val" != "null" ]] && echo "$val" || echo "-"
}
get_cost() {
  local val=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
  [[ -n "$val" && "$val" != "null" ]] && echo "$val" || echo ""
}
get_duration() {
  local val=$(echo "$input" | jq -r '.duration.total_ms // empty')
  [[ -n "$val" && "$val" != "null" ]] && echo "$val" || echo ""
}

# Context information from JSON (if available)
# Note: Token information might be available in the JSON input
get_context() {
  # Try to extract token or context information if available
  local tokens=$(echo "$input" | jq -r '.tokens.total // empty' 2>/dev/null)
  local context=$(echo "$input" | jq -r '.context.size // empty' 2>/dev/null)

  if [[ -n "$tokens" ]]; then
    echo "$tokens"
  elif [[ -n "$context" ]]; then
    echo "$context"
  else
    echo "-"
  fi
}

# Extract values
model=$(get_model)
cost=$(get_cost)
duration=$(get_duration)
context=$(get_context)

# Format duration (convert ms to seconds)
if [[ "$duration" != "null" && -n "$duration" ]]; then
  duration_sec=$(echo "scale=1; $duration / 1000" | bc)
  duration_display="${duration_sec}s"
else
  duration_display="-"
fi

# Format cost
if [[ "$cost" != "null" && -n "$cost" ]]; then
  cost_display=$(printf "\$%.4f" "$cost")
else
  cost_display="-"
fi

# Color codes
RESET="\033[0m"
BLUE="\033[34m"
GREEN="\033[32m"
YELLOW="\033[33m"
CYAN="\033[36m"
GRAY="\033[90m"

# Build status line
echo -e "${BLUE}󰧑 ${model}${RESET} ${GRAY}|${RESET} ${CYAN}󰔷 ctx:${context}${RESET} ${GRAY}|${RESET} ${YELLOW}󰊫 ${duration_display}${RESET} ${GRAY}|${RESET} ${GREEN}󰪥 ${cost_display}${RESET}"
