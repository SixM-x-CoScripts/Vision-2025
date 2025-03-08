RegisterNetEvent("core:SetPlayerActiveSkin")
AddEventHandler("core:SetPlayerActiveSkin", function(token, _skin, bool)
    local _src = source
    local ply = GetPlayer(_src)
    ply:getCloths().skin = _skin
    if not bool then
        TriggerClientEvent("core:setSkinPlayer", _src, _skin)
    end
    ply:setNeedSave(true)
    MarkPlayerDataAsNonSaved(_src)
end)

RegisterNetEvent("core:GetCloth")
AddEventHandler("core:GetCloth", function(token)
    if CheckPlayerToken(source, token) then
        TriggerClientEvent("core:GetCloth", source, cloths.data(source))
    else

    end
end)

RegisterNetEvent("core:AddCloth")
AddEventHandler("core:AddCloth", function(token, name, data)
    if CheckPlayerToken(source, token) then
        cloths.addCloth(source, name, data)
    else

    end
end)

RegisterNetEvent("core:RemoveCloth")
AddEventHandler("core:RemoveCloth", function(token, key)
    if CheckPlayerToken(source, token) then
        cloths.removeCloth(source, key)
        MarkPlayerDataAsNonSaved(source)
    else

    end
end)

RegisterNetEvent("core:RenameCloth")
AddEventHandler("core:RenameCloth", function(token, key, name)
    if CheckPlayerToken(source, token) then
        cloths.renameCloth(source, key, name)
        MarkPlayerDataAsNonSaved(source)
    else

    end
end)


RegisterNetEvent("core:GiveCloth")
AddEventHandler("core:GiveCloth", function(token, target, key)
    if CheckPlayerToken(source, token) then
        cloths.give(source, target, key)
        MarkPlayerDataAsNonSaved(source)
        MarkPlayerDataAsNonSaved(target)
    else

    end
end)

CreateThread(function()
    while RegisterServerCallback == nil do Wait(1) end

    RegisterServerCallback("core:getActiveSkin", function(source)
        return GetPlayer(source):getCloths().skin
    end)
end)