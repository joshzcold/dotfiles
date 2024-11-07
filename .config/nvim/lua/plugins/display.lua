return {
  {
    "shortcuts/no-neck-pain.nvim",
    lazy = true,
    cmd = {
      "NoNeckPain",
    },
    init = function()
      vim.keymap.set("n", "<leader>zn", function()
        vim.cmd([[:NoNeckPain]])
      end, { desc = "No Neck Pain" })
    end,
    config = function()
      require("no-neck-pain").setup({
        width = 200,
        buffers = {
          -- scratchPad = {
          --   enabled = true
          -- }
        },
      })
    end,
  },
  {
    "folke/noice.nvim",
    config = function()
      -- require("noice").setup({
      -- 	-- add any options here
      -- 	cmdline = {
      -- 		view = "cmdline",
      -- 	},
      -- 	lsp = {
      -- 		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      -- 		override = {
      -- 			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      -- 			["vim.lsp.util.stylize_markdown"] = true,
      -- 			["cmp.entry.get_documentation"] = true,
      -- 		},
      -- 		routes = {
      -- 			{
      -- 				view = "cmdline",
      -- 				filter = {
      -- 					any = {
      -- 						{ event = "msg_show", kind = "confirm_sub" },
      -- 					},
      -- 				},
      -- 			},
      -- 			{
      -- 				view = "notify",
      -- 				filter = { event = "msg_showmode" },
      -- 			},
      -- 		},
      -- 	},
      -- 	messages = {
      -- 		enabled = true,
      -- 	},
      -- 	notify = {
      -- 		enabled = true,
      -- 	},
      -- 	-- you can enable a preset for easier configuration
      -- 	presets = {
      -- 		bottom_search = true, -- use a classic bottom cmdline for search
      -- 		command_palette = true, -- position the cmdline and popupmenu together
      -- 		long_message_to_split = false, -- long messages will be sent to a split
      -- 		inc_rename = false, -- enables an input dialog for inc-rename.nvim
      -- 		lsp_doc_border = true, -- add a border to hover docs and signature help
      -- 	},
      -- })
    end,
    dependencies = {
      {
        "MunifTanjim/nui.nvim",
      },
      -- {
      --   "rcarriga/nvim-notify",
      --   config = function()
      --     require("notify").setup({
      --       fps = 30,
      --       timeout = 1500,
      --       render = "compact",
      --       top_down = false,
      --       stages = "static",
      --       minimum_width = 5,
      --     })
      --     vim.notify = require("notify")
      --   end,
      -- },
    },
  },
  -- fancy editing mode for less distraction
  {
    "Pocco81/true-zen.nvim",
    dependencies = { "folke/twilight.nvim" },
    init = function()
      vim.keymap.set("n", "<leader>zz", function()
        vim.cmd([[:TZAtaraxis]])
      end, { desc = "Zen Mode" })
    end,
    cmd = { "TZAtaraxis" },
    config = function()
      require("true-zen").setup({
        modes = {
          ataraxis = {
            shade = "dark",          -- if `dark` then dim the padding windows, otherwise if it's `light` it'll brighten said windows
            backdrop = 0,            -- percentage by which padding windows should be dimmed/brightened. Must be a number between 0 and 1. Set to 0 to keep the same background color
            minimum_writing_area = { -- minimum size of main window
              width = 180,
              height = 44,
            },
            quit_untoggles = true, -- type :q or :qa to quit Ataraxis mode
            padding = {            -- padding windows
              left = 52,
              right = 52,
              top = 0,
              bottom = 0,
            },
            callbacks = { -- run functions when opening/closing Ataraxis mode
              open_pre = nil,
              open_pos = nil,
              close_pre = nil,
              close_pos = nil,
            },
          },
        },
        integrations = {
          twilight = true, -- enable twilight (ataraxis)
          lualine = true,  -- hide nvim-lualine (ataraxis)
        },
      })
    end,
  },
  {
    "stevearc/dressing.nvim",
    opts = {},
  },
  {
    "kevinhwang91/nvim-bqf",
    opts = {},
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      callout = {
        story = { raw = '[!STORY]', rendered = '  Story', highlight = 'RenderMarkdownHint' },
        spike = { raw = '[!SPIKE]', rendered = '  Spike', highlight = 'RenderMarkdownInfo' },
      }
    },
    init = function()
      local prefix = "RenderMarkdown"
      vim.api.nvim_set_hl(0, prefix .. "Code", { bg = "#151b23" })
      vim.api.nvim_set_hl(0, prefix .. "CodeInline", { bg = "#151b23" })
      vim.api.nvim_set_hl(0, prefix .. "H4Bg", { bg = "#003F00", fg="#9ACD32" })
      vim.api.nvim_set_hl(0, prefix .. "H5Bg", { bg = "#720072", fg="#EE82EE"})
      vim.api.nvim_set_hl(0, prefix .. "H6Bg", { bg = "#000078", fg="#6A5ACD" })
    end,
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
  },
  {
    "max397574/colortils.nvim",
    cmd = { "Colortils" },
    opts = {},
  },
}
