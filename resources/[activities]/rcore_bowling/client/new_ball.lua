-- root -153.02, -257.42, 43.2



-- Citizen.CreateThread(function()
--     for i = 1, 8 do
--         Citizen.CreateThread(function()
--             local lane = Lanes['BREZE_' .. i]
--             lane.ballEnt = CreateObject(`prop_bowling_ball`, lane.SourceRoot.x, lane.SourceRoot.y, lane.SourceRoot.z, false, false, true)
--             table.insert(deleteOnEnd, lane.ballEnt)
--             AnimateBallToRack(lane)
--         end)
        
--         Wait(math.random(300, 800))
--     end
-- end)

function CreateBallInRack(lane)
    local pointsData = lane.SourcePoints[lane.SourceSide]
    local bowlBall = lane.ballEnt

    ensureModel(`prop_bowling_ball`)

    if not bowlBall then
        lane.ballEnt = CreateObject(
            `prop_bowling_ball`, 
            lane.SourceRoot.x + pointsData[#pointsData][1].x, lane.SourceRoot.y + pointsData[#pointsData][1].y, lane.SourceRoot.z + pointsData[#pointsData][1].z, 
            false, false, true
        )

        SetEntityCollision(lane.ballEnt, false, false)
        FreezeEntityPosition(lane.ballEnt, true)
        table.insert(deleteOnEnd, lane.ballEnt)
    end
end

function AnimateBallToRack(lane)
    local pointsData = lane.SourcePoints[lane.SourceSide]
    local bowlBall = lane.ballEnt

    ensureModel(`prop_bowling_ball`)

    if not bowlBall then
        lane.ballEnt = CreateObject(
            `prop_bowling_ball`, 
            lane.SourceRoot.x + pointsData[1][1].x, lane.SourceRoot.y + pointsData[1][1].y, lane.SourceRoot.z + pointsData[1][1].z, 
            false, false, true
        )
        SetEntityCollision(lane.ballEnt, false, false)
        FreezeEntityPosition(lane.ballEnt, true)
        table.insert(deleteOnEnd, lane.ballEnt)
        bowlBall = lane.ballEnt
    else
        SetEntityCoords(
            lane.ballEnt, 
            lane.SourceRoot.x + pointsData[1][1].x, lane.SourceRoot.y + pointsData[1][1].y, lane.SourceRoot.z + pointsData[1][1].z, 
            false, false, false, false
        )
    end

    local totalDist = 0.0

    for i = 2, #pointsData do
        repeat
            local targetPoint = pointsData[i][1]

            if i == #pointsData and lane.LastRackBallPos then
                targetPoint = lane.LastRackBallPos
            end

            local xDist = math.abs(pointsData[i-1][1].x - targetPoint.x)
            local yDist = math.abs(pointsData[i-1][1].y - targetPoint.y)
            local zDist = math.abs(pointsData[i-1][1].z - targetPoint.z)

            local speedVec = vector3(xDist, yDist, zDist)
            speedVec = speedVec

            local speedSum = #speedVec
            local lastPos = GetEntityCoords(bowlBall)
            local targetPos = vector3(lane.SourceRoot.x + targetPoint.x, lane.SourceRoot.y + targetPoint.y, lane.SourceRoot.z + targetPoint.z)
            local fin = SlideObject(
                bowlBall, 
                targetPos.x, targetPos.y, targetPos.z,
                speedVec.x / speedSum * 0.02 * pointsData[i-1][2], speedVec.y / speedSum * 0.02 * pointsData[i-1][2], speedVec.z / speedSum * 0.02 * pointsData[i-1][2],
                false
            )

            local distLeft = #(targetPos - lastPos)

            local newPos = GetEntityCoords(bowlBall)
            totalDist = totalDist + #(lastPos - newPos)
            SetEntityRotation(bowlBall, -totalDist * 600, 0.0, pointsData[i][3], 2, false)

            Wait(0)
        until fin or distLeft <= 0.11 or lane.ballState ~= 'racked' 
    end
end