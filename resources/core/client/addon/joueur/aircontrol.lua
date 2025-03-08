-- Vehicles to enable/disable air control
local vehicleClassDisableControl = {
    [0] = true,     --compacts --
    [1] = true,     --sedans -
    [2] = true,     --SUV's -
    [3] = true,     --coupes -
    [4] = true,     --muscle -
    [5] = true,     --sport classic -
    [6] = true,     --sport - 
    [7] = true,     --super -
    [8] = false,    --motorcycle -
    [9] = true,     --offroad
    [10] = true,    --industrial
    [11] = true,    --utility
    [12] = true,    --vans
    [13] = false,   --bicycles
    [14] = false,   --boats
    [15] = false,   --helicopter
    [16] = false,   --plane
    [17] = true,    --service
    [18] = true,    --emergency
    [19] = false    --military
}

CreateThread(function()
    local timeinair = 1
    while not p do Wait(100) end
    while true do
        Wait(1)
        local player = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(player, false)
        local vehicleClass = GetVehicleClass(vehicle)
        local playerPermission = p:getPermission()
        if vehicle and playerPermission <= 6 then
            if ((GetPedInVehicleSeat(vehicle, -1) == player) and vehicleClassDisableControl[vehicleClass]) then
                if IsEntityInAir(vehicle) then
                    DisableControlAction(2, 59)
                    DisableControlAction(2, 60)
                    timeinair = timeinair + 1
                else
                    if timeinair > 90 and timeinair < 120 then 
                        Wait(200)
                        if IsVehicleOnAllWheels(GetVehiclePedIsIn(PlayerPedId())) then 
                            local wheels = GetVehicleNumberOfWheels(GetVehiclePedIsIn(PlayerPedId()))
                            local random = math.random(0, 1)
                            if random == 0 then -- 1 chance sur deux
                                local material_id = GetVehicleWheelSurfaceMaterial(GetVehiclePedIsIn(PlayerPedId()), random)
                                if material_id == 4 or material_id == 1 or material_id == 3 or material_id == 64 or material_id == 13 or material_id == 15 or material_id == 7 or material_id == 5 or material_id == 70 or material_id == 56 or material_id == 0 or material_id == 12 then -- All roads
                                    SetVehicleTyreBurst(GetVehiclePedIsIn(PlayerPedId()), random, false, 1000.0)
                                end
                            end
                        end
                    elseif timeinair > 120 then 
                        Wait(200)
                        if IsVehicleOnAllWheels(GetVehiclePedIsIn(PlayerPedId())) then
                            local wheels = GetVehicleNumberOfWheels(GetVehiclePedIsIn(PlayerPedId()))
                            local random = math.random(0, 1)
                            local material_id = GetVehicleWheelSurfaceMaterial(GetVehiclePedIsIn(PlayerPedId()), random)
                            if material_id == 4 or material_id == 1 or material_id == 3 or material_id == 64 or material_id == 13 or material_id == 15 or material_id == 7 or material_id == 5 or material_id == 70 or material_id == 56 or material_id == 0 or material_id == 12 then -- All roads
                                SetVehicleTyreBurst(GetVehiclePedIsIn(PlayerPedId()), random, false, 1000.0)
                            end
                        end
                    end
                    timeinair = 1
                    Wait(200)
                end
            else
                Wait(1000)
            end
        else
            Wait(1000)
            local vehicle, dst = GetClosestVehicle(p:pos())
            if vehicle and dst < 3.5 then
                SetEntityAsMissionEntity(vehicle, true, true)
            end
        end
    end
end)