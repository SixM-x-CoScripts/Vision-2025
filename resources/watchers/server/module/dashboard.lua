WATCHERS.Dashboard = {}

WATCHERS.Dashboard.Webhook = CONFIG.Webhooks.loadWatcher
WATCHERS.Dashboard.MsgID = CONFIG.MessageID.load
WATCHERS.Dashboard.CoreRamUsed = 0
WATCHERS.Dashboard.WatcherRamused = 0

function WATCHERS.Dashboard.FormatCollectorBytes(bytes)
    local unit = "B"
    if bytes > 1024 then
        bytes = bytes / 1024
        unit = "KB"
    end
    if bytes > 1024 then
        bytes = bytes / 1024
        unit = "MB"
    end
    if bytes > 1024 then
        bytes = bytes / 1024
        unit = "GB"
    end
    if bytes > 1024 then
        bytes = bytes / 1024
        unit = "TB"
    end
    bytes = math.floor(bytes * 100) / 100 -- round to two decimal places
    bytes = math.floor(bytes * 100) / 100 -- round to two decimal places
    return bytes, unit
end

function WATCHERS.Dashboard.InitMSG()
    if WATCHERS.Dashboard.MsgID == "" then
        WATCHERS.srv_events.SendBaseMSG("WAITING SYNC: Dashboard", WATCHERS.Dashboard.Webhook)
    end

    local k, b = collectgarbage("count")
    WATCHERS.Dashboard.WatcherRamused = k * 1024
end

function WATCHERS.Dashboard.Run()
    if WATCHERS.Dashboard.MsgID ~= "" then
        local event_total = WATCHERS.srv_events.GetTotalEvent()
        local event_load_bar, saturationAverage = WATCHERS.PrepareBarDisplay(event_total, 70000)

        local size_total = WATCHERS.srv_events.GetTotalEventBySize()
        local size_load_bar, networkAverage = WATCHERS.PrepareBarDisplay(size_total, 30000000)

        local http_request_count = WATCHERS.GetHttpRequestCount()
        local http_load_bar, httpAverage = WATCHERS.PrepareBarDisplay(http_request_count, WATCHERS.HttpRequestsCountMax)

        local k, b = collectgarbage("count")
        WATCHERS.Dashboard.WatcherRamused = k * 1024
        local formatedWatcherRamused, formatedWatcherRamUsedUnit = WATCHERS.Dashboard.FormatCollectorBytes(WATCHERS.Dashboard.WatcherRamused)

        local formatedCoreRamUsed, formatedCoreRamUsedUnit = WATCHERS.Dashboard.FormatCollectorBytes(WATCHERS.Dashboard.CoreRamUsed)

        local saturationSymboleToAdd = ""
        if saturationAverage >= 100 then
            saturationSymboleToAdd = ":warning:"
        end

        local networkSymboleToAdd = ""
        if networkAverage >= 100 then
            networkSymboleToAdd = ":warning:"
        end

        local httpSymboleToAdd = ""
        if httpAverage >= 100 then
            httpSymboleToAdd = ":warning:"
        end

        local message = "Last refresh: " .. Trace.GetCurrentDate() .. "\n\n" .. event_load_bar .." Events load " .. saturationSymboleToAdd .."\n" .. size_load_bar .. " Network load " .. networkSymboleToAdd .."\n" .. http_load_bar .. " Http requests limit (" .. http_request_count .. ") " .. httpSymboleToAdd ..""
        local message = message .. "\n**Server response time**: "..Utils.Comma_value(WATCHERS.Hitch.HitchsPerMinutes).."ms"
        local message = message .. "\n**Server player count**: "..#GetPlayers()
        local message = message .. "\n**Watcher version**: "..CONFIG.Version
        local message = message .. "\n**Watcher RAM used**: "..formatedWatcherRamused .. " " .. formatedWatcherRamUsedUnit
        local message = message .. "\n**Core RAM used**: " ..formatedCoreRamUsed .. " " .. formatedCoreRamUsedUnit
        local message_to_send = json.encode({
            content = "",
            embeds = {
                {
                    ["color"] = WATCHERS.srv_events.Colors.good,
                    ["title"] = '**Dashboard watcher:**',
                    ["description"] = message
                }
            },
        })
        WATCHERS.UpdateWebhook(WATCHERS.Dashboard.Webhook, WATCHERS.Dashboard.MsgID, message_to_send)
    end
end

function WATCHERS.Dashboard.Init()
    Citizen.CreateThread(function()
        WATCHERS.Dashboard.InitMSG()
        while true do
            WATCHERS.Dashboard.Run()
            Wait(5*1000)
        end
    end)
end


AddEventHandler("watcher:server:SetCoreRamUsed", function(collectorData)
    --print("collectorData", collectorData)
    WATCHERS.Dashboard.CoreRamUsed = collectorData
end)