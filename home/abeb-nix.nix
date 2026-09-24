# User session config. System packages stay in modules/packages.nix.
#
# Tanjun (Quickshell) stays a git checkout under ~/.local/share/tanjun with
# ~/.config/quickshell → shell/ — same as docs/install.md. Do not fold the
# shell tree into Home Manager; copy-settings.sh + setup.sh own those links.
#
# Secrets (~/.ssh, ~/.gnupg, ~/.git-credentials, ~/.config/gh) are copied once
# from Arch and never committed here.
{ config, pkgs, lib, inputs, ... }:
{
  home.username = "abeb-nix";
  home.homeDirectory = "/home/abeb-nix";
  home.stateVersion = "26.05";

  imports = [
    ./editors.nix
    ./gtk.nix
    ./zen.nix
  ];

  programs.home-manager.enable = true;
}
