return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>ao", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
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
