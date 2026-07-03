{ ... }:
{
  imports = [ ./links.nix ];

  home.username = "s09104";
  home.homeDirectory = "/Users/s09104";

  # CLI パッケージは当面 Homebrew（darwin/homebrew.nix）のまま。
  # Phase 4 で brew formula から段階的にここへ移す。
  home.packages = [ ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
