function GetEsxObject()
    local promise_ = promise:new()
    local obj
    xpcall(function()
        obj = exports['es_extended']['getSharedObject']()
        promise_:resolve(obj)
    end, function(error)
        TriggerEvent(Config.ESX or "esx:getSharedObject", function(module)
            obj = module
            promise_:resolve(obj)
        end)
    end)

    Citizen.Await(obj)
    return obj
end

if Config.Framework == "1" then
    ESX = GetEsxObject()
end

local playersOnline = {}
local gameAdmissionTotal = {}

local beerpongGames = {}

registerCallback(TriggerName("PayForBeerGame"), function(source, cb, money, identifier)
    if PayWithMoney(source, "money", money) then
        local gameData = GetGameDataByIdentifier(identifier)

        if not gameData.paidSources then
            gameData.paidSources = {}
        end

        gameData.paidSources[source] = true

        if not gameAdmissionTotal[identifier] then
            gameAdmissionTotal[identifier] = 0
        end
        gameAdmissionTotal[identifier] = gameAdmissionTotal[identifier] + money
        cb(true)
    else
        cb(false)
    end
end)

function ReturnWinnerFromTable(table, pos)
    local minNumber
    local winnerTable
    local canQuit = true
    local copyTable = DeepCopy(table)
    while canQuit do
        Wait(1)
        minNumber = -2147483648
        for k, v in pairs(copyTable) do
            if minNumber < v.score and #(GetEntityCoords(GetPlayerPed(v.source)) - pos) < 25 then
                minNumber = v.score
                winnerTable = v
                canQuit = false
            end
        end

        if not playersOnline[winnerTable.source] then
            copyTable[winnerTable.source] = nil
            canQuit = true
        end
    end
    return winnerTable
end

function GetGameDataByIdentifier(identifier)
    for k, v in pairs(beerpongGames) do
        if v.IdentifierGame == identifier then
            return v
        end
    end
    return nil
end

function RemoveGameDataByIdentifier(identifier, payMoneyBack, giveItemBack)
    for k, v in pairs(beerpongGames) do
        if v.IdentifierGame == identifier then
            if payMoneyBack and v.AdmissionMoney and v.paidSources then
                for source, _ in pairs(v.paidSources) do
                    local xPlayer = ESX.GetPlayerFromId(source)
                    xPlayer.addMoney(v.AdmissionMoney)
                    xPlayer.addInventoryItem(Config.ItemName, 1)
                    TriggerClientEvent('chat:addMessage', source, { args = { _U("return_admission", v.AdmissionMoney) } })
                end
            end

            if giveItemBack and Config.Framework ~= "0" and #(GetEntityCoords(GetPlayerPed(v.AuthorID)) - v.StartPosition) < 25 then
                local xPlayer = ESX.GetPlayerFromId(v.AuthorID)
                xPlayer.addInventoryItem(Config.ItemName, 1)
            end
            table.remove(beerpongGames, k)
            gameAdmissionTotal[identifier] = nil
            break
        end
    end
end

function CanWeQuitThisGame(identifier)
    local canWeQuit = true
    local data = GetGameDataByIdentifier(identifier)
    if data then
        for key, value in pairs(data.CupEntityPositions) do
            if not value.scored and IsModelACup(value.model) then
                canWeQuit = false
            end
        end
    end
    return canWeQuit
end

RegisterNetEvent(TriggerName("FetchPlayerGroup"), function()
    local source = source
    local isPermitted = false
    if Config.Framework == "0" then
        isPermitted = IsPlayerAceAllowed(source, "beerpong.remove")
    end

    if Config.Framework == "1" or Config.Framework == "2" then
        local xPlayer = ESX.GetPlayerFromId(source)
        isPermitted = Config.AllowedGroups[xPlayer.getGroup()] ~= nil
    end
    TriggerClientEvent(TriggerName("FetchPlayerGroup"), source, isPermitted)
end)

RegisterNetEvent(TriggerName("FetchCache"), function()
    TriggerClientEvent(TriggerName("FetchCache"), source, beerpongGames)
end)

RegisterNetEvent(TriggerName("ThrowBall"), function(pos, force)
    TriggerClientEvent(TriggerName("ThrowBall"), -1, pos, force, source)
end)

RegisterNetEvent(TriggerName("PlayNewMethod"), function(path, hitEntity, initialPos)
    local throwPosition = GetEntityCoords(GetPlayerPed(source))

    for k, v in pairs(GetPlayers()) do
        k = type(v) == "string" and tonumber(v) or v
        if #(throwPosition - GetEntityCoords(GetPlayerPed(k))) < 40 then
            TriggerClientEvent(TriggerName("PlayNewMethod"), k, source, path, hitEntity, initialPos)
        end
    end
end)

RegisterNetEvent(TriggerName("CreateBeerGame"), function(data)
    table.insert(beerpongGames, data)
    TriggerClientEvent(TriggerName("CreateBeerGame"), -1, data, source)
end)

RegisterNetEvent(TriggerName("init"), function(data)
    playersOnline[source] = true
end)

AddEventHandler('playerDropped', function(reason)
    for k, v in pairs(beerpongGames) do
        if v.Score[source] then
            v.Score[source] = nil
        end
    end
    playersOnline[source] = nil
end)

RegisterNetEvent(TriggerName("VisibleScoreStatusForPlayer"), function(identifier, status)
    TriggerClientEvent(TriggerName("VisibleScoreStatusForPlayer"), -1, identifier, status, source)
end)

RegisterNetEvent(TriggerName("SetGameBusy"), function(identifier, status)
    local data = GetGameDataByIdentifier(identifier)
    if data == nil or data.IsBusy == status then
        return
    end
    if status then
        TriggerClientEvent(TriggerName("PutPlayerToThrow"), source)
    end

    data.IsBusy = status

    TriggerClientEvent(TriggerName("SetGameBusy"), -1, identifier, status)
end)

RegisterNetEvent(TriggerName("EndGame"), function(identifier)
    TriggerClientEvent(TriggerName("EndGame"), -1, identifier)

    RemoveGameDataByIdentifier(identifier, true, true)
end)

RegisterNetEvent(TriggerName("CheckIfPlayerIsNoOneNearToRemoveGame"), function(identifier)
    throwPosition = GetGameDataByIdentifier(identifier).CupsPosition

    local canRemove = true
    for k, v in pairs(GetPlayers()) do
        k = type(v) == "string" and tonumber(v) or v
        if #(throwPosition - GetEntityCoords(GetPlayerPed(k))) < 20 then
            canRemove = false
            break
        end
    end

    if canRemove then
        TriggerEvent(TriggerName("EndGame"), identifier)
    end
end)

RegisterNetEvent(TriggerName("OnPongHit"), function(GameData, id)
    local newData = {}
    --TriggerClientEvent(TriggerName("SetGameBusy"), -1, GameData.IdentifierGame, false)

    local data = GetGameDataByIdentifier(GameData.IdentifierGame)

    if data then
        local cupPoint = data.CupEntityPositions[id]
        if cupPoint then
            local pName = GetPlayerName(source)
            if not data.Score[source] then
                data.Score[source] = {
                    name = pName,
                    score = 0,
                    source = source,
                }
            end
            cupPoint.scored = true
            data.Score[source].score = data.Score[source].score + 1
            TriggerClientEvent(TriggerName("InteractWithObject"), -1, id, GameData.IdentifierGame, source)
        end

        if CanWeQuitThisGame(data.IdentifierGame) then
            local winnerTable = ReturnWinnerFromTable(data.Score, data.StartPosition)

            if gameAdmissionTotal[data.IdentifierGame] then
                local xPlayer = ESX.GetPlayerFromId(winnerTable.source)
                xPlayer.addMoney(gameAdmissionTotal[data.IdentifierGame])
                TriggerClientEvent('chat:addMessage', winnerTable.source, { args = { _U("you_won_admission", gameAdmissionTotal[data.IdentifierGame]) } })
            else
                TriggerClientEvent('chat:addMessage', winnerTable.source, { args = { _U("you_won") } })
            end
            TriggerClientEvent(TriggerName("WonGameAnimation"), winnerTable.source)

            RemoveGameDataByIdentifier(data.IdentifierGame, false, true)
            TriggerClientEvent(TriggerName("EndGame"), -1, data.IdentifierGame)
            return
        end

        newData = data
        TriggerClientEvent(TriggerName("UpdateGame"), -1, newData)
    end
end)