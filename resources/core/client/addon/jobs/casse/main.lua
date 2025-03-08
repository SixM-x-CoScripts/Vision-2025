local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function casseParkVehicle(zoneId)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if (veh == 0) or Casse.Duty then
        return
    end
    local canDo = TriggerServerCallback("startCasseVehicle", token, NetworkGetNetworkIdFromEntity(veh), zoneId)
    if not canDo then
        if p:getSubscription() == 0 then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Tu as atteint la limite journalière (6) ou tu ne peux pas faire ca"
            })
            return
        end
    end
    TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
    local vehpos = GetEntityCoords(veh)
    local model = 'xs_prop_x18_axel_stand_01a'

    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end

    if IsThisModelABike(GetEntityModel(veh)) then
        local stand = CreateObject(GetHashKey(model), vehpos.x, vehpos.y, vehpos.z - 0.5, true, true, true)
        PlaceObjectOnGroundProperly(stand)
        DecorSetInt(veh, 'stand', NetworkGetNetworkIdFromEntity(stand))

        AttachEntityToEntity(stand, veh, 0, 0.0, 0.0, -0.8, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
    else
        local flWheelStand = CreateObject(GetHashKey(model), vehpos.x - 0.5, vehpos.y + 1.0, vehpos.z - 0.5, true, true, true)
        PlaceObjectOnGroundProperly(flWheelStand)
        DecorSetInt(veh, 'stand1', NetworkGetNetworkIdFromEntity(flWheelStand))

        local frWheelStand = CreateObject(GetHashKey(model), vehpos.x + 0.5, vehpos.y + 1.0, vehpos.z - 0.5, true, true, true)
        PlaceObjectOnGroundProperly(frWheelStand)
        DecorSetInt(veh, 'stand2', NetworkGetNetworkIdFromEntity(frWheelStand))

        local rlWheelStand = CreateObject(GetHashKey(model), vehpos.x - 0.5, vehpos.y - 1.0, vehpos.z - 0.5, true, true, true)
        PlaceObjectOnGroundProperly(rlWheelStand)
        DecorSetInt(veh, 'stand3', NetworkGetNetworkIdFromEntity(rlWheelStand))

        local rrWheelStand = CreateObject(GetHashKey(model), vehpos.x + 0.5, vehpos.y - 1.0, vehpos.z - 0.5, true, true, true)
        PlaceObjectOnGroundProperly(rrWheelStand)
        DecorSetInt(veh, 'stand4', NetworkGetNetworkIdFromEntity(rrWheelStand))

        AttachEntityToEntity(flWheelStand, veh, 0, -0.5, 1.0, -0.8, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
        AttachEntityToEntity(frWheelStand, veh, 0, 0.5, 1.0, -0.8, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
        AttachEntityToEntity(rlWheelStand, veh, 0, -0.5, -1.0, -0.8, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
        AttachEntityToEntity(rrWheelStand, veh, 0, 0.5, -1.0, -0.8, 0.0, 0.0, 0.0, false, false, false, false, 0, true)	
    end

    FreezeEntityPosition(veh, true)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.15, true, true, true)
end

local zoneActive = { false, false }
local usedZone = { false, false }
CreateThread(function()
    while true do
        local inDuty = GlobalState['serviceCount_casse'] or 0 -- TriggerServerCallback("core:getNumberOfDuty", token, "casse") or 0

        if inDuty >= 1 then
            if not zoneActive[1] then
                if not usedZone[1] then
                    zoneActive[1] = true
                    zone.addZone(
                        "casse_park_1",
                        vector3(2345.486, 3134.004, 47.25558),
                        "Appuyer sur ~INPUT_CONTEXT~ pour garer le vehicule",
                        function()
                            casseParkVehicle(1)
                        end,
                        true,
                        25, -- Id / type du marker
                        3.0, -- La taille
                        { 51, 204, 255 }, -- RGB
                        170,-- Alpha
                        4.2
                    )
                end
            end
            if inDuty >= 2 then
                if not (zoneActive[2] and usedZone[2]) then
                    zoneActive[2] = true
                    zone.addZone(
                        "casse_park_2",
                        vector3(2356.444, 3132.04, 47.25558),
                        "Appuyer sur ~INPUT_CONTEXT~ pour garer le vehicule",
                        function()
                            casseParkVehicle(2)
                        end,
                        true,
                        25, -- Id / type du marker
                        3.0, -- La taille
                        { 51, 204, 255 }, -- RGB
                        170,-- Alpha
                        4.2
                    )
                end
            else
                zoneActive[2] = false
                zone.removeZone("casse_park_2")
            end
        else
            zoneActive[1] = false
            zoneActive[2] = false
            zone.removeZone("casse_park_1")
            zone.removeZone("casse_park_2")
        end
        Wait(30000)
    end
end)

RegisterNetEvent("SetStateZone", function(zoneId, active)
    if zoneId == 1 then
        zoneActive[1] = false
        zone.removeZone("casse_park_1")
    else
        zoneActive[2] = false
        zone.removeZone("casse_park_2")
    end
    usedZone[zoneId] = active
end)

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7casse ^3loaded")
end)