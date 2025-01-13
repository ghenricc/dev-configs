# SPDX-FileCopyrightText: 2022 The Standard Authors
#
# SPDX-License-Identifier: Unlicense
# SPDX-FileCopyrightText: 2025 Carson Henrich <carson03henrich@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

# Source 1: https://github.com/divnix/std/blob/e2b20a91d37989f85d6852ebf3f55b4b9dff3cfb/src/lib/cfg/editorconfig.nix
# Source 2: https://github.com/divnix/std/blob/e2b20a91d37989f85d6852ebf3f55b4b9dff3cfb/src/data/configs/editorconfig.nix

# Tool Homepage: https://editorconfig.org/
let
  inherit (inputs) nixpkgs;
  l = nixpkgs.lib // builtins;
in
{
  hook.mode = "copy"; # already useful before entering the devshell
  data = {
    root = true;

    "*" = {
      end_of_line = "lf";
      insert_final_newline = true;
      trim_trailing_whitespace = true;
      charset = "utf-8";
      indent_style = "space";
      indent_size = 2;
    };

    "*.{diff,patch}" = {
      end_of_line = "unset";
      insert_final_newline = "unset";
      trim_trailing_whitespace = "unset";
      indent_size = "unset";
    };

    "*.md" = {
      max_line_length = "off";
      trim_trailing_whitespace = false;
    };
    "{LICENSES/**,LICENSE}" = {
      end_of_line = "unset";
      insert_final_newline = "unset";
      trim_trailing_whitespace = "unset";
      charset = "unset";
      indent_style = "unset";
      indent_size = "unset";
    };
  };
  output = ".editorconfig";
  engine = request:
    let
      inherit (request) data output;
      name = l.baseNameOf output;
      value = {
        globalSection = { root = data.root or true; };
        sections = l.removeAttrs data [ "root" ];
      };
    in
    nixpkgs.writeText name (l.generators.toINIWithGlobalSection { } value);
  packages = [ nixpkgs.editorconfig-checker ];
}
