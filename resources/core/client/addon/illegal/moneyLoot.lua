local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local data = nil
local function DisplayText(gxt, msg)
    RequestAdditionalText(gxt, 3)
    while not HasAdditionalTextLoaded(3) do
        Citizen.Wait(1)
    end
    DisplayHelpTextThisFrame(msg, 1)
end

function moneyLoot(Trolley, rewardMoney, returnPos, forceFirstCam, removeNotif)
    if forceFirstCam then 
        SetFollowPedCamViewMode(4)
    end
    TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
    local model = "hei_prop_heist_cash_pile"
    RequestModel(GetHashKey(model))
    RequestModel(GetHashKey("hei_p_m_bag_var22_arm_s"))
    RequestAnimDict("anim@heists@ornate_bank@grab_cash")
    while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") or not HasModelLoaded(GetHashKey(model)) do
        Citizen.Wait(1)
    end
    GrabBag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), GetEntityCoords(PlayerPedId()), false, false, false)
    FreezeEntityPosition(GrabBag, true)
    SetEntityInvincible(GrabBag, true)
    SetEntityNoCollisionEntity(GrabBag, PlayerPedId())
    FreezeEntityPosition(GrabBag, true)

    Multiply = 1
    Sceneid = 0
    local started = true
    local breakall = false
    Triggerreset = false
    local phase = 0
    local grabreset = false
    Nores = false
    local firsttime1 = true
    local firsttime2 = true
    local startingphase = 0.1566388
    if data ~= nil then
        startingphase = data
    end
    local l, m, n = GetEntityRotation(Trolley)
    Grab2 = CreateSynchronizedScene(GetEntityCoords(Trolley), 0.0, 0.0, n, 2, 1065353216, 0, 1065353216)
    PlaySynchronizedEntityAnim(Trolley, Grab2, "cart_cash_dissapear", "anim@heists@ornate_bank@grab_cash", 1000.0, -4.0, 1)
    SetSynchronizedScenePhase(Grab2, startingphase)
    SetSynchronizedSceneRate(Grab2, 0.0)
    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        while true do
            if IsEntityPlayingAnim(ped, "anim@heists@ornate_bank@grab_cash", "grab", 3) then
                if HasAnimEventFired(ped, GetHashKey("CASH_APPEAR")) then
                    phase = GetSynchronizedScenePhase(Grab2) + 0.01007371
                    if not IsEntityVisible(CashProp) then
                        SetEntityVisible(CashProp, true, false)
                    end
                end
                if HasAnimEventFired(ped, GetHashKey("RELEASE_CASH_DESTROY")) then
                    if Multiply >= 0 then
                        Multiply = Multiply - 1
                    end
                    Triggerreset = true
                    if Triggerreset then
                        if Multiply == 0 then
                            DeleteEntity(CashProp)
                            SetEntityAsNoLongerNeeded(CashProp)
                            SetSynchronizedSceneRate(Grab2, 0.0)
                            Sceneid = 10
                            Triggerreset = false
                            Nores = false
                        elseif Multiply == 1 then
                            if IsEntityVisible(CashProp) then
                                SetEntityVisible(CashProp, false, false)
                            end
                            SetSynchronizedSceneRate(Grab2, 0.85)
                            Triggerreset = false
                            Sceneid = 10
                        elseif Multiply == 2 then
                            if IsEntityVisible(CashProp) then
                                SetEntityVisible(CashProp, false, false)
                            end
                            SetSynchronizedSceneRate(Grab2, 1.05)
                            Triggerreset = false
                            Sceneid = 10
                        elseif Multiply == 3 then
                            if IsEntityVisible(CashProp) then
                                SetEntityVisible(CashProp, false, false)
                            end
                            SetSynchronizedSceneRate(Grab2, 1.2)
                            Triggerreset = false
                            Sceneid = 10
                        elseif Multiply == 4 then
                            if IsEntityVisible(CashProp) then
                                SetEntityVisible(CashProp, false, false)
                            end
                            SetSynchronizedSceneRate(Grab2, 1.42)
                            Triggerreset = false
                            Sceneid = 10
                        end
                    end
                end
            end
            if breakall then
                break
            end
            Citizen.Wait(1)
        end
    end)
    Citizen.CreateThread(function()
        while true do
            if (Sceneid == 10) or (Sceneid == 20) then
                if not removeNotif then
                    if IsControlJustPressed(2, 237) then
                        if not grabreset and not Nores then
                            grabreset = true
                        end
                        if Multiply == 0 then
                            SetSynchronizedSceneRate(Grab2, 0.85)
                            Multiply = Multiply + 1
                            Sceneid = 20
                        elseif Multiply == 1 then
                            SetSynchronizedSceneRate(Grab2, 1.05)
                            Multiply = Multiply + 1
                            Sceneid = 20
                        elseif Multiply == 2 then
                            SetSynchronizedSceneRate(Grab2, 1.20)
                            Multiply = Multiply + 1
                            Sceneid = 20
                        elseif Multiply == 3 then
                            SetSynchronizedSceneRate(Grab2, 1.42)
                            Multiply = Multiply + 1
                            Sceneid = 20
                        end
                    end
                else
                    if not grabreset and not Nores then
                        grabreset = true
                    end
                    if Multiply == 0 then
                        SetSynchronizedSceneRate(Grab2, 0.85)
                        Multiply = Multiply + 1
                        Sceneid = 20
                    elseif Multiply == 1 then
                        SetSynchronizedSceneRate(Grab2, 1.05)
                        Multiply = Multiply + 1
                        Sceneid = 20
                    elseif Multiply == 2 then
                        SetSynchronizedSceneRate(Grab2, 1.20)
                        Multiply = Multiply + 1
                        Sceneid = 20
                    elseif Multiply == 3 then
                        SetSynchronizedSceneRate(Grab2, 1.42)
                        Multiply = Multiply + 1
                        Sceneid = 20
                    end
                    if IsControlJustPressed(2, 238) or IsControlJustPressed(0, 73) then
                        DeleteEntity(CashProp)
                        Sceneid = 30
                    end
                    Wait(750)
                end
            end
            if breakall then
                break
            end
            Citizen.Wait(1)
        end
    end)
    Citizen.CreateThread(function()
        while true do
            local ped = PlayerPedId()

            if not removeNotif then
                if (Sceneid == 10) or (Sceneid == 20) then
                    DisplayText("HACK", "MC_GRAB_3_MK")
                end
            end
            if started then
                if Sceneid == 0 then
                    if not IsSynchronizedSceneRunning(Grab1) then
                        local x, y, z = table.unpack(GetEntityCoords(Trolley))
                        local rotx, roty, rotz = table.unpack(GetEntityRotation(Trolley))

                        Grab1 = CreateSynchronizedScene(x, y, z, 0.0, 0.0, rotz, 2, true, false, 1065353216, 0, 1065353216)
                        if DoesEntityExist(GrabBag) then
                            PlaySynchronizedEntityAnim(GrabBag, Grab1, "bag_intro", "anim@heists@ornate_bank@grab_cash", 1.0, -1.0, 0, 0x447a0000)
                            ForceEntityAiAndAnimationUpdate(GrabBag)
                        end
                        TaskSynchronizedScene(ped, Grab1, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -1.0, 13, 16, 1.5, 0)
                        Grab2 = CreateSynchronizedScene(x, y, z, 0.0, 0.0, rotz, 2, true, false, 1065353216, 1.0, 0.0)
                    elseif IsSynchronizedSceneRunning(Grab1) then
                        if GetSynchronizedScenePhase(Grab1) >= 0.99 then
                            Sceneid = 10
                        end
                    end
                elseif Sceneid == 10 then
                    local x, y, z = table.unpack(GetEntityCoords(Trolley))
                    local rotx, roty, rotz = table.unpack(GetEntityRotation(Trolley))

                    if not IsSynchronizedSceneRunning(Grab1) then
                        if Multiply == 0 then
                            Grab2 = CreateSynchronizedScene(x, y, z, 0.0, 0.0, rotz, 2, true, false, 1065353216, 1.0, 0.0)
                            if DoesEntityExist(Trolley) then
                                PlaySynchronizedEntityAnim(Trolley, Grab2, "cart_cash_dissapear", "anim@heists@ornate_bank@grab_cash", 1000.0, -4.0, 1)
                                ForceEntityAiAndAnimationUpdate(Trolley)
                                SetSynchronizedScenePhase(Grab2, phase)
                                SetSynchronizedSceneRate(Grab2, 0.0)
                            end
                            Grab1 = CreateSynchronizedScene(x, y, z, 0.0, 0.0, rotz, 2, false, true, 1065353216, 0, 1065353216)
                            if DoesEntityExist(GrabBag) then
                                PlaySynchronizedEntityAnim(GrabBag, Grab1, "bag_grab_idle", "anim@heists@ornate_bank@grab_cash", 1000.0, 1.0, 0, 0x447a0000)
                                ForceEntityAiAndAnimationUpdate(GrabBag)
                            end
                            TaskSynchronizedScene(ped, Grab1, "anim@heists@ornate_bank@grab_cash", "grab_idle", 2.0, 1.0, 13, 16, 1148846080, 0)
                        end
                    end
                    if Multiply > 0 then
                        Sceneid = 20
                    elseif GetSynchronizedScenePhase(Grab2) == 1.0 then
                        Sceneid = 30
                    else
                        if IsControlJustPressed(2, 238) or IsControlJustPressed(0, 73) then
                            DeleteEntity(CashProp)
                            Sceneid = 30
                        end
                    end
                elseif Sceneid == 20 then
                    local x, y, z = table.unpack(GetEntityCoords(Trolley))
                    local rotx, roty, rotz = table.unpack(GetEntityRotation(Trolley))

                    if grabreset then
                        TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
                        Nores = true
                        Grab2 = CreateSynchronizedScene(x, y, z, 0.0, 0.0, rotz, 2, true, false, 1065353216, 1.0, 0.0)
                        SetSynchronizedSceneRate(Grab2, 0.89)
                        if DoesEntityExist(GrabBag) then
                            PlaySynchronizedEntityAnim(GrabBag, Grab2, "bag_grab", "anim@heists@ornate_bank@grab_cash", 1000.0, 1.0, 0, 0x447a0000)
                            if firsttime1 then
                                SetSynchronizedScenePhase(Grab1, startingphase)
                                phase = startingphase
                                firsttime1 = false
                            end
                            ForceEntityAiAndAnimationUpdate(GrabBag)
                        end
                        TaskSynchronizedScene(ped, Grab2, "anim@heists@ornate_bank@grab_cash", "grab", 4.0, 1.0, 13, 16, 1148846080, 0)
                        if DoesEntityExist(Trolley) then
                            SetSynchronizedScenePhase(Grab2, phase)
                            CashProp = CreateObject(GetHashKey(model), GetEntityCoords(ped), false, false)
                            FreezeEntityPosition(CashProp, true)
                            SetEntityInvincible(CashProp, true)
                            SetEntityNoCollisionEntity(CashProp, ped)
                            SetEntityVisible(CashProp, false, false)
                            AttachEntityToEntity(CashProp, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                            PlaySynchronizedEntityAnim(Trolley, Grab2, "cart_cash_dissapear", "anim@heists@ornate_bank@grab_cash", 1000.0, -4.0, 1)
                            if removeNotif then
                                CreateThread(function()
                                    while Sceneid ~= 30 do 
                                        Wait(2000)
                                        local mathran = math.random(rewardMoney.min, rewardMoney.max)
                                        TriggerSecurGiveEvent("core:addItemToInventory", token, "money", mathran, {})
                                        exports['vNotif']:createNotification({
                                            type = 'JAUNE',
                                            -- duration = 5, -- In seconds, default:  4
                                            content = "~c Vous avez récupéré " .. mathran .. "$"
                                        })
                                        if Sceneid == 30 then
                                            break
                                        end
                                        if Nores == false then
                                            Sceneid = 30
                                            break
                                        end
                                    end
                                end)
                            end
                            if firsttime2 then
                                SetSynchronizedScenePhase(Grab1, startingphase)
                                firsttime2 = false
                            end
                            ForceEntityAiAndAnimationUpdate(Trolley)
                            grabreset = false
                        end
                    end
                elseif Sceneid == 30 then
                    local x, y, z = table.unpack(GetEntityCoords(Trolley))
                    local rotx, roty, rotz = table.unpack(GetEntityRotation(Trolley))

                    Grab2 = CreateSynchronizedScene(x, y, z, 0.0, 0.0, rotz, 2, true, false, 1065353216, 1.0, 0.0)
                    PlaySynchronizedEntityAnim(GrabBag, Grab2, "bag_exit", "anim@heists@ornate_bank@grab_cash", 1000.0, -1000.0, 0, 0x447a0000)
                    ForceEntityAiAndAnimationUpdate(GrabBag)
                    TaskSynchronizedScene(ped, Grab2, "anim@heists@ornate_bank@grab_cash", "exit", 4.0, -4.0, 13, 16, 1148846080, 0)
                    Grab1 = CreateSynchronizedScene(x, y, z, 0.0, 0.0, rotz, 2, false, true, 1065353216, 0, 1065353216)
                    PlaySynchronizedEntityAnim(Trolley, Grab1, "cart_cash_dissapear", "anim@heists@ornate_bank@grab_cash", 1000.0, -4.0, 1)
                    SetSynchronizedScenePhase(Grab1, phase)
                    SetSynchronizedSceneRate(Grab1, 0.0)
                    data = phase
                    Sceneid = 40
                elseif Sceneid == 40 then
                    if GetSynchronizedScenePhase(Grab2) >= 0.99 then
                        DeleteEntity(GrabBag)
                        SetEntityAsNoLongerNeeded(GrabBag)
                        ClearPedTasks(ped)
                        StopSynchronizedEntityAnim(Trolley, Grab1)
                        DisposeSynchronizedScene(Grab1)
                        DisposeSynchronizedScene(Grab2)
                        if returnPos then
                            SetEntityCoords(ped, returnPos)
                        end
                        grabreset = false
                        Multiply = 0
                        Nores = false
                        phase = 0
                        firsttime1 = true
                        firsttime2 = false
                        Sceneid = -1
                        started = false
                        Triggerreset = false
                        collectgarbage("collect")
                        if removeNotif then
                            DeleteEntity(Trolley)
                        end
                    end
                end
            end
            if breakall then
                break
            end
            if removeNotif then
                if IsControlJustPressed(0, 73) then
                    DeleteEntity(CashProp)
                    Sceneid = 30
                end
            end
            Citizen.Wait(1)
        end
    end)
end