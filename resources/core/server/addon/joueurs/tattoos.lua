RegisterNetEvent("core:addTattoo")
AddEventHandler("core:addTattoo", function(token, data)
    if CheckPlayerToken(source, token) then
        local player = GetPlayer(source)
        player:setTattoos(data)
    else
        --TODO: Add AC verif
    end
end)

RegisterNetEvent("core:addTattooToPlayer")
AddEventHandler("core:addTattooToPlayer", function(token, target, data)
    if CheckPlayerToken(source, token) then
        local player = GetPlayer(source)
        local target_player = GetPlayer(target)
        while target_player == nil do
            Wait(1)
        end
        local tattoos = target_player:getTattoos()
        table.insert(tattoos, data)
        target_player:setTattoos(tattoos)
        TriggerClientEvent("core:addTattooToPlayer", target, data)
    else
        -- TODO: Add AC verif
    end
end)

CreateThread(function()
    while RegisterServerCallback == nil do Wait(1) end
    RegisterServerCallback("core:getPlayerTattoos", function(source, target)
        local target_player = GetPlayer(target)
        while target_player == nil do
            Wait(1)
        end
        local tattoos = target_player:getTattoos()
        return tattoos
    end)
end)

RegisterNetEvent("core:deleteTattooToPlayer")
AddEventHandler("core:deleteTattooToPlayer", function(token, target, data)
    if CheckPlayerToken(source, token) then
        local player = GetPlayer(source)
        local target_player = GetPlayer(target)
        while target_player == nil do
            Wait(1)
        end
        local tattoos = target_player:getTattoos()
        for k,v in pairs(tattoos) do 
            if v.HashName == data.HashName and v.Collection == data.Collection then 
                table.remove(tattoos, k)
            end
        end
        target_player:setTattoos(tattoos)
        TriggerClientEvent("core:updateTattoo", target, tattoos)
    else
        -- TODO: Add AC verif
    end
end)

RegisterNetEvent("tattoos:update")
AddEventHandler("tattoos:update", function(token, ped_net, collection, hash, targets_list)
    if CheckPlayerToken(source, token) then
        for _, target in pairs(targets_list) do
            TriggerClientEvent("tattoos:update", target, ped_net, collection, hash)
        end
    else
        -- TODO: Add AC verif
    end
end)

RegisterNetEvent("core:addDegrader")
AddEventHandler("core:addDegrader", function(token, data)
    if CheckPlayerToken(source, token) then
        local player = GetPlayer(source)
        player:setDegrader(data)
    else
        --TODO: Add AC verif
    end
end)
