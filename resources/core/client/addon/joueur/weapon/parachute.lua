local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local toRemove = false
Citizen.CreateThread(function()
    Wait(2000)
    while true do
        local paraState = GetPedParachuteState(PlayerPedId())
        if paraState == 2 then 
            toRemove = true
        end
        if paraState ~= 2 and toRemove then
            TriggerServerEvent('core:RemoveItemToInventory', token, "gadget_parachute", 1, {})
            toRemove = false
        end
        if paraState <=0 then Wait(1000)
        else Wait(100) end
    end
end)