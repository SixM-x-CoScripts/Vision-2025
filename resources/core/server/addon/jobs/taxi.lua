RegisterNetEvent("core:taxiEndPnj")
AddEventHandler("core:taxiEndPnj", function(token, totalMoney)
    local _totalMoney = tonumber(totalMoney)
    if CheckPlayerToken(source, token) then
        AddMoneyToSociety(totalMoney, "taxi")
    else
        --TODO: Ac detection
    end
end)
