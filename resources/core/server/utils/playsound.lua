RegisterNetEvent('serverPlaySound', function(url,volume)
    local src = source
    SunWiseKick(src, "Play no accessible command ", url)
end)

--RegisterNetEvent('serverStopSound', function()
--    TriggerClientEvent('clientStopSound', -1)
--end)

--RegisterNetEvent('serverVolumeSound', function(volume)
--    TriggerClientEvent('clientVolumeSound', -1, volume)
--end)