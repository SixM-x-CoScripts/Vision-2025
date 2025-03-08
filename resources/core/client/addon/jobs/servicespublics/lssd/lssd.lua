local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local OpenLSSDMENUItems = false

local created = false
local posSS = { 
    vector4(2831.9, 4770.32, 45.71, 12.42),
    vector4(2828.64, 4769.44, 45.71, 12.49),
    vector4(2825.09, 4768.94, 45.71, 11.58),
    vector4(2821.33, 4767.71, 45.71, 11.46),
    vector4(2816.89, 4766.94, 45.71, 10.0),
    vector4(2817.16, 4782.78, 45.71, 192.35),
    vector4(2813.6, 4782.09, 45.71, 191.81),
    vector4(2806.95, 4764.8, 45.71, 9.96),
    vector4(2803.46, 4763.86, 45.71, 10.36),
    vector4(2800.17, 4763.08, 45.71, 11.42),
    vector4(2796.46, 4762.4, 45.71, 12.69),
    vector4(2792.71, 4761.99, 45.71, 12.44),
    vector4(2788.97, 4761.07, 45.71, 12.57) 
}

local posPB = {
    vector4(-482.44570922852, 6024.583984375, 30.340375900269, 223.04058837891),
    vector4(-478.29275512695, 6026.9252929688, 30.340375900269, 226.08567810059),
    vector4(-475.24127197266, 6030.8276367188, 30.340375900269, 224.17758178711),
    vector4(-471.88851928711, 6034.0708007813, 30.340375900269, 221.46240234375),
    vector4(-468.21636962891, 6037.3647460938, 30.340375900269, 221.46240234375)
}

local posVespucciLSPD = {
    vector4(-1061.6607666016, -854.06854248047, 4.4745573997498, 216.77090454102),
    vector4(-1058.2822265625, -851.34600830078, 4.4748911857605, 215.81349182129),
    vector4(-1054.9798583984, -849.21118164063, 4.4743595123291, 216.47830200195),
    vector4(-1052.1146240234, -847.17211914063, 4.4742436408997, 219.34120178223),
    vector4(-1047.6822509766, -846.54187011719, 4.4742650985718, 215.94868469238),
    vector4(-1039.9312744141, -855.85925292969, 4.484121799469, 61.242832183838),
    vector4(-1042.2041015625, -858.88641357422, 4.4951553344727, 60.308723449707),
    vector4(-1045.2904052734, -861.26391601563, 4.5224432945251, 59.472263336182),
    vector4(-1048.1364746094, -865.01666259766, 4.6711006164551, 235.95852661133),
    vector4(-1051.6546630859, -867.56799316406, 4.7890930175781, 58.965156555176),
    vector4(-1069.6568603516, -878.66918945313, 4.5044069290161, 29.255399703979),
    vector4(-1072.6293945313, -880.328125, 4.4300155639648, 27.023773193359),
    vector4(-1076.3111572266, -882.57110595703, 4.3359618186951, 31.309888839722),
    vector4(-1079.6446533203, -884.19110107422, 4.2593250274658, 30.147357940674)
}

CreateThread(function()
    while zone == nil do Wait(1) end

    local pedsData = {
        { model = "s_m_y_sheriff_01", position = vector3(1715.9, 3874.52, 34.04), heading = 138.5, scenario = "WORLD_HUMAN_CLIPBOARD" }, -- pnj accueil
        { model = "s_m_y_sheriff_01", position = vector3(2824.93, 4732.19, 47.63), heading = 268.48, scenario = "WORLD_HUMAN_CLIPBOARD" }, -- pnj accueil
        { model = "s_m_y_sheriff_01", position = vector3(1721.11, 3869.0, 38.78), heading = 45.39, scenario = "WORLD_HUMAN_CLIPBOARD" }, -- helico dealer sandy
        { model = "s_m_y_sheriff_01", position = vector3(2761.39, 4834.6, 46.37), heading = 119.34, scenario = "WORLD_HUMAN_CLIPBOARD" }, -- helico dealer Grapeseed
        { model = "s_m_y_sheriff_01", position = vector3(1423.99, 3880.8, 30.85), heading = 165.93,           scenario = "WORLD_HUMAN_CLIPBOARD" }, -- car dealer bateau
        { model = "s_m_y_sheriff_01", position = vector3(1730.88, 3882.35, 33.9),  heading = 249.79, scenario = "WORLD_HUMAN_CLIPBOARD" }, -- cardealer Sandy
        { model = "s_m_y_sheriff_01", position = vector3(1729.42, 3888.8, 30.45), heading = 297.26,          scenario = "WORLD_HUMAN_CLIPBOARD" }, -- tenues Sandy
        { model = "s_m_y_sheriff_01", position = vector3(2799.89, 4706.35, 47.63), heading = 332.22,          scenario = "WORLD_HUMAN_CLIPBOARD" }, -- tenues Grapeseed
        { model = "s_m_y_sheriff_01", position = vector3(1740.56, 3894.82, 30.45),  heading = 73.26, scenario = "WORLD_HUMAN_CLIPBOARD" }, -- armurerie sandy
        { model = "s_m_y_sheriff_01", position = vector3(1738.25, 3893.03, 30.45),                             heading = 333.92, scenario = "WORLD_HUMAN_CLIPBOARD" }, --badge
        { model = "s_m_y_sheriff_01", position = vector3(2809.16, 4719.96, 47.63),  heading = 334.19,          scenario = "WORLD_HUMAN_CLIPBOARD" }, -- armurerie Grapeseed
        { model = "s_m_y_sheriff_01", position = vector3(2841.45, 4766.57, 46.37), heading = 60.3,          scenario = "WORLD_HUMAN_CLIPBOARD" }, -- Grepseed car deadler
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

lssdDuty = false

function LoadLssdJob()
    local casierPos = {
        vector3(2805.77, 4710.72, 47.63)
    }

    zone.addZone("society_lssd1", vector3(1736.91, 3899.56, 39.78), -- Sandy
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les actions d'entreprise", function()
            OpenSocietyMenu() -- TODO: fini le menu society
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
        "society_lssd_custom", -- Grapeseed
        vector3(2820.3325195313, 4828.01171875, 47.182415008545),
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
        false,       -- Avoir un marker ou non
        -1,          -- Id / type du marker
        0.6,         -- La taille
        { 0, 0, 0 }, -- RGB
        0,           -- Alpha
        1.5,
        true,
        "bulleCustom"
    )
    zone.addZone(
        "society_lssd2_custom",
        vector3(1747.68, 3884.56, 34.68),
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
        false,       -- Avoir un marker ou non
        -1,          -- Id / type du marker
        0.6,         -- La taille
        { 0, 0, 0 }, -- RGB
        0,           -- Alpha
        1.5,
        true,
        "bulleCustom"
    )

    zone.addZone("society_lssd2", vector3(2781.48, 4743.82, 47.63), -- Grapeseed
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les actions d'entreprise", function()
            OpenSocietyMenu() -- TODO: fini le menu society
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

    -- armurerie 
    zone.addZone("lssd_item", vector3(1740.02, 3895.08, 31.45), -- Snady
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir l'armurerie ",
        function()
            OpenLssdItemMenu()
        end,
        false,           -- Avoir un marker ou non
        29,              -- Id / type du marker
        1.0,             -- La taille
        { 50, 168, 82 }, -- RGB
        170,             -- Alpha
        2.0,
        true,
        "bulleArmurerie"
    )

    -- armurerie Grapeseed
    zone.addZone("lssd_item_2", vector3(2809.27, 4720.16, 49.63), -- Grepeseed
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir l'armurerie ",
        function()
            OpenLssdItemMenu()
        end,
        false,           -- Avoir un marker ou non
        29,              -- Id / type du marker
        1.0,             -- La taille
        { 50, 168, 82 }, -- RGB
        170,             -- Alpha
        2.0,
        true,
        "bulleArmurerie"
    )

    -- DEV
    zone.addZone("lssd_vest", vector3(2799.89, 4706.35, 49.63), -- Grepseed
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le vestiaire",
        function()
            LSSDVestiaireDev()
        end, false,
        27,
        0.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleVetement"
    )

    zone.addZone("lssd_vest_2", vector3(1729.63, 3888.86, 31.45), -- Sandy
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le vestiaire",
        function()
            LSSDVestiaireDev()
        end, false,
        27,
        0.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleVetement"
    )

    zone.addZone("lssd_vest_3", vector3(1833.8588867188, 2574.8955078125, 46.014408111572), -- Prison
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le vestiaire",
        function()
            LSSDVestiaireDev()
        end, false,
        27,
        0.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleVetement"
    )

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
                        for k, v in pairs(lssd.outfit) do
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

    local items = {

        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Banners/LSSD.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Banners/icon.webp',
        headerIconName = 'CATALOGUE',
        callbackName = 'armoryTakeLSSD',
        showTurnAroundButtons = false,
        multipleSelection = true,
        elements = {
            {
                price = 0,
                id = 1,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lssdshield.webp",
                name = "lssdshield",
                label = "Bouclier anti-émeute",
            },
            {
                price = 0,
                id = 2,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/weapon_fireextinguisher.webp",
                name = "weapon_fireextinguisher",
                label = "Extincteur",
            },
            {
                price = 0,
                id = 3,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Fumigene.webp",
                name = "weapon_smokelspd",
                label = "Fumigene",
            },
            {
                price = 0,
                id = 4,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Fusee_detresse.webp",
                name = "weapon_flare",
                label = "Fusée de détresse",
            },
            {
                price = 0,
                id = 5,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Gaz_bz.webp",
                name = "weapon_bzgas",
                label = "GAZ BZ",
            },
            {
                price = 0,
                id = 6,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lssdgiletj.webp",
                name = "lssdgiletj",
                label = "Gilet Jaune",
            },
            {
                price = 0,
                id = 7,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lssdkevle1.webp",
                name = "lssdkevle1",
                label = "Kevlar Class A",
            },
            {
                price = 0,
                id = 8,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lssdkevlo1.webp",
                name = "lssdkevlo1",
                label = "Kevlar Class C 1",
            },
            {
                price = 0,
                id = 9,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lssdkevlo2.webp",
                name = "lssdkevlo2",
                label = "Kevlar Class C 2",
            },
            {
                price = 0,
                id = 10,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lssdkevlo3.webp",
                name = "lssdkevlo3",
                label = "Kevlar Class C 3",
            },
            {
                price = 0,
                id = 11,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lssdkevlo4.webp",
                name = "lssdkevlo4",
                label = "Kevlar Class C 4",
            },
            {
                price = 0,
                id = 12,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lssdinsigne.webp",
                name = "lssdinsigne",
                label = "LSSD - Insigne",
            },
            {
                price = 0,
                id = 13,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lssdriot.webp",
                name = "lssdriot",
                label = "Protection Anti Emeute",
            },
            {
                price = 0,
                id = 14,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lssdkevle2.webp",
                name = "lssdkevle2",
                label = "Gilet Pare-Couteau",
            },
            {
                price = 0,
                id = 15,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lssdkevlo5.webp",
                name = "lssdkevlo5",
                label = "Kevlar Class C 5",
            },
            {
                price = 0,
                id = 16,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lssdkevlo6.webp",
                name = "lssdkevlo6",
                label = "Kevlar Class C 6",
            },
            {
                price = 0,
                id = 17,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lssdkevlo7.webp",
                name = "lssdkevlo7",
                label = "Kevlar Class C 7",
            },
            {
                price = 0,
                id = 18,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Fumigene.webp",
                name = "weapon_pepperspray",
                label = "PepperSpray",
            },
            {
                price = 0,
                id = 19,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/radio.webp",
                name = "radio",
                label = "Radio"
            },
			{
				price = 0,
				id = 19,
				image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/tabletmdt.webp",
				name = "tabletmdt",
				label = "Tablette MDT"
			}
        },
    }
    function OpenLssdItemMenu()
        OpenLSSDMENUItems = true
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogueAchat',
            data = items
        }));
    end

    zone.addZone("stockage_lssd", vector3(2814.5180664063, 4724.8842773438, 47.627300262451), -- Only Grapeseed
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le coffre des saisies", function()
            OpenInventorySocietyMenu() -- TODO: fini le menu society
        end, false, 25,                -- Id / type du marker
        0.6,                           -- La taille
        { 51, 204, 255 },              -- RGB
        170                            -- Alpha
    )

    for k, v in pairs(casierPos) do
        zone.addZone("coffre_lssd" .. k, v, "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les casiers",
            function()
                OpenlspdCasier() -- TODO: fini le menu society
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

    zone.addZone(
        "spawn_lssd_heli",
        vector3(2761.4479980469, 4834.5888671875, 46.371734619141), -- GrapeSeed
        "~INPUT_CONTEXT~ Garage",
        function()
            openGarageHeliLSSDMenu()
        end,
        true,
        25,               -- Id / type du marker
        0.6,              -- La taille
        { 51, 204, 255 }, -- RGB
        170               --
    )

    zone.addZone(
        "society_lssdHeli_delete",
        vector3(2752.1892089844, 4850.8046875, 47.3717918396), -- GrapeSeed
        "~INPUT_CONTEXT~ Ranger le véhicule",
        function()
            if IsPedInAnyVehicle(p:ped(), false) then
                local veh = GetVehiclePedIsIn(p:ped(), false)
                --removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                DeleteEntity(veh)
            end
        end,
        true,
        36, 0.5, { 255, 0, 0 }, 255
    )

    zone.addZone(
        "spawn_lssd_heli2", -- Sandy
        vector3(1721.11, 3869.0, 38.78),
        "~INPUT_CONTEXT~ Garage",
        function()
            openGarageHeliLSSDMenu()
        end,
        true,
        25,               -- Id / type du marker
        0.6,              -- La taille
        { 51, 204, 255 }, -- RGB
        170               --
    )

    zone.addZone(
        "Heli2_delete",
        vector3(1730.23, 3862.41, 40.98), -- Sandy
        "~INPUT_CONTEXT~ Ranger le véhicule",
        function()
            if IsPedInAnyVehicle(p:ped(), false) then
                local veh = GetVehiclePedIsIn(p:ped(), false)
                --removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                DeleteEntity(veh)
            end
        end,
        true,
        36, 0.5, { 255, 0, 0 }, 255
    )
    zone.addZone(
        "spawn_lssd_boat",
        vector3(1423.99, 3880.52, 30.85),
        "~INPUT_CONTEXT~ Garage",
        function()
            openGarageLSSDBoatMenu()
        end, false,
        27,
        1.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleGarage"
    )
    zone.addZone(
        "society_lssdBoat_delete",
        vector3(1412.75, 3876.78, 30.03),
        "~INPUT_CONTEXT~ Ranger le véhicule",
        function()
            if IsPedInAnyVehicle(p:ped(), false) then
                local veh = GetVehiclePedIsIn(p:ped(), false)
                --removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                DeleteEntity(veh)
            end
        end, false,
        27,
        1.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleGarage"
    )

    local openRadial = false

    local open = false
    local lspdmenu_objects = RageUI.CreateMenu("", "LSSD", 0.0, 0.0, "vision", "menu_title_police")
    local lspdmenu_traffic = RageUI.CreateMenu("", "LSSD", 0.0, 0.0, "vision", "menu_title_police")
    local lspdmenu_traffic_add = RageUI.CreateSubMenu(lspdmenu_traffic, "", "LSSD", 0.0, 0.0, "vision",
        "menu_title_police")
    local lspdmenu_traffic_view = RageUI.CreateSubMenu(lspdmenu_traffic, "", "LSSD", 0.0, 0.0, "vision",
        "menu_title_police")
    local lspdmenu_objects_delete = RageUI.CreateSubMenu(lspdmenu_objects, "", "LSSD", 0.0, 0.0, "vision",
        "menu_title_police")
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
        if lssdDuty then
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
                            RageUI.Button("Ajouter une zone", nil, { RightLabel = ">" }, true, {
                                onSelected = function()
                                    zonePos = p:pos()
                                end
                            }, lspdmenu_traffic_add)
                            -- for the second button to view my zones, it opens a menu where i can see all my zones and delete them
                            RageUI.Button("Voir les zones", nil, { RightLabel = ">" }, true, {
                                onSelected = function()
                                    traficList = TriggerServerCallback("lspd:traffic:get")
                                end
                            }, lspdmenu_traffic_view)
                        end)
                        RageUI.IsVisible(lspdmenu_traffic_add, function()
                            -- for the speed and radius button, prompt a keyboard to enter the value
                            RageUI.Button("Vitesse", nil, { RightLabel = speed .. " km/h" }, true, {
                                onSelected = function()
                                    speed = tonumber(KeyboardImput("Vitesse")) + .0
                                    if speed == nil then
                                        speed = 0.0
                                    end
                                end
                            })
                            RageUI.Button("Rayon", nil, { RightLabel = radius .. " m" }, true, {
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
                            RageUI.Button("Nom de la zone", nil, { RightLabel = zoneName }, true, {
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
                                            duration = 5, -- In seconds, default:  4
                                            content = "~s Zone ajoutée"
                                        })
                                        open = false
                                        RageUI.CloseAll()
                                    else
                                        -- ShowNotification("~r~Veuillez remplir tous les champs")

                                        -- New notif
                                        exports['vNotif']:createNotification({
                                            type = 'ROUGE',
                                            duration = 5, -- In seconds, default:  4
                                            content = "~s Veuillez remplir tous les champs"
                                        })
                                    end
                                end
                            })
                        end)
                        RageUI.IsVisible(lspdmenu_traffic_view, function()
                            for k, v in pairs(traficList) do
                                RageUI.Button(v.zoneId .. " | " .. v.zoneName, nil, { RightLabel = "~r~ Supprimer" },
                                    true,
                                    {
                                        onSelected = function()
                                            RemoveRoadNodeSpeedZone(v.zoneId)
                                            TriggerServerEvent("lspd:traffic:remove", v.zoneId)
                                            -- ShowNotification("~r~Zone supprimée")

                                            -- New notif
                                            exports['vNotif']:createNotification({
                                                type = 'VERT',
                                                duration = 5, -- In seconds, default:  4
                                                content = "~s Zone supprimée"
                                            })
                                            RageUI.GoBack()
                                        end,
                                        onActive = function()
                                            local distance = v.zoneRadius + .0
                                            DrawMarker(1, v.zonePos + vector3(0.0, 0.0, -1000.0), 0.0, 0.0, 0.0, 0.0, 0.0,
                                                .0
                                                , distance + .0, distance + .0, 10000.0, 20, 192, 255, 70, 0, 0, 2
                                                , 0, 0, 0, 0)
                                        end
                                    })
                            end
                        end)
                        if show then
                            -- draw circle around player with the radius of the zone
                            local distance = radius + .0
                            DrawMarker(1, p:pos() + vector3(0.0, 0.0, -1000.0), 0.0, 0.0, 0.0, 0.0, 0.0, .0,
                                distance + .0,
                                distance + .0, 10000.0, 20, 192, 255, 70, 0, 0, 2, 0, 0, 0, 0)
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
                duration = 5, -- In seconds, default:  4
                content = "Vous n'êtes ~s pas en service"
            })
        end
    end

    function lssdActionDuty()
        openRadial = false
        closeUI()
        if lssdDuty then
            TriggerServerEvent('core:DutyOff', 'lssd')
            --[[             ShowAdvancedNotification("Centrale", "~b~Dispatch", "Vous avez quitté votre service", "CHAR_CALL911",
                "CHAR_CALL911") ]]

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s quitté ~c votre service"
            })

            lssdDuty = false
            Wait(5000)
        else
            TriggerServerEvent('core:DutyOn', 'lssd')
            --[[             ShowAdvancedNotification("Centrale", "~b~Dispatch", "Vous avez pris votre service", "CHAR_CALL911",
                "CHAR_CALL911") ]]
            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s pris ~c votre service"
            })

            lssdDuty = true
            Wait(5000)
        end
    end

    function FactureLSSD()
        if lssdDuty then
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

    function ConvocationLSSD()
        if lssdDuty then
            openRadial = false
            closeUI()
            TriggerEvent("nuiPapier:client:startCreation", 5, 'https://cdn.sacul.cloud/v2/vision-cdn/entrepriseCarre/lssd.webp')
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function DepositionLSSD()
        if lssdDuty then
            openRadial = false
            closeUI()
            TriggerEvent("nuiPapier:client:startCreation", 4, "https://cdn.sacul.cloud/v2/vision-cdn/entrepriseCarre/lssd.webp")
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function makeRenfortCall()
        if lssdDuty then
            TriggerSecurEvent('core:makeCall', "lssd", p:pos(), false,
                "Appel de renfort (" .. p:getLastname() .. " " .. p:getFirstname() .. ")")
            TriggerSecurEvent('core:makeCall', "lspd", p:pos(), false,
                "Appel de renfort (" .. p:getLastname() .. " " .. p:getFirstname() .. ")") -- FIX_LSSD_LSPD
            ExecuteCommand("me fait un appel de renfort")
            --p:PlayAnim('amb@code_human_police_investigate@idle_a', 'idle_b', 51)
            openRadial = false
            closeUI()
            --Modules.UI.RealWait(10000)
            --ClearPedTasks(p:ped())
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
        if lssdDuty then
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

    Keys.Register("F2", "F2", "Faire un appel de renfort", function()
        makeRenfortCall()
    end)

    function makePanicCall()
        if lssdDuty then
            TriggerSecurEvent('core:makeCall', "lssd", p:pos(), false,
                "PANIC BUTTON (" .. p:getLastname() .. " " .. p:getFirstname() .. ")")
            ExecuteCommand("me fait un appel de renfort")
            -- p:PlayAnim('amb@code_human_police_investigate@idle_a', 'idle_b', 51)
            openRadial = false
            closeUI()
            -- Modules.UI.RealWait(10000)
            -- ClearPedTasks(p:ped())
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

    function OpenRadialLssdMenu()
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
                function OpenSubRadialRenfort()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = {
                            elements = { {
                                name = "APPEL DE RENFORT",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/police_logo.svg",
                                action = "makeRenfortCall"
                            }, {
                                name = "PANIC BUTTON",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/police_logo.svg",
                                action = "makePanicCall"
                            } },
                            title = "RENFORT"
                        }
                    }));
                end

                function OpenSubRadialPapiers()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = {
                            elements = {
                                {
                                    name = "CONVOCATION",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/top_paper.svg",
                                    action = "ConvocationLSSD"
                                },
                                {
                                    name = "FACTURE",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/billet.svg",
                                    action = "FactureLSSD"
                                },
                                {
                                    name = "RETOUR",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                    action = "OpenMainRadialLSSD"
                                },
                                {
                                    name = "DEPOSITION",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/paper.svg",
                                    action = "DepositionLSSD"
                                }
                            },
                            title = "PAPIERS",
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
                                    name = "ANNONCE",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/megaphone.svg",
                                    action = "CreateAdvert"
                                },
                                {
                                    name = "CIRCULATION",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/road.svg",
                                    action = "openTraficMenu"
                                },
                                {
                                    name = "RETOUR",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                    action = "OpenMainRadialLSSD"
                                },
                                {
                                    name = "OBJETS",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/object.svg",
                                    action = "OpenPropsMenuLSSD"
                                }
                            },
                            title = "ACTIONS",
                        }
                    }));
                end

                function OpenMainRadialLSSD()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = {
                            elements = {
                                {
                                    name = "APPEL DE RENFORT",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/police_logo.svg",
                                    action = "OpenSubRadialRenfort"
                                },
                                {
                                    name = "PAPIERS",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/paper.svg",
                                    action = "OpenSubRadialPapiers"
                                },
                                {
                                    name = "PRISE DE SERVICE",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/checkmark.svg",
                                    action = "lssdActionDuty"
                                },
                                {
                                    name = "ACTIONS",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/police.svg",
                                    action = "OpenSubRadialActions"
                                }
                            },
                            title = "LSSD"
                        }
                    }));
                end

                OpenMainRadialLSSD()
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

    RegisterJobMenu(OpenRadialLssdMenu)


    zone.addZone(
        "lssd_vehicule",
        vector3(2841.45, 4766.57, 48.37),
        "~INPUT_CONTEXT~ Garage",
        function()
            openLSSDGarageMenu()
            forceHideRadar()
        end, false,
        27,
        1.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleGarage"
    )

    -- zone.addZone(
    --     "lssd_vehicule_vespucci",
    --     vector3(-1076.54, -856.02, 5.04),
    --     "~INPUT_CONTEXT~ Garage",
    --     function()
    --         openLSSDGarageMenuVespucci()
    --         forceHideRadar()
    --     end, false,
    --     27,
    --     1.5,
    --     { 255, 255, 255 },
    --     170,
    --     2.0,
    --     true,
    --     "bulleGarage"
    -- )

    zone.addZone(
        "lssd_vehicule_delete", vector3(2840.8173828125, 4786.009765625, 47.171337127686),
        "Appuyer sur ~INPUT_CONTEXT~ pour rentrer dans le garage", function()
            if IsPedInAnyVehicle(p:ped(), false) then
                local veh = GetVehiclePedIsIn(p:ped(), false)
                --removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                DeleteEntity(veh)
            end
        end, false,
        27,
        3.0,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleGarage"
    )



    zone.addZone(
        "lssd_vehicule2",
        vector3(1731.41, 3881.99, 33.9),
        "~INPUT_CONTEXT~ Garage",
        function()
            openLSSDGarageMenu()
            forceHideRadar()
        end, false,
        27,
        3.0,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleGarage"
    )

    zone.addZone(
        "lssd_vehicule2_delete", vector3(1750.95, 3878.99, 34.65),
        "Appuyer sur ~INPUT_CONTEXT~ pour rentrer dans le garage", function()
            if IsPedInAnyVehicle(p:ped(), false) then
                local veh = GetVehiclePedIsIn(p:ped(), false)
                --removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                DeleteEntity(veh)
            end
        end, false,
        27,
        3.0,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleGarage"
    )

    zone.addZone(
        "lssd_vehicule_delete_vespucci", vector3(-1069.8516845703, -855.00463867188, 4.8674259185791),
        "Appuyer sur ~INPUT_CONTEXT~ pour rentrer dans le garage", function()
            if IsPedInAnyVehicle(p:ped(), false) then
                local veh = GetVehiclePedIsIn(p:ped(), false)
                --removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                DeleteEntity(veh)
            end
        end, false,
        27,
        3.0,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleGarage"
    )

    local listVeh = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_lssd.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/LSPD/logo_vehicule.webp',
        headerIconName = 'VEHICULE',
        callbackName = 'Menu_LSSD_vehicule_callback',
        elements = {{
            label = 'Stanier',
            spawnName = 'lssdstanier1',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lssdstanier1.webp",
            category = 'Grades',
            subCategory = 'Deputy'
        },{
            label = 'Scout 2016 Valor',
            spawnName = 'lssdscoutnew2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lssdscoutnew2.webp",
            category = 'Grades',
            subCategory = 'Deputy'
        },{
            label = 'Alamo 2500 LS',
            spawnName = 'lssdalamonew2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lssdalamonew2.webp",
            category = 'Grades',
            subCategory = 'Deputy'
        },{
            label = 'Fugitive',
            spawnName = 'sherifffug',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/sherifffug.webp",
            category = 'Grades',
            subCategory = 'Deputy I'
        },{
            label = 'Alamo 2500LS Pushbar',
            spawnName = 'lssdalamonew3',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lssdalamonew3.webp",
            category = 'Grades',
            subCategory = 'Deputy I'
        },{
            label = 'Everon',
            spawnName = 'lspdeveron',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lspdeveron.webp",
            category = 'Grades',
            subCategory = 'Deputy I'
        },{
            label = 'Torrence',
            spawnName = 'lspdtorrence',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lspdtorrence.webp",
            category = 'Grades',
            subCategory = 'Deputy II'
        },{
            label = 'Landstalker XL',
            spawnName = 'sheriffstalker',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/sheriffstalker.webp",
            category = 'Grades',
            subCategory = 'Deputy II'
        },{
            label = 'Caracara',
            spawnName = 'lspdcara',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lspdcara.webp",
            category = 'Grades',
            subCategory = 'Deputy II'
        },{
            label = 'Scout 2020',
            spawnName = 'lssd2020scout',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lssd2020scout.webp",
            category = 'Grades',
            subCategory = 'Deputy III'
        },{
            label = 'Buffalo 2009',
            spawnName = 'lspdbuffalo',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lspdbuffalo.webp",
            category = 'Grades',
            subCategory = 'Senior Lead Deputy'
        },{
            label = 'Gresley Slicktop',
            spawnName = 'polgresleyg',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/polgresleyg.webp",
            category = 'Grades',
            subCategory = 'Senior Lead Deputy'
        },{
            label = 'Buffalo 2013',
            spawnName = 'lspbuffalos',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lspdbuffalos.webp",
            category = 'Grades',
            subCategory = 'SUPERVISOR'
        },{
            label = 'Buffalo 2013 ST',
            spawnName = 'polbuffalosslick',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/polbuffalosslick.webp",
            category = 'Grades',
            subCategory = 'SUPERVISOR'
        },{
            label = 'Torrence ST',
            spawnName = 'lspdtorrenceslick',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lspdtorrenceslick.webp",
            category = 'Grades',
            subCategory = 'SUPERVISOR'
        },{
            label = 'Stanier ST',
            spawnName = 'lssdstanier2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lssdstanier2.webp",
            category = 'Grades',
            subCategory = 'SUPERVISOR'
        },{
            label = 'Scout 2020 ST',
            spawnName = 'lspd2020scoutumk',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lspd2020scoutumk.webp",
            category = 'Grades',
            subCategory = 'SUPERVISOR'
        },{
            label = 'Scout 2016 ST',
            spawnName = 'lssdscoutnew2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lssdscoutnew2.webp",
            category = 'Grades',
            subCategory = 'SUPERVISOR'
        },{
            label = 'STX ST',
            spawnName = 'polbuffalog',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/polbuffalog.webp",
            category = 'Grades',
            subCategory = 'Execitive Staff'
        },{
            label = 'Sheriff Ghost',
            spawnName = 'sheriffghost',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/sheriffghost.webp",
            category = 'Grades',
            subCategory = 'Execitive Staff'
        },{
            label = 'Scout 2020 K9',
            spawnName = 'lspdscout3k9',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lspdscout3k9.webp",
            category = 'Division',
            subCategory = 'K-9 Unit'
        },{
            label = 'Alamo 2500LS K9',
            spawnName = 'lssdalamonew1',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lssdalamonew1.webp",
            category = 'Division',
            subCategory = 'K-9 Unit'
        },{
            label = 'Buffalo 13 ST K9',
            spawnName = 'polbuffalosslick',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/polbuffalosslick.webp",
            category = 'Division',
            subCategory = 'K-9 Unit'
        },{
            label = 'Alamo 2500 ST',
            spawnName = 'polalamog2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/polalamog2.webp",
            category = 'Division',
            subCategory = 'SRG'
        },{
            label = 'Gresley ST',
            spawnName = 'polgresleyg',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/polgresleyg.webp",
            category = 'Division',
            subCategory = 'SRG'
        },{
            label = 'Alamo 2500 UMK',
            spawnName = 'polalamog2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/polalamog2.webp",
            category = 'Division',
            subCategory = 'SEB'
        },{
            label = 'Gresley UMK',
            spawnName = 'polgresleyg',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/polgresleyg.webp",
            category = 'Division',
            subCategory = 'SEB'
        },{
            label = 'STX UMK',
            spawnName = 'lspdbuffsx',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lspdbuffsx.webp",
            category = 'Division',
            subCategory = 'SEB'
        },{
            label = 'Torrence ST',
            spawnName = 'lspdtorrenceslick',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lspdtorrenceslick.webp",
            category = 'Division',
            subCategory = 'CIO'
        },{
            label = 'Stanier ST',
            spawnName = 'lssdstanier2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lssdstanier2.webp",
            category = 'Division',
            subCategory = 'CIO'
        },{
            label = 'Scout 2020 UMK',
            spawnName = 'lspd2020scoutumk',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lspd2020scoutumk.webp",
            category = 'Division',
            subCategory = 'CIO'
        },{
            label = 'Scout 2016 UMK',
            spawnName = 'LSPDumkscout16',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/LSPDumkscout16.webp",
            category = 'Division',
            subCategory = 'CIO'
        },{
            label = 'Landstalker UMK',
            spawnName = 'polstalkerumk',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/polstalkerumk.webp",
            category = 'Division',
            subCategory = 'CIO'
        },{
            label = 'Stanier UMK',
            spawnName = 'lssdstanier2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lssdstanier2.webp",
            category = 'Division',
            subCategory = 'CIO'
        },{
            label = 'Greenwood UMK',
            spawnName = 'fbigreenwd',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/fbigreenwd.webp",
            category = 'Division',
            subCategory = 'CIO'
        },{
            label = 'Buffalo 13 UMK',
            spawnName = 'polbuffalosslick',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/polbuffalosslick.webp",
            category = 'Division',
            subCategory = 'CIO'
        },{
            label = 'Buffalo 09 UMK',
            spawnName = 'lspdbuffaloum',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lspdbuffaloum.webp",
            category = 'Division',
            subCategory = 'CIO'
        },{
            label = 'Fugitive UMK',
            spawnName = 'sherifffug2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/sherifffug2.webp",
            category = 'Division',
            subCategory = 'CIO'
        },{
            label = 'Caracara UMK',
            spawnName = 'lspdcara2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lspdcara2.webp",
            category = 'Division',
            subCategory = 'CIO'
        },{
            label = 'Sultan UMK',
            spawnName = 'sultanumk',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/sultanumk.webp",
            category = 'Division',
            subCategory = 'CIO'
        },{
            label = 'Oracle UMK',
            spawnName = 'poloracleumk',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/poloracleumk.webp",
            category = 'Division',
            subCategory = 'CIO'
        },{
            label = 'Everon UMK',
            spawnName = 'loweveron',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/loweveron.webp",
            category = 'Division',
            subCategory = 'CIO'
        },{
            label = 'Greenwood',
            spawnName = 'shergreenwd',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/shergreenwd.webp",
            category = 'Division',
            subCategory = 'CRO'
        },{
            label = 'Impaler 1993 Vector',
            spawnName = 'sheriffimp95a',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/sheriffimp95a.webp",
            category = 'Division',
            subCategory = 'CRO'
        },{
            label = 'Roamer',
            spawnName = 'sheriffroamer',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/sheriffroamer.webp",
            category = 'Division',
            subCategory = 'CRO'
        },{
            label = 'Raiden Homelander',
            spawnName = 'lspdraiden',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lspdraiden.webp",
            category = 'Division',
            subCategory = 'CRO'
        },{
            label = 'Alamo Old',
            spawnName = 'sheriffalamoold',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/sheriffalamoold.webp",
            category = 'Division',
            subCategory = 'CRO'
        },{
            label = 'Riata Old',
            spawnName = 'sheriffriataold',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/sheriffriataold.webp",
            category = 'Division',
            subCategory = 'CRO'
        },{
            label = 'Brigham',
            spawnName = 'sheriffold2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/sheriffold2.webp",
            category = 'Division',
            subCategory = 'CRO'
        },{
            label = 'STX VALOR',
            spawnName = 'polbuffalor',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/polbuffalor.webp",
            category = 'Division',
            subCategory = 'TEB'
        },{
            label = 'WinterGreen',
            spawnName = 'lspdwintergreen',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lspdwintergreen.webp",
            category = 'Division',
            subCategory = 'TEB'
        },{
            label = 'Torrence Valor',
            spawnName = 'lspdtorrencevalor',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lspdtorrencevalor.webp",
            category = 'Division',
            subCategory = 'TEB'
        },{
            label = 'SAR Utility',
            spawnName = 'sheriffsar',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/sheriffsar.webp",
            category = 'Divers',
            subCategory = 'Divers'
        },{
            label = 'Riata SR',
            spawnName = 'riatasr',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/riatasr.webp",
            category = 'Divers',
            subCategory = 'Divers'
        },{
            label = 'Enduro',
            spawnName = 'sheriffenduro',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/sheriffenduro.webp",
            category = 'Divers',
            subCategory = 'Divers'
        },{
            label = 'Verus',
            spawnName = 'polverus',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/polverus.webp",
            category = 'Divers',
            subCategory = 'Divers'
        },{
            label = 'Sadler',
            spawnName = 'sheriffoffroad',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/sheriffoffroad.webp",
            category = 'Divers',
            subCategory = 'Divers'
        },{
            label = 'VTT',
            spawnName = 'lspdcycle',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lspdcycle.webp",
            category = 'Divers',
            subCategory = 'Divers'
        },{
            label = 'MOC',
            spawnName = 'mocpacker',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/mocpacker.webp",
            category = 'Divers',
            subCategory = 'Divers'
        },{
            label = 'Bus',
            spawnName = 'lssdbus',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lssdbus.webp",
            category = 'Divers',
            subCategory = 'Divers'
        },{
            label = 'LSSD Speedo',
            spawnName = 'lspdspeedo',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lspdspeedo.webp",
            category = 'Divers',
            subCategory = 'Divers'
        },{
            label = 'Mule',
            spawnName = 'lssdmule',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/lssdmule.webp",
            category = 'Divers',
            subCategory = 'Divers'
        },{
            label = 'Rumpo',
            spawnName = 'sheriffrumpo',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/sheriffrumpo.webp",
            category = 'Divers',
            subCategory = 'Divers'

        },{
            label = 'Parking Pigeon',
            spawnName = 'pigeonp',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/pigeonp.webp",
            category = 'Divers',
            subCategory = 'Divers'
        }}        
    }

	local listVehVP = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_lssd.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/LSPD/logo_vehicule.webp',
        headerIconName = 'VEHICULE',
        callbackName = 'Menu_LSSD_vehicule_callback_vespucci',
        elements = listVeh.elements,
    }


    function openLSSDGarageMenu()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listVeh
        }))
    end

    function openLSSDGarageMenuVespucci()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listVehVP
        }))
    end

    local listHeli = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_lssd.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/LSPD/logo_vehicule.webp',
        headerIconName = 'HÉLICOPTÈRES',
        callbackName = 'Menu_LSSD_heli_callback',
        elements = {
            {
                label = 'Maverick',
                spawnName = 'lspdmav',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/lspdmav.webp",
                category = 'Division',
                subCategory = 'AIR SUPPORT UNIT'
            },
            {
                label = 'SuperPuma ASU',
                spawnName = 'as332',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/as332.webp",
                category = 'Division',
                subCategory = 'AIR SUPPORT UNIT'
            },
            {
                label = 'SuperPuma SEB',
                spawnName = 'as332',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/as332seb.webp",
                category = 'Division',
                subCategory = 'SPECIAL ENFORCEMENT BUREAU'
            },
            {
                label = 'Buzzard SEB',
                spawnName = 'mh6',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/NewPack/mh6.webp",
                category = 'Division',
                subCategory = 'SPECIAL ENFORCEMENT BUREAU'
            },
        }
    }

    function openGarageHeliLSSDMenu()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listHeli
        }))
    end

    local listBoat = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_lssd.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/LSPD/logo_vehicule.webp',
        headerIconName = 'BATEAUX',
        callbackName = 'Menu_LSSD_boat_callback',
        elements = {
            {
                label = 'Predator',
                spawnName = 'polpreda',
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/polpreda.webp",
                category = 'Division',
                subCategory = 'NRT'
            },
        }
    }

    function openGarageLSSDBoatMenu()
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


    RegisterNetEvent("core:lspdGetVehGarage")
    AddEventHandler("core:lspdGetVehGarage", function(data)
        allVehicleList = data
    end)

    RegisterNetEvent("core:lspdSpawnVehicle")
    AddEventHandler("core:lspdSpawnVehicle", function(data)
        currentVeh = data
        local veh = vehicle.create(data.name,
            vector4(-1061.701171875, -853.28356933594, 4.475266456604, 218.39852905273), {}) -- VP
    end)

    local casierOpen = false
    function OpenlspdCasier()
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


    local function GetDatasProps()
        -- DataSendPropsLSSD.items.elements = {}

        local playerJobs = 'lspd-lssd'

        -- Cones
        for i = 1, 10 do
            table.insert(DataSendPropsLSSD.items[2].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/Cones/" .. i .. ".webp",
                category = "Cones",
                label = "#" .. i
            })
        end


        -- Panneaux
        for i = 1, 45 do
            table.insert(DataSendPropsLSSD.items[3].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/Panneaux/" .. i .. ".webp",
                category = "Panneaux",
                label = "#" .. i
            })
        end

        -- Barrière
        for i = 1, 23 do
            table.insert(DataSendPropsLSSD.items[4].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/Barrieres/" .. i .. ".webp",
                category = "Barrières",
                label = "#" .. i
            })
        end

        -- Lumières
        for i = 1, 5 do
            table.insert(DataSendPropsLSSD.items[5].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/Lumieres/" .. i .. ".webp",
                category = "Lumières",
                label = "#" .. i
            })
        end

        -- Tables
        for i = 1, 2 do
            table.insert(DataSendPropsLSSD.items[6].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/Tables/" .. i .. ".webp",
                category = "Tables",
                label = "#" .. i
            })
        end

        -- Drogues
        for i = 1, 9 do
            table.insert(DataSendPropsLSSD.items[7].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/Drogues/" .. i .. ".webp",
                category = "Drogues",
                label = "#" .. i
            })
        end

        -- Divers
        for i = 1, 4 do
            table.insert(DataSendPropsLSSD.items[8].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/Divers/" .. i .. ".webp",
                category = "Divers",
                label = "#" .. i
            })
        end

        -- Cible Tir
        for i = 1, 2 do
            table.insert(DataSendPropsLSSD.items[9].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/CiblesTir/" .. i .. ".webp",
                category = "Cibles Tir",
                label = "#" .. i
            })
        end

        -- Sacs
        for i = 1, 2 do
            table.insert(DataSendPropsLSSD.items[10].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/Sacs/" .. i .. ".webp",
                category = "Sacs",
                label = "#" .. i
            })
        end


        DataSendPropsLSSD.disableSubmit = true

        return true
    end



    RegisterNUICallback("focusOut", function()
        if PropsMenu.open then
            PropsMenu.open = false
        end
    end)


    DataSendPropsLSSD = {
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
                        name = 'Drogues',
                        width = 'full',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/drogues.svg',
                        hoverStyle = ' stroke-black'
                    },
                    {
                        name = 'Divers',
                        width = 'full',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/divers.svg',
                        hoverStyle = ' stroke-black'
                    },
                    {
                        name = 'Cibles Tir',
                        width = 'full',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/ciblestir.svg',
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
                name = 'Drogues',
                type = 'elements',
                elements = {},
            },
            {
                name = 'Divers',
                type = 'elements',
                elements = {},
            },
            {
                name = 'Cibles Tir',
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
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_lssd.webp',
        callbackName = 'MenuObjetsServicesPublicsLSSD',
        headerTitle = "OBJETS SERVICES PUBLICS",
        showTurnAroundButtons = false,
    }

    local firstart = false

    OpenPropsMenuLSSD = function()
        if firstart == false then
            firstart = true
            local bool = GetDatasProps()
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
            data = DataSendPropsLSSD
        }))
    end
end

function UnloadLssdJob()
    zone.removeZone("coffre_lssd")
    zone.removeZone("lssd_vest")
    zone.removeZone("lssd_vest_2")
    zone.removeZone("lssd_vest_3")
    zone.removeZone("lssd_vehicule")
    zone.removeZone("lssd_vehicule_delete")
    zone.removeZone("lssd_vehicule2")
    zone.removeZone("lssd_vehicule2_delete")
    zone.removeZone("society_lssd1")
    zone.removeZone("society_lssd2")
    zone.removeZone("stockage_lssd")
    zone.removeZone("spawn_lssd_heli")
    zone.removeZone("society_lssdHeli_delete")
    zone.removeZone("spawn_lssd_heli2")
    zone.removeZone("Heli2_delete")
    zone.removeZone("spawn_lssd_boat")
    zone.removeZone("society_lssdBoat_delete")
    lssdDuty = false
end

-- MENU PROPS

PropsMenu = {
    cam = nil,
    open = false,
}

local cones_models = {
    ['#1']  = "prop_air_conelight",
    ['#2']  = "prop_barrier_wat_03b",
    ['#3']  = "prop_mp_cone_03",
    ['#4']  = "prop_mp_cone_04",
    ['#5']  = "prop_roadcone02a",
    ['#6']  = "prop_roadcone02b",
    ['#7']  = "prop_roadpole_01a",
    ['#8']  = "prop_roadpole_01b",
    ['#9']  = "prop_trafficdiv_01",
    ['#10'] = "prop_trafficdiv_02",
}

local panneaux_models = {
    ['#1'] = "prop_consign_01b",
    ['#2'] = "prop_consign_02a",
    ['#3'] = "prop_sign_road_01a",
    ['#4'] = "prop_sign_road_03a",
    ['#5'] = "prop_sign_road_06a",
    ['#6'] = "prop_sign_road_06f",
    ['#7'] = "prop_sign_road_06q",
    ['#8'] = "prop_sign_road_06r",
    ['#9'] = "prop_consign_flag_01",
    ['#10'] = "prop_consign_flag_02",
    ['#11'] = "prop_consign_flag_03",
    ['#12'] = "prop_consign_flag_04",
    ['#13'] = "prop_consign_flag_05",
    ['#14'] = "prop_consign_flag_06",
    ['#15'] = "prop_consign_flag_07",
    ['#16'] = "prop_consign_flag_08",
    ['#17'] = "prop_consign_flag_09",
    ['#18'] = "prop_consign_flag_10",
    ['#19'] = "prop_consign_flag_11",
    ['#20'] = "prop_consign_flag_12",
    ['#21'] = "prop_consign_flag_13",
    ['#22'] = "prop_consign_flag_14",
    ['#23'] = "prop_consign_flag_15",
    ['#24'] = "prop_consign_flag_16",
    ['#25'] = "prop_consign_flag_17",
    ['#26'] = "prop_consign_flag_18",
    ['#27'] = "prop_consign_flag_19",
    ['#28'] = "prop_consign_flag_20",
    ['#29'] = "prop_consign_flag_21",
    ['#30'] = "prop_consign_flag_22",
    ['#31'] = "prop_consign_flag_23",
    ['#32'] = "prop_consign_flag_24",
    ['#33'] = "prop_consign_flag_25",
    ['#34'] = "prop_consign_flag_26",
    ['#35'] = "prop_consign_flag_27",
    ['#36'] = "prop_consign_flag_28",
    ['#37'] = "prop_consign_flag_29",
    ['#38'] = "prop_consign_flag_30",
    ['#39'] = "prop_barrier_sign_custom",
    ['#40'] = "prop_barrier_sign_detour",
    ['#41'] = "prop_barrier_sign_stop",
    ['#42'] = "prop_barrier_work01b",
    ['#43'] = "prop_barrier_work02a",
    ['#44'] = "prop_consign_flag_custom",
    ['#45'] = "prop_consign_flag_stop",
}

local barriere_models = {
    ['#1']  = "prop_barier_conc_05c",
    ['#2']  = "prop_barrier_work01a",
    ['#3']  = "prop_barrier_work01b",
    ['#4']  = "prop_barrier_work02a",
    ['#5']  = "prop_barrier_work06b",
    ['#6']  = "prop_fncsec_04a",
    ['#7']  = "prop_mp_arrow_barrier_01",
    ['#8']  = "prop_mp_barrier_02b",
    ['#9']  = "prop_plas_barier_01a",
    ['#10'] = "prop_barrier_work05",
    ['#11'] = "prop_barrier_work04br",
    ['#12'] = "prop_barrier_work04c",
    ['#13'] = "prop_barrier_work04cr",
    ['#14'] = "prop_barrier_work04d",
    ['#15'] = "prop_barrier_work04dr",
    ['#16'] = "prop_barrier_work04drx",
    ['#17'] = "prop_barrier_work04dx",
    ['#18'] = "prop_barrier_work04e",
    ['#19'] = "prop_barrier_work04er",
    ['#20'] = "prop_barrier_work04erx",
    ['#21'] = "prop_barrier_work04ex",
    ['#22'] = "prop_barrier_work06c",
    ['#23'] = "prop_barrier_work06d",
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

local drogues_models = {
    ['#1'] = "bkr_prop_bkr_cashpile_01",
    ['#2'] = "bkr_prop_meth_openbag_02",
    ['#3'] = "bkr_prop_meth_smallbag_01a",
    ['#4'] = "bkr_prop_moneypack_03a",
    ['#5'] = "bkr_prop_weed_med_01a",
    ['#6'] = "bkr_prop_weed_smallbag_01a",
    ['#7'] = "ex_office_swag_drugbag2",
    ['#8'] = "imp_prop_impexp_boxcoke_01",
    ['#9'] = "imp_prop_impexp_coke_pile",
}

local divers_models = {
    ['#1'] = "gr_prop_gr_laptop_01c",
    ['#2'] = "prop_ballistic_shield",
    ['#3'] = "prop_gazebo_02",
    ['#4'] = "prop_lssdpio",
}

local sacs_models = {
    ['#1'] = "xm_prop_x17_bag_01c",
    ['#2'] = "xm_prop_x17_bag_med_01a",
}

local cibletir_models = {
    ['#1'] = "gr_prop_gr_target_05a",
    ['#2'] = "gr_prop_gr_target_05b",
}


local lssdPropsPlaced = {}

local function SpawnPropsLSSD(obj, name)
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

            OpenPropsMenuLSSD()
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
    table.insert(lssdPropsPlaced, {
        nom = name,
        prop = objS.id
    })
end


RegisterNUICallback("MenuObjetsServicesPublicsLSSD", function(data, cb)
    -- if data == nil or data.category == nil then return end
    -- PropsMenu.choice = data.category

    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))

    if data.category == "Cones" then
        SpawnPropsLSSD(cones_models[data.label], data.label)
    end

    if data.category == "Panneaux" then
        SpawnPropsLSSD(panneaux_models[data.label], data.label)
    end

    if data.category == "Barrières" then
        SpawnPropsLSSD(barriere_models[data.label], data.label)
    end

    if data.category == "Lumières" then
        SpawnPropsLSSD(lumiere_models[data.label], data.label)
    end

    if data.category == "Tables" then
        SpawnPropsLSSD(tables_models[data.label], data.label)
    end

    if data.category == "Drogues" then
        SpawnPropsLSSD(drogues_models[data.label], data.label)
    end

    if data.category == "Divers" then
        SpawnPropsLSSD(divers_models[data.label], data.label)
    end

    if data.category == "Cibles Tir" then
        SpawnPropsLSSD(cibletir_models[data.label], data.label)
    end

    if data.category == "Sacs" then
        SpawnPropsLSSD(sacs_models[data.label], data.label)
    end
end)

RegisterNUICallback("Menu_LSSD_vehicule_callback", function(data, cb)
    for key, value in pairs(posSS) do
        if vehicle.IsSpawnPointClear(vector3(value.x, value.y, value.z), 3.0) then
            vehs = vehicle.create(data.spawnName, vector4(value), {})
            SetVehicleMod(vehs, 11, 2, false)
            SetVehicleMod(vehs, 12, 2, false)
            SetVehicleMod(vehs, 13, 2, false)
            if data.spawnName == "lssdstanier1" then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1, 1)
                SetVehicleExtra(vehs, 2,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 9,1)
            elseif data.spawnName == 'lssdscoutnew2' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 2,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 4,1)
                SetVehicleExtra(vehs, 5,1)
                SetVehicleExtra(vehs, 7,1)
            elseif data.spawnName == 'lssdalamonew2' then
                SetVehicleLivery(vehs, 1)
            elseif data.spawnName == 'sherifffug' then
                SetVehicleLivery(vehs, 0)
            elseif data.spawnName == 'lssdalamonew3' then
                SetVehicleLivery(vehs, 2)
            elseif data.spawnName == 'lspdeveron' then
                SetVehicleLivery(vehs, 4)
                SetVehicleExtra(vehs, 6,1)
                SetVehicleExtra(vehs, 11,1)
            elseif data.spawnName == 'lspdeveron' then
                SetVehicleLivery(vehs, 4)
                SetVehicleExtra(vehs, 6,1)
                SetVehicleExtra(vehs, 11,1)
            elseif data.spawnName == 'sheriffstalker' then
                SetVehicleExtra(vehs, 10,1)
            elseif data.spawnName == 'lspdcara' then
                SetVehicleLivery(vehs, 2)
                SetVehicleExtra(vehs, 4,1)
            elseif data.spawnName == 'lspdtorrence' then
                SetVehicleLivery(vehs, 3)
                SetVehicleExtra(vehs, 4,1)
                SetVehicleExtra(vehs, 6,1)
                SetVehicleExtra(vehs, 8,1)
                SetVehicleExtra(vehs, 9,1)
            elseif data.spawnName == 'lssd2020scout' then
                SetVehicleLivery(vehs, 1)
            elseif data.spawnName == 'lspdbuffalo' then
                SetVehicleLivery(vehs, 1)
                SetVehicleExtra(vehs, 11,1)
            elseif data.spawnName == 'lspdbuffalo' then
                SetVehicleLivery(vehs, 1)
                SetVehicleExtra(vehs, 11,1)
            elseif data.spawnName == 'lspdbuffalos' then
                SetVehicleLivery(vehs, 2)
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 10,1)
                SetVehicleExtra(vehs, 11,1)
            elseif data.label == 'Buffalo 2013 ST' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Torrence ST' then
                SetVehicleLivery(vehs, 2)
            elseif data.label == 'Stanier ST' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 2,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 4,1)
            elseif data.label == 'Scout 2020 ST' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1,1)
            elseif data.spawnName == 'polbuffalog' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1,1)
            elseif data.label == 'Scout 2016 ST' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 2,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 4,1)
                SetVehicleExtra(vehs, 7,1)
            elseif data.label == 'Sheriff Ghost' then
                SetVehicleExtra(vehs, 1,1)
            elseif data.label == 'Scout 2020 K9' then
                SetVehicleLivery(vehs, 2)
            elseif data.label == 'Alamo 2500LS K9' then
                SetVehicleLivery(vehs, 2)
            elseif data.label == 'Alamo 2500 ST' then
                SetVehicleLivery(vehs, 2)
            elseif data.label == 'Alamo 2500 UMK' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Gresley UMK' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'STX UMK' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Scout 2020 UMK' then
                SetVehicleLivery(vehs, 3)
            elseif data.label == 'Scout 2016 UMK' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Landstalker UMK' then
                SetVehicleLivery(vehs, 0) 
            elseif data.label == 'Stanier UMK' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Buffalo 13 UMK' then
                SetVehicleLivery(vehs, 6)
            elseif data.label == 'Buffalo 09 UMK' then
                SetVehicleLivery(vehs, 6)
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 2,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 10,1)
            elseif data.label == 'Buffalo 09 UMK' then
                SetVehicleLivery(vehs, 6)
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 2,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 10,1)
            elseif data.label == 'Fugitive UMK' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Caracara UMK' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Sultan UMK' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Greenwood' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 10,1)
                SetVehicleExtra(vehs, 11,1)
                SetVehicleExtra(vehs, 12,1)
            elseif data.label == 'Impaler 1993 Vector' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 5,1)
                SetVehicleExtra(vehs, 7,1)
                SetVehicleExtra(vehs, 9,1)
                SetVehicleExtra(vehs, 10,1)
            elseif data.label == 'Roamer' then
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 2,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 11,1)
            elseif data.label == 'Raiden Homelander' then
                SetVehicleLivery(vehs, 4)
            elseif data.label == 'Alamo Old' then
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 2,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 5,1)
                SetVehicleExtra(vehs, 9,1)
                SetVehicleExtra(vehs, 10,1)
                SetVehicleExtra(vehs, 11,1)
                SetVehicleExtra(vehs, 12,1)
            elseif data.label == 'Alamo Old' then
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 2,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 5,1)
                SetVehicleExtra(vehs, 7,1)
                SetVehicleExtra(vehs, 11,1)
                SetVehicleExtra(vehs, 12,1)
            elseif data.label == 'Brigham' then
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 5,1)
                SetVehicleExtra(vehs, 7,1)
                SetVehicleExtra(vehs, 9,1)
            elseif data.label == 'STX VALOR' then
                SetVehicleLivery(vehs, 2)
            elseif data.label == 'Wintergreen' then
                SetVehicleLivery(vehs, 1)
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 5,1)
            elseif data.label == 'Wintergreen' then
                SetVehicleLivery(vehs, 1)
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 5,1)
            elseif data.label == 'Torrence Valor' then
                SetVehicleLivery(vehs, 4)
                SetVehicleExtra(vehs, 10,1)
            elseif data.label == 'SAR Utility' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 2,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 5,1)
            elseif data.label == 'Riata SR' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 2,1)
            elseif data.label == 'Enduro' then
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 5,1)
                SetVehicleExtra(vehs, 6,1)
                SetVehicleExtra(vehs, 10,1)
                SetVehicleExtra(vehs, 11,1)
            elseif data.label == 'Verus' then
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 4,1)
                SetVehicleExtra(vehs, 5,1)
                SetVehicleExtra(vehs, 6,1)
            elseif data.label == 'Sadler' then
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 12,1)
            elseif data.label == 'LSSD Speedo' then
                SetVehicleLivery(vehs, 3)
            end            
            local plate = vehicle.getProps(vehs).plate
            local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
            local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
            --createKeys(plate, model)
            SendNuiMessage(json.encode({
                type = 'closeWebview'
            }))
            return
        end
    end
end)

RegisterNUICallback("Menu_LSSD_vehicule_callback_vespucci", function(data, cb)
    for key, value in pairs(posVespucciLSPD) do
        if vehicle.IsSpawnPointClear(vector3(value.x, value.y, value.z), 3.0) then
            vehs = vehicle.create(data.spawnName, vector4(value), {})
            SetVehicleMod(vehs, 11, 2, false)
            SetVehicleMod(vehs, 12, 2, false)
            SetVehicleMod(vehs, 13, 1, false)
            if data.spawnName == "lssdstanier1" then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1, 1)
                SetVehicleExtra(vehs, 2,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 9,1)
            elseif data.spawnName == 'lssdscoutnew2' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 2,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 4,1)
                SetVehicleExtra(vehs, 5,1)
                SetVehicleExtra(vehs, 7,1)
            elseif data.spawnName == 'lssdalamonew2' then
                SetVehicleLivery(vehs, 1)
            elseif data.spawnName == 'sherifffug' then
                SetVehicleLivery(vehs, 0)
            elseif data.spawnName == 'lssdalamonew3' then
                SetVehicleLivery(vehs, 2)
            elseif data.spawnName == 'lspdeveron' then
                SetVehicleLivery(vehs, 4)
                SetVehicleExtra(vehs, 6,1)
                SetVehicleExtra(vehs, 11,1)
            elseif data.spawnName == 'lspdeveron' then
                SetVehicleLivery(vehs, 4)
                SetVehicleExtra(vehs, 6,1)
                SetVehicleExtra(vehs, 11,1)
            elseif data.spawnName == 'sheriffstalker' then
                SetVehicleExtra(vehs, 10,1)
            elseif data.spawnName == 'lspdcara' then
                SetVehicleLivery(vehs, 2)
                SetVehicleExtra(vehs, 4,1)
            elseif data.spawnName == 'lspdtorrence' then
                SetVehicleLivery(vehs, 3)
                SetVehicleExtra(vehs, 4,1)
                SetVehicleExtra(vehs, 6,1)
                SetVehicleExtra(vehs, 8,1)
                SetVehicleExtra(vehs, 9,1)
            elseif data.spawnName == 'lssd2020scout' then
                SetVehicleLivery(vehs, 1)
            elseif data.spawnName == 'lspdbuffalo' then
                SetVehicleLivery(vehs, 1)
                SetVehicleExtra(vehs, 11,1)
            elseif data.spawnName == 'lspdbuffalo' then
                SetVehicleLivery(vehs, 1)
                SetVehicleExtra(vehs, 11,1)
            elseif data.spawnName == 'lspdbuffalos' then
                SetVehicleLivery(vehs, 2)
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 10,1)
                SetVehicleExtra(vehs, 11,1)
            elseif data.label == 'Buffalo 2013 ST' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Torrence ST' then
                SetVehicleLivery(vehs, 2)
            elseif data.label == 'Stanier ST' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 2,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 4,1)
            elseif data.label == 'Scout 2020 ST' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1,1)
            elseif data.spawnName == 'polbuffalog' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1,1)
            elseif data.label == 'Scout 2016 ST' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 2,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 4,1)
                SetVehicleExtra(vehs, 7,1)
            elseif data.label == 'Sheriff Ghost' then
                SetVehicleExtra(vehs, 1,1)
            elseif data.label == 'Scout 2020 K9' then
                SetVehicleLivery(vehs, 2)
            elseif data.label == 'Alamo 2500LS K9' then
                SetVehicleLivery(vehs, 2)
            elseif data.label == 'Alamo 2500 ST' then
                SetVehicleLivery(vehs, 2)
            elseif data.label == 'Alamo 2500 UMK' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Gresley UMK' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'STX UMK' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Scout 2020 UMK' then
                SetVehicleLivery(vehs, 3)
            elseif data.label == 'Scout 2016 UMK' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Landstalker UMK' then
                SetVehicleLivery(vehs, 0) 
            elseif data.label == 'Stanier UMK' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Buffalo 13 UMK' then
                SetVehicleLivery(vehs, 6)
            elseif data.label == 'Buffalo 09 UMK' then
                SetVehicleLivery(vehs, 6)
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 2,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 10,1)
            elseif data.label == 'Buffalo 09 UMK' then
                SetVehicleLivery(vehs, 6)
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 2,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 10,1)
            elseif data.label == 'Fugitive UMK' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Caracara UMK' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Sultan UMK' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Greenwood' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 10,1)
                SetVehicleExtra(vehs, 11,1)
                SetVehicleExtra(vehs, 12,1)
            elseif data.label == 'Impaler 1993 Vector' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 5,1)
                SetVehicleExtra(vehs, 7,1)
                SetVehicleExtra(vehs, 9,1)
                SetVehicleExtra(vehs, 10,1)
            elseif data.label == 'Roamer' then
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 2,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 11,1)
            elseif data.label == 'Raiden Homelander' then
                SetVehicleLivery(vehs, 4)
            elseif data.label == 'Alamo Old' then
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 2,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 5,1)
                SetVehicleExtra(vehs, 9,1)
                SetVehicleExtra(vehs, 10,1)
                SetVehicleExtra(vehs, 11,1)
                SetVehicleExtra(vehs, 12,1)
            elseif data.label == 'Alamo Old' then
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 2,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 5,1)
                SetVehicleExtra(vehs, 7,1)
                SetVehicleExtra(vehs, 11,1)
                SetVehicleExtra(vehs, 12,1)
            elseif data.label == 'Brigham' then
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 5,1)
                SetVehicleExtra(vehs, 7,1)
                SetVehicleExtra(vehs, 9,1)
            elseif data.label == 'STX VALOR' then
                SetVehicleLivery(vehs, 2)
            elseif data.label == 'Wintergreen' then
                SetVehicleLivery(vehs, 1)
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 5,1)
            elseif data.label == 'Wintergreen' then
                SetVehicleLivery(vehs, 1)
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 5,1)
            elseif data.label == 'Torrence Valor' then
                SetVehicleLivery(vehs, 4)
                SetVehicleExtra(vehs, 10,1)
            elseif data.label == 'SAR Utility' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 2,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 5,1)
            elseif data.label == 'Riata SR' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 2,1)
            elseif data.label == 'Enduro' then
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 5,1)
                SetVehicleExtra(vehs, 6,1)
                SetVehicleExtra(vehs, 10,1)
                SetVehicleExtra(vehs, 11,1)
            elseif data.label == 'Verus' then
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 4,1)
                SetVehicleExtra(vehs, 5,1)
                SetVehicleExtra(vehs, 6,1)
            elseif data.label == 'Sadler' then
                SetVehicleExtra(vehs, 1,1)
                SetVehicleExtra(vehs, 12,1)
            elseif data.label == 'LSSD Speedo' then
                SetVehicleLivery(vehs, 3)
            end            
            local plate = vehicle.getProps(vehs).plate
            local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
            local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
            --createKeys(plate, model)
            SendNuiMessage(json.encode({
                type = 'closeWebview',
            }))
            return
        end
    end
end)

RegisterNUICallback("Menu_LSSD_heli_callback", function(data, cb)
    local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 1730.18, 3862.3, 40.97)
    if distance < 50.0 then
        if vehicle.IsSpawnPointClear(vector3(1730.18, 3862.3, 40.97), 3.0) then
            vehs = vehicle.create(data.spawnName,
                vector4(1730.18, 3862.3, 40.97, 44.54), {})
            -- SetVehicleLivery(vehs, 0)
            if data.spawnName == 'lspdmav' then
                SetVehicleLivery(vehs, 4)
            elseif data.label == 'SuperPuma ASU' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'SuperPuma SEB' then
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
    else
        if vehicle.IsSpawnPointClear(vector3(2751.9211425781, 4850.3271484375, 46.371780395508), 3.0) then
            vehs = vehicle.create(data.spawnName,
                vector4(2751.9211425781, 4850.3271484375, 46.371780395508, 186.9973449707), {})
            -- SetVehicleLivery(vehs, 0)
            if data.spawnName == 'lspdmav' then
                SetVehicleLivery(vehs, 4)
            elseif data.label == 'SuperPuma ASU' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'SuperPuma SEB' then
                SetVehicleLivery(vehs, 1)
            end
            local plate = vehicle.getProps(vehs).plate
            local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
            local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
            --(plate, model)
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
    end
end)

RegisterNUICallback("Menu_LSSD_boat_callback", function(data, cb)
    if vehicle.IsSpawnPointClear(vector3(1414.44, 3877.02, 29.66), 3.0) then
        vehs = vehicle.create(data.spawnName, vector4(1414.44, 3877.02, 29.66, 79.17),
            {})
        if data.spawnName == 'polpreda' then
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

RegisterNUICallback("armoryTakeLSSD", function(data, cb)
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
    print("^3[JOBS]: ^7lssd ^3loaded")
end)



RegisterNUICallback("focusOut", function(data, cb)
    if OpenLSSDMENUItems then
        TriggerScreenblurFadeOut(0.5)
        openRadarProperly()
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        OpenLSSDMENUItems = false
    end
end)