#!/bin/bash

# Generic Process Monitor Library
# Monitors processes and their activity status
# Usage: source this file and call functions with process name

# Get process count by name
get_process_count() {
    local process_name=$1
    pgrep -x "$process_name" 2>/dev/null | wc -l | tr -d ' '
}

# Get active processes (CPU > threshold)
get_active_process_count() {
    local process_name=$1
    local threshold=$2
    local count=0

    local pids=$(pgrep -x "$process_name" 2>/dev/null)
    if [ -z "$pids" ]; then
        echo 0
        return
    fi

    # Get all process info in one call for better performance
    while read -r pid cpu; do
        if [ -n "$cpu" ] && awk -v cpu="$cpu" -v thresh="$threshold" 'BEGIN { if (cpu > thresh) exit 0; else exit 1 }'; then
            count=$((count + 1))
        fi
    done < <(ps -o pid=,pcpu= -p $(echo "$pids" | tr '\n' ',' | sed 's/,$//') 2>/dev/null)

    echo $count
}

# Get processes with detailed info
get_processes_info() {
    local process_name=$1
    ps -eo pid,pcpu,pmem,comm,args | grep -E "\\b${process_name}\\b" | grep -v grep
}

# Display status in simple format (x/y)
display_simple() {
    local active=$1
    local total=$2
    echo "${active}/${total}"
}

# Main monitoring function
monitor_process() {
    local process_name=$1
    local action=${2:-"status"}
    local cpu_threshold=${3:-1.0}

    case $action in
        "status")
            local total=$(get_process_count "$process_name")
            local active=$(get_active_process_count "$process_name" "$cpu_threshold")
            display_simple $active $total
            ;;
        "active")
            echo $(get_active_process_count "$process_name" "$cpu_threshold")
            ;;
        "total")
            echo $(get_process_count "$process_name")
            ;;
        "info")
            echo "${process_name} Process Information:"
            echo "================================"
            echo "Total processes: $(get_process_count "$process_name")"
            echo "Active processes (CPU > ${cpu_threshold}%): $(get_active_process_count "$process_name" "$cpu_threshold")"
            echo ""
            echo "Process Details:"
            get_processes_info "$process_name"
            ;;
        *)
            echo "Unknown action: $action"
            return 1
            ;;
    esac
}
