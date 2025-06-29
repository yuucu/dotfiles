#!/bin/bash

# Claude Code Status Detection Script
# Detects running claude-code processes and their activity status

get_claude_processes() {
    # Get all claude processes with CPU usage
    ps aux | grep -E "claude|claude-code" | grep -v grep | while read -r line; do
        # Extract process info
        user=$(echo "$line" | awk '{print $1}')
        pid=$(echo "$line" | awk '{print $2}')
        cpu=$(echo "$line" | awk '{print $3}')
        command=$(echo "$line" | awk '{for(i=11;i<=NF;i++) printf "%s ", $i; print ""}')
        
        # Check if it's actually claude-code (not just claude in path)
        if echo "$command" | grep -q "claude"; then
            echo "$pid,$cpu,$command"
        fi
    done
}

count_total_processes() {
    get_claude_processes | wc -l | tr -d ' '
}

count_active_processes() {
    # Consider processes with CPU > 5% as active
    get_claude_processes | awk -F',' '$2 > 5.0 {count++} END {print count+0}'
}

get_status_display() {
    local total=$(count_total_processes)
    local active=$(count_active_processes)
    
    if [ "$total" -eq 0 ]; then
        echo "🤖 0"
    else
        if [ "$active" -gt 0 ]; then
            echo "🤖 $total/$active"
        else
            echo "🤖 $total"
        fi
    fi
}

# Main execution
case "$1" in
    "total")
        count_total_processes
        ;;
    "active")
        count_active_processes
        ;;
    "display")
        get_status_display
        ;;
    *)
        get_status_display
        ;;
esac