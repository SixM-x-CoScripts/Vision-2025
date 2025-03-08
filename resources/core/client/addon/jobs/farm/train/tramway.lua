local tram = nil
local StationToGo = 1
local blip = nil
local PlayersId = {}
local PlayersInJob = {}

local DLCMars = true

local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local TrajetsTram = {
    {
        TramSpawn = vector3(-498.7607421875, -680.59393310547, 9.9208860397339),
        PnjSpawnArea = vector3(-501.94165039062, -677.01226806641, 10.808960914612),
        TakeTram = vector4(-534.93597412109, -674.98834228516, 10.808974266052, 272.13305664062),
        GotoPed = vector3(-497.40921020508, -680.75177001953, 10.861402511597),
        maxNPC = math.random(3, 7),
        Stations = {
            vector3(-218.06478881836, -1032.5264892578, 28.325445175171),
            vector3(122.80764770508, -1737.68359375, 28.054738998413),
            vector3(109.93307495117, -1715.8511962891, 28.129474639893),
            vector3(-206.00556945801, -1026.3991699219, 28.324773788452),
            vector3(-512.25152587891, -665.74517822266, 9.912693977356),
        },
        StationsPed = {
            vector3(-214.193359375, -1029.2198486328, 29.140468597412),
            vector3(118.22438812256, -1729.9093017578, 29.110849380493),
            vector3(113.62266540527, -1722.3287353516, 29.112947463989),
            vector3(-210.59341430664, -1029.5753173828, 29.139059066772),
            vector3(-508.96597290039, -669.2578125, 10.808961868286),
        },
        StationsInside = {
            vector3(-216.37489318848, -1027.9421386719, 28.325445175171),
            vector3(113.18564605713, -1729.4057617188, 29.020282745361),
            vector3(114.15760040283, -1719.4011230469, 29.128114700317),
            vector3(-210.59341430664, -1029.5753173828, 29.139059066772),
            vector3(-506.77508544922, -665.33447265625, 9.9162216186523),
        },
    }
}

local TramSpawn, PnjSpawnArea, GotoPed, Stations, StationsPed, StationsInside
CreateThread(function()
    while not p do Wait(1) end
    SetTrainsForceDoorsOpen(false)
    PlayersInJob = {
        { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
    }
    if not DLCMars then return end
    for k,v in pairs(TrajetsTram) do 
        local ped = entity:CreatePedLocal("a_m_y_business_02", v.TakeTram.xyz, v.TakeTram.w)
        ped:setFreeze(true)
        SetEntityInvincible(ped.id, true)
        SetEntityAsMissionEntity(ped.id, 0, 0)
        SetBlockingOfNonTemporaryEvents(ped.id, true)
        zone.addZone("tram"..k, -- Nom
            v.TakeTram.xyz + vector3(0.0, 0.0, 2.0),
            "~INPUT_PICKUP~ Prendre le tram",
            function()
                TramSpawn, PnjSpawnArea, GotoPed, Stations, StationsPed, StationsInside = v.TramSpawn, v.PnjSpawnArea, v.GotoPed, v.Stations, v.StationsPed, v.StationsInside
                SendNUIMessage({
                    type = "openWebview",
                    name = "MenuJob",
                    data = {
                        headerBanner = "https://cdn.sacul.cloud/v2/vision-cdn/dlcavril/banner_tram.webp",
                        choice = {
                            label = "Tram",
                            isOptional = false,
                            choices = {
                                {
                                    id = 1,
                                    label = 'Tramway',
                                    name = 'tram',
                                    img= "https://cdn.sacul.cloud/v2/vision-cdn/dlcavril/tram.webp",
                                },
                            },
                        },
                        participants = PlayersInJob,
                        participantsNumber = 2,
                        callbackName = "MetierTram",
                    }
                })
            end,
            false,
            27,
            1.5,
            { 255, 255, 255 },
            170,
            3.0,
            true,
            "bulleTravaillerTrain"
        )
    end
end)

RegisterNUICallback("MetierTram", function(data)
    if data and data.button == "start" then 
        if p:getSubscription() >= 1 then
            PlayersId = {}
            for k, v in pairs(PlayersInJob) do 
                table.insert(PlayersId, v.id)
            end
            TriggerServerEvent("core:activities:create", token, PlayersId, "tram")
            closeUI()
            CreerTram(TramSpawn, PnjSpawnArea, GotoPed, -1, Stations, StationsPed, StationsInside)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous devez avoir le premium pour pouvoir faire ce job !"
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
            TriggerServerEvent("core:activities:askJob", sID, "tram", true)
        end
    elseif data.button == "stop" then
        onMissionFinished()
        if blip then RemoveBlip(blip) end
        DeleteMissionTrain(tram)
        local playerSkin = p:skin()
        ApplySkin(playerSkin)
        for k,v in pairs(TramPeds) do 
            DeleteEntity(v)
        end
        TramPeds = {}
    end
end)

local TramPeds = {}

local function CreateMissionPnjTram(amount, posspawn, pedgoto)
    local possiblePnj = {"a_f_m_ktown_01", "a_m_y_busicas_01", "a_f_o_salton_01", "a_f_y_business_03",
        "a_f_y_femaleagent", "a_f_y_topless_01", "a_f_y_gencaspat_01", "a_f_o_genstreet_01", "a_m_y_soucent_01"}
    for i = 1, amount do 
        if possiblePnj[i] then
            local ped = entity:CreatePedLocal(possiblePnj[i], posspawn, math.random(1, 300)).id
            if i <= 2 then
                TaskWarpPedIntoVehicle(ped, tram, i)
            else
                SetEntityCoords(ped, pedgoto)
            end
            SetBlockingOfNonTemporaryEvents(ped, true)
            table.insert(TramPeds, ped)
            Wait(50)
        end
    end
end

function CreerTram(trampos, pedpos, pedgoto, pos, stations, stationsped, inside, isfriend)
    TriggerSWEvent("TREFSDFD5156FD", "VZEFDSF", 5000)
    if not isfriend then

        --if true then
        --    exports['vNotif']:createNotification({
        --        type = 'ROUGE',
        --        -- duration = 5, -- In seconds, default:  4
        --        content = "Le tramway n'est pas disponible pour le moment"
        --    })
        --    return
        --end
        --print("Request")
        loadTrainModels()
        --print("Create tram")
        --print(HasModelLoaded(`metrotrain`))
        Wait(1500)
        tram = CreateMissionTrain(27, trampos.x, trampos.y, trampos.z, true, true, true)
        --print("Created tram GOOd")
        FreezeEntityPosition(tram, true)
        OpenTutoFAInfo("Tram", "Vous avez récupéré des usagers, aller à la prochaine station")
        --print("GetTrainDoorCount")
        local doorCount = GetTrainDoorCount(tram)
        for doorIndex = 0, doorCount - 1 do
            SetTrainDoorOpenRatio(tram, doorIndex, 0.0)
        end
        TaskWarpPedIntoVehicle(p:ped(), tram, pos)
        SetTrainCruiseSpeed(tram, 0.0)
        CreateMissionPnjTram(5, pedpos, pedgoto)
        FreezeEntityPosition(tram, false)
        TriggerServerEvent("core:activities:update", PlayersId, "tramway", {trampos = trampos, pedpos = pedpos, pedgoto = pedgoto, pos = pos, stations = stations, stationsped = stationsped, inside = inside, isfriend = isfriend, tram = tram})
    else
        OpenTutoFAInfo("Tram", "Vous avez récupéré des usagers, aller à la prochaine station")
        tram = NetToVeh(isfriend.tram)
        TaskWarpPedIntoVehicle(p:ped(), tram, 0)
    end
    blip = AddBlipForCoord(stations[StationToGo])
    while true do 
        Wait(1)
        if stations[StationToGo] then
            DrawMarker(43, stations[StationToGo] + vector3(0.0, 0.0, 1.0), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 3.0, 
                51, 204, 255, 170, 0, 1, 2, 0, nil, nil, 0)
        end
        if stations[StationToGo] and stationsped[StationToGo] then
            if GetDistanceBetweenCoords(GetEntityCoords(p:ped()), stations[StationToGo]) < 4.0 then 
                exports['tuto-fa']:HideStep()
                SetVehicleDoorsLocked(tram, 0)
                SetTrainCruiseSpeed(tram, 0.0)
                for k,v in pairs(TramPeds) do 
                    ClearPedTasksImmediately(v)
                    TaskLeaveVehicle(v, tram, 1)
                    SetEntityCoords(v, stationsped[StationToGo])
                    SetEntityAsNoLongerNeeded(v)
                end
                local doorCount = GetTrainDoorCount(tram)
                for doorIndex = 0, doorCount - 1 do
                    SetTrainDoorOpenRatio(tram, doorIndex, 1.0)
                end
                Wait(5000)
                OpenTutoFAInfo("Tram", "Allez à la station suivante pour déposer vos usagers")
                local doorCount = GetTrainDoorCount(tram)
                for doorIndex = 0, doorCount - 1 do
                    SetTrainDoorOpenRatio(tram, doorIndex, 0.0)
                end
                if stationsped[StationToGo] then
                    CreateMissionPnjTram(5, stationsped[StationToGo], inside[StationToGo])
                end
                StationToGo += 1
                RemoveBlip(blip)
                print("go ", StationToGo)
                Wait(700)
                if stations[StationToGo] then
                    blip = AddBlipForCoord(stations[StationToGo])
                end
            end
        else
            for k,v in pairs(TramPeds) do 
                DeleteEntity(v)
            end
            TramPeds =  {}
            endTramWay(pedpos)
            break
        end
        if DoesEntityExist(tram) then
            if IsPedInVehicle(PlayerPedId(), tram, false) then
                if IsControlPressed(0, 32) then -- "Z"
                    SetTrainCruiseSpeed(tram, 15.0)
                end
                if IsControlPressed(0, 33) then -- "S" 
                    SetTrainCruiseSpeed(tram, 5.0)
                end
            end
        end
    end
end

function endTramWay(pedpos)
    PlayersInJob = {
        { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
    }
    onMissionFinished()
    RemoveBlip(blip)
    TaskLeaveVehicle(p:ped(), tram, 16)
    TaskLeaveAnyVehicle(p:ped(), 1, 1)
    Wait(1000)
    DeleteMissionTrain(tram)
    exports['tuto-fa']:HideStep()
    if pedpos then SetEntityCoords(PlayerPedId(), pedpos) end
    StationToGo = 1
    local playerSkin = p:skin()
    ApplySkin(playerSkin)
    local winmin, winmax = 1000, 2000
    if GetVariable("job") and GetVariable("job").tram then 
        winmin, winmax = GetVariable("job").tram.winMin, GetVariable("job").tram.winMax
    end
    for k,v in pairs(TramPeds) do 
        DeleteEntity(v)
    end
    TramPeds = {}
    local amount = math.random(winmin, winmax)
    if p:getSubscription() == 1 then amount = amount*1.25 end 
    if p:getSubscription() == 2 then amount = amount*2 end 
    TriggerSecurGiveEvent("core:addItemToInventory", token, "money", amount, {})
    exports['vNotif']:createNotification({
        type = 'VERT',
        content = "Vous avez gagné "..amount..'$'
    })
    tram = nil
end

function AddTenueTram()
    local Skin = p:skin()
    ApplySkinFake(Skin)
    if GetEntityModel(p:ped()) == `mp_m_freemode_01` then 
        SkinChangeFake("torso_1", 29)
        SkinChangeFake("torso_2", 0)
        SkinChangeFake("tshirt_1", 33)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 12)
        SkinChangeFake("arms_2", 0)
        SkinChangeFake("pants_1", 10)
        SkinChangeFake("pants_2", 0)
        SkinChangeFake("shoes_1", 24)
        SkinChangeFake("shoes_2", 0)
        SkinChangeFake("helmet_1", 113)
        SkinChangeFake("helmet_2", 1)
        SkinChangeFake("chain_1",26)
        SkinChangeFake("chain_2", 2)
    elseif GetEntityModel(p:ped()) == `mp_f_freemode_01` then 
        SkinChangeFake("torso_1", 92)
        SkinChangeFake("torso_2", 2)
        SkinChangeFake("tshirt_1", 38)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 3)
        SkinChangeFake("arms_2", 0)
        SkinChangeFake("pants_1", 34)
        SkinChangeFake("pants_2", 0)
        SkinChangeFake("shoes_1", 0)
        SkinChangeFake("shoes_2", 0)
        SkinChangeFake("helmet_1", 112)
        SkinChangeFake("helmet_2", 1)
        SkinChangeFake("chain_1",22)
        SkinChangeFake("chain_2", 0)
    end
end

RegisterNetEvent("core:activities:create", function(typejob, players)
    if typejob == "tram" then 
        AddTenueTram()
    end
    PlayersId = players
end)

RegisterNetEvent("core:activities:update", function(typejob, data, src)
    if src ~= GetPlayerServerId(PlayerId()) then
        if typejob == "tram" then 
            CreerTram(data.trampos, data.pedpos, data.pedgoto, data.pos, data.stations, data.stationsped, data.inside, data)
        end
    end
end)

RegisterNetEvent("core:activities:kickPlayer", function(typejob)
    if typejob == "tram" then 
        endTramWay()
        PlayersInJob = {
            { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
        }
    end
end)

RegisterNetEvent("core:activities:acceptedJob", function(ply, pname)
    table.insert(PlayersInJob, {name = pname, id = ply})
end)