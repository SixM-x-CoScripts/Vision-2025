RacketEntity = nil

function EnsureRacketEntity(ped, coords)
    RacketEntity = CreateObject(`prop_tennis_rack_01b`, coords + vector3(0.0, 1.0, 0.0), true, false, false)
    AttachEntityToEntity(RacketEntity, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 0, 0, 0, 2, 1)
end

function ClearRacket()
    DeleteEntity(RacketEntity)
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    ClearRacket()
end)