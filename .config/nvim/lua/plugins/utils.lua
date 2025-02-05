return {
  -- smarter increment decrement G-^a
  {
    "monaqa/dial.nvim",
    config = function()
      vim.api.nvim_set_keymap("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
      vim.api.nvim_set_keymap("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
      vim.api.nvim_set_keymap("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
      vim.api.nvim_set_keymap("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
      vim.api.nvim_set_keymap("v", "g<C-a>", require("dial.map").inc_gvisual(), { noremap = true })
      vim.api.nvim_set_keymap("v", "g<C-x>", require("dial.map").dec_gvisual(), { noremap = true })
    end,
  },
  -- smarter vim dot-repeat
  { "tpope/vim-repeat" },
  -- lots of useful lua functions plugins like to use
  { "nvim-lua/plenary.nvim" },
  -- in .json files evaluate the xpath and display at top
  {
    "phelipetls/jsonpath.nvim",
    lazy = true,
    ft = "json",
  },
  {
    "cuducos/yaml.nvim",
    lazy = true,
    ft = "yaml",
  },
  -- Get a diff view on an visual selection
  { "AndrewRadev/linediff.vim" },
  -- table format text on a regex
  { "godlygeek/tabular" },

  -- follow symlinks when opening them
  -- { "aymericbeaumet/vim-symlink", dependencies = { "moll/vim-bbye" } },

  -- detects color codes in text and colors them in buffer
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  -- allows sudo password prompt inside vim
  { "lambdalisue/suda.vim",   cmd = { "SudaWrite" } },

  -- :YankMacro [register]
  { "jesseleite/nvim-macroni" },

  {
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = true,
    lazy = true,
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    event = { "User KittyScrollbackLaunch" },
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    -- version = '^2.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
      require("kitty-scrollback").setup()
    end,
  },
  -- vim script plugin for keeping case while subsituting :%S/KEEPCASE/keepcase/g
  {
    "tpope/vim-abolish",
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      quickfile = { enabled = true },
      statuscolumn = { enabled = false },
      words = { enabled = true },
      styles = {
        notification = {
          wo = { wrap = true }, -- Wrap notifications
        },
      },
    },
    keys = {
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings fjdkslfd
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle
              .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
              :map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          vim.api.nvim_create_user_command("Notifications", function()
            Snacks.notifier.show_history()
          end, {})
        end,
      })
    end,
  },
  {
    "luukvbaal/statuscol.nvim",
    config = function()
      -- local builtin = require("statuscol.builtin")
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        setopt = true, -- Whether to set the 'statuscolumn' option, may be set to false for those who
        -- want to use the click handlers in their own 'statuscolumn': _G.Sc[SFL]a().
        -- Although I recommend just using the segments field below to build your
        -- statuscolumn to benefit from the performance optimizations in this plugin.
        -- builtin.lnumfunc number string options
        thousands = false,   -- or line number thousands separator string ("." / ",")
        relculright = false, -- whether to right-align the cursor line number with 'relativenumber' set
        -- Builtin 'statuscolumn' options
        ft_ignore = nil,     -- lua table with 'filetype' values for which 'statuscolumn' will be unset
        bt_ignore = nil,     -- lua table with 'buftype' values for which 'statuscolumn' will be unset
        -- Default segments (fold -> sign -> line number + separator), explained below
        segments = {
          { text = { "%C" }, click = "v:lua.ScFa" },
          { text = { "%s" }, click = "v:lua.ScSa" },
          {
            text = { builtin.lnumfunc, " " },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          },
        },
        clickmod = "c",   -- modifier used for certain actions in the builtin clickhandlers:
        -- "a" for Alt, "c" for Ctrl and "m" for Meta.
        clickhandlers = { -- builtin click handlers
          Lnum = builtin.lnum_click,
          FoldClose = builtin.foldclose_click,
          FoldOpen = builtin.foldopen_click,
          FoldOther = builtin.foldother_click,
          DapBreakpointRejected = builtin.toggle_breakpoint,
          DapBreakpoint = builtin.toggle_breakpoint,
          DapBreakpointCondition = builtin.toggle_breakpoint,
          ["diagnostic/signs"] = builtin.diagnostic_click,
          gitsigns = builtin.gitsigns_click,
        },
      })
    end,
  },
  {
    "MagicDuck/grug-far.nvim",
    opts = {}
  },
}
