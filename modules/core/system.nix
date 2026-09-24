{ ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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
