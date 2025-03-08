local Chests = {
	vector4(-2084.6096191406, -1011.0321655273, 4.8841257095337, 249.0-180),
	vector4(-2072.1257324219, -1024.3604736328, 4.8841271400452, 70.0 - 180),
}

local Ped = {
	model = "mp_m_boatstaff_01",
	pos = vector4(-2085.7568359375, -1017.8496704102, 11.78191280365, 74.325202941895)
}

local SafeCrackObj = {}
local hideAll = false
local PedYacht
CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do Wait(332) end
	Wait(15000)
	local ped = entity:CreatePedLocal(Ped.model, Ped.pos)
	PedYacht = ped.id
	ped:setFreeze(true)
	SetEntityAsMissionEntity(ped.id, 0, 0)
	SetBlockingOfNonTemporaryEvents(ped.id, true)
	SetPedFleeAttributes(ped.id, 0, 0)
	SetPedCombatAttributes(ped.id, 46, true)
	SetPedFleeAttributes(ped.id, 0, 0)
	ped = ped.id
	RequestModel(GetHashKey('p_v_43_safe_s'))
	while not HasModelLoaded(GetHashKey('p_v_43_safe_s')) do Wait(1) end
	for k,v in pairs(Chests) do
		SafeCrackObj[k] = CreateObject(GetHashKey('p_v_43_safe_s'), v.xyz, 0)
		SetEntityHeading(SafeCrackObj[k], v.w)
		FreezeEntityPosition(SafeCrackObj[k], true)
	end
	local hideFirst = false
	while true do 
		Wait(1)
		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(ped)) < 10.0 then 
			if CanAccessAction('Yatch') then
				if IsPedArmed(PlayerPedId(), 4) then
					if not hideFirst then
						Bulle.create("pedYacht1", GetEntityCoords(ped) + vector3(0.0, 0.0, 1.0), "bulleBraquer", true)
					else
						if not hideAll then
							Bulle.create("pedYacht2", GetEntityCoords(ped) + vector3(0.0, 0.0, 1.0), "bulleAttacher")
						end
					end
					if IsControlJustPressed(0, 38) then 
						if not hideAll then
							if hideFirst then
								TriggerSecurEvent('core:makeCall', "lspd", p:pos(), true, "Braquage d'un yacht", false, "illegal")
								TriggerSecurEvent('core:makeCall', "lssd", p:pos(), true, "Braquage d'un yacht", false, "illegal")

								TriggerServerEvent('core:createDispatchCallOnMDT', "LSPD", "Braquage d'un yacht", p:pos())						
								TriggerServerEvent('core:createDispatchCallOnMDT', "LSSD", "Braquage d'un yacht", p:pos())				

								p:PlayAnim('mp_arresting', 'a_uncuff', 1)
								Modules.UI.RealWait(4000)
								ClearPedTasks(p:ped())
								ClearPedTasks(ped)
								PlayEmoteOnPed(ped, "mp_arresting", "idle", 49, -1)
								OpenTutoFAInfo("Yacht", "Cherche les coffres pour les déverrouiller")
								Wait(2000)
								PlayEmoteOnPed(ped, "random@arrests@busted", "idle_a", 1, -1)     
								hideAll = true
								Bulle.hide("pedYacht2")
								Bulle.remove("pedYacht2")
							else
								Bulle.hide("pedYacht1")
								Bulle.remove("pedYacht1")
								hideFirst = true
							end
						end
					end
				else
					Wait(1000)
				end
			else
				Wait(60000)
			end
		else
			Wait(2000)
		end
	end
end)

local Cracking = false
local sceneSetup = false
local gStatus
local pickupLoop = false

function SafeCrackAnim2(anim, index, addh)
	local ped = PlayerPedId()
	local pedCo = GetEntityCoords(ped)
	loadAnimDict("mini@safe_cracking")
	sceneObject = GetClosestObjectOfType(pedCo, 3.0, GetHashKey('p_v_43_safe_s'), 0, 0, 0)
	while sceneObject == -1 or sceneObject == 0 do 
		Wait(1)
		print("wait")
	end
	NetworkRegisterEntityAsNetworked(sceneObject)
	TakeControl2(sceneObject)
	sceneRot = GetEntityRotation(sceneObject) + vector3(0.0, 0.0, 90.0)
	scenePos = GetEntityCoords(sceneObject) - GetAnimInitialOffsetPosition("mini@safe_cracking", "door_open_succeed_stand_safe", 0.0, 0.0, 0.0, sceneRot, 0, 2)
	if anim == 1 then
		scene = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, true, 1065353216, 0, 1.0)
		NetworkAddPedToSynchronisedScene(ped, scene, "mini@safe_cracking", 'dial_turn_clock_normal', 1.5, -4.0, 1, 16, 1148846080, 0)
		NetworkStartSynchronisedScene(scene)
	elseif anim == 2 then
		scene = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, false, 1065353216, 0, 1.0)
		NetworkAddPedToSynchronisedScene(ped, scene, "mini@safe_cracking", 'door_open_succeed_stand', 1.5, -4.0, 1, 16, 1148846080, 0)
		NetworkAddEntityToSynchronisedScene(sceneObject, scene, "mini@safe_cracking", 'door_open_succeed_stand_safe', 8.0, 8.0, 137)
		NetworkStartSynchronisedScene(scene)
		local offsetCoord = GetOffsetFromEntityInWorldCoords(sceneObject, 0.0, 0.0, 0.1)
		local offsetCoord2 = GetOffsetFromEntityInWorldCoords(sceneObject, 0.0, 0.0, -0.65)
		RequestModel(GetHashKey("prop_cash_case_02"))
		while not HasModelLoaded(GetHashKey("prop_cash_case_02")) do Wait(1) end
		local pickup = CreateObject(GetHashKey("prop_cash_case_02"), offsetCoord, 0)
		local pickup2 = CreateObject(GetHashKey("prop_cash_case_02"), offsetCoord2, 0)
		local objectRot = GetEntityRotation(pickup)
		SetEntityRotation(pickup, objectRot.x, objectRot.y, objectRot.z+addh)
		local objectRot2 = GetEntityRotation(pickup2)
		SetEntityRotation(pickup2, objectRot2.x, objectRot2.y, objectRot2.z+addh)
		Wait(5000)
		PlayEntityAnim(sceneObject, "DOOR_OPEN_SUCCEED_STAND_SAFE", "mini@safe_cracking", 8.0, false, true, 0, 0.96, 262144)
		pickupLoop = true
		Bulle.create("ramasserYacht", GetEntityCoords(pickup), "bulleRamasserDollar", true)
		local pickupCo = GetEntityCoords(pickup)
		Citizen.CreateThread(function()
			while pickupLoop do
				local ped = PlayerPedId()
				local pedCo = GetEntityCoords(ped)
				local dist  = #(pedCo - pickupCo)
				if dist <= 1.5 then
					if IsControlJustPressed(0, 38) then
						if DoesEntityExist(pickup) then
							p:PlayAnim("mini@repair","fixing_a_ped",1,-1)
							Wait(1500)
							ClearPedTasks(PlayerPedId())
							DeleteObject(pickup)
							local var = GetVariable("heist").yacht
							if var then
								local money = math.random(var.winMinCoffre,var.winMaxCoffre)
								exports['vNotif']:createNotification({
									type = 'DOLLAR',
									content = ("Vous avez récupéré ~s %s$"):format(money)
								})
								p:AddItem("money", money, {})
							else
								local money = math.random(100,500)
								exports['vNotif']:createNotification({
									type = 'DOLLAR',
									content = ("Vous avez récupéré ~s %s$"):format(money)
								})
								p:AddItem("money", money, {})
							end
						else
							if DoesEntityExist(pickup2) then
								Bulle.hide("ramasserYacht")
								p:PlayAnim("random@domestic","pickup_low",1,-1)
								Wait(1000)
								ClearPedTasks(PlayerPedId())
								DeleteObject(pickup2)
								local var = GetVariable("heist").yacht
								if var then
									local money = math.random(var.winMinCoffre,var.winMaxCoffre)
									exports['vNotif']:createNotification({
										type = 'DOLLAR',
										content = ("Vous avez récupéré ~s %s$"):format(money)
									})
									p:AddItem("money", money, {})
								else
									local money = math.random(100,500)
									exports['vNotif']:createNotification({
										type = 'DOLLAR',
										content = ("Vous avez récupéré ~s %s$"):format(money)
									})
									p:AddItem("money", money, {})
								end
								pickupLoop = false
								break
							end
						end
					end
				end
				Citizen.Wait(1)
			end
		end)
	end
end

function StartSafeCrack2(Difficulty, Index, CallBack)
	SafeCrackCallback = CallBack
	TriggerEvent("shoprobbery:safecracking:loop", Difficulty, Index)
end

function loadSafeTexture2()
	RequestStreamedTextureDict( "MPSafeCracking", false );
	while not HasStreamedTextureDictLoaded( "MPSafeCracking" ) do
		Citizen.Wait(0)
	end
end

function loadSafeAudio2()
	RequestAmbientAudioBank( "SAFE_CRACK", false )
end
	
function TakeControl2(ent)
	if DoesEntityExist(ent) then
		local timer = GetGameTimer() + 7500
		while not NetworkHasControlOfEntity(ent) do
			Wait(50)
			NetworkRequestControlOfEntity(ent)
			NetworkRegisterEntityAsNetworked(ent)
			if timer < GetGameTimer() or not DoesEntityExist(ent) then 
				return false 
			end
		end
		return true
	end
	return false
end



StartSafeCrack2Script = function(difficulty, index)
	OpenTutoFAInfo("Yacht", "Deverouillez le coffre en utilisant les fleches directionnelles")
	loadSafeTexture2()
	loadSafeAudio2()
	difficultySetting = {}
	for z = 1, difficulty do
		difficultySetting[z] = 1
	end
	curLock = 1
	factor = difficulty
	i = 0.0
	safelock = 0
	desirednum = math.floor(math.random(99))
	if desirednum == 0 then desirednum = 1 end
	openString = "lock_open"
	closedString = "lock_closed"
	Cracking = true
	mybasepos = GetEntityCoords(PlayerPedId())
	numbers = 1
	busy = true
	local pinfall = false
	SafeCrackAnim2(1)
	while Cracking do
		DisableControlAction(38, 0, true)
		DisableControlAction(44, 0, true)
		DisableControlAction(74, 0, true)
		DisableControlAction(191, 0, true)
		if IsControlPressed(0, 189) then
			if numbers > 1 then
				i = i + 1.8
				PlaySoundFrontend( 0, "TUMBLER_TURN", "SAFE_CRACK_SOUNDSET", true );
				numbers = 0
			end
		end
		if IsControlPressed(0, 190) then
			if numbers > 1 then
				i = i - 1.8
				PlaySoundFrontend( 0, "TUMBLER_TURN", "SAFE_CRACK_SOUNDSET", true );
				numbers = 0
			end
		end
		numbers = numbers + 0.2
		if i < 0.0 then i = 360.0 end
		if i > 360.0 then i = 0.0 end
		safelock = math.floor(100-(i / 3.6))
		if #(mybasepos - GetEntityCoords(PlayerPedId())) > 2 then
			Cracking = false
			return false
		end
		if curLock > difficulty then
			Cracking = false
			gStatus = true
			return true
		end
		if IsControlJustPressed(0, 202) then
			Cracking = false
			RenderScriptCams(false, true, 1500, true, false)
			DestroyCam(cam, false)
			DeleteObject(bag)
			ClearPedTasks(PlayerPedId())
			TriggerServerEvent('shoprobbery:server:sync', 'safecrack', index)
			busy = false
			sceneSetup = false
			return false
		end
		--print("safelock == desirednum", safelock, desirednum)
		if safelock == desirednum then
			if not pinfall then
				PlaySoundFrontend( 0, "TUMBLER_PIN_FALL", "SAFE_CRACK_SOUNDSET", true );
				pinfall = true
			end
			if IsDisabledControlPressed(0, 191) then
				pinfall = false
				PlaySoundFrontend( 0, "TUMBLER_RESET", "SAFE_CRACK_SOUNDSET", true );
				factor = factor / 2
				i = 0.0
				safelock = 0
				desirednum = math.floor(math.random(99))
				if desirednum == 0 then desirednum = 1 end
				difficultySetting[curLock] = 0
				curLock = curLock + 1
			end
		else
			pinfall = false
		end
		DrawSprite( "MPSafeCracking", "Dial_BG", 0.65, 0.5, 0.3, GetAspectRatio() * 0.3, 0, 255, 255, 255, 255, 255 )
		DrawSprite( "MPSafeCracking", "Dial", 0.65, 0.5, 0.3 * 0.5, GetAspectRatio() * 0.3 * 0.5, i, 255, 255, 255, 255 )
		addition = 0.70
		xaddition = 0.58
		for x = 1, difficulty do
			if difficultySetting[x] ~= 1 then
				DrawSprite( "MPSafeCracking", openString, xaddition, addition, 0.03, GetAspectRatio() * 0.03, 0, 255, 255, 255, 255)
			else
				DrawSprite( "MPSafeCracking", closedString, xaddition, addition, 0.03, GetAspectRatio() * 0.03, 0, 255, 255, 255, 255)
			end
			xaddition = xaddition + 0.05
			if x == 10 or x == 20 or x == 30 then
				addition = 0.25
				xaddition = xaddition + 0.05
			end
		end
		Wait(1)
	end
end

local hasloot = {}
CreateThread(function()
	while not Bulle do Wait(1) end
	for k,v in pairs(Chests) do
		Bulle.create("ouvrircoffreYacht" .. k, vector3(v.xyz) + vector3(0.0, 0.0, 1.0), "bulleOuvrirCadenas", true)
	end
	local timing = 1500
	while true do 
		Wait(timing)
		for k,v in pairs(Chests) do
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(v.xyz)) < 2.0 then 
				timing = 1
				if IsControlJustPressed(0, 38) then 
					if not hasloot[k] then
						if IsEntityPlayingAnim(PedYacht, "random@arrests@busted", "idle_a", 3) or hideAll then   
							Bulle.hide("ouvrircoffreYacht" .. k)
							hasloot[k] = true
							local boolean = StartSafeCrack2Script(1)
							if boolean then 
								exports['tuto-fa']:HideStep()
								SafeCrackAnim2(2, nil, k == 1 and 70.0 or 70.0+180)
							end
						else
							exports['vNotif']:createNotification({
								type = 'ROUGE',
								-- duration = 5, -- In seconds, default:  4
								content = "~c Allez menotter le capitaine pour ouvrir le coffre"
							})
						end
					end
				end
			end
		end
	end
end)