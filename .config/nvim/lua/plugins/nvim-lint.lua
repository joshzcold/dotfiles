function SetupGroovy()
    local git_cmd = vim.fn.system("git rev-parse --show-toplevel | tr -d '\n'")
    local groovy_lint = require("lint.linters.npm-groovy-lint")
    local groovy_lint_args = { "-" }
    if vim.fn.filereadable(git_cmd .. "/.groovylintrc.json") == 0 then
        table.insert(groovy_lint_args, "--config")
        table.insert(groovy_lint_args, os.getenv("HOME") .. "/.config/groovylint/groovylint.json")
    end
    groovy_lint.args = groovy_lint_args
    groovy_lint.stdin = true
    groovy_lint.env = {
        ["PATH"] = "/home/joshua/.nvm/versions/node/v12.22.12/bin",
    }
    groovy_lint.ignore_exitcode = true
    groovy_lint.append_fname = false
end

return {
    {
        "mfussenegger/nvim-lint",
        config = function()
            SetupGroovy()
            require("lint").linters_by_ft = {
                markdown = { "vale" },
                Jenkinsfile = { "npm-groovy-lint" },
                groovy = { "npm-groovy-lint" },
            }
            -- vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "TextChangedI" }, {
            --     callback = function()
            --         require("lint").try_lint()
            --     end,
            -- })
        end,
    },
}
