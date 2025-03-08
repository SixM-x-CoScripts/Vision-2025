function Horse:GetMouseClickedButton()
    local returnValue = -1

    CallScaleformMovieMethodWithNumber(self.Scaleform, 'SET_INPUT_EVENT', 237.0, -1082130432, -1082130432, -1082130432, -1082130432)
    BeginScaleformMovieMethod(self.Scaleform, 'GET_CURRENT_SELECTION')

    returnValue = EndScaleformMovieMethodReturnValue()

    while not IsScaleformMovieMethodReturnValueReady(returnValue) do
        Wait(0)
    end

    return GetScaleformMovieMethodReturnValueInt(returnValue)
end

function Horse.GetRandomHorseName()
    math.randomseed(GetGameTimer())
    local random = math.random(0, 99)
    local randomName = (random < 10) and ('ITH_NAME_00'..random) or ('ITH_NAME_0'..random)

    return randomName
end

Horse.HorseStyles = {
    {15553363,5474797,9858144,4671302},
    {16724530,3684408,14807026,16777215},
    {13560920,15582764,16770746,7500402},
    {16558591,5090807,10446437,7493977},
    {5090807,16558591,3815994,9393493},
    {16269415,16767010,10329501,16777215},
    {2263807,16777215,9086907,3815994},
    {4879871,16715535,3815994,16777215},
    {16777215,2263807,16769737,15197642},
    {16338779,16777215,11166563,6974058},
    {16777215,16559849,5716493,3815994},
    {16760644,3387257,16701597,16777215},
    {6538729,2249420,16777215,3815994},
    {15913534,15913534,16304787,15985375},
    {15655629,16240452,16760474,13664854},
    {16320263,16777215,14920312,16773316},
    {7176404,15138618,6308658,13664854},
    {4879871,8453903,11382189,15724527},
    {16777215,16777215,16754809,16777215},
    {16732497,16732497,3815994,16777215},
    {5739220,5739220,11382189,15724527},
    {16712909,6935639,8742735,3877137},
    {2136867,16777215,16761488,3877137},
    {3118422,10019244,14932209,6121086},
    {2136867,10241979,8081664,3815994},
    {16769271,13724403,9852728,14138263},
    {13724403,16769271,6444881,14138263},
    {10017279,4291288,16304787,15985375},
    {1071491,4315247,14935011,6121086},
    {3861944,16627705,14932209,6121086},
    {15583546,4671303,11836798,3090459},
    {15567418,4671303,9985296,3815994},
    {5701417,16711680,16771760,6970713},
    {16760303,5986951,12353664,15395562},
    {8907670,2709022,9475214,4278081},
    {5429688,6400829,16777215,16773316},
    {15138618,5272210,14920312,16773316},
    {10241979,12396337,14920312,15395562},
    {16777215,13481261,13667152,3815994},
    {5077874,16777215,15444592,7820105},
    {10408040,2960685,7424036,10129549},
    {7754308,16777215,12944259,3815994},
    {16736955,16106560,16771760,6970713},
    {16106560,16770224,16767659,15843765},
    {9573241,14703194,9789279,3815994},
    {44799,14703194,10968156,16777215},
    {7143224,16753956,10975076,4210752},
    {7895160,4013373,5855577,11645361},
    {16075595,6869196,13530742,7105644},
    {16090955,6272992,16777215,16777215},
    {13313356,13313356,5849409,11623516},
    {13911070,5583427,14935011,6121086},
    {8604661,10408040,12944259,3815994},
    {9716612,2960685,16767659,6708313},
    {7806040,16777215,16765601,14144436},
    {15632075,11221989,16777215,16770037},
    {1936722,14654697,16763851,3815994},
    {10377543,3815994,14807026,16777215},
    {16775067,11067903,16770746,7500402},
    {16741712,8669718,16777215,16777215},
    {16515280,6318459,3815994,9393493},
    {65526,16515280,10329501,16777215},
    {16711680,4783925,3815994,3815994},
    {65532,4783925,16766671,15197642},
    {16760303,16760303,3815994,14207663},
    {16770048,16770048,3815994,3815994},
    {16737792,16737792,11166563,6974058},
    {12773119,12773119,5716493,3815994},
    {16777215,16763043,16701597,16777215},
    {6587161,6587161,16777215,3815994},
    {6329328,16749602,3815994,3815994},
    {15793920,16519679,14920312,15395562},
    {15466636,10724259,16760474,13664854},
    {11563263,327629,6308658,13664854},
    {58867,16777215,16754809,8082236},
    {4909311,16777215,5849409,11623516},
    {3700643,7602233,9852728,14138263},
    {16777215,1017599,8742735,3877137},
    {16772022,16772022,16761488,3877137},
    {7849983,5067443,8081664,3815994},
    {15913534,7602233,6444881,14138263},
    {12320733,16775618,11836798,3090459},
    {15240846,16777215,9985296,3815994},
    {14967137,3702939,3815994,14207663},
    {6343571,3702939,12353664,15395562},
    {16761374,15018024,9475214,4278081},
    {16743936,3756172,16777215,16773316},
    {2899345,5393472,16777215,4210752},
    {11645361,16777215,16771542,10123632},
    {3421236,5958825,16771542,3815994},
    {15851871,5395026,15444592,7820105},
    {16777215,9463517,7424036,10129549},
    {16760556,16733184,16767659,15843765},
    {4781311,15771930,16765601,14144436},
    {16760556,10287103,16767659,6708313},
    {13083490,16777215,9789279,3815994},
    {13810226,9115524,5855577,11645361},
    {14176336,9115524,13530742,7105644},
    {16770310,16751169,16772294,16777215}
}

local cooldown = 60
local tick = 0
local checkRaceStatus = false
local casinoAudioBank = 'DLC_VINEWOOD/CASINO_GENERAL' -- PAS TOUCHE
local ChairData = {}
local open = false

local function OpenInsideTrack()
    if Horse.InsideTrackActive then
        return
    end

    Horse.InsideTrackActive = true

    SWTriggerServCallback("sunwisecasino:GetNumJetons", function(cb)
        Horse.PlayerBalance = cb
    end)

    -- Scaleform
    Horse.Scaleform = RequestScaleformMovie('HORSE_RACING_CONSOLE')

    while not HasScaleformMovieLoaded(Horse.Scaleform) do
        Wait(0)
    end

    DisplayHud(false)
    SetPlayerControl(PlayerId(), false, 0)

    while not RequestScriptAudioBank(casinoAudioBank) do
        Wait(0)
    end

    Horse:ShowMainScreen()
    Horse:SetMainScreenCooldown(cooldown)

    -- Add horses
    Horse.AddHorses(Horse.Scaleform)

    Horse:DrawInsideTrack()
    Horse:HandleControls()
end

local function LeaveInsideTrack()
    Horse.InsideTrackActive = false

    DisplayHud(true)
    SetPlayerControl(PlayerId(), true, 0)
    SetScaleformMovieAsNoLongerNeeded(Horse.Scaleform)
    ReleaseNamedScriptAudioBank(casinoAudioBank)

    Horse.Scaleform = -1
    open = false

   -- local sitExitScene = NetworkCreateSynchronisedScene(ChairData.chairCoords, ChairData.chairRotation, 2, true, false, 1.0, 0.0, 1.0)
   -- NetworkAddPedToSynchronisedScene(PlayerPedId(), sitExitScene, CasinoConfig.PlayerAnimDictShared, 'sit_exit_left', 2.0, -2.0, 13, 16, 2.0, 0)
   -- NetworkStartSynchronisedScene(sitExitScene)
   -- Wait(4000)
    local playerPed = PlayerPedId()
	ClearPedTasks(playerPed)
    ClearPedTasksImmediately(playerPed)
	FreezeEntityPosition(playerPed, false)

    TriggerServerEvent('Flozii:casino:RemoveSeat', ChairData.chairCoords)
    --NetworkStopSynchronisedScene(sitExitScene)
end

function Horse:DrawInsideTrack()
    Citizen.CreateThread(function()
        while self.InsideTrackActive do
            Wait(0)

            local xMouse, yMouse = GetDisabledControlNormal(2, 239), GetDisabledControlNormal(2, 240)

            -- Fake cooldown
            tick = (tick + 10)

            if (tick == 1000) then
                if (cooldown == 1) then
                    cooldown = 60
                end
                
                cooldown = (cooldown - 1)
                tick = 0

                self:SetMainScreenCooldown(cooldown)
            end
            
            -- Mouse control
            BeginScaleformMovieMethod(self.Scaleform, 'SET_MOUSE_INPUT')
            ScaleformMovieMethodAddParamFloat(xMouse)
            ScaleformMovieMethodAddParamFloat(yMouse)
            EndScaleformMovieMethod()

            -- Draw
            DrawScaleformMovieFullscreen(self.Scaleform, 255, 255, 255, 255)
        end
    end)
end

function Horse:HandleControls()
    Citizen.CreateThread(function()
        while self.InsideTrackActive do
            Wait(0)

            if IsControlJustPressed(2, 194) or IsControlJustPressed(2, 202) then
                LeaveInsideTrack()
                self:HandleBigScreen()
            end

            -- Left click
            if IsControlJustPressed(2, 237) then
                local clickedButton = self:GetMouseClickedButton()

                if self.ChooseHorseVisible then
                    if (clickedButton ~= 12) and (clickedButton ~= -1) then
                        self.CurrentHorse = (clickedButton - 1)
                        self:ShowBetScreen(self.CurrentHorse)
                        self.ChooseHorseVisible = false
                    end
                end

                -- Rules button
                if (clickedButton == 15) then
                    self:ShowRules()
                end

                -- Close buttons
                if (clickedButton == 12) then
                    if self.ChooseHorseVisible then
                        self.ChooseHorseVisible = false
                    end
                    
                    if self.BetVisible then
                        self:ShowHorseSelection()
                        self.BetVisible = false
                        self.CurrentHorse = -1
                    else
                        self:ShowMainScreen()
                    end
                end

                -- Start bet
                if (clickedButton == 1) then
                    self:ShowHorseSelection()
                end

                -- Start race
                if (clickedButton == 10) then
                    SWTriggerServCallback("sunwisecasino:GetNumJetons", function(cb)
                        if cb >= self.CurrentBet then
                            self.CurrentSoundId = GetSoundId()
                            PlaySoundFrontend(self.CurrentSoundId, 'race_loop', 'dlc_vw_casino_inside_track_betting_single_event_sounds')
                            -- laisse comme ca mec
                            TriggerServerEvent("flozii:casino:remove", self.CurrentBet)
                            self:StartRace()
                            checkRaceStatus = true
                            printDev("checkRaceStatus", checkRaceStatus)
                        else
                            CasinoConfig.ShowNotification(CasinoConfigSH.Lang.NotEnough)
                        end
                    end)
                end

                -- Change bet
                if (clickedButton == 8) then
                    if (self.CurrentBet < self.PlayerBalance) then
                        self.CurrentBet = (self.CurrentBet + 100)
                        self.CurrentGain = (self.CurrentBet * 2)
                        self:UpdateBetValues(self.CurrentHorse, self.CurrentBet, self.PlayerBalance, self.CurrentGain)
                    end
                end

                if (clickedButton == 9) then
                    if (self.CurrentBet > 100) then
                        self.CurrentBet = (self.CurrentBet - 100)
                        self.CurrentGain = (self.CurrentBet * 2)
                        self:UpdateBetValues(self.CurrentHorse, self.CurrentBet, self.PlayerBalance, self.CurrentGain)
                    end
                end

                if (clickedButton == 13) then
                    self:ShowMainScreen()
                end
                
                local timer = 1
                Wait(500)
                printDev("go checkRaceStatus", checkRaceStatus)
                while checkRaceStatus do
                    Wait(0)

                    timer += 1
                    printDev("raceFinished", timer, self.CurrentWinner, self.CurrentHorse)
                    local raceFinished = self:IsRaceFinished()

                    if (raceFinished or timer > 530) then
                        printDev("Race finished 1")
                        StopSound(self.CurrentSoundId)
                        ReleaseSoundId(self.CurrentSoundId)
                        printDev("Race finished 2")

                        self.CurrentSoundId = -1

                        printDev("Race finished 3")
                        if (self.CurrentHorse ~= self.CurrentWinner) then 
                            printDev("Race finished 4")
                            self.PlayerBalance = (self.PlayerBalance - self.CurrentBet)
                            self:UpdateBetValues(self.CurrentHorse, self.CurrentBet, self.PlayerBalance, self.CurrentGain)
                        end
                        printDev("Race finished 5")

                        if (self.CurrentHorse == self.CurrentWinner) then
                            printDev("Race finished 6")
                            -- Here you can add money
                            -- Exemple
                            TriggerSecurGiveEvent('flozii:casino:win', self.CurrentGain, GetEntityCoords(PlayerPedId()))
                            -- Refresh player balance
                            self.PlayerBalance = (self.PlayerBalance + self.CurrentGain)
                            self:UpdateBetValues(self.CurrentHorse, self.CurrentBet, self.PlayerBalance, self.CurrentGain)
                        end
                        printDev("Race finished 7")

                        self:ShowResults()

                        printDev("Race finished 8")
                        self.CurrentHorse = -1
                        self.CurrentWinner = -1
                        self.CurrentBet = 0
                        self.HorsesPositions = {}

                        checkRaceStatus = false
                        printDev("Race finished 9")
                    end
                end
            end
        end
    end)
end

--RegisterCommand('itrack', OpenInsideTrack)

local function GetNeareChair()
	local object, distance
	local coords = GetEntityCoords(PlayerPedId())
	for i=1, #CasinoConfig.ChairsHorse do
		object = GetClosestObjectOfType(coords, 3.0, GetHashKey(CasinoConfig.ChairsHorse[i]), false, false, false)
		distance = #(coords - GetEntityCoords(object))
		if distance < 2.0 then
			return object, distance
		end
	end
	return nil, nil
end

local Sitable = {
    ch_prop_casino_track_chair_01           = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
    vw_prop_casino_track_chair_01           = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	ch_prop_casino_chair_01a 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	ch_prop_casino_chair_01b 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	ch_prop_casino_chair_01c 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	vw_prop_casino_chair_01a 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
}

function sitdownHorse()
	local object, distance = GetNeareChair()

	if distance and distance < 2.0 then
		local hash = GetEntityModel(object)

		for k,v in pairs(Sitable) do
			if GetHashKey(k) == hash then
				sitdown2(object, k, v)
				break
			end
		end
	end
end

function sitdown2(object, modelName, data)
	-- Fix for sit on chairs behind walls
	--if not HasEntityClearLosToEntity(PlayerPedId(), object, 17) then
    --    printDev(3)
	--	return
	--end
	FreezeEntityPosition(object, true)

	PlaceObjectOnGroundProperly(object)
	local pos = GetEntityCoords(object)
	local playerPos = GetEntityCoords(PlayerPedId())
	local objectCoords = pos.x .. pos.y .. pos.z

    SWTriggerServCallback('sunwisecasino:horse:sitDown', function(canSit)
		if not canSit then
			CasinoConfig.ShowNotification(CasinoConfigSH.Lang.SeatOccuped)
		else
			local playerPed = PlayerPedId()
		--	lastPos, currentSitCoords = GetEntityCoords(playerPed), objectCoords
            ChairData.chairCoords = objectCoords
			currentScenario = data.scenario
            TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z + (playerPos.z - pos.z)/2, GetEntityHeading(object) + 180.0, 0, true, true)
            Wait(1000)
			OpenInsideTrack()
            if GetEntitySpeed(PlayerPedId()) > 0 then
				ClearPedTasks(PlayerPedId())
				TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z + (playerPos.z - pos.z)/2, GetEntityHeading(object) + 180.0, 0, true, true)
			end
		end
	end, objectCoords)
end

local IsPedInArea = function(ped, x, y, z, radius)
    local pedcoords = GetEntityCoords(ped)
    return GetDistanceBetweenCoords(pedcoords, x, y, z, true) < radius+0.01 -- optimisé
end

local hour = 1

CreateThread(function()
    Wait(5000)
    while true do 
        Wait(60000*3)
        SWTriggerServCallback("Flozii:casino:GetIRLTime", function(h,m,s)
            hour = h
        end)
    end
end)

CreateThread(function()
    while true do 
        Wait(1)
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
        if z < -30.0 then
            if IsPedInArea(PlayerPedId(), 1096.25, 260.56, -51.2, 9.0) then
                local object, distance = GetNeareChair()
                if distance and distance < 1.9 then
                    local xe,ye,ze = table.unpack(GetEntityCoords(object))
                    Bulle.create("horseCasino", vector3(xe,ye,ze) + vector3(0.0, 0.0, 1.0), "bulleInsideTrack", true)
                    if not Horse.InsideTrackActive then
                        --MauvaisUI.Visible(MOUAI:Get('floziiitrack', 'play'), true)
                        --if MauvaisUI.Visible(MOUAI:Get('floziiitrack', 'play')) then
                        --    MauvaisUI.IsVisible(MOUAI:Get('floziiitrack', 'play'), true, true, true, function()
                        --        MauvaisUI.ButtonWithStyle(
                        --            "Jouer au ~y~Inside Track",
                        --            false,
                        --            {RightLabel = '→→→'},
                        --            true,
                        --            function(Hovered, Active, Selected)
                        --                if (Hovered) then
                        --                end
                        --                if (Active) then
                        --                end
                        --                if (Selected) then
                        --                    sitdownHorse()
                        --                end
                        --        end)
                        --    end)
                        --end
                        CasinoConfig.ShowHelpNotification(CasinoConfigSH.Lang.PlayInsideTrack)
                        if IsControlJustPressed(0, 38) then
                            sitdownHorse()
                        end
                    end
                end
            else
                Wait(1500)
            end
        else
            Wait(5000)
        end
    end
end)

-- BIG SCREEN

local screenTarget, bigScreenScaleform = -1, -1
local bigScreenRender, isBigScreenLoaded = false, false
local renderTargetName = 'casinoscreen_02' -- Do not edit

local function registerTarget(name, objectModel)
    if not IsNamedRendertargetRegistered(name) then
        RegisterNamedRendertarget(name, false)
    end

    if not IsNamedRendertargetLinked(objectModel) then
        LinkNamedRendertarget(objectModel)
    end

    return GetNamedRendertargetRenderId(name)
end

local function loadBigScreen()
    screenTarget = registerTarget(renderTargetName, `vw_vwint01_betting_screen`)
    
    bigScreenScaleform = RequestScaleformMovie('HORSE_RACING_WALL')

    while not HasScaleformMovieLoaded(bigScreenScaleform) do
        Wait(0)
    end

    BeginScaleformMovieMethod(bigScreenScaleform, 'SHOW_SCREEN')
    ScaleformMovieMethodAddParamInt(0)
    EndScaleformMovieMethod()
    SetScaleformFitRendertarget(bigScreenScaleform, true)

    Horse.AddHorses(bigScreenScaleform)

    isBigScreenLoaded = true
end

function Horse:HandleBigScreen()
    CreateThread(function()
        while not self.InsideTrackActive do
            Wait(0)

            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - Horse.BigScreen.coords)
            
            if (distance <= 30.0) then
                if not isBigScreenLoaded then
                    loadBigScreen()
                end

                if not bigScreenRender then
                    bigScreenRender = true
                end

                if (screenTarget ~= -1) and (bigScreenScaleform ~= -1) then
                    SetTextRenderId(screenTarget)
                    SetScriptGfxDrawOrder(4)
                    SetScriptGfxDrawBehindPausemenu(true)
                    DrawScaleformMovieFullscreen(bigScreenScaleform, 255, 255, 255, 255)
                    SetTextRenderId(GetDefaultScriptRendertargetRenderId())
                end
            elseif bigScreenRender then
                bigScreenRender = false
                isBigScreenLoaded = false
                
                SetScaleformMovieAsNoLongerNeeded(bigScreenScaleform)
            end
        end
    end)
end

do
    if not Horse.BigScreen.enable then
        return
    end

    Horse:HandleBigScreen()
end

