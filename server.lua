local playerBlips = {}

exports.callbacks:registerServerCallback("custom_blips:getPlayerBlips", function(source)
	return playerBlips
end)

local function getRandomColour()
	return {math.random(0, 255), math.random(0, 255), math.random(0, 255)}
end

local function customizePlayerBlip(player, settings)
	player = tostring(player)

	if not playerBlips[player] then
		playerBlips[player] = {}
	end

	--[[
	if settings.sprite then
		playerBlips[player].sprite = settings.sprite
	end
	]]

	if settings.colour then
		playerBlips[player].colour = settings.colour
	end

	TriggerClientEvent("custom_blips:saveSettings", player, playerBlips[player])
end

AddEventHandler('onResourceStart', function(resourceName)
	if GetCurrentResourceName() == resourceName then
		for _, player in ipairs(GetPlayers()) do
			customizePlayerBlip(player, {colour = getRandomColour()})
		end
	end
end)

AddEventHandler('playerJoining', function()
	customizePlayerBlip(source, {colour = getRandomColour()})
end)

RegisterNetEvent("custom_blips:setBlipSettings", function(settings)
	customizePlayerBlip(source, settings)
end)

RegisterCommand('blipcolour', function(source, args, raw)
	local colour

	if #args == 0 then
		colour = getRandomColour()
	elseif #args == 1 then
		local r, g, b = args[1]:match("#?(%x%x?)(%x%x?)(%x%x?)")

		if not (r and g and b) then
			print("Invalid hex colour code: " .. args[1])
			return
		end

		if r:len() == 1 then
			r = r .. r
		end
		if g:len() == 1 then
			g = g .. g
		end
		if b:len() == 1 then
			b = b .. b
		end

		local r1 = tonumber(r, 16)
		local g1 = tonumber(g, 16)
		local b1 = tonumber(b, 16)

		if r1 < 0 or r1 > 255 or g1 < 0 or g1 > 255 or b1 < 0 or b1 > 255 then
			print("Hex colour out of range")
			return
		end

		colour = {r1, g1, b1}
	else
		local r = tonumber(args[1]) or 255
		local g = tonumber(args[2]) or 255
		local b = tonumber(args[3]) or 255

		colour = {r, g, b}
	end

	customizePlayerBlip(source, {colour = colour})

	TriggerClientEvent("chat:addMessage", source, {
		color = colour,
		args = {("███ ^0Your blip colour was set to ^1%d ^2%d ^5%d"):format(colour[1], colour[2], colour[3])}
	})
end, true)

--[[
RegisterCommand("blipsprite", function(source, args, raw)
	local sprite = tonumber(args[1])
	customizePlayerBlip(source, {sprite = sprite})
end, true)
]]
