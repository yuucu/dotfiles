# Claude Code Monitor for tmux

Claude Code プロセスの監視を tmux ステータスバーに表示するプラグインです。

## 機能

- Claude Code プロセスの総数を表示
- CPU 使用率が閾値を超えるアクティブなプロセス数を表示

## 使用方法

tmux.conf で設定：

```bash
# CPU 閾値の設定（デフォルト: 1.0%）
set -g @ccmonitor_cpu_threshold "1.0"

# プラグインをロード
run-shell ~/.config/tmux/plugins/ccmonitor_tmux/ccmonitor_tmux.tmux

# ステータスバーに表示
set -g status-right "🤖#{ccmonitor_active}/#{ccmonitor_total} | %Y-%m-%d %H:%M"
```

## プレースホルダー

- `#{ccmonitor_active}` - CPU 閾値を超えるアクティブプロセス数
- `#{ccmonitor_total}` - Claude Code プロセスの総数
