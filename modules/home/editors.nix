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

  programs.zed-editor = {
    enable = true;

    userKeymaps = [
      {
        context = "Editor && VimControl && !VimWaiting && !menu";
        bindings = {
          "H" = "pane::ActivatePreviousItem";
          "L" = "pane::ActivateNextItem";

          "space d" = "pane::CloseActiveItem";
        };
      }
    ];

    userSettings = {
      theme = "Ayu Dark";
      vim_mode = true;
      relative_line_numbers = "enabled";

      buffer_font_family = "JetBrainsMono Nerd Font";
      buffer_font_size = 15;
      ui_font_size = 17;
      
      autosave = {
        after_delay = {
          milliseconds = 1000;
        };
      };
      
      tool_permissions = {
        tools = {
          terminal = {
            default = "allow";
          };
        };
      };

      telemetry = {
        metrics = false;
        diagnostics = false;
      };
    };

    extensions = [
      "nix"
      "python"
      "go"
      "haskell"
      "racket"
      "toml"
      "prettier"
      "night-owl"
    ];
  };
}
