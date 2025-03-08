local locked = {}
local Spawned

RegisterNetEvent("drug:pedLock", function(ped, players)
    -- store the ped in the locked table
    table.insert(locked, ped)
    -- export the new locked ped  to the client
    TriggerClientEvents("drug:pedLock", players, ped)
end)

RegisterNetEvent("core:playerLoaded", function(source)
    TriggerClientEvent("drug:loadPedLock", source, locked)
end)

CreateThread(function()
    while true do 
        Wait(2*60000)
        locked = {}
    end
end)

CreateThread(function ()
    while RegisterServerCallback == nil do Wait(0) end
    RegisterServerCallback("core:VehTabletSpawn", function (source, token, bool)
        if CheckPlayerToken(source, token) then 
            Spawned = bool
            return Spawned
        end
    end)
end)