local limit = {}
local lastNotif = {}

RegisterNetEvent("core:sellHunt")
AddEventHandler("core:sellHunt", function (token, name, price, quantity)
    -- get the source's database id
    local id = GetPlayer(source):getId()
    if id ~= nil then    
        if limit[id] == nil then
            limit[id] = 0
        end
        new_limit = tonumber(quantity) + limit[id]
        if CheckPlayerToken(source, token) then
            if DoesPlayerHaveItemCount(source, name, quantity) then
                if AddItemToInventory(source, "money", price * quantity, {}) then
                    if GetPlayer(source):getSubscription() ~= 0 then
                        new_limit = 0
                    end
                    if new_limit <= 234 then
                        RemoveItemFromInventory(source, name, quantity, {})
                        --[[TriggerClientEvent("core:ShowNotification", source, "~g~Tu as vendu x" .. quantity .. " ~o~" .. getItemLabel(name) .. "~s~ pour ~g~$" .. price * quantity .. "~s~")]]
                        TriggerClientEvent("__atoshi::createNotification", source, {
                            type = 'DOLLAR',
                            -- duration = 5, -- In seconds, default:  4
                            content = "Tu as vendu ~s x" .. quantity .. " " .. getItemLabel(name) .. " ~c pour ~s $" .. price * quantity
                        })
                        limit[id] = new_limit
                    else
                        --[[TriggerClientEvent("core:ShowNotification", source, "~r~Tu as atteint la limite de 234 viandes par jour")]]
                        TriggerClientEvent("__atoshi::createNotification", source, {
                            type = 'ROUGE',
                            -- duration = 5, -- In seconds, default:  4
                            content = "~s Tu as atteint la limite de 234 viandes par jour"
                        })
                    end
                else
                    --[[TriggerClientEvent("core:ShowNotification", source, "~r~Tu n'as pas assez de place dans ton inventaire")]]
                    TriggerClientEvent("__atoshi::createNotification", source, {
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Tu n'as pas assez de place dans ton inventaire"
                    })
                end
            else
                --[[TriggerClientEvent("core:ShowNotification", source, "~r~Tu n'as pas assez de " .. getItemLabel(name))]]
                if not lastNotif[source] then 
                    lastNotif[source] = getItemLabel(name)
                elseif lastNotif[source] ~= getItemLabel(name) then 
                    lastNotif[source] = getItemLabel(name)
                    TriggerClientEvent("__atoshi::createNotification", source, {
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Tu n'as pas assez de " .. getItemLabel(name)
                    })
                end
            end
        end  
    end
end)

RegisterNetEvent("hunt:animalLock")
AddEventHandler("hunt:animalLock", function(animal)
    -- export the locked table to the client
    TriggerClientEvent("hunt:animalLock", -1, animal)
end)

RegisterNetEvent("hunt:removeWeap", function()
    local source = source 
    local ply = GetPlayer(source)
    for k, v in pairs(ply:getInventaire()) do
        if v.name == "weapon_musket" then 
            if v.metadatas.premium and v.metadatas.chasse then 
                RemoveItemToPlayer(source, v.name, 1, v.metadatas)
            end
        end
    end
    -- Pas besoin d'opti serv quand on paye une machine 700€ par mois ^^
    for k, v in pairs(ply:getInventaire()) do
        if v.name == "weapon_knife" then 
            if v.metadatas.premium and v.metadatas.chasse then 
                RemoveItemToPlayer(source, v.name, 1, v.metadatas)
            end
        end
    end
end)

AddEventHandler("playerDropped", function()
    local source = source 
    local ply = GetPlayer(source)
    if not ply then return end
    for k, v in pairs(ply:getInventaire()) do
        if v.name == "weapon_musket" then 
            if v.metadatas.premium and v.metadatas.chasse then 
                RemoveItemToPlayer(source, v.name, 1, v.metadatas)
            end
        end
    end
    -- Pas besoin d'opti serv quand on paye une machine 700€ par mois ^^
    for k, v in pairs(ply:getInventaire()) do
        if v.name == "weapon_knife" then 
            if v.metadatas.premium and v.metadatas.chasse then 
                RemoveItemToPlayer(source, v.name, 1, v.metadatas)
            end
        end
    end
end)