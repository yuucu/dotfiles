#!/usr/bin/env bash

# tmux-claude-status plugin main script

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Default settings
claude_status_format_default="#{claude_status}"
claude_status_update_interval_default="5"

# Get options
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

# Set up the claude status interpolation
set_claude_status_interpolation() {
    local claude_status_format=$(get_tmux_option "@claude_status_format" "$claude_status_format_default")
    local claude_status_script="$CURRENT_DIR/claude_status.sh"
    
    # Register the interpolation
    tmux set-option -gq "@claude_status" "#($claude_status_script display)"
}

# Set up automatic updates
set_claude_status_updates() {
    local update_interval=$(get_tmux_option "@claude_status_update_interval" "$claude_status_update_interval_default")
    local claude_status_script="$CURRENT_DIR/claude_status.sh"
    
    # Set up periodic updates
    tmux set-option -gq status-interval "$update_interval"
}

# Main function
main() {
    set_claude_status_interpolation
    set_claude_status_updates
    
    # Add to status-right if not already configured
    local current_status_right=$(tmux show-option -gqv status-right)
    if [[ "$current_status_right" != *"claude_status"* ]]; then
        if [ -z "$current_status_right" ]; then
            tmux set-option -gq status-right "#{claude_status}"
        else
            tmux set-option -gq status-right "#{claude_status} $current_status_right"
        fi
    fi
}

main