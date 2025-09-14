{
  inputs,
  pkgs,
  ...
} : {
  programs.firefox = {
    profiles.matt = {
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
        ublock-origin
        darkreader
        onepassword-password-manager
      ];
    };
  };
}  
