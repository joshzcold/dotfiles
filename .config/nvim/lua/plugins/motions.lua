return {
  -- {
  --   "phaazon/hop.nvim",
  --   lazy = true,
  --   cmd = {
  --     "HopWord",
  --     "HopChar1",
  --     "HopLine",
  --   },
  --   init = function()
  --     vim.keymap.set("n", "<leader>ff", function()
  --       vim.cmd([[:HopWord]])
  --     end, { desc = "Hop To Word" })
  --     vim.keymap.set("n", "<leader>fl", function()
  --       vim.cmd([[:HopLine]])
  --     end, { desc = "Hop To Line" })
  --   end,
  --   config = function()
  --     require("hop").setup()
  --   end,
  -- },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      search = {
        -- search/jump in all windows
        multi_window = true,
        -- search direction
        forward = true,
        -- when `false`, find only matches in the given direction
        wrap = true,
        ---@type Flash.Pattern.Mode
        -- Each mode will take ignorecase and smartcase into account.
        -- * exact: exact match
        -- * search: regular search
        -- * fuzzy: fuzzy search
        -- * fun(str): custom function that returns a pattern
        --   For example, to only match at the beginning of a word:
        --   mode = function(str)
        --     return "\\<" .. str
        --   end,
        mode = "fuzzy",
        -- behave like `incsearch`
        incremental = false,
        filetype_exclude = { "notify", "noice" },
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          -- default options: exact mode, multi window, all directions, with a backdrop
          require("flash").jump()
        end,
      },
      {
        "S",
        mode = { "o", "x" },
        function()
          require("flash").treesitter()
        end,
      },
    },
  },
}
