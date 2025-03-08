local warns = {}

-- Init - Fetch warns from table & store them in a local table
MySQL.ready(function()
    MySQL.Async.fetchAll('SELECT * FROM warns', {}, function(result)
    
        for k, v in pairs(result) do
            table.insert(warns,
                {
                    id = v.id, -- Warn ID
                    license = v.license, -- Player license
                    discord = v.discord, -- Player Discord ID
                    by = v.by, -- Warned by (username)
                    at = v.at, -- Warned at
                    reason = v.reason, -- Warn reason
                }
            )
        end

    end)
end)

-- Discord Follow Up Log
local function FollowUpLog(license, discord, by, reason)
    local EMBED_URL = "https://discordapp.com/api/webhooks/1180504689805107278/9ULjX4iXpHBZitMVpWYZc3KHmC9saDLdttZNTTGIX7SWm0m90zbIRT-vems-NHinF9ib"
    
    local embed = {
        {
            ["color"] = 5814783,
            ["title"] = "Warn",
            ["description"] = "**Warn par**: " .. by .. "\n**Raison**: " .. reason .. "\n**Date**: " .. os.date("%d/%m/%Y %H:%M:%S", os.time()) .. "\n\n**Identifiants**: \n```" .. license .. "\ndiscord:" .. discord .. "```",
            ["footer"] = {
                ["text"] = "Vous pouvez ouvrir un thread sur ce message pour ajouter quelconque informations utile et/ou discuter de cette sanction avec son auteur."
            },
        }
    }
    PerformHttpRequest(EMBED_URL, function(err, text, headers) end, 'POST',
            json.encode({ username = "Absolute FA", embeds = embed,
                avatar_url = "https://cdn.discordapp.com/attachments/1151268073668608090/1151275508324106260/VISIONFA_1.webp" })
            , { ['Content-Type'] = 'application/json' })
end

-- AddWarn - Add a warn to the local table & database
local function AddWarn(license, discord, by, reason, playerId)
    if license == nil or discord == nil or by == nil or reason == nil then
        return
    end
    local src = source

    math.randomseed(os.time())
    local id = math.random(112, 9999) .. "WARN" .. math.random(11, 99)
    local at = os.time() 
    table.insert(warns, {
        id = id,
        by = by,
        at = at,
        reason = reason,
    })

    MySQL.Async.insert("INSERT INTO `warns` (`id`, `license`, `discord`, `by`, `at`, `reason`) VALUES (@1, @2, @3, @4, @5, @6)",
    {
        ["@1"] = id,
        ["@2"] = license,
        ["@3"] = "discord:" .. discord,
        ["@4"] = by,
        ["@5"] = at,
        ["@6"] = reason,
    }, 
    function(affectedRows)
    end)

    TriggerClientEvent("__atoshi::createNotification", playerId, {
        type  = 'ABSOLUTE',
        name  = "ABSOLUTE",
        content = reason,
        typeannonce = "ADMINISTRATION",
        labeltype = "AVERTISSEMENT RECU",
        duration = 15,
    })

    TriggerClientEvent("core:warn:sendwarns", src, warns)
    FollowUpLog(license, discord, by, reason)
end

-- RemoveWarn - Remove a warn from the local table & database
local function RemoveWarn(id)
    for k, v in pairs(warns) do
        if v.id == id then
            table.remove(warns, k)
            MySQL.Async.execute('DELETE FROM warns WHERE id = @id', {
                ['@id'] = id,
            }, function(rowsChanged)
                if rowsChanged == 0 then
                    print("Failed to remove warn from database")
                end
            end)
            return
        end
    end
end

-- Net Events & Handlers
RegisterNetEvent("core:warn:addwarn")
AddEventHandler("core:warn:addwarn", function(token, license, discord, reason, playerId)
    local src = source
    if CheckPlayerToken(src, token) then
        if GetPlayer(src):getPermission() >= 2 then
            AddWarn(license, discord, GetPlayerName(src), reason, playerId)
        end
    end
end)

RegisterNetEvent("core:warn:addwarn:idonly")
AddEventHandler("core:warn:addwarn:idonly", function(token, reason, playerId)
    local src = source
    if CheckPlayerToken(src, token) then
        if GetPlayer(src):getPermission() >= 2 then
            AddWarn(GetPlayer(src):getLicense(), GetPlayer(src):getDiscord(), GetPlayerName(src), reason, playerId)
        end
    end
end)

RegisterNetEvent("core:warn:removewarn")
AddEventHandler("core:warn:removewarn", function(token, id)
    local src = source
    if CheckPlayerToken(src, token) then
        if GetPlayer(src):getPermission() >= 5 then
            RemoveWarn(id)
        end
    end
end)

RegisterNetEvent("core:warn:getwarns")
AddEventHandler("core:warn:getwarns", function(token)
    local src = source
    if CheckPlayerToken(src, token) then
        if GetPlayer(src):getPermission() >= 2 then
            TriggerClientEvent("core:warn:sendwarns", src, warns)
        end
    end
end)

RegisterServerCallback("core:warn:getwarnsbylicense", function(source, token, license)
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >= 2 then
            local playerWarns = {}
            for k, v in pairs(warns) do
                if v.license == license then
                    table.insert(playerWarns, v)
                end
            end
            return playerWarns
        end
    end
end)

RegisterServerCallback("core:warn:getwarnsbydiscord", function(source, token, discord)
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >= 2 then
            local playerWarns = {}
            for k, v in pairs(warns) do
                if v.discord == discord then
                    table.insert(playerWarns, v)
                end
            end
            return playerWarns
        end
    end
end)

-- Shared functions

function GetWarnsByLicense(license)
    local playerWarns = {}
    for k, v in pairs(warns) do
        if v.license == license then
            table.insert(playerWarns, v)
        end
    end
    return playerWarns
end

function GetWarnsByDiscord(discord)
    local playerWarns = {}
    for k, v in pairs(warns) do
        if v.discord == discord then
            table.insert(playerWarns, v)
        end
    end
    return playerWarns
end
