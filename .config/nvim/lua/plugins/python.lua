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
    enable = false,
    ---@type python.Config
    opts = { ---@diagnostic disable-line: missing-fields`
      auto_venv_lsp_attach_patterns = { "*.py" },
      python_lua_snippets = true,
    },
    keys = {
      { "<leader>pv", "<cmd>Python venv pick<cr>", desc = "python.nvim: pick venv" },
      { "<leader>pi", "<cmd>Python venv install<cr>", desc = "python.nvim: python venv install" },
      { "<leader>pd", "<cmd>Python dap<cr>", desc = "python.nvim: python run debug program" },

      -- Test Actions
      { "<leader>ptt", "<cmd>Python test test<cr>", desc = "python.nvim: python run test suite" },
      { "<leader>ptm", "<cmd>Python test test_method<cr>", desc = "python.nvim: python run test method" },
      { "<leader>ptf", "<cmd>Python test test_file<cr>", desc = "python.nvim: python run test file" },
      { "<leader>ptdd", "<cmd>Python test test_debug<cr>", desc = "python.nvim: run test suite in debug mode." },
      {
        "<leader>ptdm",
        "<cmd>Python test test_method_debug<cr>",
        desc = "python.nvim: run test method in debug mode.",
      },
      { "<leader>ptdf", "<cmd>Python test_file_debug<cr>", desc = "python.nvim: run test file in debug mode." },

      -- VEnv Actions
      { "<leader>ped", "<cmd>Python venv delete_select<cr>", desc = "python.nvim: select and delete a known venv." },
      { "<leader>peD", "<cmd>Python venv delete<cr>", desc = "python.nvim: delete current venv set." },

      -- Language Actions
      { "<leader>ppe", "<cmd>Python treesitter toggle_enumerate<cr>", desc = "python.nvim: turn list into enumerate" },
      {
        "<leader>pw",
        "<cmd>Python treesitter wrap_cursor<cr>",
        desc = "python.nvim: wrap treesitter identifier with pattern",
      },
      {
        "<leader>pw",
        mode = "v",
        ":Python treesitter wrap_cursor<cr>",
        desc = "python.nvim: wrap treesitter identifier with pattern",
      },
    },
  },
}
