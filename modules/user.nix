{ pkgs, ... }:
{
  programs.zsh.enable = true;

  # Keys and tokens go to /home/abeb-nix via copy-settings.sh
  # (~/.ssh, ~/.gnupg, ~/.git-credentials, ~/.config/gh). Not stored in this repo.
  # GNOME's agent turns on with the desktop modules. Only one agent is allowed.
  services.gnome.gcr-ssh-agent.enable = false;
  programs.ssh = {
    startAgent = true;
    askPassword = "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

  # Installer account. uid 1000 matches /mnt/home/abeb-nix.
  # The old Arch home partition is not mounted.
  users.users.abeb-nix = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "input"
      "wireshark"
      "video"
      "audio"
      "render"
    ];
  };
}
