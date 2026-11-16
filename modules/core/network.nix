{ host, pkgs, ... }:
{
  networking.hostName = host;
  networking.networkmanager.enable = true;
  networking.nftables.enable = false;

  services.zapret = {
    enable = true;
    configureFirewall = true;

    whitelist = [
      "youtube.com"
      "googlevideo.com"
      "discord.com"
      "discordapp.com"
    ];

    params = [
      "--dpi-desync=multidisorder"
      "--dpi-desync-split-pos=7,sld+1"
      "--dpi-desync-fake-tls=0x0F0F0F0F"
      "--dpi-desync-fooling=badseq"
      "--dpi-desync-autottl=2:2-12"
      "--ipset=${../../lists/ipset-service.txt}"
      # update with:
      # curl -o ~/nixos/lists/ipset-service.txt https://raw.githubusercontent.com/Flowseal/zapret-discord-youtube/refs/heads/main/.service/ipset-service.txt
    ];
  };

  systemd.services.zapret.wantedBy = pkgs.lib.mkForce [ ];
}