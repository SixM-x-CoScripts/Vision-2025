RegisterServerEvent('vangelicoheist:server:lootSync')
AddEventHandler('vangelicoheist:server:lootSync', function(_type, index)
    TriggerClientEvent('vangelicoheist:client:lootSync', -1, _type, index)
end)

RegisterNetEvent("core:ChangeHeistsLimitByID")
AddEventHandler("core:ChangeHeistsLimitByID", function (token, id, action)
    if CheckPlayerToken(source, token) then
        local player = GetPlayer(tonumber(id))
        if player then
            local playerLicense = player:getLicense()
            local limitsKey = 'heistsLimitPerReboot_'..playerLicense

            if GlobalState[limitsKey] == nil or action == "reset" then
                GlobalState[limitsKey] = {
                    atm = 0,
                    atmScie = 0,
                    hook = 0,
                    superette = 0,
                    binco = 0,
                    raquette = 0,
                    volArrache = 0,
                    gofast1 = 0,
                    gofast2 = 0,
                    fleeca = 0,
                    brinks = 0,
                    vangelico = 0,
                }
                if action == "reset" then
                    print("Resetting Heists Limit for ID: " .. playerLicense)
                    TriggerClientEvent("__atoshi::createNotification", player:getSource(), {
                        type = 'VERT',
                        content = "Votre limite de braquage illégaux a été réinitialisé !"
                    })
                    return
                end
            end

            local actionMap = {
                atm = "atm",
                atmScie = "atmScie",
                hook = "hook",
                superette = "superette",
                binco = "binco",
                raquette = "raquette",
                volArrache = "volArrache",
                gofast1 = "gofast1",
                gofast2 = "gofast2",
                fleeca = "fleeca",
                brinks = "brinks",
                vangelico = "vangelico",
            }
            
            if actionMap[action] then
                print("Change " .. actionMap[action] .. " Limit for ID: " .. playerLicense)
                local saveHeistsLimitPerReboot = GlobalState[limitsKey]
                saveHeistsLimitPerReboot[actionMap[action]] = saveHeistsLimitPerReboot[actionMap[action]] + 1
                GlobalState[limitsKey] = saveHeistsLimitPerReboot
            end
        end
    end
end)

HouseHeist = {}

CreateThread(function()
    while RegisterServerCallback == nil do Wait(0) end
    RegisterServerCallback("core:heist:hasBraqued", function(source, token, id)
        if CheckPlayerToken(source, token) then
            return HouseHeist[source] and HouseHeist[source][id] or false
        end
    end)
end)

RegisterNetEvent("core:braquedHouse", function(token, id)
    local src = source
    if CheckPlayerToken(src, token) then
        if not HouseHeist[src] then
            HouseHeist[src] = {}
            HouseHeist[src][id] = true
        else
            HouseHeist[src][id] = true
        end
    end
end)