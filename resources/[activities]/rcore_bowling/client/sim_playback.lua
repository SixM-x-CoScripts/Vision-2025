local ClThrowData = {}

local delmetest = false

RegisterNetEvent('rcore_bowling:throwBall', function(laneName, throwId, throwData, throwerServerId)
    Lanes[laneName].ballState = 'thrown'
    Lanes[laneName].ballStateAt = GetNetworkTimeAccurate()
    Lanes[laneName].ballServerId = nil

    ClThrowData[throwId] = throwData
    
    -- 0.215, -0.015, 0.0, 194.0, -3.0, 98.0
    local holdBallDict = 'export@bowlthrow'
    local holdBallAnim = 'head_000_r'


    if throwerServerId == GetPlayerServerId(PlayerId()) then
        ClearPedTasks(PlayerPedId())
        loadAnimDict(holdBallDict)
        TaskPlayAnim(
            PlayerPedId(), 'export@bowlthrow', 'head_000_r',
            4.0, 4.0, 1500, 0, 0.0, false, false
        )
    end

    Wait(Config.ThrowWait)

    PlayBowlSim(Lanes[laneName], ClThrowData[throwId], throwId)
end)

RegisterNetEvent('rcore_bowling:throwBallSim', function(laneName, throwId, throwData)
    -- if throwData.pinStatus then
    --     Lanes[laneName].pinStatus = throwData.pinStatus
    -- end

    for i = 1, #throwData do
        table.insert(ClThrowData[throwId], throwData[i])
    end
end)
    