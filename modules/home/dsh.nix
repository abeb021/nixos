# DeepSeek Harness
{ inputs, pkgs, ... }:
{
  imports = [ inputs.dsh-nix.homeManagerModules.dsh ];

  programs.dsh = {
    enable = true;
    package = inputs.dsh-nix.packages.${pkgs.stdenv.hostPlatform.system}.dsh.overrideAttrs (old: {
      pnpmDeps = old.pnpmDeps.overrideAttrs (_: {
        outputHash = "sha256-jfwS/aAMqNNS4MY/+OX0DhqnHzuYLDF/qd6E+vq1P4c=";
      });
    });
  };
}
