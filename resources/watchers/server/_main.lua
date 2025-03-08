WATCHERS = {}
WATCHERS.HttpRequestsCount = {}
WATCHERS.HttpRequestsCountMax = 3000
WATCHERS.HttpRequestRemoveAfter = 60 -- in seconds
WATCHERS.Errors = CONFIG.Webhooks.error
WATCHERS.Symboles = {
    Unloaded = "░",
    Loaded = "█"
}
WATCHERS.BlacklistedWebhook = {}
WATCHERS.RatelimitWait = false

function WATCHERS.AddWebhookToBlacklist(webhook)
    table.insert(WATCHERS.BlacklistedWebhook, webhook)
end

function WATCHERS.IsWebhookBlacklisted(webhook)
    for k,v in pairs(WATCHERS.BlacklistedWebhook) do
        if v == webhook then
            return true
        end
    end
    return false
end

function WATCHERS.PrepareLoadBar(value, max)
    if value > max then
        value = max
    end
    local bar = "["
    local percent = value / max
    local barLength = 10
    local loaded = math.floor(barLength * percent)
    if loaded == 0 then
        if value > 0 then
            loaded = 1
        end
    end
    local unloaded = barLength - loaded
    for i = 1, loaded do
        bar = bar .. WATCHERS.Symboles.Loaded
    end
    for i = 1, unloaded do
        bar = bar .. WATCHERS.Symboles.Unloaded
    end
    bar = bar .. "]"
    return bar
end

function WATCHERS.GetNumberInPourcent(value, max)
    local percent = value / max
    return math.floor(percent * 100)
end

function WATCHERS.PrepareBarDisplay(value, max)
    local bar = WATCHERS.PrepareLoadBar(value, max)
    local percent = WATCHERS.GetNumberInPourcent(value, max)
    return bar .. " ➤ " .. percent .. "%", percent
end

function WATCHERS.AddNewHttpRequest(url, InvokingResource)
    if InvokingResource == "watchers" then
        table.insert(WATCHERS.HttpRequestsCount, {
            time = GetGameTimer(),
            url = "watcher general logic",
            InvokingResource = InvokingResource
        })
        return
    end
    table.insert(WATCHERS.HttpRequestsCount, {
        time = GetGameTimer(),
        url = tostring(url),
        InvokingResource = InvokingResource
    })
end

function WATCHERS.GetOrganisedHttpRequests()
    local httpRequests = {}
    for k,v in pairs(WATCHERS.HttpRequestsCount) do
        local found = false
        for i,j in pairs(httpRequests) do
            if v.url == j.url then
                j.count = j.count + 1
                found = true
                break
            end
        end
        if not found then
            table.insert(httpRequests, {
                count = 1,
                InvokingResource = tostring(v.InvokingResource),
                url = v.url
            })
        end
    end
    table.sort(httpRequests, function(a, b)
        return a.count > b.count
    end)
    return httpRequests
end

function WATCHERS.CleanUpHttpRequests()
    for k,v in pairs(WATCHERS.HttpRequestsCount) do
        if GetGameTimer() - v.time > WATCHERS.HttpRequestRemoveAfter * 1000 then
            table.remove(WATCHERS.HttpRequestsCount, k)
        end
    end
end

function WATCHERS.GetHttpRequestCount()
    return #WATCHERS.HttpRequestsCount
end

function WATCHERS.UpdateWebhook(webhook, messageID, updated_data)
    if not WATCHERS.IsWebhookBlacklisted(webhook) and not WATCHERS.RatelimitWait then
        local sync = true
        PerformHttpRequest(webhook..'/messages/'..messageID, function(err, text, headers)
            sync = false
            if err == 404 or err == 401 then
                WATCHERS.AddWebhookToBlacklist(webhook)
                WATCHERS.SendToDiscord(WATCHERS.Errors, "404 error reached.\nWebhook: " .. webhook .. "\nError: " .. json.encode(headers) .. "\n\nMessageID: " .. messageID .. "\nData: " .. updated_data)
            elseif err == 429 then
                if not WATCHERS.RatelimitWait then
                    Trace.Warning("Discord Ratelimit reached, waiting 60 seconds before retrying. All discord webhook are being stopped for now.")
                    WATCHERS.RatelimitWait = true
                    Citizen.CreateThread(function()
                        Wait(60*1000)
                        WATCHERS.RatelimitWait = false
                    end)
                end
            end
        end, 'PATCH', updated_data, { ['Content-Type'] = 'application/json' })
        while sync do
            Wait(1)
        end
    end
end

function WATCHERS.SendToDiscord(webhook, message)

    local embed = {
        {
            ["color"] = 15158332,
            ["title"] = "WATCHER - Error",
            ["description"] = message,
        }
    }

    local sync = true
    PerformHttpRequest(webhook, function(err, text, headers)
        sync = false
        if err == 404 then
            WATCHERS.AddWebhookToBlacklist(webhook)
        end
    end, 'POST', json.encode({
        username = "WATCHER - Error",
        embeds = embed,
    }), { ['Content-Type'] = 'application/json' })
    while sync do
        Wait(1)
    end
end

-- Citizen.CreateThread(function()
--     while true do
--         local fakeLoad = math.random(1, 1500)
--         print(WATCHERS.PrepareBarDisplay(fakeLoad, 15000))
--         Wait(5000)
--     end
-- end)

-- Citizen.CreateThread(function()
--     while true do
--         WATCHERS.AddNewHttpRequest()
--         Wait(100)
--     end
-- end)

-- Init
Citizen.CreateThread(function()
    WATCHERS.srv_events.Init()
    WATCHERS.Dashboard.Init()
    WATCHERS.Saturation.Init()
    WATCHERS.Network.Init()
    WATCHERS.Http.Init()
    WATCHERS.Table.Init()
end)

AddEventHandler("watchers:SyncHttp", function(url, InvokingResource)
    if url ~= nil then
        WATCHERS.AddNewHttpRequest(url, InvokingResource)
    end
end)