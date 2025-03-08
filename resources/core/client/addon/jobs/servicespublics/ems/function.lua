local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function revivePatient(entity)
    if EmsDuty or SAMSDuty or CayoEMSDuty or lsfdDuty or BCMSDuty then

        if entity == nil then
            local player, dst = GetClosestPlayer()

            if dst ~= nil and dst <= 2.0 then
                local playerheading = GetEntityHeading(p:ped())
                local coords = GetEntityCoords(p:ped())
                local playerlocation = GetEntityForwardVector(p:ped())
                TriggerServerEvent('core:RevivePlayer', token, GetPlayerServerId(player))
                TriggerServerEvent("core:reviveanimrevived", GetPlayerServerId(player), playerheading, coords, playerlocation)
            else
                -- ShowNotification("Aucun joueur à proximité")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Aucun joueur à proximité"
                })
            end
        else
            local players = NetworkGetPlayerIndexFromPed(entity)
            local playerheading = GetEntityHeading(p:ped())
            local coords = GetEntityCoords(p:ped())
            local playerlocation = GetEntityForwardVector(p:ped())
            TriggerServerEvent('core:RevivePlayer', token, GetPlayerServerId(players))
            TriggerServerEvent("core:reviveanimrevived", GetPlayerServerId(players), playerheading, coords, playerlocation)
        end
    else
        -- ShowNotification("Tu n'es pas en service")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Tu n'es ~s pas en service"
        })
    end
end


RegisterNetEvent("core:anim:revived")
AddEventHandler("core:anim:revived", function(playerheading, coords, playerlocation , players)
    FreezeEntityPosition(p:ped(), true)
    local x, y, z = table.unpack(coords + playerlocation * 1.0)
    SetEntityCoords(p:ped(), x, y, z - 0.50)
    SetEntityHeading(p:ped(), playerheading - 270.0)
    while not IsEntityPlayingAnim(p:ped(), "mini@cpr@char_b@cpr_def", "cpr_intro", 1) do
        p:PlayAnim("mini@cpr@char_b@cpr_def", "cpr_intro", 1)
        Wait(100)
    end
    TriggerServerEvent("core:reviveanimreviver", players)
    Wait(15800 - 900)
    for i = 1, 15, 1 do
        Wait(900)
        p:PlayAnim("mini@cpr@char_b@cpr_str", "cpr_pumpchest", 1)
    end
    p:PlayAnim("mini@cpr@char_b@cpr_str", "cpr_success", 1)
    Citizen.Wait(30590)
    ClearPedTasks(p:ped())
    FreezeEntityPosition(p:ped(), false)
end)

RegisterNetEvent("core:anim:reviver")
AddEventHandler("core:anim:reviver", function(players)
    TriggerServerEvent('core:RevivePlayer', token, players)
    Wait(150)
    p:PlayAnim("mini@cpr@char_a@cpr_def", "cpr_intro", 1)
    Wait(15800 - 900)
    for i = 1, 15, 1 do
        Wait(900)
        p:PlayAnim("mini@cpr@char_a@cpr_str", "cpr_pumpchest", 1)
    end
    p:PlayAnim("mini@cpr@char_a@cpr_str", "cpr_success", 1)
    Citizen.Wait(30590)
    ClearPedTasks(p:ped())
end)

local open = false
local lspdmenu_objects = RageUI.CreateMenu("", "EMS", 0.0, 0.0, "vision", "menu_title_ems")
local lspdmenu_traffic = RageUI.CreateMenu("", "EMS", 0.0, 0.0, "vision", "menu_title_ems")
local lspdmenu_objects_delete = RageUI.CreateSubMenu(lspdmenu_objects, "", "EMS", 0.0, 0.0, "vision",
    "menu_title_ems")
lspdmenu_objects.Closed = function()
    open = false
end
lspdmenu_traffic.Closed = function()
    open = false
end
--[[ local policePropsPlaced = {}
local function SpawnObject(obj, name)
    local coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
    local objCoords = (coords + forward * 2.5)
    local placed = false
    local heading = p:heading()

    local objS = entity:CreateObject(obj, objCoords)
    objS:setPos(objCoords)
    objS:setHeading(heading)
    PlaceObjectOnGroundProperly(objS.id)

    while not placed do
        coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
        objCoords = (coords + forward * 2.5)
        objS:setPos(objCoords)
        PlaceObjectOnGroundProperly(objS.id)
        objS:setAlpha(170)
        SetEntityCollision(objS.id, false, true)

        if IsControlPressed(0, 190) then
            heading = heading + 0.5
        elseif IsControlPressed(0, 189) then
            heading = heading - 0.5
        end

        SetEntityHeading(objS.id, heading)

        ShowHelpNotification(
            "Appuyez sur ~INPUT_CONTEXT~ pour placer l'objet\n~INPUT_FRONTEND_LEFT~ ou ~INPUT_FRONTEND_RIGHT~ Pour faire pivoter l'objet")
        if IsControlJustPressed(0, 38) then
            placed = true
        end
        Wait(0)
    end
    SetEntityCollision(objS.id, true, true)
    -- SetEntityInvincible(objS.id, true)
    -- objS:setFreeze(true)
    objS:resetAlpha()
    local netId = objS:getNetId()
    if netId == 0 then
        objS:delete()
    end
    SetNetworkIdCanMigrate(netId, true)
    table.insert(policePropsPlaced, {
        nom = name,
        prop = objS.id
    })
end

function openEmsPropsMenu()
    if EmsDuty then
        if open then
            open = false
            RageUI.Visible(lspdmenu_objects, false)
        else
            open = true
            RageUI.Visible(lspdmenu_objects, true)

            Citizen.CreateThread(function()
                while open do
                    RageUI.IsVisible(lspdmenu_objects, function()
                        RageUI.Button("Supprimer mes props", nil, {}, true, {}, lspdmenu_objects_delete)
                        for k, v in pairs(police.props) do
                            RageUI.Button(v.nom, nil, {}, true, {
                                onSelected = function()
                                    SpawnObject(v.prop, v.nom)
                                end
                            }, nil)
                        end
                    end)
                    RageUI.IsVisible(lspdmenu_objects_delete, function()
                        for k, v in pairs(policePropsPlaced) do
                            if v.nom ~= "Herse" then
                                RageUI.Button(v.nom, nil, {}, true, {
                                    onSelected = function()
                                        DeleteObject(v.prop)
                                        table.remove(policePropsPlaced, k)
                                    end,
                                    onActive = function()
                                        DrawMarker(20, GetEntityCoords(v.prop) + vector3(0.0, 0.0, 1.0), 0.0, 0.0, 0.0,
                                            180.0, 0.0, 0.0, 0.5, 0.5, 0.5, 92, 173, 29, 255, true, 1, 0, 0)
                                    end
                                }, nil)
                            end
                        end
                    end)
                    Wait(1)
                end
            end)
        end
    else
        -- ShowNotification("~r~Vous n'êtes pas en service")
                    
                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous n'êtes ~s pas en service"
                    }) 
    end
end ]]

function HealthPatient(entity)
    if EmsDuty or SAMSDuty or CayoEMSDuty or BCMSDuty then
        local players = NetworkGetPlayerIndexFromPed(entity)

        local sID = GetPlayerServerId(players)
        if entity == nil then
            local player, dst = GetClosestPlayer()

            if dst ~= nil and dst <= 2.0 then
                local cPed = GetPlayerPed(player)
                local health = GetEntityHealth(cPed)
                if health > 0 then
                    p:PlayAnim("amb@medic@standing@kneel@base", "base", 1)
                    Wait(5000)
                    ClearPedTasks(p:ped())
                    if health > 0 then
                        TriggerServerEvent('core:HealthPlayer', token, GetPlayerServerId(player))
                    end
                end
            else
                -- ShowNotification("Aucun joueur à proximité")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Aucun joueur à proximité"
                })
            end
        else
            local cPed = GetPlayerPed(players)
            local health = GetEntityHealth(cPed)
            if health > 0 then
                --play anim
                p:PlayAnim("amb@medic@standing@kneel@base", "base", 1)
                Wait(5000)
                ClearPedTasks(p:ped())
                if health > 0 then
                    TriggerServerEvent('core:HealthPlayer', token, sID)
                end
            end
        end
    else
        -- ShowNotification("Vous n'êtes pas en service")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous n'êtes ~s pas en service"
        })
    end
end

function GetCauseOfDeath()
    if EmsDuty then
        local player, dst = GetClosestPlayer()

        if dst ~= nil and dst <= 2.0 then
            TriggerServerEvent('core:GetCauseOfDeath', token, player)
        else
            -- ShowNotification("Aucun joueur à proximité")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Aucun joueur à proximité"
            })
        end
    else
        -- ShowNotification("Vous n'êtes pas en service")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous n'êtes ~s pas en service"
        })
    end

end

function identificationComa(entity)
    local exist, lastBone = GetPedLastDamageBone(entity)
    local cause, what_cause, timeDeath = GetPedCauseOfDeath(entity), GetPedSourceOfDeath(entity), GetPedTimeOfDeath(entity)
    if IsEntityAPed(what_cause) then
        what_cause = "avoir des traces de combat"
    elseif IsEntityAVehicle(what_cause) then
        what_cause = "être écrasé par un véhicule"
    elseif IsEntityAnObject(what_cause) then
        what_cause = "s'être pris un objet"
    end
    what_cause = type(what_cause) == "string" and what_cause or "Non-Identifiée"
    if IsWeaponValid(cause) then
        cause = Death.GetDeathType[GetWeaponDamageType(cause)] or "Non-Identifiée"
    elseif IsModelInCdimage(cause) then
        cause = "Véhicule"
    end
    cause = type(cause) == "string" and cause or "Mêlée"
    local boneName = "Dos"

    if exist and lastBone then
        for k, v in pairs(Death.GetBonesType) do
            if Death.GetValueWithTable(v, lastBone) then
                boneName = k
                break
            end
        end
    end

    exports['vNotif']:createNotification({
        type = 'VERT',
        duration = 15,
        content = "L'individu semble " .. what_cause .. " au niveau du " .. string.lower(boneName),
    })
end

function getPatientIdentityCard(entity)
    if EmsDuty or policeDuty or usssDuty or lssdDuty or GCPDuty or boiDuty or BCMSDuty then
        local player = NetworkGetPlayerIndexFromPed(entity)

        local sID = GetPlayerServerId(player)
        if entity == nil then
            local player, dst = GetClosestPlayer()

            if dst ~= nil and dst <= 2.0 then
                TriggerServerEvent('core:GetPatientIdentity', token, GetPlayerServerId(player))
            else
                -- ShowNotification("Aucun joueur à proximité")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Aucun joueur à proximité"
                })
            end
        else

            TriggerServerEvent('core:GetPatientIdentity', token, sID)

        end
    else
        -- ShowNotification('Vous n\'êtes pas en service')

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous n'êtes ~s pas en service"
        })
    end
end

function AuscultatePatient()
    if EmsDuty or SAMSDuty or CayoEMSDuty or BCMSDuty then
    else
        -- ShowNotification('Vous n\'êtes pas en service')

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous n'êtes ~s pas en service"
        })

    end
end

RegisterNetEvent("core:RevivePlayer")
AddEventHandler("core:RevivePlayer", function(byStaff)
    --enlever le screen du coma au mec ici
    Death.GetAllDamagePed = {}
    openRadarProperly()
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }));
    TriggerScreenblurFadeOut(10)

    --modifier son status de mort ici
    p:setPos(GetEntityCoords(p:ped()))
    TriggerEvent("core:IsDeadStatut", false)
    SetEntityCoordsNoOffset(p:ped(), p:pos().x, p:pos().y, p:pos().z, false, false, false, true)
    if GetResourceState("ZeroTrust") == "started" then
        exports["ZeroTrust"]:Resurected()
    end
    NetworkResurrectLocalPlayer(p:pos(), p:heading(), true, false)

    if byStaff then     
        p:setHealth(200)
        p:setHunger(50)
        p:setThirst(50)
    else
        p:setHealth(150)
        p:setHunger(50)
        p:setThirst(50)
    end
    -- TriggerEvent('playerSpawned')
end)


RegisterNetEvent("core:HealthPlayer")
AddEventHandler("core:HealthPlayer", function()
    TriggerEvent("core:IsDeadStatut", false)
    p:setHealth(200)
    p:setHunger(50)
    p:setThirst(50)
end)

RegisterNetEvent("core:KillPlayer")
AddEventHandler("core:KillPlayer", function()
    TriggerEvent("core:IsDeadStatut", true)
    p:setHealth(0)
end)

RegisterNetEvent("core:GetPatientIdentity")
AddEventHandler("core:GetPatientIdentity", function(identity)
    if identity ~= nil then
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            duration = 10, -- In seconds, default:  4
            content = "Nom : " .. identity.prenom .. "\nPrénom : " .. identity.nom .. "\nAge : " .. identity.age .. "\nSexe: " .. identity.sexe
        })        
    end
end)


RegisterClientCallback('core:GetCauseOfDeath', function()
    if p ~= nil then
        local _, what_cause, _, _ = p:GetAllCauseOfDeath()
        return what_cause
    end
end)


RegisterNetEvent('core:GetCauseOfDeath')
AddEventHandler('core:GetCauseOfDeath', function(what_cause)
--[[     ShowAdvancedNotification("EMS", "Central",
        "Cause de la mort : ~r~" .. what_cause,
        "CHAR_CALL911",
        "CHAR_CALL911") ]]

    -- New notif
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        -- duration = 5, -- In seconds, default:  4
        content = "Cause de la mort : ~s" .. what_cause
    })

end)

-- RegisterCommand("spawn", function()
--     TriggerEvent('playerSpawned')
-- end)

local lastMedKitUse = 0

function checkMedicUse()
    if (lastFireTime ~= 0 and (GetGameTimer() - lastFireTime) < 600000) or (lastMedKitUse ~= 0 and (GetGameTimer() - lastMedKitUse) < 300000) then      
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Vous ne pouvez pas utiliser ce soin pour le moment."
        })
        return false
    else
        return true
    end
end

RegisterNetEvent("core:UseItemsMedic1")
AddEventHandler("core:UseItemsMedic1", function(health)
    if not checkMedicUse() then return end

    p:heal(health)
    RequestAnimDict('amb@medic@standing@kneel@base')
        while not HasAnimDictLoaded('amb@medic@standing@kneel@base') do
            Wait(0)
        end
    p:PlayAnim('amb@medic@standing@kneel@base', 'base', 1)
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'Progressbar',
        data = {
            text = "Soins en cours...",
            time = 13,
        }
    }))
    Citizen.Wait(13000)
    ClearPedTasks(p:ped())

    lastMedKitUse = GetGameTimer()
end)

RegisterNetEvent("core:UseItemsMedic2")
AddEventHandler("core:UseItemsMedic2", function(health)
    if not checkMedicUse() then return end

    p:heal(health)
    RequestAnimDict('amb@medic@standing@kneel@base')
        while not HasAnimDictLoaded('amb@medic@standing@kneel@base') do
            Wait(0)
        end
    p:PlayAnim('amb@medic@standing@kneel@base', 'base', 1)
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'Progressbar',
        data = {
            text = "Soins en cours...",
            time = 10,
        }
    }))
    Citizen.Wait(10000)
    ClearPedTasks(p:ped())

    lastMedKitUse = GetGameTimer()
end)

RegisterNetEvent("core:UseItemsMedic3")
AddEventHandler("core:UseItemsMedic3", function(health)
    if not checkMedicUse() then return end

    p:heal(health)
    RequestAnimDict('amb@medic@standing@kneel@base')
        while not HasAnimDictLoaded('amb@medic@standing@kneel@base') do
            Wait(0)
        end
    p:PlayAnim('amb@medic@standing@kneel@base', 'base', 1)
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'Progressbar',
        data = {
            text = "Soins en cours...",
            time = 20,
        }
    }))
    Citizen.Wait(20000)
    ClearPedTasks(p:ped())

    lastMedKitUse = GetGameTimer()
end)

RegisterNetEvent("core:UseItemsMedic4")
AddEventHandler("core:UseItemsMedic4", function(health)
    if not checkMedicUse() then return end

    p:heal(health)
    RequestAnimDict('mp_suicide')
        while not HasAnimDictLoaded('mp_suicide') do
            Wait(0)
        end
    p:PlayAnim('mp_suicide', 'pill', 1)
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'Progressbar',
        data = {
            text = "Soins en cours...",
            time = 6,
        }
    }))
    Citizen.Wait(6000)
    ClearPedTasks(p:ped())

    lastMedKitUse = GetGameTimer()
end)

RegisterNetEvent("core:UseItemsMedic5")
AddEventHandler("core:UseItemsMedic5", function(health)
    if not checkMedicUse() then return end

    p:heal(health)
    RequestAnimDict('mp_suicide')
        while not HasAnimDictLoaded('mp_suicide') do
            Wait(0)
        end
    p:PlayAnim('mp_suicide', 'pill', 1)
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'Progressbar',
        data = {
            text = "Soins en cours...",
            time = 6,
        }
    }))
    Citizen.Wait(6000)
    ClearPedTasks(p:ped())

    lastMedKitUse = GetGameTimer()
end)


local ems_entree = vector3(-263.11447143555, 6325.8081054688, 31.451026916504)
local ems_sortie = vector3(-257.99261474609, 6315.3876953125, 36.620128631592)

zone.addZone(
    "ems_tp",
    ems_entree,
    "~INPUT_CONTEXT~ Intéragir",
    function()
        SetEntityCoords(p:ped(), ems_sortie)
        Wait(1000)
    end,
    true,
    25, -- Id / type du marker
    0.6, -- La taille
    { 51, 204, 255 }, -- RGB
    170-- Alpha
)

zone.addZone(
    "ems_ls",
    ems_sortie,
    "~INPUT_CONTEXT~ Intéragir",
    function()
        SetEntityCoords(p:ped(), ems_entree)
        Wait(1000)
    end,
    true,
    25, -- Id / type du marker
    0.6, -- La taille
    { 51, 204, 255 }, -- RGB
    170-- Alpha
)