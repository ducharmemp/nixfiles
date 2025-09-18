{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./nvim/plugins/oil.nix
    ./nvim/plugins/flash.nix
    ./nvim/plugins/treesitter.nix
    ./nvim/plugins/blink.nix
    ./nvim/plugins/lsp.nix
    ./nvim/plugins/mini.nix
    ./nvim/plugins/conform.nix
    ./nvim/plugins/snacks.nix

    inputs.nixvim.homeModules.nixvim
  ];

  nixpkgs.overlays = [
    inputs.neovim-nightly-overlay.overlays.default
  ];

  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin.enable = true;
    colorschemes.rose-pine.enable = true;
    colorscheme = "catppuccin-mocha";
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withRuby = false;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
      have_nerd_font = true;
    };

    clipboard = {
      providers = {
        wl-copy.enable = true;
        xsel.enable = true;
      };
      register = "unnamedplus";
    };

    opts = {
      number = true;
      mouse = "a";
      showmode = false;
      breakindent = true;
      undofile = true;
      ignorecase = true;
      smartcase = true;
      signcolumn = "yes";
      updatetime = 250;
      timeoutlen = 300;
      splitright = true;
      splitbelow = true;
      list = true;
      listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";
      inccommand = "split";
      cursorline = true;
      scrolloff = 10;
      confirm = true;
      hlsearch = true;
      expandtab = true;
      swapfile = false;
      termguicolors = true;
    };

    keymaps = [
      # Clear highlights on search when pressing <Esc> in normal mode
      #  See `:help hlsearch`
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
      }
      # Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
      # for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
      # is not what someone will guess without a bit more experience.
      #
      # NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
      # or just use <C-\><C-n> to exit terminal mode
      {
        mode = "t";
        key = "<Esc><Esc>";
        action = "<C-\\><C-n>";
        options = {
          desc = "Exit terminal mode";
        };
      }
      # TIP: Disable arrow keys in normal mode
      /*
      {
        mode = "n";
        key = "<left>";
        action = "<cmd>echo 'Use h to move!!'<CR>";
      }
      {
        mode = "n";
        key = "<right>";
        action = "<cmd>echo 'Use l to move!!'<CR>";
      }
      {
        mode = "n";
        key = "<up>";
        action = "<cmd>echo 'Use k to move!!'<CR>";
      }
      {
        mode = "n";
        key = "<down>";
        action = "<cmd>echo 'Use j to move!!'<CR>";
      }
      */
      # Keybinds to make split navigation easier.
      #  Use CTRL+<hjkl> to switch between windows
      #
      #  See `:help wincmd` for a list of all window commands
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w><C-h>";
        options = {
          desc = "Move focus to the left window";
        };
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w><C-l>";
        options = {
          desc = "Move focus to the right window";
        };
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w><C-j>";
        options = {
          desc = "Move focus to the lower window";
        };
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w><C-k>";
        options = {
          desc = "Move focus to the upper window";
        };
      }
      {
        mode = "n";
        key = "<C-d>";
        action = "<C-d>zz";
        options = {
          desc = "Move down half a page and center the cursor";
        };
      }
      {
        mode = "n";
        key = "<C-u>";
        action = "<C-u>zz";
        options = {
          desc = "Move up half a page and center the cursor";
        };
      }
    ];
    # https://nix-community.github.io/nixvim/NeovimOptions/autoGroups/index.html
    autoGroups = {
      kickstart-highlight-yank = {
        clear = true;
      };
    };

    # [[ Basic Autocommands ]]
    #  See `:help lua-guide-autocommands`
    # https://nix-community.github.io/nixvim/NeovimOptions/autoCmd/index.html
    autoCmd = [
      # Highlight when yanking (copying) text
      #  Try it with `yap` in normal mode
      #  See `:help vim.hl.on_yank()`
      {
        event = ["TextYankPost"];
        desc = "Highlight when yanking (copying) text";
        group = "kickstart-highlight-yank";
        callback.__raw = ''
          function()
            vim.hl.on_yank()
          end
        '';
      }
    ];

    diagnostic = {
      settings = {
        severity_sort = true;
        float = {
          border = "rounded";
          source = "if_many";
        };
        underline = {
          severity.__raw = ''vim.diagnostic.severity.ERROR'';
        };
        signs.__raw = ''
          vim.g.have_nerd_font and {
            text = {
              [vim.diagnostic.severity.ERROR] = '󰅚 ',
              [vim.diagnostic.severity.WARN] = '󰀪 ',
              [vim.diagnostic.severity.INFO] = '󰋽 ',
              [vim.diagnostic.severity.HINT] = '󰌶 ',
            },
          } or {}
        '';
        virtual_text = {
          source = "if_many";
          spacing = 2;
          format.__raw = ''
            function(diagnostic)
              local diagnostic_message = {
                [vim.diagnostic.severity.ERROR] = diagnostic.message,
                [vim.diagnostic.severity.WARN] = diagnostic.message,
                [vim.diagnostic.severity.INFO] = diagnostic.message,
                [vim.diagnostic.severity.HINT] = diagnostic.message,
              }
              return diagnostic_message[diagnostic.severity]
            end
          '';
        };
      };
    };
    extraConfigLuaPost = ''
      -- The line beneath this is called `modeline`. See `:help modeline`
      -- vim: ts=2 sts=2 sw=2 et
    '';

    plugins.sleuth.enable = true;
    plugins.fugitive.enable = true;
    plugins.direnv.enable = true;
    plugins.highlight-colors.enable = true;
    plugins.which-key.enable = true;
    plugins.nvim-bqf.enable = true;
    # plugins.nvim-ufo.enable = true;
    plugins.undotree.enable = true;
    # plugins.indent-blankline.enable = true;
    plugins.rainbow-delimiters.enable = true;
  };
}
