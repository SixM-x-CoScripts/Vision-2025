CreateThread(function()
    local lastnpc = nil
    local PedRobbed = {}
    local CanRaquette = false
    local checked = false
    local haschecked = false 
    local timerCheck = 1
    --while p == nil do Wait(1000) end    
    while GetVariable == nil or GetVariable("heist") == nil do Wait(1000) end

    if not DlcIllegal then return end
    local hasDrugs = 0
    while true do
        Wait(1)
        local pNear = false
        local closestNPC = GetClosestNPC(10.0)
        local pedPos = GetEntityCoords(closestNPC)

        if p and p:getJob() ~= "lspd" and p:getJob() ~= "lssd" and p:getJob() ~= "usss" and p:getJob() ~= "lsfd" and p:getJob() ~= "ems" and p:getJob() ~= "justice" and p:getJob() ~= "gouv" and p:getJob() ~= "gouv2" then
            if IsPedArmed(PlayerPedId(), 1) then
                if GetDistanceBetweenCoords(GetEntityCoords(p:ped()), vector3(2490.32, -264.024, -59.92385)) > 100.0 then
                    if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("weapon_knife") or GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("weapon_switchblade") or GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("weapon_machete") or GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("weapon_dagger") then
                        if pedPos ~= nil then
                            local RaquetteVar = GetVariable("heist").raquette
                            --local RaquetteVar = {xp = 100, winMin = 50, winMax = 500, cops = 0, active = "true", limit = 5}
                            --if RaquetteVar and RaquetteVar.active == "true" then end
                            if not hashckeced then 
                                haschecked = true
                                timerCheck = 1
                                policeNumber = ((GlobalState['serviceCount_lspd'] or 0) + (GlobalState['serviceCount_lssd'] or 0))
                            else
                                timerCheck = timerCheck + 1
                                if timerCheck >= 1000 then
                                    hashckeced = false
                                end
                            end
                            if (policeNumber) >= tonumber(RaquetteVar.cops) then
                                hasDrugs, hasBool = HasMultipleDrugs()
                                if not hasBool then
                                    if #(p:pos() - vector3(pedPos.x, pedPos.y, pedPos.z)) <= 2 then
                                        pNear = true
                                        if IsEntityPositionFrozen(closestNPC) or 
                                            IsEntityDead(closestNPC) or 
                                            IsPedModel(closestNPC, GetHashKey("mp_m_shopkeep_01")) or
                                            IsPedModel(closestNPC, GetHashKey("s_f_y_shop_low")) or
                                            IsPedModel(closestNPC, GetHashKey("mp_m_freemode_01")) or
                                            IsPedModel(closestNPC, GetHashKey("mp_f_freemode_01")) or
                                            IsPedModel(closestNPC, GetHashKey("mp_s_m_armoured_01")) then
                                        else
                                            if not PedRobbed[closestNPC] then
                                                if CanAccessAction('Racket') then
                                                    Bulle.create("raquette",vector3(pedPos.x, pedPos.y, pedPos.z+0.9),"bulleRaquetter",true)
                                                    if (IsControlJustPressed(0, 38) or IsControlPressed(0, 38)) and not CanRaquette then 
                                                        CanRaquette = true
                                                        if Serveur == "FA" then
                                                            exports['tuto-fa']:GoToSpecialStep(1)
                                                        elseif Serveur == "WL" then
                                                            exports['tuto-wl']:GoToSpecialStep(1)
                                                        end
                                                        CanRaquette = true                                         
                                                    end
                                                    if IsControlJustPressed(0, 25) or IsPedInMeleeCombat(p:ped()) == 1 and CanRaquette then 
                                                        local myLimitServ = TriggerServerCallback("core:getLimitRaquette")
                                                        if not myLimitServ then 
                                                            myLimitServ = 0
                                                        end
                                                        if myLimitServ < tonumber(RaquetteVar.limit) then
                                                            Bulle.remove("raquette")
                                                            PedRobbed[closestNPC] = true
                                                            lastnpc = closestNPC
                                                            RequestAnimDict("random@mugging4") 
                                                            while not HasAnimDictLoaded("random@mugging4") do Wait(1) end
                                                            local ped = closestNPC
                                                            local playerPed = PlayerPedId()

                                                            local p1 = GetEntityCoords(ped, true)
                                                            local p2 = GetEntityCoords(playerPed, true)

                                                            local dx = p2.x - p1.x
                                                            local dy = p2.y - p1.y

                                                            ActionInTerritoire(p:getCrew(), GetZoneByPlayer(), RaquetteVar.influence or 15, 12, coordsIsInSouth(GetEntityCoords(PlayerPedId())))
                                                            
                                                            local coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
                                                            local pedNewCoord = (coords + forward * 1.5)
                                                            SetEntityCoords(ped, pedNewCoord - vec3(0.0, 0.0, 0.9)) 

                                                            local heading = GetHeadingFromVector_2d(dx, dy)
                                                            SetEntityHeading(ped, heading)

                                                            local mathrand = math.random(1, 3)

                                                            Wait(700)

                                                            local isInSouth = coordsIsInSouth(GetEntityCoords(PlayerPedId()))
                                                            if isInSouth then
                                                                TriggerSecurEvent('core:makeCall', "lspd", GetEntityCoords(PlayerPedId()), true, "Racket", false, "illegal")
                                                                TriggerSecurEvent('core:makeCall', "lssd", GetEntityCoords(PlayerPedId()), true, "Racket", false, "illegal") -- FIX_LSSD_LSPD
                                                            else
                                                                TriggerSecurEvent('core:makeCall', "lssd", GetEntityCoords(PlayerPedId()), true, "Racket", false, "illegal")
                                                                TriggerSecurEvent('core:makeCall', "lspd", GetEntityCoords(PlayerPedId()), true, "Racket", false, "illegal") -- FIX_LSSD_LSPD
                                                            end
                                                            

                                                            if Serveur == "FA" then
                                                                exports['tuto-fa']:HideStep()
                                                            elseif Serveur == "WL" then
                                                                exports['tuto-wl']:HideStep()
                                                            end

                                                            TriggerServerEvent("core:addLimitRobbery")

                                                            if mathrand == 2 then 
                                                                PlayPain(closestNPC, 5, 0.0)
                                                                TaskSmartFleePed(closestNPC, PlayerPedId(), 999.9, -1, true,true)
                                                                if Serveur == "FA" then
                                                                    exports['tuto-fa']:GoToSpecialStep(2)
                                                                elseif Serveur == "WL" then
                                                                    exports['tuto-wl']:GoToSpecialStep(2)
                                                                end
                                                            elseif mathrand == 3 then 
                                                                SetEntityAsMissionEntity(closestNPC, true,true)
                                                                NetworkRequestControlOfEntity(closestNPC)
                                                                SetBlockingOfNonTemporaryEvents(closestNPC, true)
                                                                TaskCombatPed(closestNPC, PlayerPedId(), 0, 16)
                                                                SetPedCombatAttributes(closestNPC, 5, true)
                                                                SetPedCombatAttributes(closestNPC, 13, true)
                                                                if Serveur == "FA" then
                                                                    exports['tuto-fa']:GoToSpecialStep(3)
                                                                elseif Serveur == "WL" then
                                                                    exports['tuto-wl']:GoToSpecialStep(3)
                                                                end
                                                            else
                                                                ClearPedTasksImmediately(closestNPC)
                                                                SetEntityAsMissionEntity(closestNPC, true,true)
                                                                NetworkRequestControlOfEntity(closestNPC)
                                                                SetBlockingOfNonTemporaryEvents(closestNPC, true)
                                                                Wait(200)
                                                                PlayPain(closestNPC, 5, 0.0)
                                                                RequestAnimDict("random@domestic")
                                                                while not HasAnimDictLoaded("random@domestic") do Wait(1) end
                                                                TaskPlayAnim(closestNPC, "random@domestic", "f_distressed_loop", 1.0, 1.0, -1, 1, 1.0)
                                                            end
                                                            Wait(2500)
                                                            CanRaquette = false
                                                            if mathrand == 1 then
                                                                local coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
                                                                local pedNewCoord = (coords + forward * 1.1)
                                                                SetEntityCoords(closestNPC, pedNewCoord - vec3(0.0, 0.0, 0.9)) 
                                                                TaskPlayAnim(closestNPC, "random@domestic", "f_distressed_loop", 1.0, 1.0, -1, 1, 1.0)
                                                            end
                                                            local showNotifFouille = true
                                                            while true do 
                                                                Wait(1)
                                                                if not DoesEntityExist(closestNPC) then 
                                                                    if Serveur == "FA" then
                                                                        exports['tuto-fa']:HideStep()
                                                                    elseif Serveur == "WL" then
                                                                        exports['tuto-wl']:HideStep()
                                                                    end
                                                                    break
                                                                end
                                                                if showNotifFouille then
                                                                    if not IsPedFleeing(closestNPC) then
                                                                        if mathrand ~= 2 then
                                                                            if not IsPedInCombat(closestNPC, PlayerPedId()) then
                                                                                Bulle.create("fouilleRaquette", GetEntityCoords(closestNPC) + vec3(0.0, 0.0, 0.9), "bulleFouillerMain", true)
                                                                            end
                                                                        end
                                                                    end
                                                                    if IsEntityDead(closestNPC) then 
                                                                        Bulle.create("fouilleRaquette", GetEntityCoords(closestNPC) + vec3(0.0, 0.0, 0.9), "bulleFouillerMain", true)
                                                                    end
                                                                end
                                                                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(closestNPC)) < 2.0 then 
                                                                    if IsControlJustPressed(0, 38) then 
                                                                        if Serveur == "FA" then
                                                                            exports['tuto-fa']:HideStep()
                                                                        elseif Serveur == "WL" then
                                                                            exports['tuto-wl']:HideStep()
                                                                        end
                                                                        if not IsEntityDead(closestNPC) then 
                                                                            local playerPed = PlayerPedId()
                                                                            local p1 = GetEntityCoords(closestNPC, true)
                                                                            local p2 = GetEntityCoords(playerPed, true)
                            
                                                                            local dx = p2.x - p1.x
                                                                            local dy = p2.y - p1.y
                                                                                            
                                                                            local heading = GetHeadingFromVector_2d(dx, dy)
                                                                            SetEntityHeading(closestNPC, heading)

                                                                            showNotifFouille = false
                                                                            local coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
                                                                            local pedNewCoord = (coords + forward * 1.0)
                                                                            SetEntityCoords(closestNPC, pedNewCoord - vec3(0.0, 0.0, 0.9)) 
                                                                            LoadDict('mp_common')
                                                                            TaskPlayAnim(PlayerPedId(), "mp_common", "givetake1_a", 1.0, 1.0, -1, 1, 1.0)
                                                                            TaskPlayAnim(closestNPC, "mp_common", "givetake1_a", 1.0, 1.0, -1, 1, 1.0)
                                                                            Bulle.remove("fouilleRaquette")
                                                                            local moneyprop = GetHashKey("bkr_prop_money_sorted_01")
                                                                            TaskPlayAnim(PlayerPedId(), "mp_common", "givetake1_a", 1.0, 1.0, -1, 1, 1.0)
                                                                            TaskPlayAnim(closestNPC, "mp_common", "givetake1_a", 1.0, 1.0, -1, 1, 1.0)
                                                                            local moneyProp = CreateObject(moneyprop, 1.0, 1.0, 1.0, 1, 1, 0)
                                                                            local bone = GetPedBoneIndex(closestNPC, 28422)
                                                                            AttachEntityToEntity(moneyProp, closestNPC, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
                                                                            Wait(1000)
                                                                            DeleteEntity(moneyProp)
                                                                            local moneyProp = CreateObject(moneyprop, 1.0, 1.0, 1.0, 1, 1, 0)
                                                                            local bone = GetPedBoneIndex(PlayerPedId(), 28422)
                                                                            AttachEntityToEntity(moneyProp, PlayerPedId(), bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
                                                                            Wait(1000)
                                                                            DeleteEntity(moneyProp)
                                                                            local moneyGiven = math.floor(math.random(RaquetteVar.winMin, RaquetteVar.winMax))
                                                                            exports['vNotif']:createNotification({
                                                                                type = 'JAUNE',
                                                                                -- duration = 5, -- In seconds, default:  4
                                                                                content = "Vous avez récupéré "..moneyGiven.."$ !"
                                                                            })
                                                                            Wait(500)
                                                                            ClearPedTasks(PlayerPedId())
                                                                            ClearPedTasks(closestNPC)
                                                                            p:AddItem("money", moneyGiven, {})
                                                                            TaskSmartFleePed(closestNPC, PlayerPedId(), 999.9, -1, true,true)
                                                                            break
                                                                        else
                                                                            mathrand = 0
                                                                            local moneyprop = GetHashKey("bkr_prop_money_sorted_01")
                                                                            showNotifFouille = false
                                                                            TaskStartScenarioInPlace(PlayerPedId(),'PROP_HUMAN_BUM_BIN')
                                                                            Bulle.remove("fouilleRaquette")
                                                                            Wait(500)
                                                                            local moneyProp = CreateObject(moneyprop, 1.0, 1.0, 1.0, 1, 1, 0)
                                                                            local bone = GetPedBoneIndex(PlayerPedId(), 28422)
                                                                            AttachEntityToEntity(moneyProp, PlayerPedId(), bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
                                                                            Wait(1000)
                                                                            DeleteEntity(moneyProp)
                                                                            local moneyGiven = math.floor(math.random(RaquetteVar.winMin, RaquetteVar.winMax))
                                                                            exports['vNotif']:createNotification({
                                                                                type = 'JAUNE',
                                                                                -- duration = 5, -- In seconds, default:  4
                                                                                content = "Vous avez récupéré "..moneyGiven.."$ !"
                                                                            })
                                                                            Wait(1000)
                                                                            ClearPedTasks(PlayerPedId())
                                                                            p:AddItem("money", moneyGiven, {})
                                                                            break
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                            --Wait(2000)
                                                            Bulle.remove("raquette")
                                                        else
                                                            exports['vNotif']:createNotification({
                                                                type = 'ROUGE',
                                                                -- duration = 5, -- In seconds, default:  4
                                                                content = "Tu ne fais plus peur à personne !"
                                                            })
                                                            Wait(2500)
                                                        end
                                                    end
                                                else
                                                    Wait(60000)
                                                end
                                            else
                                                Bulle.remove("raquette")
                                            end
                                        end
                                    else
                                        Bulle.remove("raquette")
                                        --Wait(200)
                                    end
                                else
                                    Bulle.remove("raquette")
                                --  Wait(200)
                                end
                            else
                                Wait(5000)
                            end
                        else
                            Wait(500)
                        end
                    else
                        Bulle.remove("raquette")
                        Wait(500)
                    end
                end
            else
                Bulle.remove("raquette")
                Wait(1000)
            end
        else
            Wait(2000)
        end
    end
end)