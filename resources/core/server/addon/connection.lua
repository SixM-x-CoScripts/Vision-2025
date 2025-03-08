-- External calls

AddEventHandler("server:queue:CheckIfPlayerIsBanned", function(source, cb)
    local bool, table, day, hour, min = IsPlayerBanned(source)
    cb(bool, table, day, hour, min)
end)

function PlayerInServer(source)
    local myLicense = GetLicense(source)
    if not next(GetPlayers()) then
        return false
    end
    for k,v in pairs(GetPlayers()) do
        if GetLicense(v) == myLicense then
            return true
        end
    end
    return false
end

local MainDeferral = {
    ["type"] = "AdaptiveCard",
    ["minHeight"] = "100px",
    ["body"] = {
        {
            ["type"] = "Container",
            ["items"] = {
                {
                    ["isVisible"] = true,
                    ["type"] = "TextBlock",
                    ["text"] = "Absolute - FA",
                    ["wrap"] = true,
                    ["fontType"] = "Default",
                    ["size"] = "extraLarge",
                    ["weight"] = "Bolder",
                    ["isSubtle"] = false,
                    ["horizontalAlignment"] = "Center"
                },
                {
                    ["type"] = "Image",
                    ["url"] = "https://cdn.sacul.cloud/v2/vision-cdn/Vision/BanniereFASimple.png",
                },
                {
                    ["isVisible"] = true,
                    ["type"] = "TextBlock",
                    ["text"] = "Vérification en cours...",
                    ["wrap"] = true,
                    ["horizontalAlignment"] = "Center"
                },
            }
        }
    },
    ["actions"] = {
        {
            ["isVisible"] = true,
            ["type"] = "Action.OpenUrl",
            ["title"] = "Discord",
            ["url"] = "https://discord.gg/absoluterp",
        },
        {
            ["isVisible"] = true,
            ["type"] = "Action.OpenUrl",
            ["title"] = "Boutique",
            ["url"] = "https://niquetamere.tebex.io", -- LIEN TEBEX A METTRE
        }
    },
    ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
    ["version"] = "1.2"
}

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local src = source
    local deferalText = nil
    deferrals.defer()
    Wait(0)
    deferrals.presentCard(MainDeferral)
    Wait(0)

    local discord = GetDiscord(src)
    if not discord then
        deferrals.done("Vous devez être connecté à Discord pour rejoindre le serveur.")
        --return
    end

    local isBanned, banInfo, banDay, banHour, banMin = IsPlayerBanned(src)
    local playerNotAllowedToJoin = false

    if isBanned then
        local banDetails = banInfo or {raison = "Aucune raison", id = "Aucun ID"}
        local remainingDay = banDay or "0"
        local remainingHour = banHour or "0"
        local remainingMin = banMin or "0"

        MainDeferral.body[1].items[2]["url"] = "https://cdn.sacul.cloud/v2/vision-cdn/Vision/BanniereBAN.png"
        MainDeferral.body[1].items[3]["text"] = nil
        MainDeferral.body[1].items[4] = {
            ["isVisible"] = true,
            ["type"] = "TextBlock",
            ["text"] = "Raison du ban : " .. banDetails.raison .. " \nTemps restant : " .. remainingDay .. ' jours ' .. remainingHour .. " heures " .. remainingMin .. " minutes" .. "\nID Ban : " .. banDetails.id,
            ["weight"] = "Bolder",
            ["fontType"] = "Default",
            ["size"] = "medium",
            ["isSubtle"] = true,
            ["wrap"] = true,
            ["horizontalAlignment"] = "Center"
        }
        deferrals.presentCard(MainDeferral)
        deferalText = ("Raison du ban : " .. banDetails.raison .. " \nTemps restant : " .. remainingDay .. ' jours ' .. remainingHour .. " heures " .. remainingMin .. " minutes" .. "\nID Ban : " .. banDetails.id)

        playerNotAllowedToJoin = true
        return
    end

    if PlayerInServer(src) and not licensesAdmin[GetLicense(src)] then
        MainDeferral.body[1].items[2]["url"] = nil
        MainDeferral.body[1].items[3]["text"] = nil
        MainDeferral.body[1].items[4] = {
            ["isVisible"] = true,
            ["type"] = "TextBlock",
            ["text"] = "Vous ne pouvez pas rejoindre le serveur, vous êtes déjà connecté.\n\nSi cela est une erreur, réessayez de vous connecter.",
            ["weight"] = "Bolder",
            ["fontType"] = "Default",
            ["size"] = "medium",
            ["isSubtle"] = true,
            ["wrap"] = true,
            ["horizontalAlignment"] = "Center"
        }
        deferrals.presentCard(MainDeferral)
        deferalText = ("Vous ne pouvez pas rejoindre le serveur, vous êtes déjà connecté.\n\nSi cela est une erreur, réessayez de vous connecter")

        playerNotAllowedToJoin = true
        return
    end

    if playerNotAllowedToJoin then
        return
    --else
        -- local license = GetLicense(src);
        -- local currentProxy;
        -- if (not license) then
        --     deferrals.done("Impossible de récupérer votre license, veuillez réessayer.")
        --     return;
        -- end
        -- local result = MySQL.Sync.fetchAll("SELECT * FROM proxy_players WHERE license = @license LIMIT 1", {
        --     ["@license"] = license
        -- });
        -- if (not next(result)) then
        --     local proxy = MySQL.Sync.fetchAll("SELECT * FROM proxy_list ORDER BY RAND() LIMIT 1");
        --     if (not next(proxy)) then
        --         deferrals.done("Impossible de vous connecter, veuillez réessayer.");
        --         return;
        --     end
        --     MySQL.Sync.execute("INSERT INTO proxy_players (license, proxy) VALUES (@license, @proxy)", {
        --         ["@license"] = license,
        --         ["@proxy"] = proxy[1].proxy
        --     });
        --     currentProxy = proxy[1];
        -- else
        --     currentProxy = result[1];
        -- end
        -- print(("Player %s connected to proxy %s"):format(license, currentProxy.proxy));
        -- deferrals.handover({endpoints={currentProxy.proxy}});
        -- TriggerEvent('startQueueScript', src, playerName, deferrals)
    end
    if deferalText then -- ne pas touché (oui c'est pas logique mais si on met deferalText meme si il est nil bah ça passe pas)
        deferrals.done(deferalText)
    else
        deferrals.done()
    end
end)

--RegisterCommand("pingply", function()
--    CheckPlayersPing()
--end)

function CheckPlayersPing()
    for k,v in pairs(GetPlayers()) do
        if GetPlayerPing(v) > 500 then
            print(v, "Ping trop élevé " .. GetPlayerPing(v))
        end
    end
end

---CreateThread(function()
---    while true do
---        Wait(60000)
---    end
---end)
