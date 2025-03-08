local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local fourriereOpen = false
local actuel = nil
local stock = nil
local amount = 100
local fourrieres = {
    {
        coords = vector4(1581.54, 3748.33, 33.76, 220.2),
        spawnCar = {
            vector4(1575.91, 3740.03, 33.27, 279.0),
        }
    }
}

local data_ui = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Fourriere/header.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
    headerIconName = 'FOURRIERE',
    callbackName = 'fourriere_callback_sandy',
    showTurnAroundButtons = false,
    elements = {}
}

function getTableSize(t)
    local count = 0
    for _, __ in pairs(t) do
        count = count + 1
    end
    return count
end


local function OpenFourriere(ped)
    fourriereOpen = true
    data_ui.elements = {}
    stock = TriggerServerCallback("core:GetVehiclesInPound")
    playerCrew = p:getCrew()

    if json.encode(stock) ~= "[]" or crewStock ~= nil then
        if json.encode(stock) ~= "[]" then
            for k, v in pairs(stock) do
                if v.job ~= nil then 
                    cat = "Entreprise"
                elseif v.vente ~= nil then
                    cat = "Crew"
                else
                    cat = "Personnel"
                end
                if v.stored == 2 then
                    table.insert(data_ui.elements, {
                        id = k,
                        price = amount,
                        image= "https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Voiture/"..v.name..".webp",
                        name=v.name,
                        label=v.name.." "..v.currentPlate,
                        category= cat,
                    })
                end
            end
        end

        playerCoords = GetEntityCoords(PlayerPedId())
        pedCoords = GetEntityCoords(ped)
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamActive(cam, 1)
        SetCamCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + 0.5)
        SetCamFov(cam, 50.0)
        PointCamAtCoord(cam, pedCoords.x, pedCoords.y, pedCoords.z + 0.5)
        RenderScriptCams(true, 0, 3000, 1, 0)   
        FreezeEntityPosition(PlayerPedId(), true)
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogueAchat',
            data = data_ui,
        }));
    else
        -- ShowNotification("Aucun véhicule dans la fourrière")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Aucun véhicule dans la fourrière"
        })

    end
end

RegisterNUICallback("focusOut", function (data, cb)
    if fourriereOpen then
        TriggerScreenblurFadeOut(0.5)
        openRadarProperly()
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        FreezeEntityPosition(PlayerPedId(), false)
        fourriereOpen = false
    end
end)

RegisterNUICallback("fourriere_callback_sandy", function(data, cb)
    tableSize = getTableSize(fourrieres[actuel].spawnCar)
    count = 0
    if data.category == "Entreprise" then                    
        if not TriggerServerEvent("core:paySocietyPounder", 100, p:getJob()) then
            for key, value in pairs(fourrieres[actuel].spawnCar) do
                count = count + 1
                if vehicle.IsSpawnPointClear(value.xyz, 3.0) then
                    local vehprops = TriggerServerCallback("core:getVehProps", stock[data.id].currentPlate)
                    local veh = vehicle.create(stock[data.id].name, value, vehprops)
                    TaskWarpPedIntoVehicle(p:ped(), veh, -1)
                    TriggerServerEvent("core:SetVehicleOut", string.upper(vehicle.getPlate(veh)), VehToNet(veh), veh)
                    SetVehicleFuelLevel(veh,
                    GetVehicleHandlingFloat(veh, "CHandlingData", "fPetrolTankVolume"))
                    SendNuiMessage(json.encode({
                        type = 'closeWebview'
                    }))
                    break
                else
                    if count == tableSize then
                        -- ShowNotification("~r~Le véhicule ne peut pas sortir")

                        -- New notif
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            -- duration = 5, -- In seconds, default:  4
                            content = "~s Le véhicule ne peut pas sortir"
                        })

                    end
                end
            end                       
        else 
            -- ShowNotification("Vous n'avez ~r~pas assez d'argent~s~")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous n'avez ~s pas assez d'argent"
            })

        end
    else                
        if p:pay(100) then
            for key, value in pairs(fourrieres[actuel].spawnCar) do
                count = count + 1
                if vehicle.IsSpawnPointClear(value.xyz, 3.0) then
                    local vehprops = TriggerServerCallback("core:getVehProps", stock[data.id].currentPlate)
                    local veh = vehicle.create(stock[data.id].name, value, vehprops)
                    TaskWarpPedIntoVehicle(p:ped(), veh, -1)
                    TriggerServerEvent("core:SetVehicleOut", string.upper(vehicle.getPlate(veh)), VehToNet(veh), veh)
                    SetVehicleFuelLevel(veh, GetVehicleHandlingFloat(veh, "CHandlingData", "fPetrolTankVolume"))
                    SendNuiMessage(json.encode({
                        type = 'closeWebview'
                    }))
                    break
                else
                    if count == tableSize then
                        -- ShowNotification("~r~Le véhicule ne peut pas sortir")

                        -- New notif
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            -- duration = 5, -- In seconds, default:  4
                            content = "~s Le véhicule ne peut pas sortir"
                        })

                    end
                end
            end                    
        else
            -- ShowNotification("Vous n'avez ~r~pas assez d'argent~s~")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous n'avez ~s pas assez d'argent"
            })

        end
    end
end)

local peds = {}

CreateThread(function()
    for k, v in pairs(fourrieres) do
        while zone == nil do Wait(1) end
        peds[k] = entity:CreatePedLocal("a_m_m_hillbilly_01", v.coords.xyz, v.coords.w)
        peds[k]:setFreeze(true)
        SetEntityInvincible(peds[k].id, true)
        SetEntityAsMissionEntity(peds[k].id, 0, 0)
        SetBlockingOfNonTemporaryEvents(peds[k].id, true)
        zone.addZone(
            "fourrière_sandy" .. k, -- Nom
            v.coords.xyz + vector3(0.0, 0.0, 2.0), -- Position
            "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir la fourrière", -- Text affiché
            function()
                local total = (GlobalState['serviceCount_sunshine'] or 0) + (GlobalState['serviceCount_hayes'] or 0) + (GlobalState['serviceCount_beekers'] or 0)
                if total > 0 then
                    -- ShowNotification("La fourrière est fermée")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s La fourrière est fermée"
                    })

                else
                    actuel = k
                    OpenFourriere(peds[k].id)
                end
            end,
            false, -- Avoir un marker ou non
            -1, -- Id / type du marker
            0.8, -- La taille
            { 235, 192, 15 }, -- RGB
            170, -- Alpha
            3, -- Interact Dist
            true,
            "bulleFourriere"
        )      
    end
end)
