local DLCMars = true
if DLCMars then
    local Fourriere = {

        ["Ped"] = {
            {x= -229.32171630859, y=-1172.7473144531, z=22.044054031372, h=68.7607116}
        },

        ["Spawn1"] =  {
            {x=-239.13346862793, y=-1166.2047119141, z=22.069646835327, h=267.25},
            {x=-239.36328125, y=-1170.8891601562, z=22.043073654175, h=267.49},
            {x=-239.59718322754, y=-1175.8228759766, z=22.091289520264, h=266.32},
            {x=-240.00169372559, y=-1180.931640625, z=22.112512588501, h=264.44},
            {x=292.17, y= -1245.75, z= 28.29, h=86.54}
        },
        ["Spawn2"] =  {
            {x=-239.13346862793, y=-1166.2047119141, z=22.069646835327, h=267.25},
            {x=-240.00169372559, y=-1180.931640625, z=22.112512588501, h=264.44},
            {x=-239.59718322754, y=-1175.8228759766, z=22.091289520264, h=266.32},
            {x=-239.36328125, y=-1170.8891601562, z=22.043073654175, h=267.49},
            {x=292.17, y= -1245.75, z= 28.29, h=86.54}
        },
        ["Spawn3"] =  {
            {x=-239.13346862793, y=-1166.2047119141, z=22.069646835327, h=267.25},
            {x=292.17, y= -1245.75, z= 28.29, h=86.54},
            {x=-239.36328125, y=-1170.8891601562, z=22.043073654175, h=267.49},
            {x=-239.59718322754, y=-1175.8228759766, z=22.091289520264, h=266.32},
            {x=-240.00169372559, y=-1180.931640625, z=22.112512588501, h=264.44}
        },

        ["Dépaneuse"] = {
            Tenue = {
                ["Homme"] = {
                    ["Haut"] = {haut = 66, variation_haut = 3, sous_haut = 57, variation_sous_haut = 0, bras = 12, bras2 = 0},
                    ["Bas"] = {bas = 39, variation_bas = 1},
                    ["Chaussure"] = {chaussure = 39, variation_chaussure = 0},
                },
                ["Femme"] = {
                    ["Haut"] = {id = 60, variation = 1, sous_haut = 15, variation_sous_haut = 0, bras = 3, bras2 = 0},
                    ["Bas"] = {id = 39, variation = 1},
                    ["Chaussure"] = {id = 25, variation = 0},
                }
            },
            PosVeh = {
                {x=-136.0456237793, y=-781.91882324219, z=31.604961395264, h=333.20083618164},
                {x=228.11459350586, y=-855.06561279297, z=28.917356491089, h=245.16110229492},
                {x=517.50164794922, y=-1483.6228027344, z=28.289279937744, h=178.8731842041},
                {x=835.58361816406, y=-1835.0532226562, z=28.281774520874, h=351.94006347656},
            }
        },

        ["VehName"] = {
            "sultan",
            "banshee",
            "futo",
            "kuruma"
        },

        NbCarToRecup = 3
    }

    local withFriend = false
    local notBoss = false
    local needWait = true
    local inMission = false
    local finish = false

    local AttachedCar = nil

    local myFriend = nil


    local posToDepos = nil 
    local NumberOfCar = 0
    local CarToRecup = {}

    local BlipFourriere = nil 
    local checkStep = nil

    function shuffleTable(t)
        local temp = {}
        for i = 1, #t do
            temp[i] = t[i]  -- Copie de l'élément dans la nouvelle table
        end

        local n = #temp
        for i = n, 2, -1 do
            local j = math.random(1, i)
            temp[i], temp[j] = temp[j], temp[i]
        end
        return temp
    end


    Citizen.CreateThread(function()
        while not p do Wait(1) end
        local PlayersInJob = {
            { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
        }

        local AllPed = {}

        for k,v in pairs(Fourriere.Ped) do
            AllPed[k] = entity:CreatePedLocal("s_m_m_trucker_01", vector3(v.x, v.y, v.z), v.h)
            SetEntityInvincible(AllPed[k].id, true)
            AllPed[k]:setFreeze(true)
            SetEntityAsMissionEntity(AllPed[k].id, 0, 0)
            SetBlockingOfNonTemporaryEvents(AllPed[k].id, true)

            Bulle.create("bulleFourriereTravailler",vector3(v.x, v.y, v.z+2.0),"bulleFourriereTravailler", true)
            zone.addZone("fourriere_pos_prendre",
                vector3(v.x, v.y, v.z),
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
                        local confirmation = ChoiceInput("Souhaitez-vous arreter la mission ?")
                        if confirmation then 
                            removeKeys(GetVehicleNumberPlateText(vehCreate), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehCreate))))
                            TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehCreate))
                            TriggerEvent('persistent-vehicles/forget-vehicle', vehCreate)
                            DeleteEntity(vehCreate)
                            RemoveBlip(BlipFourriere)
                            if myFriend ~= nil then
                                TriggerServerEvent("core:fourriereFinishMission", myFriend)
                                myFriend = nil
                            end
                            local playerSkin = p:skin()
                            ApplySkin(playerSkin)
                            zone.removeZone("fourriere_depot_car")
                            onMissionFinished()
                            inMission = false
                            finish = false
                            waitInvite = nil
                        end
                    end
                    if not finish then 
                        PlayersInJob = {{ name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }}
                        SendNUIMessage({
                            type = "openWebview",
                            name = "MenuJob",
                            data = {
                                headerBanner = "https://cdn.sacul.cloud/v2/vision-cdn/dlcavril/banner_fourriere.webp",
                                choice = {
                                    label = "Dépaneuse",
                                    isOptional = false,
                                    choices = {
                                        {
                                            id = 1,
                                            label = 'Dépaneuse',
                                            name = "flatbed3",
                                            img= "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/flatbed3.webp",
                                        }
                                    },
                                },
                                participants = PlayersInJob,
                                participantsNumber = 2,
                                callbackName = "MetierFourriere",
                            }
                        })
                    else
                        exports['tuto-fa']:HideStep()
                        local vehicle, dst = GetClosestVehicle(p:pos())
                        if vehicle == vehCreate then
                            local winmin, winmax = 150, 300
                            local varWinMin, varWinMax = getWinRange("fourriere", 150, 300)
                            if tonumber(varWinMin) and tonumber(varWinMax) then 
                                winmin, winmax = varWinMin, varWinMax
                            end
                            local price = math.random(winmin, winmax)
                            local money = NumberOfCar*price

                            removeKeys(GetVehicleNumberPlateText(vehCreate), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehCreate))))
                            TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehCreate))
                            TriggerEvent('persistent-vehicles/forget-vehicle', vehCreate)
                            DeleteEntity(vehCreate)
                            RemoveBlip(BlipFourriere)
                            if myFriend ~= nil then
                                TriggerServerEvent("core:fourriereFinishMission", myFriend)
                                myFriend = nil
                            end
                            local playerSkin = p:skin()
                            ApplySkin(playerSkin)
                            zone.removeZone("fourriere_depot_car")
                            onMissionFinished()
                            if p:getSubscription() == 1 then money = money*1.25 end 
                            if p:getSubscription() == 2 then money = money*2 end 
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
                0, -- Id / type du marker
                0.5, -- La taille
                { 255, 255, 255 }, -- RGB
                170-- Alpha
            )

        end

        local function SetCloth()
            local Skin = p:skin()
            ApplySkinFake(Skin)
            if GetEntityModel(p:ped()) == `mp_m_freemode_01` then 
                SkinChangeFake("torso_1", Fourriere["Dépaneuse"].Tenue.Homme.Haut.haut)
                SkinChangeFake("torso_2", Fourriere["Dépaneuse"].Tenue.Homme.Haut.variation_haut)
                SkinChangeFake("tshirt_1", Fourriere["Dépaneuse"].Tenue.Homme.Haut.sous_haut)
                SkinChangeFake("tshirt_2", Fourriere["Dépaneuse"].Tenue.Homme.Haut.variation_sous_haut)
                SkinChangeFake("arms", Fourriere["Dépaneuse"].Tenue.Homme.Haut.bras)
                SkinChangeFake("arms_2", Fourriere["Dépaneuse"].Tenue.Homme.Haut.bras2)
                SkinChangeFake("pants_1", Fourriere["Dépaneuse"].Tenue.Homme.Bas.id)
                SkinChangeFake("pants_2", Fourriere["Dépaneuse"].Tenue.Homme.Bas.variation)
                SkinChangeFake("shoes_1", Fourriere["Dépaneuse"].Tenue.Homme.Chaussure.id)
                SkinChangeFake("shoes_2", Fourriere["Dépaneuse"].Tenue.Homme.Chaussure.variation)
            elseif GetEntityModel(p:ped()) == `mp_f_freemode_01` then 
                SkinChangeFake("torso_1", Fourriere["Dépaneuse"].Tenue.Femme.Haut.id)
                SkinChangeFake("torso_2", Fourriere["Dépaneuse"].Tenue.Femme.Haut.variation)
                SkinChangeFake("tshirt_1", Fourriere["Dépaneuse"].Tenue.Femme.Haut.sous_haut)
                SkinChangeFake("tshirt_2", Fourriere["Dépaneuse"].Tenue.Femme.Haut.variation_sous_haut)
                SkinChangeFake("arms", Fourriere["Dépaneuse"].Tenue.Femme.Haut.bras)
                SkinChangeFake("arms_2", Fourriere["Dépaneuse"].Tenue.Femme.Haut.bras2)
                SkinChangeFake("pants_1", Fourriere["Dépaneuse"].Tenue.Femme.Bas.id)
                SkinChangeFake("pants_2", Fourriere["Dépaneuse"].Tenue.Femme.Bas.variation)
                SkinChangeFake("shoes_1", Fourriere["Dépaneuse"].Tenue.Femme.Chaussure.id)
                SkinChangeFake("shoes_2", Fourriere["Dépaneuse"].Tenue.Femme.Chaussure.variation)
            end
        end

        local function SpawnFlatBed()
            for k,v in pairs(Fourriere["Spawn1"]) do
                if vehicle.IsSpawnPointClear(vector3(v.x,v.y,v.z), 3.0) then
                    if DoesEntityExist(vehCreate) then
                        TriggerEvent('persistent-vehicles/forget-vehicle', vehCreate)
                        removeKeys(GetVehicleNumberPlateText(vehCreate), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehCreate))))
                        TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehCreate))
                        DeleteEntity(vehCreate)
                    end
                    posToDepos = vector3(v.x,v.y,v.z)
                    vehCreate = vehicle.create("flatbed3", vector4(v.x,v.y,v.z,v.h), {})
                    local plate = vehicle.getProps(vehCreate).plate
                    local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehCreate)))
                    TaskWarpPedIntoVehicle(PlayerPedId(), vehCreate, -1)
                    local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehCreate, VehToNet(vehCreate), p:getJob())
                    createKeys(plate, model)
                    break
                end
            end
        end

        local function StartFourriereJob(host)
            RemoveBlip(BlipFourriere)
            local PosSelec = {}
            if host then 
                NumberOfCar = 0
                CarToRecup = {}
                local PoseVehs = shuffleTable(Fourriere["Dépaneuse"].PosVeh)
                for k,v in pairs(PoseVehs) do 
                    if NumberOfCar == Fourriere.NbCarToRecup then break end
                    if vehicle.IsSpawnPointClear(vector3(v.x, v.y, v.z), 3.0) then
                        NumberOfCar += 1
                        print("Go for coord", vector4(v.x,v.y,v.z,v.h))
                        PosSelec[k] = vector4(v.x,v.y,v.z,v.h)
                        CarToRecup[NumberOfCar] = vehicle.create(Fourriere["VehName"][math.random(1, #Fourriere["VehName"])], PosSelec[k], {})
                        Wait(1000)
                        --SetVehicleEngineHealth(CarToRecup[NumberOfCar], -4000)
                    end
                end
            end
            Wait(200)
            for i=1, #CarToRecup do
                needWait = true
                checkStep = true
                RemoveBlip(BlipFourriere)
                print("PosSelec[i]",i,  json.encode(PosSelec[i]))
                if PosSelec[i] == nil then 
                    PosSelec[i] = Fourriere["Dépaneuse"].PosVeh[math.random(1, #Fourriere["Dépaneuse"].PosVeh)]
                end
                print("PosSelec[i]2utrghfg",i,  json.encode(PosSelec[i]))
                BlipFourriere = AddBlipForCoord(vector3(PosSelec[i].x, PosSelec[i].y, PosSelec[i].z))
                SetBlipRoute(BlipFourriere, true)
                SetBlipColour(BlipFourriere, 6)
                SetBlipRouteColour(BlipFourriere, 6)
                OpenTutoFAInfo("Fourrière", "Récupère le véhicule indiquer sur ton GPS")
                while checkStep do
                    Wait(1000)
                    local dist  = GetDistanceBetweenCoords(GetEntityCoords(p:ped()), vector3(PosSelec[i].x, PosSelec[i].y, PosSelec[i].z), false)
                    if dist < 10 then
                        if withFriend then
                            TriggerServerEvent("core:fourriereUpdateInMission", myFriend, {checkStep = false, needWait = true})
                        end
                        OpenTutoFAInfo("Fourrière", "Met la voiture sur le plateau de la dépaneuse et ramène la à la fourrière")
                        checkStep = false
                    end
                end
                local shounw = false
                while IsPedInAnyVehicle(PlayerPedId()) do 
                    Wait(100)
                    if not shounw then 
                        OpenTutoFAInfo("Fourrière", "Appuyez sur SHIFT pour faire descendre le plateau")
                        shounw = true
                    end
                end
                OpenTutoFAInfo("Fourrière", "Monter dans le véhicule et placer le sur plateau")
                while not IsPedInAnyVehicle(PlayerPedId()) do 
                    Wait(20)
                end
                local ClosestTow, closestDistance = GetClosestVehicleOfType(GetEntityCoords(PlayerPedId()),GetHashKey("flatbed3"))
                while ClosestTow == -1 do 
                    Wait(100)
                    print("Search new")
                    ClosestTow = GetClosestVehicleOfType(GetEntityCoords(PlayerPedId()),GetHashKey("flatbed3"))
                end
                print("Found ClosestTow", ClosestTow)
                local NewCoord = GetOffsetFromEntityInWorldCoords(ClosestTow,0.0,-7.0,1.0)
                Bulle.create("remorquerardo",vector3(NewCoord.x, NewCoord.y, NewCoord.z),"bulleFourriereRemorquer")
                while IsPedInAnyVehicle(PlayerPedId()) do 
                    Wait(1)
                    local TowedCar = GetVehiclePedIsIn(p:ped())
                    --DrawMarker(36, NewCoord.x, NewCoord.y, NewCoord.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255,
                    --    255, 120, 0, 1, 2, 0, nil, nil, 0)
                    local dist = GetDistanceBetweenCoords(GetEntityCoords(TowedCar), NewCoord.x, NewCoord.y, NewCoord.z)
                    if IsControlJustPressed(0, 38) and dist < 3.0 then 
                        local CoordsBone = GetWorldPositionOfEntityBone(ClosestTow,GetEntityBoneIndexByName(ClosestTow,'misc_s'))
                        local Rotation = GetEntityBoneRotation(ClosestTow,GetEntityBoneIndexByName(ClosestTow,'misc_s'))
                        local CoordsCar = GetWorldPositionOfEntityBone(TowedCar,GetEntityBoneIndexByName(TowedCar,'bodyshell'))
                        local hauteur = CoordsBone.z - CoordsCar.z
                        local Longueur = #(CoordsCar-CoordsBone)
                        local alpha = math.sin(hauteur/Longueur)
                        local beta = alpha - math.rad(1.0*Rotation.x)
                        local z = math.sin(beta)*Longueur + 0.25
                        local y = math.cos(beta)*Longueur
                        AttachedCar = TowedCar
                        AttachEntityToEntity(TowedCar, ClosestTow,GetEntityBoneIndexByName(ClosestTow,'misc_s'),0.0, -y,-z, 0, 0, 0, true, false, true, true, 0, true)
                        --TriggerEvent('hud:NotifColor',"",141)
                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            -- duration = 5, -- In seconds, default:  4
                            content = "Le véhicule est accroché."
                        })
                        Bulle.remove("remorquerardo")
                        OpenTutoFAInfo("Fourrière", "Remontez dans le camion et relevez le plateau avec CTRL")
                    end
                end
                exports['tuto-fa']:HideStep()
                CreateThread(function()
                    local sentZ = false
                    while true do 
                        Wait(1)
                        if GetDistanceBetweenCoords(-232.66, -1169.35, 21.84, GetEntityCoords(PlayerPedId())) < 50.0 then
                            if not sentZ then 
                                OpenTutoFAInfo("Fourrière", "Montez dans le véhicule et appuyez sur E pour pouvoir le rendre à la fourrière")
                                sentZ = true
                            end
                            if GetVehiclePedIsIn(PlayerPedId()) == AttachedCar then 
                                Bulle.create("bulleDetach",GetEntityCoords(AttachedCar) + vec3(0.0, 0.0, 1.0),"bulleDecrocher")
                                if IsControlJustPressed(0, 38) then 
                                    DetachEntity(AttachedCar)
                                    exports['vNotif']:createNotification({
                                        type = 'VERT',
                                        -- duration = 5, -- In seconds, default:  4
                                        content = "Le véhicule est décroché."
                                    })
                                    Bulle.remove("bulleDetach")
                                    break
                                end
                            end
                        end
                    end
                end)

                RemoveBlip(BlipFourriere)
                BlipFourriere = AddBlipForCoord(posToDepos)
                SetBlipRoute(BlipFourriere, true)
                SetBlipColour(BlipFourriere, 6)
                SetBlipRouteColour(BlipFourriere, 6)
                
                Bulle.create("bulleFourriereRemorquer",vector3(posToDepos.x, posToDepos.y, posToDepos.z+1.5),"bulleGarerVert", true)
                zone.addZone("fourriere_depot_car",
                vector3(posToDepos.x, posToDepos.y, posToDepos.z+1.0),
                nil,
                function()
                    print("CarToRecup[i] --> ",CarToRecup[i], GetVehiclePedIsIn(p:ped(), false))
                    if CarToRecup[i] ~= GetVehiclePedIsIn(p:ped(), false) then
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            -- duration = 5, -- In seconds, default:  4
                            content = "Tu dois étre dans le véhicule en panne pour le déposer !"
                        })
                    else

                        if IsEntityAttached(CarToRecup[i]) then
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                -- duration = 5, -- In seconds, default:  4
                                content = "Tu dois détacher le véhicule avant de le déposer !"
                            })
                        else
                            if NetworkRequestControlOfEntity(GetVehiclePedIsIn(p:ped(), false)) then
                                DeleteEntity(GetVehiclePedIsIn(p:ped(), false))
                            end
                            needWait = false
                            Bulle.remove("bulleFourriereRemorquer")
                            RemoveBlip(BlipFourriere)
                            if withFriend then
                                TriggerServerEvent("core:fourriereUpdateInMission", myFriend, {checkStep = false, needWait = false})
                            end
                        end
                    end
                end,
                true, -- Avoir un marker ou non
                36, -- Id / type du marker
                1.0, -- La taille
                { 0, 255, 0 }, -- RGB
                170,-- Alpha
                4.0
                )
                while needWait do Wait(1000) end
            end
            if host then
                OpenTutoFAInfo("Fourrière", "Dépose ton camion et récupère ton argent")
            else
                OpenTutoFAInfo("Fourrière", "Tu as fini la mission, attend que ton ami dépose le camion pour récupérer ton argent")
            end
            inMission = false
            finish = true
        end

        RegisterNUICallback("MetierFourriere", function(data)
            -- print("Menu --> ",json.encode(data, {indent = true}))
            if data and data.button then
                if data.button == "start" then
                    --if CheckJobLimit() then
                        finish = false
                        inMission = true
                        closeUI()
                        SetCloth()
                        SpawnFlatBed()
                        if withFriend then
                            TriggerServerEvent("core:fourriereStartMission", myFriend, CarToRecup, posToDepos)
                        end
                        StartFourriereJob(true)
                    --end
                elseif data.button == "addPlayer" then
                    closeUI()
                    if data.selected ~= 0 then 
                        local closestPlayer = ChoicePlayersInZone(5.0, false)
                        if closestPlayer == nil then
                            return
                        end
                        local sID = GetPlayerServerId(closestPlayer)
                        if sID ~= nil and myFriend ~= nil then 
                            TriggerServerEvent("core:fourriereInvitePlayer", sID, p:getFirstname(), GetPlayerServerId(PlayerId()))
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


        RegisterNetEvent("core:fourriereUpdateInMission")
        AddEventHandler("core:fourriereUpdateInMission", function(value)
            checkStep = value.checkStep
            needWait = value.needWait
        end)

        RegisterNetEvent("core:fourriereInvitePlayer")
        AddEventHandler("core:fourriereInvitePlayer", function(table)
            closeUI()
            Wait(200)
            local jobConfirmation = ChoiceInput("Souhaitez vous rejoindre l'activité avec " .. table.name .. " ?")
            if jobConfirmation then
                notBoss = true
                myFriend = table.friendLocal
                TriggerServerEvent("core:fourriereAcceptInvite", myFriend, p:getFirstname())
            end
        end)

        RegisterNetEvent("core:fourriereAcceptInvite")
        AddEventHandler("core:fourriereAcceptInvite", function(friendName)
            withFriend = true
            waitInvite = false
            PlayersInJob = {{ name = p:getFirstname(), id = 1 }}
            table.insert(PlayersInJob, { name = friendName, id = 2 })
            SendNUIMessage({
                type = "openWebview",
                name = "MenuJob",
                data = {
                    headerBanner = "https://cdn.sacul.cloud/v2/vision-cdn/dlcavril/banner_fourriere.webp",
                    choice = {
                        label = "Dépaneuse",
                        isOptional = false,
                        choices = {
                            {
                                id = 1,
                                label = 'Dépaneuse',
                                name = "flatbed3",
                                img= "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/flatbed3.webp",
                            }
                        },
                    },
                    participants = PlayersInJob,
                    participantsNumber = 2,
                    callbackName = "MetierFourriere",
                }
            })
        end)

        RegisterNetEvent("core:fourriereAcceptInvite")
        AddEventHandler("core:fourriereAcceptInvite", function(friendName)
            withFriend = true
            waitInvite = false
            PlayersInJob = {{ name = p:getFirstname(), id = 1 }}
            table.insert(PlayersInJob, { name = friendName, id = 2 })
            SendNUIMessage({
                type = "openWebview",
                name = "MenuJob",
                data = {
                    headerBanner = "https://cdn.sacul.cloud/v2/vision-cdn/dlcavril/banner_fourriere.webp",
                    choice = {
                        label = "Dépaneuse",
                        isOptional = false,
                        choices = {
                            {
                                id = 1,
                                label = 'Dépaneuse',
                                name = "flatbed3",
                                img= "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/flatbed3.webp",
                            }
                        },
                    },
                    participants = PlayersInJob,
                    participantsNumber = 2,
                    callbackName = "MetierFourriere",
                }
            })
        end)


        RegisterNetEvent("core:fourriereStartMission")
        AddEventHandler("core:fourriereStartMission", function(car)
            CarToRecup = car
            SetCloth()
            StartFourriereJob(false)
        end)

    end)
end