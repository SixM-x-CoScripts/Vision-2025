CreateThread(function()
    while true do 
        Wait(30*60000)
        TriggerClientEvent("core:delunused", -1)
    end
end)