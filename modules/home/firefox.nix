{ inputs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles.default = {
      settings = {
        "browser.compactmode.show" = true;
        "browser.uidensity" = 2;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      
      userChrome = ''
        /* 1. Global Core UI Variables Override */
        :root {
          /* Enforce sharp square edges everywhere */
          --tab-border-radius: 0px !important;
          --arrowpanel-border-radius: 0px !important;
          --toolbarbutton-border-radius: 0px !important;
          --button-border-radius: 0px !important;
          --border-radius-medium: 0px !important;

          /* Shrink Tab Heights */
          --tab-min-height: 24px !important;
          --tab-max-height: 24px !important;

          /* Squeeze Toolbar Spacing (Density) */
          --toolbarbutton-inner-padding: 2px !important;
          --toolbarbutton-outer-padding: 1px !important;
          --urlbar-min-height: 24px !important;
          --urlbar-container-height: 26px !important;
        }

        /* 2. Micro Toolbar & Navbar Adjustments */
        #nav-bar, 
        #TabsToolbar {
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

        /* 3. Hard-Forced Sidebar Dimensions */
        #sidebar-box {
          min-width: 100px !important;
          max-width: 100px !important;
          width: 100px !important;
        }

        /* Scale down the font inside the sidebar */
        #sidebar, .sidebar-placesTree {
          font-size: 11px !important;
        }

        /* 4. Tab Container & Cleanup */
        .tab-background,
        .tab-stack,
        #TabsToolbar {
          border-radius: 0px !important;
        }

        .tab-background {
          margin-block: 0px !important;
          padding-block: 0px !important;
        }
      '';
    };
  };
}
