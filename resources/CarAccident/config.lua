Config = {}

-- Amount of Time to Blackout, in milliseconds
Config.BlackoutTime = 1000

Config.EffectTimeLevel1 = 4
Config.EffectTimeLevel2 = 9
Config.EffectTimeLevel3 = 16
Config.EffectTimeLevel4 = 21
Config.EffectTimeLevel5 = 27

-- Enable blacking out due to speed deceleration -- Multiply by 1.609 to convert to KM/h
-- If a vehicle slows down rapidly over this threshold, the player blacks out
Config.BlackoutSpeedRequiredLevel1 = 40 -- 65 KM/h
Config.BlackoutSpeedRequiredLevel2 = 70 -- 112 KM/h
Config.BlackoutSpeedRequiredLevel3 = 110 -- 177 KM/h
Config.BlackoutSpeedRequiredLevel4 = 120 -- 193 KM/h
Config.BlackoutSpeedRequiredLevel5 = 130 -- 210 KM/h

-- Multiplier of screen shaking strength
Config.ScreenShakeMultiplier = 0.05
