local utils = require("telescope.utils")
local set_var = vim.api.nvim_set_var

vim.g.dashboard_custom_header = {
  " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
  " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
  " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
  " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
  " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
  " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
}

vim.g.dashboard_custom_shortcut = {
  last_session = " ",
  find_history = " ",
  find_file = "SPC SPC",
  new_file = " ",
  change_colorscheme = " ",
  find_word = " ",
  book_marks = " ",
}

local function get_dashboard_git_status()
  local git_cmd = { "git", "status", "-s", "--", "." }
  local output = utils.get_os_command_output(git_cmd)
  set_var("dashboard_custom_footer", { "Git status", "", unpack(output) })
end

if ret ~= 0 then
  local is_worktree = utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" }, vim.loop.cwd())
  if is_worktree[1] == "true" then
    get_dashboard_git_status()
  else
    set_var("dashboard_custom_footer", { "Not in a git directory" })
  end
else
  get_dashboard_git_status()
end

vim.g.dashboard_custom_section = {
  a_projects = {
    description = { "  Open Projects                              " },
    command = ":e " .. os.getenv("HOME") .. "/git",
  },

  c_history = {
    description = { "  Search History                             " },
    command = "Telescope oldfiles",
  },

  d_find_files = {
    description = { "  Find a file in the current directory       " },
    command = "Telescope find_files",
  },
}
