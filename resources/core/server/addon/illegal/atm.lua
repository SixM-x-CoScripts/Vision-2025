local playerList = {}
local wait = false
RegisterNetEvent("core:setPlayerATMRobberyGood", function()
    local source = source
    local id = GetPlayer(source):getId()
    if id ~= nil then
        playerList[id] = true;
    end
end)

local entityList = {}
RegisterNetEvent("core:BlackListATM", function(netEntity)
    entityList[netEntity] = GetGameTimer() + 600000
end)

Citizen.CreateThread(function()
    while RegisterServerCallback == nil do Wait(100) end

    RegisterServerCallback("core:ATMAlreadyRob", function(source)
        local id = GetPlayer(source):getId()
        if id ~= nil then
            return playerList[id];
        end
        return false
    end)

    RegisterServerCallback("core:EntityATMAlreadyRob", function(source, token, netEntity)
        if CheckPlayerToken(source, token) then
            return (entityList[netEntity] and (entityList[netEntity] < GetGameTimer()))
        end
    end)
end)
