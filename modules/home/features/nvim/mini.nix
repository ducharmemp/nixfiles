{ inputs, self, ... }:
{
  flake.homeModules.nvim-mini =
    { pkgs, ... }:
    {
      programs.nixvim = {
        plugins.mini-surround.enable = true;
        plugins.mini-pairs.enable = true;
        plugins.mini-icons.enable = true;
        plugins.mini-icons.mockDevIcons = true;
        plugins.mini-statusline.enable = true;
        plugins.mini-extra.enable = true;
        plugins.mini-ai = {
          enable = true;
          settings.custom_textobjects = {
            f.__raw = "require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' })";
            c.__raw = "require('mini.ai').gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' })";
            s.__raw = "require('mini.ai').gen_spec.treesitter({ a = '@local.scope', i = '@local.scope' })";
            m.__raw = "require('mini.ai').gen_spec.treesitter({ a = '@call.outer', i = '@call.inner' })";
            a.__raw = "require('mini.ai').gen_spec.treesitter({ a = '@parameter.outer', i = '@parameter.inner' })";
            o.__raw = "require('mini.ai').gen_spec.treesitter({ a = '@loop.outer', i = '@loop.inner' })";
            d.__raw = "require('mini.ai').gen_spec.treesitter({ a = '@conditional.outer', i = '@conditional.inner' })";
          };
        };
      };
    };
}
