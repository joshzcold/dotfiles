return {
  {
    "simnalamburt/vim-mundo",
    lazy = true,
    cmd = {"MundoToggle"},
    init = function()
      vim.   keymap.set("n", "<leader>ju", function()
        vim.cmd([[:MundoToggle]])
      end, { desc = "Undo Tree" })
    end
  },
}
