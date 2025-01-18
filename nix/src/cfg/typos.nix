# SPDX-FileCopyrightText: 2025 Carson Henrich <carson03henrich@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

# Config Reference: https://github.com/crate-ci/typos/blob/master/docs/reference.md
let
  inherit (inputs) nixpkgs;
  l = nixpkgs.lib // builtins;
in
{
  data = {
    default = {
      locale = "en-us";
      extend-ignore-re = [
        # Disable spellcheck on a line with `# spellchecker:disable-line`:
        "(?Rm)^.*(#|//)\\s*spellchecker:disable-line$"
        # Line block with `# spellchecker:<on|off>`:
        "(?s)(#|//)\\s*spellchecker:off.*?\\n\\s*(#|//)\\s*spellchecker:on"
      ];
    };
  };
  output = "typos.toml";
  commands = [
    {
      package = nixpkgs.typos;
      name = "typos";
    }
  ];
}
