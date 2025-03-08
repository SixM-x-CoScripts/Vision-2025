CreateThread(function()
    while not NetworkIsSessionStarted() do Wait(1) end 
    while not NetworkIsPlayerActive(PlayerId()) do Wait(1) end
    Wait(2000)
    while not p do Wait(1) end
    local isInSouth = coordsIsInSouth(GetEntityCoords(PlayerPedId()))
    TriggerServerEvent("core:RegisterPlayer", p:getCrew(), p:getJob(), isInSouth)
    while true do 
        Wait(2*60000)
        local isInSouth = coordsIsInSouth(GetEntityCoords(PlayerPedId()))
        TriggerServerEvent("core:RegisterPlayer", p:getCrew(), p:getJob(), isInSouth)
    end
end)


RegisterNetEvent("core:changedname", function(prenom, nom)
    p:setLastname(nom)
    p:setFirstname(prenom)
end)