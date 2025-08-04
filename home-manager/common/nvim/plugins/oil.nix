{ ... } : {
  programs.nixvim = {
    plugins.oil = {
      enable = true;
      settings.default_file_explorer = true;
      settings.columns = ["icon" "size" "permissions"];
      settings.view_options = {
        show_hidden = true;
      };
      settings.keymaps = { "y." = "actions.copy_entry_path"; };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Oil<CR>";
        options = {
        desc = "Open [F]ile [E]xplorer";
        };
      }
    ];
  };
}
