# 3d fastfetch
{ inputs, ... }:
{
  imports = [ inputs.fetch.homeManagerModules.default ];

  programs.fetch.enable = true;
}