# SPDX-FileCopyrightText: 2022 The Standard Authors
#
# SPDX-License-Identifier: Unlicense
# SPDX-FileCopyrightText: 2025 Carson Henrich <carson03henrich@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

# Source 1: https://github.com/divnix/std/blob/e2b20a91d37989f85d6852ebf3f55b4b9dff3cfb/src/lib/cfg/cog.nix
# Source 2: https://github.com/divnix/std/blob/e2b20a91d37989f85d6852ebf3f55b4b9dff3cfb/src/data/configs/cog.nix
let
  inherit (inputs) nixpkgs;
  l = nixpkgs.lib // builtins;
in
{
  data = { };
  output = "cog.toml";
  commands = [
    {
      package = nixpkgs.cocogitto;
      name = "cog";
    }
  ];
}
