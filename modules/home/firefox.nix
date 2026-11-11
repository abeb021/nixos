{ inputs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles.default = {
      settings = {
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "sidebar.visibility" = "expand-on-hover";
        "sidebar.animation.expand-on-hover.duration-ms" = 0;
      };

      # Styles the browser UI shell
      userChrome = ''
        :root {
          --ui-font: "JetBrainsMono Nerd Font", monospace !important;
        }

        * {
          font-family: var(--ui-font) !important;
        }

        *,
        *::before,
        *::after {
          border-radius: 0 !important;
        }

        .tabbrowser-tab,
        .tab-background,
        .tab-content,
        .tab-stack,
        .tab-label,
        .tab-icon-stack {
          border-radius: 0 !important;
        }

        .tabbrowser-tab[selected="true"] .tab-background {
          border-radius: 0 !important;
        }

        #urlbar,
        #urlbar-background,
        #urlbar-input-container,
        #searchbar,
        .searchbar-textbox {
          border-radius: 0 !important;
        }

        menupopup,
        panel,
        .panel-arrowcontent,
        .popup-internal-box,
        #appMenu-popup,
        #unified-extensions-panel,
        toolbarbutton,
        .menuitem,
        .subviewbutton {
          border-radius: 0 !important;
        } Menupopup > menu,
        menupopup > menuitem {
          border-radius: 0 !important;
        }

        button,
        toolbarbutton,
        #nav-bar toolbarbutton {
          border-radius: 0 !important;
        }

        findbar,
        .findbar-container,
        .findbar-textbox {
          border-radius: 0 !important;
        }

        #sidebar-box,
        #sidebar-header,
        #sidebar-search-container,
        .sidebar-panel {
          border-radius: 0 !important;
        }

        #downloadsPanel,
        #downloadsPanel-mainView,
        .download-state,
        .downloadButton {
          border-radius: 0 !important;
        }

        #nav-bar {
          --toolbarbutton-inner-padding: 6px !important;
        }

        #TabsToolbar {
          --toolbarbutton-inner-padding: 6px !important;
        }

        .tabbrowser-tab {
          border-left: 1px solid color-mix(
            in srgb,
            currentColor 15%,
            transparent
          ) !important;
        }
      '';

      # Styles webpage content cleanly without breaks
      userContent = ''
        /* Target standard typography elements to ensure smooth fallback loading */
        html, body, p, div, span, a, input, button, textarea, select, h1, h2, h3, h4, h5, h6 {
          font-family: "JetBrainsMono Nerd Font", monospace !important;
        }

        /* Enforce sharp square borders across web views */
        *,
        *::before,
        *::after {
          border-radius: 0 !important;
        }
      '';
    };
  };
}