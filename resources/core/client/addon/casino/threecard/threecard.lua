local SharedPokers = {}
local closeToPokers = false

local mainScene = nil -- the main sitting scene, we need it globally, for the exit
local activePokerTable = nil -- current table Id where we are sitting
local activeChairData = nil -- chair data, it is a table with rotation and coords
local currentBetInput = 0 -- currently bet input

local playerBetted = nil -- important, because when it changes to TRUE, we are disabling the standup, etc
local playerPairPlus = nil -- pair plus bet amount
local watchingCards = false -- for the notification and other inputs
local playerDecidedChoice = false

local clientTimer = nil
local currentHelpText = nil

local mainCamera = nil

local buttonScaleform = nil

local networkedChips = {}

local PlayerOwnedChips = 0

local InformationPlaying = false

local playedHudSound = false

local frm_showed = false

local GroupDigits = function(value)
    if value == 0 then return 0 end
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. ' '):reverse())..right
end

local function PlaySoundFront(soundId, audioName, audioRef, p3)
    if CasinoConfig.PlayFrontendSounds then
        PlaySoundFrontend(soundId, audioName, audioRef, p3)
    end
end

local GtaPokerCards = {
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

-- EVENTS
RegisterNetEvent('sunwisecasinoupdateCards')
RegisterNetEvent('sunwisecasinoupdateState')
RegisterNetEvent('sunwisecasinoplayerBetAnim')
RegisterNetEvent('sunwisecasinoStage:1')
RegisterNetEvent('sunwisecasinoStage:2')
RegisterNetEvent('sunwisecasinoStage:3')
RegisterNetEvent('sunwisecasinoStage:4')
RegisterNetEvent('sunwisecasinoplayerPlayCards')
RegisterNetEvent('sunwisecasinoplayerFoldCards')
RegisterNetEvent('sunwisecasinoStage:5')
RegisterNetEvent('sunwisecasinoStage:6')
RegisterNetEvent('sunwisecasinoStage:7')
RegisterNetEvent('sunwisecasinoresetTable')
RegisterNetEvent('sunwisecasinoplayerWin')
RegisterNetEvent('sunwisecasinoplayerLost')
RegisterNetEvent('sunwisecasinoplayerDraw')
RegisterNetEvent('sunwisecasinoupdatePlayerChips')
RegisterNetEvent('sunwisecasinoplayerPairPlusAnim')
----------------------

AddEventHandler('sunwisecasinoplayerPairPlusAnim',function(amount)
    if SharedPokers[activePokerTable] ~= nil then
        SharedPokers[activePokerTable].playerPairPlusAnim(amount)
    end
end)

AddEventHandler('sunwisecasinoupdateCards',function(tableId, Cards)
    if SharedPokers[tableId] ~= nil then
        SharedPokers[tableId].updateCards(Cards)
    end
end)

AddEventHandler('sunwisecasinoupdateState',function(tableId, Active, TimeLeft)
    if SharedPokers[tableId] ~= nil then
        SharedPokers[tableId].updateState(Active, TimeLeft)
    end
end)

AddEventHandler('sunwisecasinoplayerBetAnim',function(amount)
    if SharedPokers[activePokerTable] ~= nil then
        SharedPokers[activePokerTable].playerBetAnim(amount)
    end
end)

AddEventHandler('sunwisecasinoupdatePlayerChips',function(amount)
        PlayerOwnedChips = amount
end)

AddEventHandler('sunwisecasinoplayerDraw',function(tableId)
        if SharedPokers[tableId] ~= nil then
            SharedPokers[tableId].playerDraw()
        end
end)

AddEventHandler('sunwisecasinoplayerLost',function(tableId)
        if SharedPokers[tableId] ~= nil then
            SharedPokers[tableId].playerLost()
        end
end)

AddEventHandler('sunwisecasinoplayerWin',function(tableId)
        if SharedPokers[tableId] ~= nil then
            SharedPokers[tableId].playerWin()
        end
end)

AddEventHandler('sunwisecasinoresetTable',function(tableId)
        if SharedPokers[tableId] ~= nil then
            SharedPokers[tableId].resetTable()
        end
end)

AddEventHandler('sunwisecasinoStage:7', function(tableId)
    if SharedPokers[tableId] ~= nil then
        currentHelpText = CasinoConfigSH.Lang.ClearingTable .. "\n"
        SharedPokers[tableId].clearTable()
    end
end)
AddEventHandler('sunwisecasinoStage:6',function(tableId)
        if SharedPokers[tableId] ~= nil then
            currentHelpText = CasinoConfigSH.Lang.DealerShowHand .. "\n"
            SharedPokers[tableId].revealSelfCards()
        end
end)
AddEventHandler('sunwisecasinoStage:5',function(tableId)
        if SharedPokers[tableId] ~= nil then
            currentHelpText = CasinoConfigSH.Lang.ShowPlayersHands
            SharedPokers[tableId].revealPlayerCards()
        end
end)

AddEventHandler('sunwisecasinoStage:1',function(tableId)
        if SharedPokers[tableId] ~= nil then
            SharedPokers[tableId].FirstAction()
        end
end)

AddEventHandler('sunwisecasinoStage:2',function(tableId)
        if SharedPokers[tableId] ~= nil then
            currentHelpText = CasinoConfigSH.Lang.DealingCards
            SharedPokers[tableId].dealToPlayers()
        end
end)
AddEventHandler('sunwisecasinoStage:3',function(tableId)
        if SharedPokers[tableId] ~= nil then
            currentHelpText = nil
            SharedPokers[tableId].dealToSelf()
            SharedPokers[tableId].putDownDeck()
            SharedPokers[tableId].dealerStandingIdle()
        end
end)

AddEventHandler('sunwisecasinoStage:4',function(tableId)
        if SharedPokers[tableId] ~= nil then
            currentHelpText = nil
            SharedPokers[tableId].watchCards()
        end
end)

AddEventHandler('sunwisecasinoplayerPlayCards',function(mainSrc, tableId)
        if SharedPokers[tableId] ~= nil then
            SharedPokers[tableId].playCards(mainSrc)
        end
end)

AddEventHandler('sunwisecasinoplayerFoldCards',function(mainSrc, tableId)
        if SharedPokers[tableId] ~= nil then
            SharedPokers[tableId].foldCards(mainSrc)
        end
end)

local PokerGetCardType = function(cardArrayId)
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

IncreaseAmounts = function(currentAmount)
    if currentAmount < 500 then
        return 50
    elseif currentAmount >= 500 and currentAmount < 2000 then
        return 100
    elseif currentAmount >= 2000 and currentAmount < 5000 then
        return 200
    elseif currentAmount >= 5000 and currentAmount < 10000 then
        return 500
    elseif currentAmount >= 10000 then
        return 1000
    else
        return 50
    end
end

formatHandValue = function(handValue)
    if handValue > 500 then
        return 'Straight flush'
    elseif handValue > 400 then
        return '3 of a kind'
    elseif handValue > 300 then
        return 'Straight'
    elseif handValue > 200 then
        return 'Flush'
    elseif handValue > 100 then
        if handValue == 128 then
            return 'Pair Ace'
        elseif handValue == 104 then
            return 'Pair 2'
        elseif handValue == 106 then
            return 'Pair 3'
        elseif handValue == 108 then
            return 'Pair 4'
        elseif handValue == 110 then
            return 'Pair 5'
        elseif handValue == 112 then
            return 'Pair 6'
        elseif handValue == 114 then
            return 'Pair 7'
        elseif handValue == 116 then
            return 'Pair 8'
        elseif handValue == 118 then
            return 'Pair 9'
        elseif handValue == 120 then
            return 'Pair 10'
        elseif handValue == 122 then
            return 'Pair Jack'
        elseif handValue == 124 then
            return 'Pair Queen'
        elseif handValue == 126 then
            return 'Pair King'
        end
    elseif handValue == 5 then
        return 'High Card 5'
    elseif handValue == 6 then
        return 'High Card 6'
    elseif handValue == 7 then
        return 'High Card 7'
    elseif handValue == 8 then
        return 'High Card 8'
    elseif handValue == 9 then
        return 'High Card 9'
    elseif handValue == 10 then
        return 'High Card 10'
    elseif handValue == 11 then
        return 'High Card Jack'
    elseif handValue == 12 then
        return 'High Card Queen'
    elseif handValue == 13 then
        return 'High Card King'
    else
        return 'High Card Ace'
    end

    return ''
end

local PokerGetCardValue = function(cardArrayId)
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

PokerGetHandAllValues = function(handTable, bool_1, bool_2)
    if type(handTable) == 'table' then
        local c1, c2, c3 = PokerGetCardValue(handTable[1]), PokerGetCardValue(handTable[2]), PokerGetCardValue(handTable[3])

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

                if PokerGetCardType(handTable[1]) == PokerGetCardType(handTable[2]) and PokerGetCardType(handTable[1]) == PokerGetCardType(handTable[3]) then
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
        elseif PokerGetCardType(handTable[1]) == PokerGetCardType(handTable[2]) and PokerGetCardType(handTable[1]) == PokerGetCardType(handTable[3]) then
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

PokerThread = function(index, data)
    local self = {}

    self.index = index
    self.data = data

    self.cards = {}

    self.playersFolded = {}

    self.updateCards = function(Cards)
        self.ServerCards = Cards
    end

    self.updateState = function(Active, TimeLeft)
        self.Active = Active
        self.TimeLeft = TimeLeft
    end

    self.playerDraw = function()
        local pedReaction = CreateSynchronizedScene(self.data.Position, 0.0, 0.0, self.data.Heading, 2)
        if self.isPedFemale() then
            local pedr = ({'female_dealer_reaction_impartial_var01', 'female_dealer_reaction_impartial_var02', 'female_dealer_reaction_impartial_var03'})[math.random(1, 3)]
            TaskSynchronizedScene(self.ped, pedReaction, CasinoConfig.DealerAnimDictShared, pedr, 2.0, -2.0, 13, 16, 1000.0, 0)
        else
            local pedr = ({'reaction_impartial_var_01', 'reaction_impartial_var_02', 'reaction_impartial_var_03', 'reaction_impartial_var_04'})[math.random(1, 4)]
            TaskSynchronizedScene(self.ped, pedReaction, CasinoConfig.DealerAnimDictShared, pedr, 2.0, -2.0, 13, 16, 1000.0, 0)
        end
    end

    self.playerWin = function()
        local reaction = nil
        if not IsPedMale(PlayerPedId()) then -- female
            reaction =
                ({
                'female_reaction_great_var_01',
                'female_reaction_great_var_02',
                'female_reaction_great_var_03',
                'female_reaction_great_var_04',
                'female_reaction_great_var_05'
            })[math.random(1, 5)]
        else
            reaction = ({'reaction_great_var_01', 'reaction_great_var_02', 'reaction_great_var_03', 'reaction_great_var_04'})[math.random(1, 4)]
        end

        if reaction then
            local reactionScene = NetworkCreateSynchronisedScene(activeChairData.chairCoords, activeChairData.chairRotation, 2, true, false, 1.0, 0.0, 1.0)
            NetworkAddPedToSynchronisedScene(PlayerPedId(), reactionScene, CasinoConfig.PlayerAnimDictShared, reaction, 2.0, -2.0, 13, 16, 2.0, 0)
            NetworkStartSynchronisedScene(reactionScene)
        end

        local pedReaction = CreateSynchronizedScene(self.data.Position, 0.0, 0.0, self.data.Heading, 2)
        if self.isPedFemale() then
            local pedr = ({'female_dealer_reaction_bad_var01', 'female_dealer_reaction_bad_var02', 'female_dealer_reaction_bad_var03'})[math.random(1, 3)]
            TaskSynchronizedScene(self.ped, pedReaction, CasinoConfig.DealerAnimDictShared, pedr, 2.0, -2.0, 13, 16, 1000.0, 0)
        else
            local pedr = ({'reaction_bad_var_01', 'reaction_bad_var_02', 'reaction_bad_var_03', 'reaction_bad_var_04'})[math.random(1, 4)]
            TaskSynchronizedScene(self.ped, pedReaction, CasinoConfig.DealerAnimDictShared, pedr, 2.0, -2.0, 13, 16, 1000.0, 0)
        end
    end

    self.playerLost = function()
        local reaction = nil
        if not IsPedMale(PlayerPedId()) then -- female
            reaction =
                ({
                'female_reaction_terrible_var_01',
                'female_reaction_terrible_var_02',
                'female_reaction_terrible_var_03',
                'female_reaction_terrible_var_04',
                'female_reaction_terrible_var_05'
            })[math.random(1, 5)]
        else
            reaction = ({'reaction_terrible_var_01', 'reaction_terrible_var_02', 'reaction_terrible_var_03', 'reaction_terrible_var_04'})[math.random(1, 4)]
        end

        if reaction then
            local reactionScene = NetworkCreateSynchronisedScene(activeChairData.chairCoords, activeChairData.chairRotation, 2, true, false, 1.0, 0.0, 1.0)
            NetworkAddPedToSynchronisedScene(PlayerPedId(), reactionScene, CasinoConfig.PlayerAnimDictShared, reaction, 2.0, -2.0, 13, 16, 2.0, 0)
            NetworkStartSynchronisedScene(reactionScene)
        end

        local pedReaction = CreateSynchronizedScene(self.data.Position, 0.0, 0.0, self.data.Heading, 2)
        if self.isPedFemale() then
            local pedr = ({'female_dealer_reaction_good_var01', 'female_dealer_reaction_good_var02', 'female_dealer_reaction_good_var03'})[math.random(1, 3)]
            TaskSynchronizedScene(self.ped, pedReaction, CasinoConfig.DealerAnimDictShared, pedr, 2.0, -2.0, 13, 16, 1000.0, 0)
        else
            local pedr = ({'reaction_good_var_01', 'reaction_good_var_02', 'reaction_good_var_03'})[math.random(1, 3)]
            TaskSynchronizedScene(self.ped, pedReaction, CasinoConfig.DealerAnimDictShared, pedr, 2.0, -2.0, 13, 16, 1000.0, 0)
        end
    end

    self.speakPed = function(duma)
        Citizen.CreateThread(
            function()
                PlayPedAmbientSpeechNative(self.ped, duma, 'SPEECH_PARAMS_FORCE_NORMAL_CLEAR', 1)
            end
        )
    end

    self.createDefaultPakli = function()
        Citizen.CreateThread(
            function()
                local cardModel = GetHashKey('vw_prop_casino_cards_01')
                RequestModel(cardModel)
                while not HasModelLoaded(cardModel) do
                    Wait(1)
                end

                RequestAnimDict(CasinoConfig.DealerAnimDictPoker)
                while not HasAnimDictLoaded(CasinoConfig.DealerAnimDictPoker) do
                    Wait(1)
                end

                local offset = GetAnimInitialOffsetPosition(CasinoConfig.DealerAnimDictPoker, 'deck_pick_up_deck', self.data.Position, 0.0, 0.0, self.data.Heading, 0.01, 2)
                self.pakli = CreateObject(cardModel, offset, false, false, true)
                SetEntityCoordsNoOffset(self.pakli, offset, false, false, true)
                SetEntityRotation(self.pakli, 0.0, 0.0, self.data.Rotation, 2, true)
                FreezeEntityPosition(self.pakli, true)
            end
        )
    end

    self.isPedFemale = function()
        if GetEntityModel(self.ped) == GetHashKey('S_M_Y_Casino_01') then
            return false
        else
            return true
        end
    end

    self.createPed = function()
        Citizen.CreateThread(
            function()
                TriggerSWEvent("TREFSDFD5156FD", "ADSFDF", 5000)
                Wait(500)
                local maleCasinoDealer = GetHashKey('S_M_Y_Casino_01')
                local femaleCasinoDealer = GetHashKey('S_F_Y_Casino_01')

                local frmVar_1 = math.random(1, 13)
                if frmVar_1 < 7 then
                    dealerModel = maleCasinoDealer
                else
                    dealerModel = femaleCasinoDealer
                end

                RequestModel(dealerModel)
                while not HasModelLoaded(dealerModel) do
                    Wait(1)
                end

                self.ped = CreatePed(26, dealerModel, self.data.Position, self.data.Heading, false, true)
                SetModelAsNoLongerNeeded(dealerModel)
                SetEntityCanBeDamaged(self.ped, false)
                SetPedAsEnemy(self.ped, false)
                SetBlockingOfNonTemporaryEvents(self.ped, true)
                SetPedResetFlag(self.ped, 249, 1)
                SetPedConfigFlag(self.ped, 185, true)
                SetPedConfigFlag(self.ped, 108, true)
                SetPedCanEvasiveDive(self.ped, 0)
                SetPedCanRagdollFromPlayerImpact(self.ped, 0)
                SetPedConfigFlag(self.ped, 208, true)
                SetPedCanRagdoll(self.ped, false)
                frm_setPedClothes(frmVar_1, self.ped)
                frm_setPedVoiceGroup(frmVar_1, self.ped)

                SetEntityCoordsNoOffset(self.ped, self.data.Position + vector3(0.0, 0.0, 1.0), false, false, true)
                SetEntityHeading(self.ped, self.data.Heading)

                RequestAnimDict(CasinoConfig.DealerAnimDictShared)
                while not HasAnimDictLoaded(CasinoConfig.DealerAnimDictShared) do
                    Wait(1)
                end

                self.dealerStandingIdle()
            end
        )
    end

    self.sitDown = function(chairId, chairCoords, chairRotation)
        StartAudioScene('DLC_VW_Casino_Table_Games')

        if not IsEntityDead(PlayerPedId()) then
            HidePokerBulles()
            SWTriggerServCallback('sunwisecasinositDown', function(canSit)
                    if canSit then
                        activeChairData = {
                            chairId = chairId,
                            chairCoords = chairCoords,
                            chairRotation = chairRotation
                        }

                        if IsPedMale(PlayerPedId()) then
                            local rspeech = math.random(1, 2)
                            if rspeech == 1 then
                                self.speakPed('MINIGAME_DEALER_GREET')
                            else
                                self.speakPed('MINIGAME_DEALER_GREET_MALE')
                            end
                        else
                            local rspeech = math.random(1, 2)
                            if rspeech == 1 then
                                self.speakPed('MINIGAME_DEALER_GREET')
                            else
                                self.speakPed('MINIGAME_DEALER_GREET_FEMALE')
                            end
                        end

                        buttonScaleform = setupFirstButtons('instructional_buttons')

                        RequestAnimDict(CasinoConfig.PlayerAnimDictShared)
                        while not HasAnimDictLoaded(CasinoConfig.PlayerAnimDictShared) do
                            Wait(1)
                        end
                        SetPlayerControl(PlayerPedId(), 0, 0)
                        local sitScene = NetworkCreateSynchronisedScene(chairCoords, chairRotation, 2, true, false, 1.0, 0.0, 1.0)
                        local sitAnim = ({'sit_enter_left_side', 'sit_enter_right_side'})[math.random(1, 2)]
                        NetworkAddPedToSynchronisedScene(PlayerPedId(), sitScene, CasinoConfig.PlayerAnimDictShared, sitAnim, 2.0, -2.0, 13, 16, 2.0, 0)
                        NetworkStartSynchronisedScene(sitScene)

                        Wait(4000)
                        mainScene = NetworkCreateSynchronisedScene(chairCoords, chairRotation, 2, true, false, 1.0, 0.0, 1.0)
                        NetworkAddPedToSynchronisedScene(PlayerPedId(), mainScene, CasinoConfig.PlayerAnimDictShared, 'idle_cardgames', 2.0, -2.0, 13, 16, 1000.0, 0)
                        NetworkStartSynchronisedScene(mainScene)

                        self.EnableRender(true)
                        SetPlayerControl(PlayerPedId(), 1, 0)

                        Wait(500)
                    else
                        CasinoConfig.ShowNotification(CasinoConfigSH.Lang.SeatOccuped)
                    end
                end,
                self.index,
                chairId
            )
        end
    end

    self.createCard = function(cardName)
        local cardModel = GetHashKey(cardName)
        RequestModel(cardModel)
        while not HasModelLoaded(cardModel) do
            Wait(1)
        end

        return CreateObject(cardModel, self.data.Position + vector3(0.0, 0.0, -0.1), false, true, true)
    end

    self.FirstAction = function()
        self.speakPed('MINIGAME_DEALER_CLOSED_BETS')

        -- FIRST ACTION TO DO WHEN STARTING GAME
        RequestAnimDict(CasinoConfig.DealerAnimDictPoker)
        while not HasAnimDictLoaded(CasinoConfig.DealerAnimDictPoker) do
            Wait(1)
        end

        local firstScene = CreateSynchronizedScene(self.data.Position, 0.0, 0.0, self.data.Heading, 2)

        if self.isPedFemale() then
            TaskSynchronizedScene(self.ped, firstScene, CasinoConfig.DealerAnimDictPoker, 'female_deck_pick_up', 2.0, -2.0, 13, 16, 1000.0, 0)
        else
            TaskSynchronizedScene(self.ped, firstScene, CasinoConfig.DealerAnimDictPoker, 'deck_pick_up', 2.0, -2.0, 13, 16, 1000.0, 0)
        end

        while GetSynchronizedScenePhase(firstScene) < 0.99 do
            if HasAnimEventFired(self.ped, 1691374422) then
                if not IsEntityAttachedToAnyPed(self.pakli) then
                    FreezeEntityPosition(self.pakli, false)
                    AttachEntityToEntity(self.pakli, self.ped, GetPedBoneIndex(self.ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, true, 2, true)
                end
            end

            Wait(1)
        end

        if self.ServerCards['dealer'] ~= nil then
            self.cards['dealer'] = {}

            if not DoesEntityExist(self.cards['dealer'][1]) then
                self.cards['dealer'][1] = self.createCard(GtaPokerCards[self.ServerCards['dealer'].Hand[1]])
            end
            if not DoesEntityExist(self.cards['dealer'][2]) then
                self.cards['dealer'][2] = self.createCard(GtaPokerCards[self.ServerCards['dealer'].Hand[2]])
            end
            if not DoesEntityExist(self.cards['dealer'][3]) then
                self.cards['dealer'][3] = self.createCard(GtaPokerCards[self.ServerCards['dealer'].Hand[3]])
            end
        end

        local secondScene = CreateSynchronizedScene(self.data.Position, 0.0, 0.0, self.data.Heading, 2)
        if self.isPedFemale() then
            TaskSynchronizedScene(self.ped, secondScene, CasinoConfig.DealerAnimDictPoker, 'female_deck_shuffle', 2.0, -2.0, 13, 16, 1000.0, 0)
        else
            TaskSynchronizedScene(self.ped, secondScene, CasinoConfig.DealerAnimDictPoker, 'deck_shuffle', 2.0, -2.0, 13, 16, 1000.0, 0)
        end
        PlaySynchronizedEntityAnim(self.cards['dealer'][1], secondScene, 'deck_shuffle_card_a', CasinoConfig.DealerAnimDictPoker, 1000.0, 0, 0, 1000.0)
        PlaySynchronizedEntityAnim(self.cards['dealer'][2], secondScene, 'deck_shuffle_card_b', CasinoConfig.DealerAnimDictPoker, 1000.0, 0, 0, 1000.0)
        PlaySynchronizedEntityAnim(self.cards['dealer'][3], secondScene, 'deck_shuffle_card_c', CasinoConfig.DealerAnimDictPoker, 1000.0, 0, 0, 1000.0)

        while GetSynchronizedScenePhase(secondScene) < 0.99 do
            Wait(1)
        end

        SetEntityVisible(self.cards['dealer'][1], false, false)
        SetEntityVisible(self.cards['dealer'][2], false, false)
        SetEntityVisible(self.cards['dealer'][3], false, false)

        local thirdScene = CreateSynchronizedScene(self.data.Position, 0.0, 0.0, self.data.Heading, 2)
        if self.isPedFemale() then
            TaskSynchronizedScene(self.ped, thirdScene, CasinoConfig.DealerAnimDictPoker, 'female_deck_idle', 2.0, -2.0, 13, 16, 1000.0, 0)
        else
            TaskSynchronizedScene(self.ped, thirdScene, CasinoConfig.DealerAnimDictPoker, 'deck_idle', 2.0, -2.0, 13, 16, 1000.0, 0)
        end
        while GetSynchronizedScenePhase(thirdScene) < 0.99 do
            Wait(1)
        end
    end

    self.dealToPlayers = function()
        StartAudioScene('DLC_VW_Casino_Cards_Focus_Hand')
        StartAudioScene('DLC_VW_Casino_Table_Games')

        buttonScaleform = nil
        -- SECOND ACTIONS TO DO, THERE CAN BE MORE PLAYERS!
        for targetSrc, data in pairs(self.ServerCards) do
            if targetSrc ~= 'dealer' then
                self.cards[targetSrc] = {}
                self.cards[targetSrc][1] = self.createCard(GtaPokerCards[data.Hand[1]])
                self.cards[targetSrc][2] = self.createCard(GtaPokerCards[data.Hand[2]])
                self.cards[targetSrc][3] = self.createCard(GtaPokerCards[data.Hand[3]])

                RequestAnimDict(CasinoConfig.DealerAnimDictPoker)
                while not HasAnimDictLoaded(CasinoConfig.DealerAnimDictPoker) do
                    Wait(1)
                end

                local playerAnimId = nil

                if data.chairData.chairId == 4 then -- this is reverse because rockstar think differently no idea why
                    playerAnimId = 'p01'
                elseif data.chairData.chairId == 3 then
                    playerAnimId = 'p02'
                elseif data.chairData.chairId == 2 then
                    playerAnimId = 'p03'
                elseif data.chairData.chairId == 1 then
                    playerAnimId = 'p04'
                end

                if playerAnimId ~= nil then
                    local dealScene = CreateSynchronizedScene(self.data.Position, 0.0, 0.0, self.data.Heading, 2)

                    SetEntityVisible(self.cards[targetSrc][1], false, false)
                    SetEntityVisible(self.cards[targetSrc][2], false, false)
                    SetEntityVisible(self.cards[targetSrc][3], false, false)

                    if self.isPedFemale() then
                        TaskSynchronizedScene(self.ped, dealScene, CasinoConfig.DealerAnimDictPoker, string.format('female_deck_deal_%s', playerAnimId), 2.0, -2.0, 13, 16, 1000.0, 0)
                    else
                        TaskSynchronizedScene(self.ped, dealScene, CasinoConfig.DealerAnimDictPoker, string.format('deck_deal_%s', playerAnimId), 2.0, -2.0, 13, 16, 1000.0, 0)
                    end

                    PlaySynchronizedEntityAnim(
                        self.cards[targetSrc][1],
                        dealScene,
                        string.format('deck_deal_%s_card_a', playerAnimId),
                        CasinoConfig.DealerAnimDictPoker,
                        1000.0,
                        0,
                        0,
                        1000.0
                    )
                    PlaySynchronizedEntityAnim(
                        self.cards[targetSrc][2],
                        dealScene,
                        string.format('deck_deal_%s_card_b', playerAnimId),
                        CasinoConfig.DealerAnimDictPoker,
                        1000.0,
                        0,
                        0,
                        1000.0
                    )
                    PlaySynchronizedEntityAnim(
                        self.cards[targetSrc][3],
                        dealScene,
                        string.format('deck_deal_%s_card_c', playerAnimId),
                        CasinoConfig.DealerAnimDictPoker,
                        1000.0,
                        0,
                        0,
                        1000.0
                    )

                    while GetSynchronizedScenePhase(dealScene) < 0.05 do
                        Wait(1)
                    end

                    SetEntityVisible(self.cards[targetSrc][1], true, false)
                    SetEntityVisible(self.cards[targetSrc][2], true, false)
                    SetEntityVisible(self.cards[targetSrc][3], true, false)

                    while GetSynchronizedScenePhase(dealScene) < 0.99 do
                        Wait(1)
                    end
                end
            end
        end
    end

    self.watchCards = function()
        self.speakPed('MINIGAME_DEALER_COMMENT_SLOW')

        if self.index == activePokerTable and playerBetted ~= nil then
            clientTimer = 5
            Citizen.CreateThread(
                function()
                    while clientTimer ~= nil do
                        Wait(1000)
                        if clientTimer ~= nil then
                            clientTimer = clientTimer - 1

                            if clientTimer < 1 then
                                clientTimer = nil
                                CasinoConfig.ShowNotification(CasinoConfigSH.Lang.DidntAwnsered)
                                TriggerServerEvent('sunwisecasinofoldCards', self.index)
                            end
                        end
                    end
                end
            )
        end

        RequestAnimDict(CasinoConfig.PlayerAnimDictPoker)
        while not HasAnimDictLoaded(CasinoConfig.PlayerAnimDictPoker) do
            Wait(1)
        end

        for targetSrc, data in pairs(self.ServerCards) do
            if targetSrc ~= 'dealer' then
                -- if we are the player, we call it once
                if GetPlayerServerId(PlayerId()) == targetSrc and self.index == activePokerTable then
                    local scene = NetworkCreateSynchronisedScene(data.chairData.chairCoords, data.chairData.chairRotation, 2, true, false, 1.0, 0.0, 1.0)
                    NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, CasinoConfig.PlayerAnimDictPoker, 'cards_pickup', 2.0, -2.0, 13, 16, 1000.0, 0)
                    NetworkStartSynchronisedScene(scene)
                    Citizen.CreateThread(
                        function()
                            Wait(1500)
                            watchingCards = true
                            ShakeGameplayCam('HAND_SHAKE', 0.15)
                            buttonScaleform = setupThirdButtons('instructional_buttons')

                            local playerHandValue = PokerGetHandAllValues(data.Hand)
                            if playerHandValue ~= nil then
                                local form = formatHandValue(playerHandValue)
                                if form ~= nil then
                                    Citizen.CreateThread(
                                        function()
                                            while watchingCards do
                                                Wait(0)

                                                drawText2d(0.5, 0.9, 0.45, form)
                                            end
                                        end
                                    )
                                end
                            end
                        end
                    )
                end

                local cardsScene = CreateSynchronizedScene(data.chairData.chairCoords, data.chairData.chairRotation, 2)

                PlaySynchronizedEntityAnim(self.cards[targetSrc][1], cardsScene, 'cards_pickup_card_a', CasinoConfig.PlayerAnimDictPoker, 1000.0, 0, 0, 1000.0)
                PlaySynchronizedEntityAnim(self.cards[targetSrc][2], cardsScene, 'cards_pickup_card_b', CasinoConfig.PlayerAnimDictPoker, 1000.0, 0, 0, 1000.0)
                PlaySynchronizedEntityAnim(self.cards[targetSrc][3], cardsScene, 'cards_pickup_card_c', CasinoConfig.PlayerAnimDictPoker, 1000.0, 0, 0, 1000.0)
            end
        end
    end

    self.foldCards = function(mainSrc)
        self.playersFolded[mainSrc] = true

        if GetPlayerServerId(PlayerId()) == mainSrc then
            local scene = NetworkCreateSynchronisedScene(activeChairData.chairCoords, activeChairData.chairRotation, 2, true, false, 1.0, 0.0, 1.0)
            NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, CasinoConfig.PlayerAnimDictPoker, 'cards_fold', 2.0, -2.0, 13, 16, 1000.0, 0)
            NetworkStartSynchronisedScene(scene)
            playerDecidedChoice = true
            watchingCards = false
            buttonScaleform = nil
            StopGameplayCamShaking(true)
        end

        if self.cards[mainSrc] ~= nil then
            local chairData = self.ServerCards[mainSrc].chairData
            local cardsScene = CreateSynchronizedScene(chairData.chairCoords, chairData.chairRotation, 2)
            PlaySynchronizedEntityAnim(self.cards[mainSrc][1], cardsScene, 'cards_fold_card_a', CasinoConfig.PlayerAnimDictPoker, 1000.0, 0, 0, 1000.0)
            PlaySynchronizedEntityAnim(self.cards[mainSrc][2], cardsScene, 'cards_fold_card_b', CasinoConfig.PlayerAnimDictPoker, 1000.0, 0, 0, 1000.0)
            PlaySynchronizedEntityAnim(self.cards[mainSrc][3], cardsScene, 'cards_fold_card_c', CasinoConfig.PlayerAnimDictPoker, 1000.0, 0, 0, 1000.0)
        end
    end

    self.playCards = function(mainSrc)
        if GetPlayerServerId(PlayerId()) == mainSrc then
            playerDecidedChoice = true
            watchingCards = false
            buttonScaleform = nil
            StopGameplayCamShaking(true)

            Citizen.CreateThread(
                function()
                    local scene = NetworkCreateSynchronisedScene(activeChairData.chairCoords, activeChairData.chairRotation, 2, true, false, 1.0, 0.0, 1.0)
                    NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, CasinoConfig.PlayerAnimDictPoker, 'cards_play', 2.0, -2.0, 13, 16, 1000.0, 0)
                    NetworkStartSynchronisedScene(scene)

                    while not HasAnimEventFired(PlayerPedId(), -1424880317) do
                        Wait(1)
                    end

                    local nextScene = NetworkCreateSynchronisedScene(activeChairData.chairCoords, activeChairData.chairRotation, 2, true, false, 1.0, 0.0, 1.0)
                    NetworkAddPedToSynchronisedScene(PlayerPedId(), nextScene, CasinoConfig.PlayerAnimDictPoker, 'cards_bet', 2.0, -2.0, 13, 16, 1000.0, 0)
                    NetworkStartSynchronisedScene(nextScene)

                    Wait(500)

                    local offsetAlign = nil
                    if activeChairData.chairId == 4 then
                        offsetAlign = vector3(0.689125, 0.171575, 0.954)
                    elseif activeChairData.chairId == 3 then
                        offsetAlign = vector3(0.2869, -0.211925, 0.954)
                    elseif activeChairData.chairId == 2 then
                        offsetAlign = vector3(-0.30935, -0.205675, 0.954)
                    elseif activeChairData.chairId == 1 then
                        offsetAlign = vector3(-0.69795, 0.211525, 0.954)
                    end

                    if offsetAlign == nil then
                        return
                    end

                    local offset = GetObjectOffsetFromCoords(self.data.Position, self.data.Heading, offsetAlign)
                    local chipModel = getChipModelByAmount(playerBetted)
                    RequestModel(chipModel)
                    while not HasModelLoaded(chipModel) do
                        Wait(1)
                    end

                    local chipObj = CreateObjectNoOffset(chipModel, offset, true, false, true)
                    SetEntityCoordsNoOffset(chipObj, offset, false, false, true)
                    SetEntityHeading(chipObj, GetEntityHeading(PlayerPedId()))
                    table.insert(networkedChips, chipObj)

                    while not HasAnimEventFired(PlayerPedId(), -1424880317) do
                        Wait(1)
                    end

                    self.playerRandomIdleAnim()
                end
            )
        end

        if self.cards[mainSrc] ~= nil and self.ServerCards[mainSrc] ~= nil then
            local chairData = self.ServerCards[mainSrc].chairData
            local cardsScene = CreateSynchronizedScene(chairData.chairCoords, chairData.chairRotation, 2)
            PlaySynchronizedEntityAnim(self.cards[mainSrc][1], cardsScene, 'cards_play_card_a', CasinoConfig.PlayerAnimDictPoker, 1000.0, 0, 0, 1000.0)
            PlaySynchronizedEntityAnim(self.cards[mainSrc][2], cardsScene, 'cards_play_card_b', CasinoConfig.PlayerAnimDictPoker, 1000.0, 0, 0, 1000.0)
            PlaySynchronizedEntityAnim(self.cards[mainSrc][3], cardsScene, 'cards_play_card_c', CasinoConfig.PlayerAnimDictPoker, 1000.0, 0, 0, 1000.0)
        end
    end

    self.playerRandomIdleAnim = function()
        local selectedIdleAnim = nil

        if not IsPedMale(PlayerPedId()) then -- female
            local fmlIdles = {
                'female_idle_cardgames_var_01',
                'female_idle_cardgames_var_02',
                'female_idle_cardgames_var_03',
                'female_idle_cardgames_var_04',
                'female_idle_cardgames_var_05',
                'female_idle_cardgames_var_06',
                'female_idle_cardgames_var_07',
                'female_idle_cardgames_var_08'
            }
            selectedIdleAnim = fmlIdles[math.random(1, 8)]
        else -- male or UFO
            local mlIdles = {
                'idle_cardgames_var_01',
                'idle_cardgames_var_02',
                'idle_cardgames_var_03',
                'idle_cardgames_var_04',
                'idle_cardgames_var_05',
                'idle_cardgames_var_06',
                'idle_cardgames_var_07',
                'idle_cardgames_var_08',
                'idle_cardgames_var_09',
                'idle_cardgames_var_10',
                'idle_cardgames_var_11',
                'idle_cardgames_var_12',
                'idle_cardgames_var_13'
            }
            selectedIdleAnim = mlIdles[math.random(1, 13)]
        end

        if selectedIdleAnim ~= nil then
            local playerIdleScene = NetworkCreateSynchronisedScene(activeChairData.chairCoords, activeChairData.chairRotation, 2, true, false, 1.0, 0.0, 1.0)
            NetworkAddPedToSynchronisedScene(PlayerPedId(), playerIdleScene, CasinoConfig.PlayerAnimDictShared, selectedIdleAnim, 2.0, -2.0, 13, 16, 1000.0, 0)
            NetworkStartSynchronisedScene(playerIdleScene)

            while not HasAnimEventFired(PlayerPedId(), -1424880317) do
                Wait(1)
            end

            local playerIdleScene2 = NetworkCreateSynchronisedScene(activeChairData.chairCoords, activeChairData.chairRotation, 2, true, false, 1.0, 0.0, 1.0)
            NetworkAddPedToSynchronisedScene(PlayerPedId(), playerIdleScene2, CasinoConfig.PlayerAnimDictShared, 'idle_cardgames', 2.0, -2.0, 13, 16, 1000.0, 0)
            NetworkStartSynchronisedScene(playerIdleScene2)
        end
    end

    self.dealToSelf = function()
        local dealSelfScene = CreateSynchronizedScene(self.data.Position, 0.0, 0.0, self.data.Heading, 2)
        if self.isPedFemale() then
            TaskSynchronizedScene(self.ped, dealSelfScene, CasinoConfig.DealerAnimDictPoker, 'female_deck_deal_self', 2.0, -2.0, 13, 16, 1000.0, 0)
        else
            TaskSynchronizedScene(self.ped, dealSelfScene, CasinoConfig.DealerAnimDictPoker, 'deck_deal_self', 2.0, -2.0, 13, 16, 1000.0, 0)
        end
        PlaySynchronizedEntityAnim(self.cards['dealer'][1], dealSelfScene, 'deck_deal_self_card_a', CasinoConfig.DealerAnimDictPoker, 1000.0, 0, 0, 1000.0)
        PlaySynchronizedEntityAnim(self.cards['dealer'][2], dealSelfScene, 'deck_deal_self_card_b', CasinoConfig.DealerAnimDictPoker, 1000.0, 0, 0, 1000.0)
        PlaySynchronizedEntityAnim(self.cards['dealer'][3], dealSelfScene, 'deck_deal_self_card_c', CasinoConfig.DealerAnimDictPoker, 1000.0, 0, 0, 1000.0)

        while GetSynchronizedScenePhase(dealSelfScene) < 0.05 do
            Wait(1)
        end

        SetEntityVisible(self.cards['dealer'][1], true, false)
        SetEntityVisible(self.cards['dealer'][2], true, false)
        SetEntityVisible(self.cards['dealer'][3], true, false)

        while GetSynchronizedScenePhase(dealSelfScene) < 0.99 do
            Wait(1)
        end
    end

    self.dealerStandingIdle = function()
        local scene = CreateSynchronizedScene(self.data.Position, 0.0, 0.0, self.data.Heading, 2)
        if self.isPedFemale() then
            TaskSynchronizedScene(self.ped, scene, CasinoConfig.DealerAnimDictShared, 'female_idle', 1000.0, -2.0, -1.0, 33, 1000.0, 0)
        else
            TaskSynchronizedScene(self.ped, scene, CasinoConfig.DealerAnimDictShared, 'idle', 1000.0, -2.0, -1.0, 33, 1000.0, 0)
        end
    end

    self.putDownDeck = function()
        local scene = CreateSynchronizedScene(self.data.Position, 0.0, 0.0, self.data.Heading, 2)
        if self.isPedFemale() then
            TaskSynchronizedScene(self.ped, scene, CasinoConfig.DealerAnimDictPoker, 'female_deck_put_down', 2.0, -2.0, 13, 16, 1000.0, 0)
        else
            TaskSynchronizedScene(self.ped, scene, CasinoConfig.DealerAnimDictPoker, 'deck_put_down', 2.0, -2.0, 13, 16, 1000.0, 0)
        end
        while GetSynchronizedScenePhase(scene) < 0.99 do
            Wait(1)
        end

        if IsEntityAttachedToAnyPed(self.pakli) then
            DetachEntity(self.pakli, true, true)
            FreezeEntityPosition(self.pakli, true)
        end

        self.dealerStandingIdle()
    end

    self.EnableRender = function(state)
        if state then
            DisplayRadar(false)
            activePokerTable = self.index

            Citizen.CreateThread(
                function()
                    while activePokerTable do
                        Wait(0)
                        DisableAllControlActions(0)

                        if buttonScaleform ~= nil then
                            DrawScaleformMovieFullscreen(buttonScaleform, 255, 255, 255, 255, 0)
                        end

                        EnableControlAction(0, 0, true) -- changing camera
                        EnableControlAction(0, 1, true) -- mouse cam
                        EnableControlAction(0, 2, true) -- mouse cam

                        -- if player betted then
                        if playerBetted then
                            local reactiveText = ''

                            if currentHelpText then
                                reactiveText = reactiveText .. currentHelpText
                            end

                            if self.TimeLeft > 0 then
                                reactiveText = reactiveText .. CasinoConfigSH.Lang.WaitingForPlayers .. "\n"
                            end

                            if watchingCards then
                                if IsDisabledControlJustPressed(0, 38) then
                                    clientTimer = nil
                                    watchingCards = false
                                    buttonScaleform = nil
                                    StopGameplayCamShaking(true)
                                    TriggerServerEvent('sunwisecasinoplayCards', self.index, playerBetted)
                                end

                                if IsDisabledControlJustPressed(0, 177) then
                                    clientTimer = nil
                                    watchingCards = false
                                    buttonScaleform = nil
                                    StopGameplayCamShaking(true)
                                    TriggerServerEvent('sunwisecasinofoldCards', self.index)
                                end
                            end

                            if string.len(reactiveText) > 0 then
                                CasinoConfig.ShowHelpNotification(reactiveText)
                            end
                        end

                        -- only enable standup if he did not bet
                        if playerBetted == nil then
                            if IsDisabledControlJustPressed(0, 177) then
                                self.EnableRender(false)
                                PlaySoundFront(-1, 'FocusOut', 'HintCamSounds', false)
                            end
                        end

                        if playerBetted == nil or playerPairPlus == nil then
                            if self.TimeLeft == nil or self.TimeLeft > 0 then
                                -- bet input
                                if IsDisabledControlJustPressed(0, 22) then --Custom Bet [space]
                                    local tmpInput = getGenericTextInput(CasinoConfigSH.Lang.Bet)
                                    if tonumber(tmpInput) then
                                        tmpInput = tonumber(tmpInput)
                                        if tmpInput > 0 then
                                            if tmpInput > self.data.MaximumBet then
                                                PlaySoundFront(-1, 'DLC_VW_ERROR_MAX', 'dlc_vw_table_games_frontend_sounds', true)
                                            else
                                                currentBetInput = tmpInput
                                                PlaySoundFront(-1, 'DLC_VW_BET_HIGHLIGHT', 'dlc_vw_table_games_frontend_sounds', true)
                                            end
                                        end
                                    end
                                end

                                if IsDisabledControlJustPressed(0, 176) then
                                    if currentBetInput > 0 then
                                        if currentBetInput >= self.data.MinimumBet and currentBetInput <= self.data.MaximumBet then
                                            if playerBetted == nil then
                                                TriggerServerEvent('sunwisecasinobetPlayer', self.index, activeChairData, currentBetInput)
                                            else
                                                if playerPairPlus == nil then
                                                    TriggerServerEvent('sunwisecasinobetPairPlusPlayer', self.index, currentBetInput)
                                                end
                                            end
                                        else
                                            PlaySoundFront(-1, 'DLC_VW_ERROR_MAX', 'dlc_vw_table_games_frontend_sounds', true)
                                        end
                                    end
                                end

                                if IsDisabledControlJustPressed(0, 172) then -- up
                                    local increase = IncreaseAmounts(currentBetInput)
                                    currentBetInput = currentBetInput + increase
                                    if currentBetInput > self.data.MaximumBet then
                                        PlaySoundFront(-1, 'DLC_VW_ERROR_MAX', 'dlc_vw_table_games_frontend_sounds', true)
                                        currentBetInput = self.data.MaximumBet
                                    else
                                        PlaySoundFront(-1, 'DLC_VW_BET_UP', 'dlc_vw_table_games_frontend_sounds', true)
                                    end
                                elseif IsDisabledControlJustPressed(0, 173) then -- down
                                    if currentBetInput > 0 then
                                        local increase = IncreaseAmounts(currentBetInput)
                                        currentBetInput = currentBetInput - increase
                                        PlaySoundFront(-1, 'DLC_VW_BET_DOWN', 'dlc_vw_table_games_frontend_sounds', true)
                                        if currentBetInput < 0 then
                                            currentBetInput = 0
                                            PlaySoundFront(-1, 'DLC_VW_ERROR_MAX', 'dlc_vw_table_games_frontend_sounds', true)
                                        end
                                    else
                                        PlaySoundFront(-1, 'DLC_VW_ERROR_MAX', 'dlc_vw_table_games_frontend_sounds', true)
                                    end
                                end
                            end
                        end

                        if self.Active then
                            if self.TimeLeft >= 10 then
                                DrawRect(0.944, 0.799, 0.081, 0.032, 0, 0, 0, 200)
                                DrawAdvancedNativeText(1.013, 0.806, 0.005, 0.0028, 0.29, CasinoConfigSH.Lang.Time .. ": ", 255, 255, 255, 255, 0, 0)
                                DrawAdvancedNativeText(1.05, 0.799, 0.005, 0.0028, 0.464, string.format('00:%s', self.TimeLeft), 255, 255, 255, 255, 0, 0)
                            else
                                if self.TimeLeft > 0 then
                                    DrawAdvancedNativeText(1.013, 0.806, 0.005, 0.0028, 0.29, CasinoConfigSH.Lang.Time .. ": ", 255, 255, 255, 255, 0, 0)
                                    DrawRect(0.944, 0.799, 0.081, 0.032, 0, 0, 0, 200)
                                    DrawAdvancedNativeText(1.05, 0.799, 0.005, 0.0028, 0.464, string.format('00:0%s', self.TimeLeft), 255, 255, 255, 255, 0, 0)
                                else
                                    if clientTimer ~= nil then
                                        DrawAdvancedNativeText(1.013, 0.806, 0.005, 0.0028, 0.29, CasinoConfigSH.Lang.Time.. ": ", 255, 255, 255, 255, 0, 0)
                                        DrawRect(0.944, 0.799, 0.081, 0.032, 0, 0, 0, 200)
                                        if clientTimer >= 10 then
                                            DrawAdvancedNativeText(1.05, 0.799, 0.005, 0.0028, 0.464, string.format('00:%s', clientTimer), 255, 255, 255, 255, 0, 0)
                                        else
                                            DrawAdvancedNativeText(1.05, 0.799, 0.005, 0.0028, 0.464, string.format('00:0%s', clientTimer), 255, 255, 255, 255, 0, 0)
                                        end
                                    end
                                end
                            end
                        end

                        DrawRect(0.91, 0.842, 0.145, 0.032, 0, 0, 0, 200)
                        DrawAdvancedNativeText(0.965, 0.849, 0.005, 0.0028, 0.29, CasinoConfigSH.Lang.MinMax, 255, 255, 255, 255, 0, 0)
                        DrawAdvancedNativeText(1.035, 0.842, 0.005, 0.0028, 0.464, string.format('%s-%s', self.data.MinimumBet, self.data.MaximumBet), 255, 255, 255, 255, 0, 0)

                        DrawRect(0.91, 0.885, 0.145, 0.032, 0, 0, 0, 200)
                        DrawAdvancedNativeText(0.965, 0.892, 0.005, 0.0028, 0.29, CasinoConfigSH.Lang.Chips .. ": ", 255, 255, 255, 255, 0, 0)
                        DrawAdvancedNativeText(1.041, 0.885, 0.005, 0.0028, 0.464, string.format('%s', GroupDigits(PlayerOwnedChips)), 255, 255, 255, 255, 0, 0)

                        DrawRect(0.91, 0.928, 0.145, 0.032, 0, 0, 0, 200)
                        DrawAdvancedNativeText(0.965, 0.935, 0.005, 0.0028, 0.29, CasinoConfigSH.Lang.Bet .. ": ", 255, 255, 255, 255, 0, 0)
                        DrawAdvancedNativeText(1.041, 0.928, 0.005, 0.0028, 0.464, string.format('%s', GroupDigits(currentBetInput)), 255, 255, 255, 255, 0, 0)
                    end
                end
            )
        else
            self.speakPed('MINIGAME_DEALER_LEAVE_NEUTRAL_GAME')

            ShowPokerBulles()
            local sitExitScene = NetworkCreateSynchronisedScene(activeChairData.chairCoords, activeChairData.chairRotation, 2, true, false, 1.0, 0.0, 1.0)
            NetworkAddPedToSynchronisedScene(PlayerPedId(), sitExitScene, CasinoConfig.PlayerAnimDictShared, 'sit_exit_left', 2.0, -2.0, 13, 16, 2.0, 0)
            NetworkStartSynchronisedScene(sitExitScene)

            Wait(4000)
            if activeChairData then
                TriggerServerEvent('sunwisecasinostandUp', self.index, activeChairData.chairId)
            end

            NetworkStopSynchronisedScene(mainScene)
            NetworkStopSynchronisedScene(sitExitScene)
            DisplayRadar(true)

            -- only at the end reset the vars
            activePokerTable = nil
            activeChairData = nil
        end
    end

    self.revealSelfCards = function()
        Citizen.CreateThread(
            function()
                if self.index == activePokerTable then
                    local offset = GetObjectOffsetFromCoords(self.data.Position, self.data.Heading, 0.0, -0.04, 1.35)

                    mainCamera = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', offset, -78.0, 0.0, self.data.Heading, 80.0, true, 2)
                    SetCamActive(mainCamera, true)
                    RenderScriptCams(true, 900, 900, true, false)
                    ShakeCam(mainCamera, 'HAND_SHAKE', 0.25)

                    Wait(2500)

                    local dealerHandValue = PokerGetHandAllValues(self.ServerCards['dealer'].Hand)
                    if dealerHandValue ~= nil then
                        local form = formatHandValue(dealerHandValue)
                        if form ~= nil then
                            Citizen.CreateThread(
                                function()
                                    while DoesCamExist(mainCamera) do
                                        Wait(0)

                                        drawText2d(0.5, 0.9, 0.45, form)
                                    end
                                end
                            )
                        end
                    end

                    Wait(7500)

                    if DoesCamExist(mainCamera) then
                        DestroyCam(mainCamera, false)
                    end
                    RenderScriptCams(false, 900, 900, true, false)
                end
            end
        )
        if self.ServerCards['dealer'] ~= nil then
            local revealScene = CreateSynchronizedScene(self.data.Position, 0.0, 0.0, self.data.Heading, 2)
            if self.isPedFemale() then
                TaskSynchronizedScene(self.ped, revealScene, CasinoConfig.DealerAnimDictPoker, 'female_reveal_self', 2.0, -2.0, 13, 16, 1000.0, 0)
            else
                TaskSynchronizedScene(self.ped, revealScene, CasinoConfig.DealerAnimDictPoker, 'reveal_self', 2.0, -2.0, 13, 16, 1000.0, 0)
            end
            PlaySynchronizedEntityAnim(self.cards['dealer'][1], revealScene, 'reveal_self_card_a', CasinoConfig.DealerAnimDictPoker, 1000.0, 0, 0, 1000.0)
            PlaySynchronizedEntityAnim(self.cards['dealer'][2], revealScene, 'reveal_self_card_b', CasinoConfig.DealerAnimDictPoker, 1000.0, 0, 0, 1000.0)
            PlaySynchronizedEntityAnim(self.cards['dealer'][3], revealScene, 'reveal_self_card_c', CasinoConfig.DealerAnimDictPoker, 1000.0, 0, 0, 1000.0)
        end
    end

    self.revealPlayerCards = function()
        for targetSrc, data in pairs(self.ServerCards) do
            if targetSrc ~= 'dealer' then
                local playerAnimId = nil

                if data.chairData.chairId == 4 then -- this is reverse because rockstar think differently no idea why
                    playerAnimId = 'p01'
                elseif data.chairData.chairId == 3 then
                    playerAnimId = 'p02'
                elseif data.chairData.chairId == 2 then
                    playerAnimId = 'p03'
                elseif data.chairData.chairId == 1 then
                    playerAnimId = 'p04'
                end

                local mainAnimFormat = nil
                local entityAnimFormatA = nil
                local entityAnimFormatB = nil
                local entityAnimFormatC = nil

                if self.playersFolded[targetSrc] then -- if he or she folded the hand
                    if self.isPedFemale() then
                        mainAnimFormat = string.format('female_reveal_folded_%s', playerAnimId)
                    else
                        mainAnimFormat = string.format('reveal_folded_%s', playerAnimId)
                    end
                    entityAnimFormatA = string.format('reveal_folded_%s_card_a', playerAnimId)
                    entityAnimFormatB = string.format('reveal_folded_%s_card_b', playerAnimId)
                    entityAnimFormatC = string.format('reveal_folded_%s_card_c', playerAnimId)
                else
                    if self.isPedFemale() then
                        mainAnimFormat = string.format('female_reveal_played_%s', playerAnimId)
                    else
                        mainAnimFormat = string.format('reveal_played_%s', playerAnimId)
                    end
                    entityAnimFormatA = string.format('reveal_played_%s_card_a', playerAnimId)
                    entityAnimFormatB = string.format('reveal_played_%s_card_b', playerAnimId)
                    entityAnimFormatC = string.format('reveal_played_%s_card_c', playerAnimId)
                end

                if mainAnimFormat ~= nil then
                    if activePokerTable == self.index then -- only show camera if he/she is sitting at the table.
                        --if ConfigCasino.ShowCardsAfterReveal then
                            local offset =
                                GetAnimInitialOffsetPosition(CasinoConfig.PlayerAnimDictPoker, 'cards_play_card_b', data.chairData.chairCoords, data.chairData.chairRotation, 0.0, 2)

                            if DoesCamExist(mainCamera) then
                                DestroyCam(mainCamera, false)
                            end

                            mainCamera =
                                CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', offset + vector3(0.0, 0.0, 0.45), -85.0, 0.0, data.chairData.chairRotation.z - 90.0, 80.0, true, 2)
                            SetCamActive(mainCamera, true)
                            RenderScriptCams(true, 900, 900, true, false)
                            ShakeCam(mainCamera, 'HAND_SHAKE', 0.25)
                        --end
                    end

                    SetEntityVisible(self.cards[targetSrc][1], false, false)
                    SetEntityVisible(self.cards[targetSrc][2], false, false)
                    SetEntityVisible(self.cards[targetSrc][3], false, false)

                    local revealScene = CreateSynchronizedScene(self.data.Position, 0.0, 0.0, self.data.Heading, 2)
                    TaskSynchronizedScene(self.ped, revealScene, CasinoConfig.DealerAnimDictPoker, mainAnimFormat, 2.0, -2.0, 13, 16, 1000.0, 0)
                    PlaySynchronizedEntityAnim(self.cards[targetSrc][1], revealScene, entityAnimFormatA, CasinoConfig.DealerAnimDictPoker, 1000.0, 0, 0, 1000.0)
                    PlaySynchronizedEntityAnim(self.cards[targetSrc][2], revealScene, entityAnimFormatB, CasinoConfig.DealerAnimDictPoker, 1000.0, 0, 0, 1000.0)
                    PlaySynchronizedEntityAnim(self.cards[targetSrc][3], revealScene, entityAnimFormatC, CasinoConfig.DealerAnimDictPoker, 1000.0, 0, 0, 1000.0)

                    while GetSynchronizedScenePhase(revealScene) < 0.025 do
                        Wait(1)
                    end

                    SetEntityVisible(self.cards[targetSrc][1], true, false)
                    SetEntityVisible(self.cards[targetSrc][2], true, false)
                    SetEntityVisible(self.cards[targetSrc][3], true, false)

                    while GetSynchronizedScenePhase(revealScene) < 0.99 do
                        Wait(1)
                    end

                    local ggScene = CreateSynchronizedScene(self.data.Position, 0.0, 0.0, self.data.Heading, 2)
                    if self.isPedFemale() then
                        TaskSynchronizedScene(self.ped, ggScene, CasinoConfig.DealerAnimDictShared, string.format('female_acknowledge_%s', playerAnimId), 2.0, -2.0, 13, 16, 1000.0, 0)
                    else
                        TaskSynchronizedScene(self.ped, ggScene, CasinoConfig.DealerAnimDictShared, string.format('acknowledge_%s', playerAnimId), 2.0, -2.0, 13, 16, 1000.0, 0)
                    end
                end
            end
        end
    end

    self.resetTable = function()
        -- chips clearing
        if #networkedChips > 0 then
            for i = 1, #networkedChips, 1 do
                if NetworkGetEntityOwner(networkedChips[i]) == PlayerId() then
                    DeleteObject(networkedChips[i])
                end
            end
        end

        Wait(200) -- because i like timeouts -_-

        for k, v in pairs(self.cards) do
            for i = 1, #v, 1 do
                DeleteObject(v[i])
            end
        end

        Wait(200) -- because i like timeouts -_-

        self.cards = {}

        if self.index == activePokerTable then
            playerBetted = nil
            playerPairPlus = nil
            watchingCards = false
            StopGameplayCamShaking(true)
            playerDecidedChoice = false
            clientTimer = nil
            currentHelpText = nil
            networkedChips = {}
            currentBetInput = 0
            buttonScaleform = setupFirstButtons('instructional_buttons')
        end

        self.ServerCards = {}
        self.Active = false
        self.TimeLeft = nil
        self.playersPlaying = {}
        self.playersFolded = {}

        self.dealerStandingIdle()
    end

    self.clearTable = function()
        self.speakPed('MINIGAME_DEALER_ANOTHER_GO')

        -- deck picking up anim
        local firstScene = CreateSynchronizedScene(self.data.Position, 0.0, 0.0, self.data.Heading, 2)
        if self.isPedFemale() then
            TaskSynchronizedScene(self.ped, firstScene, CasinoConfig.DealerAnimDictPoker, 'female_deck_pick_up', 2.0, -2.0, 13, 16, 1000.0, 0)
        else
            TaskSynchronizedScene(self.ped, firstScene, CasinoConfig.DealerAnimDictPoker, 'deck_pick_up', 2.0, -2.0, 13, 16, 1000.0, 0)
        end
        while GetSynchronizedScenePhase(firstScene) < 0.99 do
            if HasAnimEventFired(self.ped, 1691374422) then
                if not IsEntityAttachedToAnyPed(self.pakli) then
                    FreezeEntityPosition(self.pakli, false)
                    AttachEntityToEntity(self.pakli, self.ped, GetPedBoneIndex(self.ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, true, 2, true)
                end
            end

            Wait(1)
        end

        -- collect player cards
        for targetSrc, data in pairs(self.ServerCards) do
            if targetSrc ~= 'dealer' then
                local playerAnimId = nil

                if data.chairData.chairId == 4 then -- this is reverse because rockstar think differently no idea why
                    playerAnimId = 'p01'
                elseif data.chairData.chairId == 3 then
                    playerAnimId = 'p02'
                elseif data.chairData.chairId == 2 then
                    playerAnimId = 'p03'
                elseif data.chairData.chairId == 1 then
                    playerAnimId = 'p04'
                end

                local collectScene = CreateSynchronizedScene(self.data.Position, 0.0, 0.0, self.data.Heading, 2)
                if self.isPedFemale() then
                    TaskSynchronizedScene(self.ped, collectScene, CasinoConfig.DealerAnimDictPoker, string.format('female_cards_collect_%s', playerAnimId), 2.0, -2.0, 13, 16, 1000.0, 0)
                else
                    TaskSynchronizedScene(self.ped, collectScene, CasinoConfig.DealerAnimDictPoker, string.format('cards_collect_%s', playerAnimId), 2.0, -2.0, 13, 16, 1000.0, 0)
                end
                PlaySynchronizedEntityAnim(
                    self.cards[targetSrc][1],
                    collectScene,
                    string.format('cards_collect_%s_card_a', playerAnimId),
                    CasinoConfig.DealerAnimDictPoker,
                    1000.0,
                    0,
                    0,
                    1000.0
                )
                PlaySynchronizedEntityAnim(
                    self.cards[targetSrc][2],
                    collectScene,
                    string.format('cards_collect_%s_card_b', playerAnimId),
                    CasinoConfig.DealerAnimDictPoker,
                    1000.0,
                    0,
                    0,
                    1000.0
                )
                PlaySynchronizedEntityAnim(
                    self.cards[targetSrc][3],
                    collectScene,
                    string.format('cards_collect_%s_card_c', playerAnimId),
                    CasinoConfig.DealerAnimDictPoker,
                    1000.0,
                    0,
                    0,
                    1000.0
                )
                while GetSynchronizedScenePhase(collectScene) < 0.99 do
                    Wait(1)
                end

                DeleteObject(self.cards[targetSrc][1])
                DeleteObject(self.cards[targetSrc][2])
                DeleteObject(self.cards[targetSrc][3])
            end
        end

        -- collect own dealer cards
        if self.ServerCards['dealer'] then
            local collectScene = CreateSynchronizedScene(self.data.Position, 0.0, 0.0, self.data.Heading, 2)
            if self.isPedFemale() then
                TaskSynchronizedScene(self.ped, collectScene, CasinoConfig.DealerAnimDictPoker, 'female_cards_collect_self', 2.0, -2.0, 13, 16, 1000.0, 0)
            else
                TaskSynchronizedScene(self.ped, collectScene, CasinoConfig.DealerAnimDictPoker, 'cards_collect_self', 2.0, -2.0, 13, 16, 1000.0, 0)
            end
            PlaySynchronizedEntityAnim(self.cards['dealer'][1], collectScene, 'cards_collect_self_card_a', CasinoConfig.DealerAnimDictPoker, 1000.0, 0, 0, 1000.0)
            PlaySynchronizedEntityAnim(self.cards['dealer'][2], collectScene, 'cards_collect_self_card_b', CasinoConfig.DealerAnimDictPoker, 1000.0, 0, 0, 1000.0)
            PlaySynchronizedEntityAnim(self.cards['dealer'][3], collectScene, 'cards_collect_self_card_c', CasinoConfig.DealerAnimDictPoker, 1000.0, 0, 0, 1000.0)
            SetBit(0)
            while GetSynchronizedScenePhase(collectScene) < 0.99 do
                Wait(1)
            end

            DeleteObject(self.cards['dealer'][1])
            DeleteObject(self.cards['dealer'][2])
            DeleteObject(self.cards['dealer'][3])
        end

        self.putDownDeck()
    end

    self.playerPairPlusAnim = function(amount)
        playerPairPlus = amount
        buttonScaleform = nil

        RequestAnimDict(CasinoConfig.PlayerAnimDictPoker)
        while not HasAnimDictLoaded(CasinoConfig.PlayerAnimDictPoker) do
            Wait(1)
        end

        local offsetAlign = nil
        if activeChairData.chairId == 4 then
            offsetAlign = vector3(0.51655, 0.2268, 0.95)
        elseif activeChairData.chairId == 3 then
            offsetAlign = vector3(0.2163, -0.04745, 0.95)
        elseif activeChairData.chairId == 2 then
            offsetAlign = vector3(-0.2552, -0.031225, 0.95)
        elseif activeChairData.chairId == 1 then
            offsetAlign = vector3(-0.529875, 0.281425, 0.95)
        end

        if offsetAlign == nil then
            return
        end

        local animName = 'bet_plus'
        if amount >= 10000 then
            animName = 'bet_plus_large'
        end

        local scene = NetworkCreateSynchronisedScene(activeChairData.chairCoords, activeChairData.chairRotation, 2, true, false, 1.0, 0.0, 1.0)
        NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, CasinoConfig.PlayerAnimDictPoker, animName, 2.0, -2.0, 13, 16, 1000.0, 0)
        NetworkStartSynchronisedScene(scene)

        while not HasAnimEventFired(PlayerPedId(), -1424880317) do
            Wait(1)
        end

        local offset = GetObjectOffsetFromCoords(self.data.Position, self.data.Heading, offsetAlign)
        local chipModel = getChipModelByAmount(amount)
        RequestModel(chipModel)
        while not HasModelLoaded(chipModel) do
            Wait(1)
        end

        local chipObj = CreateObjectNoOffset(chipModel, offset, true, false, true)
        SetEntityCoordsNoOffset(chipObj, offset, false, false, true)
        SetEntityHeading(chipObj, GetEntityHeading(PlayerPedId()))
        table.insert(networkedChips, chipObj)

        self.playerRandomIdleAnim()
    end

    self.playerBetAnim = function(amount)
        playerBetted = amount
        buttonScaleform = setupSecondButtons('instructional_buttons')

        RequestAnimDict(CasinoConfig.PlayerAnimDictPoker)
        while not HasAnimDictLoaded(CasinoConfig.PlayerAnimDictPoker) do
            Wait(1)
        end

        local offsetAlign = nil
        if activeChairData.chairId == 4 then
            offsetAlign = vector3(0.59535, 0.200875, 0.95)
        elseif activeChairData.chairId == 3 then
            offsetAlign = vector3(0.247825, -0.123625, 0.95)
        elseif activeChairData.chairId == 2 then
            offsetAlign = vector3(-0.2804, -0.109775, 0.95)
        elseif activeChairData.chairId == 1 then
            offsetAlign = vector3(-0.606975, 0.249675, 0.95)
        end

        if offsetAlign == nil then
            return
        end

        local animName = 'bet_ante'
        if amount >= 10000 then
            animName = 'bet_ante_large'
        end

        local scene = NetworkCreateSynchronisedScene(activeChairData.chairCoords, activeChairData.chairRotation, 2, false, true, 1.0, 0.0, 1.0)
        NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, CasinoConfig.PlayerAnimDictPoker, animName, 2.0, -2.0, 13, 16, 1000.0, 0)
        NetworkStartSynchronisedScene(scene)

        while not HasAnimEventFired(PlayerPedId(), -1424880317) do
            Wait(1)
        end

        local offset = GetObjectOffsetFromCoords(self.data.Position, self.data.Heading, offsetAlign)
        local chipModel = getChipModelByAmount(amount)
        RequestModel(chipModel)
        while not HasModelLoaded(chipModel) do
            Wait(1)
        end

        local chipObj = CreateObjectNoOffset(chipModel, offset, true, false, true)
        SetEntityCoordsNoOffset(chipObj, offset, false, false, true)
        SetEntityHeading(chipObj, GetEntityHeading(PlayerPedId()))
        table.insert(networkedChips, chipObj)

        self.playerRandomIdleAnim()
    end

    self.createDefaultPakli()
    self.createPed()

    SharedPokers[index] = self
end

local createdTable = false
local function funcCreatePokerTables()
    if not createdTable then 
        createdTable = true
        RequestAnimDict(CasinoConfig.DealerAnimDictShared)
        RequestAnimDict(CasinoConfig.DealerAnimDictPoker)
        RequestAnimDict(CasinoConfig.PlayerAnimDictShared)
        RequestAnimDict(CasinoConfig.PlayerAnimDictPoker)
    
        -- creating the poker tables
        for index, data in pairs(CasinoConfig.Pokers) do
            PokerThread(index, data)
        end
    end
end

CreateThread(function()
    while true do
        local playerpos = GetEntityCoords(PlayerPedId())
        closeToPokers = false
        for k, v in pairs(CasinoConfig.Pokers) do
            if #(playerpos - v.Position) < 100.0 then
                closeToPokers = true
                funcCreatePokerTables()
            end
        end
        Wait(1000)
    end
end)

CreateThread(function()
    while true do
        local letSleep = true

        if not InformationPlaying and activePokerTable == nil and activeChairData == nil then
            if closeToPokers then
                local playerpos = GetEntityCoords(PlayerPedId())

                local close = false

                for k, v in pairs(SharedPokers) do
                    local dist = #(playerpos - v.data.Position)
                    if dist < 3.0 then
                        for i = 1, #CasinoConfig.TreeCardTables, 1 do
                            local tableObj = GetClosestObjectOfType(playerpos, 3.0, GetHashKey(CasinoConfig.TreeCardTables[i]), false)

                            if DoesEntityExist(tableObj) then
                                letSleep = false

                                for chairBone, chairId in pairs(CasinoConfig.ChairsId) do
                                    local chaircoords = GetWorldPositionOfEntityBone(tableObj, GetEntityBoneIndexByName(tableObj, chairBone))
                                    if chaircoords then
                                        if #(playerpos - chaircoords) < 1.5 then
                                            local chairrotation = GetWorldRotationOfEntityBone(tableObj, GetEntityBoneIndexByName(tableObj, chairBone))
                                            drawfreameeMarker(chaircoords + vector3(0.0, 0.0, 1.0))
                                            close = true

                                            if not playedHudSound then
                                                PlaySoundFront(-1, 'DLC_VW_RULES', 'dlc_vw_table_games_frontend_sounds', 1)
                                                playedHudSound = true
                                            end

                                            CasinoConfig.ShowHelpNotification(CasinoConfigSH.Lang.PlayThreeCard)

                                            if IsControlJustPressed(0, 38) then 
                                                v.sitDown(chairId, chaircoords, chairrotation)
                                            end
                                            if IsControlJustPressed(0, 47) then 
                                                showRulesThreeCard()
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        if letSleep then
            Wait(1000)
        end

        if not closeToPokers then
            Wait(2000)
        end

        Wait(1)
    end
end)

-- OTHERS

function frm_setPedVoiceGroup(randomNumber, dealerPed)
    if randomNumber == 0 then
        SetPedVoiceGroup(dealerPed, GetHashKey('S_M_Y_Casino_01_WHITE_01'))
    elseif randomNumber == 1 then
        SetPedVoiceGroup(dealerPed, GetHashKey('S_M_Y_Casino_01_ASIAN_01'))
    elseif randomNumber == 2 then
        SetPedVoiceGroup(dealerPed, GetHashKey('S_M_Y_Casino_01_ASIAN_02'))
    elseif randomNumber == 3 then
        SetPedVoiceGroup(dealerPed, GetHashKey('S_M_Y_Casino_01_ASIAN_01'))
    elseif randomNumber == 4 then
        SetPedVoiceGroup(dealerPed, GetHashKey('S_M_Y_Casino_01_WHITE_01'))
    elseif randomNumber == 5 then
        SetPedVoiceGroup(dealerPed, GetHashKey('S_M_Y_Casino_01_WHITE_02'))
    elseif randomNumber == 6 then
        SetPedVoiceGroup(dealerPed, GetHashKey('S_M_Y_Casino_01_WHITE_01'))
    elseif randomNumber == 7 then
        SetPedVoiceGroup(dealerPed, GetHashKey('S_F_Y_Casino_01_ASIAN_01'))
    elseif randomNumber == 8 then
        SetPedVoiceGroup(dealerPed, GetHashKey('S_F_Y_Casino_01_ASIAN_02'))
    elseif randomNumber == 9 then
        SetPedVoiceGroup(dealerPed, GetHashKey('S_F_Y_Casino_01_ASIAN_01'))
    elseif randomNumber == 10 then
        SetPedVoiceGroup(dealerPed, GetHashKey('S_F_Y_Casino_01_ASIAN_02'))
    elseif randomNumber == 11 then
        SetPedVoiceGroup(dealerPed, GetHashKey('S_F_Y_Casino_01_LATINA_01'))
    elseif randomNumber == 12 then
        SetPedVoiceGroup(dealerPed, GetHashKey('S_F_Y_Casino_01_LATINA_02'))
    elseif randomNumber == 13 then
        SetPedVoiceGroup(dealerPed, GetHashKey('S_F_Y_Casino_01_LATINA_01'))
    end
end

function frm_setPedClothes(randomNumber, dealerPed)
    if randomNumber == 0 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 1, 0, 0)
    elseif randomNumber == 1 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 2, 2, 0)
        SetPedComponentVariation(dealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 4, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 0, 3, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 1, 0, 0)
    elseif randomNumber == 2 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 2, 1, 0)
        SetPedComponentVariation(dealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 0, 3, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 1, 0, 0)
    elseif randomNumber == 3 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 1, 3, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 1, 0, 0)
    elseif randomNumber == 4 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 4, 2, 0)
        SetPedComponentVariation(dealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 1, 0, 0)
    elseif randomNumber == 5 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 4, 0, 0)
        SetPedComponentVariation(dealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 1, 0, 0)
    elseif randomNumber == 6 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 4, 1, 0)
        SetPedComponentVariation(dealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 4, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 1, 0, 0)
    elseif randomNumber == 7 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 1, 1, 0)
        SetPedComponentVariation(dealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 0, 3, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 0, 0, 0)
    elseif randomNumber == 8 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 1, 1, 0)
        SetPedComponentVariation(dealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 1, 1, 0)
        SetPedComponentVariation(dealerPed, 3, 1, 3, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 0, 0, 0)
    elseif randomNumber == 9 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 2, 3, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 0, 0, 0)
    elseif randomNumber == 10 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 2, 1, 0)
        SetPedComponentVariation(dealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 2, 1, 0)
        SetPedComponentVariation(dealerPed, 3, 3, 3, 0)
        SetPedComponentVariation(dealerPed, 4, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 0, 0, 0)
    elseif randomNumber == 11 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 0, 1, 0)
        SetPedComponentVariation(dealerPed, 4, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 0, 0, 0)
        SetPedPropIndex(dealerPed, 1, 0, 0, false)
    elseif randomNumber == 12 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 3, 1, 0)
        SetPedComponentVariation(dealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 3, 1, 0)
        SetPedComponentVariation(dealerPed, 3, 1, 1, 0)
        SetPedComponentVariation(dealerPed, 4, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 0, 0, 0)
    elseif randomNumber == 13 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 4, 0, 0)
        SetPedComponentVariation(dealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 4, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 2, 1, 0)
        SetPedComponentVariation(dealerPed, 4, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 0, 0, 0)
        SetPedPropIndex(dealerPed, 1, 0, 0, false)
    end
end

function DrawAdvancedNativeText(x, y, w, h, sc, text, r, g, b, a, font, jus)
    SetTextFont(font)
    SetTextScale(sc, sc)
    N_0x4e096588b13ffeca(jus)
    SetTextColour(254, 254, 254, 255)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x - 0.1 + w, y - 0.02 + h)
end

function getGenericTextInput(type)
    if type == nil then
        type = ''
    end
    AddTextEntry('FMMC_MPM_NA', tostring(type))
    DisplayOnscreenKeyboard(1, 'FMMC_MPM_NA', tostring(type), '', '', '', '', 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        if result then
            return result
        end
    end
    return false
end

function getChipModelByAmount(amount)
    if amount <= 10 then
        return GetHashKey('vw_prop_chip_10dollar_x1')
    elseif amount > 10 and amount < 50 then
        return GetHashKey('vw_prop_chip_10dollar_st')
    elseif amount >= 50 and amount < 100 then
        return GetHashKey('vw_prop_chip_50dollar_x1')
    elseif amount >= 100 and amount < 200 then
        return GetHashKey('vw_prop_chip_100dollar_x1')
    elseif amount >= 200 and amount < 500 then
        return GetHashKey('vw_prop_chip_100dollar_st')
    elseif amount == 500 then
        return GetHashKey('vw_prop_chip_500dollar_x1')
    elseif amount > 500 and amount < 1000 then
        return GetHashKey('vw_prop_chip_500dollar_st')
    elseif amount == 1000 then
        return GetHashKey('vw_prop_chip_1kdollar_x1')
    elseif amount > 1000 and amount < 5000 then
        return GetHashKey('vw_prop_chip_1kdollar_st')
    elseif amount == 5000 then
        return GetHashKey('vw_prop_plaq_5kdollar_x1')
    elseif amount > 5000 and amount < 10000 then
        return GetHashKey('vw_prop_plaq_5kdollar_st')
    elseif amount == 10000 then
        return GetHashKey('vw_prop_plaq_10kdollar_x1')
    elseif amount > 10000 then
        return GetHashKey('vw_prop_plaq_10kdollar_st')
    end
end

function ButtonMessage(text)
    BeginTextCommandScaleformString('STRING')
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

function setupSecondButtons(scaleform)
    -- to have the 'hint' sound effect
    PlaySoundFront(-1, 'FocusIn', 'HintCamSounds', true)
    ---
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end
    PushScaleformMovieFunction(scaleform, 'CLEAR_ALL')
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_CLEAR_SPACE')
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_DATA_SLOT')
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(0, 177, true)) -- The button to display
    ButtonMessage(CasinoConfigSH.Lang.LeaveTable)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_DATA_SLOT')
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(0, 172, true))
    ButtonMessage(CasinoConfigSH.Lang.UpBet)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_DATA_SLOT')
    PushScaleformMovieFunctionParameterInt(3)
    Button(GetControlInstructionalButton(0, 173, true))
    ButtonMessage(CasinoConfigSH.Lang.LowerBet)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_DATA_SLOT')
    PushScaleformMovieFunctionParameterInt(4)
    Button(GetControlInstructionalButton(0, 22, true))
    ButtonMessage(CasinoConfigSH.Lang.PersoBet)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_DATA_SLOT')
    PushScaleformMovieFunctionParameterInt(5)
    Button(GetControlInstructionalButton(0, 176, true))
    ButtonMessage(CasinoConfigSH.Lang.PlacePairPlus)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'DRAW_INSTRUCTIONAL_BUTTONS')
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_BACKGROUND_COLOUR')
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function setupThirdButtons(scaleform)
    -- to have the 'hint' sound effect
    PlaySoundFront(-1, 'FocusIn', 'HintCamSounds', true)
    ---

    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end
    PushScaleformMovieFunction(scaleform, 'CLEAR_ALL')
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_CLEAR_SPACE')
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_DATA_SLOT')
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(0, 177, true)) -- The button to display
    ButtonMessage(CasinoConfigSH.Lang.Fold)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_DATA_SLOT')
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(0, 38, true))
    ButtonMessage(CasinoConfigSH.Lang.Play)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'DRAW_INSTRUCTIONAL_BUTTONS')
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_BACKGROUND_COLOUR')
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function setupFirstButtons(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end
    PushScaleformMovieFunction(scaleform, 'CLEAR_ALL')
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_CLEAR_SPACE')
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_DATA_SLOT')
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(0, 177, true)) -- The button to display
    ButtonMessage(CasinoConfigSH.Lang.LeaveTable)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_DATA_SLOT')
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(0, 172, true))
    ButtonMessage(CasinoConfigSH.Lang.UpBet)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_DATA_SLOT')
    PushScaleformMovieFunctionParameterInt(3)
    Button(GetControlInstructionalButton(0, 173, true))
    ButtonMessage(CasinoConfigSH.Lang.LowerBet)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_DATA_SLOT')
    PushScaleformMovieFunctionParameterInt(4)
    Button(GetControlInstructionalButton(0, 22, true))
    ButtonMessage(CasinoConfigSH.Lang.PersoBet)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_DATA_SLOT')
    PushScaleformMovieFunctionParameterInt(5)
    Button(GetControlInstructionalButton(0, 176, true))
    ButtonMessage(CasinoConfigSH.Lang.PlacePairPlus)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'DRAW_INSTRUCTIONAL_BUTTONS')
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_BACKGROUND_COLOUR')
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function drawText2d(x, y, sc, text)
    SetTextFont(0)
    SetTextScale(sc, sc)
    SetTextCentre(true)
    SetTextOutline()
    SetTextColour(254, 254, 254, 255)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x, y)
end

function drawfreameeMarker(position)
    DrawMarker(20, position, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 255, true, true, 2, true, nil, nil, false)
end

function showRulesThreeCard()
    Citizen.CreateThread(
        function()
            local helps = {"TCP_RULE_1", "TCP_RULE_2", "TCP_RULE_3", "TCP_RULE_4", "TCP_RULE_5"}
            local helpsHeader = {"TCP_RULE_1T", "TCP_RULE_2T", "TCP_RULE_3T", "TCP_RULE_4T", "TCP_RULE_5T"}

            InformationPlaying = true

            for i = 1, #helps, 1 do
                PlaySoundFront(-1, 'DLC_VW_CONTINUE', 'dlc_vw_table_games_frontend_sounds', true)
                BeginTextCommandDisplayHelp(helpsHeader[i])
                AddTextComponentSubstringTextLabel(helps[i])
                EndTextCommandDisplayHelp(0, false, false, 5000)

                Wait(5000)
                if helps[i + 1] == nil then
                    InformationPlaying = false
                end
            end
        end
    )
end
