# Daily session is niri plus Tanjun (Quickshell); Hyprland stays available
# as a fallback. Tanjun itself stays the git checkout under ~/.local/share/tanjun.
# The old waybar / wofi / swaync rice in ~/.config is not this session.
{ pkgs, config, username, ... }:
{
  # SDDM greeter on X11; session is still Hyprland (Wayland). Wayland greeter often has no mouse cursor.
  services.xserver.enable = true;

  services.displayManager = {
    # Matches programs.tanjun.compositor = "niri" and the session in use.
    defaultSession = "niri";
    sddm = {
      enable = true;
      wayland.enable = false;
      extraPackages = with pkgs; [ bibata-cursors ];
      theme = "simplicity";
      settings = {
        General = {
          GreeterEnvironment =
            "XCURSOR_THEME=Bibata-Modern-Classic,XCURSOR_SIZE=24,XCURSOR_PATH=${pkgs.bibata-cursors}/share/icons";
        };
        Theme = {
          CursorTheme = "Bibata-Modern-Classic";
          CursorSize = 24;
        };
      };
    };
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.niri.enable = true;

  services.gvfs.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gnome
    ];
    config = {
      common.default = [ "gtk" ];
      hyprland = {
        default = [ "hyprland" "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
        "org.freedesktop.impl.portal.Request" = [ "hyprland" ];
      };
      niri = {
        default = [ "gnome" "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
      };
    };
  };


  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

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
    hypridle
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

    # niri spawns xwayland-satellite from PATH; without it X11 apps (Zoom and
    # friends) refuse to start and niri logs "disabling integration".
    xwayland-satellite
    # Tanjun's clipboard/Bluetooth scripts call notify-send.
    libnotify
  ];
}
