RegisterNetEvent("core:useTicketGratter", function(source)
    local _source = source
    if RemoveItemFromInventory(_source, "ticket", 1, {}) then
        local PossibleWin <const> = {
            0, 0, 0, 400, 1000, 5000
        }
        local won = PossibleWin[math.random(1, #PossibleWin)]
        TriggerClientEvent("core:ticket:useTicketGratter", _source, won)
        Wait(10000)
        AddItemToInventory(_source, "money", won, {})
    end
end)