WATCHERS.Saturation = {}

WATCHERS.Saturation.Webhook = CONFIG.Webhooks.baseWatcher
WATCHERS.Saturation.MsgID = CONFIG.MessageID.count

function WATCHERS.Saturation.InitMSG()
    if WATCHERS.Saturation.MsgID == "" then
        WATCHERS.srv_events.SendBaseMSG("WAITING SYNC: saturation", WATCHERS.Saturation.Webhook)
    end
end

function WATCHERS.Saturation.Run()
    if WATCHERS.Saturation.MsgID ~= "" then
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
            return a.count > b.count
        end)


        bytesToDisplay = 30 -- Actually not bytes but event count
        

        --print(bytesToDisplay)

        local message = "Last refresh: " .. Trace.GetCurrentDate() .. "\nBytes sent last 60s: **".. WATCHERS.srv_events.FormatBytes(totalBytes) .."**\nEvents last 60s: **".. Utils.Comma_value(mediumTotal) .."**\n(🟢): Good\n(🟠): Warning\n(🔴): Critical\n(⚫): KO or CAUSING LAG\n\n"
        for k,v in pairs(eventsToUse) do
            if k < bytesToDisplay then
                if v.count > 50000 then -- Add new status really critical
                    state = "(⚫)"
                    color = WATCHERS.srv_events.Colors.bad
                    WATCHERS.srv_events.AddNewEventToTop(v.name, state, v.size, v.count)
                elseif v.count > 20000 then -- Add new status really critical
                    state = "(🔴)"
                    color = WATCHERS.srv_events.Colors.bad
                    WATCHERS.srv_events.AddNewEventToTop(v.name, state, v.size, v.count)
                elseif v.count > 10000 then
                    state = "(🟠)"
                    color = WATCHERS.srv_events.Colors.medium
                    WATCHERS.srv_events.AddNewEventToTop(v.name, state, v.size, v.count)
                else
                    state = "(🟢)"
                    
                end
                message = message .. state .. " - x**" .. v.count .. "** `" .. v.name .. " (".. WATCHERS.srv_events.FormatBytes(v.size) .. ")`\n"
            else
                break
            end
        end

        local messages = json.encode({
            content = "",
            embeds = {
                {
                    ["color"] = color,
                    ["title"] = '**SATURATION WATCHER:**',
                    ["description"] = message
                }
            },
        })

        WATCHERS.UpdateWebhook(WATCHERS.Saturation.Webhook, WATCHERS.Saturation.MsgID, messages)
    end
end

function WATCHERS.Saturation.Init()
    Citizen.CreateThread(function()
        WATCHERS.Saturation.InitMSG()
        while true do
            WATCHERS.Saturation.Run()
            Wait(5*1000)
        end
    end)
end
