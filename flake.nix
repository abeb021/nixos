{
  description = "NixOS system for this machine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    tanjun = {
      url = "github:abeb021/Tanjun-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fetch = {
      url = "github:areofyl/fetch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      username = "abeb-nix";
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/nixos ];
          specialArgs = {
            host = "nixos";
            inherit self inputs username;
          };
        };
      };
    };
}
