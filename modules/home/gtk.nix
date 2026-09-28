# Libadwaita (Nautilus, etc.) on Hyprland: dark scheme, icons, XDG folders.
{ pkgs, ... }:
{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Papirus-Dark";
      cursor-theme = "Bibata-Modern-Classic";
      cursor-size = 24;
    };
  };

  gtk = {
    enable = true;
    gtk3.enable = true;
    gtk4.enable = true;
    gtk4.theme = null;

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
  };

  home.sessionVariables = {
    ADW_DISABLE_PORTAL = "1";
    GTK_THEME = "Adwaita-dark";
  };

  xdg.userDirs = {
    enable = true;
    setSessionVariables = true;
  };
}
