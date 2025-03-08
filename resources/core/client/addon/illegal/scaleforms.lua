local Cracking = false
local sceneSetup = false
local gStatus

RegisterNetEvent("shoprobbery:safecracking:loop")
AddEventHandler("shoprobbery:safecracking:loop", function(difficulty, index)
	loadSafeTexture()
	loadSafeAudio()
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
	OpenTutoFAInfo("Braquage", "Tourne pour obtenir le bon numéro, un son sera joué")

	closedString = "lock_closed"
	Cracking = true
	mybasepos = GetEntityCoords(PlayerPedId())
	numbers = 1
    busy = true
    TriggerServerEvent('shoprobbery:server:sync', 'safecrack', index)
	local pinfall = false
    SafeCrackAnim(1)
	while Cracking do
        ShowHelpNotification('~INPUT_FRONTEND_LEFT~ ~INPUT_FRONTEND_RIGHT~ Tourner\n~INPUT_FRONTEND_RDOWN~ Tester')
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
			SafeCrackCallback(false)
		end
		if curLock > difficulty then
			Cracking = false
			SafeCrackCallback(true)
            gStatus = true
		end
		if IsControlJustPressed(0, 202) then
			Cracking = false
			SafeCrackCallback('Escaped')
            RenderScriptCams(false, true, 1500, true, false)
            DestroyCam(cam, false)
            DeleteObject(bag)
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent('shoprobbery:server:sync', 'safecrack', index)
            busy = false
            sceneSetup = false
        end
        if IsDisabledControlPressed(0, 191) then
            if safelock ~= desirednum then
                i = 0.0
            end
        end
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
	exports['tuto-fa']:HideStep()
end)

function SafeCrackAnim(anim, index)
    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)
    loadAnimDict("mini@safe_cracking")
    --sceneObject = GetClosestObjectOfType(pedCo, 2.0, GetHashKey('p_v_43_safe_s'), 0, 0, 0)
    sceneObject = GetClosestObjectOfType(pedCo, 2.0, -1375589668, 0, 0, 0)
    print("sceneObject", sceneObject)
    NetworkRegisterEntityAsNetworked(sceneObject)
    TakeControlSafe(sceneObject)
    sceneRot = GetEntityRotation(sceneObject) + vector3(0.0, 0.0, 90.0)
    local offsetCoord = GetOffsetFromEntityInWorldCoords(sceneObject, -0.35, 0.30, 0.0)
    scenePos = offsetCoord - GetAnimInitialOffsetPosition("mini@safe_cracking", "door_open_succeed_stand_safe", 0.0, 0.0, 0.0, sceneRot, 0, 2)
    if anim == 1 then
        scene = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, true, 1065353216, 0, 1.0)
        NetworkAddPedToSynchronisedScene(ped, scene, "mini@safe_cracking", 'dial_turn_clock_normal', 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkStartSynchronisedScene(scene)
    elseif anim == 2 then
        scene = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, false, 1065353216, 0, 1.0)
        NetworkAddPedToSynchronisedScene(ped, scene, "mini@safe_cracking", 'door_open_succeed_stand', 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(sceneObject, scene, "mini@safe_cracking", 'door_open_succeed_stand_safe', 8.0, 8.0, 137)
        NetworkStartSynchronisedScene(scene)
        Wait(2350)
        return true
    end
end

function StartSafeCrack(Difficulty, Index, CallBack)
	SafeCrackCallback = CallBack
	TriggerEvent("shoprobbery:safecracking:loop", Difficulty, Index)
end

function loadSafeTexture()
	RequestStreamedTextureDict( "MPSafeCracking", false );
	while not HasStreamedTextureDictLoaded( "MPSafeCracking" ) do
		Citizen.Wait(0)
	end
end

function loadSafeAudio()
	RequestAmbientAudioBank( "SAFE_CRACK", false )
end

function SafeCrackStart(index)
    local bool = nil
    Citizen.CreateThread(function()
        busy = true
        StartSafeCrack(2, index, function(status)
        end)
        Cracking = true
        while Cracking do
            Wait(1)
        end
        if gStatus then
            gStatus = false
            bool = SafeCrackSuccess(index)
        end
    end)
    while bool == nil do 
        Wait(1)
    end
    return bool
end

function SafeCrackSuccess(index)
    local bool = SafeCrackAnim(2, index)
    ClearPedTasks(PlayerPedId())
    busy = false
    Cracking = false
    sceneSetup = false
    gStatus = nil
    robber = true
    return bool
end

function TakeControlSafe(ent)
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

