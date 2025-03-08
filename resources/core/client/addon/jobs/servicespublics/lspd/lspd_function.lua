local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local dict = "mp_arresting"
local anim = "idle"

local flags = 49 -- Let the player move

CurrentEscort = nil

isCuffed = false
local prevFemaleVariation = nil
local prevMaleVariation = nil
local LockedControlsWithoutMove = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 12, 13, 14, 15, 16, 17, 24, 25, 26, 27, 28, 29, 34, 35, 36, 37, 44, 45, 47, 48, 56, 57, 58, 73, 75, 76, 77, 78, 80, 81, 82, 83, 85, 86, 87, 88, 89, 91, 92, 99, 100, 101, 102, 106, 114, 122, 135, 136, 137, 142, 143, 177, 178, 179, 184, 185, 186, 187, 188, 189, 190, 195, 196, 197, 198, 199, 200, 201, 202, 203, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 257, 261, 262, 263, 264, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360 }
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
            -- show notification
            --[[ ShowAdvancedNotification("Permis", "Information", "" .. table.concat(printing, ", "), "CHAR_CALL911",
                "CHAR_CALL911")
 ]]
            -- New notif

            local tablepermis = table.concat(printing, ", ")

            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Permis possédé : ~s" .. (tablepermis=="" and "Aucun" or tablepermis)
            })

                
        else
            --[[ ShowAdvancedNotification("Permis", "Information", "Aucun joueur dans la zone", "CHAR_CALL911",
                "CHAR_CALL911") ]]

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
        -- show notification
        --[[ ShowAdvancedNotification("Permis", "Information", "" .. table.concat(printing, ", "), "CHAR_CALL911",
            "CHAR_CALL911") ]]

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
            --[[ ShowAdvancedNotification("Permis", "Information", "Aucun joueur dans la zone", "CHAR_BRYONY",
                "CHAR_BRYONY") ]]

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
            --[[ ShowAdvancedNotification("Permis", "Information", "Aucun joueur dans la zone", "CHAR_BRYONY",
                "CHAR_BRYONY") ]]

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

function IsEmergencyVehicle(vehicle)
    local vehicleClass = GetVehicleClass(vehicle)
    return vehicleClass == 18
end

function StartCuffLoop()
    local unarmedHash = GetHashKey("WEAPON_UNARMED")
    weaponOut = false

    local moveControls = { 0, 1, 2, 23, 30, 31, 32, 33, 249 }

    while isCuffed do
        if GetSelectedPedWeapon(p:ped()) ~= unarmedHash then
            SetCurrentPedWeapon(p:ped(), unarmedHash, true)
        end

        if not IsEntityPlayingAnim(p:ped(), dict, anim, flags) then
            PlayEmote(dict, anim, flags, 5000)
        end

        DisableAllControlActions(0)
        for _, control in ipairs(moveControls) do
            EnableControlAction(0, control, true)
        end

        if IsPedInAnyVehicle(p:ped(), false) then
            local vehicle = GetVehiclePedIsIn(p:ped(), false)

            if GetEntitySpeed(vehicle) < 1.0 then
                EnableControlAction(0, 75, true)
            end 

            if IsEmergencyVehicle(vehicle) and (GetPedInVehicleSeat(vehicle, -1) == p:ped() or GetPedInVehicleSeat(vehicle, 0) == p:ped()) then
                if IsVehicleSeatFree(vehicle, 1) then
                    TaskWarpPedIntoVehicle(p:ped(), vehicle, 1)
                elseif IsVehicleSeatFree(vehicle, 2) then
                    TaskWarpPedIntoVehicle(p:ped(), vehicle, 2)
                end
            end
        end

        Citizen.Wait(5)
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

            if IsControlJustPressed(0, 73) then
                EnTrainEscorter = false
                DetachEntity(p:ped(), true, false)
            end
        end
        DetachEntity(p:ped(), true, false)
    end)
end

function PlacePlayerIntoVehicle(vehEntity)
    if policeDuty or lssdDuty or GCPDuty or usssDuty or boiDuty then
        if CurrentEscort then
            local sID = CurrentEscort
            CurrentEscort = nil
            TriggerServerEvent("core:PutPlayerIntoVehicle", token, tonumber(sID), VehToNet(vehEntity))
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous ne pouvez mettre une personne dans un véhicule sans l'escorter."
            })
        end
    else
        -- ShowNotification("Vous n'êtes pas en service")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous n'êtes ~s pas en service."
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
        distance = GetDistanceBetweenCoords(GetEntityCoords(p:ped()), GetEntityCoords(entity), true)
        if distance <= 2.0 then
            local data = TriggerServerCallback("core:GetIdentityPlayer", token, sID)
            OpenInventoryPolicePlayer(sID, data)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "~sVous êtes trop loin !"
            })
        end

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
            --[[ ShowAdvancedNotification("Permis", "Information", "Aucun joueur dans la zone", "CHAR_CALL911",
                "CHAR_CALL911") ]]

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

function MoovePlayerCuffed(target, id)
    local player
    local dst

    if id == true then
        player = GetPlayerFromServerId(target)
        dst = 0
    elseif target ~= 0 then
        player = NetworkGetPlayerIndexFromPed(target)
        dst = 0
    else
        player, dst = GetClosestPlayer()
    end

    if dst and dst <= 2.0 and (not CurrentEscort or CurrentEscort == GetPlayerServerId(player)) and not EnTrainEscorter then
        TriggerServerEvent("core:escortPlayer", token, GetPlayerServerId(player))
    end
end

RegisterNetEvent("core:returnStatusEscord")
AddEventHandler("core:returnStatusEscord", function(id)
    if CurrentEscort == id then
        CurrentEscort = nil
    else
        CurrentEscort = id
    end
end)

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
    TriggerEvent("core:RefreshData", playerData)
    DeleteEntity(entity)
    ClearPedTasks(p:ped())
end

function InfoVehLSPD(entity)
    --[[ ShowAdvancedNotification("Central",
        "Véhicule : " .. GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(entity))),
        "\nPlaque : ~b~" .. all_trim(GetVehicleNumberPlateText(entity))
        .. "\n~s~Carrosserie : ~b~" .. math.round(GetVehicleBodyHealth(entity) / 10, 2) .. "~s~%"
        .. "\nÉtat moteur : ~b~" .. math.round(GetVehicleEngineHealth(entity) / 10, 2) .. "~s~%"
        .. "\nEssence : ~o~" .. math.round(GetVehicleFuelLevel(entity), 2) .. "~s~%", "CHAR_CALL911", "CHAR_CALL911") ]]
    
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
        --[[ ShowAdvancedNotification("Centrale", "Facturation", "Veuillez entrer un nombre", "CHAR_CALL911",
            "CHAR_CALL911") ]]

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
            --[[ ShowAdvancedNotification("Centrale", "Facturation", "Aucun joueur dans la zone", "CHAR_BRYONY",
                "CHAR_BRYONY") ]]

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
AddEventHandler("core:PutPlayerIntoVehicle", function(vehiclee)
    EnTrainEscorter = false
    DetachEntity(p:ped(), true, false)
    Wait(1)
    local vehicle = NetToVeh(vehiclee)
    if DoesEntityExist(vehicle) then
        if IsVehicleSeatFree(vehicle, 1) then
            TaskWarpPedIntoVehicle(p:ped(), vehicle, 1)
        elseif IsVehicleSeatFree(vehicle, 2) then
            TaskWarpPedIntoVehicle(p:ped(), vehicle, 2)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Il n'y a plus de place dans le véhicule"
            })
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

        exports["lb-phone"]:ToggleDisabled(false)
        exports["rpemotes"]:ToggleDisabled(false)
        exports["ContextMenu"]:ToggleDisabled(false)
        
        exports["pma-voice"]:setVoiceProperty("radioEnabled", true)

        SetPedMoveRateOverride(p:ped(), 1.0)

        EnableAllControlActions(0)

        isCuffed = false
        ClearPedTasks(p:ped())
    else
        isCuffed = true

        exports["lb-phone"]:ToggleDisabled(true)
        exports["rpemotes"]:ToggleDisabled(true)
        exports["ContextMenu"]:ToggleDisabled(true)
        exports["pma-voice"]:setRadioChannel(0)
        exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
        RadioToggle(false)

        SetPedMoveRateOverride(p:ped(), 0.9)

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
end)
