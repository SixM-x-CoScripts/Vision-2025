--[[ local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local dict = "mp_arresting"
local anim = "idle"

local flags = 49 -- Let the player move

local isCuffed = false
local prevFemaleVariation = nil
local prevMaleVariation = nil
local LockedControlsWithoutMove = { 166, 167, 168, 288, 289, 38, 311, 182, 21, 24, 25, 82, 75, 38, 45, 80, 140, 22, 142,
    30, 31, 32, 33, 34, 35, 59, 60, 61, 62, 63, 64 }
local EnTrainEscorter = false
local PoliceEscort = nil
local contextOpen
local function OpenContextMenu(table)
    if not contextOpen then
        contextOpen = true
        CreateThread(function()
            while contextOpen do
                Wait(0)
                DisableControlAction(0, 1, contextOpen)
                DisableControlAction(0, 2, contextOpen)
                DisableControlAction(0, 142, contextOpen)
                DisableControlAction(0, 18, contextOpen)
                DisableControlAction(0, 322, contextOpen)
                DisableControlAction(0, 106, contextOpen)
                DisableControlAction(0, 24, true) -- disable attack
                DisableControlAction(0, 25, true) -- disable aim
                DisableControlAction(0, 263, true) -- disable melee
                DisableControlAction(0, 264, true) -- disable melee
                DisableControlAction(0, 257, true) -- disable melee
                DisableControlAction(0, 140, true) -- disable melee
                DisableControlAction(0, 141, true) -- disable melee
                DisableControlAction(0, 142, true) -- disable melee
                DisableControlAction(0, 143, true) -- disable melee
            end
        end)
        SetNuiFocusKeepInput(true)
        SetNuiFocus(true, true)
        CreateThread(function()
            SendNuiMessage(json.encode({
                type = 'openWebview',
                name = 'Interaction',
                data = {
                    position = { x = GetControlNormal(0, 239), y = GetControlNormal(0, 240) },
                    interactions = table
                }
            }));
        end)
    else
        contextOpen = false
        SetNuiFocusKeepInput(false)
        EnableControlAction(0, 1, true)
        EnableControlAction(0, 2, true)
        EnableControlAction(0, 142, true)
        EnableControlAction(0, 18, true)
        EnableControlAction(0, 322, true)
        EnableControlAction(0, 106, true)
        SetNuiFocus(false, false)
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
        return
    end
end

RegisterNUICallback("focusOut", function(data, cb)
    -- ExecuteCommand("e c")
    if contextOpen then
        contextOpen = false
        EnableControlAction(0, 1, true)
        EnableControlAction(0, 2, true)
        EnableControlAction(0, 142, true)
        EnableControlAction(0, 18, true)
        EnableControlAction(0, 322, true)
        EnableControlAction(0, 106, true)
    end
    cb({})
end)

function PermisPolice(entity)

    OpenContextMenu(
        {
            {
                icon = "Carte",
                label = "Donner permis hélico",
                action = "GivePermisHelico",
                args = { entity }
            },
            {
                icon = "Carte",
                label = "Donner permis bateau",
                action = "GivePermisBateau",
                args = { entity }
            },
            {
                icon = "Carte",
                label = "Retirer un permis",
                action = "permismenu",
                args = { entity }
            },
            {
                icon = "Carte",
                label = "Vérifier les permis",
                action = "checkpermis",
                args = { entity }
            }
        })
end

function checkpermis(entity)
    local player = NetworkGetPlayerIndexFromPed(entity)
    local serverId = GetPlayerServerId(player)
    if entity == nil then
        local closestPlayer, closestDistance = GetClosestPlayer()
        if closestPlayer ~= nil and closestDistance < 3.0 then
            local license = TriggerServerCallback("core:getAllLicensesForPlayer", GetPlayerServerId(closestPlayer), token)
            -- if the player has no license, we say it
            if license == false then
                -- ShowAdvancedNotification("Permis", "Information", "Cette personne n'a aucun permis", "CHAR_CALL911", 1)

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Cette personne n'a ~s aucun permis"
                })

                return
            end
            local printing = {}
            for k, v in pairs(license) do
                -- first letter of v.name is upper
                local name = v.name
                name = string.upper(string.sub(name, 1, 1)) .. string.sub(name, 2)
                table.insert(printing, name)
            end
            -- New notif

            local tablepermis = table.concat(printing, ", ")

            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Permis possédé : ~s" .. (tablepermis=="" and "Aucun" or tablepermis)
            })

                
        else
            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Aucun joueur dans la zone"
            })

        end
    else
        local license = TriggerServerCallback("core:getAllLicensesForPlayer", serverId, token)
        if license == false then
            -- ShowAdvancedNotification("Permis", "Information", "Cette personne n'a aucun permis", "CHAR_CALL911", 1)

            -- New notif
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Cette personne n'a ~s aucun permis"
            })

            return
        end
        local printing = {}
        for k, v in pairs(license) do
            -- first letter of v.name is upper
            local name = v.name
            name = string.upper(string.sub(name, 1, 1)) .. string.sub(name, 2)
            table.insert(printing, name)
        end
        -- New notif
        local tablepermis = table.concat(printing, ", ")

        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Permis possédé : ~s" .. (tablepermis=="" and "Aucun" or tablepermis)
        })


    end
end

function GivePermisHelico(entity)
    local player = NetworkGetPlayerIndexFromPed(entity)
    local sID = GetPlayerServerId(player)
    if entity == nil then
        local closestPlayer, closestDistance = GetClosestPlayer()
        if closestPlayer ~= nil and closestDistance < 3.0 then
            TriggerServerEvent("core:addLicenceLSPD", GetPlayerServerId(closestPlayer), token, "helico")
        else
            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Aucun joueur dans la zone"
            })

        end
    else
        TriggerServerEvent("core:addLicenceLSPD", sID, token, "helico")
    end
end

function GivePermisBateau(entity)
    local player = NetworkGetPlayerIndexFromPed(entity)
    local sID = GetPlayerServerId(player)
    if entity == nil then
        local closestPlayer, closestDistance = GetClosestPlayer()
        if closestPlayer ~= nil and closestDistance < 3.0 then
            TriggerServerEvent("core:addLicenceLSPD", GetPlayerServerId(closestPlayer), token, "bateau")
        else
            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Aucun joueur dans la zone"
            })

        end
    else
        TriggerServerEvent("core:addLicenceLSPD", sID, token, "bateau")
    end
end

function StartCuffLoop()
    weaponOut = false
    while isCuffed do
        SetCurrentPedWeapon(p:ped(), GetHashKey("WEAPON_UNARMED"), true)
        if not IsEntityPlayingAnim(p:ped(), dict, anim, flags) then
            PlayEmote(dict, anim, flags, 5000)
        end

        -- for k, v in pairs(LockedControlsWithoutMove) do
        --     DisableControlAction(1, v, true)
        -- end
        Wait(1)
    end
end

function Escort()
    CreateThread(function()
        while EnTrainEscorter do
            Wait(1)
            local targetPed = GetPlayerPed(GetPlayerFromServerId(PoliceEscort))

            if not IsPedSittingInAnyVehicle(targetPed) then
                SetEntityCoordsNoOffset(p:ped(), GetEntityCoords(targetPed), 0.0, 0.0, 0.0) -- debug
                AttachEntityToEntity(p:ped(), targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false,
                    false, 2, true)
            else
                EnTrainEscorter = false
                DetachEntity(p:ped(), true, false)
            end

            if IsPedDeadOrDying(targetPed, true) then
                EnTrainEscorter = false
                DetachEntity(p:ped(), true, false)
            end
        end
        DetachEntity(p:ped(), true, false)
    end)
end

function PlacePlayerIntoVehicle(entity)
    if policeDuty or lssdDuty or usssDuty or boiDuty then
        local players = NetworkGetPlayerIndexFromPed(entity)
        local sID = GetPlayerServerId(players)

        if entity == nil then
            local player, dst = GetClosestPlayer()
            local vehicle = GetClosestVehicle(p:pos())
            if not IsPedInVehicle(player, vehicle, true) then
                TriggerServerEvent("core:PutPlayerIntoVehicle", token, GetPlayerServerId(player), VehToNet(vehicle))
            else
                TriggerServerEvent("core:MakePlayerLeaveVehicle", token, GetPlayerServerId(player))
            end
        else
            local vehicle = GetClosestVehicle(p:pos())
            local pPed = GetPlayerPed(sID)
            if not IsPedInVehicle(pPed, vehicle, true) then
                TriggerServerEvent("core:PutPlayerIntoVehicle", token, tonumber(sID), vehicle)
            else
                TriggerServerEvent("core:MakePlayerLeaveVehicle", token, tonumber(sID))
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

function GetVehiclePlate(target)
    local entity
    local dst
    if entity ~= nil then
        entity = entity
        dst = 0
    else
        entity, dst = GetClosestVehicle(p:pos())
    end
    local plate = all_trim(GetVehicleNumberPlateText(entity))
    local result = TriggerServerCallback("core:CheckVehiclePlate", plate) GetVehicleNumberPlateText(entity)

    if result then
        -- ShowNotification("Le véhicule appartient a Mr/Mme ~g~" .. result.nom .. " " .. result.prenom)

        -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Le véhicule est immatriculé : ~s".. plate ..""
        })
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Verification MDT ~sObligatoire"
        })

    end
end

function CuffPlayer(entity)
    local player
    local dst
    if entity ~= 0 then
        player = NetworkGetPlayerIndexFromPed(entity)
        dst = 0
    else
        player, dst = GetClosestPlayer()
    end

    if dst ~= nil and dst <= 2.0 then
        TriggerServerEvent("core:CuffPlayer", token, GetPlayerServerId(player))
        p:PlayAnim('mp_arresting', 'a_uncuff', 1)
        Modules.UI.RealWait(4000)
        ClearPedTasks(p:ped())
    end
end

function StartSearchOnPlayer(entity)

    local players = NetworkGetPlayerIndexFromPed(entity)
    local sID = GetPlayerServerId(players)

    -- print(sID .. "|" .. players)

    if entity == nil then
        local player, dst = GetClosestPlayer()

        if dst ~= nil and dst <= 2.0 then
            local data = TriggerServerCallback("core:GetIdentityPlayer", token, GetPlayerServerId(player))

            OpenInventoryPolicePlayer(GetPlayerServerId(player), data)
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
        print(entity)

        local data = TriggerServerCallback("core:GetIdentityPlayer", token, sID)
        OpenInventoryPolicePlayer(sID, data)
        print(entity)

    end

end

function permismenu(target)

    OpenContextMenu({
        {
            icon = "Carte",
            label = "Retirer permis voiture",
            action = "removepermisd",
            args = { target }
        },
        {
            icon = "Carte",
            label = "Retirer permis moto",
            action = "removepermism",
            args = { target }
        },
        {
            icon = "Carte",
            label = "Retirer permis camion",
            action = "removepermisc",
            args = { target }
        },
        {
            icon = "Carte",
            label = "Retirer permis helico",
            action = "removepermish",
            args = { target }
        },
        {
            icon = "Carte",
            label = "Retirer permis bateau",
            action = "removepermisb",
            args = { target }
        },
        {
            icon = "Carte",
            label = "Retirer code de la route",
            action = "removepermiscode",
            args = { target }
        },
    })
end

function removepermisd(entity)
    removepermis(entity, "driving")
end

function removepermism(entity)
    removepermis(entity, "moto")
end

function removepermisc(entity)
    removepermis(entity, "camion")
end

function removepermish(entity)
    removepermis(entity, "helico")
end

function removepermisb(entity)
    removepermis(entity, "bateau")
end

function removepermiscode(entity)
    removepermis(entity, "traffic_law")
end

function removepermis(entity, permis)
    local player = NetworkGetPlayerIndexFromPed(entity)
    local serverId = GetPlayerServerId(player)
    if entity == nil then
        local closestPlayer, closestDistance = GetClosestPlayer()
        if closestPlayer ~= nil and closestDistance < 3.0 then
            TriggerServerEvent("core:PermisCiaoByeBye", token, GetPlayerServerId(closestPlayer), permis)
        else
            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Aucun joueur dans la zone"
            })

        end
    else
        TriggerServerEvent("core:PermisCiaoByeBye", token, serverId, permis)
    end
end

function MoovePlayerCuffed(target)
    local player
    local dst
    if target ~= 0 then
        player = NetworkGetPlayerIndexFromPed(target)
        dst = 0
    else
        player, dst = GetClosestPlayer()
    end

    if dst ~= nil and dst <= 2.0 then
        TriggerServerEvent("core:escortPlayer", token, GetPlayerServerId(player))
    end
end

function SetVehicleInFourriere(entity)
    local stopped = false
    local dst
    if entity ~= nil then
        entity = entity
        dst = 0
    else
        entity, dst = GetClosestVehicle(p:pos())
    end
    local plate = all_trim(GetVehicleNumberPlateText(entity))

    TaskStartScenarioInPlace(p:ped(), "WORLD_HUMAN_CLIPBOARD", -1, true)
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'Progressbar',
        data = {
            text = "Mise en fourrière...",
            time = 7,
        }
    }))
    Modules.UI.RealWait(7000)

    TriggerServerEvent("police:SetVehicleInFourriere", token, plate, VehToNet(entity))
    TriggerEvent('persistent-vehicles/forget-vehicle', entity)
    DeleteEntity(entity)
    ClearPedTasks(p:ped())
end

function InfoVehLSPD(entity)
    print(entity)  
    -- New notif
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        duration = 8, -- In seconds, default:  4
        content = "Véhicule : ~s".. GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(entity))) ..""
    })
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        duration = 8, -- In seconds, default:  4
        content = "Plaque : ~s".. all_trim(GetVehicleNumberPlateText(entity)) ..""
    })
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        duration = 8, -- In seconds, default:  4
        content = "Carrosserie : ~s".. math.round(GetVehicleBodyHealth(entity) / 10, 2) .."%"
    })
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        duration = 8, -- In seconds, default:  4
        content = "État moteur : ~s".. math.round(GetVehicleEngineHealth(entity) / 10, 2) .."%"
    })
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        duration = 8, -- In seconds, default:  4
        content = "Essence : ~s".. math.round(GetVehicleFuelLevel(entity), 2) .."%"
    })
end

function MakeBillingPolice(entity)
    local billing_price = 0
    local billing_reason = ""
    local player = NetworkGetPlayerIndexFromPed(entity)
    local sID = GetPlayerServerId(player)
    local price = KeyboardImput("Entrez le prix")
    if price and type(tonumber(price)) == "number" then
        billing_price = tonumber(price)
    else
       -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Veuillez entrer un nombre"
        })

    end
    local reason = KeyboardImput("Entrez la raison")
    if reason ~= nil then
        billing_reason = tostring(reason)
    end

    if entity == nil then
        local closestPlayer, closestDistance = GetClosestPlayer()
        if closestPlayer ~= nil and closestDistance < 3.0 then
            TriggerServerEvent('core:sendbilling', token, GetPlayerServerId(closestPlayer),
                p:getJob(), billing_price, billing_reason)
        else
            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Aucun joueur dans la zone"
            })

        end
    else
        TriggerServerEvent('core:sendbilling', token, sID,
            p:getJob(), billing_price, billing_reason)
        -- ShowNotification("Facturation envoyée \n Prix : ~g~" ..
        --    billing_price .. "~s~$ \n Raison : " .. billing_reason)

        -- New notif
        exports['vNotif']:createNotification({
            type = 'VERT',
            -- duration = 5, -- In seconds, default:  4
            content = "Facturation envoyée \nPrix : ~s " .. billing_price .. "$ \n~c Raison : ~s " .. billing_reason
        })

    end
end

RegisterNetEvent("core:PutPlayerIntoVehicle")
AddEventHandler("core:PutPlayerIntoVehicle", function(vehicle)
    if DoesEntityExist(vehicle) then
        if AreAnyVehicleSeatsFree(vehicle) then
            TaskWarpPedIntoVehicle(p:ped(), vehicle, 1)
        end
    end
end)

RegisterNetEvent("core:MakePlayerLeaveVehicle")
AddEventHandler("core:MakePlayerLeaveVehicle", function()
    TaskLeaveAnyVehicle(p:ped(), 0, 0)
end)

RegisterNetEvent("core:CuffPlayer")
AddEventHandler("core:CuffPlayer", function()
    weaponOut = false
    SetCurrentPedWeapon(p:ped(), GetHashKey("weapon_unarmed"), 1)
    if isCuffed then
        ClearPedTasks(p:ped())
        SetEnableHandcuffs(p:ped(), false)
        isCuffed = false
        ClearPedTasks(p:ped())
    else
        isCuffed = true
        SetEnableHandcuffs(p:ped(), true)
        PlayEmote(dict, anim, flags, -1)
        StartCuffLoop()
    end
end)

RegisterNetEvent("core:EscortPlayer")
AddEventHandler("core:EscortPlayer", function(player)
    EnTrainEscorter = not EnTrainEscorter
    PoliceEscort = tonumber(player)
    if EnTrainEscorter then
        Escort()
    end
end) ]]