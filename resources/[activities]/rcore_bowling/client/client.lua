function GetTargetPlayers()
	local serverIds = {}
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	
	for _, playerId in pairs(GetActivePlayers()) do
		local targetPed = GetPlayerPed(playerId)
		local targetCoords = GetEntityCoords(targetPed)

		if #(targetCoords - coords) < 120.0 then
			table.insert(serverIds, GetPlayerServerId(playerId))
		end
	end

	return serverIds
end

function SubtitleText(text)
	local width = string.len(string.gsub(text, '~%a~', ''))

	SetTextFont(0)
	SetTextScale(0.5, 0.5)
	SetTextCentre(true)
	SetTextColour(255, 255, 255, 255)
	SetTextJustification(0)

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.5, 0.925)

	DrawRect(0.5, 0.945, width * 0.0095, 0.045, 0, 0, 0, 90)
end