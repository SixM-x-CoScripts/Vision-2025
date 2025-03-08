RegisterNetEvent("core:SetWeaponSave")
AddEventHandler("core:SetWeaponSave", function(token, weapon)
    local source = source
    if CheckPlayerToken(source, token) then 
        if weapon ~= nil then 
            GetPlayer(source):setWeapons(weapon)
            MarkPlayerDataAsNonSaved(source)
        end
    end
end)


RegisterServerCallback("core:GetWeaponSave", function (source, token)
    if CheckPlayerToken(source, token) then
        if GetPlayer(source) == nil then return end
        return GetPlayer(source):getWeapons()
    end
end)