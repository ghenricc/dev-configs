# SPDX-FileCopyrightText: 2025 Carson Henrich <carson03henrich@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

{ inputs
, cell
,
}:
let
  inherit (inputs.std.lib.dev) mkNixago;
  inherit (inputs.cells.src) cfg;
in
{
  lefthook = mkNixago cfg.lefthook {
    # FIXME I didn't want to make a bypass here but need to because nil has issues with scopedImport https://github.com/oxalica/nil/issues/72 
    data.pre-commit.commands.nil.exclude = "^nix/src/cfg/.*\.nix";
  };

  conform = mkNixago cfg.conform;

  cog = mkNixago cfg.cog;

  editorconfig = mkNixago cfg.editorconfig;

  treefmt = mkNixago cfg.treefmt;

  githubsettings = mkNixago cfg.githubsettings {
    data.repository = {
      name = "dev-configs";
      inherit (import (inputs.self + /flake.nix)) description;
      homepage = "";
      topics = "nix nix-flakes devshells";
      private = false;
    };
  };
}
