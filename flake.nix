{
  description = "yuucu dotfiles (nix-darwin + home-manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
    }:
    let
      username = "s09104";
      # mkOutOfStoreSymlink の実体参照先。worktree で検証する場合は一時的に書き換える
      dotfilesDir = "/Users/${username}/ghq/github.com/yuucu/dotfiles";
    in
    {
      darwinConfigurations."yuucu-mac" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit username dotfilesDir; };
        modules = [
          ./darwin
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-backup";
              extraSpecialArgs = { inherit dotfilesDir; };
              users.${username} = import ./home;
            };
          }
        ];
      };
    };
}
