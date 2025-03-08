if Config.Framework == "2" then
    QBCore = Config.GetQBCoreObject()
    ESX = {}

    ESX.RegisterUsableItem = function(itemName, callBack)
        QBCore.Functions.CreateUseableItem(itemName, callBack)
    end

    ESX.GetPlayerFromId = function(source)
        local xPlayer = {}
        local qbPlayer = QBCore.Functions.GetPlayer(source)
        ---------
        xPlayer.getGroup = function()
            return QBCore.Functions.GetPermission(source)
        end
        ---------
        xPlayer.addInventoryItem = function(itemName, count)
            qbPlayer.Functions.AddItem(itemName, count, false)
        end
        ---------
        xPlayer.getMoney = function()
            return qbPlayer.Functions.GetMoney("cash")
        end
        ---------
        xPlayer.getAccount = function(type)
            if type == "money" then
                type = "cash"
            end
            return {
                money = qbPlayer.Functions.GetMoney(type) or 0
            }
        end
        ---------
        xPlayer.removeInventoryItem = function(itemName, count)
            qbPlayer.Functions.RemoveItem(itemName, count, false)
        end
        ---------
        xPlayer.addMoney = function(money)
            qbPlayer.Functions.AddMoney("cash", money)
        end
        ---------
        xPlayer.addAccountMoney = function(type, money)
            if type == "money" then
                type = "cash"
            end
            qbPlayer.Functions.AddMoney(type, money)
        end
        ---------
        xPlayer.removeAccountMoney = function(type, money)
            qbPlayer.Functions.RemoveMoney(type, money)
        end
        ---------
        xPlayer.removeMoney = function(money)
            qbPlayer.Functions.RemoveMoney("cash", money)
        end
        ---------
        return xPlayer
    end
end