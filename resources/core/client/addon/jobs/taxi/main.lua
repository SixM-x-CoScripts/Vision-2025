CreateThread(function()
    while zone == nil do Wait(1)end

    local ped = entity:CreatePedLocal("s_m_m_armoured_02", vector3(902.6006, -167.258, 73.0791),  240.0)
    ped:setFreeze(true)
    SetEntityInvincible(ped.id, true)
    SetEntityAsMissionEntity(ped.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped.id, true)

end)

local listVeh = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_taxi.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
    headerIconName = 'VEHICULES',
    callbackName = 'vehMenuTaxi',
    elements = {
        {
            id = 1,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Taxi/staniertaxi.webp',
            label = 'Stanier',
            name = "staniertaxi"
        },
        {
            id = 2,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Taxi/cabby.webp',
            label = 'Cabby',
            name = "cabby"
        },
        {
            id = 3,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Taxi/merittaxi.webp',
            label = 'Merit',
            name = "merittaxi"
        },
        {
            id = 4,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Taxi/ballertaxi.webp',
            label = 'Baller',
            name = "ballertaxi"
        },
    }
}

local coffrePos = {
    -- vector3(895.03344726563, -171.82328796387, 74.682640075684),
    vector3(897.42639160156, -171.6908416748, 74.682678222656)
}

local spawnPlaces = {
    vector4(911.5272, -163.7983, 74.3562, 198.6738),
    vector4(913.9636, -160.032, 74.7556, 200.2266),
    vector4(917.6412, -167.2584, 74.5841, 100.7624),
    vector4(915.8552, -170.6685, 74.3942, 95.2654),
    vector4(908.603, -183.1293, 74.2071, 61.7967),
    vector4(906.6928, -186.1627, 74.005, 54.1545),
    vector4(904.9775, -188.7189, 73.7999, 57.5776),
    vector4(903.019, -191.5337, 73.7914, 59.6044),
    vector4(897.8198, -183.9544, 73.7861, 243.9197),
    vector4(899.8725, -180.7313, 73.8597, 237.6166),
}

local function OpenMenuVehTaxi()
    forceHideRadar()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listVeh
        }))
end

RegisterNUICallback("vehMenuTaxi", function (data, cb)
    vehs = nil

    for k, v in pairs(spawnPlaces) do
        if vehicle.IsSpawnPointClear(vector3(v.x, v.y, v.z), 3.0) then
            if DoesEntityExist(vehs) then
                TriggerEvent('persistent-vehicles/forget-vehicle', vehs)
                --removeKeys(GetVehicleNumberPlateText(vehs), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehs))
                DeleteEntity(vehs)
            end
            vehs = vehicle.create(data.name, vector4(v), {})
            local plate = vehicle.getProps(vehs).plate
            local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
            local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
            --createKeys(plate, model)
            return
        else
            -- ShowNotification("Il n'y a pas de place pour le véhicule")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Il n'y a ~s pas de place ~c pour le véhicule"
            })
        end
    end
end)


function LoadTaxiJob()
    if pJob ~= "taxi" then
        return
    end
    local token = nil

    TriggerEvent("core:RequestTokenAcces", "core", function(t)
        token = t
    end)
    local taxiDuty = false
    local openRadial = false
    --Zone: San Andreas
    zone.addZone(
        "society_taxi",
        vector3(903.96569824219, -162.94458007812, 77.162818908691),
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
        "society_taxi_delete",
        vector3(922.37371826172, -163.35202026367, 74.870048522949),
        "~INPUT_CONTEXT~ Ranger le véhicule",
        function()
            if IsPedInAnyVehicle(p:ped(), false) then
                if GetVehicleBodyHealth(p:currentVeh()) / 10 >= 80 or GetVehicleEngineHealth(p:currentVeh()) / 10 >= 80 then
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
        1.5,
        { 255, 255, 255 },
        170,
        3.0,
        true,
        "bulleGarage"
    )

    zone.addZone(
        "society_taxi_spawn",
        vector3(902.6006, -167.258, 75.0791),
        "~INPUT_CONTEXT~ Sortir le véhicule",
        function()
            if taxiDuty then
                OpenMenuVehTaxi() --TODO: fini le menu society
            else
                -- ShowNotification("Vous n'êtes pas en service")

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
        2.0,
        true,
        "bulleVehicule"
    )

    -- zone.addZone(
    --     "vestiare_ptaxi",
    --     vector3(896.38488769531, -173.62405395508, 74.682678222656),
    --     "Appuyer sur ~INPUT_CONTEXT~ pour prendre/finir le service",
    --     function()
    --         TaxiDuty()
    --     end,
    --     false,
    --     25, -- Id / type du marker
    --     0.6, -- La taille
    --     { 51, 204, 255 }, -- RGB
    --     170-- Alpha
    -- )

   


    for k, v in pairs(coffrePos) do
        zone.addZone(
            "casier_taxi" .. k,
            v,
            "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les casiers",
            function()
                OpentaxiCasier() --TODO: fini le menu society
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

    zone.addZone(
        "coffre_TAXI", vector3(892.03363037109 , -174.02885437012, 74.682983398438),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le coffre de l'entreprise",
        function()
            OpenInventorySocietyMenu() --TODO: fini le menu society
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        1.5,
        true,
        "bulleCoffre"
    )

    local casierOpen = false
    function OpentaxiCasier()
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
    function FactureTaxiNews(entity)
        if taxiDuty then
            local billing_price = 0
            local billing_reason = ""
            local price = KeyboardImput("Entrez le prix")
            if price and type(tonumber(price)) == "number" then
                billing_price = tonumber(price)
            else
                -- ShowNotification("Veuillez entrer un nombre")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Veuillez entrer un nombre"
                })

            end
            local reason = KeyboardImput("Entrez la raison")
            if reason ~= nil then
                billing_reason = tostring(reason)
            end

            local closestPlayer, closestDistance = GetClosestPlayer()
            if closestPlayer ~= nil and closestDistance < 3.0 then
                TriggerServerEvent('core:sendbilling', token, GetPlayerServerId(closestPlayer),
                    p:getJob(), billing_price, billing_reason)
            else
                -- ShowNotification("Aucun joueur dans la zone")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Aucun joueur dans la zone"
                })

            end
        else
            -- ShowNotification("Vous n'êtes pas en service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous n'êtes ~s pas en service"
            })
        end
    end

    function TaxiDuty()
        openRadial = false
        closeUI()
        if taxiDuty then
            TriggerServerEvent('core:DutyOff', 'taxi')
            --  ShowNotification("Vous avez ~r~quitté~s~ votre service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s quitté ~c votre service"
            })

            taxiDuty = false
            Wait(5000)
        else
            TriggerServerEvent('core:DutyOn', 'taxi')
            --  ShowNotification("Vous avez ~r~quitté~s~ votre service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s pris ~c votre service"
            })
            taxiDuty = true
            Wait(5000)
        end

    end

    function FactureTaxi()
        if taxiDuty then
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

    function CreateAdvert()
        if taxiDuty then
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

    function CoursesTaxi()
        if taxiDuty then
            openRadial = false
            closeUI()
            MissionPnjTaxi()
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function OpenRadialTaxiMenu()
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
                            action = "FactureTaxi"
                        },
                        {
                            name = "PRISE DE SERVICE",
                            icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/checkmark.svg",
                            action = "TaxiDuty"
                        },
                        {
                            name = "COURSES",
                            icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/taxi.svg",
                            action = "CoursesTaxi"
                        }
                    }, title = "TAXI"
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

    end

    RegisterJobMenu(OpenRadialTaxiMenu)
end

function UnLoadTaxiJob()
    zone.removeZone("society_taxi")
    zone.removeZone("society_taxi_delete")
    zone.removeZone("society_taxi_spawn")
    zone.removeZone("casier_taxi")
    zone.removeZone("coffre_TAXI")
end

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7taxi ^3loaded")
end)