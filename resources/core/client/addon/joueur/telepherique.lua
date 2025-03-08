--[[function Lerp(a, b, t)
    return a + (b - a) * t
end

function VecLerp(x1, y1, z1, x2, y2, z2, t, clamp)
    if clamp then
        t = math.min(1.0, math.max(0.0, t))
    end
    local x = Lerp(x1, x2, t)
    local y = Lerp(y1, y2, t)
    local z = Lerp(z1, z2, t)
    return vector3(x, y, z)
end

local cable_attach = {
    [0] = {
        vector3(-740.911, 5599.341, 47.25),
        vector3(-739.557, 5599.346, 46.997),
        vector3(-581.009, 5596.517, 77.379),
        vector3(-575.717, 5596.388, 79.22),
        vector3(-273.805, 5590.844, 240.795),
        vector3(-268.707, 5590.744, 243.395),
        vector3(6.896, 5585.668, 423.614),
        vector3(11.774, 5585.591, 426.711),
        vector3(236.82, 5581.445, 599.642),
        vector3(241.365, 5581.369, 603.183),
        vector3(412.855, 5578.216, 774.401),
        vector3(417.541, 5578.124, 777.688),
        vector3(444.93, 5577.589, 786.535),
        vector3(446.288, 5577.59, 786.75),
    },
    [1] = {
        vector3(446.291, 5566.377, 786.75),
        vector3(444.937, 5566.383, 786.551),
        vector3(417.371, 5567.001, 777.708),
        vector3(412.661, 5567.085, 774.439),
        vector3(241.31, 5570.594, 603.137),
        vector3(236.821, 5570.663, 599.561),
        vector3(11.35, 5575.298, 426.629),
        vector3(6.575, 5575.391, 423.57),
        vector3(-268.965, 5580.996, 243.386),
        vector3(-273.993, 5581.124, 240.808),
        vector3(-575.898, 5587.286, 79.251),
        vector3(-581.321, 5587.4, 77.348),
        vector3(-739.646, 5590.614, 47.006),
        vector3(-740.97, 5590.617, 47.306),
    },
}

local telepherique = {
    [0] = {
        name = "téléphérique",
        entity = nil,
        doorLL = nil,
        doorLR = nil,
        doorRL = nil,
        doorRR = nil,
        index = 0, 
        position = vector3(0,0,0), 
        direction = 1, 
        gradient = 1,
        run_timer = 0, 
        gradient_distance = 0.0, 
        offset_modifier = 0.0,
        can_move = true,
        is_player_seated = false,
        speed = 15, 
        maxSpeedDistance = 50,
        state = "IDLE", 
        showTramBlips = true,
        offset = vector3(-0.2, 0.0, 0.0),
    },
    [1] = {
        name = "téléphérique",
        entity = nil,
        doorLL = nil,
        doorLR = nil,
        doorRL = nil,
        doorRR = nil,
        index = 1,
        position = vector3(0,0,0),
        direction = 1,
        gradient = 1,
        run_timer = 0,
        gradient_distance = 0.0,
        offset_modifier = 0.0,
        can_move = true,
        is_player_seated = false,
        speed = 15,
        maxSpeedDistance = 50,
        state = "IDLE",
        showTramBlips = true,
        offset = vector3(-0.2, 0.0, 0.0),
    },
}

Citizen.CreateThread(function()
    while not HasModelLoaded("p_cablecar_s") do
        RequestModel("p_cablecar_s")
        Wait(100)
    end
    while not HasModelLoaded("p_cablecar_s_door_l") do
        RequestModel("p_cablecar_s_door_l")
        Wait(100)
    end
    while not HasModelLoaded("p_cablecar_s_door_r") do
        RequestModel("p_cablecar_s_door_r")
        Wait(100)
    end
    while not HasAnimDictLoaded("p_cablecar_s") do
        RequestAnimDict("p_cablecar_s")
        Wait(100)
    end

    LoadStream("CABLE_CAR", "CABLE_CAR_SOUNDS")
    LoadStream("CABLE_CAR_SOUNDS", "CABLE_CAR")
    RequestScriptAudioBank("CABLE_CAR", false, -1)
    RequestScriptAudioBank("CABLE_CAR_SOUNDS", false, -1)

    telepherique[0].entity = CreateObjectNoOffset("p_cablecar_s", -740.911, 5599.341, 47.25, 0, 1, 0)
    telepherique[0].doorLL = CreateObjectNoOffset("p_cablecar_s_door_l", -740.911, 5599.341, 47.25, 0, 1, 0)
    telepherique[0].doorLR = CreateObjectNoOffset("p_cablecar_s_door_r", -740.911, 5599.341, 47.25, 0, 1, 0)
    AttachEntityToEntity(telepherique[0].doorLL, telepherique[0].entity, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 1, 0, 2, 1)
    AttachEntityToEntity(telepherique[0].doorLR, telepherique[0].entity, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 1, 0, 2, 1)
    telepherique[0].doorRL = CreateObjectNoOffset("p_cablecar_s_door_l", -740.911, 5599.341, 47.25, 0, 1, 0)
    telepherique[0].doorRR = CreateObjectNoOffset("p_cablecar_s_door_r", -740.911, 5599.341, 47.25, 0, 1, 0)
    AttachEntityToEntity(telepherique[0].doorRL, telepherique[0].entity, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 180.0, 0, 0, 1, 0, 2, 1)
    AttachEntityToEntity(telepherique[0].doorRR, telepherique[0].entity, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 180.0, 0, 0, 1, 0, 2, 1)

    telepherique[1].entity = CreateObjectNoOffset("p_cablecar_s", 446.291, 5566.377, 786.75, 0, 1, 0)
    telepherique[1].doorLL = CreateObjectNoOffset("p_cablecar_s_door_l", -740.911, 5599.341, 47.25, 0, 1, 0)
    telepherique[1].doorLR = CreateObjectNoOffset("p_cablecar_s_door_r", -740.911, 5599.341, 47.25, 0, 1, 0)
    AttachEntityToEntity(telepherique[1].doorLL, telepherique[1].entity, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 1, 0, 2, 1)
    AttachEntityToEntity(telepherique[1].doorLR, telepherique[1].entity, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 1, 0, 2, 1)
    telepherique[1].doorRL = CreateObjectNoOffset("p_cablecar_s_door_l", -740.911, 5599.341, 47.25, 0, 1, 0)
    telepherique[1].doorRR = CreateObjectNoOffset("p_cablecar_s_door_r", -740.911, 5599.341, 47.25, 0, 1, 0)
    AttachEntityToEntity(telepherique[1].doorRL, telepherique[1].entity, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 180.0, 0, 0, 1, 0, 2, 1)
    AttachEntityToEntity(telepherique[1].doorRR, telepherique[1].entity, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 180.0, 0, 0, 1, 0, 2, 1)

    SetEntityRotation(telepherique[0].entity, 0.0, 0.0, 270.0, 0, 1)
    SetEntityRotation(telepherique[1].entity, 0.0, 0.0, 90.0, 0, 1)

    telepherique[0].state = "MOVE_TO_IDLE_TOP"
    telepherique[1].state = "MOVE_TO_IDLE_TOP"

    if telepherique[0].showTramBlips then
        local blipstelepherique1 = AddBlipForEntity(telepherique[0].entity)      
        SetBlipSprite (blipstelepherique1, 36)
        SetBlipDisplay(blipstelepherique1, 4)
        SetBlipScale  (blipstelepherique1, 0.8)
        SetBlipColour (blipstelepherique1, 21)
        SetBlipAsShortRange(blipstelepherique1, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(telepherique[0].name)
        EndTextCommandSetBlipName(blipstelepherique1)
    end
    if telepherique[1].showTramBlips then
        local blipstelepherique2 = AddBlipForEntity(telepherique[1].entity)      
        SetBlipSprite (blipstelepherique2, 36)
        SetBlipDisplay(blipstelepherique2, 4)
        SetBlipScale  (blipstelepherique2, 0.8)
        SetBlipColour (blipstelepherique2, 21)
        SetBlipAsShortRange(blipstelepherique2, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(telepherique[1].name)
        EndTextCommandSetBlipName(blipstelepherique2)
    end

    while true do
        Wait(0)
        for ccIndex, telepherique_props in next, telepherique do
            UpdateTelepheriqueMovement(telepherique_props)
        end
    end
end)

RegisterNetEvent("core:telepherique:forceState")
AddEventHandler("core:telepherique:forceState", function(index, state)
    local telepherique_props = telepherique[index]
    if state == "IDLE_BOTTOM" then
        telepherique_props.state = "MOVE_TO_IDLE_BOTTOM"
        telepherique_props.run_timer = 0.0
    end
    if state == "IDLE_TOP" then
        telepherique_props.state = "MOVE_TO_IDLE_TOP"
        telepherique_props.run_timer = 0.0
    end
    if state == "MOVE_DOWN" then
        telepherique_props.state = "IDLE_TO_MOVE_DOWN"
        telepherique_props.gradient = #cable_attach[index]
        telepherique_props.gradient_distance = 0.0
        telepherique_props.run_timer = 0.0
    end
    if state == "MOVE_UP" then
        telepherique_props.state = "IDLE_TO_MOVE_UP"
        telepherique_props.gradient = 1
        telepherique_props.gradient_distance = 0.0
        telepherique_props.run_timer = 0.0
    end
end)


function UpdateTelepheriqueMovement(telepherique_props)
    if telepherique_props.state == "MOVE_UP" then
        telepherique_props.direction = 1.0

        local _prev, _next = cable_attach[telepherique_props.index][telepherique_props.gradient], cable_attach[telepherique_props.index][telepherique_props.gradient + 1]

        if telepherique_props.gradient_distance == 0.0 then
            telepherique_props.gradient_distance = GetDistanceBetweenCoords(_prev, _next, true)
        end

        local dist = telepherique_props.gradient_distance
        local speed = ((1.0 / dist) * Timestep()) * telepherique_props.speed
        
        local distanceFromOrigin = GetDistanceBetweenCoords(cable_attach[telepherique_props.index][#cable_attach[telepherique_props.index]]--, telepherique_props.position, true)
--[[        local distanceFromDestin = GetDistanceBetweenCoords(cable_attach[telepherique_props.index][1], telepherique_props.position, true)
        if distanceFromOrigin <= telepherique_props.maxSpeedDistance then
            speed = speed * math.abs(distanceFromOrigin + 1)/telepherique_props.maxSpeedDistance
        elseif distanceFromDestin <= telepherique_props.maxSpeedDistance then
            speed = speed * math.abs(distanceFromDestin + 1)/telepherique_props.maxSpeedDistance
        end

        telepherique_props.run_timer = telepherique_props.run_timer + speed

        if telepherique_props.run_timer > 1.0 then
            telepherique_props.gradient = telepherique_props.gradient + 1

            _prev, _next = cable_attach[telepherique_props.index][telepherique_props.gradient], cable_attach[telepherique_props.index][telepherique_props.gradient + 1]
            telepherique_props.gradient_distance = GetDistanceBetweenCoords(_prev, _next, true)
            telepherique_props.run_timer = 0.0

            if telepherique_props.gradient >= #cable_attach[telepherique_props.index] then
                telepherique_props.state = "MOVE_TO_IDLE_TOP"
                telepherique_props.gradient_distance = 0.0
                return
            end

            UpdateCablecarGradient(telepherique_props)
        else
            telepherique_props.position = VecLerp(_prev.x, _prev.y, _prev.z, _next.x, _next.y, _next.z, telepherique_props.run_timer, true)
        end

        local zLerp = 0.0
        if telepherique_props.gradient_distance > 30.0 then
            zLerp = (-1.0 + math.abs(Lerp(1.0, -1.0, telepherique_props.run_timer))) * 0.25
        end

        SetEntityCoords(telepherique_props.entity, telepherique_props.position + telepherique_props.offset + vector3(0.0, 0.0, zLerp), 1, false, 0, 1)
        GivePlayerOptionToJoinMyCablecar(telepherique_props, true)

    elseif telepherique_props.state == "MOVE_DOWN" then

        telepherique_props.direction = -1.0

        local _prev, _next = cable_attach[telepherique_props.index][telepherique_props.gradient], cable_attach[telepherique_props.index][telepherique_props.gradient - 1]

        if telepherique_props.gradient_distance == 0.0 then
            telepherique_props.gradient_distance = GetDistanceBetweenCoords(_prev, _next, true)
        end

        local dist = telepherique_props.gradient_distance
        local speed = ((1.0 / dist) * Timestep()) * telepherique_props.speed
        
        local distanceFromOrigin = GetDistanceBetweenCoords(cable_attach[telepherique_props.index][#cable_attach[telepherique_props.index]]--, telepherique_props.position, true)
 --[[       local distanceFromDestin = GetDistanceBetweenCoords(cable_attach[telepherique_props.index][1], telepherique_props.position, true)
        if distanceFromOrigin <= telepherique_props.maxSpeedDistance then
            speed = speed * math.abs(distanceFromOrigin + 1)/telepherique_props.maxSpeedDistance
        elseif distanceFromDestin <= telepherique_props.maxSpeedDistance then
            speed = speed * math.abs(distanceFromDestin + 1)/telepherique_props.maxSpeedDistance
        end

        telepherique_props.run_timer = telepherique_props.run_timer + speed

        if telepherique_props.run_timer > 1.0 then
            telepherique_props.gradient = telepherique_props.gradient - 1

            _prev, _next = cable_attach[telepherique_props.index][telepherique_props.gradient], cable_attach[telepherique_props.index][telepherique_props.gradient - 1]
            telepherique_props.gradient_distance = GetDistanceBetweenCoords(_prev, _next, true)
            telepherique_props.run_timer = 0.0

            if telepherique_props.gradient <= 1 then
                telepherique_props.state = "IDLE"
                telepherique_props.gradient_distance = 0.0
                TriggerServerEvent("core:telepherique:synchronise", telepherique_props.index, "IDLE_BOTTOM")
                return
            end
            UpdateCablecarGradient(telepherique_props)
        else
            telepherique_props.position = VecLerp(_prev.x, _prev.y, _prev.z, _next.x, _next.y, _next.z, telepherique_props.run_timer, true)
        end

        local zLerp = 0.0
        if telepherique_props.gradient_distance > 20.0 then
            zLerp = (-1.0 + math.abs(Lerp(1.0, -1.0, telepherique_props.run_timer))) * 0.25
        end

        SetEntityCoords(telepherique_props.entity, telepherique_props.position + telepherique_props.offset + vector3(0.0, 0.0, zLerp), 1, false, 0, 1)
        GivePlayerOptionToJoinMyCablecar(telepherique_props, true)

    elseif telepherique_props.state == "IDLE_TO_MOVE_UP" then

        telepherique_props.gradient = 1
        telepherique_props.gradient_distance = 0.0
        telepherique_props.run_timer = 0.0

        SetCablecarDoors(telepherique_props, false)

        telepherique_props.audio = GetSoundId()
        PlaySoundFromEntity(telepherique_props.audio, "Running", telepherique_props.entity, "CABLE_CAR_SOUNDS", 0, 0)

        telepherique_props.state = "MOVE_UP"

    elseif telepherique_props.state == "IDLE_TO_MOVE_DOWN" then

        telepherique_props.gradient = #cable_attach[telepherique_props.index]
        telepherique_props.gradient_distance = 0.0
        telepherique_props.run_timer = 0.0

        SetCablecarDoors(telepherique_props, false)
        
        telepherique_props.audio = GetSoundId()
        PlaySoundFromEntity(telepherique_props.audio, "Running", telepherique_props.entity, "CABLE_CAR_SOUNDS", 0, 0)

        telepherique_props.state = "MOVE_DOWN"

    elseif telepherique_props.state == "MOVE_TO_IDLE_TOP" then

        telepherique_props.position = cable_attach[telepherique_props.index][#cable_attach[telepherique_props.index]]
        --[[SetEntityCoords(telepherique_props.entity, telepherique_props.position + telepherique_props.offset + vector3(0.0, 0.0, 0.0), 1, false, 0, 1)

        SetCablecarDoors(telepherique_props, true)
        StartSound(telepherique_props)

        telepherique_props.state = "IDLE_TOP"
        telepherique_props.run_timer = 0.0

    elseif telepherique_props.state == "MOVE_TO_IDLE_BOTTOM" then

        telepherique_props.position = cable_attach[telepherique_props.index][1]
        SetEntityCoords(telepherique_props.entity, telepherique_props.position + telepherique_props.offset + vector3(0.0, 0.0, 0.0), 1, false, 0, 1)

        SetCablecarDoors(telepherique_props, true)
        StartSound(telepherique_props)

        telepherique_props.state = "IDLE_BOTTOM"
        telepherique_props.run_timer = 0.0

    elseif telepherique_props.state == "IDLE_TOP" then

        telepherique_props.run_timer = telepherique_props.run_timer + (Timestep() / 20.0)

        if telepherique_props.run_timer > 1.0 then
            telepherique_props.state = "IDLE_TO_MOVE_DOWN"
            telepherique_props.run_timer = 0.0
        end

        GivePlayerOptionToJoinMyCablecar(telepherique_props)

    elseif telepherique_props.state == "IDLE_BOTTOM" then

        telepherique_props.run_timer = telepherique_props.run_timer + (Timestep() / 20.0)
        if telepherique_props.run_timer > 1.0 then
            telepherique_props.state = "IDLE_TO_MOVE_UP"
            telepherique_props.run_timer = 0.0
        end

        GivePlayerOptionToJoinMyCablecar(telepherique_props)

    elseif telepherique_props.state == "IDLE" then

    end
end

function StartSound(telepherique_props)
    if telepherique_props.audio ~= -1 and telepherique_props.audio ~= nil then
        StopSound(telepherique_props.audio)
        ReleaseSoundId(telepherique_props.audio)
        telepherique_props.audio = -1
    end
end

function GivePlayerOptionToJoinMyCablecar(telepherique_props, moving)
    local ply = PlayerPedId()
    local pos = telepherique_props.position + vector3(0.0, 0.0, -5.3)
    if not telepherique_props.is_player_seated then
        local plypos = GetEntityCoords(ply, true)
        local dist = #(pos - plypos)
        if dist < 3.0 then
            ShowNotification("Appuyez sur E pour entrer dans le téléphérique")
            if IsControlJustPressed(0, 38) then
                telepherique_props.is_player_seated = true
                AttachEntityToEntity(ply, telepherique_props.entity, -1, (plypos - telepherique_props.position), GetEntityRotation(ply, 0), 0, 0, 1, 1, 0, 1)
            end
        end
    else
        if not moving then
            ShowNotification("Appuyez sur E pour sortir dans le téléphérique")
            if IsControlJustPressed(0, 38) then
                telepherique_props.is_player_seated = false
                DetachEntity(ply, 0, 0)
            end
        end
    end
end

function ShowNotification(title, description)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(title)
    AddTextComponentString(description)
    DrawNotification(true, true)
end

function SetCablecarDoors(telepherique_props, state)
    local doorClosePos = 0.95
    local doorOpenDist = 0.9
    if state == true then
        doorStart = doorClosePos
        doorDirect = 1
        PlaySoundFromEntity(-1, "station_arriver", telepherique_props.entity, "CABLE_CAR_SOUNDS", 0, 0)
        PlaySoundFromEntity(-1, "DOOR_OPEN", telepherique_props.entity, "CABLE_CAR_SOUNDS", 0, 0)
    else
        doorStart = doorClosePos+doorOpenDist
        doorDirect = -1
        PlaySoundFromEntity(-1, "station_depart", telepherique_props.entity, "CABLE_CAR_SOUNDS", 0, 0)
        PlaySoundFromEntity(-1, "DOOR_CLOSE", telepherique_props.entity, "CABLE_CAR_SOUNDS", 0, 0)
    end
    
    for i = 0,100,1
    do
        local doorPos = doorStart+doorDirect*doorOpenDist*(i/100)
        DetachEntity(telepherique_props.doorLL, 0, 0)
        DetachEntity(telepherique_props.doorLR, 0, 0)
        DetachEntity(telepherique_props.doorRL, 0, 0)
        DetachEntity(telepherique_props.doorRR, 0, 0)
        AttachEntityToEntity(telepherique_props.doorLL, telepherique_props.entity, 0, 0.0, -doorPos, 0.0, 0.0, 0.0, 0.0, 0, 0, 1, 0, 2, 1)
        AttachEntityToEntity(telepherique_props.doorLR, telepherique_props.entity, 0, 0.0, doorPos, 0.0, 0.0, 0.0, 0.0, 0, 0, 1, 0, 2, 1)
        AttachEntityToEntity(telepherique_props.doorRL, telepherique_props.entity, 0, 0.0, doorPos, 0.0, 0.0, 0.0, 180.0, 0, 0, 1, 0, 2, 1)
        AttachEntityToEntity(telepherique_props.doorRR, telepherique_props.entity, 0, 0.0, -doorPos, 0.0, 0.0, 0.0, 180.0, 0, 0, 1, 0, 2, 1)
        Wait(10)
    end
    Wait(2000)
end

function WhatDirectionDoesMyCablecarGo(telepherique_props)
    if telepherique_props.index == 0 then
        if telepherique_props.direction >= 0 then
            return 0
        else
            return 1
        end
    else
        if telepherique_props.direction >= 0 then
            return 1
        else
            return 0
        end
    end
end

function UpdateCablecarGradient(telepherique_props)
    local text = "C" .. (telepherique_props.index + 1)
    if WhatDirectionDoesMyCablecarGo(telepherique_props) == 0 then
        local _data = {
            [0] = "_up_9",
            [1] = "_up_1",
            [3] = "_up_3",
            [5] = "_up_4",
            [7] = "_up_5",
            [9] = "_up_6",
            [11] = "_up_8",
            [12] = "_up_9",
        }
        if _data[telepherique_props.gradient - 1] then
            text = text .. _data[telepherique_props.gradient - 1]
        else
            return 0
        end
    else
        local _data = {
            [0] = "_down_1",
            [1] = "_down_2",
            [3] = "_down_3",
            [5] = "_down_4",
            [7] = "_down_5",
            [9] = "_down_6",
            [11] = "_down_8",
            [12] = "_down_9",
        }
        if _data[telepherique_props.gradient - 1] then
            text = text .. _data[telepherique_props.gradient - 1]
        else
            return 0
        end
    end
    PlayEntityAnim(telepherique_props.entity, text, "p_cablecar_s", 8.0, false, 1, 0, 0, 0)
    return 1
end]]