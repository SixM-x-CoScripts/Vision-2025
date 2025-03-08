RegisterNetEvent('firework:ServerStart', function(ppos)
    local src = source
    local p = GetPlayer(src)
	if p:getPermission() > 0 then
        TriggerClientEvent('firework:ClientStart', -1, ppos)
    else
        SunWiseKick(src, "Tried exec firework:battery")
    end
end)

RegisterNetEvent('firework:STOP', function()
    local src = source
    local p = GetPlayer(src)
	if p:getPermission() > 0 then
        TriggerClientEvent('firework:STOPcl', -1)
    else
        SunWiseKick(src, "Tried exec firework:battery")
    end
end)