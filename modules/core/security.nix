{ ... }:
{
  # niri also turns the keyring on; keep it explicit for Hyprland/SDDM secrets.
  services.gnome.gnome-keyring.enable = true;
  # GNOME's SSH agent turns on with the desktop modules. Only one agent is allowed.
  services.gnome.gcr-ssh-agent.enable = false;

  security.rtkit.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;
}
