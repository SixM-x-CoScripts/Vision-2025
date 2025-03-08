local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local policePropsPlaced = {}
local created = false

local vehSpawnPos = {
    vector4(-2327.99, 3267.28, 32.83, 335.79),
}

CreateThread(function()
    while zone == nil do Wait(1) end

    local pedsData = {
        { model = "s_m_m_armoured_02", position = vector3(-2358.33, 3255.29, 31.81), heading = 234.89, scenario = "WORLD_HUMAN_GUARD_STAND" },
        { model = "s_m_m_armoured_02", position = vector3(-2324.22, 3261.14, 31.83), heading = 57.97, scenario = "WORLD_HUMAN_CLIPBOARD" },
        { model = "s_m_m_armoured_02", position = vector3(-2084.76, 3119.99, 31.81), heading = 234.68, scenario = "WORLD_HUMAN_CLIPBOARD" },

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

usmcDuty = false

function LoadUSMCJob()
    local casierPos = {
        vector3(-216.15, -822.31, 30.68),
    }

    local armureriePos = vector3(-2347.2, 3269.2, 32.81)
    local garagePos = vector4(-2327.99, 3267.28, 32.83, 335.79)
    local garagePos = vector3(-2324.66, 3261.38, 32.83)
    local customVehPos = vector3(-2324.19, 3252.67, 32.83)
    local garagePedPos = vector3(-2324.66, 3261.38, 32.83)
    local societyPos = vector3(-235.29, -825.4, 30.68)
    local stockagePos = vector3(-223.93, -820.96, 30.68)
    local vestiairePos = vector3(-2357.85, 3255.07, 32.81)

    local vehicleOut = nil
    local currentVeh = nil

    local items = {
        headerImage = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Banners/USMC.webp",
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Banners/icon.webp',
        headerIconName = 'CATALOGUE',
        callbackName = 'armoryTakeUSMC',
        showTurnAroundButtons = false,
        multipleSelection = true,
        elements = {
            --[[ {
				image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/weapon_bzgas.webp",
				price = 0,
				id = 1,
				name = "weapon_bzgas",
				label = "GAZ BZ",
			}, ]]
            {
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Kevlar_leger.webp",
                price = 0,
                id = 2,
                name = "usmckev",
                label = "Gilet de kevlar Officer",
            },
            {
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Kevlar_lourd.webp",
                price = 0,
                id = 3,
                name = "usmckev2",
                label = "Gilet de kevlar Supervisor",
            },
            --[[ {
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Lampe_torche.webp",
                price = 0,
                id = 4,
                name = "weapon_flashlight",
                label = "Lampe torche",
            },
            {
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Matraque.webp",
                price = 0,
                id = 5,
                name = "weapon_nightstick",
                label = "Matraque",
            }, ]]
            {
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Radio.webp",
                price = 0,
                id = 6,
                name = "radio",
                label = "Radio",
            },
            {
                price = 0,
                id = 7,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Fumigene.webp",
                name = "weapon_pepperspray",
                label = "PepperSpray"
            }
        }
    }

    function OpenUSMCITEMMenu()
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

    function USMCAnnounce()
        if usmcDuty then
            local annonce = KeyboardImput("Entrez le contenu de l'annonce")
            if annonce ~= "" and type(annonce) == "string" then
                TriggerServerEvent("core:makeAnnounceUSMC", token, annonce)
            else
                -- ShowNotification("~r~Veuillez entrer un texte valide")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Veuillez entrer un texte valide"
                })
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

    zone.addZone("usmc_item", armureriePos,
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir l'armurerie ", function()
            OpenUSMCITEMMenu()
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

    zone.addZone("usmc_garage", vector3(garagePos.x, garagePos.y, garagePos.z),
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

    zone.addZone("society_usmc_custom", customVehPos,
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
        2.0,
        true,
        "bulleCustom"
    )

    zone.addZone("usmc_garage_vehicle", garagePedPos,
        "~INPUT_CONTEXT~ Véhicules", function()
            print("open garage")
            openGarageMenu()
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


    zone.addZone("society_usmc", societyPos,
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

    zone.addZone("stockage_usmc", stockagePos,
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le stockage USMC", function()
            OpenInventorySocietyMenu() -- TODO: fini le menu society
        end, false, 25,                -- Id / type du marker
        0.6,                           -- La taille
        { 51, 204, 255 },              -- RGB
        170,                           -- Alpha
        1.5,
        true,
        "bulleStock"
    )

    zone.addZone("vestiaire_usmc", vestiairePos,
        "Appuyer sur ~INPUT_CONTEXT~ pour prendre une tenue", function()
            LoadVestiaireUSMC() -- TODO: fini le menu society
        end, false,
        27,
        0.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleVetement"
    )

    for k, v in pairs(casierPos) do
        zone.addZone("coffre_usmc" .. k, v, "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les casiers",
            function()
                OpenusmcCasier() -- TODO: fini le menu society
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

    -- DEV
    local tenueH = {
        ['tshirt_1'] = 217,
        ['tshirt_2'] = 0,
        ['torso_1'] = 484,
        ['torso_2'] = 0,
        ['arms'] = 11,
        ['arms_2'] = 0,
        ['pants_1'] = 170,
        ['pants_2'] = 2,
        ['shoes_1'] = 130,
        ['shoes_2'] = 0,
        ['bags_1'] = 140,
        ['bags_2'] = 0,
        ['chain_1'] = 172,
        ['chain_2'] = 0,
        ['bproof_1'] = 0,
        ['bproof_2'] = 0,
        ['helmet_1'] = -1,
        ['helmet_2'] = 0
    }
    local tenueF = {
        ['tshirt_1'] = 255,
        ['tshirt_2'] = 0,
        ['torso_1'] = 520,
        ['torso_2'] = 0,
        ['arms'] = 9,
        ['arms_2'] = 0,
        ['pants_1'] = 175,
        ['pants_2'] = 0,
        ['shoes_1'] = 134,
        ['shoes_2'] = 0,
        ['bags_1'] = 134,
        ['bags_2'] = 0,
        ['chain_1'] = 141,
        ['chain_2'] = 0,
        ['bproof_1'] = 0,
        ['bproof_2'] = 0,
        ['helmet_1'] = -1,
        ['helmet_2'] = 0
    }

    local openRadial = false

    local open = false
    local usmcmenu_objects = RageUI.CreateMenu("", "usmc", 0.0, 0.0, "vision", "menu_title_usmc")
    local usmcmenu_traffic = RageUI.CreateMenu("", "usmc", 0.0, 0.0, "vision", "menu_title_usmc")
    local usmcmenu_traffic_add = RageUI.CreateSubMenu(usmcmenu_traffic, "", "usmc", 0.0, 0.0, "vision", "menu_title_usmc")
    local usmcmenu_traffic_view = RageUI.CreateSubMenu(usmcmenu_traffic, "", "usmc", 0.0, 0.0, "vision", "menu_title_usmc")
    local usmcmenu_objects_delete = RageUI.CreateSubMenu(usmcmenu_objects, "", "usmc", 0.0, 0.0, "vision", "menu_title_usmc")

    usmcmenu_objects.Closed = function()
        open = false
    end

    usmcmenu_traffic.Closed = function()
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
        if usmcDuty then
            openRadial = false
            closeUI()
            -- open a menu with 2 buttons : one to add a new zone and one to view my zones
            if open then
                open = false
                RageUI.Visible(usmcmenu_traffic, false)
            else
                open = true
                RageUI.Visible(usmcmenu_traffic, true)

                Citizen.CreateThread(function()
                    while open do
                        RageUI.IsVisible(usmcmenu_traffic, function()
                            -- for the first button to add a new zone, it opens a menu where i can set the speed in the zone and the radius of the zone, another checkbox to show it on my client and a last button to add the zone
                            RageUI.Button("Ajouter une zone", nil, {
                                RightLabel = ">"
                            }, true, {
                                onSelected = function()
                                    zonePos = p:pos()
                                end
                            }, usmcmenu_traffic_add)
                            -- for the second button to view my zones, it opens a menu where i can see all my zones and delete them
                            RageUI.Button("Voir les zones", nil, {
                                RightLabel = ">"
                            }, true, {
                                onSelected = function()
                                    traficList = TriggerServerCallback("usmc:traffic:get")
                                end
                            }, usmcmenu_traffic_view)
                        end)
                        RageUI.IsVisible(usmcmenu_traffic_add, function()
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
                                        TriggerServerEvent("usmc:traffic:add", newZone)
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
                        RageUI.IsVisible(usmcmenu_traffic_view, function()
                            for k, v in pairs(traficList) do
                                RageUI.Button(v.zoneId .. " | " .. v.zoneName, nil, {
                                    RightLabel = "~r~ Supprimer"
                                }, true, {
                                    onSelected = function()
                                        RemoveRoadNodeSpeedZone(v.zoneId)
                                        TriggerServerEvent("usmc:traffic:remove", v.zoneId)
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

    function policeActionDuty()
        openRadial = false
        closeUI()
        if usmcDuty then
            TriggerServerEvent('core:DutyOff', 'usmc')
            --[[             ShowAdvancedNotification("Centrale", "~b~Dispatch", "Vous avez quitté votre service", "CHAR_CALL911",
                "CHAR_CALL911") ]]

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s quitté ~c votre service"
            })

            usmcDuty = false
            Wait(5000)
        else
            TriggerServerEvent('core:DutyOn', 'usmc')
            --[[             ShowAdvancedNotification("Centrale", "~b~Dispatch", "Vous avez pris votre service", "CHAR_CALL911",
                "CHAR_CALL911") ]]

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s pris ~c votre service"
            })

            usmcDuty = true
            Wait(5000)
        end
    end

    function makeRenfortCall()
        if usmcDuty then
            TriggerSecurEvent('core:makeCall', "usmc", p:pos(), false,
                "Appel de renfort (" .. p:getLastname() .. " " .. p:getFirstname() .. ")")
            ExecuteCommand("me fait un appel de renfort")
            -- p:PlayAnim('amb@code_human_usmc_investigate@idle_a', 'idle_b', 51)
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

    function makePanicCall()
        if usmcDuty then
            TriggerSecurEvent('core:makeCall', "usmc", p:pos(), false,
                "PANIC BUTTON (" .. p:getLastname() .. " " .. p:getFirstname() .. ")")
            ExecuteCommand("me fait un appel de renfort")
            -- p:PlayAnim('amb@code_human_usmc_investigate@idle_a', 'idle_b', 51)
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

    function FactureUSMC()
        if usmcDuty then
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
        if usmcDuty then
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

    function OpenRadialUSMCMenu()
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
                            elements = {
                                {
                                    name = "APPEL DE RENFORT",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/police_logo.svg",
                                    action = "makeRenfortCall"
                                },
                                {
                                    name = "PANIC BUTTON",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/police_logo.svg",
                                    action = "makePanicCall"
                                },
                                {
                                    name = "RETOUR",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                    action = "OpenMainRadialUSMC"
                                }
                            },
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
                                    name = "FACTURE",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/billet.svg",
                                    action = "FactureUSMC"
                                },
                                {
                                    name = "RETOUR",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                    action = "OpenMainRadialUSMC"
                                },
                            },
                            title = "PAPIERS"
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
                                    action = "OpenMainRadialUSMC"
                                },
                                {
                                    name = "OBJETS",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/object.svg",
                                    action = "OpenPropsMenuUSMC"
                                },
                            },
                            title = "ACTIONS"
                        }
                    }));
                end

                function OpenMainRadialUSMC()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = {
                            elements = { {
                                name = "APPEL DE RENFORT",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/police_logo.svg",
                                action = "OpenSubRadialRenfort"
                            }, {
                                name = "PAPIERS",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/paper.svg",
                                action = "OpenSubRadialPapiers"
                            }, {
                                name = "PRISE DE SERVICE",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/checkmark.svg",
                                action = "policeActionDuty"
                            }, {
                                name = "ACTIONS",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/police.svg",
                                action = "OpenSubRadialActions"
                            } },
                            title = "USMC"
                        }
                    }));
                end

                OpenMainRadialUSMC()
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
        Bulle.show("police_garage_vehicle")
        Bulle.show("police_garage_vehicle")
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

    RegisterJobMenu(OpenRadialUSMCMenu)

    local oldSkin = {}
    local open = false
    local outifitmenu = RageUI.CreateMenu("", "usmc", 0.0, 0.0, "vision", "menu_title_usmc")
    local outfitmenu_list = RageUI.CreateSubMenu(outifitmenu, "", "usmc", 0.0, 0.0, "vision", "menu_title_usmc")
    outifitmenu.Closed = function()
        local playerSkin = p:skin()
        ApplySkin(oldSkin)
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
            oldSkin = p:skin()
            Citizen.CreateThread(function()
                while open do
                    RageUI.IsVisible(outifitmenu, function()
                        for k, v in pairs(police.outfit) do
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

    local plyInGarage = false

    local defaultVehExpo = { {
        pos = vector3(1310.1032714844, 228.28462219238, -50.005670166016),
        heading = 88.874877929688,
        model = "police2"
    }, {
        pos = vector3(1310.1687011719, 231.40347290039, -50.005670166016),
        heading = 270.60833740234,
        model = "police"
    }, {
        pos = vector3(1309.8950195313, 246.94641113281, -50.005670166016),
        heading = 88.889739990234,
        model = "police3"
    }, {
        pos = vector3(1294.9595947266, 239.01225280762, -50.005670166016),
        heading = 270.05737304688,
        model = "police"
    }, {
        pos = vector3(1280.6026611328, 244.06103515625, -50.005670166016),
        heading = 270.41748046875,
        model = "fbi"
    }, {
        pos = vector3(1280.5715332031, 251.97434997559, -50.005670166016),
        heading = 90.602905273438,
        model = "riot"
    } }

    local vehExpo = nil

    local function LoadCarsinGarage()
        for k, v in pairs(defaultVehExpo) do
            vehExpo = entity:CreateVehicleLocal(v.model, v.pos, v.heading)
            vehExpo:setFreeze(true)
            SetVehicleDoorsLocked(vehExpo:getEntityId(), true)
            SetVehicleUndriveable(vehExpo:getEntityId(), true)
            SetVehicleDirtLevel(vehExpo:getEntityId(), 0.0)
        end
    end

    function enterInGarage()
        RequestIpl("vw_casino_garage")
        while not IsIplActive("vw_casino_garage") do
            Wait(1)
        end
        plyInGarage = true
        SetEntityCoords(p:ped(), garagePos.x, garagePos.y, garagePos.z)
        SetEntityHeading(p:ped(), garagePos.w)
        Wait(100)

        zone.addZone("usmc_garage_exit", vector3(1295.2905273438, 217.6827545166, -49.055416107178),
            "Appuyer sur ~INPUT_CONTEXT~ pour sortir du garage", function()
                leaveGarage()
            end, false)
        LoadCarsinGarage()
    end

    function leaveGarage()
        vehExpo:delete()
        Wait(100)
        SetEntityCoords(p:ped(), -1069.8516845703, -855.00463867188, 4.8674259185791)
        SetEntityHeading(p:ped(), 216.99613952637)
        plyInGarage = false
        zone.removeZone("police_garage_vehicle")
        zone.removeZone("police_garage_exit")
    end

    local open = false
    local usmcgarage_main = RageUI.CreateMenu("", "usmc", 0.0, 0.0, "vision", "menu_title_usmc")
    local usmcgarage_vehicle =
        RageUI.CreateSubMenu(usmcgarage_main, "", "usmc", 0.0, 0.0, "vision", "menu_title_usmc")
    usmcgarage_main.Closed = function()
        open = false
    end

    local allVehicleList = {}
    local selected_vehicle = nil

    local vehs = nil
    ---OpenVeh

    local listVeh = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_usmc.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
        headerIconName = 'VEHICULE',
        callbackName = 'Menu_USMC_vehicule_callback',
        elements = {{
            label = 'Crusader',
            spawnName = 'crusader',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/USMC/crusader.webp",
            category = 'Vehicle',
            subCategory = 'Patrol'
        }, {
            label = 'Barracks',
            spawnName = 'barracks',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/USMC/barracks.webp",
            category = 'Vehicle',
            subCategory = 'Patrol'
        }, {
            label = 'Insurgent',
            spawnName = 'insurgent2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/USMC/insurgent2.webp",
            category = 'Vehicle',
            subCategory = 'Patrol'
        }, {
            label = 'Winky',
            spawnName = 'winky',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/USMC/winky.webp",
            category = 'Vehicle',
            subCategory = 'Patrol'
        }}
    }

    function openGarageMenu()
        Bulle.hide("police_garage_vehicle")
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listVeh
        }))
    end

    RegisterNUICallback("focusOut", function(data, cb)
        TriggerScreenblurFadeOut(0.5)
        DisplayHud(true)
        openRadarProperly()
    end)

    RegisterNetEvent("core:usmcGetVehGarage")
    AddEventHandler("core:usmcGetVehGarage", function(data)
        allVehicleList = data
    end)

    RegisterNetEvent("core:usmcSpawnVehicle")
    AddEventHandler("core:usmcSpawnVehicle", function(data)
        currentVeh = data
        local veh = vehicle.create(data.name,
            vector4(-1061.701171875, -853.28356933594, 4.475266456604, 218.39852905273), {})
    end)

    local casierOpen = false
    function OpenusmcCasier()
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
                        count = 99
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

    -- MENU PROPS

    local function GetDatasProps()
        -- DataSendPropsUSMC.items.elements = {}

        local playerJobs = 'usmc-lssd'

        -- Cones
        for i = 1, 10 do
            table.insert(DataSendPropsUSMC.items[2].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/Cones/" .. i .. ".webp",
                category = "Cones",
                label = "#" .. i
            })
        end

        -- Panneaux
        for i = 1, 8 do
            table.insert(DataSendPropsUSMC.items[3].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/Panneaux/" .. i .. ".webp",
                category = "Panneaux",
                label = "#" .. i
            })
        end

        -- Barrière
        for i = 1, 11 do
            table.insert(DataSendPropsUSMC.items[4].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/Barrieres/" .. i .. ".webp",
                category = "Barrières",
                label = "#" .. i
            })
        end

        -- Lumières
        for i = 1, 5 do
            table.insert(DataSendPropsUSMC.items[5].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/Lumieres/" .. i .. ".webp",
                category = "Lumières",
                label = "#" .. i
            })
        end

        -- Tables
        for i = 1, 2 do
            table.insert(DataSendPropsUSMC.items[6].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/Tables/" .. i .. ".webp",
                category = "Tables",
                label = "#" .. i
            })
        end

        -- Drogues
        for i = 1, 9 do
            table.insert(DataSendPropsUSMC.items[7].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/Drogues/" .. i .. ".webp",
                category = "Drogues",
                label = "#" .. i
            })
        end

        -- Divers
        for i = 1, 4 do
            table.insert(DataSendPropsUSMC.items[8].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/Divers/" .. i .. ".webp",
                category = "Divers",
                label = "#" .. i
            })
        end

        -- Cible Tir
        for i = 1, 2 do
            table.insert(DataSendPropsUSMC.items[9].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/CiblesTir/" .. i .. ".webp",
                category = "Cibles Tir",
                label = "#" .. i
            })
        end

        -- Sacs
        for i = 1, 2 do
            table.insert(DataSendPropsUSMC.items[10].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" ..
                    playerJobs .. "/Sacs/" .. i .. ".webp",
                category = "Sacs",
                label = "#" .. i
            })
        end

        DataSendPropsUSMC.disableSubmit = true

        return true
    end

    PropsMenu = {
        cam = nil,
        open = false
    }

    RegisterNUICallback("focusOut", function()
        if PropsMenu.open then
            PropsMenu.open = false
        end
    end)

    DataSendPropsUSMC = {
        items = { {
            name = 'main',
            type = 'buttons',
            elements = { {
                name = 'Cones',
                width = 'full',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/cones.svg',
                hoverStyle = ' stroke-black'
            }, {
                name = 'Panneaux',
                width = 'full',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/roadsign.svg',
                hoverStyle = ' stroke-black'
            }, {
                name = 'Barrières',
                width = 'full',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/barriere.svg',
                hoverStyle = ' stroke-black'
            }, {
                name = 'Lumières',
                width = 'full',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/light.svg',
                hoverStyle = ' stroke-black'
            }, {
                name = 'Tables',
                width = 'full',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/table.svg',
                hoverStyle = ' stroke-black'
            }, {
                name = 'Drogues',
                width = 'full',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/drogues.svg',
                hoverStyle = ' stroke-black'
            }, {
                name = 'Divers',
                width = 'full',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/divers.svg',
                hoverStyle = ' stroke-black'
            }, {
                name = 'Cibles Tir',
                width = 'full',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/ciblestir.svg',
                hoverStyle = ' stroke-black'
            }, {
                name = 'Sacs',
                width = 'full',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/sacs.svg',
                hoverStyle = ' stroke-black'
            } }
        }, {
            name = 'Cones',
            type = 'elements',
            elements = {}
        }, {
            name = 'Panneaux',
            type = 'elements',
            elements = {}
        }, {
            name = 'Barrières',
            type = 'elements',
            elements = {}
        }, {
            name = 'Lumières',
            type = 'elements',
            elements = {}
        }, {
            name = 'Tables',
            type = 'elements',
            elements = {}
        }, {
            name = 'Drogues',
            type = 'elements',
            elements = {}
        }, {
            name = 'Divers',
            type = 'elements',
            elements = {}
        }, {
            name = 'Cibles Tir',
            type = 'elements',
            elements = {}
        }, {
            name = 'Sacs',
            type = 'elements',
            elements = {}
        } },

        -- headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
        -- headerIconName = 'Cones',
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_usmc.webp',
        callbackName = 'MenuObjetsServicesPublicsUSMC',
        headerTitle = "OBJETS GRUPPE SECHS",
        showTurnAroundButtons = false
    }

    local firstart = false

    OpenPropsMenuUSMC = function()
        if firstart == false then
            firstart = true
            local bool = GetDatasProps()
            while not bool do
                Wait(1)
            end
        end
        SendNuiMessage(json.encode({
            type = 'closeWebview'
        }))
        Wait(50)
        PropsMenu.open = true
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuObjetsServicesPublics',
            data = DataSendPropsUSMC
        }))
    end
end

function UnloadUSMCJob()
    zone.removeZone("coffre_usmc")
    zone.removeZone("usmcOutfit")
    zone.removeZone("police_garage")
    zone.removeZone("society_usmc")
    zone.removeZone("stockage_usmc")
    zone.removeZone("stockage_usmc2")
    zone.removeZone("police_item")
    zone.removeZone("police_item2")
    zone.removeZone("police_garage_vehicle")
    zone.removeZone("police_garage_vehicle2")
    usmcDuty = false
end

RegisterNUICallback("Menu_USMC_vehicule_callback", function(data, cb)
    for key, value in pairs(vehSpawnPos) do
        if vehicle.IsSpawnPointClear(vector3(value.x, value.y, value.z), 3.0) then
            vehs = vehicle.create(data.spawnName, vector4(value), {})
            SetVehicleMod(vehs, 11, 3, false)
            SetVehicleMod(vehs, 12, 2, false)
            SetVehicleMod(vehs, 13, 2, false)
            SetVehicleMod(vehs, 18, 1, false)

            if data.spawnName == "usmcbuffalo6" then
                SetVehicleLivery(vehs, 6)
            elseif data.spawnName == 'usmcscout5' then
                SetVehicleLivery(vehs, 3)
            elseif data.spawnName == 'usmcalamo4' then
                SetVehicleLivery(vehs, 6)
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

RegisterNUICallback("armoryTakeUSMC", function(data, cb)
    for k, v in pairs(data) do
        TriggerSecurGiveEvent("core:addItemToInventory", token, v.name, 1, {})
        exports['vNotif']:createNotification({
            type = 'DOLLAR',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous venez de récupérer ~s un(e) " .. v.label
        })
    end
    SendNuiMessage(json.encode({
        type = 'closeWebview'
    }))
end)

local function SpawnPropsUSMC(obj, name)
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

            OpenPropsMenuUSMC()
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
    table.insert(policePropsPlaced, {
        nom = name,
        prop = objS.id
    })
end

local cones_models = {
    ['#1'] = "prop_air_conelight",
    ['#2'] = "prop_barrier_wat_03b",
    ['#3'] = "prop_mp_cone_03",
    ['#4'] = "prop_mp_cone_04",
    ['#5'] = "prop_roadcone02a",
    ['#6'] = "prop_roadcone02b",
    ['#7'] = "prop_roadpole_01a",
    ['#8'] = "prop_roadpole_01b",
    ['#9'] = "prop_trafficdiv_01",
    ['#10'] = "prop_trafficdiv_02"
}

local panneaux_models = {
    ['#1'] = "prop_consign_01b",
    ['#2'] = "prop_consign_02a",
    ['#3'] = "prop_sign_road_01a",
    ['#4'] = "prop_sign_road_03a",
    ['#5'] = "prop_sign_road_06a",
    ['#6'] = "prop_sign_road_06f",
    ['#7'] = "prop_sign_road_06q",
    ['#8'] = "prop_sign_road_06r"
}

local barriere_models = {
    ['#1'] = "prop_barier_conc_05c",
    ['#2'] = "prop_barrier_work01a",
    ['#3'] = "prop_barrier_work01b",
    ['#4'] = "prop_barrier_work02a",
    ['#5'] = "prop_barrier_work06b",
    ['#6'] = "prop_fncsec_04a",
    ['#7'] = "prop_mp_arrow_barrier_01",
    ['#8'] = "prop_mp_barrier_02b",
    ['#9'] = "prop_plas_barier_01a",
    ['#10'] = "prop_barrier_work05",
    ['#11'] = "prop_barrier_work06a"
}

local lumiere_models = {
    ['#1'] = "prop_generator_03b",
    ['#2'] = "prop_worklight_01a",
    ['#3'] = "prop_worklight_03b",
    ['#4'] = "prop_worklight_04a",
    ['#5'] = "prop_worklight_04b"
}

local tables_models = {
    ['#1'] = "bkr_prop_weed_table_01b",
    ['#2'] = "prop_ven_market_table1"
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
    ['#9'] = "imp_prop_impexp_coke_pile"
}

local divers_models = {
    ['#1'] = "gr_prop_gr_laptop_01c",
    ['#2'] = "prop_ballistic_shield",
    ['#3'] = "prop_gazebo_02",
    ['#4'] = "prop_usmcpio"
}

local sacs_models = {
    ['#1'] = "xm_prop_x17_bag_01c",
    ['#2'] = "xm_prop_x17_bag_med_01a"
}

local cibletir_models = {
    ['#1'] = "gr_prop_gr_target_05a",
    ['#2'] = "gr_prop_gr_target_05b"
}

RegisterNUICallback("MenuObjetsServicesPublicsUSMC", function(data, cb)
    -- if data == nil or data.category == nil then return end
    -- PropsMenu.choice = data.category

    SendNuiMessage(json.encode({
        type = 'closeWebview'
    }))

    if data.category == "Cones" then
        SpawnPropsUSMC(cones_models[data.label], data.label)
    end

    if data.category == "Panneaux" then
        SpawnPropsUSMC(panneaux_models[data.label], data.label)
    end

    if data.category == "Barrières" then
        SpawnPropsUSMC(barriere_models[data.label], data.label)
    end

    if data.category == "Lumières" then
        SpawnPropsUSMC(lumiere_models[data.label], data.label)
    end

    if data.category == "Tables" then
        SpawnPropsUSMC(tables_models[data.label], data.label)
    end

    if data.category == "Drogues" then
        SpawnPropsUSMC(drogues_models[data.label], data.label)
    end

    if data.category == "Divers" then
        SpawnPropsUSMC(divers_models[data.label], data.label)
    end

    if data.category == "Cibles Tir" then
        SpawnPropsUSMC(cibletir_models[data.label], data.label)
    end

    if data.category == "Sacs" then
        SpawnPropsUSMC(sacs_models[data.label], data.label)
    end
end)

RegisterNetEvent("usmc:traffic:addclient", function(zone)
    AddRoadNodeSpeedZone(zone.zonePos, zone.zoneRadius, zone.zoneSpeed, true)
end)

RegisterNetEvent("usmc:traffic:removeclient", function(zone)
    RemoveRoadNodeSpeedZone(zone)
end)

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7usmc ^3loaded")
end)
