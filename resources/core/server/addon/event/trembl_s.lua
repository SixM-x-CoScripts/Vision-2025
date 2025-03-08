RegisterCommand("tremblement", function(source, args)
    if GetPlayer(source):getPermission() >= 5 then
        TriggerClientEvent("core:StartTremblement", -1)
    end
end)
