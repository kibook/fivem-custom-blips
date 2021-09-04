RegisterNetEvent("custom_blips:saveSettings", function(settings)
	SetResourceKvp("blipSettings", json.encode(settings))
end)

Citizen.CreateThread(function()
	TriggerEvent("chat:addSuggestion", "/blipcolour", "Change blip colour", {
		{name = "colour", "Can be specified with RGB (231 151 184) or a hex code (e797b8)"}
	})

	local settings = json.decode(GetResourceKvpString("blipSettings"))

	if settings then
		TriggerServerEvent("custom_blips:setBlipSettings", settings)
	end

	while true do
		exports.callbacks:triggerServerCallback("custom_blips:getPlayerBlips", function(playerBlips)
			for serverId, blipInfo in pairs(playerBlips) do
				serverId = tonumber(serverId)

				local player = GetPlayerFromServerId(serverId)

				if player ~= -1 then
					local blip

					if player == PlayerId() then
						blip = GetMainPlayerBlipId()
					else
						blip = GetBlipFromEntity(GetPlayerPed(player))
					end

					ShowOutlineIndicatorOnBlip(blip, true)

					--[[
					if blipInfo.sprite then
						SetBlipSprite(blip, blipInfo.sprite)
					end
					]]

					if blipInfo.colour then
						SetBlipSecondaryColour(blip, blipInfo.colour[1], blipInfo.colour[2], blipInfo.colour[3])
					end
				end
			end
		end)

		Citizen.Wait(2000)
	end
end)
