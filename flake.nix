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
      # x86_64-linux は Phase 4 の Linux（home-manager 単体）対応を見据えた先行出力
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs [
          "aarch64-darwin"
          "x86_64-linux"
        ] (system: f nixpkgs.legacyPackages.${system});
      lintTools =
        pkgs: with pkgs; [
          deadnix
          nixfmt
          shellcheck
          statix
          stylua
        ];
    in
    {
      darwinConfigurations."yuucu-mac" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit username; };
        modules = [
          ./darwin
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-backup";
              extraSpecialArgs = { inherit username; };
              users.${username} = import ./home;
            };
          }
        ];
      };

      # `nix fmt` で .nix ファイルを一括整形する
      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);

      # lint ツールは flake.lock で固定し、CI・ローカルで同一バージョンを使う
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell { packages = lintTools pkgs ++ [ pkgs.gitleaks ]; };
      });

      # `nix flake check` の実体。shell / lua / nix をまとめて lint する。
      # 対象は git 追跡ファイルのみ（flake source のコピー範囲）。
      # 未追跡ファイルは pre-commit の lint-staged が拾う。
      checks = forAllSystems (pkgs: {
        lint = pkgs.runCommand "dotfiles-lint" { nativeBuildInputs = lintTools pkgs; } ''
          cd ${self}
          # git 追跡ファイルのみ flake source にコピーされるため、
          # find による全走査は git ls-files 相当（runCommand 内に git は無い）。
          find . -type f -name '*.sh' -exec shellcheck {} +
          stylua --check config/nvim/
          find . -type f -name '*.nix' -exec nixfmt --check {} +
          statix check .
          deadnix --fail .
          touch $out
        '';
      });
    };
}
