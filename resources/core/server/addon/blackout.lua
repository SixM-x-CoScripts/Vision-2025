GlobalState['blackout'] = false

RegisterCommand('blackout', function(source, args, rawCommand)
    if GetPlayer(source):getPermission() >= 5 then
        GlobalState['blackout'] = not GlobalState['blackout']
        if GlobalState['blackout'] and args[1] == "purge" then
            exports["xsoundtemp"]:PlayUrl(-1, "purge", 'https://youtu.be/FL4disFETnM?si=Rjaxh4WvDxn1BY0X', 1.0, false)
            Wait(60000)
            TriggerClientEvent('toggleBlackout', -1, GlobalState['blackout'])
        else
            TriggerClientEvent('toggleBlackout', -1, GlobalState['blackout'])
        end
    end
end, false)
