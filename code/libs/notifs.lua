


function initNotifications()
	notifications = {["COUNT"] = 0}
end

function notificationThink()
	local count = 0
	for k, v in pairs(notifications) do
		if k ~= "COUNT" then
			count = count + 1
			if CurTime >= v[2] then
				table.remove(notifications, k)
				count = count - 1
			end
		end
	end
	notifications["COUNT"] = count


end


function addNotification(text, length)
	table.insert(notifications, 1, {
		text,
		CurTime + length,
		length
	})
	notifications["COUNT"] = notifications["COUNT"] + 1
end


function renderNotifications(x, y)
	for k, v in pairs(notifications) do
		if k ~= "COUNT" then
			love.graphics.setColor(1, 0.85, 0.2, (v[2] - CurTime) / v[3])
			love.graphics.print(v[1], x, y + (k * 16) - 16)
		end
	end

end