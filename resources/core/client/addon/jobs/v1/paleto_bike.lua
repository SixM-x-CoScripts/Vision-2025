local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local items = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Skate/header.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    callbackName = 'bikeBuyPaleto',
    showTurnAroundButtons = false,
    elements = {
        {
            price = 150,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/VespucciBike/skate.webp',
            name="skate",
            label="Skateboard",
            ownCallbackName = 'bikePreviewPaleto',
        },
        {
            price = 1500,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/VespucciBike/surf.webp',
            name="surfboard",
            label="Planche de surf",
            ownCallbackName = 'bikePreviewPaleto',
        },    
        {
            price = 300,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/VespucciBike/Cruiser.webp',
            name="cruiser",
            label="Cruiser",
            ownCallbackName = 'bikePreviewPaleto',
        },
        {
            price = 300,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/VespucciBike/BMX.webp',
            name="bmx",
            label="BMX",
            ownCallbackName = 'bikePreviewPaleto',
        },
        {
            price = 340,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/VespucciBike/Fixter.webp',
            name="fixter",
            label="Fixter",
            ownCallbackName = 'bikePreviewPaleto',
        },
        {
            price = 450,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/VespucciBike/Scorcher.webp',
            name="scorcher",
            label="Scorcher",
            ownCallbackName = 'bikePreviewPaleto',
        },
        {
            price = 600,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/VespucciBike/Tribike.webp',
            name="tribike",
            label="Tri-Cycles",
            ownCallbackName = 'bikePreviewPaleto',
        },
        {
            price = 555,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/VespucciBike/Tribike2.webp',
            name="tribike2",
            label="Tri-Cycles Endurex",
            ownCallbackName = 'bikePreviewPaleto',
        },
        {
            price = 525,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/VespucciBike/Tribike3.webp',
            name="tribike3",
            label="Tri-Cycles Whippet",
            ownCallbackName = 'bikePreviewPaleto',
        },
    }
}

local pedCoords = vector4(-772.2998046875, 5596.2060546875, 32.485694885254, 0)
local previewPosBike = vector4(-773.64093017578, 5590.9560546875, 32.485694885254, 0)
InsideStoreVsBike = false

function openPaletoBikeStore(ped)
    InsideStoreVsBike = true
    playerCoords = GetEntityCoords(PlayerPedId())
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamActive(cam, 1)
    SetCamCoord(cam, -777.35, 5592.35, 33.6)
    SetCamFov(cam, 30.0)
    PointCamAtCoord(cam, previewPosBike.x, previewPosBike.y, previewPosBike.z + 1.0)
    RenderScriptCams(true, 0, 3000, 1, 0)   
    FreezeEntityPosition(PlayerPedId(), true)
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'MenuCatalogueAchat',
        data = items
    }));
end

RegisterNUICallback("bikeBuyPaleto", function(data, cb)
    if p:pay(data.price) then
        if data.name == "surfboard" or data.name == "skate" then
            TriggerSecurGiveEvent("core:addItemToInventory", token, data.name, 1, {})
        else

            local props = vehicle.getProps(data.name)

            TriggerSecurGiveEvent("core:addItemToInventory", token, "bike", 1, {
                renamed = GetLabelText(data.name),
                name = data.name,
                plate = "AFG2D5",
                props = props
            })
        end
        -- ShowNotification("Vous venez d'acheter un(e) "..data.name)

        -- New notif
        exports['vNotif']:createNotification({
            type = 'DOLLAR',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous venez d'acheter ~s un(e) "..data.name
        })

    end
end)

local previewVeh
local previewModel
RegisterNUICallback("bikePreviewPaleto", function(data, cb)
    if data.name == "skate" then
        if previewVeh ~= nil then
            TriggerEvent('persistent-vehicles/forget-vehicle', previewVeh)
            DeleteEntity(previewVeh)
        end
        if not DoesEntityExist(previewVeh) then
            TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
            previewVeh = nil
            previewVeh = entity:CreateObject("p_defilied_ragdoll_01_s", previewPosBike)
            previewVeh = previewVeh.id
            previewModel = "p_defilied_ragdoll_01_s"
            FreezeEntityPosition(previewVeh, true)
        end
    else
        if previewModel == nil or previewModel ~= data.name then
            if previewVeh ~= nil then
                TriggerEvent('persistent-vehicles/forget-vehicle', previewVeh)
                DeleteEntity(previewVeh)
            end
            if not DoesEntityExist(previewVeh) then
                previewVeh = nil
                previewVeh = vehicle.createLocal(data.name, previewPosBike,
                    { plate = "VENTE" })
                previewModel = data.name
                FreezeEntityPosition(previewVeh, true)
                SetVehicleEngineOn(previewVeh, 1, 1, 0)
                SetVehicleDoorsLockedForAllPlayers(previewVeh, 1)
            end
        end
    end
end)

RegisterNUICallback("focusOut", function (data, cb)
    if InsideStoreVsBike then
        InsideStoreVsBike = false
        TriggerScreenblurFadeOut(0.5)
        openRadarProperly()
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        FreezeEntityPosition(PlayerPedId(), false)
        TriggerEvent('persistent-vehicles/forget-vehicle', previewVeh)
        DeleteEntity(previewVeh)
    end
end)


CreateThread(function()
    while p == nil do Wait(1000) end
        local ped = entity:CreatePedLocal("a_m_y_roadcyc_01", pedCoords.xyz, pedCoords.w)
        ped:setFreeze(true)
        SetEntityInvincible(ped.id, true)
        SetEntityAsMissionEntity(ped.id, 0, 0)
        SetBlockingOfNonTemporaryEvents(ped.id, true)
        zone.addZone("vespuccipaleto",
            pedCoords.xyz + vector3(0.0, 0.0, 2.0),
            "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le magasin",
            function()
                openPaletoBikeStore(ped.id)
            end, false,
            27,
            1.5,
            { 255, 255, 255 },
            170,
            1.5,
            true,
            "bulleVehicule"
        )
end)