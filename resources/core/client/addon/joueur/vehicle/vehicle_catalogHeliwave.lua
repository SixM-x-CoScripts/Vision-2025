local DataToSendConcess = {}
local token, justOnTime = nil, 0
local open = false
local selected_category
local previewVeh = { model = "", entity = nil }
local previewActive = false
local usedCatalog = nil
local FirstCo = 0
local cooldownVeh = 0
local alreadywaitingcar = false

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

RegisterNetEvent("core:deleteVehCatalogue", function(netid)
    local entity = NetToVeh(netid)
    if DoesEntityExist(entity) then
        DeleteEntity(entity)
    end
end)

RegisterNUICallback("focusOut", function (data, cb)
    if open then
        TriggerEvent("sw:allowfrrr", 0)
        open = false
        justOnTime = 0
        ClearFocus()
        DisableIdleCamera(false)
        TriggerScreenblurFadeOut(0.5)
        DisplayHud(true)
        RenderScriptCams(false, false, 0, 1, 0)
        openRadarProperly()
        SetNuiFocus(false, false)
        EnableControlAction(0, 1, true)
        EnableControlAction(0, 2, true)
        EnableControlAction(0, 142, true)
        EnableControlAction(0, 18, true)
        EnableControlAction(0, 322, true)
        EnableControlAction(0, 106, true)
        cooldownVeh = 0
        while alreadywaitingcar do -- Attend le cooldown pour supprimer le véhicule
            Wait(1)
        end
        if previewVeh.entity then
            TriggerEvent('persistent-vehicles/forget-vehicle', previewVeh.entity)
            DeleteEntity(previewVeh.entity)
        end
        TriggerServerEvent("core:changeCatalogueUsed", token, usedCatalog, false, "nord")
        ClearFocus()
    end
end)

local function LoadingPrompt(loadingText, spinnerType)
    if BusyspinnerIsOn() then
        BusyspinnerOff()
    end
    if (loadingText == nil) then
        BeginTextCommandBusyString(nil)
    else
        BeginTextCommandBusyString("STRING");
        AddTextComponentSubstringPlayerName(loadingText);
    end
    EndTextCommandBusyString(spinnerType)
end

RegisterNetEvent("core:spawnpremiumcarheliwave")
AddEventHandler("core:spawnpremiumcarheliwave", function(model, plate, color)
    TriggerSWEvent("TREFSDFD5156FD", "VZEFDSF", 7000)
    local Coords = GetEntityCoords(PlayerPedId())
    local Heading = GetEntityHeading(PlayerPedId())
    local vec = vector4(-732.50134277344, -1359.8571777344, -1.3998841941357, 138.44007873535)
    local vehicle = vehicle.create(model, vec,
        {
            plate = plate
        })
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    SetEntityAsMissionEntity(vehicle, true, true)
    TriggerServerEvent("core:SetVehicleOut", string.upper(plate), VehToNet(vehicle), vehicle)
end)

RegisterNUICallback("concessHeliwaveBUY", function(data)
    if not data.button then
        if data.category == "Premium" then 
            TriggerServerEvent("core:premium:buyCar", data, "heliwave")
            closeUI()
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = 'Appelez un concessionnaire pour pouvoir acheter ce véhicule'
            })
        end
    end
end)

---3263.1516113281, -1947.4516601563, 7.8187160491943, 209.17060852051
---1955.8843994141, 3207.3505859375, 42.009738922119, 324.21585083008
RegisterNUICallback("concessvoitureCBHeliwave", function(data, cb)
    --print("data", json.encode(data))
    if previewVeh.entity then
        DeleteEntity(previewVeh.entity)
    end
    if not data.price then return end
    local camCoord = data.kind == 1 and vector3(-862.42535400391, -1396.5495605469, 3.6923578381538) or vector3(-1249.2237548828, -3382.8793945313, 22.05516242981)
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
	TriggerEvent("sw:allowfrrr", 1)
    SetCamActive(cam, 1)
    SetCamCoord(cam, camCoord)
    SetCamFov(cam, 30.0)
    PointCamAtCoord(cam, data.kind == 1 and vector4(-856.27, -1420.55, 1.02, 350.0) or heliwave.catalogue_posHeliwave[usedCatalog].previewPosAero)
    RenderScriptCams(true, 0, 3000, 1, 0)   
    FreezeEntityPosition(PlayerPedId(), true)
    if not alreadywaitingcar then
        TriggerEvent('persistent-vehicles/forget-vehicle', previewVeh.entity)
        DeleteEntity(previewVeh.entity)
        if GetGameTimer() - cooldownVeh > 1250 then
            if not DoesEntityExist(previewVeh.entity) then
                previewVeh.entity = nil
                previewActive = true
                print("data.kind", data.kind)
                local previewPos = data.kind == 1 and vector4(-856.27, -1420.55, 1.02, 350.0) or heliwave.catalogue_posHeliwave[usedCatalog].previewPosAero
                print("previewPos", previewPos)
                previewVeh.entity = vehicle.createLocal(data.name, previewPos, {plate = "VENTE"})
                cooldownVeh = GetGameTimer()
                SetFocusPosAndVel(previewPos)
                previewVeh.model = data.name
                SetVehicleEngineOn(previewVeh.entity, 1, 1, 0)
                PointCamAtEntity(cam, previewVeh.entity)
                if justOnTime == 0 then
                    justOnTime = 1
                    CreateThread(function()
                        while open do
                            Wait(1)
                            heading = GetEntityHeading(previewVeh.entity)
                            SetEntityHeading(previewVeh.entity, heading )
                        end
                    end)
                end
            else
                NetworkRequestControlOfEntity(previewVeh.entity)
                while not NetworkHasControlOfEntity(previewVeh.entity) do
                    Wait(1)
                end
                DeleteEntity(previewVeh.entity)
            end
        else
            alreadywaitingcar = true
            while GetGameTimer() - cooldownVeh < 1250 do 
                Wait(1)
                LoadingPrompt("Chargement du véhicule...", 2)
            end
            BusyspinnerOff()
            if not DoesEntityExist(previewVeh.entity) then
                previewVeh.entity = nil
                previewActive = true
                local previewPos = data.kind == 1 and vector4(-856.27, -1420.55, 1.02, 350.0) or heliwave.catalogue_posHeliwave[usedCatalog].previewPosAero
                previewVeh.entity = vehicle.createLocal(data.name, previewPos, {plate = "VENTE"})
                NewLoadSceneStartSphere(previewPos, 50.0, 0)
                StreamvolCreateSphere(previewPos, 50.0)
                SetFocusPosAndVel(previewPos)
                cooldownVeh = GetGameTimer()
                previewVeh.model = data.name
                SetVehicleEngineOn(previewVeh.entity, 1, 1, 0)
                SetVehicleDoorsLockedForAllPlayers(previewVeh.entity, 1)
                if justOnTime == 0 then
                    justOnTime = 1
                    CreateThread(function()
                        while open do
                            Wait(1)
                            heading = GetEntityHeading(previewVeh.entity)
                            SetEntityHeading(previewVeh.entity, heading )
                        end
                    end)
                end
            else
                NetworkRequestControlOfEntity(previewVeh.entity)
                while not NetworkHasControlOfEntity(previewVeh.entity) do
                    Wait(1)
                end
                DeleteEntity(previewVeh.entity)
            end
            alreadywaitingcar = false
        end
    end
end)

DataToSendConcess = {
    buttons= {
        { -- OK
            name= 'Premium',
            width= 'full',
            isPremium = true,
            --image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/concess/car.svg',
            --hoverStyle= 'fill-black stroke-black'
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Banner/Heliwave/bateau.webp",
            type = 'coverBackground',
            hoverStyle = 'stroke-black',
            kind = 1,
        },
        { -- OK
            name= 'Bateau',
            width= 'full',
            --image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/concess/sport.svg',
            --hoverStyle= 'fill-black stroke-black'
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Banner/Heliwave/yachts.webp",
            type = 'coverBackground',
            hoverStyle = 'stroke-black',
            kind = 1,
        },
        { -- OK
            name= 'Sous-marin',
            width= 'full',
            --image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/concess/compact.svg',
            --hoverStyle= 'fill-black stroke-black'
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Banner/Heliwave/sous-marins.webp",
            type = 'coverBackground',
            hoverStyle = 'stroke-black',
            kind = 1,
        },
        { -- OK
            name= 'Avion',
            width= 'full',
            --image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/concess/sport.svg',
            --hoverStyle= 'fill-black stroke-black'
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Banner/Heliwave/avion.webp",
            type = 'coverBackground',
            hoverStyle = 'stroke-black',
            kind = 2,
        },
        { -- OK
            name= 'Helicoptere',
            width= 'full',
            --image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/concess/sport.svg',
            --hoverStyle= 'fill-black stroke-black'
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Banner/Heliwave/helico.webp",
            type = 'coverBackground',
            hoverStyle = 'stroke-black',
            kind = 2,
        },
        { -- OK
            name= 'Dirigeable',
            width= 'full',
            --image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/concess/car.svg',
            --hoverStyle= 'fill-black stroke-black'
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Banner/Heliwave/helico.webp",
            type = 'coverBackground',
            hoverStyle = 'stroke-black',
            kind = 2,
        },
        { --OK
            name= 'Hydravion',
            width= 'full',
            --image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/concess/car.svg',
            --hoverStyle= 'fill-black stroke-black'
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Banner/Heliwave/avion.webp",
            type = 'coverBackground',
            hoverStyle = 'stroke-black',
            kind = 2,
        },
        { --OK
            name= 'ULM',
            width= 'full',
            --image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/concess/car.svg',
            --hoverStyle= 'fill-black stroke-black'
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Banner/Heliwave/avion.webp",
            type = 'coverBackground',
            hoverStyle = 'stroke-black',
            kind = 2,
        },
    },
    catalogue = {},
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
    headerIconName = 'VEHICULES',
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/heliwave.webp',
    callbackName = 'concessHeliwaveBUY',
    showTurnAroundButtons = false,
    disableSubmit = false
}

function OpenVehicleCatalogue(cataChoise)
    usedCatalog = cataChoise
    previewActive = false
    open = true
    forceHideRadar()
    DataToSendConcess.isUserPremium = p:getSubscription()
    heliwave.catalogue_posHeliwave[cataChoise].used = true
    if FirstCo == 0 then
        FirstCo = 1
        for k,v in pairs(heliwave.vehicle) do
            for j,x in pairs(heliwave.vehicle[k]) do
                if k == "Sport_Classic" then
                    nameCat = "Sport Classic"
                else
                    nameCat = k
                end

                local vehicleModel = x.name
                local vehicleName = GetDisplayNameFromVehicleModel(vehicleModel)
                local localizedName = GetLabelText(vehicleName)
                if k == "Premium" then 
                    table.insert(DataToSendConcess.catalogue, {
                        id = j,
                        label = localizedName,
                        name = x.name,
                        price = math.floor(x.price/1.5*2.3),
                        image = x.kind == 1 and "https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Bateau/"..x.name..".webp" or "https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Aerien/"..x.name..".webp",
                        ownCallbackName = 'concessvoitureCBHeliwave',
                        isPremium = true,
                        category = nameCat,
                        kind = x.kind
                    })
                else
                    table.insert(DataToSendConcess.catalogue, {
                        id = j,
                        label = localizedName,
                        name = x.name,
                        price = math.floor(x.price/1.5*2.3),
                        image = x.kind == 1 and "https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Bateau/"..x.name..".webp" or "https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Aerien/"..x.name..".webp",
                        ownCallbackName = 'concessvoitureCBHeliwave',
                        category = nameCat,
                        kind = x.kind
                    })
                end
            end
        end
    end
    TriggerServerEvent("core:changeCatalogueUsed", token, cataChoise, true, "heliwave")
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'MenuGrosCatalogue',
        data = DataToSendConcess
    }))
    CreateThread(function()
        while onMenu do
            Wait(1)
            Heading = GetEntityHeading(PlayerPedId())
            for i = 0, 255 do
                DisableControlAction(0, i, false)
            end
            if IsDisabledControlJustPressed(0, 322) or IsDisabledControlJustPressed(0, 177) or IsDisabledControlJustPressed(0, 200) or IsDisabledControlJustPressed(0, 202) then 	
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
            end
        end
    end)
end

CreateThread(function()
    while zone == nil do Wait(1) end

    for k, v in pairs(heliwave.catalogue_posHeliwave) do
        zone.addZone(
            "heliwave_catalogue" .. k, -- Nom
            vector3(v.pos) + vector3(0.0, 0.0, 1.0), -- Position
            "Appuyer sur ~INPUT_CONTEXT~ pour regarder le catalogue", -- Text afficher
            function() -- Action qui seras fait
                if TriggerServerCallback("core:catalogueIsUse", 'nord', k) then
                    -- ShowNotification("~r~Quelqu'un utilise déjà ce catalogue")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Quelqu'un utilise déjà le catalogue"
                    })

                    return
                else
                    usedCatalog = k
                    DisableIdleCamera(true)
                    OpenVehicleCatalogue(k)
                end
            end,
            false, -- Avoir un marker ou non
            25, -- Id / type du marker
            0.6, -- La taille
            { 51, 204, 255 }, -- RGB
            170,-- Alpha
            1.5,
            true,
            "bulleCatalogue"
        )
    end
end)

RegisterNetEvent("core:changeCatalogueUsedClient")
AddEventHandler("core:changeCatalogueUsedClient", function(index, status)
    if where == "nord" then
        heliwave.catalogue_posHeliwave[index].used = status
    end
end)