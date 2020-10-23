c.tabs.new_position.related = "last"
c.url.searchengines["DEFAULT"] = "https://google.com/search?q={}"
c.editor.command = [ "termite", "-e", "nvim {}" ]
config.bind('<Ctrl-o>', 'tab-focus stack-prev')
config.bind('<Ctrl-i>', 'tab-focus stack-next')
config.bind('J', 'tab-prev')
config.bind('K', 'tab-next')
config.bind('j', 'scroll down')
c.auto_save.session = True
