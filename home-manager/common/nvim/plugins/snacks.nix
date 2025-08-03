{ ... } : {
  programs.nixvim = {
    plugins.snacks = {
      enable = true;
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader><space>";
        action.__raw = ''
          function()
            Snacks.picker.smart()
          end
        '';
        options = {
          desc = "Smart Find Files";
        };
      }
      {
        mode = "n";
        key = "<leader>,";
        action.__raw = ''
          function()
            Snacks.picker.buffers()
          end
        '';
        options = {
          desc = "Buffers";
        };
      }
      {
        mode = "n";
        key = "<leader>/";
        action.__raw = ''
          function()
            Snacks.picker.grep()
          end
        '';
        options = {
          desc = "Grep";
        };
      }
      {
        mode = "n";
        key = "<leader>:";
        action.__raw = ''
          function()
            Snacks.picker.command_history()
          end
        '';
        options = {
          desc = "Command History";
        };
      }
      {
        mode = "n";
        key = "<leader>n";
        action.__raw = ''
          function()
            Snacks.picker.notifications()
          end
        '';
        options = {
          desc = "[N]otification History";
        };
      }
      {
        mode = "n";
        key = "<leader>e";
        action.__raw = ''
          function()
            Snacks.explorer()
          end
        '';
        options = {
          desc = "File [E]xplorer";
        };
      }
      # Find mappings
      {
        mode = "n";
        key = "<leader>fb";
        action.__raw = ''
          function()
            Snacks.picker.buffers()
          end
        '';
        options = {
          desc = "[F]ind [B]uffers";
        };
      }
      {
        mode = "n";
        key = "<leader>fc";
        action.__raw = ''
          function()
            Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
          end
        '';
        options = {
          desc = "[F]ind [C]onfig File";
        };
      }
      {
        mode = "n";
        key = "<leader>ff";
        action.__raw = ''
          function()
            Snacks.picker.files()
          end
        '';
        options = {
          desc = "[F]ind [F]iles";
        };
      }
      {
        mode = "n";
        key = "<leader>fg";
        action.__raw = ''
          function()
            Snacks.picker.git_files()
          end
        '';
        options = {
          desc = "[F]ind [G]it Files";
        };
      }
      {
        mode = "n";
        key = "<leader>fp";
        action.__raw = ''
          function()
            Snacks.picker.projects()
          end
        '';
        options = {
          desc = "[F]ind [P]rojects";
        };
      }
      {
        mode = "n";
        key = "<leader>fr";
        action.__raw = ''
          function()
            Snacks.picker.recent()
          end
        '';
        options = {
          desc = "[F]ind [R]ecent";
        };
      }
      # Git mappings
      {
        mode = "n";
        key = "<leader>gb";
        action.__raw = ''
          function()
            Snacks.picker.git_branches()
          end
        '';
        options = {
          desc = "[G]it [B]ranches";
        };
      }
      {
        mode = "n";
        key = "<leader>gl";
        action.__raw = ''
          function()
            Snacks.picker.git_log()
          end
        '';
        options = {
          desc = "[G]it [L]og";
        };
      }
      {
        mode = "n";
        key = "<leader>gL";
        action.__raw = ''
          function()
            Snacks.picker.git_log_line()
          end
        '';
        options = {
          desc = "[G]it [L]og Line";
        };
      }
      {
        mode = "n";
        key = "<leader>gs";
        action.__raw = ''
          function()
            Snacks.picker.git_status()
          end
        '';
        options = {
          desc = "[G]it [S]tatus";
        };
      }
      {
        mode = "n";
        key = "<leader>gS";
        action.__raw = ''
          function()
            Snacks.picker.git_stash()
          end
        '';
        options = {
          desc = "[G]it [S]tash";
        };
      }
      {
        mode = "n";
        key = "<leader>gd";
        action.__raw = ''
          function()
            Snacks.picker.git_diff()
          end
        '';
        options = {
          desc = "[G]it [D]iff (Hunks)";
        };
      }
      {
        mode = "n";
        key = "<leader>gf";
        action.__raw = ''
          function()
            Snacks.picker.git_log_file()
          end
        '';
        options = {
          desc = "[G]it Log [F]ile";
        };
      }
      # Grep mappings
      {
        mode = "n";
        key = "<leader>sb";
        action.__raw = ''
          function()
            Snacks.picker.lines()
          end
        '';
        options = {
          desc = "[S]earch [B]uffer Lines";
        };
      }
      {
        mode = "n";
        key = "<leader>sB";
        action.__raw = ''
          function()
            Snacks.picker.grep_buffers()
          end
        '';
        options = {
          desc = "[S]earch [B]uffers Grep";
        };
      }
      {
        mode = "n";
        key = "<leader>sg";
        action.__raw = ''
          function()
            Snacks.picker.grep()
          end
        '';
        options = {
          desc = "[S]earch [G]rep";
        };
      }
      {
        mode = ["n" "x"];
        key = "<leader>sw";
        action.__raw = ''
          function()
            Snacks.picker.grep_word()
          end
        '';
        options = {
          desc = "[S]earch [W]ord";
        };
      }
      # Search mappings
      {
        mode = "n";
        key = "<leader>s\"";
        action.__raw = ''
          function()
            Snacks.picker.registers()
          end
        '';
        options = {
          desc = "[S]earch [R]egisters";
        };
      }
      {
        mode = "n";
        key = "<leader>s/";
        action.__raw = ''
          function()
            Snacks.picker.search_history()
          end
        '';
        options = {
          desc = "[S]earch History";
        };
      }
      {
        mode = "n";
        key = "<leader>sa";
        action.__raw = ''
          function()
            Snacks.picker.autocmds()
          end
        '';
        options = {
          desc = "[S]earch [A]utocmds";
        };
      }
      {
        mode = "n";
        key = "<leader>sc";
        action.__raw = ''
          function()
            Snacks.picker.command_history()
          end
        '';
        options = {
          desc = "[S]earch [C]ommand History";
        };
      }
      {
        mode = "n";
        key = "<leader>sC";
        action.__raw = ''
          function()
            Snacks.picker.commands()
          end
        '';
        options = {
          desc = "[S]earch [C]ommands";
        };
      }
      {
        mode = "n";
        key = "<leader>sd";
        action.__raw = ''
          function()
            Snacks.picker.diagnostics()
          end
        '';
        options = {
          desc = "[S]earch [D]iagnostics";
        };
      }
      {
        mode = "n";
        key = "<leader>sD";
        action.__raw = ''
          function()
            Snacks.picker.diagnostics_buffer()
          end
        '';
        options = {
          desc = "[S]earch Buffer [D]iagnostics";
        };
      }
      {
        mode = "n";
        key = "<leader>sh";
        action.__raw = ''
          function()
            Snacks.picker.help()
          end
        '';
        options = {
          desc = "[S]earch [H]elp Pages";
        };
      }
      {
        mode = "n";
        key = "<leader>sH";
        action.__raw = ''
          function()
            Snacks.picker.highlights()
          end
        '';
        options = {
          desc = "[S]earch [H]ighlights";
        };
      }
      {
        mode = "n";
        key = "<leader>si";
        action.__raw = ''
          function()
            Snacks.picker.icons()
          end
        '';
        options = {
          desc = "[S]earch [I]cons";
        };
      }
      {
        mode = "n";
        key = "<leader>sj";
        action.__raw = ''
          function()
            Snacks.picker.jumps()
          end
        '';
        options = {
          desc = "[S]earch [J]umps";
        };
      }
      {
        mode = "n";
        key = "<leader>sk";
        action.__raw = ''
          function()
            Snacks.picker.keymaps()
          end
        '';
        options = {
          desc = "[S]earch [K]eymaps";
        };
      }
      {
        mode = "n";
        key = "<leader>sl";
        action.__raw = ''
          function()
            Snacks.picker.loclist()
          end
        '';
        options = {
          desc = "[S]earch [L]ocation List";
        };
      }
      {
        mode = "n";
        key = "<leader>sm";
        action.__raw = ''
          function()
            Snacks.picker.marks()
          end
        '';
        options = {
          desc = "[S]earch [M]arks";
        };
      }
      {
        mode = "n";
        key = "<leader>sM";
        action.__raw = ''
          function()
            Snacks.picker.man()
          end
        '';
        options = {
          desc = "[S]earch [M]an Pages";
        };
      }
      {
        mode = "n";
        key = "<leader>sp";
        action.__raw = ''
          function()
            Snacks.picker.lazy()
          end
        '';
        options = {
          desc = "[S]earch for [P]lugin Spec";
        };
      }
      {
        mode = "n";
        key = "<leader>sq";
        action.__raw = ''
          function()
            Snacks.picker.qflist()
          end
        '';
        options = {
          desc = "[S]earch [Q]uickfix List";
        };
      }
      {
        mode = "n";
        key = "<leader>sR";
        action.__raw = ''
          function()
            Snacks.picker.resume()
          end
        '';
        options = {
          desc = "[S]earch [R]esume";
        };
      }
      {
        mode = "n";
        key = "<leader>su";
        action.__raw = ''
          function()
            Snacks.picker.undo()
          end
        '';
        options = {
          desc = "[S]earch [U]ndo History";
        };
      }
      {
        mode = "n";
        key = "<leader>uC";
        action.__raw = ''
          function()
            Snacks.picker.colorschemes()
          end
        '';
        options = {
          desc = "[U]tils [C]olorschemes";
        };
      }
      # LSP mappings
      {
        mode = "n";
        key = "gd";
        action.__raw = ''
          function()
            Snacks.picker.lsp_definitions()
          end
        '';
        options = {
          desc = "[G]oto [D]efinition";
        };
      }
      {
        mode = "n";
        key = "gD";
        action.__raw = ''
          function()
            Snacks.picker.lsp_declarations()
          end
        '';
        options = {
          desc = "[G]oto [D]eclaration";
        };
      }
      {
        mode = "n";
        key = "gr";
        action.__raw = ''
          function()
            Snacks.picker.lsp_references()
          end
        '';
        options = {
          desc = "[G]oto [R]eferences";
          nowait = true;
        };
      }
      {
        mode = "n";
        key = "gI";
        action.__raw = ''
          function()
            Snacks.picker.lsp_implementations()
          end
        '';
        options = {
          desc = "[G]oto [I]mplementation";
        };
      }
      {
        mode = "n";
        key = "gy";
        action.__raw = ''
          function()
            Snacks.picker.lsp_type_definitions()
          end
        '';
        options = {
          desc = "[G]oto T[y]pe Definition";
        };
      }
      {
        mode = "n";
        key = "<leader>ss";
        action.__raw = ''
          function()
            Snacks.picker.lsp_symbols()
          end
        '';
        options = {
          desc = "[S]earch LSP [S]ymbols";
        };
      }
      {
        mode = "n";
        key = "<leader>sS";
        action.__raw = ''
          function()
            Snacks.picker.lsp_workspace_symbols()
          end
        '';
        options = {
          desc = "[S]earch LSP Workspace [S]ymbols";
        };
      }
    ];
  };
}
