
Modules.Sound = {}
Modules.Sound.Themes = {
    "fh5",
    "mostwanted",
    "carbon",
    "underground"
}
Modules.Sound.ActiveThreads = 0
function Modules.Sound.AddPedToDialogueCooldown(ped)
    if Modules.Sound.DialoguesCooldown[ped] == nil then
        Modules.Sound.DialoguesCooldown[ped] = true
        Citizen.CreateThread(function()
            Wait(4000)
            if Modules.Sound.DialoguesCooldown[ped] ~= nil then
                Modules.Sound.DialoguesCooldown[ped] = nil
            end
        end)
    end
end

function Modules.Sound.GetSoundForDistance(maxVolume, minVolume, maxDistance, distance)
    if distance > maxDistance then
        return 0.0
    else
        local volume = maxVolume - (distance / maxDistance) * maxVolume
        if volume < minVolume then
            volume = minVolume
        end

        if volume > maxVolume then
            volume = maxVolume
        end
        return volume
    end
end

function Modules.Sound.StopAllNormalSounds()
    SendNUIMessage({
        type = 'stopAllNormalSounds',
    })
end

function Modules.Sound.PlaySound(soundId, soundName, isLooped, volume)
    if not soundId or (type(soundId) == 'number' and soundId <= 0) then
        soundId = generateUuid()
    end
    SendNUIMessage({
        type = 'playNormalSound',

        soundId      = soundId,
        soundName    = soundName,
        isLooped     = isLooped,
        volume       = volume,
    })
end

function Modules.Sound.Play3DSound(soundId, soundName, isLooped, location, maxDistance, maxVolume, minVolume, maxDistanceSound, distance)
    --print(volume, volume <= 0)
    --if volume >= 0 then
        if not soundId or (type(soundId) == 'number' and soundId <= 0) then
            soundId = generateUuid()
        end

        if type(location) == 'string' then
            if location == 'self' then
                location = { [1] = 'self', }
            end
        end

        if type(location) == 'vector3' then
            location = {
                [1] = location,
            }
        end

        activeSounds[soundId] = {
            type = 'location',
        }

        --print(soundName, maxVolume, minVolume, maxDistanceSound, distance)
        SendNUIMessage({
            type = 'play',

            soundId      = soundId,
            soundName    = soundName,
            coordinates  = convertLocation(location),
            maxDistance  = maxDistance,
            isLooped     = isLooped,
            --volume       = volume,
            maxVolume    = maxVolume,
            minVolume    = minVolume,
            maxDistanceSound  = maxDistanceSound,
            distance     = distance,
        })

        Citizen.CreateThread(function()
            Wait(10*1000)
            if activeSounds[soundId] ~= nil then
                activeSounds[soundId] = nil
            end
        end)
    --end
end

function Modules.Sound.Play3DSoundOnEntity(entityNetId, soundId, soundName, isLooped, maxDistance, maxVolume, minVolume, maxDistanceSound, distance)
        --print(entityNetId, soundId, soundName, isLooped, maxDistance, maxVolume, minVolume, maxDistanceSound, distance)
        if not soundId or (type(soundId) == 'number' and soundId <= 0) then
            soundId = generateUuid()
        end

        if not NetworkDoesEntityExistWithNetworkId(entityNetId) then
            return
        end

        local entityId = NetworkGetEntityFromNetworkId(entityNetId)

        if not entityId or not DoesEntityExist(entityId) then
            return
        end

        activeSounds[soundId] = {
            type  = 'entity',
            netId = entityNetId,
        }

        SendNUIMessage({
            type = 'play',

            soundId     = soundId,
            soundName   = soundName,
            coordinates = convertLocation({ [1] = GetEntityCoords(entityId), }),
            maxDistance = maxDistance,
            isLooped    = isLooped,
            --volume      = volume,
            maxVolume    = maxVolume,
            minVolume    = minVolume,
            maxDistanceSound  = maxDistanceSound,
            distance     = distance,
        })
        Citizen.CreateThread(function()
            Wait(10*1000)
            if activeSounds[soundId] ~= nil then
                activeSounds[soundId] = nil
                SendNUIMessage({
                    type = 'stop',
                    soundId     = soundId,
                })
            end
        end)
    --end

end