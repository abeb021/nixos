{ username, pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    # Avoid rootless Docker if you can for Minikube, as it introduces severe path overlay issues on NixOS
    rootless.enable = false; 
  };
  users.users.${username}.extraGroups = [ "docker" "libvirtd" ];

  virtualisation.libvirtd.enable = true;
  # Ensure necessary packages are available system-wide
  environment.systemPackages = with pkgs; [
    minikube
    kubectl
    OVMFFull.fd
  ];
}
