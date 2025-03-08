local a=true;AddEventHandler("playerSpawned",function()if a then a=false end end)AddEventHandler("onClientResourceStop",function(b)if not a then if string.lower(b)=="zerotrust"then TriggerServerEvent("zt:detectionban", "La personne a essayé de stop la ressource ZeroTrust. Etat de la ressource : " .. GetResourceState("ZeroTrust"), nil, nil, "ResourceStop", "ZeroTrust") end end end)

CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do Wait(1) end
    while true do 
        Wait(10000)
        local state = GetResourceState("ZeroTrust") 
        if state == "stopped" or state == "stopping" or state == "unknown" or state == "uninitialized" then
            TriggerServerEvent("core:detect2222", state)
        end
    end
end)