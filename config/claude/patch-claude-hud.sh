#!/usr/bin/env bash
# claude-hud: prompt cache が失効したときの表示を赤（critical）にする。
#
# 本家は expired を label()（dim）で描画するため、失効時に一番目立たなくなる。
# 失効は「次のリクエストでキャッシュ再構築コストが発生する」警告すべき状態なので、
# ラベルごと critical 色に変える。
#
# plugin を更新すると消えるため、更新後にこのスクリプトを再実行すること。
# 冪等: 適用済みなら何もしない。
set -euo pipefail

claude_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
plugin_dir=$(
  find "$claude_dir"/plugins/cache -mindepth 3 -maxdepth 3 -type d -path '*/claude-hud/*' 2>/dev/null \
    | awk -F/ '{ print $NF "\t" $0 }' \
    | grep -E '^[0-9]+\.[0-9]+\.[0-9]+[[:space:]]' \
    | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n \
    | tail -1 | cut -f2-
)

if [ -z "$plugin_dir" ]; then
  echo "claude-hud が見つかりません" >&2
  exit 1
fi

target="$plugin_dir/src/render/lines/prompt-cache.ts"
[ -f "$target" ] || { echo "見つかりません: $target" >&2; exit 1; }

if grep -q 'criticalColor' "$target"; then
  echo "適用済み: $plugin_dir"
  exit 0
fi

python3 - "$target" <<'PY'
import sys, re
p = sys.argv[1]
s = open(p).read()

# import に critical を追加
old_import = "import { getContextColor, RESET, label, warning as warningColor } from '../colors.js';"
new_import = "import { getContextColor, RESET, label, warning as warningColor, critical as criticalColor } from '../colors.js';"
assert old_import in s, "import 行が想定と異なります"
s = s.replace(old_import, new_import)

# expired を dim から critical に
old_expired = """  if (state === 'expired') {
    return label(value, ctx.config?.colors);
  }"""
new_expired = """  if (state === 'expired') {
    return criticalColor(value, ctx.config?.colors);
  }"""
assert old_expired in s, "expired 分岐が想定と異なります"
s = s.replace(old_expired, new_expired)

# expired のときはラベル (Cache) も赤にする
old_ret = "  return `${label(t('label.promptCache'), ctx.config?.colors)} ${colorPromptCacheValue(`⏱ ${value}`, state, ctx)}`;"
new_ret = """  const labelText = state === 'expired'
    ? criticalColor(t('label.promptCache'), ctx.config?.colors)
    : label(t('label.promptCache'), ctx.config?.colors);

  return `${labelText} ${colorPromptCacheValue(`⏱ ${value}`, state, ctx)}`;"""
assert old_ret in s, "return 行が想定と異なります"
s = s.replace(old_ret, new_ret)

open(p, "w").write(s)
PY

echo "適用しました: $plugin_dir"
