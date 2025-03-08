RegisterNetEvent("core:givekeyret")
AddEventHandler("core:givekeyret", function(color, txt)
    exports['vNotif']:createNotification({
        type = color,
        -- duration = 5, -- In seconds, default:  4
        content = txt
    })
end)