function hsvToRGB(h, s, v)
  local r, g, b

  local i = math.floor(h * 6);
  local f = h * 6 - i;
  local p = v * (1 - s);
  local q = v * (1 - f * s);
  local t = v * (1 - (1 - f) * s);

  i = i % 6

  if i == 0 then r, g, b = v, t, p
  elseif i == 1 then r, g, b = q, v, p
  elseif i == 2 then r, g, b = p, v, t
  elseif i == 3 then r, g, b = p, q, v
  elseif i == 4 then r, g, b = t, p, v
  elseif i == 5 then r, g, b = v, p, q
  end

  return r, g, b
end

function screenToTranslated(vec)
	local w, h = love.graphics.getDimensions()


	local transform = love.math.newTransform()
	transform:translate(w / 2, h / 2)
	transform:scale(ImageScale)
	transform:translate(-w / 2, -h / 2)
	transform:translate(DrawOffset[1], DrawOffset[2])
	local fx, fy = transform:transformPoint(vec[1], vec[2])
	return {fx, fy}
end

function screenToTranslatedMouse(vec)
	local fx = vec[1] - (DrawOffset[1])
	local fy = vec[2] - DrawOffset[2]

	return {fx, fy}
end



function renderEGPRectangle(dmode, x, y, w, h, ang)
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(ang)
	love.graphics.rectangle(dmode, 0 - w / 2, 0 - h / 2, w, h)
	love.graphics.pop()
end

function renderEGPPolyFull(polydata)
	local w, h = love.graphics.getDimensions()
	local tabltorender = {}

	for k, v in pairs(polydata) do 
		local fpos = screenToTranslated(v)

		tabltorender[#tabltorender + 1] = (fpos[1])
		tabltorender[#tabltorender + 1] = (fpos[2])
	end

	local tris = love.math.triangulate(tabltorender)

	for k, v in pairs(tris) do
		love.graphics.polygon("fill", v)
	end
end

function renderEGPLine(sx, sy, ex, ey)

end