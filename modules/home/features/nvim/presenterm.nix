_:
{
  # A blink.cmp completion source that offers presenterm comment commands
  # (`<!-- pause -->`, `<!-- alignment: center -->`, ...) in markdown buffers.
  # The command list comes from `presenterm --list-comment-commands`, which
  # presenterm documents as its editor-integration entry point.
  flake.homeModules.nvim-presenterm =
    _:
    {
      programs.nixvim = {
        # Register the source object under a module name so blink's
        # `require("blink-presenterm")` finds it. Defining it in
        # package.loaded avoids shipping a separate Lua file.
        extraConfigLua = ''
          do
            local source = {}
            source.__index = source

            function source.new()
              return setmetatable({ items = nil }, source)
            end

            -- Only offer these completions in markdown, and only when
            -- presenterm is actually installed.
            function source:enabled()
              return vim.bo.filetype == "markdown" and vim.fn.executable("presenterm") == 1
            end

            -- Complete right after the `<` that opens an HTML comment, plus
            -- the usual identifier characters so typing keeps the menu open.
            function source:get_trigger_characters()
              return { "<", "!", "-", " " }
            end

            function source:get_completions(ctx, callback)
              if not self.items then
                self.items = {}
                local out = vim.fn.systemlist({ "presenterm", "--list-comment-commands" })
                if vim.v.shell_error == 0 then
                  for _, line in ipairs(out) do
                    line = vim.trim(line)
                    if line ~= "" then
                      table.insert(self.items, {
                        label = line,
                        kind = vim.lsp.protocol.CompletionItemKind.Snippet,
                        insertText = line,
                        -- Replace any partial `<!-- ...` the user already typed
                        -- so we never end up with a doubled comment opener.
                        filterText = line,
                      })
                    end
                  end
                end
              end

              callback({
                items = self.items,
                is_incomplete_backward = false,
                is_incomplete_forward = false,
              })
            end

            package.loaded["blink-presenterm"] = source
          end
        '';

        # The source name is added to sources.default in blink.nix; here we
        # only declare the provider. `enabled()` above gates it to markdown
        # buffers with presenterm installed, so listing it globally is safe.
        plugins.blink-cmp.settings.sources.providers.presenterm = {
          module = "blink-presenterm";
          name = "presenterm";
          score_offset = 100;
        };
      };
    };
}
