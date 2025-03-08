local OccupiedTrunk = {}

RegisterNetEvent("core:putInTrunk")
AddEventHandler("core:putInTrunk", function(entity, vehicle)
    local source = source
    local veh = NetworkGetEntityFromNetworkId(vehicle)
    print(OccupiedTrunk, OccupiedTrunk[veh])
    if not OccupiedTrunk[veh] then
        OccupiedTrunk[veh] = true
        TriggerClientEvent("core:putInTrunk", entity, NetworkGetNetworkIdFromEntity(veh))
    else
        TriggerClientEvent("__atoshi::createNotification", source, {
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Le coffre est plein"
        })
    end
end)

RegisterNetEvent("core:removeFromTrunk", function(netid)
    local veh = NetworkGetEntityFromNetworkId(netid)
    OccupiedTrunk[veh] = nil
end)

RegisterNetEvent("core:emptyTrunk")
AddEventHandler("core:emptyTrunk", function(entity, vehicle)
    TriggerClientEvent("core:emptyTrunk2", entity)
end)