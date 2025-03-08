
RegisterNetEvent("core:events:camion", function(orga, camion, pedDrive, co)
    if orga then 
        if orga ~= "tout le monde" then 
            if string.lower(orga) ~= string.lower(p:getCrewType()) then
                return
            end
        end
    end
    camion = NetworkGetEntityFromNetworkId(camion)
    pedDrive = NetworkGetEntityFromNetworkId(pedDrive)
    print(pedDrive)
    SetBlockingOfNonTemporaryEvents(pedDrive, true)
    exports['vNotif']:createNotification({
        type = 'ILLEGAL',
        name = "Indic",
        label = "Camion",
        labelColor = "#E81010",
        logo = NotifImageIA[math.random(1, #NotifImageIA)].lien,
        mainMessage = "Hey, j'ai apperçu une cargaison d'arme que tu peux péter !",
        duration = 10,
    })
    CreateEventCamion(camion, pedDrive, co)
end)

local hasaimed = false
local blipCamion = nil

RegisterNetEvent("core:event:camionupdate", function(coords)
    if blipCamion then 
        SetBlipCoords(blipCamion, coords)
        SetBlipRoute(blipCamion, true)
    end
end)

function CreateEventCamion(camion, pedDrive, co)
    hasaimed = false
    
    blipCamion = AddBlipForCoord(co)
    SetBlipSprite(blipCamion, 477)
    SetBlipScale(blipCamion, 0.75)
    SetBlipColour(blipCamion, 1)
    SetBlipAsShortRange(blipCamion, true)
    SetBlipRoute(blipCamion, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName("~r~Camion")
    EndTextCommandSetBlipName(blipCamion)

    SetVehicleDoorsLocked(camion, 0)
    TaskVehicleDriveToCoord(pedDrive, camion, vector3(2749.3508300781, 3445.0034179688, 55.117046356201), 40.0, 0, GetEntityModel(camion), 786603, 5.0, 1.0)
    TaskVehicleDriveToCoordLongrange(pedDrive, camion, vector3(2749.3508300781, 3445.0034179688, 55.117046356201), 50.0, 427, 5.0);
    SetBlockingOfNonTemporaryEvents(pedDrive, true)
    print("task drive")

    while true do 
        Wait(5)
        if GetDistanceBetweenCoords(GetEntityCoords(camion),vector3(2749.3508300781, 3445.0034179688, 55.117046356201)) < 10.0 then 
            DeleteEntity(pedDrive)
            DeleteEntity(camion)
            break
        end

        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(camion)) < 20.0 then 
            if IsPlayerFreeAiming(PlayerId()) then 
                if not hasaimed then
                    hasaimed = true
                    BringVehicleToHalt(camion, 5.0, 1.0)
                    ClearPedTasks(pedDrive)
                    TaskLeaveVehicle(pedDrive, camion, 0)
                    RequestAnimDict("random@mugging3")
                    while not HasAnimDictLoaded("random@mugging3") do
                        Wait(0)
                    end
                    TaskPlayAnim(pedDrive, "random@mugging3", "handsup_standing_base", 1.0, 1.0, -1, 49, 1.0)
                    StopBringVehicleToHalt(camion)
                end
            end
            if hasaimed then
                -- Attach pedDrive
                if not attache then
                    Bulle.create("attachpedt", GetEntityCoords(pedDrive) + vector3(0.0, 0.0, 1.0), "bulleAttacher", true)
                    if GetDistanceBetweenCoords(GetEntityCoords(p:ped()), GetEntityCoords(pedDrive)) < 2.0 then 
                        if IsControlJustPressed(0, 38) then 
                            attache = true
                            p:PlayAnim('mp_arresting', 'a_uncuff', 1)
                            Modules.UI.RealWait(4000)
                            ClearPedTasks(p:ped())
                            ClearPedTasks(pedDrive)
                            PlayEmoteOnPed(pedDrive, "mp_arresting", "idle", 49, -1)
                            PlayEmoteOnPed(pedDrive, "random@arrests@busted", "idle_a", 1, -1)
                            Bulle.hide("attachpedt")
                            Bulle.remove("attachpedt")
                        end
                    end
                end
            end
        end
    end
end
