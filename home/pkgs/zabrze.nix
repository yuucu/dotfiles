# zabrze: zsh の abbreviation 展開（nixpkgs 未収載のため自前でビルドする）
# 更新手順: version / rev を新しい tag に書き換え、hash・cargoHash を lib.fakeHash にして
#   `nix build .#darwinConfigurations.<host>.system --dry-run` 等で出る正しい hash に置き換える
{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "zabrze";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "Ryooooooga";
    repo = "zabrze";
    rev = "v${version}";
    hash = "sha256-OmwU7/SQqEAzZo7/Eix3yc+VLEU6+/NIiALvpU3PlKA=";
  };

  cargoHash = "sha256-9UZSOXTWvX9jPE0crGb/hUpemuVhEGgyzs+HL3QwIgg=";

  # テストが起動する zsh がホストの /etc/zshenv（nix-darwin が EDITOR を設定）を読み、
  # EDITOR=vim の期待値とずれて落ちるため、環境依存の 2 件だけ除外する
  checkFlags = [
    "--skip=test_evaluate"
    "--skip=test_legacy_yaml"
  ];

  meta = {
    description = "ZSH abbreviation expansion plugin";
    homepage = "https://github.com/Ryooooooga/zabrze";
    license = lib.licenses.mit;
    mainProgram = "zabrze";
  };
}
