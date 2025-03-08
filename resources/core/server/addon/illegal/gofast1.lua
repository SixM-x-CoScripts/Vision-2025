local playerAlreadyDid = {}

Citizen.CreateThread(function()
    while true do
        TriggerEvent("watcher:server:SendTableInfo", "gofast1:playerAlreadyDid", playerAlreadyDid)
        Wait(5000)
    end
end)

RegisterNetEvent("missionTel:goFast1")
AddEventHandler("missionTel:goFast1", function(pos)
    local pPhone = exports["lb-phone"]:GetEquippedPhoneNumber(source)
    exports["lb-phone"]:SendMessage("667-8596", pPhone,
        "Merci de ton appel j'avais besoin d'aide, rejoins la position que je t'envoie une voiture t'y attends, tu recevras un message avec toutes les informations une fois là-bas."
        , nil, nil, nil)
    Wait(5000)
    exports["lb-phone"]:SendCoords("667-8596", pPhone, pos)
end)

RegisterNetEvent("missionTel:goFast2")
AddEventHandler("missionTel:goFast2", function(pos)
    local pPhone = exports["lb-phone"]:GetEquippedPhoneNumber(source)
    exports["lb-phone"]:SendMessage("667-8596", pPhone,
        "On ma informé que tu étais dans le véhicule voici les coordonnées de la livraison mes hommes t'y attendrons"
        , nil, nil, nil)
    Wait(5000)
    exports["lb-phone"]:SendCoords("667-8596", pPhone, pos)
end)

RegisterNetEvent("missionTel:goFast3")
AddEventHandler("missionTel:goFast3", function()
    local pPhone = exports["lb-phone"]:GetEquippedPhoneNumber(source)
    exports["lb-phone"]:SendMessage("667-8596", pPhone,
        "Attends que mes hommes prennent la marchandise et je te donne la suite des instructions"
        , nil, nil, nil)
end)

RegisterNetEvent("missionTel:goFast4")
AddEventHandler("missionTel:goFast4", function(pos)
    local pPhone = exports["lb-phone"]:GetEquippedPhoneNumber(source)
    exports["lb-phone"]:SendMessage("667-8596", pPhone,
        "Va me ramener le véhicule et laisse la à l'endroit que je t'envoie"
        , nil, nil, nil)
    Wait(5000)
    exports["lb-phone"]:SendCoords("667-8596", pPhone, pos)
end)

RegisterNetEvent("missionTel:goFast5")
AddEventHandler("missionTel:goFast5", function()
    local pPhone = exports["lb-phone"]:GetEquippedPhoneNumber(source)
    exports["lb-phone"]:SendMessage("667-8596", pPhone,
        "Merci de ton aide à la prochaine.", nil, nil, nil)
end)

RegisterNetEvent("missionTel:deleteconvo")
AddEventHandler("missionTel:deleteconvo", function()
    local pPhone = exports["lb-phone"]:GetEquippedPhoneNumber(source)
    -- sql query to get the id of the conversation
    local channelId = MySQL.Sync.fetchScalar([[SELECT c.channel_id FROM phone_message_channels c WHERE c.is_group = 0
            AND EXISTS (SELECT TRUE FROM phone_message_members m WHERE m.channel_id = c.channel_id AND m.phone_number = @from)
            AND EXISTS (SELECT TRUE FROM phone_message_members m WHERE m.channel_id = c.channel_id AND m.phone_number = @to)]]
        , { ["@from"] = "667-8596", ["@to"] = pPhone })
    MySQL.Async.execute("DELETE FROM phone_message_messages WHERE channel_id = @channel",
        { ["@channel"] = channelId })
    MySQL.Async.execute("DELETE FROM phone_message_channels WHERE channel_id = @channel",
        { ["@channel"] = channelId })
end)

RegisterNetEvent("missionTel:addItemTrunkGF1")
AddEventHandler("missionTel:addItemTrunkGF1", function(token, plate)
    --print(_Utils.Trim(GetVehicleNumberPlateText(veh)), GetVehicleIndexFromPlate(_Utils.Trim(GetVehicleNumberPlateText(veh))))
    --local plate = GetVehicleNumberPlateText(veh)
    --local index = GetVehicleIndexFromPlate(plate)
    AddItemToInventoryVehicleStaff(plate, "sacCocain", 10, {})
end)

RegisterNetEvent("missionTel:removeItemTrunkGF1")
AddEventHandler("missionTel:removeItemTrunkGF1", function(token, plate)
    --local plate = GetVehicleNumberPlateText(veh)
    --local index = GetVehicleIndexFromPlate(plate)
    RemoveItemToVehicle(plate, "sacCocain", 10, {})
end)

CreateThread(function()
    while RegisterServerCallback == nil do Wait(0) end
    RegisterServerCallback("gofast:AlreadyDidGF1", function(source, token, playerId)
        if CheckPlayerToken(source, token) then
            for index, value in pairs(playerAlreadyDid) do
                if playerId == value then
                    return false
                end
            end
            table.insert(playerAlreadyDid, playerId)
            return true
        end
    end)
end)