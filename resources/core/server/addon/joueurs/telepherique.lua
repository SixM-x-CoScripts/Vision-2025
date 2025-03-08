--[[RegisterServerEvent("core:telepherique:synchronise")
AddEventHandler("core:telepherique:synchronise", function(index, state)
    if source == tonumber(GetPlayers()[1]) then
        TriggerClientEvent("core:telepherique:forceState", -1, index, state)
    end
end)]]