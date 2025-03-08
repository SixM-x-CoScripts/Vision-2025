local table_plyhavebag = {}
local table_serfelxedply = {}

RegisterNetEvent("core:setHeadBag", function(token, player)
    local src = source
    if CheckPlayerToken(src, token) then
        table.insert(table_plyhavebag, player)
        TriggerClientEvent("core:setBagInHead", player, 1)
    end
end)

RegisterNetEvent("core:removeHeadBag", function(token, player)
    local src = source
    if CheckPlayerToken(src, token) then
        for k, v in pairs(table_plyhavebag) do
            if player == v then
                table.remove(table_plyhavebag, k)
                TriggerClientEvent("core:setBagInHead", player, 0)
            end
        end
    end
end)

CreateThread(function()
    while RegisterServerCallback == nil do Wait(0) end
    RegisterServerCallback("core:getHeadBag", function(source, player)
        for k, v in pairs(table_plyhavebag) do
            if player == v then
                return true
            end
        end
        return false
    end)
end)

RegisterNetEvent("core:setSerflexToPly", function(token, player)
    local src = source
    if CheckPlayerToken(src, token) then
        table_serfelxedply[player] = true
        TriggerClientEvent("core:handSerflex", player)
    end
end)

RegisterNetEvent("core:unSerflexToPly", function(token, player)
    local src = source
    if CheckPlayerToken(src, token) then
        table_serfelxedply[player] = nil
        TriggerClientEvent("core:removehandSerflex", player)
    end
end)

CreateThread(function()
    while RegisterServerCallback == nil do Wait(0) end
    RegisterServerCallback("core:getSerflexedPly", function(source, player)
        return table_serfelxedply[player]
    end)
end)
