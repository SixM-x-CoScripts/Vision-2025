local peds = {}
local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)
local inMission = false
CreateThread(function()
    --BulleInfo
    while GoFast == nil do Wait(100) end
    while p == nil do Wait(100) end
    if CanAccessAction('Gofast') then
        for k, v in pairs(GoFast) do
            Bulle.add("INFORMATEUR" .. k, vector3(v.peds.x, v.peds.y, v.peds.z),
                function()
                    RobertoBulle("gofast" .. k, vector3(v.peds.x, v.peds.y, v.peds.z + 1), 'bulleInformation', 255, 0)
                end,
                function()
                    local isInSouth = coordsIsInSouth(v.peds)
                    local policeMans = nil
                    if isInSouth then
                        policeMans = GlobalState['serviceCount_lspd'] or 0
                    else
                        policeMans = GlobalState['serviceCount_lssd'] or 0
                    end
                    local gf1 = GetVariable("heist").gofast1
                    if not inMission and policeMans >= tonumber(gf1.cops) and TriggerServerCallback("gofast:AlreadyDidGoFast1", token, p:getId()) and tostring(gf1.active) == "true" then
                        local phone = TriggerServerCallback("core:GetNumber", token)
                        if phone ~= nil then
                            inMission = true
                            CreateThread(function()
                                Visual.Subtitle("Yo mon petit, j'ai besoin de toi pour me récuperer une cargaison", 3000)
                                Modules.UI.RealWait(3000)
                                Visual.Subtitle("je vais t'envoyer toutes les informations un peu plus tard. ", 3000)
                                Modules.UI.RealWait(3000)
                                Visual.Subtitle("Maintenant BOUGE ! ", 2000)
                                Modules.UI.RealWait(5 * 1000) -- 5 Minute
                                CreateMissionGoFast(v)
                                TriggerSecurEvent("core:crew:updateXp", token, gf1.xp, "add", p:getCrew(), "gofast1")
                            end)
                        else
                            Visual.Subtitle("Va t'acheter un téléphone que je puisse te contacter et reviens me voir", 2000)
                        end
                    else
                        Visual.Subtitle("J'ai pas besoin de toi petit, bouge de la avant que tu le regrette", 2000)
                    end
                end)
            peds[k] = entity:CreatePedLocal(v.modelPed, vector3(v.peds.x, v.peds.y, v.peds.z - 1.0), v.peds.w)
            TaskStartScenarioInPlace(peds.id, "WORLD_HUMAN_DRUG_DEALER", -1, true)
            Wait(1000)
            SetEntityInvincible(peds[k].id, true)
            FreezeEntityPosition(peds[k].id, true)
            --CreatePed
        end
    end
end)


function CreateMissionGoFast(data)
    inMission = true
    local take = false
    local random = math.random(1, #data.mission)
    local firstSms = false
    local finishMess = false
    local secondMess = false
    local veh = nil
    local objectCreated = false
    local thirdMessage = false
    local payMess = false
    local index = 1
    local object = {}
    local recup = 0
    local pedsLiraison = nil
    local HaveBag = false
    local TextLast = false
    local vehLivraison = nil
    local bag = nil
    local notif = {}
    local flic1 = false
    local flic2 = false
    local pay = false
    local payed = false
    local props = {
        offset = { 0.449, 0.02, -0.041, 3.1, -88.09, 0.0 }
    }
    while inMission do
        local pNear = false

        --Send First Sms
        if not firstSms then
            firstSms = true
            TriggerServerEvent("gofast:firstSms", token,
                vector2(data.mission[random].vehicle.pos.x, data.mission[random].vehicle.pos.y))
            -- TriggerServerEvent("phone:AnonymeCall", "687-6543", data.mission[random].vehicle.pos.xyz,
            --     "Tiens récupère le véhicule les clés sont dedans je t'enverrais les instructions une fois le véhicule récuperer.")
        end

        --Premiere Phase de récupération de véhicule
        if #(p:pos() - data.mission[random].vehicle.pos.xyz) <= 50 and not secondMess then
            if not data.mission[random].vehicle.create then
                data.mission[random].vehicle.create = true
                veh = vehicle.create(data.mission[random].vehicle.model, data.mission[random].vehicle.pos, {})
            end

            if IsPedSittingInVehicle(p:ped(), veh) then
                if not secondMess then
                    secondMess = true
                    TriggerServerEvent("gofast:secondSms", token,
                        vector2(data.mission[random].loot[1].x, data.mission[random].loot[1].y))
                    -- TriggerServerEvent("phone:AnonymeCall", "687-6543", data.mission[random].loot[1].xyz,
                    --     "La cargaison est située a l'endroit que je t'envoie, n'oublie rien sinon tu le regretteras.")
                end
            end
            pNear = true
        end
        --Second Phase loot
        if #(p:pos() - data.mission[random].loot[1].xyz) <= 50 then

            if not objectCreated then
                objectCreated = true
                for i = 1, #data.mission[random].loot do
                    notif[i] = false
                    local _, groundZ = GetGroundZFor_3dCoord(data.mission[random].loot[i].x, data.mission[random].loot[i].y, data.mission[random].loot[i].z, false);
                    object[i] = entity:CreateObject("prop_money_bag_01", vector3(data.mission[random].loot[i].x, data.mission[random].loot[i].y, groundZ))
                    FreezeEntityPosition(object[i].id, true)
                end
            end
            if objectCreated then
                for i = 1, #object do

                    --CreateBulle de bg
                    if not notif[i] then
                        notif[i] = true
                        Bulle.add("bagGofast" .. i,
                            vector3(GetEntityCoords(object[i].id).x, GetEntityCoords(object[i].id).y,
                                GetEntityCoords(object[i].id).z),
                            function()
                                RobertoBulle("ped" .. i,
                                    vector3(GetEntityCoords(object[i].id).x, GetEntityCoords(object[i].id).y,
                                        GetEntityCoords(object[i].id).z + 1), 'bulleRamasser', 255, 0)
                            end,
                            function()
                                if not take then
                                    take = true
                                    p:PlayAnim("pickup_object", "pickup_low", 0)
                                    Wait(1000)
                                    AttachEntityToEntity(object[i]:getEntityId(), p:ped(),
                                        GetEntityBoneIndexByName(p:ped(), "IK_R_Hand"), props.offset[1], props.offset[2]
                                        , props.offset[3], props.offset[4], props.offset[5], props.offset[6], false,
                                        false, false, false, 0.0, true)
                                    index = i

                                    Bulle.remove("bagGofast" .. i)
                                    if recup == 0 and take and not flic1 then
                                        flic1 = true
                                        local pos = GetEntityCoords(object[i].id)
                                        --TriggerServerEvent('core:advancedCall', "lspd", NetworkGetNetworkIdFromEntity(veh), 380, "~r~GoFast")
                                        local isInSouth = coordsIsInSouth(pos)
                                        if isInSouth then
                                            TriggerSecurEvent('core:makeCall', "lspd", vector3(GetEntityCoords(object[i].id).x, GetEntityCoords(object[i].id).y, GetEntityCoords(object[i].id).z + 1), true, "Go Fast", false, "illegal")
                                            TriggerSecurEvent('core:makeCall', "lssd", vector3(GetEntityCoords(object[i].id).x, GetEntityCoords(object[i].id).y, GetEntityCoords(object[i].id).z + 1), true, "Go Fast", false, "illegal") -- FIX_LSSD_LSPD
                                        else
                                            TriggerSecurEvent('core:makeCall', "lssd", vector3(GetEntityCoords(object[i].id).x, GetEntityCoords(object[i].id).y, GetEntityCoords(object[i].id).z + 1), true, "Go Fast", false,"illegal")
                                            TriggerSecurEvent('core:makeCall', "lspd", vector3(GetEntityCoords(object[i].id).x, GetEntityCoords(object[i].id).y, GetEntityCoords(object[i].id).z + 1), true, "Go Fast", false,"illegal") -- FIX_LSSD_LSPD
                                        end
                                    end
                                else
                                    -- ShowNotification("Vous ne pouvez pas ramasser vous avez déjà quelque choses dans les mains")

                                    -- New notif
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        -- duration = 5, -- In seconds, default:  4
                                        content = "~s Impossible de ramasser, ~c vous avez déjà quelque choses dans les mains"
                                    })

                                end
                            end)
                    end
                end
            end
        end

        if recup == #data.mission[random].loot then
            if not thirdMessage then
                thirdMessage = true
                TriggerServerEvent("gofast:thirdSms", token,
                    vector2(data.mission[random].livraison.peds.x, data.mission[random].livraison.peds.y))
                -- TriggerServerEvent("phone:AnonymeCall", "687-6543", data.mission[random].livraison.peds.xyz,
                --     "On m'a informer que tu as pu récuperer la cargaison je t'attend.")
                SetVehicleDoorShut(veh, 5, false, false)
            end
        end

        if #(p:pos() - data.mission[random].livraison.peds.xyz) <= 100 then
            pNear = true
            if not data.mission[random].livraison.create then
                data.mission[random].livraison.create = true
                pedsLiraison = entity:CreatePedLocal(data.mission[random].livraison.model,
                    vector3(data.mission[random].livraison.peds.x, data.mission[random].livraison.peds.y,
                        data.mission[random].livraison.peds.z - 1.0), data.mission[random].livraison.peds.w)
                TaskStartScenarioInPlace(peds.id, "WORLD_HUMAN_DRUG_DEALER", -1, true)
                Wait(1000)
                SetEntityInvincible(pedsLiraison.id, true)
                FreezeEntityPosition(pedsLiraison.id, true)
                vehLivraison = vehicle.create(data.mission[random].livraison.veh, data.mission[random].livraison.car, {})
                SetVehicleDoorsLocked(vehLivraison, 2)
                SetVehicleDoorsLockedForAllPlayers(vehLivraison, true)
            end

            if #(p:pos() - data.mission[random].livraison.peds.xyz) <= 50 then
                if not TextLast then
                    TextLast = true
                    Visual.Subtitle("Je te laisse charger mon véhicule.", 4000)
                    exports['vNotif']:createNotification({
                        type = 'JAUNE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Va a l'arriere de ton coffre et récupere les sacs"
                    })
                end
                if #(p:pos() - GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "platelight")) +
                    vector3(0.0, 0.0, 0.5)) < 1.5 then
                    if IsControlJustPressed(0, 38) and recup >= 1 and not HaveBag then
                        HaveBag = true
                        exports['vNotif']:createNotification({
                            type = 'JAUNE',
                            -- duration = 5, -- In seconds, default:  4
                            content = "Va a l'arriere du coffre du speedo et dépose ton sac"
                        })
                        TriggerServerEvent("gofast:removeItemTrunk", token, GetVehicleNumberPlateText(veh))
                        bag = entity:CreateObject("prop_money_bag_01", vector3(p:pos().x, p:pos().y, p:pos().z - 1))
                        SetVehicleDoorOpen(veh, 5, false, false)
                        AttachEntityToEntity(bag:getEntityId(), p:ped(),
                            GetEntityBoneIndexByName(p:ped(), "IK_R_Hand"), props.offset[1], props.offset[2]
                            , props.offset[3], props.offset[4], props.offset[5], props.offset[6], false,
                            false, false, false, 0.0, true)
                        if recup == 8 and HaveBag and not flic2 then
                            flic2 = true
--[[                             TriggerSecurEvent('core:makeCall', "lspd", vector3(p:pos().x, p:pos().y, p:pos().z), true,
                                "Deux hommes vide le coffre d'un véhicule avec des sacs suspect.", false, "illegal")
                            TriggerSecurEvent('core:makeCall', "lssd", vector3(p:pos().x, p:pos().y, p:pos().z), true,
                                "Deux hommes vide le coffre d'un véhicule avec des sacs suspect.", false, "illegal") ]]
                            local isInSouth = coordsIsInSouth(p:pos())
                            if isInSout then
                                TriggerSecurEvent('core:makeCall', "lspd", vector3(p:pos().x, p:pos().y, p:pos().z), true, "Go Fast", false, "illegal")
                                TriggerSecurEvent('core:makeCall', "lssd", vector3(p:pos().x, p:pos().y, p:pos().z), true, "Go Fast", false, "illegal") -- FIX_LSSD_LSPD
                            else
                                TriggerSecurEvent('core:makeCall', "lssd", vector3(p:pos().x, p:pos().y, p:pos().z), true, "Go Fast", false, "illegal")
                                TriggerSecurEvent('core:makeCall', "lspd", vector3(p:pos().x, p:pos().y, p:pos().z), true, "Go Fast", false, "illegal") -- FIX_LSSD_LSPD
                            end
                        end
                    end

                end
                if #(p:pos() -
                    GetWorldPositionOfEntityBone(vehLivraison, GetEntityBoneIndexByName(vehLivraison, "platelight"))
                    + vector3(0.0, 0.0, 0.5)) < 1.5 then
                    if IsControlJustPressed(0, 38) and HaveBag then
                        HaveBag = false
                        SetVehicleDoorOpen(veh, 5, false, false)
                        p:PlayAnim("anim@heists@narcotics@trash", "throw_b", 49)
                        Wait(1000)
                        recup = recup - 1
                        bag:delete()
                        ClearPedTasks(p:ped())
                    end

                end

                if recup == 0 and not finishMess then
                    finishMess = true
                    SetVehicleDoorShut(veh, 5, false, false)
                    Visual.Subtitle("Merci de ton aide, on te recontacte pour le paiement. Maintenant bouge de là !",
                        4000)
                end
            end
        end

        if #(p:pos() - data.mission[random].livraison.peds.xyz) >= 60.0 and finishMess and not payMess then
            pedsLiraison:delete()
            TriggerEvent('persistent-vehicles/forget-vehicle', vehLivraison)
            DeleteEntity(vehLivraison)
            Wait(20000)
            pay = true
            payMess = true
            TriggerServerEvent("gofast:paySms", token,
                vector2(data.mission[random].reward.pos.x, data.mission[random].reward.pos.y))
        end

        if #(p:pos() - data.mission[random].reward.pos) <= 60 and pay then
            pNear = true
            if not data.mission[random].reward.create then
                -- create a bag on the ground
                data.mission[random].reward.create = true
                local _, groundZ = GetGroundZFor_3dCoord(data.mission[random].reward.pos.x, data.mission[random].reward.pos.y, data.mission[random].reward.pos.z, false);
                bag = entity:CreateObject("prop_money_bag_01", vector3(data.mission[random].reward.pos.x,
                    data.mission[random].reward.pos.y, groundZ))
                Bulle.add("rewardGoFast", data.mission[random].reward.pos,
                    function()
                        RobertoBulle("bag", data.mission[random].reward.pos, 'bulleUtiliser', 255, 0)
                    end,
                    function()
                        local gf1 = GetVariable("heist").gofast1
                        SetVehicleDoorsLockedForAllPlayers(veh, false)
                        SetVehicleDoorsLocked(veh, 0)
                        SetEntityAsNoLongerNeeded(veh)
                        pay = false
                        p:PlayAnim("pickup_object", "pickup_low", 0)
                        Wait(1000)
                        bag:delete()
                        ClearPedTasks(p:ped())
                        Bulle.remove("rewardGoFast")
                        -- ShowNotification("Tu as reçu ~g~" .. data.mission[random].reward.money .. "$~s~.")

                        -- New notif
                        exports['vNotif']:createNotification({
                            type = 'DOLLAR',
                            -- duration = 5, -- In seconds, default:  4
                            content = "Tu as reçu ~s " .. gf1.win .. "$"
                        })

                        TriggerSecurGiveEvent("core:addItemToInventory", token, "money", tonumber(gf1.win), {})
                        Wait(2000)
                        SetNewWaypoint(data.mission[random].reward2.pos.x, data.mission[random].reward2.pos.y)
                        TriggerServerEvent("gofast:deleteconvo", token)

                        OpenTutoFAInfo("GoFast", "Retourne au point de départ pour rendre le véhicule")
                    end)
            end
        end
        
        if #(p:pos() - data.mission[random].reward2.pos) <= 60 and (not pay) then
            if not data.mission[random].reward2.create then
                data.mission[random].reward2.create = true
                Bulle.add("rewardGoFast2", data.mission[random].reward2.pos,
                function()
                    RobertoBulle("bag", data.mission[random].reward2.pos, 'bulleRendreColis', 255, 0)
                end,
                function()
                    if not payed then
                        payed = true
                        DeleteEntity(veh)
                        TriggerSecurGiveEvent("core:addItemToInventory", token, "money", tonumber(200), {})
                        exports['tuto-fa']:HideStep()
                        Bulle.remove("rewardGoFast2")
                        InMission = false
                    end
                end)
            end
        end

        if take then
            pNear = true
            if #(p:pos() - GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "platelight")) +
                vector3(0.0, 0.0, 0.5)) < 1.5 then
                    Bulle.create("poserCoffreGfst1", GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "platelight")) + vector3(0.0, 0.0, 0.5), "bulleDeposer", true)
                if IsControlJustReleased(0, 38) and take then
                    local plate = tostring(GetVehicleNumberPlateText(veh))
                    TriggerServerEvent("gofast:addItemTrunk", nil, plate)
                    SetVehicleDoorOpen(veh, 5, false, false)
                    p:PlayAnim("anim@heists@narcotics@trash", "throw_b", 49)
                    Wait(1000)
                    object[index]:delete()
                    recup = recup + 1
                    take = false
                    ClearPedTasks(p:ped())
                end
            end
        end

        if pNear then
            Wait(1)
        else
            Wait(500)
        end
    end
end