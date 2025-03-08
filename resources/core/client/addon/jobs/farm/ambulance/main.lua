
local DLCMars = true
local token = nil

local InMission = false

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local PlayersId = {}
local PlayersInJob = {}

if not DLCMars then return end
local Ambu = {
    ["Ped"] = {
        vector4(318.17, -1476.46, 28.97, 234.25)
    },

    ["Spawn"] =  {
        ["Hopital"] = {
            name = "Hopital",
            pos = vector4(313.32, -1465.03, 45.51, 138.1)
        }
    },

    ["Mission"] = {
        {
            ped = vector4(-1211.6420898438, 3851.771484375, 488.93154907227, 96.817626953125),
            Mission = "Un randonneur a fait une chute dans les montagnes, il a besoin d'aide pour redescendre. Rendez-vous sur place pour le secourir.",
            pedModel = "a_f_y_eastsa_01"
        },
        {
            ped = vector4(2465.1186523438, 3765.5981445312, 40.717212677002, 53.907005310059),
            Mission = "Un toxicomane a fait une overdose, il a besoin d'aide pour être transporté à l'hôpital. Rendez-vous sur place pour le secourir.",
            pedModel = "cs_old_man1a"
        },
        {
            ped = vector4(174.79502868652, 2706.4970703125, 41.213573455811, 184.44554138184),
            Mission = "Un toxicomane a fait une overdose, il a besoin d'aide pour être transporté à l'hôpital. Rendez-vous sur place pour le secourir.",
            pedModel = "cs_old_man1a"
        },
        {
            ped = vector4(3201.8005371094, 4716.0751953125, 191.32893371582, 166.70758056641),
            Mission = "Un randonneur a fait une chute dans les montagnes, il a besoin d'aide pour redescendre. Rendez-vous sur place pour le secourir.",
            pedModel = "a_f_y_eastsa_01"
        },
        {
            ped = vector4(-952.67791748047, 4841.9028320312, 312.52056884766, 255.25700378418),
            Mission = "Un randonneur a fait une chute dans les montagnes, il a besoin d'aide pour redescendre. Rendez-vous sur place pour le secourir.",
            pedModel = "a_f_y_eastsa_01"
        },
        {
            ped = vector4(2549.3469238281, 4799.6943359375, 32.183536529541, 223.40480041504),
            Mission = "Un fermier s'est blessé à la ferme, il a besoin d'aide pour être transporté à l'hôpital. Rendez-vous sur place pour le secourir.",
            pedModel = "a_m_m_farmer_01"
        },
        {
            ped = vector4(2518.2705078125, 4345.7900390625, 38.510719299316, 117.55492401123),
            Mission = "Un fermier s'est blessé à la ferme, il a besoin d'aide pour être transporté à l'hôpital. Rendez-vous sur place pour le secourir.",
            pedModel = "a_m_m_farmer_01"
        },
    },
}

local vehCreate = nil

local function SpawnHeli()
    if vehicle.IsSpawnPointClear(Ambu["Spawn"]["Hopital"].pos.xyz, 3.0) then
        if DoesEntityExist(vehCreate) then
            TriggerEvent('persistent-vehicles/forget-vehicle', vehCreate)
            removeKeys(GetVehicleNumberPlateText(vehCreate), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehCreate))))
            TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehCreate))
            DeleteEntity(vehCreate)
        end
        vehCreate = vehicle.create("emsswift", Ambu.Spawn.Hopital.pos.xyzw, {})
        local plate = vehicle.getProps(vehCreate).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehCreate)))
        TaskWarpPedIntoVehicle(PlayerPedId(), vehCreate, -1)
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehCreate, VehToNet(vehCreate), p:getJob())
        createKeys(plate, model)
    end
end

local BlipSecouriste = nil
local NextStep = true
local Interval = 700
local PedToSave = nil

local IsPushed = false

local notBoss = false
local waitInvite = nil
local finish = false

function AddTenueSecouriste()
    local Skin = p:skin()
    ApplySkinFake(Skin)
    if GetEntityModel(p:ped()) == `mp_m_freemode_01` then 
        SkinChangeFake("torso_1", 618)
        SkinChangeFake("torso_2", 1)
        SkinChangeFake("tshirt_1", 15)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 12)
        SkinChangeFake("arms_2", 0)
        SkinChangeFake("pants_1", 217)
        SkinChangeFake("pants_2", 0)
        SkinChangeFake("shoes_1", 25)
        SkinChangeFake("shoes_2", 0)
        SkinChangeFake("helmet_1", 19)
        SkinChangeFake("helmet_2", 0)
    elseif GetEntityModel(p:ped()) == `mp_f_freemode_01` then 
        SkinChangeFake("torso_1", 669)
        SkinChangeFake("torso_2", 1)
        SkinChangeFake("tshirt_1", 3)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 3)
        SkinChangeFake("arms_2", 0)
        SkinChangeFake("pants_1", 227)
        SkinChangeFake("pants_2", 0)
        SkinChangeFake("shoes_1", 25)
        SkinChangeFake("shoes_2", 0)
        SkinChangeFake("helmet_1", 19)
        SkinChangeFake("helmet_2", 0)
        --SkinChangeFake("chain_1",22)
        --SkinChangeFake("chain_2", 0)
    end
end

local function StartSecouristeMission(host, mission, PedToSave2)


    NextStep = true

    RemoveBlip(BlipSecouriste)
    BlipSecouriste = AddBlipForCoord(mission.ped.xyz)
    SetBlipRoute(BlipSecouriste, true)
    SetBlipColour(BlipSecouriste, 12)
    SetBlipRouteColour(BlipSecouriste, 12)
    --RemoveAnimSet("move_m@injured")

    InMission = true

    OpenTutoFAInfo("Secouriste", mission.Mission)

    CreateThread(function()
        while GetDistanceBetweenCoords(GetEntityCoords(p:ped()),mission.ped.xyz) > 100.0 do 
            Wait(299)
        end
        if host then
            PedToSave = entity:CreatePedLocal(mission.pedModel, mission.ped.xyz, mission.ped.h)
            SetEntityInvincible(PedToSave.id, true)
            SetBlockingOfNonTemporaryEvents(PedToSave.id, true)
            PlayEmoteOnPed(PedToSave.id, "anim@amb@nightclub@lazlow@lo_sofa@", "lowsofa_dlg_fuckedup_laz", 1, -1)
        
            RequestAnimSet("move_m@injured")
            Wait(1000)
            SetPedMovementClipset(PedToSave.id, "move_m@injured", 0.2)
            NetworkRequestControlOfEntity(PedToSave.id)
            local timer = 1
            while (not NetworkHasControlOfEntity(PedToSave.id)) and (timer < 200) do 
                Wait(1)
                timer += 1
            end
            Bulle.create("bulleSecouristeAider", mission.ped.xyz + vector3(0.0, 0.0, 2.0), "bulleSecouristeAider", true)
            PlayEmoteOnPed(PedToSave.id, "anim@amb@nightclub@lazlow@lo_sofa@", "lowsofa_dlg_fuckedup_laz", 1, -1)
        end
        Bulle.create("bulleSecouristeAider", mission.ped.xyz + vector3(0.0, 0.0, 2.0), "bulleSecouristeAider", true)
    end)

    local shown = false
    while NextStep do
        Wait(Interval)

        local dist  = GetDistanceBetweenCoords(GetEntityCoords(p:ped()), mission.ped.xyz, false)
        if dist < 100 then
            if not IsPedInAnyVehicle(PlayerPedId()) then 
                if not shown then 
                    OpenTutoFAInfo("Secouriste", "Va voir la personne et ramène la à l'hélicoptère")
                    shown = true
                end
            end
        end
        if dist < 20 then
            Interval = 0
            if not PedToSave then 
                PedToSave = {id = GetClosestPed2(mission.ped.x,mission.ped.y,mission.ped.z,20.0)}
            end
            PlayPain(PedToSave.id, 5)
            local Helico = GetEntityCoords(vehCreate)
            if dist < 5.0 and  IsControlJustPressed(0, 38) and not IsPushed then
                NetworkRequestControlOfEntity(PedToSave.id)
                IsPushed = true
                Bulle.remove("bulleSecouristeAider")
                TaskGoToCoordAnyMeans(PedToSave.id, Helico, 1.0, 0, 0, 786603, 0)
                TaskEnterVehicle(PedToSave.id, vehCreate, -1, 2, 1.0, 1, 0)
                NextStep = false
            end

        end

    end

    NextStep = true
    Interval = 700
    OpenTutoFAInfo("Secouriste", "Ramener le patient à l'hôpital.")
    RemoveBlip(BlipSecouriste)
    BlipSecouriste = AddBlipForCoord(Ambu["Spawn"]["Hopital"].pos.xyz)
    SetBlipRoute(BlipSecouriste, true)
    SetBlipColour(BlipSecouriste, 12)
    SetBlipRouteColour(BlipSecouriste, 12)


    while NextStep do
        Wait(Interval)
        local dist  = GetDistanceBetweenCoords(GetEntityCoords(p:ped()), Ambu["Spawn"]["Hopital"].pos.xyz, true)
        if dist < 300 then
            Interval = 0
            DrawMarker(43, Ambu["Spawn"]["Hopital"].pos.xyz, 0.0, 0.0, 0.0,5.0, 5.0, 5.0, 6.0, 6.0, 6.0, 51, 204, 255, 170, 0, 1, 6, 0, nil, nil, 0)
            if dist < 5.0 then
                local vehicle, dst = GetClosestVehicle(p:pos())
                if vehicle == vehCreate then
                    removeKeys(GetVehicleNumberPlateText(vehCreate), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehCreate))))
                    TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehCreate))
                    TriggerEvent('persistent-vehicles/forget-vehicle', vehCreate)
                    DeleteEntity(vehCreate)
                    DeleteEntity(PedToSave.id)
                    RemoveBlip(BlipSecouriste)
                    
                    TaskLeaveVehicle(PedToSave.id, vehCreate, 0)
                    exports['tuto-fa']:HideStep()
    
                    if myFriend ~= nil then
                        TriggerServerEvent("core:ambulance:FinishMission", myFriend)
                        myFriend = nil
                    end
    
                    local playerSkin = p:skin()
                    ApplySkin(playerSkin)
                    IsPushed = false
                    onMissionFinished()
                    local winmin, winmax = 1000, 3000
                    local varWinMin, varWinMax = getWinRange("secouriste", 1000, 3000)
                    if tonumber(varWinMin) and tonumber(varWinMax) then 
                        winmin, winmax = varWinMin, varWinMax
                    end
                    local amount = math.random(winmin, winmax)
                    TriggerSecurGiveEvent("core:addItemToInventory", token, "money", amount, {})
                    NextStep = false

                    InMission = false

                    SetEntityCoords(PlayerPedId(),Ambu["Ped"][1].xyz)
                    
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous avez gagné "..amount.." $ !"
                    })
                    finish = false
                    waitInvite = nil
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Ce n'est pas votre hélico !"
                    })
                end
            end
        end
    end
end

Citizen.CreateThread(function()
    while not p do Wait(1) end
    local PlayersInJob = {
        { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
    }


    local ped = entity:CreatePedLocal("s_m_m_pilot_01", Ambu["Ped"][1].xyz, Ambu["Ped"][1].w)
    SetEntityInvincible(ped.id, true)
    ped:setFreeze(true)
    SetEntityAsMissionEntity(ped.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped.id, true)

    Bulle.create("bulleSecouristeTravailler", vector3(Ambu["Ped"][1].x, Ambu["Ped"][1].y, Ambu["Ped"][1].z + 2.0), "bulleSecouristeTravailler", true)

    zone.addZone("secouriste_prendre",
    vector3(Ambu["Ped"][1].xyz),
    nil,
    function()
        if p:getSubscription() == 0 then 
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~c Vous devez avoir le premium"
            })
            return 
        end
        if notBoss then 
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Seul la personne qui à lancé la mission peut prendre le camion !"
            })
            return 
        end
        if waitInvite then 
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Tu attend la réponse de ton ami !"
            })
            return 
        end
        if not finish then 
            PlayersInJob = {{ name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }}
            SendNUIMessage({
                type = "openWebview",
                name = "MenuJob",
                data = {
                    headerBanner = "https://cdn.sacul.cloud/v2/vision-cdn/dlcavril/banner_secouriste.webp",
                    choice = {
                        label = "Secouriste",
                        isOptional = false,
                        choices = {
                            {
                                id = 1,
                                label = 'EMS SWIFT',
                                name = "emsswift",
                                img= "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/EMS/emsswift.webp",
                            }
                        },
                    },
                    participants = PlayersInJob,
                    participantsNumber = 2,
                    callbackName = "MetierSecouriste",
                }
            })
        else
            local vehicle, dst = GetClosestVehicle(p:pos())
            if vehicle == vehCreate then
                removeKeys(GetVehicleNumberPlateText(vehCreate), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehCreate))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehCreate))
                TriggerEvent('persistent-vehicles/forget-vehicle', vehCreate)
                DeleteEntity(vehCreate)
                DeleteEntity(PedToSave.id)
                RemoveBlip(BlipSecouriste)
                
                TaskLeaveVehicle(PedToSave.id, vehCreate, 0)
                exports['tuto-fa']:HideStep()

                if myFriend ~= nil then
                    TriggerServerEvent("core:ambulance:FinishMission", myFriend)
                    myFriend = nil
                end

                local playerSkin = p:skin()
                ApplySkin(playerSkin)
                IsPushed = false
                onMissionFinished()
                local winmin, winmax = 1000, 3000
                local varWinMin, varWinMax = getWinRange("secouriste", 1000, 3000)
                if tonumber(varWinMin) and tonumber(varWinMax) then 
                    winmin, winmax = varWinMin, varWinMax
                end
                local amount = math.random(winmin, winmax)
                TriggerSecurGiveEvent("core:addItemToInventory", token, "money", amount, {})
                
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous avez gagné "..amount.." $ !"
                })
                InMission = false
                finish = false
                waitInvite = nil
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Ce n'est pas votre hélico !"
                })
            end

        end
    end,
    false, -- Avoir un marker ou non
    0, -- Id / type du marker
    0.5, -- La taille
    { 255, 255, 255 }, -- RGB
    170-- Alpha
    )


    RegisterNUICallback("MetierSecouriste", function(data)
        if data and data.button then
            if data.button == "start" then
                if p:getSubscription() >= 1 then 
                    if not InMission then
                        finish = false
                        
                        math.randomseed(GetGameTimer())
                        
                        local randomMission = math.random(1, #Ambu["Mission"])
                        local Smission = Ambu["Mission"][randomMission]
                        
                        closeUI()
                        --SetCloth()
                        SpawnHeli()
                        
                        if withFriend then
                            TriggerServerEvent("core:ambulance:StartMission", myFriend, Smission)
                        end
                        AddTenueSecouriste()
                        StartSecouristeMission(true, Smission)
                    end
                
                end
            elseif data.button == "addPlayer" then
                closeUI()
                if data.selected ~= 0 then 
                    local closestPlayer = ChoicePlayersInZone(5.0)
                    if closestPlayer == nil then
                        return
                    end
                    --if closestPlayer == PlayerId() then return end
                    local sID = GetPlayerServerId(closestPlayer)
                    withFriend = true
                    myFriend = sID
                    TriggerServerEvent("core:ambulance:InvitePlayer", sID, p:getFirstname(), GetPlayerServerId(PlayerId()))
                end
            elseif data.button == "removePlayer" then
                local playerSe = data.selected
                TriggerServerEvent("core:ambulance:FinishMission", playerSe)
                for k,v in pairs(PlayersInJob) do 
                    if v.id == playerSe then 
                        table.remove(PlayersInJob, k)
                    end
                end
                closeUI()
            elseif data.button == "stop" then
                StopMissionAmbulance()
            end
        end
    end)

end)

RegisterNetEvent("core:activities:create")
AddEventHandler("core:activities:create", function(typejob, players)
    if typejob == "ambulance" then 
        AddTenueSecouriste()
    end
    PlayersId = players
end)

RegisterNetEvent("core:ambulance:StartMission", function(mission)
    StartSecouristeMission(false, mission)
end)


RegisterNetEvent("core:activities:kickPlayer", function(typejob)
    if typejob == "ambulance" then 
        StopMissionAmbulance()
    end
end)

RegisterNetEvent("stopScript", function()
    StopMissionAmbulance()
end)

function StopMissionAmbulance()
    local vehicle, dst = GetClosestVehicle(p:pos())
    if vehicle == vehCreate then
        removeKeys(GetVehicleNumberPlateText(vehCreate), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehCreate))))
        TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehCreate))
        TriggerEvent('persistent-vehicles/forget-vehicle', vehCreate)
        DeleteEntity(vehCreate)
    end
    DeleteEntity(PedToSave.id)
    RemoveBlip(BlipSecouriste)
    exports['tuto-fa']:HideStep()

    if myFriend ~= nil then
        TriggerServerEvent("core:ambulance:FinishMission", myFriend)
        myFriend = nil
    end
    onMissionFinished()

    local playerSkin = p:skin()
    ApplySkin(playerSkin)
    finish = false
    IsPushed = false
    waitInvite = nil
end