local AllZoneSafe = {}

RegisterNetEvent('core:admin:createZoneSafe')
AddEventHandler('core:admin:createZoneSafe', function(name, pos)
    local source = source
    if GetPlayer(source):getPermission() < 2 then return end
    local safeZone = {
        pos = pos
    }
    AllZoneSafe[name] = safeZone
    TriggerClientEvent('core:createZoneSafe', -1, name, pos)

    MySQL.Async.execute('INSERT INTO safe_zone (name, pos) VALUES (@name, @pos)', {
        ['@name'] = name,
        ['@pos'] = json.encode(pos)
    })

end)

RegisterNetEvent('core:admin:deleteZoneSafe')
AddEventHandler('core:admin:deleteZoneSafe', function(name)
    AllZoneSafe[name] = nil
    TriggerClientEvent('core:deleteZoneSafe', -1, name)

    MySQL.Async.execute('DELETE FROM safe_zone WHERE name = @name', {
        ['@name'] = name
    })

end)


Citizen.CreateThread(function()

    MySQL.Async.fetchAll('SELECT * FROM safe_zone', {}, function(result)
        for k,v in pairs(result) do
            local oldPos = json.decode(v.pos)
            AllZoneSafe[v.name] = {
                pos = oldPos
            }
        end
    end)

    Wait(3000)

    RegisterServerCallback('core:admin:getAllZoneSafe', function()
        return AllZoneSafe
    end)

end)