
local DLCMars = true
if not DLCMars then return end
local ConducteurAv = {
    ["Ped"] = {
        {x= -991.59698486328, y=-2943.2504882812, z=12.957759857178, h=67.605926513672}
    },

    ["Spawn"] =  {
        {x= -1059.0512695312, y=-3109.2099609375, z=12.944441795349, h=61.513725280762},
        {x= -967.79064941406, y=-3161.9633789062, z=12.944443702698, h=58.161285400391},
        {x= -1001.6964111328, y=-3141.8591308594, z=12.944437026978, h=59.296005249023},
        {x= -1030.1645507812, y=3125.5656738281, z=12.95051574707, h=59.296005249023},
    },


    ["Destination"] = {
        -- {
        --     pos = {x=-2160.55859375, y=3217.7678222656, z=31.81029510498, h=299.87698364258},
        --     pedGo = {x=-2148.0339355469, y=3313.35546875, z=31.81029510498, h=299.00},
        --     name = "Aéroport Base militaire"
        -- },
        {
            pos = {x= 1737.982421875, y=3278.4829101562, z=40.116306304932, h=299.87698364258},
            pedGo = {x= 1706.5657958984, y=3277.7062988281, z=40.15255355835, h=312.478},
            fuel = {
                citerne = {x=1775.5882568359, y=3344.9165039062, z=39.795822143555, h=212.0283203125},
                ped = {x=1768.1925048828, y=3343.2434082031, z=40.093044281006, h=233.33801269531},
                goTo = {x=1750.8791503906, y=3270.12109375, z=40.202049255371, h=81.363731384277}
            },
            checkPoint = {x=-1206.8056640625, y=-3021.931640625, z=12.944437026978},
            name = "Aéroport Blane County"
        },
        {
            pos = {x= 4468.2221679688, y=-4485.6943359375, z=3.2078747749329, h=339.33},
            pedGo = {x= 4466.3701171875, y=-4471.177734375, z=3.2368564605713, h=312.478},
            fuel = {
                citerne = {x=4512.1616210938, y=-4520.0546875, z=3.1410827636719, h=20.809869766235},
                ped = {x=4508.1767578125, y=-4521.1176757812, z=3.1696147918701, h=233.33801269531},
                goTo = {x=4469.4345703125, y=-4469.7294921875, z=3.2384605407715, h=124.363731384277}
            },
            checkPoint = {x=-1206.8056640625, y=-3021.931640625, z=12.944437026978},
            name = "Aéroport Cayo Perico"
        },
        {
            pos = {x=-2299.9865722656, y=3131.2866210938, z=31.81840133667, h=234.32290649414},
            pedGo = {x= -2285.8588867188, y=3157.3425292969, z=31.814067840576, h=312.478},
            fuel = {
                citerne = {x=-2219.1479492188, y=3300.7739257812, z=31.814041137695, h=213.51344299316},
                ped = {x=-2219.1423339844, y=3305.2868652344, z=31.817070007324, h=233.33801269531},
                goTo = {x=-2302.4128417969,y=3140.7355957031, z=31.81946182251, h=124.363731384277}
            },
            checkPoint = {x=-1206.8056640625, y=-3021.931640625, z=12.944437026978},
            name = "Aéroport Militaire"
        },
    },

    ["VehName"] = {
        "nimbus",
        "velum2",
        "shamal"
    },

    ["Aviateur"] = {
        Tenue = {
            Homme = {
                Haut = {
                    haut = 322,
                    variation_haut = 0,
                    sous_haut = 57,
                    variation_sous_haut = 0,
                    bras = 12,
                    bras2 = 0,
                },
                Bas = {
                    id = 35,
                    variation = 0,
                },
                Chaussure =  {
                    id = 104,
                    variation = 0,
                },
                Casque = {
                    id = 19,
                    variation = 0,
                },
                Cou = {
                    id = 12,
                    variation = 2,
                }
            },
            Femme = {
                Haut = {
                    id = 600,
                    variation_haut = 0,
                    sous_haut = 3,
                    variation_sous_haut = 0,
                    bras = 3,
                    bras2 = 0,
                },
                Bas = {
                    id = 37 ,
                    variation = 0,
                },
                Chaussure =  {
                    id = 29,
                    variation = 2,
                },
                Casque = {
                    id = 19,
                    variation = 0,
                },
                Cou = {
                    id = 22,
                    variation = 0,
                }
            }
        }
    }
}

local pedDepos = nil 
local notBoss = false
local waitInvite = nil 
local inMission = false
local finish = false
local laststep = false

local function SetCloth()
    local Skin = p:skin()
    ApplySkinFake(Skin)
    if GetEntityModel(p:ped()) == `mp_m_freemode_01` then 
        SkinChangeFake("torso_1", ConducteurAv["Aviateur"].Tenue.Homme.Haut.haut)
        SkinChangeFake("torso_2", ConducteurAv["Aviateur"].Tenue.Homme.Haut.variation_haut)
        SkinChangeFake("tshirt_1", ConducteurAv["Aviateur"].Tenue.Homme.Haut.sous_haut)
        SkinChangeFake("tshirt_2", ConducteurAv["Aviateur"].Tenue.Homme.Haut.variation_sous_haut)
        SkinChangeFake("arms", ConducteurAv["Aviateur"].Tenue.Homme.Haut.bras)
        SkinChangeFake("arms_2", ConducteurAv["Aviateur"].Tenue.Homme.Haut.bras2)
        SkinChangeFake("pants_1", ConducteurAv["Aviateur"].Tenue.Homme.Bas.id)
        SkinChangeFake("pants_2", ConducteurAv["Aviateur"].Tenue.Homme.Bas.variation)
        SkinChangeFake("shoes_1", ConducteurAv["Aviateur"].Tenue.Homme.Chaussure.id)
        SkinChangeFake("shoes_2", ConducteurAv["Aviateur"].Tenue.Homme.Chaussure.variation)
        SkinChangeFake("chain_1", ConducteurAv["Aviateur"].Tenue.Homme.Cou.id)
        SkinChangeFake("chain_2", ConducteurAv["Aviateur"].Tenue.Homme.Cou.variation)
        SkinChangeFake("helmet_1", ConducteurAv["Aviateur"].Tenue.Homme.Casque.id)
        SkinChangeFake("helmet_2", ConducteurAv["Aviateur"].Tenue.Homme.Casque.variation)
    elseif GetEntityModel(p:ped()) == `mp_f_freemode_01` then 
        SkinChangeFake("torso_1", ConducteurAv["Aviateur"].Tenue.Femme.Haut.id)
        SkinChangeFake("torso_2", ConducteurAv["Aviateur"].Tenue.Femme.Haut.variation)
        SkinChangeFake("tshirt_1", ConducteurAv["Aviateur"].Tenue.Femme.Haut.sous_haut)
        SkinChangeFake("tshirt_2", ConducteurAv["Aviateur"].Tenue.Femme.Haut.variation_sous_haut)
        SkinChangeFake("arms", ConducteurAv["Aviateur"].Tenue.Femme.Haut.bras)
        SkinChangeFake("arms_2", ConducteurAv["Aviateur"].Tenue.Femme.Haut.bras2)
        SkinChangeFake("pants_1", ConducteurAv["Aviateur"].Tenue.Femme.Bas.id)
        SkinChangeFake("pants_2", ConducteurAv["Aviateur"].Tenue.Femme.Bas.variation)
        SkinChangeFake("shoes_1", ConducteurAv["Aviateur"].Tenue.Femme.Chaussure.id)
        SkinChangeFake("shoes_2", ConducteurAv["Aviateur"].Tenue.Femme.Chaussure.variation)
        SkinChangeFake("chain_1", ConducteurAv["Aviateur"].Tenue.Femme.Cou.id)
        SkinChangeFake("chain_2", ConducteurAv["Aviateur"].Tenue.Femme.Cou.variation)
        SkinChangeFake("helmet_1", ConducteurAv["Aviateur"].Tenue.Femme.Casque.id)
        SkinChangeFake("helmet_2", ConducteurAv["Aviateur"].Tenue.Femme.Casque.variation)
    end
end

local vehCreate = nil
local Blips = nil

local function SpawnPlane(pfVeh)
    for k,v in pairs(ConducteurAv.Spawn) do
        if vehicle.IsSpawnPointClear(vector3(v.x,v.y,v.z), 3.0) then
            if DoesEntityExist(vehCreate) then
                TriggerEvent('persistent-vehicles/forget-vehicle', vehCreate)
                removeKeys(GetVehicleNumberPlateText(vehCreate), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehCreate))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehCreate))
                DeleteEntity(vehCreate)
            end
            vehCreate = vehicle.create(pfVeh, vector4(v.x,v.y,v.z,v.h), {})
            local plate = vehicle.getProps(vehCreate).plate
            local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehCreate)))
            TaskWarpPedIntoVehicle(PlayerPedId(), vehCreate, -1)
            local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehCreate, VehToNet(vehCreate), p:getJob())
            createKeys(plate, model)

            Wait(1000)

            pedDepos = entity:CreatePed("s_m_m_pilot_01", vector3(-1010.5944824219, -3024.2868652344, 12.945067405701))
            SetEntityInvincible(pedDepos.id, true)
            TaskWarpPedIntoVehicle(pedDepos.id, vehCreate, 1)
            break
        end
    end
end

local checkStep = nil
local pedReful = nil
local carReful = nil
local pass = false

local function StartPilotPlane(dest)
    checkStep = true
    local interval = 700

    OpenTutoFAInfo("Pilote", "Va sur la piste pour décoller !")

    RemoveBlip(Blips)
    Blips = AddBlipForCoord(ConducteurAv.Destination[dest].checkPoint.x, ConducteurAv.Destination[dest].checkPoint.y, ConducteurAv.Destination[dest].checkPoint.z)
    SetBlipRoute(Blips, true)
    SetBlipColour(Blips, 12)
    SetBlipRouteColour(Blips, 12)

    --while checkStep do
    --    Wait(interval)
    --    local dist  = GetDistanceBetweenCoords(GetEntityCoords(p:ped()), vector3(ConducteurAv.Destination[dest].checkPoint.x, ConducteurAv.Destination[dest].checkPoint.y, ConducteurAv.Destination[dest].checkPoint.z), false)
    --    if dist < 200 then
    --        interval = 0
    --        DrawMarker(43, ConducteurAv.Destination[dest].checkPoint.x, ConducteurAv.Destination[dest].checkPoint.y, ConducteurAv.Destination[dest].checkPoint.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 6.0, 6.0, 51, 204, 255, 170, 0, 1, 2, 0, nil, nil, 0)
    --        if dist < 2 then
    --            checkStep = false
    --        end
    --    end
    --end

    OpenTutoFAInfo("Pilote", "Va à l'"..ConducteurAv.Destination[dest].name.." pour déposer le passager !")
    checkStep = true
    RemoveBlip(Blips)
    interval = 700
    Blips = AddBlipForCoord(ConducteurAv.Destination[dest].pos.x, ConducteurAv.Destination[dest].pos.y, ConducteurAv.Destination[dest].pos.z)
    SetBlipRoute(Blips, true)
    SetBlipColour(Blips, 12)
    SetBlipRouteColour(Blips, 12)

    while checkStep do
        Wait(interval)
        local dist  = GetDistanceBetweenCoords(GetEntityCoords(p:ped()), vector3(ConducteurAv.Destination[dest].pos.x, ConducteurAv.Destination[dest].pos.y, ConducteurAv.Destination[dest].pos.z), false)
        if dist < 100 then
            interval = 0
            if not pass then 
                DrawMarker(43, ConducteurAv.Destination[dest].pos.x, ConducteurAv.Destination[dest].pos.y, ConducteurAv.Destination[dest].pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 6.0, 6.0, 51, 204, 255, 170, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist < 5.0 then
                OpenTutoFAInfo("Pilote", "Attends que la citerne remplisse l'avion en kerosene avant de decoller")
                pass = true
                RemoveBlip(Blips)
                --SetEntityCoords(vehCreate, ConducteurAv.Destination[dest].pos.x, ConducteurAv.Destination[dest].pos.y, ConducteurAv.Destination[dest].pos.z)
                --SetEntityHeading(vehCreate, ConducteurAv.Destination[dest].pos.h)
                FreezeEntityPosition(vehCreate, true)
                
                Wait(1000)
                
                TaskLeaveVehicle(pedDepos.id, vehCreate, 0)

                pedReful = entity:CreatePed("s_m_m_pilot_01", vector3(ConducteurAv.Destination[dest].fuel.ped.x, ConducteurAv.Destination[dest].fuel.ped.y, ConducteurAv.Destination[dest].fuel.ped.z), ConducteurAv.Destination[dest].fuel.ped.h)
                SetEntityInvincible(pedReful.id, true)
                
                carReful = vehicle.create("brickadeta", vector4(ConducteurAv.Destination[dest].fuel.citerne.x,ConducteurAv.Destination[dest].fuel.citerne.y, ConducteurAv.Destination[dest].fuel.citerne.z, ConducteurAv.Destination[dest].fuel.citerne.h), {})
                Wait(200)
                SetEntityNoCollisionEntity(vehCreate, carReful)
                TaskWarpPedIntoVehicle(pedReful.id, carReful, -1)
                Wait(200)
                TaskVehicleDriveToCoord(pedReful.id, carReful, ConducteurAv.Destination[dest].fuel.goTo.x, ConducteurAv.Destination[dest].fuel.goTo.y, ConducteurAv.Destination[dest].fuel.goTo.z, 40.0, 0, GetEntityModel(carReful), 786603, 5.0, 1.0)
                
                ClearPedTasks(pedDepos.id)
                TaskGoToCoordAnyMeans(pedDepos.id, ConducteurAv.Destination[dest].pedGo.x, ConducteurAv.Destination[dest].pedGo.y, ConducteurAv.Destination[dest].pedGo.z, 1.0, 0, 0, 786603, 0)
                TaskVehicleDriveToCoord(pedReful.id, carReful, ConducteurAv.Destination[dest].fuel.goTo.x, ConducteurAv.Destination[dest].fuel.goTo.y, ConducteurAv.Destination[dest].fuel.goTo.z, 30.0, 0, GetEntityModel(carReful), 786603, 1.0, 1)
                Wait(25000)
                
                TaskVehicleDriveToCoord(pedReful.id, carReful, ConducteurAv.Destination[dest].fuel.citerne.x, ConducteurAv.Destination[dest].fuel.citerne.y, ConducteurAv.Destination[dest].fuel.citerne.z, 30.0, 0, GetEntityModel(carReful), 786603, 1.0, 1)

                Wait(5000)

                FreezeEntityPosition(vehCreate, false)
                checkStep = false
            end
        end
    end

    checkStep = true
    
    OpenTutoFAInfo("Pilote", "Retourne a l'aéroport, passe par le point de contrôle")
    interval = 700
    RemoveBlip(Blips)
    Blips = AddBlipForCoord(ConducteurAv.Destination[dest].checkPoint.x, ConducteurAv.Destination[dest].checkPoint.y, ConducteurAv.Destination[dest].checkPoint.z)
    SetBlipRoute(Blips, true)
    SetBlipColour(Blips, 12)
    SetBlipRouteColour(Blips, 12)

    while checkStep do
        Wait(interval)
        local dist  = GetDistanceBetweenCoords(GetEntityCoords(p:ped()), vector3(ConducteurAv.Destination[dest].checkPoint.x, ConducteurAv.Destination[dest].checkPoint.y, ConducteurAv.Destination[dest].checkPoint.z), false)
        if dist < 200 then
            interval = 0
            DrawMarker(43, ConducteurAv.Destination[dest].checkPoint.x, ConducteurAv.Destination[dest].checkPoint.y, ConducteurAv.Destination[dest].checkPoint.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 6.0, 6.0, 51, 204, 255, 170, 0, 1, 2, 0, nil, nil, 0)
            if dist < 5.0 then
                checkStep = false
            end
        end
    end

    RemoveBlip(Blips)
    Blips = AddBlipForCoord(-1001.5352172852, -3001.7797851562, 12.945063591003)
    SetBlipRoute(Blips, true)
    SetBlipColour(Blips, 12)
    SetBlipRouteColour(Blips, 12)

    DeleteEntity(pedDepos.id)
    DeleteEntity(pedReful.id)
    DeleteEntity(carReful)

    checkStep = true
    
    OpenTutoFAInfo("Pilote", "Ranger l'avion dans le hangar !")
    checkStep = true
    interval = 700
    while checkStep do
        Wait(interval)
        local dist  = GetDistanceBetweenCoords(GetEntityCoords(p:ped()), vector3(-1001.5352172852, -3001.7797851562, 12.945063591003), false)
        if dist < 300 then
            interval = 0
            laststep = true
            DrawMarker(43, -1001.5352172852, -3001.7797851562, 12.945063591003, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 6.0, 6.0, 51, 204, 255, 170, 0, 1, 2, 0, nil, nil, 0)
            if dist < 5.0 then
                exports['tuto-fa']:HideStep()
                DeleteEntity(vehCreate)
                RemoveBlip(Blips)
                checkStep = false
                local playerSkin = p:skin()
                ApplySkin(playerSkin)
                onMissionFinished()
                local winmin, winmax = 500, 1000
                local varWinMin, varWinMax = getWinRange("avion", 500, 1000)
                if tonumber(varWinMin) and tonumber(varWinMax) then 
                    winmin, winmax = varWinMin, varWinMax
                end
                local randomized = math.random(winmin, winmax)
                if p:getSubscription() == 1 then randomized = randomized*1.25 end 
                if p:getSubscription() == 2 then randomized = randomized*2 end 
                TriggerSecurGiveEvent("core:addItemToInventory", token, "money", randomized, {})
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous avez gagné "..randomized.."$ !"
                })


                pedDepos = nil 
                notBoss = false
                waitInvite = nil 
                inMission = false
                finish = false
                laststep = false

                checkStep = nil
                pedReful = nil
                carReful = nil
                pass = false
            end
        end
    end
end

Citizen.CreateThread(function()
    while not p do Wait(100) end
    local PlayersInJob = {
        { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
    }

    local ped = entity:CreatePedLocal("s_m_m_pilot_01", vector3(ConducteurAv["Ped"][1].x, ConducteurAv["Ped"][1].y, ConducteurAv["Ped"][1].z), ConducteurAv["Ped"][1].h)
    SetEntityInvincible(ped.id, true)
    ped:setFreeze(true)
    SetEntityAsMissionEntity(ped.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped.id, true)

    zone.addZone("cdr-avion_prendre",
        vector3(ConducteurAv["Ped"][1].x, ConducteurAv["Ped"][1].y, ConducteurAv["Ped"][1].z + 2.0),
        nil,
        function()
            print(notBoss, waitInvite, inMission, finish)
            if p:getSubscription() == 0 then 
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous devez avoir le premium pour pouvoir faire ce job !"
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
            if inMission then 
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous êtes déjà en mission !"
                })
                return 
            end
            if not finish then 
                PlayersInJob = {{ name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }}
                SendNUIMessage({
                    type = "openWebview",
                    name = "MenuJob",
                    data = {
                        headerBanner = "https://cdn.sacul.cloud/v2/vision-cdn/dlcavril/banner_pilote.webp",
                        choice = {
                            label = "Avions",
                            isOptional = false,
                            choices = {
                                {
                                    id = 1,
                                    label = 'Nimbus',
                                    name = "nimbus",
                                    img= "https://cdn.sacul.cloud/v2/vision-cdn/dlcavril/nimbus.webp",
                                },
                                {
                                    id = 2,
                                    label = 'Velum 2',
                                    name = "velum2",
                                    img= "https://cdn.sacul.cloud/v2/vision-cdn/dlcavril/velum2.webp",
                                },
                                {
                                    id = 3,
                                    label = 'Shamal',
                                    name = "shamal",
                                    img= "https://cdn.sacul.cloud/v2/vision-cdn/dlcavril/shamal.webp",
                                }
                            },
                        },
                        participants = PlayersInJob,
                        participantsNumber = 2,
                        callbackName = "MetierCdrAvion",
                    }
                })
            else
                exports['tuto-fa']:HideStep()
                local vehicle, dst = GetClosestVehicle(p:pos())
                if vehicle == vehCreate then
                    local money = NumberOfCar*250

                    removeKeys(GetVehicleNumberPlateText(vehCreate), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehCreate))))
                    TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehCreate))
                    TriggerEvent('persistent-vehicles/forget-vehicle', vehCreate)
                    DeleteEntity(vehCreate)
                    RemoveBlip(BlipFourriere)
                    if myFriend ~= nil then
                        TriggerServerEvent("core:avionFinishMission", myFriend)
                        myFriend = nil
                    end
                    local playerSkin = p:skin()
                    ApplySkin(playerSkin)
                    onMissionFinished()
                    TriggerSecurGiveEvent("core:addItemToInventory", token, "money", money, {})
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous avez gagné "..money.."$ !"
                    })
                    finish = false
                    waitInvite = nil
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Ce n'est pas votre camion !"
                    })
                end
            end
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        1.5, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        2.5,
        true,
        "bulleTravaillerAvion"
    )

    RegisterNUICallback("MetierCdrAvion", function(data)
        if data and data.button then
            if data.button == "start" then
                --if CheckJobLimit() then
                    finish = false
                    inMission = true
                    math.randomseed(GetGameTimer())
                    local dest = math.random(1, #ConducteurAv["Destination"])
                    closeUI()
                    SetCloth()
                    SpawnPlane(data.selected.name)
                    if withFriend then
                        TriggerServerEvent("core:avionStartMission", myFriend, dest)
                    end
                    StartPilotPlane(dest)
                --end
            elseif data.button == "stop" then
                if vehCreate then 
                    DeleteEntity(vehCreate)
                end
                local playerSkin = p:skin()
                ApplySkin(playerSkin)
                exports['tuto-fa']:HideStep()
                onMissionFinished()
                if Blips then 
                    RemoveBlip(Blips)
                end
                if laststep == true then 
                    checkStep = false
    
                    local winmin, winmax = 1000, 2000
                    local varWinMin, varWinMax = getWinRange("avion", 1000, 2000)
                    if tonumber(varWinMin) and tonumber(varWinMax) then 
                        winmin, winmax = varWinMin, varWinMax
                    end
                    local randomized = math.random(winmin, winmax)
    
                    TriggerSecurGiveEvent("core:addItemToInventory", token, "money", randomized, {})
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous avez gagné "..randomized.."$ !"
                    })
                else
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous avez arreté l'activité"
                    })
                end
                pedDepos = nil 
                notBoss = false
                waitInvite = nil 
                inMission = false
                finish = false
                laststep = false
                checkStep = nil
                pedReful = nil
                carReful = nil
                pass = false
            elseif data.button == "addPlayer" then
                closeUI()
                if data.selected ~= 0 then 
                    local closestPlayer = ChoicePlayersInZone(6.0, false)
                    if closestPlayer == nil then
                        return
                    end
                    local sID = GetPlayerServerId(closestPlayer)
                    if sID ~= nil and myFriend ~= nil then 
                        TriggerServerEvent("core:avionInvitePlayer", sID, p:getFirstname(), GetPlayerServerId(PlayerId()))
                        waitInvite = true
                        myFriend = sID
                        while waitInvite do 
                            Wait(10000)
                            if waitInvite then 
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "Votre invitation n'a pas été accepté !"
                                })
                                myFriend = nil
                                waitInvite = false
                            end
                        end
                    end
                end
            end
        end
    end)

end)

RegisterNetEvent("core:avionFinishMission", function()
    PlayersInJob = {{ name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }}
    if vehCreate then 
        DeleteEntity(vehCreate)
    end
    local playerSkin = p:skin()
    ApplySkin(playerSkin)
    exports['tuto-fa']:HideStep()
    onMissionFinished()
    if Blips then 
        RemoveBlip(Blips)
    end
    if laststep == true then 
        checkStep = false

        local winmin, winmax = 1000, 2000
        local varWinMin, varWinMax = getWinRange("avion", 1000, 2000)
        if tonumber(varWinMin) and tonumber(varWinMax) then 
            winmin, winmax = varWinMin, varWinMax
        end
        local randomized = math.random(winmin, winmax)

        TriggerSecurGiveEvent("core:addItemToInventory", token, "money", randomized, {})
        exports['vNotif']:createNotification({
            type = 'VERT',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez gagné "..randomized.."$ !"
        })
    else
        exports['vNotif']:createNotification({
            type = 'VERT',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez fini l'activité"
        })
    end
    pedDepos = nil 
    notBoss = false
    waitInvite = nil 
    inMission = false
    finish = false
    laststep = false
    checkStep = nil
    pedReful = nil
    carReful = nil
    pass = false
end)