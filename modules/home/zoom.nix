# Zoom on Hyprland: declarative client policy + Qt scene graph env for the binary.
{ osConfig, pkgs, lib, ... }:
let
  zoom = osConfig.programs.zoom-us.package;

  zoomWrapped = pkgs.runCommand "zoom-hyprland" { } ''
    mkdir -p $out/bin
    cp ${pkgs.writeShellScript "zoom-hyprland" ''
      export QSG_RHI_BACKEND=opengl
      unset QT_QUICK_BACKEND
      unset LIBGL_ALWAYS_SOFTWARE
      exec ${zoom}/bin/zoom "$@"
    ''} $out/bin/zoom
    chmod +x $out/bin/zoom
    ln -s zoom $out/bin/zoom-us
  '';
in
{
  # Zoom rewrites this file when it exits; nixos-rebuild restores these values.
  xdg.configFile."zoomus.conf" = {
    force = true;
    text = lib.generators.toINI { } {
      General = {
        enableCefOsrMode = false;
        enableCefGpu = true;
        enableAlphaBuffer = false;
        shortcut_as_global_ShortcutID_ShowHideFloatingMeetingControls = false;
        xwayland = true;
      };
    };
  };

  home.packages = [ (lib.hiPrio zoomWrapped) ];
}
