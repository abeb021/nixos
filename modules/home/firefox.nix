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
        /* Force square corners across the entire browser UI */
        * {
          border-radius: 0px !important;
        }

        /* Optional: Targeted adjustments for cleaner squared tabs */
        .tab-background {
          border-radius: 0px !important;
          margin-block: 1px !important;
        }
      '';
    };
  };
}
