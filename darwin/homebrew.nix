# Homebrew の宣言的管理（brew bundle dump 2026-07-03 時点から生成）
# cleanup = "none" のため、リストにないパッケージが消されることはない
{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "none"; # 安定後に "zap" へ変更を検討
    };

    # casks で実際に参照している tap のみ宣言する
    taps = [
      "entireio/tap" # entire
      "nikitabobko/tap" # aerospace
    ];

    # CLI ツールは段階的に home/default.nix の home.packages（nixpkgs）へ移行する。
    # 残しているものの理由:
    # - awscli は mise（config/mise/config.toml）で管理
    # - node: ccusage（brew formula）の依存 + グローバル npm 用
    # - coreutils / grep: brew は g-prefix で共存、nixpkgs は無印で BSD コマンドを隠すため
    # - herdr / rtk / worktrunk / chrome-cli: nixpkgs 未収載（tap・独自 formula）
    # - glib / pango / vips / ffmpeg / graphviz: ライブラリ・重量級のため当面 brew
    brews = [
      "bash-completion@2"
      "glib"
      "node"
      "ccusage"
      "certbot"
      "chrome-cli"
      "clang-format"
      "coreutils"
      "ffmpeg"
      "pango"
      "graphviz"
      "grep"
      "herdr"
      "mise"
      "pipx"
      "python@3.12"
      "rtk"
      "vips"
      "worktrunk"
    ];

    casks = [
      "nikitabobko/tap/aerospace"
      "claude-code@latest"
      "codex"
      "docker-desktop"
      "entireio/tap/entire"
      # フォントは設定が実際に参照するもののみ宣言する（alacritty.toml: Hack Nerd Font）。
      # cleanup = "none" のためインストール済みの他フォントは消えない。
      # 不要分は `brew uninstall --cask font-...-nerd-font` で手動削除する
      "font-hack-nerd-font"
      "gcloud-cli"
      "jordanbaird-ice"
      "sequel-ace"
    ];
  };
}
