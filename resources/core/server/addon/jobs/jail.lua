local jailTable = {}

MySQL.ready(function()
    MySQL.Async.fetchAll('SELECT * FROM players_jail', {}, function(result)
        for k,v in pairs(result) do
            jailTable[v.player_id] = {
                time = v.jail_time,
                startTime = os.time()
            }
        end
    end)
end)

function JailPlayer(playerId, jailTime, callback)
    if GetPlayer(playerId) == nil then
        if source ~= 0 then
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = 'ROUGE',
                content = "Le joueur n'est pas connecté."
            })
        end
        if callback then callback(false) end
        return
    end

    local idBdd = GetPlayer(playerId):getId()
    
    local result = MySQL.Sync.fetchAll('SELECT * FROM players_jail WHERE player_id = @player_id', {
        ['@player_id'] = idBdd
    })

    if result[1] then
        MySQL.Async.execute('UPDATE players_jail SET jail_time = @jail_time WHERE player_id = @player_id', {
            ['@player_id'] = idBdd,
            ['@jail_time'] = jailTime
        })
    else
        MySQL.Async.execute('INSERT INTO players_jail (player_id, jail_time) VALUES (@player_id, @jail_time) ON DUPLICATE KEY UPDATE jail_time = @jail_time', {
            ['@player_id'] = idBdd,
            ['@jail_time'] = jailTime
        })
    end

    if callback then callback(true) end
    TriggerClientEvent('jail:sendToJail', playerId, jailTime)
end

function checkIfPlayerIsInJail(source)
    local idBdd = GetPlayer(source):getId()
    if idBdd == nil then return end
    if jailTable[idBdd] then
        JailPlayer(source, jailTable[idBdd].time)
    end
end

RegisterServerEvent('jail:releasePlayer')
AddEventHandler('jail:releasePlayer',function()
    ReleasePlayer(source)
end)

function ReleasePlayer(playerId, callback)
    local idBdd = GetPlayer(playerId):getId()
    
    MySQL.Async.execute('DELETE FROM players_jail WHERE player_id = @player_id', {
        ['@player_id'] = idBdd
    })

    jailTable[idBdd] = nil

    if callback then callback(true) end
    TriggerClientEvent('jail:releaseFromJail', playerId)
end

RegisterCommand("jail", function(source, args, rawCommand)
    if source == 0 or GetPlayer(source):getPermission() >= 5 then
        local targetId = tonumber(args[1])
        local jailTime = tonumber(args[2])

        if targetId == -1 then return end

        if jailTime > 360 then
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = 'ROUGE',
                content = "Vous ne pouvez pas emprisonner quelqu'un pour plus de 6 heures."
            })
        elseif targetId and jailTime then
            JailPlayer(targetId, (jailTime*60))
        else
            print("Usage: /jail [playerId] [time]")
        end
    else
        TriggerClientEvent("__atoshi::createNotification", source, {
            type = 'ROUGE',
            content = "Vous n'avez pas la permission d'utiliser cette commande."
        })
    end
end, false)

RegisterCommand("unjail", function(source, args, rawCommand)
    if source == 0 or GetPlayer(source):getPermission() >= 4 then
        local targetId = tonumber(args[1])
        if targetId then
            ReleasePlayer(targetId)
        else
            print("Usage: /unjail [playerId]")
        end
    else
        TriggerClientEvent("__atoshi::createNotification", source, {
            type = 'ROUGE',
            content = "Vous n'avez pas la permission d'utiliser cette commande."
        })
    end
end, false)

RegisterServerEvent('core:saveJailTime')
AddEventHandler('core:saveJailTime',function(idBdd)
    saveJailTime(idBdd)
end)

function saveJailTime(idBdd)
    if jailTable[idBdd] then
        MySQL.Async.execute('UPDATE players_jail SET jail_time = @jail_time WHERE player_id = @player_id', {
            ['@player_id'] = idBdd,
            ['@jail_time'] = jailTable[idBdd].time - (os.time() - jailTable[idBdd].startTime)
        })
        jailTable[idBdd] = {
            time = jailTable[idBdd].time - (os.time() - jailTable[idBdd].startTime),
            startTime = os.time()
        }
    end
end
