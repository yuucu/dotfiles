{ pkgs, ... }:
{
  imports = [ ./links.nix ];

  home.username = "s09104";
  home.homeDirectory = "/Users/s09104";

  # brew formula から段階的にここへ移行する（docs/design.md Phase 4）。
  # 移行したら darwin/homebrew.nix の brews から外し、brew uninstall する。
  home.packages = with pkgs; [
    age
    bat
    eza
    fd
    fzf
    gh
    ghq
    lazygit
    lefthook
    ripgrep
    shellcheck
    starship
    stylua
    tree
    zoxide
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
