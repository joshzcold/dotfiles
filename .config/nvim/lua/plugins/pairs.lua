return {
    {
        "windwp/nvim-ts-autotag",
        config = function()
            require("nvim-ts-autotag").setup()
        end,
    },
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({
                ignored_next_char = "[%w%.%(%[%{%<%\"%']",
                fast_wrap = {
                    map = "<C-p>",
                    chars = { "{", "[", "(", '"', "'", "`" },
                    pattern = string.gsub([[ [%'%"%`%)%>%]%)%}%,] ]], "%s+", ""),
                    offset = 0, -- Offset from pattern match
                    end_key = "$",
                    keys = "qwertyuiopzxcvbnmasdfghjkl",
                    check_comma = true,
                    highlight = "Search",
                    highlight_grey = "Comment",
                },
            })
        end,
    },
}
