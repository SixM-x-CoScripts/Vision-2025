local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local policePropsPlaced = {}
local created = false

--[[ local pos = { 
vector4(2832.3908691406, 4769.6240234375, 45.790733337402, 13.116150856018),
vector4(2828.6967773438, 4768.96484375, 45.791984558105, 12.428242683411),
vector4(2825.1577148438, 4768.22265625, 45.790908813477, 12.377061843872),
} ]]

--[[ Citizen.CreateThread(function()
    local ped = nil
    local ped2 = nil
    local ped3 = nil
    if not created then
        ped = entity:CreatePedLocal("s_m_y_sheriff_01", vector3(2840.7805175781, 4767.0219726563, 46.37174987793), 58.332660675049)
        ped2 = entity:CreatePedLocal("s_m_y_sheriff_01", vector3(2808.6813964844, 4723.1220703125, 47.627346038818), 235.9619140625)
        ped3 = entity:CreatePedLocal("s_m_y_sheriff_01", vector3(2762.0776367188, 4834.7358398438, 46.371788024902), 105.28610992432)
        ped4 = entity:CreatePedLocal("s_m_y_sheriff_01", vector3(2824.8522949219, 4732.2202148438, 47.627300262451), 265.94284057617)
        
        created = true

    end
    SetEntityInvincible(ped.id, true)
    ped:setFreeze(true)
    TaskStartScenarioInPlace(ped.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
    SetEntityAsMissionEntity(ped.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped.id, true)
    
    SetEntityInvincible(ped2.id, true)
    ped2:setFreeze(true)
    TaskStartScenarioInPlace(ped2.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
    SetEntityAsMissionEntity(ped2.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped2.id, true)
  
    SetEntityInvincible(ped3.id, true)
    ped3:setFreeze(true)
    TaskStartScenarioInPlace(ped3.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
    SetEntityAsMissionEntity(ped3.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped3.id, true)

    SetEntityInvincible(ped4.id, true)
    ped4:setFreeze(true)
    TaskStartScenarioInPlace(ped4.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
    SetEntityAsMissionEntity(ped4.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped4.id, true)
end) ]]

local function SpawnObject(obj, name)
    local coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
    local objCoords = (coords + forward * 2.5)
    local placed = false
    local heading = p:heading()
    TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)

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

bpDuty = false

function LoadBpJob()

    local casierPos = { 
        vector3(2806.1645507813, 4709.3530273438, 48.627368927002),
        vector3(2805.5173339844, 4711.6162109375, 48.627334594727),
        vector3(2802.2687988281, 4712.9516601563, 48.627361297607),
        vector3(2802.9243164063, 4709.3403320313, 48.627338409424),
        }

    local vehicleOut = nil
    local currentVeh = nil

    local items = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Banners/BP.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Banners/icon.webp',
        headerIconName = 'CATALOGUE',
        callbackName = 'armoryTakeBP',
        showTurnAroundButtons = false,
        multipleSelection = true,
        elements = {            

            {            
                price = 0,
                id = 1,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/shield.webp",
                name = "shield",
                label = "Bouclier anti-émeute",
            },
            {           
                price = 0,
                id = 2,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Fumigene.webp",
                name = "weapon_smokelspd",
                label = "Fumigene",
            },
            {            
                price = 0,
                id = 3,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Fusee_detresse.webp",
                name = "weapon_flare",
                label = "Fusée de détresse",
            },
            {            
                price = 0,
                id = 4,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Gaz_bz.webp",
                name = "weapon_bzgas",
                label = "GAZ BZ",
            },               
            {         
                price = 0,
                id = 5,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/usbpgiletj.webp",
                name = "usbpgiletj",
                label = "Gilet Jaune",
            },
            {         
                price = 0,
                id = 6,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/usbpgiletb.webp",
                name = "usbpgiletb",
                label = "Gilet Bateau",
            },
            {         
                price = 0,
                id = 7,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/usbpkevlo1.webp",
                name = "usbpkevlo1",
                label = "Kevlar Lourd 1",
            },
            {         
                price = 0,
                id = 8,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/usbpkevlo2.webp",
                name = "usbpkevlo2",
                label = "Kevlar Lourd 2",
            },
            {         
                price = 0,
                id = 9,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/usbpkevlo3.webp",
                name = "usbpkevlo3",
                label = "Kevlar Lourd 3",
            },
            {         
                price = 0,
                id = 10,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/usbpkevlo4.webp",
                name = "usbpkevlo4",
                label = "Kevlar Lourd 4",
            },
            {         
                price = 0,
                id = 11,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/usbpkevlo5.webp",
                name = "usbpkevlo5",
                label = "Kevlar Lourd 5",
            },
            {         
                price = 0,
                id = 12,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/usbpkevpc.webp",
                name = "usbpkevpc",
                label = "Pare Couteau",
            },
            {         
                price = 0,
                id = 13,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/usbpinsigne.webp",
                name = "usbpinsigne",
                label = "Insigne USBP",
            },
            {            
                price = 0,
                id = 14,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/radio.webp",
                name = "radio",
                label = "Radio",
            },
        },
    }

    function OpenPoliceITEMMenu()
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

    function BPAnnounce()
        if bpDuty then
            local annonce = KeyboardImput("Entrez le contenu de l'annonce")
            if annonce ~= "" and type(annonce) == "string" then
                TriggerServerEvent("core:makeAnnounceLspd", token, annonce)
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
    local listHeli = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_bp.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/LSPD/logo_vehicule.webp',
        headerIconName = 'HÉLICOPTÈRES',
        callbackName= 'Menu_BP_heli_callback',
        elements = {
            {
                label = 'Buzzard',
                spawnName = 'buzzard4',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/USSS/buzzard4.webp",
                category= 'BORDER PATROL'
            },
            {
                label = 'SuperPuma ASU',
                spawnName = 'as332',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/BP/as332.webp",
                category= 'BORDER PATROL',
            },
        }
    }

    function openGarageHeliBPMenu()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listHeli
        }))
    end

    local listBoat = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_bp.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/LSPD/logo_vehicule.webp',
        headerIconName = 'VEHICULE',
        callbackName= 'Menu_BP_boat_callback',
        elements = {
            {
                label = 'Dinghy',
                spawnName = 'bpdinghy',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/poldinghy.webp",
                category= 'Division',
                subCategory= 'USBP'
            },
            {
                label = 'Predator',
                spawnName = 'bpredator',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/polpreda.webp",
                category= 'Division',
                subCategory= 'USBP'
            },
            {
                label = 'Predator (debug)',
                spawnName = 'bpreadtor',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/polpreda.webp",
                category= 'Division',
                subCategory= 'USBP'
            },
        }
    }

    function openGarageBPBoatMenu()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listBoat
        }))
    end

    zone.addZone("bp_item", vector3(2809.1608886719, 4722.7626953125, 48.627319335938),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir l'armurerie ", 
        function()
            OpenPoliceITEMMenu()
        end,
        false, -- Avoir un marker ou non
        29, -- Id / type du marker
        1.0, -- La taille
        {50, 168, 82}, -- RGB
        170, -- Alpha
        2.0,
        true,
        "bulleArmurerie"
    )

    zone.addZone(
        "society_bp_custom",
        vector3(2820.3325195313, 4828.01171875, 47.182415008545),
        "Appuyer sur ~INPUT_CONTEXT~ pour éditer votre vehicule",
        function()
           local veh = p:currentVeh()
           if GetVehicleClass(veh) == 18 or GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == 'pounder3' then
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

    zone.addZone("bp_garage", vector3(2840.8173828125, 4786.009765625, 48.171337127686),
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
        "society_BpHeli_delete",
        vector3(2752.1892089844, 4850.8046875, 47.3717918396),
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
        "society_bpBoat_delete",
        vector3(3862.1677246094, 4453.5908203125, -1.4746872484684),
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
        35, 0.6, { 255, 0, 0 }, 170
    )
    zone.addZone(
        "spawn_bp_heli",
        vector3(2761.5617675781, 4834.5014648438, 48.371768951416),
        "~INPUT_CONTEXT~ Garage",
        function()
            openGarageHeliBPMenu()
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
        "spawn_bp_boat",
        vector3(3860.0495605469, 4462.2622070313, 3.7182078361511),
        "~INPUT_CONTEXT~ Garage",
        function()
            openGarageBPBoatMenu()
        end, false,
        27,
        1.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleGarage"
    )
    zone.addZone("bp_garage_vehicle", vector3(2840.7805175781, 4767.0219726563, 48.37174987793),
        "~INPUT_CONTEXT~ Véhicules", function()
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

    zone.addZone("society_bp", vector3(2783.6198730469, 4737.9521484375, 47.627346038818),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les actions d'entreprise", function()
            OpenSocietyMenu() -- TODO: fini le menu society
        end, false, 25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170-- Alpha
    )

    zone.addZone("stockage_bp", vector3(2814.5815429688, 4724.8979492188, 47.627296447754),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le coffre des saisies", function()
            OpenInventorySocietyMenu() -- TODO: fini le menu society
        end, false, 25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170-- Alpha
    )
    
    zone.addZone("vestiaire_bp", vector3(2800.2727050781, 4707.0849609375, 48.627338409424),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le vestiaire", function()
            LoadBPVestiaire() -- TODO: fini le menu society
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
        zone.addZone("coffre_bp" .. k, v, "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les casiers",
            function()
                OpenbpCasier() -- TODO: fini le menu society
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
        if bpDuty then
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
                                    if speed == nil or speed < 25 then
                                        speed = 25.0
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
                                RageUI.Button(v.zoneId .. " | " .. v.zoneName, nil, { RightLabel = "~r~ Supprimer" }, true,
                                    {
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
                -- duration = 5, -- In seconds, default:  4
                content = "Vous n'êtes ~s pas en service"
            }) 
        end
    end

    function policeActionDuty()
        openRadial = false
        closeUI()
        if bpDuty then
            TriggerServerEvent('core:DutyOff', 'bp')
            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s quitté ~c votre service"
            })
                
            bpDuty = false
            Wait(5000)
        else
            TriggerServerEvent('core:DutyOn', 'bp')
            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s pris ~c votre service"
            })

            bpDuty = true
            Wait(5000)
        end
    end

    function makeRenfortCall()
        if bpDuty then
            TriggerSecurEvent('core:makeCall', "bp", p:pos(), false, "Appel de renfort (" .. p:getLastname() .. " " .. p:getFirstname() .. ")") 
            ExecuteCommand("me fait un appel de renfort")
            --p:PlayAnim('amb@code_human_police_investigate@idle_a', 'idle_b', 51)
            openRadial = false
            closeUI()
            Modules.UI.RealWait(10000)
            ClearPedTasks(p:ped())
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
    
    function ConvocationBP()
        if bpDuty then
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

    function FactureBP()
        if bpDuty then
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

    function DepositionBP()
        if bpDuty then
            openRadial = false
            closeUI()
            TriggerEvent("nuiPapier:client:startCreation",4)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function CreateAdvert()
        if bpDuty then
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
                function OpenSubRadialPapiers()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = { elements = {
                            {
                                name = "CONVOCATION",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/top_paper.svg",
                                action = "ConvocationBP"
                            },
                            {
                                name = "FACTURE",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/billet.svg",
                                action = "FactureBP"
                            },
                            {
                                name = "RETOUR",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                action = "OpenMainRadialBP"
                            },
                            {
                                name = "DEPOSITION",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/paper.svg",
                                action = "DepositionBP"
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
                                action = "OpenMainRadialBP"
                            },
                            {
                                name = "OBJETS",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/object.svg",
                                action = "OpenPropsMenuBP"
                            }
                        }, 
                        title = "ACTIONS",
                        }
                    }));
                end

                function OpenMainRadialBP()
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
                                action = "policeActionDuty"
                            },
                            {
                                name = "ACTIONS",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/police.svg",
                                action = "OpenSubRadialActions"
                            }
                        }, title = "BORDER PATROL"}
                    }));
                end

                OpenMainRadialBP()
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
                        for k, v in pairs(bp.outfit) do
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

    local selected_vehicle = nil

    local vehs = nil
    ---OpenVeh

    local listVeh = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_bp.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
        headerIconName = 'VEHICULE',
        callbackName= 'Menu_BP_vehicule_callback',
        elements = {
            {
                label = 'Alamo',
                spawnName = 'bpalamo16',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/BP/bpalamo16.webp",
                category= 'Grades',
                subCategory= 'BORDER PATROL'
            },
            {
                label = 'Buffalo S',
                spawnName = 'bpbuffalos',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/BP/bpbuffalos.webp",
                category= 'Grades',
                subCategory= 'BORDER PATROL'
            },
            {
                label = 'Caracara',
                spawnName = 'bpcara',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/BP/bpcara.webp",
                category= 'Grades',
                subCategory= 'BORDER PATROL'
            },
            {
                label = 'Scout',
                spawnName = 'bpscout',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/BP/bpscout.webp",
                category= 'Grades',
                subCategory= 'BORDER PATROL'
            },
            {
                label = 'Seminole',
                spawnName = 'bpseminol',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/BP/bpseminol.webp",
                category= 'Grades',
                subCategory= 'BORDER PATROL'
            },
            {
                label = 'Verus',
                spawnName = 'bpverus',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/BP/bpverus.webp",
                category= 'Grades',
                subCategory= 'BORDER PATROL'
            },
            {
                label = 'Coach',
                spawnName = 'bpcoach',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/BP/bpcoach.webp",
                category= 'Grades',
                subCategory= 'BORDER PATROL'
            },
            {
                label = 'Buffalo STX',
                spawnName = 'lspdbuffsx',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/lspdbuffsx.webp",
                category= 'Grades',
                subCategory= 'BORDER PATROL'
            },
            {
                label = 'Pounder',
                spawnName = 'pounder3',
                image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/lspdbuffsx.webp",
                category= 'Grades',
                subCategory= 'BORDER PATROL'
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

    RegisterNUICallback("focusOut", function (data, cb)
        TriggerScreenblurFadeOut(0.5)
        DisplayHud(true)
        openRadarProperly()
    end)

    local casierOpen = false
    function OpenbpCasier()
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



    -- MENU PROPS 
    
    local function GetDatasProps()
        -- DataSendPropsLSPD.items.elements = {}
    
        local playerJobs = 'lspd-lssd'
    
        -- Cones
        for i = 1, 10 do
            table.insert(DataSendPropsBP.items[2].elements, {
                id = i,
                image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Cones/"..i..".webp",
                category="Cones", 
                label = "#"..i
            })
        end
    
    
       -- Panneaux
        for i = 1, 8 do
            table.insert(DataSendPropsBP.items[3].elements, {
                id = i,
                image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Panneaux/"..i..".webp",
                category="Panneaux",
                label = "#"..i
            })
        end
    
        -- Barrière
        for i = 1, 11 do
            table.insert(DataSendPropsBP.items[4].elements, {
                id = i,
                image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Barrieres/"..i..".webp",
                category="Barrières",
                label = "#"..i
            })
        end
    
        -- Lumières
        for i = 1, 5 do
            table.insert(DataSendPropsBP.items[5].elements, {
                id = i,
                image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Lumieres/"..i..".webp",
                category="Lumières",
                label = "#"..i
            })
        end
    
        -- Tables
        for i = 1, 2 do
            table.insert(DataSendPropsBP.items[6].elements, {
                id = i,
                image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Tables/"..i..".webp",
                category="Tables",
                label = "#"..i
            })
        end
    
        -- Drogues
        for i = 1, 9 do
            table.insert(DataSendPropsBP.items[7].elements, {
                id = i,
                image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Drogues/"..i..".webp",
                category="Drogues",
                label = "#"..i
            })
        end
    
        -- Divers
        for i = 1, 4 do
            table.insert(DataSendPropsBP.items[8].elements, {
                id = i,
                image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Divers/"..i..".webp",
                category="Divers",
                label = "#"..i
            })
        end
    
        -- Cible Tir
        for i = 1, 2 do
            table.insert(DataSendPropsBP.items[9].elements, {
                id = i,
                image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/CiblesTir/"..i..".webp",
                category="Cibles Tir",
                label = "#"..i
            })
        end
    
        -- Sacs
        for i = 1, 2 do
            table.insert(DataSendPropsBP.items[10].elements, {
                id = i,
                image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Sacs/"..i..".webp",
                category="Sacs",
                label = "#"..i
            })
        end
    
    
        DataSendPropsBP.disableSubmit = true
    
        return true
    end
    
    PropsMenu = {
        cam = nil,
        open = false,
    }
    
    
    RegisterNUICallback("focusOut", function()
        if PropsMenu.open then
            PropsMenu.open = false 
        end
    end)
    
    
    DataSendPropsBP = {
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
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_bp.webp',
        callbackName = 'MenuObjetsServicesPublicsBP',
        headerTitle = "OBJETS SERVICES PUBLICS",
        showTurnAroundButtons = false,
    }
    
    local firstart = false
    
    OpenPropsMenuBP = function()
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
            data = DataSendPropsBP
        }))
    end



    end

    function UnloadBpJob()
        zone.removeZone("coffre_bp")
        zone.removeZone("vestiaire_bp")
        zone.removeZone("bp_garage")
        zone.removeZone("society_bp")
        zone.removeZone("bp_garage_vehicle")
        zone.removeZone("stockage_bp")
        zone.removeZone("bp_item")
        zone.removeZone("society_bp_custom")
        zone.removeZone("spawn_bp_heli")
        zone.removeZone("society_bpHeli_delete")
        zone.removeZone("spawn_bp_boat")
        zone.removeZone("society_bpBoat_delete")
        bpDuty = false
    end

    RegisterNUICallback("Menu_BP_vehicule_callback", function(data, cb)
        for key, value in pairs(pos) do
            if vehicle.IsSpawnPointClear(vector3(value.x, value.y, value.z), 3.0) then
                vehs = vehicle.create(data.spawnName, vector4(value), {})
                SetVehicleMod(vehs, 11, 1, false)
                SetVehicleMod(vehs, 12, 1, false)
                SetVehicleMod(vehs, 13, 1, false)
                if data.spawnName == "bpscout" then
                    SetVehicleWheelType(vehs, 4)
                    SetVehicleMod(vehs, 23, 3, false)
                elseif data.spawnName == "bpcara" then
                    --SetVehicleMod(vehs, 23, 5, false)
                    SetVehicleWheelType(vehs, 4)
                elseif data.spawnName == "bpalamo16" then
                    --SetVehicleMod(vehs, 23, 5, false)
                    SetVehicleWheelType(vehs, 4)
                elseif data.spawnName == "bpseminol" then
                    --SetVehicleMod(vehs, 23, 5, false)
                    SetVehicleWheelType(vehs, 4)
                elseif data.spawnName == "pounder3" then
                    --SetVehicleMod(vehs, 23, 5, false)
                    SetVehicleWheelType(vehs, 4)
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



    RegisterNUICallback("armoryTakeBP", function(data, cb)
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

    RegisterNUICallback("Menu_BP_heli_callback", function (data, cb)
        if vehicle.IsSpawnPointClear(vector3(2751.9211425781, 4850.3271484375, 46.371780395508), 3.0) then
            vehs = vehicle.create(data.spawnName, vector4(2751.9211425781, 4850.3271484375, 46.371780395508, 186.9973449707), {})
            -- SetVehicleLivery(vehs, 0)
            if data.spawnName == 'as332' then
                SetVehicleLivery(vehs, 3)
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

    RegisterNUICallback("Menu_BP_boat_callback", function (data, cb)
        if vehicle.IsSpawnPointClear(vector3(3862.1677246094, 4453.5908203125, -1.4746872484684), 3.0) then
            vehs = vehicle.create(data.spawnName, vector4(3862.1677246094, 4453.5908203125, -1.4746872484684, 108.33866882324), {})
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

    local function SpawnPropsBP(obj, name)
        local coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
        local objCoords = (coords + forward * 2.5)
        local placed = false
        local heading = p:heading()
        TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)

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

                OpenPropsMenuBP()
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
        ['#4']     = "prop_lspdpio",
    }

    local sacs_models = {
        ['#1']     = "xm_prop_x17_bag_01c",
        ['#2']     = "xm_prop_x17_bag_med_01a",
    }

    local cibletir_models = {
        ['#1']     = "gr_prop_gr_target_05a",
        ['#2']     = "gr_prop_gr_target_05b",
    }

    RegisterNUICallback("MenuObjetsServicesPublicsBP", function(data, cb)
        -- if data == nil or data.category == nil then return end
        -- PropsMenu.choice = data.category

        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))

        if data.category == "Cones" then 
            SpawnPropsBP(cones_models[data.label], data.label)
        end

        if data.category == "Panneaux" then 
            SpawnPropsBP(panneaux_models[data.label], data.label)
        end

        if data.category == "Barrières" then 
            SpawnPropsBP(barriere_models[data.label], data.label)
        end

        if data.category == "Lumières" then 
            SpawnPropsBP(lumiere_models[data.label], data.label)
        end

        if data.category == "Tables" then 
            SpawnPropsBP(tables_models[data.label], data.label)
        end

        if data.category == "Drogues" then 
            SpawnPropsBP(drogues_models[data.label], data.label)
        end

        if data.category == "Divers" then 
            SpawnPropsBP(divers_models[data.label], data.label)
        end

        if data.category == "Cibles Tir" then 
            SpawnPropsBP(cibletir_models[data.label], data.label)
        end

        if data.category == "Sacs" then 
            SpawnPropsBP(sacs_models[data.label], data.label)
        end

    end)


    RegisterNetEvent("lspd:traffic:addclient", function(zone)
        AddRoadNodeSpeedZone(zone.zonePos, zone.zoneRadius, zone.zoneSpeed, true)
    end)

    Citizen.CreateThread(function()
        while p == nil do Wait(1000) end
        print("^3[JOBS]: ^7bp ^3loaded")
    end)