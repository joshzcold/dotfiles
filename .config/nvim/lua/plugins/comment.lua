-- "gc" to comment visual regions/lines{
return {
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
            local ft = require("Comment.ft")

            -- Multiple filetypes
            ft({ "groovy", "java", "Jenkinsfile" }, { "// %s", "/* %s */" })
        end,
    },
}
