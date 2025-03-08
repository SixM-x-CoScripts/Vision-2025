local garageVehicle = {}

local function LoadLspdStockFromFile() -- Allow dynamic load
    local loadFile = LoadResourceFile(GetCurrentResourceName(), "server/addon/jobs/police_garage.json")
    garageVehicle = json.decode(loadFile)
end

LoadLspdStockFromFile()

local function RefreshLspdStockFromFiles() -- Allow dynamic save
    SaveResourceFile(GetCurrentResourceName(), "server/addon/jobs/police_garage.json", json.encode(garageVehicle), -1)
end

RegisterNetEvent("core:lspdGetVehGarage")
AddEventHandler("core:lspdGetVehGarage", function(token)
    if CheckPlayerToken(source, token) then
        TriggerClientEvent('core:lspdGetVehGarage', source, garageVehicle)
    end
end)

RegisterNetEvent("core:lspdSpawnVehicle")
AddEventHandler("core:lspdSpawnVehicle", function(token, vehicle)
    local source = source
    if CheckPlayerToken(source, token) then
        for i = 1, #garageVehicle, 1 do
            if garageVehicle[i].id then
                if garageVehicle[i].id == vehicle.id then
                    table.remove(garageVehicle, i)
                    RefreshLspdStockFromFiles()
                    LoadLspdStockFromFile()
                    Wait(100)
                    break
                end
            end
        end
        TriggerClientEvent('core:lspdGetVehGarage', source, garageVehicle)
        TriggerClientEvent('core:lspdSpawnVehicle', source, vehicle)
    end
end)

RegisterNetEvent("police:SetVehicleInFourriere")
AddEventHandler("police:SetVehicleInFourriere", function(token, plate, entity)
    if CheckPlayerToken(source, token) then
        SetVehicleInPounder(plate)
        RemoveVehicleFromGarage(plate)
    end
end)

RegisterNetEvent("core:lspdStoreVehicle")
AddEventHandler("core:lspdStoreVehicle", function(token, data)
    local source = source
    if CheckPlayerToken(source, token) then
        local lastItem = {}
        local lastItemId = 0
        lastItem = garageVehicle[#garageVehicle]
        lastItemId = lastItem.id
        table.insert(garageVehicle, { id = lastItemId + 1, name = data.name, customName = data.customName })
        RefreshLspdStockFromFiles()
        LoadLspdStockFromFile()
        Wait(100)
        -- send the new vehicle to the client
        TriggerClientEvent('core:lspdGetVehGarage', source, garageVehicle)
    end
end)

RegisterNetEvent("core:lspdRenameVeh")
AddEventHandler("core:lspdRenameVeh", function(token, data, newName)
    local source = source
    if CheckPlayerToken(source, token) then
        for i = 1, #garageVehicle, 1 do
            if garageVehicle[i].id then
                if garageVehicle[i].id == data.id then
                    garageVehicle[i].customName = newName
                    RefreshLspdStockFromFiles()
                    LoadLspdStockFromFile()
                    Wait(100)
                    break
                end
            end
        end
        TriggerClientEvent('core:lspdGetVehGarage', source, garageVehicle)
    end
end)

RegisterNetEvent("core:PutPlayerIntoVehicle")
AddEventHandler("core:PutPlayerIntoVehicle", function(token, target, vehicle)
    local source = source
    local id = target
    print("PutPlayerIntoVehicle", token, target, vehicle)
    if CheckPlayerToken(source, token) then
        if CheckPlayerJob(source, 'lspd') or CheckPlayerJob(source, 'usss') or CheckPlayerJob(source, 'bp') or CheckPlayerJob(source, 'lssd') or CheckPlayerJob(source, 'gcp') or CheckPlayerJob(source, 'boi') then
            TriggerClientEvent("core:PutPlayerIntoVehicle", id, vehicle)
        end
    end
end)

RegisterNetEvent("core:MakePlayerLeaveVehicle")
AddEventHandler("core:MakePlayerLeaveVehicle", function(token, target)
    local source = source
    if CheckPlayerToken(source, token) then
        if CheckPlayerJob(source, 'lspd') or CheckPlayerJob(source, 'usss') or CheckPlayerJob(source, 'lssd') or CheckPlayerJob(source, 'gcp') or CheckPlayerJob(source, 'bp') or CheckPlayerJob(source, 'boi') then
            TriggerClientEvent('core:MakePlayerLeaveVehicle', target)
        end
    end
end)

RegisterNetEvent("core:CuffPlayer")
AddEventHandler("core:CuffPlayer", function(token, target)
    if CheckPlayerToken(source, token) then
        if CheckPlayerJob(source, 'lspd') or CheckPlayerJob(source, 'usss') or CheckPlayerJob(source, 'bp') or CheckPlayerJob(source, 'g6') or CheckPlayerJob(source, 'usmc') or CheckPlayerJob(source, 'lssd') or CheckPlayerJob(source, 'gcp') or CheckPlayerJob(source, 'boi') then
            TriggerClientEvent('core:CuffPlayer', target)
        end
    end
end)

RegisterNetEvent("core:PermisCiaoByeBye")
AddEventHandler("core:PermisCiaoByeBye", function(token, target, type)
    if CheckPlayerToken(source, token) then
        if CheckPlayerJob(source, 'lspd') or CheckPlayerJob(source, 'lssd') or CheckPlayerJob(source, 'gcp') then
            local result = license.RemoveLicense(target, type)
            if result then
                --[[TriggerClientEvent("core:ShowNotification", target, "Vous avez perdu votre permis "..type)]]
                TriggerClientEvent("__atoshi::createNotification", target, {
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous avez perdu votre ~s permis " .. type
                })
                --[[TriggerClientEvent("core:ShowNotification", source,
                    "Vous venez d'enlever le permis "..type.." de " ..
                    GetPlayer(target):getIdentity().prenom .. " " .. GetPlayer(target):getIdentity().nom)]]
                TriggerClientEvent("__atoshi::createNotification", source, {
                    type = 'JAUNE',
                    duration = 5, -- In seconds, default:  4
                    content = "Vous venez d'enlever le ~s permis " ..
                    type .. " de " .. GetPlayer(target):getFirstname() .. " " .. GetPlayer(target):getLastname()
                })
            else
                --[[TriggerClientEvent("core:ShowNotification", source, "Le joueur n'a pas ce permis")]]
                TriggerClientEvent("__atoshi::createNotification", source, {
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Le joueur n'a pas ce permis"
                })
            end
        end
    end
end)


RegisterNetEvent("core:addLicenceLSPD")
AddEventHandler("core:addLicenceLSPD", function(player, token, name_license)
    if CheckPlayerToken(source, token) then
        if name_license ~= nil then
            local result = license.AddNewLicense(player, name_license)
            if result then
                --[[TriggerClientEvent("core:ShowNotification", player, "Vous avez obtenu la license " .. name_license)]]
                TriggerClientEvent("__atoshi::createNotification", player, {
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous avez obtenu la license ~s " .. name_license
                })
                --[[TriggerClientEvent("core:ShowNotification", source, "Vous avez donné la license " .. name_license .. " à "  ..GetPlayer(player):getIdentity().nom .. " " .. GetPlayer(player):getIdentity().prenom)]]
                TriggerClientEvent("__atoshi::createNotification", source, {
                    type = 'JAUNE',
                    duration = 5, -- In seconds, default:  4
                    content = "Vous avez donné la license ~s " ..
                    name_license .. " à " .. GetPlayer(player):getLastname() .. " " .. GetPlayer(player):getFirstname()
                })
            else
                --[[TriggerClientEvent("core:ShowNotification", source, "Cette personne possède déjà cette license")]]
                TriggerClientEvent("__atoshi::createNotification", source, {
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Cette personne possède déjà cette license"
                })
            end
        end
    else
        --TODO : AC Detection
    end
end)

RegisterNetEvent("core:escortPlayer")
AddEventHandler("core:escortPlayer", function(token, target)
    if CheckPlayerToken(source, token) then
        if CheckPlayerJob(source, 'lspd') or CheckPlayerJob(source, 'lssd') or CheckPlayerJob(source, 'gcp') or CheckPlayerJob(source, 'usss') or CheckPlayerJob(source, 'bp') or CheckPlayerJob(source, 'boi') then
            TriggerClientEvent("core:EscortPlayer", target, source)
            TriggerClientEvent("core:returnStatusEscord", source, target)
        end
    end
end)

RegisterServerCallback("core:RemoveItemToInventoryPolice", function(source, token, id, item, count, metadata)
    local source = source
    local ply = GetPlayer(source)
    local job = ply:getJob()
    if job ~= "lspd" and job ~= "usss" and job ~= "bp" and job ~= "lssd" and job ~= "gcp" and job ~= "boi" then
        SunWiseKick(source, "Tried to remove item with inventory police, job : " .. job)
        return false
    end
    if CheckPlayerToken(source, token) then
        local itemWeight = GetItemWeightWithCount(item, count)
        if getInventoryWeight(source) + itemWeight <= items.maxWeight then
            RemoveItemToPlayer(id, item, count, metadata)
            --RefreshPlayerData(id)
            MarkPlayerDataAsNonSaved(id)
            return true
        end
        return false
    end
end)

blacklistSearch = {}
RegisterNetEvent('core:blacklistSearch')
AddEventHandler('core:blacklistSearch', function(token, statut)
    local source = source
    if CheckPlayerToken(source, token) and GetPlayer(source):getPermission() >= 69 then
        if statut == true then
            blacklistSearch[source] = true
        elseif statut == false then
            blacklistSearch[source] = nil
        end
    end
end)

local cachedPlate = {}
CreateThread(function()
    while RegisterServerCallback == nil do
        Wait(0)
    end
    RegisterServerCallback('core:GetInventoryPlayerPolice', function(source, token, id)
        if CheckPlayerToken(source, token) then
            local player = GetPlayer(id)
            if player == nil then
                return {}
            end

            if blacklistSearch[id] then
                return false
            end

            return player:getInventaire()
        end
    end)

    RegisterServerCallback('core:GetIdentityPlayer', function(source, token, id)
        if CheckPlayerToken(source, token) then
            return GetPlayer(id):getFirstname() .. " " .. GetPlayer(id):getLastname()
        end
    end)
    RegisterServerCallback("core:CheckVehiclePlate", function(source, plate)
        local cb = {}
        local player = false
        if cachedPlate[plate] == nil then
            local k = 1
            --local index = GetVehicleIndexFromPlate(plate)
            local veh = GetVehicle(plate)
            if veh ~= nil then
                local player = GetPlayerById(veh.owner);
                if (player) then
                    cb.nom = player:getLastname();
                    cb.prenom = player:getFirstname();
                else
                    cb.nom = "";
                    cb.prenom = veh.owner;
                end
            else
                cb.nom = ""
                cb.prenom = "Inconnu"
            end
            cachedPlate[plate] = cb
        else
            cb = cachedPlate[plate]
        end
        return cb
    end)
end)

local trafficZones = {}

RegisterNetEvent("lspd:traffic:add")
AddEventHandler("lspd:traffic:add", function(zone)
    -- insert the zone into the table
    table.insert(trafficZones, zone)
    TriggerClientEvent("lspd:traffic:addclient", -1, zone)
end)

RegisterNetEvent("lspd:traffic:remove")
AddEventHandler("lspd:traffic:remove", function(id)
    -- remove the zone with the given id
    for i, zone in ipairs(trafficZones) do
        if zone.zoneId == id then
            TriggerClientEvent("lspd:traffic:removeclient", -1, id)
            table.remove(trafficZones, i)
            break
        end
    end
end)

RegisterServerCallback("lspd:traffic:get", function(source)
    -- return the table of zones
    return trafficZones
end)
