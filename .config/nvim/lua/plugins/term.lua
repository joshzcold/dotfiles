return {
  {
    "akinsho/toggleterm.nvim",
    init = function()
      --[[
			--	Set up lots of key bindings to support up to 9 terminals at once
			--]]
      for i = 9, 1, -1 do
        local n = i
        if i == 1 then
          ---@diagnostic disable-next-line: cast-local-type
          i = ""
        end
        vim.keymap.set("n", "<leader>t" .. i .. "t", function()
          vim.cmd(":" .. n .. "ToggleTerm size=10 direction=tab")
        end, { desc = "Term Tab " .. i })

        vim.keymap.set("n", "<leader>t" .. i .. "l", function()
          local width = vim.o.columns
          local set_width = width / 3
          vim.cmd(":" .. n .. "ToggleTerm size=" .. set_width .. " direction=vertical")
        end, { desc = "Term Right " .. i })

        vim.keymap.set("n", "<leader>t" .. i .. "j", function()
          vim.cmd(":" .. n .. "ToggleTerm size=10 direction=horizontal")
        end, { desc = "Term Below " .. i })

        vim.keymap.set("n", "<leader>t" .. i .. "k", function()
          vim.cmd(":" .. n .. "ToggleTerm size=10 direction=float")
        end, { desc = "Term Float " .. i })
      end
      vim.keymap.set("n", "<leader>tx", function()
        vim.cmd([[:ToggleTermToggleAll]])
      end, { desc = "Term Toggle All" })

      vim.keymap.set("n", "<leader>t<leader>", function()
        vim.cmd([[:TermSelect]])
      end, { desc = "Term Select" })

      -- misc keymappings jira
      vim.keymap.set("n", "<leader>jb", function()
        vim.cmd([[:JiraNewBranch]])
      end, { desc = "New Jira Branch" })
      vim.keymap.set("n", "<leader>jjn", function()
        toggle_term("Jira Issue Create", "jira issue create")
      end, { desc = "New Jira issue" })
      vim.keymap.set("n", "<leader>jjc", function()
        toggle_term("Jira Add Comment", "jira-add-comment")
      end, { desc = "New Jira comment" })
      vim.keymap.set("n", "<leader>jjm", function()
        toggle_term("Jira Add Comment", "jira-add-comment")
      end, { desc = "Move Jira issue" })
      vim.keymap.set("n", "<leader>jjv", function()
        toggle_term("Jira View Issue", "jira-view-issue")
      end, { desc = "View Jira Issue" })

      -- lazy git
      vim.keymap.set("n", "<leader>gl", function()
        toggle_term("LazyGit", "lazygit")
      end, { desc = "Open Lazy Git" })
    end,
    config = function()
      require("toggleterm").setup({
        start_in_insert = true,
        auto_scroll = false,
      })
      vim.cmd([[ au TermOpen * setlocal nospell ]])

      -- The pty width isn't exposed and can differ from the window's, so infer it from the widest nearby row.
      local function wrap_width(first, last)
        local context = 200
        local nearby = vim.api.nvim_buf_get_lines(0, math.max(first - 1 - context, 0), last + context, false)
        local width = math.floor(vim.api.nvim_win_get_width(0) / 2)
        for _, row in ipairs(nearby) do
          width = math.max(width, vim.fn.strdisplaywidth(row))
        end
        return width
      end

      -- Terminal rows hard-wrap long output, so rejoin parts whose source row filled the full width.
      -- TUIs like Claude Code repeat a block's indent on each wrapped row, so drop up to that much when joining.
      local function join_rows(parts, rows, width)
        local out = { (parts[1]:gsub("\r", "")) }
        local indent = #rows[1]:match("^ *")
        for i = 2, #parts do
          local text = parts[i]:gsub("\r", "")
          if vim.fn.strdisplaywidth(rows[i - 1]) >= width then
            out[#out] = out[#out] .. text:sub(math.min(#text:match("^ *"), indent) + 1)
          else
            indent = #rows[i]:match("^ *")
            table.insert(out, text)
          end
        end
        return out
      end

      -- Blockwise yanks (<C-v>) are left untouched to keep the raw rows.
      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
          local ev = vim.v.event
          if vim.bo.buftype ~= "terminal" or ev.operator ~= "y" or ev.regtype:sub(1, 1) == "\22" then
            return
          end
          local first, last = vim.fn.line("'["), vim.fn.line("']")
          local rows = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
          local reg = ev.regname
          if reg == "" then
            reg = vim.o.clipboard:find("unnamedplus") and "+" or '"'
          end
          vim.fn.setreg(reg, join_rows(ev.regcontents, rows, wrap_width(first, last)), ev.regtype)
        end,
      })

      -- Opens the URL under the mouse, rebuilding it first if the terminal wrapped it across rows.
      local function open_url_at_mouse()
        local pos = vim.fn.getmousepos()
        if pos.winid == 0 or pos.line == 0 then
          return
        end
        vim.api.nvim_set_current_win(pos.winid)
        local lnum = pos.line
        local col = vim.fn.virtcol2col(pos.winid, lnum, pos.column) - 1

        local marks = vim.api.nvim_buf_get_extmarks(0, -1, { lnum - 1, col }, { lnum - 1, col }, {
          details = true,
          type = "highlight",
          overlap = true,
        })
        for _, mark in ipairs(marks) do
          if mark[4] and mark[4].url then
            vim.ui.open(mark[4].url)
            return
          end
        end

        local width = wrap_width(lnum, lnum)
        local function full(l)
          return vim.fn.strdisplaywidth(vim.fn.getline(l)) >= width
        end
        local first, last = lnum, lnum
        while first > 1 and full(first - 1) do
          first = first - 1
        end
        while last < vim.fn.line("$") and full(last) do
          last = last + 1
        end
        local rows = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
        local joined = join_rows(rows, rows, width)[1]
        local prefix_parts = vim.list_slice(rows, 1, lnum - first)
        table.insert(prefix_parts, rows[lnum - first + 1]:sub(1, col))
        local clicked = #join_rows(prefix_parts, rows, width)[1] + 1

        for s, url, e in joined:gmatch("()(https?://[%w%-._~:/?#%[%]@!$&'()*+,;=%%]+)()") do
          if s <= clicked and clicked < e then
            vim.ui.open((url:gsub("[.,;:!?)'\"]+$", "")))
            return
          end
        end
        vim.notify("No URL under the mouse", vim.log.levels.WARN)
      end

      vim.api.nvim_create_autocmd("TermOpen", {
        callback = function(ev)
          vim.keymap.set({ "n", "t" }, "<C-LeftMouse>", open_url_at_mouse, { buffer = ev.buf, desc = "Open URL" })
        end,
      })
    end,
  },
}
