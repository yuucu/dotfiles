#!/bin/bash

# Claude Code モニタースクリプト
# Claude Code プロセスとその稼働状況を監視する

# 設定
PROCESS_NAME="claude"
CPU_THRESHOLD=${CCMONITOR_CPU_THRESHOLD:-1.0}

# プロセス名からプロセス数を取得
get_process_count() {
    local process_name=$1
    pgrep -x "$process_name" 2>/dev/null | wc -l | tr -d ' '
}

# アクティブなプロセス数を取得 (CPU > 閾値)
get_active_process_count() {
    local process_name=$1
    local threshold=$2
    local count=0

    local pids=$(pgrep -x "$process_name" 2>/dev/null)
    if [ -z "$pids" ]; then
        echo 0
        return
    fi

    # パフォーマンス向上のため ps を一度だけ呼ぶ
    while read -r pid cpu; do
        if [ -n "$cpu" ] && awk -v cpu="$cpu" -v thresh="$threshold" \
           'BEGIN { if (cpu > thresh) exit 0; else exit 1 }'; then
            count=$((count + 1))
        fi
    done < <(ps -o pid=,pcpu= -p $(echo "$pids" | tr '\n' ',' | sed 's/,$//') 2>/dev/null)

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