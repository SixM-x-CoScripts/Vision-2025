CasinoConfig = {}
CasinoConfig.ShowHelpNotification = function(msg)
    --AddTextEntry('helpNotif', msg)
	--BeginTextCommandDisplayHelp('helpNotif')
	--EndTextCommandDisplayHelp(0, false, false, 1)
end
CasinoConfig.ShowNotification = function(msg)
	--AddTextEntry('Notification', msg)
	--BeginTextCommandThefeedPost('Notification')
	--EndTextCommandThefeedPostTicker(false, false)
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        content = msg
    })
end

CasinoConfig.Blips = {
    activate = false,
    BlipId = 681,
    Pos = {x=927.60870361328, y=44.773017883301, z=79.899940490723},
    Colour = 7,
    Scale = 0.75,
    Name = "Casino"
}

CasinoConfig.ChipPrice = 1
CasinoConfig.BuyChipsPos = {x=1116.11, y=220.19, z=-49.43}

CasinoConfig.EnterPos = vector3(934.48, 46.26, 81.09)
CasinoConfig.ExitPos = vector3(1089.77, 206.55, -48.99)
CasinoConfig.Peds = {
    {
        -- Cashier
        pedHash = GetHashKey("s_f_y_casino_01"),
        pos = vector4(1117.23, 219.99, -49.90-0.50, 85.36),
        shouldtalk = true, -- will say hello
        invincible = true,
        freeze = true,
    }
}

CasinoConfig.ShowHUDChips = true

CasinoConfig.PlayFrontendSounds = true

CasinoConfig.Ipls = {
    "hei_dlc_windows_casino",
    "hei_dlc_casino_aircon",
    "vw_dlc_casino_door",
    "hei_dlc_casino_door",
    "vw_casino_main",
    "vw_casino_garage",
    "vw_casino_carpark",
    "vw_casino_penthouse",
    "vw_casino_penthouse",
}

CasinoConfig.ChairsId = {
    ['Chair_Base_01'] = 1,
    ['Chair_Base_02'] = 2,
    ['Chair_Base_03'] = 3,
    ['Chair_Base_04'] = 4
}

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------- ROULETTE ---------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

CasinoConfig.RouletteTables = {
    [0] = {
        position = vector3(1150.718505859375, 262.52783203125, -52.840850830078125),
        rot = -45.0,
        minBet = 5,
        maxBet = 200
    },
    [1] = {
        position = vector3(1144.732421875, 268.14117431640625, -52.840850830078125),
        rot = 135.0,
        minBet = 5,
        maxBet = 200
    },
    [2] = {
        position = vector3(1133.68115234375, 262.01678466796875, -52.03075408935547),
        rot = -156.0,
        minBet = 250,
        maxBet = 2000
    },
    [3] = {
        position = vector3(1129.53955078125, 267.06097412109375, -52.03075408935547),
        rot = 26.0,
        minBet = 250,
        maxBet = 2000
    }
}

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------- BLACKJACK --------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

CasinoConfig.BlackJackTables = {
    [0] = {
        dealerPos = vector3(1149.38,269.19,-52.02),
        dealerHeading = 46.0,
        tablePos = vector3(1148.84, 269.74, -52.84),
        tableHeading = -134.69,
        distance = 20.0,
        prop = "vw_prop_casino_blckjack_01"
    },
    [1] = {
        dealerPos = vector3(1151.28,267.33,-51.840),
        dealerHeading = 222.2,
        tablePos = vector3(1151.84, 266.747, -52.8409),
        tableHeading = 45.31,
        distance = 20.0,
        prop = "vw_prop_casino_blckjack_01"
    },
    [2] = {
        dealerPos = vector3(1128.862,261.795,-51.0357),
        dealerHeading = 315.0,
        tablePos = vector3(1129.406, 262.3578, -52.041),
        tableHeading = 135.31,
        distance = 20.0,
        prop = "vw_prop_casino_blckjack_01b"
    },
    [3] = {
        dealerPos = vector3(1143.859,246.783,-51.035),
        dealerHeading = 313.0,
        tablePos = vector3(1144.429, 247.3352, -52.041),
        tableHeading = 135.31,
        distance = 20.0,
        prop = "vw_prop_casino_blckjack_01b"
    },
}

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------- SLOTS ----------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

CasinoConfig.Slots = {
    [1] = { -- Diamonds
        pos = vector3(1106.23, 229.30, -49.84),
        bet = 50,
        prop = 'vw_prop_casino_slot_03a',
        prop1 = 'vw_prop_casino_slot_03a_reels',
        prop2 = 'vw_prop_casino_slot_03a_reels',
        name = "ranger"
    },
    [2] = { -- Fortune And Glory
        pos = vector3(1103.57, 230.00, -49.84),
        bet = 100,
        prop = 'vw_prop_casino_slot_05a',
        prop1 = 'vw_prop_casino_slot_05a_reels',
        prop2 = 'vw_prop_casino_slot_05b_reels',
        name = "deity"
    },
    [3] = {
        pos = vector3(1104.51, 231.38, -49.84),
        bet = 50,
        prop = 'vw_prop_casino_slot_01a',
        prop1 = 'vw_prop_casino_slot_01a_reels',
        prop2 = 'vw_prop_casino_slot_01b_reels',
        name = "angel"
    },	
    [4] = { -- Fortune And Glory
        pos = vector3(979.33, 68.53, 74.74),
        bet = 100,
        prop = 'vw_prop_casino_slot_05a',
        prop1 = 'vw_prop_casino_slot_05a_reels',
        prop2 = 'vw_prop_casino_slot_05b_reels',
        name = "deity"
    },

    [5] = { -- All FAME
        pos = vector3(1104.58, 228.56, -49.84),
        bet = 100,
        prop = 'vw_prop_casino_slot_04a',
        prop1 = 'vw_prop_casino_slot_04a_reels',
        prop2 = 'vw_prop_casino_slot_04b_reels',
        name = "fame"
    },
    [6] = {
        pos = vector3(1100.462, 229.6288, -49.84074),
        bet = 100,
        prop = 'vw_prop_casino_slot_04a',
        prop1 = 'vw_prop_casino_slot_04a_reels',
        prop2 = 'vw_prop_casino_slot_04b_reels',
        name = "fame"
    },
    [7] = {
        pos = vector3(1110.969, 238.0046, -49.20215),
        bet = 100,
        prop = 'vw_prop_casino_slot_04a',
        prop1 = 'vw_prop_casino_slot_04a_reels',
        prop2 = 'vw_prop_casino_slot_04b_reels',
        name = "fame"
    },
    [8] = {
        pos = vector3(1112.857, 233.5025, -49.84081),
        bet = 100,
        prop = 'vw_prop_casino_slot_04a',
        prop1 = 'vw_prop_casino_slot_04a_reels',
        prop2 = 'vw_prop_casino_slot_04b_reels',
        name = "fame"
    },
    [9] = {
        pos = vector3(1117.673, 230.9129, -49.84074),
        bet = 100,
        prop = 'vw_prop_casino_slot_04a',
        prop1 = 'vw_prop_casino_slot_04a_reels',
        prop2 = 'vw_prop_casino_slot_04b_reels',
        name = "fame"
    },
    [10] = {
        pos = vector3(1120.635, 230.694, -49.20213),
        bet = 100,
        prop = 'vw_prop_casino_slot_04a',
        prop1 = 'vw_prop_casino_slot_04a_reels',
        prop2 = 'vw_prop_casino_slot_04b_reels',
        name = "fame"
    },
    [11] = { -- ALL KNIFES
        pos = vector3(1112.638, 238.6774, -48.10333),
        bet = 50,
        prop = 'vw_prop_casino_slot_06a',
        prop1 = 'vw_prop_casino_slot_06a_reels',
        prop2 = 'vw_prop_casino_slot_06a_reels',
        name = "knife"
    },
    [12] = { 
        pos = vector3(1117.529, 228.015, -49.8408),
        bet = 50,
        prop = 'vw_prop_casino_slot_06a',
        prop1 = 'vw_prop_casino_slot_06a_reels',
        prop2 = 'vw_prop_casino_slot_06a_reels',
        name = "knife"
    },
    [13] = { 
        pos = vector3(1109.712, 233.8212, -49.84074),
        bet = 50,
        prop = 'vw_prop_casino_slot_06a',
        prop1 = 'vw_prop_casino_slot_06a_reels',
        prop2 = 'vw_prop_casino_slot_06a_reels',
        name = "knife"
    },
    [14] = { 
        pos = vector3(1112.714, 238.5195, -49.20214),
        bet = 50,
        prop = 'vw_prop_casino_slot_06a',
        prop1 = 'vw_prop_casino_slot_06a_reels',
        prop2 = 'vw_prop_casino_slot_06a_reels',
        name = "knife"
    },
    [15] = { 
        pos = vector3(1137.353, 251.7883, -51.03572),
        bet = 50,
        prop = 'vw_prop_casino_slot_06a',
        prop1 = 'vw_prop_casino_slot_06a_reels',
        prop2 = 'vw_prop_casino_slot_06a_reels',
        name = "knife"
    },
}

CasinoConfig.Slots2 = {}
CasinoConfig.Slots2.ShowHelpNotification = function(msg)
    AddTextEntry('helpNotif', msg)
	BeginTextCommandDisplayHelp('helpNotif')
	EndTextCommandDisplayHelp(0, false, false, 1)
end

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------- THREE CARDS POKER ----------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

CasinoConfig.TreeCardTables = {
    'h4_prop_casino_3cardpoker_01a',
    'h4_prop_casino_3cardpoker_01b',
    'h4_prop_casino_3cardpoker_01c',
    'h4_prop_casino_3cardpoker_01d',
    'h4_prop_casino_3cardpoker_01e',
    'vw_prop_casino_3cardpoker_01',
    'vw_prop_casino_3cardpoker_01b',
}

CasinoConfig.Pokers = {
    [1] = {
        Position = vector3(1143.338, 264.2453, -52.8409),
        Heading = -135.0,
        MaximumBet = 150000,
        MinimumBet = 50
    },
    [2] = {
        Position = vector3(1146.329, 261.2543, -52.8409),
        Heading = 45.0,
        MaximumBet = 150000,
        MinimumBet = 50
    },
    [3] = {
        Position = vector3(1133.74, 266.6947, -52.0409),
        Heading = -45.0,
        MaximumBet = 50000,
        MinimumBet = 50
    },
    [4] = {
        Position = vector3(1148.74, 251.6947, -52.0409),
        Heading = -45.0,
        MaximumBet = 50000,
        MinimumBet = 50
    }
}

CasinoConfig.DealerAnimDictShared = 'anim_casino_b@amb@casino@games@shared@dealer@'
CasinoConfig.DealerAnimDictPoker = 'anim_casino_b@amb@casino@games@threecardpoker@dealer'
CasinoConfig.PlayerAnimDictShared = 'anim_casino_b@amb@casino@games@shared@player@'
CasinoConfig.PlayerAnimDictPoker = 'anim_casino_b@amb@casino@games@threecardpoker@player'

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------ HORSE -----------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

CasinoConfig.ShowBigScreen = true
CasinoConfig.BigScreenCoord = vector3(1092.75, 264.56, -51.24)
CasinoConfig.ChairsHorse = {
    'ch_prop_casino_chair_01a',
    'ch_prop_casino_chair_01b',
    'ch_prop_casino_chair_01c',
    "vw_prop_casino_track_chair_01",
    "ch_prop_casino_track_chair_01",
    'vw_prop_casino_chair_01a',
}

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------ WHEEL -----------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

CasinoConfig.WheelPos = vector3(1111.052, 229.841, -50.38)
CasinoConfig.RollPrice = 0 -- 0 for free, no check
CasinoConfig.WinCar = function()
    -- QB CORE
    --[[QBCore.Functions.SpawnVehicle("tenf", function(veh)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        QBCore.Functions.Notify("You won the 10-F !", "success")
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        TriggerEvent("qb-admin:client:SaveCar")
    end, QB.SpawnPunt, true)]]

end


--This command is used to get the coords for setting up new blackjack tables. 
--Tables can be vw_prop_casino_blckjack_01 or vw_prop_casino_blckjack_01b
--RegisterCommand("getclosestcasinotable",function()
--    local blackjackTable = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()),3.0,GetHashKey("vw_prop_casino_blckjack_01"),0,0,0)
--    if DoesEntityExist(blackjackTable) then
--        print("Found entity !")
--        print("tablePos pos",GetEntityCoords(blackjackTable))
--        print("tableHeading heading",GetEntityHeading(blackjackTable))
--        print("prop: vw_prop_casino_blckjack_01")
--    else
--        local blackjackTable2 = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()),3.0,GetHashKey("vw_prop_casino_blckjack_01b"),0,0,0)
--        if DoesEntityExist(blackjackTable2) then
--            print("Found entity !")
--            print("tablePos pos:",GetEntityCoords(blackjackTable2))
--            print("tableHeading heading:",GetEntityHeading(blackjackTable2))
--            print("prop: vw_prop_casino_blckjack_01b")
--        else
--            print("Could not find any entity")
--        end
--    end
--end)

-- You can use this command to implement your POKER TABLES
-- You get the results out in the console, after you can register in the c onfig.
--RegisterCommand('getclosestpokertable',function()
--        local found = false
--
--        local playercoords = GetEntityCoords(PlayerPedId())
--        for i = 1, #CasinoConfig.TreeCardTables, 1 do
--            local obj = GetClosestObjectOfType(playercoords, 3.0, GetHashKey(CasinoConfig.TreeCardTables[i]),0,0,0)
--            if DoesEntityExist(obj) then
--                found = true
--                print('Poker table position: ' .. GetEntityCoords(obj))
--                print('Poker table heading: ' .. GetEntityHeading(obj))
--                print('(Does not matter in the config) Poker table model: ' .. CasinoConfig.TreeCardTables[i])
--            end
--        end
--
--        if not found then
--            print('none table found.')
--        end
--    end
--)


SW = {}
SW.CurrentRequestId = 0
SW.ServerCallbacks = {}

SWTriggerServCallback = function(name, cb, ...)
	SW.ServerCallbacks[SW.CurrentRequestId] = cb

	TriggerServerEvent('border:triggerServerCallback', name, SW.CurrentRequestId, ...)

	if SW.CurrentRequestId < 65535 then
		SW.CurrentRequestId = SW.CurrentRequestId + 1
	else
		SW.CurrentRequestId = 0
	end
end

RegisterNetEvent('border:serverCallback')
AddEventHandler('border:serverCallback', function(requestId, ...)
	if requestId and SW.ServerCallbacks then
		SW.ServerCallbacks[requestId](...)
		SW.ServerCallbacks[requestId] = nil
	else
		Wait(2500)
		if requestId then
			SW.ServerCallbacks[requestId](...)
			SW.ServerCallbacks[requestId] = nil
		end
	end
end)