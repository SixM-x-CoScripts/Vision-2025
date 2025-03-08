WATCHERS.Network = {}

WATCHERS.Network.Webhook = CONFIG.Webhooks.baseWatcher
WATCHERS.Network.MsgID = CONFIG.MessageID.network

function WATCHERS.Network.InitMSG()
    if WATCHERS.Network.MsgID == "" then
        WATCHERS.srv_events.SendBaseMSG("WAITING SYNC: Network", WATCHERS.Network.Webhook)
    end
end

function WATCHERS.Network.Run()
    if WATCHERS.Network.MsgID ~= "" then
        local mediumTotal = WATCHERS.srv_events.GetTotalEvent()
        local totalBytes = 0
        local bytesToDisplay = 0
        local color = WATCHERS.srv_events.Colors.good
        local state = ""
        local eventsToUse = {}
        for k,v in pairs(WATCHERS.srv_events.Events) do
            local totalSize = 0
            for _,v2 in pairs(v.events) do
                totalSize = totalSize + v2.size
            end
            totalBytes = totalBytes + totalSize
            table.insert(eventsToUse, {
                name = k,
                count = v.count,
                medium = v.medium,
                size = totalSize,
            })
        end
        table.sort(eventsToUse, function(a,b)
            return a.size > b.size
        end)

        bytesToDisplay = 30 -- Actually not bytes but event count

        --print(bytesToDisplay)

        local message = "Last refresh: " .. Trace.GetCurrentDate() .. "\nBytes sent last 60s: **".. WATCHERS.srv_events.FormatBytes(totalBytes) .."**\nEvents last 60s: **".. Utils.Comma_value(mediumTotal) .."**\n(🟢): Good\n(🟠): Warning\n(🔴): Critical\n(⚫): KO or CAUSING LAG\n\n"
        local count = 0
        for k,v in pairs(eventsToUse) do
            count = count + 1
            if count < bytesToDisplay then
                if v.size > bytesToDisplay then
                    if v.size > 1000000 * 3 then -- KO
                        state = "(⚫)"
                        color = WATCHERS.srv_events.Colors.bad
                        WATCHERS.srv_events.AddNewEventToTop(v.name, state, v.size, v.count)
                    elseif v.size > 1000000 then
                        state = "(🔴)"
                        color = WATCHERS.srv_events.Colors.bad
                        WATCHERS.srv_events.AddNewEventToTop(v.name, state, v.size, v.count)
                    elseif v.size > 500000 then
                        state = "(🟠)"
                        color = WATCHERS.srv_events.Colors.medium
                        WATCHERS.srv_events.AddNewEventToTop(v.name, state, v.size, v.count)
                    else
                        state = "(🟢)"
                        color = WATCHERS.srv_events.Colors.good
                        WATCHERS.srv_events.AddNewEventToTop(v.name, state, v.size, v.count)
                    end
                    message = message .. state .. " - x**" .. v.count .. "** `" .. v.name .. " (".. WATCHERS.srv_events.FormatBytes(v.size) .. ")`\n"
                end
            else
                break
            end
        end

        local messages = json.encode({
            content = "",
            embeds = {
                {
                    ["color"] = color,
                    ["title"] = '**NETWORK WATCHER:**',
                    ["description"] = message
                }
            },
        })

        WATCHERS.UpdateWebhook(WATCHERS.Network.Webhook, WATCHERS.Network.MsgID, messages)
    end
end

function WATCHERS.Network.Init()
    Citizen.CreateThread(function()
        WATCHERS.Network.InitMSG()
        while true do
            WATCHERS.Network.Run()
            Wait(5*1000)
        end
    end)
end
