{ inputs, ... }:
{
  flake.homeModules.nvim-lsp =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ inputs.expert.packages.${pkgs.stdenv.hostPlatform.system}.default ];
      programs.nixvim = {
        plugins.lspconfig.enable = true;
        lsp = {
          servers = {
            tailwindcss.enable = true;
            yamlls.enable = true;
            jsonls.enable = true;
            html.enable = true;
            helm_ls.enable = true;
            ts_ls.enable = true;
            svelte.enable = true;
            nixd.enable = true;
            rust_analyzer.enable = true;
            herb_ls.enable = true;
            cssls.enable = true;
            bashls.enable = true;
            terraformls.enable = true;
            marksman.enable = true;
            postgres_lsp.enable = true;
          };
        };
        extraConfigLua = ''
          vim.lsp.config('ruby-lsp', {
            filetypes = { "ruby", "eruby" },

            cmd = { "bundle", "exec", "ruby-lsp" },

            root_markers = { "Gemfile", ".git" },
            
            init_options = {
              addonSettings = {
                ["Ruby LSP Rails"] = {
                  enablePendingMigrationsPrompt = false,
                },
              },
            },
          })
          vim.lsp.enable('ruby-lsp')

          vim.lsp.config('pony_lsp', {
            filetypes = { "pony" },

            -- corral run would set PONYPATH for us, but it captures the
            -- child's stdout instead of streaming it, which severs the LSP
            -- stdio channel. Spawn pony-lsp directly and rebuild PONYPATH
            -- from _corral ourselves: pony-lsp only reads the top-level
            -- corral.json, so transitive deps (lori, ssl, ...) need it.
            cmd = function(dispatchers, config)
              local root = config.root_dir or vim.fn.getcwd()
              local deps = vim.fn.glob(root .. "/_corral/*", true, true)
              local env = {}
              if #deps > 0 then
                env.PONYPATH = table.concat(deps, ":")
              end
              return vim.lsp.rpc.start({ "pony-lsp" }, dispatchers, {
                cwd = root,
                env = env,
              })
            end,

            root_markers = { "corral.json", "bundle.json", ".git", ".jj" },
          })
          vim.lsp.enable('pony_lsp')

          vim.lsp.config('expert', {
            cmd = { '${inputs.expert.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/expert' },
            root_markers = { 'mix.exs', '.git' },
            filetypes = { 'elixir', 'eelixir', 'heex' },
          })
          vim.lsp.enable('expert')
        '';
      };
    };
}
