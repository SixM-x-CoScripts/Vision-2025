local VehicleOpenned = nil

function GetVehicleOpenned()
    return VehicleOpenned
end

function CanPlayerOpenVehicle(veh)
    local pPed = p:ped()
    local pCoords = p:pos()
    local isInVeh = IsPedInAnyVehicle(pPed, false)

    if not isInVeh then
        if GetVehicleDoorLockStatus(veh) ~= 2 then
            local vDim, _ = GetModelDimensions(GetEntityModel(veh))
            local vPos = GetOffsetFromEntityInWorldCoords(veh, 0.0, vDim.y + -0.8, 0.0)
            local dst = GetDistanceBetweenCoords(pCoords, vPos, true)
            if dst < 1.5 then
                --OpenVehicleInventory(all_trim(GetVehicleNumberPlateText(veh)), veh, vPos)
                VehicleOpenned = veh
                TriggerServerEvent("core:OpenVehicleTruck", VehToNet(veh))
                openInventory(true, "Vehicule", all_trim(GetVehicleNumberPlateText(veh)))
            else
                -- ShowNotification("Tu n'est pas proche d'un coffre de véhicule")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Tu n'es pas ~s proche d'un coffre ~c de véhicule"
                })

                if dst < 10.0 then
                    Citizen.CreateThread(function()
                        local count = 0
                        while count <= 300 do
                            count = count + 1
                            DrawMarker(27, vPos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 255, 255, 150, 0, 0, 2
                                , 1, nil, nil, 0)
                            Wait(0)
                        end
                    end)
                end
            end
        else
            -- ShowNotification("Le véhicule est ~r~fermé.")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Le véhicule est ~s fermé."
            })

        end
    end
end
