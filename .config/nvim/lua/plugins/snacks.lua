---@module 'snacks'
---@diagnostic disable: missing-fields`

-- Collect the directories currently bookmarked (marked with `m`) in nvim-tree.
local function nvim_tree_marked_dirs()
  local ok, api = pcall(require, "nvim-tree.api")
  if not ok then
    return {}
  end
  local dirs = {}
  local marks = api.marks.list()
  if marks == nil then
    return dirs
  end
  for _, node in ipairs(api.marks.list()) do
    if node.type == "directory" then
      table.insert(dirs, node.absolute_path)
    end
  end
  return dirs
end

-- Kanagawa's floats and diff colors are tuned for its stock `#1f1f28` background,
-- so against the `#0a0c0f` override in `lua/plugins/themes.lua` the picker sits on
-- a lighter `NormalFloat` (#16161d) and the diff reads as washed out. Put every
-- snacks surface on the real editor background and blend the diff colors into it.
local function snacks_dark_diff_colors()
  if vim.o.background ~= "dark" then
    return -- kanagawa-lotus keeps its own palette
  end
  local util = Snacks.util
  local bg = util.color("Normal", "bg")
  if not bg then
    return -- transparent colorscheme: nothing to blend against
  end

  -- The per-window groups (SnacksPickerPreview, SnacksPickerListBorder, ...) are
  -- default links to these four, so overriding the base cascades to all of them.
  -- The comment boxes in a PR diff ride along: they are drawn with `FloatBorder`,
  -- which 'winhighlight' remaps to SnacksPickerPreviewBorder inside the preview.
  local hl = {
    SnacksPicker = { fg = util.color("NormalFloat"), bg = bg },
    SnacksPickerBorder = { fg = util.color("FloatBorder"), bg = bg },
    SnacksPickerTitle = { fg = util.color("FloatTitle"), bg = bg },
    SnacksPickerFooter = { fg = util.color({ "FloatFooter", "FloatTitle" }), bg = bg },
    -- Same treatment for `gh_open` buffers, which have their own float groups.
    SnacksGhNormal = { fg = util.color("NormalFloat"), bg = bg },
    SnacksGhNormalFloat = { fg = util.color("NormalFloat"), bg = bg },
    SnacksGhBorder = { fg = util.color("FloatBorder"), bg = bg },
    SnacksGhTitle = { fg = util.color("FloatTitle"), bg = bg },
    SnacksGhFooter = { fg = util.color({ "FloatFooter", "FloatTitle" }), bg = bg },
  }
  -- { snacks suffix, diff group, accent group for the line numbers }
  for _, spec in ipairs({
    { "Add", "DiffAdd", "Added" },
    { "Delete", "DiffDelete", "Removed" },
    { "Context", "DiffChange", "Changed" },
  }) do
    local name, group, accent = spec[1], spec[2], spec[3]
    local base = util.color(group, "bg")
    local fg = util.color({ group, accent })
    if base then
      hl["SnacksDiff" .. name] = { bg = util.blend(base, bg, 0.5) }
      hl["SnacksDiff" .. name .. "LineNr"] = {
        bg = util.blend(base, bg, 0.3), -- gutter a shade below the line
        fg = fg and util.blend(fg, bg, 0.6) or nil,
      }
    end
  end
  -- managed = false: snacks must not cache and replay these, or the dark blend
  -- would follow us into the light theme.
  util.set_hl(hl, { managed = false })
end

-- Snacks folds gh buffers with treesitter markdown, which folds the *list* of
-- comments as a single node -- so `zc` on any thread header collapses every
-- thread at once. Give each top-level comment/review its own fold (and each
-- reply inside a review a nested one), while treesitter keeps handling the
-- description and the markup inside a comment body.
--
-- A comment header is a `*` list marker whose line also carries a timestamp
-- ("3 hours ago", "Apr 29, 2024") -- markdown bullets in a PR description or a
-- CodeRabbit summary use the same marker, so the timestamp is what separates a
-- thread from prose. Indent gives the nesting: 1 space = thread, 4 = reply,
-- 7 = reply-to-reply.
---@return number? depth
local function gh_comment_depth(line)
  local indent = line:match("^(%s*)%*%s")
  if not indent then
    return nil
  end
  local dated = line:match("%f[%a]ago%f[%A]") or line:match("%a+%s+%d+,%s+%d%d%d%d")
  if not dated then
    return nil
  end
  return math.min(math.floor(#indent / 3) + 1, 3)
end

local gh_folds = {} ---@type table<number, {tick: number, depth: table<number, number>}>

local function gh_fold_depths(buf)
  local cached = gh_folds[buf]
  local tick = vim.api.nvim_buf_get_changedtick(buf)
  if cached and cached.tick == tick then
    return cached.depth
  end
  local depth, current = {}, 0
  for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    local d = gh_comment_depth(line)
    if d then
      current, depth[i] = d, -d -- negative marks "a fold starts here"
    else
      depth[i] = current
    end
  end
  gh_folds[buf] = { tick = tick, depth = depth }
  return depth
end

function _G.gh_fold_expr(lnum)
  lnum = lnum or vim.v.lnum
  local depth = gh_fold_depths(vim.api.nvim_get_current_buf())[lnum] or 0
  if depth < 0 then
    return ">" .. -depth -- thread or reply starts on this line
  end
  local ts = vim.treesitter.foldexpr(lnum)
  if depth == 0 then
    return ts -- description and headers: plain treesitter folds
  end
  -- Inside a comment: keep treesitter's structure but never let it drop below
  -- the thread, or the thread's own fold would end early.
  return math.max(tonumber(tostring(ts):match("%d+")) or 0, depth + 1)
end

-- Same idea for the review comment boxes rendered inside a PR diff. There is no
-- syntax tree there, but every box line carries its `comment_id` in the buffer's
-- per-line metadata, so a run of one id is exactly one box.
local gh_diff_folds = {} ---@type table<number, {tick: number, level: table<number, string|number>}>

function _G.gh_diff_fold_expr(lnum)
  lnum = lnum or vim.v.lnum
  local buf = vim.api.nvim_get_current_buf()
  local tick = vim.api.nvim_buf_get_changedtick(buf)
  local cached = gh_diff_folds[buf]
  if not (cached and cached.tick == tick) then
    local meta = Snacks.picker.highlight.meta(buf) or {}
    local level, prev = {}, nil
    for i = 1, vim.api.nvim_buf_line_count(buf) do
      local id = (meta[i] or {}).comment_id
      level[i] = id and (id ~= prev and ">1" or 1) or 0
      prev = id
    end
    cached = { tick = tick, level = level }
    gh_diff_folds[buf] = cached
  end
  return cached.level[lnum] or 0
end

-- GitHub PRs where I'm the author OR a requested reviewer.
-- GitHub search has no OR operator, so run one `gh pr list --search` per
-- qualifier and merge the results, de-duped by item uri.
local function gh_pr_mine(opts)
  local qualifiers = { "author:@me", "review-requested:@me" }
  return Snacks.picker.pick(vim.tbl_deep_extend("force", {
    source = "gh_pr",
    title = "  PRs (mine + review requests)",
    finder = function(fopts, ctx)
      ---@async
      return function(cb)
        local seen = {}
        for _, qualifier in ipairs(qualifiers) do
          local o = vim.tbl_extend("force", {}, fopts)
          o.search = vim.trim(qualifier .. " " .. (ctx.filter.search or ""))
          require("snacks.gh.api")
            .list("pr", function(items)
              for _, item in ipairs(items or {}) do
                if not seen[item.uri] then
                  seen[item.uri] = true
                  cb(item)
                end
              end
            end, o)
            :wait()
        end
      end
    end,
  }, opts or {}))
end

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    enabled = true,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = {},
      gh = {
        -- Merged with the defaults (<cr> actions, i edit, a comment, c close,
        -- o reopen). `d` is free here since gh buffers are not modifiable, and
        -- it is skipped on issue buffers because gh_diff is PR-only.
        keys = {
          diff = { "d", "gh_diff", desc = "View PR diff" },
          -- Comments render as markdown list items, so treesitter folding already
          -- gives each one a fold. This flips the whole buffer between "collapsed
          -- to headers" and "everything open"; za/zo/zc still work per comment.
          fold = {
            "zi",
            function()
              local win = vim.api.nvim_get_current_win()
              vim.wo[win].foldlevel = vim.wo[win].foldlevel > 1 and 1 or 99
            end,
            desc = "Toggle comment folds",
          },
        },
        -- Open PRs as a skimmable list: thread headers visible, bodies folded.
        -- foldmethod/foldenable are spelled out rather than inherited, so a
        -- window that never picked up the snacks defaults still folds.
        wo = {
          foldmethod = "expr",
          foldexpr = "v:lua.gh_fold_expr()",
          foldenable = true,
          foldlevel = 1,
        },
      },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      quickfile = {},
      statuscolumn = {},
      input = { enabled = false },
      words = {},
      picker = {
        filter = {
          cwd = true,
        },
        sources = {
          -- Review PR diffs in a full-screen 30/70 vertical split: file list on
          -- the left, diff on the right. `a` in the diff adds a comment on the
          -- cursor line or visual selection.
          --
          -- Every size here is relative, so `VimResized` recomputes them and the
          -- ratio holds. The `sidebar` preset could not: its width was absolute
          -- columns, and its `preview = "main"` diff is a float over the main
          -- window rather than a layout window, so neither followed a resize.
          ---@type snacks.picker.gh.diff.Config
          gh_diff = {
            layout = {
              layout = {
                box = "horizontal",
                width = 0, -- 0 = fill the editor
                height = 0,
                backdrop = false,
                {
                  box = "vertical",
                  width = 0.3,
                  min_width = 30, -- floor on narrow terminals
                  border = true,
                  title = "{title} {live} {flags}",
                  title_pos = "center",
                  { win = "input", height = 1, border = "bottom" },
                  { win = "list", border = "none" },
                },
                -- No width: flexes into the remaining 70%.
                { win = "preview", title = "{preview}", border = true },
              },
            },
            -- <cr> jumps into the diff, same as <c-l>. Without this the source
            -- has no confirm action and falls back to "jump", which tries to
            -- edit the diff's path in cwd -- a file that isn't there when the
            -- repo isn't checked out locally.
            confirm = "focus_preview",
            -- Scroll the diff with <c-d>/<c-u> from the file list. The list is
            -- short here, so its own scroll keys are worth giving up.
            -- <c-l> jumps into the diff, <c-h> back to the picker, matching the
            -- global window-navigation maps in `lua/mappings.lua`.
            win = {
              input = {
                keys = {
                  ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
                  ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
                  ["<c-l>"] = { "focus_preview", mode = { "i", "n" } },
                },
              },
              list = {
                keys = {
                  ["<c-d>"] = "preview_scroll_down",
                  ["<c-u>"] = "preview_scroll_up",
                  ["<c-l>"] = "focus_preview",
                },
              },
              preview = {
                -- Fold the review comment boxes; zc/zo/za work on them, and
                -- foldlevel 99 leaves them open until you close one.
                wo = {
                  foldmethod = "expr",
                  foldexpr = "v:lua.gh_diff_fold_expr()",
                  foldlevel = 99,
                },
                keys = {
                  ["<c-h>"] = "focus_input",
                  -- Next/previous file without leaving the diff. Unmapped, these
                  -- fall through to the global <c-w>j / <c-w>k / <c-w>w in
                  -- mappings.lua, which move focus out of the float and tear the
                  -- picker down. <c-n> matches snacks' own input/list binding.
                  ["<c-j>"] = "list_down",
                  ["<c-k>"] = "list_up",
                  ["<c-n>"] = "list_down",
                  ["<c-p>"] = "list_up",
                },
              },
            },
          },
          ---@type snacks.picker.buffers.Config
          buffers = {
            win = {
              input = {
                keys = {
                  ["<c-x>"] = { "edit_split", mode = { "n", "i" } },
                },
              },
            },
          },
          ---@type snacks.picker.explorer.Config
          explorer = {
            follow_file = false,
            win = {
              list = {
                keys = {
                  ["<c-x>"] = { "edit_split", mode = { "n", "i" } },
                  ["x"] = "explorer_move",
                  ["<CR>"] = function()
                    local picker = Snacks.picker.get({ source = "explorer" })[1]
                    if not picker then
                      return
                    end
                    local selected = picker:selected()
                    local current = picker:current()
                    -- Multiselect with files: open them in the main window
                    if #selected > 0 then
                      local files = vim.tbl_filter(function(t)
                        return not t.dir
                      end, selected)
                      if #files > 0 then
                        vim.api.nvim_set_current_win(picker.main)
                        vim.cmd("edit " .. vim.fn.fnameescape(Snacks.picker.util.path(files[1])))
                        for i = 2, #files do
                          local buf = vim.fn.bufadd(Snacks.picker.util.path(files[i]))
                          vim.bo[buf].buflisted = true
                        end
                        return
                      end
                    end
                    -- Single item: expand dir or open file
                    if current then
                      if current.dir then
                        picker:action("confirm")
                      else
                        vim.api.nvim_set_current_win(picker.main)
                        vim.cmd("edit " .. vim.fn.fnameescape(Snacks.picker.util.path(current)))
                      end
                    end
                  end,
                  ["<ESC>"] = "<ESC>",
                  ["m"] = "explorer_move",
                  ["/"] = function()
                    vim.api.nvim_feedkeys("/", "n", false)
                  end,
                },
              },
            },
          },
          grep = {
            list = { keys = { ["<c-x>"] = { "edit_split", mode = { "i", "n" } } } },
            win = {
              input = { keys = { ["<c-x>"] = { "edit_split", mode = { "i", "n" } } } },
            },
            formatters = {
              file = {
                filename_first = true,
              },
            },
          },
          files = {
            list = { keys = { ["<c-x>"] = { "edit_split", mode = { "i", "n" } } } },
            win = {
              input = { keys = { ["<c-x>"] = { "edit_split", mode = { "i", "n" } } } },
            },
            formatters = {
              file = {
                filename_first = true,
              },
            },
          },
        },
      },
      styles = {},
    },
    -- stylua: ignore
    keys = {
      { "<leader><space>", function()
        local search_dirs = nvim_tree_marked_dirs()
        if #search_dirs > 0 then
          Snacks.picker.files({ follow = true, hidden = true, dirs = search_dirs })
        else
          Snacks.picker.smart()
        end
      end,   desc = "Find Files" },
      { "<leader>/v",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>/b",      function() Snacks.picker.grep_buffers() end,                            desc = "Buffers" },
      { "<leader>bb",      function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
      { "<leader>//",      function()
        local search_dirs = nvim_tree_marked_dirs()
        if #search_dirs > 0 then
          Snacks.picker.grep({ dirs = search_dirs })
        else
          Snacks.picker.grep()
        end
      end,                                    desc = "Grep" },
      { "<leader>/f",      function() Snacks.picker.treesitter() end,                              desc = "Treesitter" },
      { "<leader>/:",      function() Snacks.picker.command_history() end,                         desc = "Command History" },
      { "<leader>/h",      function() Snacks.picker.help() end,                                    desc = "Neovim Help Docs" },
      { "<leader>/n",      function() Snacks.picker.notifications() end,                           desc = "Notification History" },
      -- { "<leader>/e",      function() Snacks.explorer() end,                                       desc = "File Explorer" },
      { "<leader>/q",      function() Snacks.picker.resume() end,                                  desc = "Resume search" },
      { "<leader>ju",      function() Snacks.picker.undo() end,                                    desc = "Undo history" },
      { "<leader>/u",      function() Snacks.picker.undo() end,                                    desc = "Undo history" },
      { "<leader>/i",      function() Snacks.picker.icons() end,                                   desc = "Icons" },
      { "<leader>/d",      function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
      { "<leader>/D",      function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
      -- git
      { "<leader>gb",      function() Snacks.picker.git_branches() end,                            desc = "Git Branches" },
      { "<leader>gl",      function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
      { "<leader>gL",      function() Snacks.picker.git_log_line() end,                            desc = "Git Log Line" },
      { "<leader>gs",      function() Snacks.picker.git_status() end,                              desc = "Git Status" },
      { "<leader>gS",      function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
      { "<leader>gd",      function() Snacks.picker.git_diff() end,                                desc = "Git Diff (Hunks)" },
      { "<leader>gf",      function() Snacks.picker.git_log_file() end,                            desc = "Git Log File" },

      -- LSP
      { "gd",              function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
      { "gD",              function() Snacks.picker.lsp_declarations() end,                        desc = "Goto Declaration" },
      { "gr",              function() Snacks.picker.lsp_references() end,                          nowait = true,                     desc = "References" },
      { "gI",              function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },
      { "gy",              function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
      { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
      { "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "LSP Workspace Symbols" },
      -- Other
      { "<leader>z",       function() Snacks.zen() end,                                            desc = "Toggle Zen Mode" },
      { "<leader>Z",       function() Snacks.zen.zoom() end,                                       desc = "Toggle Zoom" },
      { "<leader>.",       function() Snacks.scratch() end,                                        desc = "Toggle Scratch Buffer" },
      { "<leader>S",       function() Snacks.scratch.select() end,                                 desc = "Select Scratch Buffer" },
      { "<leader>n",       function() Snacks.notifier.show_history() end,                          desc = "Notification History" },
      { "<leader>bd",      function() Snacks.bufdelete() end,                                      desc = "Delete Buffer" },
      { "<leader>cR",      function() Snacks.rename.rename_file() end,                             desc = "Rename File" },
      { "<leader>gB",      function() Snacks.gitbrowse() end,                                      desc = "Git Browse",               mode = { "n", "v" } },
      { "<leader>un",      function() Snacks.notifier.hide() end,                                  desc = "Dismiss All Notifications" },
    },
    init = function()
      -- Re-derive the diff colors whenever the theme changes (`:ThemeToggleLights`
      -- included). Scheduled so it lands after the colorscheme and after snacks
      -- re-applies its own defaults.
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("snacks_diff_colors", { clear = true }),
        callback = function()
          vim.schedule(snacks_dark_diff_colors)
        end,
      })

      -- Open a PR straight from a URL or `owner/repo#123`:
      --   :GhPr https://github.com/cli/cli/pull/9000
      -- With no argument the URL is read from the clipboard. No clone needed --
      -- `gh` is given the repo explicitly, so this works anywhere.
      -- Defined here (not on VeryLazy) so `nvim -c "GhPr <url>"` works too.
      vim.api.nvim_create_user_command("GhPr", function(cmd)
        local arg = vim.trim(cmd.args)
        if arg == "" then
          arg = vim.trim(vim.fn.getreg("+"))
          arg = arg ~= "" and arg or vim.trim(vim.fn.getreg("*"))
        end
        local repo, number = arg:match("([^/]+/[^/]+)/pull/(%d+)")
        if not repo then
          repo, number = arg:match("([%w._-]+/[%w._-]+)#(%d+)")
        end
        if not repo then
          vim.notify(
            "GhPr: expected a PR url or owner/repo#number, got: " .. (arg == "" and "<empty clipboard>" or arg),
            vim.log.levels.ERROR
          )
          return
        end
        -- Scheduled so the buffer opens after startup finishes.
        vim.schedule(function()
          -- Open the PR overview buffer rather than the diff: it carries the
          -- description, comments and reviews, and `<cr>` there offers "View PR
          -- diff" to get into the review flow.
          local uri = ("gh://%s/pr/%s"):format(repo, number)

          -- The gh:// buffer fetches asynchronously and sits empty until the
          -- render lands, so spin a notification until it has content.
          local notif_id = "gh_pr_loading"
          local msg = ("Loading %s#%s"):format(repo, number)
          local timer = assert((vim.uv or vim.loop).new_timer())
          local buf ---@type number?
          local waited = 0

          local function stop()
            timer:stop()
            if not timer:is_closing() then
              timer:close()
            end
            Snacks.notifier.hide(notif_id)
          end

          timer:start(
            0,
            80,
            vim.schedule_wrap(function()
              waited = waited + 80
              -- Done once the render lands; bail out if the buffer went away or
              -- `gh` is hanging.
              local gone = buf and not vim.api.nvim_buf_is_valid(buf)
              local rendered = buf and not gone and vim.api.nvim_buf_line_count(buf) > 3
              if gone or rendered or waited > 60000 then
                return stop()
              end
              Snacks.notify(msg, {
                id = notif_id,
                title = "GitHub PR",
                icon = Snacks.util.spinner(),
                timeout = false, -- replaced each tick, hidden by stop()
              })
            end)
          )

          local ok, err = pcall(vim.cmd.edit, uri)
          if not ok then
            stop()
            vim.notify("GhPr: " .. tostring(err), vim.log.levels.ERROR)
            return
          end
          buf = vim.api.nvim_get_current_buf()
        end)
      end, { nargs = "?", desc = "Open a GitHub PR buffer by URL (clipboard if omitted)" })

      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Initial pass: the startup ColorScheme event fires before the autocmd
          -- above exists, since the theme also loads at priority 1000.
          snacks_dark_diff_colors()

          -- Repair "Open PR in buffer". Snacks implements it with
          -- `Snacks.picker.actions.jump`, which discards the PR item it is handed
          -- and re-reads the picker's selection -- inside `gh_diff` that is a diff
          -- entry whose path is not on disk, so it opens an empty buffer. Edit the
          -- PR's own `gh://` uri instead. Drop this if snacks fixes it upstream.
          local ok, gh_actions = pcall(require, "snacks.gh.actions")
          if ok and type(gh_actions.actions.gh_open) == "table" then
            local orig = gh_actions.actions.gh_open
            gh_actions.actions.gh_open = vim.tbl_extend("force", orig, {
              action = function(item, ctx)
                local uri = type(item) == "table" and item.uri or nil
                if type(uri) ~= "string" or not uri:match("^gh://") then
                  return orig.action(item, ctx) -- unexpected item: leave it to snacks
                end
                local main = ctx and ctx.picker and ctx.picker.main
                if ctx and ctx.picker then
                  ctx.picker:close()
                end
                if main and vim.api.nvim_win_is_valid(main) then
                  vim.api.nvim_set_current_win(main)
                end
                vim.cmd.edit(uri)
              end,
            })
          end

          -- "Open in web browser" shells out to `gh <type> view --web`, which obeys
          -- $BROWSER (/usr/bin/qutebrowser here) and so bypasses the desktop's own
          -- handler. Hand the item's url to xdg-open instead.
          if ok and type(gh_actions.actions.gh_browse) == "table" and vim.fn.executable("xdg-open") == 1 then
            local orig = gh_actions.actions.gh_browse
            gh_actions.actions.gh_browse = vim.tbl_extend("force", orig, {
              action = function(item, ctx)
                local items = ctx and ctx.items or { item }
                local opened = {} ---@type string[]
                for _, it in ipairs(items) do
                  if type(it) == "table" and type(it.url) == "string" then
                    vim.system({ "xdg-open", it.url }, { detach = true })
                    opened[#opened + 1] = "#" .. tostring(it.number)
                  end
                end
                if #opened == 0 then
                  return orig.action(item, ctx) -- no urls to hand over: leave it to snacks
                end
                Snacks.notify.info(("Opened %s in web browser"):format(table.concat(opened, ", ")))
                if ctx and ctx.picker then
                  ctx.picker.list:set_selected() -- clear selection, as snacks does
                end
              end,
            })
          end

          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          vim.api.nvim_create_user_command("Notifications", function()
            Snacks.notifier.show_history()
          end, {})
        end,
      })
    end,
  },
}
