
local pedInSameVehicleLast=false
local vehicle
local lastVehicle
local vehicleClass
local fCollisionDamageMult = 0.0
local fDeformationDamageMult = 0.0
local fEngineDamageMult = 0.0
local fBrakeForce = 1.0

local healthEngineLast = 1000.0
local healthEngineCurrent = 1000.0
local healthEngineNew = 1000.0
local healthEngineDelta = 0.0
local healthEngineDeltaScaled = 0.0

local healthBodyLast = 1000.0
local healthBodyCurrent = 1000.0
local healthBodyNew = 1000.0
local healthBodyDelta = 0.0
local healthBodyDeltaScaled = 0.0

local healthPetrolTankLast = 1000.0
local healthPetrolTankCurrent = 1000.0
local healthPetrolTankNew = 1000.0
local healthPetrolTankDelta = 0.0
local healthPetrolTankDeltaScaled = 0.0
local tireBurstLuckyNumber

local tireBurstMaxNumber = RealisticVeh.randomTireBurstInterval * 1200; 										-- the tire burst lottery runs roughly 1200 times per minute
if RealisticVeh.randomTireBurstInterval ~= 0 then tireBurstLuckyNumber = math.random(tireBurstMaxNumber) end	-- If we hit this number again randomly, a tire will burst.


local function isPedDrivingAVehicle()
	local ped = PlayerPedId()
	vehicle = GetVehiclePedIsIn(ped, false)
	if IsPedInAnyVehicle(ped, false) then
		-- Check if ped is in driver seat
		if GetPedInVehicleSeat(vehicle, -1) == ped then
			local class = GetVehicleClass(vehicle)
			-- We don't want planes, helicopters, bicycles and trains

			if class ~= 15 and class ~= 16 and class ~=21 and class ~=13 then
				return true
			end
		end
	end
	return false
end

local function tireBurstLottery()
	local tireBurstNumber = math.random(tireBurstMaxNumber)
	if tireBurstNumber == tireBurstLuckyNumber then
		-- We won the lottery, lets burst a tire.
		if GetVehicleTyresCanBurst(vehicle) == false then return end
		local numWheels = GetVehicleNumberOfWheels(vehicle)
		local affectedTire
		if numWheels == 2 then
			affectedTire = (math.random(2)-1)*4		-- wheel 0 or 4
		elseif numWheels == 4 then
			affectedTire = (math.random(4)-1)
			if affectedTire > 1 then affectedTire = affectedTire + 2 end	-- 0, 1, 4, 5
		elseif numWheels == 6 then
			affectedTire = (math.random(6)-1)
		else
			affectedTire = 0
		end
		SetVehicleTyreBurst(vehicle, affectedTire, false, 1000.0)
		tireBurstLuckyNumber = math.random(tireBurstMaxNumber)			-- Select a new number to hit, just in case some numbers occur more often than others
	end
end

local function isTireBurst(vehicle, tireIndex)
    return IsVehicleTyreBurst(vehicle, tireIndex, false)
end

local function getBurstTireCount(vehicle)
    local burstCount = 0
    
    local tireIndices = {0, 1, 4, 5, 2, 3}
    
    for _, tireIndex in ipairs(tireIndices) do
        if isTireBurst(vehicle, tireIndex) then
            burstCount = burstCount + 1
        end
    end
    
    return burstCount
end

local damageMultiplier = 0.2
Citizen.CreateThread(function()
    while true do
		if isPedDrivingAVehicle() then
			Citizen.Wait(1000)
			
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			
			if vehicle ~= 0 then
				local burstTireCount = getBurstTireCount(vehicle)
				
				if burstTireCount > 0 then
					local engineHealth = GetVehicleEngineHealth(vehicle)
					local newEngineHealth = engineHealth - (burstTireCount * damageMultiplier * 100)
					
					if newEngineHealth < 0 then
						newEngineHealth = 0
					end
					
					SetVehicleEngineHealth(vehicle, newEngineHealth)
				end
			end
		else
			Citizen.Wait(2500)
		end
    end
end)

Citizen.CreateThread(function()
	while true do
		Wait(500)
		local ped = PlayerPedId()
		if isPedDrivingAVehicle() then
			vehicle = GetVehiclePedIsIn(ped, false)
			vehicleClass = GetVehicleClass(vehicle)
			healthEngineCurrent = GetVehicleEngineHealth(vehicle)
			if healthEngineCurrent == 1000 then healthEngineLast = 1000.0 end
			healthEngineNew = healthEngineCurrent
			healthEngineDelta = healthEngineLast - healthEngineCurrent
			healthEngineDeltaScaled = healthEngineDelta * RealisticVeh.damageFactorEngine * RealisticVeh.classDamageMultiplier[vehicleClass]

			healthBodyCurrent = GetVehicleBodyHealth(vehicle)
			if healthBodyCurrent == 1000 then healthBodyLast = 1000.0 end
			healthBodyNew = healthBodyCurrent
			healthBodyDelta = healthBodyLast - healthBodyCurrent
			healthBodyDeltaScaled = healthBodyDelta * RealisticVeh.damageFactorBody * RealisticVeh.classDamageMultiplier[vehicleClass]

			healthPetrolTankCurrent = GetVehiclePetrolTankHealth(vehicle)
			if RealisticVeh.compatibilityMode and healthPetrolTankCurrent < 1 then
				healthPetrolTankLast = healthPetrolTankCurrent
			end
			if healthPetrolTankCurrent == 1000 then healthPetrolTankLast = 1000.0 end
			healthPetrolTankNew = healthPetrolTankCurrent
			healthPetrolTankDelta = healthPetrolTankLast-healthPetrolTankCurrent
			healthPetrolTankDeltaScaled = healthPetrolTankDelta * RealisticVeh.damageFactorPetrolTank * RealisticVeh.classDamageMultiplier[vehicleClass]

			if healthEngineCurrent > RealisticVeh.engineSafeGuard+1 then
				SetVehicleUndriveable(vehicle,false)
			end

			if healthEngineCurrent <= RealisticVeh.engineSafeGuard+1 and RealisticVeh.limpMode == false then
				SetVehicleUndriveable(vehicle,true)
			end

			if vehicle ~= lastVehicle then
				pedInSameVehicleLast = false
			end


			if pedInSameVehicleLast == true then

				if healthEngineCurrent ~= 1000.0 or healthBodyCurrent ~= 1000.0 or healthPetrolTankCurrent ~= 1000.0 then


					local healthEngineCombinedDelta = math.max(healthEngineDeltaScaled, healthBodyDeltaScaled, healthPetrolTankDeltaScaled)

					if healthEngineCombinedDelta > (healthEngineCurrent - RealisticVeh.engineSafeGuard) then
						healthEngineCombinedDelta = healthEngineCombinedDelta * 0.7
					end

					if healthEngineCombinedDelta > healthEngineCurrent then
						healthEngineCombinedDelta = healthEngineCurrent - (RealisticVeh.cascadingFailureThreshold / 5)
					end
					healthEngineNew = healthEngineLast - healthEngineCombinedDelta

					if healthEngineNew > (RealisticVeh.cascadingFailureThreshold + 5) and healthEngineNew < RealisticVeh.degradingFailureThreshold then
						healthEngineNew = healthEngineNew-(0.038 * RealisticVeh.degradingHealthSpeedFactor)
					end

					if healthEngineNew < RealisticVeh.cascadingFailureThreshold then
						healthEngineNew = healthEngineNew-(0.1 * RealisticVeh.cascadingFailureSpeedFactor)
					end

					if healthEngineNew < RealisticVeh.engineSafeGuard then
						healthEngineNew = RealisticVeh.engineSafeGuard
					end

					if RealisticVeh.compatibilityMode == false and healthPetrolTankCurrent < 750 then
						healthPetrolTankNew = 750.0
					end

					-- Prevent negative body damage.
					if healthBodyNew < 0  then
						healthBodyNew = 0.0
					end
				end
			else

				if DoesEntityExist(lastVehicle) then
					fDeformationDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDeformationDamageMult')
					fBrakeForce = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fBrakeForce')
					local newFDeformationDamageMult = fDeformationDamageMult ^ RealisticVeh.deformationExponent	-- Pull the handling file value closer to 1
					if RealisticVeh.deformationMultiplier ~= -1 then SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDeformationDamageMult', newFDeformationDamageMult * RealisticVeh.deformationMultiplier) end  -- Multiply by our factor
					if RealisticVeh.weaponsDamageMultiplier ~= -1 then SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fWeaponDamageMult', RealisticVeh.weaponsDamageMultiplier/RealisticVeh.damageFactorBody) end -- Set weaponsDamageMultiplier and compensate for damageFactorBody

					--Get the CollisionDamageMultiplier
					fCollisionDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fCollisionDamageMult')
					--Modify it by pulling all number a towards 1.0
					local newFCollisionDamageMultiplier = fCollisionDamageMult ^ RealisticVeh.collisionDamageExponent	-- Pull the handling file value closer to 1
					SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fCollisionDamageMult', newFCollisionDamageMultiplier)

					--Get the EngineDamageMultiplier
					fEngineDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fEngineDamageMult')
					--Modify it by pulling all number a towards 1.0
					local newFEngineDamageMult = fEngineDamageMult ^ RealisticVeh.engineDamageExponent	-- Pull the handling file value closer to 1
					SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fEngineDamageMult', newFEngineDamageMult)

					-- If body damage catastrophic, reset somewhat so we can get new damage to multiply
					if healthBodyCurrent < RealisticVeh.cascadingFailureThreshold then
						healthBodyNew = RealisticVeh.cascadingFailureThreshold
					end
					pedInSameVehicleLast = true
				end
			end

			-- set the actual new values
			if healthEngineNew ~= healthEngineCurrent then
				SetVehicleEngineHealth(vehicle, healthEngineNew)
			end
			if healthBodyNew ~= healthBodyCurrent then SetVehicleBodyHealth(vehicle, healthBodyNew) end
			if healthPetrolTankNew ~= healthPetrolTankCurrent then SetVehiclePetrolTankHealth(vehicle, healthPetrolTankNew) end

			-- Store current values, so we can calculate delta next time around
			healthEngineLast = healthEngineNew
			healthBodyLast = healthBodyNew
			healthPetrolTankLast = healthPetrolTankNew
			lastVehicle=vehicle
			if RealisticVeh.randomTireBurstInterval ~= 0 and GetEntitySpeed(vehicle) > 10 then tireBurstLottery() end
		else
			if pedInSameVehicleLast == true then
				-- We just got out of the vehicle
				lastVehicle = GetVehiclePedIsIn(ped, true)
				if DoesEntityExist(lastVehicle) then
					if RealisticVeh.deformationMultiplier ~= -1 then SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fDeformationDamageMult', fDeformationDamageMult) end -- Restore deformation multiplier
					SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fBrakeForce', fBrakeForce)  -- Restore Brake Force multiplier
					if RealisticVeh.weaponsDamageMultiplier ~= -1 then SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fWeaponDamageMult', RealisticVeh.weaponsDamageMultiplier) end	-- Since we are out of the vehicle, we should no longer compensate for bodyDamageFactor
					SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fCollisionDamageMult', fCollisionDamageMult) -- Restore the original CollisionDamageMultiplier
					SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fEngineDamageMult', fEngineDamageMult) -- Restore the original EngineDamageMultiplier
				end
			end
			pedInSameVehicleLast = false
		end
	end
end)
