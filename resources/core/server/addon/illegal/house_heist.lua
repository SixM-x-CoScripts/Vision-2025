local playerList = {}
RegisterNetEvent("core:house:setPlayerRobberyGood")
AddEventHandler("core:house:setPlayerRobberyGood", function()
    local id = GetPlayer(source):getId()
    if id ~= nil then
        table.insert(playerList, id)
    end
end)

RegisterNetEvent("core:house:callMecAppart", function(owner, strereet)
    local ownerply = GetLoadedPlayerFromId(owner)
    TriggerClientEvent("core:houseBeingCrochet", ownerply.source, strereet)
end)

Citizen.CreateThread(function()
    while RegisterServerCallback == nil do Wait(100) end

    RegisterServerCallback("core:house:getIfPlayerAlrdyRobbe", function(source)
        local id = GetPlayer(source):getId()
        if id ~= nil then
            for k, v in pairs(playerList) do
                if v == id then
                    return true
                end
            end
        end
        return false
    end)
end)