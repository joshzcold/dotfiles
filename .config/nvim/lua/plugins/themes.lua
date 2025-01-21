vim.api.nvim_create_user_command("ThemeToggleLights", function()
  local ison = vim.g.theme_toggle_lights
  if ison == nil or ison == false then
    vim.o.background = "dark"
    vim.cmd([[colorscheme kanagawa ]])
    vim.g.theme_toggle_lights = false
  else
    vim.o.background = "light"
    vim.cmd([[colorscheme kanagawa-lotus ]])
    vim.g.theme_toggle_lights = true
  end
end, {})

return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    opts = {
      overrides = function(colors)
        return {
          WinSeparator = { fg = colors.palette.dragonBlack6 }
        }
      end,
      colors = { -- add/modify theme and palette colors
        palette = {},
        theme = {
          wave = {},
          lotus = {},
          dragon = {},
          all = {
            ui = {
              bg = "#0a0c0f",
              bg_gutter = "none",
            },
          },
        },
      },
    },
  },
}
