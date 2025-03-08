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
        TriggerServerEvent("core:changeCatalogueUsed", token, usedCatalog, false, "nord")
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

RegisterNUICallback("concessvoitureCBNord", function(data, cb)
    if not alreadywaitingcar then
        if previewVeh.entity then 
            local ids = GetActivePlayers()
            for k,v in pairs(ids) do 
                ids[k] = GetPlayerServerId(v)
            end
            TriggerServerEvent("core:deleteVehCatalogue", token, ids, VehToNet(previewVeh.entity), GetPlayerServerId(PlayerId())) 
        end
        TriggerEvent('persistent-vehicles/forget-vehicle', previewVeh.entity)
        DeleteEntity(previewVeh.entity)
        if GetGameTimer() - cooldownVeh > 1250 then
            if not DoesEntityExist(previewVeh.entity) then
                TriggerSWEvent("TREFSDFD5156FD", "VZEFDSF", 5000)
                previewVeh.entity = nil
                previewActive = true
                previewVeh.entity = vehicle.create(data.name, concessNord.catalogue_posNord[usedCatalog].previewPos,{plate = "VENTE"})
                cooldownVeh = GetGameTimer()
                previewVeh.model = data.name
                FreezeEntityPosition(previewVeh.entity, true)
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
                previewVeh.entity = vehicle.create(data.name, concessNord.catalogue_posNord[usedCatalog].previewPos,{plate = "VENTE"})
                cooldownVeh = GetGameTimer()
                previewVeh.model = data.name
                FreezeEntityPosition(previewVeh.entity, true)
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
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951144389677026123928image.webp",
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
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951144390927226507406image.webp",
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
    headerIconName= 'VEHICULES',
    headerImage= 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_pdm.webp',
    callbackName= 'MenuGrosCatalogueConcess',
    showTurnAroundButtons= false,
    disableSubmit= false
}

RegisterNUICallback("MenuGrosCatalogueConcess", function(data)
    if data.category == "Premium" then 
        local isInSouth = coordsIsInSouth(GetEntityCoords(PlayerPedId()))
        TriggerServerEvent("core:premium:buyCar", data, isInSouth and "sud" or "nord")
        closeUI()
    else
        ---if TriggerServerCallback("core:getNumberOfDuty", token, 'cardealerNord') > 0 then
        if (GlobalState['serviceCount_cardealerNord'] or 0) > 0 then
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
                        TriggerServerEvent("core:nojob:buyCar", data, "noJobNord")
                    end
                end
            end
        end
    end
end)

RegisterNuiCallback("buyItem", function()
    if open then 
        
    end
end)

local function OpenVehicleCatalogue(cataChoise)
    previewActive = false
    open = true
    forceHideRadar()
    concessNord.catalogue_posNord[cataChoise].used = true
    if FirstCo == 0 then
        FirstCo = 1
        for k,v in pairs(concessNord.vehicle) do
            for j,x in pairs(concessNord.vehicle[k]) do
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
                        price = math.floor(x.price+x.price*0.15),
                        image= "https://cdn.sacul.cloud/v2/vision-cdn/concess/"..x.name..".webp",
                        ownCallbackName = 'concessvoitureCBNord',
                        isPremium = true,
                        category= nameCat
                    })
                else
                    table.insert(DataToSendConcess.catalogue, {
                        id= j,
                        label = localizedName,
                        name = x.name,
                        price = math.floor(x.price+x.price*0.15),
                        image= "https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Voiture/"..x.name..".webp",
                        ownCallbackName = 'concessvoitureCBNord',
                        category= nameCat
                    })
                end

            end
        end
    end
    TriggerServerEvent("core:changeCatalogueUsed", token, cataChoise, true, "nord")
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

    for k, v in pairs(concessNord.catalogue_posNord) do
        zone.addZone(
            "vehicle_shop_nord" .. k, -- Nom
            vector3(v.pos), -- Position
            "~INPUT_CONTEXT~ Catalogue", -- Text afficher
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
            "bulleVehicule"
        )
    end
end)

RegisterNetEvent("core:changeCatalogueUsedClient")
AddEventHandler("core:changeCatalogueUsedClient", function(index, statu)
    if where == "nord" then
        concessNord.catalogue_posNord[index].used = statu
    end
end)
