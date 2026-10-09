-- Translated from ~/.config/qutebrowser/config.py.
-- Lines commented out with "not supported" have no hackers-browser equivalent yet.

c.tabs.new_position.related = "last"
c.auto_save.session = true
-- not supported: c.editor.command = { "kitty", "--class=float", "-e", "nvim", "-u", "NONE", "{}" }
-- not supported: c.qt.args = { "disable-blink-features=DocumentPictureInPictureAPI" }

-- qutebrowser's J/K are the reverse of hackers-browser's defaults.
rt.bind("J", "tab-prev")
rt.bind("K", "tab-next")
rt.bind("gk", "tab-move +")
rt.bind("gj", "tab-move -")
rt.bind("j", "scroll down")

-- not supported: tab-focus stack-prev/stack-next, devtools, yank selection, spawn --userscript
-- rt.bind("<Ctrl-o>", "tab-focus stack-prev")
-- rt.bind("<Ctrl-i>", "tab-focus stack-next")
-- rt.bind("<F12>", "devtools")
-- rt.bind("<Ctrl-Shift-c>", "yank selection")
-- rt.bind("<Ctrl-j>", "spawn --userscript jenkins_rebuild")
-- rt.bind("<Ctrl-g>", "spawn --userscript go_to_gravity")
-- rt.bind("<Ctrl-Shift-b>", "spawn --userscript multi_quickmark")
-- rt.bind("<Ctrl-t>", "spawn --userscript toggle_dark_mode")

-- From ~/.config/qutebrowser/autoconfig.yml. The defaults already have q, qa and wq.
local aliases = rt.get("aliases")
aliases.w = "session-save"
aliases.wqa = "quit --save"
c.aliases = aliases

-- not supported: spawn (aliases bbpull, pass; bindings ,m, <Ctrl-b>, Y), edit-url (gu),
-- gI (hint inputs --first ;; ... edit-text), per-site permissions and user agents,
-- dark mode, content blocking, spellcheck, tabs.position, tabs.title.alignment

if rt.platform == "macos" then
  -- not supported: c.qt.workarounds.disable_accessibility = "always"
  -- not supported: c.editor.command = { "/opt/homebrew/bin/kitty", "-e", "nvim", "-u", "NONE", "{}" }
  -- not supported: yank selection, insert-text
  -- rt.bind("<Ctrl-c>", "yank selection")
  -- rt.bind("<Ctrl-v>", "insert-text -- {clipboard}")
end

-- Page notifications go to the Linux desktop (D-Bus, like any app). "messages"
-- would show them in riptide's status bar instead.
c.content.notifications.presenter = "auto"
