local isInBowlingInterior = false
local uniqueAlleyLanes = {}

local bowlingVolume = 0.2

function ProcessVolumeSelector()
    local kvpVolume = GetResourceKvpInt('bowlingVolume')

    if kvpVolume == 0 then
        bowlingVolume = 0.2
    elseif kvpVolume == -1 then
        bowlingVolume = 0
    else
        bowlingVolume = (kvpVolume or 10) / 100
    end
end

Citizen.CreateThread(function()
    ProcessVolumeSelector()
end)

RegisterCommand('bowlingvolume', function(_, args)
    local volume = math.max(0, math.min(100, tonumber(math.floor(args[1]))))
    if volume == 0 then
        SetResourceKvpInt('bowlingVolume', -1)
    else
        SetResourceKvpInt('bowlingVolume', volume)
    end
    ProcessVolumeSelector()
end)

Citizen.CreateThread(function()
    local placesAdded = {}
    for laneName, lane in pairs(Lanes) do
        if not placesAdded[lane.Place] then
            placesAdded[lane.Place] = true
            table.insert(uniqueAlleyLanes, laneName)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local locIsInBowlingInterior = false
        for i = 1, #uniqueAlleyLanes do
            if Lanes[uniqueAlleyLanes[i]].IsNear then
                local ped = PlayerPedId()
                local pedInterior = GetInteriorFromEntity(ped)

                if pedInterior > 0 then
                    local laneInterior = GetInteriorAtCoords(Lanes[uniqueAlleyLanes[i]].Start.x, Lanes[uniqueAlleyLanes[i]].Start.y, Lanes[uniqueAlleyLanes[i]].Start.z)

                    if pedInterior == laneInterior then
                        locIsInBowlingInterior = true
                    end
                end

                break
            end
        end
        if locIsInBowlingInterior then
            Wait(200)
        else
            Wait(2000)
        end

        if locIsInBowlingInterior then
            local _, fwd, up, _ = GetCamMatrix(0)

            local cameraRotation = GetGameplayCamRot()
            local cameraCoord = GetGameplayCamCoord()
            local direction = RotationToDirection(cameraRotation)

            SendNUIMessage({
                type = 'setOrientation',
                fwd = direction,
                up = vector3(0.0, 0.0, 1.0),
                coord = cameraCoord,
            })
        end

        isInBowlingInterior = locIsInBowlingInterior
    end
end)

function PlayPinSoundSmall(pos)
    if isInBowlingInterior then
        SendNUIMessage({
            type = 'playSound',
            position = pos,
            volume = 0.2 * bowlingVolume,
            sounds = {'small_1','small_2','small_3','small_4','small_5','small_6'},
        })
    end
end

function PlayPinSoundBig(pos)
    if isInBowlingInterior then
        SendNUIMessage({
            type = 'playSound',
            position = pos,
            volume = 0.2 * bowlingVolume,
            sounds = {'big_1', 'big_2', 'big_3'},
        })
    end
end

function RotationToDirection(rotation)
	local adjustedRotation = 
	{ 
		x = (math.pi / 180) * rotation.x, 
		y = (math.pi / 180) * rotation.y, 
		z = (math.pi / 180) * rotation.z 
	}
	return vector3(
		-math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		math.sin(adjustedRotation.x)
    )
end

function PlayBowlingBallRollSound(lane, throwId)
    if isInBowlingInterior then
        local rollPos = (lane.Start + lane.End)/2

        SendNUIMessage({
            type = 'playSoundBall',
            position = rollPos,
            volume = 0.02 * bowlingVolume,
            sounds = {'roll'},
            throwId = throwId,
        })
    end
end

function StopRollSound(throwId)
    SendNUIMessage({
        type = 'stopSoundBall',
        throwId = throwId,
    })
end

function PlaySoundResetLowered(pos)
    if isInBowlingInterior then
        SendNUIMessage({
            type = 'playSound',
            position = pos,
            volume = 0.03 * bowlingVolume,
            sounds = {'reset_lowered'},
        })
    end
end

