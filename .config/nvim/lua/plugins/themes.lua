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
    version = "v1.1.2",
    config = function()
      require("github-theme").setup({
        options = {
          styles = {             -- Style to be applied to different syntax groups
            comments = "italic", -- Value is any valid attr-list value `:help attr-list`
            functions = "NONE",
            keywords = "NONE",
            variables = "NONE",
            conditionals = "NONE",
            constants = "NONE",
            numbers = "NONE",
            operators = "NONE",
            strings = "NONE",
            types = "NONE",
          },
          inverse = { -- Inverse highlight for different types
            match_paren = false,
            visual = false,
            search = false,
          },
          darken = { -- Darken floating windows and sidebar-like windows
            floats = true,
            sidebars = {
              enable = true,
              list = {}, -- Apply dark background to specific windows
            },
          },
          modules = { -- List of various plugins and additional options
            -- ...
          },
        },
        specs = {
          all = {
            syntax = {
              -- As with palettes, a specific style's value will be used over the `all`'s value.
              functions = "blue",
            },
          },
        },
      })
      vim.api.nvim_set_keymap("n", "<c-t>", ":ThemeToggleLights<cr>", {
        desc = "Toggle light dark theme",
        noremap = true,
        silent = true,
      })
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      color_overrides = {
        all = {},
        latte = {},
        frappe = {},
        macchiato = {},
        mocha = {
          base = "#0a0c0f",
        },
      },
    },
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    opts = {
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
