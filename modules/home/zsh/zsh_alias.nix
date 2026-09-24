{ ... }:
{
  programs.zsh.shellAliases = {
    ls = "ls --color=auto";
    ll = "ls -la";
    la = "ls -A";

    # NixOS flake at ~/nixos, host name nixos
    nrs = "sudo nixos-rebuild switch --flake ~/nixos#nixos";
    nrb = "sudo nixos-rebuild boot --flake ~/nixos#nixos";
    nrt = "sudo nixos-rebuild test --flake ~/nixos#nixos";
    nrd = "nixos-rebuild dry-activate --flake ~/nixos#nixos";
    nfu = "nix flake update --flake ~/nixos";
    nup = "nix flake update --flake ~/nixos && sudo nixos-rebuild switch --flake ~/nixos#nixos";
    ngc = "sudo nix-collect-garbage -d";
    gens = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
  };
}
