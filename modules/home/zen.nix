# Release-channel Zen (flake attribute "beta" = normal release builds, not Twilight).
{ inputs, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser.enable = true;
}
