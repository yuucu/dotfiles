#!/bin/bash

# Codex Monitor Script
# Monitors Codex processes and their activity status

# Get script directory and load common library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SCRIPT_DIR/../lib" && pwd)"

# Source the generic process monitor library
source "$LIB_DIR/generic_process_monitor.sh"

# Configuration
PROCESS_NAME="codex"
CPU_THRESHOLD=${CODEXMONITOR_CPU_THRESHOLD:-0.1}
UPDATE_INTERVAL=${CODEXMONITOR_UPDATE_INTERVAL:-5}

# Main function
main() {
    local action=${1:-"status"}

    case $action in
        "status"|"active"|"total"|"info")
            monitor_process "$PROCESS_NAME" "$action" "$CPU_THRESHOLD"
            ;;
        "test")
            echo "Testing Codex Monitor..."
            echo "CPU Threshold: ${CPU_THRESHOLD}%"
            echo "Update Interval: ${UPDATE_INTERVAL}s"
            echo ""
            monitor_process "$PROCESS_NAME" "info" "$CPU_THRESHOLD"
            ;;
        "help")
            echo "Codex Monitor - Usage:"
            echo "  $0 [status|active|total|info|test|help]"
            echo ""
            echo "Environment Variables:"
            echo "  CODEXMONITOR_CPU_THRESHOLD - CPU threshold for active processes (default: 0.1)"
            echo "  CODEXMONITOR_UPDATE_INTERVAL - Update interval in seconds (default: 5)"
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
