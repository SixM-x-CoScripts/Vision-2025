-- Simulation de class juste pour s'organiser correctement
cloths = {
    data = function(source)
        return GetPlayer(source):getCloths()
    end,

    addCloth = function(source, name, data) -- Player only
        table.insert(GetPlayer(source):getCloths().cloths, {name = name, data = data})
        triggerEventPlayer("core:addClothPlayer", source, name, data)
        --RefreshPlayerData(source)
    end,

    removeCloth = function(source, key)
        table.remove(GetPlayer(source):getCloths().cloths, key)
        triggerEventPlayer("core:removeClothPlayer", source, key)
        --RefreshPlayerData(source)
    end,

    renameCloth = function(source, key, name)
        GetPlayer(source):getCloths().cloths[key].name = name
        triggerEventPlayer("core:renameClothPlayer", source, key, name)
        --RefreshPlayerData(source)
    end,

    give = function(source, target, key)
        local data = GetPlayer(source):getCloths().cloths[key]
        cloths.addCloth(target, data.name, data.data)
        cloths.removeCloth(source, key)
        --TriggerClientEvent("core:ShowNotification", source, "Vous avez donné ~g~"..data.name.."~s~")
        TriggerClientEvent("__atoshi::createNotification", source, {
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez donné ~s" .. data.name
        })
        --TriggerClientEvent("core:ShowNotification", target, "Vous avez reçu ~g~"..data.name.."~s~")
        TriggerClientEvent("__atoshi::createNotification", target, {
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez reçu ~s " .. data.name
        })
    end,

    transferToInv = function(source, inv, key)
        local data = GetPlayer(source):getCloths().cloths[key]
        table.insert(inv, {name = data.name, data = data.data})
        cloths.removeCloth(source, key)
        --RefreshPlayerData(source)
        --TriggerClientEvent("core:ShowNotification", source, "Vous avez rangé ~g~"..data.name.."~s~")
        TriggerClientEvent("__atoshi::createNotification", source, {
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez rangé ~s " .. data.name
        })
    end,    

    transferFromInvToPlayer = function(source, inv, key)
        local data = inv[key]
        cloths.addCloth(source, data.name, data.data)
        inv[key] = nil
        --RefreshPlayerData(source)
        --TriggerClientEvent("core:ShowNotification", source, "Vous avez reçu ~g~"..data.name.."~s~")
        TriggerClientEvent("__atoshi::createNotification", source, {
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez reçu ~s " .. data.name
        })
    end,
}