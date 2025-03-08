local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local Sacs = {
    "vw_prop_casino_shopping_bag_01a",
    "prop_ld_handbag",
    "prop_shopping_bags01", 
}

PedsVol = {
    ["a_f_o_genstreet_01"] = {
        sac = 0,
        nosac = -1,
    },
    ["a_m_m_paparazzi_01"] = {
        sac = 0,
        nosac = -1,
    },
    ["a_f_y_bevhills_02"] = {
        sac = 0,
        nosac = 0,
    },
    ["a_m_y_soucent_01"] = {
        sac = 0,
        nosac = 0,
    },
    ["a_m_y_stbla_01"] = {
        sac = 0,
        nosac = 0,
    },
    ["a_m_y_yoga_01"] = {
        sac = 0,
        nosac = 0,
    },
    ["a_m_y_skater_01"] = {
        sac = 0,
        nosac = -1,
    },
    ["a_m_y_skater_02"] = {
        sac = 0,
        nosac = -1,
    },
    ["a_m_y_soucent_03"] = {
        sac = 0,
        nosac = 0,
    },
}

local multiplication = 1

CreateThread(function()
    local lastnpc = nil
    local PedRobbed = {}
    local checked = false
    while p == nil do Wait(1) end    
    while GetVariable == nil or GetVariable("heist") == nil do Wait(1000) end

    if not DlcIllegal then return end

    --RequestModel(GetHashKey("a_f_o_genstreet_01"))
    --while not HasModelLoaded(GetHashKey("a_f_o_genstreet_01")) do Wait(1) end
    --CreatePed(4, GetHashKey("a_f_o_genstreet_01"), GetEntityCoords(PlayerPedId()), 20.0, 1)
    local hasDrugs = 0
    local showDead = false
    local policeMans = 0
    while true do
        Wait(1)
        local pNear = false
        local closestNPC = GetClosestNPC(10.0)
        local pedPos = GetEntityCoords(closestNPC)

        if p and p:getJob() ~= "lspd" and p:getJob() ~= "lssd" and p:getJob() ~= "usss" and p:getJob() ~= "lsfd" and p:getJob() ~= "ems" and p:getJob() ~= "justice" and p:getJob() ~= "gouv" and p:getJob() ~= "gouv2" then
            if p:getCrew() ~= "None" then
                if pedPos ~= nil then
                    local varArrache = GetVariable("heist").volArrache or { limit = "5", winMax = "1000", XPNorthMultiplication = "1.5", xp = "100", winMin = "600", rebootLimit = "10", cops = "0", influence = "10", active = "true" }
                    --local varArrache = {xp = 100, winMin = 50, winMax = 500, cops = 0, active = "true", limit = 5}
                    if varArrache and varArrache.active ~= "true" then return end
                    local copss = varArrache.cops or 2
                    if GetDistanceBetweenCoords(GetEntityCoords(p:ped()), vector3(2490.32, -264.024, -59.92385)) > 150.0 then
                        if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("weapon_unarmed") then
                            if policeMans >= tonumber(copss) then
                                hasDrugs = HasMultipleDrugs()
                                if not hasDrugs or hasDrugs <= 0 then
                                    if #(p:pos() - vector3(pedPos.x, pedPos.y, pedPos.z)) <= 2 then
                                        pNear = true
                                        if IsEntityPositionFrozen(closestNPC) or
                                            IsPedModel(closestNPC, GetHashKey("mp_m_shopkeep_01")) or
                                            IsPedModel(closestNPC, GetHashKey("mp_m_freemode_01")) or
                                            IsPedModel(closestNPC, GetHashKey("mp_f_weed_01")) or 
                                            IsPedModel(closestNPC, GetHashKey("mp_f_meth_01")) or 
                                            IsPedModel(closestNPC, GetHashKey("s_f_y_shop_low")) or
                                            IsPedDeadOrDying(closestNPC) or
                                            IsPedModel(closestNPC, GetHashKey("mp_s_m_armoured_01")) or
                                            IsPedModel(closestNPC, GetHashKey("mp_f_freemode_01")) then
                                        else
                                            for k,v in pairs(PedsVol) do 
                                                if IsPedModel(closestNPC, GetHashKey(k)) or not IsPedMale(closestNPC) then 
                                                    if not PedRobbed[closestNPC] then
                                                        if lastnpc and lastnpc ~= closestNPC then
                                                            if v.sac then
                                                                SetPedComponentVariation(closestNPC,8,v.sac,0)
                                                            end
                                                        end
                                                        Bulle.create("arracher",vector3(pedPos.x, pedPos.y, pedPos.z+0.9),"bulleArracher",true)
                                                        if IsControlJustPressed(0, 38) then 
                                                            local myLimitServ = TriggerServerCallback("core:getLimitVolArrache")
                                                            if not myLimitServ then 
                                                                myLimitServ = 0
                                                            end
                                                            local limitsac = varArrache.limit or 5
                                                            if myLimitServ < tonumber(limitsac) then
                                                                PedRobbed[closestNPC] = true
                                                                lastnpc = closestNPC
                                                                FreezeEntityPosition(closestNPC, true)
                                                                FreezeEntityPosition(p:ped(), true)
                                                                RequestAnimDict("random@mugging4") 
                                                                --SetEntityHeading(PlayerPedId(), GetEntityHeading(closestNPC)-90)
                                                                --SetEntityHeading(closestNPC, GetEntityHeading(PlayerPedId())-90)
                                                                ClearPedTasksImmediately(PlayerPedId())
                                                                ClearPedTasksImmediately(closestNPC)

                                                                Wait(150)
                                                                local ped = closestNPC
                                                                local playerPed = PlayerPedId()
                                                                local p1 = GetEntityCoords(playerPed, true)
                                                                local p2 = GetEntityCoords(ped, true)

                                                                ActionInTerritoire(p:getCrew(), GetZoneByPlayer(), tonumber(varArrache.influence) or 10, 5, coordsIsInSouth(GetEntityCoords(PlayerPedId())))

                                                                local dx = p2.x - p1.x
                                                                local dy = p2.y - p1.y

                                                                local headingPlayer = GetHeadingFromVector_2d(dx, dy)
                                                                SetEntityHeading(playerPed, headingPlayer) 
                                                                Wait(100)

                                                                local coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
                                                                local pedNewCoord = (coords + forward * 2.0)
                                                                SetEntityCoords(ped, pedNewCoord - vec3(0.0, 0.0, 0.9)) 
                                                                Wait(100)
                                                                local p1 = GetEntityCoords(ped, true)
                                                                local p2 = GetEntityCoords(playerPed, true)

                                                                local dx = p2.x - p1.x
                                                                local dy = p2.y - p1.y
                                                                
                                                                local heading = GetHeadingFromVector_2d(dx, dy)
                                                                SetEntityHeading(ped, heading)
                                                                TriggerServerEvent("core:addLimitVolArrache")

                                                                Wait(500)
                                                                SetEntityHeading(ped, heading)
                                                                SetEntityHeading(playerPed, headingPlayer) 
                                                                local newcoords = GetOffsetFromEntityInWorldCoords(ped, -0.3, 0.0, 0.0)
                                                                print("newcoords", newcoords)
                                                                SetEntityCoords(ped, newcoords - vec3(0.0, 0.0, 0.9))
                                                                p:PlayAnim("random@mugging4", "struggle_loop_b_thief",1)
                                                                while not HasAnimDictLoaded("random@mugging4") do Wait(1) end
                                                                TaskPlayAnim(closestNPC, "random@mugging4", "struggle_loop_b_thief", 1.0, 1.0, -1, 1, 1.0)

                                                                PlayPain(closestNPC, 6)

                                                                local obj = entity:CreateObject(Sacs[math.random(1,#Sacs)], p:pos())
                                                                AttachEntityToEntity(obj:getEntityId(), p:ped(), 
                                                                    GetEntityBoneIndexByName(p:ped(), "IK_R_Hand"), 0.0, 0.0,
                                                                    0.0, -90.0, 0.0, 0.0, false, false, false, false, 0.0, true)
                                                                if coordsIsInSouth(p:pos()) then
                                                                    TriggerSecurEvent('core:makeCall', "lspd", p:pos(), true, "Vol à l'arraché", false, "illegal")
                                                                    TriggerSecurEvent('core:makeCall', "lssd", p:pos(), true, "Vol à l'arraché", false, "illegal") -- FIX_LSSD_LSPD
                                                                    TriggerSecurEvent('core:makeCall', "gcp", p:pos(), true, "Vol à l'arraché", false, "illegal")
                                                                else
                                                                    TriggerSecurEvent('core:makeCall', "lssd", p:pos(), true, "Vol à l'arraché", false, "illegal")
                                                                    TriggerSecurEvent('core:makeCall', "lspd", p:pos(), true, "Vol à l'arraché", false, "illegal") -- FIX_LSSD_LSPD
                                                                end
                                                                SetPedComponentVariation(closestNPC,8,-1,0)
                                                                Bulle.remove("arracher")
                                                                FreezeEntityPosition(closestNPC, false)
                                                                FreezeEntityPosition(p:ped(), false)
                                                                --SendNuiMessage(json.encode({
                                                                --    type = 'openWebview',
                                                                --    name = 'Progressbar',
                                                                --    data = {
                                                                --        text = "Vol en cours...",
                                                                --        time = 4,
                                                                --    }
                                                                --}))
                                                                local randomize = math.random(1,3)
                                                                local reussi = false
                                                                Wait(3000)
                                                                PlayPain(closestNPC, 5)
                                                                Wait(2000)
                                                                PlayPain(closestNPC, 7)
                                                                Wait(2000)
                                                                --obj:delete()
                                                                StopAnimTask(PlayerPedId(), "random@mugging4", "struggle_loop_b_thief", 1.0)
                                                                StopAnimTask(closestNPC, "random@mugging4", "struggle_loop_b_thief", 1.0)
                                                                Wait(500)
                                                                DetachEntity(obj:getEntityId())
                                                                Wait(100)
                                                                if IsEntityDead(closestNPC) and not showDead then 
                                                                    showDead = true
                                                                    if Serveur == "FA" then
                                                                        exports['tuto-fa']:HideStep()
                                                                    elseif Serveur == "WL" then
                                                                        exports['tuto-wl']:HideStep()
                                                                    end
                                                                end
                                                                if randomize == 1 then -- FRAPPE
                                                                    --DetachEntity(obj:getEntityId())
                                                                    --SetEntityVisible(obj:getEntityId(),false)
                                                                    TaskCombatPed(closestNPC, PlayerPedId(), 0, 16)
                                                                    
                                                                    --AttachEntityToEntity(obj:getEntityId(), closestNPC, 
                                                                    --GetEntityBoneIndexByName(closestNPC, "IK_R_Hand"), 0.0, 0.0,
                                                                    --0.0, -90.0, 0.0, 0.0, false, false, false, false, 0.0, true)
                                                                    if Serveur == "FA" then
                                                                        OpenTutoFAInfo("Vol à l'arraché", "Frappe la personne pour la mettre au sol")
                                                                    elseif Serveur == "WL" then
                                                                        OpenTutoWLInfo("Vol à l'arraché", "Frappe la personne pour la mettre au sol")
                                                                    end
                                                                    showBulle = true
                                                                    reussi = true
                                                                    while true do 
                                                                        Wait(1)
                                                                        if not DoesEntityExist(closestNPC) or GetDistanceBetweenCoords(GetEntityCoords(p:ped()), GetEntityCoords(closestNPC)) > 50.0 then 
                                                                            if Serveur == "FA" then
                                                                                exports['tuto-fa']:HideStep()
                                                                            elseif Serveur == "WL" then
                                                                                exports['tuto-wl']:HideStep()
                                                                            end
                                                                            reussi = false 
                                                                            break
                                                                        end
                                                                        if GetDistanceBetweenCoords(GetEntityCoords(p:ped()), GetEntityCoords(closestNPC)) < 2.0 then 
                                                                            if IsPedDeadOrDying(closestNPC) then
                                                                                if showBulle then
                                                                                    Bulle.create("fouillerSac", GetEntityCoords(closestNPC), "bulleRamasserSac",true)
                                                                                end
                                                                                if IsControlJustPressed(0, 38) then
                                                                                    showBulle = false
                                                                                    TaskStartScenarioInPlace(PlayerPedId(),'PROP_HUMAN_BUM_BIN')
                                                                                    Bulle.remove("fouillerSac")
                                                                                    if Serveur == "FA" then
                                                                                        exports['tuto-fa']:HideStep()
                                                                                    elseif Serveur == "WL" then
                                                                                        exports['tuto-wl']:HideStep()
                                                                                    end
                                                                                    Wait(4000)
                                                                                    ClearPedTasks(PlayerPedId())
                                                                                    DeleteEntity(phoneProp)
                                                                                    reussi = true
                                                                                    break
                                                                                end
                                                                            end
                                                                        else
                                                                            Bulle.remove("fouillerSac")
                                                                        end
                                                                    end
                                                                    if reussi then

                                                                        if not coordsIsInSouth(p:pos()) then
                                                                            multiplication = varArrache.XPNorthMultiplication
                                                                        end

                                                                        TriggerSecurEvent("core:crew:updateXp", token, tonumber(varArrache.xp*multiplication) or 5, "add", p:getCrew(), "vol arrache")
                                                                        exports['vNotif']:createNotification({
                                                                            type = 'VERT',
                                                                            -- duration = 5, -- In seconds, default:  4
                                                                            content = "T'as récupéré le sac, cours !"
                                                                        })
                                                                        SetEntityVisible(obj:getEntityId(),true)
                                                                        AttachEntityToEntity(obj:getEntityId(), p:ped(), GetEntityBoneIndexByName(p:ped(), "IK_R_Hand"), 0.0, 0.0,
                                                                            0.0, 0.0, -90.0, 0.0, false, false, false, false, 0.0, true)
                                                                        Wait(5000)
                                                                        local showBulle = true
                                                                        while true do 
                                                                            Wait(1)
                                                                            if showBulle then
                                                                                Bulle.create("fouiller", GetEntityCoords(PlayerPedId()) + vector3(0.0,0.0,0.9), "bulleFouiller",true)
                                                                            end
                                                                            if IsControlJustPressed(0, 38) then       
                                                                                showBulle = false                                      
                                                                                TaskStartScenarioInPlace(PlayerPedId(),'PROP_HUMAN_BUM_BIN')
                                                                                Bulle.remove("fouiller")
                                                                                --DetachEntity(obj:getEntityId())
                                                                                --FreezeEntityPosition(obj:getEntityId(), true)
                                                                                --local coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
                                                                                --local pedNewCoord = (coords + forward * 0.2)
                                                                                --local ground, zeee = GetGroundZFor_3dCoord(pedNewCoord)
                                                                                --SetEntityCoords(obj:getEntityId(), pedNewCoord.x, pedNewCoord.y, zeee) 
                                                                                Wait(4000)
                                                                                ClearPedTasks(PlayerPedId())
                                                                                TriggerSecurEvent("core:volarracheitems", math.floor(math.random(tonumber(varArrache.winMin) or 50, tonumber(varArrache.winMax) or 100)))
                                                                                exports['vNotif']:createNotification({
                                                                                    type = 'JAUNE',
                                                                                    -- duration = 5, -- In seconds, default:  4
                                                                                    content = "Vous avez fouillé le sac"
                                                                                })
                                                                                obj:delete()
                                                                                break
                                                                            end
                                                                        end
                                                                    end
                                                                    Bulle.remove("fouiller")
                                                                elseif randomize == 2 then -- FUIS
                                                                    DetachEntity(obj:getEntityId())
                                                                    AttachEntityToEntity(obj:getEntityId(), closestNPC, 
                                                                        GetEntityBoneIndexByName(closestNPC, "IK_R_Hand"), 0.0, 0.0,
                                                                        0.0, 0.0, -90.0, 0.0, false, false, false, false, 0.0, true)
                                                                    PlayPain(closestNPC, 5, 0.0)
                                                                    TaskSmartFleePed(closestNPC, PlayerPedId(), 999.9, -1, true,true)
                                                                    if Serveur == "FA" then
                                                                        OpenTutoFAInfo("Vol à l'arraché", "Rattrape la personne et frappe là pour la mettre au sol")
                                                                    elseif Serveur == "WL" then
                                                                        OpenTutoWLInfo("Vol à l'arraché", "Rattrape la personne et frappe là pour la mettre au sol")
                                                                    end
                                                                    showBulle = true
                                                                    reussi = true
                                                                    while true do 
                                                                        Wait(1)
                                                                        if not DoesEntityExist(closestNPC) or GetDistanceBetweenCoords(GetEntityCoords(p:ped()), GetEntityCoords(closestNPC)) > 50.0 then 
                                                                            if Serveur == "FA" then
                                                                                exports['tuto-fa']:HideStep()
                                                                            elseif Serveur == "WL" then
                                                                                exports['tuto-wl']:HideStep()
                                                                            end
                                                                            reussi = false 
                                                                            break
                                                                        end
                                                                        if GetDistanceBetweenCoords(GetEntityCoords(p:ped()), GetEntityCoords(closestNPC)) < 2.0 then 
                                                                            if IsPedDeadOrDying(closestNPC) then
                                                                                if showBulle then
                                                                                    Bulle.create("fouillerSac", GetEntityCoords(closestNPC), "bulleRamasserSac",true)
                                                                                end
                                                                                if IsControlJustPressed(0, 38) then
                                                                                    showBulle = false
                                                                                    TaskStartScenarioInPlace(PlayerPedId(),'PROP_HUMAN_BUM_BIN')
                                                                                    Bulle.remove("fouillerSac")
                                                                                    if Serveur == "FA" then
                                                                                        exports['tuto-fa']:HideStep()
                                                                                    elseif Serveur == "WL" then
                                                                                        exports['tuto-wl']:HideStep()
                                                                                    end
                                                                                    Wait(4000)
                                                                                    ClearPedTasks(PlayerPedId())
                                                                                    DeleteEntity(phoneProp)
                                                                                    break
                                                                                end
                                                                            end
                                                                        else
                                                                            Bulle.remove("fouillerSac")
                                                                        end
                                                                    end
                                                                    if reussi then

                                                                        if not coordsIsInSouth(p:pos()) then
                                                                            multiplication = varArrache.XPNorthMultiplication
                                                                        end

                                                                        TriggerSecurEvent("core:crew:updateXp", token, tonumber(varArrache.xp*multiplication) or 50, "add", p:getCrew(), "vol arrache")
                                                                        exports['vNotif']:createNotification({
                                                                            type = 'VERT',
                                                                            -- duration = 5, -- In seconds, default:  4
                                                                            content = "T'as récupéré le sac, cours !"
                                                                        })
                                                                        DetachEntity(obj:getEntityId())
                                                                        AttachEntityToEntity(obj:getEntityId(), p:ped(), 
                                                                            GetEntityBoneIndexByName(p:ped(), "IK_R_Hand"), 0.0, 0.0,
                                                                            0.0, 0.0, -90.0, 0.0, false, false, false, false, 0.0, true)
                                                                        Wait(5000)
                                                                        local showBulle = true
                                                                        while true do 
                                                                            Wait(1)
                                                                            if showBulle then
                                                                                Bulle.create("fouiller", GetEntityCoords(PlayerPedId()) + vector3(0.0,0.0,0.9), "bulleFouiller",true)
                                                                            end
                                                                            if IsControlJustPressed(0, 38) then       
                                                                                showBulle = false                                      
                                                                                TaskStartScenarioInPlace(PlayerPedId(),'PROP_HUMAN_BUM_BIN')
                                                                                Bulle.remove("fouiller")
                                                                                Wait(4000)
                                                                                ClearPedTasks(PlayerPedId())
                                                                                TriggerSecurEvent("core:volarracheitems", math.floor(math.random(varArrache.winMin or 1, varArrache.winMax or 2)))
                                                                                exports['vNotif']:createNotification({
                                                                                    type = 'JAUNE',
                                                                                    -- duration = 5, -- In seconds, default:  4
                                                                                    content = "Vous avez fouillé le sac"
                                                                                })
                                                                                obj:delete()
                                                                                break
                                                                            end
                                                                        end
                                                                    end
                                                                    Bulle.remove("fouiller")
                                                                else
                                                                    AttachEntityToEntity(obj:getEntityId(), p:ped(), 
                                                                        GetEntityBoneIndexByName(p:ped(), "IK_R_Hand"), 0.0, 0.0,
                                                                        0.0, 0.0, -90.0, 0.0, false, false, false, false, 0.0, true)

                                                                    if not coordsIsInSouth(p:pos()) then
                                                                        multiplication = varArrache.XPNorthMultiplication
                                                                    end
                                                                    TriggerSecurEvent("core:crew:updateXp", token, tonumber(varArrache.xp*multiplication) or 10, "add", p:getCrew(), "vol arrache")
                                                                    exports['vNotif']:createNotification({
                                                                        type = 'VERT',
                                                                        -- duration = 5, -- In seconds, default:  4
                                                                        content = "T'as récupéré le sac, cours !"
                                                                    })
                                                                    RequestAnimDict("cellphone@")
                                                                    while not HasAnimDictLoaded("cellphone@") do Wait(1) end
                                                                    TaskPlayAnim(closestNPC, 'cellphone@','cellphone_call_listen_base',1.0,1.0,-1,49,1.0)
                                                                    local phoneModel = `prop_amb_phone`
                                                                    RequestModel(phoneModel)
                                                                    while not HasModelLoaded(phoneModel) do
                                                                        Wait(1)
                                                                    end
                                                                    local phoneProp = CreateObject(phoneModel, 1.0, 1.0, 1.0, 1, 1, 0)
                                                                    local bone = GetPedBoneIndex(closestNPC, 28422)
                                                                    AttachEntityToEntity(phoneProp, closestNPC, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
                                                                    TaskSmartFleePed(closestNPC, PlayerPedId(), 999.9, -1, true,true)
                                                                    Wait(5000)
                                                                    DeleteEntity(phoneProp)
                                                                    local showBulle = true
                                                                    while true do 
                                                                        Wait(1)
                                                                        if showBulle then
                                                                            Bulle.create("fouiller", GetEntityCoords(PlayerPedId()) + vector3(0.0,0.0,0.9), "bulleFouiller",true)
                                                                        end
                                                                        if IsControlJustPressed(0, 38) then       
                                                                            showBulle = false                                      
                                                                            TaskStartScenarioInPlace(PlayerPedId(),'PROP_HUMAN_BUM_BIN')
                                                                            Bulle.remove("fouiller")
                                                                            Wait(4000)
                                                                            ClearPedTasks(PlayerPedId())
                                                                            TriggerSecurEvent("core:volarracheitems", math.floor(math.random(tonumber(varArrache.winMin) or 1, tonumber(varArrache.winMax) or 2)))
                                                                            exports['vNotif']:createNotification({
                                                                                type = 'JAUNE',
                                                                                -- duration = 5, -- In seconds, default:  4
                                                                                content = "Vous avez fouillé le sac"
                                                                            })
                                                                            obj:delete()
                                                                            break
                                                                        end
                                                                    end
                                                                    Bulle.remove("fouiller")                                        
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    else
                                        if closestNPC then
                                            Bulle.remove("arracher")
                                        end
                                        Wait(500)
                                    end
                                else
                                    if closestNPC then
                                        Bulle.remove("arracher")
                                    end
                                    Wait(200)
                                end
                            else
                                Bulle.remove("arracher")
                                policeMans = (GlobalState['serviceCount_lspd'] or 0) + (GlobalState['serviceCount_lssd'] or 0)
                                Wait(5000)
                            end
                        else
                            Bulle.remove("arracher")
                            Wait(500)
                        end
                    end
                else
                    Wait(500)
                end
            else
                Wait(2500)
            end
        else
            Wait(2000)
        end
    end
end)

local RollTable = {}
local sizeOfItemList = 0
for k, v in pairs(House_heist_Item) do
    sizeOfItemList = sizeOfItemList + 1
end
-- sizeOfItemList = 18 pour l'instant
for i = 1, sizeOfItemList do
    for j = 1, House_heist_Item[i].luck do
        table.insert(RollTable, House_heist_Item[i])
    end
end

local function Roll() --> ObjectName [string]
    return RollTable[math.random(1, #RollTable)]
end

RegisterNetEvent("core:usesacvole", function()
    local item = Roll()
    local item2 = Roll()
    if Serveur == "FA" then 
        TriggerSecurGiveEvent("core:addItemToInventory", token, item.label, math.random(1,3), {})
        TriggerSecurGiveEvent("core:addItemToInventory", token, item2.label, math.random(1,3), {})
        Wait(200)
        TriggerSecurGiveEvent("core:addItemToInventory", token, "money", math.random(50,100), {})
    else
        TriggerServerEvent("core:addItemToInventory", token, item.label, math.random(1,3), {})
        TriggerServerEvent("core:addItemToInventory", token, item2.label, math.random(1,3), {})
        Wait(200)
        TriggerServerEvent("core:addItemToInventory", token, "money", math.random(50,100), {})
    end    
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        -- duration = 5, -- In seconds, default:  4
        content = "Vous avez trouvé un(e) ~s " .. item.item
    })
end)