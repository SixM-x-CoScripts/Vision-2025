CreateThread(function()
    local finished = false
    local sentNotif = false
    while true do 
        Wait(500)
        if finished then Wait(7000) finished = false end

        if IsPedArmed(PlayerPedId(), 4) and not finished then
            if IsPedOnFoot(PlayerPedId()) then
                for veh in EnumerateVehicles() do
                    local vehCoords = GetEntityCoords(veh)
                    local distance = GetEntityCoords(PlayerPedId()) - vehCoords

                    if #(distance) < 10 then

                        if IsPlayerFreeAiming(PlayerId()) then 

                            if IsLookingAtCoords(vehCoords.x, vehCoords.y, vehCoords.z, 30) then 

                                if GetPedInVehicleSeat(veh, -1) ~= 0 then 

                                    local ped = GetPedInVehicleSeat(veh, -1)
                                    SetEntityAsMissionEntity(ped, true, true)
                                    NetworkRequestControlOfEntity(ped)
                                    local timer = 1
                                    while not NetworkHasControlOfEntity(ped) and timer < 150 do 
                                        Wait(1) 
                                        timer += 1
                                    end
                                    SetEntityAsMissionEntity(ped, true, true)
                                    
                                    
                                    local escapeChance = math.random(1, 3) 
                                    if escapeChance <= 1 or p:getJob() ~= "lspd" or p:getJob() ~= "lssd" or p:getJob() ~= "usss" then

                                        if p:getJob() ~= "lspd" or p:getJob() ~= "lssd" or p:getJob() ~= "usss" then
                                            if not sentNotif then
                                                TriggerSecurEvent('core:makeCall', "lspd", p:pos(), true, "Tentative de car-jacking à main armée", false, "illegal")
                                                TriggerSecurEvent('core:makeCall', "lssd", p:pos(), true, "Tentative de car-jacking à main armée", false, "illegal")
                                                sentNotif = true
                                            end
                                        end

                                        SetVehicleDoorsLocked(veh, 0)
                                        SetVehicleDoorsLockedForAllPlayers(veh, false)
                                        SetVehicleDoorsLockedForPlayer(veh, PlayerPedId(), false)
                                        TaskLeaveVehicle(ped, veh, 1)
                                        finished = true
                                        Wait(50000)
                                    else
                                        Wait(3000)
                                    end
                                end
                            end
                        end
                    end                
                end
            end
        else
            Wait(5000)
        end

        sentNotif = false
    end
end)