local CTXM = exports["ContextMenu"]

function getAdminSamePedActions(token, hitEntity, menu)
    menu = menu or 0
    local submenuAdminSamePed, submenuAdminSamePedItem = CTXM:AddSubmenu(menu, "Actions Staff")

    -- Godmode
    if p:getPermission() >= 5 then
        local godmode = CTXM:AddCheckboxItem(submenuAdminSamePed, "Godmode", vAdminMods.godmode)
        CTXM:OnActivate(godmode, function()
            vAdminMods.godmode = not vAdminMods.godmode
    
            if vAdminMods.godmode then
                TriggerServerEvent("core:staffActionLog", token, "Start godmod", "Soi-même")
            else
                TriggerServerEvent("core:staffActionLog", token, "Stop godmod", "Soi-même")
            end
        end)
    end

    -- Invisible
    local invisible = CTXM:AddCheckboxItem(submenuAdminSamePed, "Invisible", vAdminMods.invisible)
    CTXM:OnActivate(invisible, function()
        vAdminMods.invisible = not vAdminMods.invisible

        if vAdminMods.invisible then
            TriggerServerEvent("core:staffActionLog", token, "Start invisible", "Soi-même")
            SetEntityVisible(p:ped(), false)
        else
            TriggerServerEvent("core:staffActionLog", token, "Stop invisible", "Soi-même")
            SetEntityVisible(p:ped(), true)
        end
    end)

    -- Noms des Joueurs
    local names = CTXM:AddCheckboxItem(submenuAdminSamePed, "Noms des Joueurs", vAdminMods.playerNames)
    CTXM:OnActivate(names, function()
        vAdminMods.playerNames = not vAdminMods.playerNames

        if vAdminMods.playerNames then
            TriggerServerEvent("core:staffActionLog", token, "Start blips", "Soi-même")
            UseBlipsName(true)
            TogglePlayerNames()
        else
            TriggerServerEvent("core:staffActionLog", token, "Stop blips", "Soi-même")
            UseBlipsName(false)
            DestroyPlayerNames()
        end
    end)

    -- Blips Carte
    local blips = CTXM:AddCheckboxItem(submenuAdminSamePed, "Blips Carte", vAdminMods.blips)
    CTXM:OnActivate(blips, function()
        vAdminMods.blips = not vAdminMods.blips

        if vAdminMods.blips then
            UseBlipsName(true)
            ToggleGamerTag()
        else
            UseBlipsName(false)
            DestroyGamerTag()
        end
    end)

    -- Heal
    CTXM:AddItem(submenuAdminSamePed, "Heal", function()
        local ped = hitEntity
        local serverId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))

        if serverId then
            TriggerServerEvent("core:staffActionLog", token, "/heal", serverId)
            TriggerServerEvent("core:HealthPlayer", token, serverId)
        end
    end)
end

function getAdminPedActions(token, hitEntity, serverId, menu)
    menu = menu or 0
    local submenuAdminPed, submenuAdminPedItem = CTXM:AddSubmenu(menu, "Actions Staff")

    -- Ouvrir Menu Admin
    CTXM:AddItem(submenuAdminPed, "Voir dans le menu Admin", function() openPlayerOnAdminMenu(serverId) end)

    -- Envoyer un message
    CTXM:AddItem(submenuAdminPed, "Envoyer un message", function()
        local msg = KeyboardImput("Message", "")

        if msg ~= nil or msg ~= "" then
            TriggerServerEvent("core:SendMessage", token, serverId, msg)
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Message envoyé à ~s " .. serverId
            })
        end
    end)

    -- Envoyer un message chiant
    CTXM:AddItem(submenuAdminPed, "Envoyer un message chiant", function()
        local msg = KeyboardImput("Message", "")

        if msg ~= nil or msg ~= "" then
            TriggerServerEvent("core:vnotif:createAlert:player", token, msg, serverId)
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Message chiant envoyé à ~s " .. serverId
            })
        end
    end)

    -- Freeze
    local freeze = CTXM:AddCheckboxItem(submenuAdminPed, "Freeze", vAdminPlayer.freeze)
    CTXM:OnActivate(freeze, function()
        vAdminPlayer.freeze = not vAdminPlayer.freeze

        if vAdminPlayer.freeze then
            TriggerServerEvent("core:staffActionLog", token, "/freeze", serverId)
            TriggerServerEvent("core:FreezePlayer", token, serverId, true)
        else
            TriggerServerEvent("core:staffActionLog", token, "/unfreeze", serverId)
            TriggerServerEvent("core:FreezePlayer", token, serverId, false)
        end
    end)

    -- Revive 
    CTXM:AddItem(submenuAdminPed, "Revive", function()
        TriggerServerEvent("core:staffActionLog", token, "/revive", serverId)
        TriggerServerEvent("core:RevivePlayer", token, serverId, true)
    end)

    -- Kill
    CTXM:AddItem(submenuAdminPed, "Kill", function()
        TriggerServerEvent("core:staffActionLog", token, "/kill", serverId)
        TriggerServerEvent("core:KillPlayer", token, serverId)
    end)

    -- Heal
    CTXM:AddItem(submenuAdminPed, "Heal", function()
        TriggerServerEvent("core:staffActionLog", token, "/heal", serverId)
        TriggerServerEvent("core:HealthPlayer", token, serverId)
    end)

    -- Warn
    CTXM:AddItem(submenuAdminPed, "Warn", function()
        local reason = KeyboardImput("Raison du warn")

        if reason ~= nil and reason ~= "" then
            TriggerServerEvent("core:warn:addwarn:idonly", token, reason, serverId)
            
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez warn ~s " .. serverId
            })
            vAdminPlayer.refresh()
        end
    end)

    -- Kick
    CTXM:AddItem(submenuAdminPed, "Kick", function()
        local reason = KeyboardImput("Raison du kick")

        if reason ~= nil and reason ~= "" then
            TriggerServerEvent("core:staffSuivi", token, "kick", tonumber(serverId), reason)
            TriggerServerEvent("core:KickPlayer", token, serverId, reason)
        end
    end)

    -- Screen écran
    CTXM:AddItem(submenuAdminPed, "Screen écran", function()
        TriggerServerEvent("core:TakeScreenBiatch", token, serverId)

        exports['vNotif']:createNotification({
            type = 'VERT',
            content = "Vous avez pris un screen de ~s " .. serverId
        })
    end)
    
end

function getAdminVehActions(token, hitEntity, menu)
    menu = menu or 0

    local submenuAdminVeh, submenuAdminVehItem = CTXM:AddSubmenu(menu, "Actions Staff")

    -- Entrer dans un siège
    local submenuEnter, submenuEnterItem = CTXM:AddSubmenu(submenuAdminVeh, "Entrer dans un siège")
    for i = -1, GetVehicleMaxNumberOfPassengers(hitEntity), 1 do
        local itemEnter = CTXM:AddItem(submenuEnter, "Siège " .. i)
        CTXM:OnActivate(itemEnter, function()
            local vehicle = hitEntity
            if IsVehicleSeatFree(vehicle, i) then
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, i)
            end
        end)
    end


    -- Vérrouiller / Déverrouiller
    local lock = CTXM:AddCheckboxItem(submenuAdminVeh, "Vérrouiller", GetVehicleDoorLockStatus(hitEntity) == 2)
    CTXM:OnActivate(lock, function()
        if GetVehicleDoorLockStatus(hitEntity) <= 1 then
            NetworkRequestControlOfEntity(hitEntity)
            SetVehicleDoorsLocked(hitEntity, 2)
            SetVehicleDoorsLockedForAllPlayers(hitEntity, true)
            SetVehicleUndriveable(hitEntity, false)
        else
            NetworkRequestControlOfEntity(hitEntity)
            SetVehicleDoorsLocked(hitEntity, 0)
            SetVehicleDoorsLockedForAllPlayers(hitEntity, false)
            SetVehicleUndriveable(hitEntity, true)
        end
    end)

    -- Réparer
    CTXM:AddItem(submenuAdminVeh, "Réparer", function()
        local vehicle = hitEntity
        SetVehicleFixed(vehicle)
        SetVehicleBodyHealth(vehicle, 1000.0)
        SetVehicleEngineHealth(vehicle, 1000.0)
        SetVehicleDirtLevel(vehicle, 0.0)
    end)

    -- Upgrade
    CTXM:AddItem(submenuAdminVeh, "Upgrade", function()
        SetVehicleModKit(hitEntity, 0)
        for i = 0, 49 do
            if i ~= 11 and i ~= 12 and i ~= 13 and i ~= 14 and i ~= 15 and i ~= 18 and i ~= 22 then
                local max = GetNumVehicleMods(hitEntity, i) - 1
                if max > 0 then
                    SetVehicleMod(hitEntity, i, math.random(0, max), true)
                end
            end
        end
        for i = 11, 15 do
            local max = GetNumVehicleMods(hitEntity, i) - 1
            SetVehicleMod(hitEntity, i, max, true)
        end
        ToggleVehicleMod(hitEntity, 18, true)
        ToggleVehicleMod(hitEntity, 22, true)
        local props = vehicle.getProps(hitEntity)
        TriggerServerEvent("core:SetPropsVeh", token, props.plate, props)
    end)

    -- Supprimer
    CTXM:AddItem(submenuAdminVeh, "Supprimer l'entité", function()
        local vehicle = hitEntity
        deleteEntityAdmin(vehicle)
    end)
end