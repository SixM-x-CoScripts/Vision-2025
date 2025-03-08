function SetPlayerStatus(source, hunger, thirst, health)
    local player = GetPlayer(source)
    if player ~= nil then
        player:setHunger(hunger)
        player:setThirst(thirst)
        player:setHealth(health)
        triggerEventPlayer("core:setStatusPlayer", source, hunger, thirst, health)
    end
end

RegisterNetEvent("core:SetPlayerStatus")
AddEventHandler("core:SetPlayerStatus", function(token, hunger, thirst, health)
    local src = source
    if CheckPlayerToken(src, token) then
        SetPlayerStatus(src, hunger, thirst, health)
        --RefreshPlayerData(src)
        MarkPlayerDataAsNonSaved(src)
    end
end)

RegisterNetEvent("core:deletesyncItem", function(netid)
    local obj = NetworkGetEntityFromNetworkId(netid)
    TriggerClientEvent("core:deletesyncItemC", -1, netid)
    if obj and DoesEntityExist(obj) then 
        DeleteEntity(obj)
    end
end)

local AllPoudres = {}

local function StartTimerResetPoudre(src)
    Citizen.CreateThread(function()
        Citizen.Wait(1 * 2700000)
        AllPoudres[src] = nil
    end)
end

RegisterNetEvent("core:testPoudre", function()
    local src = source
    if GetPlayerRoutingBucket(src) ~= 0 then return end
    local found = false
    if AllPoudres[src] then 
        if AllPoudres[src] == 75 then 
            AllPoudres[src] = 90
        elseif AllPoudres[src] == 90 then 
            AllPoudres[src] = 100
        end
    else
        AllPoudres[src] = 75
        StartTimerResetPoudre(src)
    end
end)

RegisterServerCallback("core:getTestPoudre",function(source, id)
    return AllPoudres[id]
end)