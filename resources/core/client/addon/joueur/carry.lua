local carry = {
	InProgress = false,
	targetSrc = -1,
	type = "",
	personCarrying = {
		animDict = "missfinale_c2mcs_1",
		anim = "fin_c2_mcs_1_camman",
		flag = 49,
	},
	personCarried = {
		animDict = "nm",
		anim = "firemans_carry",
		attachX = 0.27,
		attachY = 0.15,
		attachZ = 0.63,
		flag = 33,
	}
}

local function ensureAnimDict(animDict)
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Wait(0)
		end
	end
	return animDict
end

function CarryPeople(entity)
	if not carry.InProgress then
		local players = NetworkGetPlayerIndexFromPed(entity)
		local sID = GetPlayerServerId(players)
		local targetSrc = sID
		if targetSrc ~= -1 then
			carry.InProgress = true
			carry.targetSrc = targetSrc
			TriggerServerEvent("CarryPeople:sync", targetSrc)
			ensureAnimDict(carry.personCarrying.animDict)
			carry.type = "carrying"
		else
			-- ShowNotification("Personne à proximité !")

			-- New notif
			exports['vNotif']:createNotification({
				type = 'ROUGE',
				-- duration = 5, -- In seconds, default:  4
				content = "~s Personne à proximité !"
			})

		end
	else
		carry.InProgress = false
		ClearPedSecondaryTask(p:ped())
		DetachEntity(p:ped(), true, false)
		TriggerServerEvent("CarryPeople:stop", carry.targetSrc)
		carry.targetSrc = 0
	end
end

Citizen.CreateThread(function()
	local pNear = 500
	while true do
		pNear = 500
		if carry.InProgress then
			if carry.type == "beingcarried" then
				if not IsEntityPlayingAnim(p:ped(), carry.personCarried.animDict, carry.personCarried.anim, 3) then
					TaskPlayAnim(p:ped(), carry.personCarried.animDict, carry.personCarried.anim, 8.0, -8.0, 100000,
						carry.personCarried.flag, 0, false, false, false)
						bypassAntiTeleport = true
				end
			elseif carry.type == "carrying" then
				if modsAdmin.noclip then
					exports['vNotif']:createNotification({
						type = 'ROUGE',
						-- duration = 5, -- In seconds, default:  4
						content = "~s Imposible de porter en noclip !"
					})
					CarryPeople()
				end
				if not IsEntityPlayingAnim(p:ped(), carry.personCarrying.animDict, carry.personCarrying.anim, 3) then
					TaskPlayAnim(p:ped(), carry.personCarrying.animDict, carry.personCarrying.anim, 8.0, -8.0, 100000,
						carry.personCarrying.flag, 0, false, false, false)
						bypassAntiTeleport = true
				end
			end
			pNear = 1
		end
		Wait(pNear)
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if carry.InProgress and carry.type == "carrying" then
			if IsControlJustPressed(0, 73) then
				carry.InProgress = false
				ClearPedSecondaryTask(p:ped())
				DetachEntity(p:ped(), true, false)
				bypassAntiTeleport = false
				TriggerServerEvent("CarryPeople:stop", carry.targetSrc)
				carry.targetSrc = 0
			end
		else
			Wait(2000)
		end
	end
end)

RegisterNetEvent("CarryPeople:syncTarget")
AddEventHandler("CarryPeople:syncTarget", function(targetSrc)
	if isCuffed then return end
	local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSrc))
	carry.InProgress = true
	ensureAnimDict(carry.personCarried.animDict)
	AttachEntityToEntity(p:ped(), targetPed, 0, carry.personCarried.attachX, carry.personCarried.attachY,
		carry.personCarried.attachZ, 0.5, 0.5, 180, false, false, false, false, 2, false)
	carry.type = "beingcarried"
end)

RegisterNetEvent("CarryPeople:cl_stop")
AddEventHandler("CarryPeople:cl_stop", function()
	carry.InProgress = false
	ClearPedSecondaryTask(p:ped())
	DetachEntity(p:ped(), true, false)
	bypassAntiTeleport = false
end)
