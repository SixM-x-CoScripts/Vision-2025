RegisterNetEvent("core:DisableGrabFleeca")
AddEventHandler("core:DisableGrabFleeca", function (token, key, info)
    if CheckPlayerToken(source, token ) then 
        TriggerClientEvent("core:DisableGrabFleeca", -1 , key, info)
    end
end)

RegisterNetEvent("core:FleecaDone")
AddEventHandler("core:FleecaDone", function (token, key)
    if CheckPlayerToken(source, token ) then 
        TriggerClientEvent("core:FleecaDone", -1 , key)
    end
end)

RegisterNetEvent("core:LockDoorFleecaSync")
AddEventHandler("core:LockDoorFleecaSync", function (token, data, bool)
    if CheckPlayerToken(source, token) then
        TriggerClientEvent("core:LockDoorFleecaSync", -1 ,data, bool)

    end
end)

RegisterNetEvent("core:OpenTheFleecaDoor")
AddEventHandler("core:OpenTheFleecaDoor", function (token, pos, hash)
    if CheckPlayerToken(source, token) then
        TriggerClientEvent("core:OpenTheFleecaDoor", -1 ,pos, hash)
    end
end)
RegisterNetEvent("core:HackSuccess")
AddEventHandler("core:HackSuccess", function (token, key, bool)
    if CheckPlayerToken(source, token) then
        TriggerClientEvent("core:HackSuccess", -1 ,key, bool)
    end
end)
RegisterNetEvent("core:IpHacking")
AddEventHandler("core:IpHacking", function (token, key, bool)
    if CheckPlayerToken(source, token) then
        TriggerClientEvent("core:IpHacking", -1 ,key, bool)
    end
end)

RegisterNetEvent("core:StartBoucleGrab")
AddEventHandler("core:StartBoucleGrab", function (token, data, cam, door, key)
    if CheckPlayerToken(source, token) then
        TriggerClientEvent("core:StartBoucleGrab", -1 ,data, cam, door, key)
    end
end)