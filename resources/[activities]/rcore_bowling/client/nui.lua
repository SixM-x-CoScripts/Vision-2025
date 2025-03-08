NuiCurrentlyOpenLane = nil

function NuiOpenSetupPlayers(laneName, isTeamGame)
    NuiCurrentlyOpenLane = laneName
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "setupPlayers",
        serverId = GetPlayerServerId(PlayerId()),
        isTeamGame = isTeamGame,
        data = FormatNuiLaneState(laneName),
        gameState = Lanes[laneName].gameState,
        wager = Lanes[laneName].wager,
        translations = Config.Text,
        roundCount = Lanes[laneName].roundCount or 10,
        allowBets = Config.AllowWager,
    })
end

function NuiOpenJoin(laneName, isTeamGame)
    NuiCurrentlyOpenLane = laneName
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "openJoin",
        data = FormatNuiLaneState(laneName),
        gameState = Lanes[laneName].gameState,
        wager = Lanes[laneName].wager,
        serverId = GetPlayerServerId(PlayerId()),
        isTeamGame = isTeamGame,
        translations = Config.Text,
        roundCount = Lanes[laneName].roundCount or 10,
        allowBets = Config.AllowWager,
    })
end

function UpdateNui(laneName)
    if NuiCurrentlyOpenLane == laneName then
        SendNUIMessage({
            type = "update",
            currentTurnName = NuiGetCurrentTurnName(laneName),
            data = FormatNuiLaneState(laneName),
            gameState = Lanes[laneName].gameState,
            wager = Lanes[laneName].wager,
            roundCount = Lanes[laneName].roundCount or 10,
            hideStart = false,
        })
    else
        local playerLane = GetLanePlayerIsIn()

        if playerLane == laneName then
            SendNUIMessage({
                type = "update",
                currentTurnName = NuiGetCurrentTurnName(laneName),
                data = FormatNuiLaneState(laneName),
                gameState = Lanes[laneName].gameState,
                wager = Lanes[laneName].wager,
                wagerAccumulated = Lanes[laneName].wagerAccumulated,
                roundCount = Lanes[laneName].roundCount or 10,
                hideStart = true,
            })
            SendNUIMessage({
                type = "showui"
            })

            Wait(5000)

            if not NuiCurrentlyOpenLane then
                SendNUIMessage({
                    type = "hideui"
                })
            end
        end
    end
end

function NuiResetPlayersIfCurrentLane(laneName)
    if NuiCurrentlyOpenLane == laneName then
        SendNUIMessage({
            type = "unsetplayers"
        })
    end
end

function FormatNuiLaneState(laneName)
    local state = Lanes[laneName].state
    local newState = {}

    if not state then
        return {}
    end

    for k, v in pairs(state) do
        newState[k] = v
        newState[k].Throws = ComputeBowlingScore(Lanes[laneName].roundCount, newState[k].Throws)
    end

    return newState
end

RegisterNUICallback('register', function(data, cb)
	local playerName = data.name
    local isTeamGame = data.isTeamGame
    local roundCount = data.roundCount
    
    if not data.wager then
        data.wager = -1
    else
        data.wager = tonumber(data.wager)

        if data.wager <= 0 then
            data.wager = -1
        end
    end

    local lane = Lanes[NuiCurrentlyOpenLane]
    
    if lane.state then
        TriggerServerEvent('rcore_bowling:joinGame', NuiCurrentlyOpenLane, GetTargetPlayers(), playerName, isTeamGame)
    else
        TriggerServerEvent('rcore_bowling:registerGame', NuiCurrentlyOpenLane, GetTargetPlayers(), playerName, isTeamGame, data.wager, roundCount)
    end
    
    if cb then cb() end
end)

RegisterNUICallback('removePlayer', function(data, cb)
    local serverId = GetPlayerServerId(PlayerId())
    local lane = Lanes[NuiCurrentlyOpenLane]

    if lane.ownerServerId == serverId then
        TriggerServerEvent('rcore_bowling:removePlayer', NuiCurrentlyOpenLane, GetTargetPlayers(), data.serverId)
    end
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)

    NuiCurrentlyOpenLane = nil

    if cb then cb() end
end)

RegisterNUICallback('start', function(data, cb)
    SetNuiFocus(false, false)

    local serverId = GetPlayerServerId(PlayerId())
    local lane = Lanes[NuiCurrentlyOpenLane]

    if lane.ownerServerId == serverId then
        TriggerServerEvent('rcore_bowling:start', NuiCurrentlyOpenLane, GetTargetPlayers())
    end

    NuiCurrentlyOpenLane = nil

    if cb then cb() end
end)

RegisterNetEvent('rcore_bowling:startCreateGame', function(laneName, isTeamGame)
    NuiOpenSetupPlayers(laneName, isTeamGame)
end)

local isCommandToggledOn = false
RegisterCommand(Config.ScoreboardCommand, function()
    local laneName = GetLanePlayerIsIn()

    if laneName then
        if isCommandToggledOn then
            isCommandToggledOn = false
            NuiCurrentlyOpenLane = nil
            SendNUIMessage({
                type = "hideui"
            })
        else
            isCommandToggledOn = true
            NuiCurrentlyOpenLane = laneName
            SendNUIMessage({
                type = "update",
                currentTurnName = NuiGetCurrentTurnName(laneName),
                data = FormatNuiLaneState(laneName),
                gameState = Lanes[laneName].gameState,
                wager = Lanes[laneName].wager,
                roundCount = Lanes[laneName].roundCount or 10,
            })
            SendNUIMessage({
                type = "showui"
            })
        end
    else
		SetNotificationTextEntry('STRING')
		AddTextComponentSubstringPlayerName(Config.Text.NOT_IN_GAME)
	    DrawNotification(true, true)
    end
end, false)

function NuiGetCurrentTurnName(laneName)
    local _, name = GetCurrentTurnPlayerServerId(Lanes[laneName].state, Lanes[laneName].roundCount)

    return name
end