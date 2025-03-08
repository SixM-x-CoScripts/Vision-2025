local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local isPlayerAlrdyBraked = false
local totalMoney = 0
local timer = 0
local peds = {}

local MoneyMultiplication = 1
local XPMultiplication = 1

CreateThread(function()
    while p == nil do Wait(1000) end
    while zone == nil do Wait(100) end

    Wait(3000)

    isPlayerAlrdyBraked = TriggerServerCallback("core:hasBraquedSup")

    Wait(2000)

    for k, v in pairs(superette_robbery) do
        peds[k] = entity:CreatePedLocal("mp_m_shopkeep_01", v.pos.xyz, v.pos.w)
        peds[k]:setFreeze(true)
        SetEntityInvincible(peds[k].id, true)
        SetEntityAsMissionEntity(peds[k].id, 0, 0)
        SetBlockingOfNonTemporaryEvents(peds[k].id, true)
        SetPedFleeAttributes(peds[k].id, 0, 0)
        SetPedCombatAttributes(peds[k].id, 46, true)
        SetPedFleeAttributes(peds[k].id, 0, 0)

        zone.addZone( "ltd_item" .. k,
            vector3(v.pos.x, v.pos.y, v.pos.z+1.9),
            "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le magasin",
            function()
                if not DlcIllegal then
                    openStore(peds[k].id, v.job) --TODO: fini le menu society
                end
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
        Wait(100)
    end

    if DlcIllegal then
        for k,v in pairs(superette_epicerie) do         
            zone.addZone( "ltd_epicerie" .. k,
            vector3(v.x, v.y, v.z+1.15),
                "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le magasin",
                function()
                    if GetNumberDuties({"ltdsud", "ltdseoul", "ltdmirror"}) > 0 then
                        openStore() --TODO: fini le menu society
                    else
                        openStore(nil, "ltd", true)
                    end
                end,
                false, -- Avoir un marker ou non
                -1, -- Id / type du marker
                0.6, -- La taille
                { 0, 0, 0 }, -- RGB
                0, -- Alpha
                2.5,
                true,
                "bulleEpicerie"
            )
        end
    end
    
    local PressedSuperette = false
    local canTakemoney = false
    local volerCaisse = {}
    local damagedObj = false
    local hideBulleDeverouiller = false
    local waiting = 500
    while (not isPlayerAlrdyBraked) do
        for k, v in pairs(superette_robbery) do
            local pDist = #(p:pos() - v.pos.xyz)
            if pDist <= 35.0 then
                if not (v.job and (GetNumberDuty(v.job) > 0)) then
                    if not DoesEntityExist(peds[k].id) then
                        peds[k] = entity:CreatePedLocal("mp_m_shopkeep_01", v.pos.xyz, v.pos.w)
                        peds[k]:setFreeze(true)
                        SetEntityInvincible(peds[k].id, true)
                        SetEntityAsMissionEntity(peds[k].id, 0, 0)
                        SetBlockingOfNonTemporaryEvents(peds[k].id, true)
                        SetPedFleeAttributes(peds[k].id, 0, 0)
                        SetPedCombatAttributes(peds[k].id, 46, true)
                        SetPedFleeAttributes(peds[k].id, 0, 0)
                    end
                    
                    --if pDist <= 3.0 then
                    --    waiting = 1
                    --    if IsControlJustPressed(0, 38) then 
                    --        PressedSuperette = true
                    --    end
                    --end

                    if p:getJob() == "lspd" or p:getJob() == "lssd" or p:getJob() == "g6" or p:getJob() == "usmc" or p:getJob() == "gcp" then
                    elseif (pDist <= 3) and ((IsPedArmed(p:ped(), 1) and IsPedInMeleeCombat(p:ped()) == 1) or IsPlayerFreeAiming(PlayerId())) and 
                        (not IsPedDeadOrDying(peds[k].id)) and HasEntityClearLosToEntityInFront(p:ped(), peds[k].id) then

                        printDev("Go braquage (avant check variable)")
                        local super = GetVariable("heist").superette
                        printDev("Varible check superette", super)
                        if super == nil then 
                            printDev("Variable is nil, initiate backing system")
                            super = {cops = 2, active = true, influence = 10, XPNorthMultiplication = 1.25, xp = 200, MoneyNorthMultiplication = 1.25}
                        end
                        printDev("GlobalState lspd et lssd", GlobalState['serviceCount_lspd'], GlobalState['serviceCount_lssd'])
                        printDev("Varible cops & active", tonumber(super.cops), tostring(super.active))
                        if ((GlobalState['serviceCount_lspd'] or 0) + (GlobalState['serviceCount_lssd'] or 0)) >= tonumber(super.cops) and tostring(super.active) == "true" then
                            local playerLicenseKey = 'heistsLimitPerReboot_' .. p:getLicense()
                            local superetteLimitPerReboot = (GlobalState[playerLicenseKey] and GlobalState[playerLicenseKey].superette) or nil
                        
                            if superetteLimitPerReboot == nil or superetteLimitPerReboot < (tonumber(super.rebootLimit) or 0) then 
                                TriggerServerEvent("core:ChangeHeistsLimitByID", token, GetPlayerServerId(PlayerId()), 'superette')
                            else 
                                print("Limite de superette jusqu'au reboot atteinte !")
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    content = "Vous ne pouvez pas faire la superette maintenant !"
                                })
                                return 
                            end
                            if not v.done then
                                local first = true
                                v.done = true

                                peds[k]:setFreeze(false)
                                SetEntityInvincible(peds[k].id, false)
                                Bulle.hide("ltd_item" .. k)

                                zone.removeZone("ltd_item" .. k)
                                
                                printDev("Before action in territoire")
                                ActionInTerritoire(p:getCrew(), GetZoneByPlayer(), tonumber(super.influence) or 60, 2, coordsIsInSouth(GetEntityCoords(PlayerPedId())))
                                printDev("Passed action in terrtioire")
                                                    
                                printDev("Go for xp north multiplication")
                                if not coordsIsInSouth(p:pos()) then
                                    XPMultiplication = tonumber(super.XPNorthMultiplication) or 1
                                end
                                printDev("Passed xp north multiplication", XPMultiplication)

                                TriggerSecurEvent("core:crew:updateXp", token, tonumber(super.xp*XPMultiplication), "add", p:getCrew(), "superette")
                                if v.location == "sud" then
                                    TriggerSecurEvent('core:makeCall', "lspd", v.pos.xyz, true, "Braquage de superette", false, "illegal")
                                    TriggerSecurEvent('core:makeCall', "lssd", v.pos.xyz, true, "Braquage de superette", false, "illegal") -- FIX_LSSD_LSPD
                                else
                                    TriggerSecurEvent('core:makeCall', "lssd", v.pos.xyz, true, "Braquage de superette", false, "illegal")
                                    TriggerSecurEvent('core:makeCall', "lspd", v.pos.xyz, true, "Braquage de superette", false, "illegal") -- FIX_LSSD_LSPD
                                end
                                
                                local mathrStage = math.random(1, 3)

                                if mathrStage ~= 3 then 
                                    LoadAnimDict('missheist_agency2ahands_up')
                                    TaskPlayAnim(peds[k].id, "missheist_agency2ahands_up",
                                        "handsup_anxious", 8.0, -8.0, -1, 49, 0, false,
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

                                local volerCoffre = false
                                local countMo = 0
                                CreateThread(function()
                                    while (not isPlayerAlrdyBraked) do 
                                        Wait(1)
                                        local obj = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 2.0, -1375589668, false)
                                        if obj and GetDistanceBetweenCoords(GetEntityCoords(obj), GetEntityCoords(PlayerPedId())) < 1.5 then 
                                            --print("obj", obj)
                                            local offset = GetOffsetFromEntityInWorldCoords(obj, -0.35, 0.0, 0.0)
                                            if not hideBulleDeverouiller then
                                                Bulle.create("coffreDeverouiller", offset, "bulleOuvrirCadenas", true)
                                            end
                                            if IsControlJustPressed(0, 38) then 
                                                local offsetCoord = GetOffsetFromEntityInWorldCoords(obj, -0.35, 0.30, 0.1)
                                                local offsetCoord2 = GetOffsetFromEntityInWorldCoords(obj, -0.35, 0.30, -0.65)
                                                local offsetCoord3 = GetOffsetFromEntityInWorldCoords(obj, -0.35, 0.30, -0.15)
                                                RequestModel(GetHashKey("prop_cash_case_02"))
                                                while not HasModelLoaded(GetHashKey("prop_cash_case_02")) do Wait(1) end
                                                local objectProps = CreateObject(GetHashKey("prop_cash_case_02"), offsetCoord, 1)
                                                local objectProps2 = CreateObject(GetHashKey("prop_cash_case_02"), offsetCoord2, 1)
                                                local objectRot = GetEntityRotation(objectProps)
                                                SetEntityRotation(objectProps, objectRot.x, objectRot.y, objectRot.z+125.0)
                                                local objectRot2 = GetEntityRotation(objectProps2)
                                                SetEntityRotation(objectProps2, objectRot2.x, objectRot2.y, objectRot2.z+125.0)
                                                hideBulleDeverouiller = true 
                                                Bulle.hide("coffreDeverouiller")
                                                SafeCrackStart()
                                                local timer = 1
                                                while true do 
                                                    Wait(50)
                                                    timer += 1
                                                    local vecRot = GetEntityRotation(obj)
                                                    SetEntityRotation(obj, vecRot.x, vecRot.y, vecRot.z+1.0)
                                                    if timer == 100 then 
                                                        break
                                                    end
                                                end
                                                TriggerServerEvent('core:superette:sync', ObjToNet(obj), GetEntityRotation(obj))
                                                while true do 
                                                    Wait(1)
                                                    if not volerCoffre then
                                                        Bulle.create("ramasserCoffreSup", offsetCoord3, "bulleRamasserDollar", true)
                                                    end
                                                    if GetDistanceBetweenCoords(offsetCoord, GetEntityCoords(PlayerPedId())) < 1.4 then
                                                        if IsControlJustPressed(0, 38) then 
                                                            if DoesEntityExist(objectProps) then
                                                                volerCoffre = true
                                                                Bulle.hide("ramasserCoffreSup")
                                                                p:PlayAnim("mini@repair","fixing_a_ped",1,-1)
                                                                Wait(1500)
                                                                ClearPedTasks(PlayerPedId())
                                                                DeleteEntity(objectProps)
                                                                local var = GetVariable("heist").superette
                                                                local money = math.random(var.winMinCoffre,var.winMaxCoffre)

                                                                if not coordsIsInSouth(p:pos()) then
                                                                    MoneyMultiplication = tonumber(var.MoneyNorthMultiplication) or 1
                                                                end

                                                                exports['vNotif']:createNotification({
                                                                    type = 'DOLLAR',
                                                                    content = ("Vous avez récupéré ~s %s$"):format(money*MoneyMultiplication)
                                                                })
                                                                volerCoffre = false
                                                                Bulle.show("ramasserCoffreSup")
                                                            else
                                                                if DoesEntityExist(objectProps2) then
                                                                    volerCoffre = true
                                                                    Bulle.hide("ramasserCoffreSup")
                                                                    p:PlayAnim("random@domestic","pickup_low",1,-1)
                                                                    Wait(1000)
                                                                    ClearPedTasks(PlayerPedId())
                                                                    DeleteEntity(objectProps2)
                                                                    local var = GetVariable("heist").superette
                                                                    local money = math.random(var.winMinCoffre,var.winMaxCoffre)

                                                                    if not coordsIsInSouth(p:pos()) then
                                                                        MoneyMultiplication = tonumber(var.MoneyNorthMultiplication) or 1
                                                                    end

                                                                    exports['vNotif']:createNotification({
                                                                        type = 'DOLLAR',
                                                                        content = ("Vous avez récupéré ~s %s$"):format(money*MoneyMultiplication)
                                                                    })
                                                                    if Serveur == "FA" then
                                                                        exports['tuto-fa']:HideStep()
                                                                    elseif Serveur == "WL" then
                                                                        exports['tuto-wl']:HideStep()
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end)

                                ::stage1::

                                -- BRAQUAGE
                                if mathrStage == 1 then
                                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 50.0, -1375589668, false))) < 20.0 then
                                        if Serveur == "FA" then
                                            OpenTutoFAInfo("Braquage Superette", "Frappez la caisse pour récupérer l'argent et dévérouillez le coffre de l'arrière boutique")
                                        elseif Serveur == "WL" then
                                            OpenTutoWLInfo("Braquage Superette", "Frappez la caisse pour récupérer l'argent et dévérouillez le coffre de l'arrière boutique")
                                        end
                                    else
                                        if Serveur == "FA" then
                                            OpenTutoFAInfo("Braquage Superette", "Frappez la caisse pour récupérer l'argent")
                                        elseif Serveur == "WL" then
                                            OpenTutoWLInfo("Braquage Superette", "Frappez la caisse pour récupérer l'argent")
                                        end
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
                                                    
                                                            if not coordsIsInSouth(p:pos()) then
                                                                MoneyMultiplication = tonumber(super.MoneyNorthMultiplication) or 1
                                                            end

                                                            local rand = math.random(super.winMin, super.winMax)*MoneyMultiplication
                                                            
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
                                                        OpenTutoFAInfo("Braquage Superette", "Apres avoir frappé les caisses, va récupéré l'argent dans le coffre à l'arrière boutique si il y en a un !")
                                                        countMo = 0
                                                        DeleteEntity(moneyProps)
                                                        ClearPedTasks(PlayerPedId())
                                                    end
                                                end
                                            end
                                        end
                                        if IsEntityPlayingAnim(p:ped(), 'oddjobs@shop_robbery@rob_till','loop',3) and countMo < 9 then 
                                            if IsControlJustPressed(0, 73) then 
                                                    
                                                if not coordsIsInSouth(p:pos()) then
                                                    MoneyMultiplication = tonumber(super.MoneyNorthMultiplication) or 1
                                                end

                                                local mathrand = math.random(super.winMin, super.winMax)*MoneyMultiplication
                                                p:AddItem("money", mathrand*countMo, {})
                                                totalMoney = mathrand*countMo
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
                                                    
                                            if not coordsIsInSouth(p:pos()) then
                                                XPMultiplication = tonumber(super.XPNorthMultiplication) or 1
                                            end

                                            TriggerSecurEvent("core:crew:updateXp", token, tonumber(super.xp*XPMultiplication), "add", p:getCrew(), "superette")
                                            TriggerServerEvent("core:superette", totalMoney, v.name, "quitté la zone")
                                            break
                                        end
                                    end

                                elseif mathrStage == 2 then 
                                    ClearPedTasks(peds[k].id)
                                    Citizen.CreateThread(function()
                                        while (not isPlayerAlrdyBraked) do
                                            Wait(300)

                                            if GetGameTimer() > timer then
                                                isPlayerAlrdyBraked = true
                                                TriggerServerEvent("core:superette", totalMoney, v.name, "Fin du temps")
                                                break
                                            end

                                            if IsPedDeadOrDying(peds[k].id) then
                                                isPlayerAlrdyBraked = true
                                                exports['vNotif']:createNotification({
                                                    type = 'ROUGE',
                                                    content = "~s Apu est mort !!"
                                                })

                                                TriggerServerEvent("core:superette", totalMoney, v.name, "apu mort")
                                                break
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
                                                   
                                                if not coordsIsInSouth(p:pos()) then
                                                    XPMultiplication = tonumber(super.XPNorthMultiplication) or 1
                                                end

                                                TriggerSecurEvent("core:crew:updateXp", token, tonumber(super.xp*XPMultiplication), "add", p:getCrew(), "superette")
                                                TriggerServerEvent("core:superette", totalMoney, v.name, "quitté la zone")
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

                                        if not hasShowednotif then 
                                            hasShowednotif = true
                                            if Serveur == "FA" then
                                                OpenTutoFAInfo("Braquage Superette", "Déverrouillez le coffre de l'arrière boutique")
                                            elseif Serveur == "WL" then
                                                OpenTutoWLInfo("Braquage Superette", "Déverrouillez le coffre de l'arrière boutique")
                                            end
                                        end

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
                                   
                                                if not coordsIsInSouth(p:pos()) then
                                                    MoneyMultiplication = tonumber(super.MoneyNorthMultiplication) or 1
                                                end

                                                local money = 150 + RealRandom(tonumber(super.winMin), tonumber(super.winMax))*MoneyMultiplication
                                                TriggerSecurGiveEvent("core:addItemToInventory"
                                                    , token, "money", money, {})

                                                exports['vNotif']:createNotification({
                                                    type = 'DOLLAR',
                                                    content = ("Vous avez récupéré ~s %s$"):format(money)
                                                })

                                                first = false
                                                totalMoney = totalMoney+money
                                            else
                                    
                                                if not coordsIsInSouth(p:pos()) then
                                                    MoneyMultiplication = tonumber(super.MoneyNorthMultiplication) or 1
                                                end

                                                local money = RealRandom(tonumber(super.winMin), tonumber(super.winMax))*MoneyMultiplication
                                                TriggerSecurGiveEvent("core:addItemToInventory"
                                                    , token, "money", money, {})

                                                exports['vNotif']:createNotification({
                                                    type = 'DOLLAR',
                                                    content = ("Vous avez récupéré ~s %s$"):format(money)
                                                })

                                                totalMoney = totalMoney+money
                                            end
                                            
                                            if totalMoney >= 3600*MoneyMultiplication or not coordsIsInSouth(p:pos()) and totalMoney >= 5600 then
                                                isPlayerAlrdyBraked = true
                                                exports['vNotif']:createNotification({
                                                    type = 'JAUNE',
                                                    content = "La caisse est ~s vide"
                                                })
                                                break
                                            end
                                        end
                                    end

                                    TriggerServerEvent("core:superette", totalMoney)
                                    totalMoney = 0
                                    ClearPedTasks(peds[k].id)
                                    SetEntityCoords(peds[k].id, v.pos.xyz)
                                    SetEntityHeading(peds[k].id, v.pos.w)
                                    peds[k]:setFreeze(true)
                                    SetEntityInvincible(peds[k].id, true)

                                    TriggerServerEvent('core:setPlayerRobberyGood')
                                elseif mathrStage == 3 then 
                                    ClearPedTasks(peds[k].id)
                                    TaskCombatPed(peds[k].id, PlayerPedId(), 0, 16)
                                    while (not isPlayerAlrdyBraked) do
                                        Wait(1)
                                        if IsEntityDead(peds[k].id) then 
                                            mathrStage = 1
                                            goto stage1
                                            break
                                        end
                                    end
                                end

                                isPlayerAlrdyBraked = true
                                
                                --zone.addZone( "ltd_item" .. k,
                                --vector3(v.pos.x, v.pos.y, v.pos.z+1.9),
                                --    "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le magasin",
                                --    function()
                                --        openStore(peds[k].id, v.job) --TODO: fini le menu society
                                --    end,
                                --    false, -- Avoir un marker ou non
                                --    -1, -- Id / type du marker
                                --    0.6, -- La taille
                                --    { 0, 0, 0 }, -- RGB
                                --    0, -- Alpha
                                --    2.5,
                                --    true,
                                --    "bulleEpicerie"
                                --)
                                
                                v.done = false
                            end
                        else
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                content = "~s Reviens plus tard"
                            })
                            Wait(1000)
                        end
                    end
                else
                    DeletePed(peds[k].id)
                    zone.removeZone("ltd_item" .. k)
                end
            else                
                waiting = 500
            end
        end
        Wait(waiting)
    end

    while true do
        for k, v in pairs(superette_robbery) do
            if not (v.job and (GetNumberDuty(v.job) > 0)) then
                if not DoesEntityExist(peds[k].id) then
                    peds[k] = entity:CreatePedLocal("mp_m_shopkeep_01", v.pos.xyz, v.pos.w)
                    peds[k]:setFreeze(true)
                    SetEntityInvincible(peds[k].id, true)
                    SetEntityAsMissionEntity(peds[k].id, 0, 0)
                    SetBlockingOfNonTemporaryEvents(peds[k].id, true)
                    SetPedFleeAttributes(peds[k].id, 0, 0)
                    SetPedCombatAttributes(peds[k].id, 46, true)
                    SetPedFleeAttributes(peds[k].id, 0, 0)
                end
            else
                DeletePed(peds[k].id)
                zone.removeZone("ltd_item" .. k)
            end
        end
        Wait(2500)
    end
end)

--CreateThread(function()
--    while true do
--        for k, v in pairs(superette_epicerie) do
--            if GetNumberDuty("ltdsud") and GetNumberDuty("ltdsud") > 0 then
--                zone.removeZone("ltd_epicerie" .. k)
--            end
--        end
--        Wait(15000)
--    end
--end)

function SACSuperette(entity)
    SetEntityAsMissionEntity(entity)
    NetworkRequestControlOfEntity(entity)
    while not NetworkHasControlOfEntity(entity) do 
        Wait(1)
    end
    DeleteEntity(entity)
    p:PlayAnim("random@domestic","pickup_low",1,-1)
    Wait(1000)
    ClearPedTasks(PlayerPedId())
    local super = GetVariable("heist").superette
    local rand = math.random(super.winMin, super.winMax)
    p:AddItem("money", rand, {})
    exports['vNotif']:createNotification({
        type = 'DOLLAR',
        content = ("Vous avez récupéré ~s %s$"):format(rand)
    })
end

--[[RegisterCommand("testCoffre", function()    
    local volerCoffre = false
    CreateThread(function()
        while (not isPlayerAlrdyBraked) do 
            Wait(1)
            local obj = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 2.0, -1375589668, false)
            if obj then 
                --print("obj", obj)
                if not hideBulleDeverouiller then
                    Bulle.create("coffreDeverouiller", GetEntityCoords(obj), "bulleOuvrirCadenas", true)
                end
                if IsControlJustPressed(0, 38) then 
                    local offsetCoord = GetOffsetFromEntityInWorldCoords(obj, -0.35, 0.30, 0.1)
                    local offsetCoord2 = GetOffsetFromEntityInWorldCoords(obj, -0.35, 0.30, -0.65)
                    RequestModel(GetHashKey("prop_cash_case_02"))
                    while not HasModelLoaded(GetHashKey("prop_cash_case_02")) do Wait(1) end
                    local objectProps = CreateObject(GetHashKey("prop_cash_case_02"), offsetCoord, 1)
                    local objectProps2 = CreateObject(GetHashKey("prop_cash_case_02"), offsetCoord2, 1)
                    local objectRot = GetEntityRotation(objectProps)
                    SetEntityRotation(objectProps, objectRot.x, objectRot.y, objectRot.z+125.0)
                    local objectRot2 = GetEntityRotation(objectProps2)
                    SetEntityRotation(objectProps2, objectRot2.x, objectRot2.y, objectRot2.z+125.0)
                    hideBulleDeverouiller = true 
                    Bulle.hide("coffreDeverouiller")
                    SafeCrackStart()
                    local timer = 1
                    while true do 
                        Wait(50)
                        timer += 1
                        local vecRot = GetEntityRotation(obj)
                        SetEntityRotation(obj, vecRot.x, vecRot.y, vecRot.z+1.0)
                        if timer == 100 then 
                            break
                        end
                    end
                    while true do 
                        Wait(1)
                        if not volerCoffre then
                            Bulle.create("ramasserCoffreSup", offsetCoord, "bulleFouillerDollar", true)
                        end
                        if GetDistanceBetweenCoords(offsetCoord, GetEntityCoords(PlayerPedId())) < 1.4 then
                            if IsControlJustPressed(0, 38) then 
                                if DoesEntityExist(objectProps) then
                                    volerCoffre = true
                                    Bulle.hide("ramasserCoffreSup")
                                    p:PlayAnim("mini@repair","fixing_a_ped",1,-1)
                                    Wait(1500)
                                    ClearPedTasks(PlayerPedId())
                                    DeleteEntity(objectProps)
                                    local var = GetVariable("heist").superette
                                    local money = math.random(var.winMinCoffre,var.winMaxCoffre)
                                    exports['vNotif']:createNotification({
                                        type = 'DOLLAR',
                                        content = ("Vous avez récupéré ~s %s$"):format(money)
                                    })
                                    volerCoffre = false
                                    Bulle.show("ramasserCoffreSup")
                                else
                                    if DoesEntityExist(objectProps2) then
                                        volerCoffre = true
                                        Bulle.hide("ramasserCoffreSup")
                                        p:PlayAnim("random@domestic","pickup_low",1,-1)
                                        Wait(1000)
                                        ClearPedTasks(PlayerPedId())
                                        DeleteEntity(objectProps2)
                                        local var = GetVariable("heist").superette
                                        local money = math.random(var.winMinCoffre,var.winMaxCoffre)
                                        exports['vNotif']:createNotification({
                                            type = 'DOLLAR',
                                            content = ("Vous avez récupéré ~s %s$"):format(money)
                                        })
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end)]]

RegisterNetEvent("core:superette:sync", function(netObj, vec)
    local obj = NetToObj(netObj)
    if obj and DoesEntityExist(obj) then 
        SetEntityRotation(obj, vec)
    end
end)