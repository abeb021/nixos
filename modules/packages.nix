{ pkgs, lib, ... }:
{
  programs.git.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.firefox.enable = true;

  # Amnezia ships its own unit. Enable it the same way the Arch service was enabled.
  systemd.packages = [ pkgs.amnezia-vpn ];
  systemd.services.AmneziaVPN.wantedBy = [ "multi-user.target" ];

  environment.systemPackages = with pkgs; [
    # daily apps
    chromium
    vscode
    code-cursor
    discord
    obsidian
    zoom-us
    ayugram-desktop
    postman
    libreoffice
    obs-studio
    vlc
    btop
    htop

    # dev
    git
    gh
    lazygit
    neovim
    go
    nodejs
    # Pillow is what Tanjun uses to sample wallpaper colors.
    (python3.withPackages (ps: [ ps.pillow ]))
    gcc
    gnumake
    pkg-config
    ripgrep
    fd
    fzf
    jq
    unzip
    wget
    openssh
    nano
    pinentry-qt
    docker-compose
    docker-buildx

    # psmisc killall misses Nix .*-wrapped process names (comm truncated to 15).
    psmisc
    (lib.hiPrio (pkgs.writeShellScriptBin "killall" ''
      set +e
      real=${pkgs.psmisc}/bin/killall
      "$real" "$@"
      status=$?
      flags=()
      names=()
      skip=
      for arg in "$@"; do
        if [ -n "$skip" ]; then
          flags+=("$arg")
          skip=
          continue
        fi
        case "$arg" in
          -o|--older-than|-y|--younger-than|-s|--signal)
            flags+=("$arg")
            skip=1
            ;;
          -*)
            flags+=("$arg")
            ;;
          *)
            names+=("$arg")
            ;;
        esac
      done
      for name in "''${names[@]}"; do
        short="$(printf '%.15s' ".''${name}-wrapped")"
        "$real" "''${flags[@]}" "$short" 2>/dev/null
      done
      exit "$status"
    ''))

    # VPN client. zapret's old unit executed /opt/zapret on the Arch disk;
    # the package is here, the service is not started.
    amnezia-vpn
    zapret
  ];
}
