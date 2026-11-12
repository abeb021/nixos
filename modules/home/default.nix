# User session. System packages stay in modules/core/program.nix.
#
# Tanjun: programs.tanjun in modules/home/tanjun.nix (flake input path:../Programming/Tanjun-shell).
# copy-settings.sh still creates the same symlinks once when migrating from Arch.
#
# Secrets (~/.ssh, ~/.gnupg, ~/.git-credentials, ~/.config/gh) are copied once
# from Arch and never committed here.
{ ... }:
{
  imports = [
    ./editors.nix
    ./gtk.nix
    ./firefox.nix
    ./zsh
    ./tanjun.nix
    ./fetch.nix
    ./zoom.nix
    ../../scripts/scripts.nix
  ];
}
