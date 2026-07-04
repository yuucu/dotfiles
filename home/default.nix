{ pkgs, username, ... }:
{
  imports = [ ./links.nix ];

  home = {
    inherit username;
    homeDirectory = "/Users/${username}";
    stateVersion = "25.05";

    # brew formula から段階的にここへ移行する（docs/design.md Phase 4）。
    # 移行したら darwin/homebrew.nix の brews から外し、brew uninstall する。
    packages = with pkgs; [
      age
      bat
      cmake
      deno
      eza
      fd
      fzf
      gh
      ghq
      git-lfs
      gitleaks
      go
      go-migrate
      gopls
      jujutsu
      lazygit
      lefthook
      lua-language-server
      mkcert
      neovim
      ninja
      pandoc
      pnpm
      prisma-language-server
      protobuf
      ripgrep
      shellcheck
      starship
      stylua
      terraform-ls
      tmux
      tree
      # nvim-treesitter (main branch) の parser ビルドに必要な CLI
      tree-sitter
      # nvim の LSP サーバー（jsonls / eslint は vscode-langservers-extracted）
      vscode-langservers-extracted
      yaml-language-server
      zoxide
    ];
  };

  programs.home-manager.enable = true;
}
