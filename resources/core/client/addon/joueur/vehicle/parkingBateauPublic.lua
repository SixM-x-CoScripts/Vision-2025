local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

Boats = {
    ["dinghy"],
    ["dinghy2"],
    ["dinghy3"],
    ["dinghy4"],
    ["jetmax"],
    ["marquis"],
    ["seashark"],
    ["seashark2"],
    ["seashark3"],
    ["speeder"],
    ["speeder2"],
    ["squalo"],
    ["submersible"],
    ["submersible2"],
    ["suntrap"],
    ["toro"],
    ["toro2"],
    ["tropic"],
    ["tropic2"],
    ["tug"],
    ["avisa"],
    ["dinghy5"],
    ["kosatka"],
    ["longfin"],
    ["patrolboat"],
    ["catamaran"],
    ["yacht2"],
    ["sr510"],
    ["yaluxe"],
}

local fourriereOpen = false
local actuel = nil
local stock = nil
local amount = 500
local parking = {
    {
        ped = vector4(-719.14587402344, -1327.4387207031, 0.59628856182098, 50.929458618164),
        -- Le joueur serra TP quand il aurra déposé le bateau
        posTP = vector3(-720.41656494141, -1326.2878417969, 0.59629046916962),
        enter = vector4(-721.46405029297, -1331.0955810547, 0.4750674962997, 231.88069152832),
        spawnCar = {
            vector4(-721.46405029297, -1331.0955810547, 0.4750674962997, 231.88069152832),
            vector4(-715.94049072266, -1321.8704833984, 0.4240889847279, 227.36370849609),
        },
        special = {
        }
    },
    {
        ped = vector4(4928.5522460938, -5173.873046875, 1.4523046016693, 243.2649230957),
        -- Le joueur serra TP quand il aurra déposé le bateau
        posTP = vector3(4930.3974609375, -5174.6123046875, 1.4722037315369),
        enter = vector4(4934.6713867188, -5171.046875, 1.94528013467789, 65.307014465332),
        spawnCar = {
            vector4(4934.6713867188, -5171.046875, 1.94528013467789, 65.307014465332),
            vector4(4930.1254882813, -5178.9243164063, 1.80864226818085, 66.648132324219),
            vector4(4936.73828125, -5164.8642578125, 1.95793104171753, 63.384567260742),
        },
        special = {
        }
    },
    {
        ped = vector4(-1604.3770751953, 5256.7270507813, 1.0741822719574, 25.43853187561),     
        -- Le joueur serra TP quand il aurra déposé le bateau
        posTP = vector3(-1605.0341796875, 5257.6123046875, 1.0798006057739),   
        enter = vector4(-1600.8881835938, 5258.9487304688, 1.77678024768829, 18.850746154785),
        spawnCar = {
            vector4(-1600.8881835938, 5258.9487304688, 1.77678024768829, 18.850746154785),
            vector4(-1597.9742431641, 5248.71875, -0.78642398118973, 21.30517578125),
            vector4(-1607.0418701172, 5271.443359375, -0.5113091468811, 19.222505569458),
        },
    },
    {
        ped = vector4(3859.5036621094, 4458.9409179688, 0.83488368988037, 90.371757507324),     
        -- Le joueur serra TP quand il aurra déposé le bateau
        posTP = vector3(3857.9206542969, 4459.099609375, 0.82483458518982),      
        enter = vector4(3855.9792480469, 4454.1416015625, 1.86699220538139, 270.59915161133),
        spawnCar = {
            vector4(3855.9792480469, 4454.1416015625, 0.86699220538139, 270.59915161133),
            vector4(3866.5422363281, 4454.2353515625, 0.88451144099236, 270.6032409668),
            vector4(3856.3706054688, 4447.3481445313, 0.89726305007935, 274.14013671875),
        },
    },
}

local data_ui = {
    garage = {},
    pound = {},
    isPremium = false
}

local function enterBateau(pos)
    if IsPedInAnyVehicle(p:ped(), false) then
        local veh = GetVehiclePedIsIn(p:ped(), false)
        local isOk = TriggerServerCallback('core:vehicle:setPublic', all_trim(GetVehicleNumberPlateText(veh)))
        if isOk == true then
            TriggerEvent('persistent-vehicles/forget-vehicle', veh)
            DeleteEntity(veh)
            Wait(50)
            SetEntityCoords(PlayerPedId(), pos)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s " .. isOk
            })
        end
    end
end

local function OpenFourriere(ped)
    data_ui.garage = {}
    data_ui.pound = {}
    stock = TriggerServerCallback("core:GetVehiclesParking")
    playerCrew = p:getCrew()
    data_ui.isPremium = p:getSubscription() >= 1 and true or false
    data_ui.garageType = "bateau"
    local max = data_ui.isPremium == true and 3 or 1
    if json.encode(stock) ~= "[]" or crewStock ~= nil then
        if json.encode(stock) ~= "[]" then
            for k, v in pairs(stock) do
                if Boats[string.lower(v.name)] then
                    if v.stored == 2 then
                        table.insert(data_ui.pound, {
                            id = k,
                            --price = amount,
                            image= "https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Bateau/"..v.name..".webp",
                            name=v.name,
                            label=v.name.." "..v.currentPlate,
                            category= "Fourriere",
                        })
                    elseif v.stored == 3 then
                        if max > 0 then
                            table.insert(data_ui.garage, {
                                id = k,
                                --price = amount,
                                image= "https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Bateau/"..v.name..".webp",
                                name=v.name,
                                label=v.name.." "..v.currentPlate,
                                category= "Garage public",
                            })
                            max = max - 1
                        end
                    end
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
        fourriereOpen = true
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'GaragePublique',
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

RegisterNUICallback("getVehicule", function(data, cb)
    if fourriereOpen then
        tableSize = getTableSize(parking[actuel].spawnCar)
        count = 0
        if data.tab == "garage" then
            if p:pay(0) then
                for key, value in pairs(parking[actuel].spawnCar) do
                    count = count + 1
                    if vehicle.IsSpawnPointClear(value.xyz, 3.0) then
                        local veh = vehicle.create(stock[data.veh.id].name, value, stock[data.veh.id].props, true)
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
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Le vehicule est en fourriere"
            })
        end
    end
end)

local peds = {}
local blips = {}

RegisterNUICallback("focusIn", function()
    SetNuiFocus(true, true)
end)

CreateThread(function()
    for k, v in pairs(parking) do
        while zone == nil do Wait(1) end
        peds[k] = entity:CreatePedLocal("mp_m_boatstaff_01", v.ped.xyz, v.ped.w)
        peds[k]:setFreeze(true)
        SetEntityInvincible(peds[k].id, true)
        SetEntityAsMissionEntity(peds[k].id, 0, 0)
        SetBlockingOfNonTemporaryEvents(peds[k].id, true)
        zone.addZone(
            "parking_bateau_public_ped" .. k, -- Nom
            v.ped.xyz + vector3(0.0, 0.0, 2.0), -- Position
            "~INPUT_CONTEXT~ Ouvrir le garage publique", -- Text affiché
            function()
                actuel = k
                OpenFourriere(peds[k].id)
            end,
            false, -- Avoir un marker ou non
            -1, -- Id / type du marker
            0.6, -- La taille
            { 0, 0, 0 }, -- RGB
            0, -- Alpha
            2.5,
            true,
            "bulleGarage"
        )
        zone.addZone(
            "parking_bateau_public_enter" .. k, -- Nom
            v.enter.xyz, -- Position
            "~INPUT_CONTEXT~ Garer votre bateau", -- Text affiché
            function()
                actuel = k
                enterBateau(v.posTP)
            end,
            false, -- Avoir un marker ou non
            25, -- Id / type du marker
            0.6, -- La taille
            { 51, 204, 255 }, -- RGB
            170,-- Alpha
            4.0,
            true,
            "bulleGarage"
        )
        blips[k] = AddBlipForCoord(v.ped.xyz)
        SetBlipSprite(blips[k], 427)
        SetBlipDisplay(blips[k], 4)
        SetBlipScale(blips[k], 0.8)
        SetBlipColour(blips[k], 63)
        SetBlipAsShortRange(blips[k], true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Garage bateau public")
        EndTextCommandSetBlipName(blips[k])
    end
end)
