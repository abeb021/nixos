{ ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Unattended store maintenance. Without this the store only grows: it was
  # already 68 GiB across 164 generations on 2026-11-21.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "ru_RU.UTF-8/UTF-8"
  ];
  console.keyMap = "us";
  services.xserver.xkb = {
    layout = "us,ru";
    options = "caps:escape,grp:win_space_toggle";
  };

  system.stateVersion = "26.11";
}
