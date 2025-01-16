# SPDX-FileCopyrightText: 2025 Carson Henrich <carson03henrich@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

let
  inherit (inputs) nixpkgs;
  l = nixpkgs.lib // builtins;
in
{
  data = { };
  output = "typos.toml";
  commands = [
    {
      package = nixpkgs.typos;
      name = "typos";
    }
  ];
}
