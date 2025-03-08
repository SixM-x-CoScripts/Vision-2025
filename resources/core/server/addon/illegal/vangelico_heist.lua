local braqued = false

RegisterNetEvent("core:globalObject")
AddEventHandler("core:globalObject", function(obj, random)
    TriggerClientEvent('core:globalObjectStock', -1, obj, random)
end)

RegisterNetEvent("core:insideLoop")
AddEventHandler("core:insideLoop", function()
    TriggerClientEvent('core:playerInsideLoop', -1)
end)

RegisterNetEvent("core:lootSync")
AddEventHandler("core:lootSync", function(type, index)
    braqued = true
    TriggerClientEvent('core:lootSyncObj', -1, type, index)
end)

RegisterNetEvent("core:smashSync")
AddEventHandler("core:smashSync", function(sceneCfg)
    local src = source
    TriggerClientEvent('core:smashSyncObj', src, sceneCfg)
end)

RegisterNetEvent("core:vangelico_removeBlips")
AddEventHandler("core:vangelico_removeBlips", function(blip)
    TriggerClientEvent('core:playerVangelico_removeBlips', -1, blip)
end)

Citizen.CreateThread(function()
    while RegisterServerCallback == nil do Wait(1) end

    RegisterServerCallback("core:getIfAlrdyRobbed", function()
        return braqued
    end)
end) 

local antispam = {}
RegisterNetEvent("core:startAlarm", function(typee, bool, players)
    if not antispam[source] then 
        antispam[source] = 0
    end
    antispam[source] += 1
    if antispam[source] > 5 then 
        DropPlayer(source, "Spamming event")
        CancelEvent()
    end
    TriggerClientEvents("core:startAlarm", players, typee, bool)
end)

RegisterNetEvent("core:sync:vangelicoheat", function()
    TriggerClientEvent("core:sync:vangelicoheat", -1)
end)