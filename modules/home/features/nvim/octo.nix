_:
{
  flake.homeModules.nvim-octo =
    _:
    {
      programs.nixvim = {
        plugins.octo = {
          enable = true;
          settings = {
            picker = "snacks";
          };
        };
        keymaps = [
          {
            mode = "n";
            key = "<leader>gp";
            action = "<cmd>Octo pr list<CR>";
            options = {
              desc = "[G]ithub [P]ull Requests";
            };
          }
          {
            mode = "n";
            key = "<leader>gi";
            action = "<cmd>Octo issue list<CR>";
            options = {
              desc = "[G]ithub [I]ssues";
            };
          }
          {
            mode = "n";
            key = "<leader>gP";
            action = "<cmd>Octo pr search<CR>";
            options = {
              desc = "[G]ithub [P]R Search";
            };
          }
        ];
      };
    };
}
