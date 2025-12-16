# Codex Monitor for tmux

Codex プロセスの監視を tmux ステータスバーに表示する tmux プラグインです。

## 機能

- Codex プロセスの総数を表示
- CPU 使用率が閾値を超えるアクティブなプロセス数を表示
- CPU 閾値のカスタマイズが可能

## インストール

### TPM (Tmux Plugin Manager) を使用する場合

`~/.config/tmux/tmux.conf` に以下を追加：

```bash
set -g @plugin 'codexmonitor_tmux'
```

### 手動インストール

```bash
mkdir -p ~/.config/tmux/plugins/codexmonitor_tmux
# プラグインファイルをコピー
```

## 使用方法

tmux.conf でステータスバーに表示：

```bash
set -g status-right "🤖#{codexmonitor_active}/#{codexmonitor_total} | %Y-%m-%d %H:%M"
```

### 設定オプション

#### CPU 閾値の設定

環境変数で設定（`~/.zshrc` または `~/.bashrc`）:

```bash
export CODEXMONITOR_CPU_THRESHOLD=10.0  # デフォルト: 1.0
```

または tmux.conf で設定:

```bash
set -g @codexmonitor_cpu_threshold "10.0"
```

#### 更新間隔の設定

```bash
set -g @codexmonitor_interval "5"  # デフォルト: 5秒
```

## プレースホルダー

- `#{codexmonitor_active}` - CPU 閾値を超えるアクティブプロセス数
- `#{codexmonitor_total}` - Codex プロセスの総数

## コマンドラインでの使用

```bash
# ステータス表示 (active/total)
~/.config/tmux/plugins/codexmonitor_tmux/codexmonitor_tmux.sh status

# アクティブプロセス数のみ
~/.config/tmux/plugins/codexmonitor_tmux/codexmonitor_tmux.sh active

# 総プロセス数のみ
~/.config/tmux/plugins/codexmonitor_tmux/codexmonitor_tmux.sh total

# 詳細情報
~/.config/tmux/plugins/codexmonitor_tmux/codexmonitor_tmux.sh info

# ヘルプ
~/.config/tmux/plugins/codexmonitor_tmux/codexmonitor_tmux.sh help
```

## ライセンス

MIT
