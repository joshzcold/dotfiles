-- which-key mappings in lua/mappings.lua
function toggle_term(cmd)
  -- body
    local Terminal = require("toggleterm.terminal").Terminal
    local term = Terminal:new({ cmd = cmd,
      -- "term-move-issue",
    hidden = true, direction = "float" })

    function _term_toggle()
      term:toggle()
    end
    vim.cmd([[:lua _term_toggle()]])
    vim.api.nvim_buf_set_keymap(0, "t", "<c-j>", "<down>", { silent = true })
    vim.api.nvim_buf_set_keymap(0, "t", "<c-k>", "<up>", { silent = true })
end
