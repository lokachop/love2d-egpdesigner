local function makeHSV2RGBCanvas()
	--if (rgbcanvas == nil) then
		rgbcanvas = love.graphics.newCanvas(512, 32)
		love.graphics.setCanvas(rgbcanvas)
			for i = 0, 512 do
				local calci = ((i/512) * 360) / 360
				local r, g, b = hsvToRGB(calci, CurrSaturation, CurrBrightness)
				love.graphics.setColor(r, g, b)
				love.graphics.rectangle("fill", i, 0, (512/360), 32)
			end
		love.graphics.setCanvas()
	--end
	return rgbcanvas
end

local function makeBrightnessCanvas()
	if (brightnesscanvas == nil) then
		brightnesscanvas = love.graphics.newCanvas(512, 32)
		love.graphics.setCanvas(brightnesscanvas)
			for i = 0, 512 do
				local calci = ((i/512) * 360) / 360
				love.graphics.setColor(calci, calci, calci)
				love.graphics.rectangle("fill", i, 0, (512/360), 32)
			end
		love.graphics.setCanvas()
	end
	return brightnesscanvas
end

local function makeSaturationCanvas()
	if (saturationcanvas == nil) then
		saturationcanvas = love.graphics.newCanvas(512, 32)
		love.graphics.setCanvas(saturationcanvas)
			for i = 0, 512 do
				local calci = ((i/512) * 360) / 360
				local r, g, b = hsvToRGB(0, calci, 1)
				love.graphics.setColor(r, g, b)
				love.graphics.rectangle("fill", i, 0, (512/360), 32)
			end
		love.graphics.setCanvas()
	end
	return saturationcanvas
end

function renderBorder()
	local w, h = love.graphics.getDimensions()

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(background)

	love.graphics.setColor(0.1, 0.1, 0.15, 0.5)
	love.graphics.rectangle("fill", 0, 0, 512, 512)


	love.graphics.setColor(1, 1, 1)
	love.graphics.setLineWidth(1)
	love.graphics.line(0, 513, 512, 513)

	love.graphics.line(128, 513, 128, 640)

	love.graphics.line(0, 640, 512, 640)

	local canv = makeHSV2RGBCanvas()
	local canv2 = makeBrightnessCanvas()
	local canv3 = makeSaturationCanvas()

	love.graphics.setBlendMode("alpha", "premultiplied")
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(canv, 0, 641)
	love.graphics.draw(canv2, 0, 641+32)
	love.graphics.draw(canv3, 0, 641+64)
	love.graphics.setBlendMode("alpha")
end


function initEGPDrawerGUI()
	local buttonexport, name = lsglil.makeButton("savebutton", function()
		egplib.exportEGPData()
	end)
	lsglil.setPos(buttonexport, 0, 514)
	lsglil.setSize(buttonexport, 127, 32)
	lsglil.setText(buttonexport, "Export!")
	lsglil.setRender(buttonexport, "fill")
	lsglil.setColor(buttonexport, {0, 0.15, 0.3})
	lsglil.setHoverColor(buttonexport, {0, 0.5, 1})

	lsglil.addToGuiElements(buttonexport)


	local buttonTransparency, name = lsglil.makeButton("buttonTransparency", function()
		egplib.toggleTransparency()
	end)
	lsglil.setPos(buttonTransparency, 0, 514 + 34)
	lsglil.setSize(buttonTransparency, 127, 32)
	lsglil.setText(buttonTransparency, "Transparency")
	lsglil.setRender(buttonTransparency, "fill")
	lsglil.setColor(buttonTransparency, {0, 0.15, 0.3})
	lsglil.setHoverColor(buttonTransparency, {0, 0.5, 1})

	lsglil.addToGuiElements(buttonTransparency)

end

