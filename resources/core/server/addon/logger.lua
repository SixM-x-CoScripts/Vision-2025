local isProduction = true
devMode = {}

PerformHttpRequest('https://api.ipify.org/', function(err, text, headers)
    if text == "94.23.188.114" or text == "135.125.4.181" or text == "178.33.8.109" then
        isProduction = true
    end
end)

function SendDiscordLog(type, source, ...)
    if devMode[source] == true then return end
    --print(type, logs[type].text, source)
    if logs[type] ~= nil and isProduction then
        text        = string.format(logs[type].text, source, ...)
        color       = logs[type].color
        local url   = url
        local embed = {
            {
                ["color"] = color,
                ["title"] = logs[type].title,

                ["description"] = text,
                ["footer"] = {
                    ["text"] = os.date("%Y/%m/%d %X"),
                    ["icon_url"] = "https://cdn.discordapp.com/attachments/791407719948091442/1010676021063843850/server_icon.webp",

                },
            }
        }
        PerformHttpRequest(logs[type].hook, function(err, text, headers) end, 'POST',
            json.encode({ username = "LOG", embeds = embed,
                avatar_url = "https://cdn.discordapp.com/attachments/791407719948091442/1010676021063843850/server_icon.webp" })
            , { ['Content-Type'] = 'application/json' })
    end
end

function SendDiscordLogImage(type, source, url, ...)
    if logs[type] ~= nil and isProduction then
        text        = string.format(logs[type].text, source, ...)
        color       = logs[type].color
        local url   = url
        local embed = {
            {
                ["color"] = color,
                ["title"] = logs[type].title,

                ["description"] = text,
                ["footer"] = {
                    ["text"] = os.date("%Y/%m/%d %X"),
                    ["icon_url"] = "https://cdn.discordapp.com/attachments/791407719948091442/1010676021063843850/server_icon.webp",

                },
                ["image"] = {
                    ["url"] = url,
                } 


            }
        }
        PerformHttpRequest(logs[type].hook, function(err, text, headers) end, 'POST',
            json.encode({ username = "LOG", embeds = embed,
                avatar_url = "https://cdn.discordapp.com/attachments/791407719948091442/1010676021063843850/server_icon.webp" })
            , { ['Content-Type'] = 'application/json' })
    end
end

function SendPlayerStatistiques(source, identifiers)
    PerformHttpRequest(
        "https://api-sex.sacul.cloud/stats/fa", 
        function(status, text, headers) 
            if status ~= 200 then 
                print("[AbsolutePanel API] Error while performing /stats request") 
                return 
            end
        end, 
        'POST',
        json.encode({ player = GetPlayer(source), discord = GetDiscord(source), steam = GetSteam(source), identifiers = identifiers }), 
        { ['Content-Type'] = 'application/json' }) 
end

function SendPlayerCrashLog(source, reason, identifiers)
    PerformHttpRequest(
        "https://api-sex.sacul.cloud/crash/fa", 
        function(status, text, headers) 
            if status ~= 200 then 
                print("[AbsolutePanel API] Error while performing /crash request") 
                return 
            end
        end, 
        'POST',
        json.encode({ identifiers = identifiers, reason = reason }), 
        { ['Content-Type'] = 'application/json' }) 
end

exports('SendDiscordLog', function(type, source, ...)
    SendDiscordLog(type, source, ...)
end)

exports('SendPlayerStatistiques', function(source, identifiers)
    SendPlayerStatistiques(source, identifiers)
end)

exports('SendPlayerCrashLog', function(source, reason, identifiers)
    SendPlayerCrashLog(source, reason, identifiers)
end)

RegisterNetEvent("core:heistlog")
AddEventHandler("core:heistlog", function(id, pos)
    SendDiscordLog("heist", source, string.sub(GetDiscord(source), 9, -1),
        GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(), pos, id)
end)

RegisterNetEvent("core:logs")
AddEventHandler("core:logs", function(token, data)
    if CheckPlayerToken(source, token) then
        SendDiscordLog(data.type, source, string.sub(GetDiscord(source), 9, -1),
            GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(), data.value)
    else
        -- AC ban
    end
end)

RegisterNetEvent("core:perquisitionlog")
AddEventHandler("core:perquisitionlog", function(id, name, owner, crew)
    SendDiscordLog("perquisition", source, string.sub(GetDiscord(source), 9, -1),
        GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(),
        id, name, owner, crew)
    end)

RegisterNetEvent("core:sprayLog")
AddEventHandler("core:sprayLog", function(sprayLocation, finalText)
    SendDiscordLog("sprayLog", source, string.sub(GetDiscord(source), 9, -1),
        GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(),
        math.floor(sprayLocation.x), math.floor(sprayLocation.y), finalText)
end)

RegisterNetEvent("core:superette")
AddEventHandler("core:superette", function(totalMoney, name, reason)
    SendDiscordLog("superette", source, string.sub(GetDiscord(source), 9, -1),
        GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(),
        totalMoney, name, reason)
end)

RegisterNetEvent("core:binco")
AddEventHandler("core:binco", function(totalMoney, name, reason)
    SendDiscordLog("binco", source, string.sub(GetDiscord(source), 9, -1),
        GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(),
        totalMoney, name, reason)
end)

RegisterNetEvent("core:entreprisebraquage")
AddEventHandler("core:entreprisebraquage", function(totalMoney, name, reason)
    SendDiscordLog("entreprisebraquage", source, string.sub(GetDiscord(source), 9, -1),
        GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(),
        totalMoney, name, reason)
end)

RegisterNetEvent("core:ammunationtake")
AddEventHandler("core:ammunationtake", function(totalMoney, name, reason)
    SendDiscordLog("Ammunation-TakeItem", source, string.sub(GetDiscord(source), 9, -1),
        GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(),
        totalMoney, name, reason)
end)

RegisterNetEvent("core:logLSPDSearch", function(name, qt)
    local src = source
    SendDiscordLog("lspdsearch", src, string.sub(GetDiscord(src), 9, -1),
        GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
        name, qt)
end)

RegisterNetEvent("core:logTakeVeh", function(name, qt)
    local src = source
    SendDiscordLog("takeitemveh", src, string.sub(GetDiscord(src), 9, -1),
        GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
        name, qt)
end)

RegisterNetEvent("core:logTakeProperty", function(name, qt, id)
    local src = source
    SendDiscordLog("takeitemproperty", src, string.sub(GetDiscord(src), 9, -1),
        GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
        name, qt, id)
end)

RegisterNetEvent("core:achatVehlog", function(name, qt)
    local src = source
    SendDiscordLog("achatvehLSMotors", src, string.sub(GetDiscord(src), 9, -1),
        GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
        name, qt)
end)

RegisterNetEvent("core:achatVehlog2", function(name, qt)
    local src = source
    SendDiscordLog("achatvehAMMotors", src, string.sub(GetDiscord(src), 9, -1),
        GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
        name, qt)
end)

RegisterNetEvent("core:achatVehlog3", function(name, qt)
    local src = source
    SendDiscordLog("achatveHeliwave", src, string.sub(GetDiscord(src), 9, -1),
        GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
        name, qt)
end)

RegisterNetEvent("core:achatvangelico", function(name, qt)
    local src = source
    SendDiscordLog("achatvangelico", src, string.sub(GetDiscord(src), 9, -1),
        GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
        name, qt)
end)

RegisterNetEvent("core:pawnshoplog", function(name, qt)
    local src = source
    SendDiscordLog("pawnshopAchat", src, string.sub(GetDiscord(src), 9, -1),
        GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
        name, qt)
end)

RegisterNetEvent("core:depotCoffreProp", function(name, qt, id)
    local src = source
    SendDiscordLog("depotCoffreProp", src, string.sub(GetDiscord(src), 9, -1),
        GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
        name, qt, id)
end)

RegisterNetEvent("core:depotCoffreVeh", function(name, qt)
    local src = source
    SendDiscordLog("depotCoffreVeh", src, string.sub(GetDiscord(src), 9, -1),
        GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
        name, qt)
end)

RegisterNetEvent("core:DupplicationDetect", function(methods, name, qt, count, type, idtype, ping, LastTime, NowTime)
    local src = source

    if methods == "Put2" or methods == "PutAntiSpam" or methods == "Put" then

            local Logs = nil
            
            if methods == "Put" then
                Logs = "DupplicationDetectDepots"
            elseif methods == "Put2" then
                Logs = "DupplicationDetectDepots2"
            elseif methods == "PutAntiSpam" then 
                Logs = "DupplicationDetectDepotsAntiSpam"
            end
        
            if type == "property" then
                SendDiscordLog(Logs, src, string.sub(GetDiscord(src), 9, -1), GetLicense(src),
                    GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(), GetPlayer(src):getBanque(), GetPlayer(src):getCrew(),
                    name, qt, count, "Propriété : `" .. idtype .. "`", "Ping : `" .. ping.. "`", LastTime, NowTime)
            elseif type == "casier" then
                SendDiscordLog(Logs, src, string.sub(GetDiscord(src), 9, -1), GetLicense(src),
                    GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(), GetPlayer(src):getBanque(), GetPlayer(src):getCrew(),
                    name, qt, count, "Casier numéro : `" .. idtype .. "`", "Ping : `" .. ping.. "`", LastTime, NowTime)
            elseif type == "vehicle" then
                SendDiscordLog(Logs, src, string.sub(GetDiscord(src), 9, -1), GetLicense(src),
                    GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(), GetPlayer(src):getBanque(), GetPlayer(src):getCrew(),
                    name, qt, count, "Plaque d'immatriculation : `" .. idtype .. "`", "Ping : `" .. ping .. "`", LastTime, NowTime)
            elseif type == "society" then
                SendDiscordLog(Logs, src, string.sub(GetDiscord(src), 9, -1), GetLicense(src),
                    GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(), GetPlayer(src):getBanque(), GetPlayer(src):getCrew(),
                    name, qt, count, "Dans le coffre de la société : `" .. idtype .. "`", "Ping : `" .. ping.. "`", LastTime, NowTime)
            elseif type == "autre" then
                SendDiscordLog(Logs, src, string.sub(GetDiscord(src), 9, -1), GetLicense(src),
                    GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(), GetPlayer(src):getBanque(), GetPlayer(src):getCrew(),
                    name, qt, count, "_Dans un coffre_", "Ping : `" .. ping.. "`", LastTime, NowTime)
            end
    elseif methods == "Take" or methods == "TakeAntiSpam" or methods == "Take2" then

        local Logs = nil

        if methods == "Take" then
            Logs = "DupplicationDetectTake"
        elseif methods == "TakeAntiSpam" then
            Logs = "DupplicationDetectTake2"
        elseif methods == "Take2" then 
            Logs = "DupplicationDetectTakeAntiSpam"
        end

        if type == "property" then
            SendDiscordLog(Logs, src, string.sub(GetDiscord(src), 9, -1), GetLicense(src),
                GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(), GetPlayer(src):getBanque(), GetPlayer(src):getCrew(),
                name, qt, count, "Propriété : `" .. idtype .. "`", "Ping : `" .. ping.. "`", LastTime, NowTime)
        elseif type == "casier" then
            SendDiscordLog(Logs, src, string.sub(GetDiscord(src), 9, -1), GetLicense(src),
                GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(), GetPlayer(src):getBanque(), GetPlayer(src):getCrew(),
                name, qt, count, "Casier numéro : `" .. idtype .. "`", "Ping : `" .. ping.. "`", LastTime, NowTime)
        elseif type == "vehicle" then
            SendDiscordLog(Logs, src, string.sub(GetDiscord(src), 9, -1), GetLicense(src),
                GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(), GetPlayer(src):getBanque(), GetPlayer(src):getCrew(),
                name, qt, count, "Plaque d'immatriculation : `" .. idtype .. "`", "Ping : `" .. ping .. "`", LastTime, NowTime)
        elseif type == "society" then
            SendDiscordLog(Logs, src, string.sub(GetDiscord(src), 9, -1), GetLicense(src),
                GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(), GetPlayer(src):getBanque(), GetPlayer(src):getCrew(),
                name, qt, count, "Dans le coffre de la société : `" .. idtype .. "`", "Ping : `" .. ping.. "`", LastTime, NowTime)
        elseif type == "autre" then
            SendDiscordLog(Logs, src, string.sub(GetDiscord(src), 9, -1), GetLicense(src),
                GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(), GetPlayer(src):getBanque(), GetPlayer(src):getCrew(),
                name, qt, count, "_Dans un coffre_", "Ping : `" .. ping.. "`", LastTime, NowTime)
        end
    end
end)

RegisterNetEvent("core:updateLogDev")
AddEventHandler("core:updateLogDev", function()
    local player = source
    if devMode[player] then
        devMode[player] = not devMode[player]
    else
        devMode[player] = true
    end
end)