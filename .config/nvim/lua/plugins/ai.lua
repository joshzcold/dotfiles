return {
  {
    "folke/sidekick.nvim",
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
      vim.g.opencode_opts = {}

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
        toggle_term("OpenCode", "opencode", "vertical")
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
