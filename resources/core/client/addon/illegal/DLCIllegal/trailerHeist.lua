local RandomVeh = {
    "adder",
    "tenf",
    "zion",
    "sultan",
    "sentinel",
    "vectre",
    "sultanrs"
}

local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

RegisterNetEvent("core:event:trailer", function(truk, trailer, vehone, vehtwo, vehthree, finsih, gang, start, pedone)
    if gang then
        if gang ~= "tout le monde" then 
            if string.lower(p:getCrewType()) ~= string.lower(gang) then 
                return
            end
        end
    end
    truk = NetworkGetEntityFromNetworkId(truk)
    trailer = NetworkGetEntityFromNetworkId(trailer)
    vehone = NetworkGetEntityFromNetworkId(vehone)
    vehtwo = NetworkGetEntityFromNetworkId(vehtwo)
    vehthree = NetworkGetEntityFromNetworkId(vehthree)
    pedone = NetworkGetEntityFromNetworkId(pedone)
    local price = GetVariable and GetVariable("events") and GetVariable("events").orga and GetVariable("events").orga.priceVeh or 1000
    CreateTrailerEvent(truk, trailer, vehone, vehtwo, vehthree, finsih, pedone, price, start)
end)

local hideLastbulle = false
local shouldBreakTheTrailer = false

local blipTrail = nil 
local blipTrailCoords = nil 
local pedNoir

RegisterNetEvent("core:event:trailerupdate", function(coords)
    if blipTrail then 
        SetBlipCoords(blipTrail, coords)
        SetBlipRoute(blipTrail, true)
    end
end)

function CreateTrailerEvent(truk, trailer, vehone, vehtwo, vehthree, randomtrajet, ped, price, start)
    shouldBreakTheTrailer = false
    price = tonumber(price)
    if price > 0 and price < 99999 then 
    else
        price = 1000
    end
    exports['vNotif']:createNotification({
        type = 'ILLEGAL',
        name = "Indic",
        label = "Remorque",
        labelColor = "#E81010",
        logo = NotifImageIA[math.random(1, #NotifImageIA)].lien,
        mainMessage = "Hey, j'ai apperçu une remorque avec des véhicules intéressants que tu peux péter !",
        duration = 10,
    })
    blipTrail = AddBlipForCoord(start)
    SetBlipSprite(blipTrail, 477)
    SetBlipScale(blipTrail, 0.75)
    SetBlipColour(blipTrail, 1)
    SetBlipAsShortRange(blipTrail, true)
    SetBlipRoute(blipTrail, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName("~r~Camion")
    EndTextCommandSetBlipName(blipTrail)
    local fin = randomtrajet
    local offset = GetOffsetFromEntityInWorldCoords(truk, 0.0, -5.0, 0.0)
    local vehCoords = GetEntityCoords(truk)
    SetEntityCoords(trailer, offset)
    local vehRotation = GetEntityRotation(truk)
    AttachVehicleToTrailer(truk, trailer, 15.0)
    while not IsVehicleAttachedToTrailer(truk) do 
        Wait(500)
        print("Try attach", DoesEntityExist(truk), DoesEntityExist(trailer))
        AttachVehicleToTrailer(truk, trailer, 50.0)
    end
    if not ped then 
        ped = entity:CreatePed("s_m_m_trucker_01", vector4(vehCoords.x, vehCoords.y, vehCoords.z, 0.0)).id
    end
    NetworkRequestControlOfEntity(ped)
    TaskWarpPedIntoVehicle(ped, truk, -1)
    SetBlockingOfNonTemporaryEvents(ped, true)
    while not IsPedInAnyVehicle(ped) do 
        Wait(500)
        TaskWarpPedIntoVehicle(ped, truk, -1)
    end
    TaskVehicleDriveToCoordLongrange(ped, truk, vector3(-3037.6330566406, 121.57885742188, 10.605253219604), 50.0, 427, 5.0);
    AttachEntityToEntity(vehone, trailer, GetEntityBoneIndexByName(trailer, 'chassis'), GetOffsetFromEntityGivenWorldCoords(trailer, GetEntityCoords(trailer)) + vector3(0.0, 0.0, 1.0), 0.0, 0.0, 0.0, false, false, true, false, 20, true)
    Wait(500)
    AttachEntityToEntity(vehtwo, trailer, GetEntityBoneIndexByName(trailer, 'chassis'), GetOffsetFromEntityGivenWorldCoords(trailer, GetEntityCoords(trailer)) + vector3(0.0, 5.0, 1.0), 0.0, 0.0, 0.0, false, false, true, false, 20, true)
    Wait(500)
    AttachEntityToEntity(vehthree, trailer, GetEntityBoneIndexByName(trailer, 'chassis'), GetOffsetFromEntityGivenWorldCoords(trailer, GetEntityCoords(trailer)) + vector3(0.0, -5.0, 1.0), 0.0, 0.0, 0.0, false, false, true, false, 20, true)
    local rotationtrois = GetEntityRotation(PlayerPedId())
    SetEntityRotation(vehthree, rotationtrois.x + 50.0, rotationtrois.y, rotationtrois.z)

    pedNoir = entity:CreatePedLocal("g_m_m_armboss_01", vector3(-599.59210205078, 2102.6384277344, 128.43081665039), 57.327644348145)
    pedNoir:setFreeze(true)
    SetEntityInvincible(pedNoir.id, true)
    SetEntityAsMissionEntity(pedNoir.id, 1, 1)
    SetBlockingOfNonTemporaryEvents(pedNoir.id, true)

    CreateThread(function()
        local hasaimed = false
        local attache = false
        while true do 
            Wait(1)
            if shouldBreakTheTrailer then 
                break
            end
            if GetVehiclePedIsTryingToEnter(PlayerPedId()) == vehone then 
                SetPedIntoVehicle(PlayerPedId(), vehone, -1)
                SetNewWaypoint(-599.59210205078, 2102.6384277344)
            end
            if GetVehiclePedIsTryingToEnter(PlayerPedId()) == vehtwo then 
                SetPedIntoVehicle(PlayerPedId(), vehtwo, -1)
                SetNewWaypoint(-599.59210205078, 2102.6384277344)
            end
            if GetVehiclePedIsTryingToEnter(PlayerPedId()) == vehthree then 
                SetPedIntoVehicle(PlayerPedId(), vehthree, -1)
                SetNewWaypoint(-599.59210205078, 2102.6384277344)
            end
            if GetDistanceBetweenCoords(GetEntityCoords(truk), fin) < 5.0 then 
                DeleteEntity(truk)
                DeleteEntity(ped)
                DeleteEntity(trailer)
                DeleteEntity(vehone)
                DeleteEntity(vehtwo)
                DeleteEntity(vehthree)
            end
            Bulle.create("trailerSell", vector3(-600.05743408203, 2102.9006347656, 130.26669311523), "bulleVendre", true)
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(-600.05743408203, 2102.9006347656, 130.26669311523)) < 3.0 then 
                if IsControlJustPressed(0, 38) then 
                    print("pressed")
                    print(GetEntityCoords(vehone))
                    print(GetEntityCoords(vehtwo))
                    print(GetEntityCoords(vehthree))
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),GetEntityCoords(vehone)) < 20.0 then 
                        DeleteEntity(vehone)
                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            -- duration = 5, -- In seconds, default:  4
                            content = "Vous avez vendu le véhicule pour~s " .. price .."$"
                        })
                        TriggerSecurGiveEvent("core:addItemToInventory", token, "money", price, {})
                    end
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),GetEntityCoords(vehtwo)) < 20.0 then 
                        DeleteEntity(vehtwo)
                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            -- duration = 5, -- In seconds, default:  4
                            content = "Vous avez vendu le véhicule pour~s " .. price .."$"
                        })
                        TriggerSecurGiveEvent("core:addItemToInventory", token, "money", price, {})
                    end
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),GetEntityCoords(vehthree)) < 20.0 then 
                        DeleteEntity(vehthree)
                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            -- duration = 5, -- In seconds, default:  4
                            content = "Vous avez vendu le véhicule pour~s " .. price .."$"
                        })
                        TriggerSecurGiveEvent("core:addItemToInventory", token, "money", price, {})
                    end
                end
            end
            if not DoesEntityExist(vehone) and not DoesEntityExist(vehone) and not DoesEntityExist(vehthree) then 
                TriggerServerEvent("core:events:trailer:finished")
                break
            end
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(truk)) < 20.0 then 
                if IsPlayerFreeAiming(PlayerId()) then 
                    if not hasaimed then
                        hasaimed = true
                        BringVehicleToHalt(truk, 5.0, 1.0)
                        ClearPedTasks(ped)
                        TaskLeaveVehicle(ped, truk, 0)
                        RequestAnimDict("random@mugging3")
                        while not HasAnimDictLoaded("random@mugging3") do
                            Wait(0)
                        end
                        TaskPlayAnim(ped, "random@mugging3", "handsup_standing_base", 1.0, 1.0, -1, 49, 1.0)
                        StopBringVehicleToHalt(truk)
                    end
                end
                if hasaimed then
                    -- Attach ped
                    if not attache then
                        Bulle.create("attachpedt", GetEntityCoords(ped) + vector3(0.0, 0.0, 1.0), "bulleAttacher", true)
                        if GetDistanceBetweenCoords(GetEntityCoords(p:ped()), GetEntityCoords(ped)) < 2.0 then 
                            if IsControlJustPressed(0, 38) then 
                                attache = true
                                p:PlayAnim('mp_arresting', 'a_uncuff', 1)
                                Modules.UI.RealWait(4000)
                                ClearPedTasks(p:ped())
                                ClearPedTasks(ped)
                                PlayEmoteOnPed(ped, "mp_arresting", "idle", 49, -1)
                                PlayEmoteOnPed(ped, "random@arrests@busted", "idle_a", 1, -1)
                                Bulle.hide("attachpedt")
                                Bulle.remove("attachpedt")
                            end
                        end
                    end
                    -- All vehicles
                    if attache then
                        local coords = GetOffsetFromEntityInWorldCoords(trailer, -2.0, -7.6, 0.25)
                        if not hideLastbulle then
                            Bulle.create("trailerHeist", coords, "bulleAttacher", true)
                        end
                        if GetDistanceBetweenCoords(coords, GetEntityCoords(PlayerPedId())) < 2.0 then
                            if IsControlJustPressed(0, 38) then 
                                SetVehicleDoorOpen(trailer, 5, false, false)
                                DetachEntity(vehone)
                                DetachEntity(vehtwo)
                                DetachEntity(vehthree)
                                hideLastbulle = true
                                Bulle.hide("trailerHeist")
                                Bulle.remove("trailerHeist")
                            end
                        end
                    end
                end
            end
        end
    end)
end

RegisterNetEvent("core:events:trailer:finished", function()
    RemoveBlip(blipTrail)
    shouldBreakTheTrailer = true
    Bulle.remove("trailerSell")
    DeleteEntity(pedNoir)
end)