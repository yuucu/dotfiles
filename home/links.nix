# 既存の設定ファイルを Nix store に取り込まず、repo を直接 symlink する。
# 編集は即反映（rebuild 不要）。repo の絶対パス（dotfilesDir）に依存する。
{ config, dotfilesDir, ... }:
let
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/${path}";
in
{
  xdg.configFile = {
    "nvim".source = link "config/nvim";
    "tmux".source = link "config/tmux";
    "herdr".source = link "config/herdr";
    "ccstatusline".source = link "config/ccstatusline";
    "starship.toml".source = link "config/starship.toml";
    "alacritty.toml".source = link "config/alacritty.toml";
    "mise/config.toml".source = link "config/mise/config.toml";
  };

  home.file = {
    ".zshenv".source = link "config/zsh/zshenv";
    ".zshrc".source = link "config/zsh/zshrc";
    ".ideavimrc".source = link "config/ideavim/ideavimrc";
    ".claude/CLAUDE.md".source = link "config/claude/CLAUDE.md";
    ".claude/scripts/deny-check.sh".source = link "config/claude/scripts/deny-check.sh";

    # work の identity・社内 URL を含むため local/（git 管理外）に実体を置く
    ".gitconfig".source = link "local/gitconfig";
    ".gitconfig.local".source = link "local/gitconfig.local";
    ".gitconfig-personal".source = link "local/gitconfig-personal";
    ".zshrc.local".source = link "local/zshrc.local";
  };
}
