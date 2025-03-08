local fov_max = 70.0
local fov_min = 1.0 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 10.0 -- camera zoom speed
local speed_lr = 5.0 -- speed by which the camera pans left-right
local speed_ud = 5.0 -- speed by which the camera pans up-down
local fov = (fov_max+fov_min)*0.5
local binoculars = false

function UseBinocular()
	TriggerEvent("core:CloseInv")
    if IsPedSittingInAnyVehicle(p:ped()) then
        -- ShowNotification("Vous ne pouvez pas utiliser de jumelles dans un véhicule")

		-- New notif
		exports['vNotif']:createNotification({
			type = 'ROUGE',
			-- duration = 5, -- In seconds, default:  4
			content = "~s Vous ne pouvez pas utiliser de jumelles dans un véhicule"
		})

        return
    end
    binoculars = not binoculars

    if binoculars then
        Citizen.CreateThread(function()
            TaskStartScenarioInPlace(p:ped(), "WORLD_HUMAN_BINOCULARS", 0, 1)
            PlayAmbientSpeech1(p:ped(), "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
        end)
        Wait(200)
        SetTimecycleModifier("default")
        SetTimecycleModifierStrength(0.3)
        local scaleform = RequestScaleformMovie("BINOCULARS")
        while not HasScaleformMovieLoaded(scaleform) do
            Wait(10)
        end

        local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

        AttachCamToEntity(cam, p:ped(), 0.0, 0.0, 1.0, true)
        SetCamRot(cam, 0.0, 0.0, GetEntityHeading(p:ped()))
        SetCamFov(cam, fov)
        RenderScriptCams(true, false, 0, 1, 0)
        PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
		PushScaleformMovieFunctionParameterInt(0) -- 0 for nothing, 1 for LSPD logo
		PopScaleformMovieFunctionVoid()

        while binoculars and not IsEntityDead(p:ped()) and not IsPedSittingInAnyVehicle(p:ped()) do
            ShowHelpNotification("Appuyer sur ~INPUT_CELLPHONE_CANCEL~ pour arrêter de regarder")
            if IsControlJustPressed(0, 177) then
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
				ClearPedTasks(PlayerPedId())
				binoculars = false
            end

            local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
			CheckInputRotation(cam, zoomvalue)

			HandleZoom(cam)
			HideHUDThisFrame()

			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
			Wait(1)
        end
    end

    binoculars = false
	ClearTimecycleModifier()
	fov = (fov_max+fov_min)*0.5
	RenderScriptCams(false, false, 0, 1, 0)
	SetScaleformMovieAsNoLongerNeeded(scaleform)
	DestroyCam(cam, false)
	SetNightvision(false)
	SetSeethrough(false)
end

RegisterCommand('debugjumelle', function()
	ClearPedTasks(PlayerPedId())
	binoculars = false
	ClearTimecycleModifier()
	fov = (fov_max+fov_min)*0.5
	RenderScriptCams(false, false, 0, 1, 0)
	SetScaleformMovieAsNoLongerNeeded(scaleform)
	DestroyCam(cam, false)
	SetNightvision(false)
	SetSeethrough(false)
end)

RegisterNetEvent("core:useBinocular")
AddEventHandler("core:useBinocular", function()
    UseBinocular()
end)

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(19) -- weapon wheel
	HideHudComponentThisFrame(1) -- Wanted Stars
	HideHudComponentThisFrame(2) -- Weapon icon
	HideHudComponentThisFrame(3) -- Cash
	HideHudComponentThisFrame(4) -- MP CASH
	HideHudComponentThisFrame(13) -- Cash Change
	HideHudComponentThisFrame(11) -- Floating Help Text
	HideHudComponentThisFrame(12) -- more floating help text
	HideHudComponentThisFrame(15) -- Subtitle Text
	HideHudComponentThisFrame(18) -- Game Stream
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		local new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		local new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	local lPed = p:ped()
	if not ( IsPedSittingInAnyVehicle( lPed ) ) then

		if IsControlJustPressed(0,241) then -- Scrollup
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,242) then
			fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	else
		if IsControlJustPressed(0,17) then -- Scrollup
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,16) then
			fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05) -- Smoothing of camera zoom
	end
end