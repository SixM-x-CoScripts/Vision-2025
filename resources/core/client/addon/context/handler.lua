local CTXM = exports["ContextMenu"]
local RPEMOTES <const> = exports["rpemotes"]

local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local CONFIG = {
    isCarrying = false,
}

local function isCloseEnough(entity1, entity2, distance)
    if p:getPermission() >= 6 then return true end -- hehe

    local pos1 = GetEntityCoords(entity1)
    local pos2 = GetEntityCoords(entity2)
    return GetDistanceBetweenCoords(pos1, pos2, true) < distance
end

CreateThread(function()
    while p == nil do
        Wait(10)
    end

    CTXM:Register(function(screenPosition, hitSomething, worldPosition, hitEntity, normalDirection)
        local type = GetEntityType(hitEntity)
        local source = GetPlayerServerId(PlayerId())
        local distance = GetDistanceBetweenCoords(GetEntityCoords(p:ped()), GetEntityCoords(hitEntity), true)

        if type == 0 then -- Nothing
            if p:getPermission() >= 3 then
                -- TP 
                CTXM:AddItem(0, "Se téléporter ici", function()
                    local destination = worldPosition
                    SetEntityCoords(PlayerPedId(), destination)
                end)
            end

            -- Drop player if carrying
            if CONFIG.isCarrying then
                CTXM:AddItem(0, "Lâcher la personne", function() 
                    CONFIG.isCarrying = false
                    CarryPeople(hitEntity) 
                end)
            end

            if CurrentEscort then
                CTXM:AddItem(0, "Arrêter l'escorte", function() 
                    MoovePlayerCuffed(CurrentEscort, true)
                end)
            end

            if p:getPermission() >= 5 then
                CTXM:AddItem(0, "Heal zone", function()
                    TreatZone(75, vector3(worldPosition.x, worldPosition.y, worldPosition.z))
                end)
            end

            if p:getPermission() >= 6 then
                getServerActions(token, hitEntity)
                getDevNothingActions(worldPosition)
            end
        elseif type == 1 then -- Peds    
            local isPlayer = NetworkGetPlayerIndexFromPed(hitEntity)

            if isPlayer ~= -1 then
                local pId = GetPlayerServerId(isPlayer)
                local isSamePlayer = pId == source
                if not isSamePlayer then
                    CTXM:AddItem(0, "ID Joueur: " .. pId, function() TriggerEvent("addToCopy", "ID Joueur: " .. pId) end)
                    if p:getPermission() >= 3 then
                        getAdminPedActions(token, hitEntity, pId)
                    end
                    if p:getPermission() >= 6 then
                        getDevPedActions(token, hitEntity, pId)
                    end             

                    if isCloseEnough(PlayerPedId(), hitEntity, 2.75) then
                        CTXM:AddSeparator(0)

                        -- Emotes
                        CTXM:AddItem(0, "Copier l'emote", function()
                            if not RPEMOTES then return end
                            RPEMOTES:CloneEmote(pId)
                        end)

                        local submenuEmotes, submenuEmotesItem = CTXM:AddSubmenu(0, "Emotes rapides")
                        CTXM:AddItems(GetPedEmotes(submenuEmotes))

                        CTXM:AddItem(0, "Porter la personne", function() 
                            CONFIG.isCarrying = not CONFIG.isCarrying
                            CarryPeople(hitEntity) 
                        end)
                        CTXM:AddItem(0, "Facture Personnelle", function() MakeBillingPlayer(hitEntity) end)
                        CTXM:AddItem(0, "Fouiller", function() fouille(hitEntity) end)
        
                        if isPedActionsAvailable(p:getJob()) then
                            local submenuActionsJob, submenuActionsJobItem = CTXM:AddSubmenu(0, "Actions Job")
                            CTXM:AddItems(GetContextPedActionByJobV2(submenuActionsJob, p:getJob(), hitEntity))
                        end
                    end
                else
                    if p:getPermission() >= 6 then
                        getDevSamePedActions(token, hitEntity)
                    end
                    if p:getPermission() >= 3 then
                        getAdminSamePedActions(token, hitEntity)
                        CTXM:AddItem(0, "Voir dans le menu Admin", function() openPlayerOnAdminMenu(pId) end)
                    end

                    -- Emotes
                    local submenuEmotes, submenuEmotesItem = CTXM:AddSubmenu(0, "Emotes rapides")
                    CTXM:AddItems(GetSamePedEmotes(submenuEmotes))

                    -- Drop player if carrying
                    if CONFIG.isCarrying then
                        CTXM:AddItem(0, "Lâcher la personne", function() 
                            CONFIG.isCarrying = false
                            CarryPeople(hitEntity) 
                        end)
                    end

                    if CurrentEscort then
                        CTXM:AddItem(0, "Arrêter l'escorte", function() 
                            MoovePlayerCuffed(CurrentEscort, true)
                        end)
                    end

                    CTXM:AddItem(0, "Désactiver le combat", function() disableMelee(hitEntity) end)
                    CTXM:AddItem(0, "Détacher l'objet", function() DetachObjet(hitEntity) end)
    
                    if BoomBox.holdingboom then
                        CTXM:AddItem(0, "Poser la boombox", function() PoseLaBoombox(hitEntity) end)
                    end
                end
            else
                CTXM:AddItem(0, "Supprimer l'entité", function()
                    deleteEntityAdmin(hitEntity)
                end)
            end
        elseif type == 2 then -- Vehicles
            if p:getPermission() >= 3 then
                local name = string.lower(GetEntityArchetypeName(hitEntity))
                CTXM:AddItem(0, "Nom: " .. name, function() TriggerEvent("addToCopy", name) end)
            end

            if GetPedInVehicleSeat(hitEntity, -1) ~= PlayerPedId() and NetworkGetPlayerIndexFromPed(hitEntity) ~= -1 then
                local idDriver = GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(hitEntity, -1)))
                CTXM:AddItem(0, "ID Conducteur: " .. idDriver, function() TriggerEvent("addToCopy", "ID Conducteur: " .. idDriver) end)
            end

            if p:getPermission() >= 3 then
                getAdminVehActions(token, hitEntity)
                if p:getPermission() >= 6 then
                    getDevVehActions(token, hitEntity)
                end
                local submenuPersonnalPed, submenuPersonnalPedItem = CTXM:AddSubmenu(0, "Actions Personnelles")
                if p:getPermission() >= 6 then
                    getDevSamePedActions(token, hitEntity, submenuPersonnalPed)
                end
                if p:getPermission() >= 3 then
                    getAdminSamePedActions(token, hitEntity, submenuPersonnalPed)
                    CTXM:AddItem(0, "Voir dans le menu Admin", function() openPlayerOnAdminMenu(pId) end)
                end
            end

            if isVehActionsAvailable(p:getJob()) then
                if isCloseEnough(PlayerPedId(), hitEntity, 2.75) then
                    CTXM:AddItems(GetContextVehActionByJobV2(0, p:getJob(), hitEntity))
                end
            else
                if isCloseEnough(PlayerPedId(), hitEntity, 25.0) then
                    CTXM:AddItem(0, "Verrouiller/Déverrouiller", function() useKey(hitEntity) end)
                end
                if isCloseEnough(PlayerPedId(), hitEntity, 2.75) then
                    CTXM:AddItem(0, "Rentrer dans le coffre", function() putInTrunk(hitEntity) end)
                    CTXM:AddItem(0, "Ouvrir le capot", function() openHood(hitEntity) end)
                    CTXM:AddItem(0, "Ouvrir le coffre", function() openTrunk(hitEntity) end)
                end
            end
    
            if isCloseEnough(PlayerPedId(), hitEntity, 2.75) then
                if GetContextActionForVehV2(hitEntity, GetEntityModel(hitEntity)) then
                    CTXM:AddItems(GetContextActionForVehV2(hitEntity, GetEntityModel(hitEntity)))
                end

                if CurrentEscort then
                    CTXM:AddItem(0, "Sortir/Mettre dans le véhicule", function() 
                        PlacePlayerIntoVehicle(hitEntity)
                    end)
                end
            end
        elseif type == 3 then -- Objects
            if p:getPermission() >= 3 then
                local name = string.lower(GetEntityArchetypeName(hitEntity))
                CTXM:AddItem(0, "Nom: " .. name, function() TriggerEvent("addToCopy", name) end)
            end

            if p:getPermission() >= 3 then
                CTXM:AddItem(0, "Supprimer l'entité", function()
                    deleteEntityAdmin(hitEntity)
                end)
            end
            if p:getPermission() >= 6 then
                getDevObjectActions(token, hitEntity)
            end

            if isCloseEnough(PlayerPedId(), hitEntity, 2.75) then
                if GetContextActionForObjectV2(hitEntity) then
                    CTXM:AddItems(GetContextActionForObjectV2(hitEntity))
                end
            end
        end
    
    end)    
end)