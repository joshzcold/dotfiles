local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Ansible specific
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"yaml.ansible"},
  callback = function ()
    map("n", "<leader>lab", "Iansible.builtin.")
  end
})
