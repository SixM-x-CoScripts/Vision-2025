RegisterServerEvent('fhose:requestPermissions')
AddEventHandler('fhose:requestPermissions', function()
    local idFound = false
    for _, id in ipairs(GetPlayerIdentifiers(source)) do
        if listcontains(Config.Identifiers, id) then
            idFound = true
            TriggerClientEvent('fhose:canUseNozzles', source, true)
            break
        end
    end
    if not idFound then
        TriggerClientEvent('fhose:canUseNozzles', source, false)
    end
end)

RegisterServerEvent('fhose:attachCable')
AddEventHandler('fhose:attachCable', function(pump, veh, pos)
    TriggerClientEvent("fhose:attachCable", -1, source, pump, veh, pos)
end)

RegisterServerEvent('fhose:detachCable')
AddEventHandler('fhose:detachCable', function()
    TriggerClientEvent("fhose:detachCable", -1, source)
end)

RegisterServerEvent('fhose:attachVehicle')
AddEventHandler('fhose:attachVehicle', function(veh, pos)
    TriggerClientEvent("fhose:attachVehicle", -1, veh, pos)
end)

RegisterServerEvent('fhose:attachVehicleToVehicle')
AddEventHandler('fhose:attachVehicleToVehicle', function(veh, pos)
    TriggerClientEvent("fhose:attachVehicleToVehicle", -1, veh, pos)
end)

RegisterServerEvent('fhose:detachVehicle')
AddEventHandler('fhose:detachVehicle', function(veh)
    TriggerClientEvent("fhose:detachVehicle", -1, veh)
end)

RegisterServerEvent('fhose:triggerSpray')
AddEventHandler('fhose:triggerSpray', function(trigger)
    TriggerClientEvent("fhose:triggerSpray", -1, source, trigger)
end)

AddEventHandler('playerDropped', function()
	TriggerClientEvent("fhose:triggerSpray", -1, source, false)
    TriggerClientEvent("fhose:detachCable", -1, source)
end)

print("FIREHOSE ^1Has Authenticated ^2Successfully! ^0By ^1ToxicScripts! ^7")

function listcontains(list, var)
	for i = 1, #list do
        if list[i] == var then
            return true
        end
    end
	return false
end