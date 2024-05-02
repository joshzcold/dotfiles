return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = {
          "nvim-neotest/nvim-nio"
        },
        config = function()
          require("dapui").setup()
        end,
      },
      {
        "mfussenegger/nvim-dap-python",
        config = function()
          require("dap-python").setup()
        end
      },
      { "theHamsta/nvim-dap-virtual-text" },
    },
    init = function()
      vim.keymap.set("n", "<leader>dac", function()
        require("dap").continue()
      end, { desc = "Continue" })

      vim.keymap.set("n", "<leader>dav", function()
        require("dap").step_over()
      end, { desc = "Step Over" })

      vim.keymap.set("n", "<leader>dai", function()
        require("dap").step_into()
      end, { desc = "Step Into" })

      vim.keymap.set("n", "<leader>dao", function()
        require("dap").step_out()
      end, { desc = "Step Out" })

      vim.keymap.set("n", "<leader>dhh", function()
        require("dap.ui.variables").hover()
      end, { desc = "Hover" })

      vim.keymap.set("n", "<leader>dhv", function()
        require("dap.ui.variables").hover()
      end, { desc = "Visual Hover" })

      vim.keymap.set("n", "<leader>duo", function()
        require("dapui").toggle()
      end, { desc = "Toggle UI" })

      vim.keymap.set("n", "<leader>duh", function()
        require("dap.ui.widgets").hover()
      end, { desc = "UI Hover" })

      vim.keymap.set("n", "<leader>duf", function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.scopes)
      end, { desc = "Float" })

      vim.keymap.set("n", "<leader>dro", function()
        require("dap").repl.open()
      end, { desc = "Open" })

      vim.keymap.set("n", "<leader>drl", function()
        require("dap").repl.run_last()
      end, { desc = "Run Last" })

      vim.keymap.set("n", "<leader>dbc", function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Breakpoint Condition" })

      vim.keymap.set("n", "<leader>dbm", function()
        require("dap").set_breakpoint({ nil, nil, vim.fn.input("Log point message: ") })
      end, { desc = "Log point Message" })

      vim.keymap.set("n", "<leader>dbt", function()
        require("dap").toggle_breakpoint()
      end, { desc = "Create" })

      vim.keymap.set("n", "<leader>dbi", function()
        require("dap").toggle()
      end, { desc = "Scopes" })
    end,
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },
}
