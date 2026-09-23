{ pkgs, ... }:
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
    python3
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

    # VPN client. zapret's old unit executed /opt/zapret on the Arch disk;
    # the package is here, the service is not started.
    amnezia-vpn
    zapret
  ];
}
