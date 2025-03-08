WATCHERS.srv_events = {}
WATCHERS.srv_events.Refresh = 10 -- seconds
WATCHERS.srv_events.RemoveEventAfter = 60 -- seconds
WATCHERS.srv_events.Tops = {}
WATCHERS.srv_events.Events = {}
WATCHERS.srv_events.Colors = {
    good = 5763719,
    bad = 15548997,
    medium = 16763904,
}

WATCHERS.srv_events.BaseWebhook = CONFIG.Webhooks.baseWatcher
WATCHERS.srv_events.TopMsgID = CONFIG.MessageID.logger

function WATCHERS.srv_events.SendBaseMSG(text, customWebhook)
    local webhook = WATCHERS.srv_events.BaseWebhook
    if customWebhook ~= nil then
        webhook = customWebhook
    end
    local wait = true
    PerformHttpRequest(webhook, function(err, text, headers)
        wait = false
    end, 'POST', json.encode({
       content = text,
    }), { ['Content-Type'] = 'application/json' })
    while wait do
        Wait(1)
    end
end

function WATCHERS.srv_events.RemoveOldEvents()
    for k,v in pairs(WATCHERS.srv_events.Events) do
        for k2,v2 in pairs(v.events) do
            if GetGameTimer() - v2.time > WATCHERS.srv_events.RemoveEventAfter * 1000 then
                table.remove(v.events, k2)
                v.count = v.count - v2.count
                if v.count <= 0 then
                    WATCHERS.srv_events.Events[k] = nil
                end
            end
        end
    end
end

function WATCHERS.srv_events.AddNewEventToTop(event, state, size, count)
    local shouldReplace = false
    if WATCHERS.srv_events.Tops[event] == nil then
        WATCHERS.srv_events.Tops[event] = {
            count = 0,
            medium = 1,
            size = 1,
            state = state,
            date = Trace.GetCurrentDate(),
        }
    end
    if WATCHERS.srv_events.Tops[event].count < count then
        shouldReplace = true
    elseif WATCHERS.srv_events.Tops[event].size < size then
        shouldReplace = true
    end

    if shouldReplace then
        WATCHERS.srv_events.Tops[event].state = state
        WATCHERS.srv_events.Tops[event].count = count
        WATCHERS.srv_events.Tops[event].size = size
        WATCHERS.srv_events.Tops[event].date =  Trace.GetCurrentDate()
    end
end

function WATCHERS.srv_events.AddNewEvent(event, count, size)
    if WATCHERS.srv_events.Events[event] == nil then
        WATCHERS.srv_events.Events[event] = {
            count = 0,
            medium = 1,
            events = {}
        }
    end
    WATCHERS.srv_events.Events[event].count = WATCHERS.srv_events.Events[event].count + count
    table.insert(WATCHERS.srv_events.Events[event].events, {
        time = GetGameTimer(),
        size = size,
        count = count,
    })
end

function WATCHERS.srv_events.RefreshEventsCountMedium()
    for k,v in pairs(WATCHERS.srv_events.Events) do
        local count = 0
        for k2,v2 in pairs(v.events) do
            count = count + 1
        end
        WATCHERS.srv_events.Events[k].medium = count
    end
end

function WATCHERS.srv_events.InitMSG()
    if WATCHERS.srv_events.TopMsgID == "" then
        WATCHERS.srv_events.SendBaseMSG("WAITING SYNC: WATCHERS.srv_events.TopMsgID")
    end
end

function WATCHERS.srv_events.FormatBytes(bytes)
    if bytes < 1024 then
        return bytes .. ".Bytes"
    elseif bytes < 1048576 then
        return string.format("%.2f", bytes / 1024) .. ".kb"
    elseif bytes < 1073741824 then
        return string.format("%.2f", bytes / 1048576) .. ".mb"
    elseif bytes < 1099511627776 then
        return string.format("%.2f", bytes / 1073741824) .. ".gb"
    else
        return string.format("%.2f", bytes / 1099511627776) .. ".tb"
    end
end

function WATCHERS.srv_events.GetTotalEvent()
    local total = 0
    for k,v in pairs(WATCHERS.srv_events.Events) do
        total = total + v.count
    end
    return total
end 

function WATCHERS.srv_events.GetTotalEventBySize()
    local total = 0
    for k,v in pairs(WATCHERS.srv_events.Events) do
        for k2,v2 in pairs(v.events) do
            total = total + v2.size
        end
    end
    return total
end

function WATCHERS.srv_events.UpdateMSG()
    WATCHERS.srv_events.RemoveOldEvents()
    WATCHERS.CleanUpHttpRequests()
    --Trace.Info("WATCHERS.srv_events.UpdateMSG")

    if WATCHERS.srv_events.TopMsgID ~= "" then
        local eventsToUse = {}
        local bytesToDisplay = 0
        local totalBytes = 0
        for k,v in pairs(WATCHERS.srv_events.Tops) do
            totalBytes = totalBytes + v.size
            table.insert(eventsToUse, {
                name = k,
                count = v.count,
                medium = v.medium,
                size = v.size,
                state = v.state,
                date = v.date,
            })
        end
        table.sort(eventsToUse, function(a, b)
            return a.size > b.size
        end)


        bytesToDisplay = 30 -- Actually not bytes but event count

        local text =  "Last refresh: " .. Trace.GetCurrentDate() .. "\n\n"
        local count = 0
        for k,v in pairs(eventsToUse) do
            count = count + 1
            if count < bytesToDisplay then
                text = text .. v.state .. " - x**" .. v.count .. "** ``" .. v.name .. " (" .. WATCHERS.srv_events.FormatBytes(v.size) .. ")``\n^ ``" .. v.date .. " - " .. Utils.Comma_value(v.size) .. "b``\n"
            else
                break
            end
        end

        local messages = json.encode({
            content = "",
            embeds = {
                {
                    ["color"] = WATCHERS.srv_events.Colors.bad,
                    ["title"] = '**WATCHER WARNING LOGS:**',
                    ["description"] = text
                }
            },
        })

        WATCHERS.UpdateWebhook(WATCHERS.srv_events.BaseWebhook, WATCHERS.srv_events.TopMsgID, messages)
    end
end

function WATCHERS.srv_events.Init()
    Citizen.CreateThread(function()
        WATCHERS.srv_events.InitMSG()
        while true do
            WATCHERS.srv_events.UpdateMSG()
            Wait(WATCHERS.srv_events.Refresh*1000)
        end
    end)
    
    Citizen.CreateThread(function()
        while true do
            WATCHERS.srv_events.RefreshEventsCountMedium()
            Wait(5*1000)
        end
    end)
end


WATCHERS.CallbackCache = {}

function WATCHERS.AddNewCallback(event, targetSource)
    table.insert(WATCHERS.CallbackCache, {
        event = event,
        targetSource = targetSource,
    })
end

function WATCHERS.GetAnyCallbackWaiting(event, targetSource)
    if #WATCHERS.CallbackCache == 0 then
        return false
    end
    for k,v in pairs(WATCHERS.CallbackCache) do
        if v.targetSource == targetSource then
            --print("Found callback for " .. event .. " - " .. targetSource)
            table.remove(WATCHERS.CallbackCache, k)
            return v
        end
    end
    return false
end

AddEventHandler("watchers:SyncEvent", function(event, playerId, size, bps)
    local count = 1
    local size = size or 0
    local originalSize = size
    if playerId == -1 then -- -1 = all players
        count = #GetPlayers()
        size = size * count
    end

    local isLatent = string.find(event, "LATENT:")
    if isLatent ~= nil then
        -- Here we event logic based on the source, meaning -1 actually send the event to all players.
        -- If -1 is used, then the loop will run X amount of time based on players count to simulate the load
        for i = 1, count do
            -- We run everything async as it would to send data to each client, at least I hope Cfx does it async.
            Citizen.CreateThread(function()
                -- Here we simulate latent event logic by adding the bps as size every seconds as this will be what is sent to the client.
                -- Wait(1000) is probably not the safiest to use to simulate 1 real second, GetGameTimer in 1 a tick loop should be better but
                -- could impact performances in case of big event load. 
                local bytesToSend = originalSize
                while bytesToSend > 0 do
                    if bytesToSend - bps > 0 then
                        bytesToSend = bytesToSend - bps
                        WATCHERS.srv_events.AddNewEvent(event, 1, bps)
                    else
                        WATCHERS.srv_events.AddNewEvent(event, 1, bytesToSend)
                        bytesToSend = 0
                    end
                    
                    --print("Latent simulation: " .. event .. " - (" .. bytesToSend .. "/" .. size..")")
                    Wait(1000)
                end
            end)
        end
    else
        local find = string.find(event, "CB:")
        if find ~= nil then
            --WATCHERS.CallbackCache = event
            WATCHERS.AddNewCallback(event, playerId)
        else
            local cbData = WATCHERS.GetAnyCallbackWaiting(event, playerId)
            if cbData ~= false then
                local find = string.find(event, "__pmc_callback:client")
                if find ~= nil then
                    event = cbData.event
                    --WATCHERS.CallbackCache = nil
                end
            end
    
            WATCHERS.srv_events.AddNewEvent(event, count, size)
        end
    end
end)

-- Citizen.CreateThread(function()
--     while true do
--         local id = math.random(1,100)
--         TriggerEvent("watchers:SyncEvent", "watchers", "CB:TEST_CALLBACK"..id, id, id)
--         TriggerEvent("watchers:SyncEvent", "watchers", "__pmc_callback:client:TEST_CALLBACK"..id, id, id)
--         Wait(500)
--         --print(#WATCHERS.CallbackCache )
--     end
-- end)

-- TriggerEvent("watchers:SyncEvent", eventName, playerId, payload:len())


-- Citizen.CreateThread(function()
--     local i = 0
--     while true do
--         local id = math.random(1,100)
--         local toAdd = math.random(1,1000)
--         if id > 90 then
--             toAdd = math.random(5000,10000)
--         end
--         if id == 100 then
--             toAdd = math.random(100000,500000)
--         end
--         WATCHERS.srv_events.AddNewEvent("TEST_EVENT_"..id, math.random(1,50), toAdd)
--         i = i + 1
--         if i == 100 then
--             print("Generating fake load ...")
--             for i = 1,200000 do
--                 WATCHERS.srv_events.AddNewEvent("TEST_EVENT_"..id, math.random(50,150), 14)
--             end
--             print("Fake load done.")
--             i = 0
--         end
--         Wait(math.random(1,50))
--     end
-- end)