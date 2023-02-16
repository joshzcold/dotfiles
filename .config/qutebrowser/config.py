config.load_autoconfig()
c.tabs.new_position.related = "last"
c.url.searchengines["DEFAULT"] = "https://google.com/search?q={}"
c.editor.command = ["kitty", "--class=float", "-e", "nvim", "-u", "NONE", "{}"]
config.bind('<Ctrl-o>', 'tab-focus stack-prev')
config.bind('<Ctrl-i>', 'tab-focus stack-next')
config.bind('J', 'tab-prev')
config.bind('K', 'tab-next')
config.bind('j', 'scroll down')
config.bind('<f12>', 'devtools')
config.bind('<Ctrl-j>','spawn --userscript jenkins_rebuild')
c.auto_save.session = True
