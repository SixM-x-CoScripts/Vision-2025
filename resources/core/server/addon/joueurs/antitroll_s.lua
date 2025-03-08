local RegisteredVehs = {}

local AllTimes = {}

RegisterNetEvent("core:antiTroll:storeVeh", function(veh)
    table.insert(RegisteredVehs, veh)
    TriggerClientEvent("core:antiTroll:storeVeh", -1, veh)
end)

RegisterNetEvent("core:requestTrollVehs", function()
    local src = source
    TriggerLatentClientEvent("core:antiTroll:storeAllVeh", src, 25000, veh)
end)

RegisterNetEvent("core:antiTroll:saveTime", function(token, time)
    local src = source
    local found = false
    if CheckPlayerToken(src, token) then
        for k,v in pairs(AllTimes) do
            if v.src == src then
                found = true
                v.time = time
            end
            if not found then
                table.insert(AllTimes, {src = src, time = time, license = GetPlayer(src):getLicense()})
            end
        end
    end
end)

AddEventHandler('playerDropped', function(reason)
	local source = source

    for k,v in pairs(AllTimes) do
        if v.src == source then
            MySQL.Async.execute("UPDATE players SET timeStart = @1 WHERE license = @license", {
                ["@1"] = v.time,
                ["@license"] = v.license
            }, function()
            end)
        end
    end
end)

RegisterServerCallback("core:antiTroll:getMyTime", function(source)
    local time = nil
    for k,v in pairs(AllTimes) do
        if v.src == source then
            time = v.time
        end
    end
    return time
end)
