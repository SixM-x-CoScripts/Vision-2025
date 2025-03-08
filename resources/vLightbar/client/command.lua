RegisterKeyMapping("vlightbar:toggleLightbars","On/Of vehicle lightbar","KEYBOARD","E")
RegisterKeyMapping("vlightbar:toggleLightbarAudio","On/Of vehicle siren Audio","KEYBOARD","G")
RegisterKeyMapping('+vlightbar:sirenHorn', 'turn on Siren Horn', 'keyboard', 'E')

RegisterCommand("vlightbar:toggleLightbars", function() toggleLightbars() end)
RegisterCommand("vlightbar:toggleLightbarAudio", function() toggleLightbarAudio() end)
RegisterCommand('+vlightbar:sirenHorn', function() toggleSirenHorn(true) end)
RegisterCommand('-vlightbar:sirenHorn', function() toggleSirenHorn(false) end)
RegisterCommand(vLightbar.addLightbarCommand, function() searchNearVehicle() end)
RegisterCommand(vLightbar.GivepermCommand, function(source, args)
    local tId = tonumber(args[1])
    local admin = tonumber(args[2])
    local isAdmin = isPermission("admin")
    while isAdmin == nil do Citizen.Wait(0) end
    if isAdmin then
        TriggerServerEvent("vlightbar:server:addUserPermission",tId,admin)
    end
end)