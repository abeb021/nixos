# Declarative VS Code / Cursor extensions (Open VSX + nixpkgs).
{ pkgs, ... }:
let
  inherit (pkgs.vscode-utils) extensionFromVscodeMarketplace;
  inherit (pkgs.vscode-extensions)
    vscodevim
    ms-python
    golang
    ms-azuretools
    ms-vscode-remote
    sdras
    jnoortheen
    esbenp
    ritwickdey
    ms-toolsai
    #haskell ts
    haskell
    justusadam 
    ;

  beardedTheme = extensionFromVscodeMarketplace {
    publisher = "BeardedBear";
    name = "beardedtheme";
    version = "10.1.0";
    sha256 = "0c0kcl08j8ii65h5mkpgssgqgshhkf49adgxd5xh1klx8qn2zjgc";
  };

  beardedIcons = extensionFromVscodeMarketplace {
    publisher = "BeardedBear";
    name = "beardedicons";
    version = "1.22.0";
    sha256 = "1aaxbrbss3ck9pab3fz55xkkwm1qc1dgq6aypfh7fl2qakfv0r0f";
  };

  magicRacket = extensionFromVscodeMarketplace {
    publisher = "evzen-wybitul";
    name = "magic-racket";
    version = "0.8.0";
    sha256 = "sha256-yWmJFLXktsJDEDwHO8ZCXQBTw8j5bOv6TXEOO/V8mZs="; 
  };

in
{
  editorExtensions = [
    vscodevim.vim
    ms-python.python
    golang.go
    ms-azuretools.vscode-docker
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-containers
    sdras.night-owl
    beardedTheme
    beardedIcons
    jnoortheen.nix-ide
    esbenp.prettier-vscode
    ritwickdey.liveserver
    magicRacket
    ms-toolsai.jupyter
    haskell.haskell
    justusadam.language-haskell
  ];
}
