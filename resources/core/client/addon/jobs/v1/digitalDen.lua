local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local digitalden = false

local items = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Digital/header.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    callbackName = 'digitalDenBuy',
    showTurnAroundButtons = false,
    elements = {
        {
            price = 450,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Digital/img0.webp",
            name = "phone",
            label = "Téléphone - 450$",
        },
        {
            price = 300,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Digital/img1.webp",
            name = "gps",
            label = "GPS - 300$",
        },
        {
            price = 450,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Digital/img2.webp",
            name = "radio",
            label = "Radio - 450$",
        },
        {
            price = 400,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/tabletli.webp",
            name = "tabletli",
            label = "Tablette LifeInvader - 300$",
        },
        {
            price = 300,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/boombox.webp",
            name = "boombox",
            label = "Boombox - 300$",
        },
        --{
        --    price = 100,
        --    image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/laptop.webp",
        --    name =  "laptop",
        --    label = "Ordinateur - 20$",
        --},
    }
}

local pedCoords = vector4(-1208.14453125, -1501.9516601563, 3.373884677887, 128.97775268555)

function openDigitalDenStore(ped)
    local ltdDuty = (GlobalState['serviceCount_ltdsud'] or 0) + (GlobalState['serviceCount_ltdseoul'] or 0) + (GlobalState['serviceCount_ltdmirror'] or 0)
    if ltdDuty and ltdDuty < 1 then
        playerCoords = GetEntityCoords(PlayerPedId())
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamActive(cam, 1)
        SetCamCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + 0.7)
        SetCamFov(cam, 35.0)
        PointCamAtCoord(cam, pedCoords.x, pedCoords.y, pedCoords.z + 1.5)
        RenderScriptCams(true, 0, 3000, 1, 0)   
        FreezeEntityPosition(PlayerPedId(), true)
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogueAchat',
            data = items
        }));
    else
        local theJob = nil 
        if GlobalState['serviceCount_ltdsud'] and GlobalState['serviceCount_ltdsud'] > 0 then 
            theJob = jobs["ltdsud"].label
        elseif GlobalState['serviceCount_ltdseoul'] and GlobalState['serviceCount_ltdseoul'] > 0 then
            theJob = jobs["ltdseoul"].label
        elseif GlobalState['serviceCount_ltdmirror'] and GlobalState['serviceCount_ltdmirror'] > 0 then
            theJob = jobs["ltdmirror"].label
        end
        if theJob then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "~c Une personne du LTD est en service, allez voir le " .. theJob
            })
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "~c Une personne du LTD est en service, allez le voir"
            })
        end
    end
end


RegisterNUICallback("digitalDenBuy", function(data, cb)
    if p:pay(data.price) then
        TriggerSecurGiveEvent("core:addItemToInventory", token, data.name, 1, {})
        -- ShowNotification("Vous venez d'acheter un(e) "..data.name)

        -- New notif
        exports['vNotif']:createNotification({
            type = 'DOLLAR',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous venez d'acheter ~s un(e) "..data.name
        })

    end
end)

RegisterNUICallback("focusOut", function (data, cb)
    if digitalden then
        digitalden = false
        TriggerScreenblurFadeOut(0.5)
        openRadarProperly()
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        FreezeEntityPosition(PlayerPedId(), false)
        Bulle.show("digitalDen")
    end
end)

local ped = nil

CreateThread(function()
    ped = entity:CreatePedLocal("a_f_y_business_01", pedCoords.xyz, pedCoords.w)
    ped:setFreeze(true)
    SetEntityInvincible(ped.id, true)
    SetEntityAsMissionEntity(ped.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped.id, true)
    zone.addZone("digitalDen",
        vector3(pedCoords.x, pedCoords.y, pedCoords.z+1.95),
        "~INPUT_CONTEXT~ Magasin électronique",
        function()
            Bulle.hide("digitalDen")
            digitalden = true
            openDigitalDenStore(ped.id)
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        2.5,
        true,
        "bulleDigitalDen"
    )
end)