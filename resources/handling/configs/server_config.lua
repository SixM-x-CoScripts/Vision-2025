ESX = nil
QBCore = nil

local DB_INFO <const> = Config.OwnedVehiclesDataTable

-- 88888888b                                                                    dP       
-- 88                                                                           88       
-- a88aaaa    88d888b. .d8888b. 88d8b.d8b. .d8888b. dP  dP  dP .d8888b. 88d888b. 88  .dP  
-- 88        88'  `88 88'  `88 88'`88'`88 88ooood8 88  88  88 88'  `88 88'  `88 88888"   
-- 88        88       88.  .88 88  88  88 88.  ... 88.88b.88' 88.  .88 88       88  `8b. 
-- dP        dP       `88888P8 dP  dP  dP `88888P' 8888P Y8P  `88888P' dP       dP   `YP 

local ServerFrameworkInit = {
    ['qbcore'] = function()
        if GetResourceState('qb-core') ~= 'started' then
            Citizen.Wait(2000)
        end
        if GetResourceState('qb-core') ~= 'started' then
            ErrorPrint('QBCore (qb-core) resource is not started.')
            ErrorPrint('Shared object can not be fetched')
            return
        end
        QBCore = exports['qb-core']:GetCoreObject()
    end,
    ['esx'] = function()
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        if ESX then return end
        if GetResourceState('es_extended') ~= 'started' then
            ErrorPrint('ESX (es_extended) resource is not started.')
            ErrorPrint('Shared object can not be fetched.')        
        end
        if ESX == nil then
            ErrorPrint('ESX shared object was not fetched.')
        end
    end,
    ['exm'] = function()
        ESX = exports.extendedmode:getSharedObject()
    end,
    ['other'] = function()
        -- Add your code here
    end,
    ['none'] = function() end,
}

Notify = {
    ['qbcore'] = function(src, text, type, length)
        TriggerClientEvent('QBCore:Notify', src, text, type, length)
    end,
    ['esx'] = function(src, ...)
        TriggerClientEvent(CL.BASE.NOTIFY, src, ...)
    end,
    ['custom'] = function(src, msg, flash, saveToBrief, hudColorIndex)
        TriggerClientEvent('handlingtuning:Notify', src, msg, flash, saveToBrief, hudColorIndex)
    end,
}

Citizen.CreateThread(function()
    if ServerFrameworkInit[Config.Framework] == nil then
        ErrorPrint(('Framework initiation for option ^6 %s ^7 does not exist'):format(Config.Framework))
        return
    end
    ServerFrameworkInit[Config.Framework]()
end)

RegisterNetEvent('sb-interaction:errorPrint', function(msg)
    print(msg)
end)

function ErrorPrint(...)
    local text = table.concat({...}, ' ')
    local string = ('[^6ERROR^7] - %s ^7'):format(text)
    print(string)
end

function getIsAdmin(src)
    print("gta")

    if Config.AllowEveryoneFullAccess then return true end
    local playerGroup = ''
    local identifiers = GetPlayerIdentifiers(src)
    for i,v in ipairs(Config.Admins) do
        if v.type == 'identifier' then
            for _,identifier in pairs(identifiers) do
                if identifier == v.data then 
                    print(v.data, identifier)
                    return true 
                end
            end
        elseif v.type == 'frameworkgroup' then
            if Config.Framework == 'qbcore' then
                if QBCore and QBCore.Functions.HasPermission(src, v.data) then
                    return true
                end
            elseif table.has({'esx', 'exm'}, Config.Framework) then
                local xPlayer = ESX.GetPlayerFromId(src)
                if xPlayer.getGroup() == v.data then
                    return true
                end
            else
                ErrorPrint('Framework group check is not implemented for framework ^6'..Config.Framework)
            end
        elseif v.type == 'ace' then
            if IsAceAllowed(v.data) then
                return true
            end
        end
    end

    return false
end


function getPlayerIdentifier(src)
    for _, identifier in pairs(GetPlayerIdentifiers(src)) do
        if string.find(identifier, Config.PlayerIdentifier) then
            return identifier
        end
    end
    return nil
end

function getCharacterIdentifier(src)
    if table.has({'esx', 'exm'}, Config.Framework) then
        local xPlayer = ESX.GetPlayerFromId(src)
        return xPlayer and xPlayer.getIdentifier() or nil
    elseif Config.Framework == 'qbcore' then
        local ply = QBCore.Functions.GetPlayer(src)
        return ply and ply.PlayerData.citizenid or nil
    else
        return getPlayerIdentifier(src)
    end
end

function registerItem()
    if Config.Framework == 'qbcore' then
        QBCore.Functions.CreateUseableItem("tunertablet", function(source, item)
            local Player = QBCore.Functions.GetPlayer(source)
            if Player.Functions.GetItemByName(item.name) ~= nil then
                TriggerClientEvent("handlingtuning:client:openTablet", source, false)
            end
        end)
    elseif table.has({'esx', 'exm'}, Config.Framework) then
        ESX.RegisterUsableItem(Config.TabletItemName, function(source)
            TriggerClientEvent("handlingtuning:client:openTablet", source, false)
        end)
    end
end

-- 8888ba.88ba           .d88888b   .88888.   dP        
-- 88  `8b  `8b          88.    "' d8'   `8b  88        
-- 88   88   88 dP    dP `Y88888b. 88     88  88        
-- 88   88   88 88    88       `8b 88  db 88  88        
-- 88   88   88 88.  .88 d8'   .8P Y8.  Y88P  88        
-- dP   dP   dP `8888P88  Y88888P   `8888PY8b 88888888P 
--                   .88                                
--               d8888P                                 

function isVehicleOwned(plate)
    local retval
    if plate and Config.UseDatabaseHandlingSaving then
        local res = mysqlQuerySync(('SELECT 1 FROM %s WHERE %s LIKE \'%s\''):format(DB_INFO.tableName, DB_INFO.plateColumn, '%'..plate..'%'), {})
        if res then
            retval = res[1]
        end
    else
        retval = false
    end
    return retval
end

function setNewHandling(plate, handlingData)
    if Config.UseDatabaseHandlingSaving and getIsAdmin(source) then
        mysqlQuery(('UPDATE %s SET handling = @handlingData WHERE %s LIKE \'%s\''):format(DB_INFO.tableName, DB_INFO.plateColumn, '%'..plate..'%'),
        {['handlingData'] = json.encode(handlingData)})
    end
end

function mysqlQuery(query, params, cb)
    if Config.MySQLScript == 'oxmysql' then
        MySQL.Async.fetchAll(query, params, cb)
    elseif Config.MySQLScript == 'MySQL' then
        MySQL.Async.fetchAll(query, params, cb)
    end
end

function mysqlQuerySync(query, params) 
    if Config.MySQLScript == 'oxmysql' then
        return MySQL.Sync.fetchAll(query, params)
    elseif Config.MySQLScript == 'MySQL' then
        return MySQL.Sync.fetchAll(query, params)
    end

end

RegisterNetEvent('handlingtuning:server:saveHandling', function(handlingName, handlingData, vehName)
    if getIsAdmin(source) then
        local src = source
        if Config.UseDatabasePresetsSaving then
            mysqlQuery('INSERT INTO player_handlings (identifier, handlingData, carName, handlingName) VALUES (@id, @handlingData, @carName, @handlingName)', {
                ['id'] = getPlayerIdentifier(src),
                ['handlingData'] = json.encode(handlingData),
                ['carName'] = vehName,
                ['handlingName'] = handlingName
            })
        end
    end
end)

RegisterNetEvent('handlingtuning:server:delHandling', function(presetId)
    local src = source
    mysqlQuery('DELETE FROM player_handlings WHERE `id` = @id AND `identifier` = @identifier', {id = presetId, identifier = getPlayerIdentifier(src)})
end)

RegisterNetEvent('handlingtuning:server:sharePreset', function(targetId, preset)
    if Config.UseDatabasePresetsSaving and getIsAdmin(source) then
        local src = source 
        if getPlayerIdentifier(targetId) then
            mysqlQuery('INSERT INTO player_handlings (identifier, handlingData, carName, handlingName, creator) VALUES (@id, @handlingData, @carName, @handlingName, @plyName)', {
                ['id'] = getPlayerIdentifier(tonumber(targetId)),
                ['handlingData'] = json.encode(preset.handlingData),
                ['carName'] = preset.carName,
                ['handlingName'] = preset.handlingName,
                ['plyName'] = GetPlayerName(src),
            })
            Notify[Config.NotificationSystem](tonumber(targetId), "Someone shared a new tuning tablet handling preset with you.")
        else
            Notify[Config.NotificationSystem](src, "Player is not online.")
        end
    end
end)

-- a88888b.                                                        dP          
-- d8'   `88                                                        88          
-- 88        .d8888b. 88d8b.d8b. 88d8b.d8b. .d8888b. 88d888b. .d888b88 .d8888b. 
-- 88        88'  `88 88'`88'`88 88'`88'`88 88'  `88 88'  `88 88'  `88 Y8ooooo. 
-- Y8.   .88 88.  .88 88  88  88 88  88  88 88.  .88 88    88 88.  .88       88 
--  Y88888P' `88888P' dP  dP  dP dP  dP  dP `88888P8 dP    dP `88888P8 `88888P'                                                                        

RegisterCommand(Config.TabletCommand, function(s, a)
    if getIsAdmin(s) then
        TriggerClientEvent('handlingtuning:client:openTablet', s, getIsAdmin(s))
    end
end)

-- Can be used to open minimal menu straight away
RegisterCommand('minimal', function(s, a)
    if getIsAdmin(s) then
        TriggerClientEvent('handlingtuning:client:openMinimal', s, getIsAdmin(s))
    end
end)
