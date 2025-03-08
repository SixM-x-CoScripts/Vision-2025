RegisterNetEvent("core:createCrewCreation")
AddEventHandler("core:createCrewCreation", function(playerId, typeCrew)
    local src = source 
    if GetPlayer(src):getPermission() > 1 then
        TriggerClientEvent("core:createCrewCreation", playerId, typeCrew)
    end
end)