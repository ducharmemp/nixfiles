{ inputs, ... }:
{
  flake.homeModules.nvim-straps =
    _:
    {
      programs.nixvim = {
        imports = [ inputs.straps.nixvimModules.default inputs.straps-classifier.nixvimModules.default];
        plugins.straps.enable = true;
        plugins.straps.settings.model = "claude-opus-4-8";
        extraConfigLua = ''
          require("straps").setup({ max_spawn_depth = 2 })
        '';

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
