egplib = egplib or {}
egplib.egpObjects = {}
egplib.egpRenderTable = {}

egplib.exporterSettings = {
    useFunction = false
}

egplib.CurrDrawData = {
    id = 0,
    hasPoly = false,
    points = {},
    colx = 0
}

egplib.egpRenderTable["box"] = function(obj)
    love.graphics.setColor(obj.col.r / 255, obj.col.g / 255, obj.col.b / 255)
    local x = obj.x
    local y = obj.y
    local w = obj.w
    local h = obj.h
    local ang = obj.ang
    renderEGPRectangle("fill", x - w / 2, y - h / 2, w, h, ang)
end

function egplib.addEGPBox(id, pos, siz)
    local box = {
        col = {
            r = 255,
            g = 255,
            b = 255
        },
        x = pos[1],
        y = pos[2],
        w = siz[1],
        h = siz[2],
        type = "box",
        ang = 0,
        id = id
    }

    egplib.egpObjects[id] = box
end

egplib.egpRenderTable["poly"] = function(obj)
    local transp

    if DoTransparency then
        transp = 0.4
    else
        transp = 1
    end

    love.graphics.setColor(obj.col.r / 255, obj.col.g / 255, obj.col.b / 255, transp)
    pcall(renderEGPPolyFull, obj.pdata)
end

function egplib.addEGPPoly(id, ...)
    local poly = {
        col = {
            r = 255,
            g = 255,
            b = 255
        },
        pdata = {},
        type = "poly",
        ang = 0,
        id = id
    }

    local args = {...}

    for k, v in pairs(args) do
        poly.pdata[k] = v
    end

    egplib.egpObjects[id] = poly
end

function egplib.setEGPPosID(id, pos)
    egplib.egpObjects[id].x = pos[1]
    egplib.egpObjects[id].y = pos[2]
end

function egplib.setEGPAngID(id, ang)
    egplib.egpObjects[id].ang = ang
end

function egplib.setEGPColorID(id, col)
    egplib.egpObjects[id].col = {
        r = col[1],
        g = col[2],
        b = col[3]
    }
end

function egplib.addPolyPoint(id, point)
    table.insert(egplib.egpObjects[id].pdata, point)
end

function egplib.existsPolyDraw(id)
    if egplib.egpObjects[id] ~= nil then
        if egplib.egpObjects[id].type == "poly" then
            return true
        else
            return false
        end
    else
        return false
    end
end

function egplib.removeLastPolyPoint(id)
    if egplib.existsPolyDraw(id) and egplib.egpObjects[id].pdata ~= nil then
        egplib.egpObjects[id].pdata[#egplib.egpObjects[id].pdata] = nil
    end
end

function egplib.exists(id)
    if egplib.egpObjects[id] ~= nil then
        return true
    else
        return false
    end
end

function egplib.getPolyCount(id)
    if egplib.existsPolyDraw(id) then
        return #egplib.egpObjects[id].pdata
    else
        return nil
    end
end

function egplib.getPolyData(id)
    if egplib.exists(id) then
        return egplib.egpObjects[id].pdata
    else
        return nil
    end
end

function egplib.removeObject(id)
    egplib.egpObjects[id] = nil
end

function egplib.renderEGPObjects()
    for k, v in pairs(egplib.egpObjects) do
        pcall(egplib.egpRenderTable[v.type], v)
    end

    if egplib.existsPolyDraw(egplib.CurrDrawData.id) then
        for k, v in pairs(egplib.getPolyData(egplib.CurrDrawData.id)) do
            love.graphics.setColor(1, 0, 0)

            local offset = screenToTranslated({v[1], v[2]})

            renderEGPRectangle("fill", offset[1], offset[2], 2, 2, 0)
        end
    end
end

function egplib.renderDrawingData(x, y)
    local objcount = 0

    for k, v in pairs(egplib.egpObjects) do
        objcount = objcount + 1
    end

    love.graphics.setColor(0, 255, 0)
    love.graphics.print("Objects: " .. tostring(objcount), x, y)
    tricount = 0

    for k, v in pairs(egplib.egpObjects) do
        local tritabl = {}

        if v.type == "poly" then
            for k, v in pairs(v.pdata) do
                tritabl[#tritabl + 1] = v[1]
                tritabl[#tritabl + 1] = v[2]
            end

            local ran, tris = pcall(love.math.triangulate, tritabl)

            if ran then
                for k, v in pairs(tris) do
                    tricount = tricount + 1
                end
            end
        end
    end

    love.graphics.print("EGPObjects: " .. tostring(tricount), x, y + 16)
    love.graphics.print("TotalObjects: " .. tostring(objcount + tricount), x, y + (16 * 2))
end

local function polyDrawRemovePoint()
    if egplib.getPolyCount(egplib.CurrDrawData.id) ~= 0 then
        egplib.removeLastPolyPoint(egplib.CurrDrawData.id)
    else
        egplib.removeObject(egplib.CurrDrawData.id)

        return
    end
end

local function polyDrawAddPoint(x, y)
    local fpos = screenToTranslatedMouse({x, y})

    egplib.addPolyPoint(egplib.CurrDrawData.id, {fpos[1], fpos[2]})

    addNotification("add point", 2)
end

local function polyDrawInit(x, y)
    local fpos = screenToTranslatedMouse({x, y})

    egplib.addEGPPoly(egplib.CurrDrawData.id, fpos)
    egplib.CurrDrawData.hasPoly = true
    addNotification("poly nil, made", 2)
end

local function polyDrawCurrObjSetCol(r, g, b)
    if egplib.exists(egplib.CurrDrawData.id) then
        egplib.setEGPColorID(egplib.CurrDrawData.id, {r, g, b})
    end
end

local function setColorOffX(x)
    local w, h = love.graphics.getDimensions()
    local xcalc = ((x / w) * 360) / 360
    egplib.CurrDrawData.colx = xcalc
    local r, g, b = hsvToRGB(egplib.CurrDrawData.colx, CurrSaturation, CurrBrightness)
    r = math.floor(r * 255)
    g = math.floor(g * 255)
    b = math.floor(b * 255)
    polyDrawCurrObjSetCol(r, g, b)
    addNotification("set col to r:" .. tostring(r) .. " g:" .. tostring(g) .. " b:" .. tostring(b), 2)
end

local function setBrightnessOffX(x)
    local w, h = love.graphics.getDimensions()
    local xcalc = ((x / w) * 360) / 360
    CurrBrightness = xcalc
    local r, g, b = hsvToRGB(egplib.CurrDrawData.colx, CurrSaturation, CurrBrightness)
    r = math.floor(r * 255)
    g = math.floor(g * 255)
    b = math.floor(b * 255)
    polyDrawCurrObjSetCol(r, g, b)
end

local function setSaturationOffX(x)
    local w, h = love.graphics.getDimensions()
    local xcalc = ((x / w) * 360) / 360
    CurrSaturation = xcalc
    local r, g, b = hsvToRGB(egplib.CurrDrawData.colx, CurrSaturation, CurrBrightness)
    r = math.floor(r * 255)
    g = math.floor(g * 255)
    b = math.floor(b * 255)
    polyDrawCurrObjSetCol(r, g, b)
end

function egplib.handleDrawing(x, y, button, istouch, presses)
    local mx, my = love.mouse.getPosition()

    if egplib.DrawingPoly then
        if button == 1 then
            if egplib.existsPolyDraw(egplib.CurrDrawData.id) then
                polyDrawAddPoint(mx, my)
            else
                polyDrawInit(mx, my)
            end
        elseif button == 2 then
            polyDrawRemovePoint()
        end
    else
        if button == 1 then
            local offy = ColourOffset[2]

            if math.inrange(y, 641 + offy, (641 + 32) + offy) then
                setColorOffX(x)
            elseif math.inrange(y, (641 + 32) + offy, (641 + 64) + offy) then
                setBrightnessOffX(x)
            elseif math.inrange(y, (641 + 64) + offy, (641 + 92) + offy) then
                setSaturationOffX(x)
            end
        end
    end
end

function egplib.handleDragging(x, y, dx, dy)
    if love.mouse.isDown(3) then
        DrawOffset[1] = DrawOffset[1] + (dx / 1)
        DrawOffset[2] = DrawOffset[2] + (dy / 1)
    end
end

function egplib.handleZooming(x, y)
    ImageScale = ImageScale + (y / 16)
    local w, h = love.graphics.getDimensions()
    local mx, my = love.mouse.getPosition()
    mx = mx - w / 2
    my = my - h / 2
    mx = mx * ImageScale
    my = my * ImageScale
    addNotification("ImageScale now " .. tostring(ImageScale), 2)
end

function egplib.toggleDrawing()
    if egplib.DrawingPoly == false then
        egplib.DrawingPoly = true
    else
        egplib.DrawingPoly = false
    end
end

function egplib.handleDrawingKeyboard(key, scancode, isrepeat)
    if key == "w" then
        egplib.CurrDrawData.id = egplib.CurrDrawData.id + 1
        addNotification("id set to " .. tostring(egplib.CurrDrawData.id), 2)
    elseif key == "s" then
        egplib.CurrDrawData.id = egplib.CurrDrawData.id - 1
        addNotification("id set to " .. tostring(egplib.CurrDrawData.id), 2)
    elseif key == "space" then
        egplib.toggleDrawing()
        addNotification("Toggled drawing, now " .. tostring(egplib.DrawingPoly), 2)
    end
end

function egplib.toggleTransparency()
    if DoTransparency == false then
        DoTransparency = true
    else
        DoTransparency = false
    end

    addNotification("transparency now " .. tostring(DoTransparency), 2)
end

function egplib.typeToE2Name(typeget)
    if typeget == "rect" then
        return "Box"
    elseif typeget == "poly" then
        return "Poly"
    end
end

local function exportBox(v, currID)
    local code = ""
    code = code .. "\n    EGP:egpBox(" .. currID .. ", vec2(" .. v.x .. ", " .. v.y .. "), vec2(" .. v.w .. ", " .. v.h .. "))"
    code = code .. "\n    EGP:egpColor(" .. currID .. ", vec(" .. v.col.r .. ", " .. v.col.g .. ", " .. v.col.b .. "))"
    code = code .. "\n    EGP:egpAngle(" .. currID .. ", " .. v.ang .. ")\n"

    return code, 0
end

local function exportPoly(poly, currID)
    local code = ""
    local IDAddCount = 0
    local tabltotriangulate = {}
    local offx = 0 --DrawOffset[1]
    local offy = 0 --DrawOffset[2]

    for k, v in pairs(egplib.getPolyData(poly.id)) do
        tabltotriangulate[#tabltotriangulate + 1] = v[1]
        tabltotriangulate[#tabltotriangulate + 1] = v[2]
    end

    -- its x, y stuff, so we have to compare against 6
    if #tabltotriangulate < 6 then
        code = code .. "\n\n    #This object had < 3 points, skipped!"
        addNotification("Tried to export < 3 point polygon, skipping!", 2)

        return code, IDAddCount
    end

    local tris = love.math.triangulate(tabltotriangulate)
    code = code .. "\n    \n    local ColourOBJ" .. currID .. " = vec(" .. poly.col.r .. ", " .. poly.col.g .. ", " .. poly.col.b .. ")"

    for k, v in pairs(tris) do
        local c1 = math.floor(v[1] - offx)
        local c2 = math.floor(v[2] - offy)
        local c3 = math.floor(v[3] - offx)
        local c4 = math.floor(v[4] - offy)
        local c5 = math.floor(v[5] - offx)
        local c6 = math.floor(v[6] - offy)
        code = code .. "\n    EGP:egpTriangle(IDOff + " .. tostring(currID + IDAddCount) .. ", vec2(" .. c1 .. ", " .. c2 .. "), vec2(" .. c3 .. ", " .. c4 .. "), vec2(" .. c5 .. ", " .. c6 .. "))"
        code = code .. "\n    EGP:egpColor(IDOff + " .. tostring(currID + IDAddCount) .. ", ColourOBJ" .. currID .. ")"
        IDAddCount = IDAddCount + 1
    end

    return code, IDAddCount
end

function egplib.exportEGPData()
    addNotification("Exporting current egp data!", 4)
    local currID = 0
    local code = [[
@name EGPLibExported
@inputs EGP:wirelink
]]

    if egplib.exporterSettings.useFunction then
        code = code .. "\nfunction drawExported()\n{"
    else
        code = code .. "\nif(first()|dupefinished())\n{\n    EGP:egpClear()\n    local IDOff = 0"
    end

    for k, v in pairs(egplib.egpObjects) do
        currID = currID + 1

        if v.type == "rect" then
            addNotification("exporting cube", 4)
            code = code .. exportBox(v, currID)
        elseif v.type == "poly" then
            addNotification("exporting polygon", 4)
            local cget, IDAddCount = exportPoly(v, currID)
            code = code .. cget
            currID = currID + IDAddCount
        end
    end

    if egplib.exporterSettings.useFunction then
        code = code .. "\n}"
    else
        code = code .. "\n}\n\nif(~EGP)\n{\n    reset()\n}\n\n#exported with lokachop's EGPDesignHelper, contact Lokachop#5862"
    end

    addNotification("saving file!", 4)
    local f = love.filesystem.newFile("exported.txt")
    f:open("w")
    f:write(code)
    f:close()
    love.system.openURL("file://" .. love.filesystem.getSaveDirectory())
end


local function exportPolyGPU(poly, currID)
    local code = ""
    local postCode = ""
    local IDAddCount = 0
    local tabltotriangulate = {}

    for k, v in pairs(egplib.getPolyData(poly.id)) do
        tabltotriangulate[#tabltotriangulate + 1] = v[1]
        tabltotriangulate[#tabltotriangulate + 1] = v[2]
    end

    -- its x, y stuff, so we have to compare against 6
    if #tabltotriangulate < 6 then
        code = code .. "\n\n//This object had < 3 points, skipped!"
        addNotification("Tried to export < 3 point polygon, skipping!", 2)

        return code, "", IDAddCount
    end
    code = code .. "\n\n\ndcolor polycol" .. currID .. ";"
    postCode = postCode .. "\n\n\ncolor polycol" .. currID .. ", " .. poly.col.r .. ", " .. poly.col.g .. ", " .. poly.col.b .. ";"

    local tris = love.math.triangulate(tabltotriangulate)

    for k, v in pairs(tris) do
        local c1 = math.floor(v[1])
        local c2 = math.floor(v[2])

        local c3 = math.floor(v[3])
        local c4 = math.floor(v[4])

        local c5 = math.floor(v[5])
        local c6 = math.floor(v[6])
        code = code .. "\ndvxdata_2f polydata" .. tostring(currID + IDAddCount) .. ", 3;"
        postCode = postCode .. "\npolydata" .. tostring(currID + IDAddCount) .. ":\ndb " .. c1 .. ", " .. c2 .. ";\ndb " .. c3 .. ", " .. c4 .. ";\ndb " .. c5 .. ", " .. c6 .. ";"
        IDAddCount = IDAddCount + 1
    end

    return code, postCode, IDAddCount
end


function egplib.exportEGPDataAsGPU()
    local code = "dclrscr base;\n"
    local codePost = "\n\ndexit;\ncolor base, 0, 0, 0;"
    local currID = 0

    for k, v in pairs(egplib.egpObjects) do
        currID = currID + 1

        if v.type == "poly" then
            addNotification("exporting polygon", 4)
            local cget, pcget, IDAddCount = exportPolyGPU(v, currID)
            code = code .. cget
            codePost = codePost .. pcget
            currID = currID + IDAddCount
        end
    end

    codePost = codePost .. "\n// exported with lokachop's love2d egp designer!\n// https://github.com/lokachop/love2d-egpdesigner"

    addNotification("saving file!", 4)
    local f = love.filesystem.newFile("exported_gpu.txt")
    f:open("w")
    f:write(code .. codePost)
    f:close()
    love.system.openURL("file://" .. love.filesystem.getSaveDirectory())
end