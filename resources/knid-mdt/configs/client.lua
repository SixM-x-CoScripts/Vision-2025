Config = Config or { }

--- The URL of the MDT (should include https://)
--- @type string
Config.Url = 'https://vision.lspd-mdt.com'

--- This is the command to open the MDT (F8 → +mdt and used for the RegisterKeyMapping)
--- @type string
-- Config.Command = '+mdt'

--- This is the key to open the MDT, used in RegisterKeyMapping
--- @type string
Config.Key = 'F11'

--- If true, the animation will be played when the MDT is opened
--- @type boolean
Config.AnimationEnabled = true

--- If true, the tablet prop will be created when the MDT is opened
--- @type boolean
Config.PropEnabled = true