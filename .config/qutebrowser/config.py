import platform
from qutebrowser.config.configfiles import ConfigAPI
from qutebrowser.config.config import ConfigContainer

config: ConfigAPI = config
c: ConfigContainer = c

config.load_autoconfig()
c.tabs.new_position.related = "last"
c.url.searchengines["DEFAULT"] = "https://kagi.com/search?q={}"
c.editor.command = ["kitty", "--class=float", "-e", "nvim", "-u", "NONE", "{}"]

config.bind("<Ctrl-o>", "tab-focus stack-prev")
config.bind("<Ctrl-i>", "tab-focus stack-next")
config.bind("gk", "tab-move +")
config.bind("gj", "tab-move -")
config.bind("J", "tab-prev")
config.bind("K", "tab-next")
config.bind("j", "scroll down")
config.bind("<f12>", "devtools")
config.bind("<Ctrl-Shift-c>", "yank selection")
config.bind("<Ctrl-j>", "spawn --userscript jenkins_rebuild")
config.bind("<Ctrl-g>", "spawn --userscript go_to_gravity")
config.bind("<Ctrl-Shift-b>", "spawn --userscript multi_quickmark")
config.bind("<Ctrl-t>", "spawn --userscript toggle_dark_mode")
c.auto_save.session = True
c.qt.args = ["disable-blink-features=DocumentPictureInPictureAPI"]

if platform.system() == "Darwin":
    c.editor.command = ["/opt/homebrew/bin/kitty", "-e", "nvim", "-u", "NONE", "{}"]
    config.bind("<Ctrl-c>", "yank selection")
