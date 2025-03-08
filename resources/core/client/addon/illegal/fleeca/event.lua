RegisterNetEvent("core:DisableGrabFleeca")
AddEventHandler('core:DisableGrabFleeca', function(key, trolleyKey)
    Fleeca[key].trolley[trolleyKey].loot = true
end)

RegisterNetEvent("core:FleecaDone")
AddEventHandler('core:FleecaDone', function(key, trolleyKey)
    Fleeca[key].done = true
end)


RegisterNetEvent("core:LockDoorFleecaSync")
AddEventHandler("core:LockDoorFleecaSync", function(data, bool)
    local obj = GetClosestObjectOfType(data.door[1].pos.x, data.door[1].pos.y, data.door[1].pos.z, 5.0, -1591004109,
        false, false, false)
    FreezeEntityPosition(obj, bool)
end)

RegisterNetEvent("core:OpenTheFleecaDoor")
AddEventHandler("core:OpenTheFleecaDoor", function(door, hash)
    OpenTheDoor(door, hash)
end)
