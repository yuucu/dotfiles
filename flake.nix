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
          actionlint
          deadnix
          nixfmt
          shellcheck
          statix
          stylua
          taplo
          yamllint
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
          shellcheck scripts/*.sh
          stylua --check config/nvim/
          nixfmt --check flake.nix darwin/*.nix home/*.nix
          statix check .
          deadnix --fail .
          # GitHub Actions ワークフロー（sandbox 内は git repo でないためファイルを明示）
          actionlint .github/workflows/*.yml
          # YAML lint（追跡中の .yml を find で走査。設定は .yamllint.yml）
          find . -type f -name '*.yml' -print0 | xargs -0 yamllint -c .yamllint.yml
          # TOML lint（構文チェックのみ。sandbox 内でネットワークに出ないようスキーマ検証はオフ）
          find . -type f -name '*.toml' -print0 | xargs -0 taplo lint --no-schema
          touch $out
        '';
      });
    };
}
