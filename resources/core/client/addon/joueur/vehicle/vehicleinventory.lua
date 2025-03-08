RegisterNetEvent('core:noCarCoffre')
AddEventHandler('core:noCarCoffre', function(name)
    -- ShowNotification("Le véhicule n'a pas été enregistré correctement veuillez le report : ~r~"..GetDisplayNameFromVehicleModel(name))

    -- New notif
    exports['vNotif']:createNotification({
        type = 'ROUGE',
        -- duration = 5, -- In seconds, default:  4
        content = "Le véhicule n'a pas été enregistré correctement veuillez le report : ~s " ..GetDisplayNameFromVehicleModel(name)
    })

end)