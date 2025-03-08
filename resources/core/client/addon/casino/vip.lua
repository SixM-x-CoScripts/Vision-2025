local goingto = false
CreateThread(function()
    while true do 
        Wait(1)
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
        if z < 30.0 then 
            if GetDistanceBetweenCoords(1124.0949707031, 249.99464416504, -51.040802001953, x,y,z) < 3.5 then 
                if p:getPermission() == 0 and (not goingto) then 
                    goingto = true
                    TaskGoToCoordAnyMeans(PlayerPedId(), 1120.6115722656, 252.76182556152, -51.379760742188, 1.0, 0, 0, 786603, 0)
                    CasinoConfig.ShowNotification(CasinoConfigSH.Lang.MustBeVip)
                end
            else
                goingto = false
            end
            
            if GetDistanceBetweenCoords(1131.6708984375, 242.25399780273, -51.040790557861, x,y,z) < 3.5 then 
                if p:getPermission() == 0 and (not goingto2) then 
                    goingto2 = true
                    TaskGoToCoordAnyMeans(PlayerPedId(), 1134.6273193359, 238.95390319824, -51.019390106201, 1.0, 0, 0, 786603, 0)
                    CasinoConfig.ShowNotification(CasinoConfigSH.Lang.MustBeVip)
                end
            else
                goingto2 = false
            end
        else
            Wait(5000)
        end
    end
end)