local GM = { State = { CinemaMode = 0 } }

Citizen.CreateThread(function()
	local hudEnabled = false
	local PlayerPedId, GetVehiclePedIsIn, GetIsVehicleEngineRunning, GetVehicleIndicatorLights, GetVehicleLightsState, SendNUIMessage, GetEntitySpeed, GetVehicleFuelLevel = PlayerPedId, GetVehiclePedIsIn, GetIsVehicleEngineRunning, GetVehicleIndicatorLights, GetVehicleLightsState, SendNUIMessage, GetEntitySpeed, GetVehicleFuelLevel

	while true do
		local ped, waitTime = PlayerPedId(), 1000
		local veh = GetVehiclePedIsIn(ped)

		if veh ~= 0 and GetIsVehicleEngineRunning(veh) and GM.State.CinemaMode == 0 then
			hudEnabled = true
			waitTime = 100

			local shouldUseMetric = ShouldUseMetricMeasurements()
			local _, positionLight, roadLight = GetVehicleLightsState(veh)

			SendNUIMessage({
				showhud = hudEnabled,
				speed = math.ceil(GetEntitySpeed(veh) * (shouldUseMetric and 3.6 or 2.236936)),
				speedUnit = shouldUseMetric and "km/h" or "mph",
				feuPosition = positionLight == 1,
				feuRoute = roadLight == 1,
				clignotantDroite = false,
				clignotantGauche = false,
				fuel = tonumber(100*(GetVehicleFuelLevel(veh)/GetVehicleHandlingFloat(veh, "CHandlingData", "fPetrolTankVolume"))),
				health = GetVehicleEngineHealth(veh) / 10,
			})
		elseif hudEnabled then
			hudEnabled = false
			SendNUIMessage({ showhud = hudEnabled })
		end

		Citizen.Wait(waitTime)
	end
end)

local timeWait = 1000
Citizen.CreateThread(function()
	while true do
		if IsPedInAnyVehicle(PlayerPedId(), true) then
			timeWait = 	0
			HideHudComponentThisFrame(6)
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(8)
			HideHudComponentThisFrame(9)
		else
			timeWait = 1000
		end
		Wait(timeWait)
	end
end)
