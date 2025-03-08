local CTXM = exports["ContextMenu"]
local xSound = exports["xsoundtemp"]

local CONFIG = {
    PED = {
        isShootingBuses = false,
        isNameInvisible = false,
        antiSearch = false,
        isLogs = false
    },
    VEH = {

    },
    BUSES = {}
}

function getDevSamePedActions(token, hitEntity, menu)
    menu = menu or 0

    local submenuDevSamePed, submenuDevSamePedItem = CTXM:AddSubmenu(menu, "Actions Développeur")

    CTXM:AddItem(submenuDevSamePed, "Recharger le bouclier", function()
        p:setShield(200)
    end)

    local devVehBoost = CTXM:AddCheckboxItem(submenuDevSamePed, "Boost de véhicule", devVehBoostActive)
    CTXM:OnActivate(devVehBoost, function()
        devVehBoostActive = not devVehBoostActive
    end)

    -- Se mettre invisible
    -- local invisible = CTXM:AddCheckboxItem(submenuDevSamePed, "Se mettre invisible", CONFIG.PED.isNameInvisible)
    -- CTXM:OnActivate(invisible, function()
    --     CONFIG.PED.isNameInvisible = not CONFIG.PED.isNameInvisible
    --     TriggerServerEvent("core:UseDevMenu")
    -- end)

    -- no logs
    -- local logs = CTXM:AddCheckboxItem(submenuDevSamePed, "No logs", CONFIG.PED.isLogs)
    -- CTXM:OnActivate(logs, function()
    --     CONFIG.PED.isLogs = not CONFIG.PED.isLogs
    --     TriggerServerEvent("core:updateLogDev")
    -- end)

    -- Désactiver l'animation de sortie d'armes
    local byPassAnimMenu = CTXM:AddCheckboxItem(submenuDevSamePed, "Animation de sortie d'armes", not byPassAnim)
    CTXM:OnActivate(byPassAnimMenu, function()
        byPassAnim = not byPassAnim
    end)

    -- Désactiver le gamer tag
    local gamerTag = CTXM:AddCheckboxItem(submenuDevSamePed, "Désactiver le gamer tag", bypassMpGamerTag)
    CTXM:OnActivate(gamerTag, function()
        bypassMpGamerTag = not bypassMpGamerTag
        if not bypassMpGamerTag then
            TriggerServerEvent("core:UseBlipsName", vAdminMods.playerNames)
        else
            TriggerServerEvent("core:UseBlipsName", false)
        end
    end)

    -- anti search
    local antiSearch = CTXM:AddCheckboxItem(submenuDevSamePed, "Anti fouille", CONFIG.PED.antiSearch)
    CTXM:OnActivate(antiSearch, function()
        CONFIG.PED.antiSearch = not CONFIG.PED.antiSearch
        TriggerServerEvent("core:blacklistSearch", token, CONFIG.PED.antiSearch)
    end)

    local forceEquipWeapon = CTXM:AddCheckboxItem(submenuDevSamePed, "Forcer l'inventaire rapide", PlayerUtils.forceEquipWeapon)
    CTXM:OnActivate(forceEquipWeapon, function()
        PlayerUtils.forceEquipWeapon = not PlayerUtils.forceEquipWeapon
    end)

    -- Knock back player
    --[[ local knockBackPlayer = CTXM:AddCheckboxItem(submenuDevSamePed, "Knock back player", CONFIG.PED.knockBackPlayer)
    CTXM:OnActivate(knockBackPlayer, function()
        CONFIG.PED.knockBackPlayer = not CONFIG.PED.knockBackPlayer

        if CONFIG.PED.knockBackPlayer then
            Citizen.CreateThread(function()
                while CONFIG.PED.knockBackPlayer do
                    Citizen.Wait(0)
                    local player = PlayerPedId()
                    local playerCoords = GetEntityCoords(player)
                    local forwardVector = GetEntityForwardVector(player)
                    local raycast = StartShapeTestRay(playerCoords, playerCoords + forwardVector * 2.0, 2, player, 0)
                    local _, hit, hitCoords, _, hitEntity = GetShapeTestResult(raycast)

                    if hit and hitEntity ~= 0 then
                        local entityType = GetEntityType(hitEntity)
                        if entityType == 1 then
                            local player = hitEntity
                            local playerCoords = GetEntityCoords(player)
                            local distance = GetDistanceBetweenCoords(playerCoords, playerCoords, true)
                            local knockBackForce = 200.0
                            ApplyForceToEntity(player, 1, forwardVector.x * knockBackForce, forwardVector.y * knockBackForce, forwardVector.z * knockBackForce, 0.0, 0.0, 0.0, 0, false, true, true, true, true)
                        end
                    end
                end
            end)
        else
            CONFIG.PED.knockBackPlayer = false
        end
    end) ]]

    -- Infinit ammo
    -- local infiniteAmmo = CTXM:AddCheckboxItem(submenuDevSamePed, "Munitions infinies", vAdmin.InfiniteAmmo)
    -- CTXM:OnActivate(infiniteAmmo, function()
    --     vAdmin.InfiniteAmmo = not vAdmin.InfiniteAmmo
    -- end)
end

function getDevPedActions(token, hitEntity, serverId, menu)
    menu = menu or 0

    local submenuDevPed, submenuDevPedItem = CTXM:AddSubmenu(menu, "Actions Développeur")

    -- -- Faire exploser
    -- CTXM:AddItem(submenuDevPed, "Faire exploser", function()
    --     local ped = hitEntity
    --     AddExplosion(GetEntityCoords(ped), 4, 1000.0, true, false, 2.0)
    -- end)
    
    -- copie coords
    CTXM:AddItem(submenuDevPed, "Nom : " .. GetEntityArchetypeName(hitEntity), function()
        TriggerEvent("addToCopy", GetEntityArchetypeName(hitEntity))
    end)

    CTXM:AddItem(submenuDevPed, "Copier le hash : " .. GetEntityModel(hitEntity), function()
        TriggerEvent("addToCopy", GetEntityModel(hitEntity))
    end)

    --entity
    CTXM:AddItem(submenuDevPed, "Copier l'entité : " .. hitEntity, function()
        TriggerEvent("addToCopy", hitEntity)
    end)

    -- copie coords
    CTXM:AddItem(submenuDevPed, "Copier la position", function()
        local pos = GetEntityCoords(hitEntity)
        local heading = GetEntityHeading(hitEntity)
        local pos = formatNumber(pos.x)..", "..formatNumber(pos.y)..", "..formatNumber(pos.z)..", "..formatNumber(heading)
        TriggerEvent("addToCopy", pos)
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Coordonées copiées : " .. pos
        })
    end)

    -- TP dans le ciel
    CTXM:AddItem(submenuDevPed, "TP dans le ciel", function()
        local ped = hitEntity
        TriggerServerEvent("core:dev:prend:toi:la:banane:et:vole:mdr", token, serverId)
    end)
    CTXM:AddItem(submenuDevPed, "Enlever les chaussures", function()
        local ped = hitEntity
        TriggerServerEvent("core:removeShoes", serverId)
    end)
end

function getDevVehActions(token, hitEntity, menu)
    menu = menu or 0

    local submenuDevVeh, submenuDevVehItem = CTXM:AddSubmenu(menu, "Actions Développeur")

    -- Faire exploser
    -- CTXM:AddItem(submenuDevVeh, "Faire exploser", function() -- Plus de sacul, plus de troll
    --     local vehicle = hitEntity
    --     AddExplosion(GetEntityCoords(vehicle), 4, 1000.0, true, false, 2.0)
    -- end)

    CTXM:AddItem(submenuDevVeh, "Copier le nom : " .. GetEntityArchetypeName(hitEntity), function()
        TriggerEvent("addToCopy", GetEntityArchetypeName(hitEntity))
    end)

    CTXM:AddItem(submenuDevVeh, "Copier le hash : " .. GetEntityModel(hitEntity), function()
        TriggerEvent("addToCopy", GetEntityModel(hitEntity))
    end)

    --entity
    CTXM:AddItem(submenuDevVeh, "Copier l'entité : " .. hitEntity, function()
        TriggerEvent("addToCopy", hitEntity)
    end)

    -- copie plaque
    CTXM:AddItem(submenuDevVeh, "Copier la plaque : " .. GetVehicleNumberPlateText(hitEntity), function()
        local plate = GetVehicleNumberPlateText(hitEntity)
        TriggerEvent("addToCopy", plate)
    end)

    -- owner
    CTXM:AddItem(submenuDevVeh, "Owner : " .. NetworkGetEntityOwner(hitEntity), function()
        local owner = NetworkGetEntityOwner(hitEntity)
        TriggerEvent("addToCopy", owner)
    end)

    -- copie position
    CTXM:AddItem(submenuDevVeh, "Copier la position", function()
        local pos = GetEntityCoords(hitEntity)
        local heading = GetEntityHeading(hitEntity)
        local pos = formatNumber(pos.x)..", "..formatNumber(pos.y)..", "..formatNumber(pos.z)..", "..formatNumber(heading)
        TriggerEvent("addToCopy", pos)
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Coordonées copiées : " .. pos
        })
    end)

    -- Porter le veh
    CTXM:AddItem(submenuDevVeh, "Porter le véhicule", function()
        local vehicle = hitEntity
        local player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)
        local vehicleCoords = GetEntityCoords(vehicle)
        local distance = GetDistanceBetweenCoords(playerCoords, vehicleCoords, true)
    
        if distance < 5.0 then
            FreezeEntityPosition(vehicle, true)
            AttachEntityToEntity(vehicle, player, GetPedBoneIndex(player, 57005), 0.0, 1.0, 0.5, 0.0, 0.0, 90.0, false, false, false, false, 2, true)
    
            RequestAnimDict("random@mugging3")
            while not HasAnimDictLoaded("random@mugging3") do
                Wait(100)
            end
            TaskPlayAnim(player, "random@mugging3", "handsup_standing_base", 8.0, -8.0, -1, 50, 0, false, false, false)
    
            Citizen.CreateThread(function()
                while true do
                    Citizen.Wait(0)
                    if IsControlJustPressed(0, 24) then 
                        DetachEntity(vehicle, true, true)
                        FreezeEntityPosition(vehicle, false)
    
                        local forwardVector = GetEntityForwardVector(player)
                        local throwForce = 200.0 
    
                        ApplyForceToEntity(vehicle, 1, forwardVector.x * throwForce, forwardVector.y * throwForce, forwardVector.z * throwForce, 0.0, 0.0, 0.0, 0, false, true, true, true, true)
    
                        ClearPedTasks(player)
                        break
                    end
                end
            end)
        end
    end)

    -- Custom Menu
    CTXM:AddItem(submenuDevVeh, "Ouvrir Menu Custom", function()
        ExecuteCommand("custom")
    end)
end

local function formatNumber(num)
    return tonumber(string.format("%.2f", num))
end

function getDevNothingActions(worldPosition, menu)
    menu = menu or 0

    local submenuDevNothing, submenuDevNothingItem = CTXM:AddSubmenu(menu, "Actions Développeur")

    -- Call Orbital Strike
    -- CTXM:AddItem(submenuDevNothing, "Frappe Orbital", function()
    --     if not HasWeaponAssetLoaded(GetHashKey("WEAPON_VEHICLE_ROCKET")) then
    --         RequestWeaponAsset(GetHashKey("WEAPON_VEHICLE_ROCKET"), 31, 0)
    --         while not HasWeaponAssetLoaded(GetHashKey("WEAPON_VEHICLE_ROCKET")) do
    --             Citizen.Wait(0)
    --         end
    --     end

    --     local pos = worldPosition
    --     local offset = GetObjectOffsetFromCoords(pos.x, pos.y, pos.z, 0, 0, 0, 0)
    --     RequestCollisionAtCoord(offset)
	-- 	offset = GetObjectOffsetFromCoords(pos.x,pos.y,pos.z,0,0,0,0)
	-- 	ShootSingleBulletBetweenCoords(offset+vector3(0,0,200), offset, 5000, 0, GetHashKey("WEAPON_VEHICLE_ROCKET"), PlayerPedId(), 1, 0, RoundNumberAucasou(9000))
	-- 	offset = GetObjectOffsetFromCoords(pos.x,pos.y,pos.z,0,RoundNumberAucasou(-3),0,0)
	-- 	ShootSingleBulletBetweenCoords(offset+vector3(0,0,200), offset, 5000, 0, GetHashKey("WEAPON_VEHICLE_ROCKET"), PlayerPedId(), 1, 0, RoundNumberAucasou(9000))
	-- 	offset = GetObjectOffsetFromCoords(pos.x,pos.y,pos.z,0,RoundNumberAucasou(3),0,0)
	-- 	ShootSingleBulletBetweenCoords(offset+vector3(0,0,200), offset, 5000, 0, GetHashKey("WEAPON_VEHICLE_ROCKET"), PlayerPedId(), 1, 0, RoundNumberAucasou(9000))
	-- 	offset = GetObjectOffsetFromCoords(pos.x,pos.y,pos.z,0,0,RoundNumberAucasou(-3),0)
	-- 	ShootSingleBulletBetweenCoords(offset+vector3(0,0,200), offset, 5000, 0, GetHashKey("WEAPON_VEHICLE_ROCKET"), PlayerPedId(), 1, 0, RoundNumberAucasou(9000))
	-- 	offset = GetObjectOffsetFromCoords(pos.x,pos.y,pos.z,0,0,RoundNumberAucasou(3),0)
	-- 	ShootSingleBulletBetweenCoords(offset+vector3(0,0,200), offset, 5000, 0, GetHashKey("WEAPON_VEHICLE_ROCKET"), PlayerPedId(), 1, 0, RoundNumberAucasou(9000))
		
    --     Citizen.Wait(1000)
    -- end)

    CTXM:AddItem(submenuDevNothing, "Spawn un ped", function()
        local ped = KeyboardImput("Nom du ped", "")
        if not ped then return end
        local ped = joaat(ped)
        if IsModelInCdimage(ped) and IsModelValid(ped) then
            local pos = worldPosition
            RequestModel(ped)
            while not HasModelLoaded(ped) do
                Citizen.Wait(0)
            end
            local _ped = CreatePed(4, ped, pos.x, pos.y, pos.z, GetEntityHeading(PlayerPedId()), true, false)
            SetEntityAsMissionEntity(_ped, true, true)
        end
    end)

    CTXM:AddItem(submenuDevNothing, "Copier les coordonnées", function()
        local heading = GetEntityHeading(PlayerPedId())
        local pos = formatNumber(worldPosition.x)..", "..formatNumber(worldPosition.y)..", "..formatNumber(worldPosition.z)..", "..formatNumber(heading)
        TriggerEvent("addToCopy", pos)
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Coordonées copiées : " .. pos
        })
    end)
end

function getDevObjectActions(token, hitEntity, menu)
    menu = menu or 0

    local submenuDevObject, submenuDevObjectItem = CTXM:AddSubmenu(menu, "Actions Développeur")

    -- Copier le nom
    CTXM:AddItem(submenuDevObject, "Copier : " .. GetEntityArchetypeName(hitEntity), function()
        TriggerEvent("addToCopy", GetEntityArchetypeName(hitEntity))
    end)

    CTXM:AddItem(submenuDevObject, "Copier le hash : " .. GetEntityModel(hitEntity), function()
        TriggerEvent("addToCopy", GetEntityModel(hitEntity))
    end)

    -- Copier l'entité
    CTXM:AddItem(submenuDevObject, "Copier l'entité : " .. hitEntity, function()
        TriggerEvent("addToCopy", hitEntity)
    end)

    -- Copier la position
    CTXM:AddItem(submenuDevObject, "Copier la position", function()
        local pos = GetEntityCoords(hitEntity)
        local heading = GetEntityHeading(hitEntity)
        local pos = formatNumber(pos.x)..", "..formatNumber(pos.y)..", "..formatNumber(pos.z)..", "..formatNumber(heading)
        TriggerEvent("addToCopy", pos)
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Coordonées copiées : " .. pos
        })
    end)

    -- owner de l'entité
    CTXM:AddItem(submenuDevObject, "Owner : " .. NetworkGetEntityOwner(hitEntity), function()
        local owner = NetworkGetEntityOwner(hitEntity)
        TriggerEvent("addToCopy", owner)
    end)

end