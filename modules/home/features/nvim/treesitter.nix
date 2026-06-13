_:
{
  flake.homeModules.nvim-treesitter =
    _:
    {
      programs.nixvim = {
        plugins.treesitter = {
          enable = true;
          settings.highlight.enable = true;
          settings.incremental_selection.enable = true;
        };
        plugins.treesitter-textobjects = {
          enable = true;
          settings = {
            lsp_interop = {
              enable = true;
              border = "none";
              peek_definition_code = {
                "<leader>df" = "@function.outer";
                "<leader>dF" = "@class.outer";
              };
            };
            swap = {
              enable = true;
              swap_next = {
                "<leader>a" = "@parameter.inner";
              };
              swap_previous = {
                "<leader>A" = "@parameter.inner";
              };
            };
            move = {
              enable = true;
              set_jumps = true;
              goto_next_start = {
                "]]" = {
                  query = "@class.outer";
                  desc = "Next class start";
                };
                "]f" = {
                  query = "@call.outer";
                  desc = "Next function call";
                };
                "]o" = "@loop.*";
                "]s" = {
                  query = "@local.scope";
                  query_group = "locals";
                  desc = "Next scope";
                };
                "]z" = {
                  query = "@fold";
                  query_group = "folds";
                  desc = "Next fold";
                };
              };
              goto_next_end = {
                "][" = "@class.outer";
                "]F" = "@call.outer";
              };
              goto_previous_start = {
                "[[" = "@class.outer";
                "[f" = "@call.outer";
              };
              goto_previous_end = {
                "[]" = "@class.outer";
                "[F" = "@call.outer";
              };
              goto_next = {
                "]d" = "@conditional.outer";
              };
              goto_previous = {
                "[d" = "@conditional.outer";
              };
            };
          };
        };

        # Full buffer text object (aG)
        keymaps = [
          {
            mode = [ "o" "x" ];
            key = "aG";
            action = "<cmd>normal! ggVG<CR>";
            options.desc = "Select entire buffer";
          }
        ];
      };
    };
}
