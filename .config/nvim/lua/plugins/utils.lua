return {
    -- smarter increment decrement G-^a
    {
        "monaqa/dial.nvim",
        config = function()
            vim.api.nvim_set_keymap("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
            vim.api.nvim_set_keymap("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
            vim.api.nvim_set_keymap("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
            vim.api.nvim_set_keymap("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
            vim.api.nvim_set_keymap("v", "g<C-a>", require("dial.map").inc_gvisual(), { noremap = true })
            vim.api.nvim_set_keymap("v", "g<C-x>", require("dial.map").dec_gvisual(), { noremap = true })
        end,
    },
    -- smarter vim dot-repeat
    { "tpope/vim-repeat" },
    -- lots of useful lua functions plugins like to use
    { "nvim-lua/plenary.nvim" },
    -- in .json files evaluate the xpath and display at top
    {
        "phelipetls/jsonpath.nvim",
        lazy = true,
        ft = "json",
    },
    -- Get a diff view on an visual selection
    { "AndrewRadev/linediff.vim" },
    -- table format text on a regex
    { "godlygeek/tabular" },

    -- open a web browser with interactive preview of markdown file
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        ft = "markdown",
        config = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        cmd = { "MarkdownPreview" },
    },

    -- follow symlinks when opening them
    { "aymericbeaumet/vim-symlink", dependencies = { "moll/vim-bbye" } },

    -- fancy editing mode for less distraction
    {
        "Pocco81/true-zen.nvim",
        dependencies = { "folke/twilight.nvim" },
        init = function()
            vim.keymap.set("n", "<leader>z", function()
                vim.cmd([[:TZAtaraxis]])
            end, { desc = "Zen Mode" })
        end,
        cmd = { "TZAtaraxis" },
        config = function()
            require("true-zen").setup({
                modes = {
                    ataraxis = {
                        shade = "dark", -- if `dark` then dim the padding windows, otherwise if it's `light` it'll brighten said windows
                        backdrop = 0, -- percentage by which padding windows should be dimmed/brightened. Must be a number between 0 and 1. Set to 0 to keep the same background color
                        minimum_writing_area = { -- minimum size of main window
                            width = 180,
                            height = 44,
                        },
                        quit_untoggles = true, -- type :q or :qa to quit Ataraxis mode
                        padding = { -- padding windows
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
                    lualine = true, -- hide nvim-lualine (ataraxis)
                },
            })
        end,
    },

    -- detects color codes in text and colors them in buffer
    { "norcalli/nvim-colorizer.lua" },
    -- allows sudo password prompt inside vim
    { "lambdalisue/suda.vim", cmd = { "SudaWrite" } },
}
