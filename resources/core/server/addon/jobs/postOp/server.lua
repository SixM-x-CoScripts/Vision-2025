
-- ! For now i let this like that;
-- ! no database relational for now, lets wait for the new db schema.
-- ! refactor this when the new db is out.

local function uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

local function addCommandToDb(data, cb) 
    local formatedItems = {}

    local formatedItemsAlcool = {}

    local _items = data.items

    local _itemsAlcool = data.itemsAlcool

    local postopcmd = false

    for i=1, #_items do
        table.insert(formatedItems, {
            id = uuid(),
            label = _items[i].label,
            quantity = _items[i].quantity
        })

        postopcmd = true
    end

    local alcoolcmd = false

    for i=1, #_itemsAlcool do
        table.insert(formatedItemsAlcool, {
            id = uuid(),
            label = _itemsAlcool[i].label,
            quantity = _itemsAlcool[i].quantity
        })
        
        alcoolcmd = true

    end

    local result

    if postopcmd then
        MySQL.Async.insert("INSERT INTO postop_commands (items, fournisseur, state, icon, society, phone, total) VALUES (?, ?, ?, ?, ?, ?, ?)", {
            json.encode(formatedItems),
            'postop',
            'awaiting',
            data.image or 'https://cdn.sacul.cloud/v2/vision-cdn/MenuPostOp/food.webp',
            data.society,
            data.phone,
            data.totalcmd,
        }, function(result) 
        
            result = result
        
        end)

        SendDiscordLog("PostOP-NewCommande", "PostOP", 'awaiting',
            data.society, data.phone, data.totalcmd, json.encode(formatedItems))

    end

    if alcoolcmd then
        MySQL.Async.insert("INSERT INTO postop_commands (items, fournisseur, state, icon, society, phone, total) VALUES (?, ?, ?, ?, ?, ?, ?)", {
            json.encode(formatedItemsAlcool),
            'postop',
            'awaiting',
            data.image or 'https://cdn.sacul.cloud/v2/vision-cdn/MenuPostOp/food.webp',
            data.society,
            data.phone,
            data.totalcmdalcool,
        }, function(result) 
        
            result = result
        
        end)

        SendDiscordLog("PostOP-NewCommande", "PostOP", 'awaiting',
            data.society, data.phone, data.totalcmdalcool, json.encode(formatedItemsAlcool))

    end

    if not result and cb then
        return cb({
            ok = false
        })
    end

    if cb then 
        cb({
            ok = true
        })
    end
end

-- Citizen.CreateThread(function()
    -- addCommandToDb({
    --     items = {
    --         {
    --             label = 'Hello world',
    --             quantity = 20,
    --         },
    --         {
    --             label = 'Hello world 2',
    --             quantity = 2
    --         }
    --     },
    --     society = 'burgershot',
    --     phone = 'qzdqzdqzd'
    -- })
-- end)

local function getAllCommands()
    local src = source

    local playerJob = GetPlayer(src):getJob()

    -- print(playerJob)
    local _commands

    local commands
    
    MySQL.Async.fetchAll('SELECT * FROM postop_commands WHERE fournisseur = ? ORDER BY id DESC LIMIT 15', {
        playerJob
    }, function(result) 
        _commands = result

        commands = _commands or {}

        TriggerLatentClientEvent('core:postop:getcommands', src, 20000, commands)

        -- TriggerEvent('PostOP::PrintClientSide', commands)

    end)

    return commands
end


local function approveDelivery(order)
    MySQL.Async.execute("UPDATE postop_commands SET state = 'delivered' WHERE id = ?" , {
        order.id,
    }, function(affectedRow)
    
    end)

end

local function cancelDelivery(order)
    MySQL.Async.execute("UPDATE postop_commands SET state = 'canceled' WHERE id = ?" , {
        order.id,
    }, function(affectedRow)
    
    end)

end


local function getSocietyStorage(name)
    -- ? no transaction possible with ox, so im forced to do like this.
    --[[ print(('society: %s'):format(name)) ]]
    local response
    
    MySQL.Async.fetchAll("SELECT items FROM postop_storages WHERE name = ?", {
        name
    }, function(result)
        response = result
    end)

    if not response then
--[[         MySQL.Sync.insert("INSERT INTO postop_storages (name, items) VALUES (?, ?)", {
            name,
            json.encode({}),
        }) ]]
        return nil
    end

    return response
end


local function setSocietyStorage(data)
    if not data then return end

    --[[ print(('TEST OUAIS society: %s'):format(data.society)) ]]

    local res


    local response
    
    MySQL.Async.fetchAll("SELECT items FROM postop_storages WHERE name = ?", {
        data.society
    }, function(result)
        response = result
    end)

    if not response[1] then
        
        MySQL.Async.insert("INSERT INTO postop_storages (name, items) VALUES (?, ?)", {
            data.society,
            json.encode(data.items),
        }, function(result)
        
            res = result
        
        end)

        return json.decode(res)
    end
    
    MySQL.Async.execute('UPDATE postop_storages SET items = ? WHERE name = ?', { json.encode(data.items), data.society }, function(affectedRow)
        res = affectedRow
    end)

    return json.decode(res)
end

-- Citizen.CreateThread(function()
    -- local data = setSocietyStorage({
    --     society = 'burgershot',
    --     items = {
    --         {
    --             id = 'pain1',
    --             quantity = 4
    --         },
    --         {
    --             id = 'pain2',
    --             quantity = 8
    --         }
    --     }
    -- })

    -- TriggerClientEvent('__atoshi::createNotification', -1, {
    --     type = 'SUCCESS',
    --     -- duration = 5, -- In seconds, default:  4
    --     content = 'Hello world'
    -- })
-- end)

RegisterNetEvent('__getSocietyStorageAndOpenStockMenu')
AddEventHandler('__getSocietyStorageAndOpenStockMenu', function(name)
    local src = source
    local stockage = getSocietyStorage(name)

    TriggerClientEvent('__resWithSocietyStorageAndOpenStockMenu', src, stockage)
end)

RegisterNetEvent('PostOP:TakeLogs')
AddEventHandler('PostOP:TakeLogs', function(prixtotal, playerjob,  items)

    local src = source

    json.decode(items)

    SendDiscordLog("PostOP-TakItems", src, string.sub(GetDiscord(src), 9, -1), GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(), prixtotal, playerjob, items)
end)

-- RAJOUTER TEST
 --[[
AddEventHandler('onResourceStart', function()
    TriggerEvent(PostOpEvents.GET_ALL_COMMANDS)

    print("TEST RESTART POSTOP")
end)

RegisterNetEvent('PostOP::PrintClientSide')
AddEventHandler('PostOP::PrintClientSide', function(commands)

    print("TEST ABCDIZUIDZJIUHJDIZU")
    
    local commandsToSend = {
        orders = {}
    }

    for k, v in pairs(commands) do
        local formatedItemsWithName = {}

        local CMDdecoded = json.decode(v.items)

        for i=1, #CMDdecoded do

            table.insert(formatedItemsWithName, {
                quantity = CMDdecoded[i].quantity,
                name = CMDdecoded[i].label,
                id = CMDdecoded[i].id
            })

        end


        table.insert(commandsToSend.orders, {
            id = v.id,
            state = v.state,
            from = v.society,
            phone = v.phone,
            icon = v.icon or 'https://cdn.sacul.cloud/v2/vision-cdn/MenuPostOp/food.webp',
            totalprice = v.total,
            content = formatedItemsWithName
        })

        print("----------")
        print(json.encode(formatedItemsWithName))

    end

end)

]] --


RegisterNetEvent(PostOpEvents.GET_SOCIETY_STORAGE)
AddEventHandler(PostOpEvents.GET_SOCIETY_STORAGE, getSocietyStorage)

RegisterNetEvent(PostOpEvents.SET_SOCIETY_STORAGE)
AddEventHandler(PostOpEvents.SET_SOCIETY_STORAGE, setSocietyStorage)

RegisterNetEvent(PostOpEvents.SAVE_SOCIETY_STORAGE)
AddEventHandler(PostOpEvents.SAVE_SOCIETY_STORAGE, approveDelivery)

RegisterNetEvent(PostOpEvents.APPROVE_ORDER)
AddEventHandler(PostOpEvents.APPROVE_ORDER, approveDelivery)

RegisterNetEvent(PostOpEvents.CANCEL_ORDER)
AddEventHandler(PostOpEvents.CANCEL_ORDER, cancelDelivery)

RegisterNetEvent(PostOpEvents.ADD_COMMAND_TO_DB)
AddEventHandler(PostOpEvents.ADD_COMMAND_TO_DB, addCommandToDb)

RegisterNetEvent(PostOpEvents.GET_ALL_COMMANDS)
AddEventHandler(PostOpEvents.GET_ALL_COMMANDS, getAllCommands)
