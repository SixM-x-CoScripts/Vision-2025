function LoadGouvJob()
    local token = nil
    TriggerEvent("core:RequestTokenAcces", "core", function(t)
        token = t
    end)

    zone.addZone(
        "gouv_delete",
        vector3(-571.15185546875, -143.47073364258, 37.460613250732), --570.53234863281, -145.54238891602, 37.778263092041
        "~INPUT_CONTEXT~ Ranger le véhicule",
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
                        content = "~s Votre véhicule est trop abimé"
                    })
                end
            end

        end, false,
        27,
        0.5,
        { 255, 255, 255 },
        170,
        2.4,
        true,
        "bulleGarage"
    )
    zone.addZone(
        "society_gouv",
        vector3(-543.38507080078, -200.03965759277, 47.546379089355), --544.36950683594, -199.47077941895, 47.54615020752
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les actions d'entreprise",
        function()
            OpenSocietyMenu() --TODO: fini le menu society
        end, false,
        27,
        0.5,
        { 255, 255, 255 },
        170,
        2.4,
        true,
        "bulleGestion"
    )

    zone.addZone(
        "society_gouv2",
        vector3(-1666.1337890625, 152.16833496094, 69.725059509277), --544.36950683594, -199.47077941895, 47.54615020752
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les actions d'entreprise",
        function()
            OpenSocietyMenu() --TODO: fini le menu society
        end, false,
        27,
        0.5,
        { 255, 255, 255 },
        170,
        2.4,
        true,
        "bulleGestion"
    )

    zone.addZone(
        "coffre_gouv",
        vector3(-546.68328857422, -194.9284362793, 47.546379089355), --552.38275146484, -197.94941711426, 47.54615020752
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le coffre de l'entreprise",
        function()
            OpenInventorySocietyMenu() --TODO: fini le menu society
        end, false,
        27,
        0.5,
        { 255, 255, 255 },
        170,
        2.4,
        true,
        "bulleCoffre"
    )

    zone.addZone(
        "coffre_gouv2",
        vector3(-1661.5228271484, 153.16102600098, 69.725074768066), --552.38275146484, -197.94941711426, 47.54615020752
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le coffre de l'entreprise",
        function()
            OpenInventorySocietyMenu() --TODO: fini le menu society
        end, false,
        27,
        0.5,
        { 255, 255, 255 },
        170,
        2.4,
        true,
        "bulleCoffre"
    )

    zone.addZone("casier_gouv", vector3(-567.16662597656, -195.13107299805, 39.219741821289), ---567.16662597656, -195.13107299805, 38.219741821289
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les casiers",
        function()
            OpenGouvCasier() -- TODO: fini le menu society
        end, false,
        27,
        1.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleCasiers"
    )

    local gouvDuty
    local openRadial = false
    function GouvDuty()
        openRadial = false
        closeUI()
        if gouvDuty then
            TriggerServerEvent('core:DutyOff', pJob)
            --  ShowNotification("Vous avez ~r~quitté~s~ votre service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s quitté ~c votre service"
            })
            gouvDuty = false
            Wait(5000)
        else
            TriggerServerEvent('core:DutyOn', pJob)
            --  ShowNotification("Vous avez ~r~quitté~s~ votre service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s pris ~c votre service"
            })
            gouvDuty = true
            Wait(5000)
        end
    end

    function ContratGouv()
        if gouvDuty then
            openRadial = false
            closeUI()
            TriggerEvent("nuiPapier:client:startCreation", 3, 'https://cdn.sacul.cloud/v2/vision-cdn/entrepriseCarre/justice.webp')
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function CreateAdvert()
        if gouvDuty then
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

    function FactureGouv()
        if gouvDuty then
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

    local jobLabelName = p:getJob() == "irs" and "IRS" or "GOUVERNEMENT"
    function OpenGouvRadial()
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
                            action = "FactureGouv"
                        },
                        {
                            name = "PRISE DE SERVICE",
                            icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/checkmark.svg",
                            action = "GouvDuty"
                        },
                        {
                            name = "CONTRAT",
                            icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/paper.svg",
                            action = "ContratGouv"
                        }
                    }, title = jobLabelName
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
                type = 'closeWebview',
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
    
    function CloseWebApp()
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
    end

    local casierOpen = false
    function OpenGouvCasier()
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

    RegisterJobMenu(OpenGouvRadial)
    zone.addZone(
        "spawn_gouv",
        vector3(-582.75152587891, -147.09182739258, 38.230167388916), ---583.06512451172, -146.10768127441, 37.230884552002
        "~INPUT_CONTEXT~ Sortir le véhicule",
        function()
            OpenMenuVehGouv() --TODO: fini le menu society
        end, false,
        27,
        1.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleGarage"
    )

    local listVeh = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_justice.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
        headerIconName = 'VEHICULES',
        callbackName = 'vehMenuGouv',
        elements = {
            {
                id = 1,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Voiture/washington.webp',
                label = 'Washington',
                name = "washington"
            },
            {
                id = 2,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/LSPDumkscout16.webp',
                label = 'Scout Unmarked',
                name = "LSPDumkscout16"
            },
            {
                id = 3,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/LSPDumkscout16.webp',
                label = 'Cavalcade Gouv',
                name = "govcaval3"
            },
            {
                id = 4,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSSD/LSPDumkscout16.webp',
                label = 'Cavalcade UMK',
                name = "umkcaval3"
            },
        }
    }

    function OpenMenuVehGouv()
        forceHideRadar()
            SendNuiMessage(json.encode({
                type = 'openWebview',
                name = 'MenuCatalogue',
                data = listVeh
            }))
    end

end

RegisterNUICallback("vehMenuGouv", function (data, cb)
    if vehicle.IsSpawnPointClear(vector3(-578.89428710938, -141.00605773926, 35.709003448486), 3.0) then  ---575.73504638672, -149.74160766602, 37.941028594971
        RageUI.CloseAll()
        open = false
        if DoesEntityExist(vehs) then
            TriggerEvent('persistent-vehicles/forget-vehicle', vehs)
            --removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
            TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
            DeleteEntity(vehs)
        end
        vehs = vehicle.create(data.name,
            vector4(-578.89428710938, -141.00605773926, 35.709003448486, 203.07467651367), ---575.73504638672, -149.74160766602, 37.941028594971, 205.38610839844
            {})
        local plate = vehicle.getProps(vehs).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
        --createKeys(plate, model)
        if data.name == "nspeedo" then
            SetVehicleMod(vehs, 48, 12)
            SetVehicleLivery(vehs, 12)
        elseif data.label == "Scout Unmarked" then
            SetVehicleLivery(vehs, 3)
        end
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

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7gouvernement ^3loaded")
end)