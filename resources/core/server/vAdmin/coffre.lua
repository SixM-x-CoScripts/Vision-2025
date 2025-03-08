local function computeInventoryWeight(inventory)

    -- if inventory is empty, return 0
    if not inventory then return 0 end

    -- else, compute the weight
    local weight = 0
    for _, item in pairs(inventory) do
        weight = weight + (item.weight * item.count)
    end
    return weight
end

--- TODO : Remove asynchronous call with delay
CreateThread(function()
    -- Wait for coffres and functions to be loaded
    Wait(3000)

    RegisterServerCallback("core:coffre:getCoffre", function(source, token, coffreID)
        -- Check if the player has a valid token, else return
        if not CheckPlayerToken(source, token) then return end
        -- Return the property
        return GetCoffre(coffreID)
    end)

    RegisterServerCallback("core:coffre:all", function(source, token, coffreID)
        -- Check if the player has a valid token, else return
        if not CheckPlayerToken(source, token) then return end
        -- Return the property
        return AllCoffresOnlyNecessaryData()
    end)

    RegisterServerCallback("core:coffre:getInventory", function(source, token, coffreID)
        -- Check if the player has a valid token, else return
        if not CheckPlayerToken(source, token) then return end
        -- Return the property
        return GetCoffre(coffreID):_inventory()
    end)

    RegisterServerCallback("core:coffre:addItem", function(source, token, coffreID, item, count)
        if not CheckPlayerToken(source, token) then return false end

        local _coffre = GetCoffre(coffreID)

        -- If count is superior to item.count or less than 1, set it to item.count
        if count > item.count or count < 1 then
            return false
        end

        item.count = count

        -- If property weight + items weight is superior to the max weight of the property, can't add the item
        if (item.weight * item.count) + computeInventoryWeight(_coffre.inventory) > _coffre.weight then
            return false
        -- Else, add the item to the property inventory
        end

        -- Add the item to the property inventory
        _coffre:AddInventoryItemCoffre(item)

        return true
    end)

    RegisterServerCallback("core:coffre:removeItem", function(source, token, coffreID, item, count)
        if not CheckPlayerToken(source, token) then return false end

        local _coffre = GetCoffre(coffreID)
        local player_inventory = GetPlayer(source):getInventaire()

        -- If count is superior to item.count or less than 1, set it to item.count
        if count > item.count or count < 1 then
            return false
        end

        item.count = count

        -- If player inventory weight + items weight is superior to the max weight of the player inventory, can't add the item
        if (item.weight * item.count) + computeInventoryWeight(player_inventory) > items.maxWeight then
            return false
        end

        -- Remove the item from the property inventory
        if not _coffre:RemoveInventoryItemCoffre(item) then
            return false
        end

        return true
    end)

end)

-- Get all coffres
RegisterNetEvent("core:coffre:getCoffres")
AddEventHandler("core:coffre:getCoffres", function(token)
    local _src = source

    -- Check if the player has a valid token, else return
    if not CheckPlayerToken(_src, token) then return end

    -- Return all coffres
    TriggerLatentClientEvent("core:coffre:getCoffres", _src, 50000, AllCoffresOnlyNecessaryData())
end)

-- Create a coffre
RegisterNetEvent("core:coffre:create")
AddEventHandler("core:coffre:create", function(token, name, pos, weight, code)
    local _src = source
    -- Check if the player has a valid token, else return
    if not CheckPlayerToken(_src, token) then return end
    -- Remove the property
    TriggerClientEvent("core:coffre:new", -1, CreateCoffre({
        name = name,
        pos = pos,
        weight = tonumber(weight),
        code = code,
        inventory = {}
    }))
end)

RegisterNetEvent("core:coffre:setPos")
AddEventHandler("core:coffre:setPos", function(token, coffreID, pos)
    local _src = source
    -- Check if the player has a valid token, else return
    if not CheckPlayerToken(_src, token) then return end
    -- Set the coffre pos
    GetCoffre(coffreID):_pos(pos)
    TriggerClientEvent("core:coffre:setPos", -1, coffreID, pos)
end)

RegisterNetEvent("core:coffre:setName")
AddEventHandler("core:coffre:setName", function(token, coffreID, name)
    local _src = source
    -- Check if the player has a valid token, else return
    if not CheckPlayerToken(_src, token) then return end
    -- Set the coffre name
    GetCoffre(coffreID):_name(name)
end)

RegisterNetEvent("core:coffre:setCode")
AddEventHandler("core:coffre:setCode", function(token, coffreID, code)
    local _src = source
    -- Check if the player has a valid token, else return
    if not CheckPlayerToken(_src, token) then return end
    -- Set the coffre code
    GetCoffre(coffreID):_code(code)
    TriggerClientEvent("core:coffre:setCode", -1, coffreID, code)
end)

RegisterNetEvent("core:coffre:setWeight")
AddEventHandler("core:coffre:setWeight", function(token, coffreID, weight)
    local _src = source
    -- Check if the player has a valid token, else return
    if not CheckPlayerToken(_src, token) then return end
    -- Set the coffre weight
    GetCoffre(coffreID):_weight(weight)
end)

RegisterNetEvent("core:coffre:delete")
AddEventHandler("core:coffre:delete", function(token, coffreID)
    local _src = source
    -- Check if the player has a valid token, else return
    if not CheckPlayerToken(_src, token) then return end
    -- Remove the coffre
    DeleteCoffre(coffreID)
    TriggerClientEvent("core:coffre:delete", -1, coffreID)
end)
