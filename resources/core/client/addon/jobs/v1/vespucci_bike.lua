local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local items = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Skate/header.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    callbackName = 'bikeBuyVespucci',
    showTurnAroundButtons = false,
    elements = {
        {
            price = 150,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/VespucciBike/skate.webp',
            name="skate",
            label="Skateboard",
            ownCallbackName = 'bikePreviewVespucci',
        },
        {
            price = 1500,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/VespucciBike/surf.webp',
            name="surfboard",
            label="Planche de surf",
            ownCallbackName = 'bikePreviewVespucci',
        },    
        {
            price = 300,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/VespucciBike/Cruiser.webp',
            name="cruiser",
            label="Cruiser",
            ownCallbackName = 'bikePreviewVespucci',
        },
        {
            price = 300,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/VespucciBike/BMX.webp',
            name="bmx",
            label="BMX",
            ownCallbackName = 'bikePreviewVespucci',
        },
        {
            price = 340,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/VespucciBike/Fixter.webp',
            name="fixter",
            label="Fixter",
            ownCallbackName = 'bikePreviewVespucci',
        },
        {
            price = 450,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/VespucciBike/Scorcher.webp',
            name="scorcher",
            label="Scorcher",
            ownCallbackName = 'bikePreviewVespucci',
        },
        {
            price = 600,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/VespucciBike/Tribike.webp',
            name="tribike",
            label="Tri-Cycles",
            ownCallbackName = 'bikePreviewVespucci',
        },
        {
            price = 555,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/VespucciBike/Tribike2.webp',
            name="tribike2",
            label="Tri-Cycles Endurex",
            ownCallbackName = 'bikePreviewVespucci',
        },
        {
            price = 525,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/VespucciBike/Tribike3.webp',
            name="tribike3",
            label="Tri-Cycles Whippet",
            ownCallbackName = 'bikePreviewVespucci',
        },
    }
}

local pedCoords = vector4(-1319.1069335938, -1521.2178955078, 3.4247465133667, 176.52615356445)
local previewPosBike = vector4(-1318.068359375, -1515.7208251953, 3.424747467041, 23.581296920776)
local insideVesBikeStore = false

function openVespucciBikeStore(ped)
    insideVesBikeStore = true
    playerCoords = GetEntityCoords(PlayerPedId())
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamActive(cam, 1)
    SetCamCoord(cam, -1323.3192138672, -1519.2775878906, 4.4367489814758)
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

RegisterNUICallback("bikeBuyVespucci", function(data, cb)
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
RegisterNUICallback("bikePreviewVespucci", function(data, cb)
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
    if insideVesBikeStore then
        insideVesBikeStore = false
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
    while p == nil do Wait(1) end
    local ped = entity:CreatePedLocal("a_m_y_roadcyc_01", pedCoords.xyz, pedCoords.w)
    ped:setFreeze(true)
    SetEntityInvincible(ped.id, true)
    SetEntityAsMissionEntity(ped.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped.id, true)
    zone.addZone("vespucciBhe",
        pedCoords.xyz + vector3(0.0, 0.0, 1.0),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le magasin",
        function()
            openVespucciBikeStore(ped.id)
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
end)