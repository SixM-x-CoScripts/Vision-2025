Config = {}

-- locales lang
Config.Locale = "en"

-- enable blip on map?
Config.EnableBlip = false

-- 0 is standalone
-- 1 is ESX
-- 2 is qbcore
Config.FrameWork = 0

Config.ESX = 'esx:getSharedObject'

-- in default how many players will have pocket pianos if framework is on "standalone"?
Config.DefaultPocketPianoCount = 2

-- Blip settings
Config.BlipOption = {
    sprite = 514,
    name = "piano",
    type = 4,
    scale = 1.0,
    shortRange = true,
}

-- Spawn positions of the piano
Config.PositionOfPiano = {
    [1] = {
        pos = vector3(226.98, -882.73, 30.35),
        heading = -150.0,
        distance = 25.0,
    },
    --[[ [2] = {
        pos = vector3(684.04, 568.77, 130.35),
        heading = 70.0,
        distance = 25.0,
    }, ]]
}

-- Debug
Config.Debug = false

-- default hear distance?
Config.DefaultDistance = 25

-- Simulate 3D sound?
Config.SoundFallDown = false

-- just name for volume
Config.PrefixLabel = "Piano volume "

-- distance for music volume
Config.DistanceSound = 15

-- list of default music
Config.RecordedMusic = {
    ["Keyboard cat!"] = KeyBoardCat,
    ["Doctor"] = Doctor,
    ["Mortal Kombat Theme"] = MortalKombat,
    ["Gravity Falls"] = GravityFalls,
    ["Coffin Dance"] = CoffinDance,
}

Config.OnPlayerMountedPiano = function()
    --[[
    local ped = PlayerPedId()
    local dict, anim = "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle"

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(33)
    end

    TaskPlayAnim(ped, dict, anim, 8.0, 1.0, -1, 16, 0.0, false, false, false)
    --]]

    Animation.ResetAll()
    Animation.Play("type")
end

-- list of custom sound for keyboard
Config.ToneTypes = {
    {
        name = "classic",
        label = "Classic piano tone",
    },
    {
        name = "ele",
        label = "Eletric piano tone",
    },
    {
        name = "poly_synth",
        label = "Poly Synth",
    },
}

-- do not touch, for debug purpose only.
Config.NoLocalSound = false

-- do not touch, for debug purpose only.
Config.OpenPianoOnStartScript = false