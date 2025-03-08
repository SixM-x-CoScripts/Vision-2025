local token = nil
local inServiceBarber = false
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)
local BarberCam = nil

local gestionSocieteBarber = vector3(139.40434265137, -1703.0847167969, 29.291858673096)
local stockageBarber = vector3(-1277.3532714844, -1119.4091796875, 6.9903526306152)
local posCasierBarber = vec3(-824.97497558594, -182.62814331055, 37.568916320801)

local gestionSocieteBarber2 = vector3(-1277.5874023438, -1116.0013427734, 6.9903512001038)
local stockageBarber2 = vector3(-821.1015625, -181.86897277832, 37.568916320801)
local posCasierBarber2 = vec3(-824.97497558594, -182.62814331055, 37.568916320801)

local gestionSocieteBarbercayo = vector3(5146.03125, -5134.72265625, 2.4300611019135)
local stockageBarbercayo = vector3(5145.26953125, -5133.1005859375, 2.4300611019135)

function IsBarberOnDuty()
    return inServiceBarber
end

function LoadBarber()
    local actualInmenu = false

    CreateThread(function()

        if p:getJob() == "barber" then
            for k, v in pairs(Coiffeur) do
                zone.addZone("action_coiffeur" .. k, -- Nom
                vector3(v.pos.x, v.pos.y, v.pos.z), -- Position
                "~INPUT_CONTEXT~ Intéragir avec le coiffeur", -- Text afficher
                function() -- Action qui seras fait
                    if p:getJob() == "barber" then
                        if actualInmenu == false then
                            if inServiceBarber then
                                StartBarber(v)
                            else
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    content = "Vous devez ~s prendre votre service"
                                })
                            end
                        end
                    end
                end, false, -- Avoir un marker ou non
                25, -- Id / type du marker
                0.6, -- La taille
                {51, 204, 255}, -- RGB
                170, -- Alpha
                1.0, true, "bulleCouper")
            end

            zone.addZone("stockage_barber2", stockageBarber2, "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le stockage",
                function()
                    OpenInventorySocietyMenu() -- TODO: fini le menu society
                end, false, 27, 1.5, {255, 255, 255}, 170, 2.0, true, "bulleCoffre")

            zone.addZone("casier_barber", vector3(posCasierBarber),
                "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les casiers", function()
                    OpenBarberCasier() -- TODO: fini le menu society
                end, false, 27, 1.5, {255, 255, 255}, 170, 2.0, true, "bulleCasiers")

            -- zone.addZone("stockage_barber22", 
            -- stockageBarber22,
            --     "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le stockage", function()
            --         OpenInventorySocietyMenu() -- TODO: fini le menu society
            --     end, false,
            --     27,
            --     1.5,
            --     { 255, 255, 255 },
            --     170,
            --     2.0,
            --     true,
            --     "bulleCoffre"
            -- )

            -- zone.addZone("stockage_barber222", 
            --     stockageBarber222,
            --     "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le stockage", function()
            --         OpenInventorySocietyMenu() -- TODO: fini le menu society
            --     end, false,
            --     27,
            --     1.5,
            --     { 255, 255, 255 },
            --     170,
            --     2.0,
            --     true,
            --     "bulleCoffre"
            -- )

            zone.addZone("barber_gestionsociety", -- Nom
            gestionSocieteBarber, -- Position
            "~INPUT_CONTEXT~ Intéragir", -- Text afficher
            function() -- Action qui seras fait
                if inServiceBarber then
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
            end, false, 27, 1.5, {255, 255, 255}, 170, 2.0, true, "bulleGestion")

        elseif p:getJob() == "barber2" then
            for k, v in pairs(Coiffeur) do
                zone.addZone("action_coiffeur" .. k, -- Nom
                vector3(v.pos.x, v.pos.y, v.pos.z), -- Position
                "~INPUT_CONTEXT~ Intéragir avec le coiffeur", -- Text afficher
                function() -- Action qui seras fait
                    if p:getJob() == "barber2" then
                        if actualInmenu == false then
                            if inServiceBarber then
                                StartBarber(v)
                            else
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    content = "Vous devez ~s prendre votre service"
                                })
                            end
                        end
                    end
                end, false, -- Avoir un marker ou non
                25, -- Id / type du marker
                0.6, -- La taille
                {51, 204, 255}, -- RGB
                170, -- Alpha
                1.0, true, "bulleCouper")
                Bulle.hide("action_coiffeur" .. k)
            end

            zone.addZone("stockage_barber", stockageBarber, -- Position
            "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le stockage", function()
                OpenInventorySocietyMenu() -- TODO: fini le menu society
            end, false, 27, 1.5, {255, 255, 255}, 170, 2.0, true, "bulleCoffre")

            zone.addZone("barber_gestionsociety2", -- Nom
            gestionSocieteBarber2, -- Position
            "~INPUT_CONTEXT~ Intéragir", -- Text afficher
            function() -- Action qui seras fait
                if inServiceBarber then
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
            end, false, 27, 1.5, {255, 255, 255}, 170, 2.0, true, "bulleGestion")

        elseif p:getJob() == "barbercayo" then
            for k, v in pairs(Coiffeur) do
                zone.addZone("action_coiffeur" .. k, -- Nom
                vector3(v.pos.x, v.pos.y, v.pos.z - 0.9), -- Position
                "~INPUT_CONTEXT~ Intéragir avec le coiffeur", -- Text afficher
                function() -- Action qui seras fait
                    if p:getJob() == "barbercayo" then
                        if actualInmenu == false then
                            if inServiceBarber then
                                StartBarber(v)
                            else
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    content = "Vous devez ~s prendre votre service"
                                })
                            end
                        end
                    end
                end, false, -- Avoir un marker ou non
                25, -- Id / type du marker
                0.6, -- La taille
                {51, 204, 255}, -- RGB
                170, -- Alpha
                1.0, true, "bulleCouper")
            end

            zone.addZone("stockage_barbercayo", stockageBarbercayo,
                "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le stockage", function()
                    OpenInventorySocietyMenu() -- TODO: fini le menu society
                end, false, 27, 1.5, {255, 255, 255}, 170, 2.0, true, "bulleCoffre")

            zone.addZone("barber_gestionsocietycayo", -- Nom
            gestionSocieteBarbercayo, -- Position
            "~INPUT_CONTEXT~ Intéragir", -- Text afficher
            function() -- Action qui seras fait
                if inServiceBarber then
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
            end, false, 27, 1.5, {255, 255, 255}, 170, 2.0, true, "bulleGestion")

            --[[elseif p:getJob() == "barberNord" then
            for k, v in pairs(CoiffeurNord) do
                zone.addZone(
                    "action_coiffeur" .. k, -- Nom
                    vector3(v.pos.x, v.pos.y, v.pos.z - 0.9), -- Position
                    "~INPUT_CONTEXT~ Intéragir avec le coiffeur", -- Text afficher
                    function() -- Action qui seras fait
                        print(p:getJob())
                        if p:getJob() == "barberNord" then
                            if actualInmenu == false then
                                if inServiceBarber then
                                    StartBarber(v)
                                else
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        content = "Vous devez ~s prendre votre service"
                                    })
                                end
                            end
                        end
                    end,
                    true, -- Avoir un marker ou non
                    27, -- Id / type du marker
                    0.3, -- La taille
                    { 255, 255, 255 }, -- RGB
                    170-- Alpha
                )
            end
        
            zone.addZone("stockage_barber", vector3(-275.69836425781, 6223.4506835938, 30.695755004883),
                "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le stockage", function()
                    OpenInventorySocietyMenu() -- TODO: fini le menu society
                end, false, 27, -- Id / type du marker
                0.3, -- La taille
                { 255, 255, 255 }, -- RGB
                170-- Alpha
            )]]
        end

    end)

    local casierOpen = false
    function OpenBarberCasier()
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
                        count = 60
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
    end)

    local actualCoiffeurData = nil
    local newPlSelectBarber = nil
    function StartBarber(data)
        local playerSelected = ChoicePlayersInZone(3.0, true)
        if playerSelected ~= nil then
            forceHideRadar()
            -- if GetPlayerServerId(playerSelected) == GetPlayerServerId(PlayerId()) then             
            --    exports['vNotif']:createNotification({
            --        type = 'ROUGE',
            --        content = "Vous ne pouvez pas vous faire de manucure sur vous même"
            --    }) 
            --    return 
            -- end
            actualInmenu = true
            newPlSelectBarber = playerSelected
            TriggerServerEvent("core:PlacePlayerOnSeat", token, GetPlayerServerId(playerSelected), data)
            actualCoiffeurData = data
            DataToSendCoiffeur = {
                buttons = {{
                    name = 'Coupe',
                    width = 'full',
                    image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/barber/cheveux.svg',
                    hoverStyle = 'fill-black stroke-black',
                    opacity = false,
                    color1 = true,
                    color2 = true
                }, {
                    name = 'Degradé',
                    width = 'full',
                    image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/barber/degrader.svg',
                    hoverStyle = 'fill-black stroke-black',
                    opacity = false,
                    color1 = false,
                    color2 = false

                }, {
                    name = 'Yeux',
                    width = 'full',
                    image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/barber/yeux.svg',
                    hoverStyle = 'fill-black stroke-black',
                    opacity = false,
                    color1 = false,
                    color2 = false
                }, {
                    name = 'Barbe',
                    width = 'full',
                    image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/barber/barbe.svg',
                    hoverStyle = 'fill-black stroke-black',
                    opacity = true,
                    color1 = true,
                    color2 = false
                }, {
                    name = 'Sourcils',
                    width = 'full',
                    image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/eyebrow.svg',
                    hoverStyle = 'fill-black stroke-black',
                    opacity = true,
                    color1 = true,
                    color2 = true
                }},
                catalogue = {},
                headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
                headerIconName = 'HOMME',
                hideItemList = {'Degradé'},
                headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_barbershop.webp',
                callbackName = 'MenuGrosCatalogueCoiffeur',
                showTurnAroundButtons = false,
                disableSubmit = false
            }
            DataToSendCoiffeur.catalogue = {}
            local tattoos = getDegrader()
            local plyModel = GetEntityModel(GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(newPlSelectBarber))))
            local sex = "Homme"
            if plyModel == mp_f_freemode_01 then
                sex = "Femme"
                DataToSendCoiffeur.headerIconName = "FEMME"
            end
            Wait(50)
            table.insert(DataToSendCoiffeur.catalogue, {
                id = 0,
                label = "Dégrader N°0",
                image = "",
                ownCallbackName = 'previewCoiffeurCB',
                category = "Degradé",
                info = "aucun"
            })
            for i = 1, #tattoos do
                if tattoos[i].Zone == "ZONE_HEAD" then
                    if plyModel == mp_m_freemode_01 and tattoos[i].HashNameMale ~= "" then
                        table.insert(DataToSendCoiffeur.catalogue, {
                            id = i,
                            label = "Dégrader N°" .. i,
                            image = "https://cdn.sacul.cloud/v2/vision-cdn/Barber/" .. sex .. "/Degrader/" ..
                                i .. ".webp",
                            ownCallbackName = 'previewCoiffeurCB',
                            category = "Degradé",
                            info = tattoos[i]
                        })
                    elseif plyModel == mp_f_freemode_01 and tattoos[i].HashNameFemale ~= "" then
                        table.insert(DataToSendCoiffeur.catalogue, {
                            id = i,
                            label = "Dégrader N°" .. i,
                            image = "https://cdn.sacul.cloud/v2/vision-cdn/Barber/" .. sex .. "/Degrader/" ..
                                i .. ".webp",
                            ownCallbackName = 'previewCoiffeurCB',
                            category = "Degradé",
                            info = tattoos[i]
                        })
                    end
                end
            end
            for i = 0, 31 do
                table.insert(DataToSendCoiffeur.catalogue, {
                    id = i,
                    label = "Yeux N°" .. i,
                    image = "https://cdn.sacul.cloud/v2/vision-cdn/Barber/" .. sex .. "/Yeux/" .. i ..
                        ".webp",
                    ownCallbackName = 'previewCoiffeurCB',
                    category = "Yeux"
                })
            end
            for i = 0, GetNumberOfPedDrawableVariations(GetPlayerPed(
                GetPlayerFromServerId(GetPlayerServerId(playerSelected))), 2) do
                table.insert(DataToSendCoiffeur.catalogue, {
                    id = i,
                    label = "Coiffure N°" .. i,
                    image = "https://cdn.sacul.cloud/v2/vision-cdn/Barber/" .. sex .. "/Coupes/" .. i ..
                        ".webp",
                    ownCallbackName = 'previewCoiffeurCB',
                    category = "Coupe"

                })
            end
            for i = 1, GetNumHeadOverlayValues(1) - 1 do
                table.insert(DataToSendCoiffeur.catalogue, {
                    id = i,
                    label = "Barbe N°" .. i,
                    image = "https://cdn.sacul.cloud/v2/vision-cdn/Barber/" .. sex .. "/Barbes/" .. i ..
                        ".webp",
                    ownCallbackName = 'previewCoiffeurCB',
                    category = "Barbe"

                })
            end
            -- Sourcils
            for i = 0, GetNumHeadOverlayValues(2) - 1 do
                local add = i + 1
                table.insert(DataToSendCoiffeur.catalogue, {
                    id = i,
                    label = "Sourcils N°" .. i,
                    image = "https://cdn.sacul.cloud/v2/vision-cdn/SheNails/" .. sex .. "/Sourcils/" .. add ..
                        ".webp",
                    ownCallbackName = 'previewCoiffeurCB',
                    category = "Sourcils"
                })
            end
            SendNuiMessage(json.encode({
                type = 'openWebview',
                name = 'MenuGrosCatalogueColor',
                data = DataToSendCoiffeur
            }))
            Wait(50)
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = 'Appuyez sur G pour controler/bloquer la caméra. Appuyez sur les flèches directionnelles pour tourner la caméra'
            })

            local EnableCam = false

            SetNuiFocusKeepInput(true)

            CreateThread(function()
                while actualInmenu do
                    Wait(1)
                    if IsControlJustPressed(0, 47) then
                        EnableCam = not EnableCam
                    end
                    if not EnableCam then
                        DisableControlAction(0, 1, true)
                        DisableControlAction(0, 2, true)
                    end
                    DisableControlAction(0, 142, true)
                    DisableControlAction(0, 18, true)
                    DisableControlAction(0, 322, true)
                    DisableControlAction(0, 106, true)
                    DisableControlAction(0, 24, true)
                    DisableControlAction(0, 25, true)
                    DisableControlAction(0, 263, true)
                    DisableControlAction(0, 264, true)
                    DisableControlAction(0, 257, true)
                    DisableControlAction(0, 140, true)
                    DisableControlAction(0, 141, true)
                    DisableControlAction(0, 142, true)
                    DisableControlAction(0, 143, true)
                    DisableControlAction(0, 38, true)
                    DisableControlAction(0, 44, true)
                end
            end)
        end
    end

    RegisterNUICallback("focusOut", function(data, cb)
        if actualInmenu then
            TriggerServerEvent("core:ExitPlayerOnSeatSRV", token, GetPlayerServerId(newPlSelectBarber),
                actualCoiffeurData)
            Wait(100)
            SetNuiFocusKeepInput(false)
            if BarberCam then
                -- SetCamActive(BarberCam, 0)
                -- DestroyCam(BarberCam)
                stopDragCam()
                RenderScriptCams(false, false, 0, 1, 0)
            end
            SetNuiFocus(false, false)
            BarberCam = nil
            newPlSelectBarber = nil
            actualInmenu = false
        end
    end)
    RegisterNUICallback("MenuGrosCatalogueCoiffeur", function(data, cb)
        if inServiceBarber then
            if data.changedData then
                HairCutAnim()
                TriggerServerEvent("core:applySkinBarberSRV", token, GetPlayerServerId(newPlSelectBarber),
                    data.changedData)
                -- {"changedData":{"Coupe":{"item":{"label":"Coiffure N°41","id":41,"ownCallbackName":"previewCoiffeurCB","category":"Coupe"},"color1":33}}}
                -- closeUI()
                -- Wait(100)
                -- SetNuiFocusKeepInput(false)
                -- SetNuiFocus(false, false)
            end
        end
    end)

    RegisterNUICallback("MenuGrosCatalogueCoiffeur", function(data)
        if inServiceBarber then
            TriggerServerEvent("core:SendUpdateHairToServ1", token, data, GetPlayerServerId(newPlSelectBarber))
        end
    end)

    RegisterNUICallback("previewCoiffeurCB", function(data)
        if InPrevisuCatalogueBarber then
            return
        end
        if inServiceBarber then
            TriggerServerEvent("core:SendUpdateHairToServ2", token, data, GetPlayerServerId(newPlSelectBarber))
            TriggerServerEvent("core:SendUpdateHairToServCayo", token, data, GetPlayerServerId(newPlSelectBarber))
            -- CreateCameraBarber(GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(newPlSelectBarber))), data.category)
            print("player, player id", GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(newPlSelectBarber))),
                GetPlayerServerId(newPlSelectBarber))
            BarberCam = true
            if GetPlayerServerId(newPlSelectBarber) ~= 0 and camDragCam == nil then
                print("create cam")
                startDragCam(GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(newPlSelectBarber))), {
                    initial = 1.5,
                    min = 0.5,
                    max = 2.0,
                    scrollIncrements = 1.0
                }, vector3(0.0, 0.0, -0.2))
            end
        end
    end)

    function FactureBarber()
        if inServiceBarber then
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

    function SetBarberDuty()
        openRadial = false
        closeUI()
        if not inServiceBarber then
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez ~s pris ~c votre service"
            })

            TriggerServerEvent('core:DutyOn', p:getJob())
            inServiceBarber = true
            for k, v in pairs(Coiffeur) do
                Bulle.hide("action_coiffeurSolo" .. k)
                Bulle.show("action_coiffeur" .. k)
            end
            Wait(5000)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous avez ~s quitté ~c votre service"
            })
            for k, v in pairs(Coiffeur) do
                Bulle.show("action_coiffeurSolo" .. k)
                Bulle.hide("action_coiffeur" .. k)
            end
            TriggerServerEvent('core:DutyOff', p:getJob())
            inServiceBarber = false
            Wait(5000)
        end
    end

    function CreateAdvert()
        if inServiceBarber then
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

    function OpenRadialTattoo()
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
                SendNuiMessage(json.encode({
                    type = 'openWebview',
                    name = 'RadialMenu',
                    data = {
                        elements = {{
                            name = "ANNONCE",
                            icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/megaphone.svg",
                            action = "CreateAdvert"
                        }, {
                            name = "FACTURE",
                            icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/billet.svg",
                            action = "FactureBarber"
                        }, {
                            name = "PRISE DE SERVICE",
                            icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/checkmark.svg",
                            action = "SetBarberDuty"
                        }},
                        title = ((p:getJob() == "barber") and "Hair Top") or ((p:getJob() == "barber2") and "O'Sheas") or
                            ((p:getJob() == "barbercayo") and "Barber de CayoPerico")
                    }
                }));
            end)
        else
            openRadial = false
            closeUI()
            return
        end
    end

    RegisterJobMenu(OpenRadialTattoo)
end

local angleY = 0.0
local angleZ = 0.0
local radius = 1.5
local mouseX = 0.0
local mouseY = 0.0

function ProcessNewPosition()

    if IsControlPressed(0, 174) or IsDisabledControlPressed(0, 174) then
        mouseX = mouseX + 0.1
    elseif IsControlPressed(0, 175) or IsDisabledControlPressed(0, 175) then
        mouseX = mouseX - 0.1
    else
        mouseX = 0.0
        mouseY = 0.0
    end

    if (IsInputDisabled(0)) then
        -- mouseX = GetDisabledControlNormal(1, 1) * 8.0
        -- mouseY = GetDisabledControlNormal(1, 2) * 8.0
    else
        mouseX = GetDisabledControlNormal(1, 1) * 1.5
        mouseY = GetDisabledControlNormal(1, 2) * 1.5
    end

    angleZ = angleZ - mouseX -- around Z axis (left / right)
    angleY = angleY + mouseY -- up / down
    -- limit up / down angle to 90°
    if (angleY > 89.0) then
        angleY = 89.0
    elseif (angleY < -89.0) then
        angleY = -89.0
    end

    local pCoords = GetEntityCoords(PlayerPedId())

    local behindCam = {
        x = pCoords.x + ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * (radius + 0.5),
        y = pCoords.y + ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * (radius + 0.5),
        z = pCoords.z + ((Sin(angleY))) * (radius + 0.5)
    }
    local rayHandle = StartShapeTestRay(pCoords.x, pCoords.y, pCoords.z + 0.5, behindCam.x, behindCam.y, behindCam.z,
        -1, PlayerPedId(), 0)
    local a, hitBool, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

    local maxRadius = radius
    if (hitBool and Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords) < radius + 0.5) then
        maxRadius = Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords)
    end

    local offset = {
        x = ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * maxRadius,
        y = ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * maxRadius,
        z = ((Sin(angleY))) * maxRadius
    }

    local pos = {
        x = pCoords.x + offset.x,
        y = pCoords.y + offset.y,
        z = pCoords.z + offset.z
    }
    return pos
end

function ProcessCamControls(cam)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    -- disable 1st person as the 1st person camera can cause some glitches
    DisableFirstPersonCamThisFrame()

    -- calculate new position
    local newPos = ProcessNewPosition()

    -- focus cam area
    SetFocusArea(newPos.x, newPos.y, newPos.z, 0.0, 0.0, 0.0)

    -- set coords of cam
    SetCamCoord(cam, newPos.x, newPos.y, newPos.z)

    -- set rotation
    PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + 0.5)
end

function CreateCameraBarber(player, typecam)
    if BarberCam == nil then
        BarberCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    end
    SetCamActive(BarberCam, 1)
    local coord = GetEntityCoords(player)
    -- local formattedcamval = {coord.x, coord.y, coord.z}
    -- if typecam == "Degradé" or typecam == "Barbe" or typecam == "Coupe" or typecam == "Yeux" then 
    local formattedcamval = {coord.x + (GetEntityForwardX(player) * 2), coord.y, coord.z + 0.9, 50, 0.2}
    -- elseif typecam == "Pilosité" then 
    --    formattedcamval = {coord.x-1.0, coord.y, coord.z+0.7, 55, 0.6}
    -- elseif typecam == "Manucure" then 
    --    formattedcamval = {coord.x-1.0, coord.y, coord.z+0.3, 40, -0.1}
    -- end
    SetCamCoord(BarberCam, formattedcamval[1], formattedcamval[2], formattedcamval[3])
    PointCamAtEntity(BarberCam, player)
    PointCamAtCoord(BarberCam, coord.x, coord.y, coord.z + formattedcamval[5])
    SetCamFov(BarberCam, formattedcamval[4] + 0.1)
    RenderScriptCams(true, 0, 3000, 1, 0)
    while true do
        Wait(1)
        ProcessCamControls(BarberCam)
    end
end

function UnLoadBarber()
    for k, v in pairs(Coiffeur) do
        zone.removeZone("action_coiffeur" .. k)
    end
    zone.removeZone("barber_gestionsociety")
    zone.removeZone("barber_gestionsociety2")
    zone.removeZone("barber_gestionsocietycayo")
    zone.removeZone("stockage_barber")
    zone.removeZone("stockage_barber2")
    zone.removeZone("stockage_barber22")
    zone.removeZone("stockage_barber222")
    zone.removeZone("stockage_barbercayo")
end

Citizen.CreateThread(function()
    while p == nil do
        Wait(1000)
    end
    print("^3[JOBS]: ^7barber ^3loaded")
end)
