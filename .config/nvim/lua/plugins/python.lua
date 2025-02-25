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
    opts = {
      post_set_venv = function()
        local client = vim.lsp.get_clients({ name = "basedpyright" })[1]
        if not client then
          return
        end
        local venv = require("python.venv").current_venv()
        if not venv then
          return
        end
        local venv_python = venv.path .. "/bin/python"
        if client.settings then
          client.settings = vim.tbl_deep_extend("force", client.settings, { python = { pythonPath = venv_python } })
        else
          client.config.settings =
            vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = venv_python } })
        end
        client.notify("workspace/didChangeConfiguration", { settings = nil })
      end,
      auto_create_venv = true,
      auto_create_venv_dir = ".venv",
    },

    config = function(_, opts)
      require("python").setup(opts)

      vim.api.nvim_set_keymap(
        "n",
        "<leader>pv",
        '<cmd>lua require("python.venv").pick_venv()<cr>',
        { desc = "Python pick venv" }
      )
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "python" },
        callback = function()
          require("python.venv").auto_venv()
        end,
      })
    end,
  }
}
