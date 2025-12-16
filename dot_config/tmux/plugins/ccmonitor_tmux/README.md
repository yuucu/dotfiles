# Claude Code Monitor for tmux

Claude Code プロセスの監視を tmux ステータスバーに表示する tmux プラグインです。

## 機能

- Claude Code プロセスの総数を表示
- CPU 使用率が閾値を超えるアクティブなプロセス数を表示
- CPU 閾値のカスタマイズが可能

## インストール

chezmoi でインストールされます。

## 使用方法

tmux.conf でステータスバーに表示：

```bash
set -g status-right "🤖#{ccmonitor_active}/#{ccmonitor_total} | %Y-%m-%d %H:%M"
```

### 設定オプション

#### CPU 閾値の設定

環境変数で設定（`~/.zshrc` または `~/.bashrc`）:

```bash
export CCMONITOR_CPU_THRESHOLD=10.0  # デフォルト: 1.0
```

または tmux.conf で設定:

```bash
set -g @ccmonitor_cpu_threshold "10.0"
```

#### 更新間隔の設定

```bash
set -g @ccmonitor_interval "5"  # デフォルト: 5秒
```

## プレースホルダー

- `#{ccmonitor_active}` - CPU 閾値を超えるアクティブプロセス数
- `#{ccmonitor_total}` - Claude Code プロセスの総数

## ライセンス

MIT
