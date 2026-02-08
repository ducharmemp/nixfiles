{ inputs, self, ... }:
{
  flake.homeModules.gconform =
    { pkgs, ... }:
    {
      programs.nixvim = {
        plugins.conform-nvim.enable = true;
        keymaps = [
          {
            mode = "n";
            key = "<leader>cf";
            action.__raw = ''
              function()
                require('conform').format({ async = true, lsp_fallback =true })
              end
            '';
            options = {
              desc = "[C]onform [F]ile";
            };
          }
        ];
      };
    };
}
