local token = nil

local inService = false
local posGestion = vector3(-1876.289, 2060.82, 144.5737)
local posCoffre = vector3(-1881.1793, 2063.999, 134.91)
local posCasier = vector3(-1889.50, 2060.9584, 139.98)
local garageMenuPos = vector3(-1928.788, 2060.03, 139.837)
local garageSpawn = vector4(-1919.52807, 2052.89, 139.7374, 262.30)
local garageDespawn = vector3(-1919.30591, 2052.77, 140.735)

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local posDomaine = {
    { name = "Casier_domaine", pos = posCasier,
        action = function()
            if inService then
                OpenDomaineCasier()
            else

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous n'êtes ~s pas en service"
                })

            end
        end },
    { name = "coffre_domaine", pos = posCoffre,
        action = function()
            if inService then
                OpenInventorySocietyMenu()
            else

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous n'êtes ~s pas en service"
                })

            end
        end },
    { name = "gestion_domaine", pos = posGestion,
        action = function()
            if inService then
                OpenSocietyMenu()
            else

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous n'êtes ~s pas en service"
                })

            end
        end },
    { name = "menuVeh_domaine", pos = garageMenuPos,
        action = function()
            if inService then
                OpenMenuVehDomaine()
            else

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous n'êtes ~s pas en service"
                })

            end
        end },
}

function LoadDomaine()
  
    for key, v in pairs(posDomaine) do
        zone.addZone(
            v.name,
            v.pos.xyz,
            "Appuyer sur ~INPUT_CONTEXT~ pour intéragir",
            function()
                v.action()
            end,
            true,
            25, -- Id / type du marker
            0.6, -- La taille
            { 51, 204, 255 }, -- RGB
            170-- Alpha
        )
    end

    zone.addZone(
        "Domaine_Stock", -- Nom
        vector3(-1876.2384033203, 2062.8930664063, 134.91502380371),-- Position
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le stock",  -- Text afficher
        function() -- Action qui seras fait
            if inService then
                OpenPostOPUI() -- Ouvrir le menu
            end
        end,
        true, -- Avoir un marker ou non
        29, -- Id / type du marker
        0.4, -- La taille
        {50, 168, 82}, -- RGB
        170 -- Alpha
    )

    local listVeh = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_vignoble.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
        headerIconName = 'VEHICULES',
        callbackName = 'vehMenuDomaine',
        elements = {
            {
                id = 1,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/DomaineFitzgerald/mule6.webp',
                label = 'Mule',
                name = "mule6"
            },
            {
                id = 2,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/DomaineFitzgerald/mule7.webp',
                label = 'Mule à rampe',
                name = "mule7"
            },
            {
                id = 3,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/DomaineFitzgerald/bisonutil.webp',
                label = 'Bison futé',
                name = "bisonutil"
            },
            {
                id = 4,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/DomaineFitzgerald/tractor.webp',
                label = 'Vieux tracteur',
                name = "tractor"
            },
            {
                id = 5,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/DomaineFitzgerald/tractor2.webp',
                label = 'Tracteur tout beau tout neuf',
                name = "tractor2"
            },
            {
                id = 6,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/DomaineFitzgerald/graintrailer.webp',
                label = 'Remorque à pinard',
                name = "graintrailer"
            },
        }
    }
    ---casier
    local casierOpen = false
    function OpenDomaineCasier()
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
        TriggerScreenblurFadeOut(0.5)
        casierOpen = false
        SetNuiFocusKeepInput(false)
        EnableControlAction(0, 1, true)
        EnableControlAction(0, 2, true)
        EnableControlAction(0, 142, true)
        EnableControlAction(0, 18, true)
        EnableControlAction(0, 322, true)
        EnableControlAction(0, 106, true)
        SetNuiFocus(false, false)
        openRadarProperly()
        DisplayHud(true)
        cb({})
    end)

    RegisterNUICallback("casier__callback", function(data)
        OpenInventoryCasier(p:getJob(), data.numero)
    end)
    function OpenMenuVehDomaine()
        forceHideRadar()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listVeh
        }))
    end
   
    zone.addZone(
        "domaine_delete", garageDespawn, "~INPUT_CONTEXT~ Ranger le véhicule",
        function()
            if IsPedInAnyVehicle(p:ped(), false) then
                if GetVehicleBodyHealth(p:currentVeh()) / 10 >= 80 or
                    GetVehicleEngineHealth(p:currentVeh()) / 10 >= 80 then
                    local veh = GetVehiclePedIsIn(p:ped(), false)
                    --removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                    TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                    TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                    DeleteEntity(veh)
                else
                    -- ShowNotification("~r~Votre véhicule est trop abimé")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Votre véhicule est ~s trop abimé"
                    })

                end
            end
        end,
        true,
        36, 0.5, { 255, 0, 0 }, 255
    )

    function FactureDomaine()
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

    function SetDomaineDuty()
        openRadial = false
        closeUI()
        if not inService then
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez ~s pris ~c votre service"
            })

            TriggerServerEvent('core:DutyOn', "domaine")
            inService = true
            Wait(5000)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous avez ~s quitté ~c votre service"
            })

            TriggerServerEvent('core:DutyOff', "domaine")
            inService = false
            Wait(5000)
        end
    end

    function FactureDomaineEntreprise()
        if inService then
            openRadial = false
            closeUI()
            TriggerEvent("nuiPapier:client:startCreation", 7)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
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

    function OpenRadialDomaine()
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
                function OpenMainRadialDomaine()
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
                                name = "FACTURE",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/billet.svg",
                                action = "OpenRadialDomaineFacture"
                            },
                            {
                                name = "PRISE DE SERVICE",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/checkmark.svg",
                                action = "SetDomaineDuty"
                            },
                            {
                                name = "COMMANDES",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/paper.svg",
                                action = "handleOpenMenu"
                            }
                        }, title = "DOMAINE" }
                    }));
                end
                   
                function OpenRadialDomaineFacture()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = { elements = {
                            {
                                name = "Civil",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/billet.svg",
                                action = "FactureDomaine"
                            },
                            {
                                name = "Entreprise",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/billet.svg",
                                action = "FactureDomaineEntreprise"
                            },
                            {
                                name = "RETOUR",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                action = "OpenMainRadialDomaine"
                            },
                        }, title = "DOMAINE" }
                    }));
                end


                OpenMainRadialDomaine()
            end)
        else
            openRadial = false
            closeUI()
            return
        end
    end

    RegisterJobMenu(OpenRadialDomaine)    

    
    function UnLoadDomaine()
        for key, v in pairs(posDomaine) do
            zone.removeZone(v.name)
        end
        zone.removeZone("domaine_delete")
    end
end

RegisterNUICallback("vehMenuDomaine", function (data, cb)
    if vehicle.IsSpawnPointClear(garageSpawn.xyz, 3.0) then
        RageUI.CloseAll()
        if DoesEntityExist(vehs) then
            TriggerEvent('persistent-vehicles/forget-vehicle', vehs)
            --removeKeys(GetVehicleNumberPlateText(vehs), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs))))
            TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehs))
            DeleteEntity(vehs)
        end
        vehs = vehicle.create(data.name, garageSpawn, {})
        local plate = vehicle.getProps(vehs).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
        --createKeys(plate, model)        
        if data.name == "mule6" then
            SetVehicleLivery(vehs, 3)
            SetVehicleMod(vehs, 48, 3)
        elseif data.name == "mule7" then
            SetVehicleLivery(vehs, 3)
            SetVehicleMod(vehs, 48, 3)
        elseif data.name == "bisonutil" then
            SetVehicleLivery(vehs, 2)
            SetVehicleMod(vehs, 48, 3)
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
    print("^3[JOBS]: ^7domaine ^3loaded")
end)