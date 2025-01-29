# SPDX-FileCopyrightText: 2025 Carson Henrich <carson03henrich@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

{ inputs
, cell
,
}:
let
  inherit (inputs.std) dmerge;
  inherit (inputs.std.lib.dev) mkNixago;
  inherit (inputs.cells.src) cfg;
  repository = "dev-configs";
in
{

  # Base Config: ../src/cfg/cog.nix 
  # Config Reference: https://docs.cocogitto.io/reference/config.html
  cog = mkNixago cfg.cog {
    data.changelog = {
      inherit repository;
      remote = "github.com";
      owner = "ghenricc";
      authors = [
        {
          signature = "Carson Henrich";
          username = "ghenricc";
        }
      ];
    };
  };

  # Base Config: ../src/cfg/conform.nix 
  # Config Reference: https://github.com/siderolabs/conform?tab=readme-ov-file
  conform = mkNixago cfg.conform {
    data = {
      inherit (inputs) cells;
      commit.conventional.scopes = dmerge.append [
        "cog"
        "conform"
        "editorconfig"
        "githubsettings"
        "lefthook"
        "mdbook"
        "treefmt"
        "typos"
      ];
    };
  };

  # Base Config: ../src/cfg/editorconfig.nix 
  # Config Reference: https://spec.editorconfig.org/
  editorconfig = mkNixago cfg.editorconfig;

  # Base Config: ../src/cfg/githubsettings.nix 
  # Config Reference: https://github.com/github/safe-settings/blob/main-enterprise/docs/sample-settings/settings.yml
  githubsettings = mkNixago cfg.githubsettings {
    data.repository = {
      name = repository;
      inherit (import (inputs.self + /flake.nix)) description;
      homepage = "";
      topics = "nix nix-flakes devshells";
      private = false;
    };
  };

  # Base Config: ../src/cfg/lefthook.nix 
  # Config Reference: https://evilmartians.github.io/lefthook/configuration/index.html
  lefthook = mkNixago cfg.lefthook {
    # FIXME I didn't want to make a bypass here but need to because nil has issues with scopedImport https://github.com/oxalica/nil/issues/72 
    data.pre-commit.commands.nil.exclude = "^nix/src/cfg/.*\.nix";
  };

  # Base Config: ../src/cfg/treefmt.nix 
  # Config Reference: https://treefmt.com/latest/getting-started/configure/#ci 
  treefmt = mkNixago cfg.treefmt;

  # Base Config: ../src/cfg/typos.nix 
  # Config Reference: https://github.com/crate-ci/typos/blob/master/docs/reference.md
  typos = mkNixago cfg.typos;
}
