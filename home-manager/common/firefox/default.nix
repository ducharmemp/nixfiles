{
  inputs,
  pkgs,
  ...
} : {
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
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
        ublock-origin
        onepassword-password-manager
        kagi-search
        kagi-privacy-pass
      ];
    };
  };
}  
