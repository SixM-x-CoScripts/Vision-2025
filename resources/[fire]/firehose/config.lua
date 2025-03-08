Config = {}

--If you dont use esx nor use qbus set UseESX to false and UseQBUS to false
--You can then use the identifier whitelist or the role whitelist

--If you use esx enable this
Config.UseESX = false

--If you use qbus enable this
Config.UseQBUS = false

--Required Job To Use The FireHose
Config.Job = { "lsfd" }

--Standalone identifier whitelist
--Set UseWhitelist To True To Use The Whitelist
Config.UseWhitelist = false
Config.Identifiers = {
    "steam:11000012430xfa",
    "license:1123d12313"
}