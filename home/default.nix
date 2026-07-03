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
      protobuf
      ripgrep
      shellcheck
      starship
      stylua
      tmux
      tree
      zoxide
    ];
  };

  programs.home-manager.enable = true;
}
