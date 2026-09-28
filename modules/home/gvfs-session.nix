# Hyprland/SDDM does not always import GIO_EXTRA_MODULES or start gvfsd.
# Without that, Nautilus cannot use trash:// ("trash locations are not supported").
{ pkgs, lib, ... }:
let
  gioModules = lib.concatStringsSep ":" [
    "${pkgs.gvfs}/lib/gio/modules"
    "${pkgs.dconf}/lib/gio/modules"
  ];

  startGvfs = pkgs.writeShellScript "start-gvfs-session" ''
    set -eu
    export GIO_EXTRA_MODULES=${lib.escapeShellArg gioModules}
    ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd GIO_EXTRA_MODULES
    ${pkgs.systemd}/bin/systemctl --user start gvfs-daemon.service
  '';
in
{
  home.sessionVariables.GIO_EXTRA_MODULES = gioModules;

  systemd.user.services.gvfs-session = {
    Unit = {
      Description = "GVfs (trash:// and remote volumes) for GTK apps";
      After = [ "dbus.service" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = startGvfs;
    };
    Install = {
      WantedBy = [
        "graphical-session.target"
        "nixos-fake-graphical-session.target"
      ];
    };
  };
}
