#!/bin/bash

# Claude Code Monitor tmux plugin
# Displays Claude Code process status in tmux status bar

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default values
DEFAULT_INTERVAL="5"
DEFAULT_CPU_THRESHOLD="1.0"

# Get tmux option with default fallback
get_tmux_option() {
    local option="$1"
    local default_value="$2"
    local option_value=$(tmux show-option -gqv "$option")
    if [ -z "$option_value" ]; then
        echo "$default_value"
    else
        echo "$option_value"
    fi
}

# Set tmux option
set_tmux_option() {
    local option="$1"
    local value="$2"
    tmux set-option -g "$option" "$value"
}

# Do interpolation of status string
do_interpolation() {
    local string="$1"
    local active_value="$2"
    local total_value="$3"
    
    # Simple interpolation for all placeholders
    string="${string//\#{ccmonitor_active\}/$active_value}"
    string="${string//\#{ccmonitor_total\}/$total_value}"
    
    echo "$string"
}

# Update tmux option with interpolation
update_tmux_option() {
    local option="$1"
    local option_value="$(get_tmux_option "$option" "")"
    
    # Get configuration
    local cpu_threshold=$(get_tmux_option "@ccmonitor_cpu_threshold" "$DEFAULT_CPU_THRESHOLD")
    
    # Build the command
    local ccmonitor_cmd="env CCMONITOR_CPU_THRESHOLD='$cpu_threshold' '$CURRENT_DIR/ccmonitor_tmux.sh'"
    
    # Replace interpolations
    local new_option_value="${option_value//\#{ccmonitor_active\}/#($ccmonitor_cmd active)}"
    new_option_value="${new_option_value//\#{ccmonitor_total\}/#($ccmonitor_cmd total)}"
    
    set_tmux_option "$option" "$new_option_value"
}

# Main function to setup the plugin
main() {
    # Get configuration options
    local update_interval=$(get_tmux_option "@ccmonitor_interval" "$DEFAULT_INTERVAL")
    
    # Update tmux status bar update interval
    local current_interval=$(get_tmux_option "status-interval" "15")
    if [ "$current_interval" -gt "$update_interval" ]; then
        set_tmux_option "status-interval" "$update_interval"
    fi
    
    # Update status-left and status-right
    update_tmux_option "status-left"
    update_tmux_option "status-right"
}

# Load the plugin
main "$@"