WATCHERS.Http = {}

WATCHERS.Http.Webhook = CONFIG.Webhooks.httpWatcher
WATCHERS.Http.MsgID = CONFIG.MessageID.http

function WATCHERS.Http.InitMSG()
    if WATCHERS.Http.MsgID == "" then
        WATCHERS.srv_events.SendBaseMSG("WAITING SYNC: Http", WATCHERS.Http.Webhook)
    end
end

function WATCHERS.Http.Run()
    if WATCHERS.Http.MsgID ~= "" then
        local limit = 15
        local count = 0
        local requests = WATCHERS.GetOrganisedHttpRequests()
        local total_requests = WATCHERS.GetHttpRequestCount()
        local message = "Last refresh: " .. Trace.GetCurrentDate() .. "\nRequests last 60s: **" .. total_requests .."**\n``Should be between 100 ~ 250``\n\n"

        for k,v in pairs(requests) do
            if count <= limit then
                count = count + 1
                message = message .. "x**" .. v.count .. "** ``" .. tostring(v.InvokingResource) .."``\n``(" .. tostring(v.url) .. ")``\n\n"
            else
                break
            end
        end

        local message_to_send = json.encode({
            content = "",
            embeds = {
                {
                    ["color"] = WATCHERS.srv_events.Colors.good,
                    ["title"] = '**HTTP WATCHER:**',
                    ["description"] = message
                }
            },
        })
        WATCHERS.UpdateWebhook(WATCHERS.Http.Webhook, WATCHERS.Http.MsgID, message_to_send)
    end
end

function WATCHERS.Http.Init()
    Citizen.CreateThread(function()
        WATCHERS.Http.InitMSG()
        while true do
            WATCHERS.Http.Run()
            Wait(10*1000)
        end
    end)
end
