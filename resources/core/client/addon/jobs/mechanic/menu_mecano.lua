local open = false
local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function deleteflat(entity)
    TriggerEvent('persistent-vehicles/forget-vehicle', entity)
    --removeKeys(GetVehicleNumberPlateText(entity), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(entity))))
    TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(entity))
    DeleteEntity(entity)
    if DoesEntityExist(entity) then
        SetEntityAsMissionEntity(entity, true, true)
        TriggerEvent('persistent-vehicles/forget-vehicle', entity)
        --removeKeys(GetVehicleNumberPlateText(entity), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(entity))))
        TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(entity))
        DeleteEntity(entity)
    end
    if DoesEntityExist(entity) then
        --removeKeys(GetVehicleNumberPlateText(entity), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(entity))))
        TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(entity))
        DeleteObject(entity)
    end
end

local vehiculeService = {
    "flatbed3",
    "slamtruck",
    "towtruck",
    "towtruck2",
    "sadlerrt"
}

function CheckVehiculeServiceInRadius(radius)
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    local vehicles = {}

    for vehicle in EnumerateVehicles() do
        local vehiclePos = GetEntityCoords(vehicle)
        local distance = #(playerPos - vehiclePos)
        if distance <= radius then
            table.insert(vehicles, vehicle)
        end
    end

    local serviceVeh = {}

    for _, vehicle in ipairs(vehicles) do
        for k, v in pairs(vehiculeService) do
            if GetEntityModel(vehicle) == GetHashKey(v) then
                table.insert(serviceVeh, vehicle)
                print("Véhicule de service trouvé. (" .. v .. ")")
            end
        end
    end

    return serviceVeh
end

function EnumerateVehicles()
    return coroutine.wrap(function()
        local handle, vehicle = FindFirstVehicle()
        if not handle or handle == -1 then
            EndFindVehicle(handle)
            return
        end

        local enum = { handle = handle, destructor = EndFindVehicle }
        setmetatable(enum,
            { __gc = function(enum) if enum.destructor and enum.handle then enum.destructor(enum.handle) end end })

        local next = true
        repeat
            coroutine.yield(vehicle)
            next, vehicle = FindNextVehicle(handle)
        until not next

        enum.destructor, enum.handle = nil, nil
        EndFindVehicle(handle)
    end)
end

function LoadMecanoJob()
    shopui = ""
    dictname = ""
    local garagePos = nil
    local MecanoDuty = false
    local posGestion
    local posCoffre
    local posService
    local posCasier
    local posFourriere
    local posPed
    local posSpawn
    local char = nil
    local textChar = ""
    local openRadial = false
    if p:getJob() == "bennys" then
        shopui = "vision"
        dictname = "menu_title_bennys"
        char = "CHAR_CARSITE3"
        textChar = "Benny's"
        posPed = vector4(-230.44616699219, -1318.3414306641, 30.300481796265, 269.8056640625)
        posGestion = vector3(-194.24476623535, -1314.9232177734, 30.300472259521)
        posCoffre = vector3(-192.50886535645, -1321.3864746094, 31.30047416687)
        garagePos = vector3(-206.45794677734, -1323.8568115234, 30.913496017456)
        posCasier = vector3(-194.97541809082, -1336.146484375, 31.300479888916)
        posFourriere = vector3(-174.61442565918, -1289.3253173828, 30.2961063385017)
        posSpawn = vector4(-181.17384338379, -1287.1469726563, 31.296106338501, 174.92324829102)
        mech_spawn = vector3(-178.6449432373, -1324.5291748047, 31.283283233643)
        mech_delete = vector3(-182.35163879395, -1325.2912597656, 31.233097076416)
        spawn4 = vector4(-180.94476318359, -1318.5400390625, 31.296543121338, 2.2975685596466)
        spawn3 = vector3(-180.94476318359, -1318.5400390625, 31.296543121338)
        livery_flat = 1
        livery_slam = 10
        livery_sadlerrt = 2
        imgName = "Bennys"
        header = "header_bennys.webp"
    elseif p:getJob() == "sunshine" then
        shopui = "vision"
        dictname = "sunshine"
        char = "SUNSHINE"
        textChar = "Sunshine Garage"
        posPed = vector4(915.9246, -2100.032, 29.4595, 125.9822)
        garagePos = vector3(892.6656, -2102.468, 33.8885)
        posCasier = vector3(882.9964, -2100.725, 29.4594)
        posCoffre = vector3(886.4254, -2097.374, 34.8886)
        posGestion = vector3(892.6656, -2102.468, 33.8885)
        posFourriere = vector3(866.9704, -2145.061, 29.5704)
        posSpawn = vector4(862.3558, -2137.480, 29.5148, 351.9650)
        mech_spawn = vector3(875.5851, -2100.379, 29.4796)
        mech_delete = vector3(862.0167, -2145.642, 30.4642)
        spawn4 = vector4(879.5482, -2109.020, 29.4594, 259.2134)
        spawn3 = vector3(879.5482, -2109.020, 29.4594)
        livery_flat = 2
        livery_slam = 11
        livery_sadlerrt = 1
        imgName = "SunshineGarage"
        header = "header_sunshine.webp"
    elseif p:getJob() == "cayogarage" then
        shopui = "vision"
        dictname = "sunshine"
        char = "CAYOGARAGE"
        textChar = "El Rey Motors"
        posPed = vector4(915.9246, -2100.032, 29.4595, 125.9822)
        garagePos = vector3(5125.955078125, -5134.5141601563, 1.2138636112213)
        posCasier = vector3(5134.4184570313, -5131.1967773438, 1.2138628959656)
        posCoffre = vector3(886.4254, -2097.374, 34.8886)
        posGestion = vector3(5134.5859375, -5139.4428710938, 1.2138648033142)
        posFourriere = vector3(5136.7924804688, -5135.4711914063, 1.1345272064209)
        posSpawn = vector4(5122.345703125, -5140.306640625, 1.1854507923126, 180.099)
        mech_spawn = vector3(5123.2822265625, -5145.3911132813, 1.2888531684875)
        mech_delete = vector3(5141.1142578125, -5141.1772460938, 1.1722617149353)
        spawn4 = vector4(5139.91796875, -5129.8500976563, 1.1328353881836, 353.78854370117)
        spawn3 = vector3(5130.5478515625, -5136.572265625, 1.2138652801514)
        livery_flat = 2
        livery_slam = 11
        livery_sadlerrt = 1
        imgName = "SunshineGarage"
        header = "header_sunshine.webp"
    elseif p:getJob() == "hayes" then -- pos à mettre
        shopui = "vision"
        dictname = "hayes"
        char = "HAYES"
        textChar = "Hayes Auto"
        posPed = vector4(-1406.3979492188, -444.482421875, 34.909706115723, 121.60081481934)
        garagePos = vector3(-1421.4741210938, -446.16607666016, 34.909706115723)
        posCasier = vector3(-1424.841796875, -457.35000610352, 34.90970993042)
        posCoffre = vector3(-1429.2263183594, -457.81723022461, 35.90970993042)
        posGestion = vector3(-1427.5712890625, -459.77090454102, 34.90970993042)
        posFourriere = vector3(-1412.6877441406, -431.04446411133, 35.183479309082)
        posSpawn = vector4(-1415.9300537109, -432.15802001953, 35.030872344971, 123.54905700684)
        mech_spawn = vector3(-1411.6405029297, -436.75045776367, 34.90970993042)
        mech_delete = vector3(-1397.6047363281, -461.36920166016, 33.479774475098)
        spawn4 = vector4(-1416.0408935547, -430.83834838867, 35.032279968262, 30.937286376953)
        spawn3 = vector3(-1416.0408935547, -430.83834838867, 35.032279968262)
        livery_flat = 2
        livery_slam = 11
        livery_sadlerrt = 1
        imgName = "hayes"
        header = "header_hayes.webp"
    elseif p:getJob() == "beekers" then -- pos à mettre
        shopui = "vision"
        dictname = "beekers"
        char = "BEEKERS"
        textChar = "Beekers Garage"
        posPed = vector4(115.36325836182, 6625.7685546875, 30.787309646606, 135.15690612793)
        garagePos = vector3(161.27337646484, 6378.4702148438, 30.273826599121)
        posCasier = vector3(176.15620422363, 6385.0034179688, 30.273832321167)
        posCoffre = vector3(173.28681945801, 6391.9130859375, 31.273851394653)
        posGestion = vector3(178.49256896973, 6380.9638671875, 30.273836135864)
        posFourriere = vector3(122.35676574707, 6405.94921875, 30.361400604248)
        posSpawn = vector4(123.49741363525, 6415.091796875, 30.341638565063, 228.72998046875)
        mech_spawn = vector3(173.58, 6402.76, 30.31)
        mech_delete = vector3(186.15, 6395.79, 30.38)
        spawn4 = vector4(186.15, 6395.79, 30.38, 299.51)
        spawn3 = vector3(186.15, 6395.79, 30.38)
        livery_flat = 2
        livery_slam = 11
        livery_sadlerrt = 1
        imgName = "beekers"
        header = "header_beekers.webp"
    elseif p:getJob() == "harmony" then
        shopui = "vision"
        dictname = "harmony"
        char = "HARMONY"
        textChar = "Harmony Repair"
        posPed = vector4(2519.0693359375, 2611.5014648438, 36.945369720459, 185.35195922852)   --vector4(1169.5339355469, 2634.4143066406, 36.809173583984, 274.71688842773)
        garagePos = vector3(2525.3732910156, 2620.0224609375, 36.94535446167)                  --vector3(1178.6198730469, 2644.8701171875, 36.7939453125)
        posCasier = vector3(2537.4970703125, 2641.6779785156, 36.945365905762)                 --vector3(1188.7867431641, 2640.9106445313, 37.401924133301)
        posCoffre = vector3(2529.7221679688, 2641.201171875, 37.945381164551)                  --vector3(1187.3580322266, 2635.8688964844, 37.401969909668)
        posGestion = vector3(2532.9204101563, 2639.5051269531, 36.945369720459)                --vector3(1186.8464355469, 2637.3344726563, 37.401977539063)
        posFourriere = vector3(2519.0795898438, 2611.4501953125, 36.945369720459)              --vector3(1166.390625, 2634.6975097656, 37.044261932373)
        posSpawn = vector4(2526.0454101563, 2607.0603027344, 36.945369720459, 272.50567626953) --vector4(1162.8566894531, 2638.8474121094, 37.057376861572, 359.53430175781)
        mech_spawn = vector3(2526.0454101563, 2607.0603027344, 36.945369720459)                --vector3(1169.7006835938, 2644.533203125, 36.809757232666)
        mech_delete = vector3(2520.1950683594, 2601.7329101563, 36.94535446167)                --vector3(1167.2235107422, 2638.3747558594, 36.82271194458)
        spawn4 = vector4(2524.0625, 2604.7153320313, 36.94535446167, 266.25134277344)          --vector4(1165.1669921875, 2639.0708007813, 36.990936279297, 353.92199707031)
        spawn3 = vector3(2524.0625, 2604.7153320313, 36.94535446167)                           --vector3(1165.1669921875, 2639.0708007813, 36.990936279297)
        livery_flat = 3
        livery_slam = 12
        livery_sadlerrt = 3
        imgName = "HarmonyRepair"
        header = "header_harmonyrepair.webp"
    elseif p:getJob() == "ocean" then
        shopui = "vision"
        dictname = "ocean"
        char = "OCEAN"
        textChar = "Auto Exotic"
        posPed = vector4(535.31402587891, -134.96885681152, 58.792541503906, 267.86282348633)
        garagePos = vector3(539.94818115234, -153.94497680664, 53.485961914062)
        posCasier = vector3(539.14916992188, -167.45088195801, 53.508571624756)
        posCoffre = vector3(542.92211914062, -199.3924407959, 53.508701324463)
        posGestion = vector3(559.36505126953, -199.19352722168, 57.152690887451)
        posFourriere = vector3(543.85, -207.49, 52.97)
        posSpawn = vector4(541.39935302734, -136.43165588379, 58.409450531006, 182.5658416748)
        mech_spawn = vector3(545.21533203125, -166.2015838623, 53.508647918701)
        mech_delete = vector3(539.94818115234, -153.94497680664, 53.485961914062)
        spawn4 = vector4(539.94818115234, -153.94497680664, 53.485961914062, 181.19786071777)
        spawn3 = vector3(539.94818115234, -153.94497680664, 53.485961914062)
        livery_flat = 2
        livery_slam = 0
        livery_sadlerrt = 0
        imgName = "SunshineGarage"
        header = "header_ocean.webp"
    end

    zone.addZone(
        "casier_mecano" .. p:getJob(),
        posCasier + vector3(0.0, 0.0, 1.0),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les casiers",
        function()
            OpenmecanoCasier() --TODO: fini le menu society
        end, false,
        27,
        1.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleCasiers"
    )

    local inChoice = false
    local selectedPlayer = nil

    local function StartChoiceFourriere(players)
        selectedPlayer = nil

        -- New notif
        exports['aHUD']:toggleHotkeys(true)

        local timer = GetGameTimer() + 10000
        while inChoice do
            if next(players) then
                local mCoors = GetEntityCoords(GetPlayerPed(players[1]))
                DrawMarker(20, mCoors.x, mCoors.y, mCoors.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255
                    ,
                    255, 120, 0, 1, 2, 0, nil, nil, 0)
                if GetGameTimer() > timer then
                    -- ShowNotification("~r~Le délai est dépassé")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Le délai a été dépassé"
                    })

                    inChoice = false
                    exports['aHUD']:toggleHotkeys(false)
                    return
                elseif IsControlJustPressed(0, 51) then -- E
                    selectedPlayer = players[1]
                    inChoice = false
                    exports['aHUD']:toggleHotkeys(false)
                    return
                elseif IsControlJustPressed(0, 182) then -- L
                    table.remove(players, 1)
                    if next(players) then
                        timer = GetGameTimer() + 10000
                    end
                elseif IsControlJustPressed(0, 73) then -- X
                    -- ShowNotification("~r~Vous avez annulé")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'JAUNE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous avez ~s annulé"
                    })

                    exports['aHUD']:toggleHotkeys(false)
                    selectedPlayer = nil
                    inChoice = false
                    return
                end
            else
                -- ShowNotification("~r~Il n'y a personne autour de vous")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Il n'y a personne autour de vous"
                })

                selectedPlayer = nil
                exports['aHUD']:toggleHotkeys(false)
                inChoice = false
                return
            end
            Wait(0)
        end
    end

    zone.addZone(
        "fourriere" .. p:getJob(),
        posFourriere + vector3(0.0, 0.0, 1.0),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir la fourrière",
        function()
            local player = GetAllPlayersInArea(p:pos(), 3.0)
            for k, v in pairs(player) do
                if v == PlayerId() then
                    table.remove(player, k)
                end
            end
            if player ~= nil then
                if next(player) then
                    inChoice = true
                    StartChoiceFourriere(player)
                    if selectedPlayer ~= nil then
                        OpenMenuFourriere(posSpawn, GetPlayerServerId(selectedPlayer)) --TODO: fini le menu society
                    end
                else
                    -- ShowNotification("~r~Il n'y a personne autour de vous")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Il n'y a personne autour de vous"
                    })
                end
            else
                -- ShowNotification("~r~Il n'y a personne autour de vous")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Il n'y a personne autour de vous"
                })
            end
        end,
        false,            -- Avoir un marker ou non
        -1,               -- Id / type du marker
        0.8,              -- La taille
        { 235, 192, 15 }, -- RGB
        170,              -- Alpha
        3,                -- Interact Dist
        true,
        "bulleFourriere"
    )


    local casierOpen = false
    function OpenmecanoCasier()
        if not casierOpen then
            casierOpen = true

            CreateThread(function()
                while casierOpen do
                    Wait(0)
                    DisableControlAction(0, 1, casierOpen)
                    DisableControlAction(0, 2, casierOpen)
                    DisableControlAction(0, 142, casierOpen)
                    DisableControlAction(0, 18, casierOpen)
                    DisableControlAction(0, 322, casierOpen)
                    DisableControlAction(0, 106, casierOpen)
                    DisableControlAction(0, 24, true)  -- disable attack
                    DisableControlAction(0, 25, true)  -- disable aim
                    DisableControlAction(0, 263, true) -- disable melee
                    DisableControlAction(0, 264, true) -- disable melee
                    DisableControlAction(0, 257, true) -- disable melee
                    DisableControlAction(0, 140, true) -- disable melee
                    DisableControlAction(0, 141, true) -- disable melee
                    DisableControlAction(0, 142, true) -- disable melee
                    DisableControlAction(0, 143, true) -- disable melee
                end
            end)
            SetNuiFocusKeepInput(true)
            SetNuiFocus(true, true)
            Citizen.CreateThread(function()
                SendNUIMessage({
                    type = "openWebview",
                    name = "Casiers",
                    data = {
                        count = 60,
                    },
                })
            end)
        else
            casierOpen = false
            SetNuiFocusKeepInput(false)
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 142, true)
            EnableControlAction(0, 18, true)
            EnableControlAction(0, 322, true)
            EnableControlAction(0, 106, true)
            SetNuiFocus(false, false)
            SendNuiMessage(json.encode({
                type = 'closeWebview',
            }))
            return
        end
    end

    RegisterNUICallback("focusOut", function(data, cb)
        if casierOpen then
            casierOpen = false
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 142, true)
            EnableControlAction(0, 18, true)
            EnableControlAction(0, 322, true)
            EnableControlAction(0, 106, true)
            openRadarProperly()
        end
        cb({})
    end)

    RegisterNUICallback("casier__callback", function(data)
        OpenInventoryCasier(p:getJob(), data.numero)
    end)
    ---zone
    zone.addZone(
        "society_mecano",
        posGestion + vector3(0.0, 0.0, 1.0),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les actions d'entreprise",
        function()
            OpenSocietyMenu() --TODO: fini le menu society
        end,
        false,                -- Avoir un marker ou non
        -1,                   -- Id / type du marker
        0.6,                  -- La taille
        { 0, 0, 0 },          -- RGB
        0,                    -- Alpha
        1.5,
        true,
        "bulleGestion"
    )

    zone.addZone(
        "coffre_mecano",
        posCoffre,
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le coffre de l'entreprise",
        function()
            OpenInventorySocietyMenu() --TODO: fini le menu society
        end,
        false,                         -- Avoir un marker ou non
        -1,                            -- Id / type du marker
        0.6,                           -- La taille
        { 0, 0, 0 },                   -- RGB
        0,                             -- Alpha
        1.5,
        true,
        "bulleCoffre"
    )

    zone.addZone(
        "mech_delete",
        mech_delete,
        "~INPUT_CONTEXT~ Ranger le véhicule",
        function()
            if IsPedInAnyVehicle(p:ped(), false) then
                if GetVehicleBodyHealth(p:currentVeh()) / 10 >= 80 or
                    GetVehicleEngineHealth(p:currentVeh()) / 10 >= 80 then
                    local veh = GetVehiclePedIsIn(p:ped(), false)
                    TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                    --removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                    TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                    DeleteEntity(veh)
                else
                    -- ShowNotification("~r~Votre véhicule est trop abimé")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Votre véhicule est trop abimé"
                    })
                end
            end
        end,
        false,       -- Avoir un marker ou non
        -1,          -- Id / type du marker
        0.6,         -- La taille
        { 0, 0, 0 }, -- RGB
        0,           -- Alpha
        1.5,
        true,
        "bulleGarage"
    )

    zone.addZone(
        "mech_spawn",
        mech_spawn + vector3(0.0, 0.0, 1.0),
        "~INPUT_CONTEXT~ Sortir le véhicule",
        function()
            if MecanoDuty then
                OpenMenuVehMecano() --TODO: fini le menu society
            else
                -- ShowNotification("~r~Vous n'êtes pas en service")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous n'êtes ~s pas en service"
                })
            end
        end,
        false,       -- Avoir un marker ou non
        -1,          -- Id / type du marker
        0.6,         -- La taille
        { 0, 0, 0 }, -- RGB
        0,           -- Alpha
        1.5,
        true,
        "bulleGarage"
    )


    local listVeh = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/' .. header,
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
        headerIconName = 'VEHICULES',
        callbackName = 'vehMenuMecano',
        elements = {
            {
                id = 1,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/' .. imgName .. '/flatbed3.webp',
                label = 'Flatbed',
                name = "flatbed3"
            },
            {
                id = 2,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/' .. imgName .. '/slamtruck.webp',
                label = 'Slamtruck',
                name = "slamtruck"
            },
            {
                id = 3,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/' .. imgName .. '/towtruck.webp',
                label = 'Tow Truck',
                name = "towtruck"
            },
            {
                id = 4,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/' .. imgName .. '/towtruck2.webp',
                label = 'Tow Truck Rouillé',
                name = "towtruck2"
            },
            {
                id = 5,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/' .. imgName .. '/sadlerrt.webp',
                label = 'Sadler RT',
                name = "sadlerrt"
            },
        }
    }
    function OpenMenuVehMecano()
        forceHideRadar()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listVeh
        }))
    end

    function MechanicDuty()
        closeUI()
        openRadial = false
        if MecanoDuty then
            TriggerServerEvent('core:DutyOff', pJob)
            -- ShowNotification("Vous avez ~r~quitté~s~ votre service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s quitté ~c votre service"
            })

            MecanoDuty = false
            Wait(5000)
        else
            TriggerServerEvent('core:DutyOn', pJob)
            -- ShowNotification("Vous avez ~g~pris~s~ votre service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s pris ~c votre service"
            })

            MecanoDuty = true
            Wait(5000)
        end
    end

    function RepareVehMoteur()
        if MecanoDuty then
            openRadial = false
            closeUI()
            local closestVeh, closestDist = GetClosestVehicle(p:pos())
            if closestDist <= 5 then
                local GetEngine = GetVehicleEngineHealth(closestVeh)
                if #(p:pos() - garagePos) <= 100.0 or #CheckVehiculeServiceInRadius(30) > 0 then
                    if #(p:pos() - GetWorldPositionOfEntityBone(closestVeh, GetEntityBoneIndexByName(closestVeh, "overheat"))
                            + vector3(0.0, 0.0, 1.0)) < 5.0 or GetEntityBoneIndexByName(closestVeh, "overheat") == -1 then
                        local time = 1000 - GetVehicleEngineHealth(closestVeh)
                        if GetVehicleEngineHealth(closestVeh) < 950.0 then
                            p:PlayAnim("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "fixing_a_ped", 174)

                            TaskStartScenarioInPlace(p:ped(), 'PROP_HUMAN_BUM_BIN', -1, true)

                            SendNuiMessage(json.encode({
                                type = 'openWebview',
                                name = 'Progressbar',
                                data = {
                                    text = "Réparation en cours...",
                                    time = 10,
                                }
                            }))
                            Modules.UI.RealWait(10000)
                            --[[ ShowAdvancedNotification(textChar, "Information",
                                "Réparation terminée.", char, char) ]]

                            -- New notif
                            exports['vNotif']:createNotification({
                                type = 'JAUNE',
                                -- duration = 5, -- In seconds, default:  4
                                content = "Réparation ~s terminée."
                            })

                            ClearPedTasksImmediately(p:ped())
                            SetVehicleEngineHealth(closestVeh, 1000.0)
                        else
                            --[[ ShowAdvancedNotification(textChar, "Information",
                                "Le véhicule est en bon état.", char, char) ]]

                            -- New notif
                            exports['vNotif']:createNotification({
                                type = 'JAUNE',
                                -- duration = 5, -- In seconds, default:  4
                                content = "Le véhicule est en ~s bon état."
                            })
                        end
                    end
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Vous devez être à proximité du garage ou d'une véhicule de service pour réparer."
                    })
                end
            end
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function RepareCarosserie()
        if MecanoDuty then
            openRadial = false
            closeUI()
            if #(p:pos() - garagePos) <= 100.0 or #CheckVehiculeServiceInRadius(30) > 0 then
                local closestVeh, closestDist = GetClosestVehicle(p:pos())
                if closestDist <= 3 then
                    local GetEngine = GetVehicleEngineHealth(closestVeh)
                    local time = 1000 - GetVehicleBodyHealth(closestVeh)

                    RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
                    while not HasAnimDictLoaded("anim@amb@clubhouse@tutorial@bkr_tut_ig3@") do
                        Wait(1)
                    end
                    TaskPlayAnim(p:ped(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0,
                        -8.0, -1, 1, 0, false,
                        false, false)
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'Progressbar',
                        data = {
                            text = "Réparation en cours...",
                            time = 10,
                        }
                    }))
                    RemoveAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
                    Modules.UI.RealWait(10000)
                    --[[ ShowAdvancedNotification(textChar, "Information", "Réparation terminée."
                        , char, char) ]]

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'JAUNE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Réparation ~s terminée."
                    })

                    ClearPedTasksImmediately(p:ped())
                    SetVehicleBodyHealth(closestVeh, 1000.0)
                    SetVehicleFixed(closestVeh)
                    SetVehicleDeformationFixed(closestVeh)
                    SetVehicleEngineHealth(closestVeh, GetEngine)
                    SetVehicleUndriveable(closestVeh, false)
                end
            else
                -- ShowNotification("Vous devez être à proximité du garage.")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Vous devez être à proximité du garage ou d'une véhicule de service pour réparer."
                })
            end
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function CleanVeh()
        if MecanoDuty then
            openRadial = false
            closeUI()
            local closestVeh, closestDist = GetClosestVehicle(p:pos())
            if closestDist <= 3 then
                TaskStartScenarioInPlace(p:ped(), 'WORLD_HUMAN_MAID_CLEAN', -1, true)
                SendNuiMessage(json.encode({
                    type = 'openWebview',
                    name = 'Progressbar',
                    data = {
                        text = "Nettoyage en cours...",
                        time = 8,
                    }
                }))
                Modules.UI.RealWait(8000)

                SetVehicleDirtLevel(closestVeh, 0)
                ClearPedTasksImmediately(p:ped())
                --[[ ShowAdvancedNotification(textChar, "Information", "Nettoyage terminé.", char
                    , char) ]]

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Nettoyage ~s terminée."
                })
            end
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function FactureMecano()
        if MecanoDuty then
            openRadial = false
            closeUI()
            TriggerEvent("nuiPapier:client:startCreation", 2)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function CreateAdvert()
        if MecanoDuty then
            openRadial = false
            closeUI()
            CreateJobAnnonce()
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function OpenMenuMecano()
        if not openRadial then
            openRadial = true
            CreateThread(function()
                while openRadial do
                    Wait(0)
                    DisableControlAction(0, 1, openRadial)
                    DisableControlAction(0, 2, openRadial)
                    DisableControlAction(0, 142, openRadial)
                    DisableControlAction(0, 18, openRadial)
                    DisableControlAction(0, 322, openRadial)
                    DisableControlAction(0, 106, openRadial)
                end
            end)
            SetNuiFocusKeepInput(true)
            SetNuiFocus(true, true)
            Wait(200)
            CreateThread(function()
                function SubRadial()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = {
                            elements = {
                                {
                                    name = "NETTOYAGE",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/sponge.svg",
                                    action = "CleanVeh"
                                },
                                {
                                    name = "CARROSSERIE",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/car.svg",
                                    action = "RepareCarosserie"
                                },
                                {
                                    name = "RETOUR",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                    action = "MainRadial"
                                },
                                {
                                    name = "MOTEUR",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/engine.svg",
                                    action = "RepareVehMoteur"
                                }
                            },
                            title = "REPARER"
                        }
                    }));
                end

                function MainRadial()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = {
                            elements = {
                                {
                                    name = "ANNONCE",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/megaphone.svg",
                                    action = "CreateAdvert"
                                },
                                {
                                    name = "FACTURE",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/billet.svg",
                                    action = "FactureMecano"
                                },
                                {
                                    name = "PRISE DE SERVICE",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/checkmark.svg",
                                    action = "MechanicDuty"
                                },
                                {
                                    name = "COMMANDES",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/paper.svg",
                                    action = "StockMenu"
                                },
                                {
                                    name = "REPARER",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/repair.svg",
                                    action = "SubRadial"
                                },
                            },
                            title = string.upper(textChar)
                        }
                    }));
                end

                MainRadial()
            end)
        else
            openRadial = false
            SetNuiFocusKeepInput(false)
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 142, true)
            EnableControlAction(0, 18, true)
            EnableControlAction(0, 322, true)
            EnableControlAction(0, 106, true)
            SetNuiFocus(false, false)
            SendNuiMessage(json.encode({
                type = 'closeWebview',
            }))
            return
        end
    end

    function StockMenu()
        if MecanoDuty then
            openRadial = false
            closeUI()
            handleOpenCommandMenu()
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function InfoVeh(entity)
        local textChar = "Mecano"
        local char = "MECANO"
        ShowAdvancedNotification(textChar,
            "Véhicule : " .. GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(entity))),
            "\nPlaque~b~ : " .. GetVehicleNumberPlateText(entity)
            .. "\n~s~Carrosserie : ~b~" ..
            math.round(GetVehicleBodyHealth(entity) / 10, 2) .. "~s~%"
            .. "\nÉtat moteur : ~b~" .. math.round(GetVehicleEngineHealth(entity) / 10, 2) .. "~s~%"
            .. "\nEssence : ~o~" .. math.round(GetVehicleFuelLevel(entity), 2) .. "~s~%", char, char)

        -- show advanced notification with engine, brakes, transmission, turbo, suspension stats
        local moteurstats = GetVehicleMod(entity, 11)
        if moteurstats == -1 then
            moteurstats = "Non installé"
        else
            moteurstats = "Niveau " .. moteurstats
        end
        local freinstats = GetVehicleMod(entity, 12)
        if freinstats == -1 then
            freinstats = "Non installé"
        else
            freinstats = "Niveau " .. freinstats
        end
        local transmissionstats = GetVehicleMod(entity, 13)
        if transmissionstats == -1 then
            transmissionstats = "Non installé"
        else
            transmissionstats = "Niveau " .. transmissionstats
        end
        local suspensionstats = GetVehicleMod(entity, 15)
        if suspensionstats == -1 then
            suspensionstats = "Non installé"
        else
            suspensionstats = "Niveau " .. suspensionstats
        end
        local turbostats = IsToggleModOn(entity, 18)
        if not turbostats then
            turbostats = "Non installé"
        else
            turbostats = "Installé"
        end

        ShowAdvancedNotification(textChar,
            "Véhicule : " .. GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(entity))),
            "~s~Moteur : ~b~ " ..
            moteurstats ..
            "~s~\nFreins : ~b~ " ..
            freinstats ..
            "~s~\nTransmission : ~b~ " ..
            transmissionstats ..
            "~s~\nSuspension : ~b~ " ..
            suspensionstats ..
            "~s~\nTurbo : ~b~" ..
            turbostats, char, char)
    end

    --magasin

    local open = false
    local market_main = RageUI.CreateMenu("", "Fournisseur", 0.0, 0.0, shopui, dictname)
    market_main.Closed = function()
        open = false
    end

    local marketCfg = {
        {
            item = "weapon_petrolcan",
            price = 0,
            index = 1,
        },
        {
            item = "spray",
            price = 0,
            index = 1,
        },
        {
            item = "repairkit",
            price = 100,
            index = 1,
        },
        {
            item = "cleankit",
            price = 40,
            index = 1,
        },
        {
            item = "sangle",
            price = 100,
            index = 1,
        },
    }
    local marketItem = {}



    for i = 1, 10 do
        table.insert(marketItem, i)
    end

    function OpenMechanicSell()
        if open then
            open = false
            RageUI.Visible(market_main, false)
            return
        else
            open = true
            RageUI.Visible(market_main, true)

            CreateThread(function()
                while open do
                    RageUI.IsVisible(market_main, function()
                        for k, v in pairs(marketCfg) do
                            RageUI.List(GetItemLabel(v.item), marketItem, v.index, nil,
                                { RightLabel = "~g~" .. v.price .. "$" }, true, {
                                    onListChange = function(Index, Item)
                                        v.index = Index
                                    end,
                                    onSelected = function()
                                        TriggerSecurEvent("core:marketBuyItem", v.item, v.price, v.index)
                                    end
                                })
                        end
                    end)
                    Wait(1)
                end
            end)
        end
    end

    RegisterJobMenu(OpenMenuMecano)

    RegisterNUICallback("focusOut", function(data, cb)
        if openRadial then
            openRadial = false
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 142, true)
            EnableControlAction(0, 18, true)
            EnableControlAction(0, 322, true)
            EnableControlAction(0, 106, true)
        end
        cb({})
    end)
    --Event
end

function UnloadMechanicJob()
    zone.removeZone("coffre_mecano")
    zone.removeZone("society_mecano")
    zone.removeZone("casier_mecano")
    zone.removeZone("item_mecano")
    zone.removeZone("mech_spawn")
    zone.removeZone("mech_delete")
    zone.removeZone("service_mecano")
end

RegisterNUICallback("vehMenuMecano", function(data, cb)
    if vehicle.IsSpawnPointClear(spawn3, 3.0) then
        if DoesEntityExist(vehs) then
            TriggerEvent('persistent-vehicles/forget-vehicle', vehs)
            --removeKeys(GetVehicleNumberPlateText(vehs), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs))))
            TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehs))
            DeleteEntity(vehs)
        end
        vehs = vehicle.create(data.name,
            spawn4,
            {})

        local plate = vehicle.getProps(vehs).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
        --createKeys(plate, model)

        if data.name == "flatbed3" then
            SetVehicleMod(vehs, 48, livery_flat)
            SetVehicleLivery(vehs, livery_flat)
        elseif data.name == "slamtruck" then
            SetVehicleMod(vehs, 48, livery_slam)
            SetVehicleLivery(vehs, livery_slam)
        elseif data.name == "sadlerrt" then
            SetVehicleMod(vehs, 48, livery_sadlerrt)
            SetVehicleLivery(vehs, livery_sadlerrt)
        end
    else
        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Il n'y a ~s pas de place ~c pour le véhicule"
        })
    end
end)

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7mecano ^3loaded")
end)
