{ inputs, ... }:
{
  flake.homeModules.nvim-straps =
    { config, ... }:
    {
      imports = [ inputs.agenix.homeManagerModules.default ];

      age.identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
      age.secrets.llamacpp-url.file = ../../../../secrets/llamacpp-url.age;

      programs.nixvim = {
        imports = [ 
          inputs.straps.nixvimModules.default 
          inputs.straps-classifier.nixvimModules.default
          inputs.straps-divergent.nixvimModules.default
          inputs.straps-renamer.nixvimModules.default
          inputs.straps-exoskeleton.nixvimModules.default
          inputs.straps-chartifier.nixvimModules.default
          inputs.straps-buff.nixvimModules.default
          inputs.straps-kagi.nixvimModules.default
        ];
        plugins.straps.enable = true;
        plugins.straps.settings.model = "claude-opus-5-5";
        extraConfigLua = ''
          require("straps").setup({
            max_spawn_depth = 2,
            --llamacpp_base_url = vim.trim(table.concat(vim.fn.readfile(vim.fn.expandcmd(${builtins.toJSON config.age.secrets.llamacpp-url.path})), "\n")),
          })

          local straps_attn = { focused = true, done = {} }
          local straps_grp = vim.api.nvim_create_augroup("StrapsAttention", { clear = true })

          local function straps_visible(buf)
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
              if vim.api.nvim_win_get_buf(win) == buf then return true end
            end
            return false
          end

          local function straps_toplevel(buf)
            return vim.b[buf].straps_parent == nil
          end

          local function straps_redraw()
            vim.schedule(function() vim.cmd.redrawstatus({ bang = true }) end)
          end

          local straps_zellij = { ids = {} }
          _G.StrapsZellij = straps_zellij

          local function straps_root(buf)
            local seen = {}
            while vim.api.nvim_buf_is_valid(buf) and vim.b[buf].straps_parent and not seen[buf] do
              seen[buf] = true
              buf = vim.b[buf].straps_parent
            end
            return buf
          end

          local function straps_printable(s)
            local out = {}
            for _, cp in ipairs(vim.fn.str2list(s)) do
              out[#out + 1] = (cp < 32 or (cp >= 127 and cp < 160)) and " " or vim.fn.nr2char(cp)
            end
            return table.concat(out)
          end

          local function straps_task(buf)
            local ok, text = pcall(function()
              local blocks = require("straps.state").list_blocks(buf)
              for i = #blocks, 1, -1 do
                local b = blocks[i]
                if b.kind == "user" then
                  for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, b.first_lnum - 1, b.last_lnum, false)) do
                    line = vim.trim(line)
                    if line ~= "" and not line:match("^%[straps%]") then return line end
                  end
                end
              end
            end)
            return ok and text or nil
          end

          function straps_zellij.emit(buf, state, kind, msg)
            if not vim.env.ZELLIJ then return end
            local id = "straps-" .. buf
            local seq
            if state == "clear" then
              if not straps_zellij.ids[id] then return end
              straps_zellij.ids[id] = nil
              seq = "state=clear:id=" .. id
            else
              straps_zellij.ids[id] = true
              seq = "state=" .. state .. ":id=" .. id .. ":app=straps"
              if kind then seq = seq .. ":kind=" .. kind end
              msg = msg or straps_task(buf)
              local ok, clean = pcall(straps_printable, tostring(msg or ""))
              if ok and clean ~= "" then
                seq = seq .. ":msg=" .. vim.base64.encode(require("straps.state").utf8_cut(clean, 1024))
              end
            end
            pcall(vim.api.nvim_ui_send, "\27]7501;" .. seq .. "\27\\")
          end

          function straps_zellij.report(buf, state, kind, msg)
            pcall(function()
              local root = straps_root(buf)
              if not vim.api.nvim_buf_is_valid(root) or not vim.b[root].straps_session then return end
              if root ~= buf and vim.b[root].straps_status ~= "running" then return end
              local task = straps_task(root)
              msg = type(msg) == "string" and msg or nil
              if msg and task then msg = msg .. " · " .. task end
              straps_zellij.emit(root, state, kind, msg or task)
            end)
          end

          local function straps_seen(buf)
            straps_attn.done[buf] = nil
            straps_zellij.emit(buf, "clear")
          end

          local function straps_clear_visible()
            local changed = false
            for buf in pairs(straps_attn.done) do
              if not vim.api.nvim_buf_is_valid(buf) or straps_visible(buf) then
                straps_seen(buf)
                changed = true
              end
            end
            if changed then straps_redraw() end
          end

          function _G.StrapsAttentionStatus()
            local running, done = 0, 0
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_loaded(buf) and straps_toplevel(buf)
                and vim.b[buf].straps_status == "running" then
                running = running + 1
              end
            end
            for buf in pairs(straps_attn.done) do
              if vim.api.nvim_buf_is_valid(buf) then done = done + 1 end
            end
            local parts = {}
            if running > 0 then parts[#parts + 1] = "󰚩 " .. running .. " working" end
            if done > 0 then parts[#parts + 1] = "󰋼 " .. done .. " waiting" end
            return table.concat(parts, "  ")
          end

          vim.api.nvim_create_autocmd("User", {
            group = straps_grp,
            pattern = "StrapsRunStart",
            callback = function(ev)
              local buf = ev.data.bufnr
              straps_attn.done[buf] = nil
              if straps_toplevel(buf) then straps_zellij.emit(buf, "working") end
              straps_redraw()
            end,
          })

          vim.api.nvim_create_autocmd("User", {
            group = straps_grp,
            pattern = "StrapsRunEnd",
            callback = function(ev)
              local buf, reason = ev.data.bufnr, ev.data.reason
              straps_redraw()
              if not vim.api.nvim_buf_is_valid(buf) or not straps_toplevel(buf) then return end
              if reason == "cancelled" or (straps_attn.focused and straps_visible(buf)) then
                straps_zellij.emit(buf, "clear")
                return
              end
              straps_attn.done[buf] = reason
              straps_zellij.emit(buf, reason == "error" and "error" or "done")
            end,
          })

          vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufWipeout" }, {
            group = straps_grp,
            callback = function(ev)
              if straps_attn.done[ev.buf] then
                straps_seen(ev.buf)
                straps_redraw()
              elseif ev.event == "BufWipeout" then
                straps_zellij.emit(ev.buf, "clear")
              end
            end,
          })

          vim.api.nvim_create_autocmd("VimLeavePre", {
            group = straps_grp,
            callback = function()
              for id in pairs(straps_zellij.ids) do
                pcall(vim.api.nvim_ui_send, "\27]7501;state=clear:id=" .. id .. "\27\\")
              end
            end,
          })

          local straps_registry = require("straps.registry")
          local straps_confirm_doc = "Reports a pending approval to the Zellij attention inbox, then defers to the previous hook.confirm."
          local straps_live_confirm = straps_registry.get("hook.confirm")
          if straps_live_confirm and straps_live_confirm.doc == straps_confirm_doc and _G.StrapsZellijPrevConfirm then
            straps_zellij.prev_confirm = _G.StrapsZellijPrevConfirm
          else
            straps_zellij.prev_confirm = assert(straps_registry.bind("hook.confirm"), "hook.confirm is not defined")
            _G.StrapsZellijPrevConfirm = straps_zellij.prev_confirm
          end
          straps_registry.define({
            name = "hook.confirm",
            kind = "hook",
            doc = straps_confirm_doc,
            source = [==[
          return function(name, input, ctx)
            local z = _G.StrapsZellij
            local registry = require("straps.registry")
            local buf = ctx and ctx.bufnr
            local report = buf and not registry.try_call("fn.readonly_policy", name, input)
            if report then z.report(buf, "blocked", "permission", name) end
            local ok, allowed, reason, source = pcall(z.prev_confirm, name, input, ctx)
            if report then z.report(buf, "working") end
            if not ok then error(allowed, 0) end
            return allowed, reason, source
          end
          ]==],
          }, { scope = "global" })

          straps_registry.define({
            name = "hook.before_tool.zellij",
            kind = "hook",
            doc = "Reports an ask_user question to the Zellij attention inbox.",
            source = [==[
          return function(name, input, ctx)
            if name == "ask_user" and ctx and ctx.bufnr then
              _G.StrapsZellij.report(ctx.bufnr, "blocked", "question", type(input) == "table" and input.question or nil)
            end
          end
          ]==],
          }, { scope = "global" })

          straps_registry.define({
            name = "hook.after_tool.zellij",
            kind = "hook",
            doc = "Returns the Zellij attention record to working after an ask_user answer.",
            source = [==[
          return function(name, input, result, ok, ctx)
            if name == "ask_user" and ctx and ctx.bufnr then
              _G.StrapsZellij.report(ctx.bufnr, "working")
            end
          end
          ]==],
          }, { scope = "global" })

          vim.api.nvim_create_autocmd("FocusGained", {
            group = straps_grp,
            callback = function()
              straps_attn.focused = true
              straps_clear_visible()
            end,
          })
          vim.api.nvim_create_autocmd("TabEnter", {
            group = straps_grp,
            callback = straps_clear_visible,
          })
          vim.api.nvim_create_autocmd("FocusLost", {
            group = straps_grp,
            callback = function() straps_attn.focused = false end,
          })
        '';

        plugins.mini-statusline.settings.content.active.__raw = ''
          function()
            local ms = MiniStatusline
            local mode, mode_hl = ms.section_mode({ trunc_width = 120 })
            local git = ms.section_git({ trunc_width = 40 })
            local diff = ms.section_diff({ trunc_width = 75 })
            local diagnostics = ms.section_diagnostics({ trunc_width = 75 })
            local lsp = ms.section_lsp({ trunc_width = 75 })
            local filename = ms.section_filename({ trunc_width = 140 })
            local fileinfo = ms.section_fileinfo({ trunc_width = 120 })
            local location = ms.section_location({ trunc_width = 75 })
            local search = ms.section_searchcount({ trunc_width = 75 })
            return ms.combine_groups({
              { hl = mode_hl, strings = { mode } },
              { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
              "%<",
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=",
              { hl = "DiagnosticWarn", strings = { _G.StrapsAttentionStatus and _G.StrapsAttentionStatus() or "" } },
              { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
              { hl = mode_hl, strings = { search, location } },
            })
          end
        '';

        plugins.straps-divergent.enable = true;
        plugins.straps-renamer.enable = false;
        plugins.straps-exoskeleton.enable = true;
        plugins.straps-chartifier.enable = true;
        plugins.straps-buff.enable = true;
        plugins.straps-kagi.enable = true;
        plugins.straps-classifier = {
          enable = true;
          settings = {
            model = "jev-latest";
            endpoint = "https://api.typesafe.ai/v1/systemone";
            timeout_ms = 8000;
            retry = 1;

            # Command battery (every tool but the builtin ask_user).
            deny_threshold = 0.85;   # any hazard at or above this denies
            damage_deny = 2.5;       # damage rating 0-3
            opaque_action = "deny";  # runs_script_outside_root: "deny" or "log"
            # One cutoff per hazard, by id; unset = deny_threshold, above 1
            # disables that one question. The default is null (no overrides);
            # this lets `jj git push` / `git push` through from a session while
            # every other hazard keeps the threshold.
            cutoffs = {
              pushes_or_publishes = 1.1;
              # reads_outside_root = null; writes_outside_root = null;
              # writes_harmful_content = null; executes_generated_input = null;
              # unrecoverable_loss = null; reads_credentials = null;
              # transmits_local_data = null; redefines_protected = null;
              # deploys_or_mutates_infra = null; sends_message = null;
              # runs_script_outside_root = null;
            };

            # ask_user battery. Unset ask_deny_threshold falls back to
            # deny_threshold. Any cutoff above 1 (fairness: above 4) disables
            # that question or verdict alone.
            ask_deny_threshold = null;
            ask_cutoffs = {
              # code verdicts
              viable = 0.6;              # Hobson's: at most one option at/above this
              disfavored = 0.6;          # stacked deck: options named as "described to lose"
              steer_confidence = 0.6;
              asymmetric_detail = 0.7;
              decoy_present = 0.7;
              fairness = 2.0;            # 0-4 scale
              marked_recommended = 0.7;
              deciding_factor = 0.5;
              # fixed questions; null = ask_deny_threshold
              vague_option = null;
              distinction_without_difference = null;
              permission_seeking = null;
              already_answered = null;
              loaded_premise = null;
              fabricated_cost = null;
              package_deal = null;
              appeal_to_authority_or_popularity = null;
            };
            ask_state_bytes = 16000;   # ask_user input is never elided; over this it is refused

            max_state_bytes = 32000;
            audit_limit = 500;
            always_deny_patterns = [
              "rm%s+%-rf%s+/" "%.ssh/id_" "%.aws/credentials"
              "^sudo%s" "%ssudo%s" "^doas%s" "%sdoas%s"
              "%-%-remote%-" "%-%-server%s" "%$NVIM%f[%W]" "NVIM_LISTEN_ADDRESS"
            ];
          };
        };

        plugins.which-key.settings.spec = [
          {
            __unkeyed-1 = "<leader>t";
            group = "straps";
          }
        ];
        keymaps = [
          {
            mode = "n";
            key = "<leader>tn";
            action = "<cmd>Straps<CR>";
            options.desc = "Straps: new session (split)";
          }
          {
            mode = "n";
            key = "<leader>tv";
            action = "<cmd>vertical Straps<CR>";
            options.desc = "Straps: new session (vsplit)";
          }
          {
            mode = "n";
            key = "<leader>tt";
            action.__raw = ''
              function()
                require("straps.ui").open_session("tab split")
              end
            '';
            options.desc = "Straps: new session (tab)";
          }
          {
            mode = "n";
            key = "<leader>tr";
            action = "<cmd>StrapsResume<CR>";
            options.desc = "Straps: resume latest (split)";
          }
          {
            mode = "n";
            key = "<leader>tV";
            action = "<cmd>vertical StrapsResume<CR>";
            options.desc = "Straps: resume latest (vsplit)";
          }
          {
            mode = "n";
            key = "<leader>tT";
            action.__raw = ''
              function()
                require("straps.ui").resume_session(nil, "tab split")
              end
            '';
            options.desc = "Straps: resume latest (tab)";
          }
          {
            mode = "n";
            key = "<leader>tR";
            action = "<cmd>StrapsResume!<CR>";
            options.desc = "Straps: resume session (picker)";
          }
          {
            mode = "n";
            key = "<leader>ta";
            action = "<cmd>StrapsAgents<CR>";
            options.desc = "Straps: agents buffer";
          }
          {
            mode = "n";
            key = "<leader>ts";
            action = ":StrapsSearch ";
            options.desc = "Straps: search transcripts";
          }
          {
            mode = "n";
            key = "<leader>tm";
            action = "<cmd>StrapsModel<CR>";
            options.desc = "Straps: pick model";
          }
          {
            mode = "n";
            key = "<leader>te";
            action = "<cmd>StrapsEffort<CR>";
            options.desc = "Straps: pick effort";
          }
          {
            mode = "n";
            key = "<leader>tp";
            action = "<cmd>StrapsProvider<CR>";
            options.desc = "Straps: pick provider";
          }
        ];
        autoCmd = [
          {
            event = [ "FileType" ];
            pattern = [ "straps" ];
            desc = "straps session run-control keymaps";
            callback.__raw = ''
              function(ev)
                local maps = {
                  { "<leader>tx", "<cmd>StrapsStop<CR>", "Straps: stop run" },
                  { "<leader>tc", "<cmd>StrapsContinue<CR>", "Straps: continue run" },
                  { "<leader>tg", ":StrapsSteer ", "Straps: steer run" },
                  { "<leader>tk", "<cmd>StrapsCompact<CR>", "Straps: compact session" },
                  { "<leader>tN", "<cmd>StrapsRename<CR>", "Straps: rename session" },
                  { "<leader>tu", ":StrapsAuto ", "Straps: auto permissions" },
                }
                for _, m in ipairs(maps) do
                  vim.keymap.set("n", m[1], m[2], { buffer = ev.buf, desc = m[3] })
                end
              end
            '';
          }
        ];
      };
    };
}
