{ pkgs, lib, ... } : {
  common = lib.mkDefault {
    packages = with pkgs; [ 
      zellij
      stylua
      unzip
      htop
      tree-sitter
      nodejs_21
      fd
      zoxide
    ];
  };
} 
