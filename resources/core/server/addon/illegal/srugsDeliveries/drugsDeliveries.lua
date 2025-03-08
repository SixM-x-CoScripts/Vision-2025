commandToDo = {}
CommandNeeds = {}
commandDone = {}
local store = {}
local WaitingTabletHour = {}
local crewCommandWeapon = {}
vehsToUnlock = {}
Armes = {
    --pf
    ["plate"] = {cd = 432000, quantityMax = 6, level = 1},
    --gang
    ["weapon_bat"] = {cd = 172800, quantityMax = 10, level = 2},
    ["weapon_bottle"] = {cd = 172800, quantityMax = 10, level = 2},
    ["weapon_crowbar"] = {cd = 172800, quantityMax = 10, level = 2},
    ["weapon_golfclub"] = {cd = 172800, quantityMax = 10, level = 2}, 
    ["weapon_hatchet"] = {cd = 172800, quantityMax = 10, level = 2},
    ["weapon_knuckle"] = {cd = 172800, quantityMax = 10, level = 2},
    ["weapon_machete"] = {cd = 172800, quantityMax = 10, level = 2},
    ["weapon_nightstick"] = {cd = 172800, quantityMax = 10, level = 2},
    ["weapon_wrench"] = {cd = 172800, quantityMax = 10, level = 2},
    ["weapon_knife"] = {cd = 172800, quantityMax = 10, level = 2},
    ["weapon_switchblade"] = {cd = 172800, quantityMax = 10, level = 2},
    ["weapon_battleaxe"] = {cd = 172800, quantityMax = 10, level = 2},
    ["weapon_poolcue"] = {cd = 172800, quantityMax = 10, level = 2},
    ["weapon_canette"] = {cd = 172800, quantityMax = 10, level = 2},
    ["weapon_bouteille"] = {cd = 172800, quantityMax = 10, level = 2},
    ["weapon_pelle"] = {cd = 172800, quantityMax = 10, level = 2},
    ["weapon_pickaxe"] = {cd = 172800, quantityMax = 10, level = 2},
    ["weapon_sledgehammer"] = {cd = 172800, quantityMax = 10, level = 2},
    ["weapon_dagger"] = {cd = 172800, quantityMax = 10, level = 2},

    --mc
    ["weapon_pistol"] = {cd = 345600, quantityMax = 4, level = 3},
    ["weapon_vintagepistol"] = {cd = 345600, quantityMax = 4, level = 3},
    ["weapon_snspistol"] = {cd = 345600, quantityMax = 4, level = 3},
    ["weapon_dbshotgun"] = {cd = 518400, quantityMax = 4, level = 3},
    ["weapon_molotov"] = {cd = 604800, quantityMax = 3, level = 3},

    --orga
    ["weapon_katana"] = {cd = 604800, quantityMax = 2, level = 3},
    ["weapon_combatpistol"] = {cd = 345600, quantityMax = 4, level = 3},
    ["weapon_heavypistol"] = {cd = 345600, quantityMax = 4, level = 3},
    ["weapon_revolver"] = {cd = 518400, quantityMax = 4, level = 3},
    ["weapon_doubleaction"] = {cd = 604800, quantityMax = 4, level = 3},
    ["weapon_microsmg"] = {cd = 604800, quantityMax = 2, level = 3},
    ["weapon_machinepistol"] = {cd = 604800, quantityMax = 2, level = 3},
    ["weapon_minismg"] = {cd = 604800, quantityMax = 2, level = 3},
    ["weapon_assaultshotgun"] = {cd = 604800, quantityMax = 2, level = 3},
    ["weapon_sawnoffshotgun"] = {cd = 518400, quantityMax = 2, level = 3},
    ["weapon_pumpshotgun"] = {cd = 604800, quantityMax = 2, level = 3},
    ["weapon_heavyshotgun"] = {cd = 604800, quantityMax = 2, level = 3},

    --mafia
    ["weapon_pistol50"] = {cd = 518400, quantityMax = 4, level = 3},
    ["weapon_autoshotgun"] = {cd = 604800, quantityMax = 2, level = 3},
    ["weapon_combatshotgun"] = {cd = 864000, quantityMax = 2, level = 3},
    ["weapon_compactrifle"] = {cd = 604800, quantityMax = 2, level = 3},
    ["weapon_assaultrifle"] = {cd = 864000, quantityMax = 2, level = 3},
    ["weapon_gusenberg"] = {cd = 864000, quantityMax = 2, level = 3},
    ["weapon_smg"] = {cd = 604800, quantityMax = 2, level = 3},
    ["weapon_carbinerifle"] = {cd = 864000, quantityMax = 2, level = 3},
    ["weapon_specialcarbine"] = {cd = 864000, quantityMax = 2, level = 3},
}

--[[CreateThread(function()
    MySQL.Async.fetchAll('SELECT * FROM `command_tablet`', {}, 
    function(result)
        if result ~= nil then
            for k, v in pairs(result) do
                if v.done == false then
                    table.insert(commandToDo, {
                        id = v.id,
                        order = json.decode(v.order),
                        time = v.time,
                        date = v.date,
                        total = v.total,
                        typeObject = v.typeObject,
                        crewName = v.crewName,
                        done = v.done
                    })
                else
                    table.insert(commandDone, {
                        id = v.id,
                        order = json.decode(v.order),
                        time = v.time,
                        date = v.date,
                        total = v.total,
                        typeObject = v.typeObject,
                        crewName = v.crewName,
                        done = v.done
                    })
                end
            end
        end
        -- local AllStore = MySQL.Async.fetchAll("SELECT tablet.*, tablet_type.name as name, tablet_type.typeObject as typeObject, tablet_type.price as price, tablet_type.image as image FROM tablet INNER JOIN tablet_type ON tablet.tablet_type_id = tablet_type.id")
        -- for k, v in pairs(AllCommand) do
        --     if store[v.crew] == nil then
        --         store[v.crew] = {}
        --     end
        --     store[v.crew][v.name] = {}
        --     store[v.crew][v.name].name = v.name
        --     store[v.crew][v.name].typeObject = v.typeObject
        --     store[v.crew][v.name].price = v.price
        --     store[v.crew][v.name].spawnName = v.name
        --     store[v.crew][v.name].image = v.image
        -- end
    end)
end)]]

RegisterNetEvent("drugsDeliveries:msg1")
AddEventHandler("drugsDeliveries:msg1", function(pos)
    local pPhone = exports["lb-phone"]:GetEquippedPhoneNumber(source)
    exports["lb-phone"]:SendMessage("666-8596", pPhone,
        "yo, voila la position pour l'echange, viens recuperer tes marchandises"
        , nil, nil, nil)
    Wait(5000)
    exports["lb-phone"]:SendCoords("666-8596", pPhone, pos)
end)

RegisterNetEvent("drugsDeliveries:msgEnemy")
AddEventHandler("drugsDeliveries:msgEnemy", function(pos)
    local pPhone = exports["lb-phone"]:GetEquippedPhoneNumber(source)
    exports["lb-phone"]:SendMessage("666-8596", pPhone,
        "yo, j'ai recu l'info qu'une livraison étais en cours!"
        , nil, nil, nil)
end)

RegisterNetEvent("drugsDeliveries:msg2")
AddEventHandler("drugsDeliveries:msg2", function()
    local pPhone = exports["lb-phone"]:GetEquippedPhoneNumber(source)
    exports["lb-phone"]:SendMessage("666-8596", pPhone,
        "Merci à la prochaine.", nil, nil, nil)
end)

RegisterNetEvent("drugsDeliveries:deleteconvo")
AddEventHandler("drugsDeliveries:deleteconvo", function()
    local pPhone = exports["lb-phone"]:GetEquippedPhoneNumber(source)
    -- sql query to get the id of the conversation
    local channelId = MySQL.Sync.fetchScalar([[SELECT c.channel_id FROM phone_message_channels c WHERE c.is_group = 0
            AND EXISTS (SELECT TRUE FROM phone_message_members m WHERE m.channel_id = c.channel_id AND m.phone_number = @from)
            AND EXISTS (SELECT TRUE FROM phone_message_members m WHERE m.channel_id = c.channel_id AND m.phone_number = @to)]]
        , { ["@from"] = "666-8596", ["@to"] = pPhone })
    MySQL.Async.execute("DELETE FROM phone_message_messages WHERE channel_id = @channel",
        { ["@channel"] = channelId })
    MySQL.Async.execute("DELETE FROM phone_message_channels WHERE channel_id = @channel",
        { ["@channel"] = channelId })
end)

RegisterNetEvent("drugsDeliveries:addItemTrunk")
AddEventHandler("drugsDeliveries:addItemTrunk", function(token, plate, item, nbr, actualDeliveryId)
    --print(_Utils.Trim(GetVehicleNumberPlateText(veh)), GetVehicleIndexFromPlate(_Utils.Trim(GetVehicleNumberPlateText(veh))))
    --local plate = GetVehicleNumberPlateText(veh)
    --local index = GetVehicleIndexFromPlate(plate)
    if not DoesItemexist(item) then 
        TriggerClientEvent("__atoshi::createNotification", source, {
            type = "ROUGE",
            content = "L'item "..item.." n'existe pas, merci de montrer ce message au STAFF (pas au dev)."
        })
        return
    end
    if not CommandNeeds[actualDeliveryId] then
        TriggerClientEvent("__atoshi::createNotification", source, {
            type = "ROUGE",
            content = "La commande a déjà était prise 1."
        })
        return 
    end 
    if CommandNeeds[actualDeliveryId].total <= 0 then 
        TriggerClientEvent("__atoshi::createNotification", source, {
            type = "ROUGE",
            content = "La commande a déjà était prise 2."
        })
        return 
    end
    CommandNeeds[actualDeliveryId].total -= nbr
    print("New commands needs", CommandNeeds[actualDeliveryId].total)
    AddItemToInventoryVehicleStaff(plate, item, tonumber(nbr), {})
end)

RegisterNetEvent("drugsDeliveries:spawn")
AddEventHandler("drugsDeliveries:spawn", function(data, order)
    local veh = data.veh
    local pos = data.pos
    local veh = CreateVehicle(GetHashKey(veh), pos.x, pos.y, pos.z, pos.w, true, true)
    while not DoesEntityExist(veh) do
        Wait(1)
    end
    --SetVehicleDoorsLocked(veh, 2)
    local plate = GetVehicleNumberPlateText(veh)
    local index = GetVehicleIndexFromPlate(plate)
    SetVehicleDoorsLocked(veh, 1)
    -- for key, item in pairs(order) do
    --     AddItemToInventoryVehicleStaff(plate, item.spawnName, tonumber(item.quantity), {})
    -- end
    MarkVehicleAsNotSaved(index, plate)
    Wait(1000)
    --SetVehicleDoorsLocked(veh, 2)
end)

RegisterNetEvent("drugsDeliveries:openVeh")
AddEventHandler("drugsDeliveries:openVeh", function(token, veh, robertoName, owner, typeObject, crewWin)
    SetVehicleDoorsLocked(NetworkGetEntityFromNetworkId(veh), 0)
    print(owner, typeObject, crewWin)
    local crewList = getSameKindCrewsFromName(owner)
    for k, value in pairs(crewList) do
        TriggerClientEvents("drugsDeliveries:removeBulle", GetAllCrewIds(value), robertoName, crewWin)
    end
end)

local DeliveryIndexes = {}
RegisterServerCallback("drugsDelivery:getIndex", function(source, namecrew, deliveryId)
    if not DeliveryIndexes[deliveryId] then 
        DeliveryIndexes[deliveryId] = 1
        return 1
    else
        DeliveryIndexes[deliveryId] += 1
        if DeliveryIndexes[deliveryId] >= 4 then 
            print("Finished livraison id " .. deliveryId)
            TriggerClientEvent("core:drugsDeliveries:endDelivery", -1, deliveryId, namecrew)
            SetTimeout(2000, function()
                TriggerClientEvent("core:drugsDeliveries:endDelivery", -1, deliveryId, namecrew)
                DeliveryIndexes[deliveryId] = "finished"
                CommandNeeds[deliveryId] = nil
            end)
        end
        return DeliveryIndexes[deliveryId] ~= nil and DeliveryIndexes[deliveryId] or 4
    end
end)

RegisterNetEvent("drugsDeliveries:endDelivery")
AddEventHandler("drugsDeliveries:endDelivery", function(crewWin, deliveryId)
    TriggerClientEvent("core:drugsDeliveries:endDelivery", -1, deliveryId, crewWin)
end)

function spawnVeh(data, order, typeObject)
    local vehname = data.veh
    local pos = data.pos
    local veh = CreateVehicle(GetHashKey(vehname), pos.x, pos.y, pos.z, pos.w, true, true)
    while not DoesEntityExist(veh) do 
        print(veh)
        Wait(1)
    end
    --local pilot = CreatePedInsideVehicle(veh, 1, GetHashKey("a_m_m_indian_01"), -1, true, true)
    local timer = 1
    local shouldCrea = false
    -- while not DoesEntityExist(veh) do
    --     Wait(1)
    --     timer += 1 
    --     if timer > 600 then 
    --         shouldCrea = true
    --         break
    --     end
    -- end
    -- if shouldCrea then 
    --     veh = CreateVehicle(GetHashKey("speedo"), pos.x, pos.y, pos.z, pos.w, true, true)
    --     while not DoesEntityExist(veh) do
    --         Wait(1)
    --     end
    -- end
    SetEntityDistanceCullingRadius(veh, 9999.9)
    SetVehicleDoorsLocked(veh, 1)
    local plate = GetVehicleNumberPlateText(veh)
    newVeh(plate, vehname, veh, true)
    table.insert(vehsToUnlock, plate)
    Wait(1000)
    SetVehicleDoorsLocked(veh, 0)
    --for key, item in pairs(order) do
    --    print(plate, item.spawnName, tonumber(item.quantity))
    --    AddItemToInventoryVehicleStaff(plate, item.spawnName, tonumber(item.quantity), {})
    --end
    return NetworkGetNetworkIdFromEntity(veh), plate
end

function addCommandToBdd(order, time, date, total, typeObject, crewName)
    local id = MySQL.Sync.insert("INSERT INTO `command_tablet` (`order`, `time`, `date`, `total`, `typeObject`, `done`, `crewName`) VALUES (@1, @2, @3, @4, @5, @6, @7)",
        {
            ["1"] = tostring(json.encode(order)),
            ["2"] = time,
            ["3"] = tostring(date),
            ["4"] = total,
            ["5"] = typeObject,
            ["6"] = false,
            ["7"] = crewName
        })
    -- MySQL.Async.execute("INSERT INTO `command_tablet` (`order`, `time`, `date`, `total`, `typeObject`, `done`, `crewName`) VALUES (@1, @2, @3, @4, @5, @6, @7)",
    --     {
    --         ["1"] = tostring(json.encode(order)),
    --         ["2"] = time,
    --         ["3"] = tostring(date),
    --         ["4"] = total,
    --         ["5"] = typeObject,
    --         ["6"] = false,
    --         ["7"] = crewName
    --     }, function(affectedRows)
    --         id = affectedRows
    --         print(affectedRows)
    -- end)
    return id
end

RegisterNetEvent("drugsDeliveries:saveCommand")
AddEventHandler("drugsDeliveries:saveCommand", function(data, crewName, typeObject)
    local source = source
    local date = os.date("%Y-%m-%dT%X")--2022-12-05T22:30:17-01:00
    if next(commandToDo) ~= nil then
        for k, v in pairs(commandToDo) do
            if v.time == data.time and v.crewName == crewName then
                TriggerClientEvent('drugsDeliveries:saveCommandReturn', source, "Votre crew a déjà une livraison à cette heure ci", data.order, data.total, typeObject)
                return
            end
        end
    end
    if WaitingTabletHour[tostring(data.time)] == true then 
        TriggerClientEvent('drugsDeliveries:saveCommandReturn', source, "Cette horraire n'est pas disponible, choisi en une autre")
        return
    end
    WaitingTabletHour[tostring(data.time)] = true
    local id = addCommandToBdd(data.order, data.time, date, data.total, typeObject, crewName)
    local timer = 1
    print("Created command ID ",id,data.time)
    while not id and timer < 200 do 
        Wait(1) 
        timer += 1
    end
    table.insert(commandToDo, {
        id = id,
        order = data.order,
        time = data.time,
        date = date,
        total = data.total,
        typeObject = typeObject,
        crewName = crewName,
        done = false
    })
    SendDiscordLog("tablet", source, string.sub(GetDiscord(source), 9, -1),
        GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(), crewName,
        json.encode(data.order))
    TriggerClientEvent('drugsDeliveries:saveCommandReturn', source, true, data.order, data.total, typeObject)
end)

function init(order)
    math.randomseed(GetGameTimer())
    local ramdom = math.random(1, #Drugs.Delivery)
    data = Drugs.Delivery[ramdom]
    return data
end

Citizen.CreateThread(function()
    while true do
        Wait(1 * 20000) -- 50 seconds
        for k, v in pairs(commandToDo) do
            if tostring(v.time) == tostring(os.date("%H:%M")) then
                if v.done ~= true then
                    v.done = true
                    local crewNameCreator = v.crewName
                    local dataInit = init(v.order)
                    WaitingTabletHour[tostring(data.time)] = nil
                    local crewByName = getCrewByName(crewNameCreator)
                    local crewType 
                    if crewByName then
                        crewType = crewByName:getType()
                    end
                    dataInit.objects = {}
                    local propsSpawnName = "hei_prop_hei_drug_pack_01b"
                    if v.typeObject == "weapons" then
                        propsSpawnName = "prop_box_guncase_01a"
                    elseif v.typeObject == "utils" then
                        propsSpawnName = "prop_tool_box_04"
                    end
                    for k, v in pairs(dataInit.props) do
                        local object = CreateObject(propsSpawnName, v.posProp, true, true)
                        local timer = 1
                        while not DoesEntityExist(object) and timer < 50 do Wait(1) timer += 1 end
                        if object and DoesEntityExist(object) then
                            FreezeEntityPosition(object, true)
                            SetEntityDistanceCullingRadius(object, 999.9)
                            table.insert(dataInit.objects, {pos = v.posProp, id = object, netId = NetworkGetNetworkIdFromEntity(object)})
                        end
                    end
                    print("Create needs quantity for command", v.id)
                    CommandNeeds[v.id] = { total = 0 }
                    for _, item in pairs(v.order) do
                        CommandNeeds[v.id].total += item.quantity
                    end
                    print("Commands needs quantity", CommandNeeds[v.id].total)
                    print("Envoi de la commande aux clients :", crewNameCreator, crewType, v.id)
                    local sendData = {}
                    sendData.objects = dataInit.objects
                    sendData.pos = dataInit.pos
                    TriggerClientEvent("drugsDeliveries:StartMission", -1, v.order, crewNameCreator, v.typeObject, sendData, 15, v.id, crewType)
                    callService(dataInit.pos)
                    MySQL.Async.execute("UPDATE `command_tablet` SET `done` = @done WHERE `date` = @date and `time` = @time and `crewName` = @crewName",
                    {
                        ["done"] = v.done,
                        ["date"] = v.date,
                        ["time"] = v.time,
                        ["crewName"] = v.crewName
                    }, function(result)

                    end)
                    table.insert(commandDone, v)
                    Wait(200)
                    table.remove(commandToDo, k)
                end
            end
        end
    end
end)

function callService(pos)
    CreateThread(function()
        Wait(30000)
        makeCallGreatAgain('lspd', pos, "Livraison suspecte", "drugs")
        makeCallGreatAgain('lssd', pos, "Livraison suspecte", "drugs")
        collectgarbage("collect")
    end)
end

RegisterNetEvent("drugsDeliveries:getStore")
AddEventHandler("drugsDeliveries:getStore", function(token, crew)
    if (store[crew] ~= nil) then
        return store[crew]
    end
    return nil
end)

RegisterNetEvent("drugsDeliveries:getHistoryOrderServer")
AddEventHandler("drugsDeliveries:getHistoryOrderServer", function(token, crew)
    local source = source
    local ply = GetPlayer(source)
    if not ply then return end
    local commandCrew = {}
    for k,v in pairs(commandDone) do 
        if v.crewName == ply:getCrew() then 
            table.insert(commandCrew, v)
        end
    end
    TriggerLatentClientEvent("drugsDeliveries:getHistoryOrderClient", source, 5000, commandCrew)
    --return commandDone
end)

-- function initNewCrew()
--     local crewId = 0 --crewid in bdd
--     local crewRank = 1 --1=gang, 2=mc, 3=orga, 4=mafia
--     local tabletType = MySQL.Sync.fetchAll('SELECT * FROM tablet_type')
--     for k,v in pairs(objectToAdd[crewRank]) do
--         for kk, vv in pairs(tabletType) do
--             if vv.name == v.name
--                 MySQL.Async.execute("INSERT INTO tablet (id_crew, tablet_type_id) VALUES (@1, @2)",
--                 {
--                     ["1"] = crewId,
--                     ["2"] = vv.id
--                 }, function(affectedRows)
--                     print(affectedRows)
--                 end)
--             end
--         end
--     end
-- end

RegisterNetEvent("core:GetWeaponListCrew")
AddEventHandler("core:GetWeaponListCrew", function(crew, level)
    local source = source
    local timestamp = os.time(os.date('*t'))
    if crewCommandWeapon[crew] == nil then
        MySQL.Async.fetchAll('SELECT * FROM `tablet_armes` WHERE `crew_name` = @crew', {
            ['@crew'] = crew
        }, function(result)
            crewCommandWeapon[crew] = {}
            if json.encode(result) ~= '[]' then
                for k,v in pairs(result) do
                    if timestamp > v.cooldown and v.cooldown ~= 0 then
                        v.quantity = 0
                        v.cooldown = 0
                    end
                    table.insert(crewCommandWeapon[crew], {
                        id = v.id,
                        weapon = v.weapon_name,
                        quantity = v.quantity,
                        cooldown = v.cooldown
                    })
                    TriggerClientEvent("core:GetlistWeaponMyCrewClient", source, crewCommandWeapon[crew], timestamp)
                end
            end
        end)
    else
        for k,v in pairs(crewCommandWeapon[crew]) do
            if v.cooldown then
                if timestamp > v.cooldown and v.cooldown ~= 0 then
                    v.quantity = 0
                    v.cooldown = 0
                end
            end
        end
        TriggerClientEvent("core:GetlistWeaponMyCrewClient", source, crewCommandWeapon[crew], timestamp)
    end
end)


-- [         script:core] TEST CREW
-- [   j       ] [{"quantity":4,"stock":9,"spawnName":"weapon_snspistol","id":1,"price":600,"name":"Pétoire","image":"https://cdn.sacul.cloud/v2/vision-cdn/TabletteIllegale/weapons/weapon_assaultrifle_mk2.webp","type":"weapons"}]
-- [        v           [{"cooldown":0,"quantity":9,"weapon":"weapon_snspistol","id":4}]
function WeapondAlreadyExist(weaponName, crew)
    for k,v in pairs(crewCommandWeapon[crew]) do
        if v.weapon == weaponName then
            return false 
        end
    end
    return true
end

RegisterNetEvent("core:AddWeaponListCrew")
AddEventHandler("core:AddWeaponListCrew", function(crew, command)
    print("-----------------------")
    print(crew)
    print(json.encode(command))
    print(json.encode(crewCommandWeapon[crew]))
    print("-----------------------")
    local typeCrew = getCrewByName(crew):getType()
    local crewVariable = GetVariable(typeCrew).armes
    if json.encode(crewCommandWeapon[crew]) ~= '[]' then
        for k,v in pairs(crewCommandWeapon[crew]) do
            for i,j in pairs(command) do
                print(json.encode(v), json.encode(j))
                if v.weapon == j.spawnName and not WeapondAlreadyExist(j.spawnName, crew) then
                    v.quantity = v.quantity + j.quantity
                    if tonumber(crewVariable[v.weapon].stock) <= v.quantity then
                        v.cooldown = os.time(os.date('*t')) + tonumber(crewVariable[v.weapon].cooldown)
                    end
                    -- if j.cooldown ~= nil then
                    --     v.cooldown = j.cooldown
                    -- else
                    --     v.cooldown = 0
                    -- end
                    MySQL.Async.execute("UPDATE `tablet_armes` SET `quantity` = @quant, `cooldown` = @coolD WHERE `id` = @id",
                    {
                        ["quant"] = v.quantity,
                        ["coolD"] = v.cooldown,
                        ["id"] = v.id
                    }, function(result)
                    end)
                    return
                elseif WeapondAlreadyExist(j.spawnName, crew) then
                    if j.cooldown == nil then
                        j.cooldown = 0
                    end
                    if tonumber(crewVariable[j.spawnName].stock) <= j.quantity then
                        j.cooldown = os.time(os.date('*t')) + tonumber(crewVariable[j.spawnName].cooldown)
                    end
                    table.insert(crewCommandWeapon[crew],{
                        weapon = j.spawnName,
                        quantity = j.quantity,
                        cooldown = j.cooldown}
                    )
                    MySQL.Async.execute("INSERT INTO `tablet_armes` (`crew_name`, `weapon_name`, `quantity`, `cooldown`) VALUES (@crewN, @weaponN, @quant, @coolD)",
                    {
                        ["crewN"] = crew,
                        ["weaponN"] = j.spawnName,
                        ["quant"] =  j.quantity,
                        ["coolD"] = j.cooldown
                    }, function(result)
                    end)
                    return
                end
            end
        end
    else
        for i,j in pairs(command) do 
            if j.cooldown == nil then
                j.cooldown = 0
            end
            if tonumber(crewVariable[j.spawnName].stock) <= j.quantity then
                j.cooldown = os.time(os.date('*t')) + tonumber(crewVariable[j.spawnName].cooldown)
            end
            table.insert(crewCommandWeapon[crew],{
                weapon = j.spawnName,
                quantity = j.quantity,
                cooldown = j.cooldown}
            )
            MySQL.Async.execute("INSERT INTO `tablet_armes` (`crew_name`, `weapon_name`, `quantity`, `cooldown`) VALUES (@crewN, @weaponN, @quant, @coolD)",
            {
                ["crewN"] = crew,
                ["weaponN"] = j.spawnName,
                ["quant"] = j.quantity,
                ["coolD"] = j.cooldown
            }, function(result)
            end)
            return
        end
    end
end)

RegisterNetEvent("core:StartCooldown")
AddEventHandler("core:StartCooldown", function(crew, weapon, cooldown)
    for k,v in pairs(crewCommandWeapon[crew]) do
        if v.weapon == weapon then
            time = os.time(os.date('*t'))+v.cooldown
            MySQL.Async.execute("UPDATE `tablet_armes` SET `cooldown` = @coolD WHERE `id` = @id",
            {
                ["coolD"] = time,
                ["id"] = v.id
            }, function(result)
            end)
        end
    end
end)

RegisterNetEvent("deleteObject")
AddEventHandler("deleteObject", function(id, opt)
    if DoesEntityExist(tonumber(id)) then
        DeleteEntity(tonumber(id))
    else
        if DoesEntityExist(tonumber(opt)) then
            DeleteEntity(tonumber(opt))
        end
    end
end)

RegisterNetEvent("removeBulle")
AddEventHandler("removeBulle", function(id)
    TriggerClientEvent("core:removeBulleTablet", -1, id)
end)