# SPDX-FileCopyrightText: 2022 The Standard Authors
#
# SPDX-License-Identifier: Unlicense
# SPDX-FileCopyrightText: 2025 Carson Henrich <carson03henrich@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

# Source 1: https://github.com/divnix/std/blob/e2b20a91d37989f85d6852ebf3f55b4b9dff3cfb/src/lib/cfg/conform.nix
# Source 2: https://github.com/divnix/std/blob/e2b20a91d37989f85d6852ebf3f55b4b9dff3cfb/src/data/configs/conform.nix
# Config Reference: https://github.com/siderolabs/conform?tab=readme-ov-file
let
  l = nixpkgs.lib // builtins;
  inherit (inputs) nixpkgs;
in
{
  data = {
    commit = {
      body.required = false;
      spellcheck.locale = "US";
      header = {
        length = 89;
        case = "lower";
        imperative = true;
        invalidLastCharacters = ".";
      };
      maximumOfOneCommit = true;
      conventional = {
        types = [
          "build"
          "chore"
          "ci"
          "docs"
          "feat"
          "fix"
          "perf"
          "refactor"
          "style"
          "test"
        ];
        scopes = [
          "version" # Used by cocogitto for version bumps
        ];
      };
    };
  };
  format = "yaml";
  output = ".conform.yaml";
  packages = [ nixpkgs.conform ];
  apply = d: {
    policies =
      [ ]
      ++ (l.optional (d ? commit) {
        type = "commit";
        spec =
          d.commit
          // l.optionalAttrs (d ? cells) {
            conventional =
              d.commit.conventional
              // {
                scopes =
                  d.commit.conventional.scopes
                  ++ (l.subtractLists l.systems.doubles.all (l.attrNames d.cells));
              };
          };
      })
      ++ (l.optional (d ? license) {
        type = "license";
        spec = d.license;
      });
  };
}
