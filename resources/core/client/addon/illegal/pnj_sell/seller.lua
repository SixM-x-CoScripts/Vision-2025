local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

--CreateThread(function()
--    local entity = entity:CreatePedLocal("s_m_m_chemsec_01",
--        vector3(-103.22554779053, 983.32354736328, 240.84280395508 - 1), 108.92496490479)
--    entity:setFreeze(true)
--    SetEntityAsMissionEntity(entity.id, true, false)
--    SetEntityInvincible(entity.id, true)
--    SetBlockingOfNonTemporaryEvents(entity.id, true)
--
--    zone.addZone("seller_int" .. math.random(1, 99999999), vector3(-103.22554779053, 983.32354736328, 240.84280395508),
--        "~INPUT_CONTEXT~ Intéragir", function()
--        seller:openSeller()
--    end)
--end)


RegisterNetEvent("core:putSerflex")
AddEventHandler("core:putSerflex", function()
    local closestPlayer = ChoicePlayersInZone(5.0, true)
    if closestPlayer == nil then
        return
    end
    local sID = GetPlayerServerId(closestPlayer)
    if sID > 0 then
        local headInbag = TriggerServerCallback("core:getSerflexedPly", sID)
        if not headInbag then
            TriggerServerEvent('core:setSerflexToPly', token, sID)
            -- ShowNotification("Vous avez ~r~attaché~s~ l'individu")

            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s attaché ~c l'individu"
            })

        else
            -- ShowNotification("L'individu est déjà ~r~attaché~s~")

            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "L'individu est déjà ~s attaché"
            })

        end
    else
        -- ShowNotification("Aucun ~b~individu~s~ à proximité")

        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Aucun ~s individu ~c à proximité"
        })

    end
end)

local objSerflex = nil
local handSerflex = nil
local isSerflexHand = false
local plySerflexed = false

RegisterNetEvent("core:handSerflex")
AddEventHandler("core:handSerflex", function()
    isSerflexHand = not isSerflexHand
    if isSerflexHand then
        local playerPed = PlayerPedId()
        TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
        SetPlayerControl(PlayerId(), 11, false)
        DecorSetBool(playerPed, "Handcuffed", true)
        SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
        plySerflexed = true
        -- ShowNotification('Vous avez été ~r~attaché~s~')

        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez été ~s attaché"
        })

        --Keys.keysAllow = false
        SetPedCanPlayGestureAnims(playerPed, false)
        SetEnableHandcuffs(playerPed, true)
        SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
        LoadAnimDict('re@stag_do@idle_a')
        TaskPlayAnim(playerPed, 're@stag_do@idle_a', 'idle_a_ped', 8.0, -8, -1, 49, 0.0, false, false, false)
        local plyCoords = GetEntityCoords(PlayerPedId(), false)
        objSerflex = CreateObject(GetHashKey("hei_prop_zip_tie_positioned"), plyCoords.x, plyCoords.y, plyCoords.z, 1
            , 1, 1)
        AttachEntityToEntity(objSerflex, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), -0.05, -0.04,
            0.02, -200.0, -100.0, 110.0, 1, 0, 0, 0, 0, 1)
    end
end)


local controlLock = { 99, 57, 166, 167, 168, 288, 289, 311, 182, 24, 25, 82, 45, 80, 140, 22, 142, 37, 192, 204, 211, 349}

CreateThread(function()
    while true do
        local awaiting = 750
        local playerPed = PlayerPedId()
        local wasgettingup = false
        if not isSerflexHand and not IsControlEnabled(0, 140) then
            EnableControlAction(0, 140, true)
        end
        if isSerflexHand then
            awaiting = 0
            DisablePlayerFiring(playerPed, true)
            for k, v in pairs(controlLock) do
                DisableControlAction(2, v, true)
            end
            if not IsEntityPlayingAnim(playerPed, "re@stag_do@idle_a", "idle_a_ped", 3) and
                not IsEntityPlayingAnim(playerPed, "re@stag_do@idle_a", "idle_a_ped", 3) or
                (wasgettingup and not IsPedGettingUp(playerPed)) then
                LoadAnimDict('re@stag_do@idle_a')
                TaskPlayAnim(playerPed, "re@stag_do@idle_a", "idle_a_ped", 8.0, -8, -1, 49, 0, 0, 0, 0)
            end
            wasgettingup = IsPedGettingUp(playerPed)
        end
        Wait(awaiting)
    end
end)

RegisterNetEvent("core:removeToPlySerflex", function()
    local closestPlayer = ChoicePlayersInZone(5.0, true)
    if closestPlayer == nil then
        return
    end
    local sID = GetPlayerServerId(closestPlayer)
    if sID > 0 then
        local hasserflex = TriggerServerCallback("core:getSerflexedPly", sID)
        if not hasserflex then
            -- ShowNotification("L'individu n'est pas ~y~attaché~s~")

            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "L'individu n'est pas ~s attaché"
            })

        else
            TriggerServerEvent('core:unSerflexToPly', token, sID)
            -- ShowNotification("Vous avez ~g~détaché~s~ l'individu")

            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s détaché ~c l'individu et votre pince s'est cassée"
            })

        end
    else
        -- ShowNotification("Aucun ~b~individu~s~ à proximité")

        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Aucun ~s individu ~c à proximité"
        })

    end
end)

RegisterNetEvent("core:removehandSerflex", function()
    Keys.keysAllow = true
    isSerflexHand = false
    Wait(750)
    ClearPedTasks(PlayerPedId())
    DetachEntity(objSerflex, true)
    DeleteEntity(objSerflex)
    SetModelAsNoLongerNeeded(GetHashKey("hei_prop_zip_tie_positioned"))
    -- ShowNotification('Vous avez été ~b~détaché~s~')

    -- New notif
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        -- duration = 5, -- In seconds, default:  4
        content = "Vous avez été ~s détaché"
    })

end)

RegisterNetEvent("core:putBagHead", function()
    local closestPlayer = ChoicePlayersInZone(5.0, true)
    if closestPlayer == nil then
        return
    end
    local sID = GetPlayerServerId(closestPlayer)
    if sID > 0 then
        local headInbag = TriggerServerCallback("core:getHeadBag", sID)
        if not headInbag then
            TriggerServerEvent('core:setHeadBag', token, sID)
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Sac mis sur la ~s tête ~c de l'individu"
            })
        else
            TriggerServerEvent('core:removeHeadBag', token, sID)
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez enlevé le sac de tête..."
            })
        end
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Aucun ~s individu ~c à proximité"
        })

    end
end)