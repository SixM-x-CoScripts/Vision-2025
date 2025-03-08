RegisterNetEvent('bucheron:removeWood', function(plate, rawwoodCount)
    local index = GetVehicleIndexFromPlate(plate)
    RemoveItemToVehicle(plate, "rawwood", rawwoodCount, {})
end)