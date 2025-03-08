RegisterNetEvent("core:SendCoordsToPly", function(tbl, ply)
    local minute = tonumber(os.date("%M"))
    if minute >= 0 and minute <= 9 then
        minute = "0" .. minute
    end
    local time = tonumber(os.date("%H")) .. "H" .. minute
    TriggerClientEvent("core:SendGpsCoordsToPly", ply, tbl, time)
end)

RegisterServerCallback("core:hasgps", function(source)
    local item = DoesPlayerHaveItemCount(source, "gps", 1)
    return item
end)