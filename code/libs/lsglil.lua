--[[
	LSGLIL v0.8 rev 6
	

	L okachop's
	S imple
	G ui
	L ibrary
	I n
	L ove2D

	created by lokachop, @ 16/10/2021

	this gui lib was designed for lokacraft, sorry for any weird coding problems
	
]]--

function math.inrange(num, min, max)
	if num < min then 
		return false
	elseif num > max then 
		return false
	else 
		return true 
	end
end

lsglil = {}

-- initialize the gui element table, used to store all gui elements
function lsglil.initGUI()
	GUIElements = {}
	lsglil.CanvasElements = {}
	lsglil.CurrentTextEntry = nil
end

-- gets the number of elements via a loop
function lsglil.getGUIElementCount()
	local guiElementCount = 0
	for k, v in pairs(GUIElements) do
		guiElementCount = guiElementCount + 1
	end

	return guiElementCount
end











--[[
	helper functions
]]--

function lsglil.initDefaultValues(obj)
	obj.x = 0
	obj.y = 0
	obj.w = 32
	obj.h = 32
	obj.col = {1, 1, 1}
end


-- updates object 
function lsglil.updateObject(obj)
	local name = obj.name
	GUIElements[name] = obj
end

-- function to delete stuff
function lsglil.deleteObject(obj)
	GUIElements[obj.name] = nil
end

-- function to get element via name
function lsglil.getGUIElementByName(name)
	return GUIElements[name]
end

-- function to get element via data
-- TODO: poorly optimized, deprecate completely!
function lsglil.getGUIElementByData(element)
	for k, v in pairs(GUIElements) do
		if v == element then 
			return v 
		end
	end
end

-- function to insert a gui object table into the elements, as to make it able to be handled / rendered
function lsglil.addToGuiElements(obj)
	GUIElements[obj.name] = obj
end

-- delete all the gui objects
function lsglil.clearAllObjects()
	for k, v in pairs(GUIElements) do
		lsglil.deleteObject(v)
	end
end








--[[
	object modify functions
]]--

-- sets size
function lsglil.setSize(obj, w, h)
	obj.w = w
	obj.h = h
end

-- sets pos
function lsglil.setPos(obj, x, y)
	obj.x = x
	obj.y = y
end

-- sets color
function lsglil.setColor(obj, col)
	obj.col = col
end

-- sets hover color for whatever uses it
function lsglil.setHoverColor(obj, col)
	obj.hcol = col
end

-- sets the render mode of an object
function lsglil.setRender(obj, render)
	obj.render = render
end

-- allows overriding how an object renders
function lsglil.setDrawFunc(obj, func)
	obj.draw = func
end

-- sets the text contents of an object
function lsglil.setText(obj, text)
	obj.text = text
end

-- makes stuff draggable / not draggable
function lsglil.setDraggable(obj, bool)
	obj.draggable = bool
end

-- adds object to a frame
function lsglil.addToFrame(obj, frame)
	local name = obj.name
	lsglil.getGUIElementByData(frame).contents[name] = obj
end


-- indicates that there's children to be rendered
function lsglil.setHasChildrenToRender(obj, bool)
	obj.childrenderables = bool
end

-- set min value for anything needing it (scrolly, scrollx, etc.....)
function lsglil.setMin(obj, num)
	obj.min = num
end

-- set max value for anything needing it (scrolly, scrollx, etc.....)
function lsglil.setMax(obj, num)
	obj.max = num
end

-- set current value for anything needing it (scrolly, scrollx, etc.....)
function lsglil.setCurrent(obj, num)
	obj.current = num
end









--[[
	creation functions
]]--


-- makes a frame
function lsglil.makeFrame(name)
	local frame = {}
	frame.class = "frame"
	frame.x = 0
	frame.y = 0
	frame.w = 300
	frame.h = 200
	frame.name = name
	frame.contents = {}
	frame.col = col
	frame.dragging = false
	frame.text = "Frame Name"
	frame.draggable = true
	frame.childrenderables = true

	lsglil.addToGuiElements(frame)
	return frame, name
end

-- makes a close button for a frame
-- TODO: depreciate and implement into main frame make
function lsglil.makeFrameCloseButton(frame)
	frame.contents.buttonCloseFrame = lsglil.makeButton("buttonCloseFrame", function()
		local frame = lsglil.getGUIElementByName(frame.name)
		lsglil.deleteObject(frame)
	end)

	lsglil.setPos(frame.contents.buttonCloseFrame, frame.w - 16, 0)
	lsglil.setSize(frame.contents.buttonCloseFrame, 16, 16)
	lsglil.setColor(frame.contents.buttonCloseFrame, {0.6, 0, 0})
	lsglil.setRender(frame.contents.buttonCloseFrame, "fill")
	lsglil.setText(frame.contents.buttonCloseFrame, "X")
	lsglil.setHoverColor(frame.contents.buttonCloseFrame, {1, 0, 0})
end

-- makes a panel
-- TODO: depreciate and use addToGuiElements when needed
function lsglil.makePanel(name)
	local panel = {}
	panel.class = "panel"
	lsglil.initDefaultValues(panel)
	panel.name = name
	panel.render = "fill"
	panel.childrenderables = false

	return panel, name
end


-- makes a button
function lsglil.makeButton(name, func)
	local button = {}
	button.class = "button"
	lsglil.initDefaultValues(button)
	button.text = "undefined"
	button.onPress = func
	button.name = name
	button.col = {0.8, 0.8, 0.8}
	button.hcol = {1, 1, 1}
	button.preservecol = {0, 0, 0}
	button.hovering = false
	button.childrenderables = false

	return button, name
end


-- makes a label
function lsglil.makeLabel(name)
	local label = {}
	label.class = "label"
	label.x = 0
	label.y = 0
	label.w = 32
	label.h = 32
	label.text = "undefined"
	label.name = name
	label.col = {0.8, 0.8, 0.8}
	label.childrenderables = false

	return label, name
end









--[[
	press handling functions
]]--

lsglil.pressHandlerTable = {}

function lsglil.addElementToPressHandlerTable(name, func)
	lsglil.pressHandlerTable[name] = func
end


-- handle pressing on a button
lsglil.addElementToPressHandlerTable("button", function(v, mx, my, button)
	if not math.inrange(mx, v.x, v.x + v.w) then
		return
	end
	if not math.inrange(my, v.y, v.y + v.h) then 
		return
	end

	local err, msg = pcall(v.onPress)
	if not err then
		addNotification(msg, 2)
	end
end)

-- code that lets elements able to be pressed from gui frames
lsglil.addElementToPressHandlerTable("frame", function(v, mx, my, button)
	if v.dragging then 
		return 
	end

	local parent = v
	for k, v in pairs(v.contents) do
		if not (lsglil.pressHandlerTable[v.class] == nil) then
			pcall(lsglil.pressHandlerTable[v.class], v, (mx - parent.x), (my - parent.y), button)
		end
	end
end)


-- main loop to handle gui presses
function lsglil.handlePressOnGUI(mx, my, button, istouch, presses)
	for k, v in pairs(GUIElements) do

		if not (lsglil.pressHandlerTable[v.class] == nil) then
			pcall(lsglil.pressHandlerTable[v.class], v, mx, my, button)
		end

	end
end
















--[[
	dragging handling functions
]]--


-- init the table containing the dragging handler functions
lsglil.draggingHandlerTable = {}

-- helper func to add elements to the dragging table
function lsglil.addElementToDraggingHandlerTable(name, func)
	lsglil.draggingHandlerTable[name] = func
end


-- add a handler for dragging of frame
lsglil.addElementToDraggingHandlerTable("frame", function(mx, my, v)
	for k, v in pairs(v.contents) do

	end
	
	if v.dragging then
		if not (love.mouse.isDown(1)) then
			v.dragging = false
		end
		v.x = mx - v.moffset[1]
		v.y = my - v.moffset[2]
	end

	if not math.inrange(mx, v.x, v.x + v.w) then  
		return
	end

	if not math.inrange(my, v.y, v.y + (v.h / 8)) then 
		return
	end

	if love.mouse.isDown(1) and v.dragging == false then
		v.dragging = true
		local moffsetx = mx - v.x
		local moffsety = my - v.y 
		v.moffset = {moffsetx, moffsety}
	end

end)

-- main function to handle dragging
function lsglil.handleDragging()
	local mx, my = love.mouse.getPosition()
	for k, v in pairs(GUIElements) do
		if v.draggable then 
			pcall(lsglil.draggingHandlerTable[v.class], mx, my, v)
		end
	end
end















--[[
	hover handling functions
]]--


-- init the table containing the hover handler functions
lsglil.hoverHandlerTable = {}

-- helper func to add functions to the onHover table
function lsglil.addElementToHoverHandlerTable(name, func)
	lsglil.hoverHandlerTable[name] = func
end


-- add a hover handler to button
lsglil.addElementToHoverHandlerTable("button", function(v, mx, my)
	if not math.inrange(mx, v.x, v.x + v.w) then 
		if v.hovering then
			v.col = v.preservecol
			v.hovering = false
		end
		return
	end

	if not math.inrange(my, v.y, v.y + v.h) then 
		if v.hovering then
			v.col = v.preservecol
			v.hovering = false
		end
		return
	end

	if v.hovering then
		return
	end
	v.preservecol = v.col
	v.col = v.hcol
	v.hovering = true
end)

-- add a hover handler to frame, this loops through all the contents of it and tries running their hover handler
lsglil.addElementToHoverHandlerTable("frame", function(v, mx, my)
	if v.dragging then 
		return 
	end

	local parentFrame = v

	for k, v in pairs(v.contents) do
		pcall(lsglil.hoverHandlerTable[v.class], v, mx - parentFrame.x, my - parentFrame.y)
	end

end)

-- main function to handle hovering
function lsglil.handleHovering()
	local mx, my = love.mouse.getPosition()
	for k, v in pairs(GUIElements) do
		pcall(lsglil.hoverHandlerTable[v.class], v, mx, my)
	end
end














--[[
	render functions
]]--


-- init the table containing the rendering functions
lsglil.renderTable = {}

-- helper func to add elements to the render table
function lsglil.addElementToRenderTable(name, func)
	lsglil.renderTable[name] = func
end


-- define default drawing for frames
-- TODO: move all of this to a diff file for theme support
lsglil.addElementToRenderTable("frame", function(v, offx, offy)

	if lsglil.CanvasElements[v.name] == nil then
		lsglil.CanvasElements[v.name] = love.graphics.newCanvas(v.w, v.h)
	end

	love.graphics.setCanvas(lsglil.CanvasElements[v.name])
		love.graphics.clear()

		love.graphics.setLineStyle("rough")
		love.graphics.setLineWidth(1)

		love.graphics.setColor(0, 0, 0, 0.3)
		love.graphics.rectangle("fill", (v.w * 0.05), (v.h * 0.05), v.w, v.h)


		love.graphics.setColor(0.764, 0.764, 0.764, 1)
		love.graphics.rectangle("fill", 0, 0, v.w, v.h)

		love.graphics.setColor(v.col[1], v.col[2], v.col[3])
		love.graphics.rectangle("fill", (v.w / 95), 4, v.w * 0.975, v.h / 12)

		love.graphics.setColor(1, 1, 1)
		love.graphics.print(v.text, (v.w / 95), 4)


		for i = 0, 1 do
			local col = 0.05 + (i / 4)
			love.graphics.setColor(col, col, col)
			love.graphics.line(
				i, (v.h) - i,
			 	(v.w) - i, (v.h) - i,
			 	(v.w) - i, (i)
			 )
		end

		for i = 0, 1 do
			local col = 0.45
			if i == 0 then
				col = 0.0
			end
			love.graphics.setColor(col, col, col)
			love.graphics.line(
				(i) + (v.w * 0.025), ((v.h) - i) - (v.h * 0.025), 
				(i) + (v.w * 0.025), (-i) + (v.h * 0.15),
				(i) + (v.w * 0.975), (-i) + (v.h * 0.15)
			)
		end	

		for i = 0, 1 do
			local col = 0.60
			if i == 0 then
				col = 0.75
			end
			love.graphics.setColor(col, col, col)
			love.graphics.line(
				(- i)+ (v.w * 0.025), ((v.h) - i) - (v.h * 0.025), 
				(- i)+ (v.w * 0.975), ((v.h) - i) - (v.h * 0.025),
				(- i)+ (v.w * 0.975), (-i) + (v.h * 0.1475)
			)
		end	
	love.graphics.setCanvas()
end)


-- define default drawing for buttons
-- TODO: win9x style
-- TODO: move all of this to a diff file for theme support
lsglil.addElementToRenderTable("button", function(v, offx, offy)
	love.graphics.setColor(v.col[1], v.col[2], v.col[3])
	love.graphics.rectangle(v.render, v.x+offx, v.y+offy, v.w, v.h)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(v.text, (v.x + (v.w / 2)) + offx, (v.y + (v.h / 2)) + offy, 0, 1, 1, (#v.text * 4), 8)
end)


-- define default drawing for labels
-- TODO: win9x style
-- TODO: move all of this to a diff file for theme support
lsglil.addElementToRenderTable("label", function(v, offx, offy)
	love.graphics.setColor(v.col[1], v.col[2], v.col[3])
	love.graphics.print(v.text, (v.x + (v.w / 2)) + offx, (v.y + (v.h / 2)) + offy, 0, 1, 1, (#v.text * 4), 8)
end)


-- define default drawing for panels
-- TODO? win9x stile
-- TODO: move all of this to a diff file for theme support
lsglil.addElementToRenderTable("panel", function(v, offx, offy)
	love.graphics.setColor(v.col[1], v.col[2], v.col[3])
	love.graphics.rectangle(v.render, v.x+offx, v.y+offy, v.w, v.h)
end)


-- function to render ui elements
-- checks if the GUI element it receives has its draw method overriden
-- if it does, we try to draw using that, otherwise we try to draw using the defaults
-- this function calls itself when rendering frame contents using the canvas of the frame to avoid clipping outside and allow for scrolling
function lsglil.renderUIElement(k, v, offx, offy)
	if not (v == nil) then
		if not (v.draw == nil) then
			pcall(v.draw, v)
		else
			pcall(lsglil.renderTable[v.class], v, offx, offy)
		end

		if v.childrenderables == true then
			local fx, fy = v.x, v.y

			if lsglil.CanvasElements[v.name] == nil then
				lsglil.CanvasElements[v.name] = love.graphics.newCanvas(v.w, v.h)
			end

			love.graphics.setCanvas(lsglil.CanvasElements[v.name])
				for k, v in pairs(v.contents) do
					love.graphics.setColor(1, 1, 1, 1)
					love.graphics.setBlendMode("alpha", "premultiplied")
					lsglil.renderUIElement(k, v, 0, 0)
				end
			love.graphics.setCanvas()
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.setBlendMode("alpha", "premultiplied")
			love.graphics.draw(lsglil.CanvasElements[v.name], v.x, v.y)

			love.graphics.setBlendMode("alpha")
		end

	end
end

-- this is called every render to render all gui elements
function lsglil.renderGUI()
	for k, v in pairs(GUIElements) do
		lsglil.renderUIElement(k, v, 0, 0)
	end
end