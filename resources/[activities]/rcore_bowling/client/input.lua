-- Citizen.CreateThread(function()
--     local laneName = 'GABZ_2'
--     SetGameplayCoordHint(Lanes[laneName].End.x, Lanes[laneName].End.y, Lanes[laneName].End.z, 3000, 100, 500, 0)
-- end)

function HandleBowlingInput(laneName)
    local timePassed = 0
    local startPos = nil
    local angle = nil
    local rotation = nil
    local power = nil

    -- pozice
    -- uhel
    -- rotace
    -- sila
    local ped = PlayerPedId()
    local startToEndVector = (Lanes[laneName].Start - Lanes[laneName].End)
    local fwdVector = startToEndVector / #startToEndVector

    local blockControls = true
    Citizen.CreateThreadNow(function()
        while blockControls do

            DisableAllControlActions(0)
            EnableControlAction(0, 249, true)
            EnableControlAction(0, 245, true)
    
            EnableControlAction(0, 1, true) -- mouse
            EnableControlAction(0, 2, true) -- mouse

            Wait(0)
        end
    end)

    FadeOut()

    SetEntityCoords(ped, Lanes[laneName].Start + fwdVector*1.2, 0.0, 0.0, 0.0, false)
    SetEntityHeading(ped, Lanes[laneName].StartBaseAngle)
    TaskPlayAnim(ped, holdBallDict, holdBallAnim, 8.0, 8.0, -1, 2 + 16 + 32, 1.0, false, false, false)

    local bowlingCam = CreateCam("DEFAULT_SCRIPTED_CAMERA" , 1)

    local camPos = Lanes[laneName].Start + fwdVector*1.0 + vector3(0.0, 0.0, 0.8)
    SetCamCoord(bowlingCam, camPos)

    PointCamAtCoord(bowlingCam, Lanes[laneName].Start - fwdVector)

    SetCamFov(bowlingCam, 50.0)

    RenderScriptCams(1, 0, 0, 1, 2)
    FadeIn()



    while true do
        Wait(0)

        DisplayHelpTextThisFrame('R_CONF', false)

        if startPos == nil then
            timePassed = timePassed + GetFrameTime() * 1.2 -- for position
            startPos = HandlePositionInput(timePassed, laneName)

            if startPos ~= nil then
                timePassed = 0
            end
        elseif angle == nil then
            timePassed = timePassed + GetFrameTime() * 3.0 -- for angle
            angle = HandleAngleInput(timePassed, laneName, startPos)

            if angle ~= nil then
                timePassed = 0
            end
        elseif rotation == nil then
            timePassed = timePassed + GetFrameTime() * 2.0 -- for rotation
            rotation = HandleRotationInput(timePassed, laneName)

            if rotation ~= nil then
                timePassed = 0
            end
        elseif power == nil then
            timePassed = timePassed + GetFrameTime() * 2.0 -- for power
            power = HandlePowerInput(timePassed, laneName)

            if power ~= nil then
                timePassed = 0
            end
        else
            break
        end
    end


    FadeOut()
    RenderScriptCams(0, 0, 0, 0, 0)

    blockControls = false

    DestroyCam(bowlingCam, false)
    Citizen.CreateThread(function()
        Wait(0)
        SetGameplayCoordHint(Lanes[laneName].End.x, Lanes[laneName].End.y, Lanes[laneName].End.z, 4000, 100, 500, 0)
        FadeIn()
    end)

    -- LEFTMOST
    -- startPos -> 0.0
    -- angle -> 1.0
    -- rotation -> -1

    -- RIGHTMOST
    -- startPos -> 1.0
    -- angle -> -1.0
    -- rotation -> 1

    -- power 0 -> 1

    return startPos,
            angle * 6,
            rotation * 2,
            power
end

-- Citizen.CreateThread(function()
--     local lane = Lanes.BREZE_1
--     local startPos, angle, rotation, power = HandleBowlingInput('BREZE_1')

-- 	lane.pins = SpawnPins(lane)

-- 	Wait(100)

-- 	ThrowBowlingBall(lane, startPos, angle, 1.0, rotation * 2)

-- end)

local angleArrowPoints = {
    vector2(0.06, 0.0),
    vector2(0.06, 0.5 + 3),
    vector2(0.13, 0.5 + 3),

    vector2(0.0, 0.7 + 3),
    
    vector2(-0.06, 0.0),
    vector2(-0.06, 0.5 + 3),
    vector2(-0.13, 0.5 + 3),
}

local rotationArrowStraight = {
    vector2(0.06, 0.45 + 0.0),
    vector2(0.06, 0.45 + 0.5),
    vector2(0.10, 0.45 + 0.5),

    vector2(0.0, 0.45 + 0.6),
    
    vector2(-0.06, 0.45 + 0.0),
    vector2(-0.06, 0.45 + 0.5),
    vector2(-0.10, 0.45 + 0.5),
}

local rotationArrowPoints = {
    vector2(0.0, 0.06),
    vector2(0.5, 0.06),
    vector2(0.5, 0.10),

    vector2(0.6, 0.0),
    
    vector2(0.0, -0.06),
    vector2(0.5, -0.06),
    vector2(0.5, -0.10),
}

local angleArrowPointsOrder = {
    {1, 2, 6},
    {6, 5, 1},
    {4, 7, 3}
}

function ComputeArrowPos(startPos, startAngle, point, angle, ballOffset)
    if not ballOffset then
        ballOffset = 0.5
    end
    
    return vector3(
        startPos.x + math.cos(math.rad(startAngle + angle)) * point.x + math.cos(math.rad(startAngle + angle + 90)) * point.y + math.cos(math.rad(startAngle)) * lerp(LANE_POS_MIN, LANE_POS_MAX, ballOffset),
        startPos.y + math.sin(math.rad(startAngle + angle)) * point.x + math.sin(math.rad(startAngle + angle + 90)) * point.y + math.sin(math.rad(startAngle)) * lerp(LANE_POS_MIN, LANE_POS_MAX, ballOffset),
        startPos.z
    )
end

function HandleAngleInput(t, laneName, startPosOffset)
    local lane = Lanes[laneName]

    local offset = math.sin(t) * LANE_POS_MAX

    SubtitleText(Config.Text.INPUT_ANGLE)

    for _, points in pairs(angleArrowPointsOrder) do
        local p1 = ComputeArrowPos(lane.StartPos, lane.StartBaseAngle, angleArrowPoints[points[1]], offset * 10, startPosOffset)
        local p2 = ComputeArrowPos(lane.StartPos, lane.StartBaseAngle, angleArrowPoints[points[2]], offset * 10, startPosOffset)
        local p3 = ComputeArrowPos(lane.StartPos, lane.StartBaseAngle, angleArrowPoints[points[3]], offset * 10, startPosOffset)

        DrawPoly(
            p1.x, p1.y, p1.z + 0.01, 
            p2.x, p2.y, p2.z + 0.01, 
            p3.x, p3.y, p3.z + 0.01, 
            0, 0, 0, 150
        )
    end

    if IsControlJustPressed(0, 24) or IsDisabledControlJustPressed(0, 24) then
        return offset / LANE_POS_MAX
    end
end


function HandlePowerInput(t, laneName)
    local lane = Lanes[laneName]

    local amplitude = 2
    local offset = (1/amplitude) * (amplitude - math.abs(t % (2*amplitude) - amplitude) )
    
    local powerOffset = {
        vector2(0.0, 0.0),
        vector2(0.0, 1 * offset - 3),
        vector2(0.0, 1 * offset - 3),
    
        vector2(0.0, 1 * offset - 3),
        
        vector2(0.0, 0.0),
        vector2(0.0, 1 * offset - 3),
        vector2(0.0, 1 * offset - 3),
    }

    SubtitleText(Config.Text.INPUT_POWER)

    for _, points in pairs(angleArrowPointsOrder) do
        local p1 = ComputeArrowPos(lane.StartPos, lane.StartBaseAngle, angleArrowPoints[points[1]] + powerOffset[points[1]], 0)
        local p2 = ComputeArrowPos(lane.StartPos, lane.StartBaseAngle, angleArrowPoints[points[2]] + powerOffset[points[2]], 0)
        local p3 = ComputeArrowPos(lane.StartPos, lane.StartBaseAngle, angleArrowPoints[points[3]] + powerOffset[points[3]], 0)

        DrawPoly(
            p1.x, p1.y, p1.z + 0.01, 
            p2.x, p2.y, p2.z + 0.01, 
            p3.x, p3.y, p3.z + 0.01, 
            50 + tonumber(math.floor(offset * 100)), 0, 0, 150
        )
    end

    if IsControlJustPressed(0, 24) or IsDisabledControlJustPressed(0, 24) then
        return offset
    end
end

function HandleRotationInput(t, laneName)
    local lane = Lanes[laneName]

    local offset = math.sin(t)

    SubtitleText(Config.Text.INPUT_ROTATION)

    if math.abs(offset) < 0.3 then
        for _, points in pairs(angleArrowPointsOrder) do
            local p1 = ComputeArrowPos(lane.StartPos, lane.StartBaseAngle, rotationArrowStraight[points[1]], 0.0)
            local p2 = ComputeArrowPos(lane.StartPos, lane.StartBaseAngle, rotationArrowStraight[points[2]], 0.0)
            local p3 = ComputeArrowPos(lane.StartPos, lane.StartBaseAngle, rotationArrowStraight[points[3]], 0.0)
    
            DrawPoly(
                p1.x, p1.y, p1.z + 0.01, 
                p2.x, p2.y, p2.z + 0.01, 
                p3.x, p3.y, p3.z + 0.01, 
                0, 0, 0, 150
            )
        end

        if IsControlJustPressed(0, 24) or IsDisabledControlJustPressed(0, 24) then
            return 0.0
        end
    else
        for _, points in pairs(angleArrowPointsOrder) do

            local rotArPoint1 = vector2(rotationArrowPoints[points[3]].x * offset, rotationArrowPoints[points[3]].y)
            local rotArPoint2 = vector2(rotationArrowPoints[points[2]].x * offset, rotationArrowPoints[points[2]].y)
            local rotArPoint3 = vector2(rotationArrowPoints[points[1]].x * offset, rotationArrowPoints[points[1]].y)

            local p1 = ComputeArrowPos(lane.StartPos, lane.StartBaseAngle, rotArPoint1 + vector2(0.0, 0.5), 0.0)
            local p2 = ComputeArrowPos(lane.StartPos, lane.StartBaseAngle, rotArPoint2 + vector2(0.0, 0.5), 0.0)
            local p3 = ComputeArrowPos(lane.StartPos, lane.StartBaseAngle, rotArPoint3 + vector2(0.0, 0.5), 0.0)

            if offset < 0 then
                DrawPoly(
                    p1.x, p1.y, p1.z + 0.01, 
                    p3.x, p3.y, p3.z + 0.01, 
                    p2.x, p2.y, p2.z + 0.01, 
                    0, 0, 0, 150
                )
            else
                DrawPoly(
                    p1.x, p1.y, p1.z + 0.01, 
                    p2.x, p2.y, p2.z + 0.01, 
                    p3.x, p3.y, p3.z + 0.01, 
                    0, 0, 0, 150
                )
            end
        end
    end

    if IsControlJustPressed(0, 24) or IsDisabledControlJustPressed(0, 24) then
        return offset
    end
end

function HandlePositionInput(t, laneName)
    local lane = Lanes[laneName]

    local offset = math.sin(t) * LANE_POS_MAX

    local ballPos = vector3(
        lane.StartPos.x + math.cos(math.rad(lane.StartBaseAngle)) * offset, 
        lane.StartPos.y + math.sin(math.rad(lane.StartBaseAngle)) * offset,
        lane.StartPos.z
    )

    SubtitleText(Config.Text.INPUT_POSITION)

    DrawMarker(
        0, 
        ballPos.x, ballPos.y, ballPos.z + 0.1,
        0.0, 0.0, 0.0, 
        0.0, 0.0, 0.0, 
        0.3, 0.3, 0.2, 
        255, 0, 0, 100, 
        false, false, false, false, nil, nil, false
    )
    
    if IsControlJustPressed(0, 24) or IsDisabledControlJustPressed(0, 24) then
        return ((offset / LANE_POS_MAX) + 1.0) / 2
    end
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 0 )
    end
end

local opacity = 0

function FadeOut()
    local time = 1000
    breakFadeIn = true
    breakFadeOut = false
    local startOpacity = opacity
    time = time - (startOpacity/255) * time
    local timeAcc = 0

    Citizen.CreateThread(function()
        while opacity > 0 do
            Wait(0)
            DrawRect(0.5, 0.5, 2.0, 2.0, 0, 0, 0, opacity)
        end
    end)

    while opacity < 255 do
        if breakFadeOut then
            breakFadeOut = false
            break
        end
        timeAcc = timeAcc + (GetFrameTime()*1000)
        opacity = math.ceil(math.min(255, lerp(startOpacity, 255, timeAcc/time)))
        Citizen.Wait(0)
    end
end

function FadeIn()
    local time = 1000
    breakFadeOut = true
    breakFadeIn = false
    local startOpacity = opacity

    time = time * (startOpacity/255)

    local timeAcc = 0

    while opacity > 0 do
        if breakFadeIn then
            breakFadeIn = false
            break
        end
        timeAcc = timeAcc + (GetFrameTime()*1000)
        opacity = math.ceil(math.max(0, lerp(startOpacity, 0, timeAcc/time)))
        Citizen.Wait(0)
    end
end
