RegisterNetEvent('persistent-vehicles/register-vehicle')
AddEventHandler('persistent-vehicles/register-vehicle', function (entity, light, forgetAfter)
	local props = _Utils.GetVehicleProperties(entity, light)
	local netid = NetworkGetNetworkIdFromEntity(entity)
	SetNetworkIdAlwaysExistsForPlayer(netid, PlayerId(), true)
	if forgetAfter ~= nil then
		forgetAfter = forgetAfter * 1000
	end
	TriggerServerEvent('persistent-vehicles/server/register-vehicle', netid, props, GetTrailer(entity), forgetAfter)
end)

RegisterNetEvent('persistent-vehicles/update-vehicle')
AddEventHandler('persistent-vehicles/update-vehicle', function (entity, light, forgetAfter)
	local props = _Utils.GetVehicleProperties(entity, light)
	if forgetAfter ~= nil then
		forgetAfter = forgetAfter * 1000
	end
	TriggerServerEvent('persistent-vehicles/server/update-vehicle', props.plate, props, GetTrailer(entity), forgetAfter)
end)

RegisterNetEvent('persistent-vehicles/forget-vehicle')
AddEventHandler('persistent-vehicles/forget-vehicle', function (entity)
	local plate = _Utils.Trim(GetVehicleNumberPlateText(entity))
	TriggerServerEvent('persistent-vehicles/server/forget-vehicle', plate)
end)

RegisterNetEvent('persistent-vehicles/update-vehicle-ped-is-in')
AddEventHandler('persistent-vehicles/update-vehicle-ped-is-in', function (entity, light)
	local entity = GetVehiclePedIsIn(PlayerPedId(-1), false)
	if entity > 0 then
		local props = _Utils.GetVehicleProperties(entity, light)
		TriggerServerEvent('persistent-vehicles/server/update-vehicle', props.plate, props, GetTrailer(entity))
	end
end)

RegisterNetEvent('persistent-vehicles/spawn-vehicles')
AddEventHandler('persistent-vehicles/spawn-vehicles', function (vehicles)
	local updatedNetIds = {}
	local coords = GetEntityCoords(PlayerPedId(-1))
	for i = 1, #vehicles do
		local vehicle = vehicles[i]
		local entity

		-- sometimes onesync reports wrong player cords on server. And sometimes pos is nil from server not getting to update position in time
		if vehicle.pos and Config.respawnDistance < _Utils.DistanceBetweenCoords(coords, vehicle.pos) then
			return
		end

		-- clientside vehicle dupe check
		local possibleDuplicate = _Utils.IsDuplicateVehicle(vehicle.props.plate)
		if possibleDuplicate then
			entity = possibleDuplicate
		else
			
			entity = _Utils.CreateVehicle(vehicle.props.model, vehicle.pos, vehicle.props)
			
			-- throttle otherwise NetworkGetNetworkIdFromEntity fails more often
			Wait(200)
			
			local netid = NetworkGetNetworkIdFromEntity(entity)
			
			-- one last check to ensure we have a valid netid
			if NetworkDoesEntityExistWithNetworkId(netid) then
				if vehicle.trailer then
					local trailerEntity = NetworkGetEntityFromNetworkId(vehicle.trailer.netId)
					if trailerEntity == 0 then
						trailerEntity = _Utils.CreateVehicle(vehicle.trailer.model, vehicle.pos)
						AttachVehicleToTrailer(entity, trailerEntity, 1.0)
					end
				end
				table.insert(updatedNetIds, {netId = NetworkGetNetworkIdFromEntity(entity), plate = vehicle.props.plate})
			else
				DeleteEntity(entity)
			end
		end
	end
	if updatedNetIds[1] ~= nil then
		TriggerServerEvent('persistent-vehicles/done-spawning', updatedNetIds)
	end
end)

function GetTrailer(entity)
	local trailer = nil
	local hasTrailer, trailerEntity = GetVehicleTrailerVehicle(entity)
	if hasTrailer  then
		local trailerNetId = NetworkGetNetworkIdFromEntity(trailerEntity)
		trailer = {model = GetEntityModel(trailerEntity), netId = trailerNetId}
		SetNetworkIdExistsOnAllMachines(trailerNetId, true)
	end
	return trailer
end

Citizen.CreateThread(function() 
	while not DoesEntityExist(PlayerPedId(-1)) do
		Wait(100)
	end
	TriggerServerEvent('persistent-vehicles/new-player') 
end)