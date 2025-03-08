local playerAlreadyDid = {}
local playerAlreadyDidM = {}

CreateThread(function()
    while RegisterServerCallback == nil do Wait(0) end
    RegisterServerCallback("core:GetNumber", function(source, token)
        if CheckPlayerToken(source, token) then
            return exports["lb-phone"]:GetEquippedPhoneNumber(source)
        end
    end)
end)

RegisterNetEvent("gofast:firstSms")
AddEventHandler("gofast:firstSms", function(token, pos)
    if CheckPlayerToken(source, token) then
        local pPhone = exports["lb-phone"]:GetEquippedPhoneNumber(source)
        exports["lb-phone"]:SendMessage("687-6543", pPhone,
            "Tiens récupère le véhicule les clés sont dedans je t'enverrais les instructions une fois le véhicule récuperé."
            , nil, nil, nil)
        Wait(5000)
        exports["lb-phone"]:SendCoords("687-6543", pPhone, pos)
    end
end)

RegisterNetEvent("gofast:secondSms")
AddEventHandler("gofast:secondSms", function(token, pos)
    if CheckPlayerToken(source, token) then
        local pPhone = exports["lb-phone"]:GetEquippedPhoneNumber(source)
        exports["lb-phone"]:SendMessage("687-6543", pPhone,
            "La cargaison est située a l'endroit que je t'envoie, n'oublie rien sinon tu le regretteras.", nil, nil, nil)
        Wait(5000)
        exports["lb-phone"]:SendCoords("687-6543", pPhone, pos)
    end
end)

RegisterNetEvent("gofast:thirdSms")
AddEventHandler("gofast:thirdSms", function(token, pos)
    if CheckPlayerToken(source, token) then
        local pPhone = exports["lb-phone"]:GetEquippedPhoneNumber(source)
        exports["lb-phone"]:SendMessage("687-6543", pPhone,
            "On m'a informé que tu as pu récuperer la cargaison je t'attends.", nil, nil, nil)
        Wait(5000)
        exports["lb-phone"]:SendCoords("687-6543", pPhone, pos)
    end
end)

RegisterNetEvent("gofast:paySms")
AddEventHandler("gofast:paySms", function(token, pos)
    if CheckPlayerToken(source, token) then
        local pPhone = exports["lb-phone"]:GetEquippedPhoneNumber(source)
        exports["lb-phone"]:SendMessage("687-6543", pPhone,
            "Merci de ton aide, ton argent t'attends là-bas, gare la voiture, prends ton argent et tires toi !", nil, nil, nil)
        Wait(5000)
        exports["lb-phone"]:SendCoords("687-6543", pPhone, pos)
    end
end)


RegisterNetEvent("gofast:deleteconvo")
AddEventHandler("gofast:deleteconvo", function(token)
    if CheckPlayerToken(source, token) then
        local pPhone = exports["lb-phone"]:GetEquippedPhoneNumber(source)
        -- sql query to get the id of the conversation
        local channelId = MySQL.Sync.fetchScalar([[SELECT c.channel_id FROM phone_message_channels c WHERE c.is_group = 0
                AND EXISTS (SELECT TRUE FROM phone_message_members m WHERE m.channel_id = c.channel_id AND m.phone_number = @from)
                AND EXISTS (SELECT TRUE FROM phone_message_members m WHERE m.channel_id = c.channel_id AND m.phone_number = @to)]]
            , { ["@from"] = "687-6543", ["@to"] = pPhone })
        MySQL.Async.execute("DELETE FROM phone_message_messages WHERE channel_id = @channel",
            { ["@channel"] = channelId })
        MySQL.Async.execute("DELETE FROM phone_message_channels WHERE channel_id = @channel",
            { ["@channel"] = channelId })
    end
end)


RegisterNetEvent("gofast:addItemTrunk")
AddEventHandler("gofast:addItemTrunk", function(token, plate)
    --local index = GetVehicleIndexFromPlate(plate)
    AddItemToInventoryVehicleStaff(plate, "drugsBags", 1, {})
end)

RegisterNetEvent("gofast:removeItemTrunk")
AddEventHandler("gofast:removeItemTrunk", function(token, plate)
    --local index = GetVehicleIndexFromPlate(plate)
    RemoveItemToVehicle(plate, "drugsBags", 1, {})
end)

CreateThread(function()
    while RegisterServerCallback == nil do Wait(0) end
    RegisterServerCallback("gofast:AlreadyDidGoFast1", function(source, token, playerId)
        if CheckPlayerToken(source, token) then
            if playerAlreadyDid[playerId] then 
                return false
            end
            playerAlreadyDid[playerId] = true
            return true
        end
    end)
    RegisterServerCallback("gofast:AlreadyDidGoFast2", function(source, token, playerId)
        if CheckPlayerToken(source, token) then
            if playerAlreadyDidM[playerId] then 
                return false
            end
            playerAlreadyDidM[playerId] = true
            return true
        end
    end)
end)