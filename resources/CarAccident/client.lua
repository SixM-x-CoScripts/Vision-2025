local effectActive = false;
local blackOutActive = false;
local currAccidentLevel = 0;
local wasInCar = false;
local oldSpeed = 0;
local currentDamage = 0;
local currentSpeed = 0;
local vehicle;

IsCar = function(veh)
	local vc = GetVehicleClass(veh);
	return vc >= 0 and vc <= 7 or vc >= 9 and vc <= 12 or vc >= 17 and vc <= 20;
end;

RegisterNetEvent("crashEffect");
AddEventHandler("crashEffect", function(countDown, accidentLevel, playSound)
	if not effectActive or accidentLevel > currAccidentLevel then
		currAccidentLevel = accidentLevel;
		effectActive = true;
		blackOutActive = true;
		DoScreenFadeOut(100);
		Wait(Config.BlackoutTime);
		DoScreenFadeIn(250);
		blackOutActive = false;
		StartScreenEffect("MP_race_crash", 0, true);
		
		if playSound == 1 then
			SendNUIMessage({
				sound = "accident_effect",
				volume = 0.5
			});
		end;

		SetPedMovementClipset(PlayerPedId(), "MOVE_M@DRUNK@VERYDRUNK", true);
		while countDown > 0 do
			if countDown > 3.5 * accidentLevel then
				ShakeGameplayCam("MEDIUM_EXPLOSION_SHAKE", accidentLevel * Config.ScreenShakeMultiplier);
			end;
			Wait(750);
			countDown = countDown - 1;
			if countDown <= 1 then
				StopScreenEffect("Dont_tazeme_bro");
				StopScreenEffect("MP_race_crash");
				ResetPedMovementClipset(PlayerPedId(), 0);
				SetPedStealthMovement(PlayerPedId(), true, "DEFAULT_ACTION");
			end;
		end;
		currAccidentLevel = 0;
		effectActive = false;
	end;
end);

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10);
		vehicle = GetVehiclePedIsIn(PlayerPedId(-1), false);
		if DoesEntityExist(vehicle) and (wasInCar or IsCar(vehicle)) then
			wasInCar = true;
			oldSpeed = currentSpeed;
			currentSpeed = GetEntitySpeed(vehicle) * 2.23;
			if currentSpeed > 0 then
				if not effect then 
					if oldSpeed - currentSpeed >= Config.BlackoutSpeedRequiredLevel5 then
						TriggerEvent("crashEffect", Config.EffectTimeLevel5, 5, 1);
					elseif oldSpeed - currentSpeed >= Config.BlackoutSpeedRequiredLevel4 then
						TriggerEvent("crashEffect", Config.EffectTimeLevel4, 4, 1);
					elseif oldSpeed - currentSpeed >= Config.BlackoutSpeedRequiredLevel3 then
						TriggerEvent("crashEffect", Config.EffectTimeLevel3, 3, 1);
					elseif oldSpeed - currentSpeed >= Config.BlackoutSpeedRequiredLevel2 then
						TriggerEvent("crashEffect", Config.EffectTimeLevel2, 2, 0);
					elseif oldSpeed - currentSpeed >= Config.BlackoutSpeedRequiredLevel1 then
						TriggerEvent("crashEffect", Config.EffectTimeLevel1, 1, 0);
					end;
				end;
			end;
		elseif wasInCar then
			wasInCar = false;
			beltOn = false;
			currentSpeed = 0;
			oldSpeed = 0;
		end;
	end;
end);
