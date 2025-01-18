# SPDX-FileCopyrightText: 2022 The Standard Authors
#
# SPDX-License-Identifier: Unlicense
# SPDX-FileCopyrightText: 2025 Carson Henrich <carson03henrich@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

# Source 1: https://github.com/divnix/std/blob/e2b20a91d37989f85d6852ebf3f55b4b9dff3cfb/src/lib/cfg/mdbook.nix
# Source 2: https://github.com/divnix/std/blob/e2b20a91d37989f85d6852ebf3f55b4b9dff3cfb/src/data/configs/mdbook.nix
# Config Reference: https://rust-lang.github.io/mdBook/format/configuration/index.html
let
  inherit (inputs) nixpkgs;
  inherit (inputs.mdbook-paisano-preprocessor.app.package) mdbook-paisano-preprocessor;
  l = nixpkgs.lib // builtins;
in
{
  hook.mode = "copy"; # let CI pick it up outside of devshell
  packages = [
    mdbook-paisano-preprocessor
    nixpkgs.mdbook-mermaid
  ];

  output = "docs/book.toml";
  format = "toml";
  data = {
    book = {
      language = "en";
      multilingual = false;
      src = "src";
      title = "Documentation";
    };
    build = {
      build-dir = "build";
    };
    preprocessor.paisano-preprocessor = {
      before = [ "links" ];
      registry = ".#__std.init";
    };

  };
  hook.extra = d:
    let
      sentinel = "nixago-auto-created: mdbook-build-folder";
      file = ".gitignore";
      str = ''
        # ${sentinel}
        ${d.build.build-dir or "book"}/**
      '';
    in
    ''
      # Configure gitignore
      create() {
        echo -n "${str}" > "${file}"
      }
      append() {
        echo -en "\n${str}" >> "${file}"
      }
      if ! test -f "${file}"; then
        create
      elif ! grep -qF "${sentinel}" "${file}"; then
        append
      fi
    '';
  commands = [{ package = nixpkgs.mdbook; }];
}
