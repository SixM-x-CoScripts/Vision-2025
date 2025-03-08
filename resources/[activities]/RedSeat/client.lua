--[Développé par RED (github.com/ImRedTV)]

--[Choisir son siège]

local checkInterval = 2000

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local vehicle = GetClosestVehicle(playerCoords, 5.0, 0, 71)
        local vehpos = GetEntityCoords(vehicle)
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) and #(playerCoords - vehpos) < 3 and GetVehicleDoorLockStatus(vehicle) == 0 and DoesVehicleHaveDoor(vehicle, 2) then
            checkInterval = 10
            
            local bldoor = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "window_lr"))
            local brdoor = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "window_rr"))
            local frdoor = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "window_rf"))
            local distanceToBrdoor = #(playerCoords - brdoor)
            local distanceToBldoor = #(playerCoords - bldoor)
            local distanceToFrdoor = #(playerCoords - frdoor)
            
            if distanceToBrdoor < 0.9 and DoesVehicleHaveDoor(vehicle, 2) and not DoesEntityExist(GetPedInVehicleSeat(vehicle, 2)) and GetVehicleDoorLockStatus(vehicle) ~= 2 then
                if IsControlJustPressed(1, 49) then
                    TaskEnterVehicle(playerPed, vehicle, 10000, 2, 1.0, 1, 0)
                end
            elseif distanceToBldoor < 0.9 and DoesVehicleHaveDoor(vehicle, 2) and not DoesEntityExist(GetPedInVehicleSeat(vehicle, 1)) and GetVehicleDoorLockStatus(vehicle) ~= 2 then
                if IsControlJustPressed(1, 49) then
                    TaskEnterVehicle(playerPed, vehicle, 10000, 1, 1.0, 1, 0)
                end
            elseif distanceToFrdoor < 0.9 and DoesVehicleHaveDoor(vehicle, 1) and not DoesEntityExist(GetPedInVehicleSeat(vehicle, 0)) and GetVehicleDoorLockStatus(vehicle) ~= 2 then
                if IsControlJustPressed(1, 49) then
                    TaskEnterVehicle(playerPed, vehicle, 10000, 0, 1.0, 1, 0)
                end
            end
        else
            checkInterval = 2000
        end
		Citizen.Wait(checkInterval)
    end
end)

--[Bloquer la position du passager avant]

-- local actionkey=21 --Lshift
-- local allowshuffle = false
-- local playerped=nil
-- local currentvehicle=nil

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(100)
-- 		playerped=PlayerPedId()
-- 		currentvehicle=GetVehiclePedIsIn(playerped, false)
-- 	end
-- end)


-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(100)
-- 		if IsPedInAnyVehicle(playerped, false) and allowshuffle == false then
-- 			SetPedConfigFlag(playerped, 184, true)
-- 			if GetIsTaskActive(playerped, 165) then
-- 				seat=0
-- 				if GetPedInVehicleSeat(currentvehicle, -1) == playerped then
-- 					seat=-1
-- 				end
-- 				SetPedIntoVehicle(playerped, currentvehicle, seat)
-- 			end
-- 		elseif IsPedInAnyVehicle(playerped, false) and allowshuffle == true then
-- 			SetPedConfigFlag(playerped, 184, false)
-- 		end
-- 	end
-- end)


-- RegisterNetEvent("SeatShuffle")
-- AddEventHandler("SeatShuffle", function()
-- 	if IsPedInAnyVehicle(playerped, false) then
-- 		seat=0
-- 		if GetPedInVehicleSeat(currentvehicle, -1) == playerped then
-- 			seat=-1
-- 		end
-- 		if GetPedInVehicleSeat(currentvehicle,-1) == playerped then
-- 			TaskShuffleToNextVehicleSeat(playerped,currentvehicle)
-- 		end
-- 		allowshuffle=true
-- 		while GetPedInVehicleSeat(currentvehicle,seat) == playerped do
-- 			Citizen.Wait(0)
-- 		end
-- 		allowshuffle=false
-- 	else
-- 		allowshuffle=false
-- 		CancelEvent('SeatShuffle')
-- 	end
-- end)


-- local elapsed=0
-- Citizen.CreateThread(function()
--   while true do
-- 	Citizen.Wait(0)
-- 	elapsed=0
-- 	while IsControlPressed(0,actionkey) and GetIsTaskActive(playerped, 165) do
-- 		Citizen.Wait(100)
-- 		elapsed=elapsed+0.1
-- 	end
--   end
-- end)



-- Citizen.CreateThread(function()
--   while true do
-- 	if IsControlJustPressed(1, actionkey) then -- Lshift
-- 	   TriggerEvent("SeatShuffle")
--     end
-- 	if IsControlJustReleased(1, actionkey) and allowshuffle == true then 
-- 		threshhold=0.8
-- 	   if GetIsTaskActive(playerped, 165) and elapsed < threshhold then
-- 			allowshuffle=false
-- 	   end
--     end
--     Citizen.Wait(0)
--   end
-- end)