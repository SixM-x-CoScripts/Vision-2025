local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

CreateThread(function()
    while zone == nil do Wait(1) end

    local pedsData = {
        { model = "s_m_y_fireman_01", position = vector3(-1032.45, -1388.21, 3.97), heading = 343.84, scenario = "WORLD_HUMAN_CLIPBOARD" }, -- PNJ Véhicule
        { model = "s_m_y_fireman_01", position = vector3(-1040.23, -1432.73, 8.56), heading = 164.14, scenario = "WORLD_HUMAN_CLIPBOARD" }, -- PNJ Hélico
    }

    for _, data in ipairs(pedsData) do
        local ped = entity:CreatePedLocal(data.model, data.position, data.heading)
        ped:setFreeze(true)
        if data.scenario then
            TaskStartScenarioInPlace(ped.id, data.scenario, -1, true)
        end
        SetEntityInvincible(ped.id, true)
        SetEntityAsMissionEntity(ped.id, 0, 0)
        SetBlockingOfNonTemporaryEvents(ped.id, true)
    end
end)

local casierPos = vector3(-1028.27, -1364.58, 4.97)
local coffrePos = vector3(-1030.22, -1414.5, 4.05)

local spawnVehPos = vector4(-1052.64, -1379.39, 4.08, 74.2)
local garageVehPos = vector3(-1032.32, -1387.52, 4.97)
local customVehPos = vector3(-1037.42, -1325.59, 4.14)
local deleteVehPos = vector3(-1055.19, -1442.72, 4.96)
local vestiairePos = vector3(-1036.57, -1391.58, 4.97)
local armureriePos = vector3(-1024.7, -1340.18, 4.97)
local jobGestionPos = vector3(-1055.47, -1432.13, 4.97)

local garageHeliPos = vector3(-1041.15, -1432.79, 8.55)
local spawnHeliPos = vector4(-1052.79, -1437.26, 8.06, 347.69)
local deleteHeliPos = vector3(-1052.79, -1437.26, 8.06)

local garageBoatPos = vector3(-1004.96, -1399.27, 0.6)
local spawnBoatPos = vector4(-997.85, -1403.0, -0.88, 19.28)
local deleteBoatPos = vector3(-997.85, -1403.0, -0.88)


lsfdDuty = false

function LoadLsfdJob()
    print("Loading")

    local vehicleOut = nil
    local currentVeh = nil

    zone.addZone(
        "society_lsfd_custom",
        customVehPos,
        "Appuyer sur ~INPUT_CONTEXT~ pour éditer votre vehicule",
        function()
            local veh = p:currentVeh()
            if GetVehicleClass(veh) == 18 then
                extraVeh(veh)
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    duration = 5, -- In seconds, default:  4
                    content = "Ceci n'est ~s pas un véhicule de fonction"
                })
            end
        end,
        true,
        39,             -- Id / type du marker
        0.5,            -- La taille
        { 203, 75, 0 }, -- RGB
        170             -- Alpha
    )

    zone.addZone("lsfd_vestiaire", vestiairePos, "Appuyer sur ~INPUT_CONTEXT~ pour prendre une tenue",
        function()
            LoadLSFDVestiaire()
        end, false,
        27,
        0.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleVetement"
    )

    zone.addZone("lsfd_armory", armureriePos,
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir l'armurerie ",
        function()
            OpenLSFDITEMMenu()
        end,
        true,             -- Avoir un marker ou non
        27,               -- Id / type du marker
        0.6,              -- La taille
        { 51, 204, 255 }, -- RGB
        170,              -- Alpha
        1.5,              -- Interact dist
        true,
        "bulleArmurerie"
    )

    local items = {
        headerImage = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Banners/LSFD.webp",
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Banners/icon.webp',
        headerIconName = 'CATALOGUE',
        callbackName = 'armoryTakeLSFD',
        showTurnAroundButtons = false,
        multipleSelection = true,
        elements = {
            {
                id = 1,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Jumelles.webp",
                price = 0,
                name = "jumelle",
                label = "Jumelles",
            },
            {
                id = 2,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lsfdkev.webp",
                price = 100,
                name = "lsfdkev",
                label = "LSFD - kevlar Jaune",
            },
            {
                id = 3,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lsfdkev2.webp",
                price = 100,
                name = "lsfdkev2",
                label = "LSFD - kevlar Rouge",
            },
            {
                id = 4,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lsfdkev3.webp",
                price = 100,
                name = "lsfdkev3",
                label = "LSFD - Gilet",
            },
			{
                id = 5,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lsfdkev4.webp",
                price = 100,
                name = "lsfdkev4",
                label = "LSFD - Gilet TAC",
            },
			{
                id = 6,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lsfdkev5.webp",
                price = 100,
                name = "lsfdkev5",
                label = "LSFD - Gilet ARSON",
            },
            {
                id = 7,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lsfdradio.webp",
                price = 100,
                name = "lsfdradio",
                label = "LSFD - Radio",
            },
			{
				price = 0,
				id = 8,
				image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/tabletmdt.webp",
				name = "tabletmdt",
				label = "Tablette MDT"
			}
        }
    }

    function OpenLSFDITEMMenu()
        FreezeEntityPosition(PlayerPedId(), true)
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogueAchat',
            data = items
        }));

        RegisterNUICallback("focusOut", function(data, cb)
            TriggerScreenblurFadeOut(0.5)
            openRadarProperly()
            RenderScriptCams(false, false, 0, 1, 0)
            DestroyCam(cam, false)
            FreezeEntityPosition(PlayerPedId(), false)
        end)
    end

    zone.addZone("lsfd_garage_delete", deleteVehPos,
        "Appuyer sur ~INPUT_CONTEXT~ pour rentrer dans le garage", function()
            if IsPedInAnyVehicle(p:ped(), false) then
                local veh = GetVehiclePedIsIn(p:ped(), false)
                TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                -- removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                DeleteEntity(veh)
            end
        end,
        false,
        36,
        0.5,
        { 255, 0, 0 },
        255,
        2.0,
        true,
        "bulleGarage"
    )

    zone.addZone("lsfd_garage_vehicle", garageVehPos,
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir la liste des véhicules", function()
            openGarageMenu()
            forceHideRadar()
        end, false,
        25,               -- Id / type du marker
        0.6,              -- La taille
        { 51, 204, 255 }, -- RGB
        170,
        1.5,
        true,
        "bulleGarage"
    )

    zone.addZone("society_lsfd", jobGestionPos,
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les actions d'entreprise", function()
            OpenSocietyMenu() -- TODO: fini le menu society
        end,
        false,
        25,               -- Id / type du marker
        0.6,              -- La taille
        { 51, 204, 255 }, -- RGB
        170,
        1.5,
        true,
        "bulleGestion"
    )
    zone.addZone("stockage_lsfd", coffrePos,
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le stockage lsfd", function()
            OpenInventorySocietyMenu() -- TODO: fini le menu society
        end, false, 25,                -- Id / type du marker
        0.6,                           -- La taille
        { 51, 204, 255 },              -- RGB
        170,
        2.0,
        true,
        "bulleCoffre"
    )
    zone.addZone("casier_lsfd", casierPos,
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les casiers", function()
            OpenlsfdCasier() -- TODO: fini le menu society
        end, false, 25,      -- Id / type du marker
        0.6,                 -- La taille
        { 51, 204, 255 },    -- RGB
        170,
        2.0,
        true,
        "bulleCasiers"
    )

    -- DEV
    local tenueH = {
        ['tshirt_1'] = 229,
        ['tshirt_2'] = 0,
        ['torso_1'] = 530,
        ['torso_2'] = 1,
        ['arms'] = 11,
        ['arms_2'] = 0,
        ['pants_1'] = 166,
        ['pants_2'] = 1,
        ['shoes_1'] = 24,
        ['shoes_2'] = 0,
        ['bproof_1'] = 0,
        ['bproof_2'] = 0,
        ['helmet_1'] = -1,
        ['helmet_2'] = 0,
        ['bags_1'] = 168,
        ['bags_2'] = 6,
    }
    local tenueF = {
        ['tshirt_1'] = 265,
        ['tshirt_2'] = 0,
        ['torso_1'] = 550,
        ['torso_2'] = 1,
        ['arms'] = 9,
        ['arms_2'] = 0,
        ['pants_1'] = 172,
        ['pants_2'] = 1,
        ['shoes_1'] = 24,
        ['shoes_2'] = 0,
        ['bproof_1'] = 0,
        ['bproof_2'] = 0,
        ['helmet_1'] = -1,
        ['helmet_2'] = 0,
        ['bags_1'] = 164,
        ['bags_2'] = 6,
    }
    --function LSFDVestiaireDev()
    --    exports['vNotif']:createNotification({
    --        type = 'JAUNE',
    --        content = "Vous venez de récupérer votre tenue"
    --    })

    --    if p:isMale() then
    --        TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1, {renamed = "Tenue LSFD HOMME", data = tenueH})
    --    else
    --        TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1, {renamed = "Tenue LSFD FEMME", data = tenueF})
    --    end
    --end
    --

    function lsfdActionDuty()
        if lsfdDuty then
            TriggerServerEvent('core:DutyOff', 'lsfd')
            --[[             ShowAdvancedNotification("Centrale", "~b~Dispatch", "Vous avez quitté votre service", "CHAR_CALL911",
                "CHAR_CALL911") ]]

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s quitté ~c votre service"
            })

            lsfdDuty = false
            Wait(5000)
        else
            TriggerServerEvent('core:DutyOn', 'lsfd')
            --[[             ShowAdvancedNotification("Centrale", "~b~Dispatch", "Vous avez pris votre service", "CHAR_CALL911",
                "CHAR_CALL911") ]]


            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s pris ~c votre service"
            })


            lsfdDuty = true
            Wait(5000)
        end
    end

    local openRadial = false

    local allVehicleList = {}
    local selected_vehicle = nil

    local vehs = nil
    ---OpenVeh

    local listVeh = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/LSFD/header_lsfd.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/LSFD/logo_vehicule.webp',
        headerIconName = 'VEHICULE',
        callbackName = 'Menu_LSFD_vehicule_callback',
        elements = {
            {
                label = 'Stanier LSFD',
                spawnName = 'LSFD',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/LSFD.webp",
                category= 'VL',
                subCategory= 'Véhicule'
            },
            {
                label = 'Buffalo S LSFD',
                spawnName = 'LSFDBUFS',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/LSFDBUFS.webp",
                category= 'VL',
                subCategory= 'Véhicule'
            },
            {
                label = 'Granger LSFD',
                spawnName = 'bfdsuv',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/bfdsuv.webp",
                category = 'VL',
                subCategory = 'Véhicule'
            },
            {
                label = 'Bison LSFD',
                spawnName = 'lsfdcmd',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/lsfdcmd.webp",
                category = 'VL',
                subCategory = 'Véhicule'
            },
            {
                label = 'Alamo 2021',
                spawnName = 'tffdnalamo',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/tffdnalamo.webp",
                category = 'VL',
                subCategory = 'Véhicule'
            },
            {
                label = 'Rescue',
                spawnName = 'LSFD4',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/LSFD4.webp",
                category= 'Intervention',
                subCategory= 'Intervention'
            },
            {
                label = 'Sandstorm RA',
                spawnName = 'sandbulance',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/sandbulance.webp",
                category= 'Intervention',
                subCategory= 'Intervention'
            },
            {
                label = 'Engine',
                spawnName = 'LSFDTRUCK',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/LSFDTRUCK.webp",
                category= 'Intervention',
                subCategory= 'Intervention'
            },
            {
                label = 'First Response',
                spawnName = 'LSFD5',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/LSFD5.webp",
                category= 'Intervention',
                subCategory= 'Intervention'
            },
            {
                label = 'Squad',
                spawnName = 'LSFDTRUCK3',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/LSFDTRUCK3.webp",
                category= 'Division',
                subCategory= 'Division'
            },
            {
                label = 'Truck',
                spawnName = 'LSFDTRUCK2',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/lsfdtruck2.webp",
                category= 'Division',
                subCategory= 'Division'
            },
            {
                label = 'Swift Water',
                spawnName = 'LSFD2',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/LSFD2.webp",
                category= 'Division',
                subCategory= 'Division'
            },
            {
                label = 'Buffalo LifeGuard',
                spawnName = 'lguardbufs',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/lguardbufs.webp",
                category = 'Division',
                subCategory = 'Division'
            },
            {
                label = 'Caracara LSFD',
                spawnName = 'samscara',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/samscara.webp",
                category= 'VL',
                subCategory= 'Véhicule'
            },
            -- ARSON
            {
                label = 'Stalker FM LSFD',
                spawnName = 'emsstalker',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/emsstalkerfm.webp",
                category= 'Division',
                subCategory= 'ARSON'
            },
            {
                label = 'Buffalo banalisée',
                spawnName = 'lsfdbufac2',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/lsfdbufac2.webp",
                category = 'Division',
                subCategory = 'ARSON'
            },
            {
                label = 'Buffalo S banalisée',
                spawnName = 'lsfdbufs2',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/lsfdbufs2.webp",
                category = 'Division',
                subCategory = 'ARSON'
            },
            {
                label = 'Scout 20',
                spawnName = 'cfd1',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/lsfdscout.webp",
                category = 'VL',
                subCategory = 'Véhicule'
            },
            {
                label = 'Scout banalisé',
                spawnName = 'lsfdscout2',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/lsfdscout2.webp",
                category = 'Division',
                subCategory = 'ARSON'
            },
            {
                label = 'Benefactor L300',
                spawnName = 'fdl300',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/fdl300.webp",
                category = 'Division',
                subCategory = 'Brush Patrol'
            },
            {
                label = 'Brush 4x4',
                spawnName = 'nsandbrush4',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/nsandbrush4.webp",
                category = 'Division',
                subCategory = 'Brush Patrol'
            },
            {
                label = 'Brush 6x6',
                spawnName = 'nsandbrush6',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/nsandbrush6.webp",
                category = 'Division',
                subCategory = 'Brush Patrol'
            },
            {
                label = 'Old brush',
                spawnName = 'dlbrush',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/dlbrush.webp",
                category = 'Division',
                subCategory = 'Brush Patrol'
            },
            {
                label = 'Mobile Operation Command',
                spawnName = 'mocpacker',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/mocpacker.webp",
                category= 'Division',
                subCategory= 'Division'
            },
            -- VL
            {
                label = 'Stalker LSFD',
                spawnName = 'emsstalker',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/emsstalker.webp",
                category = 'VL',
                subCategory = 'Véhicule'
            },
            {
                label = 'Ladder Engine',
                spawnName = 'fdlcladder',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/fdlcladder.webp",
                category = 'Intervention',
                subCategory = 'Intervention'
            },
            {
                label = 'Heavy Rescue',
                spawnName = 'fdlcheavy',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/fdlcheavy.webp",
                category = 'Intervention',
                subCategory = 'Intervention'
            },
        },
    }


    function openGarageMenu()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listVeh
        }))
    end

    local listHeli = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/LSFD/header_lsfd.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/LSFD/logo_vehicule.webp',
        headerIconName = 'VEHICULE',
        callbackName = 'Menu_LSFD_heli_callback',
        elements = {
            {
                label = 'AS332',
                spawnName = 'AS332',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/AS332.webp",
                category = 'Marina',
                subCategory = 'Marina'
            },
            {
                label = 'Maverick',
                spawnName = 'LSPDMAV',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/LSPDMAV.webp",
                category = 'Marina',
                subCategory = 'Marina'
            },
			{
                label = 'Swift',
                spawnName = 'emsswift',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/emsswift.webp",
                category = 'Marina',
                subCategory = 'Marina'
            },
        }
    }

    function openGarageHeliLSFDMenu()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listHeli
        }))
    end

    local listBoat = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/LSFD/header_lsfd.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/LSFD/logo_vehicule.webp',
        headerIconName = 'VEHICULE',
        callbackName = 'Menu_LSFD_boat_callback',
        elements = {
            {
                label = 'Jet-ski',
                spawnName = 'emsseashark',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/emsseashark.webp",
                category = 'Division',
                subCategory = 'Marina'
            },
            {
                label = 'Dinghy',
                spawnName = 'poldinghy',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/poldinghy.webp",
                category = 'Division',
                subCategory = 'Marina'
            },
        }
    }

    function openGarageLSFDBoatMenu()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listBoat
        }))
    end

    zone.addZone(
        "spawn_lsfd_heli",
        garageHeliPos,
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le garage",
        function()
            openGarageHeliLSFDMenu()
        end,
        false,
        25,               -- Id / type du marker
        0.6,              -- La taille
        { 51, 204, 255 }, -- RGB
        170,
        2.0,
        true,
        "bulleGarage"
    )


    zone.addZone(
        "spawn_lsfd_heli_delete",
        deleteHeliPos,
        "Appuyer sur ~INPUT_CONTEXT~ pour ranger le véhicule",
        function()
            if IsPedInAnyVehicle(p:ped(), false) then
                local veh = GetVehiclePedIsIn(p:ped(), false)
                removeKeys(GetVehicleNumberPlateText(veh),
                    GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                DeleteEntity(veh)
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
        "spawn_lsfd_boat",
        garageBoatPos,
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le garage",
        function()
            openGarageLSFDBoatMenu()
        end,
        false,
        25,               -- Id / type du marker
        0.6,              -- La taille
        { 51, 204, 255 }, -- RGB
        170,
        2.0,
        true,
        "bulleGarage"
    )

    zone.addZone(
        "society_lsfdBoat_delete",
        deleteBoatPos,
        "Appuyer sur ~INPUT_CONTEXT~ pour ranger le véhicule",
        function()
            if IsPedInAnyVehicle(p:ped(), false) then
                local veh = GetVehiclePedIsIn(p:ped(), false)
                -- removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                DeleteEntity(veh)
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

    RegisterNUICallback("focusOut", function(data, cb)
        TriggerScreenblurFadeOut(0.5)
        DisplayHud(true)
        openRadarProperly()
    end)

    local casierOpen = false
    function OpenlsfdCasier()
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
                        count = 100
                    }
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
                type = 'closeWebview'
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
        -- OpenInventorySocietyMenu()
    end)

    local openRadial = false
    local lsfdDuty = false
    function lsfdActionDuty()
        openRadial = false
        closeUI()
        if lsfdDuty then
            TriggerServerEvent('core:DutyOff', 'lsfd')
            --[[ShowAdvancedNotification("Centrale", "~b~Dispatch", "Vous avez quitté votre service", "CHAR_CALL911",
                "CHAR_CALL911") ]]

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s quitté ~c votre service"
            })

            lsfdDuty = false
            Wait(5000)
        else
            TriggerServerEvent('core:DutyOn', 'lsfd')
            --[[ShowAdvancedNotification("Centrale", "~b~Dispatch", "Vous avez pris votre service", "CHAR_CALL911",
                "CHAR_CALL911") ]]
            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s pris ~c votre service"
            })

            lsfdDuty = true
            Wait(5000)
        end
    end

    function HealthPatientLSFD()
        if lsfdDuty then
            openRadial = false
            closeUI()
            local closestPlayer = ChoicePlayersInZone(2.0)
            if closestPlayer == nil then
                return
            end

            globalTarget = GetPlayerServerId(closestPlayer)

            if closestPlayer ~= PlayerId() then
                local cPed = GetPlayerPed(closestPlayer)
                local health = GetEntityHealth(cPed)

                if health > 0 then
                    p:PlayAnim("amb@medic@standing@kneel@base", "base", 1)
                    Wait(5000)
                    ClearPedTasks(p:ped())
                    if health > 0 then
                        TriggerServerEvent('core:HealthPlayer', token, globalTarget)
                    end
                end
            else
                local cPed = GetPlayerPed(closestPlayer)
                local health = GetEntityHealth(cPed)
                if health > 0 then
                    p:PlayAnim("amb@medic@standing@kneel@base", "base", 1)
                    Wait(5000)
                    ClearPedTasks(p:ped())
                    if health > 0 then
                        TriggerServerEvent('core:HealthPlayer', token, globalTarget)
                    end
                end
            end
        else
            -- ShowNotification("Vous n'êtes pas en service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous n'êtes ~s pas en service"
            })
        end
    end

    function FactureLSFD()
        if lsfdDuty then
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

    function CertificatLSFD()
        if lsfdDuty then
            openRadial = false
            closeUI()
            TriggerEvent("nuiPapier:client:startCreation", 1)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function makeRenfortCall()
        if lsfdDuty then
            openRadial = false
            closeUI()
            TriggerSecurEvent('core:makeCall', "lsfd", p:pos(), false,
                "Appel de renfort (" .. p:getLastname() .. " " .. p:getFirstname() .. ")")
        else
            -- ShowNotification("~r~Vous n'êtes pas en service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                duration = 5, -- In seconds, default:  4
                content = "Vous n'êtes ~s pas en service"
            })
        end
    end

    function CreateAdvert()
        if lsfdDuty then
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

    function RevivePatientLSFD()
        if lsfdDuty then
            openRadial = false
            closeUI()
            local closestPlayer = ChoicePlayersInZone(2.0, false)
            if closestPlayer == nil then
                return
            end

            globalTarget = GetPlayerServerId(closestPlayer)

            local playerheading = GetEntityHeading(p:ped())
            local coords = GetEntityCoords(p:ped())
            local playerlocation = GetEntityForwardVector(p:ped())

            TriggerServerEvent('core:RevivePlayer', token, globalTarget)
            TriggerServerEvent("core:reviveanimrevived", globalTarget, playerheading, coords, playerlocation)
        else
            -- ShowNotification("Tu n'es pas en service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Tu n'es ~s pas en service"
            })
        end
    end

    local hose = false
    function ToggleHose()
        if lsfdDuty then
            ExecuteCommand('hose')
            if hose == false then
                hose = true
            else
                hose = false
            end
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Tu n'es ~s pas en service"
            })
        end
    end

    local foam = false
    function ToggleFoam()
        if lsfdDuty then
            if hose == false then
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "La lance n'est pas déployée"
                })
            else
                ExecuteCommand('foam')
                if foam == false then
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        content = "La mousse est activée"
                    })
                    foam = true
                else
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        content = "La mousse est désactivée"
                    })
                    foam = false
                end
            end
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Tu n'es ~s pas en service"
            })
        end
    end

    Keys.Register("F2", "F2", "Faire un appel de renfort", function()
        makeRenfortCall()
    end)

    local open = false
    local lspdmenu_objects = RageUI.CreateMenu("", "LSFD", 0.0, 0.0, "vision", "menu_title_ems")
    local lspdmenu_traffic = RageUI.CreateMenu("", "LSFD", 0.0, 0.0, "vision", "menu_title_ems")
    local lspdmenu_traffic_add = RageUI.CreateSubMenu(lspdmenu_traffic, "", "LSFD", 0.0, 0.0, "vision",
        "menu_title_ems")
    local lspdmenu_traffic_view = RageUI.CreateSubMenu(lspdmenu_traffic, "", "LSFD", 0.0, 0.0, "vision",
        "menu_title_ems")
    local lspdmenu_objects_delete = RageUI.CreateSubMenu(lspdmenu_objects, "", "LSFD", 0.0, 0.0, "vision",
        "menu_title_ems")
    lspdmenu_objects.Closed = function()
        open = false
    end
    lspdmenu_traffic.Closed = function()
        open = false
        speed = 0.0
        radius = 0.0
        show = false
        zoneName = ""
    end

    local traficList = {}
    local speed = 0.0
    local radius = 0.0
    local show = false
    local zoneName = ""
    local zonePos = vector3(0, 0, 0)

    function openTraficMenu()
        if lsfdDuty then
            openRadial = false
            closeUI()
            -- open a menu with 2 buttons : one to add a new zone and one to view my zones
            if open then
                open = false
                RageUI.Visible(lspdmenu_traffic, false)
            else
                open = true
                RageUI.Visible(lspdmenu_traffic, true)

                Citizen.CreateThread(function()
                    while open do
                        RageUI.IsVisible(lspdmenu_traffic, function()
                            -- for the first button to add a new zone, it opens a menu where i can set the speed in the zone and the radius of the zone, another checkbox to show it on my client and a last button to add the zone
                            RageUI.Button("Ajouter une zone", nil, {
                                RightLabel = ">"
                            }, true, {
                                onSelected = function()
                                    zonePos = p:pos()
                                end
                            }, lspdmenu_traffic_add)
                            -- for the second button to view my zones, it opens a menu where i can see all my zones and delete them
                            RageUI.Button("Voir les zones", nil, {
                                RightLabel = ">"
                            }, true, {
                                onSelected = function()
                                    traficList = TriggerServerCallback("lspd:traffic:get")
                                end
                            }, lspdmenu_traffic_view)
                        end)
                        RageUI.IsVisible(lspdmenu_traffic_add, function()
                            -- for the speed and radius button, prompt a keyboard to enter the value
                            RageUI.Button("Vitesse", nil, {
                                RightLabel = speed .. " km/h"
                            }, true, {
                                onSelected = function()
                                    speed = tonumber(KeyboardImput("Vitesse")) + .0
                                    if speed == nil then
                                        speed = 0.0
                                    end
                                end
                            })
                            RageUI.Button("Rayon", nil, {
                                RightLabel = radius .. " m"
                            }, true, {
                                onSelected = function()
                                    radius = tonumber(KeyboardImput("Rayon")) + .0
                                    if radius == nil then
                                        radius = 0.0
                                    end
                                end
                            })
                            RageUI.Checkbox("Afficher", nil, show, {}, {
                                onChecked = function()
                                    show = true
                                end,
                                onUnChecked = function()
                                    show = false
                                end
                            })
                            RageUI.Button("Nom de la zone", nil, {
                                RightLabel = zoneName
                            }, true, {
                                onSelected = function()
                                    zoneName = KeyboardImput("Nom de la zone")
                                end
                            })
                            RageUI.Button("Ajouter la zone", nil, {}, true, {
                                onSelected = function()
                                    if radius ~= 0 and zoneName ~= "" then
                                        local id = AddRoadNodeSpeedZone(zonePos, radius, speed, true)
                                        local newZone = {
                                            zoneName = zoneName,
                                            zonePos = zonePos,
                                            zoneRadius = radius,
                                            zoneSpeed = speed,
                                            zoneId = id
                                        }
                                        show = false
                                        TriggerServerEvent("lspd:traffic:add", newZone)
                                        -- ShowNotification("~g~Zone ajoutée")

                                        -- New notif
                                        exports['vNotif']:createNotification({
                                            type = 'VERT',
                                            -- duration = 5, -- In seconds, default:  4
                                            content = "~s Zone ajoutée"
                                        })
                                        open = false
                                        RageUI.CloseAll()
                                    else
                                        -- ShowNotification("~r~Veuillez remplir tous les champs")

                                        -- New notif
                                        exports['vNotif']:createNotification({
                                            type = 'ROUGE',
                                            -- duration = 5, -- In seconds, default:  4
                                            content = "~s Veuillez remplir tous les champs"
                                        })
                                    end
                                end
                            })
                        end)
                        RageUI.IsVisible(lspdmenu_traffic_view, function()
                            for k, v in pairs(traficList) do
                                RageUI.Button(v.zoneId .. " | " .. v.zoneName, nil, {
                                    RightLabel = "~r~ Supprimer"
                                }, true, {
                                    onSelected = function()
                                        RemoveRoadNodeSpeedZone(v.zoneId)
                                        TriggerServerEvent("lspd:traffic:remove", v.zoneId)
                                        -- ShowNotification("~r~Zone supprimée")

                                        -- New notif
                                        exports['vNotif']:createNotification({
                                            type = 'VERT',
                                            -- duration = 5, -- In seconds, default:  4
                                            content = "~s Zone supprimée"
                                        })
                                        RageUI.GoBack()
                                    end,
                                    onActive = function()
                                        local distance = v.zoneRadius + .0
                                        DrawMarker(1, v.zonePos + vector3(0.0, 0.0, -1000.0), 0.0, 0.0, 0.0, 0.0, 0.0,
                                            .0, distance + .0, distance + .0, 10000.0, 20, 192, 255, 70, 0, 0, 2, 0, 0,
                                            0, 0)
                                    end
                                })
                            end
                        end)
                        if show then
                            -- draw circle around player with the radius of the zone
                            local distance = radius + .0
                            DrawMarker(1, p:pos() + vector3(0.0, 0.0, -1000.0), 0.0, 0.0, 0.0, 0.0, 0.0, .0,
                                distance + .0, distance + .0, 10000.0, 20, 192, 255, 70, 0, 0, 2, 0, 0, 0, 0)
                        end
                        Wait(1)
                    end
                end)
            end
        else
            -- ShowNotification("~r~Vous n'êtes pas en service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous n'êtes ~s pas en service"
            })
        end
    end

    function OpenRadialLSFDMenu()
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
            closeUI()
            Wait(200)
            CreateThread(function()
                function OpenSubRadialPapiers()
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
                                    action = "FactureLSFD"
                                },
                                {
                                    name = "RETOUR",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                    action = "OpenMainRadialLSFD"
                                },
                                {
                                    name = "CERTIFICAT",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/health_paper.svg",
                                    action = "CertificatLSFD"
                                }
                            },
                            title = "PAPIERS",
                        }
                    }));
                end

                function OpenSubSoinsRadial()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = {
                            elements = {
                                {
                                    name = "REANIMER",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/heart.svg",
                                    action = "RevivePatientLSFD"
                                },
                                {
                                    name = "SOIGNER",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/health_tool.svg",
                                    action = "HealthPatientLSFD"
                                },
                                {
                                    name = "RETOUR",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                    action = "OpenSubRadialActions"
                                },
                            },
                            title = "SOINS",
                        }
                    }));
                end

                function OpenSubIncendieRadial()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = {
                            elements = {
                                {
                                    name = "LANCE",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/fire_extinguisher.svg",
                                    action = "ToggleHose"
                                },
                                {
                                    name = "MOUSSE",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/repair.svg",
                                    action = "ToggleFoam"
                                },
                                {
                                    name = "RETOUR",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                    action = "OpenSubRadialActions"
                                },
                            },
                            title = "INCENDIE",
                        }
                    }));
                end

                function OpenSubRadialObjectLSFD()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = {
                            elements = {
                                {
                                    name = "OBJETS",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/object.svg",
                                    action = "OpenPropsMenuLSFD"
                                },
                                {
                                    name = "BRANCARD",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/health_tool.svg",
                                    action = "Spawnbrancard"
                                },
                                {
                                    name = "RETOUR",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                    action = "OpenSubRadialActions"
                                }
                            },
                            title = "SOINS",
                        }
                    }));
                end

                function OpenSubRadialActions()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = {
                            elements = {
                                {
                                    name = "OBJETS",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/object.svg",
                                    action = "OpenSubRadialObjectLSFD"
                                },
                                {
                                    name = "CIRCULATION",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/road.svg",
                                    action = "openTraficMenu"
                                },
                                {
                                    name = "SOINS",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/health_tool.svg",
                                    action = "OpenSubSoinsRadial"
                                },
                                {
                                    name = "RETOUR",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                    action = "OpenMainRadialLSFD"
                                },
                                {
                                    name = "INCENDIE",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/fire_station.svg",
                                    action = "OpenSubIncendieRadial"
                                }
                            },
                            title = "ACTIONS",
                        }
                    }));
                end

                function OpenMainRadialLSFD()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = {
                            elements = {
                                {
                                    name = "APPEL DE RENFORT",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/fire.svg",
                                    action = "makeRenfortCall"
                                },
                                {
                                    name = "PAPIERS",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/paper.svg",
                                    action = "OpenSubRadialPapiers"
                                },
                                {
                                    name = "PRISE DE SERVICE",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/checkmark.svg",
                                    action = "lsfdActionDuty"
                                },
                                {
                                    name = "ACTIONS",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/fire_extinguisher.svg",
                                    action = "OpenSubRadialActions"
                                }
                            },
                            title = "LSFD"
                        }
                    }));
                end

                OpenMainRadialLSFD()
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
                type = 'closeWebview'
            }))
            return
        end
    end

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

    RegisterJobMenu(OpenRadialLSFDMenu)

    function openOutfitMenu()
        if open then
            open = false
            RageUI.Visible(outifitmenu, false)
        else
            open = true
            RageUI.Visible(outifitmenu, true)
            oldSkin = p:skin()
            Citizen.CreateThread(function()
                while open do
                    RageUI.IsVisible(outifitmenu, function()
                        for k, v in pairs(lsfd.outfit) do
                            RageUI.Button(v.name, nil, {}, true, {
                                onSelected = function()
                                    selected_table = v
                                end
                            }, outfitmenu_list)
                        end
                    end)
                    RageUI.IsVisible(outfitmenu_list, function()
                        for k, v in pairs(selected_table) do
                            if k ~= "name" then
                                RageUI.Button(k, nil, {}, true, {
                                    onSelected = function()
                                        TriggerEvent('skinchanger:getSkin', function(skin)
                                            if skin.sex == 0 then
                                                if v.male then
                                                    TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1,
                                                        {
                                                            renamed = k,
                                                            data = v.male
                                                        })
                                                end
                                            else
                                                if v.female then
                                                    TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1,
                                                        {
                                                            renamed = k,
                                                            data = v.female
                                                        })
                                                end
                                            end
                                        end)
                                    end
                                })
                            end
                        end
                    end)
                    Wait(1)
                end
            end)
        end
    end

    local function GetDatasPropsLSFD()
        -- DataSendPropsLSFD.items.elements = {}

        playerJobs = 'lsfd-sams'

        -- Cones
        for i = 1, 7 do
            table.insert(DataSendPropsLSFD.items[2].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/Cones/" .. i .. ".webp",
                category = "Cones",
                label = "#" .. i
            })
        end


        -- Panneaux
        for i = 1, 5 do
            table.insert(DataSendPropsLSFD.items[3].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/Panneaux/" .. i .. ".webp",
                category = "Panneaux",
                label = "#" .. i
            })
        end

        -- Barrière
        for i = 1, 9 do
            table.insert(DataSendPropsLSFD.items[4].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/Barrieres/" .. i .. ".webp",
                category = "Barrières",
                label = "#" .. i
            })
        end

        -- Lumières
        for i = 1, 5 do
            table.insert(DataSendPropsLSFD.items[5].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/Lumieres/" .. i .. ".webp",
                category = "Lumières",
                label = "#" .. i
            })
        end

        -- Tables
        for i = 1, 2 do
            table.insert(DataSendPropsLSFD.items[6].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/Tables/" .. i .. ".webp",
                category = "Tables",
                label = "#" .. i
            })
        end

        -- Divers
        for i = 1, 7 do
            table.insert(DataSendPropsLSFD.items[7].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/Divers/" .. i .. ".webp",
                category = "Divers",
                label = "#" .. i
            })
        end

        -- Sacs
        for i = 1, 2 do
            table.insert(DataSendPropsLSFD.items[8].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/Sacs/" .. i .. ".webp",
                category = "Sacs",
                label = "#" .. i
            })
        end


        DataSendPropsLSFD.disableSubmit = true

        return true
    end




    RegisterNUICallback("focusOut", function()
        if PropsMenu.open then
            PropsMenu.open = false
        end
    end)

    DataSendPropsLSFD = {
        items = {
            {
                name = 'main',
                type = 'buttons',
                elements = {
                    {
                        name = 'Cones',
                        width = 'full',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/cones.svg',
                        hoverStyle = ' stroke-black'
                    },
                    {
                        name = 'Panneaux',
                        width = 'full',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/roadsign.svg',
                        hoverStyle = ' stroke-black'
                    },
                    {
                        name = 'Barrières',
                        width = 'full',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/barriere.svg',
                        hoverStyle = ' stroke-black'
                    },
                    {
                        name = 'Lumières',
                        width = 'full',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/light.svg',
                        hoverStyle = ' stroke-black'
                    },
                    {
                        name = 'Tables',
                        width = 'full',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/table.svg',
                        hoverStyle = ' stroke-black'
                    },
                    {
                        name = 'Divers',
                        width = 'full',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/divers.svg',
                        hoverStyle = ' stroke-black'
                    },
                    {
                        name = 'Sacs',
                        width = 'full',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/sacs.svg',
                        hoverStyle = ' stroke-black'
                    },
                },
            },
            {
                name = 'Cones',
                type = 'elements',
                elements = {},
            },
            {
                name = 'Panneaux',
                type = 'elements',
                elements = {},
            },
            {
                name = 'Barrières',
                type = 'elements',
                elements = {},
            },
            {
                name = 'Lumières',
                type = 'elements',
                elements = {},
            },
            {
                name = 'Tables',
                type = 'elements',
                elements = {},
            },
            {
                name = 'Divers',
                type = 'elements',
                elements = {},
            },
            {
                name = 'Sacs',
                type = 'elements',
                elements = {},
            },
        },


        -- headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
        -- headerIconName = 'Cones',
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/header_lsfd.webp',
        callbackName = 'MenuObjetsServicesPublicsLSFD',
        headerTitle = "OBJETS SERVICES PUBLICS",
        showTurnAroundButtons = false,
    }

    local firstart = false

    function OpenPropsMenuLSFD()
        if firstart == false then
            firstart = true
            local bool = GetDatasPropsLSFD()
            while not bool do
                Wait(1)
            end
        end
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
        Wait(50)
        PropsMenu.open = true
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuObjetsServicesPublics',
            data = DataSendPropsLSFD
        }))
    end
end

function UnloadLsfdJob()
    zone.removeZone("casier_lsfd")
    zone.removeZone("lsfdOutfit")

    zone.removeZone("lsfd_garage")
    zone.removeZone("society_lsfd")
    zone.removeZone("stockage_lsfd")
    zone.removeZone("lsfd_armory")
    zone.removeZone("lsfd_garage_vehicle")
    zone.removeZone("spawn_lsfd_heli")
    zone.removeZone("society_lsfdHeli_delete")
    zone.removeZone("spawn_lsfd_boat")
    zone.removeZone("society_lsfdBoat_delete")
    lsfdDuty = false
end

PropsMenu = {
    cam = nil,
    open = false,
}

-- MENU PROPS

local LSFDPropsPlaced = {}

local function SpawnPropsLSFD(obj, name)
    TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
    local coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
    local objCoords = (coords + forward * 2.5)
    local placed = false
    local heading = p:heading()

    local objS = entity:CreateObject(obj, objCoords)
    objS:setPos(objCoords)
    objS:setHeading(heading)
    PlaceObjectOnGroundProperly(objS.id)

    while not placed do
        coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
        objCoords = (coords + forward * 2.5)
        objS:setPos(objCoords)
        PlaceObjectOnGroundProperly(objS.id)
        objS:setAlpha(170)
        SetEntityCollision(objS.id, false, true)

        if IsControlPressed(0, 190) then
            heading = heading + 0.5
        elseif IsControlPressed(0, 189) then
            heading = heading - 0.5
        end

        SetEntityHeading(objS.id, heading)

        ShowHelpNotification(
            "Appuyez sur ~INPUT_CONTEXT~ pour placer l'objet\n~INPUT_FRONTEND_LEFT~ ou ~INPUT_FRONTEND_RIGHT~ Pour faire pivoter l'objet") -- \n ~INPUT_VEH_FLY_DUCK~ Pour annuler
        if IsControlJustPressed(0, 38) then
            placed = true

            OpenPropsMenuLSFD()
        end

        Wait(0)
    end
    SetEntityCollision(objS.id, true, true)
    -- SetEntityInvincible(objS.id, true)
    -- objS:setFreeze(true)
    objS:resetAlpha()
    local netId = objS:getNetId()
    if netId == 0 then
        objS:delete()
    end
    SetNetworkIdCanMigrate(netId, true)
    table.insert(LSFDPropsPlaced, {
        nom = name,
        prop = objS.id
    })
end

local cones_models = {
    ['#1'] = "prop_air_conelight",
    ['#2'] = "prop_mp_cone_03",
    ['#3'] = "prop_mp_cone_04",
    ['#4'] = "prop_roadcone02a",
    ['#5'] = "prop_roadcone02b",
    ['#6'] = "prop_roadpole_01a",
    ['#7'] = "prop_roadpole_01b",
}

local panneaux_models = {
    ['#1'] = "prop_consign_01b",
    ['#2'] = "prop_consign_02a",
    ['#3'] = "prop_sign_road_01a",
    ['#4'] = "prop_sign_road_06q",
    ['#5'] = "prop_sign_road_06r",
}

local barriere_models = {
    ['#1'] = "prop_barrier_work01a",
    ['#2'] = "prop_barrier_work01b",
    ['#3'] = "prop_barrier_work02a",
    ['#4'] = "prop_barrier_work05",
    ['#5'] = "prop_barrier_work06a",
    ['#6'] = "prop_barrier_work06b",
    ['#7'] = "prop_fncsec_04a",
    ['#8'] = "prop_mp_arrow_barrier_01",
    ['#9'] = "prop_mp_barrier_02b",
}

local lumiere_models = {
    ['#1'] = "prop_generator_03b",
    ['#2'] = "prop_worklight_01a",
    ['#3'] = "prop_worklight_03b",
    ['#4'] = "prop_worklight_04a",
    ['#5'] = "prop_worklight_04b",
}

local tables_models = {
    ['#1'] = "bkr_prop_weed_table_01b",
    ['#2'] = "prop_ven_market_table1",
}

local divers_models = {
    ['#1'] = "ex_office_swag_med2",
    ['#2'] = "gr_prop_gr_laptop_01c",
    ['#3'] = "prop_gazebo_02",
    ['#4'] = "prop_ld_health_pack",
    ['#5'] = "sm_prop_smug_crate_m_medical",
    ['#6'] = "xm_prop_body_bag",
    ['#7'] = "xm_prop_smug_crate_s_medical",
}

local sacs_models = {
    ['#1'] = "xm_prop_x17_bag_01c",
    ['#2'] = "xm_prop_x17_bag_med_01a",
}


RegisterNUICallback("MenuObjetsServicesPublicsLSFD", function(data, cb)
    -- if data == nil or data.category == nil then return end
    -- PropsMenu.choice = data.category

    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))

    if data.category == "Cones" then
        SpawnPropsLSFD(cones_models[data.label], data.label)
    end

    if data.category == "Panneaux" then
        SpawnPropsLSFD(panneaux_models[data.label], data.label)
    end

    if data.category == "Barrières" then
        SpawnPropsLSFD(barriere_models[data.label], data.label)
    end

    if data.category == "Lumières" then
        SpawnPropsLSFD(lumiere_models[data.label], data.label)
    end

    if data.category == "Tables" then
        SpawnPropsLSFD(tables_models[data.label], data.label)
    end

    if data.category == "Divers" then
        SpawnPropsLSFD(divers_models[data.label], data.label)
    end

    if data.category == "Sacs" then
        SpawnPropsLSFD(sacs_models[data.label], data.label)
    end
end)


local pos = {
    vector4(-1659.53, 44.39, 64, 142.08),
}

RegisterNUICallback("Menu_LSFD_vehicule_callback", function(data, cb)
    if vehicle.IsSpawnPointClear(vector3(spawnVehPos.x, spawnVehPos.y, spawnVehPos.z), 3.0) then
        vehs = vehicle.create(data.spawnName, spawnVehPos, {})
        SetVehicleMod(vehs, 11, 1, false)
        SetVehicleMod(vehs, 12, 1, false)
        SetVehicleMod(vehs, 13, 1, false)
        if data.spawnName == 'samscara' then
            SetVehicleLivery(vehs, 2)
        elseif data.label == 'Stalker FM LSFD' then
            SetVehicleLivery(vehs, 3)
        elseif data.label == 'Stalker LSFD' then
            SetVehicleLivery(vehs, 2)
		elseif data.spawnName == 'sandbulance' then
            SetVehicleLivery(vehs, 4)
        elseif data.spawnName == 'ems2stx' then
            SetVehicleLivery(vehs, 0)
        elseif data.spawnName == 'mocpacker' then
            SetVehicleLivery(vehs, 4)
        end
        local plate = vehicle.getProps(vehs).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
        -- createKeys(plate, model)
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Il n'y a ~s pas de place ~c pour le véhicule"
        })
    end
end)

RegisterNUICallback("Menu_LSFD_heli_callback", function(data, cb)
	if vehicle.IsSpawnPointClear(vector3(spawnHeliPos.x, spawnHeliPos.y, spawnHeliPos.z), 3.0) then
		vehs = vehicle.create(data.spawnName, spawnHeliPos, {})
		-- SetVehicleLivery(vehs, 0)
		if data.spawnName == 'AS332' then
			SetVehicleLivery(vehs, 2)
		elseif data.spawnName == 'emsswift' then
			SetVehicleLivery(vehs, 1)
		else
			SetVehicleLivery(vehs, 2)
		end
		local plate = vehicle.getProps(vehs).plate
		local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
		local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
		-- createKeys(plate, model)
		SendNuiMessage(json.encode({
			type = 'closeWebview',
		}))
	else
		-- ShowNotification("Il n'y a pas de place pour le véhicule")

		-- New notif
		exports['vNotif']:createNotification({
			type = 'ROUGE',
			-- duration = 5, -- In seconds, default:  4
			content = "Il n'y a ~s pas de place ~c pour le véhicule"
		})
	end
end)

RegisterNUICallback("Menu_LSFD_boat_callback", function(data, cb)
    if vehicle.IsSpawnPointClear(vector3(spawnBoatPos.x, spawnBoatPos.y, spawnBoatPos.z), 3.0) then
        vehs = vehicle.create(data.spawnName, spawnBoatPos, {})
        if data.spawnName == 'emsseashark' then
            SetVehicleLivery(vehs, 1)
        elseif data.spawnName == 'poldinghy' then
            SetVehicleLivery(vehs, 2)
        end
        local plate = vehicle.getProps(vehs).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
        -- createKeys(plate, model)
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
    else
        -- ShowNotification("Il n'y a pas de place pour le véhicule")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Il n'y a ~s pas de place ~c pour le véhicule"
        })
    end
end)

RegisterNUICallback("armoryTakeLSFD", function(data, cb)
    for k, v in pairs(data) do
        TriggerSecurGiveEvent("core:addItemToInventory", token, v.name, 1, {})
        exports['vNotif']:createNotification({
            type = 'DOLLAR',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous venez de récupérer ~s un(e) " .. v.label
        })
    end
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
end)

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7lsfd ^3loaded")
end)
