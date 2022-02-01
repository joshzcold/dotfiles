require("which-key").setup({
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = true, -- adds help for operators like d, y, ... And registers them for motion / text object completion
      motions = false, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = false, -- default bindings on <c-w>
      nav = false, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  -- operators = { gc = "Comments" },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    -- ["<space>"] = "SPC",
    -- ["<cr>"] = "RET",
    -- ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = "<c-d>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>", -- binding to scroll up inside the popup
  },
  window = {
    border = "none", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0,
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
  ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = "auto", -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k" },
    v = { "j", "k" },
  },
})

--Add leader shortcuts
-- Large WhichKey mappings
local wk = require("which-key")
-- As an example, we will the create following mappings:
--  * <leader>ff find files
--  * <leader>fr show recent files
--  * <leader>fb Foobar
-- we'll document:
--  * <leader>fn new file
--  * <leader>fe edit file
-- and hide <leader>1

wk.register({
  [" "] = {
    function()
      require("telescope.builtin").find_files({})
    end,
    "Find File",
  },
  f = {
    name = "file", -- optional group name
    f = {
      "<cmd>HopWord<cr>",
      "Find File",
    }, -- create a binding with label
    l = {
      "<cmd>HopLine<cr>",
      "Find File",
    }, -- create a binding with label
  },
  b = {
    name = "buffers",
    b = {
      [[<cmd>lua require('telescope.builtin').buffers()<CR>]],
      "List Buffers",
    },
    d = {
      [[<cmd>:bn|:bd#<cr>]],
      "Delete Buffer",
    },
    x = {
      "<cmd>:%bd|e#<cr>",
      "delete-other-buffers",
    },
  },
  j = {
    name = "misc",
    ["="] = {
      [[<cmd>normal mqHmwgg=G`wzt`q<cr>]],
      "Indent File",
    },
    j = {
      [[<cmd>call JenkinsLint()<cr>]],
      "Jenkins Lint",
    },
    u = {
      [[<cmd>MundoToggle<cr>]],
      "Undo Tree",
    },
    s = {
      [[<cmd>syntax sync fromstart<cr>]],
      "Restart Syntax",
    },
  },
  v = {
    name = "vim",
    r = {
      [[<cmd>source $MYVIMRC<cr>]],
      "Refresh Config",
    },
    e = {
      [[<cmd>e $MYVIMRC | cd ~/.config/nvim/ <cr>]],
      "Edit Config",
    },
  },
  ["/"] = {
    name = "search",
    ["/"] = {
      function()
        require("telescope.builtin").live_grep({
          only_sort_text = true,
        })
      end,
      "Grep Directory",
    },
    e = {
      [[<cmd>NvimTreeToggle<cr>]],
      "Explorer",
    },
  },
  s = {
    name = "subsitute",
    u = {
      [[<cmd>%!uniq]],
      "delete-duplicate-lines",
    },
    ["1"] = {
      [[<cmd>g/^\_$\n\_^$/d<cr>]],
      "clear >1 blank lines",
    },
    ["2"] = {
      [[<cmd>g/^\_$\n\_^$\n\_^$/d<cr>]],
      "clear >2 blank lines",
    },
    ["0"] = {
      [[<cmd>g/^\s*$/d<cr>]],
      "clear all blank lines",
    },
    ["w"] = {
      [[<cmd>%s/\s\+$//e<cr>]],
      "clear trailing white space",
    },
  },
  g = {
    name = "git",
    l = {
      function()
        local Terminal = require("toggleterm.terminal").Terminal
        local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

        function _lazygit_toggle()
          lazygit:toggle()
        end
        vim.cmd([[:lua _lazygit_toggle()]])
      end,

      "lazy git",
    },
    g = {
      [[<cmd>Git<cr>]],
      "Git",
    },
    p = {
      [[<cmd>call GitPush()<cr>]],
      "Git Sync",
    },
    u = {
      [[<cmd>Git pull<cr>]],
      "Git Pull",
    },
    d = {
      [[<cmd>Gdiffsplit!<cr>]],
      "Git Diff Split",
    },
    c = {
      [[<cmd>Telescope git_commits<cr>]],
      "Git commits",
    },
    b = {
      function()
        local result = require("telescope.builtin").git_bcommits({
          prompt_title = "switch to commit on this buffer",
        })
        print(result)
      end,
      "Git commits buffer",
    },
  },
  y = {
    f = {
      [[<cmd>let @+ = expand("%")<cr>]],
      "Yank file relative path",
    },
    F = {
      [[<cmd>let @+ = expand("%:p")<cr>]],
      "Yank file full path",
    },
    y = {
      [[<cmd>let @+ = expand("%:t")<cr>]],
      "Yank filename",
    },
    d = {
      [[<cmd>let @+ = expand("%:p:h")<cr>]],
      "Yank directory name",
    },
  },
  t = {
    t = { [[<cmd>ToggleTerm size=10 direction=horizontal<cr>]], "Term Below" },
    l = {
      function()
        local width = vim.fn.winwidth(0)
        local set_width = width / 3
        vim.cmd(":ToggleTerm size=" .. set_width .. " direction=vertical")
      end,
      "Term Right",
    },
    h = {
      function()
        local width = vim.fn.winwidth(0)
        local set_width = width / 3
        vim.cmd(":ToggleTerm size=" .. set_width .. " direction=vertical")
      end,
      "Term Left",
    },
    j = { [[<cmd>ToggleTerm size=10 direction=horizontal<cr>]], "Term Below" },
    k = { [[<cmd>ToggleTerm direction=float<cr>]], "Term Float" },
  },
  z = {
    g = {
      [[<cmd> SpellCheck | cdo norm zg <cr>]],
      "add all spelling mistakes to dictionary"
    }
  }
}, { prefix = "<leader>" })
