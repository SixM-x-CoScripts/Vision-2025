local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local isPlayerAlrdyBraked = false
local policemanCheck = false
local totalMoney = 0
local timer = 0
local policeMans = 0
local peds = {}
CreateThread(function()
    while p == nil do Wait(1000) end
    Wait(5012)
    isPlayerAlrdyBraked = TriggerServerCallback("core:getIfPlayerAlrdyRobbeEntreprises")

    if not DlcIllegal then return end
    
    while (not isPlayerAlrdyBraked) do
        for k, v in pairs(entreprises_robbery) do
            local pDist = #(p:pos() - v.pos.xyz)
            if pDist <= 35 then
                if p:getJob() == "lspd" or p:getJob() == "lssd" or p:getJob() == "g6" or p:getJob() == "usmc" or p:getJob() == "gcp" then
                    return
                elseif (pDist <= 3) and ((IsPedArmed(p:ped(), 1) and IsPedInMeleeCombat(p:ped()) == 1) or IsPlayerFreeAiming(PlayerId())) and 
                    (not IsPedDeadOrDying(peds[k].id)) and HasEntityClearLosToEntityInFront(p:ped(), peds[k].id) then

                    if not policemanCheck then
                        policemanCheck = true
                        policeMans = (GlobalState['serviceCount_lspd'] or 0) + (GlobalState['serviceCount_lssd'] or 0)
                    end
                    local super = GetVariable("heist").entreprises
                    --local super = {cops = 0, active = "true", xp = 10, winMin = 100, winMax = 500}
                    if policeMans >= tonumber(super.cops) and tostring(super.active) == "true" then
                        if not v.done then
                            local first = true
                            v.done = true
                            
                            peds[k]:setFreeze(false)
                            SetEntityInvincible(peds[k].id, false)
                            
                            Bulle.hide("etpbraq" .. v.name)

                            zone.removeZone("etpbraq" .. v.name)

                            TriggerSecurEvent("core:crew:updateXp", token, tonumber(super.xp), "add", p:getCrew(), "braquage entreprise")
                            local isInSouth = coordsIsInSouth(GetEntityCoords(p:ped()))
                            if isInSouth then
                                TriggerSecurEvent('core:makeCall', "lspd", v.pos.xyz, true, "Braquage de binco", false, "illegal")
                                TriggerSecurEvent('core:makeCall', "lssd", v.pos.xyz, true, "Braquage de binco", false, "illegal") -- FIX_LSSD_LSPD
                            else
                                TriggerSecurEvent('core:makeCall', "lssd", v.pos.xyz, true, "Braquage de binco", false, "illegal")
                                TriggerSecurEvent('core:makeCall', "lspd", v.pos.xyz, true, "Braquage de binco", false, "illegal") -- FIX_LSSD_LSPD
                            end
                            
                            local mathrStage = math.random(1, 3)

                            local obj = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 15.0, 303280717, 1)
                            if GetDistanceBetweenCoords(GetEntityCoords(obj), GetEntityCoords(PlayerPedId())) > 10.0 then 
                                mathrStage = 2
                            end

                            if mathrStage ~= 3 then 
                                LoadAnimDict('missheist_agency2ahands_up')
                                TaskPlayAnim(peds[k].id, "missheist_agency2ahands_up",
                                    "handsup_anxious", 8.0, -8.0, -1, 1, 0, false,
                                    false, false)
                                Wait(5000)
                                if IsPedDeadOrDying(peds[k].id) then
                                    return
                                end
                            end
                            timer = GetGameTimer() + (60000 * 6)
                            
                            if mathrStage == 3 then 
                                if IsPedArmed(PlayerPedId(), 4) then 
                                    mathrStage = math.random(1,2)
                                end
                            end
                            
                            ::stageEtp1::
                            local countMo = 0
                            
                            if mathrStage == 1 then 
                                if Serveur == "FA" then
                                    OpenTutoFAInfo("Braquage Entreprises", "Frappez la caisse pour récupérer l'argent")
                                elseif Serveur == "WL" then
                                    OpenTutoWLInfo("Braquage Entreprises", "Frappez la caisse pour récupérer l'argent")
                                end
                                TaskGoToCoordAnyMeans(peds[k].id, v.coin, 1.0, 0, 0, 786603, 0)
                                while (not isPlayerAlrdyBraked) do 
                                    Wait(1)
                                    local obj = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.0, 303280717, 1)
                                    if obj and GetDistanceBetweenCoords(GetEntityCoords(obj), GetEntityCoords(PlayerPedId())) < 3.0 then 
                                        if HasEntityBeenDamagedByAnyPed(obj) then 
                                            if not volerCaisse[obj] then
                                                Bulle.create("volerSuperette", GetEntityCoords(obj) + vec3(0.0, 0.0, 0.3), "bulleFouillerDollar", true)
                                            end
                                            if GetDistanceBetweenCoords(GetEntityCoords(obj), GetEntityCoords(PlayerPedId())) < 1.2 then 
                                                if IsControlJustPressed(0, 38) and not volerCaisse[obj] then 
                                                    volerCaisse[obj] = true
                                                    SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)
                                                    Bulle.hide("volerSuperette")
                                                    local moneyprop = GetHashKey("bkr_prop_money_sorted_01")
                                                    RequestModel(moneyprop)
                                                    while not HasModelLoaded(moneyprop) do Wait(1) end
                                                    local moneyProps = CreateObject(moneyprop, 1.0, 1.0, 1.0, 1, 1, 0)
                                                    local bone = GetPedBoneIndex(PlayerPedId(), 28422)
                                                    AttachEntityToEntity(moneyProps, PlayerPedId(), bone, 0.0, 0.0, 90.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
                                                    p:PlayAnim('oddjobs@shop_robbery@rob_till','loop',1)
                                                    canTakemoney = true
                                                    while canTakemoney do
                                                        Wait(1200)
                                                        countMo += 1
                                                        local rand = math.random(super.winMin, super.winMax)
                                                        exports['vNotif']:createNotification({
                                                            type = 'JAUNE',
                                                            -- duration = 5, -- In seconds, default:  4
                                                            content = "Vous avez récupéré " .. rand .. "$"
                                                        })
                                                        if countMo >= 9 then 
                                                            ClearPedTasks(PlayerPedId())
                                                            totalMoney = rand*countMo
                                                            p:AddItem("money", rand*countMo, {})
                                                            canTakemoney = false
                                                        end
                                                        if not canTakemoney then break end
                                                    end
                                                    countMo = 0
                                                    if Serveur == "FA" then
                                                        exports['tuto-fa']:HideStep()
                                                    elseif Serveur == "WL" then
                                                        exports['tuto-wl']:HideStep()
                                                    end
                                                    DeleteEntity(moneyProps)
                                                    ClearPedTasks(PlayerPedId())
                                                end
                                            end
                                        end
                                    end
                                    if IsEntityPlayingAnim(p:ped(), 'oddjobs@shop_robbery@rob_till','loop',3) and countMo < 9 then 
                                        if IsControlJustPressed(0, 73) then 
                                            local mathrand = math.random(super.winMin, super.winMax)
                                            totalMoney = mathrand*countMo
                                            p:AddItem("money", mathrand*countMo, {})
                                            canTakemoney = false
                                            ClearPedTasks(p:ped())
                                        end 
                                    end
                                    if #(p:pos() - v.pos.xyz) >= 30 then
                                        isPlayerAlrdyBraked = true
                                        if Serveur == "FA" then
                                            exports['tuto-fa']:HideStep()
                                        elseif Serveur == "WL" then
                                            exports['tuto-wl']:HideStep()
                                        end
                                        
                                        exports['vNotif']:createNotification({
                                            type = 'ROUGE',
                                            content = "Vous avez quitté la zone, ~s braquage annulé"
                                        })

                                        TriggerSecurEvent("core:crew:updateXp", token, tonumber(super.xp), "add", p:getCrew(), "superette")
                                        TriggerServerEvent("core:superette", totalMoney, v.name, "entreprise braquable quitté la zone")
                                        break
                                    end
                                end
                            elseif mathrStage == 2 then 
                                Citizen.CreateThread(function()
                                    while (not isPlayerAlrdyBraked) do
                                        Wait(300)

                                        if GetGameTimer() > timer then
                                            isPlayerAlrdyBraked = true
                                            TriggerServerEvent("core:binco", totalMoney, v.name, "Fin du temps")
                                            break
                                        end

                                        if IsPedDeadOrDying(peds[k].id) then
                                            isPlayerAlrdyBraked = true
                                            exports['vNotif']:createNotification({
                                                type = 'ROUGE',
                                                content = IsPedMale(peds[k].id) and "~s Chris est mort !!" or "~s Christine est morte !!"
                                            })

                                            TriggerServerEvent("core:binco", totalMoney, v.name, "christine est morte")
                                            break
                                        end
                                        if #(p:pos() - v.pos.xyz) >= 30 then
                                            isPlayerAlrdyBraked = true
                                            
                                            exports['vNotif']:createNotification({
                                                type = 'ROUGE',
                                                content = "Vous avez quitté la zone, ~s braquage annulé"
                                            })

                                            TriggerSecurEvent("core:crew:updateXp", token, tonumber(super.xp), "add", p:getCrew(), "braquage entreprise")
                                            TriggerServerEvent("core:binco", totalMoney, v.name, "quitté la zone")
                                            break
                                        end
                                    end

                                    ClearPedTasks(peds[k].id)
                                    SetEntityCoords(peds[k].id, v.pos.xyz)
                                    SetEntityHeading(peds[k].id, v.pos.w)
                                    peds[k]:setFreeze(true)
                                    ResurrectPed(peds[k].id)
                                    SetEntityInvincible(peds[k].id, true)
                                end)

                                while (not isPlayerAlrdyBraked) do
                                    LoadAnimDict('mp_am_hold_up')
                                    TaskPlayAnim(peds[k].id, "mp_am_hold_up",
                                        "holdup_victim_20s", 8.0, -8.0, -1, 2, 0,
                                        false, false, false)

                                    Modules.UI.RealWait(11000)

                                    local cashRegister = GetClosestObjectOfType(GetEntityCoords(peds[k]
                                        .id), 5.0, GetHashKey('prop_till_01'))
                                    if DoesEntityExist(cashRegister) then
                                        CreateModelSwap(GetEntityCoords(cashRegister)
                                            , 0.5, GetHashKey('prop_till_01'),
                                            GetHashKey('prop_till_01_dam'), false)
                                    end

                                    local model = GetHashKey('prop_poly_bag_01')
                                    RequestModel(model)
                                    LoadModel('prop_poly_bag_01')
                                    bag = CreateObject(model,
                                        GetEntityCoords(peds[k].id),
                                        false, false)
                                    AttachEntityToEntity(bag, peds[k].id,
                                        GetPedBoneIndex(peds[k].id, 60309), 0.1,
                                        -0.11, 0.08, 0.0, -75.0, -75.0, 1, 1, 0, 0, 2
                                        , 1)

                                    Modules.UI.RealWait(10000)

                                    if not IsPedDeadOrDying(peds[k].id) then
                                        DetachEntity(bag, true, false)
                                        Wait(75)
                                        SetEntityHeading(bag, v.pos.w)
                                        ApplyForceToEntity(bag, 3,
                                            vector3(0.0, 50.0, 0.0), 0.0,
                                            0.0, 0.0, 0, true, true, false, false,
                                            true)
                                    end
                                    if #(p:pos() - GetEntityCoords(bag)) <= 1.5 then
                                        SetEntityAsMissionEntity(bag, true, true)
                                        DeleteEntity(bag)
                                        if first then
                                            local money = 150 + RealRandom(tonumber(super.winMin), tonumber(super.winMax))
                                            p:AddItem("money", money, {})

                                            exports['vNotif']:createNotification({
                                                type = 'DOLLAR',
                                                content = ("Vous avez récupéré ~s %s$"):format(money)
                                            })

                                            first = false
                                            totalMoney = totalMoney+money
                                        else
                                            local money = RealRandom(tonumber(super.winMin), tonumber(super.winMax))
                                            p:AddItem("money", money, {})

                                            exports['vNotif']:createNotification({
                                                type = 'DOLLAR',
                                                content = ("Vous avez récupéré ~s %s$"):format(money)
                                            })

                                            totalMoney = totalMoney+money
                                        end
                                        if totalMoney >= 3600 then
                                            isPlayerAlrdyBraked = true
                                            exports['vNotif']:createNotification({
                                                type = 'JAUNE',
                                                content = "La caisse est ~s vide"
                                            })
                                            break
                                        end
                                    end
                                end
                            elseif mathrStage == 3 then  
                                ClearPedTasks(peds[k].id)
                                TaskCombatPed(peds[k].id, PlayerPedId(), 0, 16)
                                while (not isPlayerAlrdyBraked) do
                                    Wait(1)
                                    if IsEntityDead(peds[k].id) then 
                                        mathrStage = 1
                                        goto stageEtp1
                                        break
                                    end
                                end
                            end

                            TriggerServerEvent("core:entreprisebraquage", totalMoney)
                            totalMoney = 0
                            ClearPedTasks(peds[k].id)
                            SetEntityCoords(peds[k].id, v.pos.xyz)
                            SetEntityHeading(peds[k].id, v.pos.w)
                            peds[k]:setFreeze(true)
                            SetEntityInvincible(peds[k].id, true)

                            TriggerServerEvent('core:setPlayerRobberyGoodEntreprises')
                            policemanCheck = false
                            isPlayerAlrdyBraked = true
                            
                            v.done = false
                        end
                    else
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            content = "~s Reviens plus tard"
                        })
                        Wait(2000)
                    end
                end
            end
        end
        Wait(500)
    end
end)

CreateThread(function()    
    if not DlcIllegal then return end
    while true do
        for k, v in pairs(entreprises_robbery) do
            if GetNumberDuty(v.name) > 0 then
                if peds[k].id then
                    DeletePed(peds[k].id)
                end
                Bulle.hide("etpbraq" .. v.name)
                Bulle.remove("etpbraq" .. v.name)
                zone.removeZone("etpbraq" .. v.name)
            else
                if not peds[k] then
                    peds[k] = entity:CreatePedLocal(v.ped, v.pos.xyz, v.pos.w)
                    peds[k]:setFreeze(true)
                    SetEntityInvincible(peds[k].id, true)
                    SetEntityAsMissionEntity(peds[k].id, 0, 0)
                    SetBlockingOfNonTemporaryEvents(peds[k].id, true)
                    SetPedFleeAttributes(peds[k].id, 0, 0)
                    SetPedCombatAttributes(peds[k].id, 46, true)
                    SetPedFleeAttributes(peds[k].id, 0, 0)
                    zone.addZone("etpbraq" .. v.name,
                        vector3(v.pos.x, v.pos.y, v.pos.z+1.9),
                        "Appuyez sur ma bite pour braquer",
                        function()
                        end,
                        false, -- Avoir un marker ou non
                        -1, -- Id / type du marker
                        0.6, -- La taille
                        { 0, 0, 0 }, -- RGB
                        0, -- Alpha
                        2.5,
                        true,
                        "bulleBraquer"
                    )
                end
            end
            Wait(500)
        end
        Wait(math.random(3000,4000))
    end
end)