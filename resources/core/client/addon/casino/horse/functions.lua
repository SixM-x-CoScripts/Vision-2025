Horse = {
    Scaleform = -1,
    ChooseHorseVisible = false,
    BetVisible = false,
    PlayerBalance = 500,
    CurrentHorse = -1,
    CurrentBet = 100,
    CurrentGain = 1000,
    HorsesPositions = {},
    CurrentWiner = -1,
    CurrentSoundId = -1,
    InsideTrackActive = false,
    BigScreen = {
        enable = CasinoConfig.ShowBigScreen, -- Set it to false if you don't need the big screen
        coords = CasinoConfig.BigScreenCoord
    }
}

function Horse:ShowBetScreen(horse)
    self:UpdateBetValues(horse, self.CurrentBet, self.PlayerBalance, self.CurrentGain)

    BeginScaleformMovieMethod(self.Scaleform, 'SHOW_SCREEN')
    ScaleformMovieMethodAddParamInt(3)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(self.Scaleform, 'SET_BETTING_ENABLED')
    ScaleformMovieMethodAddParamBool(true)
    EndScaleformMovieMethod()

    self.BetVisible = true
end

function Horse:UpdateBetValues(horse, bet, balance, gain)
    BeginScaleformMovieMethod(self.Scaleform, 'SET_BETTING_VALUES')
    ScaleformMovieMethodAddParamInt(horse) -- Cheval index

    ScaleformMovieMethodAddParamInt(bet) -- Bet
    ScaleformMovieMethodAddParamInt(balance) -- Current balance
    ScaleformMovieMethodAddParamInt(gain) -- Gain
    EndScaleformMovieMethod()
end

function Horse:ShowHorseSelection()
    self.ChooseHorseVisible = true

    BeginScaleformMovieMethod(self.Scaleform, 'SHOW_SCREEN')
    ScaleformMovieMethodAddParamInt(1)
    EndScaleformMovieMethod()
end

function Horse.AddHorses(scaleform)
    for i = 1, 6 do
        local name = Horse.GetRandomHorseName()

        BeginScaleformMovieMethod(scaleform, 'SET_HORSE')
        ScaleformMovieMethodAddParamInt(i) -- Cheval index

        -- Cheval name
        BeginTextCommandScaleformString(name)
        EndTextCommandScaleformString()

        ScaleformMovieMethodAddParamPlayerNameString(i)

        -- Cheval style (TODO: Random preset)
        ScaleformMovieMethodAddParamInt(Horse.HorseStyles[i][1])
        ScaleformMovieMethodAddParamInt(Horse.HorseStyles[i][2])
        ScaleformMovieMethodAddParamInt(Horse.HorseStyles[i][3])
        ScaleformMovieMethodAddParamInt(Horse.HorseStyles[i][4])
        EndScaleformMovieMethod()
    end
end

-- int param :
-- 0 = main
-- 1 = choose a horse
-- 2 = choose a horse (2)
-- 3 = select a bet
-- 4 = select a bet (2)
-- 5 = race screen (frozen)
-- 6 = photo finish (frozen)
-- 7 = results
-- 8 = same as main but a bit different
-- 9 = rules
function Horse:ShowMainScreen()
    BeginScaleformMovieMethod(self.Scaleform, 'SHOW_SCREEN')
    ScaleformMovieMethodAddParamInt(0)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(Horse.Scaleform, 'SET_MAIN_EVENT_IN_PROGRESS')
    ScaleformMovieMethodAddParamBool(true)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(Horse.Scaleform, 'CLEAR_ALL')
    EndScaleformMovieMethod()
end

---@param cooldown integer
---(in seconds).
function Horse:SetMainScreenCooldown(cooldown)
    BeginScaleformMovieMethod(self.Scaleform, 'SET_COUNTDOWN')
    ScaleformMovieMethodAddParamInt(cooldown)
    EndScaleformMovieMethod()
end

function Horse:SetNotAvailable()
    BeginScaleformMovieMethod(self.Scaleform, 'SHOW_ERROR')

    BeginTextCommandScaleformString('IT_ERROR_TITLE')
    EndTextCommandScaleformString()

    BeginTextCommandScaleformString('IT_ERROR_MSG')
    EndTextCommandScaleformString()

    EndScaleformMovieMethod()
end

local function IsPositionAvailable(position)
    for i = 1, #Horse.HorsesPositions do
        if (Horse.HorsesPositions[i] == position) then
            return false
        end
    end

    return true
end

local function GenerateHorsesOrder()
    math.randomseed(GetGameTimer())
    while (#Horse.HorsesPositions < 6) do
        Wait(0)

        for i = 1, 6 do
            math.randomseed(GetGameTimer())
            local randomPos = math.random(1,6)

            if IsPositionAvailable(randomPos) then
                table.insert(Horse.HorsesPositions, randomPos)
            end
        end
    end
end

function Horse:StartRace()
    GenerateHorsesOrder()

    self.CurrentWinner = self.HorsesPositions[1]

    BeginScaleformMovieMethod(self.Scaleform, 'START_RACE')
    ScaleformMovieMethodAddParamFloat(15000.0) -- Race duration (in MS)
    ScaleformMovieMethodAddParamInt(4)

    -- Add each horses by their index (win order)
    ScaleformMovieMethodAddParamInt(self.HorsesPositions[1])
    ScaleformMovieMethodAddParamInt(self.HorsesPositions[2])
    ScaleformMovieMethodAddParamInt(self.HorsesPositions[3])
    ScaleformMovieMethodAddParamInt(self.HorsesPositions[4])
    ScaleformMovieMethodAddParamInt(self.HorsesPositions[5])
    ScaleformMovieMethodAddParamInt(self.HorsesPositions[6])

    ScaleformMovieMethodAddParamFloat(0.0) -- Unk
    ScaleformMovieMethodAddParamBool(false)
    EndScaleformMovieMethod()
end

function Horse:IsRaceFinished()
    BeginScaleformMovieMethod(Horse.Scaleform, 'GET_RACE_IS_COMPLETE')

    local raceReturnValue = EndScaleformMovieMethodReturnValue()

    while not IsScaleformMovieMethodReturnValueReady(raceReturnValue) do
        Wait(0)
    end

    return GetScaleformMovieMethodReturnValueBool(raceReturnValue)
end

function Horse:ShowResults()
    BeginScaleformMovieMethod(self.Scaleform, 'SHOW_SCREEN')
    ScaleformMovieMethodAddParamInt(7)
    EndScaleformMovieMethod()
end

function Horse:ShowRules()
    BeginScaleformMovieMethod(self.Scaleform, 'SHOW_SCREEN')
    ScaleformMovieMethodAddParamInt(9)
    EndScaleformMovieMethod()
end