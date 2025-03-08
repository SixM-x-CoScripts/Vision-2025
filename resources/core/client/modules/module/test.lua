-- RegisterCommand("car", function(source, args, rawCommand)
--     if p:getPermission() >= 1 then
--         local model = Modules.World.LoadModel(args[1])
--         local vehicle = CreateVehicle(model, Modules.Player.GetPos(), Modules.Player.GetHeading(), true, true)
--         TaskWarpPedIntoVehicle(Modules.Player.GetPed(), vehicle, -1)
--     end
-- end, false)

-- RegisterCommand("dv", function(source, args, rawCommand)
--     if p:getPermission() >= 1 then
--         DeleteVehicle(Modules.Player.GetCurrentVehicle())
--     end
-- end, false)

-- RegisterCommand("day", function(source, args, rawCommand)
--     NetworkOverrideClockTime(12, 00, 00)
-- 	SetWeatherTypeNowPersist("EXTRASUNNY")
-- 	SetWeatherTypePersist("EXTRASUNNY")
-- 	SetWeatherTypeNow("EXTRASUNNY")
-- end, false)

-- RegisterCommand("night", function(source, args, rawCommand)
--     NetworkOverrideClockTime(23, 00, 00)
-- 	SetWeatherTypeNowPersist("EXTRASUNNY")
-- 	SetWeatherTypePersist("EXTRASUNNY")
-- 	SetWeatherTypeNow("EXTRASUNNY")
-- end, false)

-- RegisterCommand('upgrade', function(source, args, rawCommand)
--     local pVeh = Modules.Player.GetCurrentVehicle()
--     SetVehicleModKit(pVeh, 0)
--     for i = 1,49 do
--         local max = GetNumVehicleMods(pVeh, i)
--         SetVehicleMod(pVeh, i, math.random(0,max), true)

--     end
--     print(GetNumVehicleMods(pVeh, 11))
--     SetVehicleMod(pVeh, 11, GetNumVehicleMods(pVeh, 11) - 1, true)
--     print(GetVehicleMod(pVeh, 11))
--     SetVehicleMod(pVeh, 12, GetNumVehicleMods(pVeh, 12) - 1, true)
--     SetVehicleMod(pVeh, 13, GetNumVehicleMods(pVeh, 13) - 1, true)
--     SetVehicleMod(pVeh, 14, GetNumVehicleMods(pVeh, 14) - 1, true)
--     SetVehicleMod(pVeh, 15, GetNumVehicleMods(pVeh, 15) - 1, true)
--     ToggleVehicleMod(pVeh, 18, true)
--     ToggleVehicleMod(pVeh, 22, true)

--     SetVehicleNitroEnabled(pVeh, true)
-- end, false)
