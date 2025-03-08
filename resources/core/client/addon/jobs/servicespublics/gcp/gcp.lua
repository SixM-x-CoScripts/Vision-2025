local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local created = false
local posSS = { 
vector4(1846.1009521484, 3683.0422363281, 33.015636444092, 210.47543334961),
vector4(1848.8779296875, 3684.3435058594, 32.991184234619, 205.70333862305),
vector4(1851.5484619141, 3686.0888671875, 32.984485626221, 209.00559997559),
vector4(1854.1516113281, 3687.5639648438, 32.974479675293, 210.54666137695),
vector4(1856.7744140625, 3689.1391601563, 32.973510742188, 210.62004089355),
vector4(1859.4742431641, 3690.7448730469, 32.965492248535, 209.88619995117),
vector4(1862.0922851563, 3692.2785644531, 32.965557098389, 209.95959472656),
vector4(1870.0708007813, 3684.4592285156, 32.761756896973, 30.698202133179),
vector4(1867.5274658203, 3682.9943847656, 32.778057098389, 29.890981674194),
vector4(1864.7573242188, 3681.3703613281, 32.820789337158, 29.890981674194),
vector4(1853.1021728516, 3674.7277832031, 32.989971160889, 28.423355102539),
vector4(1850.5083007813, 3673.2827148438, 33.019504547119, 29.303928375244),
vector4(1847.8205566406, 3671.7395019531, 33.048400878906, 29.157163619995),
vector4(1845.1099853516, 3670.2104492188, 33.08517074585, 30.991661071777) 
}

local posPB = { 
vector4(-482.44570922852, 6024.583984375, 30.340375900269, 223.04058837891),
vector4(-478.29275512695, 6026.9252929688, 30.340375900269, 226.08567810059),
vector4(-475.24127197266, 6030.8276367188, 30.340375900269, 224.17758178711),
vector4(-471.88851928711, 6034.0708007813, 30.340375900269, 221.46240234375),
vector4(-468.21636962891, 6037.3647460938, 30.340375900269, 221.46240234375)
}

CreateThread(function()
    local ped = nil
    local ped2 = nil
    local ped3, ped4, ped5 = nil, nil, nil
    if not created then
        ped3 = entity:CreatePedLocal("s_m_y_sheriff_01", vector3(-462.71929931641, 6001.5576171875, 30.489170074463),
            136.33042907715)
        --[[ ped4 = entity:CreatePedLocal("s_m_y_sheriff_01", vector3(-462.72024536133, 6025.9243164063, 30.448970794678),
            136.35829162598)
        ped5 = entity:CreatePedLocal("s_m_y_sheriff_01", vector3(1453.0445556641, 3766.8862304688, 30.746339797974),
            298.91055297852) ]]

        created = true
    end

    SetEntityInvincible(ped3.id, true)
    ped3:setFreeze(true)
    TaskStartScenarioInPlace(ped3.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
    SetEntityAsMissionEntity(ped3.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped3.id, true)

    --SetEntityInvincible(ped4.id, true)
    --ped4:setFreeze(true)
    --TaskStartScenarioInPlace(ped4.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
    --SetEntityAsMissionEntity(ped4.id, 0, 0)
    --SetBlockingOfNonTemporaryEvents(ped4.id, true)

    --SetEntityInvincible(ped5.id, true)
    --ped5:setFreeze(true)
    --TaskStartScenarioInPlace(ped5.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
    --SetEntityAsMissionEntity(ped5.id, 0, 0)
    --SetBlockingOfNonTemporaryEvents(ped5.id, true)
end)


GCPDuty = false

function LoadGCPJob()

    local casierPos = { 
        vector3(2806.1645507813, 4709.3530273438, 47.627368927002),
        vector3(2805.5173339844, 4711.6162109375, 47.627334594727),
        vector3(2802.2687988281, 4712.9516601563, 47.627361297607),
        vector3(2802.9243164063, 4709.3403320313, 47.627338409424),
        vector3(-1087.1840820313, -812.73260498047, 5.4792823791504),
        vector3(-1095.697265625, -824.0, 26.826816558838),
        vector3(-1098.9569091797, -827.09417724609, 26.826910018921) 
    }

    zone.addZone("society_GCP1", vector3(4921.4584960938, -5277.373046875, 4.9025950431824),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les actions d'entreprise", function()
            OpenSocietyMenu() -- TODO: fini le menu society
        end, false, 25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170-- Alpha
    )

    zone.addZone(
        "society_GCP_custom",
        vector3(4957.72265625, -5285.056640625, 4.7666702270508),
        "Appuyer sur ~INPUT_CONTEXT~ pour éditer votre vehicule",
        function()
           local veh = p:currentVeh()
           if GetVehicleClass(veh)== 18 then
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
        39, -- Id / type du marker
        0.5, -- La taille
        { 203, 75, 0 }, -- RGB
        170-- Alpha
    )

    zone.addZone(
        "society_GCP2_custom",
        vector3(4950.2133789063, -5284.3662109375, 3.9175820350647),
        "Appuyer sur ~INPUT_CONTEXT~ pour éditer votre vehicule",
        function()
            local veh = p:currentVeh()
            if GetVehicleClass(veh)== 18 then
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
        39, -- Id / type du marker
        0.5, -- La taille
        { 203, 75, 0 }, -- RGB
        170-- Alpha
    )

    zone.addZone("society_GCP2", vector3(4929.34375, -5271.1694335938, 4.9011831283569),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les actions d'entreprise", function()
            OpenSocietyMenu() -- TODO: fini le menu society
        end, false, 25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170-- Alpha
    )

    zone.addZone("GCP_item", vector3(0,0,0),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir l'armurerie ", 
        function()
            OpenGCPItemMenu()
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        1.1 -- Interact dist
    )

    zone.addZone("GCP_item_2", vector3(4928.2768554688, -5280.611328125, 4.9025888442993),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir l'armurerie ", 
        function()
            OpenGCPItemMenu()
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        2.5 -- Interact dist
    )

    -- DEV
    zone.addZone("GCP_vest", vector3(0, 0, 0),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le vestiaire", 
        function()
            GCPVestiaireDev()
        end,
        true, 25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170-- Alpha
    )

    zone.addZone("GCP_vest_2", vector3(0, 0, 0),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le vestiaire", 
        function()
            GCPVestiaireDev()
        end,
        true, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        2.5 -- Interact dist
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
                        for k, v in pairs(gcp.outfit) do
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

        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_gcp.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Banners/icon.webp',
        headerIconName = 'CATALOGUE',
        callbackName = 'armoryTakeGCP',
        showTurnAroundButtons = false,
        multipleSelection = true,
        elements = {
            {
                price = 0,
                id = 1,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/GCP/radio.webp",
                name = "radio",
                label = "Radio",
            },
            {           
                price = 0,
                id = 2,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/GCP/jumelles.webp",
                name = "jumelles",
                label = "Jumelles",
            },
            {           
                price = 0,
                id = 3,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/GCP/keville5.webp",
                name = "keville5",
                label = "Kevlar Class C 5",
            },
            {           
                price = 0,
                id = 4,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/GCP/weapon_machete.webp",
                name = "weapon_machete",
                label = "Machette",
            },
            {           
                price = 0,
                id = 5,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/GCP/weapon_assaultrifle.webp",
                name = "weapon_assaultrifle",
                label = "Fusil D'assault",
            },
            {           
                price = 0,
                id = 6,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/GCP/weapon_pistol.webp",
                name = "weapon_pistol",
                label = "Beretta",
            },
            {
                price = 0,
                id = 7,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/GCP/ammobox_rifle.webp",
                name = "ammobox_rifle",
                label = "Boite de munitions d'assault",
            },
            {
                price = 0,
                id = 8,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/GCP/ammobox_pistol.webp",
                name = "ammobox_pistol",
                label = "Boite de munitions pistolet",
            },
        },
    }
    function OpenGCPItemMenu()
        FreezeEntityPosition(PlayerPedId(), true)
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogueAchat',
            data = items
        }));

        RegisterNUICallback("focusOut", function (data, cb)
            TriggerScreenblurFadeOut(0.5)
            openRadarProperly()
            RenderScriptCams(false, false, 0, 1, 0)
            DestroyCam(cam, false)
            FreezeEntityPosition(PlayerPedId(), false)
        end)
    end

    zone.addZone("stockage_GCP", vector3(2814.5180664063, 4724.8842773438, 47.627300262451),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le coffre des saisies", function()
            OpenInventorySocietyMenu() -- TODO: fini le menu society
        end, false, 25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170-- Alpha
    )

    for k, v in pairs(casierPos) do
        zone.addZone("coffre_GCP" .. k, v, "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les casiers",
            function()
                OpenlspdCasier() -- TODO: fini le menu society
            end, false, 25, -- Id / type du marker
            0.6, -- La taille
            { 51, 204, 255 }, -- RGB
            170-- Alpha
        )
    end

    zone.addZone(
        "spawn_GCP_heli",
        vector3(4893.0883789063, -5279.4741210938, 7.4644422531128),
        "~INPUT_CONTEXT~ Garage",
        function()
            openGarageHeliGCPMenu()
        end,
        true,
        25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170--
    )

    zone.addZone(
        "society_GCPHeli_delete",
        vector3(4882.2631835938, -5282.5190429688, 7.4239463806152),
        "~INPUT_CONTEXT~ Ranger le véhicule",
        function()
            if IsPedInAnyVehicle(p:ped(), false) then
                local veh = GetVehiclePedIsIn(p:ped(), false)
                removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                DeleteEntity(veh)

            end
        end,
        true,
        36, 0.5, { 255, 0, 0 }, 255
    )

    zone.addZone(
        "spawn_GCP_heli2",
        vector3(-463.1799621582, 6000.970703125, 30.489166259766),
        "~INPUT_CONTEXT~ Garage",
        function()
            openGarageHeliGCPMenu()
        end,
        true,
        25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170--
    )

    zone.addZone(
        "society_GCPHeli2_delete",
        vector3(-475.1667175293, 5988.453125, 31.336488723755),
        "~INPUT_CONTEXT~ Ranger le véhicule",
        function()
            if IsPedInAnyVehicle(p:ped(), false) then
                local veh = GetVehiclePedIsIn(p:ped(), false)
                removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                DeleteEntity(veh)

            end
        end,
        true,
        36, 0.5, { 255, 0, 0 }, 255
    )
    zone.addZone(
        "spawn_GCP_boat",
        vector3(1453.8256835938, 3767.2709960938, 30.846427536011),
        "~INPUT_CONTEXT~ Garage",
        function()
        openGarageGCPBoatMenu()
        end,
        true,
        25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170--
    )
    zone.addZone(
        "society_GCPBoat_delete",
        vector3(1454.3397216797, 3772.1853027344, 28.974069595337),
        "~INPUT_CONTEXT~ Ranger le véhicule",
        function()
            if IsPedInAnyVehicle(p:ped(), false) then
                local veh = GetVehiclePedIsIn(p:ped(), false)
                removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                DeleteEntity(veh)

            end
        end,
        true,
        35, 0.6, { 255, 0, 0 }, 170
    )

    local openRadial = false

    local open = false
    local lspdmenu_objects = RageUI.CreateMenu("", "GCP", 0.0, 0.0, "vision", "menu_title_police")
    local lspdmenu_traffic = RageUI.CreateMenu("", "GCP", 0.0, 0.0, "vision", "menu_title_police")
    local lspdmenu_traffic_add = RageUI.CreateSubMenu(lspdmenu_traffic, "", "GCP", 0.0, 0.0, "vision",
        "menu_title_police")
    local lspdmenu_traffic_view = RageUI.CreateSubMenu(lspdmenu_traffic, "", "GCP", 0.0, 0.0, "vision",
        "menu_title_police")
    local lspdmenu_objects_delete = RageUI.CreateSubMenu(lspdmenu_objects, "", "GCP", 0.0, 0.0, "vision",
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
        if GCPDuty then
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
                                    radius = tonumber(KeyboardImput("Rayon"))  + .0
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
                                RageUI.Button(v.zoneId .. " | " .. v.zoneName, nil, { RightLabel = "~r~ Supprimer" }, true,
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
                                            DrawMarker(1, v.zonePos + vector3(0.0, 0.0, -1000.0), 0.0, 0.0, 0.0, 0.0, 0.0, .0
                                                , distance + .0, distance + .0, 10000.0, 20, 192, 255, 70, 0, 0, 2
                                                , 0, 0, 0, 0)
                                        end
                                    })
                            end
                        end)
                        if show then
                            -- draw circle around player with the radius of the zone
                            local distance = radius + .0
                            DrawMarker(1, p:pos() + vector3(0.0, 0.0, -1000.0), 0.0, 0.0, 0.0, 0.0, 0.0, .0, distance + .0,
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

    function gcpActionDuty()
        openRadial = false
        closeUI()
        if GCPDuty then
            TriggerServerEvent('core:DutyOff', 'gcp')
--[[             ShowAdvancedNotification("Centrale", "~b~Dispatch", "Vous avez quitté votre service", "CHAR_CALL911",
                "CHAR_CALL911") ]]

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s quitté ~c votre service"
            })

            GCPDuty = false
            Wait(5000)
        else
            TriggerServerEvent('core:DutyOn', 'gcp')
--[[             ShowAdvancedNotification("Centrale", "~b~Dispatch", "Vous avez pris votre service", "CHAR_CALL911",
                "CHAR_CALL911") ]]
            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s pris ~c votre service"
            })

            GCPDuty = true
            Wait(5000)
        end
    end

    function FactureGCP()
        if GCPDuty then
            openRadial = false
            closeUI()
            TriggerEvent("nuiPapier:client:startCreation",2)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end
    
    function ConvocationGCP()
        if GCPDuty then
            openRadial = false
            closeUI()
            TriggerEvent("nuiPapier:client:startCreation", 5, 'https://cdn.sacul.cloud/v2/vision-cdn/entrepriseCarre/gcp.webp')
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function DepositionGCP()
        if GCPDuty then
            openRadial = false
            closeUI()
            TriggerEvent("nuiPapier:client:startCreation", 4, "https://cdn.sacul.cloud/v2/vision-cdn/entrepriseCarre/gcp.webp")
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function makeRenfortCall()
        if GCPDuty then
            TriggerSecurEvent('core:makeCall', "gcp", p:pos(), false, "Appel de renfort (" .. p:getLastname() .. " " .. p:getFirstname() .. ")") 
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
        if GCPDuty then
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

    function OpenRadialGCPMenu()
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
                    DisableControlAction(0, 24, true) -- disable attack
                    DisableControlAction(0, 25, true) -- disable aim
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
                        data = { elements = {
                            {
                                name = "CONVOCATION",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/top_paper.svg",
                                action = "ConvocationGCP"
                            },
                            {
                                name = "FACTURE",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/billet.svg",
                                action = "FactureGCP"
                            },
                            {
                                name = "RETOUR",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                action = "OpenMainRadialGCP"
                            },
                            {
                                name = "DEPOSITION",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/paper.svg",
                                action = "DepositionGCP"
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
                        data = { elements = {
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
                                action = "OpenMainRadialGCP"
                            },
                            {
                                name = "OBJETS",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/object.svg",
                                action = "OpenPropsMenuGCP"
                            }
                        }, 
                        title = "ACTIONS",
                        }
                    }));
                end

                function OpenMainRadialGCP()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = { elements = {
                            {
                                name = "APPEL DE RENFORT",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/police_logo.svg",
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
                                action = "gcpActionDuty"
                            },
                            {
                                name = "ACTIONS",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/police.svg",
                                action = "OpenSubRadialActions"
                            }
                        }, title = "GCP"}
                    }));
                end

                OpenMainRadialGCP()
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

    RegisterJobMenu(OpenRadialGCPMenu)
    
    
    zone.addZone(
        "gcp_vehicule",
        vector3(4964.3759765625, -5289.1928710938, 5.2409014701843),
        "~INPUT_CONTEXT~ Garage",
        function()
            openGCPGarageMenu()
            forceHideRadar()
        end,
        false,
        25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170-- Alpha
    )
    
    zone.addZone(
        "gcp_vehicule_delete", vector3(4935.4731445313, -5308.4208984375, 5.1532664299011),
        "Appuyer sur ~INPUT_CONTEXT~ pour rentrer dans le garage", function()
            if IsPedInAnyVehicle(p:ped(), false) then
                local veh = GetVehiclePedIsIn(p:ped(), false)
                removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                DeleteEntity(veh)
            end
        end, true,
        36, 0.5, { 255, 0, 0 }, 255)

        

    zone.addZone(
        "gcp_vehicule2",
        vector3(0, 0, 0),
        "~INPUT_CONTEXT~ Garage",
        function()
            openGCPGarageMenu()
            forceHideRadar()
        end,
        false,
        25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170-- Alpha
    )
    
    zone.addZone(
        "gcp_vehicule2_delete", vector3(0, 0, 0),
        "Appuyer sur ~INPUT_CONTEXT~ pour rentrer dans le garage", function()
            if IsPedInAnyVehicle(p:ped(), false) then
                local veh = GetVehiclePedIsIn(p:ped(), false)
                removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                DeleteEntity(veh)
            end
        end, true,
        36, 0.5, { 255, 0, 0 }, 255)


    local listVeh = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_gcp.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/LSPD/logo_vehicule.webp',
        headerIconName = 'VEHICULE',
        callbackName= 'Menu_gcp_vehicule_callback',
        elements = {
            {
                label = 'Winky',
                spawnName = 'winky',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/sheriffscout.webp",
                category= 'Grade',
                subCategory= 'Recrue'
            },
            {
                label = 'Vetir',
                spawnName = 'vetir',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/sheriff.webp",
                category= 'Grade',
                subCategory= 'Soldat'
            },
            {
                label = 'Mesa XL',
                spawnName = 'mesa3',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/sheriffscout.webp",
                category= 'Grade',
                subCategory= 'Soldat'
            },
            {
                label = 'Enduro MK2',
                spawnName = 'enduromk2',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/sheriffscout.webp",
                category= 'Grade',
                subCategory= 'Soldat'
            },
            {
                label = 'Winky',
                spawnName = 'winky',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/sheriffscout.webp",
                category= 'Grade',
                subCategory= 'Soldat'
            },
            {
                label = 'Vetir',
                spawnName = 'vetir',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/sheriff.webp",
                category= 'Grade',
                subCategory= 'Soldat'
            },
            {
                label = 'Mesa XL',
                spawnName = 'mesa3',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/sheriffscout.webp",
                category= 'Grade',
                subCategory= 'Sergent'
            },
            {
                label = 'Enduro MK2',
                spawnName = 'enduromk2',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/sheriffscout.webp",
                category= 'Grade',
                subCategory= 'Sergent'
            },
            {
                label = 'Winky',
                spawnName = 'winky',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/sheriffscout.webp",
                category= 'Grade',
                subCategory= 'Sergent'
            },
            {
                label = 'Vetir',
                spawnName = 'vetir',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/sheriff.webp",
                category= 'Grade',
                subCategory= 'Sergent'
            },  
            {
                label = 'Mesa XL',
                spawnName = 'mesa3',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/sheriffscout.webp",
                category= 'Grade',
                subCategory= 'Capitaine'
            },
            {
                label = 'Enduro MK2',
                spawnName = 'enduromk2',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/sheriffscout.webp",
                category= 'Grade',
                subCategory= 'Capitaine'
            },
            {
                label = 'Winky',
                spawnName = 'winky',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/sheriffscout.webp",
                category= 'Grade',
                subCategory= 'Capitaine'
            },
            {
                label = 'Vetir',
                spawnName = 'vetir',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/sheriff.webp",
                category= 'Grade',
                subCategory= 'Capitaine'
            }, 
            {
                label = 'Mesa XL',
                spawnName = 'mesa3',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/sheriffscout.webp",
                category= 'Grade',
                subCategory= 'Général'
            },
            {
                label = 'Enduro MK2',
                spawnName = 'enduromk2',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/sheriffscout.webp",
                category= 'Grade',
                subCategory= 'Général'
            },
            {
                label = 'Winky',
                spawnName = 'winky',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/sheriffscout.webp",
                category= 'Grade',
                subCategory= 'Général'
            },
            {
                label = 'Vetir',
                spawnName = 'vetir',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/sheriff.webp",
                category= 'Grade',
                subCategory= 'Général'
            },    
        },
    }
    
    
    function openGCPGarageMenu()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listVeh
        }))
    end

        local listHeli = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_gcp.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/LSPD/logo_vehicule.webp',
        headerIconName = 'HÉLICOPTÈRES',
        callbackName= 'Menu_GCP_heli_callback',
        elements = {
            {
                label = 'Buzzard',
                spawnName = 'buzzard',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/lspdmav.webp",
                category= 'Grade',
                subCategory= 'Capitaine'
            },
            {
                label = 'Valkyrie',
                spawnName = 'valkyrie2',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/lspdmav.webp",
                category= 'Grade',
                subCategory= 'Capitaine'
            },
            {
                label = 'Buzzard',
                spawnName = 'buzzard',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/lspdmav.webp",
                category= 'Grade',
                subCategory= 'Sergent'
            },
            {
                label = 'Valkyrie',
                spawnName = 'valkyrie2',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/lspdmav.webp",
                category= 'Grade',
                subCategory= 'Sergent'
            },
            {
                label = 'Buzzard',
                spawnName = 'buzzard',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/lspdmav.webp",
                category= 'Grade',
                subCategory= 'Général'
            },
            {
                label = 'Valkyrie',
                spawnName = 'valkyrie2',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/lspdmav.webp",
                category= 'Grade',
                subCategory= 'Général'
            },
        }
    }

    function openGarageHeliGCPMenu()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listHeli
        }))
    end

    local listBoat = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_gcp.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/LSPD/logo_vehicule.webp',
        headerIconName = 'BATEAUX',
        callbackName= 'Menu_GCP_boat_callback',
        elements = {
            {
                label = 'Predator',
                spawnName = 'polpreda',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/polpreda.webp",
                category= 'Division',
                subCategory= 'NRT'
            },
        }
    }

    function openGarageGCPBoatMenu()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listBoat
        }))
    end

    
    RegisterNUICallback("focusOut", function (data, cb)
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
            vector4(4953.4311523438, -5287.6376953125, 4.3473677635193, 82.122657775879), {})
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
                    DisableControlAction(0, 24, true) -- disable attack
                    DisableControlAction(0, 25, true) -- disable aim
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
        -- DataSendPropsGCP.items.elements = {}

        local playerJobs = 'lspd-lssd'

        -- Cones
        for i = 1, 10 do
            table.insert(DataSendPropsGCP.items[2].elements, {
                id = i,
                image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Cones/"..i..".webp",
                category="Cones", 
                label = "#"..i
            })
        end


    -- Panneaux
        for i = 1, 8 do
            table.insert(DataSendPropsGCP.items[3].elements, {
                id = i,
                image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Panneaux/"..i..".webp",
                category="Panneaux",
                label = "#"..i
            })
        end

        -- Barrière
        for i = 1, 11 do
            table.insert(DataSendPropsGCP.items[4].elements, {
                id = i,
                image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Barrieres/"..i..".webp",
                category="Barrières",
                label = "#"..i
            })
        end

        -- Lumières
        for i = 1, 5 do
            table.insert(DataSendPropsGCP.items[5].elements, {
                id = i,
                image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Lumieres/"..i..".webp",
                category="Lumières",
                label = "#"..i
            })
        end

        -- Tables
        for i = 1, 2 do
            table.insert(DataSendPropsGCP.items[6].elements, {
                id = i,
                image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Tables/"..i..".webp",
                category="Tables",
                label = "#"..i
            })
        end

        -- Drogues
        for i = 1, 9 do
            table.insert(DataSendPropsGCP.items[7].elements, {
                id = i,
                image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Drogues/"..i..".webp",
                category="Drogues",
                label = "#"..i
            })
        end

        -- Divers
        for i = 1, 4 do
            table.insert(DataSendPropsGCP.items[8].elements, {
                id = i,
                image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Divers/"..i..".webp",
                category="Divers",
                label = "#"..i
            })
        end

        -- Cible Tir
        for i = 1, 2 do
            table.insert(DataSendPropsGCP.items[9].elements, {
                id = i,
                image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/CiblesTir/"..i..".webp",
                category="Cibles Tir",
                label = "#"..i
            })
        end

        -- Sacs
        for i = 1, 2 do
            table.insert(DataSendPropsGCP.items[10].elements, {
                id = i,
                image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Sacs/"..i..".webp",
                category="Sacs",
                label = "#"..i
            })
        end


        DataSendPropsGCP.disableSubmit = true

        return true
    end



    RegisterNUICallback("focusOut", function()
        if PropsMenu.open then
            PropsMenu.open = false 
        end
    end)


    DataSendPropsGCP = {
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
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_gcp.webp',
        callbackName = 'MenuObjetsServicesPublicsGCP',
        headerTitle = "OBJETS SERVICES PUBLICS",
        showTurnAroundButtons = false,
    }

    local firstart = false

    OpenPropsMenuGCP = function()
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
            data = DataSendPropsGCP
        }))
    end
end

function UnloadGCPJob()
    GCPDuty = false
end

    -- MENU PROPS

    PropsMenu = {
        cam = nil,
        open = false,
    }

    local cones_models = {
        ['#1']     = "prop_air_conelight",
        ['#2']     = "prop_barrier_wat_03b",
        ['#3']     = "prop_mp_cone_03",
        ['#4']     = "prop_mp_cone_04",
        ['#5']     = "prop_roadcone02a",
        ['#6']     = "prop_roadcone02b",
        ['#7']     = "prop_roadpole_01a",
        ['#8']     = "prop_roadpole_01b",
        ['#9']     = "prop_trafficdiv_01",
        ['#10']     = "prop_trafficdiv_02",
    }

    local panneaux_models = {
        ['#1']     = "prop_consign_01b",
        ['#2']     = "prop_consign_02a",
        ['#3']     = "prop_sign_road_01a",
        ['#4']     = "prop_sign_road_03a",
        ['#5']     = "prop_sign_road_06a",
        ['#6']     = "prop_sign_road_06f",
        ['#7']     = "prop_sign_road_06q",
        ['#8']     = "prop_sign_road_06r",
    }

    local barriere_models = {
        ['#1']     = "prop_barier_conc_05c",
        ['#2']     = "prop_barrier_work01a",
        ['#3']     = "prop_barrier_work01b",
        ['#4']     = "prop_barrier_work02a",
        ['#5']     = "prop_barrier_work06b",
        ['#6']     = "prop_fncsec_04a",
        ['#7']     = "prop_mp_arrow_barrier_01",
        ['#8']     = "prop_mp_barrier_02b",
        ['#9']     = "prop_plas_barier_01a",
        ['#10']     = "prop_barrier_work05",
        ['#11']     = "prop_barrier_work06a",
    }

    local lumiere_models = {
        ['#1']     = "prop_generator_03b",
        ['#2']     = "prop_worklight_01a",
        ['#3']     = "prop_worklight_03b",
        ['#4']     = "prop_worklight_04a",
        ['#5']     = "prop_worklight_04b",
    }

    local tables_models = {
        ['#1']     = "bkr_prop_weed_table_01b",
        ['#2']     = "prop_ven_market_table1",
    }

    local drogues_models = {
        ['#1']     = "bkr_prop_bkr_cashpile_01",
        ['#2']     = "bkr_prop_meth_openbag_02",
        ['#3']     = "bkr_prop_meth_smallbag_01a",
        ['#4']     = "bkr_prop_moneypack_03a",
        ['#5']     = "bkr_prop_weed_med_01a",
        ['#6']     = "bkr_prop_weed_smallbag_01a",
        ['#7']     = "ex_office_swag_drugbag2",
        ['#8']     = "imp_prop_impexp_boxcoke_01",
        ['#9']     = "imp_prop_impexp_coke_pile",
    }

    local divers_models = {
        ['#1']     = "gr_prop_gr_laptop_01c",
        ['#2']     = "prop_ballistic_shield",
        ['#3']     = "prop_gazebo_02",
        ['#4']     = "prop_lssdpio",
    }

    local sacs_models = {
        ['#1']     = "xm_prop_x17_bag_01c",
        ['#2']     = "xm_prop_x17_bag_med_01a",
    }

    local cibletir_models = {
        ['#1']     = "gr_prop_gr_target_05a",
        ['#2']     = "gr_prop_gr_target_05b",
    }


    local gcpPropsPlaced = {}

    local function SpawnPropsGCP(obj, name)
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

                OpenPropsMenuGCP()
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
        table.insert(gcpPropsPlaced, {
            nom = name,
            prop = objS.id
        })
    end


    RegisterNUICallback("MenuObjetsServicesPublicsGCP", function(data, cb)
        -- if data == nil or data.category == nil then return end
        -- PropsMenu.choice = data.category

        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))

        if data.category == "Cones" then 
            SpawnPropsGCP(cones_models[data.label], data.label)
        end
        
        if data.category == "Panneaux" then 
            SpawnPropsGCP(panneaux_models[data.label], data.label)
        end

        if data.category == "Barrières" then 
            SpawnPropsGCP(barriere_models[data.label], data.label)
        end

        if data.category == "Lumières" then 
            SpawnPropsGCP(lumiere_models[data.label], data.label)
        end

        if data.category == "Tables" then 
            SpawnPropsGCP(tables_models[data.label], data.label)
        end

        if data.category == "Drogues" then 
            SpawnPropsGCP(drogues_models[data.label], data.label)
        end

        if data.category == "Divers" then 
            SpawnPropsGCP(divers_models[data.label], data.label)
        end

        if data.category == "Cibles Tir" then 
            SpawnPropsGCP(cibletir_models[data.label], data.label)
        end

        if data.category == "Sacs" then 
            SpawnPropsGCP(sacs_models[data.label], data.label)
        end

    end)

RegisterNUICallback("Menu_gcp_vehicule_callback", function (data, cb)
    local distancenord = GetDistanceBetweenCoords(4953.4311523438, -5287.6376953125, 4.3473677635193, GetEntityCoords(PlayerPedId()))
    if distancenord < 50.0 then
        if vehicle.IsSpawnPointClear(vector3(4953.4311523438, -5287.6376953125, 4.3473677635193), 5.0) then
            -- if DoesEntityExist(vehs) then
            --     TriggerEvent('persistent-vehicles/forget-vehicle', vehs)
            --     DeleteEntity(vehs)
            -- end
            vehs = vehicle.create(data.spawnName, vector4(4953.4311523438, -5287.6376953125, 4.3473677635193, 82.122657775879), {})
                if data.spawnName == "winky" then
                    SetVehicleLivery(vehs, 2)
                elseif data.spawnName == 'mesa3' then
                    SetVehicleLivery(vehs, 1)
                elseif data.spawnName == 'enduromk2' then
                    SetVehicleLivery(vehs, 1)
                elseif data.spawnName == "vetir" then
                    SetVehicleLivery(vehs, 1)
                end
                SetVehicleMod(vehs, 11, 1, false)
                SetVehicleMod(vehs, 12, 1, false)
                SetVehicleMod(vehs, 13, 1, false)
                local plate = vehicle.getProps(vehs).plate
                local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
                local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
                createKeys(plate, model)
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
            if vehicle.IsSpawnPointClear(vector3(4953.4311523438, -5287.6376953125, 4.3473677635193), 3.0) then
                vehs = vehicle.create(data.spawnName, vector4(4953.4311523438, -5287.6376953125, 4.3473677635193, 82.122657775879), {})
                if data.spawnName == "winky" then
                    SetVehicleLivery(vehs, 2)
                elseif data.spawnName == 'mesa3' then
                    SetVehicleLivery(vehs, 1)
                elseif data.spawnName == 'enduromk2' then
                    SetVehicleLivery(vehs, 1)
                elseif data.spawnName == "vetir" then
                    SetVehicleLivery(vehs, 1)
                end
                SetVehicleMod(vehs, 11, 1, false)
                SetVehicleMod(vehs, 12, 1, false)
                SetVehicleMod(vehs, 13, 1, false)
                local plate = vehicle.getProps(vehs).plate
                local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
                local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
                createKeys(plate, model)
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

RegisterNUICallback("Menu_GCP_heli_callback", function (data, cb)
    local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 4882.2211914063, -5282.904296875, 7.4297094345093)
    if distance < 50.0 then
        if vehicle.IsSpawnPointClear(vector3(4882.2211914063, -5282.904296875, 7.4297094345093), 3.0) then
            vehs = vehicle.create(data.spawnName, vector4(4882.2211914063, -5282.904296875, 7.4297094345093, 273.3984375), {})
            -- SetVehicleLivery(vehs, 0)
            if data.spawnName == "buzzard" then
                SetVehicleLivery(vehs, 2)
            elseif data.spawnName == 'valkyrie' then
                SetVehicleLivery(vehs, 1)
            elseif data.spawnName == 'valkyrie2' then
                SetVehicleLivery(vehs, 1)
            end
            local plate = vehicle.getProps(vehs).plate
            local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
            local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
            createKeys(plate, model)
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
        if vehicle.IsSpawnPointClear(vector3(4882.2211914063, -5282.904296875, 7.4297094345093), 3.0) then
            vehs = vehicle.create(data.spawnName, vector4(4882.2211914063, -5282.904296875, 7.4297094345093, 273.3984375), {})
            -- SetVehicleLivery(vehs, 0)
            if data.spawnName == "buzzard" then
                SetVehicleLivery(vehs, 2)
            elseif data.spawnName == 'valkyrie' then
                SetVehicleLivery(vehs, 1)
            elseif data.spawnName == 'valkyrie2' then
                SetVehicleLivery(vehs, 1)
            end
            local plate = vehicle.getProps(vehs).plate
            local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
            local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
            createKeys(plate, model)
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

RegisterNUICallback("Menu_GCP_boat_callback", function (data, cb)
    if vehicle.IsSpawnPointClear(vector3(0, 0, 0), 3.0) then
        vehs = vehicle.create(data.spawnName, vector4(0, 0, 0, 0), {})
        if data.spawnName == 'polpreda' then
            SetVehicleLivery(vehs, 1)
        end
        local plate = vehicle.getProps(vehs).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
        createKeys(plate, model)
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

RegisterNUICallback("armoryTakeGCP", function(data, cb)
    for k, v in pairs(data) do
        TriggerSecurGiveEvent("core:addItemToInventory", token, v.name, 1, {})
        exports['vNotif']:createNotification({
            type = 'DOLLAR',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous venez de récupérer ~s un(e) ".. v.label
        })
    end
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
end)

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7gcp ^3loaded")
end)