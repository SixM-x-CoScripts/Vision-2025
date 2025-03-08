local bans = {}

function IsPlayerBanned(source)
    local ids = GetPlayerIdentifiers(source)
    --local tokens = {}
    --local numIds = GetNumPlayerTokens(source)
    --for i = 0, numIds - 1 do 
    --    table.insert(tokens, GetPlayerToken(source, i))
    --end
    local idsToCheck = {}
    for k, v in pairs(ids) do
        if v and not string.find(v, "ip:") then
            idsToCheck[v] = true
        end
    end

    for k, v in pairs(bans) do
        for _, i in pairs(v.ids) do
            if idsToCheck[i] ~= nil then
                local exp = v.expiration
                local unban, d, h, m = CheckTimeRemaning(exp, k)
                if not unban then
                    return true, v, d, h, m
                else
                    return false
                end
            end
        end
    end
    return false
end

function CheckTimeRemaning(time, key)
    local d = 0
    local h = 0
    local m = 0
    local unban = false
    if time ~= 0 then
        if (tonumber(time)) > os.time() then

            local tempsrestant = (((tonumber(time)) - os.time()) / 60)
            if tempsrestant >= 1440 then
                local day = (tempsrestant / 60) / 24
                local hrs = (day - math.floor(day)) * 24
                local minutes = (hrs - math.floor(hrs)) * 60
                d = math.floor(day)
                h = math.floor(hrs)
                m = math.ceil(minutes)
            elseif tempsrestant >= 60 and tempsrestant < 1440 then
                local day = (tempsrestant / 60) / 24
                local hrs = tempsrestant / 60
                local minutes = (hrs - math.floor(hrs)) * 60
                d = math.floor(day)
                h = math.floor(hrs)
                m = math.ceil(minutes)
            elseif tempsrestant < 60 then
                d = 0
                h = 0
                m = math.ceil(tempsrestant)
            end
        else
            unban = true
            DeleteBan(key)
        end
    end
    return unban, d, h, m
end

function BanPlayer(source, raison, time2, by, heureoujour, data, callback)
    if time2 and time2 > 900 then 
        time2 = 900
    end
    local ids = GetPlayerIdentifiers(source)

    if not ids or #ids == 0 then
        if by == 0 then
            if callback then callback(false) end
            return
        end
        if GetPlayer(source) == nil then
            TriggerClientEvent("__atoshi::createNotification", by, {
                type = 'ROUGE',
                duration = 15,
                content = "Ce joueur n'est pas connecté. Le ban n'a pas été effectué.",
            })
            if callback then callback(false) end
            return
        else
            TriggerClientEvent("__atoshi::createNotification", by, {
                type = 'ROUGE',
                duration = 15,
                content = "Ce joueur n'a pas d'identifiant valide. Le ban n'a pas été effectué.",
            })
            if callback then callback(false) end
            return
        end
    end

    if not by == 0 and GetPlayer(by):getPermission() < GetPlayer(source):getPermission() then
        TriggerClientEvent("__atoshi::createNotification", by, {
            type = 'ROUGE',
            duration = 10,
            content = "Vous ne pouvez pas bannir un joueur ayant un grade supérieur au votre.",
        })
        return
    end

    local time = 9999999999
    if heureoujour == nil then heureoujour = "heure" end
    heureoujour = string.lower(heureoujour)
    
    if heureoujour == "perm" then
        expiration = 32508259200
    elseif time2 then
        if heureoujour == "heures" then 
            time = time2 * 3600
        elseif heureoujour == "jours" then 
            time = time2 * 86400
        elseif heureoujour == "perm" then 
            time = 9999999999
        end
    end
    local expiration = time
    local added = os.date("%d/%m/%Y %X")

    if expiration < os.time() and heureoujour ~= "perm" then
        expiration = os.time() + expiration
    end
    local timetext = heureoujour ~= "perm" and (time2 .. " " .. heureoujour) or "Permanent"
    DropPlayer(source, "Ban: " .. raison .. "\n\nTemps: " .. timetext)
    math.randomseed(os.time())
    local idban = math.random(112, 9999) .. "BAN" .. math.random(11, 99)

    local name = "CONSOLE" if by ~= 0 then name = GetPlayerName(by) end
    if data and data.username and data.username ~= "" and data.username ~= nil then name = data.username end

    table.insert(bans, { raison = raison, ids = ids, by = name, expiration = expiration, banDate = tostring(added), id = idban})
    MySQL.Async.insert("INSERT INTO `ban` (`id`, `ids`, `raison`, `by`, `expiration`, `date`) VALUES (@1, @2, @3, @4, @5, @6)",
    {
        ["@1"] = idban,
        ["@2"] = json.encode(ids),
        ["@3"] = raison,
        ["@4"] = name,
        ["@5"] = tostring(expiration),
        ["@6"] = tostring(added),
    })

    if callback then callback(true, idban) end
    sendEmbed("ban", name, raison, added, expiration, ids, idban)
end

function UnBanPlayer(id, callback)
    for k,v in pairs(bans) do 
        if v.id == id then 
            table.remove(bans, k)
        end
    end
    MySQL.Async.execute("DELETE FROM ban WHERE id = @id",
    {
        ['@id'] = id,
    },
    function(affectedRows)
        if affectedRows > 0 then
            if callback then callback(true) end
        else
            if callback then callback(false) end
        end
    end)
end

function DeleteBan(key)
    MySQL.Async.execute("DELETE FROM ban WHERE ban.ids = @1 AND ban.expiration = @2 AND ban.date = @3",
    {
        ['@1'] = json.encode(bans[key].ids),
        ['@2'] = bans[key].expiration,
        ['@3'] = bans[key].banDate,
    },
    function(affectedRows)
        bans[key] = nil
    end)
end

-- Init
MySQL.ready(function()
    MySQL.Async.fetchAll('SELECT * FROM ban', {}, function(result)

        for k, v in pairs(result) do
            table.insert(bans,
                { id = v.id, 
                raison = v.raison, 
                ids = json.decode(v.ids),
                by = v.by, 
                expiration = v.expiration, 
                banDate = v.date,
                needSave = false,
            })
        end
    end)
end)

RegisterNetEvent("core:ban:getbans")
AddEventHandler("core:ban:getbans", function(token)
    local src = source
    if CheckPlayerToken(src, token) then
        if GetPlayer(src):getPermission() >= 3 then
            TriggerClientEvent("core:ban:sendbans", src, bans)
        end
    end
end)

RegisterNetEvent("core:ban:banplayer")
AddEventHandler("core:ban:banplayer", function(token, id, raison, time, by, heureoujour)
    local src = source
    if CheckPlayerToken(src, token) then
        if GetPlayer(src):getPermission() >= 3 then
            BanPlayer(id, raison, time, by, heureoujour)
        end
    end
end)

function BanOfflinePlayer(identifiers, raison, time, by, heureoujour, data, callback)
    local pattern = "(%w+:%S+)"
    local ids = {}
    local license = nil

    for match in identifiers:gmatch(pattern) do
        table.insert(ids, match)
        if string.find(match, "license:") then
            license = match
        end
    end
    
    if not ids or #ids == 0 then
        if callback then callback(false) end
        return
    end

    local expiration = 0

    if heureoujour == "perm" then
        expiration = 32508259200
    elseif time ~= 0 then
        if heureoujour == "heures" then 
            expiration = os.time() + (time * 3600)
        elseif heureoujour == "jours" then
            expiration = os.time() + (time * 86400)
        else
            if callback then callback(false) end
            return
        end
    end

    local added = os.date("%d/%m/%Y %X")
    local timetext = heureoujour ~= "perm" and (time .. " " .. heureoujour) or "Permanent"
    local idban = "OFFLINE" .. math.random(112, 9999) .. "BAN" .. math.random(11, 99)

    local name = "CONSOLE" if by ~= 0 then name = GetPlayerName(by) end
    if data and data.username and data.username ~= "" and data.username ~= nil then name = data.username end

    local onlinePlayers = GetOnlinePlayer()
    for k2, v2 in pairs(onlinePlayers) do
        if v2["license"] == license then
            DropPlayer(v2["id"], "Ban: " .. raison .. "\n\nTemps: " .. timetext)
        end
    end

    table.insert(bans, { raison = raison, ids = ids, by = name, expiration = expiration, banDate = tostring(added), id = idban})
    MySQL.Async.insert("INSERT INTO `ban` (`id`, `ids`, `raison`, `by`, `expiration`, `date`) VALUES (@1, @2, @3, @4, @5, @6)",
    {
        ["@1"] = idban,
        ["@2"] = json.encode(ids),
        ["@3"] = raison,
        ["@4"] = name,
        ["@5"] = tostring(expiration),
        ["@6"] = tostring(added),
    }) 

    if callback then callback(true, idban) end
    sendEmbed("ban", name, raison, added, expiration, ids, idban)
end

RegisterNetEvent("core:ban:banofflineplayer")
AddEventHandler("core:ban:banofflineplayer", function(token, identifiers, raison, time, by, heureoujour)
    local src = source
    if CheckPlayerToken(src, token) then
        if GetPlayer(src):getPermission() >= 5 then
            BanOfflinePlayer(identifiers, raison, time, by, heureoujour)
        end
    end
end)

RegisterNetEvent("core:ban:unbanplayer", function(token, id)
    local src = source
    if CheckPlayerToken(src, token) then
        if GetPlayer(src):getPermission() >= 3 then
            UnBanPlayer(id)
        end
    end
end)