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
    use({ "tpope/vim-fugitive", config = get_setup("fugitive") }) -- Git commands in nvim
    use("tpope/vim-commentary") -- "gc" to comment visual regions/lines
    -- UI to select things (files, grep results, open buffers...)
    use({
      "nvim-telescope/telescope.nvim",
      config = get_setup("telescope"),
      requires = {
        { "nvim-lua/popup.nvim" },
        { "nvim-lua/plenary.nvim" },
      },
    })
    -- use "itchyny/lightline.vim" -- Fancier statusline
    -- Add indentation guides even on blank lines
    -- use 'lukas-reineke/indent-blankline.nvim'

    -- Add git related info in the signs columns and popups
    use({
      "lewis6991/gitsigns.nvim",
      config = get_setup("gitsigns"),
      requires = {
        "nvim-lua/plenary.nvim",
      },
    })
    -- Highlight, edit, and navigate code using a fast incremental parsing library
    use({
      "nvim-treesitter/nvim-treesitter",
      config = get_setup("treesitter"),
      requires = {
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
    })
    use({ "neovim/nvim-lspconfig", config = get_setup("lspconfig") }) -- Collection of configurations for built-in LSP client
    use("https://github.com/williamboman/nvim-lsp-installer")

    use({
      "hrsh7th/nvim-cmp",
      config = get_setup("cmp"),
      requires = {
        { "quangnguyen30192/cmp-nvim-ultisnips" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-cmdline" },
      },
    })
    use("https://github.com/onsails/lspkind-nvim")
    use("joshzcold/cmp-jenkinsfile")

    use({ "folke/which-key.nvim", config = get_setup("which-key") }) -- emacs style leader preview
    use("simnalamburt/vim-mundo")
    use("https://github.com/godlygeek/tabular")

    use("SirVer/ultisnips") -- custom code snippets manager
    use("honza/vim-snippets") -- lots of pre-made snippets
    use("tpope/vim-surround") -- Vim actions to surround word with quotes
    use("sheerun/vim-polyglot")
    use("iamcco/markdown-preview.nvim")
    use("neo4j-contrib/cypher-vim-syntax")

    use("https://github.com/Pocco81/TrueZen.nvim")
    use("https://github.com/akinsho/nvim-toggleterm.lua")

    use({
      "kyazdani42/nvim-tree.lua",
      config = get_setup("nvim-tree"),
      requires = {
        { "kyazdani42/nvim-web-devicons" },
      },
    })
    use({ "https://github.com/windwp/nvim-ts-autotag", config = get_setup("nvim-ts-autotag") })
    use({ "norcalli/nvim-colorizer.lua", config = get_setup("colorizer") })
    use("tomasiser/vim-code-dark")
    use({
      "hoob3rt/lualine.nvim",
      config = get_setup("lualine"),
      requires = { "kyazdani42/nvim-web-devicons", opt = true },
    })
    use({ "phaazon/hop.nvim", config = get_setup("hop") })
    use({
      "https://github.com/windwp/nvim-autopairs",
      config = get_setup("autopairs"),
    })
    -- use ({'mhartington/formatter.nvim', config = get_setup("formatter")})
    use("https://github.com/nvim-lua/lsp-status.nvim")
    use("https://github.com/glepnir/lspsaga.nvim")
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
