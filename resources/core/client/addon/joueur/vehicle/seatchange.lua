CreateThread(function()
    while p == nil do
        Wait(1)
    end
    while p:isInVeh() do
        local ped = PlayerPedId()
        local restrictSwitching = false

        if IsPedInAnyVehicle(ped, false) then
            if GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), 0) == ped then
                restrictSwitching = true
            end
        end

        SetPedConfigFlag(ped, 184, restrictSwitching)
        Wait(150)
    end
end)

local function switchSeat(numberseat)

    if IsPedInAnyVehicle(PlayerPedId(), false) and not PlayerUtils.forceEquipWeapon then

        local seatIndex = numberseat - 2

        local speedvehicle = GetVehicleDashboardSpeed(GetVehiclePedIsIn(PlayerPedId(), false))

        --print("seatIndex: " .. seatIndex.." "..GetVehicleDashboardSpeed(GetVehiclePedIsIn(PlayerPedId(), false)))


        if speedvehicle > 0.5 then return end

        --if not (seatIndex < -1 or seatIndex >= 4) then
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)

        if veh ~= nil and veh > 0 then
            CreateThread(function()
                disabled = true
                SetPedIntoVehicle(PlayerPedId(), veh, seatIndex)
                Wait(50)
                disabled = false
            end)
        end

    end
    --end
end

local keys_ = {
    "&",
    "é",
    "\"",
    "'",
}

for a, b in pairs(keys_) do
    RegisterKeyMapping("Seat" .. tostring(a), "Place conducteur " .. a, "keyboard", tostring(a));
    RegisterCommand("Seat" .. tostring(a), function()
        switchSeat(a)
    end, false)
end
