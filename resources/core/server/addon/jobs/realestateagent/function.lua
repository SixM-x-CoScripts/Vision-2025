local PlayersInHouse = {}
local recentRings = {}

local InsideCoffreProperty = {}

CreateThread(function()
    while RegisterServerCallback == nil do Wait(1000) end
    while not GetPlayer do Wait(1000) end

    -- Wait for handler to load all properties
    Wait(2000)

    RegisterServerCallback("core:property:getProperty", function(source, token, propertyID)
        -- Check if the player has a valid token, else return
        if not CheckPlayerToken(source, token) then return end
        -- Return the property
        return GetProperty(propertyID)
    end)

    RegisterServerCallback("core:property:getPropertyOpti", function(source, token, propertyID)
        -- Check if the player has a valid token, else return
        if not CheckPlayerToken(source, token) then return end
        -- Return the property
        local property = GetProperty(propertyID)
        local tosend = {id = property.id, enter_pos = property.enter_pos, co_owner = property.co_owner}
        return tosend
    end)

    RegisterServerCallback("core:property:getPropertyInventory", function(source, token, propertyID)
        -- Check if the player has a valid token, else return
        if not CheckPlayerToken(source, token) then return end
        -- Return the property inventory
        return GetProperty(propertyID):_inventory()
    end)

    RegisterServerCallback("core:property:getMailbox", function(source, token, propertyID)
        -- Check if the player has a valid token, else return
        if not CheckPlayerToken(source, token) then return end
        -- TODO: Return the mailbox
        return GetProperty(propertyID):_data().mailbox
    end)

    RegisterServerCallback("core:property:getVehiclesInGarage", function(source, token, propertyID)
        -- Check if the player has a valid token, else return
        if not CheckPlayerToken(source, token) then return end

        -- Return the garage
        local vehicles = GetProperty(propertyID):_garage()
        local garage = {}

        -- for each vehicle, get it in vehicles table
        for _, veh in pairs(vehicles) do
            if json.decode(veh) == nil or type(json.decode(veh)) ~= "table" then
                local _veh = GetVehicle(veh)
                if _veh ~= nil then
                    table.insert(garage, {plate=_veh.currentPlate, name = _veh.name, props = _veh.props})
                end
            else
                veh = json.decode(veh)
                if veh ~= nil and veh ~= 0 and veh.props ~= nil and veh.props.plate ~= nil and veh.props.model ~= nil then
                    local _veh = GetVehicle(veh.props.plate)
                    if _veh == nil then
                        local _veh1 = GetVehicle(veh.props.plate)
                        if _veh1 == nil and veh.inventory then
                            _veh = newVeh(veh.props.plate, veh.props.model, 0, 0, true, veh.inventory)
                        end
                        table.insert(garage, {plate=veh.props.plate, name=veh.props.model, props=veh.props})
                    elseif _veh ~= nil then
                        table.insert(garage, {plate=_veh.currentPlate, name = _veh.name, props = _veh.props})
                    end
                end
            end


            -- if nil, stolen car, then create it

        end

        -- Return the garage
        return garage
    end)

    CreateThread(function()
        GlobalState.OsDateHM = os.date("%H:%M")
        GlobalState.OsTime = os.time()
        GlobalState.OsServerTime = os.date('%S', os.time())
        while true do
            Wait(30000)
            GlobalState.OsTime = os.time()
            GlobalState.OsDateHM = os.date("%H:%M")
            GlobalState.OsServerTime = os.date('%S', os.time())
        end
    end)

    RegisterServerCallback("core:addItemToInvProperty", function(source, token, propertyID, item, count)
        if CheckPlayerToken(source, token) then
            local prop = GetProperty(propertyID)

            -- If count is superior to item.count or less than 1, set it to item.count
            if count > item.count or count < 1 then
                return false
            end

            item.count = count

            -- If property weight + items weight is superior to the max weight of the property, can't add the item
            if (item.weight * item.count) + computeInventoryWeight(prop.inventory) > prop.weight then
                return false
            -- Else, add the item to the property inventory
            end

            -- Add the item to the property inventory
            prop:AddInventoryItemProperty(item)

            -- Trigger the event to refresh inventory for each player in the property
            if PlayersInHouse[propertyID] then
                for _, player in pairs(PlayersInHouse[propertyID]) do
                    TriggerClientEvent("core:property:refreshInventory", player, propertyID, prop:_inventory())
                end
            end

            return true
        end
    end)

    RegisterServerCallback("core:removeItemToInventoryProperty", function(source, token, propertyID, item, count)
        if CheckPlayerToken(source, token) then
            local prop = GetProperty(propertyID)
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
            if not prop:RemoveInventoryItemProperty(item) then
                return false
            end

            -- Trigger the event to refresh inventory for each player in the property
            if PlayersInHouse[propertyID] then
                for _, player in pairs(PlayersInHouse[propertyID]) do
                    TriggerClientEvent("core:property:refreshInventory", player, propertyID, prop:_inventory())
                end
            end

            return true
        end
    end)

    -- Add item to property mailbox
    RegisterServerCallback("core:property:addItemToBoxMail", function(source, token, propertyID, item, count)
        if CheckPlayerToken(source, token) then
            local prop = GetProperty(propertyID)
            local mailbox = prop:_data().mailbox

            -- If count is superior to item.count or less than 1, set it to item.count
            if count > item.count or count < 1 then
                count = item.count
            end

            item.count = count

            -- If property mailbox weight + items weight is superior to the max weight of the property mailbox, can't add the item
            if (item.weight * item.count) + computeInventoryWeight(mailbox) > 3 then
                return false
            -- Else, add the item to the property mailbox
            end

            prop:AddItemToMailBox(item)

            return true
        end
    end)

    -- Get player last property
    RegisterServerCallback("core:getPlayerLastProperty", function(source, token, order)
        local player = GetPlayer(source);
        if (player and CheckPlayerToken(source, token)) then
            local result = MySQL.Sync.fetchAll("SELECT last_property FROM players WHERE id = @id", { ["@id"] = player:getId() })
            if (result) then
                local prop = json.decode(result[1].last_property)
                if prop ~= nil and prop.id then
                    return GetProperty(prop.id)
                end
            end
        end
        return nil
    end)

    RegisterServerCallback("core:property:canAccessCoffre", function(source, id)
        if InsideCoffreProperty[id] then
            return false
        else
            InsideCoffreProperty[id] = source
            return true
        end
    end)

    RegisterNetEvent("core:leaveCoffre", function(id)
        local source = source
        InsideCoffreProperty[id] = nil
    end)

    AddEventHandler("playerDropped", function(source)
        for k,v in pairs(InsideCoffreProperty) do
            if v == source then
                InsideCoffreProperty[k] = nil
            end
        end
    end)
end)


function computeInventoryWeight(inventory)

    -- if inventory is empty, return 0
    if not inventory then return 0 end

    -- else, compute the weight
    local weight = 0
    for _, item in pairs(inventory) do
        weight = weight + (item.weight * item.count)
    end
    return weight
end

function addItemToInventory(inventory, item)
    local found = false
    -- if item is already in inventory, add to quantity
    for k, v in pairs(inventory) do
        if v.name == item.name then
            v.count = v.count + item.count
            found = true
            break
        end
    end
    -- else add item to inventory
    if not found then
        table.insert(inventory, item)
    end
    return inventory
end

-- Remove a vehicle from the garage by plate
-- Used by @core/server/addon/jobs/police.lua (line 45)
function RemoveVehicleFromGarage(plate)
    local properties = AllProperties()
    for k, v in pairs(properties) do
        local garage = v:_garage()
        for _, vehicle in pairs(garage) do
            if vehicle == plate then
                v:RemoveVehicle(vehicle)
                return true
            end
        end
    end
end

RegisterNetEvent("core:AddPlayerInHouse")
AddEventHandler("core:AddPlayerInHouse", function(token, house)
    local source = source
    if CheckPlayerToken(source, token) then
        if PlayersInHouse[house] == nil then
            PlayersInHouse[house] = {}
            table.insert(PlayersInHouse[house], source)
        else
            table.insert(PlayersInHouse[house], source)
        end
    end
end)

RegisterNetEvent("core:rmvPlayerInHouse")
AddEventHandler("core:rmvPlayerInHouse", function(token, player, house)
    if CheckPlayerToken(source, token) then
        if PlayersInHouse ~= nil and PlayersInHouse[house] ~= nil then
            for k,v in pairs(PlayersInHouse[house]) do
                if v == source then
                    table.remove(PlayersInHouse[house], k)
                end
            end
        end
    end
end)

RegisterServerCallback("core:properties:getWeight", function(source, propertyId)
    local prop = GetProperty(propertyId)
    return prop and prop.weight or 0
end)

-- Get all properties
RegisterNetEvent("core:property:getProperties")
AddEventHandler("core:property:getProperties", function()
    local _src = source
    -- Return all properties
    TriggerClientEvent("core:property:client:getProperties", _src, AllPropertiesOnlyNecessaryData())
end)

-- Create a new property
RegisterNetEvent("core:property:create")
AddEventHandler("core:property:create", function(token, owner, propertyName, enterCoords, data, weight)
    local _src = source
    -- Check if the player has a valid token, else return
    if not CheckPlayerToken(_src, token) then return end
    if not CheckPlayerJob(_src, 'realestateagent') then return end
    -- Trigger the client event for all players
    TriggerClientEvent("core:property:new", -1, CreateProperty({
        name = propertyName,
        enter_pos = enterCoords,
        data = data,
        weight = weight,
        owner = GetPlayer(owner):getId(),
        source = owner
    }))

    SendDiscordLog("Dynasty-NewProperty", _src, string.sub(GetDiscord(_src), 9, -1),
        GetPlayer(_src):getLastname() .. " " .. GetPlayer(_src):getFirstname(), GetPlayer(_src):getJob(),
        owner, GetPlayer(owner):getId(), string.sub(GetDiscord(owner), 9, -1),
        GetPlayer(owner):getLastname() .. " " .. GetPlayer(owner):getFirstname(), GetPlayer(owner):getJob(), data.interior, weight, data.type, data.duration, propertyName, enterCoords)
end)

-- Update door state
RegisterNetEvent("core:property:updateDoorState")
AddEventHandler("core:property:updateDoorState", function(token, propertyId, state)
    local _src = source

    -- Check if the player has a valid token, else return
    if not CheckPlayerToken(_src, token) then return end

    -- Update the door state
    --GetProperty(propertyId):UpdateDoorState(state)
    GlobalState["propertyDoorState_"..propertyId] = state

end)

-- Add a co owner
RegisterNetEvent("core:property:addCoOwner")
AddEventHandler("core:property:addCoOwner", function(time, secu, token, propertyId, target)
    local _src = source
    if CheckTrigger(_src, time, secu, "core:property:addCoOwner") then
        if CheckPlayerToken(_src, token) then
            local new_co_owner = GetPlayer(target):getId()
            GetProperty(propertyId):AddCoOwner(new_co_owner)
            TriggerClientEvent("core:property:addCoOwner", target, propertyId, new_co_owner)
        end
    end
end)

-- Remove a co owner
RegisterNetEvent("core:property:removeCoOwner")
AddEventHandler("core:property:removeCoOwner", function(token, propertyId, target)
    local _src = source
    if CheckPlayerToken(_src, token) then
        local co_owner = GetPlayer(target):getId()
        GetProperty(propertyId):RemoveCoOwner(co_owner)
        TriggerClientEvent("core:property:removeCoOwner", target, propertyId, co_owner)
    end
end)

-- Give property
RegisterNetEvent("core:property:give")
AddEventHandler("core:property:give", function(token, propertyId, target)
    local _src = source
    if CheckPlayerToken(_src, token) then
        local new_owner = GetPlayer(target):getId()
        GetProperty(propertyId):_owner(new_owner)
    end
end)

-- Delete property
RegisterNetEvent("core:property:delete")
AddEventHandler("core:property:delete", function(token, propertyId)
    local _src = source
    local ply = GetPlayer(_src)
    if not ply then return end
    local perm = ply:getPermission()
    local job = ply:getJob()
    if job == "realestateagent" or perm >= 2 then
        if CheckPlayerToken(_src, token) then
            DeleteProperty(propertyId)
            TriggerClientEvent("core:property:delete", -1, propertyId)
        end
    else
        SunWiseKick(_src, "Tried exec core:property:delete")
    end
end)

-- Empty property mailbox
RegisterNetEvent("core:property:emptyMailbox")
AddEventHandler("core:property:emptyMailbox", function(token, propertyId)
    local _src = source
    if CheckPlayerToken(_src, token) then
        GetProperty(propertyId):EmptyMailbox()
    end
end)

-- Update rent duration
RegisterNetEvent("core:property:updateRentDuration")
AddEventHandler("core:property:updateRentDuration", function(token, propertyId, duration)
    local _src = source
    if CheckPlayerToken(_src, token) then
        GetProperty(propertyId):UpdateRentDuration(duration)
    end
end)

-- Update type
RegisterNetEvent("core:updatePropType")
AddEventHandler("core:updatePropType", function(token, propertyId, _type)
    local _src = source
    local crew
    --if CheckPlayerToken(_src, token) then
        local property = GetProperty(propertyId)
        local player = GetPlayerFromId(property:_owner())

        if _type == "crew" then
            crew = player.crew
        elseif _type == "entreprise" then
            crew = player.job
        else
            _type = ""
        end

        property:_type(_type)
        property:_crew(crew)
    --end
end)

-- Save last property
RegisterNetEvent("core:updateLastProperty")
AddEventHandler("core:updateLastProperty", function(token, property)
    local _src = source
    if CheckPlayerToken(_src, token) then
        MySQL.Sync.execute("UPDATE `players` SET `last_property` = @property WHERE `id` = @id", {
            ['@property'] = property,
            ['@id'] = GetPlayer(_src):getId()
        })
    end
end)

-- Add a vehicle to a garage
RegisterNetEvent("core:property:addVehicle")
AddEventHandler("core:property:addVehicle", function(token, propertyId, veh)
    local _src = source
    if CheckPlayerToken(_src, token) then
        local property = GetProperty(propertyId)
        local _veh = GetVehicle(veh.plate)
        local inventory = nil

        local data_to_save

        -- Check if vehicle exists
        if _veh ~= nil then
            inventory = _veh:getInventory()
        end

        -- If vehicle is not stolen
        if _veh ~= nil and _veh.tmp == false then
            -- Save only the plate
            data_to_save = veh.plate
        else
            -- Save all
            data_to_save = json.encode({
                inventory = inventory,
                props = veh,
            })
        end

        property:AddVehicle(data_to_save)

        -- Trigger the client event for all players in the house
        if PlayersInHouse[propertyId] then
            for k,v in pairs(PlayersInHouse[propertyId]) do
                TriggerClientEvent("core:property:updateVehicles", v, propertyId)
            end
        end
    end
end)

-- Remove a vehicle from a garage
RegisterNetEvent("core:property:removeVehicle")
AddEventHandler("core:property:removeVehicle", function(token, propertyId, vehiclePlate)
    local _src = source
    if CheckPlayerToken(_src, token) then
        local property = GetProperty(propertyId)
        property:RemoveVehicle(vehiclePlate)

        -- Trigger the client event for all players in the house
        for k,v in pairs(PlayersInHouse[propertyId]) do
            TriggerClientEvent("core:property:updateVehicles", v, propertyId)
        end
    end
end)

-- Ring the doorbell
RegisterNetEvent("core:property:ring")
AddEventHandler("core:property:ring", function(token, propertyId)
    local _src = source
    -- If someone already ringed the doorbell, return
    if recentRings[propertyId] ~= nil then
        TriggerClientEvent("__atoshi::createNotification", _src, {
            type = 'CLOCHE',
            content = "Quelqu'un vient de sonner, attendez un peu"
        })
    elseif CheckPlayerToken(_src, token) then
        recentRings[propertyId] =  _src
        SetTimeout(10000, function()
            recentRings[propertyId] = nil
        end)
        if PlayersInHouse[propertyId] ~= nil then
            for k,v in pairs(PlayersInHouse[propertyId]) do
                TriggerClientEvent("__atoshi::createNotification", v, {
                    type = 'CLOCHE',
                    content = "Quelqu'un sonne à la porte"
                })
            end
        end
    end
end)

-- Enter persons who ringed the doorbell
RegisterNetEvent("core:property:enterByDoorbell")
AddEventHandler("core:property:enterByDoorbell", function(token, propertyId)
    local _src = source
    if CheckPlayerToken(_src, token) then
        TriggerClientEvent("core:property:enterByDoorbell", recentRings[propertyId], propertyId)
    end
end)

--[[
    {
        - id = 38
        - name = "ff"
        - enter_pos = {"x":-1520.8,"z":49.5,"y":-285.9}
        data = {
            "mailbox":[],
            "type":"habitation",
            "doorState":true,
            "interior":"Duplex 1"
        }
        inventory = [{"name":"water","type":"items","label":"Bouteille d eau","weight":0.09999999999999,"count":5,"metadatas":[],"cols":1,"rows":1}]
        garage = ["FFF", "SDKDLS"]
        - owner = 1
        - type = "Individuel"
        co_owner = [2, 3]
        rentedat = 1690919396
        - rentalEnd = 1691956196
        - crew = ""
        - weight = 400
    }
]]


--[[

Convertir l'ancien format en nouveau
Pour Prestor: Vérifie bien, en ce qui concerne le formattage de l'inventaire, je n'ai pas d'exemple dans ton dump tout est NULL
Il faut donc que tu check si mon format correspond a l'ancien ou si il faut changer des trucs
Idem pour le garage
Idem pour les co-owner

Avant toute chose tu dois rename la colonne "etage" en "data"

Résumé:
    Tu dois vérifier les formats de :
        - L'inventaire  (ligne 485)
        - Le garage     (ligne 492)
        - Les co-owner  (ligne 499)
    Tu as les formats attendus juste au dessus
    Ensuite tu pourras start le serveur, et le format se mettra à jour pour s'adapter au nouveau système

]]

-- function ConvertDBFormat()

--     local properties = MySQL.Sync.fetchAll("SELECT * FROM `property`")

--     for k,v in pairs(properties) do
--         print(v.id)
--         v.data = json.decode(v.data)[1]
--         --v.inventory = json.decode(v.inventory)
--         v.garage = {}
--         print(json.encode(v.data))
--         local _type = "habitation"
--         if v.data.type == "Garage" then
--             _type = "garage"
--         elseif v.data.type == "Entrepot" then
--             _type = "stockage"
--         end
--         if v.rentedat then
--             -- Formate la date de YYYY/MM/DD HH:MM:SS en timestamp
--             v.rentedat = os.time({
--                 year = tonumber(string.sub(v.rentedat, 1, 4)),
--                 month = tonumber(string.sub(v.rentedat, 6, 7)),
--                 day = tonumber(string.sub(v.rentedat, 9, 10)),
--                 hour = tonumber(string.sub(v.rentedat, 12, 13)),
--                 min = tonumber(string.sub(v.rentedat, 15, 16)),
--                 sec = tonumber(string.sub(v.rentedat, 18, 19))
--             })
--         else
--             v.rentedat = os.time()
--         end

--         if _type == "garage" then
--             if v.data.garage ~= nil then
--                 for _,veh in pairs(v.data.garage) do
--                     table.insert(v.garage, veh.plate)
--                 end
--             end
--         else
--             if v.data.inventory ~= nil then
--                 v.inventory = v.data.inventory.item
--             else
--                 v.inventory = {}
--             end
--         end
--             -- Formattage des co-owner
--         local newco = {}
--         v.co_owner = json.decode(v.co_owner)
--         if v.co_owner ~= nil then
--             for _,co in pairs(v.co_owner) do
--                 print(json.encode(co))
--                 table.insert(newco, co.id)
--             end
--         end
--         v.co_owner = newco
--         v.data = {
--             mailbox     = {},
--             type        = _type,
--             doorState   = false,
--             interior    = v.data.interior
--         }
--         print(v.id, v.name, v.enter_pos, json.encode(v.data), v.inventory, json.encode(v.garage), v.owner, json.encode(v.co_owner), v.type, v.rentedat, v.rentalEnd, v.crew, v.weight)
--         -- Instancie la propriété avec le nouveau format
--         local prop = property:new({
--             id = v.id,
--             name = v.name,
--             enter_pos = v.enter_pos,
--             data = v.data,
--             inventory = v.inventory,
--             garage = v.garage,
--             owner = v.owner,
--             co_owner = v.co_owner,
--             type = v.type,
--             rentedAt = v.rentedat,
--             rentalEnd = v.rentalEnd,
--             crew = v.crew,
--             weight = v.weight
--         })

-- -- Sauvegarde la propriété en BDD

--         MySQL.Async.execute("UPDATE property SET name = @name, enter_pos = @enter_pos, data = @data, inventory = @inventory, garage = @garage, type = @type, rentedAt = @rentedAt, rentalEnd = @rentalEnd, crew = @crew, weight = @weight, co_owner = @co_owner WHERE id = @id", {
--             ["@id"] = prop.id,
--             ["@name"] = prop.name,
--             ["@enter_pos"] = prop.enter_pos,
--             ["@data"] = json.encode(prop.data),
--             ["@inventory"] = json.encode(prop.inventory),
--             ["@garage"] = json.encode(prop.garage),
--             ["@type"] = prop.type,
--             ["@rentedAt"] = prop.rentedAt,
--             ["@rentalEnd"] = prop.rentalEnd,
--             ["@crew"] = prop.crew,
--             ["@weight"] = prop.weight,
--             ["@co_owner"] = json.encode(prop.co_owner)
--         })
--     end
-- end


-- MySQL.ready(function()
--     Wait(5000)
--     print("Pour lancer la conversion des propriétés, décommente la ligne 564 dans @core/server/addon/jobs/realestateagent/function.lua")
--     print("Avant de faire ca, assure toi d'avoir bien lu les commentaires lignes 433 à 447 de ce même fichier")
--     --ConvertDBFormat()
-- end)

function RemoveItemToInventoryProperty(source, propertyID, item, count)
    local prop = GetProperty(propertyID)
    local player_inventory = GetPlayer(source):getInventaire()

    -- If count is superior to item.count or less than 1, set it to item.count
    if count > item.count or count < 1 then
        return false
    end

    item.count = count

    -- If player inventory weight + items weight is superior to the max weight of the player inventory, can't add the item
    --print("item.weight", item.weight, item.count, computeInventoryWeight(player_inventory))
    --if (item.weight * item.count) + computeInventoryWeight(player_inventory) > items.maxWeight then
    --    print("second false", (item.weight * item.count) + computeInventoryWeight(player_inventory), items.maxWeight)
    --    return false
    --end

    -- Remove the item from the property inventory
    if not prop:RemoveInventoryItemProperty(item) then
        return false
    end

    -- Trigger the event to refresh inventory for each player in the property
    if PlayersInHouse[propertyID] then
        for _, player in pairs(PlayersInHouse[propertyID]) do
            TriggerClientEvent("core:property:refreshInventory", player, propertyID, prop:_inventory())
        end
    end

    return true
end
