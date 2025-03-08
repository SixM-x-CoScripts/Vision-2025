function InitPositionHandler(pos, fromCharCreator)
    if not fromCharCreator then
        TeleportPlayer(vector3(pos.x, pos.y, pos.z))
        SetEntityHeading(PlayerPedId(), pos.w)

        local _, z = GetGroundZFor_3dCoord(pos.x, pos.y, pos.z, false)
        SetEntityCoordsNoOffset(PlayerPedId(), pos.x, pos.y, z, 0.0, 0.0, 0.0)
    end
    Citizen.CreateThread(function()
        local oldCoords = pos
        while true do
            local pPed = PlayerPedId()
            local pCoords = GetEntityCoords(pPed)
            if GetDistanceBetweenCoords(pCoords, oldCoords.x, oldCoords.y, oldCoords.z, true) >= 5.0 then
                oldCoords = vector4(pCoords, GetEntityHeading(pPed))
                TriggerServerEvent("core:UpdatePlayerPosition", oldCoords)
            end
            Wait(8000)
        end
    end)
end