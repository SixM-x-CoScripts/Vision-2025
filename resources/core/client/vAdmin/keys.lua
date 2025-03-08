function GetKeysAdmin(plate, model)

    TriggerEvent("core:createKeys", plate, model)
    exports['vNotif']:createNotification({
        type = 'VERT',
        content = "Clés du véhicule récupérées"
    })
end

RegisterNetEvent("core:admin:getKeys")
AddEventHandler("core:admin:getKeys", function(plate, model)
    GetKeysAdmin(plate, model)
end)