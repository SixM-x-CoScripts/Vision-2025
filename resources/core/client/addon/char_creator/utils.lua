function ExitCharCreator(fisrtname, lastname)

	local interior_pos = vector3(399.9, -998.7, -100.0)
	local interior = GetInteriorAtCoordsWithType(interior_pos, "v_mugshot")
	local lineup_male = "mp_character_creation@lineup@male_a"
	local pPed = PlayerPedId()
	local handle
	local board
	local board_model = GetHashKey("prop_police_id_board")
	local board_pos = vector3(409.02, -1000.8, -98.859)
	local board_scaleform
	local overlay
	local overlay_model = GetHashKey("prop_police_id_text")

	local camera_scaleform
	local cam
	local cam2

	function Cleanup()
		ReleaseNamedRendertarget("ID_Text", Citizen.ReturnResultAnyway())
		SetScaleformMovieAsNoLongerNeeded(board_scaleform)
		DeleteObject(overlay)
		DeleteObject(board)
		DetachEntity(overlay, true, false)
		DetachEntity(board, true, false)
		DeleteEntity(overlay)
		DeleteEntity(board)
		ClearAreaOfObjects(
			p:pos().x--[[ number ]] ,
			p:pos().y--[[ number ]] ,
			p:pos().z--[[ number ]] ,
			3.0--[[ number ]] ,
			17--[[ integer ]]
		)
		DestroyCam(cam, true)
		DestroyCam(cam2, true)
		DestroyAllCams(true)
		ReleaseNamedScriptAudioBank("DLC_GTAO/MUGSHOT_ROOM")
		ReleaseNamedScriptAudioBank("Mugshot_Character_Creator")
		RemoveAnimDict(lineup_male)
		ClearPedTasksImmediately(PlayerPedId())
		StopPlayerSwitch()
		UnpinInterior("v_mugshot")
		EndScaleformMovieMethod()
		handle = false
		RenderScriptCams(false, false, 3000, 1, 0, 0)

	end

	AddEventHandler('onResourceStop', function(resource)
		if resource == GetCurrentResourceName() then Cleanup() end
	end)

	function TaskHoldBoard()
		local empty, sequence = OpenSequenceTask(0)
		TaskPlayAnim(pPed, lineup_male, "react_light", 8.0, -8.0, -1, 512, 0, 0, 0, 0)
		TaskPlayAnim(0, lineup_male, "Loop", 8.0, -8.0, -1, 513, 0, 0, 0, 0)
		CloseSequenceTask(sequence)
		ClearPedTasks(PlayerPedId())
		TaskPerformSequence(PlayerPedId(), sequence)
		ClearSequenceTask(sequence)
	end

	function TaskRaiseBoard()
		local empty, sequence = OpenSequenceTask(0)
		TaskPlayAnim(pPed, lineup_male, "low_to_high", 8.0, -8.0, -1, 512, 0, 0, 0, 0)
		TaskPlayAnim(0, lineup_male, "Loop_raised", 8.0, -8.0, -1, 513, 0, 0, 0, 0)
		CloseSequenceTask(sequence)
		ClearPedTasks(PlayerPedId())
		TaskPerformSequence(PlayerPedId(), sequence)
		ClearSequenceTask(sequence)
	end

	function TaskWalkInToRoom()
		local empty, sequence = OpenSequenceTask(0)
		local ped = PlayerPedId()
		local rot = vector3(0.0, 0.0, 0.0)
		TaskPlayAnimAdvanced(pPed, lineup_male, "Intro", board_pos, rot, 8.0, -8.0, -1, 4608, 0, 2, 0)
		TaskPlayAnim(0, lineup_male, "Loop", 8.0, -8.0, -1, 513, 0, 0, 0, 0)
		CloseSequenceTask(sequence)
		ClearPedTasks(ped)
		TaskPerformSequence(ped, sequence)
		ClearSequenceTask(sequence)
	end

	function ConfigCameraUI(bool)
		CallScaleformMethod(camera_scaleform, 'OPEN_SHUTTER', 250)
		if bool then
			CallScaleformMethod(camera_scaleform, 'SHOW_PHOTO_FRAME', false)
			CallScaleformMethod(camera_scaleform, 'SHOW_PHOTO_BORDER', true, -0.7, 0.5, 0.5, 162, 120)
		else
			CallScaleformMethod(camera_scaleform, 'SHOW_REMAINING_PHOTOS', true)
			CallScaleformMethod(camera_scaleform, 'SET_REMAINING_PHOTOS', 0, 1)
			CallScaleformMethod(camera_scaleform, 'SHOW_PHOTO_FRAME', true)
			CallScaleformMethod(camera_scaleform, 'SHOW_PHOTO_BORDER', false)
		end
	end

	function TaskTakePicture()
		local ped = PlayerPedId()

		CallScaleformMethod(camera_scaleform, 'CLOSE_SHUTTER', 250)
		if RequestScriptAudioBank("Mugshot_Character_Creator", false, -1) then
			PlaySound(-1, "Take_Picture", "MUGSHOT_CHARACTER_CREATION_SOUNDS", 0, 0, 1)
		end
		TaskPlayAnim(pPed, lineup_male, "outro", 8.0, -8.0, -1, 513, 0, 0, 0, 0)

		BeginTakeHighQualityPhoto()
		if GetStatusOfTakeHighQualityPhoto() --[[and SaveHighQualityPhoto(-1)]] then

		end
		ConfigCameraUI(true)
		FreeMemoryForHighQualityPhoto()
	end

	function ExitRoom()
		local empty, sequence = OpenSequenceTask(0)
		TaskPlayAnim(pPed, lineup_male, "outro", 8.0, -8.0, -1, 512, 0, 0, 0, 0)
		TaskPlayAnim(0, lineup_male, "outro_loop", 8.0, -8.0, -1, 513, 0, 0, 0, 0)
		CloseSequenceTask(sequence)
		ClearPedTasks(PlayerPedId())
		TaskPerformSequence(PlayerPedId(), sequence)
		ClearSequenceTask(sequence)
		TaskLookAtCoord(PlayerPedId(), GetCamCoord(cam), -1, 10240, 2)
		Modules.UI.RealWait(10240)
		ClearFocus()
		Cleanup()
		handle = false
		ClearPedTasks(pPed)
		StartIntroAnimation()

	end

	function func_1636(cam, f1, f2, f3, f4)
		N_0xf55e4046f6f831dc(cam, f1)
		N_0xe111a7c0d200cbc5(cam, f2)
		SetCamDofFnumberOfLens(cam, f3)
		SetCamDofMaxNearInFocusDistanceBlendLevel(cam, f4)
	end

	CreateThread(function()
		-- SCRIPT::SHUTDOWN_LOADING_SCREEN();
		LoadInterior(interior)
		DoScreenFadeOut(0)

		-- Booth cam
		cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
		SetCamCoord(cam, 416.4084, -998.3806, -99.24789)
		SetCamRot(cam, 0.878834, -0.022102, 90.0173, 2)
		SetCamFov(cam, 36.97171)
		ShakeCam(cam, "HAND_SHAKE", 0.1)
		func_1636(cam, 7.2, 1.0, 0.5, 1.0)

		-- Show booth cam eventually
		Wait(5000)
		ConfigCameraUI(false)
		SetCamActive(cam, true)

		-- Zoomed cam
		cam2 = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
		SetCamCoord(cam2, 412.0216, -997.9448, -98.8) -- In room
		SetCamRot(cam2, 0.865862, -0.01934, 91.04581, 2)
		SetCamFov(cam2, 35.2015)

		while DoesCamExist(cam) do
			if not IsCamInterpolating(cam) and not IsCamInterpolating(cam2) then
				RenderScriptCams(true, false, 3000, 1, 0, 0)
			end
			Wait(0)
		end
	end)

	CreateThread(function()
		Wait(500)
		if IsScreenFadedOut() or IsScreenFadingOut() then
			DoScreenFadeIn(500)
		end
	end)

	CreateThread(function()
		local ped = PlayerPedId()

		-- SetEntityCoords(interior_pos)
		SetPlayerVisibleLocally(PlayerId(), false)
		FreezeEntityPosition(ped, true)
		RequestModel(board_model)
		RequestModel(overlay_model)
		RequestAnimDict(lineup_male);
		RequestScriptAudioBank("DLC_GTAO/MUGSHOT_ROOM", false, -1)
		RequestScriptAudioBank("Mugshot_Character_Creator", false, -1)
        TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)

		while not IsInteriorReady(interior) do Wait(1) end
		while not HasModelLoaded(board_model) or not HasModelLoaded(overlay_model) do Wait(1) end
		while not HasAnimDictLoaded(lineup_male) do Wait(1) end

		board = CreateObject(board_model, board_pos, false, true, false)
		overlay = CreateObject(overlay_model, board_pos, false, true, false)
		AttachEntityToEntity(overlay, board, -1, 4103, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		SetModelAsNoLongerNeeded(board_model)
		SetModelAsNoLongerNeeded(overlay_model)

		SetEntityCoords(ped, board_pos)
		ClearPedWetness(ped)
		ClearPedBloodDamage(ped)
		ClearPlayerWantedLevel(PlayerId())
		SetCurrentPedWeapon(ped, GetHashKey("weapon_unarmed"), 1)
		FreezeEntityPosition(ped, false)
		AttachEntityToEntity(board, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 2, 1)

		-- FIXME
		ClearPedTasksImmediately(ped)
		TaskWalkInToRoom()
		Wait(7000)
		if RequestScriptAudioBank("DLC_GTAO/MUGSHOT_ROOM", false, -1) then
			PlaySoundFrontend(-1, "Lights_On", "GTAO_MUGSHOT_ROOM_SOUNDS", true)
		end

		Wait(500)
		TaskHoldBoard()

		PlaySound(-1, "Zoom_In", "MUGSHOT_CHARACTER_CREATION_SOUNDS", 0, 0, 1)

		if DoesCamExist(cam2) then
			StopCamShaking(cam2)
			SetCamActiveWithInterp(cam2, cam, 300, 1, 1)
		end

		Wait(5000)
		TaskTakePicture()
		Wait(1000)
		ConfigCameraUI(false)
		SetCamActiveWithInterp(cam, cam2, 300, 1, 1)
		PlaySound(-1, "Zoom_Out", "MUGSHOT_CHARACTER_CREATION_SOUNDS", 0, 0, 1)
		ExitRoom()
	end)

	-- Draw the id board
	CreateThread(function()
		board_scaleform = LoadScaleform("mugshot_board_01")
		camera_scaleform = LoadScaleform("digital_camera")
		handle = CreateNamedRenderTargetForModel("ID_Text", overlay_model)

		-- headerStr, numStr, footerStr, importedStr, importedCol, rankNum, rankCol
		CallScaleformMethod(board_scaleform, 'SET_BOARD', fisrtname .. " " .. lastname, 'Citoyen', '001', 'Los Santos', 0, 1)
		CallScaleformMethod(camera_scaleform, 'OPEN_SHUTTER', 250)

		while handle do
			HideHudAndRadarThisFrame()
			SetTextRenderId(handle)
			Set_2dLayer(4)
			SetScriptGfxDrawBehindPausemenu(1)
			DrawScaleformMovie(board_scaleform, 0.405, 0.37, 0.81, 0.74, 255, 255, 255, 255, 0);
			SetScriptGfxDrawBehindPausemenu(1)
			SetTextRenderId(GetDefaultScriptRendertargetRenderId())
			SetScriptGfxDrawBehindPausemenu(1)
			DrawScaleformMovieFullscreen(camera_scaleform, 255, 255, 255, 255, 0);
			SetScriptGfxDrawBehindPausemenu(1)
			Wait(0)
		end
	end)
end

function CreateNamedRenderTargetForModel(name, model)
	local handle = 0
	if not IsNamedRendertargetRegistered(name) then
		RegisterNamedRendertarget(name, 0)
	end
	if not IsNamedRendertargetLinked(model) then
		LinkNamedRendertarget(model)
	end
	if IsNamedRendertargetRegistered(name) then
		handle = GetNamedRendertargetRenderId(name)
	end

	return handle
end

function LoadScaleform(scaleform)
	local handle = RequestScaleformMovie(scaleform)

	if handle ~= 0 then
		while not HasScaleformMovieLoaded(handle) do
			Wait(1)
		end
	end

	return handle
end

function CallScaleformMethod(scaleform, method, ...)
	local t
	local args = { ... }

	BeginScaleformMovieMethod(scaleform, method)

	for k, v in ipairs(args) do
		t = type(v)
		if t == 'string' then
			PushScaleformMovieMethodParameterString(v)
		elseif t == 'number' then
			if string.match(tostring(v), "%.") then
				PushScaleformMovieFunctionParameterFloat(v)
			else
				PushScaleformMovieFunctionParameterInt(v)
			end
		elseif t == 'boolean' then
			PushScaleformMovieMethodParameterBool(v)
		end
	end

	EndScaleformMovieMethod()
end
