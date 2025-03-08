function PayWithMoney(source, type, money)
    if Config.Framework == "0" then
        return true
    end

    local xPlayer = ESX.GetPlayerFromId(source)
    if type == "money" then
        if xPlayer.getMoney() >= money then
            xPlayer.removeMoney(money)
            return true
        end
    end

    if type == "bank" then
        if xPlayer.getAccount('bank').money >= money then
            xPlayer.removeAccountMoney('bank', money)
            return true
        end
    end

    return false
end