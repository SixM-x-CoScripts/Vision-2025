RegisterCommand('bowlingleave', function(source)
    RemovePlayerFromAllAlleys(source)
end, false)

RegisterNetEvent('rcore_bowling:leaveLane', function()
    RemovePlayerFromAllAlleys(source)
end)

AddEventHandler('playerDropped', function()
    RemovePlayerFromAllAlleys(source)
end)

function RemovePlayerFromAllAlleys(serverId)
    for laneIdx, laneState in pairs(State) do
        local anythingChanged = false
        local cancelGame = false

        if laneState.Players then
            local _, currentlyPlayingName = GetCurrentTurnPlayerServerId(laneState.Players, laneState.RoundCount)

            for idx, playerInfo in pairs(laneState.Players) do
                if playerInfo.ServerId == serverId then
                    table.remove(laneState.Players, idx)

                    if currentlyPlayingName == playerInfo.Name and (laneState.BallState == 'thrown' or laneState.BallState == 'in-hand') then
                        ResetLaneToRacked(laneState.Lane)
                    end

                    if #laneState.Players == 0 then
                        cancelGame = true
                    end

                    anythingChanged = true
                    break
                end
            end
        else
            local _, currentlyPlayingName = GetCurrentTurnPlayerServerId(laneState.Teams, laneState.RoundCount)

            for teamIdx, teamInfo in pairs(laneState.Teams) do
                local shouldBreak = false
                for tpId, tpSvId in pairs(teamInfo.Players) do
                    if tpSvId == serverId then
                        table.remove(teamInfo.Players, tpId)
                        
                        if currentlyPlayingName == teamInfo.Name and laneState.BallHolder == tpSvId and (laneState.BallState == 'thrown' or laneState.BallState == 'in-hand') then
                            ResetLaneToRacked(laneState.Lane)
                        end

                        anythingChanged = true
                        shouldBreak = true
                        break
                    end

                    if shouldBreak then
                        break
                    end
                end

                if #teamInfo.Players == 0 then
                    table.remove(laneState.Teams, teamIdx)
                    anythingChanged = true
                end
                
                if #laneState.Teams == 0 then
                    cancelGame = true
                end
            end
        end

        if anythingChanged then
            local nearbyPlayers = FindPlayersNearLane(laneState.Lane)

            if cancelGame then
                for _, nearbyServerId in pairs(nearbyPlayers) do
                    TriggerClientEvent('rcore_bowling:unsetState', nearbyServerId, laneState.Lane)
                end
                table.remove(State, laneIdx)
            else
                for _, nearbyServerId in pairs(nearbyPlayers) do
                    local ballHolder = nil 
                    if laneState.BallState == 'in-hand' then
                        ballHolder = laneState.BallHolder
                    end
                    TriggerClientEvent('rcore_bowling:setState', nearbyServerId, laneState.Lane, laneState.OwnerServerId, laneState.Players or laneState.Teams, laneState.State, laneState.pinStatus, laneState.Type, laneState.Wager, laneState.WagerAccumulated, laneState.RoundCount)
                    TriggerClientEvent('rcore_bowling:setBallState', nearbyServerId, laneState.Lane, laneState.BallState, laneState.BallStateAt, ballHolder)
                end
            end
        end
    end
end

function FindPlayersNearLane(laneName)
    local startPos = Lanes[laneName].Start

    local timeout = 20
    local nearPlayers = {}

    for _, serverId in pairs(GetPlayers()) do
        if timeout < 0 then
            Wait(0)
            timeout = 20
        end

        timeout = timeout - 1

        local ped = GetPlayerPed(serverId)

        if ped and ped > 0 then
            local coords = GetEntityCoords(ped)
            if #(coords - startPos) < 200 then
                table.insert(nearPlayers, serverId)
            end
        end
    end

    return nearPlayers
end

function ResetLaneToRacked(laneName)
    local laneState = GetLaneState(laneName)
    local nearbyPlayers = FindPlayersNearLane(laneName)

    laneState.BallState = 'racked'
    laneState.BallStateAt = GetGameTimer()
    laneState.BallHolder = nil
    laneState.pinStatus = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1}

    for _, nearbyServerId in pairs(nearbyPlayers) do
        TriggerClientEvent('rcore_bowling:setState', nearbyServerId, laneState.Lane, laneState.OwnerServerId, laneState.Players or laneState.Teams, laneState.State, laneState.pinStatus, laneState.Type, laneState.Wager, laneState.WagerAccumulated, laneState.RoundCount)
        TriggerClientEvent('rcore_bowling:setBallState', nearbyServerId, laneState.Lane, laneState.BallState, laneState.BallStateAt, nil)
    end

end