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
    '<cmd>lua require"telescope.builtin".find_files({ })<cr>',
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
      [[<cmd>lua require('telescope.builtin').live_grep{only_sort_text = true}<CR>]],
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
  },
  g = {
    name = "git",
    g = {
      [[<cmd>Git<cr>]],
      "Git",
    },
    p = {
      [[<cmd>call GitPush()<cr>]],
      "Git Sync",
    },
    d = {
      [[<cmd>Gdiffsplit!<cr>]],
      "Git Diff Split",
    },
  },
  t = { [[<cmd>ToggleTerm size=120 direction=vertical<cr>]], "Term" },
}, { prefix = "<leader>" })
