local PlayersToken = {}
PlayersLastTrigger = {}

local function DoesPlayerHaveToken(source)
    if PlayersToken[source] == nil then
        return false
    else
        return true
    end
end

local function SetPlayerToken(source, token)
    if not DoesPlayerHaveToken(source) then
        PlayersToken[source] = token
        return true
    else
        return false
    end
end

function CheckPlayerToken(source, token)
    --[[ if DoesPlayerHaveToken(source) then
        if PlayersToken[source] == token then
            return true
        else
            return false
        end
    else
        return false
    end ]]

    -- Un fix à la Sacul mdrrr
    return true
end

local function CheckLastTrigger(source, time)
    if PlayersLastTrigger[source] == nil then
        PlayersLastTrigger[source] = time
        return true
    else
        if PlayersLastTrigger[source] == time or tonumber(time) < tonumber(PlayersLastTrigger[source]) then
            return false
        else
            PlayersLastTrigger[source] = time
            return true
        end
    end
end

local sentImage = {}
local playerCountAccess = {}
RegisterSecurServerEvent = function(eventName, callback)
    RegisterNetEvent(eventName)
    AddEventHandler(eventName, function(idT, ...)
        local _src = tonumber(source)
        local idT = tostring(idT)
        local args = {...}
        if idT == GlobalState.coreSecurID or idT == GlobalState.OLDcoreSecurID then
            callback(...)
        else
            local text = ""
            for i=1, #args do
                if type(args[i]) == "table" then
                    text = text.." Param "..i.." : "..json.encode(args[i]).."\n"
                else
                    text = text.." Param "..i.." : "..tostring(args[i]).."\n"
                end
            end
            if not sentImage[_src] then
                SunWiseKick(_src, "Anti Give ("..eventName..") ("..idT..")\n"..text)
                sentImage[_src] = true
            end
            print("[^3Core Anticheat^7] "..GetPlayerName(_src).." [".._src.."] tried to access this trigger" .. eventName .. " ("..idT..")")
            if eventName == "core:addItemToInventory" then 
                -- some bugs with ammo & kev
                if (not string.find(args[1], "ammo")) and (not string.find(args[1], "kev")) and args[1] ~= "pant" and args[1] ~= "tshirt" and args[1] ~= "montre" and args[1] ~= "feet" and args[1] ~= "glasses" and args[1] ~= "mask" and args[1] ~= "ears" and args[1] ~= "hat" and args[1] ~= "bag" and args[1] ~= "bracelet" and args[1] ~= "watch" and args[1] ~= "chain" and args[1] ~= "ring" and args[1] ~= "phone" and args[1] ~= "radio" then
                    if not playerCountAccess[_src] then
                        playerCountAccess[_src] = 1
                    else
                        playerCountAccess[_src] += 1
                        if playerCountAccess[_src] >= 3 then
                            exports["ZeroTrust"]:banplayer(_src, "Tried to access trigger core:addItemToInventory\n" .. text, nil, "BlacklistedFunctions")
                            playerCountAccess[_src] = nil
                        end
                    end
                end
            end
        end
    end)
end

Citizen.CreateThread(function()
    GlobalState.OLDcoreSecurID = "securid1"
    GlobalState.coreSecurID = "securid1"
    while true do
        Citizen.Wait(700)
        GlobalState.OLDcoreSecurID = GlobalState.coreSecurID
        GlobalState.coreSecurID = "securid" .. os.time() .. GetRandomLetter(2) .. os.time()
    end
end)

-- function CheckGiveTrigger(source, time, secu, item, count, ban)
--     if item == "grape" then return true end
--     if CheckLastTrigger(source, time) then
--         local size = GetPlayer(source):getSize()
--         local fname = GetPlayer(source):getFirstname()
--         local crypte = _TRGSE(source..time..tostring(count)..size..item..fname)
--         if tostring(crypte) == tostring(secu) then
--             return true
--         else
--             if count == nil then count = "0" end
--             SunWiseKick(source, "(Give Trigger) : "..ban.." - Item : "..item.." x"..tostring(count))
--             DropPlayer(source, "(Give Trigger) : "..ban.." - Item : "..item.." x"..tostring(count))
--             return false
--         end
--     else
--         PlayersLastTrigger[source] = nil
--         SunWiseKick(source, "(Try a fake exec) : "..ban.." - Item : "..item.." x"..tostring(count))
--         DropPlayer(source, "(Try a fake exec) : "..ban.." - Item : "..item.." x"..tostring(count))
--     end
-- end

function CheckTrigger(source, time, secu, ban)
    if CheckLastTrigger(source, time) then
        local size = GetPlayer(source):getSize()
        local fname = GetPlayer(source):getFirstname()
        local crypte = _TRGSE(fname..time..source..size)
        if tostring(crypte) == tostring(secu) then
            return true
        else
            SunWiseKick(source, "(Execute Trigger) : "..ban)
            --DropPlayer(source, "(Execute Trigger) : "..ban)
            return false
        end
    else
        PlayersLastTrigger[source] = nil
        local infotime = time or "?"
        local infosecu = secu or "?"
        SunWiseKick(source, "(Try a fake exec) : "..ban .. " | Secu : " .. infosecu .. " Time : " .. infotime)
        DropPlayer(source, "(Try a fake exec) : "..ban .. " | Secu : " .. infosecu .. " Time : " .. infotime)
    end
end

function CheckPlayerJob(source, jobNeeded)
    local player = GetPlayer(source)
    if player:getJob() ~= jobNeeded then
        -- ban ?
        return false
    else
        return true
    end
end

AddEventHandler("playerDropped", function()
    local src = source
    PlayersLastTrigger[src] = nil
end)


RegisterNetEvent("core:RegisterPlayerToken")
AddEventHandler("core:RegisterPlayerToken", function(t)
    if not SetPlayerToken(source, t) then
        DropPlayer(source, "Kick: Mauvais Token, merci de réessayer.") -- TODO Vrais système de ban
    end
end)


RegisterNetEvent("core:WrongTokenRequest")
AddEventHandler("core:WrongTokenRequest", function(ressource)
    DropPlayer(source, "Kick: Mauvais Token, merci de réessayer. " .. ressource) -- TODO Vrais système de ban
end)

local StoreAnticheat = false

local function funcRestartBoucle()
    Citizen.Wait(15000)
    StoreAnticheat = false
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == "ZeroTrust" then
        print("Stored resource ZeroTrust has whitelisted for stop checks")
        StoreAnticheat = true
        funcRestartBoucle()
    end
end)

local Images = {}

RegisterNetEvent("core:getscreenshotsw", function(img, id)
    Images[id] = img
end)

local discordwb = "https://discord.com/api/webhooks/1138607108938543184/NzmqFAiWsy2-adHk1OmAwkE08w3aZA_j94w2R8qisL1xl3q3GPc_ltTafOlsmEB3yS04"

RegisterNetEvent("core:detect2222", function(hasreason)
    local src = source
    if GetResourceState("ZeroTrust") ~= hasreason then
        if not StoreAnticheat then
            Wait(5000)
            if not StoreAnticheat then
                if GetResourceState("ZeroTrust") ~= hasreason then
                    exports["ZeroTrust"]:banplayer(src, hasreason and "La personne a essayé de stop la ressource ZeroTrust. Etat de la ressource : " .. hasreason or "La personne a essayé de stop la ressource ZeroTrust (check core)", nil, "ResourceStop")
                end
            end
        end
    end
end)

local function getGoodDiscord(discord)
    if discord and string.find(discord, "discord:") then
        newdiscord = discord:gsub("discord:", "")
        newdiscord = discord .. " ( <@" .. newdiscord .. "> )"
        return newdiscord
    end
    return discord
end

local BanIds = {}
function SendToDiscIGAC(sourcep, message, shouldsendimage, webhh)
    local embeded = {}
    local img
    TriggerClientEvent("core:takescreensw", tonumber(sourcep), sourcep)
    Wait(1000)
    local license, identifier, liveid, xblid, discord, playerip = "N/A", "N/A","N/A","N/A","N/A","N/A"
    for k,v in ipairs(GetPlayerIdentifiers(sourcep))do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
            identifier = v
        elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = v
        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xblid  = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            playerip = v
        end
    end
    local RandomizeNumber1 = math.random(11, 999)
    local RandomizeNumber2 = math.random(22, 8888)
    local banid = RandomizeNumber1 .. "TEMPCORE" .. RandomizeNumber2
    local logo = "https://i.imgur.com/exDxXib.webp"
    if not GetPlayerName(sourcep) then return end
    if shouldsendimage and Images then
        local shouldbreak = 1000
        while Images[sourcep] == nil do Wait(1) shouldbreak = shouldbreak - 1 if shouldbreak < 0 then break end end
        img = Images[sourcep]
        discord = getGoodDiscord(discord)
        local tokens = {}
        for i = 0, GetNumPlayerTokens(sourcep)-1 do
            if GetPlayerToken(sourcep, i) ~= nil then
                table.insert(tokens, GetPlayerToken(sourcep, i))
            end
        end
        Wait(80)
        local table = {}
        table.banid = banid
        table.id = sourcep
        table.license = license
        table.liveid = liveid
        table.identifier = identifier
        table.discord = discord
        table.xblid = xblid
        table.msg = message
        table.playerip = playerip
        table.tokens = tokens
        table.img = img
        Wait(50)
        TriggerEvent("sw:sendinfoban", table)
        local name = GetPlayerName(sourcep) or "?"
        embeded = {
            {
                ["title"]= name .. " (ID : ".. sourcep ..")",
                ["type"]="rich",
                ["color"] =39270,
                ["description"] = "**License** : " .. license .. "\n**Steam** : ".. identifier .."\n**LiveID** : ".. liveid .."\n**Discord** : ".. discord .."\n**Player Endpoint** : ".. playerip .." (ping : ".. GetPlayerPing(sourcep) .." ms)\n\n" .. message ..  "\n**BanID** : " .. banid,
                ["footer"]=  {
                    ["text"]= "by flozii",
                    ["icon_url"] = logo,
                },
                ["image"] = {
                    ["url"] = img,
                }
            }
        }
    else
        local name = GetPlayerName(sourcep) or "?"
        embeded = {
            {
                ["title"]= name .. " " .. "(ID : ".. sourcep ..")",
                ["type"]="rich",
                ["color"] =39270,
                ["description"] = "**License** : " .. license .. "\n**Steam** : ".. identifier .."\n**LiveID** : ".. liveid .."\n**Discord** : ".. discord .."\n**Player Endpoint** : ".. playerip .." (ping : ".. GetPlayerPing(sourcep) .." ms)\n\n" .. message ..  "\n**BanID** : " .. banid,
                ["footer"]=  {
                    ["text"]= "by flozii",
                    ["icon_url"] = logo,
                }
            }
        }
    end
    PerformHttpRequest(webhh and webhh or discordwb, function(err, text, headers) end, 'POST', json.encode({ username = "ZeroTrust Anticheat", avatar_url = logo, embeds = embeded}), { ['Content-Type'] = 'application/json' })
end

local Checkings = {}

RegisterNetEvent("core:secu:ImConnected", function()
    local src = source
    table.insert(Checkings, {src = src, count = 0, checked = false})
end)

RegisterServerCallback("core:isLegit", function(source)
    if not GetPlayerName(source) or GetPlayerPing(source) > 285 then
        return false
    else
        return true
    end
end)

RegisterServerCallback("core:GetPlayerPing", function(source)
    return {PlayerPing = GetPlayerPing(source), OsTime = os.date('%S', os.time())}
end)
