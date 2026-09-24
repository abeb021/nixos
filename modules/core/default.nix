{ ... }:
{
  imports = [
    ./nixpkgs.nix
    ./bootloader.nix
    ./hardware.nix
    ./bluetooth.nix
    ./network.nix
    ./fonts.nix
    ./pipewire.nix
    ./security.nix
    ./program.nix
    ./system.nix
    ./user.nix
    ./wayland.nix
    ./virtualization.nix
  ];
}
