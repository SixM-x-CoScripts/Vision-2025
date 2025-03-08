local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local time = 20000

local function RepareCarosserie()
    local closestVeh, closestDist = GetClosestVehicle(p:pos())
    if closestDist <= 3 then
        local GetEngine = GetVehicleEngineHealth(closestVeh)

        RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
        while not HasAnimDictLoaded("anim@amb@clubhouse@tutorial@bkr_tut_ig3@") do
            Wait(1)
        end
        TaskPlayAnim(p:ped(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, -8.0, -1, 1, 0, false, false, false)
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'Progressbar',
            data = {
                text = "Réparation de la carrosserie en cours...",
                time = time / 1000,
            }
        }))
        RemoveAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
        Modules.UI.RealWait(time)

        -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Réparation ~s terminée."
        })

        ClearPedTasksImmediately(p:ped())
        SetVehicleBodyHealth(closestVeh, 1000.0)
        SetVehicleFixed(closestVeh)
        SetVehicleDeformationFixed(closestVeh)
        SetVehicleEngineHealth(closestVeh, GetEngine)
        SetVehicleUndriveable(closestVeh, false)
        time = 20000
    end
end

local function RepareVehMoteur()
    local closestVeh, closestDist = GetClosestVehicle(p:pos())
    if closestDist <= 3 then
        local GetEngine = GetVehicleEngineHealth(closestVeh)
        if GetEngine < 950.0 then
            time = (60000 - ((GetVehicleEngineHealth(closestVeh) / 1000) * (60000 - 20000))) / 2

            p:PlayAnim("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "fixing_a_ped", 174)

            TaskStartScenarioInPlace(p:ped(), 'PROP_HUMAN_BUM_BIN', -1, true)

            SendNuiMessage(json.encode({
                type = 'openWebview',
                name = 'Progressbar',
                data = {
                    text = "Réparation du moteur en cours...",
                    time = time / 1000, -- convertir en secondes
                }
            }))
            Modules.UI.RealWait(time)

            -- Nouvelle notification
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                content = "Réparation ~s terminée."
            })

            ClearPedTasksImmediately(p:ped())
            SetVehicleEngineHealth(closestVeh, 1000.0)
        else
            -- Nouvelle notification
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                content = "Le véhicule est en ~s bon état."
            })
        end
    end
end

local function CleanVeh()
    local closestVeh, closestDist = GetClosestVehicle(p:pos())
    if closestDist <= 3 then
        TaskStartScenarioInPlace(p:ped(), 'WORLD_HUMAN_MAID_CLEAN', -1, true)
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'Progressbar',
            data = {
                text = "Nettoyage en cours...",
                time = 8,
            }
        }))
        Modules.UI.RealWait(8000)

        SetVehicleDirtLevel(closestVeh, 0)
        ClearPedTasksImmediately(p:ped())
        --[[ ShowAdvancedNotification(textChar, "Information", "Nettoyage terminé.", char
            , char) ]]

        -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Nettoyage ~s terminée."
        })
    end
end

RegisterNetEvent("core:UseToolKit")
AddEventHandler("core:UseToolKit", function()
    RepareVehMoteur()
    RepareCarosserie()
end)
RegisterNetEvent("core:UseToolNettoyage")
AddEventHandler("core:UseToolNettoyage", function()
    CleanVeh()
end)

RegisterNetEvent("core:usekitmoteur", function()
    TriggerEvent("core:CloseInv")
    local closestVeh, closestDist = GetClosestVehicle(p:pos())
    if closestDist <= 3 then
        if #(p:pos() - GetWorldPositionOfEntityBone(closestVeh, GetEntityBoneIndexByName(closestVeh, "overheat")) + vector3(0.0, 0.0, 0.5)) < 2.0 or GetEntityBoneIndexByName(closestVeh, "overheat") == -1 then
            if GetVehicleEngineHealth(closestVeh) < 500.0 then
                p:PlayAnim("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "fixing_a_ped", 174)

                TaskStartScenarioInPlace(p:ped(), 'PROP_HUMAN_BUM_BIN', -1, true)
                TriggerServerEvent("core:RemoveItemToInventory", token, "kitmoteur", 1, {})

                SendNuiMessage(json.encode({
                    type = 'openWebview',
                    name = 'Progressbar',
                    data = {
                        text = "Réparation en cours...",
                        time = 60,
                    }
                }))
                Modules.UI.RealWait(60000)

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Réparation ~s terminée."
                })
                ClearPedTasksImmediately(p:ped())
                SetVehicleEngineHealth(closestVeh, 600.0)
            else
                -- New notif
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Le véhicule est en ~s bon état."
                })
            end
        end
    end
end)
