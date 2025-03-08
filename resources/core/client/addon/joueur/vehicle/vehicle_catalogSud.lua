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

CreateThread(function()    
    AddTextEntry("caracaran", "2022 Caracara")
    AddTextEntry("issi8s", "Weeny Issi Rally")
    AddTextEntry("argento2", "Argento 2")
    AddTextEntry("bati901", "Bati 901")
    AddTextEntry("dominatorgt", "Novaja Papka")
    AddTextEntry("gauntlets", "Gauntlets")
    AddTextEntry("flivver", "Vapid Flivver")
    AddTextEntry("doubled", "Obey DD Blitz")
    AddTextEntry("revolution", "Revolution")
    AddTextEntry("blistacr", "Blista CR")
    AddTextEntry("yougat", "Yougat")
    AddTextEntry("yougav12", "Yougat v12")
    AddTextEntry("estancia", "Ocelot Estancia")
    AddTextEntry("pointer01", "Declasse Pointer")
    AddTextEntry("huntleys", "Huntley S")

    -- YACHTS    
    AddTextEntry("catamaran", "Catamaran")
    AddTextEntry("yacht2", "Yacht")
    AddTextEntry("sr510", "SR 510")
    AddTextEntry("yaluxe", "Yaluxe")
end)

RegisterNetEvent("core:deleteVehCatalogue", function(netid)
    local entity = NetToVeh(netid)
    if DoesEntityExist(entity) then
        DeleteEntity(entity)
    end
end)

RegisterNUICallback("focusOut", function (data, cb)
    if open then
        open = false
        justOnTime = 0
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
        TriggerServerEvent("core:changeCatalogueUsed", token, usedCatalog, false, "sud")
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

local scaleform = nil
function InitializeCarStat(scaleform, price, vehName, speed, acce, brake, trac, manufactu)
	scaleform = RequestScaleformMovie(scaleform)
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end
    print("manufactu", manufactu)
    trac = trac/2
    speed, acce, brake = speed / 20, acce / 20, brake / 20
	print("speed, acce, brake, trac",speed, acce, brake, trac)
    trac = trac*100
	PushScaleformMovieFunction(scaleform, "SET_VEHICLE_INFOR_AND_STATS")
	PushScaleformMovieFunctionParameterString(vehName)
	PushScaleformMovieFunctionParameterString(price)
	PushScaleformMovieFunctionParameterString("MPCarHUD")
	PushScaleformMovieFunctionParameterString(GetLabelText(manufactu) or "Benefactor")
	PushScaleformMovieFunctionParameterString("Vitesse")
	PushScaleformMovieFunctionParameterString("Acceleration")
	PushScaleformMovieFunctionParameterString("Freinage")
	PushScaleformMovieFunctionParameterString("Traction")
	PushScaleformMovieFunctionParameterInt(speed or 100)
	PushScaleformMovieFunctionParameterInt(acce or 100)
	PushScaleformMovieFunctionParameterInt(brake or 100)
	PushScaleformMovieFunctionParameterInt(trac or 100)
	PopScaleformMovieFunctionVoid()
	return scaleform
end

RegisterNUICallback("concessvoitureCBSud", function(data, cb)
    if not alreadywaitingcar then
        if previewVeh.entity then 
            local ids = GetActivePlayers()
            for k,v in pairs(ids) do 
                ids[k] = GetPlayerServerId(v)
            end
            TriggerServerEvent("core:deleteVehCatalogue", token, ids, VehToNet(previewVeh.entity), GetPlayerServerId(PlayerId())) 
        end
        scaleform = nil
        TriggerEvent('persistent-vehicles/forget-vehicle', previewVeh.entity)
        DeleteEntity(previewVeh.entity)
        if GetGameTimer() - cooldownVeh > 1250 then
            if not DoesEntityExist(previewVeh.entity) then
                TriggerSWEvent("TREFSDFD5156FD", "VZEFDSF", 5000)
                previewVeh.entity = nil
                previewActive = true
                previewVeh.entity = vehicle.create(data.name, concessSud.catalogue_posSud[usedCatalog].previewPos,{plate = "VENTE"})
                cooldownVeh = GetGameTimer()
                previewVeh.model = data.name
                FreezeEntityPosition(previewVeh.entity, true)
                SetVehicleEngineOn(previewVeh.entity, 1, 1, 0)
                SetVehicleDoorsLockedForAllPlayers(previewVeh.entity, 1)
                local topspeed = math.ceil(GetVehicleHandlingFloat(previewVeh.entity, 'CHandlingData', 'fInitialDriveMaxFlatVel') / 2)
                local handling = math.ceil(GetVehicleHandlingFloat(previewVeh.entity, 'CHandlingData', 'fSteeringLock') * 2)
                local braking = math.ceil(GetVehicleHandlingFloat(previewVeh.entity, 'CHandlingData', 'fBrakeForce') * 100)
                local accel = math.ceil(GetVehicleHandlingFloat(previewVeh.entity, 'CHandlingData', 'fInitialDriveForce') * 100) 
                scaleform = InitializeCarStat("mp_car_stats_01", (data.price or "Gratuit lol") .. "$", data.label, topspeed, accel, braking, GetVehicleModelMaxTraction(GetHashKey(data.name)), GetMakeNameFromVehicleModel(GetHashKey(data.name)))
                if justOnTime == 0 then
                    justOnTime = 1
                    CreateThread(function()
                        while open do
                            Wait(1)
                            heading = GetEntityHeading(previewVeh.entity)
                            SetEntityHeading(previewVeh.entity, heading )
                            local coord = GetEntityCoords(previewVeh.entity)
                            if (scaleform ~= nil) then
                                local x = 0.48
                                local y = -0.12
                                local width = 0.85
                                local height = width / 1.0
                                DrawScaleformMovie(scaleform, x, y, width, height)
                                --x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
                                --DrawScaleformMovie_3d(scaleform, x-1,y+1.8,z+7.0, 0.0, 180.0, 90.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0)
                            end
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
                TriggerSWEvent("TREFSDFD5156FD", "VZEFDSF", 5000)
                previewVeh.entity = nil
                previewActive = true
                previewVeh.entity = vehicle.create(data.name, concessSud.catalogue_posSud[usedCatalog].previewPos,{plate = "VENTE"})
                cooldownVeh = GetGameTimer()
                previewVeh.model = data.name
                FreezeEntityPosition(previewVeh.entity, true)
                SetVehicleEngineOn(previewVeh.entity, 1, 1, 0)
                SetVehicleDoorsLockedForAllPlayers(previewVeh.entity, 1)
                local topspeed = math.ceil(GetVehicleHandlingFloat(previewVeh.entity, 'CHandlingData', 'fInitialDriveMaxFlatVel') / 2)
                local handling = math.ceil(GetVehicleHandlingFloat(previewVeh.entity, 'CHandlingData', 'fSteeringLock') * 2)
                local braking = math.ceil(GetVehicleHandlingFloat(previewVeh.entity, 'CHandlingData', 'fBrakeForce') * 100)
                local accel = math.ceil(GetVehicleHandlingFloat(previewVeh.entity, 'CHandlingData', 'fInitialDriveForce') * 100) 
                scaleform = InitializeCarStat("mp_car_stats_01", (data.price or "Gratuit lol") .. "$", data.label, topspeed, accel, braking, GetVehicleModelMaxTraction(GetHashKey(data.name)), GetMakeNameFromVehicleModel(GetHashKey(data.name)))
                if justOnTime == 0 then
                    justOnTime = 1
                    CreateThread(function()
                        while open do
                            Wait(1)
                            heading = GetEntityHeading(previewVeh.entity)
                            SetEntityHeading(previewVeh.entity, heading )
                            if (scaleform ~= nil) then
                                local x = 0.48
                                local y = -0.12
                                local width = 0.85
                                local height = width / 1.0
                                DrawScaleformMovie(scaleform, x, y, width, height)
                            end
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
            --image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/concess/sport.svg',
            --hoverStyle= 'fill-black stroke-black'
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/11547698159453594501157083759292723311Rectangle326.webp",
            type = 'coverBackground',
            hoverStyle = 'stroke-black',
        },
        { -- OK
            name= 'Sport Classic',
            width= 'full',
            --image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/concess/sport.svg',
            --hoverStyle= 'fill-black stroke-black'
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951144389574408278068image.webp",
            type = 'coverBackground',
            hoverStyle = 'stroke-black',
        },
        { -- OK
            name= 'Compact',
            width= 'full',
            --image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/concess/car.svg',
            --hoverStyle= 'fill-black stroke-black'
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951144390927226507406image.webp",
            type = 'coverBackground',
            hoverStyle = 'stroke-black',
        },
        { -- OK
            name= 'Coupe',
            width= 'full',
            --image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/concess/compact.svg',
            --hoverStyle= 'fill-black stroke-black'
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951144389799558529135image.webp",
            type = 'coverBackground',
            hoverStyle = 'stroke-black',
        },
        { -- OK
            name= 'Sport',
            width= 'full',
            --image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/concess/sport.svg',
            --hoverStyle= 'fill-black stroke-black'
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951144390023525974066image.webp",
            type = 'coverBackground',
            hoverStyle = 'stroke-black',
        },
        { -- OK
            name= 'Super',
            width= 'full',
            --image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/concess/sport.svg',
            --hoverStyle= 'fill-black stroke-black'
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951144390096309714977image.webp",
            type = 'coverBackground',
            hoverStyle = 'stroke-black',
        },
        { -- OK
            name= 'Van',
            width= 'full',
            --image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/concess/car.svg',
            --hoverStyle= 'fill-black stroke-black'
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951144390192862613644image.webp",
            type = 'coverBackground',
            hoverStyle = 'stroke-black',
        },
        { --OK
            name= 'Tout-Terrain',
            width= 'full',
            --image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/concess/car.svg',
            --hoverStyle= 'fill-black stroke-black'
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951144390316049313842image.webp",
            type = 'coverBackground',
            hoverStyle = 'stroke-black',
        },
        { --OK
            name= 'SUV',
            width= 'full',
            --image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/concess/car.svg',
            --hoverStyle= 'fill-black stroke-black'
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951144390424010694767image.webp",
            type = 'coverBackground',
            hoverStyle = 'stroke-black',
        },
        {--OK
            name= 'Sedans',
            width= 'full',
            --image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/concess/car.svg',
            --hoverStyle= 'fill-black stroke-black'
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951144390527379329134image.webp",
            type = 'coverBackground',
            hoverStyle = 'stroke-black',
        },
        { --OK
            name= 'Muscles',
            width= 'full',
            --image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/concess/car.svg',
            --hoverStyle= 'fill-black stroke-black'
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951144389677026123928image.webp",
            type = 'coverBackground',
            hoverStyle = 'stroke-black',
        },
        {  --OK
            name= 'Moto',
            width= 'full',
            --image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/concess/bike.svg',
            --hoverStyle= 'fill-black stroke-black'
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951144391683073659052image.webp",
            type = 'coverBackground',
            hoverStyle = 'stroke-black',
        }
    },
    catalogue = {},
    headerIcon= 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
    headerIconName= 'Concessionnaire',
    headerImage= 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_lsmotors.webp',
    callbackName= 'MenuGrosCatalogueConcessSud',
    showTurnAroundButtons= false,
    disableSubmit= false
}

RegisterNetEvent("core:spawnnojobcarSud", function(model, plate, color)
    TriggerSWEvent("TREFSDFD5156FD", "VZEFDSF", 7000)
    local Coords = GetEntityCoords(PlayerPedId())
    local Heading = GetEntityHeading(PlayerPedId())
    local vec = vector4(-34.29, -1079.94, 25.69, 70.58)
    local vehicle = vehicle.create(model, vec,
        {
            plate = plate
        })
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    SetEntityAsMissionEntity(vehicle, true, true)
    TriggerServerEvent("core:SetVehicleOut", string.upper(plate), VehToNet(vehicle), vehicle)
    exports['vNotif']:createNotification({
        type = 'VERT',
        -- duration = 5, -- In seconds, default:  4
        content = "Vous avez reçu votre véhicule."
    })
end)

RegisterNetEvent("core:spawnnojobcarNord", function(model, plate, color)
    TriggerSWEvent("TREFSDFD5156FD", "VZEFDSF", 7000)
    local Coords = GetEntityCoords(PlayerPedId())
    local Heading = GetEntityHeading(PlayerPedId())
    local vec = vector4(-198.47758483887, 6243.7329101563, 30.495500564575, 222.24540710449)
    local vehicle = vehicle.create(model, vec,
        {
            plate = plate
        })
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    SetEntityAsMissionEntity(vehicle, true, true)
    TriggerServerEvent("core:SetVehicleOut", string.upper(plate), VehToNet(vehicle), vehicle)
    exports['vNotif']:createNotification({
        type = 'VERT',
        -- duration = 5, -- In seconds, default:  4
        content = "Vous avez reçu votre véhicule."
    })
end)

RegisterNetEvent("core:spawnpremiumcarSud")
AddEventHandler("core:spawnpremiumcarSud", function(model, plate, color)
    TriggerSWEvent("TREFSDFD5156FD", "VZEFDSF", 7000)
    local Coords = GetEntityCoords(PlayerPedId())
    local Heading = GetEntityHeading(PlayerPedId())
    local vec = vector4(-34.29, -1079.94, 25.69, 70.58)
    local vehicle = vehicle.create(model, vec,
        {
            plate = plate
        })
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    SetEntityAsMissionEntity(vehicle, true, true)
    TriggerServerEvent("core:SetVehicleOut", string.upper(plate), VehToNet(vehicle), vehicle)
end)
RegisterNetEvent("core:spawnpremiumcarNorth")
AddEventHandler("core:spawnpremiumcarNorth", function(model, plate, color)
    TriggerSWEvent("TREFSDFD5156FD", "VZEFDSF", 7000)
    local Coords = GetEntityCoords(PlayerPedId())
    local Heading = GetEntityHeading(PlayerPedId())
    local vec = vector4(-198.47758483887, 6243.7329101563, 30.495500564575, 222.24540710449)
    local vehicle = vehicle.create(model, vec,
        {
            plate = plate
        })
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    SetEntityAsMissionEntity(vehicle, true, true)
    TriggerServerEvent("core:SetVehicleOut", string.upper(plate), VehToNet(vehicle), vehicle)
end)

RegisterNUICallback("MenuGrosCatalogueConcessSud", function(data)
    if not data.button then
        if data.reset then return end
        if data.category == "Premium" then 
            local isInSouth = coordsIsInSouth(GetEntityCoords(PlayerPedId()))
            TriggerServerEvent("core:premium:buyCar", data, isInSouth and "sud" or "nord")
            closeUI()
        else
            --if TriggerServerCallback("core:getNumberOfDuty", token, 'cardealerSud') > 0 then
            if (GlobalState['serviceCount_cardealerSud'] or 0) > 0 then
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = 'Appelez un concessionnaire pour pouvoir acheter ce véhicule'
                })
            else
                if data.label and data.price then
                    closeUI()
                    Wait(200)
                    local confirmation = ChoiceInput("Shouhaitez vous vraiment acheter un(e) " .. data.label .. " pour " .. data.price .. "$ ?")
                    if confirmation == true then
                        if data.name == "ztype" or data.name == "gspeedster" or data.name == "emerus" or data.name == "hurricane" or data.name == "patriots" or data.name == "stafford" or data.name == "toros" or data.name == "rrocket" then 
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                -- duration = 5, -- In seconds, default:  4
                                content = 'Ce véhicule n\'est plus disponible à la vente.'
                            })
                        else
                            TriggerServerEvent("core:nojob:buyCar", data, "noJobSud")
                        end
                    end
                end
            end
        end
    end
end)

local function OpenVehicleCatalogue(cataChoise)
    previewActive = false
    open = true
    forceHideRadar()
    concessSud.catalogue_posSud[cataChoise].used = true
    if FirstCo == 0 then
        FirstCo = 1
        for k,v in pairs(concessSud.vehicle) do
            for j,x in pairs(concessSud.vehicle[k]) do
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
                        id= j,
                        label = localizedName,
                        name = x.name,
                        price = math.floor(x.price*1.15),
                        image= "https://cdn.sacul.cloud/v2/vision-cdn/concess/"..x.name..".webp",
                        ownCallbackName = 'concessvoitureCBSud',
                        isPremium = true,
                        category= nameCat
                    })
                else
                    table.insert(DataToSendConcess.catalogue, {
                        id= j,
                        label = localizedName,
                        name = x.name,
                        price = math.floor(x.price*1.15),
                        image= "https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Voiture/"..x.name..".webp",
                        ownCallbackName = 'concessvoitureCBSud',
                        category= nameCat
                    })
                end
            end
        end
    end
    TriggerServerEvent("core:changeCatalogueUsed", token, cataChoise, true, "sud")
    DataToSendConcess.isUserPremium = p:getSubscription()
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

    for k, v in pairs(concessSud.catalogue_posSud) do
        zone.addZone(
            "vehicle_shop_sud" .. k, -- Nom
            vector3(v.pos), -- Position
            "~INPUT_CONTEXT~ Catalogue", -- Text afficher
            function() -- Action qui seras fait
                if TriggerServerCallback("core:catalogueIsUse", 'sud', k) then
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
            "bulleVehicule"
        )
    end
end)

RegisterNetEvent("core:changeCatalogueUsedClient")
AddEventHandler("core:changeCatalogueUsedClient", function(index, status)
    if where == "sud" then
        concessSud.catalogue_posSud[index].used = status
    end
end)
