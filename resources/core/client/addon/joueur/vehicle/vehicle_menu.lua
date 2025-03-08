local infoVeh, maxSpeed, limitateur, autoDrive, open = nil , 50, false, false, false

Keys.Register("M", "M", "Limitateur de vitesse", function()
    if p:isInVeh() then
        if GetPedInVehicleSeat(p:currentVeh(), -1) == p:ped() then
            if limitateur then
                -- ShowNotification("Limitateur désactivé")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Limitateur ~s désactivé"
                })

                SetVehicleMaxSpeed(p:currentVeh(), GetVehicleEstimatedMaxSpeed(p:currentVeh()))
                limitateur = false
            else
                -- ShowNotification("Limitateur activé à " .. maxSpeed .. "km/h")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Limitateur ~s activé ~c à ~s" .. maxSpeed .. "km/h"
                })

                while GetEntitySpeed(p:currentVeh()) > maxSpeed / 3.6 do Wait(1) end
                SetVehicleMaxSpeed(p:currentVeh(), maxSpeed / 3.6)
                limitateur = true
            end
        end
    end
end)

Keys.Register("F11", "F11", "Ouvrir le menu info du véhicule", function()
    if open == false then
        if p:isInVeh() then
            infoVeh = {
                fuel= Round(GetVehicleFuelLevel(p:currentVeh())),
                condition= math.floor(Round(GetVehicleEngineHealth(p:currentVeh())) / 10),
                immatriculation= all_trim(GetVehicleNumberPlateText(p:currentVeh())),
                vehicleName= string.upper(GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(p:currentVeh()))))
            }
            if GetPedInVehicleSeat(p:currentVeh(), -1) == p:ped() then
                open = true
                SendNuiMessage(json.encode({
                    type = 'openWebview',
                    name = 'MenuVehicule',
                    data = infoVeh
                }));
                CreateThread(function()
                    while open do
                        Wait(0)
                        DisableControlAction(0, 24, true) -- disable attack
                        DisableControlAction(0, 25, true) -- disable aim
                        DisableControlAction(0, 1, true) -- LookLeftRight
                        DisableControlAction(0, 2, true) -- LookUpDown
                        DisableControlAction(0, 142, open)
                        DisableControlAction(0, 18, open)
                        DisableControlAction(0, 322, open)
                        DisableControlAction(0, 106, open)
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
            end
        end
    else 
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
    end
end)

RegisterNUICallback("MenuVoiture", function(data,cb)
    for k,v in pairs(data) do
        if k == "moteur" then
            if v == false then
                SetVehicleEngineOn(p:currentVeh(), false, false, true)
                SetVehicleUndriveable(p:currentVeh(), true)
            else
                SetVehicleEngineOn(p:currentVeh(), true, false, true)
                SetVehicleUndriveable(p:currentVeh(), false)
            end
            return
        elseif k == "porteAvantG" then
            if v == false then
                SetVehicleDoorOpen(p:currentVeh(), 0, false, false)
            else
                SetVehicleDoorShut(p:currentVeh(), 0, false)
            end
            return
        elseif k == "porteAvantD" then
            if v == false then
                SetVehicleDoorOpen(p:currentVeh(), 1, false, false)
            else
                SetVehicleDoorShut(p:currentVeh(), 1, false)
            end
            return
        elseif k == "porteArriereG" then
            if v == false then
                SetVehicleDoorOpen(p:currentVeh(), 2, false, false)
            else
                SetVehicleDoorShut(p:currentVeh(), 2, false)
            end
            return
        elseif k == "porteArriereD" then
            if v == false then
                SetVehicleDoorOpen(p:currentVeh(), 3, false, false)
            else
                SetVehicleDoorShut(p:currentVeh(), 3, false)
            end
            return
        elseif k == "capot" then
            if v == false then
                SetVehicleDoorOpen(p:currentVeh(), 4, false, false)
            else
                SetVehicleDoorShut(p:currentVeh(), 4, false)
            end
            return
        elseif k == "coffre" then
            if v == false then
                SetVehicleDoorOpen(p:currentVeh(), 5, false, false)
            else
                SetVehicleDoorShut(p:currentVeh(), 5, false)
            end
            return
        elseif k == "fenetreAvantG" then
            if v == true then
                RollUpWindow(p:currentVeh(), 0)
            else
                RollDownWindow(p:currentVeh(), 0)
            end
            return
        elseif k == "fenetreAvantD" then
            if v == true then
                RollUpWindow(p:currentVeh(), 1)
            else
                RollDownWindow(p:currentVeh(), 1)
            end
            return
        elseif k == "fenetreArriereG" then
            if v == true then
                RollUpWindow(p:currentVeh(), 2)
            else
                RollDownWindow(p:currentVeh(), 2)
            end
            return
        elseif k == "fenetreArriereD" then
            if v == true then
                RollUpWindow(p:currentVeh(), 3)
            else
                RollDownWindow(p:currentVeh(), 3)
            end
            return
        elseif k == "limitateurVitesse" then
            maxSpeed = v
            return
        elseif k == "conduiteAuto" then
            if v == true then
                if IsWaypointActive() then
                    StartAutoDrive()
                    autoDrive = true
                else
                    -- ShowNotification("Vous devez avoir un point d'arrivée pour lancer la conduite auto")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Vous devez avoir un point d'arrivée pour lancer la conduite auto"
                    })

                end
            else
                ClearPedTasks(p:ped())
                autoDrive = false
            end
            return
        end
    end
end)

RegisterNUICallback("focusOut", function (data, cb)
    if open then
        open = false
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        TriggerScreenblurFadeOut(0.5)
    end
end)

-- Function

function openTrunk(entity)
    -- check if the car is locked
    if GetVehicleDoorLockStatus(entity) ~= 2 then
        -- if the trunk opened angle is positive, close the trunk
        if GetVehicleDoorAngleRatio(entity, 5) > 0 then
            SetVehicleDoorShut(entity, 5, false)
        else -- if the trunk is closed, open it
            SetVehicleDoorOpen(entity, 5, false, false)
        end
    else
        -- ShowNotification("Le véhicule est ~r~verrouillé")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Le véhicule est ~s verrouillé"
        })

    end
end


function openHood(entity)
    -- check if the car is locked
    if GetVehicleDoorLockStatus(entity) ~= 2 then
        -- if the hood opened angle is positive, close the hood
        if GetVehicleDoorAngleRatio(entity, 4) > 0 then
            SetVehicleDoorShut(entity, 4, false)
        else -- if the hood is closed, open it
            SetVehicleDoorOpen(entity, 4, false, false)
        end
    else
        -- ShowNotification("Le véhicule est ~r~verrouillé")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Le véhicule est ~s verrouillé"
        })

    end
end

function takeConducteurId(entity)
    local ped = GetPedInVehicleSeat(entity, -1)
    if IsPedAPlayer(ped) and GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped)) ~= 0 then
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "L'id du conducteur est ~s " .. GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
        })
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Aucun conducteur"
        })
    end
end

function StartAutoDrive()
    local coords = GetBlipInfoIdCoord(GetFirstBlipInfoId(8))
    if coords ~= nil and coords ~= 0 then
        TaskVehicleDriveToCoordLongrange(p:ped(), p:currentVeh(), coords.x, coords.y, coords.z, 50.0, 907, 20.0)
    end
    CreateThread(function()
        while autoDrive do
            if #(p:pos() - coords) <= 20.0 then
                if autoDrive then
                    ClearPedTasks(p:ped())
                    SetVehicleForwardSpeed(p:currentVeh(), 19.0)
                    Wait(200)
                    SetVehicleForwardSpeed(p:currentVeh(), 15.0)
                    Wait(200)
                    SetVehicleForwardSpeed(p:currentVeh(), 11.0)
                    Wait(200)
                    SetVehicleForwardSpeed(p:currentVeh(), 6.0)
                    Wait(200)
                    SetVehicleForwardSpeed(p:currentVeh(), 0.0)
                    --
                    -- ShowNotification("Vous êtes arrivé à destination")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'JAUNE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous êtes ~s arrivé ~c à destination"
                    })

                    autoDrive = false
                    return
                else
                    return
                end
            end
            Wait(1)
        end
    end)
end

--- Old geston Car ----

--[[


local neon = false
local neonEnabled = false
local open = false
local vehicleInfo_main = RageUI.CreateMenu("", "gestion du véhicule", 0.0, 0.0, "vision", "menu_title_vehicle")
vehicleInfo_main.Closed = function()
    open = false
    if neon then
        SetVehicleNeonLightEnabled(p:currentVeh(), 0, true)
        SetVehicleNeonLightEnabled(p:currentVeh(), 1, true)
        SetVehicleNeonLightEnabled(p:currentVeh(), 2, true)
        SetVehicleNeonLightEnabled(p:currentVeh(), 3, true)
        neon = false
    end
end

local vehMotor = false
local vehCapot = false
local vehCoffre = false
local vehWindow = false
local vehPorte = { "Avant-gauche", "Avant-droite", "Arrière-gauche", "Arrière-droit" }
local vehPorteIndexIsOpen = { false, false, false, false }
local vehPorteIndex = 1


function OpenInfoVehicleMenu()
    if open then
        open = false
        RageUI.Visible(vehicleInfo_main, false)
        -- if there was neon, turn them back on
        if neon then
            SetVehicleNeonLightEnabled(p:currentVeh(), 0, true)
            SetVehicleNeonLightEnabled(p:currentVeh(), 1, true)
            SetVehicleNeonLightEnabled(p:currentVeh(), 2, true)
            SetVehicleNeonLightEnabled(p:currentVeh(), 3, true)
            neon = false
        end
    else
        open = true
        RageUI.Visible(vehicleInfo_main, true)
        -- get veh props
        local veh = vehicle.getProps(p:currentVeh())
        -- check if any neon is enabled
        for i = 1, 4 do
            if veh.neonEnabled[i] then
                neon = true
                neonEnabled = true
                break
            end
        end
        CreateThread(function()
            while open do
                if not p:isInVeh() then
                    open = false
                    RageUI.CloseAll()
                    return
                end
                RageUI.IsVisible(vehicleInfo_main, function()
                    RageUI.Checkbox("Eteindre le moteur", nil, vehMotor, {}, {
                        onChecked = function()
                            SetVehicleEngineOn(p:currentVeh(), false, false, true)
                            SetVehicleUndriveable(p:currentVeh(), true)
                            vehMotor = true
                        end,
                        onUnChecked = function()
                            SetVehicleEngineOn(p:currentVeh(), true, false, true)
                            SetVehicleUndriveable(p:currentVeh(), false)
                            vehMotor = false
                        end
                    })
                    RageUI.Checkbox("Ouvrir/fermer le capot", nil, vehCapot, {}, {
                        onChecked = function()
                            SetVehicleDoorOpen(p:currentVeh(), 4, false, false)
                            vehCapot = true
                        end,
                        onUnChecked = function()
                            SetVehicleDoorShut(p:currentVeh(), 4, false, false)
                            vehCapot = false
                        end
                    })
                    RageUI.Checkbox("Ouvrir/fermer le coffre", nil, vehCoffre, {}, {
                        onChecked = function()
                            SetVehicleDoorOpen(p:currentVeh(), 5, false, false)
                            vehCoffre = true
                        end,
                        onUnChecked = function()
                            SetVehicleDoorShut(p:currentVeh(), 5, false, false)
                            vehCoffre = false
                        end
                    })
                    RageUI.Checkbox("Ouvrir/fermer les fenêtres", nil, vehWindow, {}, {
                        onChecked = function()
                            RollDownWindows(p:currentVeh())
                            vehWindow = true
                        end,
                        onUnChecked = function()
                            RollUpWindow(p:currentVeh(), 0)
                            RollUpWindow(p:currentVeh(), 1)
                            RollUpWindow(p:currentVeh(), 2)
                            RollUpWindow(p:currentVeh(), 3)
                            vehWindow = false
                        end
                    })
                    -- if any neon is enabled, create a checkbox to toggle all neons
                    if neon then
                        RageUI.Checkbox("Allumer/éteindre les néons", nil, neonEnabled, {}, {
                            onChecked = function()
                                SetVehicleNeonLightEnabled(p:currentVeh(), 0, veh.neonEnabled[1])
                                SetVehicleNeonLightEnabled(p:currentVeh(), 1, veh.neonEnabled[2])
                                SetVehicleNeonLightEnabled(p:currentVeh(), 2, veh.neonEnabled[3])
                                SetVehicleNeonLightEnabled(p:currentVeh(), 3, veh.neonEnabled[4])
                                neonEnabled = true
                            end,
                            onUnChecked = function()
                                SetVehicleNeonLightEnabled(p:currentVeh(), 0, false)
                                SetVehicleNeonLightEnabled(p:currentVeh(), 1, false)
                                SetVehicleNeonLightEnabled(p:currentVeh(), 2, false)
                                SetVehicleNeonLightEnabled(p:currentVeh(), 3, false)
                                neonEnabled = false
                            end
                        })
                    end
                    RageUI.List("Ouvrir/fermer les portes", vehPorte, vehPorteIndex, nil, {}, true, {
                        onListChange = function(index)
                            vehPorteIndex = index
                        end,
                        onSelected = function()
                            if vehPorteIndexIsOpen[vehPorte] then
                                SetVehicleDoorShut(p:currentVeh(), vehPorteIndex - 1, false)
                                vehPorteIndexIsOpen[vehPorte] = false
                            else
                                SetVehicleDoorOpen(p:currentVeh(), vehPorteIndex - 1, false, false)
                                vehPorteIndexIsOpen[vehPorte] = true
                            end
                        end
                    })
                end)
                Wait(1)
            end
        end)
    end
end


    
function OpenVehicleGestion()
    if open then
        open = false
        RageUI.Visible(vehicleGestion_main, false)
    else
        open = true
        RageUI.Visible(vehicleGestion_main, true)

        CreateThread(function()
            while open do
                if not p:isInVeh() then
                    open = false
                    RageUI.CloseAll()
                    return
                end
                RageUI.IsVisible(vehicleGestion_main, function()
                    RageUI.Checkbox("Conduite auto", nil, autoDrive, {}, {
                        onChecked = function()
                            if IsWaypointActive() then
                                StartAutoDrive()
                                autoDrive = true
                            else
                                -- ShowNotification("Vous devez avoir un point d'arrivée pour lancer la conduite auto")

                                -- New notif
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "~s Vous devez avoir un point d'arrivée pour lancer la conduite auto"
                                })


                            end
                        end,
                        onUnChecked = function()
                            ClearPedTasks(p:ped())
                            autoDrive = false
                        end
                    })
                    RageUI.List("Limitateur", limitateurItem, limitateurIndex, nil, {},
                        (GetEntitySpeed(p:currentVeh()) * 3.5) <= 50.0, {
                        onListChange = function(index)
                            limitateurIndex = index
                        end,
                        onSelected = function()
                            if limitateur then
                                -- ShowNotification("~r~Limitateur désactivé")

                                -- New notif
                                exports['vNotif']:createNotification({
                                    type = 'JAUNE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "Limitateur ~s désactivé"
                                })
                                
                                SetVehicleMaxSpeed(p:currentVeh(), GetVehicleEstimatedMaxSpeed(p:currentVeh()))
                                limitateur = false
                            else
                                -- ShowNotification("~g~Limitateur activé")

                                -- New notif
                                exports['vNotif']:createNotification({
                                    type = 'JAUNE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "Limitateur ~s activé"
                                })

                                SetVehicleMaxSpeed(p:currentVeh(), limitateurItem[limitateurIndex] / 3.6)
                                limitateur = true
                            end
                        end
                    })
                    RageUI.Button("Etat du véhicule", nil,
                        { RightLabel = "~g~" .. (Round(GetVehicleEngineHealth(p:currentVeh())) / 10) .. "%" }, true, {})
                    RageUI.Button("Essence", nil,
                        { RightLabel = "~g~" .. (Round(GetVehicleFuelLevel(p:currentVeh()))) .. "L" }, true, {})
                    -- RageUI.Button("Vider le coffre", nil, {}, true, {
                    --     onSelected = function()
                    --         TriggerEvent("core:emptyTrunk", p:currentVeh())
                    --     end
                    -- })
                end)
                Wait(1)
            end
        end)
    end
end

]]