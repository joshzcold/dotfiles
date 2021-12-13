require("Comment").setup()
local ft = require("Comment.ft")

-- Multiple filetypes
ft({ "groovy", "java", "Jenkinsfile" }, { "// %s", "/* %s */" })
