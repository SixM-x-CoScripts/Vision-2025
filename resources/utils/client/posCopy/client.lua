-- copy coords command

local function formatNumber(num)
    return tonumber(string.format("%.2f", num))
end

RegisterCommand('co', function(source, args, rawCommand)
	local coords = GetEntityCoords(PlayerPedId())
	local heading = GetEntityHeading(PlayerPedId())
	local z = coords.z-1
	print(formatNumber(coords.x)..", "..formatNumber(coords.y)..", "..formatNumber(z))
	SendNUIMessage({
		coords = formatNumber(coords.x)..", "..formatNumber(coords.y)..", "..formatNumber(z)
	})
end)

RegisterCommand('coh', function(source, args, rawCommand)
	local coords = GetEntityCoords(PlayerPedId())
	local heading = GetEntityHeading(PlayerPedId())
	local z = coords.z-1
	print(formatNumber(coords.x)..", "..formatNumber(coords.y)..", "..formatNumber(z)..", "..formatNumber(heading))
	SendNUIMessage({
		coords = formatNumber(coords.x)..", "..formatNumber(coords.y)..", "..formatNumber(z)..", "..formatNumber(heading)
	})
end)

AddEventHandler("addToCopy", function(...)
	SendNUIMessage({
		coords = ...
	})
end)