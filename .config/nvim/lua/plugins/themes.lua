vim.api.nvim_create_user_command("ThemeToggleLights", function()
  local ison = vim.g.theme_toggle_lights
  if ison == nil or ison == false then
    vim.cmd([[
      colorscheme github_light_default
    ]])
    vim.g.theme_toggle_lights = true
  else
    vim.cmd([[
      colorscheme github_dark_default
    ]])
    vim.g.theme_toggle_lights = false
  end
end, {})

return {
  {
    "projekt0n/github-nvim-theme",
    version = "v0.0.7",
    config = function()
      require("github-theme").setup({
        -- options = {
        --   transparent = true,
        -- },
      })
      vim.api.nvim_set_keymap("n", "<c-t>", ":ThemeToggleLights<cr>", {
        desc = "Toggle light dark theme",
        noremap = true,
        silent = true,
      })
    end,
  },
}
