-- which-key mappings in lua/mappings.lua

local M = {}

---Toggle the terminal
---@param term Terminal
---@param direction string direction string to pass to Terminal
function _term_toggle(term, direction)
  local width = vim.o.columns
  local set_width = width / 3
  term:toggle(set_width, direction)
end

---
---@param name string Name of the terminal created
---@param cmd string Command to execute
---@param direction string ToggleTerm direction
function toggle_term(name, cmd, direction)
  local Terminal = require("toggleterm.terminal").Terminal

  local parts = vim.split(cmd, " ")

  if vim.fn.executable(parts[1]) ~= 1 then
    vim.notify(("Command: '%s' is not found in PATH"):format(parts[1]), vim.log.levels.ERROR)
  end

  M._toggle_terms = M._toggle_terms or {}

  for _, t in pairs(M._toggle_terms) do
    if t.display_name == name then
      _term_toggle(t)
      return
    end
  end

  local term = Terminal:new({
    display_name = name,
    cmd = cmd,
    -- "term-move-issue",
    hidden = true,
    direction = direction or "float",
  })
  table.insert(M._toggle_terms, term)

  _term_toggle(term, direction or "float")
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
