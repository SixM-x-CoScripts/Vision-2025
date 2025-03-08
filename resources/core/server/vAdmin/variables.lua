RegisterServerCallback("core:loadVariables", function(source)
    return server_variables
end)

RegisterServerCallback("core:variables:selec", function(source, typevar)
    return server_variables[typevar] or {}
end)

RegisterNetEvent('core:updateVariable')
AddEventHandler('core:updateVariable', function(token, name, value)
    local _src = source
    local ply = GetPlayer(_src)
    if ply:getPermission() < 3 then
        TriggerClientEvent("__atoshi::createNotification", _src, {
            type = 'ROUGE',
            content = "Vous n'avez pas la permission de faire cela."
        })
        return
    end

    if not CheckPlayerToken(_src, token) then return end

    print("Updating variable " .. name)

    SetVariable(name, value)
    TriggerLatentClientEvent('core:updateVariable', -1, 15000, name, value)
end)

RegisterNetEvent("core:updateVariables", function(value)
    local src = source
    local ply = GetPlayer(src)
    if ply:getPermission() < 4 then
        TriggerClientEvent("__atoshi::createNotification", src, {
            type = 'ROUGE',
            content = "Vous n'avez pas la permission de faire cela."
        })
        return
    end
    UpdateVariables(value)
    TriggerClientEvent("__atoshi::createNotification", src, {
        type = 'VERT',
        content = "Les variables ont été changées."
    })
end)
