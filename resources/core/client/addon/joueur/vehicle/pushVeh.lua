local First = vector3(0.0, 0.0, 0.0)
local Second = vector3(5.0, 5.0, 5.0)
CreateThread(function()
    while p == nil do Wait(1) end
    local lerpCurrentAngle = 0.0
    while true do
        local pNear = false
        local ped = p:ped()
        local vehicle, dist = GetClosestVehicle(p:pos())
        local isFront = false
        local dimension = GetModelDimensions(GetEntityModel(vehicle), First, Second)
        local pousse = false
        if dist <= 6.0 and not IsPedInAnyVehicle(ped, false) and not IsPedFalling(PlayerPedId()) then
            pNear = true
            -- if #(p:pos() - GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "windscreen")) +
            --         vector3(0.0, 0.0, 0.5)) < 3.0 then
            --     -- ShowHelpNotification('Appuyer sur ~INPUT_SPRINT~ et ~INPUT_CONTEXT~ pour pousser le véhicule', false)
            -- elseif #(p:pos() - GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "platelight")) +
            --         vector3(0.0, 0.0, 0.5)) <= 2.0 then
            --     -- ShowHelpNotification('Appuyer sur ~INPUT_SPRINT~ et ~INPUT_CONTEXT~ pour pousser le véhicule', false)
            -- end
            if IsControlPressed(0, 21) and IsVehicleSeatFree(vehicle, -1) and
                not IsEntityAttachedToEntity(ped, vehicle) and IsControlJustPressed(0, 47) then
                NetworkRequestControlOfEntity(vehicle)
                if GetDistanceBetweenCoords(GetEntityCoords(vehicle) + GetEntityForwardVector(vehicle),
                    GetEntityCoords(ped), true) >
                    GetDistanceBetweenCoords(GetEntityCoords(vehicle) +
                        GetEntityForwardVector(vehicle) * -1,
                        GetEntityCoords(ped), true) then
                    AttachEntityToEntity(p:ped(), vehicle, GetPedBoneIndex(6286), 0.0,
                        dimension.y - 0.3, dimension.z + 1.0, 0.0, 0.0, 0.0, 0.0, false, false, true,
                        false, true)
                    isFront = false
                    pousse = true
                else
                    AttachEntityToEntity(p:ped(), vehicle, GetPedBoneIndex(6286), 0.0,
                        dimension.y * -1 + 0.1, dimension.z + 1.0, 0.0, 0.0, 180.0, 0.0, false, false,
                        true, false, true)
                    isFront = true
                    pousse = true
                end

                RequestAnimDict('missfinale_c2ig_11')
                while not HasAnimDictLoaded('missfinale_c2ig_11') do
                    Wait(1)
                end
                TaskPlayAnim(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, 0, 0, 0)
                Wait(200)
                while pousse do
                    Wait(5)
                    -- ShowHelpNotification( 'Appuyer sur ~INPUT_MOVE_LEFT_ONLY~ pour aller à gauche et ~INPUT_CONTEXT~ pour aller à droite', false)

                    local speed = GetFrameTime() * 50
                    if IsDisabledControlPressed(0, 34) then
                        SetVehicleSteeringAngle(vehicle, lerpCurrentAngle)
                        lerpCurrentAngle = lerpCurrentAngle + speed
                    elseif IsDisabledControlPressed(0, 9) then
                        SetVehicleSteeringAngle(vehicle, lerpCurrentAngle)
                        lerpCurrentAngle = lerpCurrentAngle - speed
                    else
                        SetVehicleSteeringAngle(vehicle, lerpCurrentAngle)
                        if lerpCurrentAngle < -0.02 then
                            lerpCurrentAngle = lerpCurrentAngle + speed
                        elseif lerpCurrentAngle > 0.02 then
                            lerpCurrentAngle = lerpCurrentAngle - speed
                        else
                            lerpCurrentAngle = 0.0
                        end
                    end

                    if lerpCurrentAngle > 15.0 then
                        lerpCurrentAngle = 15.0
                    elseif lerpCurrentAngle < -15.0 then
                        lerpCurrentAngle = -15.0
                    end

                    if isFront then
                        SetVehicleForwardSpeed(vehicle, -1.0)
                    else
                        SetVehicleForwardSpeed(vehicle, 1.0)
                    end

                    if HasEntityCollidedWithAnything(vehicle) then
                        SetVehicleOnGroundProperly(vehicle)
                    end
                    if not IsDisabledControlPressed(0, 47) then
                        DetachEntity(ped, false, false)
                        StopAnimTask(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
                        FreezeEntityPosition(ped, false)
                        break
                    end
                end
            end
        end
        if pNear then
            Wait(5)
        else
            Wait(500)
        end
    end
end)
