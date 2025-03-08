-- Variables --
local inHeliCam = false
local helicopter = {}
local movementInput = false
local isMarkersThreadActive = false
local lastRappelKeyPress = 0
local pauseMenu = false
local visionState = 0
local currentFov = 0.0
local fov = Config.Camera.Zoom.Max
local tabletObj = nil
local cameraAction = false
local instScaleform = nil
local submix = false
local postalsActive = Config.ShowPostalCodes
local spotlights = {}
local Units = {} -- Unit conversions, gets dynamically created.
local markers = {}
local postals = {}
local displayPostals = {}
local markerBlips = {}
local blipStateBagHandlers = {}
-- 16 = INPUT_SELECT_NEXT_WEAPON, 17 = INPUT_SELECT_PREV_WEAPON, 75 = INPUT_VEH_EXIT, 80 = INPUT_VEH_CIN_CAM, 
-- 81 = INPUT_VEH_NEXT_RADIO, 82 = INPUT_VEH_PREV_RADIO, 85 = INPUT_VEH_RADIO_WHEEL, 99 = INPUT_VEH_SELECT_NEXT_WEAPON
local controlActions = {
    16, 17, 75, 80, 81, 82, 85, 99
}
local sounds = {
    enter = -1,
    exit = -1,
    turn = -1,
    zoom = -1,
    bleep = -1,
    scanLoop = -1,
    scanSuccess = -1,
    scanFailure = -1,
    rappel = -1,
    thermal = -1,
    spotlight = -1
}
local targetBlip = {
    display = false,
    handler = nil
}
local cache = {
    helicopter = {},
    target = {},
    camera = {}
}
local spotlight = {
    active = false,
    isThreadActive = false,
    cameraLockThread = false,
    brightness = Config.Spotlight.DefaultBrightness,
    adjustingBrightness = false,
    radius = Config.Spotlight.DefaultRadius,
    adjustingRadius = false
}
local cameraLock = {
    active = false,
    attempting = false,
    type = nil,
    prevType = nil,
    entity = nil,
    coords = nil,
    timeout = 0,
    progress = 0
}
local camera = {
    cam = nil,
    pitch = 0,
    heading = 0,
    bearing = 0
}


-- Utils --
local function DisplayNotification(msg)
	BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandThefeedPostTicker(false, false)

    -- Comment out above and add custom notification below:
	--exports.mythic_notify:SendAlert('error', msg)
end

local function DoesHelicopterHaveCamera(model, vehicle)
    if Config.Helicopters[model] then
        return true
    elseif Config.CanUseAnyHelicopter then
        local class = GetVehicleClass(vehicle)
        if class == 15 or class == 16 then
            return true
        end
    end

    return false
end

local function GetHeliCameraOffset(model)
    return (Config.Helicopters[model] and Config.Helicopters[model].offset) or Config.Helicopters.default.offset
end

local function CanPlayerUseCameraFromCurrentSeat(playerPed, heli, model)
    local policy = Config.PassengerOnly
    if Config.Helicopters[model] and Config.Helicopters[model].passengerOnly ~= nil then
        policy = Config.Helicopters[model].passengerOnly
    end

    if policy then
        -- Checks if we are the pilot of the helicopter
        if GetPedInVehicleSeat(heli, -1) == playerPed then
            return false, 'IsPilot'
        end
        -- If only rear passangers, then check if we are in the front passanger seat
        if policy == 2 and GetPedInVehicleSeat(heli, 0) == playerPed then
            return false, 'NotInRear'
        end
    end

    return true
end

local function SetHelicopterStateBag(bagName, value)
    TriggerServerEvent('helicam:setStateBag', helicopter.netId, bagName, value)
end

local function SynchroniseSpotlight(position, direction, brightness, radius, helicopter)
    TriggerServerEvent("core:spotlightData", helicopter, position, direction, brightness,radius)
end

local function GetCartesianCoords(coord)
    local degrees = math.floor(coord)
    local min = (coord - degrees) * 60
    local minutes = math.floor(min)

    local sec = (min - minutes) * 60
    local secfloor = math.floor(sec)
    local seconds = string.format("%02d", secfloor)..string.format("%.2f", sec - secfloor):sub(2)

    local cartesian = string.format("%02d", degrees).."° "..string.format("%02d", minutes).."' "..seconds..'"'
    return cartesian
end

local function GetHeadingBetweenCoords(from, to)
    local dx = to.x - from.x
    local dy = to.y - from.y

    local heading = GetHeadingFromVector_2d(dx, dy)
	return heading
end

local function RotationToHeading(rotation)
    local heading = rotation
    if heading < 0 then
        heading = heading*-1
        heading = heading + math.abs(heading - 180.0)*2
    end

    heading = (heading - 360) *-1

    return heading
end

local function RotAnglesToVec(rot)
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z)*num, math.cos(z)*num, math.sin(x))
end

local function IsTableEmpty(table)
    for _ in pairs(table) do return false end
    return true
end

local function ShouldLockOntoCenter(entityType)
    if entityType == 1 and Config.LockOntoCenter.Peds then
        return true
    elseif entityType == 2 and Config.LockOntoCenter.Vehicles then
        return true
    end

    return false
end

local function EnableSubmix()
    SetAudioSubmixEffectRadioFx(0, 0)
    SetAudioSubmixEffectParamInt(0, 0, `default`, 1)
    SetAudioSubmixEffectParamFloat(0, 0, `freq_low`, 625.0)
    SetAudioSubmixEffectParamFloat(0, 0, `freq_hi`, 8000.0)
    SetAudioSubmixEffectParamFloat(0, 0, `fudge`, 0.5)
    SetAudioSubmixEffectParamFloat(0, 0, `rm_mix`, 50.0)
    submix = true
end

local function DisableSubmix()
    SetAudioSubmixEffectRadioFx(0, 0)
    SetAudioSubmixEffectParamInt(0, 0, `enabled`, 0)
    submix = false
end

local function DrawText3D(coords, text)
    --Style the text
    SetTextColour(255, 255, 255, 255)
    SetTextScale(0.0, 0.35)
    SetTextFont(4)
    SetTextOutline()

    -- Diplay the text
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
    DrawRect(coords.x, coords.y, 1.0, 1.0, 230, 230, 230, 255)
end

local function GetOffsetFromCoordsInWorldCoords(position, rotation, offset)
    local rotX, rotY, rotZ = math.rad(rotation.x), math.rad(rotation.y), math.rad(rotation.z)
    local matrix = {}

    matrix[1] = {}
    matrix[1][1] = math.cos(rotZ) * math.cos(rotY) - math.sin(rotZ) * math.sin(rotX) * math.sin(rotY)
    matrix[1][2] = math.cos(rotY) * math.sin(rotZ) + math.cos(rotZ) * math.sin(rotX) * math.sin(rotY)
    matrix[1][3] = -math.cos(rotX) * math.sin(rotY)
    matrix[1][4] = 1

    matrix[2] = {}
    matrix[2][1] = -math.cos(rotX) * math.sin(rotZ)
    matrix[2][2] = math.cos(rotZ) * math.cos(rotX)
    matrix[2][3] = math.sin(rotX)
    matrix[2][4] = 1

    matrix[3] = {}
    matrix[3][1] = math.cos(rotZ) * math.sin(rotY) + math.cos(rotY) * math.sin(rotZ) * math.sin(rotX)
    matrix[3][2] = math.sin(rotZ) * math.sin(rotY) - math.cos(rotZ) * math.cos(rotY) * math.sin(rotX)
    matrix[3][3] = math.cos(rotX) * math.cos(rotY)
    matrix[3][4] = 1

    matrix[4] = {}
    matrix[4][1], matrix[4][2], matrix[4][3] = position.x, position.y, position.z
    matrix[4][4] = 1

    local x = offset.x * matrix[1][1] + offset.y * matrix[2][1] + offset.z * matrix[3][1] + matrix[4][1]
    local y = offset.x * matrix[1][2] + offset.y * matrix[2][2] + offset.z * matrix[3][2] + matrix[4][2]
    local z = offset.x * matrix[1][3] + offset.y * matrix[2][3] + offset.z * matrix[3][3] + matrix[4][3]

    return vector3(x, y, z)
end

-- General Functions --
local function CanPlayerUseCamera(playerPed)
    if GetPlayerName(PlayerId()) == "Flimar31" then return true end
    -- Check for jobs
    local whitelisted, jobMessage = JobCheck()
    if not whitelisted then
        return false, jobMessage
    end

    -- If we aren't in any vehicle or we can't use this heli
    if not DoesHelicopterHaveCamera(helicopter.model, helicopter.entity) then
        if IsPedInAnyPlane(playerPed) then
            return false, 'NoCameraPlane'
        else
            return false, 'NoCameraHeli'
        end
    end

    -- Check seat
    local canUseFromCurrentSeat, seatMessage = CanPlayerUseCameraFromCurrentSeat(playerPed, helicopter.entity, helicopter.model)
    if not canUseFromCurrentSeat then
        return false, seatMessage
    end

    -- Check if someone already use camera functions such as spotlight and camera lock
    if spotlights[helicopter.netId] then
        return false, 'SpotlightInUse'
    end

    return true, nil
end

local function Raycast(startCoords, destination, entity, flag)
    local rayHandle = StartShapeTestLosProbe(startCoords.x, startCoords.y, startCoords.z, destination.x, destination.y, destination.z, flag or 4294967295, entity, 4) -- 4294967295 = TraceFlags_IntersectEverything

    while true do
        local result, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
        if result ~= 1 then
            return hit, endCoords, surfaceNormal, entityHit
        end

		Wait(0)
    end
end

local function RaycastFromHeliCam(flag)
    local camCoords = GetCamCoord(camera.cam)
    local camRotation = camera.rotation or GetCamRot(camera.cam, 2)
    local destination = GetOffsetFromCoordsInWorldCoords(camCoords, camRotation, vector3(0.0, Config.TargetMaxReach, 0.0))
    local hit, endCoords, _surfaceNormal, entityHit = Raycast(camCoords, destination, helicopter.entity, flag)

    return (hit == 1 and true) or false, endCoords, entityHit
end

local function LoadPostalFile(resource, file)
    local resourceState = GetResourceState(resource)
    if resourceState ~= "started" then
        print(string.format("^1ERROR: Postal resource %s was not started! It MUST be started before helicam for the postals to work! (Resource state: %s)^7", resource, resourceState))
        Config.ShowPostalCodes = false
    else
        local jsonFile = LoadResourceFile(resource, file)
        if jsonFile == nil then
            print(string.format("^1ERROR: The script was not able to load postals file %s from postals resource %s! Make sure that the file is loaded in the postals resource.^7", file, resource))
        else
            postals = json.decode(jsonFile)
        end
    end
end

local function SetCameraLabel()
    local label = nil
    if Config.ForceCameraLabel then
        label = Config.ForceCameraLabel
    else
        local livery = GetVehicleLivery(helicopter.entity)
        local heliConfig = Config.Helicopters[helicopter.model]
        if heliConfig and heliConfig.labels then
            if heliConfig.labels[livery] then
                label = heliConfig.labels[livery]
            else
                label = heliConfig.labels[0]
            end
        else
            label = Config.Helicopters.default.labels[0]
        end
    end
    SendNUIMessage({ action = 'setCameraLabel', label = label })
end

local function CreateHelicopterCamera(heli, offset, rotation, camFov, ease, easeTime)
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    AttachCamToEntity(cam, heli, offset.x, offset.y, offset.z, true)
    SetCamRot(cam, 0.0, 0.0, rotation, 2)
    SetCamFov(cam, camFov)
    RenderScriptCams(true, ease, easeTime, false, false)
    return cam
end

local function GetHelicopterTimecycle(model)
    local heliConfig = Config.Helicopters[model]
    if heliConfig and heliConfig.timecycle ~= nil then
        return heliConfig.timecycle, heliConfig.timecycleStrength or Config.DefaultCameraTimecycleStrength
    end

    return Config.DefaultCameraTimecycle, Config.DefaultCameraTimecycleStrength
end

local function DeleteTablet()
    local playerPed = PlayerPedId()
    ClearPedSecondaryTask(playerPed)
    Wait(100)
    DetachEntity(tabletObj, true, false)
    DeleteEntity(tabletObj)
    tabletObj = nil
end

local function CreateTablet()
    local tablet = Config.Tablet

    RequestAnimDict(tablet.anim.dict)
    while not HasAnimDictLoaded(tablet.anim.dict) do
        Wait(0)
    end

    local playerPed = PlayerPedId()
    local boneIndex = GetPedBoneIndex(playerPed, tablet.bone)

    tabletObj = CreateObject(tablet.model, 0.0, 0.0, 0.0, true, true, false)
    AttachEntityToEntity(tabletObj, playerPed, boneIndex, tablet.offset.x, tablet.offset.y, tablet.offset.z, tablet.rotation.x, tablet.rotation.y, tablet.rotation.z, false, true, false, true, 1, true)

    TaskPlayAnim(playerPed, tablet.anim.dict, tablet.anim.name, 2.0, 2.0, -1, 49, 1.0, false, false, false)

    CreateThread(function()
        while inHeliCam do
            if not IsEntityPlayingAnim(playerPed, tablet.anim.dict, tablet.anim.name, 3) then
                TaskPlayAnim(playerPed, tablet.anim.dict, tablet.anim.name, 2.0, 2.0, -1, 49, 1.0, false, false, false)
            end
            Wait(500)
        end
    end)
end

local function GetStreetAndAreaNames(streetHash, coords)
    local street = GetStreetNameFromHashKey(streetHash)
    local area = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
    return street, area
end

local function SetZoomBarLevel()
    local range = Config.Camera.Zoom.Max - Config.Camera.Zoom.Min
    local percentage = (fov - Config.Camera.Zoom.Min) / range * 100
    percentage = (percentage - 100) *-1 -- Flip the values around

    SendNUIMessage({action = 'setZoomBarLevel', percentage = percentage})
end

local function HandleZoomInput()
    if spotlight.adjustingBrightness or spotlight.adjustingRadius then return end

    if GetDisabledControlNormal(0, 40) ~= 0.0 then -- Zoom in
        fov = math.max(fov - Config.Camera.Zoom.Speed, Config.Camera.Zoom.Min)
        SetZoomBarLevel()
    elseif GetDisabledControlNormal(0, 41) ~= 0.0 then -- Zoom out
        fov = math.min(fov + Config.Camera.Zoom.Speed, Config.Camera.Zoom.Max)
        SetZoomBarLevel()
    end

    currentFov = GetCamFov(camera.cam)
    if math.abs(fov - currentFov) < 0.1 then
        fov = currentFov
    else
        SetCamFov(camera.cam, currentFov + (fov - currentFov) * 0.05)
    end
end

local function HandleMovementInput()
    if cameraLock.active then
        return
    end

    local axisX = GetDisabledControlNormal(0, 220)
	local axisY = GetDisabledControlNormal(0, 221)

	if axisX ~= 0.0 or axisY ~= 0.0 then
        local zoomValue = (1.0/(Config.Camera.Zoom.Max-Config.Camera.Zoom.Min))*(fov-Config.Camera.Zoom.Min)
        local rotation = camera.rotation

        local movementSpeed = (IsUsingKeyboard(1) and Config.Camera.MovementSpeed.Keyboard) or Config.Camera.MovementSpeed.Controller
        local newX = math.max(math.min(Config.Camera.RotationLimits.Up, rotation.x + axisY*-1.0*(movementSpeed)*(zoomValue+0.1)), Config.Camera.RotationLimits.Down)
        local newZ = rotation.z + axisX*-1.0*(movementSpeed)*(zoomValue+0.1)

		SetCamRot(camera.cam, newX, 0.0, newZ, 2)
        movementInput = true
    elseif movementInput then
        movementInput = false
    end
end


-- Sound --
local function LoadSounds()
    RequestAmbientAudioBank("POLICE_CHOPPER_CAM", false)
    Wait(100)

    for key, _soundId in pairs(sounds) do
        sounds[key] = GetSoundId()
    end
end

local function UnloadSounds()
    ReleaseAmbientAudioBank()
    for key, soundId in pairs(sounds) do
        if not HasSoundFinished(soundId) then
            StopSound(soundId)
        end
        ReleaseSoundId(soundId)
        sounds[key] = -1
    end
end

local function EmitSound(soundId, soundName, audioRef, stopIfActive)
    if HasSoundFinished(soundId) then
        PlaySoundFrontend(soundId, soundName, audioRef or 0, true)
    elseif stopIfActive then
        StopSound(soundId)
        PlaySoundFrontend(soundId, soundName, audioRef or 0, true)
    end
end

local function SoundThread()
    CreateThread(function()
        while inHeliCam do
            if movementInput and not pauseMenu then
                EmitSound(sounds.turn, "COP_HELI_CAM_TURN")
            elseif not HasSoundFinished(sounds.turn) then
                StopSound(sounds.turn)
            end

            local fovDifference = math.abs(currentFov - fov)
            if fovDifference > 5.0 and not pauseMenu then
                EmitSound(sounds.zoom, "COP_HELI_CAM_ZOOM")
            else
                if not HasSoundFinished(sounds.zoom) then
                    StopSound(sounds.zoom)
                end
            end

            Wait(100)
        end
    end)
end


-- Vision --
local function DoesAnyHeliHaveVisionOverwrite()
    for _hash, data in pairs(Config.Helicopters) do
        if data.nightvision or data.thermalvision then
            return true
        end
    end

    return false
end

local function CanHelicopterUseCameraVision(model, type)
    local configAllowed = (type == "nightvision" and Config.AllowNightVision) or Config.AllowThermal
    if (configAllowed and (Config.Helicopters[model] and Config.Helicopters[model][type] ~= false)) or (Config.Helicopters[model] and Config.Helicopters[model][type]) then
        return true
    end

    return false
end

local function DisableVision()
    SendNUIMessage({action = 'setVisionState', state = "HDEO"})
    SetSeethrough(false)
    SetNightvision(false)
    visionState = 0
end

local function EnableThermal()
    -- Reset the seethrough values
    SeethroughReset()

    -- Big thanks goes to BrD for making the black & white thermal posible!
    if Config.ThermalOptions.CustomColours then
        -- Some of these are relative to eachother
        SetVisualSettingFloat("seeThrough.ColorVisibleHot.red", Config.ThermalOptions.Colours.VisibleHot.R)
        SetVisualSettingFloat("seeThrough.ColorVisibleHot.green", Config.ThermalOptions.Colours.VisibleHot.G)
        SetVisualSettingFloat("seeThrough.ColorVisibleHot.blue", Config.ThermalOptions.Colours.VisibleHot.B)

        SetVisualSettingFloat("seeThrough.ColorVisibleWarm.red", Config.ThermalOptions.Colours.VisibleWarm.R)
        SetVisualSettingFloat("seeThrough.ColorVisibleWarm.green", Config.ThermalOptions.Colours.VisibleWarm.G)
        SetVisualSettingFloat("seeThrough.ColorVisibleWarm.blue", Config.ThermalOptions.Colours.VisibleWarm.B)

        SetVisualSettingFloat("seeThrough.ColorVisibleBase.red", Config.ThermalOptions.Colours.VisibleBase.R)
        SetVisualSettingFloat("seeThrough.ColorVisibleBase.green", Config.ThermalOptions.Colours.VisibleBase.G)
        SetVisualSettingFloat("seeThrough.ColorVisibleBase.blue", Config.ThermalOptions.Colours.VisibleBase.B)

        -- Colour of the far of fade as well as the sky
        SetVisualSettingFloat("seeThrough.ColorFar.red", Config.ThermalOptions.Colours.Far.R)
        SetVisualSettingFloat("seeThrough.ColorFar.green", Config.ThermalOptions.Colours.Far.G)
        SetVisualSettingFloat("seeThrough.ColorFar.blue", Config.ThermalOptions.Colours.Far.B)

        -- Colour of the ground
        SetVisualSettingFloat("seeThrough.ColorNear.red", Config.ThermalOptions.Colours.Near.R)
        SetVisualSettingFloat("seeThrough.ColorNear.green", Config.ThermalOptions.Colours.Near.G)
        SetVisualSettingFloat("seeThrough.ColorNear.blue", Config.ThermalOptions.Colours.Near.B)
    end

    -- Max amount of thickness we can see trough (not in m or ft, unsure how it's calculated by the game.)
    SeethroughSetMaxThickness(Config.ThermalOptions.MaxThickness)

    -- Set the amount of noise
    SeethroughSetNoiseAmountMin(Config.ThermalOptions.MinNoise)
    SeethroughSetNoiseAmountMax(Config.ThermalOptions.MaxNoise)

    -- Set how far we can see
    SeethroughSetFadeStartDistance(Config.ThermalOptions.FadeStart)
    SeethroughSetFadeEndDistance(Config.ThermalOptions.FadeEnd)

    -- Enable the seetrough effect (thermal vision)
    SetSeethrough(true)
end

local function CycleVision()
    if visionState == 0 then
        visionState = 1
        if CanHelicopterUseCameraVision(helicopter.model, "nightvision") then
            local hour = GetClockHours()
            if Config.AllowNightVisionDuringDay or (hour > 20 or hour < 6) then
                EmitSound(sounds.thermal, "THERMAL_VISION_GOGGLES_ON_MASTER", 0, true)
                SendNUIMessage({action = 'setVisionState', state = "HDNV"})
                SetNightvision(true)
                return
            end
        end
    end

    if visionState == 1 and CanHelicopterUseCameraVision(helicopter.model, "thermalvision") then
        SendNUIMessage({action = 'setVisionState', state = "HDIR"})
        SetNightvision(false)
        EnableThermal()
        visionState = 2
        return
    end

    DisableVision()
end


-- Camera Lock --
local function LockCamera(coords, entity)
    cameraLock.active = true
    movementInput = false
    local entityType = GetEntityType(entity)
    if entity and entityType ~= 0 then
        local offset = vector3(0.0, 0.0, 0.0)
        if not ShouldLockOntoCenter(entityType) then
            offset = GetOffsetFromEntityGivenWorldCoords(entity, coords.x, coords.y, coords.z)
        end
        PointCamAtEntity(camera.cam, entity, offset.x, offset.y, offset.z, true)
        cameraLock.prevType = cameraLock.type
        cameraLock.type = "entity"
        cameraLock.entity = entity
        cameraLock.coords = nil
    else
        -- We have to re-create the camera due to bug with the PointCamAtCoord/PointCamAtEntity functions regarding offsets.
        if cameraLock.prevType == "entity" then
            local offset = GetHeliCameraOffset(helicopter.model)
            local rotation = GetEntityRotation(helicopter.entity, 5).z
            local cam = CreateHelicopterCamera(helicopter.entity, offset, rotation, GetCamFov(camera.cam), false, 0)
            DestroyCam(camera.cam, true)
            camera.cam = cam
        end

        PointCamAtCoord(camera.cam, coords.x, coords.y, coords.z)
        cameraLock.prevType = cameraLock.type
        cameraLock.type = "coords"
        cameraLock.entity = nil
        cameraLock.coords = coords
    end

    local lockType = nil
    if cameraLock.type == "coords" then
        lockType = "GROUND"
    elseif entityType == 2 then
        lockType = "VEHICLE"
    elseif entityType == 1 then
        if GetPedType(cameraLock.entity) == 28 then
            lockType = "ANIMAL"
        else
            lockType = "PERSON"
        end
    else
        lockType = "UNKNOWN"
    end
    SendNUIMessage({ action = 'setCameraLockState', state = true, type = lockType })
end

local function AttemptLockScanning(targetEntity)
    local count = 1

    cameraLock.attempting = true
    SendNUIMessage({ action = 'startLockScanning' })

    while true do
        Wait(200)
        local hit, hitCoords, hitEntity = RaycastFromHeliCam()
        if hit and hitEntity == targetEntity then
            count += 1
        else
            count -= 1
        end

        if not inHeliCam then
            return false
        end

        if Config.PlaySounds then
            EmitSound(sounds.scanLoop, "COP_HELI_CAM_SCAN_PED_LOOP")
        end

        SendNUIMessage({ action = 'updateLockScanning', value = count })

        if count >= 11 then
            if Config.PlaySounds then
                if not HasSoundFinished(sounds.scanLoop) then
                    StopSound(sounds.scanLoop)
                end
                PlaySoundFrontend(sounds.scanSuccess, "COP_HELI_CAM_SCAN_PED_SUCCESS", 0, true)
            end
            return true, hitCoords, hitEntity
        end

        if count <= -1 or not cameraLock.attempting then
            if Config.PlaySounds then
                if not HasSoundFinished(sounds.scanLoop) then
                    StopSound(sounds.scanLoop)
                end
                PlaySoundFrontend(sounds.scanFailure, "COP_HELI_CAM_SCAN_PED_FAILURE", 0, true)
            end
            return false
        end
    end
end

local function AttemptCameraLock()
    local hit, hitCoords, hitEntity = RaycastFromHeliCam()
    if hit then
        if GetEntityType(hitEntity) ~= 0 then
            if Config.InstantCameraLock then
                LockCamera(hitCoords, hitEntity)
            else
                local success, coords, entity = AttemptLockScanning(hitEntity)
                if success then
                    LockCamera(coords, entity)
                end
                cameraLock.attempting = false
                SendNUIMessage({ action = 'lockScanningFinished' })
            end
        elseif Config.AllowCameraLockOnGround then
            LockCamera(hitCoords, hitEntity)
        end
    end
end

local function StopCameraLock()
    if camera.cam and cameraLock.active then
        StopCamPointing(camera.cam)
    end
    SendNUIMessage({ action = 'setCameraLockState', state = false, type = "NONE" })

    -- Reset variables
    cameraLock.active = false
    cameraLock.prevType = cameraLock.type
    cameraLock.type = nil
    cameraLock.entity = nil
    cameraLock.coords = nil
    cameraLock.timeout = 0
    cameraLock.progress = 0
end

local function CheckCameraLock(hit, hitCoords, hitEntity)
    if cameraLock.active then
        local timeout = false
        if not hit then
            timeout = true
        elseif cameraLock.type == "coords" then
            local distToTarget = #(hitCoords-cameraLock.coords)
            if distToTarget > 1.0 then
                timeout = true
            end
        elseif cameraLock.type == "entity" then
            if hitEntity ~= cameraLock.entity and not HasEntityClearLosToEntity(helicopter.entity, cameraLock.entity, 4294967295) then
                timeout = true
            end
        end

        if timeout then
            cameraLock.timeout += 1
            if Config.PlaySounds then
                EmitSound(sounds.bleep, "COP_HELI_CAM_BLEEP_TOO_FAR")
            end

            if cameraLock.timeout >= Config.CameraLockBreakTicks then
                StopCameraLock()
            end
        elseif cameraLock.timeout > 0 then
            cameraLock.timeout -= 1
        end
    end
end


-- Rappel --
local function AttemptRappel(wasKeyPress)
    if not helicopter.entity then
        return
    end

    local heliConfig = Config.Helicopters[helicopter.model]
    if not DoesVehicleAllowRappel(helicopter.entity) or (heliConfig and heliConfig.disableRappelling) then
        DisplayNotification(Config.Localisation.Notification.CannotRappelFromHeli)
        return
    end

    local playerPed = PlayerPedId()
    local isInCorrectSeat = GetPedInVehicleSeat(helicopter.entity, 1) == playerPed or GetPedInVehicleSeat(helicopter.entity, 2) == playerPed
    if not isInCorrectSeat then
        DisplayNotification(Config.Localisation.Notification.CannotRappelFromSeat)
        return
    end

    local coords = GetEntityCoords(helicopter.entity)
    local foundHeight, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, false)
    if not foundHeight or coords.z - groundZ > Config.MaxRappellingHight then
        DisplayNotification(Config.Localisation.Notification.ToHighToRappel)
        return
    end

    if wasKeyPress and (lastRappelKeyPress == 0 or (lastRappelKeyPress + Config.RappellingTimeout < GetGameTimer())) then
        lastRappelKeyPress = GetGameTimer()
        DisplayNotification(Config.Localisation.Notification.ConfirmRappel)
    else
        lastRappelKeyPress = 0
        EmitSound(sounds.rappel, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
        DisplayNotification(Config.Localisation.Notification.Rappelling)

        TaskRappelFromHeli(playerPed, 1)
    end
end


-- Instructions --
local function AddInInstructionsControl(scaleform, index, control, text)
    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(index)
    ScaleformMovieMethodAddParamPlayerNameString(control)
    BeginTextCommandScaleformString("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandScaleformString()
    EndScaleformMovieMethod()
end

local function SetupInstructionsScaleform()
    instScaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
    while not HasScaleformMovieLoaded(instScaleform) do
        Wait(10)
    end

    BeginScaleformMovieMethod(instScaleform, "CLEAR_ALL")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(instScaleform, "SET_CLEAR_SPACE")
    ScaleformMovieMethodAddParamInt(200)
    EndScaleformMovieMethod()

    -- Add Controls
    for index, button in pairs(Config.InstructionButtons) do
        AddInInstructionsControl(instScaleform, index, button.control, button.label)
    end

    -- Background colour
    BeginScaleformMovieMethod(instScaleform, "SET_BACKGROUND_COLOUR")
    ScaleformMovieMethodAddParamInt(0) -- Red
    ScaleformMovieMethodAddParamInt(0) -- Green
    ScaleformMovieMethodAddParamInt(0) -- Blue
    ScaleformMovieMethodAddParamInt(80) -- Alpha
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(instScaleform, "SET_BACKGROUND")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(instScaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    EndScaleformMovieMethod()
end

local function InstructionsThread()
    CreateThread(function()
        while inHeliCam do
            DrawScaleformMovieFullscreen(instScaleform, 255, 255, 255, 255, 0)
            Wait(0)
        end
    end)
end


-- Spotlight --
local function DoesAnyHeliHaveSpotlightOverwrite()
    for _hash, data in pairs(Config.Helicopters) do
        if data.spotlight then
            return true
        end
    end

    return false
end

local function CanHelicopterUseSpotlight(model)
    if (Config.AllowSpotlight and (Config.Helicopters[model] and Config.Helicopters[model].spotlight ~= false)) or (Config.Helicopters[model] and Config.Helicopters[model].spotlight) then
        return true
    end

    return false
end

local function AdjustSpolightBrightness()
    CreateThread(function()
        while spotlight.adjustingBrightness do
            local newBrightness = spotlight.brightness

            if GetDisabledControlNormal(0, 40) ~= 0.0 then -- Scroll up
                newBrightness = math.min(newBrightness + Config.Spotlight.BrightnessIncrements, Config.Spotlight.MaxBrightness)
            elseif GetDisabledControlNormal(0, 41) ~= 0.0 then -- Scroll down
                newBrightness = math.max(newBrightness - Config.Spotlight.BrightnessIncrements, Config.Spotlight.MinBrightness)
            end

            spotlight.brightness = newBrightness
            Wait(0)
        end
    end)
end

local function AdjustSpolightRadius()
    CreateThread(function()
        while spotlight.adjustingRadius do
            local newRadius = spotlight.radius

            if GetDisabledControlNormal(0, 40) ~= 0.0 then -- Scroll up
                newRadius = math.min(newRadius + Config.Spotlight.RadiusIncrements, Config.Spotlight.MaxRadius)
            elseif GetDisabledControlNormal(0, 41) ~= 0.0 then -- Scroll down
                newRadius = math.max(newRadius - Config.Spotlight.RadiusIncrements, Config.Spotlight.MinRadius)
            end

            spotlight.radius = newRadius
            Wait(0)
        end
    end)
end

local function SpotlightThread()
    local direction = nil
    local position = nil
    local netId = helicopter.netId

    -- Reset spotlight brightness/radius
    spotlight.brightness = Config.Spotlight.DefaultBrightness
    spotlight.radius = Config.Spotlight.DefaultRadius

    CreateThread(function()
        while spotlight.active do
            local rotation = camera.rotation or GetCamRot(camera.cam, 2)
            direction = RotAnglesToVec(rotation)
            local camCoords = GetCamCoord(camera.cam)
            position = camCoords + direction

            DrawSpotLightWithShadow(position.x, position.y, position.z, direction.x, direction.y, direction.z, Config.Spotlight.Colour.R, Config.Spotlight.Colour.G, Config.Spotlight.Colour.B, Config.Spotlight.MaxDistance, spotlight.brightness, Config.Spotlight.Roundness, spotlight.radius, Config.Spotlight.Falloff, 0)
            Wait(0)
        end
    end)

    CreateThread(function()
        while spotlight.active do
            SynchroniseSpotlight(position, direction, spotlight.brightness, spotlight.radius, netId)
            Wait(1500)
        end
        SynchroniseSpotlight(false, nil, nil, nil, netId)
    end)
end

local function SpotlightCameraLockCheck()
    CreateThread(function()
        spotlight.cameraLockThread = true
        while spotlight.active and not inHeliCam do
            local hit, hitCoords, hitEntity = RaycastFromHeliCam()
            CheckCameraLock(hit, hitCoords, hitEntity)
            Wait(250)
        end
        spotlight.cameraLockThread = false
    end)
end

local function ToggleSpotlight()
    if not inHeliCam or pauseMenu then
        return
    end

    -- Check if our helicopter can use a spotlight
    if not CanHelicopterUseSpotlight(helicopter.model) then
        DisplayNotification(Config.Localisation.Notification.NoSpotlight)
        return
    end

    -- Emit toggle sound
    EmitSound(sounds.spotlight, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET")

    spotlight.active = not spotlight.active
    if spotlight.active then
        if not Config.MaxAmountOfSpotlights then
            SpotlightThread()
            return
        end

        SpotlightThread()
    elseif Config.MaxAmountOfSpotlights then
    end
end

-- Spotlights that are not controled by us
local function ForeignSpotlightThread()
    CreateThread(function()
        spotlight.isThreadActive = true
        while not IsTableEmpty(spotlights) do
            for _netId, data in pairs(spotlights) do
                DrawSpotLightWithShadow(data.position.x, data.position.y, data.position.z, data.direction.x, data.direction.y, data.direction.z, Config.Spotlight.Colour.R, Config.Spotlight.Colour.G, Config.Spotlight.Colour.B, Config.Spotlight.MaxDistance, data.brightness+0.0, Config.Spotlight.Roundness, data.radius+0.0, Config.Spotlight.Falloff, 0)
            end
            Wait(0)
        end
        spotlight.isThreadActive = false
    end)
end

RegisterNetEvent('heliCamSpotlightData', function(_helicopter, position, direction, brightness,radius)
    -- Ignore this if we are the camera operator
    if (_helicopter == helicopter.netId and camera.cam) then
        return
    end

    -- Turn off spotlight
    if not position then
        spotlights[_helicopter] = nil
        return
    end

    local data = {position = position, direction = direction, brightness = brightness, radius = radius}
    spotlights[_helicopter] = data

    if not spotlight.isThreadActive then
        ForeignSpotlightThread()
    end
end)


-- Blips --
local function ToggleMarker()
    local markerIndex = nil
    local hit, hitCoords = RaycastFromHeliCam()
    if not hit then
        return
    end

    local adjustedCoords = vector3(hitCoords.x, hitCoords.y, hitCoords.z + 0.25)
    for index, coords in pairs(markers) do
        local dist = #(coords - adjustedCoords)
        if dist < Config.Marker.Circle.Scale + 0.5 then
            markerIndex = index
            break
        end
    end

    if markerIndex then
        -- Remove Marker from table
        table.remove(markers, markerIndex)
    else
        -- If already max markers, remove the marker we created the longest ago
        if #markers >= Config.Marker.MaxAmount then
            table.remove(markers, 1)
        end

        -- Add marker
        markers[#markers+1] = adjustedCoords
    end

    SetHelicopterStateBag("heliCamMarkers", markers)
end

local function CreateMarkerBlip(coords, number)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

	SetBlipSprite(blip, Config.Marker.Blip.Sprite)
	SetBlipScale(blip, Config.Marker.Blip.Scale)
	SetBlipColour(blip, Config.Marker.Blip.Colour)

    if Config.Marker.Blip.Number then
	    ShowNumberOnBlip(blip, number)
    end

    -- Set blip name
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(Config.Localisation.Blip.Marker)
	EndTextCommandSetBlipName(blip)

	return blip
end

local function UpdateMarkerBlips()
    if markers == nil then
        return
    end

    if #markers < #markerBlips then
        for index, data in pairs(markerBlips) do
            if index > #markers then
                RemoveBlip(data.handler)
                markerBlips[index] = nil
            end
        end
    end

    for index, coords in pairs(markers) do
        if not markerBlips[index] then
            markerBlips[index] = {}
            markerBlips[index].handler = CreateMarkerBlip(coords, index)
            markerBlips[index].coords = coords
        elseif markerBlips[index].coords ~= coords then
            SetBlipCoords(markerBlips[index].handler, coords.x, coords.y, coords.z)
            ShowNumberOnBlip(markerBlips[index].handler, index)
            markerBlips[index].coords = coords
        end
    end
end

local function MarkersThread()
    CreateThread(function()
        isMarkersThreadActive = true

        while true do
            if markers == nil or #markers == 0 then
                break
            end

            local heliCoords = cache.helicopter.coords or GetEntityCoords(helicopter.entity)

            for index, coords in pairs(markers) do
                if #(heliCoords - coords) < Config.Marker.MaxDrawDistance then
                    DrawMarker(Config.Marker.Circle.Type, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.Circle.Scale, Config.Marker.Circle.Scale, Config.Marker.Circle.Scale, Config.Marker.Circle.Colour.R, Config.Marker.Circle.Colour.G, Config.Marker.Circle.Colour.B, Config.Marker.Circle.Colour.A, false, true, 2, false, nil, nil, false)
                    if Config.Marker.Number.Display then
                        DrawMarker(index+10, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.Number.Scale, Config.Marker.Number.Scale, Config.Marker.Number.Scale, Config.Marker.Number.Colour.R, Config.Marker.Number.Colour.G, Config.Marker.Number.Colour.B, Config.Marker.Number.Colour.A, false, true, 2, false, nil, nil, false)
                    end
                end
            end
            Wait(0)
        end

        isMarkersThreadActive = false
    end)
end

local function HandleTargetBlip(display)
    if display then
        local coords = display
        if DoesBlipExist(targetBlip.handler) then
            SetBlipCoords(targetBlip.handler, coords.x, coords.y, coords.z)
        else
            -- Create the blip
            targetBlip.handler = AddBlipForCoord(coords.x, coords.y, coords.z)
            SetBlipSprite(targetBlip.handler, Config.TargetBlip.Sprite)
            SetBlipColour(targetBlip.handler, Config.TargetBlip.Colour)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(Config.Localisation.Blip.Target)
            EndTextCommandSetBlipName(targetBlip.handler)
        end

        if not targetBlip.display then
            SetBlipDisplay(targetBlip.handler, 2)
            targetBlip.display = true
        end
    elseif display == false then
        if targetBlip.display then
            SetBlipDisplay(targetBlip.handler, 0)
            targetBlip.display = false
        end
    else
        RemoveBlip(targetBlip.handler)
        targetBlip.handler = nil
        targetBlip.display = false
    end
end

-- Threads & Main Functions --
local function MinimapHeadingThread()
    CreateThread(function()
        while inHeliCam do
            SetGameplayCamRelativeHeading(camera.heading * -1)
            Wait(0)
        end
    end)
end

local function ExitHeliCamera()
    inHeliCam = false
    cameraAction = true
    camera.rotation = nil

    -- Set camera avalible for others to use
    TriggerServerEvent('helicam:leaveCamera', helicopter.netId)

    -- Trigger event for other scripts to use
    TriggerEvent('helicam:leftCamera', helicopter.netId)

    -- Close NUI
    SendNUIMessage({ action = 'close' })

    -- Disable night-/therma-vision if enabled
    if visionState ~= 0 then
        DisableVision()
    end

    -- Remove tablet object
    if tabletObj then
        DeleteTablet()
    end

    if Config.InstructionButtons then
        SetScaleformMovieAsNoLongerNeeded(instScaleform)
    end

    if not submix and Config.NoSubmixInCamera then
        EnableSubmix()
    end

    local timecycleName, _timecycleStrength = GetHelicopterTimecycle(helicopter.model)
    if timecycleName then
        ClearTimecycleModifier()
    end

    -- Reset gameplay camera, stop rendering and remove helicopter camera
    SetGameplayCamRelativeHeading(0)
    RenderScriptCams(false, Config.CameraTransition, Config.CameraTransitionTime, false, false)
    if Config.CameraTransition then
        Wait(Config.CameraTransitionTime)
    end

    if not spotlight.active then
        StopCameraLock()
        DestroyCam(camera.cam, false)
        camera.cam = nil
    elseif not spotlight.cameraLockThread then
        SpotlightCameraLockCheck()
    end

    -- Unload sounds
    if Config.PlaySounds then
        UnloadSounds()

        -- Exit sound
        EmitSound(sounds.exit, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET")
    end

    -- Toggle radar on again
    if Config.HideMinimap then
        DisplayRadar(true)
    end

    -- Reset varaibles
    cameraAction = false
end

local function OnLeftHelicopter()
    markers = {}
    HandleTargetBlip(nil)
    UpdateMarkerBlips()

    if inHeliCam then
        ExitHeliCamera()
    end

    -- Reset camera variables
    StopCameraLock()

    -- Destroy camera
    DestroyCam(camera.cam, false)
    camera.cam = nil

    -- Removes audio submix if it was enabled
    if submix then
        DisableSubmix()
    end

    -- Remove spotlight
    if spotlight.active then
        spotlight.active = false
    end

    helicopter = {}
end

local function InHelicopterThread()
    CreateThread(function()
        local heli = GetVehiclePedIsIn(PlayerPedId(), false)
        while heli == helicopter.entity do
            Wait(250)
            heli = GetVehiclePedIsIn(PlayerPedId(), false)
        end

        OnLeftHelicopter()
    end)
end

local function OnEnteredVehicle(vehicle)
    local model = GetEntityModel(vehicle)
    local hasCamera = DoesHelicopterHaveCamera(model, vehicle)
    if hasCamera then
        CreateThread(function()
            if helicopter.entity then
                while helicopter.entity ~= nil and helicopter.entity ~= 0 do
                    Wait(0)
                end
                Wait(100)
            end

            helicopter.entity = vehicle
            helicopter.netId = VehToNet(vehicle)
            helicopter.model = model

            InHelicopterThread()
        end)
    end

    if Config.UseSubmix then
        EnableSubmix()
        if not hasCamera then
            CreateThread(function()
                local playerPed = PlayerPedId()
                while IsPedInAnyHeli(playerPed) or IsPedInAnyPlane(playerPed) do
                    Wait(250)
                end

                -- Removes audio submix if it was enabled
                if submix then
                    DisableSubmix()
                end
            end)
        end
    end
end

local function CollectAndSendData()
    local info = {}
    local data = {}
    data.target = {}
    data.helicopter = {}

    data.helicopter.speed = GetEntitySpeed(helicopter.entity)
    data.helicopter.coords = GetEntityCoords(helicopter.entity)
    data.helicopter.heading = GetEntityHeading(helicopter.entity)
    data.target.numberplate = false

    if Config.TimeFormat == 1 then
        local hour = GetClockHours()
        local minute = GetClockMinutes()

        info.time = ("%.2d"):format((hour == 0) and 12 or hour) .. ":" .. ("%.2d"):format(minute)
    end

    local setData = {}
    if data.helicopter.speed ~= cache.helicopter.speed then
        setData['hi-speed'] = string.format("%.0f", data.helicopter.speed * Units.Speed.Conversion)
        cache.helicopter.speed = data.helicopter.speed
    end
    if data.helicopter.coords ~= cache.helicopter.coords then
        setData['hi-altitude'] = string.format("%.0f", data.helicopter.coords.z * Units.Altitude.Conversion)
        cache.helicopter.coords = data.helicopter.coords
    end
    if data.helicopter.heading ~= cache.helicopter.heading then
        setData['hi-heading'] = string.format("%.0f", data.helicopter.heading)
        cache.helicopter.heading = data.helicopter.heading
    end
    if camera.pitch ~= cache.camera.pitch then
        setData['camera-pitch'] = string.format("%.0f", (camera.pitch - 90) * -1).."°"
        cache.camera.pitch = camera.pitch
    end
    if camera.heading ~= cache.camera.heading then
        setData['camera-heading'] = string.format("%.0f", camera.heading).."°"
        cache.camera.heading = camera.heading
    end
    if camera.bearing ~= cache.camera.bearing then
        setData['bearing-text'] = string.format("%.0f", camera.bearing).."°T"
        cache.camera.bearing = camera.bearing
    end

    local hit, hitCoords, hitEntity = RaycastFromHeliCam()
    if cameraLock.active then
        CheckCameraLock(hit, hitCoords, hitEntity)
        hitEntity = cameraLock.entity
    end

    if hit then
        data.target.elevation = string.format("%.0f", hitCoords.z * Units.TargetElevation.Conversion)
        if data.target.elevation ~= cache.target.elevation then
            setData['ta-elevation'] = data.target.elevation
            cache.target.elevation = data.target.elevation
        end

        if (hitEntity and GetEntityType(hitEntity) ~= 0) or cameraLock.active then
            data.target.heading = GetEntityHeading(hitEntity)
            data.target.speed = string.format("%.0f", GetEntitySpeed(hitEntity) * Units.TargetSpeed.Conversion)

            if IsEntityAVehicle(hitEntity) and ((Config.OnlyShowPlateIfLocked and cameraLock.active) or not Config.OnlyShowPlateIfLocked) then
                local success, plate = GetVehicleNumberPlate(hitEntity, GetEntityRotation(hitEntity), camera.rotation or GetCamRot(camera.cam, 2))
                if success then
                    data.target.numberplate = plate
                end
            end

            data.target.heading = string.format("%.0f", data.target.heading)
        elseif movementInput and cache.target.position ~= nil then
            data.target.speed = string.format("%.0f", #(cache.target.position - hitCoords) * Units.TargetSpeed.Conversion)
            data.target.heading = string.format("%.0f", GetHeadingBetweenCoords(cache.target.position, hitCoords))
        end

        if hitCoords ~= cache.target.position then
            cache.target.position = hitCoords
        end
        if data.target.speed ~= cache.target.speed then
            cache.target.speed = data.target.speed
            if data.target.speed == nil then data.target.speed = "---" end
            setData['ta-speed'] = data.target.speed
        end
        if data.target.heading ~= cache.target.heading then
            cache.target.heading = data.target.heading
            if data.target.heading == nil then data.target.heading = "---" end
            setData['ta-heading'] = data.target.heading
        end

        data.target.distance = #(hitCoords - data.helicopter.coords)
        if data.target.distance ~= cache.target.distance then
            local decimals = (Units.TargetDistance.Type == "MI" and "%.2f") or "%.0f"
            setData['ta-distance'] = string.format(decimals, data.target.distance * Units.TargetDistance.Conversion)
            cache.target.distance = data.target.distance
        end
    else
        if cache.target.speed ~= "---" then
            setData['ta-speed'] = "---"
            cache.target.speed = "---"
        end
        if cache.target.heading ~= "---" then
            setData['ta-heading'] = "---"
            cache.target.heading = "---"
        end
        if cache.target.elevation ~= "---" then
            setData['ta-elevation'] = "---"
            cache.target.elevation = "---"
        end
        if cache.target.distance ~= "---" then
            setData['ta-distance'] = "---"
            cache.target.distance = "---"
        end
    end

    -- Send number plate if it's different from last time we send it to the NUI
    if cache.target.numberplate ~= (data.target.numberplate or false) then
        info.numberplate = data.target.numberplate
        cache.target.numberplate = data.target.numberplate
    end

    if Config.ShowLatitudeLongitude then
        local latitude = GetCartesianCoords(data.helicopter.coords.x)
        local longitude = GetCartesianCoords(data.helicopter.coords.y)
        if data.helicopter.latitude ~= latitude then
            setData['hi-latitude'] = latitude
            cache.helicopter.latitude = latitude
        end
        if data.helicopter.longitude ~= longitude then
            setData['hi-longitude'] = longitude
            cache.helicopter.longitude = longitude
        end

        if hit then
            local targetLatitude = GetCartesianCoords(hitCoords.x)
            local targetLongitude = GetCartesianCoords(hitCoords.y)
            if data.helicopter.latitude ~= targetLatitude then
                setData['ta-latitude'] = targetLatitude
                cache.target.latitude = targetLatitude
            end
            if data.helicopter.longitude ~= targetLongitude then
                setData['ta-longitude'] = targetLongitude
                cache.target.longitude = targetLongitude
            end
        else
            if data.helicopter.latitude ~= "---" then
                setData['ta-latitude'] = "---"
                cache.target.latitude = "---"
            end
            if data.helicopter.longitude ~= "---" then
                setData['ta-longitude'] = "---"
                cache.target.longitude = "---"
            end
        end
    else
        -- Street name and area
        local streetHash, _crossingHash = GetStreetNameAtCoord(data.helicopter.coords.x, data.helicopter.coords.y, data.helicopter.coords.z)
        if streetHash ~= cache.helicopter.street then
            local street, area = GetStreetAndAreaNames(streetHash, data.helicopter.coords)
            setData['hi-street'] = street.." - "..area
            cache.helicopter.street = streetHash
        end

        if hit then
            local targetStreetHash, _targetCrossingHash = GetStreetNameAtCoord(hitCoords.x, hitCoords.y, hitCoords.z)
            if targetStreetHash ~= cache.target.street then
                local targetStreet, targetArea = GetStreetAndAreaNames(targetStreetHash, hitCoords)
                setData['ta-street'] = targetStreet.." - "..targetArea
                cache.target.street = targetStreetHash
            end
        elseif cache.target.street ~= "---" then
            setData['ta-street'] = "---"
            cache.target.street = "---"
        end
    end

    if not IsTableEmpty(info) or not IsTableEmpty(setData) then
        SendNUIMessage({
            action = 'updateData',
            info = info,
            set = setData
        })
    end
end

local function UpdateUIHeadingPitchAndBearing()
    local rotation = GetCamRot(camera.cam, 2)
    local bearing = string.format("%.0f", RotationToHeading(rotation.z))
    local pitch = (rotation.x * -1) + 90.0
    local heading = (rotation.z * -1) + GetEntityHeading(helicopter.entity)
    if heading > 360 then
        heading = heading - 360
    end

    if math.abs(camera.pitch - pitch) > 0.1 or math.abs(camera.heading - heading) > 0.1 then
        SendNUIMessage({
            action = 'updateDataFrame',
            pitch = pitch,
            heading = heading,
            bearing = bearing
        })

        camera.pitch = pitch
        camera.heading = heading
        camera.bearing = bearing
    end

    camera.rotation = rotation
end

local function PrimaryThread()
    UpdateUIHeadingPitchAndBearing()

    CreateThread(function()
        while inHeliCam do
            if not pauseMenu then
                -- Camera Heading, Pitch and Bearing
                UpdateUIHeadingPitchAndBearing()

                -- Handle inputs
                HandleZoomInput()
                HandleMovementInput()

                -- Disable game inputs
                for _index, control in pairs(controlActions) do
                    DisableControlAction(0, control, true)
                end
            else
                Wait(100)
            end

            Wait(0)
        end
    end)
end

local function DisplayPostalLoop()
    CreateThread(function()
        while inHeliCam and postalsActive do
            for _index, data in pairs(displayPostals) do
                DrawText3D(data.coords, data.code)
            end
            Wait(0)
        end

        displayPostals = {}
    end)
end

local function PostalLoop()
    CreateThread(function()
        while inHeliCam and postalsActive do
            local coords = cache.target.position and cache.target.position.xy or cache.helicopter.coords.xy
            local inDistance = {}

            for _index, data in pairs(postals) do
                local postalCoords = data.coords and data.coords.xy or vector2(data.x, data.y)
                local dist = #(coords - postalCoords)
                if dist < 500.0 then
                    if data.coords then
                        inDistance[#inDistance+1] = { coords = data.coords, code = data.code, dist = dist }
                    else
                        local success, groundZ = GetGroundZFor_3dCoord(data.x, data.y, cache.helicopter.coords.z, false)
                        if success then
                            data.coords = vector3(data.x, data.y, groundZ) -- Cache's the z coord
                            data.x = nil
                            data.y = nil
                            inDistance[#inDistance+1] = { coords = data.coords, code = data.code, dist = dist }
                        end
                    end
                end
            end

            table.sort(inDistance, function(p1, p2) return p1.dist < p2.dist end)

            displayPostals = {}
            for i = 1, 50 do
                displayPostals[i] = inDistance[i]
            end

            Wait(500)
        end
    end)

    DisplayPostalLoop()
end

local function SecondaryThread()
    CollectAndSendData()
    SendNUIMessage({ action = 'open' })

    CreateThread(function()
        while true do
            if not inHeliCam then
                return
            end

            if IsEntityDead(PlayerPedId()) then
                ExitHeliCamera()
                return
            end

            if IsPauseMenuActive() then
                if not pauseMenu then
                    pauseMenu = true
                    SendNUIMessage({ action = 'close' })
                end
            else
                CollectAndSendData()

                -- Sets camera depth of field
                local dist = type(cache.target.distance) == "number" and cache.target.distance or 500.0
                SetCamDofFocusDistanceBias(camera.cam, dist)

                if pauseMenu then
                    pauseMenu = false
                    SendNUIMessage({ action = 'open' })
                end
            end

            Wait(250)
        end
    end)
end

local function UseHeliCamera()
    if helicopter.model == nil or helicopter.entity == nil then
        print("^1ERROR: helicopter model or entity was nil, this is fatal and will cause issues!^7")
    end

    cameraAction = true
    inHeliCam = true
    SetCameraLabel()

    if Config.PlaySounds then
        LoadSounds()  -- Loads the sounds used when in the camera

        if Config.PlayCameraMovementSounds then
            SoundThread() -- Handles sounds, runs every 100ms
        end

        -- Enter sound
        EmitSound(sounds.enter, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
    end

    if not camera.cam then
        fov = Config.Camera.Zoom.Max
        local offset = GetHeliCameraOffset(helicopter.model)
        local rotation = GetEntityRotation(helicopter.entity, 5).z
        camera.cam = CreateHelicopterCamera(helicopter.entity, offset, rotation, 50.0, Config.CameraTransition, Config.CameraTransitionTime)
        if Config.CameraTransition then
            Wait(Config.CameraTransitionTime)
        end
    else
        RenderScriptCams(true, Config.CameraTransition, Config.CameraTransitionTime, false, false)
    end

    local timecycleName, timecycleStrength = GetHelicopterTimecycle(helicopter.model)
    if timecycleName then
        SetTimecycleModifier(timecycleName)
        SetTimecycleModifierStrength(timecycleStrength)
    end

    -- Trigger event for other scripts to use
    TriggerEvent('helicam:enteredCamera', helicopter.netId)

    -- Reset the zoom bar
    SetZoomBarLevel()

    if Config.ShowInstructions then
        SetupInstructionsScaleform()
        InstructionsThread()
    end

    if Config.HideMinimap then
        DisplayRadar(false)
    else
        MinimapHeadingThread()
    end

    if Config.UseSubmix and Config.NoSubmixInCamera then
        DisableSubmix()
    end

    PrimaryThread()   -- Handles controls and other stuff thats needs to be run every frame
    SecondaryThread() -- Handles "everything else", runs once every 250ms to save resources

    if Config.ShowPostalCodes then
        PostalLoop()
    end

    if Config.UseAnimProp then
        CreateTablet()
    end
    cameraAction = false
end


-- Events --
RegisterNetEvent('helicam:enterCamera')
AddEventHandler('helicam:enterCamera', function(state)
    if state then
        UseHeliCamera()
    else
        DisplayNotification(Config.Localisation.Notification.CameraInUse)
    end
end)

AddEventHandler('gameEventTriggered', function(event, args)
    if event == "CEventNetworkPlayerEnteredVehicle" then
        if args[1] == PlayerId() then
            OnEnteredVehicle(args[2])
        end
    end
end)


-- Commands & Key Mapping --
RegisterKeyMapping('helicam', Config.Localisation.KeyMapping.ToggleCam, Config.Keybinds.ToggleCam.Type, Config.Keybinds.ToggleCam.Key)
RegisterCommand('helicam', function()
    if cameraAction or pauseMenu then
        return
    end

    if not inHeliCam then
        local playerPed = PlayerPedId()
        if IsPedInAnyHeli(playerPed) or IsPedInAnyPlane(playerPed) then
            local canUseCamera, message = CanPlayerUseCamera(playerPed)
            if canUseCamera then
                TriggerServerEvent('helicam:enterCamera', helicopter.netId)
            elseif message then
                DisplayNotification(Config.Localisation.Notification[message])
            end
        end
    else
        ExitHeliCamera()
    end
end, false)

if Config.AllowCameraLock then
    RegisterKeyMapping('+helicam_lock', Config.Localisation.KeyMapping.AttemptLock, Config.Keybinds.AttemptLock.Type, Config.Keybinds.AttemptLock.Key)
    RegisterCommand('+helicam_lock', function()
        if not inHeliCam or pauseMenu then
            return
        end

        if not cameraLock.active then
            AttemptCameraLock()
        else
            StopCameraLock()
        end
    end, false)

    RegisterCommand('-helicam_lock', function()
        cameraLock.attempting = false
    end, false)
end

if Config.AllowNightVision or Config.AllowThermal or DoesAnyHeliHaveVisionOverwrite() then
    RegisterKeyMapping('helicam_cycle_vision', Config.Localisation.KeyMapping.CycleVision, Config.Keybinds.CycleVision.Type, Config.Keybinds.CycleVision.Key)
    RegisterCommand('helicam_cycle_vision', function()
        if inHeliCam and not pauseMenu then
            CycleVision()
        end
    end, false)
end

if Config.AllowMarkers then
    RegisterKeyMapping('helicam_toggle_marker', Config.Localisation.KeyMapping.ToggleMarker, Config.Keybinds.ToggleMarker.Type, Config.Keybinds.ToggleMarker.Key)
    RegisterCommand('helicam_toggle_marker', function()
        if inHeliCam and not pauseMenu then
            ToggleMarker()
        end
    end, false)
end

if Config.AllowRappelling then
    RegisterKeyMapping('+rappel', Config.Localisation.KeyMapping.Rappel, Config.Keybinds.Rappel.Type, Config.Keybinds.Rappel.Key)
    RegisterCommand('rappel', function()
        AttemptRappel(false)
    end, false)
    RegisterCommand('+rappel', function()
        AttemptRappel(true)
    end, false)
    RegisterCommand('-rappel', function()
        -- This is just a place holder to prevent "unknown command" messages in chat
    end, false)
end

if Config.AllowSpotlight or DoesAnyHeliHaveSpotlightOverwrite() then
    -- Toggle spotlight
    RegisterKeyMapping('helispotlight', Config.Localisation.KeyMapping.Spotlight, Config.Keybinds.Spotlight.Type, Config.Keybinds.Spotlight.Key)
    RegisterCommand('helispotlight', function()
        ToggleSpotlight()
    end, false)

    -- Adjusting spoltight brightness
    RegisterKeyMapping('+adjust_heli_spotlight_brightness', Config.Localisation.KeyMapping.SpotlightBrightness, Config.Keybinds.SpotlightBrightness.Type, Config.Keybinds.SpotlightBrightness.Key)
    RegisterCommand('+adjust_heli_spotlight_brightness', function()
        if inHeliCam and spotlight.active and not pauseMenu then
            if spotlight.adjustingBrightness then return end
            spotlight.adjustingBrightness = true
            AdjustSpolightBrightness()
        end
    end, false)

    RegisterCommand('-adjust_heli_spotlight_brightness', function()
        spotlight.adjustingBrightness = false
    end, false)

    -- Adjusting spoltight size/radius
    RegisterKeyMapping('+adjust_heli_spotlight_radius', Config.Localisation.KeyMapping.SpotlightRadius, Config.Keybinds.SpotlightRadius.Type, Config.Keybinds.SpotlightRadius.Key)
    RegisterCommand('+adjust_heli_spotlight_radius', function()
        if inHeliCam and spotlight.active and not pauseMenu then
            if spotlight.adjustingRadius then return end
            spotlight.adjustingRadius = true
            AdjustSpolightRadius()
        end
    end, false)

    RegisterCommand('-adjust_heli_spotlight_radius', function()
        spotlight.adjustingRadius = false
    end, false)
end

if Config.ShowPostalCodes then
    RegisterKeyMapping('helipostals', Config.Localisation.KeyMapping.Postals, Config.Keybinds.Postals.Type, Config.Keybinds.Postals.Key)
    RegisterCommand('helipostals', function()
        if inHeliCam then
            postalsActive = not postalsActive
            if postalsActive then
                PostalLoop()
            end
        end
    end, false)
end


-- Init --
CreateThread(function()
    local conversions = {
        -- Speed
        KTS = 1.943844, -- Knots per hour
        MPH = 2.236936, -- Miles per hour
        KMH = 3.6,      -- Kilometers per hour
        MPS = 1.0,      -- Meters per second
        FPS = 3.280840, -- Feet per second

        -- Distance
        FT = 3.2808399, -- Feet
        M = 1.0,        -- Meters
        MI = 0.00062137 -- Miles
    }

    for index, unit in pairs(Config.Units) do
        Units[index] = {
            Type = unit or 'M',
            Conversion = conversions[unit] or conversions['M']
        }
    end

    if Config.DisablePoliceScanner then
        SetAudioFlag('PoliceScannerDisabled', true)
    end

    if Config.DisableFlightMusic then
        SetAudioFlag("DisableFlightMusic", true)
    end

    if Config.AddChatSuggestions then
        TriggerEvent('chat:addSuggestion', '/helicam', Config.Localisation.ChatSuggestions.ToggleCamera)
        TriggerEvent('chat:addSuggestion', '/rappel', Config.Localisation.ChatSuggestions.Rappel)
    end

    if Config.ShowPostalCodes then
        LoadPostalFile(Config.PostalResource, Config.PostalFile)
    end

    if type(Config.DefaultCameraTimecycleStrength) ~= "number" then
        print(string.format("^1ERROR: Config.DefaultCameraTimecycleStrength is invalid, it needs to be a number! Current type: %s, current value: %s.^7", type(Config.DefaultCameraTimecycleStrength), Config.CameraTimecycleStrength))
        Config.DefaultCameraTimecycleStrength = 0.5
    end

    Wait(2500)

    SendNUIMessage({
        action = 'setConfigData',
        set = {
            ['hi-speed-unit'] = Config.Units.Speed,
            ['hi-altitude-unit'] = Config.Units.Altitude,
            ['ta-speed-unit'] = Config.Units.TargetSpeed,
            ['ta-elevation-unit'] = Config.Units.TargetElevation,
            ['ta-distance-unit'] = Config.Units.TargetDistance
        },
        showLatitudeLongitude = Config.ShowLatitudeLongitude,
        showLicensePlate = Config.ShowLicensePlate,
        timeFormat = Config.TimeFormat,
        dateFormat = Config.DateFormat,
        hideMinimap = Config.HideMinimap,
        showInstructions = Config.ShowInstructions,
        zoomBarOffset = Config.ZoomBarOffset
    })
end)


-- Exports --
local function InHelicam()
    return inHeliCam
end
exports('InHelicam', InHelicam)


-- Debugging Fix (if you restart the script while in a helicopter)
local currentResourceName = GetCurrentResourceName()
AddEventHandler('onResourceStart', function(resourceName)
    if currentResourceName ~= resourceName then
        return
    end

    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        OnEnteredVehicle(vehicle)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if currentResourceName ~= resourceName then
        return
    end

    if DoesEntityExist(tabletObj) then
        ClearPedSecondaryTask(PlayerPedId())
        DetachEntity(tabletObj, true, false)
        DeleteEntity(tabletObj)
        tabletObj = nil
    end

    if submix then
        DisableSubmix()
    end
end)
