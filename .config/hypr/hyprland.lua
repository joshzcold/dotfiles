-- Hyprland Lua config — translated from ~/.dwm/config.h
-- Requires Hyprland v0.55+
-- https://wiki.hypr.land/Configuring/Start/

--------------------
---- ENV VARS ----
--------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("SDL_VIDEODRIVER", "wayland")

-- Nvidia
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

--------------------
---- MONITORS ----
--------------------

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

--------------------
---- AUTOSTART ----
--------------------

-- Status bar
hl.on("hyprland.start", function()
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("waybar")

	-- Scratchpads: pre-launch so they're ready to toggle
	-- Each window rule below routes these to their special workspace by title
	-- hl.exec_cmd("nixGL kitty -T scratchpad")
	-- hl.exec_cmd("nixGL kitty -T notes zsh -c \"nvim -c 'Org agenda a'\"")
	-- hl.exec_cmd("nixGL kitty -T github_reviews zsh -c /home/joshua/.config/usr-scripts/github_reviews.sh")
	-- hl.exec_cmd(
	-- 	"nixGL kitty -T qutebrowser_quickmarks zsh -c /home/joshua/.config/usr-scripts/qutebrowser_quickmarks.sh"
	-- )
end)

----------------------------
---- LOOK AND FEEL ----
----------------------------

-- dwm colors (for reference — fg/bg apply to waybar CSS, not hyprland.lua):
--   normal bg:    #222222   normal border:   #444444   normal fg:   #bbbbbb
--   selected bg:  #525252   selected border: #b54500   selected fg: #eeeeee

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 5,

		border_size = 1,

		col = {
			active_border = "0xffb54500",
			inactive_border = "0xff444444",
		},

		resize_on_border = false,
		allow_tearing = false,
		layout = "master",
	},

	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 1,
		sensitivity = 0,

		repeat_rate = 25,
		repeat_delay = 600,

		touchpad = {
			natural_scroll = false,
		},
	},

	misc = {
		force_default_wallpaper = 0,
		disable_splash_rendering = true,
		disable_hyprland_logo = true,
	},
	decoration = {
		rounding = 6,
		rounding_power = 2,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = false,
	},
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
-- hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
-- hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
-- hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
-- hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
-- hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
--
-- -- Default springs
-- hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })
--
-- hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
-- hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
-- hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
-- hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
-- hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
-- hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
-- hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
-- hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
-- hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
-- hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
-- hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
-- hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
-- hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
-- hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
-- hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
-- hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
-- hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- Master layout: mirrors dwm's tile (mfact 0.55, 1 master)
hl.config({
	master = {
		mfact = 0.55,
		new_status = "slave",
	},
})

--------------------------
---- WINDOW RULES ----
--------------------------

-- Float by class
local float_classes = {
	"Peek",
	"Bitwarden",
	"Steam",
	"Emulator",
	"Blueman-manager",
	"Pavucontrol",
	"explorer.exe",
	"float",
}
for _, cls in ipairs(float_classes) do
	hl.window_rule({
		name = "float-" .. cls,
		match = { class = cls },
		float = true,
	})
end

-- Float by title
local float_titles = { "Event Tester", "notes", "github_reviews", "qutebrowser_quickmarks" }
for _, t in ipairs(float_titles) do
	hl.window_rule({
		name = "float-title-" .. t,
		match = { title = t },
		float = true,
	})
end

-- Scratchpad workspace assignments (match by kitty -T title)
hl.window_rule({
	name = "scratch-scratchpad",
	match = { title = "scratchpad" },
	workspace = "special:scratchpad",
})
hl.window_rule({
	name = "scratch-notes",
	match = { title = "notes" },
	workspace = "special:notes",
})
hl.window_rule({
	name = "scratch-github_reviews",
	match = { title = "github_reviews" },
	workspace = "special:github_reviews",
})
hl.window_rule({
	name = "scratch-qutebrowser_quickmarks",
	match = { title = "qutebrowser_quickmarks" },
	workspace = "special:qutebrowser_quickmarks",
})

-- Suppress maximize requests
hl.window_rule({
	name = "suppress-maximize",
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- Fix XWayland drag issues
hl.window_rule({
	name = "fix-xwayland-drags",
	match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
	no_focus = true,
})

------------------------------
---- APPLICATION BINDS ----
------------------------------

local mainMod = "SUPER"

-- Launchers
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("/home/joshua/.config/rofi/launchers/type-3/launcher.sh"))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("nixGL kitty"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("rofimoji --action copy --skin-tone neutral"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("/home/joshua/.config/usr-scripts/totp"))

-- Scratchpads
hl.bind(mainMod .. " + grave", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.workspace.toggle_special("notes"))
hl.bind(mainMod .. " + R", hl.dsp.workspace.toggle_special("github_reviews"))
hl.bind(mainMod .. " + W", hl.dsp.workspace.toggle_special("qutebrowser_quickmarks"))

-- Scripts
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("/home/joshua/.config/usr-scripts/screenshot.sh"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("/home/joshua/.config/usr-scripts/insert_with_rofi.sh"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("/home/joshua/.config/usr-scripts/screen_record"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("/home/joshua/.config/usr-scripts/bw-pass.sh"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("/home/joshua/.config/usr-scripts/vault-clipboard.sh"))

-- Lock / sleep
hl.bind("CTRL + SHIFT + S", hl.dsp.exec_cmd("betterlockscreen --lock blur"))

-- Bar toggle (SUPER+b in dwm; sends SIGUSR1 to waybar to show/hide)
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))

-- Media / brightness (locked = works on lockscreen)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("light -A 10"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("light -U 10"), { locked = true, repeating = true })
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +10%"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -10%"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"), { locked = true })

-- Quit
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exit())

----------------------------------
---- WINDOW MANAGEMENT BINDS ----
----------------------------------

-- Close / float
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))

-- dwm's float layout set is per-window only in Hyprland (no global float mode)
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))

-- Monocle (fullscreen maximized, bar still visible)
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized" }))

-- Cycle layout backward (approximates dwm SUPER+space toggle last layout)
-- TODO: no hl.dsp equivalent for cyclelayout yet — broken until Hyprland adds it to the Lua API
hl.bind(mainMod .. " + space", hl.dsp.exec_cmd("hyprctl dispatch cyclelayout -1"))

-- Focus cycling (focusstack +1/-1)
hl.bind(mainMod .. " + J", hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + K", hl.dsp.window.cycle_next({ next = false }))

-- Master area count (incnmaster)
hl.bind(mainMod .. " + I", hl.dsp.layout("addmaster"))
hl.bind(mainMod .. " + O", hl.dsp.layout("removemaster"))

-- Master area size (setmfact)
hl.bind(mainMod .. " + H", hl.dsp.layout("mfact -0.05"), { repeating = true })
hl.bind(mainMod .. " + L", hl.dsp.layout("mfact 0.05"), { repeating = true })

-- Swap focused window with master (zoom)
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.layout("swapwithmaster"))

-- Toggle previous workspace (view in dwm)
hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "previous" }))

-- Move floating window (SUPER+CTRL+hjkl)
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.move({ x = -75, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.move({ x = 0, y = 75, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.move({ x = 0, y = -75, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.move({ x = 75, y = 0, relative = true }), { repeating = true })

-- Resize window (SUPER+SHIFT+hjkl)
-- Note: dwm config had setcfact on SHIFT+h/l and moveresize on SHIFT+hjkl — using moveresize
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.resize({ x = -75, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.resize({ x = 0, y = 75, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.resize({ x = 0, y = -75, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.resize({ x = 75, y = 0, relative = true }), { repeating = true })
-- SUPER+SHIFT+O (reset cfact) has no Hyprland equivalent — omitted

-- Snap floating window to screen edge (moveresizeedge)
-- TODO: no hl.dsp equivalent for movetoedge yet — broken until Hyprland adds it to the Lua API
hl.bind(mainMod .. " + CTRL + SHIFT + K", hl.dsp.exec_cmd("hyprctl dispatch movetoedge t"))
hl.bind(mainMod .. " + CTRL + SHIFT + J", hl.dsp.exec_cmd("hyprctl dispatch movetoedge b"))
hl.bind(mainMod .. " + CTRL + SHIFT + H", hl.dsp.exec_cmd("hyprctl dispatch movetoedge l"))
hl.bind(mainMod .. " + CTRL + SHIFT + L", hl.dsp.exec_cmd("hyprctl dispatch movetoedge r"))

-- Monitor focus / move window to monitor
hl.bind(mainMod .. " + comma", hl.dsp.focus({ monitor = "-1" }))
hl.bind(mainMod .. " + period", hl.dsp.focus({ monitor = "+1" }))
hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.window.move({ monitor = "-1" }))
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.window.move({ monitor = "+1" }))

-- Cycle layouts
-- TODO: no hl.dsp equivalent for cyclelayout yet — broken until Hyprland adds it to the Lua API
hl.bind(mainMod .. " + CTRL + comma", hl.dsp.exec_cmd("hyprctl dispatch cyclelayout -1"))
hl.bind(mainMod .. " + CTRL + period", hl.dsp.exec_cmd("hyprctl dispatch cyclelayout 1"))

-- Rename workspace (nametag — requires rofi + jq)
-- TODO: no hl.dsp equivalent for renameworkspace with dynamic name yet — broken until Hyprland adds it to the Lua API
hl.bind(
	mainMod .. " + N",
	hl.dsp.exec_cmd(
		"hyprctl dispatch renameworkspace"
			.. " $(hyprctl activeworkspace -j | jq .id)"
			.. " \"$(rofi -dmenu -p 'Rename workspace:')\""
	)
)

-- Pin window to all workspaces (SUPER+SHIFT+0)
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.pin())
-- SUPER+0 (view all tags simultaneously) has no Hyprland equivalent — omitted

-- Workspace switching + window movement (TAGKEYS equivalent)
for i = 1, 9 do
	local key = tostring(i)
	-- SUPER+n          → switch to workspace n
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	-- SUPER+SHIFT+n    → move focused window to workspace n
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
	-- SUPER+CTRL+n     → toggle-view workspace n (approximated as switch; Hyprland has no multi-view)
	hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.focus({ workspace = i }))
	-- SUPER+CTRL+SHIFT+n → toggle-tag window (approximated as silent move)
	hl.bind(mainMod .. " + CTRL + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

--------------------------
---- MOUSE BINDINGS ----
--------------------------

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + mouse:274", hl.dsp.window.float({ action = "toggle" }), { mouse = true })
