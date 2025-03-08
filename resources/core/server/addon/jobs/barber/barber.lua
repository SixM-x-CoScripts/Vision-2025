RegisterNetEvent("core:SendUpdateHairToServ1")
AddEventHandler("core:SendUpdateHairToServ1", function(token, data, playerSelected)
    if tonumber(playerSelected) == 0 then return end
    if CheckPlayerToken(source, token) then
        TriggerClientEvent("core:InreractWithBarber2", tonumber(playerSelected), data)
    end
end)

RegisterNetEvent("core:SendUpdateHairToServCayo")
AddEventHandler("core:SendUpdateHairToServCayo", function(token, data, playerSelected)
    if tonumber(playerSelected) == 0 then return end
    if CheckPlayerToken(source, token) then
        TriggerClientEvent("core:InreractWithBarbercayo", tonumber(playerSelected), data)
    end
end)

RegisterNetEvent("core:SendUpdateHairToServ2")
AddEventHandler("core:SendUpdateHairToServ2", function(token, data, playerSelected)
    if playerSelected == 0 then return end
    if CheckPlayerToken(source, token) then
        TriggerClientEvent("core:InreractWithBarber1", playerSelected, data)
    end
end)

RegisterNetEvent("core:PlacePlayerOnSeat")
AddEventHandler("core:PlacePlayerOnSeat", function(token, playerSelected, data)
    if CheckPlayerToken(source, token) then
        TriggerClientEvent("core:PlacePlayerOnSeatClient", playerSelected, data)
    end
end)


RegisterNetEvent("core:ExitPlayerOnSeatSRV")
AddEventHandler("core:ExitPlayerOnSeatSRV", function(token, playerSelected, data)
    if CheckPlayerToken(source, token) then
        TriggerClientEvent("core:ExitPlayerOnSeatClient", playerSelected, data)
    end
end)

RegisterNetEvent("core:applySkinBarberSRV")
AddEventHandler("core:applySkinBarberSRV", function(token, playerSelected, changedData)
    if tonumber(playerSelected) == 0 then return end
    if CheckPlayerToken(source, token) then
        TriggerClientEvent("core:applySkinBarberClient", playerSelected, changedData)
    end
end)