RegisterNetEvent('core:setPedStaff')
AddEventHandler('core:setPedStaff', function(token, player, ped)
    if CheckPlayerToken(source, token) then
        TriggerClientEvent("core:setPedStaff", player, ped)
    end
end)

RegisterNetEvent("Gabz:server:UpdateMBALocation", function(map)
    GlobalState['mba:map'] = map
    TriggerClientEvent("Gabz:client:UpdateMBALocation", -1, map)
end)

RegisterNetEvent("core:vadmin:message:chiant")
AddEventHandler("core:vadmin:message:chiant", function(token, id, title, message)
    if CheckPlayerToken(source, token) then
        TriggerClientEvent("core:vadmin:message:chiant", id, { title = title, message = message })
    end
end)

--RegisterNetEvent("updatespFreq", function(job, freq)
--    local alrdSet = false
--
--    MySQL.Async.fetchAll("SELECT * FROM frequency", {}, function(result)
--        if result[1] ~= nil then
--            for k, v in pairs(result) do
--                if tostring(v.job) == tostring(job) then
--                    alrdSet = true
--                end
--            end
--        end
--    end)
--
--    Wait(2000)
--    if alrdSet then
--        MySQL.Async.execute("UPDATE frequency SET freq = @freq WHERE job = @job",{
--            ['@freq'] = freq,
--            ['@job'] = job,
--        })
--    else
--        MySQL.Async.execute("INSERT INTO `frequency` (`job`, `freq`) VALUES (@job, @freq)",{
--            ['@freq'] = freq,
--            ['@job'] = job,
--        })
--    end
--    sp_switchFrequence[job] = freq
--
--    
--end)