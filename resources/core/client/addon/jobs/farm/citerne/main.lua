local vehCreate = nil
withFriend = false
InsideJobCiterne = false
local DoneK = {}
local notBoss = false
local spawnName = "brickadeta"
local myFriend = nil
needWait = true
local Citerne = {

    ["Spawn"] =  {
        {x=-1046.7596435547, y=-2023.484375, z=12.161570549011, h=133.97700500488},
        {x=-1050.0625, y=-2019.1596679688, z=12.161576271057, h=136.39866638184},
        {x=-1057.4897460938, y=-2011.8005371094, z=12.1615858078, h=137.35264587402},
        {x=-1060.7108154297, y=-2007.5646972656, z=12.16157245636, h=134.34182739258}
    },

    ["LTD"] = {
        Tenue = {
            ["Homme"] = {
                ["Haut"] = {haut = 71, variation = 25, sous_haut = 15, variation_sous_haut = 0, bras = 0, bras2 = 0},
                ["Bas"] = {id = 234, variation = 6},
                ["Chaussure"] = {id = 25, variation = 0},
                ["Chapeau"] = {id = 120, variation = 0}
            },
            ["Femme"] = {
                ["Haut"] = {id = 88, variation = 0, sous_haut = 15, variation_sous_haut = 0, bras = 70, bras2 = 0},
                ["Bas"] = {id = 129, variation = 0},
                ["Chaussure"] = {id = 25, variation = 0},
                ["Chapeau"] = {id = 5, variation = 0}
            }
        },
        Pos = {
            {x=1183.2283935547, y=-321.0407409668, z=69.310134887695, h=51.361598968506}, -- LTD Mirrorpark
            {x=-77.723999023438, y=-1754.8978271484, z=30.277648925781, h=51.361598968506}, -- LTD Grove Street
            {x=-723.79205322266, y=-939.54302978516, z=19.138715744019, h=51.361598968506}, -- LTD Little Seoul
            {x=1212.61, y=-1403.67, z=36.39, h=327.4}, -- LTD Pompier
        }
    },
    ["RON"] = {
        Tenue = {
                ["Homme"] = {
                    ["Haut"] = {haut = 71, variation = 25, sous_haut = 15, variation_sous_haut = 0, bras = 0, bras2 = 0},
                    ["Bas"] = {id = 234, variation = 6},
                    ["Chaussure"] = {id = 25, variation = 0},
                    ["Chapeau"] = {id = 120, variation = 0}
                },
                ["Femme"] = {
                    ["Haut"] = {id = 88, variation = 0, sous_haut = 15, variation_sous_haut = 0, bras = 70, bras2 = 0},
                    ["Bas"] = {id = 129, variation = 0},
                    ["Chaussure"] = {id = 25, variation = 0},
                    ["Chapeau"] = {id = 5, variation = 0}
                }
        },
        Pos = {
            {x= 1213.1893310547, y=-1404.5983886719, z=35.687286376953, h=51.361598968506}, -- RON El burro
            {x=2581.4389648438, y=364.46142578125, z=108.84380340576, h=51.361598968506}, -- RON Monts tataviam
            {x=-1444.5250244141, y=-274.40438842773, z=47.574333190918, h=51.361598968506}, -- RON Morningwood
            {x=1178.94, y=-338.95, z=68.360918, h=51.361598968506},
        }
    },
    ["XeroGas"] = {
        Tenue = {
            ["Homme"] = {
                ["Haut"] = {haut = 71, variation = 25, sous_haut = 15, variation_sous_haut = 0, bras = 0, bras2 = 0},
                ["Bas"] = {id = 234, variation = 6},
                ["Chaussure"] = {id = 25, variation = 0},
                ["Chapeau"] = {id = 120, variation = 0}
            },
            ["Femme"] = {
                ["Haut"] = {id = 88, variation = 0, sous_haut = 15, variation_sous_haut = 0, bras = 70, bras2 = 0},
                ["Bas"] = {id = 129, variation = 0},
                ["Chaussure"] = {id = 25, variation = 0},
                ["Chapeau"] = {id = 5, variation = 0}
            }
        },
        Pos = {
            {x=265.25814819336, y=-1268.7762451172, z=29.380367279053, h=51.361598968506}, -- XeroGas Strawberry
            {x=-705.57769775391, y=-1464.8015136719, z=4.9099078178406, h=51.361598968506}, -- XeroGas La puerta
            {x=-532.35211181641, y=-1212.8297119141, z=18.225637435913, h=51.361598968506}, -- XeroGas Little seoul
            {x=256.39837646484, y=-1269.0373535156, z=29.431301116943, h=51.361598968506}, -- XeroGas Strawberry
            {x=-2106.2075195313, y=-325.54211425781, z=13.772211074829, h=51.361598968506} -- XeroGas Pacific bluffs

        }
    }
}

local finish = false
CreateThread(function()
    while not p do Wait(1) end
    local PlayersInJob = {
        { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
    }

    local pedCiterne = entity:CreatePedLocal("s_m_m_cntrybar_01", vector3(-1051.8033447266, -2033.3562011719, 12.161578178406), 49.972995758057)
    SetEntityInvincible(pedCiterne.id, true)
    pedCiterne:setFreeze(true)
    SetEntityAsMissionEntity(pedCiterne.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(pedCiterne.id, true)

    Bulle.create("bulleCiterneRecuperer",vector3(-1051.8033447266, -2033.3562011719, 14.161578178406),"bulleTravaillerGrosCamion", true)
    zone.addZone("citerne_pos_prendre",
    vector3(-1051.8033447266, -2033.3562011719, 14.161578178406),
    nil,
    function()
        if notBoss then 
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Seul la personne qui à lancé la mission peut prendre le camion !"
            })
            local inpt = ChoiceInput("Voulez vous arreter la mission ?")
            if inpt then 
                removeKeys(GetVehicleNumberPlateText(vehCreate), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehCreate))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehCreate))
                TriggerEvent('persistent-vehicles/forget-vehicle', vehCreate)
                DeleteEntity(vehCreate)
                RemoveBlip(blippos)
                if myFriend ~= nil then
                    TriggerServerEvent("core:citerneFinishMission", myFriend)
                    myFriend = nil
                end
                local playerSkin = p:skin()
                onMissionFinished()
                InsideJobCiterne = false
                ApplySkin(playerSkin)
                finish = false
                waitInvite = nil
            end
            return 
        end
        if waitInvite then return end
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
                    headerBanner = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/12015581374009959241204649826550026271pompiste.webp",
                    choice = {
                        label = "Camions",
                        isOptional = false,
                        choices = {
                            {
                                id = 1,
                                label = 'XeroGas',
                                name = spawnName,
                                img= "https://cdn.sacul.cloud/v2/vision-cdn/Discord/citerne.webp",
                            },
                            {
                                id = 2,
                                label = 'LTD',
                                name = spawnName,
                                img= "https://cdn.sacul.cloud/v2/vision-cdn/Discord/citerne2.webp",
                            },
                            {
                                id = 3,
                                label = 'RON',
                                name = spawnName,
                                img= "https://cdn.sacul.cloud/v2/vision-cdn/Discord/citerne3.webp",
                            }
                        },
                    },
                    participants = PlayersInJob,
                    participantsNumber = 2,
                    callbackName = "MetierCiterne",
                }
            })
        else
            exports['tuto-fa']:HideStep()
            local vehicle, dst = GetClosestVehicleOfType(p:pos(), GetHashKey(spawnName))
            if vehicle == vehCreate then
                    removeKeys(GetVehicleNumberPlateText(vehCreate), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehCreate))))
                    TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehCreate))
                    TriggerEvent('persistent-vehicles/forget-vehicle', vehCreate)
                    DeleteEntity(vehCreate)
                    RemoveBlip(blippos)
                    if myFriend ~= nil then
                        TriggerServerEvent("core:citerneFinishMission", myFriend)
                        myFriend = nil
                    end
                    local playerSkin = p:skin()
                    ApplySkin(playerSkin)
                    onMissionFinished()
                    InsideJobCiterne = false
                    local winmin, winmax = 1000, 1300
                    if GetVariable("jobcenter") and GetVariable("jobcenter").pompiste.winMin and GetVariable("jobcenter").pompiste.winMax then
                        winmin, winmax = GetVariable("jobcenter").pompiste.winMin, GetVariable("jobcenter").pompiste.winMax
                    else
                        winmin, winmax = 1000, 1300
                    end
                    local price = math.random(winmin, winmax)   
                    if p:getSubscription() == 1 then price = 1300*1.25 end 
                    if p:getSubscription() == 2 then price = 1300*2 end 
                    TriggerSecurGiveEvent("core:addItemToInventory", token, "money", price, {})
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous avez gagné "..price.."$ !"
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
    0, -- Id / type du marker
    0.5, -- La taille
    { 255, 255, 255 }, -- RGB
    170-- Alpha
    )


    function SpawnCiterne(veh)
        local liveries = nil
        if veh == "XeroGas" then
            liveries = 2
        elseif veh == "LTD" then
            liveries = 3
        elseif veh == "RON" then
            liveries = 4
        end
        InsideJobCiterne = true
        for k,v in pairs(Citerne.Spawn) do
            if vehicle.IsSpawnPointClear(vector3(v.x,v.y,v.z), 3.0) then
                if DoesEntityExist(vehCreate) then
                    TriggerEvent('persistent-vehicles/forget-vehicle', vehCreate)
                    removeKeys(GetVehicleNumberPlateText(vehCreate), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehCreate))))
                    TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehCreate))
                    DeleteEntity(vehCreate)
                end
                vehCreate = vehicle.create(spawnName, vector4(v.x,v.y,v.z,v.h), {})
                SetVehicleLivery(vehs, liveries)
                local plate = vehicle.getProps(vehCreate).plate
                local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehCreate)))
                TaskWarpPedIntoVehicle(PlayerPedId(), vehCreate, -1)
                local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehCreate, VehToNet(vehCreate), p:getJob())
                createKeys(plate, model)
                break
            end
        end
    end

    local function SetCloth(cloth)
        local Skin = p:skin()
        ApplySkinFake(Skin)
        if GetEntityModel(p:ped()) == `mp_m_freemode_01` then 
            SkinChangeFake("torso_1", Citerne[cloth].Tenue.Homme.Haut.haut)
            SkinChangeFake("torso_2", Citerne[cloth].Tenue.Homme.Haut.variation_haut)
            SkinChangeFake("tshirt_1", Citerne[cloth].Tenue.Homme.Haut.sous_haut)
            SkinChangeFake("tshirt_2", Citerne[cloth].Tenue.Homme.Haut.variation_sous_haut)
            SkinChangeFake("arms", Citerne[cloth].Tenue.Homme.Haut.bras)
            SkinChangeFake("arms_2", Citerne[cloth].Tenue.Homme.Haut.bras2)
            SkinChangeFake("pants_1", Citerne[cloth].Tenue.Homme.Bas.id)
            SkinChangeFake("pants_2", Citerne[cloth].Tenue.Homme.Bas.variation)
            SkinChangeFake("shoes_1", Citerne[cloth].Tenue.Homme.Chaussure.id)
            SkinChangeFake("shoes_2", Citerne[cloth].Tenue.Homme.Chaussure.variation)
            SkinChangeFake("helmet_1", Citerne[cloth].Tenue.Homme.Chapeau.id)
            SkinChangeFake("helmet_2", Citerne[cloth].Tenue.Homme.Chapeau.variation)
        elseif GetEntityModel(p:ped()) == `mp_f_freemode_01` then 
            SkinChangeFake("torso_1", Citerne[cloth].Tenue.Femme.Haut.id)
            SkinChangeFake("torso_2", Citerne[cloth].Tenue.Femme.Haut.variation)
            SkinChangeFake("tshirt_1", Citerne[cloth].Tenue.Femme.Haut.sous_haut)
            SkinChangeFake("tshirt_2", Citerne[cloth].Tenue.Femme.Haut.variation_sous_haut)
            SkinChangeFake("arms", Citerne[cloth].Tenue.Femme.Haut.bras)
            SkinChangeFake("arms_2", Citerne[cloth].Tenue.Femme.Haut.bras2)
            SkinChangeFake("pants_1", Citerne[cloth].Tenue.Femme.Bas.id)
            SkinChangeFake("pants_2", Citerne[cloth].Tenue.Femme.Bas.variation)
            SkinChangeFake("shoes_1", Citerne[cloth].Tenue.Femme.Chaussure.id)
            SkinChangeFake("shoes_2", Citerne[cloth].Tenue.Femme.Chaussure.variation)
            SkinChangeFake("helmet_1", Citerne[cloth].Tenue.Femme.Chapeau.id)
            SkinChangeFake("helmet_2", Citerne[cloth].Tenue.Femme.Chapeau.variation)
        end
    end

    blippos = nil

    function StartCiterne(job)
        DoneK = {}

        RemoveBlip(blippos)
        blippos = AddBlipForCoord(vector3(Citerne[job].Pos[1].x,Citerne[job].Pos[1].y,Citerne[job].Pos[1].z))
        SetBlipRoute(blippos, true)
        SetBlipColour(blippos, 9)
        

        OpenTutoFAInfo("Citerne", "Monter dans le camion, et commencez à livrer le carburant.")
        --Bulle.create("bulleCiternerVider",vector3(Citerne[job].Pos[1].x,Citerne[job].Pos[1].y,Citerne[job].Pos[1].z),"bulleCiternerVider", true)
        CreateThread(function()
            local added = {}
            local found = false
            while InsideJobCiterne do 
                Wait(1) 
                if IsPedInAnyVehicle(PlayerPedId()) then 
                    found = false
                    for k,v in pairs(Citerne[job].Pos) do
                        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(v.x,v.y,v.z)) < 6.0 then 
                            found = true
                            if not DoneK[k] then
                                Bulle.create("bulleCiternerVider",GetEntityCoords(PlayerPedId()) + vector3(0.0, 0.0, 2.0),"bulleCiterneRemplir", true)
                            end
                        end
                    end
                    if not found then 
                        Bulle.hide("bulleCiternerVider")
                    end
                end
            end
        end)
        for k,v in pairs(Citerne[job].Pos) do
            needWait = true
            zone.addZone("bulleCiterneVider"..k,
                vector3(v.x,v.y,v.z),
                nil,
                function()
                    if withFriend then
                        TriggerServerEvent("core:citerneUpdateInMission", myFriend, job, k)
                    end
                    needWait = false
                    if k == #Citerne[job].Pos then
                        OpenTutoFAInfo("Citerne", "Vous avez terminé la livraison, retournez voir le boss pour récupérer votre salaire.")

                        RemoveBlip(blippos)
                        blippos = AddBlipForCoord(vector3(-1051.8033447266, -2033.3562011719, 14.161578178406))
                        SetBlipRoute(blippos, true)
                        SetBlipColour(blippos, 9)

                        if withFriend then
                            TriggerServerEvent("core:citerneUpdate", myFriend , true)
                        end
                        DoneK[k] = true

                        zone.removeZone("bulleCiterneVider"..k)
                        Bulle.hide("bulleCiternerVider")
                        Bulle.remove("bulleCiternerVider")
                        finish = true
                        zone.addZone("terminerCiterne",
                            vector3(-1056.65, -2018.04, 12.16 + 1.0),
                            nil,
                            function()
                                FinishCiterne()
                            end,
                            true, -- Avoir un marker ou non
                            39, -- Id / type du marker
                            1.0, -- La taille
                            { 0, 255, 0 },
                            170,
                            5.5,
                            true,
                            "bulleRendreVelo"
                        )
                        return
                    else
                        DoneK[k] = true
                        OpenTutoFAInfo("Citerne", "Vous avez livré "..k.." / "..#Citerne[job].Pos.." stations.")

                        RemoveBlip(blippos)
                        blippos = AddBlipForCoord(vector3(Citerne[job].Pos[k+1].x,Citerne[job].Pos[k+1].y,Citerne[job].Pos[k+1].z))
                        SetBlipRoute(blippos, true)
                        SetBlipColour(blippos, 9)
                    
                        if withFriend then
                            TriggerServerEvent("core:citerneUpdate", myFriend , false, vector3(Citerne[job].Pos[k+1].x,Citerne[job].Pos[k+1].y,Citerne[job].Pos[k+1].z), #Citerne[job].Pos)
                        end

                        zone.removeZone("bulleCiterneVider"..k)
                        Bulle.hide("bulleCiternerVider")
                        Bulle.remove("bulleCiternerVider")
                        --Bulle.create("bulleCiternerVider",vector3(Citerne[job].Pos[k+1].x,Citerne[job].Pos[k+1].y,Citerne[job].Pos[k+1].z),"bulleCiternerVider", true)
                    end
                end,
                false, -- Avoir un marker ou non
                0, -- Id / type du marker
                1.5, -- La taille
                { 255, 255, 255 }, -- RGB
                170,-- Alpha
                6.0
            )
            while needWait do Wait(1000) end
        end
    end

    local inMission = false
    local waitInvite = false
    RegisterNUICallback("MetierCiterne", function(data)
        -- print("Menu --> ",json.encode(data, {indent = true}))
        if data and data.button then
            if data.button == "start" then
                if CheckJobLimit() then
                    finish = false
                    inMission = true
                    closeUI()
                    SetCloth(data.selected.label)
                    SpawnCiterne(data.selected.label)
                    if withFriend then
                        TriggerServerEvent("core:citerneStartMission", myFriend ,data.selected.label, vehCreate)
                    end
                    StartCiterne(data.selected.label)
                end
            elseif data.button == "removePlayer" then
                local playerSe = data.selected
                TriggerServerEvent("core:citerneFinishMission", playerSe)
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
                FinishCiterne()
            elseif data.button == "addPlayer" then
                closeUI()
                if data.selected ~= 0 then 
                    local closestPlayer = ChoicePlayersInZone(5.0, false)
                    if closestPlayer == PlayerId() then return end
                    if closestPlayer == nil then
                        return
                    end
                    local sID = GetPlayerServerId(closestPlayer)
                    if sID ~= nil then 
                        TriggerServerEvent("core:citerneInvitePlayer", sID, p:getFirstname(), GetPlayerServerId(PlayerId()))
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

    RegisterNetEvent("core:citerneInvitePlayer")
    AddEventHandler("core:citerneInvitePlayer", function(table)
        closeUI()
        Wait(200)
        local jobConfirmation = ChoiceInput("Souhaitez vous rejoindre l'activité livraison en camion citerne avec " .. table.name .. " ?")
        if jobConfirmation then
            if not insideMission then
                insideMission = true
                notBoss = true
                myFriend = table.friendLocal
                TriggerServerEvent("core:citerneAcceptInvite", table.friendLocal, p:getFirstname())
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous êtes déjà dans l'activité."
                })   
            end
        end
    end)
    

    RegisterNetEvent("core:citerneAcceptInvite")
    AddEventHandler("core:citerneAcceptInvite", function(friendName)
        withFriend = true
        waitInvite = false
        PlayersInJob = {{ name = p:getFirstname(), id = 1 }}
        table.insert(PlayersInJob, { name = friendName, id = 2 })
            SendNUIMessage({
                type = "openWebview",
                name = "MenuJob",
                data = {
                    headerBanner = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/12015581374009959241204649826550026271pompiste.webp",
                    choice = {
                        label = "Camions",
                        isOptional = false,
                        choices = {
                            {
                                id = 1,
                                label = 'XeroGas',
                                name = "sultan",
                                img= "https://media.discordapp.net/attachments/1201558137400995924/1202585813767168070/image-removebg-preview_8_1.webp?ex=65d738d0&is=65c4c3d0&hm=ddb822ddda2038f2e93d1da705d321c16a684a17601064331474e1893a536a43&=&format=webp&quality=lossless",
                            },
                            {
                                id = 2,
                                label = 'LTD',
                                name = "sultan",
                                img= "https://media.discordapp.net/attachments/1201558137400995924/1202585815201349672/image-removebg-preview_6_1.webp?ex=65d738d1&is=65c4c3d1&hm=5baa6034fb5cf201e6d45a1c72dd1ed74ce523a1d3bae8c241faad2850f5e0ba&=&format=webp&quality=lossless",
                            },
                            {
                                id = 3,
                                label = 'RON',
                                name = "sultan",
                                img= "https://media.discordapp.net/attachments/1201558137400995924/1202585814438117496/image-removebg-preview_7_1.webp?ex=65d738d1&is=65c4c3d1&hm=85c51d550348904d1157bd7eeaf4d1d6f23b6c8f5ae5cf5d81f31e3fd49019c4&=&format=webp&quality=lossless",
                            },
                            --{
                            --    id = 4,
                            --    label = 'GlobeOIL',
                            --    name = "sultan",
                            --    img= "https://cdn.discordapp.com/attachments/1201558380456718496/1203805358766825502/image.webp",
                            --}
                        },
                    },
                    participants = PlayersInJob,
                    participantsNumber = 2,
                    callbackName = "MetierCiterne",
                }
            })
    end)

    RegisterNetEvent("core:citerneStartMission")
    AddEventHandler("core:citerneStartMission", function(job, car)
        vehCreate = car
        withFriend = true
        InsideJobCiterne = true
        SetCloth(job)
        StartCiterne(job)
    end)

    RegisterNetEvent("core:citerneUpdateInMission")
    AddEventHandler("core:citerneUpdateInMission", function(job, k)
        needWait = false
        if k == #Citerne[job].Pos then
            OpenTutoFAInfo("Citerne", "Vous avez terminé la livraison, retournez voir le boss pour récupérer votre salaire.")

            RemoveBlip(blippos)
            blippos = AddBlipForCoord(vector3(-1051.8033447266, -2033.3562011719, 14.161578178406))
            SetBlipRoute(blippos, true)
            SetBlipColour(blippos, 9)

            zone.removeZone("bulleCiterneVider"..k)
            Bulle.hide("bulleCiternerVider")
            Bulle.remove("bulleCiternerVider")
            finish = true
            return
        else
            OpenTutoFAInfo("Citerne", "Vous avez livré "..k.." / "..#Citerne[job].Pos.." stations.")

            RemoveBlip(blippos)
            blippos = AddBlipForCoord(vector3(Citerne[job].Pos[k+1].x,Citerne[job].Pos[k+1].y,Citerne[job].Pos[k+1].z))
            SetBlipRoute(blippos, true)
            SetBlipColour(blippos, 9)

            zone.removeZone("bulleCiterneVider"..k)
            Bulle.hide("bulleCiternerVider")
            Bulle.remove("bulleCiternerVider")
            Bulle.create("bulleCiternerVider",vector3(Citerne[job].Pos[k+1].x,Citerne[job].Pos[k+1].y,Citerne[job].Pos[k+1].z),"bulleCiterneRemplir", true)
        end
    end)

    RegisterNetEvent("core:citerneUpdate", function(finnish, newpos, amount)
        if finnish then
            OpenTutoFAInfo("Citerne", "Vous avez terminé la livraison, retournez voir le boss pour récupérer votre salaire.")

            RemoveBlip(blippos)
            blippos = AddBlipForCoord(vector3(-1051.8033447266, -2033.3562011719, 14.161578178406))
            SetBlipRoute(blippos, true)
            SetBlipColour(blippos, 9)

            zone.removeZone("bulleCiterneVider"..k)
            Bulle.hide("bulleCiternerVider")
            Bulle.remove("bulleCiternerVider")
            finish = true
            return
        else
            OpenTutoFAInfo("Citerne", "Vous avez livré "..k.." / "..amount.." stations.")

            RemoveBlip(blippos)
            blippos = AddBlipForCoord(newpos)
            SetBlipRoute(blippos, true)
            SetBlipColour(blippos, 9)
            zone.removeZone("bulleCiterneVider"..k)
            Bulle.hide("bulleCiternerVider")
            Bulle.remove("bulleCiternerVider")
            Bulle.create("bulleCiternerVider",newpos,"bulleCiterneRemplir", true)
        end
    end)

    RegisterNetEvent("core:citerneFinishMission")
    AddEventHandler("core:citerneFinishMission", function(finishedFriend)
        if blippos then
            notBoss = false
            withFriend = false
            PlayersInJob = {{ name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }}
            inMission = false
            finish = false
            waitInvite = true
            exports['tuto-fa']:HideStep()
            RemoveBlip(blippos)
            blippos = nil
            onMissionFinished()
            InsideJobCiterne = false
            local playerSkin = p:skin()
            ApplySkin(playerSkin)
            if finishedFriend then
                local price = 1300
                if p:getSubscription() == 1 then price = 1300*1.25 end 
                if p:getSubscription() == 2 then price = 1300*2 end 
                TriggerSecurGiveEvent("core:addItemToInventory", token, "money", price, {})
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous avez gagné 1300$ !"
                })
            end
        end
    end)

end)


function FinishCiterne()
    removeKeys(GetVehicleNumberPlateText(vehCreate), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehCreate))))
    TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehCreate))
    TriggerEvent('persistent-vehicles/forget-vehicle', vehCreate)
    DeleteEntity(vehCreate)
    RemoveBlip(blippos)
    local playerSkin = p:skin()
    ApplySkin(playerSkin)
    PlayersInJob = {{ name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }}
    onMissionFinished()
    InsideJobCiterne = false
    if finish then
        local winmin, winmax = 1000, 3000
        local varWinMin, varWinMax = getWinRange("pompiste", 1000, 3000)
        if tonumber(varWinMin) and tonumber(varWinMax) then 
            winmin, winmax = varWinMin, varWinMax
        end
        local price = math.random(winmin, winmax)
        if p:getSubscription() == 1 then price = 1300*1.25 end 
        if p:getSubscription() == 2 then price = 1300*2 end 
        TriggerSecurGiveEvent("core:addItemToInventory", token, "money", price, {})
        exports['vNotif']:createNotification({
            type = 'VERT',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez gagné "..price.."$ !"
        })
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous n'avez rien gagné"
        })
    end
    if myFriend ~= nil then
        TriggerServerEvent("core:citerneFinishMission", myFriend, finish)
        myFriend = nil
    end
    finish = false
    waitInvite = nil
end