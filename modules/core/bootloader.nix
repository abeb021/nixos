{ ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # The ESP is only 1 GiB; cap entries so old kernels cannot fill it up.
  boot.loader.systemd-boot.configurationLimit = 10;
}
