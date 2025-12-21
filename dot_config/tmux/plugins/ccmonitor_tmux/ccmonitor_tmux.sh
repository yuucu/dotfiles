#!/bin/bash

# Claude Code モニタースクリプト
# Claude Code プロセスとその稼働状況を監視する

# 設定
PROCESS_NAME="claude"
CPU_THRESHOLD=${CCMONITOR_CPU_THRESHOLD:-1.0}

# プロセス名からプロセス数を取得
get_process_count() {
    local process_name=$1
    # macOS 対応: ps で claude プロセスを検索
    ps -eo comm | grep -c "^${process_name}$" 2>/dev/null || echo 0
}

# アクティブなプロセス数を取得 (CPU > 閾値)
get_active_process_count() {
    local process_name=$1
    local threshold=$2
    local count=0

    # macOS 対応: ps で直接 claude プロセスを取得
    while read -r pid cpu comm; do
        if [ "$comm" = "$process_name" ] && [ -n "$cpu" ]; then
            if awk -v cpu="$cpu" -v thresh="$threshold" \
               'BEGIN { if (cpu > thresh) exit 0; else exit 1 }'; then
                count=$((count + 1))
            fi
        fi
    done < <(ps -eo pid=,pcpu=,comm= 2>/dev/null | grep "^[[:space:]]*[0-9]")

    echo $count
}

# メイン処理
main() {
    local action=${1:-"status"}

    case $action in
        "status")
            local total=$(get_process_count "$PROCESS_NAME")
            local active=$(get_active_process_count "$PROCESS_NAME" "$CPU_THRESHOLD")
            echo "${active}/${total}"
            ;;
        "active")
            echo $(get_active_process_count "$PROCESS_NAME" "$CPU_THRESHOLD")
            ;;
        "total")
            echo $(get_process_count "$PROCESS_NAME")
            ;;
        "info")
            echo "Claude Code プロセス情報:"
            echo "Total: $(get_process_count "$PROCESS_NAME")"
            echo "Active (CPU > ${CPU_THRESHOLD}%): $(get_active_process_count "$PROCESS_NAME" "$CPU_THRESHOLD")"
            ps -eo pid,pcpu,pmem,comm,args | grep -E "\\bclaude\\b" | grep -v grep
            ;;
    esac
}

main "$@"