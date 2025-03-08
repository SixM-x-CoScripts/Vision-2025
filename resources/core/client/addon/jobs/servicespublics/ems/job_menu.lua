local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

CreateThread(function()
    while zone == nil do Wait(1) end

    local pedsData = {
        { model = "s_m_m_armoured_02", position = vector3(327.96, -578.78, 27.79), heading = 293.36, scenario = "WORLD_HUMAN_GUARD_STAND" }, -- Garage 
        { model = "s_f_y_scrubs_01", position = vector3(316.57, -597.8, 42.26), heading = 252.09, scenario = "WORLD_HUMAN_GUARD_STAND" },
        { model = "s_f_y_scrubs_01",   position = vector3(298.27, -597.86, 42.26), heading = 337.22, scenario = "WORLD_HUMAN_CLIPBOARD" }, -- Phramacie
        { model = "s_m_y_airworker",   position = vector3(-786.37, -1507.97, 0.6),heading = 331.4,scenario = "WORLD_HUMAN_CLIPBOARD" },
        { model = "s_m_m_armoured_02", position = vector3(340.52, -581.57, 73.16),heading = 243.34, scenario = "WORLD_HUMAN_CLIPBOARD" },
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

EmsDuty = false

function LoadEmsJob()
    ----Zone

    zone.addZone("pharmacie_ems",
        vector3(298.27, -597.86, 44.10),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir la pharmacie",
        function()
            OpenEMSITEMMenu()
        end,
        false,          -- Avoir un marker ou non
        39,             -- Id / type du marker
        0.5,            -- La taille
        { 203, 75, 0 }, -- RGB
        170,            -- Alpha
        2.0,
        true,
        "bulleCatalogue"
    )

    zone.addZone("society_ems_custom", vector3(340.27, -561.91, 28.75),
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
        false,          -- Avoir un marker ou non
        39,             -- Id / type du marker
        0.5,            -- La taille
        { 203, 75, 0 }, -- RGB
        170,            -- Alpha
        2.0,
        true,
        "bulleCustom"
    )

    local items = {
        headerImage = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Banners/SAMS.webp",
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Banners/icon.webp',
        headerIconName = 'CATALOGUE',
        callbackName = 'pharmacyTakeEMS',
        --[[ showTurnAroundButtons = false,
        multipleSelection = true, ]]
        elements = {
            {
                id = 1,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/bandages.webp",
                name = "band",
                label = "Bandages",
                price = 0,
            },
            {
                id = 2,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Jumelles.webp",
                name = "jumelle",
                label = "Jumelles",
                price = 0,
            },
            {
                id = 3,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/medicament.webp",
                name = "medic",
                label = "Médicament",
                price = 0,
            },
            {
                id = 4,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/medikit.webp",
                name = "medikit",
                label = "Medikit",
                price = 0,
            },
            {
                id = 5,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Pansement.webp",
                name = "pad",
                label = "Pansement",
                price = 0,
            },
            {
                id = 6,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/bequille.webp",
                name = "bequille",
                label = "Bequille",
                price = 0,
            },
            {
                id = 7,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/wheelchair.webp",
                name = "froulant",
                label = "Chaise Roulante",
                price = 0,
            },
            {
                id = 8,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/samskev.webp",
                name = "samskev",
                label = "Kevlar Class C",
            },
            {
                id = 9,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/samskev.webp",
                name = "samskev2",
                label = "Kevlar Bleu",
            },
            {
                id = 10,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/samskev.webp",
                name = "samskev3",
                label = "Kevlar Noir",
            },
            {
                id = 11,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/samskev.webp",
                name = "samskev4",
                label = "Gilet",
            },
			{
                id = 11,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/samskev.webp",
                name = "samskev5",
                label = "GPB TEMS",
            },
            {
                id = 12,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/poudre.webp",
                name = "poudre",
                label = "Kit test de poudre",
            },
            {
                id = 13,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/pad3.webp",
                name = "pad3",
                label = "Pansement Bob L'éponge",
            },
			{
				price = 0,
				id = 13,
				image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/tabletmdt.webp",
				name = "tabletmdt",
				label = "Tablette MDT"
			}
        }
    }

    function OpenEMSITEMMenu()
        FreezeEntityPosition(PlayerPedId(), true)
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuPostOPStock',
            --[[ data = items ]]
            data = {
                headerImage = items.headerImage,
                elements = items.elements,
                stocks = items.elements,
                headerIcon = items.headerIcon,
                headerIconName = 'Catalogue',
                callbackName = items.callbackName
            }
        }));
    end

    zone.addZone(
        "bateau_ems",
        vector3(-786.37, -1507.97, 2.6),
        "~INPUT_CONTEXT~ Garage bateau",
        function()
            spawnMenuChoose = 'boat'
            openGarageSAMSBoatMenu() --TODO: fini le menu society
        end,
        false,                       -- Avoir un marker ou non
        -1,                          -- Id / type du marker
        0.6,                         -- La taille
        { 0, 0, 0 },                 -- RGB
        0,                           -- Alpha
        1.5,
        true,
        "bulleGarage"
    )
    zone.addZone(
        "delete_bateau_ems",
        vector3(-803.27239990234, -1500.1253662109, 1.11955547332764),
        "Appuyer sur ~INPUT_CONTEXT~ pour ranger le bateau",
        function()
            if IsPedInAnyVehicle(p:ped(), false) then
                local veh = GetVehiclePedIsIn(p:ped(), false)
                TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                --removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                DeleteEntity(veh)
            end
        end,
        true,
        35,            -- Id / type du marker
        0.6,           -- La taille
        { 255, 0, 0 }, -- RGB
        170            -- Alpha
    )

    zone.addZone(
        "society_ems",
        vector3(328.75, -604.43, 43.26),
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
        "coffre_pems",
        vector3(334.51, -583.06, 27.78),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le coffre de l'entreprise",
        function()
            OpenInventorySocietyMenu() --TODO: fini le menu society
        end,
        false,
        27,
        0.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleCoffre"
    )

    zone.addZone(
        "society_ems_delete",
        vector3(329.99, -573.44, 28.74),
        "Appuyer sur ~INPUT_CONTEXT~ pour ranger le véhicule",
        function()
            if IsPedInAnyVehicle(p:ped(), false) then
                local veh = GetVehiclePedIsIn(p:ped(), false)
                removeKeys(GetVehicleNumberPlateText(veh),
                    GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
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
    zone.addZone(
        "society_emsHeli_delete",
        vector3(351.53289794922, -588.029296875, 73.77205657959),
        "Appuyer sur ~INPUT_CONTEXT~ pour ranger le véhicule",
        function()
            if IsPedInAnyVehicle(p:ped(), false) then
                local veh = GetVehiclePedIsIn(p:ped(), false)
                removeKeys(GetVehicleNumberPlateText(veh),
                    GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
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
    zone.addZone(
        "spawn_ems_heli",
        vector3(340.65145874023, -581.5576171875, 75.165649414062),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le garage",
        function()
            spawnMenuChoose = 'heli'
            openGarageHeliSAMSMenu()
        end,
        false,       -- Avoir un marker ou non
        -1,          -- Id / type du marker
        0.6,         -- La taille
        { 0, 0, 0 }, -- RGB
        0,           -- Alpha
        3.5,
        true,
        "bulleGarage"
    )

    local listHeli = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/EMS/header_sams.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/EMS/logo_voiture.webp',
        headerIconName = 'HELICOPTERES',
        callbackName = 'Menu_SAMS_heli_callback',
        elements = {
            {
                label = 'Swift',
                spawnName = 'EMSSWIFT',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/EMS/emsswift.webp",
            },
            {
                label = 'Maverick',
                spawnName = 'lspdmav',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/EMS/lspdmav.webp",
            },
        }
    }

    function openGarageHeliSAMSMenu()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listHeli
        }))
    end

    zone.addZone(
        "spawn_ems",
        vector3(327.83, -578.85, 29.69),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le garage",
        function()
            spawnMenuChoose = 'car'
            OpenMenuVehEms()
        end,
        false,       -- Avoir un marker ou non
        -1,          -- Id / type du marker
        0.6,         -- La taille
        { 0, 0, 0 }, -- RGB
        0,           -- Alpha
        3.5,
        true,
        "bulleGarage"
    )

    zone.addZone("emsVestiaire", vector3(316.64, -597.73, 44.16),
        "Appuyer sur ~INPUT_CONTEXT~ pour interagir",
        function()
            LoadSAMSVestiaire()
        end,
        false,
        27,
        0.5,
        { 255, 255, 255 },
        170,
        2.4,
        true,
        "bulleVetement"
    )

    local tenueH = {
        ['tshirt_1'] = 263,
        ['tshirt_2'] = 0,

        ['torso_1'] = 518,
        ['torso_2'] = 6,

        ['arms'] = 11,
        ['arms_2'] = 0,

        ['pants_1'] = 191,
        ['pants_2'] = 0,

        ['shoes_1'] = 25,
        ['shoes_2'] = 0,
    }
    local tenueF = {
        ['tshirt_1'] = 265,
        ['tshirt_2'] = 0,

        ['torso_1'] = 562,
        ['torso_2'] = 6,

        ['arms'] = 9,
        ['arms_2'] = 0,

        ['pants_1'] = 195,
        ['pants_2'] = 0,

        ['shoes_1'] = 25,
        ['shoes_2'] = 0,

        ['chain_1'] = 162,
        ['chain_2'] = 0,
    }
    --[[function EMSVestiaireDev()
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            content = "Vous venez de récupérer votre tenue"
        })

        if p:isMale() then
            TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1, {renamed = "Tenue SAMS HOMME", data = tenueH})
        else
            TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1, {renamed = "Tenue SAMS FEMME", data = tenueF})
        end
    end ]]

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
                        for k, v in pairs(ems.outfit) do
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

    local coffrePos = {
        vector3(318.66, -580.03, 43.26),
        --vector3(-1814.8516845703, -359.9665222168, 49.456581115723),
        --vector3(-1819.8349609375, -360.47152709961, 49.449405670166),
        --vector3(-1814.6741943359, -353.55563354492, 49.467071533203),
        --vector3(-1816.4432373047, -355.45855712891, 49.46178817749),
        --vector3(-1812.9456787109, -358.21035766602, 49.461769104004),

    }

    for k, v in pairs(coffrePos) do
        zone.addZone(
            "casier_ems" .. k,
            v,
            "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les casiers",
            function()
                OpenEMSCasier() --TODO: fini le menu society
            end, false,
            27,
            1.5,
            { 255, 255, 255 },
            170,
            2.0,
            true,
            "bulleCasiers"
        )
    end

    local casierOpen = false
    function OpenEMSCasier()
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
        -- OpenInventorySocietyMenu()
    end)

    local emsVeh = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_sams.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
        headerIconName = 'VEHICULES',
        callbackName = 'Menu_SAMS_vehicule_callback',
        elements = {
            {
                id = 1,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/EMS/blazerems.webp',
                label = 'SAMS Quad',
                name = "blazerems"
            },
            {
                id = 2,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/EMS/ambulance4.webp',
                label = 'Ambulance',
                name = "ambulance4"
            },
            {
                id = 3,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/EMS/emsstalker.webp',
                label = 'Stalker SAMS',
                name = "emsstalker"
            },
            {
                id = 4,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/EMS/samscara.webp',
                label = 'Caracara SAMS',
                name = "samscara"
            },
            {
                id = 5,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/EMS/lsfd3.webp',
                label = 'Ambulance SAMS',
                name = "lsfd3"
            },
            {
                id = 6,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/EMS/lsfd3tems.webp',
                label = 'Ambulance TEMS',
                name = "lsfd3"
            },
            {
                id = 7,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSFD/LSFDTRUCK3.webp',
                label = 'Hazmat TEMS',
                name = "LSFDTRUCK3"
            },
            {
                id = 8,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/EMS/emsbike.webp',
                label = 'Vélo',
                name = "emsbike"
            },
			{
                id = 9,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/EMS/ambulance4.webp',
                label = 'Ambulance',
                name = "sandbulance"
            },
			{
                id = 10,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/EMS/coroner.webp',
                label = 'Van coroner',
                name = "coroner"
            },
        }
    }

    function OpenMenuVehEms()
        forceHideRadar()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = emsVeh
        }))
    end

    local listBoat = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_sams.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
        headerIconName = 'BATEAUX',
        callbackName = 'Menu_SAMS_boat_callback',
        elements = {
            {
                label = 'Jet-ski',
                spawnName = 'emsseashark',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/EMS/emsseashark.webp",
                category = 'Division',
                subCategory = 'Marina'
            },
            {
                label = 'Dinghy',
                spawnName = 'poldinghy',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/EMS/poldinghy.webp",
                category = 'Division',
                subCategory = 'Marina'
            },
        }
    }

    function openGarageSAMSBoatMenu()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listBoat
        }))
    end

    RegisterNUICallback("focusOut", function(data, cb)
        TriggerScreenblurFadeOut(0.5)
        DisplayHud(true)
        openRadarProperly()
    end)

    local openRadial = false
    function SetEmsDuty()
        if EmsDuty then
            TriggerServerEvent('core:DutyOff', 'ems')
            --  ShowNotification("Vous avez ~r~quitté~s~ votre service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s quitté ~c votre service"
            })
            EmsDuty = false
            Wait(5000)
        else
            TriggerServerEvent('core:DutyOn', 'ems')
            --  ShowNotification("Vous avez ~r~quitté~s~ votre service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s pris ~c votre service"
            })
            EmsDuty = true
            Wait(5000)
        end
    end

    function RenfortEms()
        if EmsDuty then
            openRadial = false
            closeUI()
            TriggerSecurEvent('core:makeCall', "ems", p:pos(), false, "Besoin de renfort")
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    CreateThread(function()
        local showB = true
        local waitTime = 2000
        while true do
            Wait(waitTime)
            if EmsDuty then
                local player, dst = GetClosestPlayer()
                --print(dst)
                if dst ~= nil and dst <= 6.0 then
                    if GetPlayerPed(player) and IsEntityDead(GetPlayerPed(player)) then
                        if GetDistanceBetweenCoords(GetEntityCoords(p:ped()), GetEntityCoords(GetPlayerPed(player))) < 5.0 then
                            waitTime = 1
                            if showB then
                                Bulle.create("reanimer", GetEntityCoords(GetPlayerPed(player)), "bulleReanimer", true)
                            end
                            if IsControlJustPressed(0, 38) and GetDistanceBetweenCoords(GetEntityCoords(p:ped()), GetEntityCoords(GetPlayerPed(player))) < 3.0 then
                                local playerheading = GetEntityHeading(p:ped())
                                local coords = GetEntityCoords(p:ped())
                                local playerlocation = GetEntityForwardVector(p:ped())
                                showB = false
                                TriggerServerEvent('core:RevivePlayer', token, GetPlayerServerId(player))
                                TriggerServerEvent("core:reviveanimrevived", GetPlayerServerId(player), playerheading,
                                    coords, playerlocation)
                                Bulle.remove("reanimer")
                                Wait(5000)
                                showB = true
                            end
                        end
                    end
                end
            end
        end
    end)

    function FactureEms(entity)
        if EmsDuty then
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

    local open = false
    local outifitmenu = RageUI.CreateMenu("", "EMS", 0.0, 0.0, "vision", "menu_title_ems")
    local outfitmenu_list = RageUI.CreateSubMenu(outifitmenu, "", "EMS", 0.0, 0.0, "vision", "menu_title_ems")
    outifitmenu.Closed = function()
        open = false
    end

    local selected_table = {}

    function openOutfitMenu()
        if open then
            open = false
            RageUI.Visible(outifitmenu, false)
        else
            open = true
            RageUI.Visible(outifitmenu, true)

            Citizen.CreateThread(function()
                while open do
                    RageUI.IsVisible(outifitmenu, function()
                        for k, v in pairs(ems.outfit) do
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

    --[[local outfit = {
        vector3(-1817.7576904297, -361.52426147461, 49.450511932373),
        vector3(-1812.4222412109, -355.35546875, 49.466976165771),
    }
    for k, v in pairs(outfit) do
        zone.addZone(
            "ems.Outfit" .. math.random(0, 156465654),
            v,
            "~INPUT_CONTEXT~ Intéragir",
            function()
                openOutfitMenu()
            end,
            false
        )
    end]]

    function HealthPatientSAMS()
        if EmsDuty then
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
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous n'êtes ~s pas en service"
            })
        end
    end

    function CertificatSAMS()
        if EmsDuty then
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

    function CreateAdvert()
        if EmsDuty then
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

    function RevivePatientSAMS()
        if EmsDuty then
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

    function OpenRadialEmsMenu()
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
                                    action = "FactureEms"
                                },
                                {
                                    name = "RETOUR",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                    action = "OpenMainRadialSAMS"
                                },
                                {
                                    name = "CERTIFICAT",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/health_paper.svg",
                                    action = "CertificatSAMS"
                                }
                            },
                            title = "PAPIERS",
                        }
                    }));
                end

                function OpenSubRadialObject()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = {
                            elements = {
                                {
                                    name = "OBJETS",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/object.svg",
                                    action = "OpenPropsMenuSAMS"
                                },
                                {
                                    name = "BRANCARD",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/health_tool.svg",
                                    action = "Spawnbrancard"
                                },
                                {
                                    name = "RETOUR",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                    action = "OpenSubRadialSoins"
                                }
                            },
                            title = "SOINS",
                        }
                    }));
                end

                function OpenSubRadialSoins()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = {
                            elements = {
                                {
                                    name = "OBJETS",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/object.svg",
                                    action = "OpenSubRadialObject"
                                },
                                {
                                    name = "SOIGNER",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/health_tool.svg",
                                    action = "HealthPatientSAMS"
                                },
                                {
                                    name = "RETOUR",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                    action = "OpenMainRadialSAMS"
                                },
                                {
                                    name = "REANIMER",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/heart.svg",
                                    action = "RevivePatientSAMS"
                                }
                            },
                            title = "SOINS",
                        }
                    }));
                end

                function OpenMainRadialSAMS()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = {
                            elements = {
                                {
                                    name = "APPEL DE RENFORT",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/pharmacy.svg",
                                    action = "RenfortEms"
                                },
                                {
                                    name = "PAPIERS",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/bpm.svg",
                                    action = "OpenSubRadialPapiers"
                                },
                                {
                                    name = "PRISE DE SERVICE",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/checkmark.svg",
                                    action = "SetEmsDuty"
                                },
                                {
                                    name = "SOINS",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/health.svg",
                                    action = "OpenSubRadialSoins"
                                }
                            },
                            title = "SAMS"
                        }
                    }));
                end

                OpenMainRadialSAMS()
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

    RegisterJobMenu(OpenRadialEmsMenu)

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



    local function GetDatasPropsSAMS()
        -- DataSendPropsSAMS.items.elements = {}

        playerJobs = 'lsfd-sams'

        -- Cones
        for i = 1, 7 do
            table.insert(DataSendPropsSAMS.items[2].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" .. playerJobs .. "/Cones/" .. i .. ".webp",
                category = "Cones",
                label = "#" .. i
            })
        end


        -- Panneaux
        for i = 1, 5 do
            table.insert(DataSendPropsSAMS.items[3].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" .. playerJobs .. "/Panneaux/" .. i .. ".webp",
                category = "Panneaux",
                label = "#" .. i
            })
        end

        -- Barrière
        for i = 1, 9 do
            table.insert(DataSendPropsSAMS.items[4].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" .. playerJobs .. "/Barrieres/" .. i .. ".webp",
                category = "Barrières",
                label = "#" .. i
            })
        end

        -- Lumières
        for i = 1, 5 do
            table.insert(DataSendPropsSAMS.items[5].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" .. playerJobs .. "/Lumieres/" .. i .. ".webp",
                category = "Lumières",
                label = "#" .. i
            })
        end

        -- Tables
        for i = 1, 2 do
            table.insert(DataSendPropsSAMS.items[6].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" .. playerJobs .. "/Tables/" .. i .. ".webp",
                category = "Tables",
                label = "#" .. i
            })
        end

        -- Divers
        for i = 1, 8 do
            table.insert(DataSendPropsSAMS.items[7].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" .. playerJobs .. "/Divers/" .. i .. ".webp",
                category = "Divers",
                label = "#" .. i
            })
        end

        -- Sacs
        for i = 1, 2 do
            table.insert(DataSendPropsSAMS.items[8].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" .. playerJobs .. "/Sacs/" .. i .. ".webp",
                category = "Sacs",
                label = "#" .. i
            })
        end


        DataSendPropsSAMS.disableSubmit = true

        return true
    end


    DataSendPropsSAMS = {
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
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/EMS/header_sams.webp',
        callbackName = 'MenuObjetsServicesPublicsSAMS',
        headerTitle = "OBJETS SERVICES PUBLICS",
        showTurnAroundButtons = false,
    }

    local firstart = false

    function OpenPropsMenuSAMS()
        if firstart == false then
            firstart = true
            local bool = GetDatasPropsSAMS()
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
            data = DataSendPropsSAMS
        }))
    end
end

function UnLoadEmsJob()
    zone.removeZone("society_ems")
    zone.removeZone("society_ems2")
    zone.removeZone("coffre_pems")
    zone.removeZone("coffre_pems2")
    zone.removeZone("vestiare_pems")
    zone.removeZone("emsVestiaire")
    zone.removeZone("society_ems_delete")
    zone.removeZone("society_ems_delete2")
    zone.removeZone("society_emsHeli_delete")
    zone.removeZone("spawn_ems_heli")
    zone.removeZone("society_emsHeli2_delete")
    zone.removeZone("spawn_ems_heli2")
    zone.removeZone("spawn_ems")
    zone.removeZone("spawn_ems2")
end

RegisterNUICallback("Menu_SAMS_vehicule_callback", function(data, cb)
    if vehicle.IsSpawnPointClear(vector3(336.71, -571.25, 27.51), 5.0) then
        vehs = vehicle.create(data.name, vector4(336.71, -571.25, 27.51, 340.73), {})
        SetVehicleMod(vehs, 11, 1, false)
        SetVehicleMod(vehs, 13, 1, false)
        if data.label == "Ambulance SAMS" then
            SetVehicleLivery(vehs, 1)
        elseif data.label == "Ambulance TEMS" then
            SetVehicleLivery(vehs, 2)
		elseif data.name == "sandbulance" then
            SetVehicleLivery(vehs, 2)
        elseif data.name == "samscara" then
            SetVehicleLivery(vehs, 1)
        elseif data.name == 'emsstalker' then
            SetVehicleLivery(vehs, 0)
        elseif data.name == 'LSFDTRUCK3' then
            SetVehicleLivery(vehs, 1)
        end
        local plate = vehicle.getProps(vehs).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
        --createKeys(plate, model)
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
    elseif vehicle.IsSpawnPointClear(vector3(322.04, -570.76, 27.51), 5.0) then
        vehs = vehicle.create(data.name, vector4(322.04, -570.76, 27.51, 254.27), {})
        SetVehicleMod(vehs, 11, 1, false)
        SetVehicleMod(vehs, 13, 1, false)
        if data.label == "Ambulance SAMS" then
            SetVehicleLivery(vehs, 1)
        elseif data.label == "Ambulance TEMS" then
            SetVehicleLivery(vehs, 2)
        elseif data.name == "samscara" then
            SetVehicleLivery(vehs, 1)
        elseif data.name == 'emsstalker' then
            SetVehicleLivery(vehs, 0)
        elseif data.name == 'LSFDTRUCK3' then
            SetVehicleLivery(vehs, 1)
        end
        local plate = vehicle.getProps(vehs).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
        --createKeys(plate, model)
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
    elseif vehicle.IsSpawnPointClear(vector3(342.53, -577.14, 27.51), 5.0) then
        vehs = vehicle.create(data.name, vector4(342.53, -577.14, 27.51, 341.99), {})
        SetVehicleMod(vehs, 11, 1, false)
        SetVehicleMod(vehs, 13, 1, false)
        if data.label == "Ambulance SAMS" then
            SetVehicleLivery(vehs, 1)
        elseif data.label == "Ambulance TEMS" then
            SetVehicleLivery(vehs, 2)
        elseif data.name == "samscara" then
            SetVehicleLivery(vehs, 1)
        elseif data.name == 'emsstalker' then
            SetVehicleLivery(vehs, 0)
        elseif data.name == 'LSFDTRUCK3' then
            SetVehicleLivery(vehs, 1)
        end
        local plate = vehicle.getProps(vehs).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
        --createKeys(plate, model)
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

RegisterNUICallback("Menu_SAMS_heli_callback", function(data, cb)
    if vehicle.IsSpawnPointClear(vector3(351.76434326172, -588.16717529297, 72.772407531738), 3.0) then
        vehs = vehicle.create(data.spawnName,
            vector4(351.76434326172, -588.16717529297, 72.772407531738, 341.80337524414), {})
        -- SetVehicleLivery(vehs, 0)
        if data.spawnName == 'EMSSWIFT' then
            SetVehicleLivery(vehs, 0)
        elseif data.spawnName == 'lspdmav' then
            SetVehicleLivery(vehs, 3)
        else
            SetVehicleLivery(vehs, 1)
        end
        local plate = vehicle.getProps(vehs).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
        --createKeys(plate, model)
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

RegisterNUICallback("Menu_SAMS_boat_callback", function(data, cb)
    if vehicle.IsSpawnPointClear(vector3(-801.99151611328, -1500.0753173828, -0.47385582327843), 3.0) then
        vehs = vehicle.create(data.spawnName,
            vector4(-801.99151611328, -1500.0753173828, -0.47385582327843, 108.33866882324), {})
        if data.spawnName == 'emsseashark' then
            SetVehicleLivery(vehs, 0)
        elseif data.spawnName == 'poldinghy' then
            SetVehicleLivery(vehs, 2)
        end
        local plate = vehicle.getProps(vehs).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
        --createKeys(plate, model)
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

RegisterNUICallback("pharmacyTakeEMS", function(data, cb)
    for k, v in pairs(data.items) do
        TriggerSecurGiveEvent("core:addItemToInventory", token, v.name, v.quantity, {})
        exports['vNotif']:createNotification({
            type = 'DOLLAR',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous venez de récupérer ~sx" .. v.quantity .. " " .. v.label
        })
    end
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
end)


PropsMenu = {
    cam = nil,
    open = false,
}

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
    ['#8'] = "treasurechest",
}

local sacs_models = {
    ['#1'] = "xm_prop_x17_bag_01c",
    ['#2'] = "xm_prop_x17_bag_med_01a",
}


RegisterNUICallback("focusOut", function()
    if PropsMenu.open then
        PropsMenu.open = false
    end
end)

RegisterNUICallback("MenuObjetsServicesPublicsSAMS", function(data, cb)
    -- if data == nil or data.category == nil then return end
    -- PropsMenu.choice = data.category

    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))

    if data.category == "Cones" then
        SpawnPropsSAMS(cones_models[data.label], data.label)
    end

    if data.category == "Panneaux" then
        SpawnPropsSAMS(panneaux_models[data.label], data.label)
    end

    if data.category == "Barrières" then
        SpawnPropsSAMS(barriere_models[data.label], data.label)
    end

    if data.category == "Lumières" then
        SpawnPropsSAMS(lumiere_models[data.label], data.label)
    end

    if data.category == "Tables" then
        SpawnPropsSAMS(tables_models[data.label], data.label)
    end

    if data.category == "Divers" then
        SpawnPropsSAMS(divers_models[data.label], data.label)
    end

    if data.category == "Sacs" then
        SpawnPropsSAMS(sacs_models[data.label], data.label)
    end
end)


local SAMSPropsPlaced = {}

function SpawnPropsSAMS(obj, name)
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

            OpenPropsMenuSAMS()
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
    table.insert(SAMSPropsPlaced, {
        nom = name,
        prop = objS.id
    })
end

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7ems ^3loaded")
end)
