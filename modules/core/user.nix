# Keys and tokens go to /home/abeb-nix via scripts/scripts/copy-settings.sh
# (~/.ssh, ~/.gnupg, ~/.git-credentials, ~/.config/gh). Not stored in this repo.
{
  pkgs,
  inputs,
  username,
  host,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

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

  # Installer account. uid 1000 matches the existing home directory.
  users.users.${username} = {
    isNormalUser = true;
    uid = 1001;
    description = username;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "input"
      "wireshark"
      "video"
      "audio"
      "render"
    ];
  };

  nix.settings.allowed-users = [ username ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-bak";
    extraSpecialArgs = {
      inherit inputs username host;
    };
    users.${username} = {
      imports = [ ../home ];
      home.username = username;
      home.homeDirectory = "/home/${username}";
      home.stateVersion = "26.05";
      programs.home-manager.enable = true;
    };
  };
}
