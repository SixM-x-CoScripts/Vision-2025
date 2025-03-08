local function getPlayerChips(source)
    return CasinoConfig.GetChipsCount(source)
end

local function GetAnteMultiplier(handValue)
    if handValue > 500 then
        return 5
    elseif handValue > 400 then
        return 4
    elseif handValue > 300 then
        return 1
    end

    return 0
end

local function GetPairMultiplier(handValue)
    if handValue > 500 then
        return 40
    elseif handValue > 400 then
        return 30
    elseif handValue > 300 then
        return 6
    elseif handValue > 200 then
        return 4
    elseif handValue > 100 then
        return 1
    end

    return 0
end

function giveChips(source, amount)
    CasinoConfig.GiveChips(source, amount)
end

function removeChips(source, amount)
    CasinoConfig.RemoveChips(source, amount)
end

local ServerPokers = {}

RegisterNetEvent('sunwisecasinostandUp')
RegisterNetEvent('sunwisecasinobetPlayer')
RegisterNetEvent('sunwisecasinoplayCards')
RegisterNetEvent('sunwisecasinofoldCards')
RegisterNetEvent('sunwisecasinobetPairPlusPlayer')

AddEventHandler('sunwisecasinofoldCards', function(tableId)
    local source = source
    if ServerPokers[tableId] ~= nil then
        ServerPokers[tableId].PlayersFolded[source] = true
        TriggerClientEvent('sunwisecasinoplayerFoldCards', -1, source, tableId)
    end
end)

AddEventHandler(
    'sunwisecasinoplayCards',
    function(tableId, bettedAmount)
        local source = source
        if ServerPokers[tableId] ~= nil then
            if getPlayerChips(source) >= bettedAmount then
                TriggerClientEvent('sunwisecasinoplayerPlayCards', -1, source, tableId)
                removeChips(source, bettedAmount)
            else
                TriggerClientEvent("blackjack:notify",source,CasinoConfigSH.Lang.BadAmount)
            end
        end
    end
)

AddEventHandler(
    'sunwisecasinostandUp',
    function(tableId, chairId)
        local source = source
        if ServerPokers[tableId] ~= nil and ServerPokers[tableId].ChairsUsed[chairId] ~= nil then
            ServerPokers[tableId].ChairsUsed[chairId] = nil
        end
    end
)

AddEventHandler(
    'sunwisecasinobetPairPlusPlayer',
    function(tableId, betAmount)
        local source = source
        if ServerPokers[tableId] ~= nil then
            if ServerPokers[tableId].PairPlusBets[source] == nil then
                if getPlayerChips(source) < betAmount then
                    TriggerClientEvent("blackjack:notify",source,CasinoConfigSH.Lang.BadAmount)
                    return
                end

                -- checking if he is able to bet the pair plus without lowering the bets < 0
                local currentAnteBetAmount = getPlayerBetAmount(source, tableId)
                if getPlayerChips(source) < (currentAnteBetAmount + betAmount) then
                    TriggerClientEvent("blackjack:notify",source,CasinoConfigSH.Lang.BadAmount)
                    return
                end

                ----------------

                if ServerPokers[tableId].TimeLeft ~= nil and ServerPokers[tableId].TimeLeft > 0 then
                    ServerPokers[tableId].PairPlusBets[source] = betAmount
                    TriggerClientEvent('sunwisecasinoplayerPairPlusAnim', source, betAmount)
                    removeChips(source, betAmount)
                end
            end
        end
    end
)

AddEventHandler(
    'sunwisecasinobetPlayer',
    function(tableId, chairData, betAmount)
        local source = source
        if ServerPokers[tableId] ~= nil then
            if ServerPokers[tableId].PlayerBets[source] == nil then
                if getPlayerChips(source) < betAmount then
                    TriggerClientEvent("blackjack:notify",source,CasinoConfigSH.Lang.BadAmount)
                    return
                end

                -- check the doubled value of the bet for the play deny
                if getPlayerChips(source) < betAmount * 2 then
                    TriggerClientEvent("blackjack:notify",source,CasinoConfigSH.Lang.BadAmount)
                    return
                end

                ---------------------
                if ServerPokers[tableId].Active == false then -- really important here
                    -- important to have it after
                    ServerPokers[tableId].TimeLeft = 5
                    ServerPokers[tableId].Active = true
                    TriggerClientEvent('sunwisecasinoupdateState', -1, tableId, ServerPokers[tableId].Active, ServerPokers[tableId].TimeLeft)
                end

                ------------------------------------------

                if ServerPokers[tableId].TimeLeft ~= nil and ServerPokers[tableId].TimeLeft > 0 then
                    ServerPokers[tableId].PlayerBets[source] = betAmount
                    TriggerClientEvent('sunwisecasinoplayerBetAnim', source, betAmount)
                    removeChips(source, betAmount)

                    if ServerPokers[tableId].Cards['dealer'] == nil then -- generating dealer hands if not exist
                        ServerPokers[tableId].Cards['dealer'] = {
                            Hand = generateHand(tableId)
                        }
                    end

                    if ServerPokers[tableId].Cards[source] == nil then -- generating player hands if not exist
                        ServerPokers[tableId].Cards[source] = {
                            Hand = generateHand(tableId),
                            chairData = chairData
                        }
                    end

                    TriggerClientEvent('sunwisecasinoupdateCards', -1, tableId, ServerPokers[tableId].Cards)
                end
            end
        end
    end
)

local PokerCards = {
    [1] = 'vw_prop_vw_club_char_a_a',
    [2] = 'vw_prop_vw_club_char_02a',
    [3] = 'vw_prop_vw_club_char_03a',
    [4] = 'vw_prop_vw_club_char_04a',
    [5] = 'vw_prop_vw_club_char_05a',
    [6] = 'vw_prop_vw_club_char_06a',
    [7] = 'vw_prop_vw_club_char_07a',
    [8] = 'vw_prop_vw_club_char_08a',
    [9] = 'vw_prop_vw_club_char_09a',
    [10] = 'vw_prop_vw_club_char_10a',
    [11] = 'vw_prop_vw_club_char_j_a',
    [12] = 'vw_prop_vw_club_char_q_a',
    [13] = 'vw_prop_vw_club_char_k_a',
    [14] = 'vw_prop_vw_dia_char_a_a',
    [15] = 'vw_prop_vw_dia_char_02a',
    [16] = 'vw_prop_vw_dia_char_03a',
    [17] = 'vw_prop_vw_dia_char_04a',
    [18] = 'vw_prop_vw_dia_char_05a',
    [19] = 'vw_prop_vw_dia_char_06a',
    [20] = 'vw_prop_vw_dia_char_07a',
    [21] = 'vw_prop_vw_dia_char_08a',
    [22] = 'vw_prop_vw_dia_char_09a',
    [23] = 'vw_prop_vw_dia_char_10a',
    [24] = 'vw_prop_vw_dia_char_j_a',
    [25] = 'vw_prop_vw_dia_char_q_a',
    [26] = 'vw_prop_vw_dia_char_k_a',
    [27] = 'vw_prop_vw_hrt_char_a_a',
    [28] = 'vw_prop_vw_hrt_char_02a',
    [29] = 'vw_prop_vw_hrt_char_03a',
    [30] = 'vw_prop_vw_hrt_char_04a',
    [31] = 'vw_prop_vw_hrt_char_05a',
    [32] = 'vw_prop_vw_hrt_char_06a',
    [33] = 'vw_prop_vw_hrt_char_07a',
    [34] = 'vw_prop_vw_hrt_char_08a',
    [35] = 'vw_prop_vw_hrt_char_09a',
    [36] = 'vw_prop_vw_hrt_char_10a',
    [37] = 'vw_prop_vw_hrt_char_j_a',
    [38] = 'vw_prop_vw_hrt_char_q_a',
    [39] = 'vw_prop_vw_hrt_char_k_a',
    [40] = 'vw_prop_vw_spd_char_a_a',
    [41] = 'vw_prop_vw_spd_char_02a',
    [42] = 'vw_prop_vw_spd_char_03a',
    [43] = 'vw_prop_vw_spd_char_04a',
    [44] = 'vw_prop_vw_spd_char_05a',
    [45] = 'vw_prop_vw_spd_char_06a',
    [46] = 'vw_prop_vw_spd_char_07a',
    [47] = 'vw_prop_vw_spd_char_08a',
    [48] = 'vw_prop_vw_spd_char_09a',
    [49] = 'vw_prop_vw_spd_char_10a',
    [50] = 'vw_prop_vw_spd_char_j_a',
    [51] = 'vw_prop_vw_spd_char_q_a',
    [52] = 'vw_prop_vw_spd_char_k_a'
}

-- generating hand function
function generateHand(tableId)
    local handTable = {}

    if ServerPokers[tableId] ~= nil then
        for i = 1, 3, 1 do
            local randomCard = math.random(1, #PokerCards)

            while ServerPokers[tableId].UsedCards[randomCard] ~= nil do
                randomCard = math.random(1, #PokerCards)
            end

            ServerPokers[tableId].UsedCards[randomCard] = true
            handTable[i] = randomCard
        end

        return handTable
    end
end

CreateThread(
    function()
        while true do
            Wait(1000)

            for tableId, _ in pairs(ServerPokers) do
                if ServerPokers[tableId].Active then
                    if ServerPokers[tableId].TimeLeft > 0 then
                        ServerPokers[tableId].TimeLeft = ServerPokers[tableId].TimeLeft - 1
                        TriggerClientEvent('sunwisecasinoupdateState', -1, tableId, ServerPokers[tableId].Active, ServerPokers[tableId].TimeLeft)

                        if ServerPokers[tableId].TimeLeft < 1 then
                            if ServerPokers[tableId].Stage == 0 then
                                CreateThread(
                                    function()
                                        TriggerClientEvent('sunwisecasinoStage:1', -1, tableId) -- first ACTION

                                        Wait(9000)

                                        TriggerClientEvent('sunwisecasinoStage:2', -1, tableId) -- dealing PLAYER cards

                                        local activePlayers = getTablePlayersCount(tableId)

                                        Wait(4000 * activePlayers)

                                        TriggerClientEvent('sunwisecasinoStage:3', -1, tableId) -- dealing DEALER cards

                                        Wait(8000)

                                        TriggerClientEvent('sunwisecasinoStage:4', -1, tableId) -- PLAYERS watching cards

                                        Wait((5 * 1000) + 5000)

                                        TriggerClientEvent('sunwisecasinoStage:5', -1, tableId) -- reveal PLAYER cards

                                        local activePlayers = getTablePlayersCount(tableId)
                                        Wait(2000 + (5000 * activePlayers))

                                        TriggerClientEvent('sunwisecasinoStage:6', -1, tableId) -- reveal DEALER cards
                                        Wait(10000)
                                        CheckWinners(tableId) -- checking winners on server side
                                        Wait(1500)

                                        TriggerClientEvent('sunwisecasinoStage:7', -1, tableId) -- clearing table

                                        Wait(8000 + (4000 * activePlayers))

                                        TriggerClientEvent('sunwisecasinoresetTable', -1, tableId)
                                        ServerPokers[tableId].PlayerBets = {}
                                        ServerPokers[tableId].Active = false
                                        ServerPokers[tableId].Cards = {}
                                        ServerPokers[tableId].UsedCards = {}
                                        ServerPokers[tableId].Stage = 0
                                        ServerPokers[tableId].TimeLeft = nil
                                        ServerPokers[tableId].PlayersFolded = {}
                                        ServerPokers[tableId].PairPlusBets = {}
                                    end
                                )
                            end
                        end
                    end
                end
            end
        end
    end
)

local GetCardValue = function(cardArrayId)
    local vals = {
        -- 2
        [2] = 2,
        [15] = 2,
        [28] = 2,
        [41] = 2,
        -- 3
        [3] = 3,
        [16] = 3,
        [29] = 3,
        [42] = 3,
        -- 4
        [4] = 4,
        [17] = 4,
        [30] = 4,
        [43] = 4,
        -- 5
        [5] = 5,
        [18] = 5,
        [31] = 5,
        [44] = 5,
        -- 6
        [6] = 6,
        [19] = 6,
        [32] = 6,
        [45] = 6,
        -- 7
        [7] = 7,
        [20] = 7,
        [33] = 7,
        [46] = 7,
        -- 8
        [8] = 8,
        [21] = 8,
        [34] = 8,
        [47] = 8,
        -- 9
        [9] = 9,
        [22] = 9,
        [35] = 9,
        [48] = 9,
        -- 10
        [10] = 10,
        [23] = 10,
        [36] = 10,
        [49] = 10,
        -- JACK
        [11] = 11,
        [24] = 11,
        [37] = 11,
        [50] = 11,
        -- QUEEN
        [12] = 12,
        [25] = 12,
        [38] = 12,
        [51] = 12,
        -- KING
        [13] = 13,
        [26] = 13,
        [39] = 13,
        [52] = 13,
        -- ACE
        [1] = 14,
        [14] = 14,
        [27] = 14,
        [40] = 14
    }

    if vals[cardArrayId] then
        return vals[cardArrayId]
    else
        return 0
    end
end

GetCardType = function(cardArrayId)
    if cardArrayId >= 1 and cardArrayId <= 13 then -- CLUBS
        return 0
    elseif cardArrayId >= 14 and cardArrayId <= 26 then -- DIAMOND
        return 1
    elseif cardArrayId >= 26 and cardArrayId <= 39 then -- HEARTS
        return 2
    elseif cardArrayId >= 39 and cardArrayId <= 52 then -- SPADES
        return 3
    end
end

getHandAllValues = function(handTable, bool_1, bool_2)
    if type(handTable) == 'table' then
        local c1, c2, c3 = GetCardValue(handTable[1]), GetCardValue(handTable[2]), GetCardValue(handTable[3])

        local handValue = 0

        -- FIRST CHECK
        if (c1 ~= c2 and c1 ~= c3) and c2 ~= c3 then
            local Flush = false

            handValue = c1 + c2 + c3

            if handValue == 19 then
                if (c1 == 14 or c1 == 2 or c1 == 3) and (c2 == 14 or c2 == 2 or c2 == 3) and (c3 == 14 or c3 == 2 or c3 == 3) then
                    Flush = true
                end
            elseif handValue == 9 then
                if (c1 == 2 or c1 == 3 or c1 == 4) and (c2 == 2 or c2 == 3 or c2 == 4) and (c3 == 2 or c3 == 3 or c3 == 4) then
                    Flush = true
                end
            elseif handValue == 12 then
                if (c1 == 3 or c1 == 4 or c1 == 5) and (c2 == 3 or c2 == 4 or c2 == 5) and (c3 == 3 or c3 == 4 or c3 == 5) then
                    Flush = true
                end
            elseif handValue == 15 then
                if (c1 == 4 or c1 == 5 or c1 == 6) and (c2 == 4 or c2 == 5 or c2 == 6) and (c3 == 4 or c3 == 5 or c3 == 6) then
                    Flush = true
                end
            elseif handValue == 18 then
                if (c1 == 5 or c1 == 6 or c1 == 7) and (c2 == 5 or c2 == 6 or c2 == 7) and (c3 == 5 or c3 == 6 or c3 == 7) then
                    Flush = true
                end
            elseif handValue == 21 then
                if (c1 == 6 or c1 == 7 or c1 == 8) and (c2 == 6 or c2 == 7 or c2 == 8) and (c3 == 6 or c3 == 7 or c3 == 8) then
                    Flush = true
                end
            elseif handValue == 24 then
                if (c1 == 7 or c1 == 8 or c1 == 9) and (c2 == 7 or c2 == 8 or c2 == 9) and (c3 == 7 or c3 == 8 or c3 == 9) then
                    Flush = true
                end
            elseif handValue == 27 then
                if (c1 == 8 or c1 == 9 or c1 == 10) and (c2 == 8 or c2 == 9 or c2 == 10) and (c3 == 8 or c3 == 9 or c3 == 10) then
                    Flush = true
                end
            elseif handValue == 30 then
                if (c1 == 9 or c1 == 10 or c1 == 11) and (c2 == 9 or c2 == 10 or c2 == 11) and (c3 == 9 or c3 == 10 or c3 == 11) then
                    Flush = true
                end
            elseif handValue == 33 then
                if (c1 == 10 or c1 == 11 or c1 == 12) and (c2 == 10 or c2 == 11 or c2 == 12) and (c3 == 10 or c3 == 11 or c3 == 12) then
                    Flush = true
                end
            elseif handValue == 36 then
                if (c1 == 11 or c1 == 12 or c1 == 13) and (c2 == 11 or c2 == 12 or c3 == 13) and (c3 == 11 or c3 == 12 or c3 == 13) then
                    --something true
                    Flush = true
                end
            elseif handValue == 39 then
                if (c1 == 12 or c1 == 13 or c1 == 14) and (c2 == 12 or c2 == 13 or c2 == 14) and (c3 == 12 or c3 == 13 or c3 == 14) then
                    --something true
                    Flush = true
                end
            end

            if Flush then
                if handValue == 19 then
                    handValue = 6
                end

                if GetCardType(handTable[1]) == GetCardType(handTable[2]) and GetCardType(handTable[1]) == GetCardType(handTable[3]) then
                    return handValue + 500
                end

                return handValue + 300
            end
        end

        handValue = 0

        -- SECOND CHECK
        if (c1 == c2) and c1 ~= c3 then -- pairs
            if not bool_1 and not bool_2 then
                return (c1 + c2) + 100
            else
                return c3
            end
        elseif (c2 == c3) and c2 ~= c1 then -- pairs
            if not bool_1 and not bool_2 then
                return (c2 + c3) + 100
            else
                return c1
            end
        elseif (c3 == c1) and c3 ~= c2 then -- pairs
            if not bool_1 and not bool_2 then
                return (c1 + c3) + 100
            else
                return c2
            end
        elseif c1 == c2 and c1 == c3 then -- 3 of a kind
            return c1 + c2 + c3 + 400
        elseif GetCardType(handTable[1]) == GetCardType(handTable[2]) and GetCardType(handTable[1]) == GetCardType(handTable[3]) then
            handValue = 200
        end

        -- third check if it runs here

        if c1 > c2 and c1 > c3 then
            if bool_1 then
                if c2 > c3 then
                    return handValue + c2
                else
                    return handValue + c3
                end
            elseif bool_2 then
                if c2 > c3 then
                    return handValue + c3
                else
                    return handValue + c2
                end
            end

            return handValue + c1
        elseif c2 > c1 and c2 > c3 then
            if bool_1 then
                if c1 > c3 then
                    return handValue + c1
                else
                    return handValue + c3
                end
            elseif bool_2 then
                if c1 > c3 then
                    return handValue + c3
                else
                    return handValue + c1
                end
            end

            return handValue + c2
        elseif c3 > c1 and c3 > c2 then
            if bool_1 then
                if c1 > c2 then
                    return handValue + c1
                else
                    return handValue + c2
                end
            elseif bool_2 then
                if c1 > c2 then
                    return handValue + c2
                else
                    return handValue + c1
                end
            end

            return handValue + c3
        end

        return handValue
    else
        return 0
    end
end

local function canDealerPlay(handValue)
    if handValue >= 12 then
        return true
    else
        return false
    end
end

function CheckWinners(tableId)
    if ServerPokers[tableId] ~= nil then
        local dealerHand = 0
        local dealerHand_second = 0
        local dealerHand_third = 0

        -- dh means dealerhand
        local dH = ServerPokers[tableId].Cards['dealer']
        if dH then
            dealerHand = getHandAllValues(dH.Hand)
            dealerHand_second = getHandAllValues(dH.Hand, true, false)
            dealerHand_third = getHandAllValues(dH.Hand, false, true)
        end

        for targetSrc, data in pairs(ServerPokers[tableId].Cards) do
            if targetSrc ~= 'dealer' and playerStillExist(targetSrc) then
                -- check that the player folded their hand or not
                if ServerPokers[tableId].PlayersFolded[targetSrc] == nil then
                    local playerHand = getHandAllValues(data.Hand)
                    local playerHand_second = getHandAllValues(data.Hand, true, false)
                    local playerHand_third = getHandAllValues(data.Hand, false, true)

                    if canDealerPlay(dealerHand) then
                        if playerHand > dealerHand then -- win
                            playerWon(targetSrc, tableId, playerHand)
                        elseif playerHand < dealerHand then -- lose
                            playerLost(targetSrc, tableId, playerHand)
                        elseif playerHand == dealerHand then
                            if playerHand_second == dealerHand_second then -- if equals going more
                                if playerHand_third > dealerHand_third then
                                    playerWon(targetSrc, tableId, playerHand)
                                elseif playerHand_third == dealerHand_third then
                                    playerDraw(targetSrc, tableId, playerHand)
                                else
                                    playerLost(targetSrc, tableId, playerHand)
                                end
                            elseif playerHand_second > dealerHand_second then -- if bigger then win
                                playerWon(targetSrc, tableId, playerHand)
                            else
                                playerLost(targetSrc, tableId, playerHand)
                            end
                        end
                    else
                        playerDraw(targetSrc, tableId, playerHand)
                    end

                    local pairMultiplier = GetPairMultiplier(playerHand)
                    if pairMultiplier > 0 then
                        playerPairPlusWon(targetSrc, tableId, pairMultiplier)
                    end
                end
            end
        end
    end
end

function playerPairPlusWon(targetSrc, tableId, pairMultiplier)
    local betAmount = getPlayerPairPlusBetAmount(targetSrc, tableId)
    if betAmount > 0 then
        local plusChips = math.floor(betAmount * pairMultiplier)
        if plusChips > 0 then
            TriggerClientEvent("blackjack:notify",targetSrc,string.format(CasinoConfigSH.Lang.WonPairPlusMult, plusChips, pairMultiplier))
            giveChips(targetSrc, plusChips)
        end
    end
end

function playerWon(targetSrc, tableId, handValue)
    local betAmount = getPlayerBetAmount(targetSrc, tableId)
    if betAmount > 0 then
        local plusChips = math.floor((betAmount * 2) * 2)

        local AnteMultiplier = GetAnteMultiplier(handValue)
        if AnteMultiplier > 0 then
            plusChips = math.floor(plusChips + (AnteMultiplier * betAmount))
            TriggerClientEvent("blackjack:notify",targetSrc,string.format(CasinoConfigSH.Lang.WonAntMult, plusChips, AnteMultiplier))
        else
            TriggerClientEvent("blackjack:notify",targetSrc,string.format(CasinoConfigSH.Lang.WonAmount, plusChips))
        end
        giveChips(targetSrc, plusChips)
        TriggerClientEvent('sunwisecasinoplayerWin', targetSrc, tableId)
    end
end

function playerDraw(targetSrc, tableId, handValue)
    local betAmount = getPlayerBetAmount(targetSrc, tableId)
    if betAmount > 0 then
        local plusChips = math.floor(betAmount * 2)

        -- you will get your ante bet bonus even if you loss or draw
        local AnteMultiplier = GetAnteMultiplier(handValue)
        if AnteMultiplier > 0 then
            plusChips = math.floor(plusChips + ((betAmount / 2) * AnteMultiplier))
        end
        TriggerClientEvent("blackjack:notify",targetSrc,string.format(CasinoConfigSH.Lang.DealerDidntQualify,plusChips))

        giveChips(targetSrc, plusChips)
        TriggerClientEvent('sunwisecasinoplayerDraw', targetSrc, tableId)
    end
end

function playerLost(targetSrc, tableId, handValue)
    local betAmount = getPlayerBetAmount(targetSrc, tableId)
    if betAmount > 0 then
        TriggerClientEvent("blackjack:notify",targetSrc,CasinoConfigSH.Lang.Lost)
        TriggerClientEvent('sunwisecasinoplayerLost', targetSrc, tableId)
    end
end

function updatePlayerChips(targetSrc)
    TriggerClientEvent('sunwisecasinoupdatePlayerChips', targetSrc, getPlayerChips(targetSrc))
end

function getPlayerPairPlusBetAmount(targetSrc, tableId)
    if ServerPokers[tableId] ~= nil then
        if ServerPokers[tableId].PairPlusBets ~= nil and ServerPokers[tableId].PairPlusBets[targetSrc] ~= nil then
            return ServerPokers[tableId].PairPlusBets[targetSrc]
        end
    end

    return 0
end

function getPlayerBetAmount(targetSrc, tableId)
    if ServerPokers[tableId] ~= nil then
        if ServerPokers[tableId].PlayerBets ~= nil and ServerPokers[tableId].PlayerBets[targetSrc] ~= nil then
            return ServerPokers[tableId].PlayerBets[targetSrc]
        end
    end

    return 0
end

function playerStillExist(source)
    if GetPlayerName(source) == nil then
        return false
    else
        return true
    end
end

function getTablePlayersCount(tableId)
    local playersCount = 0
    if ServerPokers[tableId] ~= nil then
        for targetSrc, _ in pairs(ServerPokers[tableId].Cards) do
            if playerStillExist(targetSrc) then
                playersCount = playersCount + 1
            end
        end
    end

    return playersCount
end

SWRegisterServCallback(
    'sunwisecasinositDown',
    function(source, cb, tableId, chairId)
        if ServerPokers[tableId] == nil then
            ServerPokers[tableId] = {
                ChairsUsed = {}, -- chairs used, for disable sitting
                PlayerBets = {}, -- player bets ofc.
                Active = false,
                Cards = {}, -- player / dealer cards, etc.
                UsedCards = {}, -- which card was used, so we can not pick the same
                PlayersFolded = {}, -- following who folded their cards
                PairPlusBets = {},
                Stage = 0, -- following the stages
                TimeLeft = nil
            }
        end

        if ServerPokers[tableId].ChairsUsed[chairId] == nil then
            ServerPokers[tableId].ChairsUsed[chairId] = source
            updatePlayerChips(source)
            cb(true)
        else
            cb(false)
        end
    end
)

AddEventHandler(
    'playerDropped',
    function(reason)
        local source = source

        for k, v in pairs(ServerPokers) do
            if v.ChairsUsed ~= nil then
                for chairId, chairOwner in pairs(v.ChairsUsed) do
                    if chairOwner == source then
                        ServerPokers[k].ChairsUsed[chairId] = nil
                    end
                end
            end
        end
    end
)