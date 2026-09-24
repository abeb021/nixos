{ pkgs, lib, ... }:
let
  inherit (import ./extensions.nix { inherit pkgs; }) editorExtensions;

  codeSettings = lib.importJSON ./files/code-settings.json;

  cursorSettings =
    (lib.importJSON ./files/cursor-settings.json)
    // {
      python.defaultInterpreterPath = "${pkgs.python3}/bin/python3";
    };

  cursorKeybindings = lib.importJSON ./files/cursor-keybindings.json;

  editorProfile = userSettings:
    {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      userSettings = userSettings;
      extensions = editorExtensions;
    };
in
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default = editorProfile codeSettings;
  };

  programs.cursor = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default = editorProfile cursorSettings // {
      keybindings = cursorKeybindings;
    };
  };
}
