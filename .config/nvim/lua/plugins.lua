vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- Install packer
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end

vim.api.nvim_command("packadd packer.nvim")
-- returns the require for use in `config` parameter of packer's use
-- expects the name of the config file
function get_setup(name)
  return string.format('require("setup/%s")', name)
end

require("packer").startup({
  function(use)
    use("wbthomason/packer.nvim") -- Package manager
    -- neovim dap
    use({
      "mfussenegger/nvim-dap",
      config = get_setup("dap"),
      requires = {
        { "Pocco81/DAPInstall.nvim" },
        { "rcarriga/nvim-dap-ui" },
        { "theHamsta/nvim-dap-virtual-text" },
      },
    })
    use({ "folke/which-key.nvim", config = get_setup("whichkey") }) -- which-key mappings in lua/mappings.lua
    use({ "monaqa/dial.nvim" })
    use({ "tpope/vim-fugitive", config = get_setup("fugitive") }) -- Git commands in nvim
    use({ "tpope/vim-repeat" })
    use({ "numToStr/Comment.nvim", config = get_setup("comment") }) -- "gc" to comment visual regions/lines
    -- UI to select things (files, grep results, open buffers...)
    use({ "nvim-lua/plenary.nvim" })
    use({
      "nvim-telescope/telescope.nvim",
      config = get_setup("telescope"),
      requires = {
        { "nvim-lua/popup.nvim" },
        { "nvim-lua/plenary.nvim" },
      },
    })

    use({
      "nvim-telescope/telescope-fzf-native.nvim",
      run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    })
    use({ "lewis6991/gitsigns.nvim", config = get_setup("gitsigns"), tag = "release" })
    use({ "https://github.com/hoschi/yode-nvim" })
    -- Add git related info in the signs columns and popups
    -- Highlight, edit, and navigate code using a fast incremental parsing library
    use({
      "nvim-treesitter/nvim-treesitter",
      config = get_setup("treesitter"),
      requires = {
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
    })
    use({ "neovim/nvim-lspconfig", config = get_setup("lspconfig") }) -- Collection of configurations for built-in LSP client

    use({ "nvim-telescope/telescope-ui-select.nvim" })
    use({
      "kosayoda/nvim-lightbulb",
      config = function()
        require("nvim-lightbulb").setup({ autocmd = { enabled = true } })
      end,
    })
    use({ "https://github.com/williamboman/nvim-lsp-installer", config = get_setup("lspconfig") })
    use({ "L3MON4D3/LuaSnip", config = get_setup("luasnip") })
    use({
      "hrsh7th/nvim-cmp",
      config = get_setup("cmp"),
      requires = {
        { "saadparwaiz1/cmp_luasnip" },
        { "L3MON4D3/LuaSnip" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-cmdline" },
        { "https://github.com/joshzcold/cmp-rg" },
      },
    })
    use("https://github.com/AndrewRadev/linediff.vim")
    use("https://github.com/onsails/lspkind-nvim")
    use("joshzcold/cmp-jenkinsfile")

    use("simnalamburt/vim-mundo")
    use("https://github.com/godlygeek/tabular")

    use("honza/vim-snippets") -- lots of pre-made snippets
    use("tpope/vim-surround") -- Vim actions to surround word with quotes
    use("sheerun/vim-polyglot")
    use("iamcco/markdown-preview.nvim")
    use("neo4j-contrib/cypher-vim-syntax")

    use({
      "Pocco81/true-zen.nvim",
      requires = {
        "folke/twilight.nvim",
      },
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
    })

    use({
      "akinsho/toggleterm.nvim",
      tag = "v1.*",
      config = function()
        require("toggleterm").setup()
      end,
    })

    use({
      "kyazdani42/nvim-tree.lua",
      config = get_setup("nvim-tree"),
      requires = {
        { "kyazdani42/nvim-web-devicons" },
      },
    })
    use({ "https://github.com/windwp/nvim-ts-autotag", config = get_setup("nvim-ts-autotag") })
    use({ "norcalli/nvim-colorizer.lua", config = get_setup("colorizer") })
    -- use({ "/glepnir/dashboard-nvim", config = get_setup("dashboard") })
    use({ "projekt0n/github-nvim-theme", config = get_setup("theme") })
    use({ "Mofiqul/vscode.nvim", config = get_setup("theme") }) -- vscode like theme
    use({ "folke/tokyonight.nvim", config = get_setup("theme") })
    -- use({ "marko-cerovac/material.nvim", config = get_setup("theme") })
    use({ "https://github.com/lambdalisue/suda.vim" })
    use({
      "hoob3rt/lualine.nvim",
      config = get_setup("lualine"),
      requires = {
        { "kyazdani42/nvim-web-devicons", opt = true },
      },
    })
    use({ "phaazon/hop.nvim", config = get_setup("hop") })
    use({
      "https://github.com/windwp/nvim-autopairs",
      config = get_setup("autopairs"),
    })
    -- use({
    --   "https://github.com/ZhiyuanLck/smart-pairs",
    --   config = get_setup("autopairs"),
    -- })
    use("https://github.com/nvim-lua/lsp-status.nvim")
    use({
      "https://github.com/inkarkat/vim-SpellCheck",
      requires = {
        {
          "inkarkat/vim-ingo-library",
        },
      },
    })
    use({
      "danymat/neogen",
      config = function()
        require("neogen").setup({
          enabled = true,
        })
      end,
    })
    use({
      "ruifm/gitlinker.nvim",
      config = get_setup("gitlinker"),
    })
    use("folke/trouble.nvim")
    use({
      "j-hui/fidget.nvim",
      config = function()
        require("fidget").setup({ window = { winblend = 0 } })
      end,
    })
    use({ "https://github.com/jbyuki/venn.nvim", config = get_setup("venn") })
    use({
      "jose-elias-alvarez/null-ls.nvim",
      config = get_setup("null-ls"),
    })
  end,
  config = {
    display = {
      open_fn = require("packer.util").float,
    },
    profile = {
      enable = true,
      threshold = 1, -- the amount in ms that a plugins load time must be over for it to be included in the profile
    },
  },
})
