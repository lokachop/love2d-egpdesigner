function love.load() -- called on start
	local f = love.filesystem.load("/initlua.lua")
	f()


	lsglil.initGUI()
	initNotifications()
	CurTime = 0
	CurrBrightness = 1
	CurrSaturation = 1

	background = love.graphics.newImage("res/swedishpfp.png")
	DoTransparency = false

	initEGPDrawerGUI()
	addNotification("Loaded!", 2)
end

function love.update(dt) -- dt is deltatime




	CurTime = CurTime + dt
	lsglil.handleDragging()
	lsglil.handleHovering()
	notificationThink()

end

function love.draw() -- draw
	renderBorder()
	egplib.renderEGPObjects()

	lsglil.renderGUI()
	renderNotifications(0, 0)
	
end

function love.mousepressed(x, y, button, istouch, presses)
	lsglil.handlePressOnGUI(x, y, button, istouch, presses)

	egplib.handleDrawing(x, y, button, istouch, presses)
end

function love.keypressed(key, scancode, isrepeat)
	egplib.handleDrawingKeyboard(key, scancode, isrepeat)
end