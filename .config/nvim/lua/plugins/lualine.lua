return {
  {
    "hoob3rt/lualine.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
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
            -- Get the last noice message into the bar
            {
              function()
                local message = require("noice").api.status.message.get()
                return message:sub(1, 120)
              end,
              cond = require("noice").api.status.message.has,
              color = { fg = "6b6b6b" },
            },
          },
          lualine_x = {
            "filetype",
            function()
              return require("lsp-status").status()
            end,
            {
              "swenv",
              icon = "",
              cond = function()
                return vim.bo.filetype == "python"
              end,
            },
            {
              require("noice").api.status.mode.get,
              cond = require("noice").api.status.mode.has,
              color = { fg = "ff9e64" },
            },
            {
              function()
                local is_loaded = vim.api.nvim_buf_is_loaded
                local tbl = vim.api.nvim_list_bufs()
                local loaded_bufs = 0
                for i = 1, #tbl do
                  if is_loaded(tbl[i]) then
                    loaded_bufs = loaded_bufs + 1
                  end
                end
                return loaded_bufs
              end,
              icon = "",
              color = { fg = "DarkCyan", gui = "" },
            },
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
