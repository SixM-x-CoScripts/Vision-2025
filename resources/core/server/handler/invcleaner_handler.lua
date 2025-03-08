RegisterNetEvent("core:InventoryCleaner:Clean")
AddEventHandler("core:InventoryCleaner:Clean", function(token, data)
    local source = source
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >= 5 then
            local player = GetPlayer(data.source)

            while player == nil do Wait(10) end

            player:setInventaire(data.inventory)
            player:setNeedSave(true)
            triggerEventPlayer("core:SetNewInventory", data.source, data.inventory)
            
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "L'inventaire du joueur " .. player:getLastname() .. " " .. player:getFirstname() .. " a été nettoyé."
            })
            TriggerClientEvent("__atoshi::createNotification", data.source, {
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Votre inventaire a été nettoyé par un membre du staff."
            })
        else
            SunWiseKick(source, "Tried exec core:InventoryCleaner:Clean")
        end
    end
end)

Citizen.CreateThread(function()
    while RegisterServerCallback == nil do Wait(100) end

    RegisterServerCallback("core:InventoryCleaner:GetData", function(source, token, playerId)
        if CheckPlayerToken(source, token) then
            if GetPlayer(source):getPermission() >= 5 then
                local player = GetPlayer(playerId)
                if player then
                    return {
                        inventory = player:getInventaire(),
                        balance = player:getBalance(),
                        premium = player:getSubscription(),
                        unique_id = player:getUniqueId(),
                        fullname = player:getFirstname() .. " " .. player:getLastname(),
                        source = playerId,
                    }
                end
            else
                SunWiseKick(source, "Tried exec core:InventoryCleaner:GetData")
            end
        end
    end)

end)