require("gitlinker").setup({
  opts = {
    remote = nil, -- force the use of a specific remote
    -- adds current line nr in the url for normal mode
    add_current_line_on_normal_mode = true,
    -- callback for what to do with the url
    action_callback = require("gitlinker.actions").copy_to_clipboard,
    -- print the url after performing the action
    print_url = true,
  },
  callbacks = {
    ["bitbucket.secmet.co"] = function(url_data)
      local project, repo = string.match(url_data.repo, "(%w+)/(.*)")
      local url = "https://"
        .. url_data.host
        .. "/projects/"
        .. project
        .. "/repos/"
        .. repo
        .. "/browse/"
        .. url_data.file
        .. "?at="
        .. url_data.rev
      if url_data.lstart then
        url = url .. "#" .. url_data.lstart
      end
      return url
    end,
  },
})
