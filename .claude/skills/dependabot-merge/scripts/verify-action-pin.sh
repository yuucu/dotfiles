#!/bin/bash
# Dependabot が pin した SHA が上流タグの指すコミットと一致するか検証する。
# annotated tag は ref が tag オブジェクトを指すため、コミット SHA へ deref して比較する。
#
# usage: verify-action-pin.sh <owner/repo> <tag> <pinned-sha>
# exit 0: 一致 / exit 1: 不一致 / exit 2: 引数エラー
set -euo pipefail

if [ $# -ne 3 ]; then
  echo "usage: $0 <owner/repo> <tag> <pinned-sha>" >&2
  exit 2
fi

repo="$1"
tag="$2"
pinned="$3"

ref_json=$(gh api "repos/${repo}/git/ref/tags/${tag}")
obj_type=$(echo "$ref_json" | jq -r '.object.type')
obj_sha=$(echo "$ref_json" | jq -r '.object.sha')

if [ "$obj_type" = "tag" ]; then
  commit_sha=$(gh api "repos/${repo}/git/tags/${obj_sha}" --jq '.object.sha')
else
  commit_sha="$obj_sha"
fi

if [ "$commit_sha" = "$pinned" ]; then
  echo "OK: ${repo}@${tag} -> ${commit_sha}"
else
  echo "NG: ${repo}@${tag} の実体は ${commit_sha} だが、PR の pin は ${pinned}" >&2
  exit 1
fi
