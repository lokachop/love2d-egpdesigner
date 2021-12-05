function love.conf(t)
	t.version = "11.3"
	t.window.title = "EGPDesignHelper"
	t.window.borderless = false
    t.window.width = 512 + 256 * 2
    t.window.height = 800
    t.window.vsync = 1
	t.console = true
	t.modules.joystick = false
end