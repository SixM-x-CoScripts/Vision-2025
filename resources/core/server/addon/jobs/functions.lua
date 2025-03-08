LimitJobInterim = {}
RegisterServerCallback("core:getInterimJobLimit", function(source)
    local lic = GetLicense(source)
    local returnLimit = LimitJobInterim[lic]
    if not LimitJobInterim[lic] then
        LimitJobInterim[lic] = 1
    else
        LimitJobInterim[lic] = LimitJobInterim[lic] + 1
    end
    return returnLimit
end)
