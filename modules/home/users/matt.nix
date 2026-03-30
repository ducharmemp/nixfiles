{ inputs, self, ... }:
{
  flake.homeModules.matt =
    { pkgs, self, ... }:
    {
      imports = [
        self.homeModules.git
        self.homeModules.nvim
        self.homeModules.wezterm
        self.homeModules.fish
        self.homeModules.psql
        self.homeModules.zellij
        self.homeModules.browsers
        self.homeModules.thunderbird
        self.homeModules.tailscale
        self.homeModules.ssh
        self.homeModules.theme
        self.homeModules.common-packages
      ];

      home = {
        username = "matt";
        homeDirectory = "/home/matt";
      };

      catppuccin.thunderbird.profile = "home";
      catppuccin.firefox.enable = true;
      programs.firefox.profiles.matt.extensions.force = true;

      programs.git.settings = {
        user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIW24VUbwgiLgX4RNe+1KBNWdx6X3CPoYYfJZ37XCAi8";
        commit.gpgsign = true;
        gpg."ssh".program = "op-ssh-sign";
      };

      home.packages = with pkgs; [
        gimp3
        krita
        discord
        inter
        meslo-lgs-nf
        git-absorb
        entr
        ncdu
        rclone
        libreoffice-fresh
        moonlight-qt
      ];

      systemd.user.startServices = "sd-switch";

      home.stateVersion = "25.05";
    };
}
