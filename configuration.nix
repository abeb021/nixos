# NixOS replacement for the Arch install.
# User files stay on the home partition. This file only declares the system.
{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./modules/system.nix
    ./modules/desktop.nix
    ./modules/user.nix
    ./modules/packages.nix
  ];

  system.stateVersion = "26.11";
}
