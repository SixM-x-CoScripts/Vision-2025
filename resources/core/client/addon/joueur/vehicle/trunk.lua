local invalid_classes = { -- blacklisted classes = the player can't be put in these trunks
    13, --vélos
    14, --bateaux
    15, --helicoptères
    16, --avions
    21, --trains
    22, --openwheel
    8, --motos
}
local inTrunk = false

function putInTrunk(entity) -- function that puts the player in the trunk of the selected car
    -- get the closest vehicle
    local vehicle = entity
    local playerID = GetPlayerServerId(PlayerId())
    -- check if the vehicle class is not in the invalid class
    if not tableContains(invalid_classes, GetVehicleClass(vehicle)) then
        if vehicle ~= nil then
            if GetVehiclePedIsIn(playerID, false) == 0 then
                TriggerServerEvent("core:putInTrunk", playerID, NetworkGetNetworkIdFromEntity(vehicle))
            elseif GetVehicleDoorLockStatus(vehicle) == 0 then
                -- ShowNotification("Le véhicule est verrouillé")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Le véhicule est ~s verrouillé"
                })

            elseif GetVehiclePedIsIn(playerID, false) ~= 0 then
                -- ShowNotification("Impossible de vous mettre dans le coffre")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Impossible de vous mettre dans le coffre"
                })
                
            end
        else
            -- ShowNotification("Aucun véhicule à proximité")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Aucun véhicule à proximité"
            })

        end
    else
        -- ShowNotification("Vous ne pouvez pas vous mettre dans le coffre")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Vous ne pouvez pas vous mettre dans le coffre"
        })


    end
end

RegisterNetEvent("core:putInTrunk")
AddEventHandler("core:putInTrunk", function(vehicle)
    local vehicle = NetworkGetEntityFromNetworkId(vehicle)
    playerPed = PlayerPedId()
    local vehiclesSave = nil
    if not IsEntityAttached(playerPed) then
        SetCarBootOpen(vehicle)
        Wait(350)
        -- ShowNotification("Vous êtes dans le coffre")

        setBypassAntiTeleport(true)
        -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous êtes ~s dans le coffre"
        })

        -- TODO BLACK SCREEN
        inTrunk = true
        -- SetEntityVisible(playerPed, false, false)
        vehiclesSave = vehicle
        AttachEntityToEntity(PlayerPedId(), vehicle, GetEntityBoneIndexByName(vehicle, "platelight"), 0.0, 0.4, 0.4, 0.0
            , 0.0, 0.0, false, false, false, false, 20, true)
        LoadDict('timetable@floyd@cryingonbed@base')
        TaskPlayAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 2, 0, false, false, false)
        Wait(1500)
        SetVehicleDoorShut(vehicle, 5)
    else
        -- ShowNotification("Il y a déja quelqu'un dans le coffre")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Il y a déja quelqu'un dans le coffre"
        })
        
    end
    CreateThread(function()
        -- thread to check if the player is considered as in the trunk but is not attached to the vehicle
        -- aka inTrunk is true but the vehicle is not here somehow
        local firstVeh = 0
        while inTrunk do
            local pNear = false
            if inTrunk then
                pNear = true
                ShowHelpNotification("Appuyer sur ~INPUT_CONTEXT~ pour sortir")
                local vehicle, dist = GetClosestVehicle(p:pos())
                if firstVeh == 0 then 
                    firstVeh = NetworkGetNetworkIdFromEntity(vehicle)
                end
                if GetVehicleDoorAngleRatio(vehicle, 5) > 0 or GetEntityModel(vehicle) == GetHashKey("outlaw") then
                    SetEntityVisible(p:ped(), true, false)
                elseif IsVehicleDoorDamaged(vehicle, 5) then
                    SetEntityVisible(p:ped(), true, false)
                else
                    SetEntityVisible(p:ped(), false, false)
                end
                if not DoesEntityExist(vehiclesSave) then
                    SetEntityVisible(p:ped(), true, false)
                    inTrunk = false
                    ClearPedTasksImmediately(p:ped())
                    DetachEntity(p:ped(), true, true)
                    SetEntityCoordsNoOffset(p:ped(), p:pos().x, p:pos().y, p:pos().z, 0.0, 0.0, 0.0)
                end
                if dist > 15 then 
                    playerTrunk = GetEntityAttachedTo(vehicle)
                    SetEntityVisible(p:ped(), true, false)
                    inTrunk = false
                    -- ClearPedTasksImmediately(p:ped())
                    DetachEntity(p:ped(), true, true)
                    TriggerServerEvent("core:removeFromTrunk", firstVeh)
                end
                if IsControlJustPressed(0, 38) then
                    local vehicle, dist = GetClosestVehicle(p:pos())
                    if dist <= 5.0 and inTrunk then
                        setBypassAntiTeleport(false)
                        playerTrunk = GetEntityAttachedTo(vehicle)
                        SetEntityVisible(p:ped(), true, false)
                        inTrunk = false
                        -- ClearPedTasksImmediately(p:ped())
                        DetachEntity(p:ped(), true, true)
                        TriggerServerEvent("core:removeFromTrunk", NetworkGetNetworkIdFromEntity(vehicle))
                        local coords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -3.0, 0.0)
                        SetEntityCoordsNoOffset(p:ped(), coords.x, coords.y, coords.z, 0.0, 0.0, 0.0)
                    end
                end
            end
            if pNear then
                Wait(1)
            else
                Wait(1000)
            end
        end
    end)
end)


RegisterNetEvent("core:emptyTrunk")
AddEventHandler("core:emptyTrunk", function(veh)
    --check if a player is in the veh trunk
    playerTrunk = GetEntityAttachedTo(veh)
    if playerTrunk ~= 0 then
        TriggerServerEvent("core:emptyTrunk", GetPlayerServerId(NetworkGetPlayerIndexFromPed(playerTrunk)))
        -- ClearPedTasksImmediately(playerTrunk)
        SetVehicleDoorOpen(veh, 5)
        Wait(350)
        SetVehicleDoorShut(veh, 5)
    else
        -- ShowNotification("Il n'y a personne dans le coffre")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Il n'y a personne dans le coffre"
        })

    end
end)

RegisterNetEvent("core:emptyTrunk2")
AddEventHandler("core:emptyTrunk2", function()
    SetEntityVisible(p:ped(), true, false)
    inTrunk = false
    -- ClearPedTasksImmediately(p:ped())
    DetachEntity(p:ped(), true, true)
end)
