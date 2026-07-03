{ username, ... }:
{
  imports = [ ./homebrew.nix ];

  # Determinate Systems installer が Nix デーモンを管理するため、
  # nix-darwin 側の Nix 管理は無効化する
  nix.enable = false;

  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.${username}.home = "/Users/${username}";
  system.primaryUser = username;

  # sudo を Touch ID で
  security.pam.services.sudo_local.touchIdAuth = true;

  # macOS システム設定はここに追加していく（例）
  # system.defaults = {
  #   dock.autohide = true;
  #   NSGlobalDomain.KeyRepeat = 2;
  # };

  programs.zsh.enable = true;

  system.stateVersion = 6;
}
