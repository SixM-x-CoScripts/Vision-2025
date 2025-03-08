local peds = {}
local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)
local inMission = false
CreateThread(function()
    --BulleInfo
    while GoFastMaritime == nil do Wait(1) end
    for k, v in pairs(GoFastMaritime) do
        Bulle.add("INFORMATEURGOFASTMARITIME" .. k, vector3(v.peds.x, v.peds.y, v.peds.z),
            function()
                RobertoBulle("gofastmaritime" .. k, vector3(v.peds.x, v.peds.y, v.peds.z + 1), 'bulleInformation', 255, 0)
            end,
            function()
                local isInSouth = coordsIsInSouth(v.peds)
                local policeMans = (GlobalState['serviceCount_lspd'] or 0)
                if not inMission and policeMans >= 2 and TriggerServerCallback("gofast:AlreadyDidGoFast2", token, p:getId()) then
                    local phone = TriggerServerCallback("core:GetNumber", token)
                    if phone ~= nil then
                        inMission = true
                        CreateThread(function()
                            Visual.Subtitle("Yo mon petit, j'ai besoin de toi pour me récuperer une cargaison", 3000)
                            Modules.UI.RealWait(3000)
                            Visual.Subtitle("je vais t'envoyer toutes les informations un peu plus tard. ", 3000)
                            Modules.UI.RealWait(3000)
                            Visual.Subtitle("Maintenant BOUGE ! ", 2000)
                            Modules.UI.RealWait(3 * 1000) -- 3 Minutes
                            CreateMissionGoFastMaritime(v)
                            TriggerSecurEvent("core:crew:updateXp", token, 200, "add", p:getCrew(), "gofast1")
                        end)
                    else
                        Visual.Subtitle("Va t'acheter un téléphone que je puisse te contacter et reviens me voir", 2000)
                    end
                else
                    Visual.Subtitle("J'ai pas besoin de toi petit, bouge de la avant que tu le regrette", 2000)
                end
            end)
        peds[k] = entity:CreatePedLocal(v.modelPed, vector3(v.peds.x, v.peds.y, v.peds.z - 1.0), v.peds.w)
        SetEntityAsMissionEntity(peds[k].id, true)
        TaskStartScenarioInPlace(peds.id, "WORLD_HUMAN_DRUG_DEALER", -1, true)
        SetBlockingOfNonTemporaryEvents(peds.id, true)
        Wait(1000)
        SetEntityInvincible(peds[k].id, true)
        FreezeEntityPosition(peds[k].id, true)
        --CreatePed
    end
end)


function CreateMissionGoFastMaritime(data)
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
    local removeFromTrunk = false
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
    local props = {
        offset = { 0.449, 0.02, -0.041, 3.1, -88.09, 0.0 }
    }
    local pNear = false
    while inMission do

        --Send First Sms
        if not firstSms then
            firstSms = true
            TriggerServerEvent("gofast:firstSms", token,
                vector2(data.mission[random].vehicle.pos.x, data.mission[random].vehicle.pos.y))
            --SetNewWaypoint(vector2(data.mission[random].vehicle.pos.x, data.mission[random].vehicle.pos.y))
            -- TriggerServerEvent("phone:AnonymeCall", "687-6543", data.mission[random].vehicle.pos.xyz,
            --     "Tiens récupère le véhicule les clés sont dedans je t'enverrais les instructions une fois le véhicule récuperer.")
        end

        --Premiere Phase de récupération de véhicule
        if #(p:pos() - data.mission[random].vehicle.pos.xyz) <= 50 and not secondMess then
            if not data.mission[random].vehicle.create then
                data.mission[random].vehicle.create = true
                veh = vehicle.create(data.mission[random].vehicle.model, data.mission[random].vehicle.pos, {})
                blipVeh = AddBlipForEntity(veh)
                SetBlipSprite(blipVeh, 427)
                SetBlipColour(blipVeh, 2)
                Wait(50)
                print("Additem", data.mission[random].loot, data.mission[random].lootAmount, GetVehicleNumberPlateText(veh))
                --local vehBone = GetEntityBoneIndexByName(veh, "extra_2")
                --local obj = entity:CreateObjectLocal('prop_weed_tub_01b', GetEntityCoords(GetVehiclePedIsIn(p:ped())))
                ----obj:setFreeze(true)
                --SetEntityAsMissionEntity(obj.id, true, true)
                --SetEntityCollision(obj.id, false, false)
                --AttachEntityToEntity(obj.id, veh, vehBone, 0.0, 0.0, 0.0, false, true, false, false, 1, true)
            end

            if IsPedSittingInVehicle(p:ped(), veh) then
                if not secondMess then
                    secondMess = true
                    recup = 1
                    if not thirdMessage then
                        thirdMessage = true
                        local x, y,z = table.unpack(data.mission[random].livraison.pos)
                        TriggerServerEvent("gofast:thirdSms", token,
                            vector2(x, y))
                        --SetNewWaypoint(x, y)
                        -- TriggerServerEvent("phone:AnonymeCall", "687-6543", data.mission[random].pos.peds.xyz,
                        --     "On m'a informer que tu as pu récuperer la cargaison je t'attend.")
                        SetVehicleDoorShut(veh, 5, false, false)
                    end
                    --TriggerServerEvent('core:advancedCall', "lspd", NetworkGetNetworkIdFromEntity(veh), 427, "~r~GoFast Maritime")
                    TriggerSecurEvent('core:makeCall', "lspd", GetEntityCoords(PlayerPedId()), true, "GoFast Maritime")
                    Wait(10000)
                    TriggerSecurEvent('core:makeCall', "lspd", GetEntityCoords(PlayerPedId()), true, "Suite GoFast Maritime")
                end
            end
            pNear = true
        end


        if #(p:pos() - data.mission[random].livraison.pos) <= 100 then
            pNear = true
            if not data.mission[random].livraison.create then
                data.mission[random].livraison.create = true
                pedsLiraison = entity:CreatePedLocal(data.mission[random].livraison.model,
                    vector3(data.mission[random].livraison.peds.x, data.mission[random].livraison.peds.y,
                        data.mission[random].livraison.peds.z - 1.0), data.mission[random].livraison.peds.w)
                TaskStartScenarioInPlace(peds.id, "WORLD_HUMAN_DRUG_DEALER", -1, true)
                SetEntityAsMissionEntity(pedsLiraison.id, true)
                Wait(1000)
                SetEntityInvincible(pedsLiraison.id, true)
                FreezeEntityPosition(pedsLiraison.id, true)
                vehLivraison = vehicle.create(data.mission[random].livraison.veh, data.mission[random].livraison.car, {})
                SetVehicleDoorsLocked(vehLivraison, 2)
                SetVehicleDoorsLockedForAllPlayers(vehLivraison, true)
            end

            if not finishMess then
                DrawMarker(35, data.mission[random].livraison.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 1.5, 1.0, 255, 255, 255, 120, 0, 1, 2, 0, nil, nil, 0)
            end

            if #(p:pos() - data.mission[random].livraison.pos) <= 10.0 then
                if not TextLast then
                    TextLast = true
                    Visual.Subtitle("Laisse moi décharger.", 4000)
                    Wait(4000)
                    Visual.Subtitle("C'est bon, tiens t'es ".. data.mission[random].money .."$, moi je me casse ciao.", 4000)
                    if not removeFromTrunk then 
                        removeFromTrunk = true 
                        TriggerServerEvent("core:RemoveItemFromVehicle", token, data.mission[random].loot, data.mission[random].lootAmount, GetVehicleNumberPlateText(veh), {})
                        recup = 0
                    end
                    TriggerSecurGiveEvent("core:addItemToInventory", token, "money", tonumber(data.mission[random].money), {})
                    SetVehicleDoorsLocked(vehLivraison, 1)
                    SetVehicleDoorsLockedForAllPlayers(vehLivraison, false)
                    FreezeEntityPosition(pedsLiraison.id, false)
                    TaskEnterVehicle(pedsLiraison.id, vehLivraison, -1, -1, 2.0, 1, 0)
                    Wait(6000)
                    TaskVehicleDriveWander(pedsLiraison.id, vehLivraison, 60.0, 0)
                    pNear = false 
                end
                if recup == 0 and not finishMess then
                    finishMess = true
                    SetVehicleDoorShut(veh, 5, false, false)
                    Visual.Subtitle("Merci de ton aide. Maintenant bouge de là !", 4000)
                end
            end
        end

        --print("#(p:pos() - data.mission[random].livraison.pos)", #(p:pos() - data.mission[random].livraison.pos))
        --print("finishMess",finishMess)
        --print("payMess",payMess)
        if #(p:pos() - data.mission[random].livraison.pos) >= 20.0 and finishMess and not payMess then
            --print("Inside")
            pedsLiraison:delete()
            TriggerEvent('persistent-vehicles/forget-vehicle', vehLivraison)
            DeleteEntity(vehLivraison)
            Wait(5000)
           -- print("Wait(5000)")
            pay = true
            payMess = true
            --TriggerServerEvent("gofast:paySms", token, vector2(data.mission[random].reward.pos.x, data.mission[random].reward.pos.y))
            SetNewWaypoint(vector2(data.mission[random].reward.pos.x, data.mission[random].reward.pos.y))
        end

        if pay and payMess then 
            if #(p:pos() - data.mission[random].reward.pos) < 35.0 then 
                pNear = true
                DrawMarker(35, data.mission[random].reward.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 1.5, 1.0, 255, 255, 255, 120, 0, 1, 2, 0, nil, nil, 0)
                if IsControlJustPressed(0, 38) then 
                    DeleteEntity(GetVehiclePedIsIn(PlayerPedId()))
                    SetEntityCoords(PlayerPedId(), data.peds.xyz)
                    Visual.Subtitle("Reviens quand tu veux !", 4000)
                    inMission = false
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
