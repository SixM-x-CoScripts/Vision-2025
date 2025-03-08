RegisterNetEvent('mine:removeMinerai', function(plate, item, count)
    RemoveItemToVehicle(plate, item, count, {})
end)