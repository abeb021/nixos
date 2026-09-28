# This machine only. Shared system config lives in modules/core.
{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
  ];

  # Intel laptop: SOF audio firmware and hardware video decode.
  hardware.firmware = [ pkgs.sof-firmware ];
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    vpl-gpu-rt
  ];

  services.upower.enable = true;

   zramSwap.enable = true;
}
