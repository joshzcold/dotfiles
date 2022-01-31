-- User Functions
local function GetRepoName()
  local handle = io.popen([[basename -s .git $(git config --get remote.origin.url) 2>/dev/null|| true]])
  local result = handle:read("*a")
  if result then
    return result.gsub(result, "%s+", "")
  end
  handle:close()
end

require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "vscode",
    component_separators = { "∙", "∙" },
    section_separators = { "", "" },
    disabled_filetypes = {},
  },
  sections = {
    lualine_a = { "mode", "paste" },
    lualine_b = { GetRepoName, "branch", "diff" },

    lualine_c = {
      "filename",
      "lsp_progress",
    },
    lualine_x = {
      "filetype",
      function()
        return require("lsp-status").status()
      end,
    },
    lualine_y = {
      {
        "progress",
      },
    },
    lualine_z = {
      {
        "location",
        icon = "",
      },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
})
