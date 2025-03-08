PlayersVIP = {}
function IsPlayerVIP(src)
    local license = GetLicense(src)
    return PlayersVIP[license]
end

SWRegisterServCallback("sw:casino:IsPlayerVIP", function(source, cb)
    local isvip = CasinoConfig.IsPlayerVIP(source)
    cb(isvip)
end)