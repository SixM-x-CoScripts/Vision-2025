local coupe2 = {}
local lastcoupe2 = {}

function GetCoupe2(source)
    if coupe2[source] == nil then
        local result = MySQL.Sync.fetchAll('SELECT coupe FROM players WHERE license = @license',
            { ['@license'] = GetPlayer(source):getLicense() })
        coupe[source] = result[1].coupe
        lastcoupe[source] = result[1].coupe
    end
    return coupe[source]
end

function GetDefaultCoupe(source)
    if coupe2[source] == nil then
        local result = MySQL.Sync.fetchAll('SELECT coupe FROM players WHERE license = @license',
            { ['@license'] = GetPlayer(source):getLicense() })
        coupe[source] = result[1].coupe
        lastcoupe[source] = result[1].coupe
    end
    return coupe[source]
end

RegisterNetEvent("core:SetNewCoupe2")
AddEventHandler("core:SetNewCoupe2", function(coupe2)
    MySQL.Async.execute("UPDATE players SET coupe2 = @1 WHERE license = @license",
    {
            ['@1'] = coupe2,
            ['@license'] = GetPlayer(source):getLicense(),
    })
end)

function SetCoupe2(source, coupe)
    lastcoupe2[source] = coupe2[source]
    coupe2[source] = coupe
end

RegisterNetEvent("core:SetNewCoupe2")
AddEventHandler("core:SetNewCoupe2", function(token, coupe)
    local source = source
    if CheckPlayerToken(source, token) then
        SetCoupe2(source, coupe)
    end
end)

CreateThread(function()
    while RegisterServerCallback == nil do Wait(1) end
    RegisterServerCallback("core:GetCoupe2", function(source)
        local get = GetCoupe2(source)
        return get
    end)
end)

-- CreateThread(function() -- Toz
--     while true do
--         local sources = GetPlayers();
--         local src;
--         for i = 1, #sources do
--             src = tonumber(sources[i]);
--             if coupe2[src] ~= lastcoupe2[src] and coupe2[src] ~= nil then
--                 SaveCoupe2Player(k)
--             end
--         end
--         -- for k, v in pairs(players) do
--         --     if coupe2[k] ~= lastcoupe2[k] and coupe2[k] ~= nil then
--         --         SaveCoupe2Player(k)
--         --     end
--         -- end
--         Wait(30 * 60000)
--     end
-- end)
