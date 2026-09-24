# User session. System packages stay in modules/core/program.nix.
#
# Tanjun (Quickshell) stays a git checkout under ~/.local/share/tanjun with
# ~/.config/quickshell → shell/ — same as docs/install.md. Do not fold the
# shell tree into Home Manager; scripts/scripts/copy-settings.sh owns those links.
#
# Secrets (~/.ssh, ~/.gnupg, ~/.git-credentials, ~/.config/gh) are copied once
# from Arch and never committed here.
{ ... }:
{
  imports = [
    ./editors.nix
    ./gtk.nix
    ./zen.nix
    ./zsh
    ../../scripts/scripts.nix
  ];
}
