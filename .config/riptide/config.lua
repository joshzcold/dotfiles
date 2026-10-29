-- Translated from ~/.config/qutebrowser/config.py.
-- Lines commented out with "not supported" have no hackers-browser equivalent yet.

c.tabs.new_position.related = "last"
c.auto_save.session = true
c.editor.command = { "kitty", "--class=float", "-e", "nvim", "-u", "NONE", "{file}" }
-- not supported: c.qt.args = { "disable-blink-features=DocumentPictureInPictureAPI" }

-- qutebrowser's J/K are the reverse of hackers-browser's defaults.
rt.bind("J", "tab-prev")
rt.bind("K", "tab-next")
rt.bind("gk", "tab-move +")
rt.bind("gj", "tab-move -")
rt.bind("j", "scroll down")
rt.bind("gu", "edit-url")

rt.bind("<Ctrl-o>", "tab-focus stack-prev")
rt.bind("<Ctrl-i>", "tab-focus stack-next")
rt.bind("<F12>", "devtools")
rt.bind("<Ctrl-Shift-c>", "yank selection")
rt.bind("<Ctrl-j>", "spawn --userscript jenkins_rebuild")
rt.bind("<Ctrl-g>", "spawn --userscript go_to_gravity")
rt.bind("<Ctrl-Shift-b>", "spawn --userscript multi_quickmark")
rt.bind("<Ctrl-t>", "spawn --userscript toggle_dark_mode")

-- From ~/.config/qutebrowser/autoconfig.yml. The defaults already have q, qa and wq.
local aliases = rt.get("aliases")
aliases.w = "session-save"
aliases.wqa = "quit --save"
c.aliases = aliases

-- not supported: spawn (aliases bbpull, pass; bindings ,m, <Ctrl-b>, Y),
-- gI (hint inputs --first ;; ... edit-text), per-site permissions and user agents,
-- dark mode, content blocking, spellcheck, tabs.position, tabs.title.alignment

if rt.platform == "macos" then
  -- not supported: c.qt.workarounds.disable_accessibility = "always"
  c.editor.command = { "/opt/homebrew/bin/kitty", "-e", "nvim", "-u", "NONE", "{file}" }
  -- Karabiner rewrites ctrl+c/ctrl+v to the cmd chord, which arrives as Meta,
  -- but CEF's native copy and paste never fire for it. Bind them per mode.
  rt.bind("<Meta-v>", "rl-paste", "command")
  -- yank selection reads the main frame only, so a selection in an iframe
  -- (Gmail's compose) comes back empty; read the focused frame instead.
  -- getSelection() also skips form fields, so check the active element first.
  local selection_js = [[(() => {
    const el = document.activeElement;
    if (el && (el.tagName === "INPUT" || el.tagName === "TEXTAREA")
        && el.selectionStart != null && el.selectionStart !== el.selectionEnd) {
      return el.value.slice(el.selectionStart, el.selectionEnd);
    }
    return String(getSelection());
  })()]]

  local function yank_selection()
    rt.page.eval(selection_js, function(text)
      if text and text ~= "" then
        rt.spawn({ "pbcopy" }, { stdin = text })
        rt.message("Yanked selection")
      else
        rt.run("yank selection")
      end
    end, { frame = "focused" })
  end

  rt.bind("<Meta-c>", yank_selection)
  rt.bind("<Meta-c>", yank_selection, "caret")
  rt.bind("<Meta-c>", yank_selection, "insert")
  rt.bind("<Meta-v>", "insert-text {clipboard}", "insert")
end

-- Bitwarden logins through the bw CLI; riptide adds the passwords plugin it fills through.
rt.pack.add({ "https://github.com/joshzcold/riptide-plugins", subdir = "bitwarden" })

-- Edit the focused text field in nvim, drawn over the field: <Ctrl-Shift-e> or :firenvim.
-- It opens by itself on text areas; its "⊘ ignore" button can leave a field or site alone from then on.
rt.pack.add({ "https://github.com/joshzcold/riptide-plugins", subdir = "firenvim", opts = {} })

-- Mark pages and jump to them: <Space>a marks, <Space>1-4 jump, <Space>h lists.
rt.pack.add({ "https://github.com/joshzcold/riptide-plugins", subdir = "harpoon" })
-- The page's article alone, in a tab of its own: gR or :reader.
rt.pack.add({ "https://github.com/joshzcold/riptide-plugins", subdir = "reader" })
-- Fuzzy-find tabs, history, bookmarks and quickmarks: <Space>ff, ft, fh, fb, fq.
rt.pack.add({ "https://github.com/joshzcold/riptide-plugins", subdir = "telescope" })
-- Edit tabs, bookmarks and quickmarks as text in nvim: :oil tabs, :oil bookmarks, :oil quickmarks.
rt.pack.add({ "https://github.com/joshzcold/riptide-plugins", subdir = "oil" })
-- Jump to text by two of its characters: <Space>s (caret mode there), <Space>S (follow its link).
rt.pack.add({ "https://github.com/joshzcold/riptide-plugins", subdir = "flash" })
-- A cleaner command line, questions, tabs and status bar; :noice turns it off and on.
-- The palette and the centered questions need these two settings.
c.ui.overlay.position = "center"
c.prompt.position = "center"
rt.pack.add({ "https://github.com/joshzcold/riptide-plugins", subdir = "noice" })

-- Page notifications go to the Linux desktop (D-Bus, like any app). "messages"
-- would show them in riptide's status bar instead.
c.content.notifications.presenter = "auto"
