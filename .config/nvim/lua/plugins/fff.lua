return {
  {
    "dmtrKovalenko/fff.nvim",
    build = "cargo build --release",
    -- or if you are using nixos
    -- build = "nix run .#release",
    opts = {

      max_threads = 8, -- Maximum threads for fuzzy search
      -- pass here all the options
      -- Keymaps
      keymaps = {
        close = '<Esc>',
        select = '<CR>',
        select_split = '<C-s>',
        select_vsplit = '<C-v>',
        select_tab = '<C-t>',
        move_up = { '<Up>', '<C-k>' }, -- Multiple bindings supported
        move_down = { '<Down>', '<C-j>' },
        preview_scroll_up = '<C-u>',
        preview_scroll_down = '<C-d>',
        toggle_debug = '<F2>', -- Toggle debug scores display
      },
    },
    keys = {
      {
        "ff",                         -- try it if you didn't it is a banger keybinding for a picker
        function()
          require("fff").find_files() -- or find_in_git_root() if you only want git files
        end,
        desc = "Open file picker",
      },
    },
  }
}
