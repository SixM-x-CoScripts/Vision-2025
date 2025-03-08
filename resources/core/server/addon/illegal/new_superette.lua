local playerListRob = {}
RegisterNetEvent("core:setPlayerRobberyGood")
AddEventHandler("core:setPlayerRobberyGood", function()
    local src = source
    local id = GetPlayer(src):getId()
    if id ~= nil then
        playerListRob[id] = true
    end
end)

local playerListBinco = {}
local playerListEntreprises = {}

RegisterServerCallback("core:hasBraquedSup", function(source)
    local id = GetPlayer(source)
    if not id then return false end
    local plyid = id:getId()
    return playerListRob[plyid]
end)


RegisterServerCallback("core:getIfPlayerAlrdyRobbeBinco", function(source)
    local id = GetPlayer(source)
    if not id then return false end
    local plyid = id:getId()
    if id ~= nil then
        return playerListBinco[plyid]
    end
    return false
end)

RegisterServerCallback("core:getIfPlayerAlrdyRobbeEntreprises", function(source)
    local id = GetPlayer(source)
    if not id then return false end
    local plyid = id:getId()
    if id ~= nil then
        return playerListEntreprises[plyid]
    end
    return false
end)

RegisterNetEvent("core:setPlayerRobberyGoodBinco")
AddEventHandler("core:setPlayerRobberyGoodBinco", function()
    local id = GetPlayer(source):getId()
    if id ~= nil then
        playerListBinco[id] = true
    end
end)

RegisterNetEvent("core:superette:sync", function(objNet, rot)
    TriggerClientEvent("core:superette:sync", -1, objNet, rot)
end)

RegisterNetEvent("core:setPlayerRobberyGoodEntreprises")
AddEventHandler("core:setPlayerRobberyGoodEntreprises", function()
    local id = GetPlayer(source):getId()
    if id ~= nil then
        playerListEntreprises[id] = true
    end
end)
