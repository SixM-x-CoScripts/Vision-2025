local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

CreateThread(function()
    while zone == nil do Wait(1) end

    local pedsData = {
        { model = "s_m_m_armoured_02", position = vector3(246.9, -401.51, 46.93), heading = 112.06 },
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

local casier = {
    vector3(227.93, -425.97, 47.1)
}

local coffre = vector3(197.79, -421.82, 47.33)
local gestionSociety = vector3(250.75, -445.29, 48.29)
local garage = vector3(246.9, -401.51, 48.93)
local spawnGarage = vector4(263.77, -379.74, 44.35, 244.71)
local deleteGarage = vector3(263.77, -379.74, 44.35)

function LoadJustice()
    local justiceDuty = false
    local openRadial = false
    function ContratJustice()
        if justiceDuty then
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
        if justiceDuty then
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

    function FactureJustice()
        if justiceDuty then
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

    function OpenRadialJusticeMenu()
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
                                name = "FACTURE",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/billet.svg",
                                action = "FactureJustice"
                            },
                            {
                                name = "PRISE DE SERVICE",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/checkmark.svg",
                                action = "setJusticeDuty"
                            },
                            {
                                name = "CONTRAT",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/paper.svg",
                                action = "ContratJustice"
                            }
                        },
                        title = "JUSTICE"
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
            openRadarProperly()
        end
        cb({})
    end)

    function closeRadialMenu()
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
    end

    function setJusticeDuty()
        openRadial = false
        closeUI()
        if justiceDuty then
            TriggerServerEvent('core:DutyOff', 'justice')
            --  ShowNotification("Vous avez ~r~quitté~s~ votre service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s quitté ~c votre service"
            })
            justiceDuty = false
            Wait(5000)
        else
            TriggerServerEvent('core:DutyOn', 'justice')
            --  ShowNotification("Vous avez ~r~quitté~s~ votre service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s pris ~c votre service"
            })
            justiceDuty = true
            Wait(5000)
        end
    end

    RegisterJobMenu(OpenRadialJusticeMenu)

    zone.addZone(
        "justice_delete",
        deleteGarage,
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
        end,
        false,       -- Avoir un marker ou non
        -1,          -- Id / type du marker
        0.6,         -- La taille
        { 0, 0, 0 }, -- RGB
        0,           -- Alpha
        1.5,
        true,
        "bulleGarage"
    )

    zone.addZone(
        "society_justice",
        gestionSociety,
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les actions d'entreprise",
        function()
            OpenSocietyMenu() --TODO: fini le menu society
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
    zone.addZone(
        "coffre_justice",
        coffre,
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le coffre de l'entreprise",
        function()
            OpenInventorySocietyMenu() --TODO: fini le menu society
        end,
        false,                         -- Avoir un marker ou non
        -1,                            -- Id / type du marker
        0.6,                           -- La taille
        { 0, 0, 0 },                   -- RGB
        0,                             -- Alpha
        1.5,
        true,
        "bulleCoffre"
    )

    zone.addZone(
        "justice_spawn",
        garage,
        "~INPUT_CONTEXT~ Sortir le véhicule",
        function()
            OpenMenuVehJustice() --TODO: fini le menu society
        end,
        false,                   -- Avoir un marker ou non
        -1,                      -- Id / type du marker
        0.6,                     -- La taille
        { 0, 0, 0 },             -- RGB
        0,                       -- Alpha
        1.5,
        true,
        "bulleGarage"
    )

    local listVehJustice = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_justice.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
        headerIconName = 'VEHICULES',
        callbackName = 'vehMenuJustice',
        elements = {
            {
                id = 1,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Voiture/oracle2.webp',
                label = 'Oracle',
                name = "lspdoraclemk2um"
            },
            {
                id = 2,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/lspdscoutum.webp',
                label = 'Scout',
                name = "sheriffscout2"
            },
            {
                id = 3,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/lspdtru.webp',
                label = 'Scout',
                name = "lspdtru"
            },
            {
                id = 4,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/usssscoutps.webp',
                label = 'Scout 20',
                name = "usssscoutps"
            },
            {
                id = 5,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/LSPD/usumk1.webp',
                label = 'Buffalo Sx',
                name = "usumk1"
            },

        }
    }

    function OpenMenuVehJustice()
        forceHideRadar()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listVehJustice
        }))
    end

    -- Caisiers
    for k, v in pairs(casier) do
        zone.addZone("coffre_lssd" .. k, v, "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les casiers",
            function()
                OpenJusticeCasier() -- TODO: fini le menu society
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

    local casierOpen = false
    function OpenJusticeCasier()
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
                        count = 50
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
end

local waitForCar = false
RegisterNUICallback("vehMenuJustice", function(data, cb)
    if not waitForCar then
        waitForCar = true
        if vehicle.IsSpawnPointClear(spawnGarage, 3.0) then
            RageUI.CloseAll()
            open = false
            if DoesEntityExist(vehs) then
                --removeKeys(GetVehicleNumberPlateText(vehs), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehs))
                TriggerEvent('persistent-vehicles/forget-vehicle', vehs)
                --removeKeys(GetVehicleNumberPlateText(vehs), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehs))
                DeleteEntity(vehs)
            end
            vehs = vehicle.create(data.name, spawnGarage, {})
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

function UnLoadJustice()
    zone.removeZone("coffre_justice")
    zone.removeZone("society_justice")
    zone.removeZone("justice_delete")
    zone.removeZone('justice_spawn')
    justiceDuty = false
    openRadial = false
end

function MakeBillingPlayer(entity)
    local billing_price = 0
    local billing_reason = ""
    local player = NetworkGetPlayerIndexFromPed(entity)
    local sID = GetPlayerServerId(player)
    local price = KeyboardImput("Entrez le prix")
    if price and type(tonumber(price)) == "number" then
        billing_price = tonumber(price)
    else
        --[[ ShowAdvancedNotification("Centrale", "Facturation", "Veuillez entrer un nombre", "CHAR_CALL911",
            "CHAR_CALL911") ]]

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Veuillez entrer un nombre"
        })
    end
    local reason = KeyboardImput("Entrez la raison")
    if reason ~= nil then
        billing_reason = tostring(reason)
    end

    if entity == nil then
        local closestPlayer, closestDistance = GetClosestPlayer()
        if closestPlayer ~= nil and closestDistance < 3.0 then
            TriggerServerEvent('core:sendbilling', token, GetPlayerServerId(closestPlayer),
                "player", billing_price, billing_reason)
        else
            --[[ ShowAdvancedNotification("Centrale", "Facturation", "Aucun joueur dans la zone", "CHAR_BRYONY",
                "CHAR_BRYONY") ]]

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Aucun joueur dans la zone"
            })
        end
    else
        TriggerServerEvent('core:sendbilling', token, sID,
            "player", billing_price, billing_reason)
        -- ShowNotification("Facturation envoyée \n Prix : ~g~" ..
        --    billing_price .. "~s~$ \n Raison : " .. billing_reason)

        -- New notif
        exports['vNotif']:createNotification({
            type = 'VERT',
            -- duration = 5, -- In seconds, default:  4
            content = "Facturation envoyée \nPrix : ~s " .. billing_price .. "$ \n~c Raison : ~s " .. billing_reason
        })
    end
end

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7justice ^3loaded")
end)
