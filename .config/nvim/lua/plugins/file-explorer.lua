return {
  {
    "echasnovski/mini.files",
    version = false,
    enabled = false,
    opts = {
      mappings = {
        go_in_plus = 'l'
      }
    },
    init = function()
      vim.keymap.set("n", "<leader>/e", function()
        require("mini.files").open()
      end, { desc = "Open oil file explorer" })
    end,
  },
  {
    "stevearc/oil.nvim",
    enabled = false,
    opts = {
      keymaps = {
        ["<bs>"] = "actions.parent",
      },
    },
    init = function()
      vim.keymap.set("n", "<leader>/e", "<cmd>Oil<cr>", { desc = "Open oil file explorer" })
    end,
  },
  {
    {
      "kyazdani42/nvim-tree.lua",
      enabled = true,
      dependencies = {
        { "nvim-tree/nvim-web-devicons" },
      },
      init = function()
        vim.keymap.set("n", "<leader>/e", function()
          vim.cmd([[:NvimTreeFindFileToggle]])
        end, { desc = "Open nvim-tree" })
      end,
      config = function()
        -- local tree_cb = require("nvim-tree.config").nvim_tree_callback
        --
        local M = {}

        function M.on_attach(bufnr)
          local api = require("nvim-tree.api")
          -- BEGIN_DEFAULT_ON_ATTACH
          local opts = function(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end
          vim.keymap.set("n", "<C-]>", api.tree.change_root_to_node, opts("CD"))
          vim.keymap.set("n", "<C-e>", api.node.open.replace_tree_buffer, opts("Open: In Place"))
          vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts("Info"))
          vim.keymap.set("n", "<C-r>", api.fs.rename_sub, opts("Rename: Omit Filename"))
          vim.keymap.set("n", "<C-t>", api.node.open.tab, opts("Open: New Tab"))
          vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts("Open: Vertical Split"))
          vim.keymap.set("n", "<C-x>", api.node.open.horizontal, opts("Open: Horizontal Split"))
          vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, opts("Close Directory"))
          vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
          vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
          vim.keymap.set("n", "h", api.node.open.edit, opts("Open"))
          vim.keymap.set("n", "<Tab>", api.node.open.preview, opts("Open Preview"))
          vim.keymap.set("n", ">", api.node.navigate.sibling.next, opts("Next Sibling"))
          vim.keymap.set("n", "<", api.node.navigate.sibling.prev, opts("Previous Sibling"))
          vim.keymap.set("n", ".", api.node.run.cmd, opts("Run Command"))
          vim.keymap.set("n", "-", api.tree.change_root_to_parent, opts("Up"))
          vim.keymap.set("n", "a", api.fs.create, opts("Create"))
          vim.keymap.set("n", "bmv", api.marks.bulk.move, opts("Move Bookmarked"))
          vim.keymap.set("n", "B", api.tree.toggle_no_buffer_filter, opts("Toggle No Buffer"))
          vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
          vim.keymap.set("n", "C", api.tree.toggle_git_clean_filter, opts("Toggle Git Clean"))
          vim.keymap.set("n", "[c", api.node.navigate.git.prev, opts("Prev Git"))
          vim.keymap.set("n", "]c", api.node.navigate.git.next, opts("Next Git"))
          vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
          vim.keymap.set("n", "D", api.fs.trash, opts("Trash"))
          vim.keymap.set("n", "E", api.tree.expand_all, opts("Expand All"))
          vim.keymap.set("n", "e", api.fs.rename_basename, opts("Rename: Basename"))
          vim.keymap.set("n", "]e", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
          vim.keymap.set("n", "[e", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
          vim.keymap.set("n", "F", api.live_filter.clear, opts("Clean Filter"))
          vim.keymap.set("n", "f", api.live_filter.start, opts("Filter"))
          vim.keymap.set("n", "g?", api.tree.toggle_help, opts("Help"))
          vim.keymap.set("n", "gy", api.fs.copy.absolute_path, opts("Copy Absolute Path"))
          vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts("Toggle Dotfiles"))
          vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, opts("Toggle Git Ignore"))
          vim.keymap.set("n", "J", api.node.navigate.sibling.last, opts("Last Sibling"))
          vim.keymap.set("n", "K", api.node.navigate.sibling.first, opts("First Sibling"))
          vim.keymap.set("n", "m", api.marks.toggle, opts("Toggle Bookmark"))
          vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
          vim.keymap.set("n", "O", api.node.open.no_window_picker, opts("Open: No Window Picker"))
          vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
          vim.keymap.set("n", "P", api.node.navigate.parent, opts("Parent Directory"))
          vim.keymap.set("n", "q", api.tree.close, opts("Close"))
          vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
          vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
          vim.keymap.set("n", "s", api.node.run.system, opts("Run System"))
          vim.keymap.set("n", "S", api.tree.search_node, opts("Search"))
          vim.keymap.set("n", "U", api.tree.toggle_custom_filter, opts("Toggle Hidden"))
          vim.keymap.set("n", "W", api.tree.collapse_all, opts("Collapse"))
          vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
          vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
          vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts("Copy Relative Path"))
          vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
          vim.keymap.set("n", "<2-RightMouse>", api.tree.change_root_to_node, opts("CD"))
          -- END_DEFAULT_ON_ATTACH
        end

        require("nvim-tree").setup({
          disable_netrw = false,
          hijack_netrw = false,
          on_attach = M.on_attach,
          sync_root_with_cwd = true,
          respect_buf_cwd = true,
          view = {
            width = "20%",
          },
        })
      end,
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    init = function()
      vim.keymap.set("n", "<leader>/e", function()
        vim.cmd([[:NeoTreeFocusToggle]])
      end, { desc = "Open nvim-tree" })
    end,
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      { "nvim-tree/nvim-web-devicons" },
    },
    config = function()
      require("neo-tree").setup({
        renderers = {
          directory = {
            { "indent" },
            { "icon" },
            { "current_filter" },
            {
              "container",
              content = {
                { "name",      zindex = 10 },
                {
                  "symlink_target",
                  zindex = 10,
                  highlight = "NeoTreeSymbolicLinkTarget",
                },
                { "clipboard", zindex = 10 },
                {
                  "diagnostics",
                  errors_only = true,
                  zindex = 20,
                  align = "right",
                  hide_when_expanded = true,
                },
                { "git_status", zindex = 20, align = "right", hide_when_expanded = true },
              },
            },
          },
          file = {
            { "indent" },
            { "icon" },
            {
              "container",
              content = {
                {
                  "name",
                  zindex = 10,
                },
                {
                  "symlink_target",
                  zindex = 10,
                  highlight = "NeoTreeSymbolicLinkTarget",
                },
                { "clipboard",   zindex = 10 },
                { "bufnr",       zindex = 10 },
                { "modified",    zindex = 20, align = "right" },
                { "diagnostics", zindex = 20, align = "right" },
                { "git_status",  zindex = 20, align = "right" },
              },
            },
          },
          message = {
            { "indent", with_markers = false },
            { "name",   highlight = "NeoTreeMessage" },
          },
          terminal = {
            { "indent" },
            { "icon" },
            { "name" },
            { "bufnr" },
          },
        },
        default_component_configs = {
          icon = {
            folder_empty = "󰜌",
            folder_empty_open = "󰜌",
          },
          git_status = {
            symbols = {
              renamed = "󰁕",
              unstaged = "󰄱",
            },
          },
        },
        document_symbols = {
          kinds = {
            File = { icon = "󰈙", hl = "Tag" },
            Namespace = { icon = "󰌗", hl = "Include" },
            Package = { icon = "󰏖", hl = "Label" },
            Class = { icon = "󰌗", hl = "Include" },
            Property = { icon = "󰆧", hl = "@property" },
            Enum = { icon = "󰒻", hl = "@number" },
            Function = { icon = "󰊕", hl = "Function" },
            String = { icon = "󰀬", hl = "String" },
            Number = { icon = "󰎠", hl = "Number" },
            Array = { icon = "󰅪", hl = "Type" },
            Object = { icon = "󰅩", hl = "Type" },
            Key = { icon = "󰌋", hl = "" },
            Struct = { icon = "󰌗", hl = "Type" },
            Operator = { icon = "󰆕", hl = "Operator" },
            TypeParameter = { icon = "󰊄", hl = "Type" },
            StaticMethod = { icon = "󰠄 ", hl = "Function" },
          },
        },
        -- Add this section only if you've configured source selector.
        source_selector = {
          sources = {
            { source = "filesystem", display_name = " 󰉓 Files " },
            { source = "git_status", display_name = " 󰊢 Git " },
          },
        },
        -- Other options ...
        window = {
          position = "left",
          width = 40,
          mapping_options = {
            noremap = true,
            nowait = true,
          },
          mappings = {
            ["<space>"] = {
              "toggle_node",
              nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
            },
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            ["<esc>"] = "revert_preview",
            ["P"] = { "toggle_preview", config = { use_float = true } },
            ["l"] = "open",
            ["h"] = "close_node",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            -- ["S"] = "split_with_window_picker",
            -- ["s"] = "vsplit_with_window_picker",
            ["t"] = "open_tabnew",
            ["/"] = "",
            -- ["<cr>"] = "open_drop",
            -- ["t"] = "open_tab_drop",
            ["w"] = "open_with_window_picker",
            --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
            ["C"] = "close_node",
            -- ['C'] = 'close_all_subnodes',
            ["z"] = "close_all_nodes",
            --["Z"] = "expand_all_nodes",
            ["a"] = {
              "add",
              -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
              -- some commands may take optional config options, see `:h neo-tree-mappings` for details
              config = {
                show_path = "none", -- "none", "relative", "absolute"
              },
            },
            ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
            -- ["c"] = {
            --  "copy",
            --  config = {
            --    show_path = "none" -- "none", "relative", "absolute"
            --  }
            --}
            ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
          },
        },
      })
    end,
  },
}
