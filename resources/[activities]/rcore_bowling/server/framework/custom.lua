CreateThread(function()
    if Config.Framework == 3 then
        PlayerHasMoney = function(serverId, amount)
            print("Checking has money", serverId, amount)
            return true
        end

        PlayerTakeMoney = function(serverId, amount)
            print("Deducting money", serverId, amount)
        end

        PlayerGiveMoney = function(serverId, amount)
            print("Giving money", serverId, amount)
        end

        SendNotification = function(serverId, msg)
            print("Send notification", serverId, msg)
        end
    end
end)