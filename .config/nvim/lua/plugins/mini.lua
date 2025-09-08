return {
  "echasnovski/mini.nvim",
  version = false,
  config = function()
    -- enable mini modules
    -- - bracket navigation
    -- -- :h *mini.bracketed*
    require("mini.bracketed").setup()
    require("mini.icons").setup()
    require("mini.test").setup()
    -- - animate
    -- -- :h mini.animate
    -- require('mini.animate').setup()
  end,
}
