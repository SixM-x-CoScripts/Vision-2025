local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local colors_list = {
    { id = 1,  name = "Noir" },
    { id = 5,  name = "Gris" },
    { id = 74, name = "Blanc" },
    --{ id = 158, name = "dorée" },
}

local gestion = vector3(-788.63616943359, -1345.9036865234, 4.1785078048706)
local coffre = vector3(-788.83337402344, -1344.7885742188, 8.035361289978)
local casier = vector3(-790.93701171875, -1350.3780517578, 4.1785063743591)

local essaieAero = vector4(-979.75152587891, -2997.6594238281, 12.945077896118, 56.049507141113)
local essaieWater = vector4(-733.09143066406, -1374.5495605469, -1.4745574891567, 134.09315490723)

local spawnBigBoat = vector4(-733.09143066406, -1374.5495605469, -1.4745574891567, 134.09315490723)
local spawnNormalBoat = vector4(-768.54815673828, -1378.7236328125, -1.4747704863548, 230.43048095703)

local spawnNormalAero = vector4(-979.75152587891, -2997.6594238281, 12.945077896118, 56.049507141113)

local testDeleteBoat = vector3(-237.84963989258, 6233.5532226563, 30.501665115356)
local testDeleteAero = vector3(-237.84963989258, 6233.5532226563, 30.501665115356)

local menuVeh = vector3(-810.70941162109, -1340.2717285156, 4.1504802703857)
local spawnVehMenu = vector4(-811.19329833984, -1324.7645263672, 4.0003814697266, 75.28581237793)
local deleteVeh = vector3(-814.81701660156, -1329.5904541016, 4.0003800392151)

local color = 1
local inService = false
function LoadHeliwaveJob()
    local inService = false
    local openRadial = false

    zone.addZone(
        "heliwave_delete",
        deleteVeh + vector3(0.0, 0.0, 1.0),
        "Appuyer sur ~INPUT_CONTEXT~ pour ranger le véhicule",
        function()
            if IsPedInAnyVehicle(p:ped(), false) then
                if GetVehicleBodyHealth(p:currentVeh()) / 10 >= 80 or
                    GetVehicleEngineHealth(p:currentVeh()) / 10 >= 80 then
                    local veh = GetVehiclePedIsIn(p:ped(), false)
                    removeKeys(GetVehicleNumberPlateText(veh),
                        GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                    TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                    TriggerEvent('persistent-vehicles/forget-vehicle', veh)
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
        false,
        36, 0.5, { 255, 0, 0 }, 255, -- Alpha
        2.0,
        true,
        "bulleGarage"
    )

    zone.addZone(
        "heliwave_spawn",
        menuVeh + vector3(0.0, 0.0, 1.0),
        "Appuyer sur ~INPUT_CONTEXT~ pour sortir le véhicule",
        function()
            if inService then
                OpenMenuVehHeliwave() --TODO: fini le menu society
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
        false,
        36, 0.5, { 255, 0, 0 }, 255, -- Alpha
        2.0,
        true,
        "bulleVehicule"
    )

    local listVeh = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/heliwave.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
        headerIconName = 'VEHICULES',
        callbackName = 'vehMenuHeliwave',
        elements = {
            {
                id = 1,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Heliwave/sadler.webp',
                label = 'Sadler',
                name = "sadler"
            },
            {
                id = 2,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Pawnshop/20fttrailer.webp',
                label = 'Remorque bateau',
                name = "boattrailer"
            },
            {
                id = 3,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Heliwave/packer.webp',
                label = 'Packer',
                name = "packer"
            },
            {
                id = 4,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Heliwave/freighttrailer.webp',
                label = 'Remorque bateau',
                name = "freighttrailer"
            },
        }
    }

    function OpenMenuVehHeliwave()
        forceHideRadar()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listVeh
        }))
    end

    zone.addZone("heliwave_gestionsociety",           -- Nom
        gestion + vector3(0.0, 0.0, 1.0),             -- Position
        "Appuyer sur ~INPUT_CONTEXT~ pour interagir", -- Text afficher
        function()                                    -- Action qui seras fait
            if inService then
                OpenSocietyMenu()
            else
                -- ShowNotification("~r~Vous n'êtes pas en service")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous n'êtes ~s pas en service"
                })
            end
        end, false,       -- Avoir un marker ou non
        25,               -- Id / type du marker
        0.6,              -- La taille
        { 51, 204, 255 }, -- RGB
        170,              -- Alpha
        2.0,
        true,
        "bulleGestion"
    )

    zone.addZone("heliwave_inventory",                -- Nom
        coffre + vector3(0.0, 0.0, 1.0),              -- Position
        "Appuyer sur ~INPUT_CONTEXT~ pour interagir", -- Text afficher
        function()                                    -- Action qui seras fait
            if inService then
                OpenInventorySocietyMenu()
            else
                -- ShowNotification("~r~Vous n'êtes pas en service")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous n'êtes ~s pas en service"
                })
            end
        end, false,       -- Avoir un marker ou non
        25,               -- Id / type du marker
        0.6,              -- La taille
        { 51, 204, 255 }, -- RGB
        170,              -- Alpha
        2.0,
        true,
        "bulleCoffre"
    )

    zone.addZone("concess_gestion",                                  -- Nom
        vector3(-793.64630126953, -1349.9300537109, 5.178514957428), -- Position
        "Appuyer sur ~INPUT_CONTEXT~ pour interagir",                -- Text afficher
        function()                                                   -- Action qui seras fait
            if inService then
                openGestionHeliwaveMenu()
            else
                -- ShowNotification("~r~Vous n'êtes pas en service")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous n'êtes ~s pas en service"
                })
            end
        end, false,       -- Avoir un marker ou non
        25,               -- Id / type du marker
        0.6,              -- La taille
        { 51, 204, 255 }, -- RGB
        170,              -- Alpha
        2.0,
        true,
        "bulleGestion"
    )

    local function closestPlayer()
        local players = GetActivePlayers()
        local closestDistance = -1
        local closestPlayer = -1
        local ply = PlayerPedId()
        local plyCoords = GetEntityCoords(ply, 0)

        for index, value in ipairs(players) do
            local target = GetPlayerPed(value)
            if (target ~= ply) then
                local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
                local distance = GetDistanceBetweenCoords(targetCoords["x"], targetCoords["y"], targetCoords["z"],
                    plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
                if (closestDistance == -1 or closestDistance > distance) then
                    closestPlayer = value
                    closestDistance = distance
                end
            end
        end
        return closestPlayer, closestDistance
    end

    local open = false
    local selected_category
    local selected_vehicle
    local stockmenu_main =
        RageUI.CreateMenu("", "Gérer le stock", 0.0, 0.0, "root_cause", "shopui_title_premiumdeluxe")
    local stockmenu_category = RageUI.CreateSubMenu(stockmenu_main, "", "Gérer le stock", 0.0, 0.0, "root_cause",
        "shopui_title_premiumdeluxe")
    local stockmenu_buy = RageUI.CreateSubMenu(stockmenu_category, "", "Gérer le stock", 0.0, 0.0, "root_cause",
        "shopui_title_premiumdeluxe")
    stockmenu_main.Closed = function()
        open = false
    end

    local concessStock = {}

    function openStockMenu()
        if open then
            open = false
            RageUI.Visible(stockmenu_main, false)
        else
            open = true
            openRadial = false
            closeUI()
            RageUI.Visible(stockmenu_main, true)

            CreateThread(function()
                while open do
                    RageUI.IsVisible(stockmenu_main, function()
                        for k, v in pairs(heliwave.vehicle) do
                            RageUI.Button(k, nil, {}, true, {
                                onSelected = function()
                                    selected_category = v
                                end
                            }, stockmenu_category)
                        end
                    end)
                    RageUI.IsVisible(stockmenu_category, function()
                        for i = 1, #selected_category, 1 do
                            RageUI.Button(
                                GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(selected_category[i].name)))
                                , nil,
                                {
                                    RightLabel = "~g~" .. selected_category[i].price .. "$"
                                }, true, {
                                    onSelected = function()
                                        selected_vehicle = selected_category[i]
                                    end
                                }, stockmenu_buy)
                        end
                    end)
                    RageUI.IsVisible(stockmenu_buy, function()
                        RageUI.Separator("Vehicule: " ..
                            GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(selected_vehicle.name))))
                        RageUI.Separator("Prix: " .. selected_vehicle.price)
                        RageUI.Button("Acheter", nil, {
                            RightLabel = ">"
                        }, true, {
                            onSelected = function()
                                TriggerServerEvent('core:cardealerBuyVeh', token, selected_vehicle,
                                    selected_vehicle.price, "heliwave")
                                TriggerServerEvent("core:achatVehlog3", selected_vehicle.name, selected_vehicle.price)
                                RageUI.GoBack()
                            end
                        })
                        RageUI.Button("Faire essayer",
                            "Voulez-vous faire essayer le véhicule à la personne la plus proche ?", {}, true, {
                                onSelected = function()
                                    local closestPlayer, closestDistance = closestPlayer()
                                    -- if closestPlayer ~= nil and closestDistance < 3.0 then
                                    if not TriggerServerCallback("core:isTryCar", 'heliwave') then
                                        TriggerServerEvent('core:cardealerTryVeh', token,
                                            GetPlayerServerId(closestPlayer),
                                            selected_vehicle.name, "heliwave", selected_vehicle.kind)
                                    else
                                        exports['vNotif']:createNotification({
                                            type = 'ROUGE',
                                            -- duration = 5, -- In seconds, default:  4
                                            content = "un vehicule est déja ~s en essai"
                                        })
                                    end
                                    -- else
                                    -- ShowAdvancedNotification("Vision", "Concessionnaire", "Aucun joueur dans la zone", "CHAR_VISION", "VISION")
                                    -- end
                                end
                            })
                    end)
                    Wait(1)
                end
            end)
        end
    end

    RegisterNetEvent("core:heliwaveGetStock")
    AddEventHandler("core:heliwaveGetStock", function(data)
        concessStock = data
    end)

    local opengh = false
    local gestionmenu_main = RageUI.CreateMenu("", "Gestion", 0.0, 0.0, "root_cause", "shopui_title_premiumdeluxe")
    local gestionmenu_stock = RageUI.CreateSubMenu(gestionmenu_main, "", "Gestion", 0.0, 0.0, "root_cause",
        "shopui_title_premiumdeluxe")
    local gestionmenu_sell = RageUI.CreateSubMenu(gestionmenu_stock, "", "Gestion", 0.0, 0.0, "root_cause",
        "shopui_title_premiumdeluxe")
    local gestionmenu_select_buyer = RageUI.CreateSubMenu(gestionmenu_sell, "", "Gestion", 0.0, 0.0, "root_cause",
        "shopui_title_premiumdeluxe")
    gestionmenu_main.Closed = function()
        opengh = false
    end

    local selected_vehicle_sold = {}
    local selected_vehicle_price = 0

    function openGestionHeliwaveMenu()
        if opengh then
            opengh = false
            RageUI.Visible(gestionmenu_main, false)
        else
            opengh = true
            RageUI.Visible(gestionmenu_main, true)
            TriggerServerEvent('core:cardealerGetStock', token, "heliwave")

            CreateThread(function()
                while opengh do
                    RageUI.IsVisible(gestionmenu_main, function()
                        RageUI.Button("Gérer le stock", nil, {}, true, {
                            onSelected = function()
                                TriggerServerEvent('core:cardealerGetStock', token, "heliwave")
                            end
                        }, gestionmenu_stock)
                    end)
                    RageUI.IsVisible(gestionmenu_stock, function()
                        for k, v in pairs(concessStock) do
                            RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(v.name))), nil, {
                                RightLabel = "Acheté: ~g~" .. v.price .. '$'
                            }, true, {
                                onSelected = function()
                                    selected_vehicle_sold = v
                                end
                            }, gestionmenu_sell)
                        end
                    end)
                    RageUI.IsVisible(gestionmenu_sell, function()
                        RageUI.Separator("Vehicule: " ..
                            GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(selected_vehicle_sold.name))))
                        RageUI.Separator("Prix: " .. selected_vehicle_sold.price)
                        RageUI.Button("Revendre le véhicule", nil, {}, true, {
                            onSelected = function()
                                TriggerServerEvent('core:reSellVehicle', token, selected_vehicle_sold.name,
                                    selected_vehicle_sold.price, "heliwave")
                                RageUI.GoBack()
                            end
                        })
                    end)
                    Wait(1)
                end
            end)
        end
    end

    local crew_open = false
    local cardealerMenu_giveVehicle = RageUI.CreateMenu("", "Concessionnaire", 0.0, 0.0,
        "root_cause", "shopui_title_premiumdeluxe")
    local cardealerMenu_select_color = RageUI.CreateSubMenu(cardealerMenu_giveVehicle, "", "Concessionnaire", 0.0, 0.0,
        "root_cause", "shopui_title_premiumdeluxe")
    local cardealerMenu_select_buyer = RageUI.CreateSubMenu(cardealerMenu_select_color, "", "Concessionnaire", 0.0, 0.0,
        "root_cause", "shopui_title_premiumdeluxe")
    cardealerMenu_giveVehicle.Closed = function()
        crew_open = false
    end

    local vehicle_selected_to_give = {}
    local plys = {}
    local ACrew = true
    local AJob = false
    function openHeliwaveMenu(AJob, ACrew)
        if crew_open then
            crew_open = false
            RageUI.Visible(cardealerMenu_giveVehicle, false)
        else
            crew_open = true
            RageUI.Visible(cardealerMenu_giveVehicle, true)
            TriggerServerEvent('core:cardealerGetStock', token, "heliwave")
            plys = {}
            AJob = AJob
            ACrew = ACrew

            CreateThread(function()
                while crew_open do
                    RageUI.IsVisible(cardealerMenu_giveVehicle, function()
                        for k, v in pairs(concessStock) do
                            RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(v.name))), nil, {}, true
                            , {
                                onSelected = function()
                                    vehicle_selected_to_give = v
                                end
                            }, cardealerMenu_select_color)
                        end
                    end)
                    RageUI.IsVisible(cardealerMenu_select_color, function()
                        RageUI.Separator("Vehicule: " ..
                            GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(vehicle_selected_to_give.name))))
                        RageUI.Separator("Prix: " .. vehicle_selected_to_give.price)
                        for k, v in pairs(colors_list) do
                            RageUI.Button("Couleur " .. v.name, nil, {}, true, {
                                onSelected = function()
                                    color = v.id
                                    GetAllPlayersInAreaWithDataConcess()
                                end
                            }, cardealerMenu_select_buyer)
                        end
                    end)
                    RageUI.IsVisible(cardealerMenu_select_buyer, function()
                        if plys then
                            for k, v in pairs(plys) do
                                RageUI.Button("~o~" .. v.player .. "~s~ | ~o~" .. v.name, nil, {}, true, {
                                    onSelected = function()
                                        if ACrew and not AJob then
                                            TriggerServerEvent('core:assignBuyerToVehicle', token,
                                                vehicle_selected_to_give, v.player, v.crew, color, "aucun", "heliwave")
                                            RageUI.CloseAll()
                                            crew_open = false
                                        elseif AJob and not ACrew then
                                            TriggerServerEvent('core:assignBuyerToVehicle', token,
                                                vehicle_selected_to_give, v.player, v.crew, color, v.job, "heliwave")
                                            RageUI.CloseAll()
                                            crew_open = false
                                        else
                                            TriggerServerEvent('core:assignBuyerToVehicle', token,
                                                vehicle_selected_to_give, v.player, "None", color, "aucun", "heliwave")
                                            RageUI.CloseAll()
                                            crew_open = false
                                        end
                                    end
                                }, nil)
                            end
                        else
                            RageUI.Button("Aucun joueur dans la zone", nil, {}, true, {})
                        end
                    end)
                    Wait(1)
                end
            end)
        end
    end

    function FactureHeliwave()
        if inService then
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

    function SetCardealerDutyNord()
        openRadial = false
        closeUI()
        if not inService then
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez ~s pris ~c votre service"
            })

            TriggerServerEvent('core:DutyOn', p:getJob())
            inService = true
            Wait(5000)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous avez ~s quitté ~c votre service"
            })

            TriggerServerEvent('core:DutyOff', p:getJob())
            inService = false
            Wait(5000)
        end
    end

    function CreateAdvert()
        if inService then
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

    function OpenCrewVehicle()
        if inService then
            openRadial = false
            closeUI()
            openHeliwaveMenu(false, true)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function OpenJobVehicle()
        if inService then
            openRadial = false
            closeUI()
            openHeliwaveMenu(true, false)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function ContratCardealer()
        if inService then
            openRadial = false
            closeUI()
            TriggerEvent("nuiPapier:client:startCreation", 3)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function OpenPlayerVehicle()
        if inService then
            openRadial = false
            closeUI()
            openHeliwaveMenu(false, false)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function OpencardealerRadial()
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
                function SubAttribueRadialCarDealer()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = {
                            elements = {
                                {
                                    name = "JOUEUR",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/player.svg",
                                    action = "OpenPlayerVehicle"
                                },
                                {
                                    name = "JOB",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/job.svg",
                                    action = "OpenJobVehicle"
                                },
                                {
                                    name = "RETOUR",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                    action = "SubRadialCarDealerN"
                                },
                                {
                                    name = "CREW",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/crew.svg",
                                    action = "OpenCrewVehicle"
                                }
                            },
                            title = "ATTRIBUE"
                        }
                    }));
                end

                function SubRadialCarDealerN()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = {
                            elements = {
                                {
                                    name = "LISTE",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/liste.svg",
                                    action = "openStockMenu"
                                },
                                {
                                    name = "RETOUR",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                    action = "MainRadialCarDealer"
                                },
                                {
                                    name = "ATTRIBUÉ",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/add.svg",
                                    action = "SubAttribueRadialCarDealer"
                                }
                            },
                            title = "CLES"
                        }
                    }));
                end

                function SubPapierRadialCarDealerN()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = {
                            elements = {
                                {
                                    name = "CONTRAT",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/paper.svg",
                                    action = "ContratCardealer"
                                },
                                {
                                    name = "RETOUR",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                    action = "MainRadialCarDealer"
                                },
                                {
                                    name = "FACTURE",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/billet.svg",
                                    action = "FactureHeliwave"
                                }
                            },
                            title = "PAPIERS"
                        }
                    }));
                end

                function MainRadialCarDealer()
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
                                    name = "PAPIERS",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/paper.svg",
                                    action = "SubPapierRadialCarDealerN"
                                },
                                {
                                    name = "PRISE DE SERVICE",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/checkmark.svg",
                                    action = "SetCardealerDutyNord"
                                },
                                {
                                    name = "CLES",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/key.svg",
                                    action = "SubRadialCarDealerN"
                                }
                            },
                            title = "HELIWAVE"
                        }
                    }));
                end

                MainRadialCarDealer()
            end)
        else
            openRadial = false
            closeUI()
            return
        end
    end

    RegisterJobMenu(OpencardealerRadial)

    function GetAllPlayersInAreaWithDataConcess()
        local players = GetAllPlayersInArea(p:pos(), 5.0)
        plys = {}

        for k, v in pairs(players) do
            local src = GetPlayerServerId(v)
            local name = TriggerServerCallback("core:GetPlayerAreaName", src)
            local crew = TriggerServerCallback("core:GetPlayerCrewArea", src)
            local job = TriggerServerCallback("core:GetPlayerJobArea", src)
            table.insert(plys, {
                player = src,
                name = name,
                crew = crew,
                job = job
            })
        end
    end
end

function UnloadHeliwaveJob()
    zone.removeZone("heliwave_inventory")
    zone.removeZone("heliwave_gestionsociety")
end

local inTryVeh = false
local tryPlate = ""

RegisterNetEvent("core:heliwaveTryVeh")
AddEventHandler("core:heliwaveTryVeh", function(model, kind) --done
    inTryVeh = true
    local zoneSpawn = kind == 1 and essaieWater or essaieAero
    local vehicle = vehicle.create(model, zoneSpawn, {})
    local plate = GetVehicleNumberPlateText(vehicle)
    local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
    local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehicle, VehToNet(vehicle), p:getJob())
    --createKeys(plate, model)
    local random = math.random(100, 999)
    tryPlate = "ESSAI" .. random
    SetVehicleNumberPlateText(vehicle, "ESSAI" .. random)
    --TriggerServerEvent("core:GiveVehicleKeyToPlayer", token, "ESSAI" .. random)
    local savedPos = GetEntityCoords(GetPlayerPed(PlayerId()))
    TaskWarpPedIntoVehicle(p:ped(), vehicle, -1)

    local timer = GetGameTimer() + 60000
    while inTryVeh do
        ShowHelpNotification("Appuyez sur ~INPUT_MULTIPLAYER_INFO~ pour mettre fin au test")
        if GetGameTimer() > timer then
            SetEntityCoords(GetPlayerPed(PlayerId()), savedPos)
            TriggerEvent('persistent-vehicles/forget-vehicle', vehicle)
            --removeKeys(GetVehicleNumberPlateText(vehicle), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))))
            TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehicle))
            DeleteEntity(vehicle)
            -- ShowNotification("~r~Le délai a été dépassé")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Le délai a été dépassé"
            })

            inTryVeh = false
            TriggerServerEvent('core:unsetTryCar', "heliwave")

            return
        elseif IsControlJustPressed(0, 20) then
            -- ShowNotification("~r~Vous avez annulé le test")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s annulé ~c le test"
            })

            SetEntityCoords(GetPlayerPed(PlayerId()), savedPos)
            TriggerEvent('persistent-vehicles/forget-vehicle', vehicle)
            --removeKeys(GetVehicleNumberPlateText(vehicle), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))))
            TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehicle))
            DeleteEntity(vehicle)
            TriggerServerEvent('core:unsetTryCar', "heliwave")
            inTryVeh = false
            return
        end
        Wait(0)
    end
end)

RegisterNetEvent("core:spawnVehicleHeliwave")
AddEventHandler("core:spawnVehicleHeliwave", function(model, plate, color, kind)
    local vehicles
    local spawn
    if kind == 1 then
        if model == "yacht2" or model == "catamaran" then
            spawn = spawnBigBoat
        else
            spawn = spawnNormalBoat
        end
    else
        spawn = spawnNormalAero
    end
    vehicles = vehicle.create(model, spawn,
        {
            plate = plate
        })
    TriggerServerEvent("core:SetPropsVeh", token, string.upper(plate), vehicle.getProps(vehicles))
    TriggerServerEvent("core:SetVehicleOut", string.upper(plate), VehToNet(vehicles), vehicle)
    SetVehicleDirtLevel(vehicles, 0.0)
end)

function concessNordFacture(entity)
    local billing_price = 0
    local billing_reason = ""
    local player = NetworkGetPlayerIndexFromPed(entity)
    local sID = GetPlayerServerId(player)
    local price = KeyboardImput("Entrez le prix")
    if price and type(tonumber(price)) == "number" then
        billing_price = tonumber(price)
    end
    local reason = KeyboardImput("Entrez la raison")
    if reason ~= nil then
        billing_reason = tostring(reason)
    end

    if entity == nil then
        local closestPlayer, closestDistance = GetClosestPlayer()
        if closestPlayer ~= nil and closestDistance < 1.5 then
            TriggerServerEvent('core:sendbilling', token, GetPlayerServerId(closestPlayer),
                p:getJob(), billing_price, billing_reason)
        end
    else
        TriggerServerEvent('core:sendbilling', token, sID,
            p:getJob(), billing_price, billing_reason)

        --[[ Ancienne notification
        -- ShowNotification("Facturation envoyée \n Prix : ~g~" ..
            billing_price .. "~s~$ \n Raison : " .. billing_reason)
        --]]

        -- New notif
        exports['vNotif']:createNotification({
            type = 'VERT',
            -- duration = 5, -- In seconds, default:  4
            content = "Facturation envoyée \nPrix : ~s " .. billing_price .. "$ \n~c Raison : ~s " .. billing_reason
        })
    end
end

RegisterNUICallback("vehMenuHeliwave", function(data, cb)
    if vehicle.IsSpawnPointClear(vector3(-811.19329833984, -1324.7645263672, 4.0003814697266), 3.0) then
        vehs = vehicle.create(data.name,
            vector4(-811.19329833984, -1324.7645263672, 4.0003814697266, 75.28581237793),
            {})
        local plate = vehicle.getProps(vehs).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
        --createKeys(plate, model)
        if data.name == "nspeedo" then
            SetVehicleMod(vehs, 48, 0)
            SetVehicleLivery(vehs, 0)
        end
        closeWebview()
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
