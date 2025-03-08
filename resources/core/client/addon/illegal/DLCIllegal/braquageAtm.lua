local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

InsideDrilling = false

local ATMList = {
    -1364697528,
    -870868698,
    -1126237515,
    506770882
}

local pfx = nil
function StartDropBillet(entity)
    local heading = GetEntityHeading(entity)
    RequestNamedPtfxAsset("scr_xs_celebration")
    while not HasNamedPtfxAssetLoaded("scr_xs_celebration") do
        Wait(10)
    end
    UseParticleFxAssetNextCall("scr_xs_celebration")
    pfx = StartParticleFxLoopedOnEntity("scr_xs_money_rain", entity, -0.1, -0.3, 0.75, -90.0, heading - 180.0, heading, 1.0, false, false, false)
end

function GetClosestATM()
    for k,v in pairs(ATMList) do
        local obj = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 2.0, v, true)
        if obj ~= 0 then 
            return obj
        end
    end
    return nil
end

insideRobberyAtm = false
local AnimBillet = false
local melee = 0

local timerStop = 1
local CanAttackAtm = false
CreateThread(function()
    Wait(5000)
    if not DlcIllegal then return end
    --while not GetVariable do Wait(1) end
    while not GetVariable("heist") do Wait(1) end
    while true do 
        Wait(1)
        if IsPedArmed(PlayerPedId(), 1) then  
            local atmVariable = GetVariable("heist").atm
            --local atmVariable = {active = "true", xp = 50, winMin = 20, winMax = 200, cops = 0}
            if CanAccessAction('ATM') then
                if tostring(atmVariable.active) == "true" then
                    local atm = GetClosestATM()
                    if atm then
                        if not insideRobberyAtm then 
                            Bulle.hide("atm_bank" .. atm)
                            zone.removeZone("atm_bank" .. atm)
                            Bulle.create("atm", GetEntityCoords(atm) + vector3(0.0, 0.0, 1.57), "bulleFrapper", true) -- bulleFrapper
                            if IsControlJustPressed(0, 38) then 
                                local policeMans = (GlobalState['serviceCount_lspd'] or 0) + (GlobalState['serviceCount_lssd'] or 0)
                                if policeMans >= tonumber(atmVariable.cops) then
                                    local isPlayerAlrdyBraked = TriggerServerCallback("core:ATMAlreadyRob")
                                    if (not isPlayerAlrdyBraked) and (p:getJob() ~= "lspd" and p:getJob() ~= "lssd") then
                                        TriggerServerEvent("core:setPlayerATMRobberyGood")
                                        TriggerSecurEvent("core:crew:updateXp", token, tonumber(atmVariable.xp), "add", p:getCrew(), "ATM")
                                        RequestAnimDict('pickup_object')
                                        while not HasAnimDictLoaded('pickup_object') do
                                            Wait(10)
                                        end                                    
                                        CanAttackAtm = true
                                        exports['vNotif']:createNotification({
                                            type = 'VERT',
                                            content = "Vous commencez à voler l'ATM."
                                        })
                                        insideRobberyAtm = true
                                        Bulle.remove("atm")
                                        if Serveur == "FA" then
                                            exports['tuto-fa']:GoToSpecialStep(0)
                                        elseif Serveur == "WL" then
                                            exports['tuto-wl']:GoToSpecialStep(0)
                                        end
                                    else
                                        exports['vNotif']:createNotification({
                                            type = 'ROUGE',
                                            content = "Vous ne pouvez pas braquer l'ATM (Vous en avez deja braqué un)"
                                        })
                                        Wait(2000)
                                    end
                                else
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        content = "Il n'y a pas assez de policier en ville"
                                    })
                                    Wait(2000)
                                    
                                end
                            end
                        end
                        if insideRobberyAtm then 
                            timerStop = timerStop + 1
                            if timerStop > 3000 then 
                                StopParticleFxLooped(pfx, 0)
                                AnimBillet = false
                                
                                melee = 0
                                insideRobberyAtm = false
                            end
                            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(atm)) > 20.0 then 
                                StopParticleFxLooped(pfx, 0)
                                AnimBillet = false                            
                                melee = 0
                                insideRobberyAtm = false
                                if Serveur == "FA" then
                                    exports['tuto-fa']:HideStep()
                                elseif Serveur == "WL" then
                                    exports['tuto-wl']:HideStep()
                                end
                            end
                            if IsPedPerformingMeleeAction(PlayerPedId()) then
                                melee += 1
                                if melee > 10 then 
                                    Wait(1100)
                                    local plyPed = PlayerPedId()
                                    ClearPedTasksImmediately(plyPed)
                                    TaskPlayAnim(plyPed, "pickup_object", "pickup_low", 2.0, 2.0, -1, 31, 2.0, 0, 0, 0)
                                    Wait(500)
                                    PlaySound(-1, 'ROBBERY_MONEY_TOTAL', 'HUD_FRONTEND_CUSTOM_SOUNDSET', 0, 0, 1)
                                    local money = RealRandom(tonumber(atmVariable.winMin), tonumber(atmVariable.winMax))
                                    p:AddItem("money", money, {})
                                    exports['vNotif']:createNotification({
                                        type = 'DOLLAR',
                                        content = ("Vous avez récupéré ~s %s$"):format(money)
                                    })
                                    Wait(500)
                                    ClearPedTasks(plyPed)
                                    Wait(200)
                                else
                                    Wait(1200)
                                end
                                if melee >= 30 then 
                                    StopParticleFxLooped(pfx, 0)
                                    AnimBillet = false
                                    RequestNamedPtfxAsset("core")
                                    while not HasNamedPtfxAssetLoaded("core") do
                                        Wait(1)
                                    end
                                    UseParticleFxAssetNextCall("core")
                                    local atmForward = GetEntityCoords(atm) + vector3(0.0, 0.0, 1.1)
                                    local particle1 = StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", atmForward, 0.0, 0.0, 0.0, 2.0, 0, 0, 0)     
                                    Wait(100)       
                                    StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", atmForward, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
                                    Wait(100)       
                                    StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", atmForward, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
                                    Wait(100)       
                                    StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", atmForward, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
                                    Wait(100)       
                                    local particle2 = StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", atmForward, 0.0, 0.0, 0.0, 2.0, 0, 0, 0)
                                    Wait(100)       
                                    StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", atmForward, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
                                    Wait(100)       
                                    StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", atmForward, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
                                    Wait(100)       
                                    StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", atmForward, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)                                
                                    melee = 0
                                    insideRobberyAtm = false
                                    CanAttackAtm = false
                                    if Serveur == "FA" then
                                        exports['tuto-fa']:HideStep()
                                    elseif Serveur == "WL" then
                                        exports['tuto-wl']:HideStep()
                                    end
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        content = "Le distributeur n'a plus de billets"
                                    })
                                end                                
                                if melee > 10 then 
                                    if not AnimBillet then
                                        AnimBillet = true
                                        ActionInTerritoire(p:getCrew(), GetZoneByPlayer(), atmVariable.influence or 80, 10, coordsIsInSouth(GetEntityCoords(PlayerPedId())))
                                        local isInSouth = coordsIsInSouth(GetEntityCoords(PlayerPedId()))
                                        if isInSouth then
                                            TriggerSecurEvent('core:makeCall', "lspd", GetEntityCoords(PlayerPedId()), true, "Braquage d'atm", false, "illegal")
                                            TriggerSecurEvent('core:makeCall', "lssd", GetEntityCoords(PlayerPedId()), true, "Braquage d'atm", false, "illegal") -- FIX_LSSD_LSPD
                                        else
                                            TriggerSecurEvent('core:makeCall', "lssd", GetEntityCoords(PlayerPedId()), true, "Braquage d'atm", false, "illegal")
                                            TriggerSecurEvent('core:makeCall', "lspd", GetEntityCoords(PlayerPedId()), true, "Braquage d'atm", false, "illegal") -- FIX_LSSD_LSPD
                                        end
                                        StartDropBillet(atm)
                                    end
                                end
                            end
                        end
                    else
                        Wait(200)
                        Bulle.remove("atm")
                    end
                end
            else
                Wait(60000)
            end
        else
            Bulle.remove("atm")
            Wait(2000)
        end
    end
end)

local UseForreuse = false
local createdObject = false
local DrillObj = nil
RegisterNetEvent("core:Forreuse", function()
    UseForreuse = not UseForreuse
    if not UseForreuse then 
        DeleteEntity(DrillObj)
        createdObject = false
        ClearPedTasks(p:ped())
    end
end)

local insideRobberyAtm2 = false
local attachedDrill
CreateThread(function()
    if not DlcIllegal then return end
    while true do 
        Wait(1)
        if UseForreuse then 
            if not createdObject then 
                insideRobberyAtm2 = true
                insideRobberyAtm = true
                createdObject = true        
                RequestAnimDict("anim@heists@fleeca_bank@drilling")
                while not HasAnimDictLoaded("anim@heists@fleeca_bank@drilling") do
                    Wait(1)
                end	
                SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"),true)
                Wait(100)
                local drillProp = GetHashKey("hei_prop_heist_drill")
                local boneIndex = GetPedBoneIndex(PlayerPedId(), 28422)			
                RequestModel(drillProp)
                while not HasModelLoaded(drillProp) do
                    Wait(1)
                end			
                TaskPlayAnim(PlayerPedId(),"anim@heists@fleeca_bank@drilling","drill_straight_idle",1.0, -1.0, -1, 49, 0, 0, 0, 0)			
                DrillObj = CreateObject(drillProp, 1.0, 1.0, 1.0, 1, 1, 0)	
                AttachEntityToEntity(DrillObj, PlayerPedId(), boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)			
                SetEntityAsMissionEntity(DrillObj, true, true)		
            end
            if not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 3) then 
                TaskPlayAnim(PlayerPedId(),"anim@heists@fleeca_bank@drilling","drill_straight_idle",1.0, -1.0, -1, 49, 0, 0, 0, 0)
            end
            DisableControlAction(0, 24, true)
            local closestAtm = GetClosestATM()
            if closestAtm then 
                Bulle.create("atm", GetEntityCoords(closestAtm) + vector3(0.0, 0.0, 1.57), "bulleForer", true)
                if IsControlJustPressed(0, 38) then 
                    UseForreuse = false
                    DeleteEntity(DrillObj)
                    createdObject = false
                    ClearPedTasks(p:ped())
                    DrillATM(closestAtm)
                end
            end
        else
            if insideRobberyAtm2 and insideRobberyAtm and (not attachedDrill) then 
                insideRobberyAtm2 = false
                insideRobberyAtm = false
            end
            Wait(2000)
        end
    end
end)

function DrillATM(atm)
    local isPlayerAlrdyBraked = TriggerServerCallback("core:ATMAlreadyRob")
    local policeMans = (GlobalState['serviceCount_lspd'] or 0) + (GlobalState['serviceCount_lssd'] or 0)
    local atmVariable = GetVariable("heist").atmScie
    --local atmVariable = {active = "true", xp = 50, cops = 0, winMin = 50, winMax = 200}
    OpenTutoFAInfo("Braquage", "Utilisez les fleches directionnelles pour forrer l'atm")
    if tostring(atmVariable.active) ~= "true" then return false end
    if (not isPlayerAlrdyBraked) and (p:getJob() ~= "lspd" and p:getJob() ~= "lssd") then
        if policeMans >= tonumber(atmVariable.cops) then
            local ped = PlayerPedId()
            local p1 = GetEntityCoords(ped, true)
            local p2 = GetEntityCoords(atm, true)
            local dx = p2.x - p1.x
            local dy = p2.y - p1.y    
            local heading = GetHeadingFromVector_2d(dx, dy)
            SetEntityHeading(ped, heading)
            
            local coords, forward = GetEntityCoords(atm), GetEntityForwardVector(atm)
            --local atmForward = (coords + forward * -0.8)
            local atmForward = (coords + forward * -0.7)
            SetEntityCoords(ped, atmForward) 
            
            local coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
            local particleForward = (coords + forward * 0.8) + vector3(0.0, -0.15, 0.13) 

            local ped = PlayerPedId()
            local animDict = "anim@heists@fleeca_bank@drilling"
            local animLib = "drill_straight_idle"
                    
            RequestAnimDict(animDict)
            while not HasAnimDictLoaded(animDict) do
                Citizen.Wait(50)
            end	
            SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"),true)
            Citizen.Wait(500)				
            --local drillProp = GetHashKey('prop_tool_consaw')
            local drillProp = GetHashKey("hei_prop_heist_drill")
            local boneIndex = GetPedBoneIndex(ped, 28422)			
            RequestModel(drillProp)
            while not HasModelLoaded(drillProp) do
                Wait(1)
                print("load")
            end			
            TaskPlayAnim(ped,animDict,animLib,1.0, -1.0, -1, 2, 0, 0, 0, 0)			
            attachedDrill = CreateObject(drillProp, 1.0, 1.0, 1.0, 1, 1, 0)
            --AttachEntityToEntity(attachedDrill, ped, boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 90.0, 1, 1, 0, 0, 2, 1)		
            AttachEntityToEntity(attachedDrill, ped, boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)			
            SetEntityAsMissionEntity(attachedDrill, true, true)		
            RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET", 0)
            RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", 0)
            RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", 0)		
            local soundId = GetSoundId()	
            PlaySoundFromEntity(soundId, "Drill", attachedDrill, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
            
            local isInSouth = coordsIsInSouth(GetEntityCoords(p:ped()))
            local policeMans
            if isInSouth then
                TriggerSecurEvent('core:makeCall', "lspd", GetEntityCoords(p:ped()), true, "Braquage d'atm", false, "illegal")
                TriggerSecurEvent('core:makeCall', "lssd", GetEntityCoords(p:ped()), true, "Braquage d'atm", false, "illegal") -- FIX_LSSD_LSPD
            else
                TriggerSecurEvent('core:makeCall', "lssd", GetEntityCoords(p:ped()), true, "Braquage d'atm", false, "illegal")
                TriggerSecurEvent('core:makeCall', "lspd", GetEntityCoords(p:ped()), true, "Braquage d'atm", false, "illegal") -- FIX_LSSD_LSPD
            end
            TriggerSecurEvent("core:crew:updateXp", token, tonumber(atmVariable.xp), "add", p:getCrew(), "ATM")
            
            TriggerEvent("Drilling:Start",function(success)
                if (success) then
                    ActionInTerritoire(p:getCrew(), GetZoneByPlayer(), atmVariable.influence or 100, 10, coordsIsInSouth(GetEntityCoords(PlayerPedId())))
                    HideAtmInfos()
                    InsideDrilling = true
                    exports['tuto-fa']:HideStep()
                    DetachEntity(attachedDrill)
                    DeleteEntity(attachedDrill)
                    attachedDrill = nil
                    ClearPedTasksImmediately(ped)
                    --AddExplosion(particleForward, 0, 0.1, false, true, 0.0)
                    print("success")
                    StopSound(soundId)
                    RequestNamedPtfxAsset("core")
                    while not HasNamedPtfxAssetLoaded("core") do
                        Wait(1)
                    end
                    UseParticleFxAssetNextCall("core")
                    local atmForward = GetEntityCoords(atm) + vector3(0.0, 0.0, 1.1)
                    local particle1 = StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", atmForward, 0.0, 0.0, 0.0, 2.0, 0, 0, 0)     
                    Wait(200)       
                    StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", atmForward, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
                    Wait(200)       
                    StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", atmForward, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
                    Wait(200)       
                    StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", atmForward, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
                    Wait(1000)
                    UseParticleFxAssetNextCall("core")
                    local particle2 = StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", atmForward, 0.0, 0.0, 0.0, 2.0, 0, 0, 0)
                    Wait(200)       
                    StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", atmForward, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
                    Wait(200)       
                    StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", atmForward, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
                    Wait(200)       
                    StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", atmForward, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
                    Wait(1000)
                    UseParticleFxAssetNextCall("core")
                    local particle3 = StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", atmForward, 0.0, 0.0, 0.0, 2.0, 0, 0, 0)
                    Wait(200)       
                    StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", atmForward, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
                    Wait(200)       
                    StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", atmForward, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
                    Wait(200)       
                    StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", atmForward, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
                    Wait(200)       
                    StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", atmForward, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
                    Wait(200)       
                    StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", atmForward, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
                    local timeout = 1
                    Bulle.create("ramasserAtm", atmForward, "bulleRamasser", true)
                    local canLoot = true
                    while true do 
                        Wait(1)
                        timeout += 1
                        local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(atm))
                        if dist < 2.0 then 
                            if IsControlJustPressed(0, 38) and canLoot then 
                                canLoot = false
                                Bulle.remove("ramasserAtm")
                                local moneyprop = GetHashKey("bkr_prop_money_sorted_01")
                                RequestModel(moneyprop)
                                while not HasModelLoaded(moneyprop) do Wait(1) end
                                local moneyProp = CreateObject(moneyprop, 1.0, 1.0, 1.0, 1, 1, 0)
                                local bone = GetPedBoneIndex(PlayerPedId(), 28422)
                                AttachEntityToEntity(moneyProp, PlayerPedId(), bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
                                p:PlayAnim('oddjobs@shop_robbery@rob_till','loop',1)
                                Wait(10000)
                                atmVariable.winMin = tonumber(atmVariable.winMin)
                                atmVariable.winMax = tonumber(atmVariable.winMax)
                                if not atmVariable.winMin then 
                                    print("[^3Core^7] ^1ERREUR^7: La variable ^1winMin^7 n'existe pas. UN STAFF DOIT CORRIGER CELA")
                                    return
                                end
                                if not atmVariable.winMax then 
                                    print("[^3Core^7] ^1ERREUR^7: La variable ^1winMax^7 n'existe pas. UN STAFF DOIT CORRIGER CELA")
                                    return
                                end
                                if atmVariable.winMin > atmVariable.winMax then 
                                    print("[^3Core^7] ^1ERREUR^7: La variable ^1winMin^7 doit être inférieur à ^1winMax^7. UN STAFF DOIT CORRIGER CELA")
                                    return
                                end
                                local money = math.random(atmVariable.winMin, atmVariable.winMax)
                                TriggerSecurEvent("core:braquageAtm", money)
                                exports['vNotif']:createNotification({
                                    type = 'JAUNE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = 'Vous avez récupéré ~s' .. money .."$"
                                })
                                DeleteEntity(moneyProp)
                                ClearPedTasks(PlayerPedId())
                            end
                        end
                        if stopScript == true then
                            TriggerEvent("Drilling:Stop")
                            break
                        end
                        if dist > 20.0 then 
                            TriggerEvent("Drilling:Stop")
                            break
                        end
                        if timeout > 1000 then 
                            break
                        end
                    end
                    Bulle.remove("ramasserAtm")
                    local players = {}
                    for k,v in pairs(GetActivePlayers()) do 
                        table.insert(players, GetPlayerServerId(v))
                    end
                    InsideDrilling = false
                    ShowAtmInfos()
                    insideRobberyAtm = false
                    TriggerServerEvent("core:sync:BurnEvent", players, atmForward)
                    --RemoveParticleFx(particle1, 0)
                    --StopParticleFxLooped(particle1, 0)
                    --RemoveParticleFx(particle2, 0)
                    --StopParticleFxLooped(particle2, 0)
                    --RemoveParticleFx(particle3, 0)
                    --StopParticleFxLooped(particle3, 0)
                else
                    insideRobberyAtm = false
                    exports['tuto-fa']:HideStep()
                    StopSound(soundId)
                    DetachEntity(attachedDrill)
                    DeleteEntity(attachedDrill)
                    attachedDrill = nil
                    ClearPedTasksImmediately(ped)
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous n'avez pas réussi à braquer l'ATM"
                    })
                end
            end, particleForward)
            TriggerServerEvent("core:RemoveItemToInventory", token, "forreuse", 1, {})
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Il n'y a pas assez de policier en ville"
            })
        end
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Vous ne pouvez pas braquer l'ATM"
        })
    end
end

RegisterNetEvent("core:sync:atmburn", function(coords)
    RequestNamedPtfxAsset("core")
    while not HasNamedPtfxAssetLoaded("core") do
        Wait(1)
    end
    UseParticleFxAssetNextCall("core")
    local particle3 = StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", coords, 0.0, 0.0, 0.0, 2.0, 0, 0, 0)
    Wait(200)       
    UseParticleFxAssetNextCall("core")
    StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", coords, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
    Wait(200)       
    UseParticleFxAssetNextCall("core")
    StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", coords, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
    Wait(200)       
    UseParticleFxAssetNextCall("core")
    StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", coords, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
    Wait(200)       
    UseParticleFxAssetNextCall("core")
    StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", coords, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
    Wait(200)       
    UseParticleFxAssetNextCall("core")
    StartParticleFxLoopedAtCoord("ent_amb_steam_vent_open_lgt", coords, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
end)
