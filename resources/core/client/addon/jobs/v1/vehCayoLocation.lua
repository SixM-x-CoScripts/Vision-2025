local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local itemsvehcayo = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_location.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
    headerIconName = 'LOCATION',
    callbackName = 'BuyVehCayoLocation',
    showTurnAroundButtons = false,
    elements = {
        {
            price = 400,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/LocationCayo/Vehicule/rebel.webp",
            name = "rebel",
            label = "Rebel - 400$",
        },
        {
            price = 400,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/LocationCayo/Vehicule/enduro.webp",
            name = "enduro",
            label = "Enduro Mk2 - 400$",
        },
        {
            price = 400,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/LocationCayo/Vehicule/verus.webp",
            name = "verus",
            label = "Verus - 400$",
        },
    }
}

local table = {
    CAYOPERICOVEHICULES = {
        vector4(4512.375, -4521.31640625, 3.1711921691895, 19.598257064819),
    },
}

local points = { -- POINTS DES PNJ
    ['CAYOPERICOVEHICULES']     = vector3(4517.419921875, -4514.7114257813, 3.5372529029846),
}

local pedCoords = {
    {pos = vector4(4517.419921875, -4514.7114257813, 3.5372529029846, 76.84888458252)},
}

local CAYOPERICOVEHICULES = vector4(4517.419921875, -4514.7114257813, 3.5372529029846, 76.84888458252)

local requiredDistance = 10 --Meters
InsideStoreLocCayoVeh = false

function openLocationMenuCayoVeh(ped)
    InsideStoreLocCayoVeh = true
    local playerPos = GetEntityCoords(PlayerPedId())

    local shortestDistance = math.huge

    for name,coords in pairs(points) do
        playerPos = GetEntityCoords(PlayerPedId())
        local distance = #(playerPos - coords)
        if distance < shortestDistance then
            shortestDistance = distance
        end
        if distance <= requiredDistance then

            playerCoords = GetEntityCoords(PlayerPedId())
            --cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
            --SetCamActive(cam, 1)
            --SetCamCoord(cam, playerCoords.x , playerCoords.y, playerCoords.z + 0.7)
            --SetCamFov(cam, 36.0)
            --PointCamAtCoord(cam, points[name].x, points[name].y, points[name].z + 1.5)
            --RenderScriptCams(true, 0, 3000, 1, 0)   
            FreezeEntityPosition(PlayerPedId(), true)
            SendNuiMessage(json.encode({
                type = 'openWebview',
                name = 'MenuCatalogueAchat',
                data = itemsvehcayo
            }));
        else 
        end

    end
end

RegisterNUICallback("BuyVehCayoLocation", function(data, cb)
    vehs = nil
    local playerPos = GetEntityCoords(PlayerPedId())
    local shortestDistance = math.huge
   
    for name,coords in pairs(points) do
        playerPos = GetEntityCoords(PlayerPedId())
        local distance = #(playerPos - coords)
        if distance < shortestDistance then
            shortestDistance = distance
        end
        if distance <= requiredDistance then
            for k, v in pairs(table[name]) do
                if vehicle.IsSpawnPointClear(vector3(v.x, v.y, v.z), 3.0) then
                    if p:pay(data.price) then
        
                        exports['vNotif']:createNotification({
                            type = 'DOLLAR',
                            -- duration = 5, -- In seconds, default:  4
                            content = "Vous venez de louer ~s un "..data.name
                        })
        
                        vehs = vehicle.create(data.name, vector4(v), {})
                        TaskWarpPedIntoVehicle(PlayerPedId(), vehs, -1)
                        SetVehicleNumberPlateText(vehs, "LOCAT" .. math.random(111, 999))
                        local plate = vehicle.getProps(vehs).plate
                        table.insert(StoredVehsLocation, plate)
                        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
                        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), nil)
                        --createKeys(plate, model)
                        SendNuiMessage(json.encode({
                            type = 'closeWebview',
                        }))
        
                        return
                    end
                else
                    -- ShowNotification("Il n'y a pas de place pour le véhicule")
        
                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Il n'y a ~s pas de place ~c pour l'avion"
                    })
                end
            end
        end
    end
end)

RegisterNUICallback("focusOut", function (data, cb)
    if InsideStoreLocCayoVeh then
        InsideStoreLocCayoVeh = false
        TriggerScreenblurFadeOut(0.5)
        openRadarProperly()
        --RenderScriptCams(false, false, 0, 1, 0)
        --DestroyCam(cam, false)
        FreezeEntityPosition(PlayerPedId(), false)
    end
end)

local peds = {}

CreateThread(function()

    while p == nil do Wait(1) end

    for k, v in pairs(pedCoords) do
        peds[k] = entity:CreatePedLocal("g_m_m_armlieut_01", v.pos.xyz, v.pos.w)
        peds[k]:setFreeze(true)
        SetEntityInvincible(peds[k].id, true)
        SetEntityAsMissionEntity(peds[k].id, 0, 0)
        SetBlockingOfNonTemporaryEvents(peds[k].id, true)
        zone.addZone( "VehCayoLocation" .. k,
            v.pos.xyz,
            "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les catalogues",
            function()
                openLocationMenuCayoVeh(peds[k].id) --TODO: fini le menu society
            end,
            false, -- Avoir un marker ou non
            -1, -- Id / type du marker
            0.6, -- La taille
            { 0, 0, 0 }, -- RGB
            0, -- Alpha
            2.5
        )
        local blip = AddBlipForCoord(v.pos.xyz)
        SetBlipSprite(blip, 225)
        SetBlipColour(blip, 2)
        SetBlipScale(blip, 0.70)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Location de véhicules")
        EndTextCommandSetBlipName(blip)
    end
--[[     while true do
        for k, v in pairs(pedCoords) do
            peds[k] = entity:CreatePedLocal("ig_thornton", v.pos.xyz, v.pos.w)
            peds[k]:setFreeze(true)
            SetEntityInvincible(peds[k].id, true)
            SetEntityAsMissionEntity(peds[k].id, 0, 0)
            SetBlockingOfNonTemporaryEvents(peds[k].id, true)
            zone.addZone( "VehCayoLocation" .. k,
                v.pos.xyz,
                "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les catalogues",
                function()
                    openLocationMenuCayoVeh(peds[k].id) --TODO: fini le menu society
                end,
                false, -- Avoir un marker ou non
                -1, -- Id / type du marker
                0.6, -- La taille
                { 0, 0, 0 }, -- RGB
                0, -- Alpha
                2.5
            )
        end
        Wait(5000)
    end

        ped = entity:CreatePedLocal("ig_thornton", pedCoords.xyz, pedCoords.w)
        ped:setFreeze(true)
        SetEntityInvincible(ped.id, true)
        SetEntityAsMissionEntity(ped.id, 0, 0)
        SetBlockingOfNonTemporaryEvents(ped.id, true)
        zone.addZone("VehCayoLocation",
            pedCoords.xyz,
            "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les locations",
            function()
                openLocationMenuCayoVeh(ped.id)
            end,
            false, -- Avoir un marker ou non
            -1, -- Id / type du marker
            0.6, -- La taille
            { 0, 0, 0 }, -- RGB
            0, -- Alpha
            2.5
        )
    end ]]
end)