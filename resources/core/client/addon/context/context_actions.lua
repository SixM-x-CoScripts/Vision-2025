local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function UseVendingMachineCoca(entity)

    for k, v in pairs(p:getInventaire()) do
        if v.name == "money" and v.count >= 20 then
            TriggerServerEvent("core:RemoveItemToInventory", token, "money", 20,
                v.metadatas)
            TriggerSecurGiveEvent("core:addItemToInventory", token, "ecola", 1, {})
            -- ShowNotification("Vous venez d'acheter x1 ~o~eCola~s~")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous venez d'acheter ~s x1 eCola"
            })

        elseif v.name == "money" and v.count < 20 then
            -- ShowNotification("Vous n'avez pas assez d'argent")

            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~c Vous n'avez ~s pas assez d'argent"
            })

            return
        end
    end
    local DispenseDict = { "mini@sprunk", "plyr_buy_drink_pt1" }
    local PocketAnims = { "mp_common_miss", "put_away_coke" }
    local items = {
        ["coca"] = { "ng_proc_sodacan_01a", "e soda" },
    }
    if items["coca"] ~= nil then
        LoadModel(items["coca"][1])

        RequestAnimDict(DispenseDict[1])
        while not HasAnimDictLoaded(DispenseDict[1]) do
            Wait(0)
        end
        RequestAmbientAudioBank("VENDING_MACHINE")
        HintAmbientAudioBank("VENDING_MACHINE", 0, -1)
        SetPedResetFlag(p:ped(), 322, true)
        local position = GetOffsetFromEntityInWorldCoords(entity, 0.0, -0.97, 0.0)
        if not IsEntityAtCoord(p:ped(), position, 0.1, 0.1, 0.1, false, true, 0) then
            TaskGoStraightToCoord(p:ped(), position, 1.0, 20000, GetEntityHeading(entity), 0.1)
            while GetDistanceBetweenCoords(position, p:pos(), true) > 0.1 do
                Wait(2000)
                SetEntityCoordsNoOffset(p:ped(), position, 0.0, 0.0, 0.0)
            end
        end

        TaskTurnPedToFaceEntity(p:ped(), entity, -1)
        Wait(1000)
        TaskPlayAnim(p:ped(), DispenseDict[1], DispenseDict[2], 8.0, 5.0, -1, true, 1, 0, 0, 0)
        TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 8000)
        Wait(2500)
        local canModel = CreateObjectNoOffset(items["coca"][1], position, true, false, false)
        SetEntityProofs(canModel, false, true, false, false, false, false, 0, false)
        AttachEntityToEntity(canModel, p:ped(), GetPedBoneIndex(p:ped(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0
            , 2, 1)
        Wait(1700)

        RequestAnimDict(PocketAnims[1])
        while not HasAnimDictLoaded(PocketAnims[1]) do
            Wait(0)
        end

        Wait(1000)
        ClearPedTasks(p:ped())
        ReleaseAmbientAudioBank()
        RemoveAnimDict(DispenseDict[1])
        RemoveAnimDict(PocketAnims[1])
        if DoesEntityExist(canModel) then
            DetachEntity(canModel, true, true)
            DeleteEntity(canModel)
        end

        ExecuteCommand(items["coca"][2])
    end
end

function UseVendingMachineSprunk(entity)
    for k, v in pairs(p:getInventaire()) do
        if v.name == "money" and v.count >= 20 then
            TriggerServerEvent("core:RemoveItemToInventory", token, "money", 20,
                v.metadatas)
            TriggerSecurGiveEvent("core:addItemToInventory", token, "sprunk", 1, {})
            -- ShowNotification("Vous venez d'acheter x1 ~o~Sprunk~s~")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous venez d'acheter ~s x1 Sprunk"
            })

        elseif v.name == "money" and v.count < 20 then
            -- ShowNotification("Vous n'avez pas assez d'argent")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~c Vous n'avez ~s pas assez d'argent"
            })

            return
        end
    end
    local DispenseDict = { "mini@sprunk", "plyr_buy_drink_pt1" }
    local PocketAnims = { "mp_common_miss", "put_away_coke" }
    local items = {
        ["sprunk"] = { "ng_proc_sodacan_01b", "e soda" },
    }
    if items["sprunk"] ~= nil then

        LoadModel(items["sprunk"][1])

        RequestAnimDict(DispenseDict[1])
        while not HasAnimDictLoaded(DispenseDict[1]) do
            Wait(0)
        end
        RequestAmbientAudioBank("VENDING_MACHINE")
        HintAmbientAudioBank("VENDING_MACHINE", 0, -1)
        SetPedResetFlag(p:ped(), 322, true)
        local position = GetOffsetFromEntityInWorldCoords(entity, 0.0, -0.97, 0.0)
        if not IsEntityAtCoord(p:ped(), position, 0.1, 0.1, 0.1, false, true, 0) then
            TaskGoStraightToCoord(p:ped(), position, 1.0, 20000, GetEntityHeading(entity), 0.1)
            while GetDistanceBetweenCoords(position, p:pos(), true) > 0.1 do
                Wait(2000)
                SetEntityCoordsNoOffset(p:ped(), position, 0.0, 0.0, 0.0)
            end
        end

        TaskTurnPedToFaceEntity(p:ped(), entity, -1)
        Wait(1000)
        TaskPlayAnim(p:ped(), DispenseDict[1], DispenseDict[2], 8.0, 5.0, -1, true, 1, 0, 0, 0)
        TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 7000)
        Wait(2500)
        local canModel = CreateObjectNoOffset(items["sprunk"][1], position, true, false, false)
        SetEntityProofs(canModel, false, true, false, false, false, false, 0, false)
        AttachEntityToEntity(canModel, p:ped(), GetPedBoneIndex(p:ped(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0
            , 2, 1)
        Wait(1700)

        RequestAnimDict(PocketAnims[1])
        while not HasAnimDictLoaded(PocketAnims[1]) do
            Wait(0)
        end

        Wait(1000)
        ClearPedTasks(p:ped())
        ReleaseAmbientAudioBank()
        RemoveAnimDict(DispenseDict[1])
        RemoveAnimDict(PocketAnims[1])
        if DoesEntityExist(canModel) then
            DetachEntity(canModel, true, true)
            DeleteEntity(canModel)
        end

        ExecuteCommand(items["sprunk"][2])
    end
end

function UseVendingMachineChips(entity)
    for k, v in pairs(p:getInventaire()) do
        if v.name == "money" and v.count >= 20 then
            TriggerServerEvent("core:RemoveItemToInventory", token, "money", 20,
                v.metadatas)
            TriggerSecurGiveEvent("core:addItemToInventory", token, "tapas", 1, {})
            -- ShowNotification("Vous venez d'acheter x1 ~o~Tapas~s~")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous venez d'acheter ~s x1 Tapas"
            })

        elseif v.name == "money" and v.count < 20 then
            -- ShowNotification("Vous n'avez pas assez d'argent")
            
            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~c Vous n'avez ~s pas assez d'argent"
            })
            
            return
        end
    end
    local DispenseDict = { "mini@sprunk", "plyr_buy_drink_pt1" }
    local PocketAnims = { "mp_common_miss", "put_away_coke" }
    local items = {
        ["chips"] = { "prop_food_bs_chips", "e eat" },
    }
    if items["chips"] ~= nil then

        LoadModel(items["chips"][1])

        RequestAnimDict(DispenseDict[1])
        while not HasAnimDictLoaded(DispenseDict[1]) do
            Wait(0)
        end
        RequestAmbientAudioBank("VENDING_MACHINE")
        HintAmbientAudioBank("VENDING_MACHINE", 0, -1)
        SetPedResetFlag(p:ped(), 322, true)
        local position = GetOffsetFromEntityInWorldCoords(entity, 0.0, -0.97, 0.0)
        if not IsEntityAtCoord(p:ped(), position, 0.1, 0.1, 0.1, false, true, 0) then
            TaskGoStraightToCoord(p:ped(), position, 1.0, 20000, GetEntityHeading(entity), 0.1)
            while GetDistanceBetweenCoords(position, p:pos(), true) > 0.1 do
                Wait(2000)
                SetEntityCoordsNoOffset(p:ped(), position, 0.0, 0.0, 0.0)
            end
        end

        TaskTurnPedToFaceEntity(p:ped(), entity, -1)
        Wait(1000)
        TaskPlayAnim(p:ped(), DispenseDict[1], DispenseDict[2], 8.0, 5.0, -1, true, 1, 0, 0, 0)
        TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
        Wait(2500)
        local canModel = CreateObjectNoOffset(items["chips"][1], position, true, false, false)
        SetEntityProofs(canModel, false, true, false, false, false, false, 0, false)
        AttachEntityToEntity(canModel, p:ped(), GetPedBoneIndex(p:ped(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0
            , 2, 1)
        Wait(1700)

        RequestAnimDict(PocketAnims[1])
        while not HasAnimDictLoaded(PocketAnims[1]) do
            Wait(0)
        end

        Wait(1000)
        ClearPedTasks(p:ped())
        ReleaseAmbientAudioBank()
        RemoveAnimDict(DispenseDict[1])
        RemoveAnimDict(PocketAnims[1])


        ExecuteCommand(items["chips"][2])
        Wait(2000)
        if DoesEntityExist(canModel) then
            DetachEntity(canModel, true, true)
            DeleteEntity(canModel)
        end
    end
end

function UseVendingMachineCoffee(entity)
    for k, v in pairs(p:getInventaire()) do
        if v.name == "money" and v.count >= 20 then
            TriggerServerEvent("core:RemoveItemToInventory", token, "money", 20,
                v.metadatas)
            TriggerSecurGiveEvent("core:addItemToInventory", token, "coffee", 1, {})
            -- ShowNotification("Vous venez d'acheter x1 ~o~Café~s~")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous venez d'acheter ~s x1 Café"
            })

        elseif v.name == "money" and v.count < 20 then
            -- ShowNotification("Vous n'avez pas assez d'argent")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~c Vous n'avez ~s pas assez d'argent"
            })

            return
        end
    end
    local DispenseDict = { "mini@sprunk", "plyr_buy_drink_pt1" }
    local PocketAnims = { "mp_common_miss", "put_away_coke" }
    local items = {
        ["coffee"] = { "p_ing_coffeecup_01", "e coffee" },
    }
    if items["coffee"] ~= nil then

        LoadModel(items["coffee"][1])

        RequestAnimDict(DispenseDict[1])
        while not HasAnimDictLoaded(DispenseDict[1]) do
            Wait(0)
        end
        RequestAmbientAudioBank("VENDING_MACHINE")
        HintAmbientAudioBank("VENDING_MACHINE", 0, -1)
        SetPedResetFlag(p:ped(), 322, true)
        local position = GetOffsetFromEntityInWorldCoords(entity, 0.0, -0.97, 0.0)
        if not IsEntityAtCoord(p:ped(), position, 0.1, 0.1, 0.1, false, true, 0) then
            TaskGoStraightToCoord(p:ped(), position, 1.0, 20000, GetEntityHeading(entity), 0.1)
            while GetDistanceBetweenCoords(position, p:pos(), true) > 0.1 do
                Wait(2000)
                SetEntityCoordsNoOffset(p:ped(), position, 0.0, 0.0, 0.0)
            end
        end

        TaskTurnPedToFaceEntity(p:ped(), entity, -1)
        Wait(1000)
        TaskPlayAnim(p:ped(), DispenseDict[1], DispenseDict[2], 8.0, 5.0, -1, true, 1, 0, 0, 0)
        TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
        Wait(2500)
        local canModel = CreateObjectNoOffset(items["coffee"][1], position, true, false, false)
        SetEntityProofs(canModel, false, true, false, false, false, false, 0, false)
        AttachEntityToEntity(canModel, p:ped(), GetPedBoneIndex(p:ped(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0
            , 2, 1)
        Wait(1700)

        RequestAnimDict(PocketAnims[1])
        while not HasAnimDictLoaded(PocketAnims[1]) do
            Wait(0)
        end

        Wait(1000)
        ClearPedTasks(p:ped())
        ReleaseAmbientAudioBank()
        RemoveAnimDict(DispenseDict[1])
        RemoveAnimDict(PocketAnims[1])


        ExecuteCommand(items["coffee"][2])
        Wait(2000)
        if DoesEntityExist(canModel) then
            DetachEntity(canModel, true, true)
            DeleteEntity(canModel)
        end
    end
end

function UseFontaine(entity)
    for k, v in pairs(p:getInventaire()) do
        if v.name == "money" and v.count >= 20 then
            TriggerServerEvent("core:RemoveItemToInventory", token, "money", 20,
                v.metadatas)
            TriggerSecurGiveEvent("core:addItemToInventory", token, "water", 1, {})
            -- ShowNotification("Vous venez d'acheter x1 ~o~Bouteille d'eau~s~")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous venez d'acheter ~s x1 Bouteille d'eau"
            })

        elseif v.name == "money" and v.count < 20 then
            -- ShowNotification("Vous n'avez pas assez d'argent")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~c Vous n'avez ~s pas assez d'argent"
            })

            return
        end
    end
    local DispenseDict = { "mini@sprunk", "plyr_buy_drink_pt1" }
    local PocketAnims = { "mp_common_miss", "put_away_coke" }
    local items = {
        ["water"] = { "prop_ld_flow_bottle", "e drink" },
    }
    if items["water"] ~= nil then

        LoadModel(items["water"][1])

        RequestAnimDict(DispenseDict[1])
        while not HasAnimDictLoaded(DispenseDict[1]) do
            Wait(0)
        end
        RequestAmbientAudioBank("VENDING_MACHINE")
        HintAmbientAudioBank("VENDING_MACHINE", 0, -1)
        SetPedResetFlag(p:ped(), 322, true)
        local position = GetOffsetFromEntityInWorldCoords(entity, 0.0, -0.97, 0.0)
        if not IsEntityAtCoord(p:ped(), position, 0.1, 0.1, 0.1, false, true, 0) then
            TaskGoStraightToCoord(p:ped(), position, 1.0, 20000, GetEntityHeading(entity), 0.1)
            while GetDistanceBetweenCoords(position, p:pos(), true) > 0.1 do
                Wait(2000)
                SetEntityCoordsNoOffset(p:ped(), position, 0.0, 0.0, 0.0)
            end
        end

        TaskTurnPedToFaceEntity(p:ped(), entity, -1)
        Wait(1000)
        TaskPlayAnim(p:ped(), DispenseDict[1], DispenseDict[2], 8.0, 5.0, -1, true, 1, 0, 0, 0)
        TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
        Wait(2500)
        local canModel = CreateObjectNoOffset(items["water"][1], position, true, false, false)
        SetEntityProofs(canModel, false, true, false, false, false, false, 0, false)
        AttachEntityToEntity(canModel, p:ped(), GetPedBoneIndex(p:ped(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0
            , 2, 1)
        Wait(1700)

        RequestAnimDict(PocketAnims[1])
        while not HasAnimDictLoaded(PocketAnims[1]) do
            Wait(0)
        end

        Wait(1000)
        ClearPedTasks(p:ped())
        ReleaseAmbientAudioBank()
        RemoveAnimDict(DispenseDict[1])
        RemoveAnimDict(PocketAnims[1])


        ExecuteCommand(items["water"][2])
        Wait(2000)
        if DoesEntityExist(canModel) then
            DetachEntity(canModel, true, true)
            DeleteEntity(canModel)
        end
    end
end

function TaskTakeBike(target)
    local ped = PlayerPedId()
    
    if IsPedOnFoot(ped) then
        local vehicleHash = GetEntityModel(target)
        
        if IsThisModelABike(vehicleHash) then
            local playerCoords = GetEntityCoords(ped)
            local vehicleCoords = GetEntityCoords(target)
            local distance = #(playerCoords - vehicleCoords)
            
            if distance <= 5.0 then -- Vérifie si le joueur est proche du vélo
                RequestAnimDict("pickup_object") while not HasAnimDictLoaded("pickup_object") do Wait(0) end
                if AreAnyVehicleSeatsFree(target) and GetPedInVehicleSeat(target, -1) == 0 then
                    TaskPlayAnim(ped, "pickup_object", "pickup_low", 8.0, -8.0, -1, 0, 0, false, false, false)
                    local props = vehicle.getProps(target)
                    TriggerSecurGiveEvent("core:addItemToInventory", token, "bike", 1, {
                        renamed = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(target))),
                        name = GetDisplayNameFromVehicleModel(GetEntityModel(target)),
                        plate = GetVehicleNumberPlateText(target),
                        props = props
                    })
                    TriggerServerEvent("DeleteEntity", token, { VehToNet(target) })
                    DeleteEntity(target)
                    --print("ok::addItemToInventory")
                end
            end
        else
            --print("action impossible, tu peux avoir que un seul vélo")
        end
    else
        --print("impossible de prendre le vélo car tu est déjà sur un vélo")
    end
end

function TaskTakeWheel(target)
    local ped = PlayerPedId()
    
    if IsPedOnFoot(ped) then
        local vehicleHash = GetEntityModel(target)
        
        if IsThisModelABike(vehicleHash) then
            local playerCoords = GetEntityCoords(ped)
            local vehicleCoords = GetEntityCoords(target)
            local distance = #(playerCoords - vehicleCoords)
            
            if distance <= 5.0 then -- Vérifie si le joueur est proche du vélo
                RequestAnimDict("pickup_object") while not HasAnimDictLoaded("pickup_object") do Wait(0) end
                if AreAnyVehicleSeatsFree(target) and GetPedInVehicleSeat(target, -1) == 0 then
                    TaskPlayAnim(ped, "pickup_object", "pickup_low", 8.0, -8.0, -1, 0, 0, false, false, false)
                    local props = vehicle.getProps(target)
                    TriggerSecurGiveEvent("core:addItemToInventory", token, "wheelchair", 1, {})
                    TriggerServerEvent("DeleteEntity", token, { VehToNet(target) })
                    DeleteEntity(target)
                end
            end
        end
    end
end


function TakeSurfBeach(target)
    if AreAnyVehicleSeatsFree(target) and print(GetPedInVehicleSeat(target, -1)) ~= 0 then
        local props = vehicle.getProps(target)
        TriggerSecurGiveEvent("core:addItemToInventory", token, "surfboard", 1, {})

        DeleteEntity(target)
    end
end

local contextOpen = false
function OpenContextMenu(table)
    printDev("Table context menu", type(table), table)
    if type(table) ~= "table" then 
        print("Le context menu ne peut pas s'ouvrir a cause des arguments", type(table), table)
        return 
    end
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
            printDev("Type of GetControl", type(GetControlNormal(0, 239)), type(GetControlNormal(0, 240)), GetControlNormal(0, 239), GetControlNormal(0, 240))
            SendNuiMessage(json.encode({
                type = 'openWebview',
                name = 'Interaction',
                data = {
                    position = { x = type(GetControlNormal(0, 239)) == "number" and GetControlNormal(0, 239) or 0.5, y = type(GetControlNormal(0, 239)) == "number" and GetControlNormal(0, 240) or 0.5},
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

function ShowIds(entity)
    local player = NetworkGetPlayerIndexFromPed(entity)
    local sID = GetPlayerServerId(player)
    print("Id Serveur du joueur : " .. sID or "?")

    exports['vNotif']:createNotification({
        type = 'JAUNE',
        -- duration = 5, -- In seconds, default:  4
        content = "ID Serveur du joueur : " .. sID or '?'
    })
end

function contextMenuPage2(entity)
    local player = NetworkGetPlayerIndexFromPed(entity)
    local sID = GetPlayerServerId(player)
    -- close the context menu and open the new one
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
    -- open the new one
    OpenContextMenu(
        {
            {
                icon = "Facture",
                label = "Facture personelle",
                action = "MakeBillingPlayer",
                args = { entity }
            },
            {
                icon = "debout",
                label = "Porter la personne",
                action = "CarryPeople",
                args = { entity }
            },
        })
end

-- Stand by je finis si j'ai le temps après les choses prioritaires
function transformSapinToSapinNoel(entity)
    local x, y ,z = table.unpack(GetEntityCoords(entity))
    DeleteEntity(entity)

    local prop = "prop_xmas_tree_int"
    local modelhash = GetHashKey(prop)
    local isNetwork = true

    RequestModel(modelhash)
    while not HasModelLoaded(modelhash) do
      Wait(100)
    end
    TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
    sapin = CreateObject(modelhash, x, y, z, isNetwork, false, false)
    FreezeEntityPosition(sapin, true)
    PlaceObjectOnGroundProperly(sapin)
    SetModelAsNoLongerNeeded(modelhash) -- unload de la mémoire le props (bonne procédure d'opti)
end

-- Delete le sapin et donne l'item sapin
function ramasserSapinNoel(entity)

    FreezeEntityPosition(p:ped(), true)
    p:PlayAnim("mini@repair", "fixing_a_ped", 1)
    Wait(6500)
    ClearPedTasks(p:ped())
    FreezeEntityPosition(p:ped(), false)
    
    DeleteEntity(entity)
    TriggerSecurGiveEvent("core:addItemToInventory", token, "sapin", 1, {})
    TriggerSecurGiveEvent("core:addItemToInventory", token, "guirlande", 1, {})
    local randombreak = math.random(0,100)
    if randombreak <= 60 then
        TriggerSecurGiveEvent("core:addItemToInventory", token, "boulenoel", 3, {})
        -- ShowNotification("Vous avez démonté le sapin !")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez démonté le sapin !"
        })

    else 
        TriggerSecurGiveEvent("core:addItemToInventory", token, "boulenoel", 2, {})
        -- ShowNotification("Vous avez cassé une boule en démontant le sapin !")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez cassé une boule en démontant le sapin !"
        })

    end
end


-- Ramassage props

function ramasserProps(entity)

    FreezeEntityPosition(p:ped(), true)
    p:PlayAnim("pickup_object", "pickup_low", 0.5)
    Wait(1500)
    ClearPedTasks(p:ped())
    FreezeEntityPosition(p:ped(), false)
        
    DeleteEntity(entity)
end

-- Freeze props

function freezeProps(entity)

    -- Voir si il est freeze ou pas : print(IsEntityPositionFrozen(entity))

    local freeze = IsEntityPositionFrozen(entity)

    if not freeze then
        -- print('Freeze')

        FreezeEntityPosition(entity, true)
        freeze = true

    else
        -- print('Unfreeze')

        FreezeEntityPosition(entity, false)
        freeze = false
    end

end
