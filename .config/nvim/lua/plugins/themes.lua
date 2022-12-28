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

      -- highlighting tweaks
      vim.api.nvim_set_hl(0, "SpellBad", { sp = "#325905", underline = true })
      vim.api.nvim_set_hl(0, "SpellCap", { sp = "#000c7a", underline = true })
      vim.api.nvim_set_hl(0, "SpellRare", { sp = "#000c7a", underline = true })
      vim.api.nvim_set_hl(0, "SpellLocal", { sp = "#6c007a", underline = true })

      vim.api.nvim_set_hl(0, "Search", { reverse = true })
      vim.api.nvim_set_hl(0, "Cursor", { reverse = true })
    end,
  },
}
