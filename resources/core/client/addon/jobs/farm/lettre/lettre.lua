local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local MaximumLettres = 5

local pos = {}
local PlayersId = {}
local HasLettersInHand = false
local MissionVeh = nil
local idToGo = 1
local ShouldReloadZone = false
local PlayersInJob = {}
local finished
local blippos = nil
local advance = 0
local addpos = vector3(0.0, 0.0, 0.0)
local blipBoites
local delivered = 0
local FriendHasTakenColis
local veh
local playerpos = nil
local near = false
local price = 0
local stoped = false
local recupedLettres = 0
local ColisObj = {}
local objLettre = nil

PositionsLettres = {
    spawnPlaces = {
        vector4(-259.34771728516, -846.05590820312, 30.409322738647, 66.025382995605),
        vector4(-260.07, -847.98, 30.41, 70.16),
        vector4(-263.29, -846.13, 30.49, 72.1),
        vector4(-255.69, -848.73, 30.26, 80.84)
    },
    deleteVehicule = vector3(-261.70083618164, -848.19689941406, 31.496185302734),
    ped = vector4(-258.77249145508, -841.4580078125, 30.42031288147, 121.01572418213),
    veh = "foodbike",
    posTakeLettre = vector3(-255.32971191406, -846.03106689453, 31.282838821411),
    jobName = "Facteur",
}

local BoxesDone = {}
function GetFirstLetterBoxFromZone(zone, radius)
    local gamePool = GetGamePool("CObject")
    if type(radius) == "bool" or type(radius) == "boolean" then radius = 60.0 end
    for k,v in pairs(gamePool) do 
        if DoesEntityExist(v) then
            if GetDistanceBetweenCoords(GetEntityCoords(v), zone) < radius + 0.1 then
                if GetEntityModel(v) == `prop_letterbox_01` or GetEntityModel(v) == `prop_letterbox_02` or GetEntityModel(v) == `prop_letterbox_03` or GetEntityModel(v) == `prop_letterbox_04` then
                    if not BoxesDone[v] then 
                        RemoveBlip(blippos)
                        Wait(260)
                        BoxesDone[v] = true 
                        blippos = AddBlipForCoord(GetEntityCoords(v))
                        SetBlipRoute(blippos, true)
                        SetNewWaypoint(GetEntityCoords(v).xy)
                        return GetEntityCoords(v)
                    end
                end
            end
        end
    end
    return nil
end

function AttachLetter()
    local props = GetHashKey("rcnk_letter")
    RequestModel(props)
    while not HasModelLoaded(props) do
        Wait(1)
    end
    local obj = entity:CreateObject("rcnk_letter", GetEntityCoords(p:ped()))
    AttachEntityToEntity(obj:getEntityId(), p:ped(), GetEntityBoneIndexByName(p:ped(), "IK_R_Hand"), 0.0, 0.0,
        0.0, 0.0, 0.0, 0.0, false, false, false, false, 0.0, true)
    return obj:getEntityId()
end

CreateThread(function()
    local ped = nil
    local created = false
    if not created then
        ped = entity:CreatePedLocal("s_m_m_cntrybar_01", PositionsLettres.ped.xyz, PositionsLettres.ped.w)
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
end)

local function spawnVeh()
    for k, v in pairs(PositionsLettres.spawnPlaces) do
        if vehicle.IsSpawnPointClear(vector3(v.x, v.y, v.z), 3.0) then
            if DoesEntityExist(vehs) then
                TriggerEvent('persistent-vehicles/forget-vehicle', vehs)
                removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                DeleteEntity(vehs)
            end
            vehs = vehicle.create(PositionsLettres.veh, vector4(v), {})
            MissionVeh = vehs
            local plate = vehicle.getProps(vehs).plate
            SetVehicleLivery(vehs, 9)
            local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
            local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
            createKeys(plate, model)
            veh = vehs
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


zone.addZone("lettrepos",
    PositionsLettres.ped.xyz + vector3(0.0, 0.0, 2.0),
    "Appuyer sur ~INPUT_CONTEXT~ pour récupérer la feuille de service",
    function()
        SendNUIMessage({
            type = "openWebview",
            name = "MenuJob",
            data = {
                headerBanner = "https://cdn.sacul.cloud/v2/vision-cdn/dlcavril/banner_facteur.webp",
                choice = {
                    label = "Scoots",
                    isOptional = false,
                    choices = {
                        {
                            id = 1,
                            label = 'Foodbike',
                            name = PositionsLettres.veh,
                            img= "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/BurgerShot/foodbike.webp",
                        },
                    },
                },
                participants = PlayersInJob,
                participantsNumber = 1,
                callbackName = "MetierLettres",
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
    "bulleTravaillerLettre"
)

RegisterNUICallback("MetierLettres", function(data)
    print("data.button", data.button)
    if data and data.button == "start" then 
        if CheckJobLimit() then
            PlayersId = {}
            for k, v in pairs(PlayersInJob) do 
                table.insert(PlayersId, v.id)
            end
            TriggerServerEvent("core:activities:create", token, PlayersId, "lettre")
            closeUI()
            StartLetterMission()
        end
    elseif data.button == "stop" then
        closeUI()
        endLetterMission()
    elseif data.button == "removePlayer" then
        local playerSe = data.selected
        TriggerServerEvent("core:activities:SelectedKickPlayer", playerSe, "lettre")
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
            if closestPlayer == PlayerId() then return end
            local sID = GetPlayerServerId(closestPlayer)
            TriggerServerEvent("core:activities:askJob", sID, PositionsLettres.jobName)
        end
    end
end)

function AddTenueLettre()
    local Skin = p:skin()
    ApplySkinFake(Skin)
    -- TODO
    if GetEntityModel(p:ped()) == `mp_m_freemode_01` then 
        SkinChangeFake("torso_1", 9)
        SkinChangeFake("torso_2", 11)
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
        SkinChangeFake("torso_1", 27)
        SkinChangeFake("torso_2", 0)
        SkinChangeFake("tshirt_1", 14)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 0)
        SkinChangeFake("arms_2", 0)
        SkinChangeFake("pants_1", 25)
        SkinChangeFake("pants_2", 9)
        SkinChangeFake("shoes_1", 1)
        SkinChangeFake("shoes_2", 0)
        SkinChangeFake("helmet_1", 172)
        SkinChangeFake("helmet_2", 2)
        SkinChangeFake("bags_1", 180)
        SkinChangeFake("bags_2", 0)
    end
end 

RegisterNetEvent("core:activities:liveupdate", function(typejob, data)
    if typejob == "lettre" then 
        --if data.addpos then 
        --    print("addpos", data.addpos)
        --    print("blippos", blippos)
        --    if blippos then RemoveBlip(blippos) end
        --    addpos = data.addpos
        --    blippos = AddBlipForCoord(addpos)
        --    SetNewWaypoint(addpos.x, addpos.y)
        --end
        --if data.recupedLettres then 
        --    recupedLettres = data.recupedLettres
        --    if recupedLettres == 1 then 
        --        exports['tuto-fa']:HideStep()
        --        Bulle.hide("lettre:recupBoites")
        --        Bulle.hide("poserCoffreLettre")
        --        Bulle.remove("lettre:recupBoites")
        --        Bulle.remove("poserCoffreLettre")
        --        math.randomseed(GetGameTimer())
        --        addpos = data.addpos
        --        blippos = AddBlipForCoord(addpos)
        --        RemoveBlip(blipBoites)
        --        SetNewWaypoint(addpos.x, addpos.y)
        --        SetVehicleDoorShut(veh, 3, false, false)
        --        SetVehicleDoorShut(veh, 2, false, false)
        --        OpenTutoFAInfo(PositionsLettres.jobName, "Montez dans votre scooter et allez sur le point défini sur votre GPS.")
        --    end
        --end
        if data.finished then 
            print("data.finished", data.finished)
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

local shown = false
local hasToGoDeposLettre = false
function StartLetterMission(isFriend)
    AddTenueLettre()
    delivered = 0
    idToGo = math.random(1, #lettrePos)
    OpenTutoFAInfo(PositionsLettres.jobName, "Aller récupérer les lettres sur le point GPS.")
    veh = isFriend and NetToVeh(isFriend.veh) or spawnVeh()
    advance = 0
    Bulle.create("lettre:recupBoites", PositionsLettres.posTakeLettre, "bulleRecupererLettre", true)
    blipBoites = AddBlipForCoord(PositionsLettres.posTakeLettre)
    near = false
    finished = false
    if not isFriend then
        TriggerServerEvent("core:activities:update", PlayersId, "lettre", {MaximumLettres = MaximumLettres, veh = VehToNet(veh)})
    end
    while not finished do
        Wait(1)
        if finished then 
            break
        end
        playerpos = GetEntityCoords(PlayerPedId())
        LettreFindLetterBox(addpos)
        LettreRecupCoffre(addpos, veh)
        -- Donner la lettre au client
        if GetDistanceBetweenCoords(playerpos, addpos) < 2 then
            if HasLettersInHand then
                near = true
                --ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour déposer le colis")
                Bulle.create("colisDepos", addpos + vector3(0.0, 0.0, 1.5), "bulleLivrerLettre", true)
                if IsControlJustPressed(0, 38) then
                    TriggerServerEvent("core:activities:liveupdate", PlayersId, "lettre", {finishcolis = true})
                    p:PlayAnim("anim@heists@narcotics@trash", "throw_b", 49)
                    Wait(1000)
                    DetachEntity(objLettre)
                    DeleteEntity(objLettre)
                    objLettre = nil
                    HasLettersInHand = false
                    ClearPedTasks(p:ped())
                    RemoveBlip(blippos)
                    Bulle.hide("colisDepos")
                    Bulle.remove("colisDepos")
                    if Bulle.exists("poserCoffreLettre") then
                        Bulle.hide("poserCoffreLettre")
                        Bulle.remove("poserCoffreLettre")
                    end
                    delivered += 1
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous déposé une lettre"
                    })
                    hasToGoDeposLettre = false
                    print(delivered, MaximumLettres)
                    if tonumber(delivered) == tonumber(MaximumLettres) then 
                        TriggerServerEvent("core:activities:liveupdate", PlayersId, "lettre", {finished = true})
                        finished = true
                        break
                    end
                    if delivered < MaximumLettres then
                        addpos = GetFirstLetterBoxFromZone(lettrePos[idToGo].xyz, lettrePos[idToGo].w)
                        if addpos == nil then
                            addpos = GetFirstLetterBoxFromZone(lettrePos[idToGo+1] and lettrePos[idToGo+1].xyz or lettrePos[1].xyz, lettrePos[idToGo+1] and lettrePos[idToGo+1].w or lettrePos[1].w)
                            TriggerServerEvent("core:activities:liveupdate", PlayersId, "lettre", {addpos = addpos, delivered = delivered})
                        else
                            TriggerServerEvent("core:activities:liveupdate", PlayersId, "lettre", {addpos = addpos, delivered = delivered})
                        end
                    end
                end
            end
        else
            near = false
        end
        -- Recup lettre pour aller mettre dans le coffre
        if GetDistanceBetweenCoords(GetEntityCoords(p:ped()), PositionsLettres.posTakeLettre) < 2.0 then 
            if IsControlJustPressed(0, 38) then 
                if recupedLettres < MaximumLettres then
                    if not IsEntityPlayingAnim(p:ped(), "anim@heists@box_carry@", "idle", 3) then
                        recupedLettres += 1
                        ExecuteCommand("e letter")
                        Bulle.hide("lettre:recupBoites")
                        Bulle.remove("lettre:recupBoites")
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
        -- Depos dans le coffre des lettres
        if GetDistanceBetweenCoords(GetEntityCoords(p:ped()), PositionsLettres.ped.xyz) < 200.0 then
            if IsEntityPlayingAnim(p:ped(), "anim@heists@box_carry@", "idle", 3) then
                if Vdist2(GetEntityCoords(p:ped()), GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "exhaust"))) < 5.0 or Vdist2(GetEntityCoords(p:ped()), GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "boot"))) < 5.0 then 
                    local posEx = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "exhaust"))
                    if GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "exhaust")) == vector3(0.0, 0.0, 0.0) then 
                        posEx = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "boot"))
                    end
                    Bulle.create("poserCoffreLettre", posEx + vector3(0.0, 0.0, 0.5), "bulleDeposerLettre", true)
                    if IsControlJustPressed(0, 38) then 
                        p:PlayAnim("anim@heists@narcotics@trash", "throw_b", 49)
                        Wait(500)
                        ExecuteCommand("e c")
                        Wait(500)
                        ClearPedTasks(PlayerPedId())
                        exports['tuto-fa']:HideStep()
                        Bulle.hide("lettre:recupBoites")
                        Bulle.hide("poserCoffreLettre")
                        Bulle.remove("lettre:recupBoites")
                        Bulle.remove("poserCoffreLettre")
                        math.randomseed(GetGameTimer())
                        --print("addpos, ShouldReloadZone", addpos, ShouldReloadZone)
                        RemoveBlip(blipBoites)
                        SetNewWaypoint(lettrePos[idToGo].x, lettrePos[idToGo].y)
                        TriggerServerEvent("core:activities:liveupdate", PlayersId, "lettre", {recupedLettres = recupedLettres, addpos = lettrePos[idToGo].xyz})
                        OpenTutoFAInfo(PositionsLettres.jobName, "Montez dans votre scooter et allez sur le point défini sur votre GPS.")
                        Bulle.hide("lettre:recupBoites")
                    end
                end
            end
        end
    end
    FriendHasTakenColis = false
    HasLettersInHand = false
    if Bulle.exists("poserCoffreLettre") then
        Bulle.hide("poserCoffreLettre")
        Bulle.remove("poserCoffreLettre")
    end
    print("FINISHEDD")
    RemoveBlip(blippos)
    advance = advance + 1
    if stoped then return end
    local finishblip = AddBlipForCoord(PositionsLettres.deleteVehicule.xy, 10.0)
    SetNewWaypoint(PositionsLettres.deleteVehicule.xy)
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        content = "Allez rendre le scooter pour etre payé"
    })
    zone.addZone(PositionsLettres.jobName..":deleteveh",
        PositionsLettres.deleteVehicule.xyz,
        "Appuyer sur ~INPUT_CONTEXT~ pour rendre le vehicle",
        function()
            RemoveBlip(finishblip)
            endLetterMission()
            TriggerServerEvent("core:activities:kickPlayers", PlayersId, "lettre")
        end,
        false,
        27,
        0.5,
        { 255, 255, 255 },
        170,
        5.5,
        true,
        "bulleRendreVelo"
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


RegisterCommand("stoplettre", function()
    stoped = true
    advance = 5
    local playerSkin = p:skin()
    ApplySkin(playerSkin)
    recupedLettres = 0
    exports['tuto-fa']:HideStep()
end)



function endLetterMission()
    onMissionFinished()
    RemoveBlip(blippos)
    RemoveBlip(blipBoites)
    local veh = GetVehiclePedIsIn(p:ped(), false)
    if veh then
        removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
        TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
        TriggerEvent('persistent-vehicles/forget-vehicle', veh)
        DeleteEntity(veh)
    end
    if MissionVeh and DoesEntityExist(MissionVeh) then 
        DeleteEntity(MissionVeh)
    end

    BoxesDone = {}

    if delivered ~= 0 then
        
        local winmin, winmax = 20, 30
        local varWinMin, varWinMax = getWinRange("facteur", 20, 30)
        if tonumber(varWinMin) and tonumber(varWinMax) then 
            winmin, winmax = varWinMin, varWinMax
        end
        local money = math.random(winmin, winmax)
        price = money * delivered
        if p:getSubscription() == 1 then price = price*1.25 end 
        if p:getSubscription() == 2 then price = price*2 end 
        TriggerSecurGiveEvent("core:addItemToInventory", token, "money", price, {})

        local nprice = price or 0
        exports['vNotif']:createNotification({
            type = 'VERT',
            content = "Vous avez gagné "..nprice..'$'
        })
    end
    delivered = 0
    recupedLettres = 0
    price = 0

    for k,v in pairs(ColisObj) do 
        if DoesEntityExist(k) then 
            DeleteEntity(k)
        end
    end
    local playerSkin = p:skin()
    ApplySkin(playerSkin)
    
    stoped = true
    finished = true
    exports['tuto-fa']:HideStep()
    FriendHasTakenColis = false
    HasLettersInHand = false
    if Bulle.exists("poserCoffreLettre") then
        Bulle.hide("poserCoffreLettre")
        Bulle.remove("poserCoffreLettre")
    end
    Bulle.hide("lettre:recupBoites")
    RemoveBlip(blippos)
    RemoveBlip(blipBoites)

    pos = {}
    advance = 0
    if PositionsLettres and PositionsLettres.jobName then
        Bulle.hide(PositionsLettres.jobName..":deleteveh")
        zone.hideNotif(PositionsLettres.jobName..":deleteveh")
        zone.removeZone(PositionsLettres.jobName..":deleteveh")
    end
end


RegisterNetEvent("core:activities:create", function(typejob, players)
    if typejob == "lettre" then 
        AddTenueLettre()
    end
    PlayersId = players
end)

RegisterNetEvent("core:activities:update", function(typejob, data, src)
    if src ~= GetPlayerServerId(PlayerId()) then
        if typejob == "lettre" then 
            -- lettre job
            StartLetterMission(data)
        end
    end
end)

RegisterNetEvent("core:activities:kickPlayer", function(typejob)
    if typejob == "lettre" then 
        endLetterMission()
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
    print("^3[JOBS]: ^7"..PositionsLettres.jobName.." ^3loaded")
end)

local shown2 = false
function LettreRecupCoffre(addpos, veh)
    if GetDistanceBetweenCoords(playerpos, addpos) < 20.0 then
        if not IsPedInAnyVehicle(p:ped()) then 
            if not HasLettersInHand then
                if not FriendHasTakenColis then
                    if not shown2 then
                        OpenTutoFAInfo(PositionsLettres.jobName, "Vous devez récupérer la lettre dans votre coffre.")
                        shown2 = true
                    end
                    Bulle.create("poserCoffreLettre", GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "exhaust")) + vector3(0.0, 0.0, 0.5), "bulleRecupererLettre", true)
                    if Vdist2(GetEntityCoords(p:ped()), GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "exhaust"))) < 5.0 or Vdist2(GetEntityCoords(p:ped()), GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "boot"))) < 5.0 then 
                        if IsControlJustPressed(0, 38) then 
                            TriggerServerEvent("core:activities:liveupdate", PlayersId, "lettre", {takencolis = true})
                            objLettre = AttachLetter()
                            HasLettersInHand = true
                            exports['tuto-fa']:HideStep()
                            Bulle.hide("poserCoffreLettre")
                            Bulle.remove("poserCoffreLettre")
                        end
                    end
                else
                    Bulle.hide("poserCoffreLettre")
                    Bulle.remove("poserCoffreLettre")
                end
            else
                if shown then
                    shown = false
                    if Bulle.exists("poserCoffreLettre") then
                        Bulle.hide("poserCoffreLettre")
                        Bulle.remove("poserCoffreLettre")
                    end
                    exports['tuto-fa']:HideStep()
                end
            end
        else
            if shown then
                shown = false
                if Bulle.exists("poserCoffreLettre") then
                    Bulle.hide("poserCoffreLettre")
                    Bulle.remove("poserCoffreLettre")
                end
                exports['tuto-fa']:HideStep()
            end
            if Bulle.exists("poserCoffreLettre") then
                Bulle.hide("poserCoffreLettre")
                Bulle.remove("poserCoffreLettre")
            end
        end
    end
end

function LettreFindLetterBox()
    -- Prendre lettre du coffre
    if GetDistanceBetweenCoords(p:pos(), lettrePos[idToGo].xyz) < 50.0 and not hasToGoDeposLettre then
        local newpos = GetFirstLetterBoxFromZone(lettrePos[idToGo].xyz, lettrePos[idToGo].w + 1.0)
        local timer = 1
        while newpos == nil and timer < 20 do 
            Wait(200)
            timer += 1
            newpos = GetFirstLetterBoxFromZone(lettrePos[idToGo].xyz, lettrePos[idToGo].w + 1.0)
        end
        print("Go find pos", newpos)
        if newpos == nil then
            print("Toutes les boites aux lettres faites donc fini")
            finished = true
        else
            addpos = newpos
            hasToGoDeposLettre = true
        end
    else
        shown = false
    end
end