{ inputs, ... }:
{
  flake.homeModules.nvim-orgmode =
    { pkgs, ... }:
    {
      programs.nixvim = {
        plugins.orgmode.enable = true;
        plugins.blink-cmp.settings.sources.providers.orgmode = {
          name = "Orgmode";
          module = "orgmode.org.autocompletion.blink";
          score_offset = 100;
        };

        extraPlugins = [
          (pkgs.vimUtils.buildVimPlugin {
            pname = "telescope-orgmode.nvim";
            version = inputs.telescope-orgmode.shortRev;
            src = inputs.telescope-orgmode;
            doCheck = false;
          })
        ];

        extraConfigLua = ''
          require("telescope-orgmode").setup({ adapter = "snacks" })
        '';

        keymaps = [
          {
            mode = "n";
            key = "<leader>oh";
            action.__raw = ''
              function()
                require("telescope-orgmode").search_headings()
              end
            '';
            options.desc = "[O]rg [H]eadlines";
          }
          {
            mode = "n";
            key = "<leader>ot";
            action.__raw = ''
              function()
                require("telescope-orgmode").search_tags()
              end
            '';
            options.desc = "[O]rg [T]ags";
          }
          {
            mode = "n";
            key = "<leader>or";
            action.__raw = ''
              function()
                require("telescope-orgmode").refile_heading()
              end
            '';
            options.desc = "[O]rg [R]efile";
          }
          {
            mode = "n";
            key = "<leader>ol";
            action.__raw = ''
              function()
                require("telescope-orgmode").insert_link()
              end
            '';
            options.desc = "[O]rg Insert [L]ink";
          }
        ];
      };
    };
}
