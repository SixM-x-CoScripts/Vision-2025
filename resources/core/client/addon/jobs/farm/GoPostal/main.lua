local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local vehs
local pos = {}
local PlayersId = {}
local PlayersInJob = {}
local finished = true
local blippos = nil
local advance = 0
local HoldingBox = false
local addpos = vector3(0.0, 0.0, 0.0)
local blipBoites
local delivered = 0
local FriendHasTakenColis
local veh
local playerpos = nil
local near = false
local stoped = false
local maxBoites = 0
local recupedBoites = 0
local ColisObj = {}

local spawnPlaces = {
    vector4(71.280143737793, 120.3359375, 78.070098876953, 157.0),
    vector4(66.152099609375, 120.35468292236, 78.034202575684, 157.0),
    vector4(61.115509033203, 121.84418487549, 78.066772460938, 157.0),
}
CreateThread(function()
    local ped = nil
    local created = false
    if not created then
        ped = entity:CreatePedLocal("s_m_m_cntrybar_01", vector3(60.200622558594, 129.7130279541, 78.224227905273),
            178.23)
        created = true
    end
    SetEntityInvincible(ped.id, true)
    ped:setFreeze(true)
    TaskStartScenarioInPlace(ped.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
    SetEntityAsMissionEntity(ped.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped.id, true)
    
    while not p do Wait(1) end
    PlayersInJob = {
        { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
    }

    local pilebox = GetHashKey("prop_rub_boxpile_06")
    while not pilebox do Wait(1) end
    local pile = CreateObject(pilebox, 75.878875732422, 124.9892578125, 78.214836120605)
    local pile2 = CreateObject(pilebox, 76.950393676758, 123.86821746826, 78.215270996094)
    SetEntityHeading(pile, 135.38424682617+90)
    FreezeEntityPosition(pile, true)
    SetEntityAsMissionEntity(pile, true, true)
    SetEntityHeading(pile2, 135.38424682617+90)
    FreezeEntityPosition(pile2, true)
    SetEntityAsMissionEntity(pile2, true, true)
end)

local function spawnVeh()
    for k, v in pairs(spawnPlaces) do
        if vehicle.IsSpawnPointClear(vector3(v.x, v.y, v.z), 3.0) then
            if DoesEntityExist(vehs) then
                TriggerEvent('persistent-vehicles/forget-vehicle', vehs)
                removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                DeleteEntity(vehs)
            end
            vehs = vehicle.create('boxville2', vector4(v), {})
            local plate = vehicle.getProps(vehs).plate
            local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
            local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
            createKeys(plate, model)
            --TaskWarpPedIntoVehicle(PlayerPedId(), vehs, -1)
            return vehs
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Il n'y a ~s pas de place ~c pour le véhicule"
            })
        end
    end
    return nil
end


zone.addZone("servicePost",
    vector3(60.200622558594, 129.7130279541, 80.224227905273),
    "Appuyer sur ~INPUT_CONTEXT~ pour récupérer la feuille de service",
    function()
        SendNUIMessage({
            type = "openWebview",
            name = "MenuJob",
            data = {
                headerBanner = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/10493763812109926601206612952321495100bannieregopostal1.webp",
                choice = {
                    label = "Camions",
                    isOptional = false,
                    choices = {
                        {
                            id = 1,
                            label = 'Boxville',
                            name = 'boxville2',
                            img= "https://cdn.sacul.cloud/v2/vision-cdn/Discord/12015580604732580841202581456879230976image2removebgpreview.webp",
                        },
                    },
                },
                participants = PlayersInJob,
                participantsNumber = 2,
                callbackName = "MetierGoPostal",
            }
        })
    end, 
    false,
    27,
    0.5,
    { 255, 255, 255 },
    170,
    3.0,
    true,
    "bulleTravaillerCamion2"
)

RegisterNUICallback("MetierGoPostal", function(data)
    if data and data.button == "start" then 
        if finished then
            if CheckJobLimit() then
                PlayersId = {}
                for k, v in pairs(PlayersInJob) do 
                    table.insert(PlayersId, v.id)
                end
                TriggerServerEvent("core:activities:create", token, PlayersId, "gopostal")
                closeUI()
                StartPostal()
            end
        end
    elseif data.button == "removePlayer" then
        local playerSe = data.selected
        TriggerServerEvent("core:activities:SelectedKickPlayer", playerSe, "gopostal")
        for k,v in pairs(PlayersInJob) do 
            if v.id == playerSe then 
                table.remove(PlayersInJob, k)
            end
        end
        if PlayersId then 
            for k,v in pairs(PlayersId) do 
                if v == PlayersId then 
                    table.remove(PlayersId, k)
                end
            end
        end
        closeUI()
    elseif data.button == "addPlayer" then
        if data.selected ~= 0 then 
            local closestPlayer = ChoicePlayersInZone(5.0)
            if closestPlayer == nil then
                return
            end
            local sID = GetPlayerServerId(closestPlayer)
            TriggerServerEvent("core:activities:askJob", sID, "GoPostal")
        end
    elseif data.button == "stop" then 
        endGoPostal()
    end
end)

function AddTenueGoPostal()
    local Skin = p:skin()
    ApplySkinFake(Skin)
    if GetEntityModel(p:ped()) == `mp_m_freemode_01` then 
        SkinChangeFake("torso_1", 593)
        SkinChangeFake("torso_2", 1)
        SkinChangeFake("tshirt_1", 15)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 0)
        SkinChangeFake("arms_2", 0)
        SkinChangeFake("pants_1", 15)
        SkinChangeFake("pants_2",0)
        SkinChangeFake("shoes_1", 1)
        SkinChangeFake("shoes_2", 0)
        SkinChangeFake("helmet_1", 173)
        SkinChangeFake("helmet_2", 0)
        SkinChangeFake("bags_1", 195)
        SkinChangeFake("bags_2", 1)
    elseif GetEntityModel(p:ped()) == `mp_f_freemode_01` then 
        SkinChangeFake("torso_1", 645)
        SkinChangeFake("torso_2", 1)
        SkinChangeFake("tshirt_1", 14)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 14)
        SkinChangeFake("arms_2", 0)
        SkinChangeFake("pants_1", 25)
        SkinChangeFake("pants_2",9)
        SkinChangeFake("shoes_1", 1)
        SkinChangeFake("shoes_2", 0)
        SkinChangeFake("helmet_1", 172)
        SkinChangeFake("helmet_2", 2)
        SkinChangeFake("bags_1", 180)
        SkinChangeFake("bags_2", 0)
    end
end 

RegisterNetEvent("core:activities:liveupdate", function(typejob, data, src)
    if typejob == "gopostal" then 
        if data.addpos then 
            printDev("addpos", data.addpos)
            printDev("blippos", blippos)
            if blippos then RemoveBlip(blippos) Wait(260) end
            addpos = data.addpos
            blippos = AddBlipForCoord(addpos)
            SetNewWaypoint(addpos.x, addpos.y)
        end
        if data.recupedBoites then 
            if tonumber(src) ~= tonumber(GetPlayerServerId(PlayerId())) then
                recupedBoites = data.recupedBoites
                if recupedBoites == maxBoites then 
                    exports['tuto-fa']:HideStep()
                    Bulle.hide("gopostal:recupBoites")
                    Bulle.hide("poserCoffreBox")
                    Bulle.remove("gopostal:recupBoites")
                    Bulle.remove("poserCoffreBox")
                    if blippos then RemoveBlip(blippos) Wait(260) end
                    math.randomseed(GetGameTimer())
                    addpos = data.addpos
                    blippos = AddBlipForCoord(addpos)
                    RemoveBlip(blipBoites)
                    SetNewWaypoint(addpos.x, addpos.y)
                    SetVehicleDoorShut(veh, 3, false, false)
                    SetVehicleDoorShut(veh, 2, false, false)
                    OpenTutoFAInfo("GoPostal", "Montez dans votre camion et allez sur le point défini sur votre GPS.")
                end
            end
        end
        if data.finished then 
            printDev("data.finished", data.finished)
            finished = data.finished
        end
        if data.delivered then 
            delivered = data.delivered
        end
        if data.takencolis then 
            FriendHasTakenColis = true
        end
        if data.finishcolis then 
            FriendHasTakenColis = false
        end
    end
end)

function StartPostal(isFriend)
    AddTenueGoPostal()
    delivered = 0
    printDev("max gopostal " .. #goPostal)
    math.randomseed(GetGameTimer())
    local idToGo = math.random(1, #goPostal)
    maxBoites = #goPostal[idToGo]
    if isFriend then 
        maxBoites = isFriend.maxBoites
    end
    printDev("maxBoites", maxBoites)
    OpenTutoFAInfo("GoPostal", "Aller récupérer "..#goPostal[idToGo].." colis sur le point GPS.")
    veh = isFriend and NetToVeh(isFriend.veh) or spawnVeh()
    advance = 0
    printDev("veh", veh)
    if not isFriend then
        SetVehicleDoorOpen(veh, 3, false, false)
        SetVehicleDoorOpen(veh, 2, false, false)
    end
    if blipBoites then RemoveBlip(blipBoites) Wait(260) end
    Bulle.create("gopostal:recupBoites", vector3(75.878784179688, 123.76702880859, 79.211387634277), "bulleRecupererColis", true)
    blipBoites = AddBlipForCoord(vector3(75.878784179688, 123.76702880859, 79.211387634277))
    near = false
    local shown = false
    finished = false
    if not isFriend then
        TriggerServerEvent("core:activities:update", PlayersId, "gopostal", {maxBoites = maxBoites, veh = VehToNet(veh)})
    end
    while not finished do
        Wait(1)
        playerpos = GetEntityCoords(PlayerPedId())
        -- Prendre colis du coffre
        if finished then 
            break
        end
        -- Récup colis du coffre pour donner au client
        if GetDistanceBetweenCoords(playerpos, addpos) < 50.0 then
            if not IsPedInAnyVehicle(p:ped()) then 
                if not HoldingBox or not IsEntityPlayingAnim(p:ped(), "anim@heists@box_carry@", "idle", 3) or not IsEntityPlayingAnim(p:ped(), "anim@mp_ferris_wheel", "idle_a_player_one", 3) then
                    if not FriendHasTakenColis then
                        if not shown then
                            OpenTutoFAInfo("GoPostal", "Vous devez récupérer le colis dans votre coffre.")
                            shown = true
                        end
                        Bulle.create("poserCoffreBox", GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "platelight")) + vector3(0.0, 0.0, 0.5), "bulleRecupererColis", true)
                        if Vdist2(GetEntityCoords(p:ped()), GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "platelight"))) < 2.0 then 
                            if IsControlJustPressed(0, 38) then 
                                TriggerServerEvent("core:activities:liveupdate", PlayersId, "gopostal", {takencolis = true})
                                SetVehicleDoorOpen(veh, 3, false, false)
                                SetVehicleDoorOpen(veh, 2, false, false)
                                local randomize = math.random(1,3)
                                Bulle.show("colisDepos")
                                if randomize == 1 or randomize == 2 then
                                    ExecuteCommand("e box")
                                else
                                    ExecuteCommand("e pallet3")
                                end
                                HoldingBox = true
                                Wait(1000)
                                DeleteEntity(ColisObj[delivered+1])
                                SetVehicleDoorShut(veh, 3, false, false)
                                SetVehicleDoorShut(veh, 2, false, false)
                                exports['tuto-fa']:HideStep()
                                Bulle.hide("poserCoffreBox")
                                Bulle.remove("poserCoffreBox")
                            end
                        end
                    else
                        Bulle.hide("poserCoffreBox")
                        Bulle.remove("poserCoffreBox")
                    end
                else
                    if shown then
                        shown = false
                        if Bulle.exists("poserCoffreBox") then
                            Bulle.hide("poserCoffreBox")
                            Bulle.remove("poserCoffreBox")
                        end
                        exports['tuto-fa']:HideStep()
                    end
                end
            else
                if shown then
                    shown = false
                    if Bulle.exists("poserCoffreBox") then
                        Bulle.hide("poserCoffreBox")
                        Bulle.remove("poserCoffreBox")
                    end
                    exports['tuto-fa']:HideStep()
                end
                if Bulle.exists("poserCoffreBox") then
                    Bulle.hide("poserCoffreBox")
                    Bulle.remove("poserCoffreBox")
                end
            end
        else
            shown = false
        end
       -- if GetDistanceBetweenCoords(playerpos, addpos) < 50.0 and (HoldingBox or IsEntityPlayingAnim(p:ped(), "anim@heists@box_carry@", "idle", 3) or IsEntityPlayingAnim(p:ped(), "anim@mp_ferris_wheel", "idle_a_player_one", 3)) then
       --     DrawMarker(2, addpos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, 
       --         255, 0, 255, 170, 0, 1, 2, 0, nil, nil, 0)
       -- end
        -- Donner le colis au client
        if GetDistanceBetweenCoords(playerpos, addpos) < 2 then
            if HoldingBox or IsEntityPlayingAnim(p:ped(), "anim@heists@box_carry@", "idle", 3) or IsEntityPlayingAnim(p:ped(), "anim@mp_ferris_wheel", "idle_a_player_one", 3) then
                near = true
                --ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour déposer le colis")
                Bulle.create("colisDepos", addpos, "bulleDeposerColis")
                if IsControlJustPressed(0, 38) then
                    RemoveBlip(blippos)
                    TriggerServerEvent("core:activities:liveupdate", PlayersId, "gopostal", {finishcolis = true})
                    ExecuteCommand("e jpbox")
                    Wait(2500)
                    ExecuteCommand("e c")
                    Bulle.hide("colisDepos")
                    Bulle.remove("colisDepos")
                    if Bulle.exists("poserCoffreBox") then
                        Bulle.hide("poserCoffreBox")
                        Bulle.remove("poserCoffreBox")
                    end
                    HoldingBox = false
                    delivered += 1
                    print(delivered, maxBoites)
                    if tonumber(delivered) == tonumber(maxBoites) then 
                        TriggerServerEvent("core:activities:liveupdate", PlayersId, "gopostal", {finished = true})
                        finished = true
                    end
                    if goPostal[idToGo][delivered+1] then
                        if blippos then RemoveBlip(blippos) Wait(260) end
                        addpos = goPostal[idToGo][delivered+1]
                        blippos = AddBlipForCoord(addpos)
                        SetNewWaypoint(addpos.x, addpos.y)
                        OpenTutoFAInfo("GoPostal", "Remontez dans le camion et aller à la position GPS.")
                        TriggerServerEvent("core:activities:liveupdate", PlayersId, "gopostal", {addpos = addpos, delivered = delivered})
                    end
                end
            end
        else
            near = false
        end
        -- Recup colis pour aller mettre dans le coffre
        if GetDistanceBetweenCoords(GetEntityCoords(p:ped()), vector3(75.878784179688, 123.76702880859, 79.211387634277)) < 2.0 then 
            if IsControlJustPressed(0, 38) then 
                print("press")
                if recupedBoites < maxBoites then
                    if not IsEntityPlayingAnim(p:ped(), "anim@heists@box_carry@", "idle", 3) then
                        recupedBoites += 1
                        TriggerServerEvent("")
                        ExecuteCommand("e box")
                    else
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            -- duration = 5, -- In seconds, default:  4
                            content = "Allez d'abord déposer dans le coffre votre colis !"
                        })
                    end
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous avez déjà pris tous vos colis, vous pouvez commencer votre service !"
                    })
                end
            end 
        end
        -- Depos dans le coffre des colis
        if GetDistanceBetweenCoords(GetEntityCoords(p:ped()), vector3(67.031044006348, 124.18302154541, 78.166702270508)) < 50.0 then
            if IsEntityPlayingAnim(p:ped(), "anim@heists@box_carry@", "idle", 3) then
                if Vdist2(p:pos(), GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "platelight"))) < 2.5 then 
                    Bulle.create("poserCoffreBox", GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "platelight")) + vector3(0.0, 0.0, 0.5), "bulleDeposerColis", true)
                    if IsControlJustPressed(0, 38) then 
                        if recupedBoites ~= maxBoites then
                            TriggerServerEvent("core:activities:liveupdate", PlayersId, "gopostal", {recupedBoites = recupedBoites})
                        end
                        p:PlayAnim("anim@heists@narcotics@trash", "throw_b", 49)
                        Wait(500)
                        ExecuteCommand("e c")
                        Wait(500)
                        ClearPedTasks(PlayerPedId())
                        if recupedBoites == maxBoites then 
                            exports['tuto-fa']:HideStep()
                            if blippos then RemoveBlip(blippos) Wait(260) end
                            Bulle.hide("gopostal:recupBoites")
                            Bulle.hide("poserCoffreBox")
                            Bulle.remove("gopostal:recupBoites")
                            Bulle.remove("poserCoffreBox")
                            math.randomseed(GetGameTimer())
                            addpos = goPostal[idToGo][delivered+1]
                            blippos = AddBlipForCoord(addpos)
                            RemoveBlip(blipBoites)
                            SetNewWaypoint(addpos.x, addpos.y)
                            TriggerServerEvent("core:activities:liveupdate", PlayersId, "gopostal", {recupedBoites = recupedBoites, addpos = addpos})
                            SetVehicleDoorShut(veh, 3, false, false)
                            SetVehicleDoorShut(veh, 2, false, false)
                            OpenTutoFAInfo("GoPostal", "Montez dans votre camion et allez sur le point défini sur votre GPS.")
                        end
                        local PossiblePos = {
                            vector3(-0.2, 3.1, 0.2),
                            vector3(0.2, 3.1, 0.2),
                            vector3(-0.2, 2.6, 0.2),
                            vector3(0.2, 2.6, 0.2),
                            vector3(-0.2, 2.1, 0.2),
                            vector3(0.2, 2.1, 0.2),
                            vector3(-0.2, 1.5, 0.2),
                            vector3(0.2, 1.5, 0.2),
                            vector3(-0.2, 1.0, 0.2),
                            vector3(0.2, 1.0, 0.2),
                            vector3(-0.2, 0.5, 0.2),
                            vector3(0.2, 0.5, 0.2),
                        }
                        if PossiblePos[recupedBoites] then
                            ColisObj[recupedBoites] = entity:CreateObject(GetHashKey("hei_prop_heist_box"), GetEntityCoords(p:ped())).id
                            SetEntityAsMissionEntity(ColisObj[recupedBoites], true, true)
                            SetEntityCollision(ColisObj[recupedBoites], false, false)
                            AttachEntityToEntity(ColisObj[recupedBoites], veh, GetEntityBoneIndexByName(veh, "platelight"), PossiblePos[recupedBoites], 0.0, 0.0, 0.0, false, true, false, false, 1, true)
                        end
                    end
                end
            end
        end
        
        for v in EnumerateObjects() do
            if IsEntityPositionFrozen(v) then 
                FreezeEntityPosition(v, false)
            end
        end
    end
    if Bulle.exists("poserCoffreBox") then
        Bulle.hide("poserCoffreBox")
        Bulle.remove("poserCoffreBox")
    end
    print("FINISHEDD")
    RemoveBlip(blippos)
    advance = advance + 1
    if stoped then return end
    local finishblip = AddBlipForCoord(73.735473632813, 121.23113250732, 10.0)
    SetNewWaypoint(73.735473632813, 121.23113250732)
    if IsPedInAnyVehicle(PlayerPedId()) or DoesEntityExist(vehs) then
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            content = "Allez rendre le camion pour etre payer"
        })
    end
    zone.addZone("gopostal:deleteveh",
        vector3(66.575218200684, 122.3657989502, 79.134414672852),
        "Appuyer sur ~INPUT_CONTEXT~ pour rendre le vehicle",
        function()
            RemoveBlip(finishblip)
            endGoPostal()
            TriggerServerEvent("core:activities:kickPlayers", PlayersId, "gopostal")
        end,
        true,
        36,
        0.5,
        { 255, 0, 0 },
        170,
        5.5,
        true,
        "bulleRendreColis"
    )
    
end

-- RegisterNetEvent("core:letteruse", function()
--     for k=1, #pos do
--         playerpos = GetEntityCoords(PlayerPedId())
--         letterbox = pos[k]
--         if GetDistanceBetweenCoords(playerpos, letterbox) > 2 then
--             near = false
            
--         else
--             RemoveBlip(blippos[k])
--             near = true
--             table.remove(pos, k)
--             table.remove(blippos, k)
--             goto skipboucle

--         end
--     end

--     ::skipboucle::
--     if near then
--         advance = advance+1
--         letterBoxDone = letterBoxDone + 1
--     else
--         exports['vNotif']:createNotification({
--             type = 'ROUGE',
--             duration = 5, -- In seconds, default:  4
--             content = "Ce n'est pas la bonne boite au lettre"
--         })
--         TriggerSecurGiveEvent("core:addItemToInventory", token, "letter", 1, {})
--     end
-- end)


RegisterCommand("stoppostal", function()
    stoped = true
    advance = 5
    maxBoites = 0
    local playerSkin = p:skin()
    ApplySkin(playerSkin)
    recupedBoites = 0
    exports['tuto-fa']:HideStep()
end)



function endGoPostal()
    onMissionFinished()
    if IsPedInAnyVehicle(p:ped(), false) then
        local veh = GetVehiclePedIsIn(p:ped(), false)
        if veh then
            removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
            TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
            TriggerEvent('persistent-vehicles/forget-vehicle', veh)
            DeleteEntity(veh)
        end
    end
    local price = 0
    if delivered ~= 0 then
        local winmin, winmax = 400, 600
        local varWinMin, varWinMax = getWinRange("gopostal", 400, 600)
        if tonumber(varWinMin) and tonumber(varWinMax) then 
            winmin, winmax = varWinMin, varWinMax
        end
        local money = math.random(winmin, winmax)
        price = money * delivered
    end
    delivered = 0

    if vehs and DoesEntityExist(vehs) then 
        DeleteEntity(vehs)
    end
    
    if price ~= 0 then
        if p:getSubscription() == 1 then price = price*1.25 end 
        if p:getSubscription() == 2 then price = price*2 end 
        TriggerSecurGiveEvent("core:addItemToInventory", token, "money", price, {})

        local nprice = price or 0 
        exports['vNotif']:createNotification({
            type = 'VERT',
            duration = 5, -- In seconds, default:  4
            content = "Vous avez gagné "..nprice..'$'
        })
    end

    for k,v in pairs(ColisObj) do 
        if DoesEntityExist(k) then 
            DeleteEntity(k)
        end
        if DoesEntityExist(v) then 
            DeleteEntity(v)
        end
    end
    local playerSkin = p:skin()
    ApplySkin(playerSkin)
    if blippos then RemoveBlip(blippos) end
    blippos = nil
    maxBoites = 0
    delivered = 0
    recupedBoites = 0

    if blipBoites then RemoveBlip(blipBoites) end
    if finishblip then RemoveBlip(finishblip) end
    pos = {}
    advance = 0
    price = 0
    ColisObj = {}
    finished = true
    exports['tuto-fa']:HideStep()
    Bulle.hide("gopostal:deleteveh")
    zone.hideNotif("gopostal:deleteveh")
    zone.removeZone("gopostal:deleteveh")
    exports['tuto-fa']:HideStep()
    Bulle.hide("gopostal:recupBoites")
    Bulle.hide("poserCoffreBox")
    Bulle.remove("gopostal:recupBoites")
    Bulle.remove("poserCoffreBox")
    Bulle.hide("colisDepos")
    Bulle.remove("colisDepos")
end


RegisterNetEvent("core:activities:create", function(typejob, players)
    if typejob == "gopostal" then 
        AddTenueGoPostal()
    end
    PlayersId = players
end)

RegisterNetEvent("core:activities:update", function(typejob, data, src)
    if src ~= GetPlayerServerId(PlayerId()) then
        if typejob == "gopostal" then 
            -- gopostal job
            StartPostal(data)
        end
    end
end)

RegisterNetEvent("core:activities:kickPlayer", function(typejob)
    if typejob == "gopostal" then 
        endGoPostal()
        PlayersInJob = {
            { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
        }
    end
end)

RegisterNetEvent("core:activities:acceptedJob", function(ply, pname)
    table.insert(PlayersInJob, {name = pname, id = ply})
end)

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7gopostal ^3loaded")
end)