ActiveHalloween = false

RegisterCommand("startZombie", function(source)
    if source ~= 0 then 
        local ply = GetPlayer(source)
        if ply:getPermission() > 4 then
            ActiveHalloween = true
            TriggerClientEvent("core:event:halloween:setped", source)
            TriggerClientEvent("__atoshi::createNotification", source, {
                type  = 'ABSOLUTE',
                name  = "ABSOLUTE",
                content = "Mode zombie démarré.",
                typeannonce = "ADMINISTRATION",
                labeltype = "EVENT",
                duration = 10,
            })
        end
    end
end)

RegisterNetEvent("core:event:resetPed", function()
    ActiveHalloween = false
    for k,v in pairs(GetPlayers()) do 
        removeTemporaryItems(v)
    end
    TriggerClientEvent("core:event:resetPed", -1)
    TriggerClientEvent("__atoshi::createNotification", source, {
        type  = 'ABSOLUTE',
        name  = "ABSOLUTE",
        content = "Mode zombie terminé.",
        typeannonce = "ADMINISTRATION",
        labeltype = "EVENT",
        duration = 10,
    })
end)

-- core:event:getPedModel
RegisterServerCallback("core:event:getPedModel", function(source, plyid)
    local ped = GetPlayerPed(plyid)
    if not ped then return {Pedmodel = 0, Active = ActiveHalloween} end
    local model = GetEntityModel(ped)
    return {Pedmodel = model, Active = ActiveHalloween}
end)