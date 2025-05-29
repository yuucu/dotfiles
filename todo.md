
思考時間: 1m 53s
以下は 「chezmoi で管理する Neovim 中心 dotfiles を “誰でも clone → すぐ試せる” 公開リポジトリに仕立てる設計図」 です。
ポイントは ①レイアウトを読める形で公開しつつ ②秘密は age で暗号化し ③CI で壊れていないか自動チェック の三本柱です。

1. リポジトリのトップレベル構成
csharp
コピーする
編集する
dotfiles/
├── README.md              # 初期セットアップ一行コマンドや設計方針を明記
├── LICENSE                # MIT/LGPL など明示（例: MIT）           
├── .chezmoi.yaml          # chezmoi 設定（ソース dir, 暗号化方式）
├── .chezmoiignore         # 公開不要ファイルを除外
├── .chezmoiexternal.toml  # tpm など外部リポジトリ自動取得設定
├── scripts/
│   └── bootstrap.sh       # curl | sh で実行される初期化ワンライナー
├── dot_config/
│   └── nvim/              # Neovim (lazy.nvim) 完全 Lua 構成
│       ├── init.lua
│       ├── lua/
│       └── lazy-lock.json
└── private/
    └── encrypted_id_rsa.txt.age  # age で暗号化された秘密鍵
chezmoi は dot_ → . に変換されて展開されるため、上記のように置くだけで $HOME/.config/nvim 等へシンボリックリンク不要で反映できます 。
LICENSE を明示しておくと外部の人が安心して reuse できます（MIT の実例 : CoreyMSchafer/dotfiles）。

2. 秘密情報を安全に公開する ― age × chezmoi
操作	コマンド例	説明
age 鍵生成	age-keygen -o ~/.config/age/keys.txt	private key は公開しない
追加 & 暗号化	chezmoi add --encrypt ~/.ssh/id_rsa	encrypted_id_rsa.txt.age が作成される
復号して編集	chezmoi edit ~/.ssh/id_rsa	自動復号→保存時再暗号化

age はコンパクト鍵・少設定のモダン暗号ツールで chezmoi が標準対応 。

.chezmoiignore で private_key* など万一平文が混入してもコミットされないよう保険を掛けます 。

さらに機密を多人数運用する場合は Mozilla SOPS + age で CI から復号する運用もあり 。

3. README に必ず載せたい 5 つの項目
クローン & 適用 1 行

bash
コピーする
編集する
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply <your-github-name>/dotfiles
chezmoi 公式インストーラを使えば “clone 即 apply” が実現できます 。

依存パッケージ

chezmoi ≥ 2.50, age, git, neovim ≥ 0.10 など。

レイアウト説明図（前章を転載）。

暗号化ファイルの復号方法

bash
コピーする
編集する
export AGE_SECRET_KEY="$(pass show age/keys.txt)"
chezmoi apply
コントリビュート手順
Fork → Feature branch → PR。スタイルチェックは CI がブロック、と明記。

良い README は「何が出来て・どう試すか」を 30 秒で掴めるようにするのがコツです 。

4. GitHub Actions で “壊れていない” を保証
yaml
コピーする
編集する
name: dotfiles CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install chezmoi & deps
        run: |
          curl -fsLS get.chezmoi.io | sh -s -- -b "$HOME/bin"
          sudo apt-get update && sudo apt-get -y install neovim shellcheck stylua
      - name: Lint shell & Lua
        run: |
          shellcheck scripts/*.sh
          stylua --check dot_config/nvim
      - name: Dry-run apply
        run: |
          "$HOME/bin/chezmoi" apply --dry-run --verbose
      - name: Lazy.nvim sync
        run: |
          nvim --headless "+Lazy! sync" +qa
chezmoi apply --dry-run でテンプレートが壊れていないか確認する事例は公式 discussion でも推奨されています 。

headless Neovim 起動で lazy-lock.json の衝突も早期検知できるため “clone したら起動しない” 事故を防げます。

5. テンプレート・マシン分岐の実装例
tmpl
コピーする
編集する
# dot_zshrc.tmpl
{{ if eq .chezmoi.hostname "work-laptop" }}
export EDITOR="vim"
{{ else }}
export EDITOR="nvim"
{{ end }}
Go template 拡張でホスト名や OS 判定が可能なので 1 ファイルに多環境を収めつつ公開できます 。
ホスト毎の大規模差分は ~/.config/chezmoi/chezmoi.toml に [data] role="work" のように置いて条件分岐する手もあります 。

6. 追加で押さえておきたい小技
目的	機能/ファイル	参考
外部プラグインの自動 DL	.chezmoiexternal.toml	tpm などを tarball で取得
グローバル GitIgnore	$HOME/.gitignore_global	バイナリや swap を一括無視
OS ごとのパッケージ自動導入	run_once_install-packages.sh.tmpl	brew/apt 分岐の例
Code of Conduct	CODE_OF_CONDUCT.md	OSS 文化圏での安心感

まとめ
公開レイアウト : dot_* プレフィクスにまとめ、README と LICENSE を必ず置く。

セキュリティ : chezmoi add --encrypt + age で秘密をコミット可能にしつつ漏洩は防ぐ。

信頼性 : GitHub Actions で「テンプレート→dry-run」「Neovim 起動」「lint」を毎 PR で実行。

拡張性 : テンプレート／外部レポ／スクリプトで macOS–Linux–WSL まで 1 repo で賄う。

この構成なら “パブリックにしても安全・誰でもすぐ再現・壊れにくい” dotfiles リポジトリを維持できます。
