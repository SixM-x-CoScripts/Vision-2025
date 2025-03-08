local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local fourriereOpen = false
local actuel = nil
local stock = nil
local amount = 500
local parking = {
    {
        ped = vector4(-281.28280639648, -887.86883544922, 30.318016052246, 77.3076171875),
        enter = vector4(-285.65646362305, -887.17260742188, 31.080623626709, 168.11770629883),
        spawnCar = {
            vector4(-292.81506347656, -886.07281494141, 30.080615997314, 171.02478027344),
            vector4(-296.349609375, -884.89074707031, 30.080615997314, 164.26420593262),
            vector4(-300.05487060547, -884.09771728516, 30.080615997314, 163.03523254395),
            vector4(-303.71389770508, -882.71142578125, 30.080615997314, 165.33633422852),
            vector4(-307.35684204102, -882.40264892578, 30.080615997314, 161.39405822754),
            vector4(-311.04418945313, -881.5244140625, 30.080615997314, 165.37184143066),
            vector4(-314.40914916992, -880.87237548828, 30.080615997314, 152.99195861816),
            vector4(-318.13250732422, -880.09814453125, 30.080617904663, 160.09783935547),
            vector4(-322.11962890625, -879.61657714844, 30.073844909668, 167.68322753906),
            vector4(-325.24139404297, -878.62133789063, 30.073072433472, 158.7186126709),
            vector4(-328.99792480469, -877.53247070313, 30.073009490967, 156.8335723877),
            vector4(-332.5461730957, -876.84405517578, 30.07300567627, 160.25775146484),
            vector4(-336.20037841797, -875.89526367188, 30.07142829895, 160.10269165039),
            vector4(-340.02117919922, -875.57904052734, 30.071430206299, 160.35479736328),
            vector4(-343.84158325195, -875.25646972656, 30.071430206299, 164.67770385742),
            vector4(-338.38012695313, -891.84600830078, 30.071441650391, 345.46563720703),
            vector4(-335.00958251953, -893.12261962891, 30.071441650391, 341.45092773438),
            vector4(-331.45751953125, -893.83020019531, 30.071857452393, 336.05703735352),
            vector4(-327.57147216797, -894.50762939453, 30.072914123535, 351.91864013672),
            vector4(-323.84289550781, -895.17144775391, 30.072946548462, 343.8200378418),
            vector4(-320.37411499023, -896.07330322266, 30.073198318481, 344.23126220703),
            vector4(-316.76727294922, -896.79357910156, 30.07420539856, 338.13055419922),
            vector4(-313.24185180664, -897.67028808594, 30.075204849243, 336.84799194336),
            vector4(-309.67300415039, -898.32720947266, 30.080076217651, 335.34527587891),
        },
        special = {
            vector4(-305.85092163086, -899.02978515625, 30.080619812012, 338.05102539063),
            vector4(-302.3239440918, -899.84710693359, 30.080619812012, 343.92263793945),
            vector4(-298.62890625, -900.78271484375, 30.080619812012, 341.58920288086),
        }
    },
    {
        ped = vector4(95.31470489502, 6365.1264648438, 30.375862121582, 15.229319572449),
        enter = vector4(91.094055175781, 6362.5107421875, 31.225786209106, 30.34481048584),
        spawnCar = {
            vector4(94.921852111816, 6372.1381835938, 30.225782394409, 1.986048579216),
            vector4(81.402702331543, 6365.0961914063, 30.227891921997, 10.327586174011),
            vector4(77.79988861084, 6363.3139648438, 30.227937698364, 17.396987915039),
            vector4(74.53271484375, 6362.3383789063, 30.228633880615, 10.93194103241),
            vector4(70.657089233398, 6360.1616210938, 30.228363037109, 10.433659553528),
            vector4(60.694862365723, 6374.080078125, 30.239858627319, 24.923820495605),
            vector4(63.508403778076, 6377.4360351563, 30.239858627319, 25.61173248291),
            vector4(67.008201599121, 6378.7431640625, 30.239858627319, 26.277843475342),
        },
        special = {
            vector4(98.711242675781, 6373.1220703125, 30.225788116455, 4.6233968734741),
            vector4(102.06247711182, 6374.9267578125, 30.225786209106, 5.8635969161987),
        }
    },
    {
        ped = vector4(1532.49, 3783.94, 32.73, 209.44),
        enter = vector4(1532.49, 3783.94, 33.73, 209.44),
        spawnCar = {
            vector4(1544.23, 3783.32, 32.34, 302.05),
            vector4(1549.81, 3786.67, 32.39, 300.89),
            vector4(1555.5, 3790.38, 32.46, 303.52),
            vector4(1560.87, 3793.75, 32.53, 301.59),
            vector4(1567.39, 3797.95, 32.6, 300.45),
        },
        special = {
        }
    },
    {
        ped = vector4(-1520.7, 4948.17, 60.84, 51.21),
        enter = vector4(-1524.21, 4951.27, 61.99, 52.48),
        spawnCar = {
            vector4(-1518.93, 4956.86, 61.06, 79.61),
            vector4(-1523.11, 4952.3, 61.02, 75.96),
            vector4(-1528.33, 4947.01, 60.69, 81.59),
        },
        special = {
        }
    },
    {
        ped = vector4(-2030.298828125, -465.30102539063, 10.603974342346, 316.26083374023),
        enter = vector4(-2025.6932373047, -461.38067626953, 11.517674446106, 321.63323974609),
        spawnCar = {
            vector4(-2023.642578125, -471.24542236328, 10.421620368958, 141.67498779297),
            vector4(-2021.466796875, -473.09939575195, 10.421619415283, 145.05372619629),
            vector4(-2018.7404785156, -474.85116577148, 10.429237365723, 134.15756225586),
            vector4(-2036.8737792969, -460.46685791016, 10.41626739502, 137.662109375),
            vector4(-2039.0178222656, -458.24548339844, 10.422093391418, 126.10158538818),
            vector4(-2041.3122558594, -456.20904541016, 10.423421859741, 137.50965881348),
        },
        special = {
        }
    },
    {
        ped = vector4(402.98764038086, -1628.7103271484, 28.29207611084, 217.68898010254),
        enter = vector4(408.98330688477, -1638.4364013672, 29.29207611084, 226.70753479004),
        spawnCar = {
            vector4(417.58798217773, -1627.0186767578, 28.292083740234, 139.4193572998),
            vector4(420.02331542969, -1629.125, 28.292074203491, 134.30122375488),
            vector4(421.62362670898, -1638.7410888672, 28.29248046875, 92.146995544434),
            vector4(407.5549621582, -1655.5675048828, 28.29216003418, 322.24871826172),
            vector4(403.04125976563, -1651.2457275391, 28.294658660889, 316.75708007813),
            vector4(398.66741943359, -1646.7257080078, 28.292058944702, 310.03253173828),
        },
        special = {
        }
    }
}

local data_ui = {
    garage = {},
    pound = {},
    isPremium = false
}

function getTableSize(t)
    local count = 0
    for _, __ in pairs(t) do
        count = count + 1
    end
    return count
end

local function enterCar()
    if IsPedInAnyVehicle(p:ped(), false) then
        local veh = GetVehiclePedIsIn(p:ped(), false)
        local props = vehicle.getProps(veh)
        TriggerServerEvent("core:SetPropsVeh", token, props.plate, props)
        local isOk = TriggerServerCallback('core:vehicle:setPublic', all_trim(GetVehicleNumberPlateText(veh)))
        if isOk == true then
            TriggerEvent('persistent-vehicles/forget-vehicle', veh)
            DeleteEntity(veh)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s " .. isOk
            })
        end
    end
end

local function OpenGaragePublic(ped)
    data_ui.garage = {}
    data_ui.pound = {}
    stock = TriggerServerCallback("core:GetVehiclesParking")
    playerCrew = p:getCrew()
    data_ui.isPremium = p:getSubscription() >= 1 and true or false
    local max = data_ui.isPremium == true and 3 or 1
    data_ui.garageType = "voiture"
    if json.encode(stock) ~= "[]" or crewStock ~= nil then
        if json.encode(stock) ~= "[]" then
            for k, v in pairs(stock) do
                if not Boats[string.lower(v.name)] then
                    if v.stored == 2 then
                        table.insert(data_ui.pound, {
                            id = k,
                            --price = amount,
                            image= "https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Voiture/"..v.name..".webp",
                            name=v.name,
                            label=v.name.." "..v.currentPlate,
                            category= "Fourriere",
                        })
                    elseif v.stored == 3 then
                        if max > 0 then
                            table.insert(data_ui.garage, {
                                id = k,
                                --price = amount,
                                image= "https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Voiture/"..v.name..".webp",
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
            content = "~s Aucun véhicule dans le garage"
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

CreateThread(function()
    for k, v in pairs(parking) do
        while zone == nil do Wait(1) end
        peds[k] = entity:CreatePedLocal("a_m_m_hillbilly_01", v.ped.xyz, v.ped.w)
        peds[k]:setFreeze(true)
        SetEntityInvincible(peds[k].id, true)
        SetEntityAsMissionEntity(peds[k].id, 0, 0)
        SetBlockingOfNonTemporaryEvents(peds[k].id, true)
        zone.addZone(
            "parking_public_ped" .. k, -- Nom
            v.ped.xyz + vector3(0.0, 0.0, 2.0), -- Position
            "~INPUT_CONTEXT~ Ouvrir le garage publique", -- Text affiché
            function()
                actuel = k
                OpenGaragePublic(peds[k].id)
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
            "parking_public_enter" .. k, -- Nom
            v.enter.xyz, -- Position
            "~INPUT_CONTEXT~ Garer votre voiture", -- Text affiché
            function()
                actuel = k
                enterCar()
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
        SetBlipSprite(blips[k], 524)
        SetBlipDisplay(blips[k], 4)
        SetBlipScale(blips[k], 0.8)
        SetBlipColour(blips[k], 48)
        SetBlipAsShortRange(blips[k], true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Garage public")
        EndTextCommandSetBlipName(blips[k])
    end
end)
