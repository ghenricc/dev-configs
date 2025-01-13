# SPDX-FileCopyrightText: 2025 Carson Henrich <carson03henrich@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  description = "Base Configs for my Nix Devshells";

  inputs = {
    nixpkgs-unstable.url = "github:NixOs/nixpkgs/nixos-unstable";
    nixpkgs.follows = "nixpkgs-unstable";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixago = {
      url = "github:nix-community/nixago";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    std = {
      url = "github:divnix/std";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        devshell.follows = "devshell";
        nixago.follows = "nixago";
      };
    };
  };

  nixConfig = {
    extra-experimental-features = [ "nix-command" "flakes" ];
    extra-substituters = [
      "https://carsonhenrich.cachix.org"
      "https://nix-community.cachix.org"
    ];
  };

  outputs =
    inputs @ { self
    , std
    , ...
    }: std.growOn
      {
        inherit inputs;
        cellsFrom = std.incl ./nix [ "src" "dev" ];
        cellBlocks = with std.blockTypes; [
          # src: Things for downstream usage
          (functions "cfg")
          # dev: Dev Environment
          (nixago "configs")
          (devshells "shells" { ci.build = true; })
        ];
      }
      {
        devShells = std.harvest self [ "dev" "shells" ];
      };
}
