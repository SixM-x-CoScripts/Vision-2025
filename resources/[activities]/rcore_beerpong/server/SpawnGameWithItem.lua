if Config.Framework == "1" or Config.Framework == "2" then
    ESX.RegisterUsableItem(Config.ItemName, function(source)
        TriggerClientEvent("rcore_beerpong:startEditGame", source)
    end)

    RegisterNetEvent(TriggerName("RemoveCupSet"), function() 
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem(Config.ItemName, 1)
    end)
end