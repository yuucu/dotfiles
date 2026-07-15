---
name: dependabot-merge
description: Dependabot が作成した依存更新 PR（主に GitHub Actions の SHA bump）を精査してマージする。差分範囲の確認、新 SHA と上流タグの対応検証、上流の変更内容確認、CI 通過確認を経て squash マージする。「dependabot の PR をマージして」「dependabot を精査して」「依存更新 PR を処理して」などで使用。
---

# Dependabot PR の精査とマージ

## 前提

- PR 操作（マージ・コメント）の前に gh の active アカウントを確認し、CLAUDE.local.md の指示に従って切り替える。作業終了後に元へ戻す。
- 精査で 1 つでも不審な点があればマージせず、理由を添えてユーザーに報告する（マージは取り消せない）。

## 手順

### 1. 対象 PR の一覧

```bash
gh pr list --author "app/dependabot" --state open --json number,title,url,headRefName
```

0 件ならその旨を報告して終了する。

### 2. 各 PR の精査

PR ごとに以下をすべて確認する。

**a. 差分範囲**：`gh pr diff <num>` で変更が想定内であることを確認する。

- GitHub Actions の bump なら `.github/workflows/*.yml` の `uses:` 行（SHA とバージョンコメント）のみが変わること
- 想定外のファイル・行が変わっていたらマージしない

**b. SHA とタグの対応**：bump された action ごとに、PR 本文から新バージョンのタグを特定し、pin された SHA が上流タグの指すコミットと一致するか検証する。

```bash
.claude/skills/dependabot-merge/scripts/verify-action-pin.sh <owner/repo> <tag> <pinned-sha>
# 例: .claude/skills/dependabot-merge/scripts/verify-action-pin.sh actions/checkout v5.0.0 abc123...
```

スクリプトは annotated tag の deref（ref が tag オブジェクトを指すケース）を処理済み。`NG` が出たらタグ差し替えの可能性があるためマージしない。

**c. 上流の変更内容**：リリースノートと差分を俯瞰し、不審な変更（token の扱いの変更、外部への送信追加、難読化されたコード、メンテナ交代直後の大きな変更など）がないか確認する。

```bash
gh api "repos/<owner>/<repo>/releases/tags/<tag>" --jq '.body'
gh api "repos/<owner>/<repo>/compare/<old-sha>...<new-sha>" --jq '.files[].filename'
```

**d. CI**：`gh pr checks <num> --watch` で全チェックの通過を待つ。失敗したらマージしない。

### 3. マージ

```bash
gh pr merge <num> --squash --delete-branch
```

- 複数 PR は 1 件ずつマージする。後続 PR が conflict / stale になったら `gh pr comment <num> --body "@dependabot rebase"` で rebase させ、CI を待って再開する。
- `--delete-branch` のローカル側削除は worktree 使用中だと失敗することがあるが、リモートブランチが消えていれば問題ない。

### 4. 後処理

- main の checkout（リポジトリルート）で `git pull` して最新化する
- gh の active アカウントを元に戻す
- 結果（マージした PR、スキップした PR とその理由）を報告する

## マージしない条件（いずれか 1 つで停止）

- SHA と上流タグが不一致（`verify-action-pin.sh` が NG）
- 差分に想定外のファイル・行の変更が含まれる
- CI が失敗している
- 上流のリリース内容が不審で判断に迷う

この場合は PR をそのまま残し、確認結果を添えてユーザーの判断を仰ぐ。
