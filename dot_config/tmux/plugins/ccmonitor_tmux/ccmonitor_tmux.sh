#!/bin/bash

# Claude Code Monitor Script
# Monitors Claude Code processes and their activity status

# Default configuration
CPU_THRESHOLD=${CCMONITOR_CPU_THRESHOLD:-1.0}
UPDATE_INTERVAL=${CCMONITOR_UPDATE_INTERVAL:-5}

# Function to get Claude Code process count
get_claude_process_count() {
    pgrep -x claude | wc -l | tr -d ' '
}

# Function to get active Claude Code processes (CPU > threshold)
get_active_claude_count() {
    local threshold=$1
    local count=0
    for pid in $(pgrep -x claude); do
        local cpu=$(ps -p $pid -o %cpu= | tr -d ' ')
        if [ -n "$cpu" ] && awk -v cpu="$cpu" -v thresh="$threshold" 'BEGIN { if (cpu > thresh) exit 0; else exit 1 }'; then
            count=$((count + 1))
        fi
    done
    echo $count
}

# Function to get Claude processes with detailed info
get_claude_processes_info() {
    ps -eo pid,pcpu,pmem,comm,args | grep -E "\bclaude\b" | grep -v grep
}

# Function to display status in simple format (x/y)
display_simple() {
    local active=$1
    local total=$2
    echo "${active}/${total}"
}


# Main function
main() {
    local action=${1:-"status"}
    
    case $action in
        "status")
            local total=$(get_claude_process_count)
            local active=$(get_active_claude_count $CPU_THRESHOLD)
            display_simple $active $total
            ;;
        "active")
            echo $(get_active_claude_count $CPU_THRESHOLD)
            ;;
        "total")
            echo $(get_claude_process_count)
            ;;
        "info")
            echo "Claude Code Process Information:"
            echo "================================"
            echo "Total processes: $(get_claude_process_count)"
            echo "Active processes (CPU > ${CPU_THRESHOLD}%): $(get_active_claude_count $CPU_THRESHOLD)"
            echo ""
            echo "Process Details:"
            get_claude_processes_info
            ;;
        "test")
            echo "Testing Claude Code Monitor..."
            echo "CPU Threshold: ${CPU_THRESHOLD}%"
            echo "Update Interval: ${UPDATE_INTERVAL}s"
            echo ""
            main "info"
            ;;
        "help")
            echo "Claude Code Monitor - Usage:"
            echo "  $0 [status|active|total|info|test|help]"
            echo ""
            echo "Environment Variables:"
            echo "  CCMONITOR_CPU_THRESHOLD - CPU threshold for active processes (default: 1.0)"
            echo "  CCMONITOR_UPDATE_INTERVAL - Update interval in seconds (default: 5)"
            ;;
        *)
            echo "Unknown action: $action"
            echo "Use '$0 help' for usage information"
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"