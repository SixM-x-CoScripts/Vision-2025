local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function LoadAvocat2()
    local avocatDuty = false
    local openRadial = false
    function ContratAvocat2()
        if avocatDuty then
            openRadial = false
            closeUI()
            TriggerEvent("nuiPapier:client:startCreation", 3, 'https://cdn.sacul.cloud/v2/vision-cdn/entrepriseCarre/avocat2.webp')
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function CreateAdvert()
        if avocatDuty then
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

    function FactureAvocat()
        if avocatDuty then
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

    function OpenRadialAvocatMenu()
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
                    data = { elements = {
                        {
                            name = "ANNONCE",
                            icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/megaphone.svg",
                            action = "CreateAdvert"
                        },  
                        {
                            name = "FACTURE",
                            icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/billet.svg",
                            action = "FactureAvocat"
                        },
                        {
                            name = "PRISE DE SERVICE",
                            icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/checkmark.svg",
                            action = "setAvocatDuty"
                        },
                        {
                            name = "CONTRAT",
                            icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/paper.svg",
                            action = "ContratAvocat2"
                        }
                    }, title = "AVOCAT"
                    }
                }));
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
    
    function closeRadialMenu()
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
    end

    function setAvocatDuty()
        openRadial = false
        closeUI()
        if avocatDuty then
            TriggerServerEvent('core:DutyOff', 'avocat2')
            --  ShowNotification("Vous avez ~r~quitté~s~ votre service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s quitté ~c votre service"
            })
            avocatDuty = false
            Wait(5000)
        else
            TriggerServerEvent('core:DutyOn', 'avocat2')
            --  ShowNotification("Vous avez ~r~quitté~s~ votre service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s pris ~c votre service"
            })
            avocatDuty = true
            Wait(5000)
        end
    end

    RegisterJobMenu(OpenRadialAvocatMenu)
    
    zone.addZone(
        "avocat_delete2",
        vector3(-570.42083740234, -145.66032409668, 37.799659729004),
        "~INPUT_CONTEXT~ Ranger le véhicule",
        function()
            if IsPedInAnyVehicle(p:ped(), false) then
                if GetVehicleBodyHealth(p:currentVeh()) / 10 >= 80 or
                    GetVehicleEngineHealth(p:currentVeh()) / 10 >= 80 then
                    local veh = GetVehiclePedIsIn(p:ped(), false)
                    removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
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
        "society_avocat2",
        vector3(-599.29406738281, -719.73699951172, 115.80547332764),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les actions d'entreprise",
        function()
            OpenSocietyMenu() --TODO: fini le menu society
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        1.5,
        true,
        "bulleGestion"
    )
    zone.addZone(
        "coffre_avocat2",
        vector3(-250.29486083984, 164.13175964355, 77.870849609375),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le coffre de l'entreprise",
        function()
            OpenInventorySocietyMenu() --TODO: fini le menu society
        end, false,
        27,
        1.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleCoffre"
    )

    zone.addZone(
        "avocat_spawn2",
        vector3(-592.72039794922, -712.60107421875, 25.732513427734),
        "~INPUT_CONTEXT~ Sortir le véhicule",
        function()
            OpenMenuVehAvocat() --TODO: fini le menu society
        end, false,
        27,
        1.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleGarage"
    )

    local listVehAvocat = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_avocat.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
        headerIconName = 'VEHICULES',
        callbackName = 'vehMenuAvocat2',
        elements = {
            {
                id = 1,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Voiture/washington.webp',
                label = 'Washington',
                name = "washington"
            },
        }
    }

    function OpenMenuVehAvocat()
        forceHideRadar()
            SendNuiMessage(json.encode({
                type = 'openWebview',
                name = 'MenuCatalogue',
                data = listVehAvocat
            }))
    end

end

local waitForCar = false
RegisterNUICallback("vehMenuAvocat2", function (data, cb)
    if not waitForCar then
        waitForCar = true
        if vehicle.IsSpawnPointClear(vector3(-594.49029541016, -728.3408203125, 25.732524871826), 3.0) then
            RageUI.CloseAll()
            open = false
            if DoesEntityExist(vehs) then
                TriggerEvent('persistent-vehicles/forget-vehicle', vehs)
                removeKeys(GetVehicleNumberPlateText(vehs), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehs))
                DeleteEntity(vehs)
            end
            vehs = vehicle.create(data.name,
                vector4(-594.49029541016, -728.3408203125, 25.732524871826, 359.77117919922),
                {})
            local plate = vehicle.getProps(vehs).plate
            local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
            local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
            --createKeys(plate, model)
            SetVehicleCustomSecondaryColour(vehs, 0, 0, 0)
            local plate = vehicle.getProps(vehs).plate
            local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
            local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
            --createKeys(plate, model)
        else
            -- ShowNotification("Il n'y a pas de place pour le véhicule")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Il n'y a ~s pas de place ~c pour le véhicule"
            })
        end
        Wait(50)
        waitForCar = false
    end
end)

function UnLoadAvocat2()
    zone.removeZone("coffre_avocat2")
    zone.removeZone("society_avocat2")
    zone.removeZone("avocat_delete2")
    zone.removeZone('avocat_spawn2')
    avocatDuty = false
    openRadial = false
end

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7avocat2 ^3loaded")
end)