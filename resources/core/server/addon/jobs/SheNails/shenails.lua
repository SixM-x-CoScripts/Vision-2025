RegisterNetEvent("core:SheNailsPlacePlayerOnSeatSRV")
AddEventHandler("core:SheNailsPlacePlayerOnSeatSRV", function(token, player, info)
    local src = source
    if CheckPlayerToken(src, token) then
     --   print(info)
        TriggerClientEvent("core:SheNailsPlacePlayerOnSeat", player, info)
    end
end)

RegisterNetEvent("core:Menu_manucure_preview_callbackSRV")
AddEventHandler("core:Menu_manucure_preview_callbackSRV", function(token, player, info)
    local src = source
    if CheckPlayerToken(src, token) then
       -- print(info)
        TriggerClientEvent("core:Menu_manucure_preview_callback", tonumber(player), info)
    end
end)

RegisterNetEvent("core:Menu_manucure_achat_callbackSRV")
AddEventHandler("core:Menu_manucure_achat_callbackSRV", function(token, player, info)
    local src = source
    if player == 0 then return end
    if CheckPlayerToken(src, token) then
    --    print(info)
        TriggerClientEvent("core:Menu_manucure_achat_callback", tonumber(player), info)
    end
end)

RegisterNetEvent("core:SheNailsRemovePlayerOnSeatSRV")
AddEventHandler("core:SheNailsRemovePlayerOnSeatSRV", function(token, player)
    local src = source
    if CheckPlayerToken(src, token) then
        TriggerClientEvent("core:SheNailsRemovePlayerOnSeat", player)
    end
end)