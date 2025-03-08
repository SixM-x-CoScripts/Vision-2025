local AleaItems = {
    --"donutc",
    --"donutn",
    --"Muffinchoco",
    --"citronade",
    --"Jusdefruits",
    "jewel",
    "perfume",
    --"camera",
    "enceinte",
    "manettejv",
    "weapon_bouteille",
    "guitar",
    "bouteille2",
    "champagne_pack",
    "weapon_knuckle",
    "weapon_knife",
    "money",
    --"burger",
    --"juice",
    --"sundae",
    --"warpp",
    --"wrarpb",
    "coke",
    "weed",
    "cig",
    "can",
    --"whisky",
    --"vodka",
    "penden",
    "penden2",
    "pince",
}

RegisterNetEvent("core:volarracheitems", function(timeC, secu, money)
    if CheckTrigger(source, timeC, secu, "core:volarracheitems") then
        local ply = GetPlayer(source)
        local ran = math.random(4, 6)
        for i=1, ran do
            GiveItemToPlayer(source, AleaItems[math.random(1, #AleaItems)], 1, {})
        end
        GiveItemToPlayer(source, "money", money, {})
    end
end)

local playerList = {}
local plyListArrache = {}

RegisterNetEvent("core:addLimitRobbery")
AddEventHandler("core:addLimitRobbery", function()
    local id = GetPlayer(source):getId()
    if id ~= nil then
        if not playerList[id] then
            playerList[id] = 1
        else
            playerList[id] += 1
        end
    end
end)

RegisterNetEvent("core:addLimitVolArrache")
AddEventHandler("core:addLimitVolArrache", function()
    local id = GetPlayer(source):getId()
    if id ~= nil then
        if not plyListArrache[id] then
            plyListArrache[id] = 1
        else
            plyListArrache[id] += 1
        end
    end
end)

RegisterServerCallback("core:getLimitRaquette", function(source)
    local id = GetPlayer(source):getId()
    return playerList[id]
end)

RegisterServerCallback("core:getLimitVolArrache", function(source)
    local id = GetPlayer(source):getId()
    return plyListArrache[id]
end)

RegisterNetEvent("core:braquageAtm", function(timeC, secu, money)
    if CheckTrigger(source, timeC, secu, "core:braquageAtm") then
        GiveItemToPlayer(source, "money", money, {})
    end
end)

RegisterNetEvent("core:sync:BurnEvent", function(players, coords)
    TriggerClientEvents("core:sync:atmburn", players, coords)
end)

RegisterServerEvent('shoprobbery:server:sync')
AddEventHandler('shoprobbery:server:sync', function(type, index, index2)
    if type ~= 'startRobbery' then
        TriggerClientEvent('shoprobbery:client:sync', -1, type, index, index2)
    else
        local chance = math.random(1, 100)
        TriggerClientEvent('shoprobbery:client:sync', -1, type, index, index2, chance)
    end
end)
