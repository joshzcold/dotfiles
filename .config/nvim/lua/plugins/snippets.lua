return {
    {
        "L3MON4D3/LuaSnip",
        version = "v1.2.*",
        config = function()
            local ls = require("luasnip")
            ls.filetype_extend("all", { "_" })
            require("luasnip.loaders.from_snipmate").lazy_load()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
        dependencies = {
            { "honza/vim-snippets" },
            { "rafamadriz/friendly-snippets" },
        },
    },
}
