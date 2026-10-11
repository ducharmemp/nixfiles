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
            # ts_ls.enable = true;
            svelte.enable = true;
            nixd.enable = true;
            rust_analyzer.enable = true;
            herb_ls.enable = true;
            cssls.enable = true;
            bashls.enable = true;
            terraformls.enable = true;
            postgres_lsp.enable = true;
          };
        };
        extraConfigLua = ''
          local function client_has_root(client, root_dir)
            local uri = vim.uri_from_fname(root_dir)
            for _, folder in ipairs(client.workspace_folders or {}) do
              if folder.uri == uri then
                return true
              end
            end
            return false
          end

          local function reuse_per_root(client, config)
            if client.name ~= config.name or client:is_stopped() then
              return false
            end
            if not config.root_dir then
              return not next(client.workspace_folders or {})
            end
            return client_has_root(client, config.root_dir)
          end

          local function reuse_per_server(client, config)
            if reuse_per_root(client, config) then
              return true
            end
            if client.name ~= config.name or client:is_stopped() or not config.root_dir then
              return false
            end
            if not client.initialized or not next(client.workspace_folders or {}) then
              return false
            end
            if not client:supports_method('workspace/didChangeWorkspaceFolders') then
              return false
            end
            if type(client._add_workspace_folder) ~= 'function' then
              return false
            end
            client:_add_workspace_folder(config.root_dir)
            return true
          end

          vim.lsp.config('*', { reuse_client = reuse_per_server })

          vim.lsp.config('ruby-lsp', {
            filetypes = { "ruby", "eruby" },

            cmd = { "bundle", "exec", "ruby-lsp" },

            root_markers = { "Gemfile", ".git" },

            reuse_client = reuse_per_root,
            
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

            reuse_client = reuse_per_root,
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
