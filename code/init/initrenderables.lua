local function makeHSV2RGBCanvas()
    local w, h = love.graphics.getDimensions()

    if (rgbcanvas == nil) then
        rgbcanvas = love.graphics.newCanvas(w, 32)
    end

    love.graphics.setCanvas(rgbcanvas)

    for i = 0, w do
        local calci = ((i / w) * 360) / 360
        local r, g, b = hsvToRGB(calci, CurrSaturation, CurrBrightness)
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle("fill", i, 0, w / 360, 32)
    end

    love.graphics.setCanvas()

    return rgbcanvas
end

local function makeBrightnessCanvas()
    local w, h = love.graphics.getDimensions()

    if (brightnesscanvas == nil) then
        brightnesscanvas = love.graphics.newCanvas(w, 32)
    end

    love.graphics.setCanvas(brightnesscanvas)

    for i = 0, w do
        local calci = ((i / w) * 360) / 360
        local r, g, b = hsvToRGB(egplib.CurrDrawData.colx, CurrSaturation, calci)
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle("fill", i, 0, w / 360, 32)
    end

    love.graphics.setCanvas()

    return brightnesscanvas
end

local function makeSaturationCanvas()
    local w, h = love.graphics.getDimensions()

    if (saturationcanvas == nil) then
        saturationcanvas = love.graphics.newCanvas(w, 32)
    end

    love.graphics.setCanvas(saturationcanvas)

    for i = 0, w do
        local calci = ((i / w) * 360) / 360
        local r, g, b = hsvToRGB(egplib.CurrDrawData.colx, calci, CurrBrightness)
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle("fill", i, 0, w / 360, 32)
    end

    love.graphics.setCanvas()

    return saturationcanvas
end

function renderIcon()
    local ioffx = DrawOffset[1]
    local ioffy = DrawOffset[2]
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(background, backgroundQuad, (ioffx + 256) - ((ImageScale / 2) * 512), (ioffy + 256) - ((ImageScale / 2) * 512), 0, ImageScale, ImageScale)
    love.graphics.setColor(0.1, 0.1, 0.15, 0.5)
    love.graphics.rectangle("fill", (ioffx + 256) - ((ImageScale / 2) * 512), (ioffy + 256) - ((ImageScale / 2) * 512), 512 * ImageScale, 512 * ImageScale)
end

function renderBorder()
    local w, h = love.graphics.getDimensions()
    local offx = ColourOffset[1]
    local offy = ColourOffset[2]
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(1)
    love.graphics.line(0 + offx, 513 + offy, w + offx, 513 + offy)
    love.graphics.line(128 + offx, 513 + offy, 128 + offx, 640 + offy)
    love.graphics.line(0 + offx, 640 + offy, w + offx, 640 + offy)
    local canv = makeHSV2RGBCanvas()
    local canv2 = makeBrightnessCanvas()
    local canv3 = makeSaturationCanvas()
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(canv, 0 + offx, 641 + offy)
    love.graphics.draw(canv2, 0 + offx, 641 + 32 + offy)
    love.graphics.draw(canv3, 0 + offx, 641 + 64 + offy)
    love.graphics.setBlendMode("alpha")
end

function initEGPDrawerGUI()
    local offx = ColourOffset[1]
    local offy = ColourOffset[2]

    local buttonexport, _ = lsglil.makeButton("savebutton", function()
        egplib.exportEGPData()
    end)

    lsglil.setPos(buttonexport, 0 + offx, 514 + offy)
    lsglil.setSize(buttonexport, 127, 32)
    lsglil.setText(buttonexport, "Export!")
    lsglil.setRender(buttonexport, "fill")

    lsglil.setColor(buttonexport, {0, 0.15, 0.3})

    lsglil.setHoverColor(buttonexport, {0, 0.5, 1})

    lsglil.addToGuiElements(buttonexport)

    local buttonExportGPU, _ = lsglil.makeButton("buttonExportGPU", function()
        egplib.exportEGPDataAsGPU()
    end)

    lsglil.setPos(buttonExportGPU, 0 + offx, 514 + 34 + offy)
    lsglil.setSize(buttonExportGPU, 127, 32)
    lsglil.setText(buttonExportGPU, "Export as GPU")
    lsglil.setRender(buttonExportGPU, "fill")

    lsglil.setColor(buttonExportGPU, {0, 0.15, 0.3})

    lsglil.setHoverColor(buttonExportGPU, {0, 0.5, 1})

    lsglil.addToGuiElements(buttonExportGPU)

    local buttonTransparency, _ = lsglil.makeButton("buttonTransparency", function()
        egplib.toggleTransparency()
    end)

    lsglil.setPos(buttonTransparency, 0 + offx, 514 + 68 + offy)
    lsglil.setSize(buttonTransparency, 127, 32)
    lsglil.setText(buttonTransparency, "Transparency")
    lsglil.setRender(buttonTransparency, "fill")

    lsglil.setColor(buttonTransparency, {0, 0.15, 0.3})

    lsglil.setHoverColor(buttonTransparency, {0, 0.5, 1})

    lsglil.addToGuiElements(buttonTransparency)
end