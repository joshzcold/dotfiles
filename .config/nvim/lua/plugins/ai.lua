return {
  {
    "coder/claudecode.nvim",
    enabled = true,
    dependencies = { "folke/snacks.nvim", "akinsho/toggleterm.nvim" },
    opts = {
      terminal = {
        split_side = "right",
        split_width_percentage = 0.30,
        provider = (function()
          local term = nil

          local function get_width(cfg)
            local pct = (cfg and cfg.split_width_percentage) or 0.30
            return math.floor(vim.o.columns * pct)
          end

          local function is_alive()
            return term ~= nil and term.bufnr ~= nil and vim.api.nvim_buf_is_valid(term.bufnr)
          end

          local function create_and_open(cmd, env, cfg)
            local Terminal = require("toggleterm.terminal").Terminal
            if term then
              pcall(function() term:shutdown() end)
              term = nil
            end
            term = Terminal:new({
              display_name = "Claude Code",
              cmd = cmd,
              env = env,
              hidden = true,
              direction = "vertical",
              close_on_exit = true,
              on_close = function() term = nil end,
            })
            term:open(get_width(cfg), "vertical")
            vim.cmd("startinsert")
          end

          local function find_term_win()
            if not is_alive() then return nil end
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if vim.api.nvim_win_get_buf(win) == term.bufnr then
                return win
              end
            end
          end

          return {
            setup = function(_cfg) end,

            open = function(cmd, env, cfg, _focus)
              if is_alive() then
                if not term:is_open() then
                  term:open(get_width(cfg), "vertical")
                end
                term:focus()
                vim.cmd("startinsert")
              else
                create_and_open(cmd, env, cfg)
              end
            end,

            close = function()
              if term then term:close() end
            end,

            simple_toggle = function(cmd, env, cfg)
              if is_alive() and term:is_open() then
                term:close()
              elseif is_alive() then
                term:open(get_width(cfg), "vertical")
                vim.cmd("startinsert")
              else
                create_and_open(cmd, env, cfg)
              end
            end,

            focus_toggle = function(cmd, env, cfg)
              if is_alive() and term:is_open() then
                local cur_win = vim.api.nvim_get_current_win()
                if find_term_win() == cur_win then
                  term:close()
                else
                  term:focus()
                  vim.cmd("startinsert")
                end
              elseif is_alive() then
                term:open(get_width(cfg), "vertical")
                vim.cmd("startinsert")
              else
                create_and_open(cmd, env, cfg)
              end
            end,

            get_active_bufnr = function()
              return is_alive() and term.bufnr or nil
            end,

            is_available = function()
              local ok = pcall(require, "toggleterm.terminal")
              return ok
            end,
          }
        end)(),
      },
    },
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>ao", "V<cmd>ClaudeCodeSend<cr>", desc = "Send line to Claude" },
      { "<leader>ao", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}
