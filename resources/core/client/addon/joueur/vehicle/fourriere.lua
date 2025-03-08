local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local fourriereOpen = false
local actuel = nil
local stock = nil
local amount = 200
local fourrieres = {
    {
        coords = vector4(-191.85945129395, -1162.5910644531, 22.671405792236, 89.124092102051),
        spawnCar = {
            vector4(-197.67306518555, -1174.9251708984, 22.795925140381, 200.740264892578),
            vector4(-194.36993408203, -1174.9923095703, 22.795751571655, 198.195869445801),
            vector4(-190.77606201172, -1174.8872070313, 22.796464920044, 198.441762924194),
            vector4(-187.35966491699, -1174.7669677734, 22.79584312439, 199.544822692871),
            vector4(-183.85089111328, -1174.5499267578, 22.797420501709, 199.068328857422),
            vector4(-204.58918762207, -1166.451171875, 22.797485351563, 1.15173339844),
            vector4(-151.79689025879, -1170.0504150391, 23.52161026001, 89.25259399414),
            vector4(-151.92556762695, -1166.6984863281, 23.522134780884, 89.74127197266),
            vector4(-147.54244995117, -1162.6472167969, 23.5218334198, 358.62031555176),
            vector4(-144.21099853516, -1163.2287597656, 23.52158164978, 0.10087585449),
            vector4(-139.20890808105, -1163.3782958984, 23.522674560547, 0.99736022949)
        }
    }
}

local data_ui = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Fourriere/header.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
    headerIconName = 'FOURRIERE',
    callbackName = 'fourriere_callback_ls',
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
    Wait(250)

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
                        price = (GetFourriereServices() <= 0 and amount) or (GetFourriereServices() > 0 and 2500),
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
        fourriereOpen = false
        TriggerScreenblurFadeOut(0.5)
        openRadarProperly()
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        FreezeEntityPosition(PlayerPedId(), false)
    end
end)

RegisterNUICallback("fourriere_callback_ls", function(data, cb)
    tableSize = getTableSize(fourrieres[actuel].spawnCar)
    count = 0
    if data.category == "Entreprise" then                    
        if not TriggerServerEvent("core:paySocietyPounder", amount, p:getJob()) then
            for key, value in pairs(fourrieres[actuel].spawnCar) do
                count = count + 1
                if vehicle.IsSpawnPointClear(value.xyz, 3.0) then
                    local vehprops = TriggerServerCallback("core:getVehProps", stock[data.id].currentPlate)
                    local veh = vehicle.create(stock[data.id].name, value, vehprops, true)
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
        if (GetFourriereServices() <= 0 and p:pay(amount)) or (GetFourriereServices() > 0 and ChoiceInput("Un mécano est ouvert, souhaitez vous payer 2500$ pour sortir votre véhicule ?")) then
            for key, value in pairs(fourrieres[actuel].spawnCar) do
                count = count + 1
                if vehicle.IsSpawnPointClear(value.xyz, 3.0) then
                    local vehprops = TriggerServerCallback("core:getVehProps", stock[data.id].currentPlate)
                    local veh = vehicle.create(stock[data.id].name, value, vehprops, true)
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
            "fourrière_ls" .. k, -- Nom
            v.coords.xyz + vector3(0.0, 0.0, 2.0), -- Position
            "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir la fourrière", -- Text affiché
            function()
                actuel = k
                OpenFourriere(peds[k].id)
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

function GetFourriereServices()
    return tonumber((GlobalState['serviceCount_bennys'] or 0) + (GlobalState['serviceCount_sunshine'] or 0) + (GlobalState['serviceCount_hayes'] or 0) + (GlobalState['serviceCount_beekers'] or 0) + (GlobalState['serviceCount_ocean'] or 0))
end