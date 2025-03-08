Config = {}

Config.TimeFormat = 2 -- 0 = ZULU (UTC), 1 = In Game Time, 2 = OS TIME (Local Time)
Config.DateFormat = 1 -- 0 = MM/DD/YY, 1 = DD/MM/YY, 2 = YY/MM/DD, 3 = DD-Mon-YYYY

Config.PlaySounds = true
Config.PlayCameraMovementSounds = true -- If true, sounds will be played when you move the helicopter camera
Config.DisablePoliceScanner = true -- If true, disables the police radio/scanner/dispatch sounds.
Config.DisableFlightMusic = true -- If true, the ambiant flight music will be disabled.

Config.CameraTransition = true -- If true, the camera will ease when you enter/exit the camera
Config.CameraTransitionTime = 1000 -- The time the transition/ease will take.

Config.DefaultCameraTimecycle = false -- "modiferName" or false. If set to a modifer name (string) then all helicopters will have this timecycle effect unless spesifed under the model inside the Config.Helicopters table ("CAMERA_BW", "CAMERA_secuirity", "secret_camera" or any valid timecycle: https://wiki.rage.mp/index.php?title=Timecycle_Modifiers)
Config.DefaultCameraTimecycleStrength = 0.5 -- number, 0.0 to 1.0.

Config.ShowLatitudeLongitude = false -- If set to true, it shows latitude/longitude, otherwise it shows the street and area
Config.TargetMaxReach = 424.0 -- The longest distance we can target an entity (424 is the regular culling dist for a player, you won't ever be able to practically reach this long anyway)

Config.ForceCameraLabel = false -- false or "Label"
Config.CanUseAnyHelicopter = false -- If true, any helicopter can be used, if false, only helicopters in the Config.Helicopters table are allowed.

Config.AllowCameraLock = true -- If true, the camera can lock onto the ground/targets
Config.InstantCameraLock = false -- If true, the camera will immediately lock on to the target instead of requiering a grace period
Config.AllowCameraLockOnGround = true -- If true, the camera can lock onto the ground/buildings etc.
Config.CameraLockBreakTicks = 3 -- The maximum amount of ticks the camera can lose visual of the point/person/vehicle before it breaks.
-- If true, when locking onto an entity it will lock to the center of it, if false the camera locks onto the part of the entity you were aiming at right before locking.
Config.LockOntoCenter = {
    Peds = true, -- It has a tendency to not work perfectly when this is false.
    Vehicles = false
}

Config.ShowLicensePlate = true -- (LPL)
Config.CheckLicensePlateAngle = true -- If true, it checks the angle between the helicopter camera and the plate. This reasults in player beeing unable to get a license plate read when the camera can't clearly see the plate.
Config.OnlyShowPlateIfLocked = false -- If true, the plate will only be showed if we have a lock on the vehicle.

Config.WhitelistedJobs = false -- If false, the script doesn't check for jobs. If you want to check for jobs add a table where the job is the key, and the value is the job level like so: Config.WhitelistedJobs = { ['police'] = 2, ['ambulance'] = 5 }
Config.ShowMessageIfWrongJob = true -- If true, it will display an error message of you attempt to enter the camer without the right job, if false no message, just won't allow you to enter

-- false = Anyone can use the camera (including the pilot), 1 = Any passanger (not pilot) can use the camera, 2 = Only rear passangers can use the camera
Config.PassengerOnly = true

Config.ShowPostalCodes = false -- Shows postals while in the camera (This is a little resource heavy)
Config.PostalResource = "nearest-postal" -- The resource the postal file is located in (resource must be loaded before helicam, and the files must be formated like nearest-postal)
Config.PostalFile = "new-postals.json" -- MUST be a JSON file! (Note: The file must be loaded inside the fxmanifest of Config.PostalResource for the helicam script to be able to read it)

-- Adds a audio sumbix while in a helicopter/plane (noise suppression) (NOTE: Get's applied to all helicopters/planes, not just the ones with a camera)
Config.UseSubmix = false
Config.NoSubmixInCamera = false -- Only applys if Config.UseSubmix is set to true, if true, this will stop the submix when you are using the camera

-- If true, players will be able to rappel from helicopters that support it.
Config.AllowRappelling = true
Config.RappellingTimeout = 1000 -- The time in ms that you have to press the rappel button again (so people don't accidentally rappel)
Config.MaxRappellingHight = 35.0 -- At any higher then 35.0 players might fall off the rope as the game has a hardcoded cap around 30.0 - 40.0 meters.

-- If the script should add chat suggestions for some of the chat commands.
Config.AddChatSuggestions = false

-- Spotlight
Config.AllowSpotlight = true
Config.MaxAmountOfSpotlights = false -- false or number, set's the maximum amount of spotlights that are allowed on the server at any given time (global limit)
Config.Spotlight = {
    Colour = { R = 255, G = 255, B = 255 }, -- The RGB colour values of the spotlight, you can for example make it slightly more blue like so: { R = 220, G = 220, B = 255 }
    MaxDistance = 600.0,                    -- The maximum distance the spotlight will glow
    DefaultBrightness = 5.0,                -- The defult brightness of the spotlight
    MinBrightness = 0.5,                    -- The minimum brightness of the spotlight
    MaxBrightness = 15.0,                   -- The maximum brightness of the spotlight
    BrightnessIncrements = 0.75,            -- How much to change the brightness of the spotlight when adjusting it
    Roundness = 2.0,                        -- The "roundness" of the spotlight
    DefaultRadius = 10.0,                   -- The defult radius/size of the spotlight
    MinRadius = 5.0,                        -- The minimum radius of the spotlight
    MaxRadius = 15.0,                       -- The maximum radius of the spotlight
    RadiusIncrements = 0.75,                -- How much to change the radius of the spotlight when adjusting it
    Falloff = 200.0,                        -- 
}

Config.HideMinimap = false
Config.ZoomBarOffset = 20 -- The offset in % from the bottom of the screen the zoom bar will be when the minimap is enabled. (If you have something on the top of your minimap then setting it to 25 usally works well)
Config.TargetBlip = {
    Display = true,
    Sprite = 390,
    Colour = 40
}

Config.AllowNightVision = true
Config.AllowNightVisionDuringDay = false -- If the night vision can be enabeld during the day or not.
Config.AllowThermal = false
Config.ThermalOptions = {
    MaxThickness = 1.0, -- 1.0 = Default GTA, can't see trough much at all. 20.0 = Able to see trough most thin walls, however won't be able to see trough the ground or multiple/thick walls.
    MinNoise = 0.0, -- The minimum amount of background noise
    MaxNoise = 0.1, -- The maximum amount of background noise
    FadeStart = 5000.0, -- How far away (meters) before the "background" fade starts
    FadeEnd = 6000.0, -- How far away (meters) before the "background" fade becomes solid
    CustomColours = true, -- If we should use custom colours for the thermal camera (so it becomes black & white for example). (Colours are set below under Config.ThermalOptions.Colours)
    Colours = {
        VisibleHot = { R = 0.80, G = 0.80, B = 0.80 },
        VisibleWarm = { R = 0.80, G = 0.80, B = 0.80 },
        VisibleBase = { R = 0.80, G = 0.80, B = 0.80 },
        Far = { R = 0.20, G = 0.20, B = 0.20 },
        Near = { R = 0.15, G = 0.15, B = 0.15 }
    }
}

Config.AllowMarkers = true
Config.Marker = {
    MaxAmount = 9, -- Above 9 the number markers should be disabled.
    MaxDrawDistance = 1000.0, -- The furthest distance a marker will be drawn at.
    Circle = {
        Type = 23,
        Scale = 8.0,
        Colour = { R = 230, G = 50, B = 50, A = 200 } -- { R = 110, G = 160, B = 230, A = 200 }
    },
    Number = {
        Display = true, -- Set this to false if you want the max amount of markers the be above 9
        Scale = 6.0,
        Colour = { R = 230, G = 50, B = 50, A = 200 }
    },
    Blip = {
        Display = true, -- Whether to display marker blips
        Number = true, -- Whether to display the number on the blip or not (99 is cap.)
        Sprite = 57,
        Scale = 0.75,
        Colour = 1, -- Red
    }
}

Config.UseAnimProp = true -- If true, players will have a tablet in their hands while using the camera
Config.Tablet = {
    model = -1585232418, -- prop_cs_tablet
    anim = {
        dict = "amb@world_human_seat_wall_tablet@female@base",
        name = "base"
    },
    bone = 57005, -- SKEL_R_Hand
    offset = vector3(0.17, 0.10, -0.13),
    rotation = vector3(20.0, 180.0, 180.0)
}

Config.ShowInstructions = false -- If true, instructions will be showns while you are in the camera
-- Used this website to get the controls (~INPUT_5D25DCCD~ for example): http://tools.povers.fr/hashgenerator/
-- 0 = On the right, 3+ = on the left.
Config.InstructionButtons = {
    -- [0] = { control = "~INPUT_5D25DCCD~", label = "Adjust Spotlight Brightness (scroll +)" },
    -- [1] = { control = "~INPUT_F8C9FB3A~", label = "Adjust Spotlight Radius (scroll +)" },
    -- [2] = { control = "~INPUT_DB481F5~", label = "Lock Camera" }, -- This doesn't work for some reason...
    [0] = { control = "~INPUT_662F7BF5~", label = "Ajouter/Supprimer un marqueur" },
    [1] = { control = "~INPUT_DB471A88~", label = "Cycle Vision" },
    [2] = { control = "~INPUT_3593EB0B~", label = "Projecteur" },
    [3] = { control = "~INPUT_5D25DCCD~", label = "Exit Camera" }
}

-- Speed Units:
-- KTS = Knots (nautical miles per hour)
-- MPH = Miles per hour
-- KMH = Kilometers per hour
-- MPS = Meters per second
-- FPS = Feet per second

-- Distance Units:
-- FT = Feet
-- M = Meters
-- MI = Miles
Config.Units = {
    Speed = "KTS", -- The speed of the helicopter                               (unit type: speed)
    Altitude = "FT", -- The altitude of the helicopter                          (unit type: distance)
    TargetSpeed = "KMH", -- The speed of the target the camera is looking at    (unit type: speed)
    TargetElevation = "FT", -- The elevation of where the camera is aming       (unit type: distance)
    TargetDistance = "M" -- The distance from the helicopter to the target      (unit type: distance)
}

Config.Camera = {
    MovementSpeed = {
        Keyboard = 3.0,
        Controller = 1.0
    },
    Zoom = {
        Max = 50.0,
        Min = 5.0,
        Speed = 5.0
    },
    RotationLimits = {
        Up = 25.0,
        Down = -89.5
    }
}

-- Docs: https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/ -- https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
Config.Keybinds = {
    ToggleCam = {
        Type = "KEYBOARD",
        Key = "E"
    },
    AttemptLock = {
        Type = "KEYBOARD",
        Key = "SPACE"
    },
    CycleVision = {
        Type = "MOUSE_BUTTON",
        Key = "MOUSE_RIGHT"
    },
    ToggleMarker = {
        Type = "MOUSE_BUTTON",
        Key = "MOUSE_MIDDLE"
    },
    Rappel = {
        Type = "KEYBOARD",
        Key = "X"
    },
    Spotlight = {
        Type = "KEYBOARD",
        Key = "G"
    },
    SpotlightBrightness = {
        Type = "KEYBOARD",
        Key = "LMENU"
    },
    SpotlightRadius = {
        Type = "KEYBOARD",
        Key = "LCONTROL"
    },
    Postals = {
        Type = "KEYBOARD",
        Key = ""
    }
}

Config.Localisation = {
    -- Notifications
    Notification = {
        JobNotWhitelisted = "Vous n'avez pas le job requis !",
        JobGrade = "Vous n'êtes pas assez gradé !",
        NoCameraHeli = "Cet hélicoptère n'a pas de caméra !",
        NoCameraPlane = "Cet avion n'a pas de caméra !",
        IsPilot = "Vous ne pouvez pas utiliser de caméra en pilotant !",
        NotInRear = "Tu dois être a l'arrière pour la caméra !",
        CameraInUse = "Quelqu'un utilise déjà la caméra !",
        SpotlightInUse = "Quelqu'un utilise déjà le projecteur !",
        NoSpotlight = "Cet hélicoptère n'a pas de projecteur !",
        SpotlightGlobalLimit = "The global spotlight limit has been reached!",
        CannotRappelFromHeli = "Cet hélicoptère n'a pas de corde de rappel !",
        CannotRappelFromSeat = "Vous ne pouvez pas descendre en rappel de cette place !",
        ToHighToRappel = "Vous êtes trop haut pour descendre en rappel !",
        ConfirmRappel = "Êtes vous sûr de vouloir descendre en rappel ? (Appuyez de nouveau)",
        Rappelling = "Descente en cours !"
    },
    -- Blip Names
    Blip = {
        Target = "Helicam Target",
        Marker = "Helicam Marker"
    },
    -- Keybinding Descriptions
    KeyMapping = {
        ToggleCam = "Activer Camera",
        AttemptLock = "Verrouillage",
        CycleVision = "Cycle Vision",
        ToggleMarker = "Ajouter/Supprimer un marqueur",
        Rappel = "Descente en rappel",
        Spotlight = "Activer Projecteur",
        SpotlightBrightness = "Ajuster Puissance Projecteur",
        SpotlightRadius = "Ajuster Rayon Projecteur",
        Postals = "Toggle Postals"
    },
    ChatSuggestions = {
        ToggleCamera = "Enter/Exit the helicopter camera",
        Rappel = "Rappel from the helicopter"
    }
}

-- Nightvision/Thermal/Spotlight/PassengerOnly etc. can be manually enabled/disabled (overwriten) for each model by adding one or more of following varabels under the model.
-- nightvision = true / false
-- thermalvision = true / false
-- spotlight = true / false
-- passengerOnly = false / 1 / 2 (see Config.PassengerOnly)
-- disableRappelling = true / false
-- timecycle = "modiferName" / false
-- timecycleStrength = 0.0 to 1.0
Config.Helicopters = {
    -- Default (if there is any missing data it will draw it's options from here)
    default = {
        offset = vector3(0.0, 0.0, -1.0),
        -- nightvision = true,        -- These are only needed/used if Config.AllowNightVision or Config.AllowThermal is set to false
        -- thermalvision = true,      -- You can add these to each and every model, adding these and setting them to false disables the vision even if Config.AllowThermal etc. is set to true
        -- spotlight = true,          -- Allows yo overwrite Config.AllowSpotlight on a helicopter to helicopter basis.
        -- passengerOnly = false,     -- Set's who can use the camera based on the seat they are in. (see Config.PassengerOnly)
        -- disableRappelling = false, -- Disables rappelling for the helicopter model, will only make a diffrence when set to true. The helicopter also needs the "FLAG_ALLOWS_RAPPEL" flag too allow you to rappel out of it.
        -- timecycle = "CAMERA_BW",   -- The timecycle modifer name (can be set to false if you want to disable it)
        -- timecycleStrength = 0.5,   -- The strength of the timecycle, defaults to Config.DefaultCameraTimecycleStrength if not included.
        labels = {
            [0] = "FLIR SYSTEMS"
        }
    },
    -- Police Maverick (polmav)
    [353883353] = {
        offset = vector3(0.0, 2.65, -1.0),
        labels = { -- Liveries
            [0] = "LOS SANTOS POLICE DEPARTMENT", -- 0 is default
            [1] = "AIR AMBULANCE"
        }
    },
    -- Maverick (maverick)
    [-1660661558] = {
        offset = vector3(0.0, 3.45, -0.65)
    },
    -- Buzzard Attack Chopper (buzzard)
    [788747387] = {
        offset = vector3(0.0, 2.15, -0.35)
    },
    -- Buzzard (buzzard2)
    [745926877] = {
        offset = vector3(0.0, 2.15, -0.35)
    },
    -- Frogger (frogger)
    [744705981] = {
        offset = vector3(0.0, 3.0, -0.35)
    },
    -- TPI/FIB Frogger (frogger2)
    [1949211328] = {
        offset = vector3(0.0, 3.0, -0.35),
        labels = { -- Liveries
            [0] = "FEDERAL INVESTIGATION BUREAU",
            [1] = "TREVOR PHILIPS ENTERPRISES"
        }
    },
    -- Annihilator/Patriotism and Immigration Authority (annihilator)
    [837858166] = {
        offset = vector3(-0.5, 4.0, -0.35),
        labels = { -- Liveries
            [0] = "NATIONAL OFFICE OF SECURITY ENFORCMENT"
        }
    },
    -- Valkyrie (valkyrie)
    [-1600252419] = {
        offset = vector3(0.0, 4.0, -1.15),
        labels = { -- Liveries
            [0] = "UNITED STATES ARMY"
        }
    },
    -- Avenger (avenger)
    [-2118308144] = {
        offset = vector3(0.0, 9.45, -2.45),
        labels = { -- Liveries
            [0] = "UNITED STATES MARINES"
        }
    },
    -- LSPDMAV
    [-699926421] = {
        offset = vector3(0.0, 2.65, -1.0),
        labels = { -- Liveries
            [0] = "CIVIL",
            [1] = "LOS SANTOS POLICE DEPARTMENT",
            [2] = "LOS SANTOS FIRE DEPARTMENT",
            [3] = "SAN ANDREAS MEDICAL SERVICE",
            [4] = "LOS SANTOS SHERIFF DEPARTMENT",
        }
    },
    -- Valkyrie (valkyrie)
    [1407316096] = {
        offset = vector3(0.0, 4.0, -1.15),
        labels = { -- Liveries
            [0] = "LSPD - SWAT"
        }
    },
    -- EMSSWIFT
    [-40598623] = {
        offset = vector3(0.0, 4.0, -1.15),
        labels = { -- Liveries
            [0] = "SAN ANDREAS MEDICAL SERVICE",
            [1] = "LOS SANTOS FIRE DEPARTMENT"
        }
    },
    -- NEWSMAV
    [-1470089635] = {
        offset = vector3(0.0, 2.65, -1.0),
        labels = { -- Liveries
            [0] = "WEAZEL NEWS",
        }
    },
    -- AS332
    [1290625056] = {
        offset = vector3(0.0, 4.0, -1.15),
        labels = { -- Liveries
            [0] = "LOS SANTOS SHERIFF DEPARTMENT",
            [1] = "LSSD - SEB",
            [2] = "LOS SANTOS FIRE DEPARTMENT",
            [3] = "U.S BORDER PATROL"
        }
    },
    -- Buzzard (buzzard4)
    [686516684] = {
        offset = vector3(0.0, 2.15, -0.35),
        labels = { -- Liveries
            [0] = "USSS / USBP",
        }
    },

    -- Example of custom helicopter:
    -- Emergency Maverick AS350 (eheli)
    -- [`eheli`] = {
    --     offset = vector3(0.0, 3.0, -1.15),
    --     labels = { -- Liveries
    --         [0] = "LOS SANTOS POLICE DEPARTMENT",
    --         [1] = "SAN ANDREAS HIGHWAY PATROL",
    --         [2] = "BLAIN COUNTY SHERIFF OFFICE",
    --         [3] = "SAN ANDREAS FIRE DEPARTMENT"
    --     }
    -- },
    -- You can also do GetHashKey("eheli") instead of `eheli`
    -- Here is a guide if you need more help: https://madsl.gitbook.io/docs/resources/helicopter-camera/adding-custom-helicopters
}
