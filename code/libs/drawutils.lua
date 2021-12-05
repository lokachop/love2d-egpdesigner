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

function renderEGPRectangle(dmode, x, y, w, h, ang)
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(ang)
	love.graphics.rectangle(dmode, 0 - w / 2, 0 - h / 2, w, h)
	love.graphics.pop()
end

function renderEGPPolyFull(polydata)

	local tabltorender = {}

	for k, v in pairs(polydata) do 
		tabltorender[#tabltorender + 1] = v[1]
		tabltorender[#tabltorender + 1] = v[2]
	end

	--for k, v in pairs(tabltorender) do
		--addNotification("["..tostring(k).."]: "..tostring(v), 2)
	--end

	local tris = love.math.triangulate(tabltorender)

	for k, v in pairs(tris) do
		love.graphics.polygon("fill", v)
	end
end

function renderEGPLine(sx, sy, ex, ey)

end