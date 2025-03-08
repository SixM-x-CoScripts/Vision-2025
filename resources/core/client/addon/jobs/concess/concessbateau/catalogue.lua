BateauCatalogue = {
    { label = "Dinghy 4P", name = "dinghy", price = 75000 },
    { label = "Bateau Peche", name = "tug", price = 50000 },
    { label = "Avisa", name = "avisa", price = 175000 },
    { label = "Dinghy 2P", name = "dinghy2", price = 45000 },
    { label = "Jetmax", name = "jetmax", price = 95000 },
    { label = "Longfin", name = "longfin", price = 150000 },
    { label = "Marquis", name = "marquis", price = 285000 },
    { label = "Seashark", name = "seashark", price = 25000 },
    { label = "Speeder", name = "speeder", price = 125000 },
    { label = "Squalo", name = "squalo", price = 105000 },
    { label = "Suntrap", name = "suntrap", price = 55000 },
    { label = "Toro", name = "toro", price = 180000 },
    { label = "Toro Yatch", name = "toro2", price = 195000 },
    { label = "Tropic", name = "tropic", price = 40000 },
}


local open = false
local used = false
local previewPos = vector4(-715.96783447266, -1348.1307373047, 0.06020431518555, 140.65835571289)
local camPos = vector3(-712.92797851563, -1334.8035888672, 4.5998101234436)
local previewVeh
local previewModel
local main = RageUI.CreateMenu("", "Gestion", 0.0, 0.0, "root_cause", "shopui_title_premiumdeluxe")
local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

RegisterNUICallback("focusOut", function(data, cb)
    if open then
        if previewVeh ~= nil then
            TriggerEvent('persistent-vehicles/forget-vehicle', previewVeh)
            DeleteEntity(previewVeh)
        end
        previewVeh = nil
        Cam.render("nwar", false, true, 2000)
        Wait(2000)
        Cam.delete("nwar")
        used = TriggerServerCallback("core:EntrepriseCatalogueState", false)
        TriggerEvent("sw:allowfrrr", 0)
    end
end)

function OpenCatalogueBoatMenu()
    if open then
        TriggerEvent("sw:allowfrrr", 0)
        open = false
        return
    else
        TriggerEvent("sw:allowfrrr", 1)
        open = true
        RageUI.Visible(main, true)
        used = TriggerServerCallback("core:EntrepriseCatalogueState", true)
        Cam.create("nwar")
        Cam.setPos("nwar", camPos)
        Cam.lookAtCoords("nwar", vector3(-715.96783447266, -1348.1307373047, 0.76020431518555))
        Cam.render("nwar", true, true, 2000)
        --[[CreateThread(function()
            while open do
                RageUI.IsVisible(main, function()
                    for k, v in pairs(BateauCatalogue) do
                        RageUI.Button(v.label, false, { RightLabel = "~g~" .. v.price .. "$" }, true, {
                            onActive = function()
                                if previewModel == nil or previewModel ~= v.name then
                                    if previewVeh ~= nil then
                                        TriggerEvent('persistent-vehicles/forget-vehicle', previewVeh)
                                        DeleteEntity(previewVeh)
                                    end
                                    if not DoesEntityExist(previewVeh) then
                                        previewVeh = nil
                                        previewVeh = vehicle.create(v.name, previewPos,
                                            { plate = "VENTE" })
                                        previewModel = v.name
                                        Wait(200)
                                        FreezeEntityPosition(previewVeh, true)
                                        SetVehicleEngineOn(previewVeh, 1, 1, 0)
                                        SetVehicleDoorsLockedForAllPlayers(previewVeh, 1)
                                        SetVehicleLivery(previewVeh, v.liveries)
                                    end
                                end
                            end
                        })
                    end
                end)
                Wait(1)
            end
        end)]]
        local listVeh = {
            headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_pdm.webp',
            headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
            headerIconName = 'VEHICULES',
            callbackName = 'vehMenuAchat',
            elements = {}
        }
    
        for k, v in pairs(BateauCatalogue) do
            table.insert(listVeh.elements, {
                id = k, 
                image = "https://cdn.sacul.cloud/v2/vision-cdn/concessbateau/" .. v.name .. ".webp",
                label = v.label,
                name = v.name,
                price = v.price
            })
        end
        
        function OpenGestionBoatMenu()
            if open then
                open = false
            else
                open = true
                SendNuiMessage(json.encode({
                    type = 'openWebview',
                    name = 'MenuCatalogue',
                    data = listVeh
                }))
            end
        end
        
        RegisterNUICallback("vehMenuAchat", function (data, cb)
            if not DoesEntityExist(previewVeh) then
                if p:pay(data.price) then
                    TriggerServerEvent("core:boutique:buyBateau", data.name)
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous n'avez pas assez d'argent"
                    })
                end
            end
        end)

        OpenGestionBoatMenu()
    end
end

RegisterNetEvent("core:spawnbateauachat", function(model, plate, color)
    TriggerSWEvent("TREFSDFD5156FD", "VZEFDSF", 7000)
    local Coords = GetEntityCoords(PlayerPedId())
    local Heading = GetEntityHeading(PlayerPedId())
    local vec = previewPos
    local vehicle = vehicle.create(model, vec,
        {
            plate = plate
        })
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    SetEntityAsMissionEntity(vehicle, true, true)
    TriggerServerEvent("core:SetVehicleOut", string.upper(plate), VehToNet(vehicle), vehicle)
end)

-- -1317.7603759766, -1518.7332763672, 4.4247484207153

Citizen.CreateThread(function()
    while zone == nil do Wait(1) end

    zone.addZone(
        "boat_catalogue",
        vector3(-712.48699951172, -1298.6228027344, 5.1187734794617), -- Position
        "~INPUT_CONTEXT~ Catalogue", -- Text afficher
        function() -- Action qui seras fait
            used = TriggerServerCallback("core:GetUsed")
            if used then
                -- ShowNotification("~r~Quelqu'un utilise déjà le catalogue")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Quelqu'un utilise déjà le catalogue"
                })

                return
            else
                OpenCatalogueBoatMenu()
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

end)
