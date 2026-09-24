{ inputs, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (
        final: prev:
        import ../../pkgs {
          inherit inputs;
          pkgs = prev;
        }
      )
    ];
  };
}
