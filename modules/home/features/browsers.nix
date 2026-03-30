{ inputs, self, ... }:
{
  flake.homeModules.browsers =
    { pkgs, ... }:
    {
      programs.firefox = {
        enable = true;
        profiles.matt = {
          settings = {
            CaptivePortal = false;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            DisableTelemetry = true;
            DisableFirefoxAccounts = false;
            NoDefaultBookmarks = true;
            OfferToSaveLogins = false;
            OfferToSaveLoginsDefault = false;
            PasswordManagerEnabled = false;
          };
        };
      };

      programs.chromium = {
        enable = true;
      };
    };
}
