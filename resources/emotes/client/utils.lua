preview_emote = nil
current_emote = nil
local attached_props = {}
local clone_attached_props = {}
local player_emoting_with = nil
local emotePed = nil

local function createClone()
    local clone = ClonePed(PlayerPedId(), false, false, true)
    -- Freeze the ped so it doesn't move
    FreezeEntityPosition(clone, true)
    -- Set the ped to be invisible
    SetEntityVisible(clone, false, false)
    -- Set the ped to be invincible
    SetEntityInvincible(clone, true)
    -- Set the ped to be untargetable
    SetEntityCanBeDamaged(clone, false)
    -- Set the ped to not be able to ragdoll
    SetPedCanRagdoll(clone, false)
    -- Set the ped to not be able to ragdoll from melee
    SetPedCanRagdollFromPlayerImpact(clone, false)
    return clone
end

local function abs(n)
    if n < 0 then
        return -n
    end
    return n
end

local function RotationToDirection(rotation)
    local adjustedRotation = vec3(
        (math.pi / 180) * rotation.x,
        (math.pi / 180) * rotation.y,
        (math.pi / 180) * rotation.z
    )
    local direction = vec3(
        -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        math.sin(adjustedRotation.x)
    )
    return direction
end

local function LoadAnimDict(dict)
    local timer = GetGameTimer() + 5000
    while not HasAnimDictLoaded(dict) and GetGameTimer() < timer do
        RequestAnimDict(dict)
        Wait(10)
    end
end

function UpdateOrCreateClone()
    DestroyCloneAttachedProps()
    -- Delete the previous clone
    if emotePed ~= nil then
        DeletePed(emotePed)
        emotePed = nil
    end
    emotePed = createClone()
end

--[[ CreateThread(function()
    while true do
        Wait(10)
        if preview_emote ~= nil then
            local _ = GetGameplayCamCoord()
            -- Get the coordinates that are 5 units forward, 1 unit up and 1 unit right the coords _ depending on the rotation of the camera
            local rot = GetGameplayCamRot()
            local forward = RotationToDirection(rot)
            local right = RotationToDirection(vec3(rot.x, rot.y, rot.z - 90.0))
            local up = vec3(0.0, 0.0, 1.5)
            local coords = _ + forward * 5.0 + up * 0.8 + right * 1.2
            -- Set the ped coords to the coords we calculated
            SetEntityCoordsNoOffset(emotePed, coords, false, false, false)
            -- Make the ped look at the inverse of the camera
            SetEntityHeading(emotePed, rot.z + 180)
            SetEntityVisible(emotePed, true, false)
            -- Load the emote
            if not IsEntityPlayingAnim(emotePed, preview_emote[1], preview_emote[2], 3) then
                ClearPedTasks(emotePed)
                DestroyCloneAttachedProps()
                PreviewEmote(preview_emote)
            end
        else
            SetEntityVisible(emotePed, false, false)
            SetEntityCoordsNoOffset(emotePed, vec3(0.0, 0.0, 0.0), false, false, false)
        end
    end
end) ]]

function AttachProp(prop1, bone, off1, off2, off3, rot1, rot2, rot3, textureVariation, pedid)
    local Player = pedid or PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(Player))

    if not IsModelValid(prop1) then
        return false
    end

    if not HasModelLoaded(prop1) then
        LoadPropDict(prop1)
    end

    prop = CreateObject(joaat(prop1), x, y, z + 0.2, true, true, true)
    if textureVariation ~= nil then
        SetObjectTextureVariation(prop, textureVariation)
    end
    AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true,
        false, true, 1, true)
    if pedid ~= nil then
        table.insert(clone_attached_props, prop)
    else
        table.insert(attached_props, prop)
    end
    PlayerHasProp = true
    SetModelAsNoLongerNeeded(prop1)
end

function AttachPropLocal(prop1, bone, off1, off2, off3, rot1, rot2, rot3, textureVariation, pedid)
    local Player = pedid or PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(Player))

    if not IsModelValid(prop1) then
        return false
    end

    if not HasModelLoaded(prop1) then
        LoadPropDict(prop1)
    end

    prop = CreateObject(joaat(prop1), x, y, z + 0.2, false, true, true)
    if textureVariation ~= nil then
        SetObjectTextureVariation(prop, textureVariation)
    end
    AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true,
            false, true, 1, true)
    if pedid ~= nil then
        table.insert(clone_attached_props, prop)
    else
        table.insert(attached_props, prop)
    end
    PlayerHasProp = true
    SetModelAsNoLongerNeeded(prop1)
end

function DestroyAttachedProps()
    for i = 1, #attached_props do
        DeleteEntity(attached_props[i])
    end
    attached_props = {}
    PlayerHasProp = false
end

function DestroyCloneAttachedProps()
    for i = 1, #clone_attached_props do
        DeleteEntity(clone_attached_props[i])
    end
    clone_attached_props = {}
end

function PlayEmote(emote)

    current_emote = emote
    player_emoting_with = nil
    local flag = 1
    local duration = -1
    LoadAnimDict(emote[1])
    if emote.AnimationOptions then

        if emote.AnimationOptions.EmoteDuration then
            duration = emote.AnimationOptions.EmoteDuration
        end

        if emote.AnimationOptions.Prop then
            local x, y, z, xR, yR, zR = table.unpack(emote.AnimationOptions.PropPlacement)
            local propEntity = CreateObject(GetHashKey(emote.AnimationOptions.Prop), 0, 0, 0, true, true, true)
            AttachProp(emote.AnimationOptions.Prop, emote.AnimationOptions.PropBone, x, y, z, xR, yR, zR, emote.AnimationOptions.PropTextureVariation)
        end

        if emote.AnimationOptions.SecondProp then
            local x, y, z, xR, yR, zR = table.unpack(emote.AnimationOptions.SecondPropPlacement)
            local propEntity = CreateObject(GetHashKey(emote.AnimationOptions.SecondProp), 0, 0, 0, true, true, true)
            AttachProp(emote.AnimationOptions.SecondProp, emote.AnimationOptions.SecondPropBone, x, y, z, xR, yR, zR, emote.AnimationOptions.SecondPropTextureVariation)
        end

        if emote.AnimationOptions.EmoteMoving or IsPedInVehicle(PlayerPedId(-1), GetVehiclePedIsIn(PlayerPedId(-1), false), false) then
            flag = 51
        elseif emote.AnimationOptions.EmoteLoop then
            flag = 1
        elseif emote.AnimationOptions.EmoteStuck then
            flag = 50
        end
    end
    print(emote[1], emote[2],duration, flag)
    TaskPlayAnim(PlayerPedId(), emote[1], emote[2], 8.0, 8.0, duration, flag, 0, false, false, false)
end

function PreviewEmote(emote)
    local flag = 1
    local duration = -1
    LoadAnimDict(emote[1])
    if emote.AnimationOptions then

        if emote.AnimationOptions.EmoteDuration then
            duration = emote.AnimationOptions.EmoteDuration
        end

        if emote.AnimationOptions.Prop then
            local x, y, z, xR, yR, zR = table.unpack(emote.AnimationOptions.PropPlacement)
            local propEntity = CreateObject(GetHashKey(emote.AnimationOptions.Prop), 0, 0, 0, false, true, true)
            AttachPropLocal(emote.AnimationOptions.Prop, emote.AnimationOptions.PropBone, x, y, z, xR, yR, zR, emote.AnimationOptions.PropTextureVariation, emotePed)
        end

        if emote.AnimationOptions.SecondProp then
            local x, y, z, xR, yR, zR = table.unpack(emote.AnimationOptions.SecondPropPlacement)
            local propEntity = CreateObject(GetHashKey(emote.AnimationOptions.SecondProp), 0, 0, 0, false, true, true)
            AttachPropLocal(emote.AnimationOptions.SecondProp, emote.AnimationOptions.SecondPropBone, x, y, z, xR, yR, zR, emote.AnimationOptions.SecondPropTextureVariation, emotePed)
        end

        if emote.AnimationOptions.EmoteMoving or IsPedInVehicle(emotePed, GetVehiclePedIsIn(emotePed, false), false) then
            flag = 51
        elseif emote.AnimationOptions.EmoteLoop then
            flag = 1
        elseif emote.AnimationOptions.EmoteStuck then
            flag = 50
        end
    end
    TaskPlayAnim(emotePed, emote[1], emote[2], 8.0, 8.0, duration, flag, 0, false, false, false)
end

function PlaySharedEmote(emote, player)

    current_emote = emote
    player_emoting_with = player
    local flag = 1
    local duration = -1
    local pedInFront = GetPlayerPed(GetPlayerFromServerId(player))
    local ply = PlayerPedId()

    local SyncOffsetFront = 1.0
    local SyncOffsetSide = 0.0
    local SyncOffsetHeight = 0.0
    local SyncOffsetHeading = 180.1

    LoadAnimDict(emote[1])
    if emote.AnimationOptions then

        if emote.AnimationOptions.SyncOffsetFront then
            SyncOffsetFront = emote.AnimationOptions.SyncOffsetFront + 0.0
        end
        if emote.AnimationOptions.SyncOffsetSide then
            SyncOffsetSide = emote.AnimationOptions.SyncOffsetSide + 0.0
        end
        if emote.AnimationOptions.SyncOffsetHeight then
            SyncOffsetHeight = emote.AnimationOptions.SyncOffsetHeight + 0.0
        end
        if emote.AnimationOptions.SyncOffsetHeading then
            SyncOffsetHeading = emote.AnimationOptions.SyncOffsetHeading + 0.0
        end

        -- There is a priority to the source attached, if it is not set, it will use the target
        if (emote.AnimationOptions.Attachto) then
            local bone = emote.AnimationOptions.bone or -1 -- No bone
            local xPos = emote.AnimationOptions.xPos or 0.0
            local yPos = emote.AnimationOptions.yPos or 0.0
            local zPos = emote.AnimationOptions.zPos or 0.0
            local xRot = emote.AnimationOptions.xRot or 0.0
            local yRot = emote.AnimationOptions.yRot or 0.0
            local zRot = emote.AnimationOptions.zRot or 0.0
            AttachEntityToEntity(ply, pedInFront, GetPedBoneIndex(pedInFront, bone), xPos, yPos, zPos, xRot, yRot, zRot,
                false, false, false, true, 1, true)
        end

        if emote.AnimationOptions.EmoteDuration then
            duration = emote.AnimationOptions.EmoteDuration
        end

        if emote.AnimationOptions.Prop then
            local x, y, z, xR, yR, zR = table.unpack(emote.AnimationOptions.PropPlacement)
            local propEntity = CreateObject(GetHashKey(emote.AnimationOptions.Prop), 0, 0, 0, true, true, true)
            AttachProp(emote.AnimationOptions.Prop, emote.AnimationOptions.PropBone, x, y, z, xR, yR, zR, emote.AnimationOptions.PropTextureVariation)
        end

        if emote.AnimationOptions.SecondProp then
            local x, y, z, xR, yR, zR = table.unpack(emote.AnimationOptions.SecondPropPlacement)
            local propEntity = CreateObject(GetHashKey(emote.AnimationOptions.SecondProp), 0, 0, 0, true, true, true)
            AttachProp(emote.AnimationOptions.Prop, emote.AnimationOptions.PropBone, x, y, z, xR, yR, zR, emote.AnimationOptions.PropTextureVariation)
        end

        if emote.AnimationOptions.EmoteMoving or IsPedInVehicle(PlayerPedId(-1), GetVehiclePedIsIn(PlayerPedId(-1), false), false) then
            flag = 51
        elseif emote.AnimationOptions.EmoteLoop then
            flag = 1
        elseif emote.AnimationOptions.EmoteStuck then
            flag = 50
        end
    end

    --print(duration, flag)

    local coords = GetOffsetFromEntityInWorldCoords(pedInFront, SyncOffsetSide, SyncOffsetFront, SyncOffsetHeight)
    local heading = GetEntityHeading(pedInFront)
    SetEntityHeading(ply, heading - SyncOffsetHeading)
    SetEntityCoordsNoOffset(ply, coords.x, coords.y, coords.z, 0)
    TaskPlayAnim(PlayerPedId(), emote[1], emote[2], 8.0, 8.0, duration, flag, 0, false, false, false)
end

function StopEmote()
    if current_emote ~= nil then
        -- if entity is attached to another entity, detach it
        if current_emote.AnimationOptions ~= nil and current_emote.AnimationOptions.Attachto ~= nil then
            DetachEntity(PlayerPedId(), true, true)
        end
        -- if current emote is a shared emote, send a stop event to the other player
        if player_emoting_with then
            TriggerServerEvent("emotes:StopEmote", player_emoting_with)
        end
        DestroyAttachedProps()
        if current_emote.AnimationOptions ~= nil and current_emote.AnimationOptions.ExitEmote ~= nil then
            local exitEmote = EmotesList[current_emote.AnimationOptions.ExitEmoteType or "Exits"][current_emote.AnimationOptions.ExitEmote]
            current_emote = nil
            PlayEmote(exitEmote)
        else
            ClearPedTasks(PlayerPedId())
        end
        current_emote = nil
    end
    current_emote = nil
end

function RequestWalking(set)
    local timeout = GetGameTimer() + 5000
    while not HasAnimSetLoaded(set) and GetGameTimer() < timeout do
        RequestAnimSet(set)
        Wait(5)
    end
end

function pairsByKeys(t, f)
    local a = {}
    for n in pairs(t) do
        table.insert(a, n)
    end
    table.sort(a, f)
    local i = 0             -- iterator variable
    local iter = function() -- iterator function
        i = i + 1
        if a[i] == nil then
            return nil
        else
            return a[i], t[a[i]]
        end
    end
    return iter
end

function loadAnimDict2(dict)
    local timer = GetGameTimer() + 5000
	while not HasAnimDictLoaded(dict) and GetGameTimer() < timer do
		RequestAnimDict(dict)
		Wait(0)
	end
end

function LoadPropDict(model)
    -- load the model if it's not loaded and wait until it's loaded or timeout
    if not HasModelLoaded(joaat(model)) then
        RequestModel(joaat(model))
        local timeout = 2000
        while not HasModelLoaded(joaat(model)) and timeout > 0 do
            Wait(5)
            timeout = timeout - 5
        end
        if timeout == 0 then
            return
        end
    end
end

function CloneEmoteNearestPlayer()
    local ClosestPlayer, ClosestDistance = nil, nil
    for _, player in ipairs(GetActivePlayers()) do
        if player ~= PlayerId() then
            local ped = GetPlayerPed(player)
            local coords = GetEntityCoords(ped)
            local distance = #(GetEntityCoords(PlayerPedId()) - coords)
            if ClosestDistance == nil or distance < ClosestDistance then
                ClosestPlayer = player
                ClosestDistance = distance
            end
        end
    end
    if ClosestPlayer ~= nil and ClosestDistance < 3.0 then
        TriggerServerEvent("emotes:CloneEmote", GetPlayerServerId(ClosestPlayer))
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "~s Aucun joueur à proximité !"
        })
    end
end

function GetCurrentEmote()
    return current_emote
end