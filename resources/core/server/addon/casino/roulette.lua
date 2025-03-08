local activeRoulette = {}
local roulettePlayers = {}

--//////////////////////////--//////////////////////////--//////////////////////////
-- EDIT THESE FOR YOUR SERVER
-- EDIT THESE FOR YOUR SERVER
local function getPlayerChips(source)
    local count = CasinoConfig.GetChipsCount(source)
    return count
end

local function giveChipsRoulette(source, amount)
    CasinoConfig.GiveChips(source, amount)
end

local function removeChips(source, amount)
    CasinoConfig.RemoveChips(source, amount)
end

function r_showNotification(source, msg)
    TriggerClientEvent("blackjack:notify",source,msg)
end
--//////////////////////////--//////////////////////////--//////////////////////////

function isPlayerExist(source)
    if GetPlayerName(source) ~= nil then
        return true
    else
        return false
    end
end

RegisterNetEvent('casino:roulette:taskSitDown')
AddEventHandler(
    'casino:roulette:taskSitDown',
    function(rouletteIndex, chairData)
        local source = source
        local chairId = chairData.chairId

        if activeRoulette[rouletteIndex] ~= nil then
            if activeRoulette[rouletteIndex].chairsUsed[chairId] ~= nil then
                return r_showNotification(source, CasinoConfigSH.Lang.SeatOccuped)
            else
                TriggerClientEvent('sunwiseRoulette:callback::taskSitDown', source, rouletteIndex, chairData)
            end
        else
            TriggerClientEvent('sunwiseRoulette:callback::taskSitDown', source, rouletteIndex, chairData)
        end
        if not roulettePlayers[rouletteIndex] then 
            roulettePlayers[rouletteIndex] = {}
        end
        roulettePlayers[rouletteIndex][source] = true
    end
)

RegisterNetEvent('casino:taskStartRoulette')
AddEventHandler(
    'casino:taskStartRoulette',
    function(rouletteIndex, chairId)
        local source = source
        if activeRoulette[rouletteIndex] == nil then
            activeRoulette[rouletteIndex] = {
                Status = false,
                ido = 30,
                bets = {},
                chairsUsed = {}
            }
        end

        if activeRoulette[rouletteIndex].chairsUsed[chairId] == nil then
            activeRoulette[rouletteIndex].chairsUsed[chairId] = source
            TriggerClientEvent('sunwiseRoulette:open', source, rouletteIndex)
        else
            r_showNotification(source, CasinoConfigSH.Lang.SeatOccuped)
        end
    end
)

function countTablePlayers(rouletteIndex)
    local count = 0

    if activeRoulette[rouletteIndex] ~= nil then
        for chairId, _ in pairs(activeRoulette[rouletteIndex].chairsUsed) do
            count = count + 1
        end

        return count
    else
        return count
    end
end

RegisterNetEvent('sunwiseRoulette:notUsing')
AddEventHandler(
    'sunwiseRoulette:notUsing',
    function(rouletteIndex)
        local source = source
        if activeRoulette[rouletteIndex] ~= nil then
            for chairId, src in pairs(activeRoulette[rouletteIndex].chairsUsed) do
                if src == source then
                    activeRoulette[rouletteIndex].chairsUsed[chairId] = nil
                end
            end
        end
        if roulettePlayers[rouletteIndex] then 
            roulettePlayers[rouletteIndex][source] = nil
        end
    end
)

AddEventHandler(
    'playerDropped',
    function(reason)
        local source = source
        for rouletteIndex, v in pairs(activeRoulette) do
            for chairId, src in pairs(v.chairsUsed) do
                if src == source then
                    activeRoulette[rouletteIndex].chairsUsed[chairId] = nil
                end
            end
        end
    end
)

local RouletteData = {
    [1] = '00',
    [2] = '27',
    [3] = '10',
    [4] = '25',
    [5] = '29',
    [6] = '12',
    [7] = '8',
    [8] = '19',
    [9] = '31',
    [10] = '18',
    [11] = '6',
    [12] = '21',
    [13] = '33',
    [14] = '16',
    [15] = '4',
    [16] = '23',
    [17] = '35',
    [18] = '14',
    [19] = '2',
    [20] = '0',
    [21] = '28',
    [22] = '9',
    [23] = '26',
    [24] = '30',
    [25] = '11',
    [26] = '7',
    [27] = '20',
    [28] = '32',
    [29] = '17',
    [30] = '5',
    [31] = '22',
    [32] = '34',
    [33] = '15',
    [34] = '3',
    [35] = '24',
    [36] = '36',
    [37] = '13',
    [38] = '1'
}

CreateThread(
    function()
        while true do
            Wait(1000)

            for rouletteIndex, v in pairs(activeRoulette) do
                if v.Status == false then
                    if v.ido > 0 then
                        activeRoulette[rouletteIndex].ido = v.ido - 1
                        TriggerClientEvents('sunwiseRoulette:updateStatus', GetRoulettePlayers(rouletteIndex), rouletteIndex, v.ido, v.Status)
                    end

                    if v.ido < 1 then
                        local randomSpinNumber = math.random(1, 38)
                        local WinningBetIndex = RouletteData[randomSpinNumber]

                        activeRoulette[rouletteIndex].Status = true
                        activeRoulette[rouletteIndex].WinningBetIndex = WinningBetIndex
                        TriggerClientEvents('sunwiseRoulette:updateStatus', GetRoulettePlayers(rouletteIndex), rouletteIndex, v.ido, v.Status)

                        CreateThread(function()
                            TriggerClientEvent('sunwiseRoulette:startSpin', -1, rouletteIndex, randomSpinNumber)
                            Wait(15500)
                                if #v.bets > 0 then
                                    CheckWinnersRoulette(v.bets, activeRoulette[rouletteIndex].WinningBetIndex)
                                    activeRoulette[rouletteIndex].Status = false
                                    activeRoulette[rouletteIndex].ido = 30
                                    activeRoulette[rouletteIndex].WinningBetIndex = nil
                                    activeRoulette[rouletteIndex].bets = {} -- reset the bets on the table, very importante
                                    TriggerClientEvents('sunwiseRoulette:updateTableBets', GetRoulettePlayers(rouletteIndex), rouletteIndex, activeRoulette[rouletteIndex].bets)
                                else
                                    if countTablePlayers(rouletteIndex) < 1 then
                                        activeRoulette[rouletteIndex] = nil -- deleting the table from srv
                                        TriggerClientEvents('sunwiseRoulette:updateStatus', GetRoulettePlayers(rouletteIndex), rouletteIndex, nil, nil)
                                    else
                                        activeRoulette[rouletteIndex].Status = false
                                        activeRoulette[rouletteIndex].ido = 30
                                        activeRoulette[rouletteIndex].WinningBetIndex = nil
                                        activeRoulette[rouletteIndex].bets = {} -- reset the bets on the table, very importante
                                        TriggerClientEvents('sunwiseRoulette:updateTableBets', GetRoulettePlayers(rouletteIndex), rouletteIndex, activeRoulette[rouletteIndex].bets)
                                    end
                                end
                            end
                        )
                    end
                end
            end
        end
    end
)

RouletteNumbers = {}
RouletteNumbers.Red = {
    ['1'] = true,
    ['3'] = true,
    ['5'] = true,
    ['7'] = true,
    ['9'] = true,
    ['12'] = true,
    ['14'] = true,
    ['16'] = true,
    ['18'] = true,
    ['19'] = true,
    ['21'] = true,
    ['23'] = true,
    ['25'] = true,
    ['27'] = true,
    ['30'] = true,
    ['32'] = true,
    ['34'] = true,
    ['36'] = true
}
RouletteNumbers.Black = {
    ['2'] = true,
    ['4'] = true,
    ['6'] = true,
    ['8'] = true,
    ['10'] = true,
    ['11'] = true,
    ['13'] = true,
    ['15'] = true,
    ['17'] = true,
    ['20'] = true,
    ['22'] = true,
    ['24'] = true,
    ['26'] = true,
    ['28'] = true,
    ['29'] = true,
    ['31'] = true,
    ['33'] = true,
    ['35'] = true
}
RouletteNumbers.Dealer = {
    ['2'] = true,
    ['4'] = true,
    ['6'] = true,
    ['8'] = true,
    ['10'] = true,
    ['12'] = true,
    ['14'] = true,
    ['16'] = true,
    ['18'] = true,
    ['20'] = true,
    ['22'] = true,
    ['24'] = true,
    ['26'] = true,
    ['28'] = true,
    ['30'] = true,
    ['32'] = true,
    ['34'] = true,
    ['36'] = true
}
RouletteNumbers.Paratlanok = {
    ['1'] = true,
    ['3'] = true,
    ['5'] = true,
    ['7'] = true,
    ['9'] = true,
    ['11'] = true,
    ['13'] = true,
    ['15'] = true,
    ['17'] = true,
    ['19'] = true,
    ['21'] = true,
    ['23'] = true,
    ['25'] = true,
    ['27'] = true,
    ['29'] = true,
    ['31'] = true,
    ['33'] = true,
    ['35'] = true
}
RouletteNumbers.to18 = {
    ['1'] = true,
    ['2'] = true,
    ['3'] = true,
    ['4'] = true,
    ['5'] = true,
    ['6'] = true,
    ['7'] = true,
    ['8'] = true,
    ['9'] = true,
    ['10'] = true,
    ['11'] = true,
    ['12'] = true,
    ['13'] = true,
    ['14'] = true,
    ['15'] = true,
    ['16'] = true,
    ['17'] = true,
    ['18'] = true
}
RouletteNumbers.to36 = {
    ['19'] = true,
    ['20'] = true,
    ['21'] = true,
    ['22'] = true,
    ['23'] = true,
    ['24'] = true,
    ['25'] = true,
    ['26'] = true,
    ['27'] = true,
    ['28'] = true,
    ['29'] = true,
    ['30'] = true,
    ['31'] = true,
    ['32'] = true,
    ['33'] = true,
    ['34'] = true,
    ['35'] = true,
    ['36'] = true
}
RouletteNumbers.st12 = {
    ['1'] = true,
    ['2'] = true,
    ['3'] = true,
    ['4'] = true,
    ['5'] = true,
    ['6'] = true,
    ['7'] = true,
    ['8'] = true,
    ['9'] = true,
    ['10'] = true,
    ['11'] = true,
    ['12'] = true
}
RouletteNumbers.sn12 = {
    ['13'] = true,
    ['14'] = true,
    ['15'] = true,
    ['16'] = true,
    ['17'] = true,
    ['18'] = true,
    ['19'] = true,
    ['20'] = true,
    ['21'] = true,
    ['22'] = true,
    ['23'] = true,
    ['24'] = true
}
RouletteNumbers.rd12 = {
    ['25'] = true,
    ['26'] = true,
    ['27'] = true,
    ['28'] = true,
    ['29'] = true,
    ['30'] = true,
    ['31'] = true,
    ['32'] = true,
    ['33'] = true,
    ['34'] = true,
    ['35'] = true,
    ['36'] = true
}
RouletteNumbers.ket_to_1 = {
    ['1'] = true,
    ['4'] = true,
    ['7'] = true,
    ['10'] = true,
    ['13'] = true,
    ['16'] = true,
    ['19'] = true,
    ['22'] = true,
    ['25'] = true,
    ['28'] = true,
    ['31'] = true,
    ['34'] = true
}
RouletteNumbers.ket_to_2 = {
    ['2'] = true,
    ['5'] = true,
    ['8'] = true,
    ['11'] = true,
    ['14'] = true,
    ['17'] = true,
    ['20'] = true,
    ['23'] = true,
    ['26'] = true,
    ['29'] = true,
    ['32'] = true,
    ['35'] = true
}
RouletteNumbers.ket_to_3 = {
    ['3'] = true,
    ['6'] = true,
    ['9'] = true,
    ['12'] = true,
    ['15'] = true,
    ['18'] = true,
    ['21'] = true,
    ['24'] = true,
    ['27'] = true,
    ['30'] = true,
    ['33'] = true,
    ['36'] = true
}

function CheckWinnersRoulette(bets, WinningBetIndex)
    local playersWon = {}
    local playersLoss = {}

    for i = 1, #bets, 1 do
        local betData = bets[i]

        local targetSrc = betData.playerSrc
        local PLAYER_HANDLE = isPlayerExist(targetSrc)
        if PLAYER_HANDLE then
            betData.betId = tostring(betData.betId)
            if (WinningBetIndex == '0' and betData.betId == '37') or (WinningBetIndex == '00' and betData.betId == '38') then -- dbl zero, and zero
          --      print("okGoGive")
                giveWinningChips(targetSrc, betData.betAmount, 35)
                playersWon[targetSrc] = true
                if playersLoss[targetSrc] then
                    playersWon[targetSrc] = nil
                end
            elseif
                (betData.betId == '39' and RouletteNumbers.Red[WinningBetIndex]) or (betData.betId == '40' and RouletteNumbers.Black[WinningBetIndex]) or
                    (betData.betId == '41' and RouletteNumbers.Dealer[WinningBetIndex]) or
                    (betData.betId == '42' and RouletteNumbers.Paratlanok[WinningBetIndex]) or
                    (betData.betId == '43' and RouletteNumbers.to18[WinningBetIndex]) or
                    (betData.betId == '44' and RouletteNumbers.to36[WinningBetIndex])
             then
         --       print("okGoGive2")
                giveWinningChips(targetSrc, betData.betAmount, 2)
                playersWon[targetSrc] = true
                if playersLoss[targetSrc] then
                    playersWon[targetSrc] = nil
                end
            elseif betData.betId <= '36' and WinningBetIndex == betData.betId then -- the numbers
           --     print("okGoGive3")
                giveWinningChips(targetSrc, betData.betAmount, 35)
                playersWon[targetSrc] = true
                if playersLoss[targetSrc] then
                    playersWon[targetSrc] = nil
                end
            elseif
                (betData.betId == '45' and RouletteNumbers.st12[WinningBetIndex]) or (betData.betId == '46' and RouletteNumbers.sn12[WinningBetIndex]) or
                    (betData.betId == '47' and RouletteNumbers.rd12[WinningBetIndex]) or
                    (betData.betId == '48' and RouletteNumbers.ket_to_1[WinningBetIndex]) or
                    (betData.betId == '49' and RouletteNumbers.ket_to_2[WinningBetIndex]) or
                    (betData.betId == '50' and RouletteNumbers.ket_to_3[WinningBetIndex])
             then
           --     print("okGoGive4")
                giveWinningChips(targetSrc, betData.betAmount, 3)
                playersWon[targetSrc] = true

                if playersLoss[targetSrc] then
                    playersWon[targetSrc] = nil
                end
            else -- LOSS
            --    print("okGoLoooosee")
                if playersWon[targetSrc] == nil then
                    playersLoss[targetSrc] = true
                else
                    playersLoss[targetSrc] = nil
                end
            end
        end
    end

    for targetSrc, _ in pairs(playersLoss) do
        local chairId = getPlayerTableSeat(targetSrc)
        if chairId ~= nil then
            TriggerClientEvent('sunwiseRoulette:playWinAnim', targetSrc, chairId)
        end
    end

    for targetSrc, _ in pairs(playersWon) do
        local chairId = getPlayerTableSeat(targetSrc)
        if chairId ~= nil then
            TriggerClientEvent('sunwiseRoulette:playLossAnim', targetSrc, chairId)
        end
    end
end

function giveWinningChips(source, amount, szorzo)
    amount = math.floor(amount * szorzo)
    if amount > 0 then
        r_showNotification(source, string.format(CasinoConfigSH.Lang.WonAmount, amount))
        giveChipsRoulette(source, amount)
    end
end

RegisterNetEvent('sunwiseRoulette:goRoulette')
AddEventHandler(
    'sunwiseRoulette:goRoulette',
    function(rouletteIndex, betId, betAmount)
        local source = source

        if activeRoulette[rouletteIndex] ~= nil then
            if activeRoulette[rouletteIndex].Status then
                return r_showNotification(source, CasinoConfigSH.Lang.AlreadyStarted)
            end

            local chipsAmount = getPlayerChips(source)
            if chipsAmount >= betAmount then
                removeChips(source, betAmount)
                r_showNotification(source, string.format(CasinoConfigSH.Lang.BetPlaced, betAmount))

                local exist = false
                for i = 1, #activeRoulette[rouletteIndex].bets, 1 do
                    local d = activeRoulette[rouletteIndex].bets[i]
                    if d.betId == betId and d.playerSrc == source then
                        exist = true
                        activeRoulette[rouletteIndex].bets[i].betAmount = activeRoulette[rouletteIndex].bets[i].betAmount + betAmount
                    end
                end

                if not exist then
                    table.insert(
                        activeRoulette[rouletteIndex].bets,
                        {
                            betId = betId,
                            playerSrc = source,
                            betAmount = betAmount
                        }
                    )
                end
                TriggerClientEvents('sunwiseRoulette:updateTableBets', GetRoulettePlayers(rouletteIndex), rouletteIndex, activeRoulette[rouletteIndex].bets)
                local chairId = getPlayerTableSeat(source)
                if chairId ~= nil then
                    TriggerClientEvent('sunwiseRoulette:playBetAnim', source, chairId)
                end
            else
                r_showNotification(source, CasinoConfigSH.Lang.BadAmount)
            end
        end
    end
)

function getPlayerTableSeat(source)
    for rouletteIndex, v in pairs(activeRoulette) do
        for chairId, src in pairs(v.chairsUsed) do
            if src == source then
                return chairId
            end
        end
    end
end

function GetRoulettePlayers(rouletteIndex)
    local tosend = {}
    if roulettePlayers[rouletteIndex] then 
        for k, v in pairs(roulettePlayers[rouletteIndex]) do 
            table.insert(tosend, k)
        end
    end
    return tosend
end