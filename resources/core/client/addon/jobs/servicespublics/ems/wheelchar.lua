local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

RegisterNetEvent("core:SpawnWheelChair")
AddEventHandler('core:SpawnWheelChair', function()
    SpawWheelChair()
end)

function SpawWheelChair()
    TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
    LoadModel('prop_wheelchair_01')

    local wheelchair = CreateObject(GetHashKey('prop_wheelchair_01'), GetEntityCoords(PlayerPedId()), true)
end

function DeleteWheelChair()
    local wheelchair = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 10.0, GetHashKey('prop_wheelchair_01'))
    TriggerSecurGiveEvent("core:addItemToInventory", token, "froulant", 1, {})
    TriggerServerEvent("DeleteEntity", token, { ObjToNet(wheelchair) })
end

Citizen.CreateThread(function()
    while p == nil do Wait(1) end
    while true do
        local sleep = 500

        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)

        local closestObject = GetClosestObjectOfType(pedCoords, 3.0, GetHashKey("prop_wheelchair_01"), false)

        if DoesEntityExist(closestObject) then
            sleep = 5

            local wheelChairCoords = GetEntityCoords(closestObject)
            local wheelChairForward = GetEntityForwardVector(closestObject)

            local sitCoords = (wheelChairCoords + wheelChairForward * -0.5)
            local pickupCoords = (wheelChairCoords + wheelChairForward * 0.3)

            if GetDistanceBetweenCoords(pedCoords, sitCoords, true) <= 1.0 then
                Modules.UI.Draw3DText(sitCoords.x, sitCoords.y, sitCoords.z + 0.5, "[E] pour s'asseoir", 4, 0.03, 0.03)
                DrawLine(p:pos(), vector3(sitCoords.x, sitCoords.y, sitCoords.z), 255, 255, 255, 170);

                if IsControlJustPressed(0, 38) then
                    Sit(closestObject)
                end
            end

            if GetDistanceBetweenCoords(pedCoords, pickupCoords, true) <= 1.0 then
                Modules.UI.Draw3DText(pickupCoords.x, pickupCoords.y, pickupCoords.z + 0.5, "[K] pour pousser", 4, 0.03
                    , 0.03)
                DrawLine(p:pos(), vector3(pickupCoords.x, pickupCoords.y, pickupCoords.z), 255, 255, 255, 170);

                if IsControlJustPressed(0, 311) then
                    PickUp(closestObject)
                end
            end
        end

        Citizen.Wait(sleep)
    end
end)

Sit = function(wheelchairObject)
    local closestPlayer, closestPlayerDist = GetClosestPlayer()

    if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
        if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'missfinale_c2leadinoutfin_c_int', '_leadin_loop2_lester', 3) then
            -- ShowNotification("Quelqu'un est déjà assis sur cette chaise roulante!")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Quelqu'un est déjà assis sur cette chaise roulante !"
            })

            return
        end
    end
    RequestAnimDict("missfinale_c2leadinoutfin_c_int")
    while not HasAnimDictLoaded("missfinale_c2leadinoutfin_c_int") do Wait(1) end

    AttachEntityToEntity(PlayerPedId(), wheelchairObject, 0, 0, 0.0, 0.4, 0.0, 0.0, 180.0, 0.0, false, false, false,
        false, 2, true)

    local heading = GetEntityHeading(wheelchairObject)

    while IsEntityAttachedToEntity(PlayerPedId(), wheelchairObject) do
        Citizen.Wait(5)

        if IsPedDeadOrDying(PlayerPedId()) then
            DetachEntity(PlayerPedId(), true, true)
        end

        if not IsEntityPlayingAnim(PlayerPedId(), 'missfinale_c2leadinoutfin_c_int', '_leadin_loop2_lester', 3) then
            TaskPlayAnim(PlayerPedId(), 'missfinale_c2leadinoutfin_c_int', '_leadin_loop2_lester', 8.0, 8.0, -1, 69, 1,
                false, false, false)
        end

        if IsControlPressed(0, 32) then
            local x, y, z = table.unpack(GetEntityCoords(wheelchairObject) +
                GetEntityForwardVector(wheelchairObject) * -0.02)
            SetEntityCoords(wheelchairObject, x, y, z)
            PlaceObjectOnGroundProperly(wheelchairObject)
        end

        if IsControlPressed(0, 31) then
            local x, y, z = table.unpack(GetEntityCoords(wheelchairObject) +
                GetEntityForwardVector(wheelchairObject) * 0.02)
            SetEntityCoords(wheelchairObject, x, y, z)
            PlaceObjectOnGroundProperly(wheelchairObject)
        end

        if IsControlPressed(1, 34) then
            heading = heading + 0.4

            if heading > 360 then
                heading = 0
            end

            SetEntityHeading(wheelchairObject, heading)
        end

        if IsControlPressed(1, 9) then
            heading = heading - 0.4

            if heading < 0 then
                heading = 360
            end

            SetEntityHeading(wheelchairObject, heading)
        end

        if IsControlJustPressed(0, 73) then
            DetachEntity(PlayerPedId(), true, true)

            local x, y, z = table.unpack(GetEntityCoords(wheelchairObject) +
                GetEntityForwardVector(wheelchairObject) * -0.7)

            SetEntityCoords(PlayerPedId(), x, y, z)
        end
    end
end

PickUp = function(wheelchairObject)
    local closestPlayer, closestPlayerDist = GetClosestPlayer()

    if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
        if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'anim@heists@box_carry@', 'idle', 3) then
            -- ShowNotification("Quelqu'un est déjà en train de pousser cette chaise roulante!")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Quelqu'un est déjà en train de pousser cette chaise roulante !"
            })

            return
        end
    end

    NetworkRequestControlOfEntity(wheelchairObject)
    RequestAnimDict("anim@heists@box_carry@")
    while not HasAnimDictLoaded("anim@heists@box_carry@") do Wait(1) end

    AttachEntityToEntity(wheelchairObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), -0.00, -0.3, -0.73,
        195.0, 180.0, 180.0, 0.0, false, false, true, false, 2, true)

    while IsEntityAttachedToEntity(wheelchairObject, PlayerPedId()) do
        Citizen.Wait(5)

        if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
            TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
        end

        if IsPedDeadOrDying(PlayerPedId()) then
            DetachEntity(wheelchairObject, true, true)
        end

        if IsControlJustPressed(0, 73) then
            DetachEntity(wheelchairObject, true, true)
        end
    end

    StopAnimTask(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 1.0)
    ClearPedTasks(p:ped())
end
