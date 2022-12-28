return {
  {
    "hoob3rt/lualine.nvim",
    dependencies = {
      { "kyazdani42/nvim-web-devicons" },
    },
    config = function()
      -- User Functions
      local function GetRepoName()
        local handle = io.popen([[basename -s .git $(git config --get remote.origin.url) 2>/dev/null|| true]])
        local result = handle:read("*a")
        handle:close()
        if result then
          return result.gsub(result, "%s+", "")
        end
      end

      require("lualine").setup({
        options = {
          icons_enabled = true,
          globalstatus = true,
          theme = "auto",
          component_separators = { "∙", "∙" },
          section_separators = { "", "" },
          disabled_filetypes = {},
        },
        sections = {
          lualine_a = { "mode", "paste" },
          lualine_b = { GetRepoName, "branch", "diff" },

          lualine_c = {
            "filename",
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
    end,
  },
}
