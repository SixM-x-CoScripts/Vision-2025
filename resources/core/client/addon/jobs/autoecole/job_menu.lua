local policePropsPlaced = {}
local vehs = nil
local token = nil
AutoEcoleDuty = false
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function LoadDrivingSchoolJob()

    zone.addZone("society_drivingschool", vector3(-938.68023681641, -176.53294372559, 36.349170684814),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le coffre de l'entreprise", function()
            OpenInventorySocietyMenu() -- TODO: fini le menu society

        end, true, 25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170-- Alpha
    )

    zone.addZone("coffre_drivingschool", vector3(-937.4716796875, -179.29032897949, 36.349166870117),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les actions d'entreprise", function()
            OpenSocietyMenu() -- TODO: fini le menu society
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        1.5,
        true,
        "bulleGestion"
    )

    zone.addZone("autoecole_garage", vector3(-881.45654296875, -195.01258850098, 37.508083343506),
        "~INPUT_CONTEXT~ Intéragir", function()
            OpenMenuVeh()
        end, true, 27, 0.7, { 17, 201, 198 }, 255)

    zone.addZone("autoecole_delete", vector3(-878.11065673828, -210.421875, 39.215995788574),
        "~INPUT_CONTEXT~ Ranger le véhicule", function()
            if IsPedInAnyVehicle(p:ped(), false) then
                local veh = GetVehiclePedIsIn(p:ped(), false)
                TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                --removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                DeleteEntity(veh)
            end
        end, true, 36, 0.5, { 255, 0, 0 }, 255
    )

    local openRadial = false
    function OpenRadialAutoEcoleMenu()
        if not openRadial then
            openRadial = true
            CreateThread(function()
                while openRadial do
                    Wait(0)
                    DisableControlAction(0, 1, openRadial)
                    DisableControlAction(0, 2, openRadial)
                    DisableControlAction(0, 142, openRadial)
                    DisableControlAction(0, 18, openRadial)
                    DisableControlAction(0, 322, openRadial)
                    DisableControlAction(0, 106, openRadial)
                    DisableControlAction(0, 24, true) -- disable attack
                    DisableControlAction(0, 25, true) -- disable aim
                    DisableControlAction(0, 263, true) -- disable melee
                    DisableControlAction(0, 264, true) -- disable melee
                    DisableControlAction(0, 257, true) -- disable melee
                    DisableControlAction(0, 140, true) -- disable melee
                    DisableControlAction(0, 141, true) -- disable melee
                    DisableControlAction(0, 142, true) -- disable melee
                    DisableControlAction(0, 143, true) -- disable melee
                end
            end)
            SetNuiFocusKeepInput(true)
            SetNuiFocus(true, true)
            Wait(200)
            CreateThread(function()
                SendNuiMessage(json.encode({
                    type = 'openWebview',
                    name = 'RadialMenu',
                    data = { elements = {
                        {
                            name = "Service",
                            icon = "https://cdn.sacul.cloud/v2/vision-cdn/RadialMenus/check.svg",
                            action = "SetAutoEcoleDuty"
                        }, {
                            name = "Objets",
                            icon = "https://cdn.sacul.cloud/v2/vision-cdn/RadialMenus/barriere-routiere.svg",
                            action = "openAutoEcolePropsMenu"
                        }
                    }, title = "Menu Auto Ecole" }
                }));
            end)
        else
            openRadial = false
            SetNuiFocusKeepInput(false)
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 142, true)
            EnableControlAction(0, 18, true)
            EnableControlAction(0, 322, true)
            EnableControlAction(0, 106, true)
            SetNuiFocus(false, false)
            SendNuiMessage(json.encode({
                type = 'closeWebview'
            }))
            return
        end

    end

    RegisterNUICallback("focusOut", function(data, cb)
        if openRadial then
            openRadial = false
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 142, true)
            EnableControlAction(0, 18, true)
            EnableControlAction(0, 322, true)
            EnableControlAction(0, 106, true)
        end
        cb({})
    end)
    function SetAutoEcoleDuty()
        if AutoEcoleDuty then
            TriggerServerEvent('core:DutyOff', 'autoecole')
            -- ShowNotification("Vous avez ~r~quitté~s~ votre service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s quitté ~c votre service"
            })
            
            AutoEcoleDuty = false
            Wait(5000)
        else
            TriggerServerEvent('core:DutyOn', 'autoecole')
            -- ShowNotification("Vous avez ~g~pris~s~ votre service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s pris ~c votre service"
            })

            AutoEcoleDuty = true
            Wait(5000)
        end
    end

    local open = false
    local main = RageUI.CreateMenu("", "Action Disponible", 0.0, 0.0, "root_cause", "shopui_title_drivingschool")
    main.Closed = function()
        open = false
        RageUI.Visible(main, false)
    end


    local function SpawnObject(obj, name)
        local coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
        local objCoords = (coords + forward * 2.5)
        local placed = false
        local heading = p:heading()
        TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)

        local objS = entity:CreateObject(obj, objCoords)
        objS:setPos(objCoords)
        objS:setHeading(heading)
        PlaceObjectOnGroundProperly(objS.id)

        while not placed do
            coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
            objCoords = (coords + forward * 2.5)
            objS:setPos(objCoords)
            PlaceObjectOnGroundProperly(objS.id)
            objS:setAlpha(170)
            SetEntityCollision(objS.id, false, true)

            if IsControlPressed(0, 190) then
                heading = heading + 0.5
            elseif IsControlPressed(0, 189) then
                heading = heading - 0.5
            end

            SetEntityHeading(objS.id, heading)

            ShowHelpNotification(
                "Appuyez sur ~INPUT_CONTEXT~ pour placer l'objet\n~INPUT_FRONTEND_LEFT~ ou ~INPUT_FRONTEND_RIGHT~ Pour faire pivoter l'objet")
            if IsControlJustPressed(0, 38) then
                placed = true
            end
            Wait(0)
        end
        SetEntityCollision(objS.id, true, true)
        -- SetEntityInvincible(objS.id, true)
        -- objS:setFreeze(true)
        objS:resetAlpha()
        local netId = objS:getNetId()
        if netId == 0 then
            objS:delete()
        end
        SetNetworkIdCanMigrate(netId, true)
        table.insert(policePropsPlaced, {
            nom = name,
            prop = objS.id
        })
    end

    local open = false
    local auto_ecole_props = RageUI.CreateMenu("", "Auto-école", 0.0, 0.0, "root_cause", "shopui_title_drivingschool")
    local lspdmenu_traffic = RageUI.CreateMenu("", "Auto-école", 0.0, 0.0, "root_cause", "shopui_title_drivingschool")
    local auto_ecole_props_delete = RageUI.CreateSubMenu(auto_ecole_props, "", "Auto-école", 0.0, 0.0, "root_cause",
        "shopui_title_drivingschool")
    auto_ecole_props.Closed = function()
        open = false
    end
    lspdmenu_traffic.Closed = function()
        open = false
    end
    local traficList = {}

    for i = 0, 110 do
        table.insert(traficList, i)
    end
    local props = {
        { nom = "Barrière 1", prop = "prop_barrier_work05" },
        { nom = "Barrière 2", prop = "prop_barrier_work06b" },
        { nom = "Barrière 3", prop = "prop_barrier_work06a" },
        { nom = "Barrière 4", prop = "prop_barrier_work01a" },
        { nom = "Cône lumineux", prop = "prop_air_conelight" },
        { nom = "Cône", prop = "prop_roadcone02a" },
        { nom = "Cône 2", prop = "prop_mp_cone_04" },
        { nom = "Cône 3", prop = "prop_roadcone01a" },
        { nom = "Cône 4", prop = "prop_roadcone02b" },
        { nom = "Panneau STOP", prop = "prop_snow_sign_road_01a" },
        { nom = "Lumière rouge", prop = "prop_air_lights_02b" },
        { nom = "Lumière bleue", prop = "prop_air_lights_05a" },
        { nom = "Lumière de chantier", prop = "prop_worklight_03a" },
    }

    function openAutoEcolePropsMenu()
        if AutoEcoleDuty then
            if open then
                open = false
                RageUI.Visible(auto_ecole_props, false)
            else
                open = true
                RageUI.Visible(auto_ecole_props, true)

                Citizen.CreateThread(function()
                    while open do
                        RageUI.IsVisible(auto_ecole_props, function()
                            RageUI.Button("Supprimer mes props", nil, {}, true, {}, auto_ecole_props_delete)
                            for k, v in pairs(props) do
                                RageUI.Button(v.nom, nil, {}, true, {
                                    onSelected = function()
                                        SpawnObject(v.prop, v.nom)
                                    end
                                })
                            end
                        end)
                        RageUI.IsVisible(auto_ecole_props_delete, function()
                            for k, v in pairs(policePropsPlaced) do
                                RageUI.Button(v.nom, nil, {}, true, {
                                    onSelected = function()
                                        DeleteObject(v.prop)
                                        table.remove(policePropsPlaced, k)
                                    end,
                                    onActive = function()
                                        DrawMarker(20, GetEntityCoords(v.prop) + vector3(0.0, 0.0, 1.0), 0.0, 0.0, 0.0,
                                            180.0, 0.0, 0.0, 0.5, 0.5, 0.5, 92, 173, 29, 255, true, 1, 0, 0)
                                    end
                                })
                            end
                        end)
                        Wait(1)
                    end
                end)
            end
        else
            -- ShowNotification("~r~Vous n'êtes pas en service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous n'êtes ~s pas en service"
            })

        end
    end

    RegisterJobMenu(OpenRadialAutoEcoleMenu)

    ---SortirVehicule
    local open = false
    local main = RageUI.CreateMenu("", "Action Disponible", 0.0, 0.0, "root_cause", "shopui_title_drivingschool")

    local veh = { {
        name = "Asbo ",
        model = "asbo"
    }, {
        name = "Akuma ",
        model = "akuma"
    }, {
        name = "Ruffian ",
        model = "ruffian"
    }, {
        name = "Mule ",
        model = "mule"
    }, {
        name = "Pounder ",
        model = "pounder2"
    } }

    function OpenMenuVeh()
        if open then
            open = false
            RageUI.Visible(main, false)
            return
        else
            open = true
            RageUI.Visible(main, true)
            Citizen.CreateThread(function()
                while open do
                    RageUI.IsVisible(main, function()
                        for k, v in pairs(veh) do
                            RageUI.Button(v.name, "Appuyer sur entrer pour sortir le véhicule.", {}, true, {
                                onSelected = function()

                                    if vehicle.IsSpawnPointClear(
                                        vector3(-886.70751953125, -194.2233581543, 38.20825958252), 3.0) then
                                        RageUI.CloseAll()
                                        if DoesEntityExist(vehs) then
                                            TriggerEvent('persistent-vehicles/forget-vehicle', vehs)
                                            --removeKeys(GetVehicleNumberPlateText(vehs), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs))))
                                            TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehs))
                                            DeleteEntity(vehs)

                                        end
                                        vehs = vehicle.create(v.model,
                                            vector4(-886.70751953125, -194.2233581543, 38.20825958252, 27.606513977051),
                                            {})
                                        local plate = vehicle.getProps(vehs).plate
                                        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
                                        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
                                        --createKeys(plate, model)
                                    else
                                        -- ShowNotification("Il n'y a pas de place pour le véhicule")

                                        -- New notif
                                        exports['vNotif']:createNotification({
                                            type = 'ROUGE',
                                            -- duration = 5, -- In seconds, default:  4
                                            content = "Il n'y a ~s pas de place ~c pour le véhicule"
                                        })

                                    end
                                end
                            }, nil)
                        end

                    end)
                    Wait(1)
                end
            end)
        end

    end

    function FactureAutoEcole(entity)
        local billing_price = 0
        local billing_reason = ""
        local player = NetworkGetPlayerIndexFromPed(entity)
        local sID = GetPlayerServerId(player)
        local price = KeyboardImput("Entrez le prix")
        if price and type(tonumber(price)) == "number" then
            billing_price = tonumber(price)
        else
            -- ShowAdvancedNotification(textChar, "", "Veuillez entrer un nombre", char, char)

            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "~s Veuillez entrer un nombre"
            })

        end
        local reason = KeyboardImput("Entrez la raison")
        if reason ~= nil then
            billing_reason = tostring(reason)
        end

        if entity == nil then
            local closestPlayer, closestDistance = GetClosestPlayer()
            if closestPlayer ~= nil and closestDistance < 3.0 then
                TriggerServerEvent('core:sendbilling', token, GetPlayerServerId(closestPlayer), p:getJob(),
                    billing_price, billing_reason)
            else
                --[[ ShowAdvancedNotification(textChar, "Facturation", "Aucun joueur dans la zone", "CHAR_BRYONY",
                    "CHAR_BRYONY") ]]

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Aucun joueur dans la zone"
                })

            end
        else
            TriggerServerEvent('core:sendbilling', token, sID, p:getJob(), billing_price, billing_reason)
            
            --[[Ancienne notification
            -- -- ShowNotification("Facturation envoyée \n Prix : ~g~" ..
            --    billing_price .. "~s~$ \n Raison : " .. billing_reason)

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Facturation envoyée \nPrix : ~s " .. billing_price .. "$ \n~c Raison : ~s " .. billing_reason
            })
            --]]

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Facturation envoyée \nPrix : ~s " .. billing_price .. "$ \n~c Raison : ~s " .. billing_reason
            })

        end
    end

    function GivePermis(entity)
        local player = NetworkGetPlayerIndexFromPed(entity)
        local sID = GetPlayerServerId(player)
        if entity == nil then
            local closestPlayer, closestDistance = GetClosestPlayer()
            if closestPlayer ~= nil and closestDistance < 3.0 then
                TriggerServerEvent("core:addLicence", GetPlayerServerId(closestPlayer), token, "driving")
            else
                --[[ ShowAdvancedNotification(textChar, "Information", "Aucun joueur dans la zone", "CHAR_BRYONY",
                    "CHAR_BRYONY") ]]

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Aucun joueur dans la zone"
                })

            end
        else
            TriggerServerEvent("core:addLicence", sID, token, "driving")

            -- ShowNotification("Vous venez de donner le permis.")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous venez de donner le ~s permis."
            })

        end
    end

    function GivePermisMoto(entity)
        local player = NetworkGetPlayerIndexFromPed(entity)
        local sID = GetPlayerServerId(player)
        if entity == nil then
            local closestPlayer, closestDistance = GetClosestPlayer()
            if closestPlayer ~= nil and closestDistance < 3.0 then
                TriggerServerEvent("core:addLicence", GetPlayerServerId(closestPlayer), token, "moto")
            else
                --[[ ShowAdvancedNotification(textChar, "Information", "Aucun joueur dans la zone", "CHAR_BRYONY",
                    "CHAR_BRYONY") ]]

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Aucun joueur dans la zone"
            })

            end
        else
            TriggerServerEvent("core:addLicence", sID, token, "moto")

            -- ShowNotification("Vous venez de donner le permis moto.")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous venez de donner le ~s permis moto."
            })

        end
    end

    function GivePermisCamion(entity)
        local player = NetworkGetPlayerIndexFromPed(entity)
        local sID = GetPlayerServerId(player)
        if entity == nil then
            local closestPlayer, closestDistance = GetClosestPlayer()
            if closestPlayer ~= nil and closestDistance < 3.0 then
                TriggerServerEvent("core:addLicence", GetPlayerServerId(closestPlayer), token, "camion")
            else
                --[[ ShowAdvancedNotification(textChar, "Information", "Aucun joueur dans la zone", "CHAR_BRYONY",
                    "CHAR_BRYONY") ]]

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Aucun joueur dans la zone"
                })

            end
        else
            TriggerServerEvent("core:addLicence", sID, token, "camion")

            -- ShowNotification("Vous venez de donner le permis camion.")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous venez de donner le ~s permis camion."
            })

        end
    end
end

function UnLoadDrivingSchoolJob()
    zone.removeZone("autoecole_delete")
    zone.removeZone("autoecole_garage")
    zone.removeZone("coffre_drivingschool")
    zone.removeZone("society_drivingschool")
end
