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

      userChrome = ''
        /* 1. Global Core UI Variables Override */
        :root {
          /* Enforce sharp square edges everywhere */
          --tab-border-radius: 0px !important;
          --arrowpanel-border-radius: 0px !important;
          --toolbarbutton-border-radius: 0px !important;

          /* Shrink Tab Heights */
          --tab-min-height: 24px !important;

          /* Squeeze Toolbar Spacing (Density) */
          --toolbarbutton-inner-padding: 2px !important;
          --urlbar-min-height: 24px !important;
          --urlbar-container-height: 26px !important;
        }

        /* 2. Micro Toolbar & Navbar Adjustments */
        #nav-bar {
          max-height: 28px !important;
          min-height: 24px !important;
        }

        /* Shrink address bar text to match compact layout */
        #urlbar-input-container {
          font-size: 11px !important;
          padding-block: 0px !important;
        }

        /* Ensure toolbar buttons compress perfectly */
        .toolbarbutton-1 {
          padding: 0px 2px !important;
          margin: 0px !important;
        }

        /* Scale down the font inside the sidebar */
        #sidebar, .sidebar-placesTree {
          font-size: 11px !important;
        }

        #vertical-tabs #tabbrowser-arrowscrollbox-periphery {
          display: flex !important;
          justify-content: center !important;
          align-items: center !important;
          width: 100% !important;
        }

        #vertical-tabs-newtab-button {
          width: 24px !important;
          height: 24px !important;
          padding: 0px !important;
          margin: 6px auto 0px auto !important;
          box-sizing: border-box !important;
        }

        #vertical-tabs-newtab-button > .toolbarbutton-icon {
          display: block !important;
          width: 14px !important;
          height: 14px !important;
          margin: 0px !important;
        }

        /* 4. Tab Container & Cleanup */
        .tab-background {
          margin-block: 0px !important;
        }
      '';
    };
  };
}