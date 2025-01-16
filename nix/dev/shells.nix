# SPDX-FileCopyrightText: 2025 Carson Henrich <carson03henrich@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

/*
  This file holds reproducible shells with commands in them.

  They conveniently also generate config files in their startup hook.
*/
{ inputs
, cell
,
}:
let
  inherit (inputs.std) std;
  inherit (inputs) nixpkgs;
  lib = nixpkgs.lib // inputs.std.lib;
  pairToAttrs = name: value: value // { inherit name; };
in
builtins.mapAttrs (_: lib.dev.mkShell) {
  # Tool Homepage: https://numtide.github.io/devshell/
  default = {
    name = "default-devshell";

    imports = [
      std.devshellProfiles.default
    ];

    # Tool Homepage: https://nix-community.github.io/nixago/
    # This is Standard's devshell integration.
    # It runs the startup hook when entering the shell.
    nixago = [
      cell.configs.conform
      cell.configs.cog
      cell.configs.editorconfig
      cell.configs.githubsettings
      cell.configs.lefthook
      cell.configs.typos
      cell.configs.treefmt
    ];

    env = lib.mapAttrsToList pairToAttrs {
      nix_config.value = "extra-experimental-features = nix-command flakes";
    };

    packages = with nixpkgs; [
      nix-tree
    ];

    commands = lib.mapAttrsToList pairToAttrs {
      checks = {
        category = "checks";
        help = "Runs all defined pre-commit checks for this repository";
        command = ''
          lefthook run pre-commit
          conform enforce
          nix flake check
        '';
      };
      reuse = {
        category = "checks";
        help = "Make licensing easy for humans and machines alike.";
        package = nixpkgs.reuse;
      };
      conform = {
        category = "checks";
        help = "Policy enforcement for your pipelines.";
        package = nixpkgs.conform;
      };
      nil = {
        category = "checks";
        help = "Nix Language server, an incremental analysis assistant for writing in Nix.";
        package = nixpkgs.nil;
      };
    };
  };
}
