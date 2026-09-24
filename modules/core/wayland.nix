# Live session is Hyprland plus Tanjun (Quickshell).
# Tanjun itself stays the git checkout under ~/.local/share/tanjun.
# The old waybar / wofi / swaync rice in ~/.config is not this session.
{ pkgs, config, username, ... }:
{
  services.displayManager = {
    defaultSession = "hyprland";
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "simplicity";
      settings = {
        Theme = {
          CursorTheme = "Bibata-Modern-Classic";
          CursorSize = 24;
        };
      };
    };
  };

  programs.hyprland.enable = true;
  programs.niri.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    config = {
      common.default = [
        "hyprland"
        "gtk"
      ];
      hyprland.default = [
        "hyprland"
        "gtk"
      ];
      hyprland."org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
      hyprland."org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
    # Must be a list — xdg/icons.nix also defines this option as a list.
    XCURSOR_PATH = [ "${pkgs.bibata-cursors}/share/icons" ];
    HYPRCURSOR_THEME = "rose-pine-hyprcursor";
    HYPRCURSOR_SIZE = "24";
  };
  environment.pathsToLink = [ "/share/icons" ];

  # Hyprland only searches ~/.local/share/icons for hyprcursor themes.
  system.activationScripts.hyprcursorIcons =
    let
      user = config.users.users.${username};
      home = user.home;
    in
    ''
      install -d -o ${toString user.uid} -g ${toString user.group} ${home}/.local/share/icons
      ln -sfn ${pkgs.rose-pine-hyprcursor}/share/icons/rose-pine-hyprcursor \
        ${home}/.local/share/icons/rose-pine-hyprcursor
    '';

  environment.systemPackages = with pkgs; [
    bibata-cursors
    simplicity-sddm-theme
    rose-pine-hyprcursor
    libsecret
    seahorse
    quickshell
    kitty
    yazi
    hyprpaper
    hyprsunset
    hyprshot
    mpvpaper
    cliphist
    wl-clipboard
    brightnessctl
    playerctl
    libqalculate
    grim
    slurp
    ffmpeg
    mpv
    libinput-gestures
    polkit_gnome
  ];

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
