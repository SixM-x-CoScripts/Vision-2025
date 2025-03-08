local isInAllowedGroup = false

if Config.Framework == "0" then
    CreateThread(function()
        Wait(500)
        TriggerServerEvent(TriggerName("FetchPlayerGroup"))
    end)
end

if Config.Framework == "1" then
    RegisterNetEvent('esx:playerLoaded', function()
        TriggerServerEvent(TriggerName("FetchPlayerGroup"))
    end)
end

if Config.Framework == "2" then
    RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
        TriggerServerEvent(TriggerName("FetchPlayerGroup"))
    end)
end


RegisterNetEvent(TriggerName("FetchPlayerGroup"), function(result)
    isInAllowedGroup = result
end)

function IsAtAllowedGroup()
    return isInAllowedGroup
end