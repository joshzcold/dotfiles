local prettier = function()
  return {
    exe = "prettier",
    args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--double-quote"},
    stdin = true
  }
end

require('formatter').setup({
  logging = false,
  filetype = {
      javascript = {prettier},
      typescript = {prettier},
      html = {prettier},
      css = {prettier},
      scss = {prettier},
      markdown = {prettier},
      json = {prettier},
      yaml = {prettier},
      sh = {
          -- Shell Script Formatter
       function()
         return {
           exe = "shfmt",
           args = { "-i", 2 },
           stdin = true,
         }
       end,
      }
  }
})

vim.api.nvim_exec([[
augroup FormatAutogroup
  autocmd FileType sh,js,ts,css,scss,md,html,json,yaml 
   \ autocmd! BufWritePost <buffer> :FormatWrite
augroup END
]], true)
