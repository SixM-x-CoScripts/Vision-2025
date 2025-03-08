--[[ local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local job = player:getJob()

local uwu_cafe_items = 
{
    header = "https://cdn.sacul.cloud/v2/vision-cdn/Maquette_Food/UwUCafe/header.webp",
    items = {
        {
            image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/water.webp",
            id = 0,
            prix = "50",
            name = "water",
            label = "Eau",
        },
        {
            image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/tapas.webp",
            prix = "70",
            id = 1,
            name = "tapas",
            label = "Tapas",
        },
        {
            image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/gps.webp",
            prix = "500",
            id = 2,
            name = "gps",
            label = "GPS",
        },
    }
}

local bahamas_items = 
{
    {
        image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/water.webp",
        id=0,
        prix="50",
        name = 'water'
    },
    {
        image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/tapas.webp",
        prix = '70',
        id = 1,
        name = 'tapas'
    },
    {
        image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/gps.webp",
        prix = '500',
        id = 2,
        name = 'gps'
    },
}

local yellow_jack_items = 
{
    {
        image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/water.webp",
        id=0,
        prix="50",
        name = 'water'
    },
    {
        image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/tapas.webp",
        prix = '70',
        id = 1,
        name = 'tapas'
    },
    {
        image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/gps.webp",
        prix = '500',
        id = 2,
        name = 'gps'
    },
}

local pops_diner_items = 
{
    {
        image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/water.webp",
        id=0,
        prix="50",
        name = 'water'
    },
    {
        image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/tapas.webp",
        prix = '70',
        id = 1,
        name = 'tapas'
    },
    {
        image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/gps.webp",
        prix = '500',
        id = 2,
        name = 'gps'
    },
}

local comrades_bar_items = 
{
    {
        image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/water.webp",
        id=0,
        prix="50",
        name = 'water'
    },
    {
        image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/tapas.webp",
        prix = '70',
        id = 1,
        name = 'tapas'
    },
    {
        image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/gps.webp",
        prix = '500',
        id = 2,
        name = 'gps'
    },
}

local burger_shot_items = 
{
    {
        image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/water.webp",
        id=0,
        prix="50",
        name = 'water'
    },
    {
        image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/tapas.webp",
        prix = '70',
        id = 1,
        name = 'tapas'
    },
    {
        image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/gps.webp",
        prix = '500',
        id = 2,
        name = 'gps'
    },
}

local le_miroir_items = 
{
    {
        image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/water.webp",
        id=0,
        prix="50",
        name = 'water'
    },
    {
        image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/tapas.webp",
        prix = '70',
        id = 1,
        name = 'tapas'
    },
    {
        image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/gps.webp",
        prix = '500',
        id = 2,
        name = 'gps'
    },
}

local bayview_lodge_items = 
{
    {
        image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/water.webp",
        id=0,
        prix="50",
        name = 'water'
    },
    {
        image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/tapas.webp",
        prix = '70',
        id = 1,
        name = 'tapas'
    },
    {
        image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/gps.webp",
        prix = '500',
        id = 2,
        name = 'gps'
    },
}

local restaurants = {
    {job = "uwu", pos = vector3(-590.302734375, -1058.8515625, 21.344200134277), items = uwu_cafe_items},
    {job = "bahamas_mamas", pos = vector3(-1402.7001953125, -598.50787353516, 30.319971084595), items = bahamas_items},
    {job = "yellow_jack", pos = vector3(0, 0, 0), items = yellow_jack_items},
    {job = "pops_diner", pos = vector3(0, 0, 0), items = pops_diner_items},
    {job = "comrades_bar", pos = vector3(0, 0, 0), items = comrades_bar_items},
    {job = "burger_shot", pos = vector3(-1198.8935546875, -902.60162353516, 12.974186897278), items = burger_shot_items},
    {job = "le_miroir", pos = vector3(0, 0, 0), items = le_miroir_items},
    {job = "bayview_lodge", pos = vector3(0, 0, 0), items = bayview_lodge_items},
}
function openFridge(v)
    FreezeEntityPosition(PlayerPedId(), true)
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'Maquette_food',
        data = v.items
    }));
end

RegisterNUICallback("Maquette_food_callback", function(data, cb)
    if p:pay(data.choiceUser.prix) then
        data.choiceUser.name = "saumon"
        TriggerSecurGiveEvent("core:addItemToInventory", token, data.choiceUser.name, 1, {})
        -- ShowNotification("Vous venez d'acheter un(e) "..data.choiceUser.name)

        -- New notif
        exports['vNotif']:createNotification({
            type = 'DOLLAR',
            duration = 5, -- In seconds, default:  4
            content = "Vous venez d'acheter ~s un(e) "..data.choiceUser.name
        })

    end
end)

RegisterNUICallback("focusOut", function (data, cb)
    TriggerScreenblurFadeOut(0.5)
    openRadarProperly()
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    FreezeEntityPosition(PlayerPedId(), false)
end)

CreateThread(function()
    while true do
        for k, v in pairs(restaurants) do
            if job ~= v.job then
                zone.addZone(
                    v.job,
                    v.pos.xyz,
                    "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le frigo",
                    function()
                        openFridge(v)
                    end,
                    false, -- Avoir un marker ou non
                    -1, -- Id / type du marker
                    0.6, -- La taille
                    { 0, 0, 0 }, -- RGB
                    0, -- Alpha
                    2.5 -- Interact dist
                )
            end
        end
        Wait(5000)
    end
end) ]]