local casseSave = {}
local cassing = {}
local validZone = {}

CreateThread(function()
    while RegisterServerCallback == nil do Wait(0) end
    RegisterServerCallback("startCasseVehicle", function(source, token, veh, zoneId)
        if CheckPlayerToken(source, token) then
            local plate = all_trim(GetVehicleNumberPlateText(NetworkGetEntityFromNetworkId(veh)))
            local valid = false
            for k, v in pairs(GetAllVehicles()) do
                if all_trim(GetVehicleNumberPlateText(v)) == plate then
                    valid = true
                    break
                end
            end

            local playerLicense = GetPlayer(src):getLicense()
            if valid and ((casseSave[playerLicense] or 0) < 7) then
                TriggerClientEvent("SetStateZone", -1, zoneId, true)
            
                cassing[zoneId] = playerLicense
                validZone[zoneId] = { veh, zoneId }
                for k, v in pairs(inDuty["casse"]) do
                    TriggerClientEvent("NewVehicleCasse", k, veh, zoneId)
                end

                return true
            else
                return false
            end
        end
    end)
end)
RegisterNetEvent("startCasseVehicle", function(token, veh, zoneId)
    local src = source
    if CheckPlayerToken(src, token) then
        local plate = all_trim(GetVehicleNumberPlateText(NetworkGetEntityFromNetworkId(veh)))
        local valid = false
        for k, v in pairs(GetAllVehicles()) do
            if all_trim(GetVehicleNumberPlateText(v)) == plate then
                valid = true
                break
            end
        end

        if valid then
            TriggerClientEvent("SetStateZone", -1, zoneId, true)
            
            cassing[zoneId] = GetPlayer(src):getLicense()
            validZone[zoneId] = { veh, zoneId }
            for k, v in pairs(inDuty["casse"]) do
                TriggerClientEvent("NewVehicleCasse", k, veh, zoneId)
            end
        else

        end
    else

    end
end)

RegisterNetEvent("AcceptVehicleCasse", function(token, zoneCasseID)
    local src = source
    if CheckPlayerToken(src, token) then
        validZone[zoneCasseID] = nil
        for k, v in pairs(inDuty["casse"]) do
            TriggerClientEvent("DisableValidVehicleCasse", k, zoneCasseID)
        end
    else

    end
end)

RegisterNetEvent("TakeDutyCasse", function(token)
    local src = source
    if CheckPlayerToken(src, token) then
        for k, v in pairs(validZone) do
            TriggerClientEvent("NewVehicleCasse", src, v[1], v[2])
        end
    else

    end
end)

RegisterNetEvent("endCasseVehicle", function(token, zoneId, bike)
    local src = source
    if CheckPlayerToken(src, token) then
        if cassing[zoneId] then
            local playerLicense = cassing[zoneId]
            casseSave[playerLicense] = (casseSave[playerLicense] or 0) + 1
            local price = 0
            if bike then
                price = math.floor(2750/((casseSave[playerLicense] + 1)/2))
                AddMoneyToSociety(500, 'casse')
            else
                price = math.floor(3500/((casseSave[playerLicense] + 1)/2))
                AddMoneyToSociety(750, 'casse')
            end
            AddItemToInventory(src, "money", price, {})
            TriggerClientEvent("SetStateZone", -1, zoneId, false)
            cassing[zoneId] = nil

            TriggerClientEvent("__atoshi::createNotification", src, {
                type = 'JAUNE',
                content = "Tu as recu ~s " .. price .. "$ donne le au client"
            })
        end
    else

    end
end)

RegisterNetEvent("DeleteCasseVeh", function(token, netVeh)
    local src = source
    if CheckPlayerToken(src, token) then
        local veh = NetworkGetEntityFromNetworkId(netVeh)
        DeleteEntity(veh)
    else

    end
end)
