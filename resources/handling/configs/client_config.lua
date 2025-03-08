ESX = nil
QBCore = nil

local ClientFrameworkInit = {
    ['qbcore'] = function()
        if GetResourceState('qb-core') ~= 'started' then
            Citizen.Wait(2000)
        end
        if GetResourceState('qb-core') ~= 'started' then
            ErrorPrint('QBCore (qb-core) resource is not started on client side.')
            ErrorPrint('Shared object can not be fetched')
            return
        end
        QBCore = exports['qb-core']:GetCoreObject()
    end,
    ['esx'] = function()
        local startTime = GetGameTimer()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
            if GetGameTimer() - 5000 > startTime then
                ErrorPrint('ESX not fetched on Client side.')
                ErrorPrint('Make sure your shared even name is set correctly in ^3configs/client_config.lua^7 and you set the correct framework')
                return
            end
        end
        if ESX then return end
        if GetResourceState('es_extended') ~= 'started' then
            ErrorPrint('ESX (es_extended) resource is not started on client side.')
            ErrorPrint('Shared object can not be fetched')        
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
    ['qbcore'] = function(text, type, length)
        QBCore.Functions.Notify(text, type, length)
    end,
    ['esx'] = function(...)
        ESX.ShowNotification(...)
    end,
    ['custom'] = function(msg)
        ShowNotif(msg)
    end,
}

function ShowNotif(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(false, false)
end

RegisterNetEvent('handlingtuning:Notify', function(...)
    Notify[Config.NotificationSystem](...)
end)

Citizen.CreateThread(function()
    if ClientFrameworkInit[Config.Framework] == nil then
        ErrorPrint(('Framework initiation for option ^6 %s ^7 does not exist'):format(Config.Framework))
        return
    end
    ClientFrameworkInit[Config.Framework]()
end)

function ErrorPrint(...)
    local text = table.concat({...}, ' ')
    local string = ('[^6ERROR^7] - %s ^7'):format(text)
    print(string)
    if not CFG or CFG.SendClientSideErrorsToServer then return end
    TriggerServerEvent('sb-interaction:errorPrint', ('[^4Client^7] %s ^7'):format(string))
end