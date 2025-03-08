local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function LoadPawnShopMenu()
    local openRadial = false

    if pJob ~= "pawnshop" then
        return
    end
    loadPawnshop()
    -- zone.addZone(
    --     "pawnshop_society",
    --     vector3(-329.38662719727, -91.743537902832, 46.047325134277),
    --     "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir la gestion d'entreprise",
    --     function()
    --         OpenSocietyMenu() --TODO: fini le menu society
    --     end,
    --     true,
    --     25, -- Id / type du marker
    --     0.6, -- La taille
    --     { 51, 204, 255 }, -- RGB
    --     170-- Alpha
    -- )
    zone.addZone(
        "pawnshop_keys",
        vector3(-329.38662719727, -91.743537902832, 47.047325134277),
        "Appuyer sur ~INPUT_CONTEXT~ pour créer une clef",
        function()
            local plate = KeyboardImput("Entrez la plaque")
            local model = KeyboardImput("Entrez le model")
            createKeys(string.upper(plate), model)
        end, false,
        27,
        1.5,
        { 255, 255, 255 },
        170,
        1.5,
        true,
        "bulleFrabriquer"
    )
    zone.addZone(
        "coffre_pawnshop",
        vector3(-330.88665771484, -96.598190307617, 47.047325134277),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le coffre de l'entreprise",
        function()
            OpenInventorySocietyMenu() --TODO: fini le menu society
        end, false,
        27,
        1.5,
        { 255, 255, 255 },
        170,
        1.5,
        true,
        "bulleCoffre"
    )

    zone.addZone(
        "society_pawnshop_delete",
        vector3(-344.08572387695, -86.925682067871, 45.664241790771),
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
        1.5,
        true,
        "bulleGarage"
    )

    zone.addZone(
        "society_pawnshop_spawn",
        vector3(-339.98199462891, -86.368354797363, 45.664241790771),
        "~INPUT_CONTEXT~ Sortir le véhicule",
        function()
            if PawnShop.Duty then
                OpenMenuVehPawnshop() --TODO: fini le menu society
            else
                -- ShowNotification("~r~Vous n'êtes pas en service")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous n'êtes ~s pas en service"
                })

            end
        end, false,
        27,
        1.5,
        { 255, 255, 255 },
        170,
        1.5,
        true,
        "bulleVehicule"
    )

    function FacturePawnshop()
        if PawnShop.Duty then
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

    function SetPawnshopDuty()
        openRadial = false
        closeUI()
        if not PawnShop.Duty then
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez ~s pris ~c votre service"
            })

            TriggerServerEvent('core:DutyOn', pJob)
            PawnShop.Duty = true
            Wait(5000)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous avez ~s quitté ~c votre service"
            })

            TriggerServerEvent('core:DutyOff', pJob)
            PawnShop.Duty = false
            Wait(5000)
        end
    end

    function CreateAdvert()
        if PawnShop.Duty then
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

    function ContratPawnshop()
        if PawnShop.Duty then
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
    
    function OpenRadialPawnshop()
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
                            action = "FacturePawnshop"
                        },
                        {
                            name = "PRISE DE SERVICE",
                            icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/checkmark.svg",
                            action = "SetPawnshopDuty"
                        },
                        {
                            name = "CONTRAT",
                            icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/paper.svg",
                            action = "ContratPawnshop"
                        }
                    }, title = "PAWNSHOP" }
                }));
            end)
        else
            openRadial = false
            closeUI()
            return
        end
    end

    RegisterJobMenu(OpenRadialPawnshop)

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

    local listVeh = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_pawnshop1.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
        headerIconName = 'VEHICULES',
        callbackName = 'vehMenuPawnshop',
        elements = {
            {
                id = 1,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Voiture/nspeedo.webp',
                label = 'VAN - Speedo',
                name = "nspeedo"
            },
            {
                id = 2,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Voiture/xls.webp',
                label = 'SUV - XLS',
                name = "xls"
            },
        }
    }

    function OpenMenuVehPawnshop()
        forceHideRadar()
            SendNuiMessage(json.encode({
                type = 'openWebview',
                name = 'MenuCatalogue',
                data = listVeh
            }))
    end


        zone.addZone("casier_pawnshop", vector3(-333.1887512207, -94.328987121582, 46.047367095947), "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les casiers",
            function()
                if PawnShop.Duty then
                    OpenPawnshopCasier() -- TODO: fini le menu society
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        duration = 5, -- In seconds, default:  4
                        content = "Vous n'êtes ~s pas en service"
                    }) 
                end
            end, false,
            27,
            1.5,
            { 255, 255, 255 },
            170,
            2.0,
            true,
            "bulleCasiers"
        )
    ---casier
    local casierOpen = false
    function OpenPawnshopCasier()
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
end

RegisterNUICallback("vehMenuPawnshop", function (data, cb)
    if vehicle.IsSpawnPointClear(vector3(-347.15203857422, -94.17716217041, 44.664241790771), 3.0) then
        if DoesEntityExist(vehs) then
            TriggerEvent('persistent-vehicles/forget-vehicle', vehs)
            --removeKeys(GetVehicleNumberPlateText(vehs), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs))))
            TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehs))
            DeleteEntity(vehs)
        end
        vehs = vehicle.create(data.name,
            vector4(-347.15203857422, -94.17716217041, 44.664241790771, 338.55340576172),
            {})
        local plate = vehicle.getProps(vehs).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
        --createKeys(plate, model)
        if data.name == "nspeedo" then
            SetVehicleMod(vehs, 48, 13)
            SetVehicleLivery(vehs, 13)
        elseif data.name == "rebla" then
            SetVehicleMod(vehs, 48, 0)
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


function UnLoadPawnShop()
    -- body
    zone.removeZone("pawnshop_society")
    zone.removeZone("coffre_pawnshop")
    zone.removeZone("society_pawnshop_delete")
    zone.removeZone("society_pawnshop_spawn")
    zone.removeZone("pawnshop_keys")
end