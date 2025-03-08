function ComputeBowlingScore(totalRoundCount, bowlingThrows)
    local finalScore = {}

    for i = 1, math.min(#bowlingThrows, totalRoundCount) do
        if bowlingThrows[i] then
            local firstThrow = bowlingThrows[i][1]
            local secondThrow = bowlingThrows[i][2]
            local thirdThrow = bowlingThrows[i][3]

            local thisRoundSum = nil

            if firstThrow ~= nil and (secondThrow ~= nil or firstThrow == 10) and (i < totalRoundCount or thirdThrow ~= nil) then
                thisRoundSum = (firstThrow and firstThrow or 0) + (secondThrow and secondThrow or 0) + (thirdThrow and thirdThrow or 0)

                if i < totalRoundCount then
                    -- strike calculation
                    if firstThrow == 10 then
                        if bowlingThrows[i+1] ~= nil then
                            if bowlingThrows[i+1][1] ~= nil then
                                thisRoundSum = thisRoundSum + bowlingThrows[i+1][1]
                                -- if second throw is also strike, get 2nd points from next throw
                                if bowlingThrows[i+1][1] == 10 then
                                    if i == (totalRoundCount-1) and bowlingThrows[i+1][2] ~= nil and bowlingThrows[i+1][3] ~= nil then
                                        thisRoundSum = thisRoundSum + bowlingThrows[i+1][2]
                                    elseif bowlingThrows[i+2] ~= nil and bowlingThrows[i+2][1] ~= nil then
                                        thisRoundSum = thisRoundSum + bowlingThrows[i+2][1]
                                    else
                                        thisRoundSum = nil -- not enough next throws to compute
                                    end
                                elseif bowlingThrows[i+1][2] ~= nil then
                                    thisRoundSum = thisRoundSum + bowlingThrows[i+1][2]
                                else
                                    thisRoundSum = nil -- not enough throws completed to compute this
                                end
                            else
                                thisRoundSum = nil -- not enough throws completed to compute this
                            end
                        else
                            thisRoundSum = nil -- not enough throws completed to compute this
                        end
                    elseif (firstThrow + secondThrow) == 10 then
                        if bowlingThrows[i+1] ~= nil and bowlingThrows[i+1][1] ~= nil then
                            thisRoundSum = thisRoundSum + bowlingThrows[i+1][1]
                        else
                            thisRoundSum = nil -- not enough throws completed to compute this
                        end
                    end
                end

                if i > 1 and thisRoundSum then
                    if finalScore[i-1] and finalScore[i-1][4] then
                        thisRoundSum = thisRoundSum + finalScore[i-1][4]
                    else
                        thisRoundSum = nil
                    end
                end
            end

            finalScore[i] = {
                bowlingThrows[i][1], 
                bowlingThrows[i][2], 
                bowlingThrows[i][3],
                thisRoundSum
            }
        else
            finalScore[i] = {}
        end
    end

    return finalScore
end

function GetCurrentTurnPlayerServerId(laneState, totalRounds)
    local maxThrows = #laneState[1].Throws

    for _, playerData in pairs(laneState) do
        local throwData = playerData.Throws[maxThrows]

        if not throwData then
            return playerData.ServerId or playerData.Players, playerData.Name
        end

        if totalRounds == maxThrows then
            if not throwData[3] then
                return playerData.ServerId or playerData.Players, playerData.Name
            end
        else
            if throwData[1] == 10 or throwData[2] then
            else
                return playerData.ServerId or playerData.Players, playerData.Name
            end
        end
    end

    if maxThrows == totalRounds then
        return nil, nil
    end

    return laneState[1].ServerId or laneState[1].Players, laneState[1].Name
end