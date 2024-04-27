local wezterm = require("wezterm")
local mux = wezterm.mux
local config = wezterm.config_builder()

config.color_scheme = "Gruvbox dark, hard (base16)"
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

return config
