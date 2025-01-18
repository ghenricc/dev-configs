# SPDX-FileCopyrightText: 2025 Carson Henrich <carson03henrich@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

# Config Reference: https://docs.cocogitto.io/reference/config.html
let
  inherit (inputs) nixpkgs;
  l = nixpkgs.lib // builtins;
in
{
  data = {
    tag_prefix = "v";
    branch_whitelist = [ "main" "release/**" ];
    changelog = {
      template = "remote";
    };
    commit_types = {
      feat = {
        changelog_title = "Features";
        omit_from_changelog = false;
        bump_patch = false;
        bump_minor = true;
      };
      fix = {
        changelog_title = "Bug Fixes";
        omit_from_changelog = false;
        bump_patch = true;
        bump_minor = false;
      };
      perf = {
        changelog_title = "Performance Improvements";
        omit_from_changelog = false;
        bump_patch = true;
        bump_minor = false;
      };
      refactor = {
        changelog_title = "Refactoring";
        omit_from_changelog = false;
        bump_patch = false;
        bump_minor = false;
      };
      test = {
        changelog_title = "Testing";
        omit_from_changelog = false;
        bump_patch = false;
        bump_minor = false;
      };
      build = {
        changelog_title = "Build System";
        omit_from_changelog = false;
        bump_patch = false;
        bump_minor = false;
      };
      ci = {
        changelog_title = "CI";
        omit_from_changelog = false;
        bump_patch = false;
        bump_minor = false;
      };
      docs = {
        changelog_title = "Documentation";
        omit_from_changelog = false;
        bump_patch = false;
        bump_minor = false;
      };
      chore = {
        changelog_title = "Housekeeping";
        omit_from_changelog = false;
        bump_patch = false;
        bump_minor = false;
      };
      style = {
        changelog_title = "Formatting";
        omit_from_changelog = false;
        bump_patch = false;
        bump_minor = false;
      };
    };
  };
  output = "cog.toml";
  commands = [
    {
      package = nixpkgs.cocogitto;
      name = "cog";
    }
  ];
}
