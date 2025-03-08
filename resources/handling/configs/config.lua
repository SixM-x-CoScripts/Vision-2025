Config = {}

-- 88888888b                                                                    dP
-- 88                                                                           88
-- a88aaaa    88d888b. .d8888b. 88d8b.d8b. .d8888b. dP  dP  dP .d8888b. 88d888b. 88  .dP
-- 88        88'  `88 88'  `88 88'`88'`88 88ooood8 88  88  88 88'  `88 88'  `88 88888"
-- 88        88       88.  .88 88  88  88 88.  ... 88.88b.88' 88.  .88 88       88  `8b.
-- dP        dP       `88888P8 dP  dP  dP `88888P' 8888P Y8P  `88888P' dP       dP   `YP

Config.Framework = 'other' -- qbcore/esx/exm/other

Config.MySQLScript = 'oxmysql' -- MySQL / oxmysql

Config.NotificationSystem = 'custom' -- qbcore / esx / custom

-- Identifier used to save/load player's presets in database
Config.PlayerIdentifier = 'discord' -- license / steam / discord / ip

Config.UseDatabaseHandlingSaving = true
Config.UseDatabasePresetsSaving = true

Config.UseVstancer = true

-- Owned vehicles table in database information.
-- tableName - Name of table in which all owned vehicles are stored
-- ownerColumn - Owned vehicles owner column in DB table
-- plateColumn - Vehicle plate column in DB table
if Config.Framework == 'qbcore' then
    Config.OwnedVehiclesDataTable = {
        tableName = 'player_vehicles', ownerColumn = 'citizenid', plateColumn = 'plate' -- QBCore
    }
elseif Config.Framework == 'esx' or Config.Framework == 'exm' then
    Config.OwnedVehiclesDataTable = {
        tableName = 'owned_vehicles', ownerColumn = 'owner', plateColumn = 'plate' -- ESX
    }
else
    Config.OwnedVehiclesDataTable = { tableName = 'vehicles', ownerColumn = 'owner', plateColumn = 'plate' -- custom
    }
end

-- .d888888
-- d8'    88
-- 88aaaaa88a .d8888b. .d8888b. .d8888b. .d8888b. .d8888b.
-- 88     88  88'  `"" 88'  `"" 88ooood8 Y8ooooo. Y8ooooo.
-- 88     88  88.  ... 88.  ... 88.  ...       88       88
-- 88     88  `88888P' `88888P' `88888P' `88888P' `88888P'

-- Admins and their checks
Config.Admins = {
    {type = 'identifier', data = 'discord:149576203479547904'},
    {type = 'identifier', data = 'discord:143822290516312064'}, 
    {type = 'identifier', data = 'discord:618228507000045599'}, 
    {type = 'identifier', data = 'discord:395187741496836096'}, 
    {type = 'identifier', data = 'discord:297077339135803392'}, 
    {type = 'identifier', data = 'discord:396297265595154433'},
    {type = 'identifier', data = 'discord:259056305187192833'},
}

-- NOT recommended for RolePlay server
-- If set to true players will be able to fully adjust their vehicle
-- and make it as crazy fast as they want.
Config.AllowEveryoneFullAccess = false

-- Limited editing allows for all players to use the tablet, but only adjust vehicles handling values for limited number
-- You can adjust how much of each field can be changed by editing configs/config.js Min / Max > changeLimit
--
-- For example if vehicle's standard mass is 2000, Min.changeLimit is 200 and Max.changeLimit is 500,
-- then player will have 1800 - 2500 to play around with, as 2000 - 200 = 1800, 2000 + 500 = 2500.
--
-- THIS WILL NOT AFFECT TABLET VALUES FOR ADMINS - TABLET DEV USAGE
Config.AllowLimitedEditing = true

-- If value in config.js is not added, this will be used instead
Config.DefaultChangeLimit = 0.0

-- Name of inventory item
-- FOR QBCORE:
-- ADD TO qb-core/shared.lua  >  QBShared.Items
-- ['tunertablet'] 			 		 = {['name'] = 'tunertablet', 				['label'] = 'Tuner Tablet', 			['weight'] = 1000, 		['type'] = 'item', 		['image'] = 'tablet.png', 				['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,    ['combinable'] = nil,   ['description'] = 'Tablet used to adjust vehicle handling data'},
-- FOR ESX/EXM:
-- ADD TO database
-- INSERT INTO `items` (name, label)
-- VALUES ('tunertablet', 'Tuning Tablet');
Config.TabletItemName = 'tunertablet'

-- Command for admins full tablet access
Config.TabletCommand = 'tablet'

-- If you want any field to not be accessible by any regular player add it here
Config.BlacklistedFields = {
    -- 'fMass',
    -- 'fInitialDragCoeff',
    -- 'fPercentSubmerged',
    -- 'vecCentreOfMassOffset',
    -- 'fInitialDriveGears',
    -- 'fInitialDriveForce',
    -- 'fInitialDragCoeff',
    -- 'fDriveInertia',
    -- 'fClutchChangeRateScaleUpShift',
    -- 'fClutchChangeRateScaleDownShift',
    -- 'fInitialDriveMaxFlatVel',
    -- 'fBrakeForce',
    -- 'fBrakeBiasFront',
    -- 'fHandBrakeForce',
    -- 'fSteeringLock',
    -- 'fTractionCurveMax',
    -- 'fTractionCurveMin',
    -- 'fTractionCurveLateral',
    -- 'fTractionSpringDeltaMax',
    -- 'fLowSpeedTractionLossMult',
    -- 'fCamberStiffnesss',
    -- 'fTractionBiasFront',
    -- 'fTractionLossMult',
    -- 'fSuspensionForce',
    -- 'fSuspensionCompDamp',
    -- 'fSuspensionReboundDamp',
    -- 'fSuspensionUpperLimit',
    -- 'fSuspensionLowerLimit',
    -- 'fSuspensionRaise',
    -- 'fSuspensionBiasFront',
    -- 'fAntiRollBarForce',
    -- 'fAntiRollBarBiasFront',
    -- 'fRollCentreHeightFront',
    -- 'fRollCentreHeightRear',
    -- 'fCollisionDamageMult',
    -- 'uiModelFlags',
    -- 'uiHandlingFlags',
    -- 'fSeatOffsetDistance',
    -- 'uiMonetary',
    -- 'fSteeringLockRatio',
    -- 'fTractionCurveMaxRatio',
    -- 'fTractionCurveMinRatio',
    -- 'fTractionCurveLateralRatio',
    -- 'fCollisionDamageMultRatio',
    -- 'fWeaponDamageMult',
    -- 'fDeformationDamageMult',
    -- 'fEngineDamageMult',
    -- 'fPetrolTankVolume',
    -- 'fOilVolume',
    -- 'fSeatOffsetDistX',
    -- 'fSeatOffsetDistY',
    -- 'fSeatOffsetDistZ',
    -- 'nMonetaryValue',
    -- 'vecInertiaMultiplier',
    -- 'fWeaponDamageScaledToVehHealthMult',
    -- 'fPopUpLightRotation',
    -- 'fDownforceModifier',
    -- 'fRocketBoostCapacity',
    -- 'fBoostMaxSpeed',
    -- 'stanceFrontCamber',
    -- 'stanceRearWidth',
    -- 'stanceRearCamber',
    -- 'stanceFrontWidth',
    -- 'driftSteeringLock',
    -- 'driftTractionCurveMin',
    -- 'driftDriveBiasFront',
    -- 'driftInitialDriveForce',
    -- 'fDriveBiasFront',
    -- 'nInitialDriveGears',
}

-- Handling groups and their parameters.
-- Params define what car modification(s) is/are needed for the value to be changable.
-- Available mods names: Engine, Suspension, Transmission, Spoiler, FrontBumper, RearBumper, Armor
Config.HandlingGroups = {
    {
        Label = 'Engine', Params = {
            Engine = 2,
            Suspension = false,
            Transmission = false,
            Spoiler = false,
            FrontBumper = false,
            RearBumper = false,
        }
    },
    {
        Label = 'Suspension', Params = {
            Engine = false,
            Suspension = false,
            Transmission = false,
            Spoiler = false,
            FrontBumper = false,
            RearBumper = false,

        }
    },
    {
        Label = 'Stance', Params = {
            Engine = false,
            Suspension = false,
            Transmission = false,
            Spoiler = false,
            FrontBumper = false,
            RearBumper = false,

        }
    },
    {
        Label = 'Traction', Params = {
            Engine = false,
            Suspension = false,
            Transmission = 2,
            Spoiler = false,
            FrontBumper = false,
            RearBumper = false,

        }
    },
    {
        Label = 'Aero', Params = {}
    },
    {
        Label = 'Damage', Params = {}
    },
    {
        Label = 'Brakes', Params = { Brakes = 4 }
    },
    { -- Other is needed.
        Label = 'Other', Params = {}
    },
}

-- Scores to be displayed in diagram for the tablet
local handlingConfig = {}
Citizen.CreateThread(function()
    Citizen.Wait(100)
    if not IsDuplicityVersion() then
        handlingConfig = exports[GetCurrentResourceName()].getHandlingConfig()
        Config.ScoreValues = {
            { label = 'Aero', field = 'fDownforceModifier', max = handlingConfig.fDownforceModifier.Max.value },
            { label = 'TopSpeed', field = 'fInitialDriveMaxFlatVel',
                max = handlingConfig.fInitialDriveMaxFlatVel.Max.value },
            { label = 'Braking', field = 'fBrakeForce', max = handlingConfig.fBrakeForce.Max.value },
            { label = 'Acceleration', field = { 'fInitialDriveForce', 'fDriveInertia' },
                max = handlingConfig.fInitialDriveForce.Max.value + handlingConfig.fDriveInertia.Max.value },
        }
    end
end)

-- If you want specific field to require specific mod add it here
-- Available mods names: Engine, Suspension, Transmission, Spoiler, FrontBumper, RearBumper, Armor
Config.RequirementsForFields = {
    fSuspensionRaise = {
        --Transmission = 4
    }
}

-- Your addon vehicles models
Config.AddonVehicles = {
    -- Civil
    'admiral3',
    'altior',
    'argento',
    'ariant',
    'asteropers',
    'bansheepo',
    'briosoc1',
    'briosoc2',
    'briosoc3',
    'buffalo4h',
    'buffaloh',
    'cavalcadem',
    'citi',
    'comet3s',
    'contender8',
    'contenderc',
    'crowdrunner',
    'cycloneex0',
    'cypherct',
    'deluxo2',
    'elegant',
    'elegy4',
    'elegyrh7',
    'elegyrh72',
    'elegyute',
    'esperanto',
    'esperanto2d',
    'executioner',
    'executioner2',
    'faggiobs',
    'faggiolp',
    'faggioss',
    'faggiotr',
    'ferocid',
    'fxt1',
    'gauntlet4c',
    'gauntletac',
    'greenwoodc',
    'gresleyh',
    'hachura',
    'hellion2',
    'howitzer',
    'howitzer2',
    'jd_oraclev12',
    'jd_oraclev12a',
    'jd_oraclev12w',
    'landroamer',
    'mesar',
    'mulef',
    'nebulaw',
    'nexus',
    'oracxsle',
    'paradrop',
    'pentro',
    'pentro2',
    'pentro3',
    'pentrogpr',
    'pentrogpr2',
    'picadorl',
    'picadorld',
    'primo3',
    'primoard',
    'rapidgt4',
    'razor',
    'rebel4',
    'recursion',
    'regina4',
    'remusvert',
    'revolutions',
    'rh4',
    'roxanne',
    's230',
    'sadler6',
    'sadler7',
    'sadler8',
    'savannasa',
    'scharmann',
    'scheisser',
    'scout',
    'sentinels',
    'sentinelsg3',
    'sentinelsg3a',
    'sentinelsg3b',
    'sentinelsg3c',
    'sentinelsg3d',
    'sentinelsg4d',
    'sentinelsg32',
    'seraph',
    'seraph3',
    'severo',
    'sheavas',
    'sigma3',
    'spritzer',
    'spritzerdtm',
    'ss550',
    'steed2',
    'stratumc',
    'streiter2',
    'sultan2c',
    'sunrise1',
    'supergts',
    'swindler',
    'taco2',
    'tahoma',
    'tahoma2',
    'tampar',
    'taranis',
    'torrence',
    'tulip3',
    'turmalina',
    'turmalina2',
    'vesper',
    'vigeronew',
    'vincent2',
    'vincent3',
    'vorstand',
    'zinger',
    'zionks',
    'zodiac',
    'zodiacc',
    'zodiacr',
    'zr',
    'zr250',

    -- Moto Civil

    'acknodlow',
    'bati701',
    'dyna',
    'dyne',
    'enforcer',
    'kampfer',
    'kunoichi',
    'kusa',
    'lpbagger',
    'na25',
    'slave',
    'softail1',
    'sovereign2',
    'spirit',
    'spirit1',
    'templar',
    'trig',
    'troti',
    'wintergreen',

    -- Drift

    'dukes3d',
    'elegyrh72d',
    'gauntlet4d',
    'jester3d',
    'stratumcd',
    'stratumcd_slap_1',
    'sunrise1d',

    -- Entreprise

    'ballertaxi',
    'cabby',
    'flatbed3',
    'merittaxi',
    'newsmav',
    'newsvan',
    'newsvan2',
    'nspeedo',
    'speedobox',
    'staniertaxi',

    -- EMS

    'ambulance4',
    'blazerems',
    'caracaraems',
    'dinghyems',
    'emsbike',
    'emsnspeedo',
    'emsroamer',
    'lsfd3',
    'stretcher',

    -- LSPD

    'buffalotd',
    'cat',
    'coachlspd',
    'dominatorsis',
    'gtfminivan',
    'idcar',
    'lspdb',
    'mocpacker',
    'nscoutlspd',
    'nscoutumk',
    'pbike',
    'pdumkbuffalo',
    'polalamo',
    'polalamoold',
    'police',
    'police1k9',
    'police1k9b',
    'police2',
    'police2a',
    'police2c',
    'police2new',
    'police3new',
    'police3slick',
    'police3umk',
    'police4',
    'police42old',
    'policek9',
    'policeold',
    'policeslick',
    'polmav',
    'lspdmav',
    'polnspeedo',
    'polraiden',
    'polriot',
    'polsadlerk9',
    'polspeedo',
    'pscout',
    'roadrunner3',
    'sbus',
    'umkscout',
    'umkspeedo',
    'unmarkora',
    'ussssuv2',
}

Config.MaximumFetchBuffer = 3

-- 888888ba           oo .8888b   dP       8888ba.88ba                 dP
-- 88    `8b             88   "   88       88  `8b  `8b                88
-- 88     88 88d888b. dP 88aaa  d8888P     88   88   88 .d8888b. .d888b88 .d8888b.
-- 88     88 88'  `88 88 88       88       88   88   88 88'  `88 88'  `88 88ooood8
-- 88    .8P 88       88 88       88       88   88   88 88.  .88 88.  .88 88.  ...
-- 8888888P  dP       dP dP       dP       dP   dP   dP `88888P' `88888P8 `88888P'

Config.DriftModeEnabled = false
-- Modifications required for Drift mode to be enabled
Config.DriftGroupParams = {}

-- Drift mode parameters.
-- label, description - what is displayed in tablet under the Drift group configuration
-- formula - formula used to calculate changes for the field when vehicle is moving sideways
Config.DriftModeFields = {
    fInitialDriveForce = {
        label = 'Drive Force multiplier on slide',
        description = 'How much of drive force will be increased when vehicle slides',
        formula = function(defaultValue, speed, angle, multiplier)
            local result = defaultValue + angle / 15
            return result
        end
    },
    fSteeringLock = {
        label = 'Steering lock multiplier on slide',
        formula = function(defaultValue, speed, angle, multiplier)
            local result = math.max(defaultValue, math.min(defaultValue + angle, 70.0))
            return result
        end
    },
    fTractionCurveMin = {
        label = 'Traction decrease multiplier on slide',
        formula = function(defaultValue, speed, angle, multiplier)
            local result = math.max(defaultValue - angle / 17, 1.0)
            return result
        end
    },
    fDriveBiasFront = {
        label = 'Drive bias multiplier on slide',
        formula = function(defaultValue, speed, angle, multiplier)
            local result = math.max(defaultValue, 0.2)
            return result
        end
    },
}

table.has = function(t, e)
    for _, v in ipairs(t) do
        if e == v then
            return true
        end
    end
    return false
end

table.count = function(t)
    local count = 0
    for _, __ in pairs(t) do
        count = count + 1
    end
    return count
end

table.clone = function(t)
    if type(t) ~= 'table' then return t end

    local meta = getmetatable(t)
    local target = {}

    for k, v in pairs(t) do
        if type(v) == 'table' then
            target[k] = table.clone(v)
        else
            target[k] = v
        end
    end

    setmetatable(target, meta)

    return target
end
