# SPDX-FileCopyrightText: 2022 The Standard Authors
#
# SPDX-License-Identifier: Unlicense
# SPDX-FileCopyrightText: 2025 Carson Henrich <carson03henrich@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

# Source 1: https://github.com/divnix/std/blob/e2b20a91d37989f85d6852ebf3f55b4b9dff3cfb/src/lib/cfg/lefthook.nix
# Source 2: https://github.com/divnix/std/blob/e2b20a91d37989f85d6852ebf3f55b4b9dff3cfb/src/data/configs/lefthook.nix
let
  inherit (inputs) nixpkgs;
  l = nixpkgs.lib // builtins;
  mkScript = stage:
    nixpkgs.writeScript "lefthook-${stage}" ''
      #!${nixpkgs.runtimeShell}
      [ "$LEFTHOOK" == "0" ] || ${l.getExe nixpkgs.lefthook} run "${stage}" "$@"
    '';

  toStagesConfig = config:
    l.removeAttrs config [
      "colors"
      "extends"
      "skip_output"
      "source_dir"
      "source_dir_local"
    ];
in
{
  output = "lefthook.yml";
  packages = with nixpkgs; [
    lefthook
    gnugrep
    reuse
    conform
    treefmt
    typos
    flake-checker
    nil
  ];
  format = "yaml";
  data = {
    pre-push = {
      commands = {
        conform = {
          run = ''
            ${l.getExe nixpkgs.conform} enforce
          '';
          skip = [ "merge" "rebase" ];
        };
      };
    };
    commit-msg = {
      commands = {
        conform = {
          # allow "WIP:", "wip:", "fixup!", and "squash!" commits locally
          run = ''
            [[ "$(head -n 1 {1})" =~ ^WIP(:.*)?$|^wip(:.*)?$|fixup\!.*|squash\!.* ]] ||
            ${l.getExe nixpkgs.conform} enforce --commit-msg-file {1}
          '';
          skip = [ "merge" "rebase" ];
        };
      };
    };
    pre-commit = {
      commands = {
        treefmt = {
          run = "${l.getExe nixpkgs.treefmt} --fail-on-change {staged_files}";
          skip = [ "merge" "rebase" ];
        };
        reuse = {
          run = "${l.getExe nixpkgs.reuse} lint";
          skip = [ "merge" "rebase" ];
        };
        typos = {
          run = "${l.getExe nixpkgs.typos} --locale 'en-us' --no-unicode {staged_files}";
          skip = [ "merge" "rebase" ];
        };
        # TODO Cause warnings to error, once merged https://github.com/oxalica/nil/pull/157
        # TODO Get rid of for loop, once merged https://github.com/oxalica/nil/pull/126
        nil = {
          run = ''
            EXIT=0
            for i in {staged_files}; do
                if ! ${l.getExe nixpkgs.nil} diagnostics $i && test -z $BYPASS_NIL; then
                   EXIT=1
                fi
            done
            if test 1 -eq $EXIT; then
                echo -e "\033[31;1;4mSet BYPASS_NIL to non-null to bypass a failed check\033[0m"
            fi
            exit $EXIT
          '';
          glob = "*.nix";
          skip = [ "merge" "rebase" ];
        };
        flake-checker = {
          run = "${l.getExe nixpkgs.flake-checker}";
          skip = [ "merge" "rebase" ];
        };
        std = {
          run = "${l.getExe inputs.std.packages.std} check";
          skip = [ "merge" "rebase" ];
        };
      };
    };
  };
  # Add an extra hook for adding required stages whenever the file changes
  hook.extra = config:
    l.pipe config [
      toStagesConfig
      l.attrNames
      (l.map (stage: ''ln -sf "${mkScript stage}" ".git/hooks/${stage}"''))
      (stages:
        l.optional (stages != [ ]) "mkdir -p .git/hooks"
        ++ stages)
      (l.concatStringsSep "\n")
    ];
}
