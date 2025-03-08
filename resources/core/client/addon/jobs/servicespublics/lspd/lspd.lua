local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local policePropsPlaced = {}
local zonesCreated = {}
local created = false
local varLSPD = {}

CreateThread(function()
    while p == nil do Wait(1) end
    while zone == nil do Wait(1) end
    while not vAdminVariablesLoaded do Wait(1) end

    local pedsData = {
        {model = "s_m_y_cop_01", position = vector3(-1097.5017089844, -839.79248046875, 18.001207351685), heading = 125.86557006836, scenario = "WORLD_HUMAN_CLIPBOARD"},           -- Carte d'identité
    }

    --- TODO: Check why jobs doesn't load when using fresh database
    if (not vAdminVariables['jobs']) then
        print('Aborting LSPD job creation, no jobs found.');
        return;
    end
    varLSPD = vAdminVariables['jobs'].lspd
	print(json.encode(varLSPD))

    for k, v in pairs(varLSPD.vestiaires) do
        table.insert(pedsData, {model = "s_m_y_cop_01", position = vector3(v.x, v.y, v.z - 1.0), heading = v.w, scenario = "WORLD_HUMAN_CLIPBOARD"})
    end

    for k, v in pairs(varLSPD.garagesMenu) do
        table.insert(pedsData, {model = "s_m_y_cop_01", position = vector3(v.x, v.y, v.z - 1.0), heading = v.w, scenario = "WORLD_HUMAN_CLIPBOARD"})
    end

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

local function SpawnObject(obj, name)
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
            "Appuyez sur ~INPUT_CONTEXT~ pour placer l'objet\n~INPUT_FRONTEND_LEFT~ ou ~INPUT_FRONTEND_RIGHT~ Pour faire pivoter l'objet")
        if IsControlJustPressed(0, 38) then
            placed = true
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

policeDuty = false

function LoadLspdJob()
    while GetVariable("jobs") == nil do Wait(1) end
    while GetVariable('jobs').lspd == nil do Wait(1) end
    local varLSPD = GetVariable('jobs').lspd

    local vehicleOut = nil
    local currentVeh = nil

    local items = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Banners/LSPD.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Banners/icon.webp',
        headerIconName = 'CATALOGUE',
        callbackName = 'armoryTakeLSPD',
        showTurnAroundButtons = false,
        multipleSelection = true,
        elements = {
            {
                price = 0,
                id = 1,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/shield.webp",
                name = "shield", 
                label = "Bouclier anti-émeute"
            },
            {
                price = 0,
                id = 2,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Fumigene.webp", 
                name = "weapon_smokelspd",
                label = "Fumigene"
            },
            {
                price = 0,
                id = 3,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Fusee_detresse.webp",
                name = "weapon_flare",
                label = "Fusée de détresse"
            },
            {
                price = 0,
                id = 4,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Fumigene.webp",
                name = "weapon_bzgas",
                label = "GAZ BZ"
            },
            {
                price = 0,
                id = 5,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdgiletj.webp",
                name = "lspdgiletj",
                label = "Gilet Jaune"
            },
            {
                price = 0,
                id = 6,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdkevle1.webp",
                name = "lspdkevle1",
                label = "Kevlar Class A 1"
            },
            {
                price = 0,
                id = 7,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdkevle2.webp",
                name = "lspdkevle2", 
                label = "Kevlar Class A 2"
            },
            {
                price = 0,
                id = 8,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdkevle3.webp",
                name = "lspdkevle3",
                label = "Kevlar DD"
            },
            {
                price = 0,
                id = 9,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdriot.webp",
                name = "lspdriot",
                label = "Protection Anti Emeute"
            },
            {
                price = 0,
                id = 10,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdkevm1.webp",
                name = "lspdkevm1",
                label = "Kevlar Class B"
            },
            {
                price = 0,
                id = 11,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdkevlo1.webp",
                name = "lspdkevlo1",
                label = "Kevlar Class C 1"
            },
            {
                price = 0,
                id = 12,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdkevlo2.webp",
                name = "lspdkevlo2",
                label = "Kevlar Class C 2"
            },
            {
                price = 0,
                id = 13,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdkevlo3.webp",
                name = "lspdkevlo3",
                label = "Kevlar Class C 3"
            },
            {
                price = 0,
                id = 14,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdkevpc2.webp",
                name = "lspdkevlo4",
                label = "Kevlar Class C 4"
            },
            {
                price = 0,
                id = 15,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdkevsupervisor.webp",
                name = "lspdkevsupervisor",
                label = "LSPD - Supervisor"
            },
            {
                price = 0,
                id = 16,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdkevsupervisor.webp",
                name = "lspdkevsupervisor",
                label = "LSPD - Field Supervisor"
            },
            {
                price = 0,
                id = 17,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdkevdb.webp",
                name = "lspdkevdb",
                label = "LSPD - DB"
            },
            {
                price = 0,
                id = 18,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdkevcs.webp",
                name = "lspdkevcs",
                label = "LSPD - CS"
            },
            {
                price = 0,
                id = 19,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdkevco.webp",
                name = "lspdkevco",
                label = "LSPD - CO"
            },
            {
                price = 0,
                id = 20,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdkevlourd.webp",
                name = "lspdkevlourd",
                label = "Kevlar Lourd"
            },
            {
                price = 0,
                id = 21,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdkevnegotiator.webp",
                name = "lspdkevnegotiator",
                label = "Kevlar Negotiator"
            },
            {
                price = 0,
                id = 22,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdmetrole.webp",
                name = "lspdmetrole",
                label = "Metro Leger"
            },
            {
                price = 0,
                id = 23,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdmetro.webp",
                name = "lspdmetro",
                label = "Kevlar Metro"
            },
            {
                price = 0,
                id = 24,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdk9.webp",
                name = "lspdk9",
                label = "Kevlar K9"
            },
            {
                price = 0,
                id = 25,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdtd.webp",
                name = "lspdtd",
                label = "Kevlar TD"
            },
            {
                price = 0,
                id = 26,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdtdj.webp",
                name = "lspdtdj",
                label = "Kevlar TD Jaune"
            },
            {
                price = 0,
                id = 27,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdswat.webp",
                name = "lspdswat",
                label = "Kevlar SWAT"
            },
            {
                price = 0,
                id = 28,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdswat2.webp",
                name = "lspdswat2",
                label = "Kevlar SWAT 2"
            },
            {
                price = 0,
                id = 29,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdswat2.webp",
                name = "lspdcnt1",
                label = "Kevlar CNT"
            },
            {
                price = 0,
                id = 30,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdkevpc.webp",
                name = "lspdkevpc",
                label = "Gilet Pare Couteau BC"
            },
            {
                price = 0,
                id = 31,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdkevpc2.webp",
                name = "lspdkevpc2",
                label = "Gilet Pare Couteau Lourd"
            },
            {
                price = 0,
                id = 32,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/lspdgnd.webp",
                name = "lspdgnd",
                label = "Kevlar GND"
            },
            {
                price = 0,
                id = 33,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/radio.webp",
                name = "radio",
                label = "Radio"
            },
            {
                price = 0,
                id = 34,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/tabletmdt.webp",
                name = "tabletmdt",
                label = "Tablette MDT"
            }
		}
    }

    function OpenPoliceITEMMenu()
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

    local listHeli = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Banners/LSPD.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Banners/icon.webp',
        headerIconName = 'VEHICULE',
        callbackName = 'Menu_LSPD_heli_callback',
        elements = {{
            label = 'Maverick',
            spawnName = 'lspdmav',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/lspdmav.webp",
            category = 'Division',
            subCategory = 'Air Support Division'
        }, {
            label = 'Valkyrie',
            spawnName = 'lspdvalkyrie',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/lspdvalkyrie.webp",
            category = 'Division',
            subCategory = 'Metropolitan Division'
        },{
            label = 'MH6',
            spawnName = 'mh6swat',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/mh6swat.webp",
            category = 'Division',
            subCategory = 'Metropolitan Division'
        }}
    }

	local listHeliMR = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/LSPD/Pack911/header.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/LSPD/Pack911/logo_vehicule.webp',
        headerIconName = 'VEHICULE',
        callbackName = 'Menu_LSPD_heli_callback_MR',
        elements = listHeli.elements
    }

    function openGarageHeliLSPDMenu()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listHeli
        }))
    end

	function openGarageHeliLSPDMenuMR()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listHeliMR
        }))
    end

    local main = RageUI.CreateMenu("", "Action disponible", 0.0, 0.0, "shopui_title_carmod", "shopui_title_carmod")
    local liveries = RageUI.CreateSubMenu(main, "", "Action disponible")
    local stickers = RageUI.CreateSubMenu(main, "", "Action disponible")
    local extra = RageUI.CreateSubMenu(main, "", "Action disponible")
    local colors = RageUI.CreateSubMenu(main, "", "Changer la couleur")
    local openExtra = false
    main.Closed = function()
        RageUI.Visible(main, false)
        RageUI.Visible(liveries, false)
        RageUI.Visible(stickers, false)
        RageUI.Visible(extra, false)
        RageUI.Visible(colors, false)
        openExtra = false
    end

    function extraVehLSPD(veh)
        if openExtra then
            openExtra = false
            RageUI.Visible(main, false)
            RageUI.Visible(liveries, false)
            RageUI.Visible(stickers, false)
            RageUI.Visible(extra, false)
            RageUI.Visible(colors, false)

            return
        else
            openExtra = true
            RageUI.Visible(main, true)
            Citizen.CreateThread(function()
                while openExtra do
                    RageUI.IsVisible(main, function()
                        RageUI.Button("Motif", false, { RightLabel = ">" }, true, {
                            onSelected = function()
                            end
                        }, liveries)
                        RageUI.Button("Stickers", false, { RightLabel = ">" }, true, {
                            onSelected = function()
                            end
                        }, stickers)
                        RageUI.Button("extra", false, { RightLabel = ">" }, true, {
                            onSelected = function()
                            end
                        }, extra)
                        RageUI.Button("Couleur", false, { RightLabel = ">" }, true, {
                            onSelected = function()
                            end
                        }, colors)
                    end)
                    RageUI.IsVisible(liveries, function()
                        if GetNumVehicleMods(veh, 48) == 0 then
                            RageUI.Separator("Pas de modification disponible")
                        else
                            for i = 1, GetNumVehicleMods(veh, 48) do
                                local name = GetLabelText(GetModTextLabel(veh, 48, i))
                                if name == "NULL" then
                                    name = "Original"
                                end
                                if index == i then
                                    Rightbadge = RageUI.BadgeStyle.Car
                                else
                                    Rightbadge = nil
                                end

                                RageUI.Button(name, false, { RightBadge = Rightbadge }, true, {
                                    onActive = function()
                                        SetVehicleMod(veh, 48, i, 0)
                                    end,
                                    onSelected = function()
                                        index = i
                                        SetVehicleMod(veh, 48, i, 0)
                                    end
                                }, nil)
                            end
                        end
                    end)                
                    RageUI.IsVisible(colors, function()
                        local colorOptions = {
                            {name = "Noir", color = 0},
                            {name = "Blanc", color = 111},
                            {name = "Violet", color = 149},
                            {name = "Jaune", color = 42},
                            {name = "Argent Ombré", color = 7},
                            {name = "Rouge", color = 27},
                            {name = "Bleu", color = 75},
                            {name = "Vert", color = 49},
                            {name = "Brun clair", color = 98},
                        }
    
                        for _, colorData in pairs(colorOptions) do
                            local name = colorData.name
                            local color = colorData.color
    
                            if index == color then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end
    
                            RageUI.Button(name, false, { RightBadge = Rightbadge }, true, {
                                onSelected = function()
                                    index = color
                                    SetVehicleColours(veh, color, color)
                                end
                            }, nil)
                        end
                    end)
                    RageUI.IsVisible(stickers, function()
                        if GetVehicleLiveryCount(veh) == -1 then
                            RageUI.Separator("Pas de modification disponible")
                        else
                            for i = 1, GetVehicleLiveryCount(veh) do
                                local name = GetLabelText(GetLiveryName(veh, i))
                                if name == "NULL" then
                                    name = "Original"
                                end
                                if index == i then
                                    Rightbadge = RageUI.BadgeStyle.Car
                                else
                                    Rightbadge = nil
                                end

                                RageUI.Button(name, false, { RightBadge = Rightbadge }, true, {
                                    onActive = function()
                                        SetVehicleLivery(veh, i)
                                    end,
                                    onSelected = function()
                                        index = i
                                        SetVehicleLivery(veh, i)
                                    end
                                }, nil)

                            end
                        end
                    end)
                    RageUI.IsVisible(extra, function()
                        local veh = p:currentVeh()
                        local availableExtras = {}
                        extrasExist = false
                        for extra = 0, 20 do
                            if DoesExtraExist(veh, extra) then
                                availableExtras[extra] = extra
                                extrasExist = true
                            end
                        end

                        if not extrasExist then
                            RageUI.Separator("Pas de modification disponible")
                        else
                            for i in pairs(availableExtras) do
                                name = 'ORIGINAL'
                                if index == i then
                                    Rightbadge = RageUI.BadgeStyle.Car
                                else
                                    Rightbadge = nil
                                end
                                RageUI.Button(name, false, { RightBadge = Rightbadge }, true, {

                                    onSelected = function()
                                        if IsVehicleExtraTurnedOn(veh, i) then
                                            SetVehicleExtra(veh, i, 1)
                                        else
                                            index = i
                                            SetVehicleExtra(veh, i, 0)
                                        end
                                    end
                                }, nil)
                            end
                        end
                    end)
                    Wait(0)
                end
            end)
        end
    end


    local listBoat = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/LSPD/Pack911/header.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/LSPD/Pack911/logo_vehicule.webp',
        headerIconName = 'VEHICULE',
        callbackName = 'Menu_LSPD_boat_callback',
        elements = {{
            label = 'Jet-ski',
            spawnName = 'lspdseashark',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/emsseashark.webp",
            category = 'Division',
            subCategory = 'Los Santos Port Police'
        }, {
            label = 'Dinghy',
            spawnName = 'poldinghy',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/poldinghy.webp",
            category = 'Division',
            subCategory = 'Los Santos Port Police'
        }, {
            label = 'Predator',
            spawnName = 'polpreda',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/polpreda.webp",
            category = 'Division',
            subCategory = 'Los Santos Port Police'
        }}
    }

    function openGarageLSPDBoatMenu()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listBoat
        }))
    end

    for k, v in pairs(varLSPD.armureries) do
        table.insert(zonesCreated, "police_" .. k)
        zone.addZone("police_" .. k, vector3(v.x, v.y, v.z),
            "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir l'armurerie", function()
                printDev("Variable : " .. k)
                OpenPoliceITEMMenu()
            end, false,
            29,
            1.0,
            { 50, 168, 82 },
            170,
            2.0,
            true,
            "bulleArmurerie"
        )
    end

    for k, v in pairs(varLSPD.garagesDespawn) do
        table.insert(zonesCreated, "police_garage_" .. k)
        zone.addZone("police_" .. k, vector3(v.x, v.y, v.z),
            "Appuyer sur ~INPUT_CONTEXT~ pour rentrer dans le garage", function()
                printDev("Variable : " .. k)
                if IsPedInAnyVehicle(p:ped(), false) then
                    local veh = GetVehiclePedIsIn(p:ped(), false)
                    TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                    TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                    DeleteEntity(veh)
                end
            end, false,
            27,
            3.0,
            { 255, 255, 255 },
            170,
            3.0,
            true,
            "bulleGarage"
        )
    end

    for k, v in pairs(varLSPD.custom) do
        table.insert(zonesCreated, "police_custom_" .. k)
        zone.addZone("police_" .. k, vector3(v.x, v.y, v.z),
            "Appuyer sur ~INPUT_CONTEXT~ pour éditer votre vehicule",
            function()
                printDev("Variable : " .. k)
                local veh = p:currentVeh()
                if GetVehicleClass(veh)== 18 then
                extraVehLSPD(veh)
                else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    duration = 5, -- In seconds, default:  4
                    content = "Ceci n'est ~s pas un véhicule de fonction"
                    })
                end
            end,
            false, -- Avoir un marker ou non
            -1, -- Id / type du marker
            0.6, -- La taille
            { 0, 0, 0 }, -- RGB
            0, -- Alpha
            3.0,
            true,
            "bulleCustom"
        )
    end

    table.insert(zonesCreated, "police_garageHeli")
    zone.addZone("police_garageHeli", vector3(varLSPD.garagesMenu.garageHeli.x, varLSPD.garagesMenu.garageHeli.y, varLSPD.garagesMenu.garageHeli.z + 1.0),
        "~INPUT_CONTEXT~ Garage", function()
            printDev("Variable : garageHeli")
            openGarageHeliLSPDMenu()
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        1.5,
        true,
        "bulleGarage"
    )

	table.insert(zonesCreated, "police_garageHeliMR")
    zone.addZone("police_garageHeli", vector3(varLSPD.garagesMenu.garageHeliMissionRow.x, varLSPD.garagesMenu.garageHeliMissionRow.y, varLSPD.garagesMenu.garageHeliMissionRow.z + 1.0),
        "~INPUT_CONTEXT~ Garage", function()
            printDev("Variable : garageHeli")
            openGarageHeliLSPDMenuMR()
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        1.5,
        true,
        "bulleGarage"
    )

    table.insert(zonesCreated, "police_garageBoat")
    zone.addZone("police_garageBoat", vector3(varLSPD.garagesMenu.garageBoat.x, varLSPD.garagesMenu.garageBoat.y, varLSPD.garagesMenu.garageBoat.z + 1.0),
        "~INPUT_CONTEXT~ Garage", function()
            printDev("Variable : garageBoat")
            openGarageLSPDBoatMenu()
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        1.5,
        true,
        "bulleGarage"
    )

    table.insert(zonesCreated, "police_garageVespucci")
    zone.addZone("police_garageVespucci", vector3(varLSPD.garagesMenu.garageVespucci.x, varLSPD.garagesMenu.garageVespucci.y, varLSPD.garagesMenu.garageVespucci.z + 1.0),
        "~INPUT_CONTEXT~ Véhicules", function()
            printDev("Variable : garageVespucci")
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

	table.insert(zonesCreated, "police_garageMR")
    zone.addZone("police_garageMR", vector3(varLSPD.garagesMenu.garageMissionRow.x, varLSPD.garagesMenu.garageMissionRow.y, varLSPD.garagesMenu.garageMissionRow.z + 1.0),
        "~INPUT_CONTEXT~ Véhicules", function()
            printDev("Variable : garageMissionRow")
            openGarageMenuMR()
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

    table.insert(zonesCreated, "police_garageVinewood")
    zone.addZone("police_garageVinewood", vector3(varLSPD.garagesMenu.garageVinewood.x, varLSPD.garagesMenu.garageVinewood.y, varLSPD.garagesMenu.garageVinewood.z + 1.0),
        "~INPUT_CONTEXT~ Véhicules", function()
            printDev("Variable : garageVinewood")
            openGarageMenuVinewood()
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

    for k, v in pairs(varLSPD.societies) do
        table.insert(zonesCreated, "police_" .. k)
        zone.addZone("police_" .. k, vector3(v.x, v.y, v.z), "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les actions d'entreprise",
            function()
                printDev("Variable : " .. k)
                OpenSocietyMenu() -- TODO: fini le menu society
            end, false,
            27,
            0.5,
            { 255, 255, 255 },
            170,
            2.0,
            true,
            "bulleGestion"
        )
    end

    for k, v in pairs(varLSPD.coffres) do
        table.insert(zonesCreated, "police_" .. k)
        zone.addZone("police_" .. k, vector3(v.x, v.y, v.z), "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le coffre",
            function()
                printDev("Variable : " .. k)
                OpenInventorySocietyMenu() -- TODO: fini le menu society
            end, false,
            27,
            0.5,
            { 255, 255, 255 },
            170,
            2.0,
            true,
            "bulleCoffre"
        )
    end

    for k, v in pairs(varLSPD.vestiaires) do
        table.insert(zonesCreated, "police_" .. k)
        zone.addZone("police_" .. k, vector3(v.x, v.y, v.z + 1.0), "Appuyer sur ~INPUT_CONTEXT~ pour prendre une tenue",
            function()
                printDev("Variable : " .. k)
                LoadVestiaireLSPD() -- TODO: fini le menu society
            end, false,
            27,
            0.5,
            { 255, 255, 255 },
            170,
            2.0,
            true,
            "bulleVetement"
        )
    end

    for k, v in pairs(varLSPD.casiers) do
        table.insert(zonesCreated, "police_casier_" .. k)
        zone.addZone("police_casier_" .. k, vector3(v.x, v.y, v.z), "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les casiers",
            function()
                printDev("Variable : " .. k)
                OpenlspdCasier() -- TODO: fini le menu society
            end, false,
            27,
            0.5,
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
    local lspdmenu_objects = RageUI.CreateMenu("", "LSPD", 0.0, 0.0, "vision", "menu_title_police")
    local lspdmenu_traffic = RageUI.CreateMenu("", "LSPD", 0.0, 0.0, "vision", "menu_title_police")
    local lspdmenu_traffic_add = RageUI.CreateSubMenu(lspdmenu_traffic, "", "LSPD", 0.0, 0.0, "vision",
        "menu_title_police")
    local lspdmenu_traffic_view = RageUI.CreateSubMenu(lspdmenu_traffic, "", "LSPD", 0.0, 0.0, "vision",
        "menu_title_police")
    local lspdmenu_objects_delete = RageUI.CreateSubMenu(lspdmenu_objects, "", "LSPD", 0.0, 0.0, "vision",
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
        if policeDuty then
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

    function policeActionDuty()
        openRadial = false
        closeUI()
        if policeDuty then
            TriggerServerEvent('core:DutyOff', 'lspd')
            --[[             ShowAdvancedNotification("Centrale", "~b~Dispatch", "Vous avez quitté votre service", "CHAR_CALL911",
                "CHAR_CALL911") ]]

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s quitté ~c votre service"
            })

            policeDuty = false
            Wait(5000)
        else
            TriggerServerEvent('core:DutyOn', 'lspd')
            --[[             ShowAdvancedNotification("Centrale", "~b~Dispatch", "Vous avez pris votre service", "CHAR_CALL911",
                "CHAR_CALL911") ]]

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s pris ~c votre service"
            })

            policeDuty = true
            Wait(5000)
        end
    end

    function makeRenfortCall()
        if policeDuty then
            TriggerSecurEvent('core:makeCall', "lspd", p:pos(), false, "Appel de renfort (" .. p:getLastname() .. " " .. p:getFirstname() .. ")")
            TriggerSecurEvent('core:makeCall', "lssd", p:pos(), false, "Appel de renfort (" .. p:getLastname() .. " " .. p:getFirstname() .. ")") -- FIX_LSSD_LSPD
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

    function makePanicCall()
        if policeDuty then
            TriggerSecurEvent('core:makeCall', "lspd", p:pos(), false, "PANIC BUTTON (" .. p:getLastname() .. " " .. p:getFirstname() .. ")")
			TriggerServerEvent('core:createDispatchCallOnMDT', "LSPD", "PANIC BUTTON (" .. p:getLastname() .. " " .. p:getFirstname() .. ")", p:pos())
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

    function ConvocationLSPD()
        if policeDuty then
            openRadial = false
            closeUI()
            TriggerEvent("nuiPapier:client:startCreation", 5)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function FactureLSPD()
        if policeDuty then
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

    function DepositionLSPD()
        if policeDuty then
            openRadial = false
            closeUI()
            TriggerEvent("nuiPapier:client:startCreation", 4)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function CreateAdvert()
        if policeDuty then
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

    function OpenRadialPoliceMenu()
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
                function OpenSubRadialRenfort()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = {
                            elements = {{
                                name = "APPEL DE RENFORT",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/police_logo.svg",
                                action = "makeRenfortCall"
                            },{
                                name = "PANIC BUTTON",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/police_logo.svg",
                                action = "makePanicCall"
                            }},
                            title = "RENFORT"
                        }
                    }));
                end
                function OpenSubRadialPapiers()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = {
                            elements = {{
                                name = "CONVOCATION",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/top_paper.svg",
                                action = "ConvocationLSPD"
                            }, {
                                name = "FACTURE",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/billet.svg",
                                action = "FactureLSPD"
                            }, {
                                name = "RETOUR",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                action = "OpenMainRadialLSPD"
                            }, {
                                name = "DEPOSITION",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/paper.svg",
                                action = "DepositionLSPD"
                            }},
                            title = "PAPIERS"
                        }
                    }));
                end

                function OpenSubRadialActions()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = {
                            elements = {{
                                name = "ANNONCE",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/megaphone.svg",
                                action = "CreateAdvert"
                            }, {
                                name = "CIRCULATION",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/road.svg",
                                action = "openTraficMenu"
                            }, {
                                name = "RETOUR",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                action = "OpenMainRadialLSPD"
                            }, {
                                name = "OBJETS",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/object.svg",
                                action = "OpenPropsMenuLSPD"
                            }},
                            title = "ACTIONS"
                        }
                    }));
                end

                function OpenMainRadialLSPD()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = {
                            elements = {{
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
                            }},
                            title = "POLICE"
                        }
                    }));
                end

                OpenMainRadialLSPD()
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

    RegisterJobMenu(OpenRadialPoliceMenu)

    local oldSkin = {}
    local open = false
    local outifitmenu = RageUI.CreateMenu("", "LSPD", 0.0, 0.0, "vision", "menu_title_police")
    local outfitmenu_list = RageUI.CreateSubMenu(outifitmenu, "", "LSPD", 0.0, 0.0, "vision", "menu_title_police")
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
                                                    TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1, {
                                                        renamed = k,
                                                        data = v.male
                                                    })
                                                end
                                            else
                                                if v.female then
                                                    TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1, {
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

    local garagePos = vector4(1295.3653564453, 220.2564239502, -49.057468414307, 1.7115516662598)
    local plyInGarage = false

    local defaultVehExpo = {{
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
    }}

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

        zone.addZone("police_garage_exit", vector3(1295.2905273438, 217.6827545166, -49.055416107178),
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
    local lspdgarage_main = RageUI.CreateMenu("", "LSPD", 0.0, 0.0, "vision", "menu_title_police")
    local lspdgarage_vehicle =
        RageUI.CreateSubMenu(lspdgarage_main, "", "LSPD", 0.0, 0.0, "vision", "menu_title_police")
    lspdgarage_main.Closed = function()
        open = false
    end

    local allVehicleList = {}
    local selected_vehicle = nil

    local vehs = nil
    ---OpenVeh

    local listVeh = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_lspd.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
        headerIconName = 'VEHICULE',
        callbackName = 'Menu_LSPD_vehicule_callback',
        elements = {{
            label = 'Stanier',
            spawnName = 'tfpdstanier',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/tfpdstanier.webp",
            category = 'Grades',
            subCategory = 'ROOKIE'
        },{
            label = 'Scout 16',
            spawnName = 'lspdscout3',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/LSPDSCOUT3.webp",
            category = 'Grades',
            subCategory = 'OFFICIER I'
        },{
            label = 'Torrence',
            spawnName = 'lspdtorrence',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/lspdtorrence.webp",
            category = 'Grades',
            subCategory = 'OFFICIER II'
        },{
            label = 'Scout 20',
            spawnName = 'lspdscoutnew1',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/lspdscoutnew1.webp",
            category = 'Grades',
            subCategory = 'OFFICIER II'
        },{
            label = 'Fugitive',
            spawnName = 'sherifffug',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/sherifffug.webp",
            category = 'Grades',
            subCategory = 'OFFICIER III'
        },{
            label = 'Alamo 23',
            spawnName = 'tfpdnalamo',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/tfpdnalamo.webp",
            category = 'Grades',
            subCategory = 'OFFICIER III'
        },{
            label = 'Buffalo 2009',
            spawnName = 'lspdbuffalo',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/lspdbuffalo.webp",
            category = 'Grades',
            subCategory = 'SLO'
        },{
            label = 'Caracara',
            spawnName = 'lspdcara',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/lspdcara.webp",
            category = 'Grades',
            subCategory = 'SLO'
        },{
            label = 'Buffalo 2013',
            spawnName = 'lspdbuffalos',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/lspdbuffalos.webp",
            category = 'Grades',
            subCategory = 'SERGENT I'
        },{
            label = 'Buffalo 13 ST',
            spawnName = 'polbuffalosslick',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/polbuffalosslick.webp",
            category = 'Grades',
            subCategory = 'SERGENT II'
        },{
            label = 'Sandstorm',
            spawnName = 'tfpdstorm',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/tfpdstorm.webp",
            category = 'Grades',
            subCategory = 'SERGENT II'
        },{
            label = 'Buffalo STX ST',
            spawnName = 'polbuffalog',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/polbuffalog.webp",
            category = 'Grades',
            subCategory = 'COMMAND STAFF'
        },{
            label = 'Aleutian',
            spawnName = 'polaleutian',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/polaleutian.webp",
            category = 'Grades',
            subCategory = 'COMMAND STAFF'
        },{
            label = 'Alamo 23 ST',
            spawnName = 'tfpdnalamo2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/tfpdnalamo2.webp",
            category = 'Grades',
            subCategory = 'COMMAND STAFF'
        },{
            label = 'Alamo 20 UMK',
            spawnName = 'polalamoumk',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/polalamoumk.webp",
            category = 'Grades',
            subCategory = 'COMMAND STAFF'
        },{
            label = 'Alamo 20',
            spawnName = 'lssdalamonew2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/lssdalamonew2.webp",
            category = 'Grades',
            subCategory = 'COMMAND STAFF'
        },{
            label = 'Torence ST',
            spawnName = 'lspdtorrenceslick',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/lspdtorrenceslick.webp",
            category = 'Division',
            subCategory = 'METROPOLITAN DIVISION'
        },{
            label = 'Stanier ST',
            spawnName = 'tfpdstanier2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/tfpdstanier2.webp",
            category = 'Division',
            subCategory = 'METROPOLITAN DIVISION'
        },{
            label = 'Gresley UMK',
            spawnName = 'polgresleyg',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/polgresleyg.webp",
            category = 'Division',
            subCategory = 'METROPOLITAN DIVISION'
        },{
            label = 'Buffalo STX UMK',
            spawnName = 'lspdbuffsx',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/lspdbuffsx.webp",
            category = 'Division',
            subCategory = 'METROPOLITAN DIVISION'
        },{
            label = 'Bearcat',
            spawnName = 'lspdcenturion',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/LSPDcenturion.webp",
            category = 'Division',
            subCategory = 'METROPOLITAN DIVISION'
        },{
            label = 'Alamo 2500 UMK',
            spawnName = 'polalamog2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/polalamog2.webp",
            category = 'Division',
            subCategory = 'METROPOLITAN DIVISION'
        },{
            label = 'Scout 20 UMK',
            spawnName = 'lspd2020scoutumk',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/lspd2020scoutumk.webp",
            category = 'Division',
            subCategory = 'METROPOLITAN DIVISION'
        },{
            label = 'Scout 20 K9',
            spawnName = 'lspdscout3k9',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/lspdscout3k9.webp",
            category = 'Division',
            subCategory = 'K9'
        },{
            label = 'Alamo 23 K9',
            spawnName = 'tfpdnalamo',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/tfpdnalamo.webp",
            category = 'Division',
            subCategory = 'K9'
        },{
            label = 'Scout 16',
            spawnName = 'lspdscout2k9a',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/lspdscout2k9a.webp",
            category = 'Division',
            subCategory = 'K9'
        },{
            label = 'SandStorm',
            spawnName = 'tfpdstorm',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/tfpdstorm.webp",
            category = 'Division',
            subCategory = 'K9'
        },{
            label = 'Buffalo 13 K9',
            spawnName = 'polbuffalosslick',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/polbuffalosslick.webp",
            category = 'Division',
            subCategory = 'K9'
        },{
            label = 'Torrence',
            spawnName = 'lspdtorrenceslick',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/lspdtorrenceslick.webp",
            category = 'Division',
            subCategory = 'DB'
        },{
            label = 'Stanier UMK',
            spawnName = 'lssdumk2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/lssdumk2.webp",
            category = 'Division',
            subCategory = 'DB'
        },{
            label = 'Stanier',
            spawnName = 'tfpdstanier2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/tfpdstanier2.webp",
            category = 'Division',
            subCategory = 'DB'
        },{
            label = 'Alamo 20',
            spawnName = 'polalamoumk',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/polalamoumk.webp",
            category = 'Division',
            subCategory = 'DB'
        },{
            label = 'Scout 20 UMK',
            spawnName = 'lspd2020scoutumk',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/lspd2020scoutumk.webp",
            category = 'Division',
            subCategory = 'DB'
        },{
            label = 'Scout 16',
            spawnName = 'LSPDumkscout16',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/LSPDumkscout16.webp",
            category = 'Division',
            subCategory = 'DB'
        },{
            label = 'Buffalo 13 UMK',
            spawnName = 'polbuffalosslick',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/polbuffalosslick.webp",
            category = 'Division',
            subCategory = 'DB'
        },{
            label = 'Buffalo 09 UMK',
            spawnName = 'lspdbuffaloum',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/lspdbuffaloum.webp",
            category = 'Division',
            subCategory = 'DB'
        },{
            label = 'Alamo 23 UMK',
            spawnName = 'tfpdnalamo2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/tfpdnalamo2.webp",
            category = 'Division',
            subCategory = 'DB'
        },{
            label = 'Greenwood',
            spawnName = 'fbigreenwd',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/fbigreenwd.webp",
            category = 'Division',
            subCategory = 'DB'
        },{
            label = 'Fugitive',
            spawnName = 'sherifffug2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/sherifffug2.webp",
            category = 'Division',
            subCategory = 'DB'
        },{
            label = 'Caracara',
            spawnName = 'lspdcara2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/lspdcara2.webp",
            category = 'Division',
            subCategory = 'DB'
        },{
            label = 'Sandstorm',
            spawnName = 'tfpdstorm2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/tfpdstorm2.webp",
            category = 'Division',
            subCategory = 'DB'
        },{
            label = 'Sultan',
            spawnName = 'sultanumk',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/sultanumk.webp",
            category = 'Division',
            subCategory = 'DB'
        },{
            label = 'Oracle',
            spawnName = 'poloracleumk',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/poloracleumk.webp",
            category = 'Division',
            subCategory = 'DB'
        },{
            label = 'Everon',
            spawnName = 'loweveron',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/loweveron.webp",
            category = 'Division',
            subCategory = 'DB'
        },--[[ {
            label = 'Buffalo STX TD',
            spawnName = 'polbuffalor',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/polbuffalor.webp",
            category = 'Division',
            subCategory = 'Traffic Division'
        }, ]]{
            label = 'Wintergreen LSPD',
            spawnName = 'hpbike2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/hpbike2.webp", 
            category = 'Division',
            subCategory = 'TRAFFIC DIVISION'
        }, {
            label = 'MBU TD',
            spawnName = 'hpbike1',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/hpbike1.webp",
            category = 'Division',
            subCategory = 'TRAFFIC DIVISION'
        }, {
            label = 'Stanier TD',
            spawnName = 'hwaycar',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/hwaycar.webp",
            category = 'Division',
            subCategory = 'TRAFFIC DIVISION'
        }, {
            label = 'Buffalo STX TD',
            spawnName = 'hwaycar2',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/hwaycar2.webp",
            category = 'Division',
            subCategory = 'TRAFFIC DIVISION'
        }, {
            label = 'Alamo TD',
            spawnName = 'hwaycar3',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/hwaycar3.webp",
            category = 'Division',
            subCategory = 'TRAFFIC DIVISION'
        }, {
            label = 'Scout 20 TD',
            spawnName = 'hwaycar4',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/hwaycar4.webp",
            category = 'Division',
            subCategory = 'TRAFFIC DIVISION'
        }, {
            label = 'Sadlerk TD',
            spawnName = 'hwaycar6',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/hwaycar6.webp",
            category = 'Division',
            subCategory = 'TRAFFIC DIVISION'
        }, {
            label = 'Stanier Old TD',
            spawnName = 'hwaycarold',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/hwaycarold.webp",
            category = 'Division',
            subCategory = 'TRAFFIC DIVISION'
        },--[[ {
            label = 'Vigeros TD',
            spawnName = 'polvigeros',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/polbuffalor.webp",
            category = 'Division',
            subCategory = 'TRAFFIC DIVISION'
        }, ]]{
            label = 'Utility Rescue',
            spawnName = 'sheriffsar',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/sheriffsar.webp",
            category = 'Utility',
            subCategory = 'Divers'
        },{
            label = 'Everon',
            spawnName = 'lspdeveron',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/lspdeveron.webp",
            category = 'Utility',
            subCategory = 'Divers'
        },{
            label = 'Verus',
            spawnName = 'polverus',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/polverus.webp",
            category = 'Utility',
            subCategory = 'Divers'
        },{
            label = 'VTT',
            spawnName = 'lspdcycle',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/lspdcycle.webp",
            category = 'Utility',
            subCategory = 'Divers'
        },{
            label = 'M.O.C',
            spawnName = 'mocpacker',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/mocpacker.webp",
            category = 'Utility',
            subCategory = 'Divers'
        },{
            label = 'Parking pigeon',
            spawnName = 'pigeonp',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/pigeonp.webp",
            category = 'Utility',
            subCategory = 'Divers'
        },{
            label = 'Bus',
            spawnName = 'lssdbus',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/lssdbus.webp",
            category = 'Utility',
            subCategory = 'Divers'
        },{
            label = 'Speedo express',
            spawnName = 'lspdspeedo',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/Pack911/lspdspeedo.webp",
            category = 'Utility',
            subCategory = 'Divers'
        }}
    }

	local listVehMR = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_lspd.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
        headerIconName = 'VEHICULE',
        callbackName = 'Menu_LSPD_vehicule_callback_MR',
        elements = listVeh.elements
    }

    local listVehVinewood = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_lspd.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
        headerIconName = 'VEHICULE',
        callbackName = 'Menu_LSPD_vehicule_callback_Vinewood',
        elements = listVeh.elements
    }

    function openGarageMenu()
        if not policeDuty then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez être en service pour accéder au garage"
            })
            return
        end
        
        Bulle.hide("police_garage_vehicle")
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listVeh
        }))
    end
    
    function openGarageMenuMR()
        if not policeDuty then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez être en service pour accéder au garage"
            })
            return
        end
        
        Bulle.hide("police_garage_vehicle")
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listVehMR
        }))
    end
    
    function openGarageMenuVinewood()
        if not policeDuty then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez être en service pour accéder au garage"
            })
            return
        end
        
        Bulle.hide("police_garage_vehicle")
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listVehVinewood
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
            vector4(-1061.701171875, -853.28356933594, 4.475266456604, 218.39852905273), {})
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
                        count = 399
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
        -- DataSendPropsLSPD.items.elements = {}

        local playerJobs = 'lspd-lssd'

        -- Cones
        for i = 1, 10 do
            table.insert(DataSendPropsLSPD.items[2].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" .. playerJobs .. "/Cones/" .. i .. ".webp",
                category = "Cones",
                label = "#" .. i
            })
        end

        -- Panneaux
        for i = 1, 45 do
            table.insert(DataSendPropsLSPD.items[3].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" .. playerJobs .. "/Panneaux/" .. i .. ".webp",
                category = "Panneaux",
                label = "#" .. i
            })
        end

        -- Barrière
        for i = 1, 23 do
            table.insert(DataSendPropsLSPD.items[4].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" .. playerJobs .. "/Barrieres/" .. i .. ".webp",
                category = "Barrières",
                label = "#" .. i
            })
        end

        -- Lumières
        for i = 1, 5 do
            table.insert(DataSendPropsLSPD.items[5].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" .. playerJobs .. "/Lumieres/" .. i .. ".webp",
                category = "Lumières",
                label = "#" .. i
            })
        end

        -- Tables
        for i = 1, 2 do
            table.insert(DataSendPropsLSPD.items[6].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" .. playerJobs .. "/Tables/" .. i .. ".webp",
                category = "Tables",
                label = "#" .. i
            })
        end

        -- Drogues
        for i = 1, 9 do
            table.insert(DataSendPropsLSPD.items[7].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" .. playerJobs .. "/Drogues/" .. i .. ".webp",
                category = "Drogues",
                label = "#" .. i
            })
        end

        -- Divers
        for i = 1, 4 do
            table.insert(DataSendPropsLSPD.items[8].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" .. playerJobs .. "/Divers/" .. i .. ".webp",
                category = "Divers",
                label = "#" .. i
            })
        end

        -- Cible Tir
        for i = 1, 2 do
            table.insert(DataSendPropsLSPD.items[9].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" .. playerJobs .. "/CiblesTir/" .. i .. ".webp",
                category = "Cibles Tir",
                label = "#" .. i
            })
        end

        -- Sacs
        for i = 1, 2 do
            table.insert(DataSendPropsLSPD.items[10].elements, {
                id = i,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/" .. playerJobs .. "/Sacs/" .. i .. ".webp",
                category = "Sacs",
                label = "#" .. i
            })
        end

        DataSendPropsLSPD.disableSubmit = true

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

    DataSendPropsLSPD = {
        items = {{
            name = 'main',
            type = 'buttons',
            elements = {{
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
            }}
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
        }},

        -- headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
        -- headerIconName = 'Cones',
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_lspd.webp',
        callbackName = 'MenuObjetsServicesPublicsLSPD',
        headerTitle = "OBJETS SERVICES PUBLICS",
        showTurnAroundButtons = false
    }

    local firstart = false

    OpenPropsMenuLSPD = function()
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
            data = DataSendPropsLSPD
        }))
    end

end

function UnloadLspdJob()
    -- for k, v in pairs(zonesCreated) do
    --     print(v)
    --     zone.removeZone(v)
    -- end
    policeDuty = false
end

showShotId = function(playerID)
	local posx, posy = 0, 0.26
	local width, height = 0.07, 0.14
	local x, y = GetActiveScreenResolution()
	if x == 1920 and y == 1080 then
		posx, posy = 0.085, 0.35
		width, height = 0.07, 0.14
	elseif x == 1366 and y == 768 then
		posx, posy = 0.686, 0.366
		width, height = 0.086, 0.196
	elseif x == 1360 and y == 768 then
		posx, posy = 0.685, 0.366
		width, height = 0.087, 0.196
	elseif x == 1600 and y == 900 then
		posx, posy = 0.732, 0.3122
		width, height = 0.073, 0.168
	elseif x == 1400 and y == 1050 then
		posx, posy = 0.694, 0.267
		width, height = 0.083, 0.145
	elseif x == 1440 and y == 900 then
		posx, posy = 0.702, 0.312
		width, height = 0.082, 0.169
	elseif x == 1680 and y == 1050 then
		posx, posy = 0.745, 0.268
		width, height = 0.068, 0.1435
	elseif x == 1280 and y == 720 then
		posx, posy = 0.665, 0.3905
		width, height = 0.09, 0.2105
	elseif x == 1280 and y == 768 then
		posx, posy = 0.665, 0.366
		width, height = 0.091, 0.196
	elseif x == 1280 and y == 800 then
		posx, posy = 0.665, 0.3515
		width, height = 0.091, 0.1895
	elseif x == 1280 and y == 960 then
		posx, posy = 0.665, 0.2925
		width, height = 0.091, 0.1585
	elseif x == 1280 and y == 1024 then
		posx, posy = 0.665, 0.2745
		width, height = 0.091, 0.1475
	elseif x == 1024 and y == 768 then
		posx, posy = 0.5810, 0.366
		width, height = 0.115, 0.1965
	elseif x == 800 and y == 600 then
		posx, posy = 0.4635, 0.4685
		width, height = 0.1455, 0.251
	elseif x == 1152 and y == 864 then
		posx, posy = 0.6275, 0.325
		width, height = 0.1005, 0.175
	elseif x == 1280 and y == 600 then
		posx, posy = 0.665, 0.468
		width, height = 0.0905, 0.251
	end

	local handle = RegisterPedheadshot(GetPlayerPed(GetPlayerFromServerId(playerID)))

	if not IsPedheadshotValid(handle) then
		print('erreur')
		print(handle)
	end

	while not IsPedheadshotReady (handle) do
		Wait (100)
	end
	local headshot = GetPedheadshotTxdString (handle)
	while openID do
		Wait(5)
		DrawSprite(headshot, headshot, posx, posy, width, height, 0.0, 255, 255, 255, 255)
	end
	if not openID then
		UnregisterPedheadshot(handle)
	end
end

function AddRandomVehicleStuff(plate)
    local stuff = {
        {item = "lspdkevle1", qMin = 1, qMax = 1, metadatas = {}},
        {item = "lspdkevlourd", qMin = 0, qMax = 2, metadatas = {}},
        {item = "herse", qMin = 0, qMax = 1, metadatas = {}},
        {item = "medikit", qMin = 0, qMax = 2, metadatas = {}},
        {item = "lspdgiletj", qMin = 1, qMax = 3, metadatas = {}},
        {item = "weapon_flare", qMin = 1, qMax = 2, metadatas = {}},
        {item = "weapon_fireextinguisher", qMin = 0, qMax = 1, metadatas = {}},
    }

    TriggerServerEvent("core:AddStuffToVehicle", token, stuff, plate)
end

RegisterNUICallback("Menu_LSPD_vehicule_callback", function(data, cb)
    while GetVariable("jobs") == nil do Wait(1) end
    while GetVariable('jobs').lspd == nil do Wait(1) end
    local varLSPD = GetVariable('jobs').lspd
    local keys = {}
    for key in pairs(varLSPD.garagesSpawn.spawnVespucci) do table.insert(keys, tonumber(key)) end table.sort(keys)
    for _, key in ipairs(keys) do
        local value = varLSPD.garagesSpawn.spawnVespucci[tostring(key)]
        if vehicle.IsSpawnPointClear(vector3(value.x, value.y, value.z), 3.0) then
            vehs = vehicle.create(data.spawnName, vector4(value.x, value.y, value.z, value.w), {})
            SetVehicleMod(vehs, 11, 2, false)
            SetVehicleMod(vehs, 12, 2, false)
            SetVehicleMod(vehs, 13, 2, false)
            if data.label == "lspdscout3" then
                SetVehicleExtra(vehs, 1, 1)
                SetVehicleExtra(vehs, 2,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 4,1)
                SetVehicleExtra(vehs, 5,1)
                SetVehicleExtra(vehs, 9,1)
                SetVehicleExtra(vehs, 10,1)
                SetVehicleExtra(vehs, 11,1)
            elseif data.label == 'Torrence' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 4, 1)
                SetVehicleExtra(vehs, 5, 1)
                SetVehicleExtra(vehs, 6, 1)
                SetVehicleExtra(vehs, 8, 1)
                SetVehicleExtra(vehs, 10, 1)
            elseif data.label == 'Fugitive' then
                SetVehicleLivery(vehs, 4)
            elseif data.label == 'Buffalo 2009' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Buffalo 2009' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Caracara' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Buffalo 2013' then
                SetVehicleLivery(vehs, 1)
                SetVehicleExtra(vehs, 10, 1)
                SetVehicleExtra(vehs, 11, 1)
            elseif data.label == 'Buffalo 13 ST' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Buffalo 13 ST' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Buffalo STX ST' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Buffalo STX ST' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Aleutian' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1, 1)
                SetVehicleExtra(vehs, 2,1)
            elseif data.label == 'Alamo 23 ST' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1, 1)
                SetVehicleExtra(vehs, 2,1)
            elseif data.label == 'Torence ST' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Gresley UMK' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Buffalo STX UMK' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Bearcat' then
                SetVehicleLivery(vehs, 3)
            elseif data.label == 'Alamo 2500 UMK' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Scout 20 UMK' then
                SetVehicleLivery(vehs, 3)
                SetVehicleExtra(vehs, 1, 0)
                SetVehicleExtra(vehs, 2, 0)
            elseif data.label == 'Scout 20 K9' then
                SetVehicleLivery(vehs, 0)
            elseif data.spawnName == 'lspdscout2k9a' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Buffalo 13 K9' then
                SetVehicleLivery(vehs, 4)
            elseif data.spawnName == 'lspdtorrenceslick' then
                SetVehicleLivery(vehs, 5)
            elseif data.label == 'Stanier ST' then
                SetVehicleLivery(vehs, 7)
            elseif data.label == 'Scout 20 UMK' then
                SetVehicleLivery(vehs, 1)
                SetVehicleExtra(vehs, 1, 0)
            elseif data.spawnName == 'LSPDumkscout16' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Buffalo 13 UMK' then
                SetVehicleLivery(vehs, 6)
            elseif data.label == 'Buffalo 13 UMK' then
                SetVehicleLivery(vehs, 6)
            elseif data.label == 'Buffalo STX TD' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Wintergreen TD' then
                SetVehicleLivery(vehs, 2)
                SetVehicleExtra(vehs, 1, 1)
                SetVehicleExtra(vehs, 5, 1)
            elseif data.label == 'Trust' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Utility Rescue' then
                SetVehicleLivery(vehs, 4)
                SetVehicleExtra(vehs, 1, 1)
                SetVehicleExtra(vehs, 2, 1)
                SetVehicleExtra(vehs, 5, 1)
            elseif data.label == 'Everon' then
                SetVehicleLivery(vehs, 2)
                SetVehicleExtra(vehs, 5, 1)
                SetVehicleExtra(vehs, 6, 1)
                SetVehicleExtra(vehs, 11, 1)
            elseif data.label == 'M.O.C' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1, 1)
                SetVehicleExtra(vehs, 3, 1)
                SetVehicleExtra(vehs, 4, 1)
                SetVehicleExtra(vehs, 5, 1)
                SetVehicleExtra(vehs, 6, 1)
                SetVehicleExtra(vehs, 9, 1)
                SetVehicleExtra(vehs, 10, 1)
            elseif data.spawnName == 'pigeonp' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Speedo express' then
                SetVehicleLivery(vehs, 4)
            elseif data.label == 'Alamo 23 K9' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Alamo 23' then
                SetVehicleLivery(vehs, 7)
            elseif data.label == 'Stanier' then
                SetVehicleLivery(vehs, 7)
            elseif data.label == 'Alamo 23 UMK' then
                SetVehicleLivery(vehs, 6)
            elseif data.spawnName == 'lssdbus' then
                SetVehicleLivery(vehs, 1)
                SetVehicleExtra(vehs, 1, 0)
                SetVehicleExtra(vehs, 2, 0)
            end            
            local plate = vehicle.getProps(vehs).plate
            local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
            local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
            AddRandomVehicleStuff(plate)
            --createKeys(plate, model)
            SendNuiMessage(json.encode({
                type = 'closeWebview'
            }))
            return
        end
    end
end)

RegisterNUICallback("Menu_LSPD_vehicule_callback_MR", function(data, cb)
    while GetVariable("jobs") == nil do Wait(1) end
    while GetVariable('jobs').lspd == nil do Wait(1) end
    local varLSPD = GetVariable('jobs').lspd
    local keys = {}
    for key in pairs(varLSPD.garagesSpawn.spawnMissionRow) do table.insert(keys, tonumber(key)) end table.sort(keys)
    for _, key in ipairs(keys) do
        local value = varLSPD.garagesSpawn.spawnMissionRow[tostring(key)]
		local eden = varLSPD.garagesSpawn.spawnObeseMissionRow[0]
        if vehicle.IsSpawnPointClear(vector3(value.x, value.y, value.z), 3.0) then
			if data.spawnName == 'mocpacker' then
				vehs = vehicle.create(data.spawnName, vector4(eden.x, eden.y, eden.z, eden.w), {})
			else
				vehs = vehicle.create(data.spawnName, vector4(value.x, value.y, value.z, value.w), {})
			end
            SetVehicleMod(vehs, 11, 2, false)
            SetVehicleMod(vehs, 12, 2, false)
            SetVehicleMod(vehs, 13, 2, false)
            if data.label == "lspdscout3" then
                SetVehicleExtra(vehs, 1, 1)
                SetVehicleExtra(vehs, 2,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 4,1)
                SetVehicleExtra(vehs, 5,1)
                SetVehicleExtra(vehs, 9,1)
                SetVehicleExtra(vehs, 10,1)
                SetVehicleExtra(vehs, 11,1)
            elseif data.label == 'Torrence' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 4, 1)
                SetVehicleExtra(vehs, 5, 1)
                SetVehicleExtra(vehs, 6, 1)
                SetVehicleExtra(vehs, 8, 1)
                SetVehicleExtra(vehs, 10, 1)
            elseif data.label == 'Fugitive' then
                SetVehicleLivery(vehs, 4)
            elseif data.label == 'Buffalo 2009' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Buffalo 2009' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Caracara' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Buffalo 2013' then
                SetVehicleLivery(vehs, 1)
                SetVehicleExtra(vehs, 10, 1)
                SetVehicleExtra(vehs, 11, 1)
            elseif data.label == 'Buffalo 13 ST' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Buffalo 13 ST' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Buffalo STX ST' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Buffalo STX ST' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Aleutian' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1, 1)
                SetVehicleExtra(vehs, 2,1)
            elseif data.label == 'Alamo 23 ST' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1, 1)
                SetVehicleExtra(vehs, 2,1)
            elseif data.label == 'Torence ST' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Gresley UMK' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Buffalo STX UMK' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Bearcat' then
                SetVehicleLivery(vehs, 3)
            elseif data.label == 'Alamo 2500 UMK' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Scout 20 UMK' then
                SetVehicleLivery(vehs, 3)
                SetVehicleExtra(vehs, 1, 0)
                SetVehicleExtra(vehs, 2, 0)
            elseif data.label == 'Scout 20 K9' then
                SetVehicleLivery(vehs, 0)
            elseif data.spawnName == 'lspdscout2k9a' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Buffalo 13 K9' then
                SetVehicleLivery(vehs, 4)
            elseif data.spawnName == 'lspdtorrenceslick' then
                SetVehicleLivery(vehs, 5)
            elseif data.label == 'Stanier ST' then
                SetVehicleLivery(vehs, 7)
            elseif data.label == 'Scout 20 UMK' then
                SetVehicleLivery(vehs, 1)
                SetVehicleExtra(vehs, 1, 0)
            elseif data.spawnName == 'LSPDumkscout16' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Buffalo 13 UMK' then
                SetVehicleLivery(vehs, 6)
            elseif data.label == 'Buffalo 13 UMK' then
                SetVehicleLivery(vehs, 6)
            elseif data.label == 'Buffalo STX TD' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Wintergreen TD' then
                SetVehicleLivery(vehs, 2)
                SetVehicleExtra(vehs, 1, 1)
                SetVehicleExtra(vehs, 5, 1)
            elseif data.label == 'Trust' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Utility Rescue' then
                SetVehicleLivery(vehs, 4)
                SetVehicleExtra(vehs, 1, 1)
                SetVehicleExtra(vehs, 2, 1)
                SetVehicleExtra(vehs, 5, 1)
            elseif data.label == 'Everon' then
                SetVehicleLivery(vehs, 2)
                SetVehicleExtra(vehs, 5, 1)
                SetVehicleExtra(vehs, 6, 1)
                SetVehicleExtra(vehs, 11, 1)
            elseif data.label == 'M.O.C' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1, 1)
                SetVehicleExtra(vehs, 3, 1)
                SetVehicleExtra(vehs, 4, 1)
                SetVehicleExtra(vehs, 5, 1)
                SetVehicleExtra(vehs, 6, 1)
                SetVehicleExtra(vehs, 9, 1)
                SetVehicleExtra(vehs, 10, 1)
            elseif data.spawnName == 'pigeonp' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Speedo express' then
                SetVehicleLivery(vehs, 4)
            elseif data.label == 'Alamo 23 K9' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Alamo 23' then
                SetVehicleLivery(vehs, 7)
            elseif data.label == 'Stanier' then
                SetVehicleLivery(vehs, 7)
            elseif data.label == 'Alamo 23 UMK' then
                SetVehicleLivery(vehs, 6)
            elseif data.spawnName == 'lssdbus' then
                SetVehicleLivery(vehs, 1)
                SetVehicleExtra(vehs, 1, 0)
                SetVehicleExtra(vehs, 2, 0)
            end            
            local plate = vehicle.getProps(vehs).plate
            local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
            local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
            AddRandomVehicleStuff(plate)
            --createKeys(plate, model)
            SendNuiMessage(json.encode({
                type = 'closeWebview'
            }))
            return
        end
    end
end)

RegisterNUICallback("Menu_LSPD_vehicule_callback_Vinewood", function(data, cb)
    while GetVariable("jobs") == nil do Wait(1) end
    while GetVariable('jobs').lspd == nil do Wait(1) end
    local varLSPD = GetVariable('jobs').lspd
    local keys = {}
    for key in pairs(varLSPD.garagesSpawn.spawnVinewood) do table.insert(keys, tonumber(key)) end table.sort(keys)
    for _, key in ipairs(keys) do
        local value = varLSPD.garagesSpawn.spawnVinewood[tostring(key)]
		local eden = varLSPD.garagesSpawn.spawnObeseVinewood[0]
        if vehicle.IsSpawnPointClear(vector3(value.x, value.y, value.z), 3.0) then
			if data.spawnName == 'mocpacker' then
				vehs = vehicle.create(data.spawnName, vector4(eden.x, eden.y, eden.z, eden.w), {})
			else
				vehs = vehicle.create(data.spawnName, vector4(value.x, value.y, value.z, value.w), {})
			end
            SetVehicleMod(vehs, 11, 2, false)
            SetVehicleMod(vehs, 12, 2, false)
            SetVehicleMod(vehs, 13, 2, false)
            if data.label == "lspdscout3" then
                SetVehicleExtra(vehs, 1, 1)
                SetVehicleExtra(vehs, 2,1)
                SetVehicleExtra(vehs, 3,1)
                SetVehicleExtra(vehs, 4,1)
                SetVehicleExtra(vehs, 5,1)
                SetVehicleExtra(vehs, 9,1)
                SetVehicleExtra(vehs, 10,1)
                SetVehicleExtra(vehs, 11,1)
            elseif data.label == 'Torrence' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 4, 1)
                SetVehicleExtra(vehs, 5, 1)
                SetVehicleExtra(vehs, 6, 1)
                SetVehicleExtra(vehs, 8, 1)
                SetVehicleExtra(vehs, 10, 1)
            elseif data.label == 'Fugitive' then
                SetVehicleLivery(vehs, 4)
            elseif data.label == 'Buffalo 2009' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Buffalo 2009' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Caracara' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Buffalo 2013' then
                SetVehicleLivery(vehs, 1)
                SetVehicleExtra(vehs, 10, 1)
                SetVehicleExtra(vehs, 11, 1)
            elseif data.label == 'Buffalo 13 ST' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Buffalo 13 ST' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Buffalo STX ST' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Buffalo STX ST' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Aleutian' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1, 1)
                SetVehicleExtra(vehs, 2,1)
            elseif data.label == 'Alamo 23 ST' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1, 1)
                SetVehicleExtra(vehs, 2,1)
            elseif data.label == 'Torence ST' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Gresley UMK' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Buffalo STX UMK' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Bearcat' then
                SetVehicleLivery(vehs, 3)
            elseif data.label == 'Alamo 2500 UMK' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Scout 20 UMK' then
                SetVehicleLivery(vehs, 3)
                SetVehicleExtra(vehs, 1, 0)
                SetVehicleExtra(vehs, 2, 0)
            elseif data.label == 'Scout 20 K9' then
                SetVehicleLivery(vehs, 0)
            elseif data.spawnName == 'lspdscout2k9a' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Buffalo 13 K9' then
                SetVehicleLivery(vehs, 4)
            elseif data.spawnName == 'lspdtorrenceslick' then
                SetVehicleLivery(vehs, 5)
            elseif data.label == 'Stanier ST' then
                SetVehicleLivery(vehs, 7)
            elseif data.label == 'Scout 20 UMK' then
                SetVehicleLivery(vehs, 1)
                SetVehicleExtra(vehs, 1, 0)
            elseif data.spawnName == 'LSPDumkscout16' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Buffalo 13 UMK' then
                SetVehicleLivery(vehs, 6)
            elseif data.label == 'Buffalo 13 UMK' then
                SetVehicleLivery(vehs, 6)
            elseif data.label == 'Buffalo STX TD' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Wintergreen TD' then
                SetVehicleLivery(vehs, 2)
                SetVehicleExtra(vehs, 1, 1)
                SetVehicleExtra(vehs, 5, 1)
            elseif data.label == 'Trust' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Utility Rescue' then
                SetVehicleLivery(vehs, 4)
                SetVehicleExtra(vehs, 1, 1)
                SetVehicleExtra(vehs, 2, 1)
                SetVehicleExtra(vehs, 5, 1)
            elseif data.label == 'Everon' then
                SetVehicleLivery(vehs, 2)
                SetVehicleExtra(vehs, 5, 1)
                SetVehicleExtra(vehs, 6, 1)
                SetVehicleExtra(vehs, 11, 1)
            elseif data.label == 'M.O.C' then
                SetVehicleLivery(vehs, 0)
                SetVehicleExtra(vehs, 1, 1)
                SetVehicleExtra(vehs, 3, 1)
                SetVehicleExtra(vehs, 4, 1)
                SetVehicleExtra(vehs, 5, 1)
                SetVehicleExtra(vehs, 6, 1)
                SetVehicleExtra(vehs, 9, 1)
                SetVehicleExtra(vehs, 10, 1)
            elseif data.spawnName == 'pigeonp' then
                SetVehicleLivery(vehs, 0)
            elseif data.label == 'Speedo express' then
                SetVehicleLivery(vehs, 4)
            elseif data.label == 'Alamo 20' then
                SetVehicleLivery(vehs, 8)
            elseif data.label == 'Alamo 23 K9' then
                SetVehicleLivery(vehs, 1)
            elseif data.label == 'Alamo 23' then
                SetVehicleLivery(vehs, 7)
            elseif data.label == 'Stanier' then
                SetVehicleLivery(vehs, 7)
            elseif data.label == 'Alamo 23 UMK' then
                SetVehicleLivery(vehs, 6)
            elseif data.spawnName == 'lssdbus' then
                SetVehicleLivery(vehs, 1)
                SetVehicleExtra(vehs, 1, 0)
                SetVehicleExtra(vehs, 2, 0)
            end            
            local plate = vehicle.getProps(vehs).plate
            local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
            local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
            AddRandomVehicleStuff(plate)
            --createKeys(plate, model)
            SendNuiMessage(json.encode({
                type = 'closeWebview'
            }))
            return
        end
    end
end)

RegisterNUICallback("armoryTakeLSPD", function(data, cb)
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

RegisterNUICallback("Menu_LSPD_heli_callback", function(data, cb)
    while GetVariable("jobs") == nil do Wait(1) end
    while GetVariable('jobs').lspd == nil do Wait(1) end
    local varLSPD = GetVariable('jobs').lspd
    if vehicle.IsSpawnPointClear(vector3(varLSPD.garagesSpawn.spawnHeli["1"].x, varLSPD.garagesSpawn.spawnHeli["1"].y, varLSPD.garagesSpawn.spawnHeli["1"].z), 3.0) then
        vehs = vehicle.create(data.spawnName,
            vector4(varLSPD.garagesSpawn.spawnHeli["1"].x, varLSPD.garagesSpawn.spawnHeli["1"].y, varLSPD.garagesSpawn.spawnHeli["1"].z, varLSPD.garagesSpawn.spawnHeli["1"].w), {})
        -- SetVehicleLivery(vehs, 0)
        if data.spawnName == 'lspdmav' then
            SetVehicleLivery(vehs, 1)
        elseif data.spawnName == 'lspdvalkyrie' then
            SetVehicleLivery(vehs, 0)
        end
        local plate = vehicle.getProps(vehs).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
        --createKeys(plate, model)
        SendNuiMessage(json.encode({
            type = 'closeWebview'
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

RegisterNUICallback("Menu_LSPD_heli_callback_MR", function(data, cb)
	print('spwawnMR')
    while GetVariable("jobs") == nil do Wait(1) end
    while GetVariable('jobs').lspd == nil do Wait(1) end
    local varLSPD = GetVariable('jobs').lspd
    if vehicle.IsSpawnPointClear(vector3(varLSPD.garagesSpawn.spawnHeliMissionRow["1"].x, varLSPD.garagesSpawn.spawnHeliMissionRow["1"].y, varLSPD.garagesSpawn.spawnHeliMissionRow["1"].z), 3.0) then
        vehs = vehicle.create(data.spawnName, vector4(varLSPD.garagesSpawn.spawnHeliMissionRow["1"].x, varLSPD.garagesSpawn.spawnHeliMissionRow["1"].y, varLSPD.garagesSpawn.spawnHeliMissionRow["1"].z, varLSPD.garagesSpawn.spawnHeliMissionRow["1"].w), {})
        -- SetVehicleLivery(vehs, 0)
        if data.spawnName == 'lspdmav' then
            SetVehicleLivery(vehs, 1)
        elseif data.spawnName == 'lspdvalkyrie' then
            SetVehicleLivery(vehs, 0)
        end
        local plate = vehicle.getProps(vehs).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
        --createKeys(plate, model)
        SendNuiMessage(json.encode({
            type = 'closeWebview'
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

RegisterNUICallback("Menu_LSPD_boat_callback", function(data, cb)
    while GetVariable("jobs") == nil do Wait(1) end
    while GetVariable('jobs').lspd == nil do Wait(1) end
    local varLSPD = GetVariable('jobs').lspd
    if vehicle.IsSpawnPointClear(vector3(varLSPD.garagesSpawn.spawnBoat["1"].x, varLSPD.garagesSpawn.spawnBoat["1"].y, varLSPD.garagesSpawn.spawnBoat["1"].z), 3.0) then
        vehs = vehicle.create(data.spawnName, vector4(varLSPD.garagesSpawn.spawnBoat["1"].x, varLSPD.garagesSpawn.spawnBoat["1"].y, varLSPD.garagesSpawn.spawnBoat["1"].z, varLSPD.garagesSpawn.spawnBoat["1"].w), {})
        if data.spawnName == 'lspdseashark' then
            SetVehicleLivery(vehs, 0)
        elseif data.spawnName == 'poldinghy' then
            SetVehicleLivery(vehs, 3)
        elseif data.spawnName == 'polpreda' then
            SetVehicleLivery(vehs, 0)
        end
        local plate = vehicle.getProps(vehs).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
        --createKeys(plate, model)
        SendNuiMessage(json.encode({
            type = 'closeWebview'
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

local function SpawnPropsLSPD(obj, name)
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

            OpenPropsMenuLSPD()
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
    ['#45'] = "prop_consign_flag_stop"
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
    ['#23'] = "prop_barrier_work06d"
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
    ['#4'] = "prop_lspdpio"
}

local sacs_models = {
    ['#1'] = "xm_prop_x17_bag_01c",
    ['#2'] = "xm_prop_x17_bag_med_01a"
}

local cibletir_models = {
    ['#1'] = "gr_prop_gr_target_05a",
    ['#2'] = "gr_prop_gr_target_05b"
}

RegisterNUICallback("MenuObjetsServicesPublicsLSPD", function(data, cb)
    -- if data == nil or data.category == nil then return end
    -- PropsMenu.choice = data.category

    SendNuiMessage(json.encode({
        type = 'closeWebview'
    }))

    if data.category == "Cones" then
        SpawnPropsLSPD(cones_models[data.label], data.label)
    end

    if data.category == "Panneaux" then
        SpawnPropsLSPD(panneaux_models[data.label], data.label)
    end

    if data.category == "Barrières" then
        SpawnPropsLSPD(barriere_models[data.label], data.label)
    end

    if data.category == "Lumières" then
        SpawnPropsLSPD(lumiere_models[data.label], data.label)
    end

    if data.category == "Tables" then
        SpawnPropsLSPD(tables_models[data.label], data.label)
    end

    if data.category == "Drogues" then
        SpawnPropsLSPD(drogues_models[data.label], data.label)
    end

    if data.category == "Divers" then
        SpawnPropsLSPD(divers_models[data.label], data.label)
    end

    if data.category == "Cibles Tir" then
        SpawnPropsLSPD(cibletir_models[data.label], data.label)
    end

    if data.category == "Sacs" then
        SpawnPropsLSPD(sacs_models[data.label], data.label)
    end

end)

RegisterNetEvent("lspd:traffic:addclient", function(zone)
    AddRoadNodeSpeedZone(zone.zonePos, zone.zoneRadius, zone.zoneSpeed, true)
end)

RegisterNetEvent("lspd:traffic:removeclient", function(zone)
    RemoveRoadNodeSpeedZone(zone)
end)

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7lspd ^3loaded")
end)
