Trace = {}
Trace.Cache = {}

function Trace.Warning(...)
    --print("^7(^1!^7) WARNING: ", ...)
end

function Trace.Info(...)
    --print("^7(^3!^7) INFO: ", ...)
end

function Trace.SendToDiscord(type, ...)
    if ServerConfig.Traces[type] ~= nil then
        local self = ServerConfig.Traces[type]
        local message = Trace.FormatMessage(self) .. string.format(self.label, ...)
        Trace.AddMessageToCache(self.webhook, message)
        --Trace.SendMessageToWebhook(self.webhook, message)
    else
        Trace.Warning("WATCHER tried to send an trace that do not exist. ("..type..")", ...)
    end
end

function Trace.GetCurrentDate()
    return os.date("%Y/%m/%d - %H:%M %Ss")
end

function Trace.FormatMessage(self)
    local date = Trace.GetCurrentDate()
    return "``[" .. self.tag .. "][" .. date .. "]``\n"
end

function Trace.AddMessageToCache(webhook, message)
    if Trace.Cache[webhook] == nil then
        Trace.Cache[webhook] = {}
    end

    table.insert(Trace.Cache[webhook], message)
end

function Trace.SendMessageToWebhook(webhook, msg)
    if not WATCHERS.IsWebhookBlacklisted(webhook) then
        local embed = {
            {
                ["color"] = 15158332,
                ["title"] = "WATCHER - LOGS",
                ["description"] = msg,
            }
        }
    
        local sync = true
        PerformHttpRequest(webhook, function(err, text, headers)
            sync = false
            if err == 404 then
                WATCHERS.AddWebhookToBlacklist(webhook)
                WATCHERS.SendToDiscord(WATCHERS.Errors, "404 error reached. (Trace.SendMessageToWebhook)\nWebhook: " .. webhook .. "\nData: " .. msg)
            end
        end, 'POST', json.encode({
            username = "WATCHER - Logs",
            embeds = embed,
        }), { ['Content-Type'] = 'application/json' })
        while sync do
            Wait(1)
        end
    end
end

function Trace.BuildMessage(messages)
    local send_message = false
    local message = ""
    for k,v in pairs(messages) do
        message = message .. tostring(v) .. "\n"
        send_message = true
    end
    return send_message, message
end

AddEventHandler("TRACE:SendTrace", function(type, ...)
    Trace.SendToDiscord(type, ...)
end)

-- AddEventHandler('oxmysql:error', function(data)
--     Trace.SendToDiscord(11, data.query, json.encode(data.parameters), data.message, json.encode(data.err), data.invokingResource)
-- end)