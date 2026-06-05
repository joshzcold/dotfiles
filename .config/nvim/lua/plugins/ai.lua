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
  {
    "zbirenbaum/copilot.lua",
    dependencies = {
      "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
    },
    config = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuOpen",
        callback = function()
          vim.b.copilot_suggestion_hidden = true
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuClose",
        callback = function()
          vim.b.copilot_suggestion_hidden = false
        end,
      })
      require("copilot").setup({
        nes = {
          enabled = false,
          keymap = {
            accept_and_goto = "<ctrl>p",
            accept = false,
            dismiss = "<Esc>",
          },
        },
      })
    end,
  },
  {
    "folke/sidekick.nvim",
    enabled = false,
    opts = {
      -- add any options here
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
        },
      },
    },
    keys = {
      -- {
      --   "<tab>",
      --   function()
      --     -- if there is a next edit, jump to it, otherwise apply it if any
      --     if not require("sidekick").nes_jump_or_apply() then
      --       return "<Tab>" -- fallback to normal tab
      --     end
      --   end,
      --   expr = true,
      --   desc = "Goto/Apply Next Edit Suggestion",
      -- },
      -- {
      --   "<leader>aa",
      --   function()
      --     require("sidekick.cli").toggle()
      --   end,
      --   desc = "Sidekick Toggle CLI",
      -- },
      -- {
      --   "<leader>as",
      --   function()
      --     require("sidekick.cli").select()
      --   end,
      --   -- Or to select only installed tools:
      --   -- require("sidekick.cli").select({ filter = { installed = true } })
      --   desc = "Select CLI",
      -- },
      -- {
      --   "<leader>ad",
      --   function()
      --     require("sidekick.cli").close()
      --   end,
      --   desc = "Detach a CLI Session",
      -- },
      -- {
      --   "<leader>at",
      --   function()
      --     require("sidekick.cli").send({ msg = "{this}" })
      --   end,
      --   mode = { "x", "n" },
      --   desc = "Send This",
      -- },
      -- {
      --   "<leader>af",
      --   function()
      --     require("sidekick.cli").send({ msg = "{file}" })
      --   end,
      --   desc = "Send File",
      -- },
      -- {
      --   "<leader>av",
      --   function()
      --     require("sidekick.cli").send({ msg = "{selection}" })
      --   end,
      --   mode = { "x" },
      --   desc = "Send Visual Selection",
      -- },
      -- {
      --   "<leader>ap",
      --   function()
      --     require("sidekick.cli").prompt()
      --   end,
      --   mode = { "n", "x" },
      --   desc = "Sidekick Select Prompt",
      -- },
      -- -- Example of a keybinding to open Claude directly
      -- {
      --   "<leader>ac",
      --   function()
      --     require("sidekick.cli").toggle({ name = "claude", focus = true })
      --   end,
      --   desc = "Sidekick Toggle Claude",
      -- },
    },
  },
  {
    "NickvanDyke/opencode.nvim",
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        provider = {
          enabled = "terminal",
          terminal = {},
        },
      }

      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      -- Recommended/example keymaps.
      vim.keymap.set({ "n", "x" }, "<leader>Oa", function()
        require("opencode").ask("@this: ", { submit = true })
      end, { desc = "Ask opencode" })

      vim.keymap.set({ "n", "x" }, "<leader>Ox", function()
        require("opencode").select()
      end, { desc = "Execute opencode action…" })

      vim.keymap.set({ "n" }, "<leader>to", function()
        toggle_term("OpenCode", "opencode --port", "vertical")
      end, { desc = "Toggle opencode" })

      vim.keymap.set({ "x" }, "go", function()
        return require("opencode").operator("@this ")
      end, { expr = true, desc = "Add range to opencode" })

      vim.keymap.set("n", "go", function()
        return require("opencode").operator("@this ") .. "_"
      end, { expr = true, desc = "Add line to opencode" })

      -- vim.keymap.set("n", "<S-C-u>", function()
      --   require("opencode").command("session.half.page.up")
      -- end, { desc = "opencode half page up" })
      --
      -- vim.keymap.set("n", "<S-C-d>", function()
      --   require("opencode").command("session.half.page.down")
      -- end, { desc = "opencode half page down" })
    end,
  },
}
