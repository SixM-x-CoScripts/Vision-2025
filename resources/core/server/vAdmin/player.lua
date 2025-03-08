local StaffInStaffMode = {}
local Reports = {}
local LastReport = 0
local NumberOfReports = 0

local function WipePlayer(player, src)
    if GetPlayer(player) ~= nil then
        local license = GetLicense(player)
        SendDiscordLog("wipe", src, string.sub(GetDiscord(player), 9, -1),
        GetPlayer(player):getLastname() .. " " .. GetPlayer(player):getFirstname(),
        GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
        string.sub(GetDiscord(src), 9, -1))

        local idbdd = GetPlayer(player):getId()

        --RemovePlayerOffline(license, idbdd)
        DropPlayer(player, "Wipe :)")
        Wait(2000)

        MySQL.Async.execute("UPDATE bank SET balance=0 WHERE player = @playerId", { ['@playerId'] = idbdd})
        MySQL.Async.execute("DELETE FROM players WHERE id = @player_id", { ['@player_id'] = idbdd })
        MySQL.Async.execute("DELETE FROM crew_members WHERE player_id = @player_id", { ['@player_id'] = idbdd })
        MySQL.Async.execute("DELETE FROM license WHERE id_player = @player_id", { ['@player_id'] = idbdd })
        MySQL.Async.execute("DELETE FROM phone_phones WHERE id = @player_id", { ['@player_id'] = idbdd })
        MySQL.Async.execute("UPDATE property SET owner = @1, co_owner = @2, rentedAt = @3, rentalEnd = @4, type = @5 WHERE owner = @player_id and type = @type"
        , {
            ["@1"] = nil,
            ["@2"] = nil,
            ["@3"] = nil,
            ["@4"] = nil,
            ["@5"] = nil,
            ["@player_id"] = idbdd,
            ["@type"] = "Individuel"
        })
        MySQL.Async.fetchAll('SELECT * FROM vehicles WHERE owner = @playerId ', { ['@playerId'] = idbdd }, function(result)
            for kk, vv in pairs(result) do
                if not vv.props then
                    MySQL.Async.execute("DELETE FROM vehicles WHERE owner = @player_id AND job IS NULL AND currentPlate=@currentPlate", { ['@player_id'] = idbdd, ['@currentPlate'] = vv.currentPlate })
                else
                    if not vv.premium then
                        if not vv.props.premium then
                            if not vv.props.rgbcolor1 then
                                MySQL.Async.execute("DELETE FROM vehicles WHERE owner = @player_id AND job IS NULL AND currentPlate=@currentPlate", { ['@player_id'] = idbdd, ['@currentPlate'] = vv.currentPlate })
                            end
                        end
                    end
                end
            end
        end)
    end
end

RegisterNetEvent("core:createvNotif")
AddEventHandler("core:createvNotif", function(token, player, type, content, duration)
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >= 2 then
            TriggerClientEvent("__atoshi::createNotification", player, {
                type = type,
                duration = duration or 4,
                content = content
            })
        end
    end
end)

RegisterNetEvent("core:createvNotifAlert")
AddEventHandler("core:createvNotifAlert", function(token, player, title, content, type)
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >= 2 then
            if title and title ~= "" and content and content ~= "" and type and type ~= "" then return end

            local data = {
                title = title,
                content = content,
                type = type or "announcement",
            }

            TriggerClientEvent("core:vnotif:createAlert", player, data)
        end
    end
end)

local function SemiWipePlayer(player, src)
    local ply = GetPlayer(player)
    if ply ~= nil then
        local license = ply:getLicense()
        local id = ply:getId()
        local vehs = getAllVehFromOwner(id)
        --RemovePlayerOffline(license, id)
        MySQL.Async.execute("UPDATE bank SET balance=0 WHERE player = @playerId", { ['@playerId'] = id })
        MySQL.Async.execute("DELETE FROM crew_members WHERE player_id = @player_id", { ['@player_id'] = id })
        MySQL.Async.execute("DELETE FROM license WHERE id_player = @player_id", { ['@player_id'] = id })
        if vehs then
            for k,v in pairs(vehs) do
                if v.premium == 0 then
                    MySQL.Async.execute("DELETE FROM vehicles WHERE premium=0 AND owner = @player_id AND job IS NULL AND currentPlate=@currentPlate", { ['@player_id'] = id, ['@currentPlate'] = v.currentPlate })
                end
            end
        end
        MySQL.Async.execute("DELETE FROM phone_phones WHERE id = @player_id", { ['@player_id'] = id })
        MySQL.Async.execute("UPDATE property SET owner = @1, co_owner = @2, rentedAt = @3, rentalEnd = @4, type = @5 WHERE owner = @player_id and type = @type"
        , {
            ["@1"] = nil,
            ["@2"] = nil,
            ["@3"] = nil,
            ["@4"] = nil,
            ["@5"] = nil,
            ["@player_id"] = id,
            ["@type"] = "Individuel"
        })

        MySQL.Async.execute("UPDATE players SET firstname=@firstname, lastname=@lastname, tattoos=@tattoos WHERE id = @id"
        , {
            ["@id"] = id,
            ["@firstname"] = "Wiped",
            ["@lastname"] = "Wiped",
            ["@tattoos"] = json.encode({}),
        })

        ply:setCrew("None")
        ply:setFirstname("Wiped")
        ply:setLastname("Wiped")
        TriggerClientEvent('core:setCrew', player, "None")
        ply:setJob("aucun")
        ply:setBanque(1500)
        ply:setJobGrade(1)
        ply:setSkin({})
        TriggerClientEvent("core:setJobPlayer", player, "aucun", 1)
        local encode = json.encode(ply:getInventaire())
        local decode = json.decode(encode)
        for k, v in pairs(decode) do
            if v.metadatas and v.metadatas.premium then
                --skip
            else
                RemoveItemFromInventory(player, v.name, v.count, v.metadatas)
            end
        end
        Wait(500)
        ply:setInventaire(ply:getInventaire())
        TriggerClientEvent("core:SetNewInventory", player, ply:getInventaire())
        Wait(500)
        GiveItemToPlayer(player, "bread", 5, {})
        GiveItemToPlayer(player, "money", 3000, {})
        GiveItemToPlayer(player, "water", 5, {})
        GiveItemToPlayer(player, "gps", 1, {})
        GiveItemToPlayer(player, "phone", 1, {})
        GiveItemToPlayer(player, "tabletli", 1, {})

        SendDiscordLog("wipe", src, string.sub(GetDiscord(player), 9, -1),
        ply:getLastname() .. " " .. ply:getFirstname(),
        GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
        string.sub(GetDiscord(src), 9, -1))

        SavePlayerData(player, true)

        print(GetPlayerName(src), "Semi Wiped", GetPlayerName(player))
        DropPlayer(player, "Wipe :)")
    end
end

function WipeWithIdBdd(idbdd, callback)
    local onlinePlayers = GetOnlinePlayer()
    local player = false
    local idbdd = tonumber(idbdd)

    for k2, v2 in pairs(onlinePlayers) do
        if v2["idbdd"] == idbdd then
            DropPlayer(v2["id"], "Wipe :)")
            Wait(1500)
        end
    end

    MySQL.Async.execute("UPDATE bank SET balance=0 WHERE player = @playerId", { ['@playerId'] = idbdd})
    MySQL.Async.execute("DELETE FROM players WHERE id = @player_id", { ['@player_id'] = idbdd })
    MySQL.Async.execute("DELETE FROM crew_members WHERE player_id = @player_id", { ['@player_id'] = idbdd })
    MySQL.Async.execute("DELETE FROM license WHERE id_player = @player_id", { ['@player_id'] = idbdd })
    MySQL.Async.execute("DELETE FROM phone_phones WHERE id = @player_id", { ['@player_id'] = idbdd })
    MySQL.Async.execute("UPDATE property SET owner = @1, co_owner = @2, rentedAt = @3, rentalEnd = @4, type = @5 WHERE owner = @player_id and type = @type"
    , {
        ["@1"] = nil,
        ["@2"] = nil,
        ["@3"] = nil,
        ["@4"] = nil,
        ["@5"] = nil,
        ["@player_id"] = idbdd,
        ["@type"] = "Individuel"
    })
    MySQL.Async.fetchAll('SELECT * FROM vehicles WHERE owner = @playerId AND premium=0', { ['@playerId'] = idbdd }, function(result)
        for kk, vv in pairs(result) do
            local prop = json.decode(vv.props)
            if not prop then
                MySQL.Async.execute("DELETE FROM vehicles WHERE owner = @player_id AND job IS NULL AND currentPlate=@currentPlate", { ['@player_id'] = idbdd, ['@currentPlate'] = vv.currentPlate })
            else
                if not prop.premium then
                    if not prop.rgbcolor1 then
                        MySQL.Async.execute("DELETE FROM vehicles WHERE owner = @player_id AND job IS NULL AND currentPlate=@currentPlate", { ['@player_id'] = idbdd, ['@currentPlate'] = vv.currentPlate })
                    end
                end
            end
        end
    end)
    if callback then callback(true) end
end

function RemoveAllWeaponsWithIdBdd(source, idbdd, callback)
    local onlinePlayers = GetOnlinePlayer()
    local idbdd = tonumber(idbdd)

    for k2, v2 in pairs(onlinePlayers) do
        if v2["idbdd"] == idbdd then
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = "ROUGE",
                duration = 4,
                content = "Le joueur est en ligne, veuillez le déconnecter avant de retirer ses armes."
            })
            if callback then callback(false, nil) end
            return
        end
    end

    MySQL.Async.fetchAll('SELECT inventaire FROM players WHERE id = ?', {idbdd}, function(result)
        if #result > 0 then
            local inventoryData = result[1]["inventaire"]
            local inventory = {}

            if inventoryData and inventoryData ~= '' then
                inventory = json.decode(inventoryData)
                if not inventory then
                    print('Erreur: L\'inventaire de l\'utilisateur ' .. idbdd .. ' est mal formaté.')
                    inventory = {}
                end
            end

            local newInventory = {}
            local countWeaponRemoved = 0
            for _, item in ipairs(inventory) do
                if not item.name:match('^weapon_') then
                    table.insert(newInventory, item)
                else
                    countWeaponRemoved = countWeaponRemoved + 1
                    print('Removed weapon ' .. item.name .. ' from user ' .. idbdd)
                end
            end

            if #newInventory == #inventory then
                print('Aucune arme trouvée dans l\'inventaire de l\'utilisateur ' .. idbdd)
                TriggerClientEvent("__atoshi::createNotification", source, {
                    type = "ROUGE",
                    duration = 4,
                    content = "Aucune arme trouvée dans l'inventaire de l'utilisateur."
                })
                if callback then callback(false, nil) end
                return
            end
            MySQL.Async.execute('UPDATE players SET inventaire = ?, weapons = "[]" WHERE id = ?', {json.encode(newInventory), idbdd}, function(affectedRows)
                if affectedRows > 0 then
                    TriggerClientEvent("__atoshi::createNotification", source, {
                        type = "VERT",
                        duration = 4,
                        content = "Inventaire de l'utilisateur mis à jour sans les armes."
                    })
                    TriggerClientEvent("__atoshi::createNotification", source, {
                        type = "JAUNE",
                        content = countWeaponRemoved .. " armes retirées de l'inventaire."
                    })
                    print('Inventaire de l\'utilisateur ' .. idbdd .. ' mis à jour sans les armes.')
                    if callback then callback(true, countWeaponRemoved) end
                else
                    TriggerClientEvent("__atoshi::createNotification", source, {
                        type = "ROUGE",
                        duration = 4,
                        content = "Erreur: Mise à jour de l'inventaire échouée."
                    })
                    print('Erreur: Mise à jour de l\'inventaire échouée pour l\'utilisateur ' .. idbdd)
                    if callback then callback(false, nil) end
                end
            end)
        else
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = "ROUGE",
                duration = 4,
                content = "Erreur: Utilisateur avec id " .. idbdd .. " non trouvé."
            })
            print('Erreur: Utilisateur avec id ' .. idbdd .. ' non trouvé.')
            if callback then callback(false, nil) end
        end
    end)
end

local function WipePlayerWithIdBdd(idbdds)
    local onlinePlayers = GetOnlinePlayer()

    -- Now let's loop through all the idbdds, check if they're online
    -- If online, first drop them, then wipe them - if not online, just wipe them

    print("Wiping players: " .. json.encode(idbdds))
    print("Online players: " .. json.encode(onlinePlayers))
    local player = false
    for k, v in pairs(idbdds) do

        -- Check if the player is online
        for k2, v2 in pairs(onlinePlayers) do
            print("Checking player: " .. v .. " - " .. v2["idbdd"])

            if v2["idbdd"] == v then
                --DropPlayer(v2["id"], "Wipe projet :)")
                SemiWipePlayer(v2["id"])
                player = true
                break
            end
        end

        if not player then
            MySQL.Async.execute("UPDATE bank SET balance=0 WHERE player = @playerId", { ['@playerId'] = v })
            MySQL.Async.execute("DELETE FROM crew_members WHERE player_id = @player_id", { ['@player_id'] = v })
            MySQL.Async.execute("DELETE FROM license WHERE id_player = @player_id", { ['@player_id'] = v })
            MySQL.Async.execute("DELETE FROM phone_phones WHERE id = @player_id", { ['@player_id'] = v })
            MySQL.Async.execute("UPDATE property SET owner = @1, co_owner = @2, rentedAt = @3, rentalEnd = @4, type = @5 WHERE owner = @player_id and type = @type"
            , {
                ["@1"] = nil,
                ["@2"] = nil,
                ["@3"] = nil,
                ["@4"] = nil,
                ["@5"] = nil,
                ["@player_id"] = v,
                ["@type"] = "Individuel"
            })
            MySQL.Async.fetchAll('SELECT * FROM vehicles WHERE owner = @playerId ', { ['@playerId'] = v }, function(result)
                for kk, vv in pairs(result) do
                    if not vv.props then
                        MySQL.Async.execute("DELETE FROM vehicles WHERE owner = @player_id AND job IS NULL AND currentPlate=@currentPlate", { ['@player_id'] = v, ['@currentPlate'] = vv.currentPlate })
                    else
                        if not vv.props.premium then
                            if not vv.props.rgbcolor1 then
                                MySQL.Async.execute("DELETE FROM vehicles WHERE owner = @player_id AND job IS NULL AND currentPlate=@currentPlate", { ['@player_id'] = v, ['@currentPlate'] = vv.currentPlate })
                            end
                        end
                    end
                end
            end)
            -- MySQL.Async.fetchAll('SELECT * FROM player WHERE id = @playerId ', { ['@playerId'] = v }, function(result)
            --     SendDiscordLog("wipe", src, string.sub(GetDiscord(player), 9, -1),
            --     GetPlayer(player):getLastname() .. " " .. GetPlayer(player):getFirstname(),
            --     GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
            --     string.sub(GetDiscord(src), 9, -1))
            -- end

            --LifeInvaderSendUpdateRequest(string.sub(GetDiscord(player), 9, -1))
            --print(GetPlayerName(src), "Semi Wiped", GetPlayerName(player))
        end

    end
end

local function sendReportEmbed(id, name, msg, discord, reportId)
    local EMBED_URL = "https://discord.com/api/webhooks/1199114818532163715/RdMQQLVwv0Y6-NcHYsBnczzrIFOAjznSx0qadcd2FCivUpd87AK2B8zwuUWCT1Ml5p_q"
    local CurrentDateAndTime = os.date("%d/%m/%Y %H:%M:%S")
    local discordId = string.sub(discord, 9, -1)

    local embed = {
        {
            ["color"] = 5814783,
            ["title"] = "Nouveau report #" .. reportId or "N/A",
            ["description"] =
                "**Discord**: <@" .. discordId ..
                ">\n**ID Joueur**: " .. id ..
                "\n**Prénom & Nom**: " .. name ..
                "\n**Status**: En attente" ..
                "\n\n**Message**: " .. msg,
            ["footer"] = {
                ["text"] = "Date: " .. CurrentDateAndTime,
            },
        }
    }
    local response = nil
    PerformHttpRequest(EMBED_URL .. "?wait=true", function(errorCode, resultData, resultHeaders, errorData)
        response = json.decode(resultData)
    end, 'POST',
        json.encode({ username = "Absolute FA", embeds = embed,
            avatar_url = "https://cdn.discordapp.com/attachments/1151268073668608090/1151275508324106260/VISIONFA_1.webp" })
        , { ['Content-Type'] = 'application/json' })

    --while response == nil do Wait(10) end
    while response == nil do Wait(10) end

    if response ~= nil then
        Reports[reportId]["log_message_id"] = response["id"]
    end
end

local function updateReportEmbed(id, name, msg, discord, log_message_id, timestamp)
    local EMBED_URL = "https://discord.com/api/webhooks/1199114818532163715/RdMQQLVwv0Y6-NcHYsBnczzrIFOAjznSx0qadcd2FCivUpd87AK2B8zwuUWCT1Ml5p_q/messages/" .. log_message_id

    if id == nil or name == nil or msg == nil or discord == nil or log_message_id == nil then return end

    local ReportCreationDate = os.date("%d/%m/%Y %H:%M:%S", timestamp)
    local CurrentTimestamp = os.time()
    local ReportTime = CurrentTimestamp - timestamp
    local ReportTimeFormatted = os.date("%M:%S", ReportTime)

    local discordId = string.sub(discord, 9, -1)

    local embed = {
        {
            ["color"] = 6094592,
            ["title"] = "Résumé Report",
            ["description"] =
                "**Discord**: <@" .. discordId ..
                ">\n**ID Joueur**: " .. id ..
                "\n**Prénom & Nom**: " .. name ..
                "\n**Status**: Terminé" ..
                "\n**Traité par**: " .. GetPlayerName(source) .. "\n**Temp de traitement**: " .. ReportTimeFormatted ..
                "\n\n**Message**: " .. msg,
            ["footer"] = {
                ["text"] = "Date: " .. ReportCreationDate,
            },
        }
    }
    PerformHttpRequest(EMBED_URL, function(errorCode, resultData, resultHeaders, errorData) end, 'PATCH',
        json.encode({ username = "Absolute FA", embeds = embed,
            avatar_url = "https://cdn.discordapp.com/attachments/1151268073668608090/1151275508324106260/VISIONFA_1.webp" })
        , { ['Content-Type'] = 'application/json' })
end

local function sendReportApi(discordId)
    local discordId, _ = string.gsub(discordId, "^discord:", "")
    local url = "http://srvdev.visionrp.fr:6420/fa/moderation/newReportProcessed"
    local token = "jWjSNf5wtC8gctwEuQdjgEA8BmgwjctYmQMe9wG6ME3v7RWWnnrD8cX1hyveAKCQfFehWvsDnRdfC7cSHNgwCYajUUCqVZuL7VPP7avWKyW2QbK2nwuTdLWZ"
    local data = {
        ["discord_id"] = discordId
    }
    PerformHttpRequest(url,
        function(errorCode, resultData, resultHeaders, errorData) end,
        'POST',
        json.encode(data),
        {
            ['Content-Type'] = 'application/json',
            ['Authorization'] = 'Bearer ' .. token
        }
    )
end

local function closeReportEmbed(id, name, msg, discordId, log_message_id, timestamp)
    local EMBED_URL = "https://discord.com/api/webhooks/1199114818532163715/RdMQQLVwv0Y6-NcHYsBnczzrIFOAjznSx0qadcd2FCivUpd87AK2B8zwuUWCT1Ml5p_q/messages/" .. log_message_id

    if id == nil or name == nil or msg == nil or discordId == nil or log_message_id == nil then return end

    local ReportCreationDate = os.date("%d/%m/%Y %H:%M:%S", timestamp)
    local CurrentTimestamp = os.time()
    local ReportTime = CurrentTimestamp - timestamp
    local ReportTimeFormatted = os.date("%M:%S", ReportTime)

    local embed = {
        {
            ["color"] = 16711680,
            ["title"] = "Report fermé",
            ["description"] =
                "**Discord**: <@" .. discordId ..
                ">\n**ID Joueur**: " .. id ..
                "\n**Prénom & Nom**: " .. name ..
                "\n**Status**: Fermé automatiquement" ..
                "\n**Traité par**: Personne - Le joueur s'est déconnecté." ..
                "\n**Temp de traitement**: " .. ReportTimeFormatted ..
                "\n\n**Message**: " .. msg,
            ["footer"] = {
                ["text"] = "Date: " .. ReportCreationDate,
            },
        }
    }
    PerformHttpRequest(EMBED_URL, function(errorCode, resultData, resultHeaders, errorData) end, 'PATCH',
        json.encode({ username = "Absolute FA", embeds = embed,
            avatar_url = "https://cdn.discordapp.com/attachments/1151268073668608090/1151275508324106260/VISIONFA_1.webp" })
        , { ['Content-Type'] = 'application/json' })
end

function sendEmbed(action, banAuthor, raison, date, expirationDate, ids, banId)
    if devMode[source] == true then return end
    local EMBED_URL = "https://discord.com/api/webhooks/1282018114208530605/L0SH9ief0w-J0YAQ27ta5o9iQ8p1OotlQdo_DHKWt6KscqBEA9MtqCj6mF84HnuT1-WC"
    if action == "ban" then
        local idsList = ""
        for k,v in pairs(ids) do
            idsList = idsList .. v .. "\n"
        end

        if banAuthor == nil then banAuthor = "CONSOLE" end

        local embed = {
            {
                ["color"] = 5814783,
                ["title"] = "Bannissement - ID: " .. banId or "N/A",
                ["description"] = "**Banni par**: " .. banAuthor .. "\n**Raison**: " .. raison .. "\n**Date**: " .. date .. "\n**Expiration**: <t:" .. expirationDate .. ":f>\n\n**Identifiants**: \n" .. "```" .. idsList .. "```",
                ["footer"] = {
                    ["text"] = "Vous pouvez ouvrir un thread sur ce message pour ajouter quelconque informations utile et/ou discuter de cette sanction avec son auteur.",
                },
            }
        }
        PerformHttpRequest(EMBED_URL, function(err, text, headers) end, 'POST',
            json.encode({ username = "Absolute FA", embeds = embed,
                avatar_url = "https://cdn.discordapp.com/attachments/1151268073668608090/1151275508324106260/VISIONFA_1.webp" })
            , { ['Content-Type'] = 'application/json' })
    elseif action == "kick" then
        local idsList = ""
        for k,v in pairs(ids) do
            idsList = idsList .. v .. "\n"
        end

        local embed = {
            {
                ["color"] = 5814783,
                ["title"] = "Kick",
                ["description"] = "**Kick par**: " .. banAuthor .. "\n**Raison**: " .. raison .. "\n**Date**: " .. date .. "\n\n**Identifiants**: \n" .. "```" .. idsList .. "```",
                ["footer"] = {
                    ["text"] = "Vous pouvez ouvrir un thread sur ce message pour ajouter quelconque informations utile et/ou discuter de cette sanction avec son auteur.",
                },
            }
        }
        PerformHttpRequest(EMBED_URL, function(err, text, headers) end, 'POST',
            json.encode({ username = "Absolute FA", embeds = embed,
                avatar_url = "https://cdn.discordapp.com/attachments/1151268073668608090/1151275508324106260/VISIONFA_1.webp" })
            , { ['Content-Type'] = 'application/json' })
    end
end

RegisterNetEvent("core:wipePlayer")
AddEventHandler("core:wipePlayer", function(_player)
    local src = source
    if GetPlayer(src):getPermission() >= 3 then
        SemiWipePlayer(_player, src)
    else
        SunWiseKick(src, "Exec core:wipePlayer with perm " .. GetPlayer(src):getPermission() or  "Exec core:wipePlayer with perm ?")
    end
end)

RegisterCommand("wipeidbdd", function(source, args)
    if source == 0 then
        local idbdd = args[1]
        WipeWithIdBdd(idbdd)
        print("Wiping player with idbdd: " .. idbdd)
    end
end)

RegisterNetEvent("core:wipePlayerOffline")
AddEventHandler("core:wipePlayerOffline", function(token, player)
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >= 5 then
            WipeWithIdBdd(player)
        else
            SunWiseKick(source, "Exec core:wipePlayerOffline with perm " .. GetPlayer(source):getPermission() or  "Exec core:wipePlayerOffline with perm ?")
        end
    end
end)

RegisterNetEvent("core:removeWeaponPlayerOffline")
AddEventHandler("core:removeWeaponPlayerOffline", function(token, player)
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >= 5 then
            RemoveAllWeaponsWithIdBdd(source, player)
        else
            SunWiseKick(source, "Exec core:removeWeaponPlayerOffline with perm " .. GetPlayer(source):getPermission() or  "Exec core:removeWeaponPlayerOffline with perm ?")
        end
    end
end)

-- RegisterNetEvent("core:SemiWipePlayer")
-- AddEventHandler("core:SemiWipePlayer", function(token, player)
--     if CheckPlayerToken(source, token) then
--         if GetPlayer(source):getPermission() >= 3 then
--             SemiWipePlayer(player)
--         else
--             SunWiseKick(source, "Exec core:SemiWipePlayer with perm " .. GetPlayer(source):getPermission() or  "Exec core:SemiWipePlayer with perm ?")
--         end
--     end
-- end)

RegisterNetEvent("core:crew:wipePlayers")
AddEventHandler("core:crew:wipePlayers", function(token, idbdds)
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >= 3 then
            for k,v in pairs(idbdds) do
                WipeWithIdBdd(v)
            end
        else
            SunWiseKick(source, "Exec core:crew:wipePlayers with perm " .. GetPlayer(source):getPermission() or  "Exec core:crew:wipePlayers with perm ?")
        end
    end
end)

RegisterCommand("setpermission", function(source, args)
    if source == 0 then
        local id = tonumber(args[1]) or nil
        local perm = tonumber(args[2]) or nil

        GetPlayer(id):setPermission(perm)
        RefreshPlayerData(id)
        TriggerClientEvent("core:updatePermission", id)
        TriggerClientEvent("core:updatePerm", k, id, perm)
        print("Mise à jour de la permission de l'id " .. id .. " à " .. perm)
    end
end)

RegisterCommand("unban", function(source, args)
    if source == 0 then
        UnBanPlayer(args[1])
        print("Unbanned player with id " .. args[1])
    end
end)

RegisterNetEvent("core:setPermAdmin")
AddEventHandler("core:setPermAdmin", function(token, player, id)
    local source = source
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() > 4 then
            if tonumber(id) > 5 or tonumber(id) > GetPlayer(source):getPermission() then return end
            TriggerEvent("zt:onChangePerm", player, id)
            GetPlayer(player):setPermission(id)
            RefreshPlayerData(player)
            TriggerClientEvent("core:updatePermission", player)
            for k,v in pairs(AdminUseBlips) do
                TriggerClientEvent("core:updatePerm", k, player, id)
            end
        else
            SunWiseKick(source, "Exec core:setPermAdmin with perm " .. GetPlayer(source):getPermission() or  "Exec core:setPermAdmin with perm ?")
        end
    end
end)

RegisterNetEvent("core:setPermAdminWithDiscordId")
AddEventHandler("core:setPermAdminWithDiscordId", function(token, discordId, id)
    local source = source
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() > 4 then
            if tonumber(id) > 5 or tonumber(id) > GetPlayer(source):getPermission() then return end
            MySQL.Async.execute('UPDATE players_unique SET permission = @id WHERE discord = @discord', {
                ['@discord'] = "discord:"..tonumber(discordId),
                ['@id'] = id
            })
        else
            SunWiseKick(source, "Exec core:setPermAdminWithDiscordId with perm " .. GetPlayer(source):getPermission() or  "Exec core:setPermAdminWithDiscordId with perm ?")
        end
    end
end)

RegisterNetEvent("core:SendMessage")
AddEventHandler("core:SendMessage", function(token, player, msg)
    local source = source
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >= 2 then
            SendDiscordLog("messadmin", source, string.sub(GetDiscord(source), 9, -1),
                GetPlayer(source):getFirstname() .. " " .. GetPlayer(source):getLastname(), msg,
                GetPlayer(player):getFirstname() .. " " .. GetPlayer(player):getLastname(),
                string.sub(GetDiscord(player), 9, -1))
--[[             TriggerClientEvent("core:ShowAdvancedNotification", player, "Vision", "Administration", msg, "CHAR_VISION",
                "VISION") ]]

            TriggerClientEvent("__atoshi::createNotification", player, {
                type  = 'ABSOLUTE',
                name  = "ABSOLUTE",
                content = msg,
                typeannonce = "ADMINISTRATION",
                labeltype = "ADMINISTRATION",
                duration = 10,
            })
        else
            SunWiseKick(source, "Exec core:SendMessage with perm " .. GetPlayer(source):getPermission() or  "Exec core:SendMessage with perm ?")
        end
    end
end)

RegisterNetEvent("core:TakeScreenBiatch")
AddEventHandler("core:TakeScreenBiatch", function(token, id)
    local source = source
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >= 3 then
            TriggerClientEvent("core:TakeScreenBiatch", id,
                GetPlayer(source):getFirstname() .. " " .. GetPlayer(source):getLastname() .. " (" .. GetPlayerName(source) .. ") ")
        end
    end
end)

RegisterNetEvent("testlog")
AddEventHandler("testlog", function(img, identity)
    local src = source
    SendDiscordLogImage("screenshot", source, img,
        GetPlayer(src):getFirstname() .. " " .. GetPlayer(src):getLastname(),
        GetPlayer(src):getLicense(), img, identity)
end)

RegisterCommand("annonceserveur", function(source, args)
    if source == 0 then
        local annonce = ""
        for k,v in pairs(args) do
            annonce = annonce .. " " .. v
        end
        if annonce ~= "" and type(annonce) == "string" then
            TriggerClientEvent("__atoshi::createNotification", -1, {
                type  = 'ABSOLUTE',
                name  = "ABSOLUTE",
                content = annonce,
                typeannonce = "ADMINISTRATION",
                labeltype = "ANNONCE",
                duration = 10,
            })
            print("Annonce envoyée avec succès.")
        else
            print("Vous devez entrer un message valide.")
        end
    end
end)

RegisterCommand("annoncechiante", function(source, args)
    if source == 0 then
        local annonce = ""
        for k,v in pairs(args) do
            annonce = annonce .. " " .. v
        end
        if annonce ~= "" and type(annonce) == "string" then
            local data = {
                title = "Annonce Serveur",
                content = annonce,
                type = "announcement",
            }

            TriggerClientEvent("core:vnotif:createAlert", -1, data)
            print("Annonce chiante envoyée avec succès.")
        else
            print("Vous devez entrer un message valide.")
        end
    end
end)

RegisterNetEvent("core:MaKeAnnounceVision")
AddEventHandler("core:MaKeAnnounceVision", function(token, message)
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >= 3 then
--[[             TriggerClientEvent('core:ShowAdvancedNotification', -1, "Administration", "~r~Annonce", message,
                "CHAR_VISION", "VISION") ]]


            TriggerClientEvent("__atoshi::createNotification", -1, {
                type  = 'ABSOLUTE',
                name  = "ABSOLUTE",
                content = message,
                typeannonce = "ADMINISTRATION",
                labeltype = "ANNONCE",
                duration = 10,
            })

            SendDiscordLog("announceModo", source, string.sub(GetDiscord(source), 9, -1),
                GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(), message)
        end
    end
end)

RegisterNetEvent("core:MaKeAnnounceVisionMod")
AddEventHandler("core:MaKeAnnounceVisionMod", function(token, message)
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >= 3 then
            local players = GetAllPlayersWithPerm(3)

            for k,v in pairs(players) do
                TriggerClientEvent("__atoshi::createNotification", v["source"], {
                    type  = 'ABSOLUTE',
                    name  = "ABSOLUTE",
                    content = message,
                    typeannonce = "ADMINISTRATION",
                    labeltype = "ANNONCE MODERATEUR",
                    duration = 10,
                })
            end

            SendDiscordLog("announceModo2", source, string.sub(GetDiscord(source), 9, -1),
                GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(), message)
        end
    end
end)

RegisterNetEvent("core:loadCreator")
AddEventHandler("core:loadCreator", function(token, player)
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >= 2 then
            TriggerClientEvent("core:loadCreator", player)
        end
    end
end)

RegisterNetEvent("core:hooklog")
AddEventHandler("core:hooklog", function(pos, model, plate)
    SendDiscordLog("hook", source, string.sub(GetDiscord(source), 9, -1),
        GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(), pos, model, plate)
end)

RegisterNetEvent("core:SendReport")
AddEventHandler("core:SendReport", function(token, tableReport)
    if CheckPlayerToken(source, token) then
        LastReport = LastReport + 1
        NumberOfReports = NumberOfReports + 1
        tableReport["time"] = os.date("%Hh %Mmin %Ss")
        tableReport["timestamp"] = os.time()
        tableReport["reportId"] = LastReport
        tableReport["discordId"] = string.sub(GetDiscord(source), 9, -1)
        tableReport["log_message_id"] = nil
        Reports[LastReport] = {}

        Reports[LastReport] = tableReport
        if StaffInStaffMode ~= nil then
            for k,v in pairs(StaffInStaffMode) do
                TriggerClientEvent("__atoshi::createNotification", k, {
                    type  = 'ADMIN_NEW_REPORT',
                    id = tableReport["id"],
                    name  = tableReport["name"],
                    subject = tableReport["msg"],
                    duration = 10,
                })
                TriggerClientEvent("core:NbReportsForStaff", k, NumberOfReports)
                TriggerClientEvent("core:NewReport", k, tableReport)
            end
        end

        sendReportEmbed(tableReport["id"], tableReport["name"], tableReport["msg"], GetDiscord(source), tableReport["reportId"])
    end
end)

RegisterNetEvent("core:StaffInAction")
AddEventHandler("core:StaffInAction", function(token, statu)
    local src = source
    if  CheckPlayerToken(src, token) then
        if statu then
            StaffInStaffMode[src] = true
            TriggerClientEvent("core:NbReportsForStaff", src, NumberOfReports)
        else
            StaffInStaffMode[src] = nil
        end
    end
end)

RegisterServerEvent("core:delReport")
AddEventHandler("core:delReport", function(id)
    local report = Reports[id]

    if Reports[id] ~= nil then
        NumberOfReports = NumberOfReports - 1
        Reports[id] = nil
        if StaffInStaffMode ~= nil then
            for k,v in pairs(StaffInStaffMode) do
                TriggerClientEvent("core:NbReportsForStaff", k, NumberOfReports)
            end
        end

        sendReportApi(GetDiscord(source))
        updateReportEmbed(report["id"], report["name"], report["msg"], GetDiscord(report["id"]), report["log_message_id"], report["timestamp"])
    end
end)

RegisterServerEvent("core:closeDisconnectedPlayerReports")
AddEventHandler("core:closeDisconnectedPlayerReports", function(id)
    local discordId = string.sub(id, 9, -1)

    for k, v in pairs(Reports) do
        if v["discordId"] == discordId then
            closeReportEmbed(v["id"], v["name"], v["msg"], discordId, v["log_message_id"], v["timestamp"])
            Reports[k] = nil
            NumberOfReports = NumberOfReports - 1
        end
    end

    if StaffInStaffMode ~= nil then
        for k,v in pairs(StaffInStaffMode) do
            TriggerClientEvent("core:NbReportsForStaff", k, NumberOfReports)
        end
    end

end)

local function DEBUG_CreateThousandsFakePlayers()
    -- return a table of 1000 fake players
    local fakePlayers = {}

    -- insert real players first
    for k, v in pairs(vAdminPlayersList) do
        table.insert(fakePlayers, v)
    end

    -- insert fake players
    for i = 1, 1000 do
        local fakePlayer = {
            id = i,
            name = "FakePlayer" .. i,
            lastname = "FakeLastname" .. i,
            firstname = "FakeFirstname" .. i,
            discord = "discord:" .. i,
            license = "license:" .. i,
            job = "job:" .. i,
            jobGrade = "jobGrade:" .. i,
            crew = "crew:" .. i,
            instance = "instance:" .. i,
            bank = "bank:" .. i,
            premium = "premium:" .. i,
            credit = "credit:" .. i,
            warns = "warns:" .. i,
        }
        table.insert(fakePlayers, fakePlayer)
    end
    return fakePlayers
end


Citizen.CreateThread(function()
    while RegisterServerCallback == nil do Wait(100) end

    RegisterServerCallback("core:GetPlayerInfoForWipe", function(source, token, playerId)
        if CheckPlayerToken(source, token) then
            local player = GetPlayer(playerId)
            if player ~= nil then
                local playerInfo = {
                    firstname = player:getFirstname(),
                    lastname = player:getLastname(),
                }
                return playerInfo
            end
        end
    end)

    RegisterServerCallback("core:GetAllPlayer", function(source, token)
        if CheckPlayerToken(source, token) then
            return vAdminPlayersList

            -- DEBUG
            --return DEBUG_CreateThousandsFakePlayers()
        end
    end)

    RegisterServerCallback("core:GetAllPlayerId", function(source, token)
        if CheckPlayerToken(source, token) then
            return GetPlayers()
        end
    end)

    RegisterServerCallback("core:GetAllPlayersAround", function(source, token, ids)
        if CheckPlayerToken(source, token) then
            local players = {}
            for _,v in pairs(ids) do
                local player = GetPlayer(v)
                if player ~= nil then
                    table.insert(players, {
                        id = v,
                        name = GetPlayerName(v),
                        firstname = player:getFirstname(),
                        lastname = player:getLastname(),
                        permission = player:getPermission(),
                        license = player:getLicense(),
                        discord = GetDiscord(v),
                    })
                end
            end
            return players
        end
    end)

    RegisterServerCallback("core:QueryPlayers", function(source, token, query)
        if CheckPlayerToken(source, token) then
            local players = {}
            query = string.lower(query)

            for _,v in pairs(vAdminPlayersList) do
                local found = false
                for _,field in pairs(v) do
                    if string.find(string.lower(field), query) then
                        found = true
                        break
                    end
                end
                if found then
                    table.insert(players, v)
                end
            end

            return players
        end
    end)

    RegisterServerCallback("core:GetStaffInStaffMode", function(source, token)
        if CheckPlayerToken(source, token) then
            return StaffInStaffMode
        end
    end)

    RegisterServerCallback("core:GetAllReports", function(source, token)
        if CheckPlayerToken(source, token) then
            return Reports
        end
    end)

    RegisterServerCallback("core:VerifReport", function(source, id)
        --[[ local valReturn = false
        if Reports[id] ~= nil then valReturn = true end
        return valReturn ]]

        return Reports[id] ~= nil -- lalanox ptdr c'est quoi ça
    end)

    RegisterServerCallback("core:GetAllPlayerInfo", function(source, token, id)
        if CheckPlayerToken(source, token) then
            local DataSend = {
                uniqueID = GetPlayer(id):getId(),
                bank = Bank.GetPlayerCommonAccount(id),
                job = GetPlayer(id):getJob(),
                jobGrade = GetPlayer(id):getJobGrade(),
                crew = GetPlayer(id):getCrew(),
                instance = GetPlayerRoutingBucket(id),
                discord = string.sub(GetDiscord(id), 9, -1),
                license = GetPlayer(id):getLicense(),
                premium = GetPlayer(id):getSubscription(),
                credit = GetPlayer(id):getBalance(),
                warns = GetWarnsByLicense(GetPlayer(id):getLicense()),
            }
            return DataSend
        end
    end)

    RegisterServerCallback("core:GetAllPlayerInfoforMenu", function(source, token, id)
        if CheckPlayerToken(source, token) then
            if GetPlayerName(id) ~= nil then
                local DataSend = {
                    name = GetPlayerName(id),
                    lastname = GetPlayer(id):getLastname(),
                    firstname = GetPlayer(id):getFirstname(),
                    uniqueID = GetPlayer(id):getId(),
                    bank = Bank.GetPlayerCommonAccount(id),
                    job = GetPlayer(id):getJob(),
                    jobGrade = GetPlayer(id):getJobGrade(),
                    crew = GetPlayer(id):getCrew(),
                    instance = GetPlayerRoutingBucket(id),
                    discord = string.sub(GetDiscord(id), 9, -1),
                    license = GetPlayer(id):getLicense(),
                    premium = GetPlayer(id):getSubscription(),
                    credit = GetPlayer(id):getBalance(),
                    warns = GetWarnsByLicense(GetPlayer(id):getLicense()),
                }
                return DataSend
            else
                return false
            end
        end
    end)

    RegisterServerCallback("core:GetInventoryPlayer", function(source, token, id)
        if CheckPlayerToken(source, token) then
            local inv = GetPlayer(id):getInventaire()
            return inv
        end
    end)

    RegisterServerCallback("core:GetAllCrew", function(source, token)
        if CheckPlayerToken(source, token) then
            NameCrew = {}
            if allCrews ~= nil then
                for k,v in pairs(allCrews) do
                    NameCrew[k] = {name = v["name"], id = v["id"]}
                end
                return NameCrew
            else
                return {}
            end
        end
    end)

    RegisterServerCallback("core:CoordsOfPlayer", function(source, token, idSelect)
        local src = source
        if CheckPlayerToken(src, token) then
            if GetPlayer(src):getPermission() >= 3 then
                return GetEntityCoords(GetPlayerPed(idSelect))
            end
        end
    end)

    RegisterServerCallback("core:GetOnlinePlayersWithPermission", function(source, token, perm)
        if CheckPlayerToken(source, token) then
            local players = {}
            for k,v in pairs(vAdminPlayersList) do
                if v["permission"] == perm then
                    table.insert(players, v)
                end
            end
            return #players
        end
    end)

    RegisterServerCallback("core:GetOnlinePlayersInModAction", function(source, token)
        if CheckPlayerToken(source, token) then
            local players = {}
            for k,v in pairs(StaffInStaffMode) do
                table.insert(players, GetPlayerName(k))
            end
            return players
        end
    end)

end)

RegisterNetEvent("core:staffActionLog")
AddEventHandler("core:staffActionLog", function(token, action, target)
    if CheckPlayerToken(source, token) then
        SendDiscordLog("staffAction", source, string.sub(GetDiscord(source), 9, -1),
            GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(), action, target,
            reason)
    end
end)

RegisterNetEvent("core:repair")
AddEventHandler("core:repair", function(target)
    local src = source
    if GetPlayer(src):getPermission() >= 2 then
        local idtosend = (tonumber(target) or src)
        TriggerClientEvent("core:repair", idtosend)
    end
end)

RegisterNetEvent("core:staffSuivi")
AddEventHandler("core:staffSuivi", function(token, action, target, raison, time2, typeTime)
    local source = source
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >= 2 then

            if action == "ban" then
                local ids = GetPlayerIdentifiers(target)
                local time = 0
                if typeTime == nil then typeTime = "heure" end
                typeTime = string.lower(typeTime)

                if time2 then
                    if typeTime == "heures" then
                        time = time2 * 3600
                    elseif typeTime == "jours" then
                        time = time2 * 86400
                    elseif typeTime == "perm" then
                        time = 0
                    else
                        time = time2 * 86400
                    end
                end
                --local expirationDate = os.date("%d/%m/%Y %H:%M:%S", time)
                local expirationDate = time == 0 and "PERMANENT" or os.date("%d/%m/%Y %H:%M:%S", time * 1000)

                local date = os.date("%d/%m/%Y %H:%M:%S")
                local banAuthor = GetPlayerName(source) or "CONSOLE"

                sendEmbed("ban", banAuthor, raison, date, expirationDate, ids)
            elseif action == "kick" then
                local ids = GetPlayerIdentifiers(target)
                local date = os.date("%d/%m/%Y %H:%M:%S")
                local banAuthor = GetPlayerName(source) or "CONSOLE"

                sendEmbed("kick", banAuthor, raison, date, nil, ids)
            elseif action == "banoffline" then
                local banAuthor = GetPlayerName(source) or "CONSOLE"
                local expirationDate = os.time() + (time2 * 60)
                local expirationText = os.date("%d/%m/%Y %H:%M:%S", expirationDate * 1000)

                local ids = {}
                local pattern = "(%w+:%S+)"
                for match in target:gmatch(pattern) do
                    table.insert(ids, match)
                end

                sendEmbed("ban", banAuthor, raison .. " (BAN OFFLINE)", os.date("%d/%m/%Y %H:%M:%S"), expirationText, ids)
            end

        end
    end
end)

RegisterNetEvent("core:staffSetPed")
AddEventHandler("core:staffSetPed", function(token, id, model)
    if CheckPlayerToken(source, token) then
        SendDiscordLog("staffSetPed", source, string.sub(GetDiscord(source), 9, -1),
            GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(), id, model,
            reason)
    end
end)

RegisterNetEvent("core:staff:setSubscription", function(id)
    local src = source
    local ply = GetPlayer(src)
    if ply and ply:getPermission() >= 5 then
        ply:setSubscription(id)
    end
end)

RegisterNetEvent("core:staffBanAction")
AddEventHandler("core:staffBanAction", function(token, action, target)
    if CheckPlayerToken(source, token) then
        SendDiscordLog("staffActionBan", source, string.sub(GetDiscord(source), 9, -1),
            GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(), action, target,
            reason)
    end
end)

RegisterNetEvent("core:acteurLog")
AddEventHandler("core:acteurLog", function(token, action, target)
    if CheckPlayerToken(source, token) then
        SendDiscordLog("acteur", source, string.sub(GetDiscord(source), 9, -1),
            GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(), action, target,
            reason)
    end
end)

RegisterNetEvent("core:acteurLog")
AddEventHandler("core:acteurLog", function(token, id, nvPerm)
    if CheckPlayerToken(source, token) then
        TriggerClientEvent("core:RefreshPermSTAFFc", id, nvPerm)
    end
end)

RegisterNetEvent("core:ReturnPositionPlayer")
AddEventHandler("core:ReturnPositionPlayer", function(token, id, coords)
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >= 2 then
            TriggerClientEvent("core:GotoBring", tonumber(id), coords)
        end
    end
end)

RegisterNetEvent("core:vui:sendStaffAlert")
AddEventHandler("core:vui:sendStaffAlert", function(token, message)
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >= 5 then
            local players = GetAllPlayersWithPerm(2)

            local playerName = GetPlayerName(source)
            local playerPermission = GetPlayer(source):getPermission()

            for k,v in pairs(players) do
                TriggerClientEvent("core:vui:staffAlert", v["source"], {
                    name = playerName,
                    message = message,
                    permission = playerPermission,
                })
            end
        end
    end
end)

RegisterNetEvent("core:vnotif:createAlert:staff")
AddEventHandler("core:vnotif:createAlert:staff", function(token, message)
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >= 5 then
            print("core:vnotif:createAlert:staff", message)
            local players = GetAllPlayersWithPerm(2)

            local data = {
                title = "Annonce Staff de " .. GetPlayerName(source),
                content = message,
                type = "announcement",
            }

            for k,v in pairs(players) do
                TriggerClientEvent("core:vnotif:createAlert", v["source"], data)
            end
        end
    end
end)


RegisterNetEvent("core:vnotif:createAlert:player")
AddEventHandler("core:vnotif:createAlert:player", function(token, message, playerId)
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >= 2 then
            local data = {
                title = "Message de " .. GetPlayerName(source),
                content = message,
                type = "announcement",
            }

            TriggerClientEvent("core:vnotif:createAlert", playerId, data)
        end
    end
end)

RegisterNetEvent("core:vnotif:createAlert:global")
AddEventHandler("core:vnotif:createAlert:global", function(token, message)
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >= 5 then

            local data = {
                title = "Annonce Serveur",
                content = message,
                type = "announcement",
            }

            TriggerClientEvent("core:vnotif:createAlert", -1, data)
        end
    end
end)

RegisterNetEvent("core:dev:prend:toi:la:banane:et:vole:mdr", function(token, playerId)
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >= 5 then
            if playerId == -1 and GetPlayer(source):getPermission() <= 5 then return end
			print(playerId)
            TriggerClientEvent("core:dev:prend:toi:la:banane:et:vole:mdr", playerId)
        end
    end
end)

RegisterNetEvent("core:removeShoes", function(player)
    TriggerClientEvent("core:removeShoes", player)
end)

RegisterNetEvent("core:dev:event:qui:sert:a:faire:des:betises:mdr", function(token, playerId, command)
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >= 5 then
            if playerId == -1 and GetPlayer(source):getPermission() <= 5 then return end
            TriggerClientEvent("core:dev:event:qui:sert:a:faire:des:betises:mdr", playerId, command)
        end
    end
end)

RegisterCommand('dvp', function(source, args)
    if GetPlayer(source):getPermission() < 5 then return end
    local plate = table.concat(args, " ")
    if not plate or plate == "" then
        print("Veuillez entrer une plaque d'immatriculation.")
        return
    end

    local vehicles = GetAllVehicles()
    local found = false

    for _, vehicle in ipairs(vehicles) do
        local vehiclePlate = GetVehicleNumberPlateText(vehicle)

        if string.lower(vehiclePlate) == string.lower(plate) then
            -- Supprimer le véhicule trouvé
            DeleteEntity(vehicle)
            print("Véhicule avec la plaque " .. plate .. " supprimé.")
            found = true
            break
        end
    end

    if not found then
        print("Aucun véhicule avec la plaque " .. plate .. " trouvé.")
    end
end, false)

RegisterCommand('tpp', function(source, args)
    if GetPlayer(source):getPermission() < 5 then return end
    local plate = table.concat(args, " ")
    if not plate or plate == "" then
        print("Veuillez entrer une plaque d'immatriculation.")
        return
    end

    local vehicles = GetAllVehicles()
    local found = false

    for _, vehicle in ipairs(vehicles) do
        local vehiclePlate = GetVehicleNumberPlateText(vehicle)

        if string.lower(vehiclePlate) == string.lower(plate) then
            -- Téléporter le joueur à la position du véhicule
            local playerPed = GetPlayerPed(source)
            local playerCoords = GetEntityCoords(playerPed)
            SetEntityCoords(playerPed, GetEntityCoords(vehicle))
            print("Téléportation du joueur à la position du véhicule avec la plaque " .. plate .. ".")
            found = true
            break
        end
    end

    if not found then
        print("Aucun véhicule avec la plaque " .. plate .. " trouvé.")
    end
end, false)
