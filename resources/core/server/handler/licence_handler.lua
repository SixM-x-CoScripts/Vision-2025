-- @Callbacks
Citizen.CreateThread(function()

    while RegisterServerCallback == nil do Wait(100) end

    ---GetLicences
    RegisterServerCallback("core:getAllLicensesForPlayer", function(source, target, token)
        if CheckPlayerToken(source, token) then
            local account = license.GetAllLicensePlayer(target)
            -- if account is empty, return false
            if account == nil then
                return false
            end
            for i = 1, #account do
                -- get the name of the license
                account[i].name = license.GetNameLicense(account[i].license_type)
            end
            return account
        else
            -- TODO: Ac detection
        end
    end)

    --GetLicenceInPlayer
    RegisterServerCallback("core:getLicenseInPlayer", function(source, token, licenseType)
        if CheckPlayerToken(source, token) then
            local account = license.GetLicenseInPlayer(source, licenseType)
            return account
        else
            -- TODO: Ac detection
        end
    end)

    ----Suppression d'une licences
    RegisterServerCallback("core:removeLicence", function(source, token, name_license)
        if CheckPlayerToken(source, token) then
            if name_license ~= nil then
                license.RemoveLicense(source, name_license)
                -- CorePrint("[info]: " .. GetPlayer(source):getLastname() .. " "..GetPlayer(source):getFirstname().." a perdu la license " .. name_license)
                return true
            end
        else
        end
    end)
    ----Changement de valeur pour licences valider

    RegisterServerCallback("core:AddLicencesValue", function(source, token, licences)
        if CheckPlayerToken(source, token) then

            for k, v in pairs(sv_licenses.licenses) do
                for key, value in pairs(sv_licenses.licenses[k]) do
                    sv_licenses.addLicenceToAccount(k, key, licences)
                    sv_licenses.setAccountAsNotSaved(k, key)
                end
            end
            return true
        else
            -- TODO: Ac detection
        end
    end)
    RegisterServerCallback("core:get_clock", function(source, token)
        local hour = os.date("%H:%M")
        if CheckPlayerToken(source, token) then
            return hour
        end
    end)


    -- RegisterCommand("os", function()

    --  end, false)
end)

RegisterNetEvent("core:addLicence")
AddEventHandler("core:addLicence", function(player, token, name_license)
    if CheckPlayerToken(player, token) then
        if name_license ~= nil then
            local result = license.AddNewLicense(player, name_license)
            if result then
                -- CorePrint("[info]: " .. GetPlayer(player):getLastname() .. " "..GetPlayer(player):getFirstname() .. " a obtenu la license " .. name_license)
            end
        end
    else
        -- TODO: Ac detection
    end
end)