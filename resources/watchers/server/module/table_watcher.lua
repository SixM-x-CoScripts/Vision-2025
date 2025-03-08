WATCHERS.Table = {}
WATCHERS.Table.List = {}

WATCHERS.Table.Webhook = CONFIG.Webhooks.table
WATCHERS.Table.MsgID = CONFIG.MessageID.table

function WATCHERS.Table.InitMSG()
    if WATCHERS.Table.MsgID == "" then
        WATCHERS.srv_events.SendBaseMSG("WAITING SYNC: Table", WATCHERS.Table.Webhook)
    end

end

function WATCHERS.Table.SetTableInfo(table_name, table_data)
    WATCHERS.Table.List[table_name] = table_data
end

function WATCHERS.Table.Run()
    if WATCHERS.Table.MsgID ~= "" then


        local message = "Last refresh: " .. Trace.GetCurrentDate()
        local formatedCoreRamUsed, formatedCoreRamUsedUnit = WATCHERS.Dashboard.FormatCollectorBytes(WATCHERS.Dashboard.CoreRamUsed)
        local message = message .. "\n**Server player count**: "..#GetPlayers()
        message = message .. "\n**Core RAM used**: " ..formatedCoreRamUsed .. " " .. formatedCoreRamUsedUnit
        message = message .. "\n\n**Table list**:"
        local cache = {}

        for name,tables in pairs(WATCHERS.Table.List) do
            --message = message .. "\n[**"..name.."**]"
            local count = 0
            if type(tables) == "table" then
                for k,v in pairs(tables) do
                    count = count + 1
                end
            else
                count = tables
            end
            --message = message .. " - data count: ``"..count.."``"
            local temps = {}
            temps.name = name
            temps.count = count
            table.insert(cache, temps)
        end

        table.sort(cache, function(a, b)
            return a.count > b.count
        end)

        for name,table in pairs(cache) do
            message = message .. "\n[**"..table.name.."**]"
            message = message .. " - data count: ``"..table.count.."``"
        end

        local message_to_send = json.encode({
            content = "",
            embeds = {
                {
                    ["color"] = WATCHERS.srv_events.Colors.good,
                    ["title"] = '**Table watcher:**',
                    ["description"] = message
                }
            },
        })
        WATCHERS.UpdateWebhook(WATCHERS.Table.Webhook, WATCHERS.Table.MsgID, message_to_send)
    end
end

function WATCHERS.Table.Init()
    Citizen.CreateThread(function()
        WATCHERS.Table.InitMSG()
        while true do
            WATCHERS.Table.Run()
            Wait(5*1000)
        end
    end)
end


AddEventHandler("watcher:server:SendTableInfo", function(table_name, table_data)
    WATCHERS.Table.SetTableInfo(table_name, table_data)
end)

-- Citizen.CreateThread(function()
--     while true do
--         for i=1, 50 do
--             local dataTable = {}
--             for y = 1, math.random(1,100) do
--                 table.insert(dataTable, y)
--             end
--             TriggerEvent("watcher:server:SendTableInfo", "test"..i, dataTable)
--             Wait(50)
--         end
--         Wait(50)
--     end
-- end)