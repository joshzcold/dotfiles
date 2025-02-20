-- which-key mappings in lua/mappings.lua
function toggle_term(cmd)
  -- body
  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new({
    cmd = cmd,
    -- "term-move-issue",
    hidden = true,
    direction = "float",
  })

  function _term_toggle()
    term:toggle()
  end
  vim.cmd([[:lua _term_toggle()]])
  vim.api.nvim_buf_set_keymap(0, "t", "<c-j>", "<down>", { silent = true })
  vim.api.nvim_buf_set_keymap(0, "t", "<c-k>", "<up>", { silent = true })
end

-- vim.keymap.set("n", "<leader>tl", function()
--   local width = vim.fn.winwidth(0)
--   local set_width = width / 3
--   vim.cmd(":vertical term")
--   vim.cmd(":vertical resize " .. set_width)
-- end, { desc = "Term Right" })
--
-- vim.keymap.set("n", "<leader>tj", function()
--   local height = vim.fn.winheight(0)
--   local set_height = height / 5
--   vim.cmd(":horizontal term")
--   vim.cmd(":horizontal resize " .. set_height)
-- end, { desc = "Term Below" })
