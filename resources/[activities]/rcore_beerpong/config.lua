Config = {}

-- will enable debug
Config.Debug = false

-- Choose your framework
-- 0 = standalone
-- 1 = esx
-- 2 = qbcore
Config.Framework = 0

-- 0 = none
-- 1 = int system drunk
-- 2 = esx_status
-- 3 = qbcore drunk
-- 4 = rcore_drunk
-- you can buy it here: https://store.rcore.cz/package/5161129
Config.DrunkSystem = "1"

-- Will remove cups if no one near
Config.RemoveCupsIfNoOneNear = false

-- locales
Config.Locale = "en"

-- will disable the camera above player and use only real player camera
-- because anticheats.
Config.DisableAimCamera = false

-- how many beer pong items can player have it the resource is on standalone?
Config.BeerPongInventory = 2

--- drunk system

-- interval when we remove the % from drunk status?
Config.IntervalForDrunk = 3000

-- how much % we will take when the interval hit?
Config.DrunkTakeAfterTime = 1 -- 1 = 1%

--- How many percent player need to be
--- drunk to random events in vehicle happens?
Config.MinimumDrunkPercentageForVehicle = 40.0

--- How many percent chance is there to vehicele random event? in %
Config.ChanceForVehicleEvent = 50.0

--- How many percent player need to be
--- drunk for falling to ground randomly?
Config.MinimumDrunkPercentageForFalling = 25.0

--- How many percent chance is there to fall? in %
Config.ChanceForFalling = 60.0

--- How much drunk player has to be for hearing echo?
Config.MinimumDrunkPercentageForEcho = 50.0

--- Maximum drunk level? if player hits this value he will fall to the ground
--- and be unconscious
Config.MaximumDrunkPercentage  = 95.0

-- Esx event name?
Config.ESX = "esx:getSharedObject"

-- item name
Config.ItemName = "cups"

-- Can only author of the game quit the game?
Config.OnlyAuthorCanQuit = true

-- admin groups who will be able to remove any on going beer pong game
Config.AllowedGroups = {
    god = true,
    admin = true,
    superadmin = true,
}

-- Marker size
Config.MarkerSize = 1.0

-- Marker size
Config.MarkerSize = 1.0

-- Marker type
Config.MarkerType = 1

-- Marker color
Config.MarkerColor = {
    R = 255,
    G = 125,
    B = 125,
    A = 100,
}

-- key map
Config.KeyMap = {
    RemoveGame = {
        KeyCode = 47,
        KeyChar = "G",
        KeySymbol = "~INPUT_DETONATE~",
    },
    JoinGame = {
        KeyCode = 38,
        KeyChar = "E",
        KeySymbol = "~INPUT_CONTEXT~",
    },
    PlaceCup = {
        KeyCode = 38,
        KeyChar = "E",
        KeySymbol = "~INPUT_CONTEXT~",
    },
    ReturnBackToMenu = {
        KeyCode = 177,
        KeyChar = "back",
        KeySymbol = "~INPUT_CELLPHONE_CANCEL~",
    },
}

local boxOffset = vector3(1.0, 0.5, 0.0)
local pyramideOffset = vector3(0.3, 0.4, 0.0)

local rectangleOffset = vector3(0.5, 0.5, 0.0)
local smallBoxOffset = vector3(0.5, 0.25, 0.0)

-- Prefab for the beerpong
Config.GameSetups = {
    {
        Label = "Big box",
        Order = 1,
        Cups = {
            vector3(0.5, 0, 0) - boxOffset,
            vector3(1.0, 0, 0) - boxOffset,
            vector3(1.5, 0, 0) - boxOffset,

            vector3(0.5, 0.5, 0) - boxOffset,
            vector3(1.0, 0.5, 0) - boxOffset,
            vector3(1.5, 0.5, 0) - boxOffset,

            vector3(0.5, 1, 0) - boxOffset,
            vector3(1.0, 1, 0) - boxOffset,
            vector3(1.5, 1, 0) - boxOffset,
        },
    },
    {
        Label = "Wings",
        Order = 2,
        Cups = {
            vector3(0, 0, 0),
            vector3(0, 0.5, 0),
            vector3(0.5, 1, 0),
            vector3(1, 1.5, 0),
            vector3(1.5, 2, 0),
            vector3(2.0, 2.5, 0),

            vector3(0, -0.5, 0),
            vector3(0.5, -1, 0),
            vector3(1, -1.5, 0),
            vector3(1.5, -2, 0),
            vector3(2.0, -2.5, 0),
        },
    },
    {
        Label = "Pyramide",
        Order = 3,
        Cups = {
            vector3(0, 0.0, 0) - pyramideOffset,
            vector3(0, 0.2, 0) - pyramideOffset,
            vector3(0, 0.4, 0) - pyramideOffset,
            vector3(0, 0.6, 0) - pyramideOffset,
            vector3(0, 0.8, 0) - pyramideOffset,

            vector3(0.2, 0.1, 0) - pyramideOffset,
            vector3(0.2, 0.3, 0) - pyramideOffset,
            vector3(0.2, 0.5, 0) - pyramideOffset,
            vector3(0.2, 0.7, 0) - pyramideOffset,

            vector3(0.4, 0.2, 0) - pyramideOffset,
            vector3(0.4, 0.4, 0) - pyramideOffset,
            vector3(0.4, 0.6, 0) - pyramideOffset,

            vector3(0.6, 0.3, 0) - pyramideOffset,
            vector3(0.6, 0.5, 0) - pyramideOffset,

            vector3(0.8, 0.4, 0) - pyramideOffset,
        },
    },
    {
        Label = "Rectangle",
        Order = 4,
        Cups = {
            vector3(0.25, 0, 0) - rectangleOffset,
            vector3(0.5, 0, 0) - rectangleOffset,
            vector3(0.75, 0, 0) - rectangleOffset,

            vector3(0.25, 0.5, 0) - rectangleOffset,
            vector3(0.5, 0.5, 0) - rectangleOffset,
            vector3(0.75, 0.5, 0) - rectangleOffset,

            vector3(0.25, 1, 0) - rectangleOffset,
            vector3(0.5, 1, 0) - rectangleOffset,
            vector3(0.75, 1, 0) - rectangleOffset,
        },
    },
    {
        Label = "Small box",
        Order = 5,
        Cups = {
            vector3(0.25, 0, 0) - smallBoxOffset,
            vector3(0.5, 0, 0) - smallBoxOffset,
            vector3(0.75, 0, 0) - smallBoxOffset,

            vector3(0.25, 0.25, 0) - smallBoxOffset,
            vector3(0.5, 0.25, 0) - smallBoxOffset,
            vector3(0.75, 0.25, 0) - smallBoxOffset,

            vector3(0.25, 0.5, 0) - smallBoxOffset,
            vector3(0.5, 0.5, 0) - smallBoxOffset,
            vector3(0.75, 0.5, 0) - smallBoxOffset,
        },
    },

    {
        Label = "Small box + table",
        Order = 6,
        PropTable = GetHashKey("prop_table_02"),
        Cups = {
            vector3(0.25, 0, 0) - smallBoxOffset,
            vector3(0.5, 0, 0) - smallBoxOffset,
            vector3(0.75, 0, 0) - smallBoxOffset,

            vector3(0.25, 0.25, 0) - smallBoxOffset,
            vector3(0.5, 0.25, 0) - smallBoxOffset,
            vector3(0.75, 0.25, 0) - smallBoxOffset,

            vector3(0.25, 0.5, 0) - smallBoxOffset,
            vector3(0.5, 0.5, 0) - smallBoxOffset,
            vector3(0.75, 0.5, 0) - smallBoxOffset,
        },
    },
}

-- qbcore shared object
Config.GetQBCoreObject = function()
    local objectType = 1
    --------------------------
    if objectType == 1 then
        return exports['qb-core']:GetCoreObject()
    end
    --------------------------
    if objectType == 2 then
        local QBCore = nil
        local breakPoint = 0
        while not QBCore do
            Wait(100)
            TriggerEvent("QBCore:GetObject", function(obj)
                QBCore = obj
            end)

            breakPoint = breakPoint + 1
            if breakPoint == 25 then
                print(string.format("^1[%s]^7 Could not load the sharedobject, are you sure it is called ^1˙QBCore:GetObject˙^7?", GetCurrentResourceName()))
                break
            end
        end

        return QBCore
    end
    --------------------------
    if objectType == 3 then
        return exports['qb-core']:GetSharedObject()
    end
    --------------------------
end

-- Do not change
Config.RollingResistance = 1.0

Config.Gravity = vector3(0.0, 0.0, -9.0)

Config.Drag = 0.55

Config.BallElasticity = 0.87

Config.GroundBounceEnergyLoss = 1.06

Config.StopHorizontalBounceTreshold = 1.9