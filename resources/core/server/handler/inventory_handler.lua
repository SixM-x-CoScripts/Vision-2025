local pickupId = 1
local pickups = {}

local function CreatePickup(source, data, pos)
    pickupId = pickupId + 1
    local coords = pos

    pickups[pickupId] = {
        id = pickupId,
        name = data.item.name,
        label = data.item.label,
        type = data.item.type,
        count = data.quantity,
        metadatas = data.item.metadatas,
    }

    --TriggerClientEvent('core:createPickup', -1, source, pickupId, data.item.label, data.item.name, data.item.type,
    --    data.quantity, data.item.metadatas, coords)
    GlobalState.newpickup = {player = source, id = pickupId, name = data.item.name, typer = data.item.type, 
        count = data.quantity, metadatas = data.item.metadatas, coords = coords}
end

--RegisterNetEvent("core:isPlayerforObjectRoutingBucket", function(netobj, pickupId, player)
--    local src = source
--    local routingbucket = GetPlayerRoutingBucket(player)
--    local entity = NetworkGetEntityFromNetworkId(netobj)
--    if routingbucket ~= 0 then
--        SetEntityRoutingBucket(entity, routingbucket)
--        TriggerClientEvents("core:isPlayerforObjectRoutingBucketC", GetAllBucketIdsExcept(routingbucket), pickupId)
--    end
--end)

RegisterNetEvent("core:pickup")
AddEventHandler("core:pickup", function(token, pickupId)
    if CheckPlayerToken(source, token) then
        local pickup = pickups[pickupId]
        if pickup then
            if AddItemToInventory(source, pickups[pickupId].name, pickups[pickupId].count, pickups[pickupId].metadatas) then

                -- Ancienne notification
                --TriggerClientEvent('core:ShowNotification', source,
                --    "Vous avez ramassé x" .. pickups[pickupId].count .. " " .. pickups[pickupId].label .. ".")

                -- New Notif
                TriggerClientEvent("__atoshi::createNotification", source, {
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous avez ramassé : ~s x" .. pickups[pickupId].count .. " " .. pickups[pickupId].label .. "."
                })
                
                pickups[pickupId] = nil
                TriggerClientEvent('core:removePickup', -1, pickupId)
            end
        end
    end
end)

RegisterNetEvent("core:UpdateInventoryforall")
AddEventHandler("core:UpdateInventoryforall", function(token, society, veh, police, casier)
    local source = source
    if CheckPlayerToken(source, token) then
        TriggerClientEvent("core:UpdateInventoryforall", -1, society, veh, police, casier)
    end
end)

RegisterNetEvent("core:ThrowItem")
AddEventHandler("core:ThrowItem", function(token, itemData, pos)
    local src = source
    if CheckPlayerToken(src, token) then
        if itemData.quantity > 0 then
            if itemData.quantity <= itemData.item.count then
                SendDiscordLog("jetitem", src, string.sub(GetDiscord(src), 9, -1),
                GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
                itemData.item.name, itemData.quantity)
                if itemData.item.metadatas == nil then
                    --print('A')
                    if RemoveItemFromInventoryNil(src, itemData.item.name, itemData.quantity, itemData.item.metadatas ) then
                        --triggerEventPlayer("core:RemoveItemFromInventoryNil", source, itemData.item.name, itemData.quantity, itemData.item.metadatas)
                    end
                elseif itemData.item.metadatas and itemData.item.metadatas.id then
                    --print('B')
                    if RemoveKevlarFromInventory(src, itemData.item.name, itemData.quantity, itemData.item.metadatas) then
                        --triggerEventPlayer("core:RemoveMetadatasInventory", source, itemData.item.name, itemData.quantity, itemData.item.metadatas)
                        CreatePickup(src, itemData, pos)
                    end
                elseif itemData.item.name == 'identitycard' then
                    --print('B')
                    if RemoveIdentityCardFromInventory(src, itemData.item.name, itemData.quantity, itemData.item.metadatas) then
                        --triggerEventPlayer("core:RemoveMetadatasInventory", source, itemData.item.name, itemData.quantity, itemData.item.metadatas)
                        CreatePickup(src, itemData, pos)
                    end
                elseif itemData.item.name == 'outfit' then
                    --print('C')
                    if RemoveClothFromInventory(src, itemData.item.name, itemData.quantity, itemData.item.metadatas) then
                        --triggerEventPlayer("core:RemoveMetadatasInventory", source, itemData.item.name, itemData.quantity, itemData.item.metadatas)
                        CreatePickup(src, itemData, pos)
                    end
                elseif itemData.item.type == 'weapons' then
                    --print('D')
                    if RemoveWeaponFromInventory(src, itemData.item.name, itemData.quantity, itemData.item.metadatas) then
                        --triggerEventPlayer("core:RemoveMetadatasInventory", source, itemData.item.name, itemData.quantity, itemData.item.metadatas)
                        CreatePickup(src, itemData, pos)
                    end
                else
                    --print('E')
                    if RemoveItemFromInventory(src, itemData.item.name, itemData.quantity, itemData.item.metadatas) then
                        --triggerEventPlayer("core:RemoveMetadatasInventory", source, itemData.item.name, itemData.quantity, itemData.item.metadatas)
                        CreatePickup(src, itemData, pos)
                    end
                end
            end
        end
    end
end)
