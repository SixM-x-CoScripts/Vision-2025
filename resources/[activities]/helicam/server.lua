local helicopters = {}
local helis = {}

RegisterServerEvent('helicam:enterCamera')
AddEventHandler('helicam:enterCamera', function(heliNetId)
    local id = NetworkGetEntityFromNetworkId(heliNetId)
    local helicopter = helis
    if not helicopter[id] then helicopter[id] = {} end
    if helicopter[id] and (not helicopter[id].heliCamInUse) then
        helicopter[id].heliCamInUse = true
        helicopters[source] = heliNetId
        TriggerClientEvent('helicam:enterCamera', source, true)
    else
        TriggerClientEvent('helicam:enterCamera', source, false)
    end
end)

RegisterServerEvent('helicam:leaveCamera')
AddEventHandler('helicam:leaveCamera', function(heliNetId)
    local id = NetworkGetEntityFromNetworkId(heliNetId)
    local helicopter = helis
    if not helicopter[id] then helicopter[id] = {} end
    helicopter[id].heliCamInUse = false
    if source ~= nil and source ~= "" then
        helicopters[source] = nil
    end
end)

RegisterServerEvent('helicam:setStateBag')
AddEventHandler('helicam:setStateBag', function(heliNetId, bagName, value)
    local id = NetworkGetEntityFromNetworkId(heliNetId)
    local helicopter = helis
    helicopter[id][bagName] = value
end)

RegisterNetEvent("core:spotlightData", function(helicopter, position, direction, brightness,radius)
    TriggerClientEvent("heliCamSpotlightData", -1, helicopter, position, direction, brightness,radius)
end)

-- If a player crashes/leaves while in the camera
AddEventHandler('playerDropped', function(reason)
    if helicopters[source] then
        TriggerEvent('helicam:leaveCamera', helicopters[source])
        TriggerClientEvent("heliCamSpotlightData", -1, helicopters[source])
        helicopters[source] = nil
    end
end)
