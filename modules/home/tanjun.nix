# Tanjun Quickshell (flake input github:abeb021/Tanjun-shell).
# Override programs.tanjun.checkout with a local clone path for live shell dev.
{ inputs, ... }:
{
  imports = [ inputs.tanjun.homeManagerModules.default ];

  programs.tanjun = {
    enable = true;
    compositor = "hyprland";
  # checkout = inputs.tanjun.outPath;
    checkout = "/home/abeb-nix/Programming/Tanjun-shell";
  };
}
