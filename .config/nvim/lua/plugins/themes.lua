return {
  {
    "projekt0n/github-nvim-theme",
    config = function()
      require("github-theme").setup({
        theme_style = "dark_default",
        overrides = function(c)
          -- fix the look of yaml in this color scheme
          vim.api.nvim_create_autocmd(
            "FileType",
            { pattern = { "yaml", "yaml.ansible" }, command = "hi TSField guifg=" .. c.green }
          )
          return {}
        end,
      })

    end,
  },
}
