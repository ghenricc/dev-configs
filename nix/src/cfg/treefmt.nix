# SPDX-FileCopyrightText: 2022 The Standard Authors
#
# SPDX-License-Identifier: Unlicense
# SPDX-FileCopyrightText: 2025 Carson Henrich <carson03henrich@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

# Source 1: https://github.com/divnix/std/blob/e2b20a91d37989f85d6852ebf3f55b4b9dff3cfb/src/lib/cfg/treefmt.nix
# Source 2: https://github.com/divnix/std/blob/e2b20a91d37989f85d6852ebf3f55b4b9dff3cfb/src/data/configs/treefmt.nix
# Config Reference: https://treefmt.com/latest/getting-started/configure/#ci 

let
  inherit (inputs) nixpkgs;
  l = nixpkgs.lib // builtins;
in
{
  output = "treefmt.toml";
  format = "toml";
  commands = [{ package = nixpkgs.treefmt; }];
  packages = [
    nixpkgs.nixpkgs-fmt
    nixpkgs.nodePackages.prettier
    nixpkgs.nodePackages.prettier-plugin-toml
    nixpkgs.shfmt
  ];

  data = {
    excludes = [
      "cog.toml"
      "lefthook.yml"
      "treefmt.toml"
      "typos.toml"
      "docs/book.toml"
      ".conform.yaml"
      ".gitignore"
      ".envrc"
      ".editorconfig"
      ".github/settings.yml"
      "LICENSES/**"
      ".bin/**"
      ".cache/**"
      ".config/**"
      ".data/**"
      ".git/**"
      ".github/**"
      ".run/**"
      "*.license"
      "*.lock"
    ];
    formatter = {
      nix = {
        command = l.getExe nixpkgs.nixpkgs-fmt;
        includes = [ "*.nix" ];
      };
      prettier = {
        command = l.getExe nixpkgs.nodePackages.prettier;
        options = [ "--write" ];
        includes = [
          "*.css"
          "*.html"
          "*.js"
          "*.json"
          "*.jsx"
          "*.md"
          "*.mdx"
          "*.scss"
          "*.ts"
          "*.yaml"
          "*.yml"
        ];
      };
      shell = {
        command = l.getExe nixpkgs.shfmt;
        options = [ "-i" "2" "-s" "-w" ];
        includes = [ "*.sh" ];
      };
    };
  };
}
