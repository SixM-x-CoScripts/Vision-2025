local holdingCam = false
local usingCam = false
local holdingMic = false
local usingMic = false
local camModel = "prop_v_cam_01"
local camanimDict = "missfinale_c2mcs_1"
local camanimName = "fin_c2_mcs_1_camman"
local actionTime = 10
local mic_net = nil
local cam_net = nil

RegisterNetEvent("vision:togglecamera")
AddEventHandler("vision:togglecamera", function()
    if not holdingCam then
        RequestModel(GetHashKey(camModel))
        while not HasModelLoaded(GetHashKey(camModel)) do
            Wait(100)
        end

        RequestAnimDict(camanimDict)
        while not HasAnimDictLoaded(camanimDict) do
            Wait(100)
        end
        TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)

        local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
        local camspawned = CreateObject(GetHashKey(camModel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
        Wait(100)
        local netid = ObjToNet(camspawned)
        SetNetworkIdExistsOnAllMachines(netid, true)
        NetworkSetNetworkIdDynamic(netid, true)
        SetNetworkIdCanMigrate(netid, false)
        AttachEntityToEntity(camspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
        TaskPlayAnim(GetPlayerPed(PlayerId()), camanimDict, camanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
		RemoveAnimDict(camanimDict)
        cam_net = netid
        holdingCam = true
    else
        ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
        DetachEntity(NetToObj(cam_net), 1, 1)
        DeleteEntity(NetToObj(cam_net))
        cam_net = nil
        holdingCam = false
        usingCam = false
    end
end)

local fov_max = 70.0
local fov_min = 5.0
local zoomspeed = 10.0
local speed_lr = 8.0
local speed_ud = 8.0
local camera = false
local fov = (fov_max+fov_min)*0.5
local shouldshowScaleform = false 
local shouldshowNotif = true
local locked_on_vehicle = nil


local function RotAnglesToVecW(rot) -- input vector3
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z)*num, math.cos(z)*num, math.sin(x))
end

local function GetVehicleInViewWeazel(cam)
	local coords = GetCamCoord(cam)
	local forward_vector = RotAnglesToVecW(GetCamRot(cam, 2))
	--DrawLine(coords, coords+(forward_vector*100.0), 255,0,0,255) -- debug line to show LOS of cam
	local rayhandle = CastRayPointToPoint(coords, coords+(forward_vector*200.0), 10, GetVehiclePedIsIn(PlayerPedId()), 0)
	local _, _, _, _, entityHit = GetRaycastResult(rayhandle)
	if entityHit>0 and IsEntityAVehicle(entityHit) then
		return entityHit
	else
		return nil
	end
end

CreateThread(function()
	while true do
		Wait(1)
		local lPed = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(lPed)
		if not holdingCam then 
			Wait(2000)
		else
			ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour regarder dans la caméra")
		end
		if holdingCam and IsControlJustReleased(0, 38) then
			camera = true
			SetTimecycleModifier("default")
			SetTimecycleModifierStrength(0.3)
			local scaleform = RequestScaleformMovie("security_camera")
			local scaleform2 = RequestScaleformMovie("breaking_news")

			while not HasScaleformMovieLoaded(scaleform) do
				Wait(10)
			end
			while not HasScaleformMovieLoaded(scaleform2) do
				Wait(10)
			end
			local lPed = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(lPed)
			local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
			AttachCamToEntity(cam, lPed, 0.0,0.0,1.0, true)
			SetCamRot(cam, 0.0,0.0,GetEntityHeading(lPed))
			SetCamFov(cam, fov)
			RenderScriptCams(true, false, 0, 1, 0)
			PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
			PushScaleformMovieFunction(scaleform2, "breaking_news")
			PopScaleformMovieFunctionVoid()
			forceHideRadar()
			while camera and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == vehicle) and true do
				if shouldshowNotif then
					ShowHelpNotification("Appuyez sur ~INPUT_CELLPHONE_CANCEL~ pour fermer le mode camera\nAppuyez sur ~INPUT_FRONTEND_RIGHT~ pour naviguer les filtres\nAppuyez sur ~INPUT_ATTACK~ pour bloquer la camera sur un véhicule\nAppuyez sur ~INPUT_DETONATE~ pour cacher ce message")
				end
				if IsControlJustPressed(0, 177) then
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					openRadarProperly()
					camera = false
				end
				if IsControlJustPressed(0, 190) then
					shouldshowScaleform = not shouldshowScaleform
				end
				if IsControlJustPressed(0, 47) then
					shouldshowNotif = not shouldshowNotif
				end
				if IsDisabledControlJustPressed(0, 24) then 
					if locked_on_vehicle then 
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
						locked_on_vehicle = nil
						local rot = GetCamRot(cam, 2) -- All this because I can't seem to get the camera unlocked from the entity
						local fov = GetCamFov(cam)
						local old_cam = cam
						DestroyCam(old_cam, false)
						cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
						AttachCamToEntity(cam, PlayerPedId(), 0.0,0.0,1.0, true)
						SetCamRot(cam, rot, 2)
						SetCamFov(cam, fov)
						RenderScriptCams(true, false, 0, 1, 0)
					else
						local vehicle_detected = GetVehicleInViewWeazel(cam)
						if DoesEntityExist(vehicle_detected) then
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							locked_on_vehicle = vehicle_detected
							Wait(200)
						end
					end
				end
				DisableControlAction(0, 24, true)

				if DoesEntityExist(locked_on_vehicle) then
				--	print("veh exist")
					PointCamAtEntity(cam, locked_on_vehicle, 0.0, 0.0, 0.0, true)
				else
					locked_on_vehicle = nil -- Cam will auto unlock when entity doesn't exist anyway
				end

				local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
				CheckInputRotation(cam, zoomvalue)

				HandleZoom(cam)

				if shouldshowScaleform then
					DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
					DrawScaleformMovie(scaleform2, 0.5, 0.63, 1.0, 1.0, 255, 255, 255, 255)
				end
				Wait(1)
			end
			camera = false
			ClearTimecycleModifier()
			fov = (fov_max+fov_min)*0.5
			RenderScriptCams(false, false, 0, 1, 0)
			SetScaleformMovieAsNoLongerNeeded(scaleform)
			DestroyCam(cam, false)
		end
	end
end)

---------------------------------------------------------------------------
-- Events --
---------------------------------------------------------------------------

-- Activate camera
RegisterNetEvent('camera:Activate')
AddEventHandler('camera:Activate', function()
	camera = not camera
end)

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	local lPed = PlayerPedId()
	if not ( IsPedSittingInAnyVehicle( lPed ) ) then

		if IsControlJustPressed(0,241) then
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,242) then
			fov = math.min(fov + zoomspeed, fov_max)
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	else
		if IsControlJustPressed(0,17) then
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,16) then
			fov = math.min(fov + zoomspeed, fov_max)
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	end
end