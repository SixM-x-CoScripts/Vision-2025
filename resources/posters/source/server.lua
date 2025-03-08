RegisteredSprays = {}

RegisterNetEvent("posters:addNewImage", function(data)
    local _source = source
    RegisteredSprays[#RegisteredSprays+1] = data
    TriggerClientEvent("posters:sendAddedImage", -1, data)
end)

RegisterNetEvent("posters:deleteImage", function(id, isOwner)
    for k,v in pairs(RegisteredSprays) do
        if v.id == id then
            table.remove(RegisteredSprays, k)
            TriggerClientEvent("posters:deleteClientImage", -1, id)
        end
    end
end)

RegisterCommand("removeposter", function(source, args, raw)
    TriggerClientEvent("posters:removePoster", source)
end)