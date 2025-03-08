RegisterNetEvent("core:admin:giveKeys")
AddEventHandler("core:admin:giveKeys", function(token, id, plate, model)
    TriggerClientEvent("core:admin:getKeys", id, plate, model)
end)
