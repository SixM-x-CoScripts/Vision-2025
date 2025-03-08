local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local vehicleThieft = nil
function HookVehicleLSPD()
    CreateThread(function()
        vehicleThieft = nil
        local vehicle, dst = GetClosestVehicle(p:pos())
        local random = math.random(0, 100)

        if dst < 1.5 then
            local seat = GetVehicleModelNumberOfSeats(GetEntityModel(vehicle))
            for i = -1, seat - 2 do
                if not IsVehicleSeatFree(vehicle, i) then
                    -- ShowNotification("~r~Il y a quelqu'un dans le vehicule")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Il y a quelqu'un dans le vehicule"
                    })

                    return
                end
            end
            SetEntityAsMissionEntity(vehicle, true, true)
            SetVehicleHasBeenOwnedByPlayer(vehicle, true)
            RequestAnimDict('missheistfbisetup1')
            while not HasAnimDictLoaded('missheistfbisetup1') do
                Wait(0)
            end
            TaskPlayAnim(PlayerPedId(), 'missheistfbisetup1' , 'hassle_intro_loop_f' ,8.0, -8.0, -1, 1, 0, false, false, false )
            SendNuiMessage(json.encode({
                type = 'openWebview',
                name = 'Progressbar',
                data = {
                    text = "Crochetage en cours...",
                    time = 10,
                }
            }))
            RemoveAnimDict("missheistfbisetup1")
            Wait(10000)
            ClearPedTasks(p:ped())
            NetworkRequestControlOfEntity(vehicle)
            SetVehicleDoorsLocked(vehicle, 0)
            SetVehicleDoorsLockedForAllPlayers(vehicle, false)
            SetVehicleUndriveable(vehicle, true)
            -- ShowNotification("~g~Vous avez crocheté le vehicule")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Vous avez crocheté le vehicule"
            })

        else
            local randomAlarm = math.random(0, 100)
            if randomAlarm < 10 then
                SetVehicleAlarm(vehicle, true)
                SetVehicleAlarmTimeLeft(vehicle, 30000)
            end
            -- ShowNotification("~r~Vous n'êtes pas à proximité d'un véhicule")
        end
    end)
end

function HookVehicle()

    CreateThread(function()
        vehicleThieft = nil
        local vehicle, dst = GetClosestVehicle(p:pos())
        local random = math.random(0, 100)

        if dst < 3.5 then

            local seat = GetVehicleModelNumberOfSeats(GetEntityModel(vehicle))
            for i = -1, seat - 2 do
                if not IsVehicleSeatFree(vehicle, i) then
                    -- ShowNotification("~r~Il y a quelqu'un dans le vehicule")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Il y a quelqu'un dans le vehicule"
                    })

                    return
                end
            end

            local vehicleClass = GetVehicleClass(vehicle)
--[[ 
            print(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))

            print(vehicleClass) ]]

            if vehicleClass == 15 or vehicleClass == 16 or vehicleClass == 19 or vehicleClass == 17 then
                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Il est impossible de ~s crocheter ce véhicule"
                })
                return
            else

                RequestAnimDict('missheistfbisetup1')
                while not HasAnimDictLoaded('missheistfbisetup1') do
                    Wait(1)
                end
                for _, value in pairs(p:getInventaire()) do
                    if value.name == "crochet" then
                        TriggerServerEvent("core:RemoveItemToInventory", token, "crochet", 1, value.metadatas)
                    end
                end
                SetEntityAsMissionEntity(vehicle, true, true)
                SetVehicleHasBeenOwnedByPlayer(vehicle, true)
                TaskPlayAnim(PlayerPedId(), 'missheistfbisetup1' , 'hassle_intro_loop_f' ,8.0, -8.0, -1, 1, 0, false, false, false )
                RemoveAnimDict("missheistfbisetup1")
                --SendNuiMessage(json.encode({
                --    type = 'openWebview',
                --    name = 'Progressbar',
                --    data = {
                --        text = "Crochetage en cours...",
                --        time = 40,
                --    }
                --}))
                --Modules.UI.RealWait(40000)                
                TriggerSecurEvent('core:makeCall', "lspd", p:pos(), true, "Vol de véhicule", false, nil)
                TriggerSecurEvent('core:makeCall', "lssd", p:pos(), true, "Vol de véhicule", false, nil)
                TriggerSecurEvent('core:makeCall', "gcp", p:pos(), true, "Vol de véhicule", false, nil)
                if Serveur == "FA" then
                    OpenTutoFAInfo("Vol de véhicule", "Utilisez ZQSD ou les fleches pour deplacer la goupille")
                elseif Serveur == "WL" then
                    OpenTutoWLInfo("Vol de véhicule", "Utilisez ZQSD ou les fleches pour deplacer la goupille")
                end
                local result = exports['lockpick']:startLockpick()
                while result == nil do 
                    Wait(1)
                end
                if Serveur == "FA" then
                    exports['tuto-fa']:HideStep()
                elseif Serveur == "WL" then
                    exports['tuto-wl']:HideStep()
                end
                if not result then 
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Vous avez cassé votre crochet !"
                    })
                    DeleteCrochet()
                    ClearPedTasks(PlayerPedId())
                    return 
                end
                useCrochet = false
                inHeist = false
                ClearPedTasks(p:ped())
                NetworkRequestControlOfEntity(vehicle)
                SetVehicleDoorsLocked(vehicle, 0)
                SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                local hookVariable = GetVariable("heist").hook
                ActionInTerritoire(p:getCrew(), GetZoneByPlayer(), hookVariable.influence or 5, 6, coordsIsInSouth(GetEntityCoords(PlayerPedId())))
                SetVehicleUndriveable(vehicle, true)
                TriggerSecurEvent("core:crew:updateXp", token, tonumber(hookVariable.xp), "add", p:getCrew(), "hook")

                -- ShowNotification("~g~Vous avez crocheté le vehicule")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Vous avez crocheté le vehicule"
                })

                vehicleThieft = vehicle
                StartVehicleLoop()
                TriggerServerEvent("core:hooklog", p:pos(), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))), GetVehicleNumberPlateText(vehicle))
            end
        else
            local randomAlarm = math.random(0, 100)
            if randomAlarm < 10 then
                SetVehicleAlarm(vehicle, true)
                SetVehicleAlarmTimeLeft(vehicle, 30000)
            end
            -- ShowNotification("~r~Vous n'êtes pas à proximité d'un véhicule")
        end
    end)
end

function StartVehicleLoop()
    SetVehicleAlarm(vehicleThieft, true)
    TaskEnterVehicle(PlayerPedId(), vehicleThieft, -1, -1, 1.0, 1, 0)
    SetVehicleAlarm(vehicleThieft, true)
    SetVehicleAlarmTimeLeft(vehicleThieft, 50000)
    SetFollowPedCamViewMode(4)   
    CreateThread(function()
        local timer = GetGameTimer() + 15000
        local start = false
        local minigame = false
        while vehicleThieft ~= nil do
            Wait(0)
            if GetGameTimer() > timer and not IsPedInVehicle(p:ped(), vehicleThieft, true) then
                SetVehicleDoorsLocked(vehicleThieft, 2)
                return
            elseif IsPedInVehicle(p:ped(), vehicleThieft) then
                local coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
                local newCoords = (coords + forward * 1.1) + vector3(0.0, -0.4, 0.3)
                if not minigame then 
                    SetFollowPedCamViewMode(4)   
                    p:PlayAnim('anim@amb@carmeet@checkout_car@male_a@idles', 'idle_b', 49)     
                    minigame = true 
                    TriggerEvent("Mx::StartMinigameElectricCircuit", "50%", "90%", 1.0, "30vmin", "1.ogg", function()
                        start = true
                        ClearPedTasks(PlayerPedId())
                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            -- duration = 5, -- In seconds, default:  4
                            content = 'Vous avez volé le véhicule'
                        })
                        SetVehicleEngineOn(p:currentVeh(), false, false, false)
                    end)
                end
                if IsVehicleEngineStarting(vehicleThieft) then
                    SetVehicleEngineOn(p:currentVeh(), false, true, true)
                end
                if not IsVehicleEngineStarting(vehicleThieft) and start and p:currentVeh() then
                    Wait(2000)
                    SetVehicleEngineOn(p:currentVeh(), true, true, true)
                    SetFollowPedCamViewMode(2)
                    SetTimeout(10000, function()
                        SetVehicleUndriveable(vehicleThieft, false)
                        SetVehicleAlarmTimeLeft(vehicleThieft, 30000)
                    end)
                    start = false
                    -- stop the alarm after 30 seconds
                    SetTimeout(40000, function()
                        SetVehicleAlarm(vehicleThieft, false)
                    end)
                    return
                end
                -- return
            end
        end
    end)
end

RegisterNetEvent("core:hookVehicle")
AddEventHandler("core:hookVehicle", function()
    HookVehicle()
end)