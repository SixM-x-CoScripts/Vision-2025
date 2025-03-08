RegisterServerEvent("shareImOnSkate")
AddEventHandler("shareImOnSkate", function() 
    local _source = source
    TriggerClientEvent("shareHeIsOnSkate", -1, _source)
end)