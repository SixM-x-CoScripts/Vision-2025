local doorOpen = false

function OpenDoor()
    player = PlayerPedId()
    veh = GetVehiclePedIsIn(player)
    vehName = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
    
    
    if vehName == 'BUS' or vehName == 'BUS4' and p:getJob() == 'lst' then
        if not doorOpen then
            for i = 0, 3 do
                SetVehicleDoorOpen(veh, i, false, false)
            end
            doorOpen = true
        else
            for i = 0, 3 do
                SetVehicleDoorShut(veh, i, false)
            end
            doorOpen = false
        end
    end

end

lineActive = false


function CancelLineLST()
    lineActive = false

    exports['vNotif']:createNotification({
        type = 'BLEU',
        content = "Vous avez annulé votre ligne."
    })
end

function AactionLineR()
    if lstDuty then
        local year , month , day , starthour , startminute , second  = GetLocalTime()
        local startTime = starthour..':'..startminute

        lineActive = true
        local cooStop = choiceLine.aller.red.Stop_1
        while lineActive do
            cooPlayer = GetEntityCoords(PlayerPedId())
            SetNewWaypoint(cooStop)
            
            distPlayerStop = GetDistanceBetweenCoords(cooPlayer, cooStop, false)
            if distPlayerStop < 50 then
                if cooStop == choiceLine.aller.red.Stop_1 then
                    cooStop = choiceLine.aller.red.Stop_2
                elseif cooStop == choiceLine.aller.red.Stop_2 then
                    cooStop = choiceLine.aller.red.Stop_3    
                elseif cooStop == choiceLine.aller.red.Stop_3 then
                    cooStop = choiceLine.aller.red.Stop_4
                elseif cooStop == choiceLine.aller.red.Stop_4 then
                    cooStop = choiceLine.aller.red.Stop_5    
                elseif cooStop == choiceLine.aller.red.Stop_5 then
                    cooStop = choiceLine.aller.red.Stop_6
                elseif cooStop == choiceLine.aller.red.Stop_6 then
                    cooStop = choiceLine.aller.red.Stop_7    
                elseif cooStop == choiceLine.aller.red.Stop_7 then
                    cooStop = choiceLine.aller.red.Stop_8
                elseif cooStop == choiceLine.aller.red.Stop_8 then
                    cooStop = choiceLine.aller.red.Stop_9    
                elseif cooStop == choiceLine.aller.red.Stop_9 then
                    cooStop = choiceLine.aller.red.Stop_10
                elseif cooStop == choiceLine.aller.red.Stop_10 then
                    cooStop = choiceLine.aller.red.Stop_11   
                elseif cooStop == choiceLine.aller.red.Stop_11 then
                    cooStop = choiceLine.aller.red.Stop_12
                elseif cooStop == choiceLine.aller.red.Stop_12 then
                    cooStop = choiceLine.aller.red.Stop_13    
                elseif cooStop == choiceLine.aller.red.Stop_13 then
                    goto stoparret
                end
            end
            Wait(1)
        end
        ::stoparret::

        if lineActive then
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez fini la ligne rouge. Vous avez rapporter 300$ à votre entreprise."
            })
            local year , month , day , stophour , stopminute , second  = GetLocalTime()
            local stopTime = stophour..':'..stopminute
    
            local ligne = 'rouge (aller)'
            TriggerServerEvent('lstDiscordLog', ligne, startTime, stopTime)
    
            TriggerServerEvent('giveMoneyLst')
        end
        lineActive = false
        
        
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Vous devez ~s prendre votre service et être dans un bus"
        })
    end
end
function AactionLineG()
    if lstDuty then
        local year , month , day , starthour , startminute , second  = GetLocalTime()
        local startTime = starthour..':'..startminute

        lineActive = true
        local cooStop = choiceLine.aller.green.Stop_1
        while lineActive do
            
            cooPlayer = GetEntityCoords(PlayerPedId())
            SetNewWaypoint(cooStop)
            
            distPlayerStop = GetDistanceBetweenCoords(cooPlayer, cooStop, false)
            if distPlayerStop < 50 then
                if cooStop == choiceLine.aller.green.Stop_1 then
                    cooStop = choiceLine.aller.green.Stop_2
                elseif cooStop == choiceLine.aller.green.Stop_2 then
                    cooStop = choiceLine.aller.green.Stop_3    
                elseif cooStop == choiceLine.aller.green.Stop_3 then
                    cooStop = choiceLine.aller.green.Stop_4
                elseif cooStop == choiceLine.aller.green.Stop_4 then
                    cooStop = choiceLine.aller.green.Stop_5    
                elseif cooStop == choiceLine.aller.green.Stop_5 then
                    cooStop = choiceLine.aller.green.Stop_6
                elseif cooStop == choiceLine.aller.green.Stop_6 then
                    cooStop = choiceLine.aller.green.Stop_7    
                elseif cooStop == choiceLine.aller.green.Stop_7 then
                    cooStop = choiceLine.aller.green.Stop_8
                elseif cooStop == choiceLine.aller.green.Stop_8 then
                    cooStop = choiceLine.aller.green.Stop_9    
                elseif cooStop == choiceLine.aller.green.Stop_9 then
                    cooStop = choiceLine.aller.green.Stop_10
                elseif cooStop == choiceLine.aller.green.Stop_10 then
                    cooStop = choiceLine.aller.green.Stop_11   
                elseif cooStop == choiceLine.aller.green.Stop_11 then
                    cooStop = choiceLine.aller.green.Stop_12
                elseif cooStop == choiceLine.aller.green.Stop_12 then
                    cooStop = choiceLine.aller.green.Stop_13    
                elseif cooStop == choiceLine.aller.green.Stop_13 then
                    cooStop = choiceLine.aller.green.Stop_14 
                elseif cooStop == choiceLine.aller.green.Stop_14 then
                    cooStop = choiceLine.aller.green.Stop_15
                elseif cooStop == choiceLine.aller.green.Stop_15 then
                    cooStop = choiceLine.aller.green.Stop_16    
                elseif cooStop == choiceLine.aller.green.Stop_16 then
                    cooStop = choiceLine.aller.green.Stop_17
                elseif cooStop == choiceLine.aller.green.Stop_17 then
                    cooStop = choiceLine.aller.green.Stop_18    
                elseif cooStop == choiceLine.aller.green.Stop_18 then
                    cooStop = choiceLine.aller.green.Stop_19
                elseif cooStop == choiceLine.aller.green.Stop_19 then
                    cooStop = choiceLine.aller.green.Stop_20    
                elseif cooStop == choiceLine.aller.green.Stop_20 then
                    cooStop = choiceLine.aller.green.Stop_21
                elseif cooStop == choiceLine.aller.green.Stop_21 then
                    cooStop = choiceLine.aller.green.Stop_22    
                elseif cooStop == choiceLine.aller.green.Stop_22 then
                    cooStop = choiceLine.aller.green.Stop_23
                elseif cooStop == choiceLine.aller.green.Stop_23 then
                    cooStop = choiceLine.aller.green.Stop_24   
                elseif cooStop == choiceLine.aller.green.Stop_24 then
                    cooStop = choiceLine.aller.green.Stop_25
                elseif cooStop == choiceLine.aller.green.Stop_25 then
                    cooStop = choiceLine.aller.green.Stop_26    
                elseif cooStop == choiceLine.aller.green.Stop_26 then
                    cooStop = choiceLine.aller.green.Stop_27
                elseif cooStop == choiceLine.aller.green.Stop_27 then
                    cooStop = choiceLine.aller.green.Stop_28    
                elseif cooStop == choiceLine.aller.green.Stop_28 then
                    cooStop = choiceLine.aller.green.Stop_29  
                elseif cooStop == choiceLine.aller.green.Stop_29 then
                    goto stoparret
                end
            end
            Wait(1)
        end
        ::stoparret::
        if lineActive then
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez fini la ligne verte. Vous avez rapporter 300$ à votre entreprise."
            })
            local year , month , day , stophour , stopminute , second  = GetLocalTime()
            local stopTime = stophour..':'..stopminute
    
            local ligne = 'verte (aller)'
            TriggerServerEvent('lstDiscordLog', ligne, startTime, stopTime)
    
            TriggerServerEvent('giveMoneyLst')
        end
        lineActive = false
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Vous devez ~s prendre votre service et être dans un bus"
        })
    end
end
function AactionLineB()
    if lstDuty then
        local year , month , day , starthour , startminute , second  = GetLocalTime()
        local startTime = starthour..':'..startminute

        lineActive = true
        local cooStop = choiceLine.aller.blue.Stop_1
        while lineActive do
            
            cooPlayer = GetEntityCoords(PlayerPedId())
            SetNewWaypoint(cooStop)
            
            distPlayerStop = GetDistanceBetweenCoords(cooPlayer, cooStop, false)
            if distPlayerStop < 50 then
                if cooStop == choiceLine.aller.blue.Stop_1 then
                    cooStop = choiceLine.aller.blue.Stop_2
                elseif cooStop == choiceLine.aller.blue.Stop_2 then
                    cooStop = choiceLine.aller.blue.Stop_3    
                elseif cooStop == choiceLine.aller.blue.Stop_3 then
                    cooStop = choiceLine.aller.blue.Stop_4
                elseif cooStop == choiceLine.aller.blue.Stop_4 then
                    cooStop = choiceLine.aller.blue.Stop_5    
                elseif cooStop == choiceLine.aller.blue.Stop_5 then
                    cooStop = choiceLine.aller.blue.Stop_6
                elseif cooStop == choiceLine.aller.blue.Stop_6 then
                    cooStop = choiceLine.aller.blue.Stop_7    
                elseif cooStop == choiceLine.aller.blue.Stop_7 then
                    cooStop = choiceLine.aller.blue.Stop_8
                elseif cooStop == choiceLine.aller.blue.Stop_8 then
                    cooStop = choiceLine.aller.blue.Stop_9    
                elseif cooStop == choiceLine.aller.blue.Stop_9 then
                    cooStop = choiceLine.aller.blue.Stop_10
                elseif cooStop == choiceLine.aller.blue.Stop_10 then
                    cooStop = choiceLine.aller.blue.Stop_11   
                elseif cooStop == choiceLine.aller.blue.Stop_11 then
                    cooStop = choiceLine.aller.blue.Stop_12
                elseif cooStop == choiceLine.aller.blue.Stop_12 then
                    cooStop = choiceLine.aller.blue.Stop_13    
                elseif cooStop == choiceLine.aller.blue.Stop_13 then
                    cooStop = choiceLine.aller.blue.Stop_14 
                elseif cooStop == choiceLine.aller.blue.Stop_14 then
                    cooStop = choiceLine.aller.blue.Stop_15
                elseif cooStop == choiceLine.aller.blue.Stop_15 then
                    cooStop = choiceLine.aller.blue.Stop_16    
                elseif cooStop == choiceLine.aller.blue.Stop_16 then
                    cooStop = choiceLine.aller.blue.Stop_17
                elseif cooStop == choiceLine.aller.blue.Stop_17 then
                    cooStop = choiceLine.aller.blue.Stop_18    
                elseif cooStop == choiceLine.aller.blue.Stop_18 then
                    goto stoparret
                end
            end
            Wait(1)
        end
        ::stoparret::
        if lineActive then
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez fini la ligne bleue. Vous avez rapporter 300$ à votre entreprise."
            })
            local year , month , day , stophour , stopminute , second  = GetLocalTime()
            local stopTime = stophour..':'..stopminute
    
            local ligne = 'bleue (aller)'
            TriggerServerEvent('lstDiscordLog', ligne, startTime, stopTime)
    
            TriggerServerEvent('giveMoneyLst')
        end
        lineActive = false
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Vous devez ~s prendre votre service et être dans un bus"
        })
    end
end
-- retour
function BactionLineR()
    if lstDuty then
        local year , month , day , starthour , startminute , second  = GetLocalTime()
        local startTime = starthour..':'..startminute

        lineActive = true
        local cooStop = choiceLine.retour.red.Stop_1
        while lineActive do
            
            cooPlayer = GetEntityCoords(PlayerPedId())
            SetNewWaypoint(cooStop)
            
            distPlayerStop = GetDistanceBetweenCoords(cooPlayer, cooStop, false)
            if distPlayerStop < 50 then
                if cooStop == choiceLine.retour.red.Stop_1 then
                    cooStop = choiceLine.retour.red.Stop_2
                elseif cooStop == choiceLine.retour.red.Stop_2 then
                    cooStop = choiceLine.retour.red.Stop_3    
                elseif cooStop == choiceLine.retour.red.Stop_3 then
                    cooStop = choiceLine.retour.red.Stop_4
                elseif cooStop == choiceLine.retour.red.Stop_4 then
                    cooStop = choiceLine.retour.red.Stop_5    
                elseif cooStop == choiceLine.retour.red.Stop_5 then
                    cooStop = choiceLine.retour.red.Stop_6
                elseif cooStop == choiceLine.retour.red.Stop_6 then
                    cooStop = choiceLine.retour.red.Stop_7    
                elseif cooStop == choiceLine.retour.red.Stop_7 then
                    cooStop = choiceLine.retour.red.Stop_8
                elseif cooStop == choiceLine.retour.red.Stop_8 then
                    cooStop = choiceLine.retour.red.Stop_9    
                elseif cooStop == choiceLine.retour.red.Stop_9 then
                    cooStop = choiceLine.retour.red.Stop_10
                elseif cooStop == choiceLine.retour.red.Stop_10 then
                    cooStop = choiceLine.retour.red.Stop_11   
                elseif cooStop == choiceLine.retour.red.Stop_11 then
                    cooStop = choiceLine.retour.red.Stop_12
                elseif cooStop == choiceLine.retour.red.Stop_12 then
                    cooStop = choiceLine.retour.red.Stop_13    
                elseif cooStop == choiceLine.retour.red.Stop_13 then
                    goto stoparret
                end
            end
            Wait(1)
        end
        ::stoparret::
        if lineActive then
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez fini la ligne rouge. Vous avez rapporter 300$ à votre entreprise."
            })
            local year , month , day , stophour , stopminute , second  = GetLocalTime()
            local stopTime = stophour..':'..stopminute
    
            local ligne = 'rouge (retour)'
            TriggerServerEvent('lstDiscordLog', ligne, startTime, stopTime)
    
            TriggerServerEvent('giveMoneyLst')
        end
        lineActive = false
        
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Vous devez ~s prendre votre service et être dans un bus"
        })
    end
end
function BactionLineG()
    if lstDuty then
        local year , month , day , starthour , startminute , second  = GetLocalTime()
        local startTime = starthour..':'..startminute

        lineActive = true
        local cooStop = choiceLine.retour.green.Stop_1
        while lineActive do
            
            cooPlayer = GetEntityCoords(PlayerPedId())
            SetNewWaypoint(cooStop)
            
            distPlayerStop = GetDistanceBetweenCoords(cooPlayer, cooStop, false)
            if distPlayerStop < 50 then
                if cooStop == choiceLine.retour.green.Stop_1 then
                    cooStop = choiceLine.retour.green.Stop_2
                elseif cooStop == choiceLine.retour.green.Stop_2 then
                    cooStop = choiceLine.retour.green.Stop_3    
                elseif cooStop == choiceLine.retour.green.Stop_3 then
                    cooStop = choiceLine.retour.green.Stop_4
                elseif cooStop == choiceLine.retour.green.Stop_4 then
                    cooStop = choiceLine.retour.green.Stop_5    
                elseif cooStop == choiceLine.retour.green.Stop_5 then
                    cooStop = choiceLine.retour.green.Stop_6
                elseif cooStop == choiceLine.retour.green.Stop_6 then
                    cooStop = choiceLine.retour.green.Stop_7    
                elseif cooStop == choiceLine.retour.green.Stop_7 then
                    cooStop = choiceLine.retour.green.Stop_8
                elseif cooStop == choiceLine.retour.green.Stop_8 then
                    cooStop = choiceLine.retour.green.Stop_9    
                elseif cooStop == choiceLine.retour.green.Stop_9 then
                    cooStop = choiceLine.retour.green.Stop_10
                elseif cooStop == choiceLine.retour.green.Stop_10 then
                    cooStop = choiceLine.retour.green.Stop_11   
                elseif cooStop == choiceLine.retour.green.Stop_11 then
                    cooStop = choiceLine.retour.green.Stop_12
                elseif cooStop == choiceLine.retour.green.Stop_12 then
                    cooStop = choiceLine.retour.green.Stop_13    
                elseif cooStop == choiceLine.retour.green.Stop_13 then
                    cooStop = choiceLine.retour.green.Stop_14 
                elseif cooStop == choiceLine.retour.green.Stop_14 then
                    cooStop = choiceLine.retour.green.Stop_15
                elseif cooStop == choiceLine.retour.green.Stop_15 then
                    cooStop = choiceLine.retour.green.Stop_16    
                elseif cooStop == choiceLine.retour.green.Stop_16 then
                    cooStop = choiceLine.retour.green.Stop_17
                elseif cooStop == choiceLine.retour.green.Stop_17 then
                    cooStop = choiceLine.retour.green.Stop_18    
                elseif cooStop == choiceLine.retour.green.Stop_18 then
                    cooStop = choiceLine.retour.green.Stop_19
                elseif cooStop == choiceLine.retour.green.Stop_19 then
                    cooStop = choiceLine.retour.green.Stop_20    
                elseif cooStop == choiceLine.retour.green.Stop_20 then
                    cooStop = choiceLine.retour.green.Stop_21
                elseif cooStop == choiceLine.retour.green.Stop_21 then
                    cooStop = choiceLine.retour.green.Stop_22    
                elseif cooStop == choiceLine.retour.green.Stop_22 then
                    cooStop = choiceLine.retour.green.Stop_23
                elseif cooStop == choiceLine.retour.green.Stop_23 then
                    cooStop = choiceLine.retour.green.Stop_24   
                elseif cooStop == choiceLine.retour.green.Stop_24 then
                    cooStop = choiceLine.retour.green.Stop_25
                elseif cooStop == choiceLine.retour.green.Stop_25 then
                    cooStop = choiceLine.retour.green.Stop_26    
                elseif cooStop == choiceLine.retour.green.Stop_26 then
                    cooStop = choiceLine.retour.green.Stop_27
                elseif cooStop == choiceLine.retour.green.Stop_27 then
                    cooStop = choiceLine.retour.green.Stop_28    
                elseif cooStop == choiceLine.retour.green.Stop_28 then
                    cooStop = choiceLine.retour.green.Stop_29  
                elseif cooStop == choiceLine.retour.green.Stop_29 then
                    goto stoparret
                end
            end
            Wait(1)
        end
        ::stoparret::
        if lineActive then
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez fini la ligne verte. Vous avez rapporter 300$ à votre entreprise."
            })
            local year , month , day , stophour , stopminute , second  = GetLocalTime()
            local stopTime = stophour..':'..stopminute
    
            local ligne = 'verte (retour)'
            TriggerServerEvent('lstDiscordLog', ligne, startTime, stopTime)
    
            TriggerServerEvent('giveMoneyLst')
        end
        lineActive = false
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Vous devez ~s prendre votre service et être dans un bus"
        })
    end
end
function BactionLineB()
    if lstDuty then
        local year , month , day , starthour , startminute , second  = GetLocalTime()
        local startTime = starthour..':'..startminute

        lineActive = true
        local cooStop = choiceLine.retour.blue.Stop_1
        while lineActive do
            
            cooPlayer = GetEntityCoords(PlayerPedId())
            SetNewWaypoint(cooStop)
            
            distPlayerStop = GetDistanceBetweenCoords(cooPlayer, cooStop, false)
            if distPlayerStop < 50 then
                if cooStop == choiceLine.retour.blue.Stop_1 then
                    cooStop = choiceLine.retour.blue.Stop_2
                elseif cooStop == choiceLine.retour.blue.Stop_2 then
                    cooStop = choiceLine.retour.blue.Stop_3    
                elseif cooStop == choiceLine.retour.blue.Stop_3 then
                    cooStop = choiceLine.retour.blue.Stop_4
                elseif cooStop == choiceLine.retour.blue.Stop_4 then
                    cooStop = choiceLine.retour.blue.Stop_5    
                elseif cooStop == choiceLine.retour.blue.Stop_5 then
                    cooStop = choiceLine.retour.blue.Stop_6
                elseif cooStop == choiceLine.retour.blue.Stop_6 then
                    cooStop = choiceLine.retour.blue.Stop_7    
                elseif cooStop == choiceLine.retour.blue.Stop_7 then
                    cooStop = choiceLine.retour.blue.Stop_8
                elseif cooStop == choiceLine.retour.blue.Stop_8 then
                    cooStop = choiceLine.retour.blue.Stop_9    
                elseif cooStop == choiceLine.retour.blue.Stop_9 then
                    cooStop = choiceLine.retour.blue.Stop_10
                elseif cooStop == choiceLine.retour.blue.Stop_10 then
                    cooStop = choiceLine.retour.blue.Stop_11   
                elseif cooStop == choiceLine.retour.blue.Stop_11 then
                    cooStop = choiceLine.retour.blue.Stop_12
                elseif cooStop == choiceLine.retour.blue.Stop_12 then
                    cooStop = choiceLine.retour.blue.Stop_13    
                elseif cooStop == choiceLine.retour.blue.Stop_13 then
                    cooStop = choiceLine.retour.blue.Stop_14 
                elseif cooStop == choiceLine.retour.blue.Stop_14 then
                    cooStop = choiceLine.retour.blue.Stop_15
                elseif cooStop == choiceLine.retour.blue.Stop_15 then
                    cooStop = choiceLine.retour.blue.Stop_16    
                elseif cooStop == choiceLine.retour.blue.Stop_16 then
                    cooStop = choiceLine.retour.blue.Stop_17
                elseif cooStop == choiceLine.retour.blue.Stop_17 then
                    cooStop = choiceLine.retour.blue.Stop_18    
                elseif cooStop == choiceLine.retour.blue.Stop_18 then
                    goto stoparret
                end
            end
            Wait(1)
        end
        ::stoparret::
        if lineActive then
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez fini la ligne bleue. Vous avez rapporter 300$ à votre entreprise."
            })
            local year , month , day , stophour , stopminute , second  = GetLocalTime()
            local stopTime = stophour..':'..stopminute
    
            local ligne = 'bleue (retour)'
            TriggerServerEvent('lstDiscordLog', ligne, startTime, stopTime)
    
            TriggerServerEvent('giveMoneyLst')
        end
        lineActive = false
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Vous devez ~s prendre votre service et être dans un bus"
        })
    end
end 