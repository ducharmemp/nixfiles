{
  inputs,
  pkgs,
  ...
} : {
  programs.firefox = {
    enable = true; 
    profiles.matt = {
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
        ublock-origin
        onepassword-password-manager
        kagi-search
        kagi-privacy-pass
      ];
    };
  };
}  
