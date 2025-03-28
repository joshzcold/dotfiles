vim.api.nvim_create_user_command("BasedPyRightChangeTypeCheckingMode", function(opts)
  local clients = vim.lsp.get_clients({
    bufnr = vim.api.nvim_get_current_buf(),
    name = "basedpyright",
  })
  for _, client in ipairs(clients) do
    client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
      basedpyright = {
        analysis = {
          typeCheckingMode = opts.args,
        },
      },
    })
    print(vim.inspect(client.config.settings))
    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  end
end, {
  nargs = 1,
  count = 1,
  complete = function()
    return { "off", "basic", "standard", "strict", "all" }
  end,
})

return {
  ---@module 'python'
  {
    "joshzcold/python.nvim",
    ---@type python.Config
    opts = { ---@diagnostic disable-line: missing-fields`
      auto_venv_lsp_attach_patterns = { "*.py" },
      command_setup_filetypes = { "python" },
      python_lua_snippets = true,
    },
    dependencies = {
      { "mfussenegger/nvim-dap" },
      { "mfussenegger/nvim-dap-python" },
      { "neovim/nvim-lspconfig" },
      { "MunifTanjim/nui.nvim" },
      { "L3MON4D3/LuaSnip" }
    },
    init = function()
      vim.api.nvim_set_keymap(
        "n",
        "<leader>pv",
        '<cmd>lua require("python.venv").pick_venv()<cr>',
        { desc = "Python pick venv" }
      )
    end,
  }
}
