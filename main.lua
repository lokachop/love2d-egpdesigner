function love.load() -- called on start
	local f = love.filesystem.load("/initlua.lua")
	f()


	lsglil.initGUI()
	initNotifications()
	CurTime = 0
	CurrBrightness = 1
	CurrSaturation = 1
	DrawOffset = {0, 0}
	ColourOffset = {0, 64}
	ImageScale = 1

	background = love.graphics.newImage("res/background.png")
	backgroundQuad = love.graphics.newQuad(0, 0, 512, 512, 512, 512)

	
	DoTransparency = false
	drawCanvas = love.graphics.newCanvas(512, 512)

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
	local w, h = love.graphics.getDimensions()
	renderBorder()
	egplib.renderEGPObjects()

	lsglil.renderGUI()
	renderNotifications(0, 0)
	egplib.renderDrawingData(w * 0.85, 0)
end

function love.mousemoved(x, y, dx, dy)
	egplib.handleDragging(x, y, dx, dy)
end

function love.mousepressed(x, y, button, istouch, presses)
	lsglil.handlePressOnGUI(x, y, button, istouch, presses)

	egplib.handleDrawing(x, y, button, istouch, presses)
end

function love.keypressed(key, scancode, isrepeat)
	egplib.handleDrawingKeyboard(key, scancode, isrepeat)
end

function love.wheelmoved(x, y) -- how do you even move your mousewheel on the x axis??!?!?
	--egplib.handleZooming(x, y)
end