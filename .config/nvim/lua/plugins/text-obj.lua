return {
    {
        "chrisgrieser/nvim-various-textobjs",
        config = function()
            require("various-textobjs").setup({
                useDefaultKeymaps = true ,
                disabledKeymaps = {
                    "L",
                    "gc",
                    "gb"
                }
            })
        end,
    },
}
