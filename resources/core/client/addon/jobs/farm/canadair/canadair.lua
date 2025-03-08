local PlayersId = {}
local PlayersInJob = {}
local radiusWater = nil
local finishedMission = false
local radiusFire = nil
local Smoke1 = nil 
local Smoke2 = nil
local WaterAvion = nil
local Passages = 1
local haswatered = false
local countedWater = 0
local blip = nil
local hasWater = false

local MissionsPos = {
    {
        Water = vector3(1700.92, 4192.06, 30.7),
        Fire = vector3(1478.43, 4708.36, 119.24),
    },
    {
        Water = vector3(1700.92, 4192.06, 30.7),
        Fire = vector3(1261.83, 4390.84, 43.38),
    },
    {
        Water = vector3(1700.92, 4192.06, 30.7),
        Fire = vector3(1314.72, 4598.26, 128.27),
    },
}

local PosCanadair = {
    Interact = vector4(2138.22, 4796.54, 40.12, 29.04),
}

local canadair = nil

local DLCMars = true
local SubscriptionNeed = 1

CreateThread(function()
    while not p do Wait(200) end
    --while not GetVariable do Wait(500) end
    --SubscriptionNeed = GetVariable("job").canadair and GetVariable("job").canadair.premium ~= nil and GetVariable("job").canadair.premium or 1
    PlayersInJob = {
        { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
    }
    if not DLCMars then return end
    local ped = entity:CreatePedLocal("s_m_y_fireman_01", PosCanadair.Interact.xyz, PosCanadair.Interact.w)
    ped:setFreeze(true)
    SetEntityInvincible(ped.id, true)
    SetEntityAsMissionEntity(ped.id, 1, 1)
    SetBlockingOfNonTemporaryEvents(ped.id, true)

    zone.addZone("canadair", -- Nom
        PosCanadair.Interact.xyz +  vector3(0.0, 0.0, 2.0),
        "~INPUT_PICKUP~ Prendre le canadair",
        function()
            SendNUIMessage({
                type = "openWebview",
                name = "MenuJob",
                data = {
                    headerBanner = "https://cdn.sacul.cloud/v2/vision-cdn/dlcavril/banner_canadair.webp",
                    choice = {
                        label = "Avion",
                        isOptional = false,
                        choices = {
                            {
                                id = 1,
                                label = 'Canadair CL415',
                                name = 'canadair',
                                img= "https://cdn.sacul.cloud/v2/vision-cdn/dlcavril/cl415.webp",
                            },
                        },
                    },
                    participants = PlayersInJob,
                    participantsNumber = 4,
                    callbackName = "MetierCanadair",
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
        "bulleTravaillerCanadair"
    )
end)

local PoseCanadair = {
    vector4(2140.07, 4814.13, 40.2, 114.76),
    vector4(2123.04, 4805.67, 40.2, 115.97),
    vector4(2103.28, 4796.04, 40.06, 115.97),
}

local function CreateSmoke(pos)
    if not HasNamedPtfxAssetLoaded("scr_agencyheistb") then
        RequestNamedPtfxAsset("scr_agencyheistb")
        local timer = 1
        while not HasNamedPtfxAssetLoaded("scr_agencyheistb") and timer < 500 do
            Wait(1)
            timer += 1
        end
    end
    if not HasNamedPtfxAssetLoaded("scr_trevor3") then
        RequestNamedPtfxAsset("scr_trevor3")
        local timer = 1
        while not HasNamedPtfxAssetLoaded("scr_trevor3") and timer < 500 do
            Wait(1)
            timer += 1
        end
    end
    UseParticleFxAsset("scr_agencyheistb")
    Smoke1 = StartParticleFxLoopedAtCoord(
        "scr_env_agency3b_smoke",
        pos + vector3(0.0, 0.0, 1.0),
        0.0,
        0.0,
        0.0,
        5.0,
        false,
        false,
        false,
        false
    )

    UseParticleFxAsset("scr_trevor3")

    Smoke2 = StartParticleFxLoopedAtCoord(
        "scr_trev3_trailer_plume",
        pos + vector3(0.0, 0.0, 1.2),
        0.0,
        0.0,
        0.0,
        4.5,
        false,
        false,
        false,
        false
    )
end

local function CreateMissionCanadair(isFriend)
    local randommission = nil -- MissionsPos[math.random(1, #MissionsPos)]
    if isFriend then 
        randommission = isFriend.missionpos
    else
        randommission = MissionsPos[math.random(1, #MissionsPos)]
        TriggerServerEvent("core:activities:update", PlayersId, "canadair", {missionpos = randommission})
    end
    Wait(200)
    hasntshow = false
    radiusWater = AddBlipForRadius(randommission.Water, 300.0)
    SetNewWaypoint(randommission.Water.xy)
    SetBlipAsShortRange(radiusWater, false)
    SetBlipColour(radiusWater, 42)
    OpenTutoFAInfo("Bombardier d'eau", "Décollez de la piste et charge l'avion en eau dans la mer, fait attention a te poser doucement")
    CreateSmoke(randommission.Fire)
    local cooord = GetEntityCoords(PlayerPedId())
    while true do 
        Wait(1)

        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
        local height = GetEntityHeightAboveGround(GetVehiclePedIsIn(PlayerPedId()))

        local zDiff = (z - randommission.Water.z) < 4.0
        if zDiff and GetDistanceBetweenCoords(GetEntityCoords(GetVehiclePedIsIn(p:ped())), randommission.Water - vector3(0.0, 0.0, 1.5), true) < 300.0 and not hasWater then 
            DeleteWaypoint()
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                content = "Vous êtes en train de récupérer l'eau..."
            })
            haswatered = false
            Wait(5000)
            if not hasWater then
                hasWater = true
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "Vous avez récupéré l'eau, allez éteindre le feu"
                })
                SetVehicleFixed(p:currentVeh())
                SetVehicleBodyHealth(p:currentVeh(), 1000.0)
                SetVehicleEngineHealth(p:currentVeh(), 1000.0)
                SetVehicleDirtLevel(p:currentVeh(), 0.0)
                RemoveBlip(radiusWater)
                radiusFire = AddBlipForRadius(randommission.Fire, 75.0)
                SetBlipColour(radiusFire, 49)
                SetBlipAsShortRange(radiusFire, false)
                OpenTutoFAInfo("Bombardier d'eau", "Tu a chargé l'avion en eau ! Rends toi dans la zone de feu et largue la cargaison")
            end
        end

        if Passages >= 3 then 
            DrawMarker(43, 2086.42, 4787.22, 40.06, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 6.0, 6.0, 
                51, 204, 255, 170, 0, 1, 2, 0, nil, nil, 0)
            if GetDistanceBetweenCoords(GetEntityCoords(GetVehiclePedIsIn(p:ped())), 2086.42, 4787.22, 40.06, true) < 6.0 then
                finishedMission = true
                stopMissionCanadair()
                break
            end
        end
        
        if GetDistanceBetweenCoords(GetEntityCoords(GetVehiclePedIsIn(p:ped())), randommission.Fire) < 75.0 then 
            UseParticleFxAsset("core")
            if hasWater then 
                local pos = GetWorldPositionOfEntityBone(canadair, GetEntityBoneIndexByName(canadair, "seat_dside_r2")) - vector3(0.0, 0.0, 1.3)
                UseParticleFxAsset("core")
                WaterAvion = StartParticleFxLoopedAtCoord(
                    "water_splash_plane_in",
                    pos,
                    0.0,
                    0.0,
                    0.0,
                    3.0
                )
                Wait(150)
                countedWater += 1
                if not haswatered and countedWater > 15 then 
                    haswatered = true 
                    if Passages < 4 then 
                        Passages += 1
                        print("add passage")
                        OpenTutoFAInfo("Bombardier d'eau", "Recharge l'avion en eau, oublie pas de te poser doucement")               
                        RemoveBlip(radiusFire)
                        radiusWater = AddBlipForRadius(randommission.Water, 300.0)
                        SetBlipAsShortRange(radiusWater, false)
                        SetBlipColour(radiusWater, 42)
                        hasWater = false
                        countedWater = 0
                    else
                        print("FINISHED")
                        OpenTutoFAInfo("Bombardier d'eau", "Félicitation tu a eteins le feu ! Retourne a la base pour rendre l'avion, n'oublie pas de mettre les roues")                   
                        RemoveBlip(radiusFire)
                        blip = AddBlipForCoord(2086.42, 4787.22, 40.06)
                        SetBlipAsShortRange(blip, false)
                        StopParticleFxLooped(Smoke1)
                        StopParticleFxLooped(Smoke2)
                    end
                end
            else
                StopParticleFxLooped(WaterAvion)
            end
        end
    end
end

local function CreateCanadair(isFriend)
    TriggerSWEvent("TREFSDFD5156FD", "VZEFDSF", 5000)
    for k,v in pairs(PoseCanadair) do 
        if vehicle.IsSpawnPointClear(v.xyz, 5.0) then
            canadair = entity:CreateVehicle("cl415", v.xyz, v.w).id
            TaskWarpPedIntoVehicle(p:ped(), canadair, -1)
            CreateMissionCanadair(isFriend)
            break
        end
    end
end

function stopMissionCanadair()
    PlayersInJob = {
        { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
    }
    DeleteEntity(canadair)
    onMissionFinished()
    exports['tuto-fa']:HideStep()
    RemoveBlip(radiusWater)
    RemoveBlip(radiusFire)
    ClearGpsPlayerWaypoint()
    SetEntityCoords(p:ped(), 2136.84, 4798.02, 40.14)
    RemoveBlip(blip)
    local playerSkin = p:skin()
    ApplySkin(playerSkin)
    if finishedMission then
        local winmin, winmax = 1000, 2000
        local varWinMin, varWinMax = getWinRange("canadair", 1000, 2000)
        if tonumber(varWinMin) and tonumber(varWinMax) then 
            winmin, winmax = varWinMin, varWinMax
        end
        local wined = math.random(winmin, winmax)
        if p:getSubscription() == 1 then wined = wined*1.25 end 
        if p:getSubscription() == 2 then wined = wined*2 end 
        TriggerSecurGiveEvent("core:addItemToInventory", token, "money", wined, {})
        finishedMission = false
        exports['vNotif']:createNotification({
            type = 'VERT',
            content = "Vous avez gagné "..wined.. " $"
        })
    end
    radiusWater = nil
    radiusFire = nil
    Smoke1 = nil 
    Smoke2 = nil
    WaterAvion = nil
    Passages = 0
    haswatered = false
    blip = nil
    hasWater = false
end

RegisterNUICallback("MetierCanadair", function(data)
    if data and data.button == "start" then 
        if p:getSubscription() >= SubscriptionNeed or SubscriptionNeed == 0 then
            --if CheckJobLimit() then
                PlayersId = {}
                for k, v in pairs(PlayersInJob) do 
                    table.insert(PlayersId, v.id)
                end
                TriggerServerEvent("core:activities:create", token, PlayersId, "canadair")
                closeUI()
                CreateCanadair()
            --end
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~c Vous devez avoir le premium"
            })
        end
    elseif data.button == "addPlayer" then
        if data.selected ~= 0 then 
            local closestPlayer = ChoicePlayersInZone(5.0)
            if closestPlayer == nil then
                return
            end
            if closestPlayer == PlayerId() then return end
            local sID = GetPlayerServerId(closestPlayer)
            TriggerServerEvent("core:activities:askJob", sID, "canadair", true)
        end
    elseif data.button == "removePlayer" then
        local playerSe = data.selected
        TriggerServerEvent("core:activities:SelectedKickPlayer", playerSe, "canadair")
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
    elseif data.button == "stop" then
        stopMissionCanadair()
    end
end)

function AddTenueCandair()
    local Skin = p:skin()
    ApplySkinFake(Skin)
    if GetEntityModel(p:ped()) == `mp_m_freemode_01` then 
        SkinChangeFake("torso_1", 618)
        SkinChangeFake("torso_2", 0)
        SkinChangeFake("tshirt_1", 15)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 12)
        SkinChangeFake("arms_2", 0)
        SkinChangeFake("pants_1", 217)
        SkinChangeFake("pants_2", 0)
        SkinChangeFake("shoes_1", 25)
        SkinChangeFake("shoes_2", 0)
        SkinChangeFake("helmet_1", 222)
        SkinChangeFake("helmet_2", 0)
    elseif GetEntityModel(p:ped()) == `mp_f_freemode_01` then 
        SkinChangeFake("torso_1", 669)
        SkinChangeFake("torso_2", 0)
        SkinChangeFake("tshirt_1", 3)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 3)
        SkinChangeFake("arms_2", 0)
        SkinChangeFake("pants_1", 227)
        SkinChangeFake("pants_2", 0)
        SkinChangeFake("shoes_1", 25)
        SkinChangeFake("shoes_2", 0)
        SkinChangeFake("helmet_1", 227)
        SkinChangeFake("helmet_2", 0)
    end
end

RegisterNetEvent("core:activities:create", function(typejob, players)
    if typejob == "canadair" then 
        AddTenueCandair()
    end
    PlayersId = players
end)

RegisterNetEvent("core:activities:update", function(typejob, data, src)
    if src ~= GetPlayerServerId(PlayerId()) then
        if typejob == "canadair" then 
            Wait(math.random(111, 999))
            CreateCanadair(data)
        end
    end
end)

RegisterNetEvent("core:activities:kickPlayer", function(typejob)
    if typejob == "canadair" then 
        stopMissionCanadair()
    end
end)

RegisterNetEvent("core:activities:acceptedJob", function(ply, pname)
    table.insert(PlayersInJob, {name = pname, id = ply})
end)