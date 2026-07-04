# 既存の設定ファイルを Nix store に取り込まず、repo を直接 symlink する。
# 編集は即反映（rebuild 不要）。repo の絶対パス（dotfilesDir）に依存する。
# worktree での検証は `make check`（評価のみ）で行い、switch は main checkout から実行する。
{ config, ... }:
let
  dotfilesDir = "${config.home.homeDirectory}/ghq/github.com/yuucu/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/${path}";
in
{
  xdg.configFile = {
    "nvim".source = link "config/nvim";
    "tmux".source = link "config/tmux";
    "ccstatusline".source = link "config/ccstatusline";
    "starship.toml".source = link "config/starship.toml";
    "alacritty.toml".source = link "config/alacritty.toml";
    "mise/config.toml".source = link "config/mise/config.toml";
    # state を同居させるツールは設定ファイル単位で link する
    # （lazygit: state.yml / worktrunk: approvals.toml / gh: hosts.yml /
    #   herdr: session.json・session-history.json は管理外）
    "herdr/config.toml".source = link "config/herdr/config.toml";
    "lazygit/config.yml".source = link "config/lazygit/config.yml";
    "git/ignore".source = link "config/git/ignore";
    "worktrunk/config.toml".source = link "config/worktrunk/config.toml";
    "gwq/config.toml".source = link "config/gwq/config.toml";
    "gh/config.yml".source = link "config/gh/config.yml";
  };

  home.file = {
    ".zshenv".source = link "config/zsh/zshenv";
    ".zshrc".source = link "config/zsh/zshrc";
    ".ideavimrc".source = link "config/ideavim/ideavimrc";
    ".claude/CLAUDE.md".source = link "config/claude/CLAUDE.md";
    ".claude/hooks/herdr-agent-state.sh".source = link "config/claude/hooks/herdr-agent-state.sh";
    # 権限設定・deny パターンは攻撃者への設計図になるため local/（git 管理外）に置く
    ".claude/settings.json".source = link "local/claude/settings.json";
    ".claude/scripts/deny-check.sh".source = link "local/claude/deny-check.sh";
    ".claude/agents".source = link "config/claude/agents";
    # skills/ は work repo への symlink 等が同居するため、汎用 skill だけ個別に link
    ".claude/skills/ask-codex".source = link "config/claude/skills/ask-codex";
    ".claude/skills/herdr".source = link "config/claude/skills/herdr";
    ".claude/skills/skill-creator".source = link "config/claude/skills/skill-creator";
    # config.toml は Codex が動的更新する state（work パス含む）のため管理しない
    # rules/default.rules も承認履歴の state（work 情報含む）のため管理しない
    ".codex/AGENTS.md".source = link "config/codex/AGENTS.md";
    ".codex/hooks.json".source = link "config/codex/hooks.json";
    ".codex/herdr-agent-state.sh".source = link "config/codex/herdr-agent-state.sh";
    ".codex/scripts/notify.sh".source = link "config/codex/scripts/notify.sh";
    ".codex/rules/commands.rules".source = link "local/codex/commands.rules";
    ".codex/keybindings.json".source = link "config/codex/keybindings.json";

    # work の identity・社内 URL を含むため local/（git 管理外）に実体を置く
    ".gitconfig".source = link "local/gitconfig";
    ".gitconfig.local".source = link "local/gitconfig.local";
    ".gitconfig-personal".source = link "local/gitconfig-personal";
    ".zshrc.local".source = link "local/zshrc.local";
  };
}
