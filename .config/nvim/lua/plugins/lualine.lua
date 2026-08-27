return {
  {
    "hoob3rt/lualine.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
    config = function()
      -- User Functions
      local repo_name_cache = {}

      -- Statusline components run on every redraw, so this reads .git/config
      -- directly and caches per repo root rather than spawning git.
      local function GetRepoName()
        local root = vim.fs.root(0, ".git")
        if not root then
          return ""
        end
        if repo_name_cache[root] then
          return repo_name_cache[root]
        end

        local name = vim.fs.basename(root)
        local gitconfig = root .. "/.git/config"
        if vim.uv.fs_stat(gitconfig) then
          for _, line in ipairs(vim.fn.readfile(gitconfig)) do
            local url = line:match("^%s*url%s*=%s*(.-)%s*$")
            if url then
              name = url:gsub("%.git$", ""):gsub("/+$", ""):match("([^/:]+)$") or name
              break
            end
          end
        end

        repo_name_cache[root] = name
        return name
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
            function()
              return vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
            end
          },
          lualine_x = {
            "filetype",
            {
              "python",
              cond = function()
                return vim.bo.filetype == "python"
              end,
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
