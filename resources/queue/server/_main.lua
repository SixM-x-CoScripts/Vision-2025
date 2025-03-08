local memeberRoleId = "992111793742807040"

local devRoleId = "992116038802087987"
local supportRoleId = "1005201031010988074"
local stafffRoleId = "992116202623205407"
local modoRoleId = "1129972791865778276"
local discordId = "992031086555172895"
local botToken = "Bot 2ca43daeeb6c59d31226e890e861972008e8369a5ae3015f2a4fe9274cc80886"
local vipRoleId = "0912093"

---------- Info Serv ------------

local queue = {}
local queueCount = 0

local maxSlot = 600 --GetConvarInt("sv_maxclients", 600)
local VIPslot = 20
local slotDispo = maxSlot - VIPslot
local MaxDiscordRequest = 45 -- 50 per second
local SameTimeConnection = 20

local nbPlyrCheckDiscord = 0


local QUEUE = {}
QUEUE.BypassMod = false -- Toggle if queue is bugged
QUEUE.WaitingToBeSend = 0
QUEUE.List = {}
QUEUE.Stats = {
   waiting = 0,
   vip = 0, -- Not done yet, don't use
}

--------------------

local function discordRequest(method, endpoint, data)
    local resultDatas

    while nbPlyrCheckDiscord > MaxDiscordRequest do Wait(100) end
    nbPlyrCheckDiscord += 1

    local fail = 0

    :: request ::

    PerformHttpRequest("https://discordapp.com/api/" .. tostring(endpoint),
        function(errorCode, resultData, resultHeaders)
            resultDatas = { errorCode = errorCode, resultData = resultData, resultHeaders = resultHeaders }
        end, method, #data > 0 and json.encode(data) or "",
        { ["Content-Type"] = "application/json", ["Authorization"] = botToken }
    )

    while resultDatas == nil do Wait(100) end
    if (resultDatas.errorCode ~= 200) and (resultDatas.errorCode ~= 502) then -- 200 request completed 502 API DOWN
        Wait(1000)
        if fail < 5 then
            fail += 1
            goto request
        end
    end

    SetTimeout(1000, function() -- request clear after 1s
        nbPlyrCheckDiscord -= 1
    end)

    return resultDatas
end

local function GetPlayerRoles(discord)
    if discord then
        local endpoint = ("guilds/%s/members/%s"):format(discordId, discord)
        local member = discordRequest("GET", endpoint, {})
        if member.errorCode == 200 then
            local data = json.decode(member.resultData)
            local roles = data.roles

            for _, v in pairs(pRoles) do
                roleList[v] = true
            end

            return roles
        else
            return false
        end
    else
        return false
    end
end

--------------------

RegisterNetEvent('startQueueScript')
AddEventHandler('startQueueScript', function(src, playerName, deferrals)
    print("Queue started")
    deferrals.defer()
    Wait(50)
    local ban = CheckBan(src, deferrals)
    Wait(100)
    if not ban then
        local itsOkay = CheckDiscord(src, deferrals)
        if itsOkay then
            if QUEUE.BypassMod then
                deferrals.done()
                return
            else
                local FinishedQueue = JoinQueue(src, deferrals, itsOkay.vip)
                if FinishedQueue then
                    deferrals.done()
                end
            end
        end
    end
end)

------------------------------

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
                    ["isSubtle"] = true,
                    ["horizontalAlignment"] = "Center"
                },
                {
                    ["type"] = "Image",
                    ["url"] = "https://media.discordapp.net/attachments/1134891884603527288/1140252342562861146/image.png",
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
            ["url"] = "https://absoluterp.tebex.io",
        }
    },
    ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
    ["version"] = "1.2"
}

function GetIP(src)
    local ip = ""
    for _, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.match(v, "ip:") then
            ip = string.gsub(v, "ip:", "")
        end
    end
    return ip
end

function CheckDiscord(src, deferrals)
    local indiscord = false
    local discord = nil
    local good = false
    for _, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.match(v, "discord:") then
            discord = string.gsub(v, "discord:", "")
        end
    end

    if discord == nil then
        MainDeferral.body[1].items[3]["text"] = "Discord non détecté"
        deferrals.presentCard(MainDeferral)
        deferrals.done("Discord non détecté")
        return false
    end

    MainDeferral.body[1].items[3]["text"] = "En attente de la vérification de Discord."
    deferrals.presentCard(MainDeferral)

    return {vip = false}

    --local playerRoles = GetPlayerRoles(discord)
    --if playerRoles[devRoleId] or playerRoles[supportRoleId] or playerRoles[stafffRoleId] or playerRoles[modoRoleId] then
    --    deferrals.done()
    --end

    --if playerRoles[memeberRoleId] then
    --    MainDeferral.body[1].items[3]["text"] = "Accès autorisé ! Placement dans la file d'attente."
    --    deferrals.presentCard(MainDeferral)
    --    return { vip = playerRoles[vipRoleId] }
    --end

    --MainDeferral.body[1].items[3]["text"] = "Vous devez rejoindre le discord de absoluterp"
    --deferrals.presentCard(MainDeferral)
    --deferrals.done("Vous devez rejoindre le discord de absoluterp")
    --return false
end

function CheckBan(src, deferrals)
    local waitingSync = true
    local checks = 0
    local bool = false
    TriggerEvent("server:queue:CheckIfPlayerIsBanned", src, function(boolean, table, day, hour, min)
       -- print("ban", boolean, table, day, hour, mi)
        bool = boolean
        if bool then
            local table = table or {raison = "Aucune raison", id = "Aucun ID"}
            local day = day or "0"
            local hour = hour or "0"
            local min = min or "0"

            MainDeferral.body[1].items[3]["text"] = "Vous avez été banni !"
            MainDeferral.body[1].items[3]["size"] = "large"
            MainDeferral.body[1].items[4] = {
                ["isVisible"] = true,
                ["type"] = "TextBlock",
                ["text"] = "Raison du ban : " .. table.raison .. " \nTemps restant : ".. day .. ' jours ' .. hour .. " heures " .. min .. " minutes" .."\nID Ban : " .. table.id,
                ["weight"] = "Bolder",
                ["fontType"] = "Default",
                ["size"] = "medium",
                ["isSubtle"] = true,
                ["wrap"] = true,
                ["horizontalAlignment"] = "Center"
            }
            deferrals.presentCard(MainDeferral)
        end
        waitingSync = false
    end)

    while waitingSync do
        --print("waiting sync")
        checks = checks + 1
        if checks > 10 then -- Avoid infinite loop
            deferrals.done("Erreur pendant la liaison queue -> core server:queue:")
            return true
        end
        Wait(100)
    end
   -- print("sync done", bool)

    return bool
end

function QUEUE.Add(source)
    table.insert(QUEUE.List, {
        source = source,
        priority = 0,
        canEnter = false,
    })
    return #QUEUE.List
end

function QUEUE.Remove(source)
    for k, v in pairs(QUEUE.List) do
        if v.source == source then
            QUEUE.WaitingToBeSend = QUEUE.WaitingToBeSend - 1
            table.remove(QUEUE.List, k)
        end
    end
end

function QUEUE.OrderForPriority()
    table.sort(QUEUE.List, function(a, b)
        return a.priority > b.priority
    end)
end

function QUEUE.RemoveOffline()
    for k,v in pairs(QUEUE.List) do
        if GetPlayerPing(v.source) == 0 then
            table.remove(QUEUE.List, k)
        end
    end
end

function QUEUE.GetFromQueue(source)
    for k, v in pairs(QUEUE.List) do
        if v.source == source then
            return v, k
        end
    end
    return nil, 0
end

function QUEUE.AddPriority(source, priority)
    --TODO: Ajouter le système de priorité avec grade
    for k, v in pairs(QUEUE.List) do
        if v.source == source then
            v.priority = v.priority + priority
        end
    end
end

function QUEUE.UpdateTime()
    for k,v in pairs(QUEUE.List) do
        v.priority = v.priority + 1
    end
end

function JoinQueue(src, deferrals, priority)
    local position = QUEUE.Add(src)
    local ip = GetIP(src)
    if priority ~= nil then
        if priority then -- Kind of stupid to have 3 if but just to be sure xD
            QUEUE.AddPriority(src, 1000)
        end
    end

    Wait(50) -- va pas trop vite pelo
    while true do
        Wait(1000)
        local self, position = QUEUE.GetFromQueue(src)

        if self == nil then
            break -- exit queue
        else
            MainDeferral.body[1].items[3]["text"] = "Vous avez rejoint la file d'attente"
            MainDeferral.body[1].items[3]["size"] = "large"
            MainDeferral.body[1].items[4] = {
                ["isVisible"] = true,
                ["type"] = "TextBlock",
                ["text"] = "Nombre de personne(s) en attente: " .. queueCount,
                ["weight"] = "Bolder",
                ["fontType"] = "Default",
                ["size"] = "medium",
                ["isSubtle"] = true,
                ["wrap"] = true,
                ["horizontalAlignment"] = "Center"
            }
            if queue[src] then
                MainDeferral.body[1].items[5] = {
                    ["isVisible"] = true,
                    ["type"] = "TextBlock",
                    ["text"] = "Position : " .. position .. "/" .. queueCount,
                    ["weight"] = "Bolder",
                    ["fontType"] = "Default",
                    ["size"] = "medium",
                    ["isSubtle"] = true,
                    ["wrap"] = true,
                    ["horizontalAlignment"] = "Center"
                }
            end
            deferrals.presentCard(MainDeferral)
            if self.canEnter then
                print("DEBUG QUEUE: Player "..GetPlayerName(src).." IP : "..ip.." is entering the serv")
                MainDeferral.body[1].items[3]["text"] = "Vous rejoignez le serveur !"
                MainDeferral.body[1].items[3]["size"] = "large"
                deferrals.presentCard(MainDeferral)
                Wait(1000)
                QUEUE.Remove(src)
                break
            end
        end
    end
    return true
end

Citizen.CreateThread(function()
    print("Queue started")
    while true do
        QUEUE.RemoveOffline()
        QUEUE.Stats.waiting = #QUEUE.List
        if GetNumPlayerIndices() < maxSlot then
            QUEUE.OrderForPriority()
            QUEUE.UpdateTime()

            if QUEUE.WaitingToBeSend < 5 then
                for k,v in pairs(QUEUE.List) do
                    if v.canEnter == false then
                        v.canEnter = true
                        QUEUE.WaitingToBeSend = QUEUE.WaitingToBeSend + 1
                        break -- Avoid sending more that what we need
                    end
                end
            end
        end
        Wait(1000)
    end
end)

-- Unlock queue if locked for too long
Citizen.CreateThread(function()
    local lockedTracked = 0
    local lastValue = 0
    while true do
        if QUEUE.WaitingToBeSend > 0 then
            if lastValue == QUEUE.WaitingToBeSend then
                lockedTracked = lockedTracked + 1
            else
                lockedTracked = 0
            end

            lastValue = QUEUE.WaitingToBeSend
            if lockedTracked > 10 then
                print("Queue unlocked, locked for too long. This is an issue that need to be fixed!!!")
                QUEUE.WaitingToBeSend = 0
                lockedTracked = 0
            end
        else
            lockedTracked = 0
        end

        if QUEUE.WaitingToBeSend < 0 then
            QUEUE.WaitingToBeSend = 0
        end

        --print(QUEUE.WaitingToBeSend, #QUEUE.List, lockedTracked)
        TriggerEvent("watcher:server:SendTableInfo", "QUEUE.WaitingToBeSend", QUEUE.WaitingToBeSend)
        TriggerEvent("watcher:server:SendTableInfo", "QUEUE.List", #QUEUE.List)
        Wait(1000)
    end
end)


-- Citizen.CreateThread(function()
--     for i = 1,1000 do
--         QUEUE.Add(i)
--     end
-- end)