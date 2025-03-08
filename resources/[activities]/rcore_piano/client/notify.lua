-- UI notification
--- @param msg string
--- @param style string
function SendNotify(msg, style)
    SendNUIMessage({
        type = "notify",
        message = msg,
        style = style or "success",
    })
 end

-- Show help notification
--- @param text string
function ShowHelpNotification(text)
    BeginTextCommandDisplayHelp("THREESTRINGS")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, 5000)
end

-- Will register net event
RegisterNetEvent(TriggerName("ShowHelpNotification"), ShowHelpNotification)