local token = nil
local societyInventory = {}
societyInventory.item = {}
societyInventory.cloths = {}
local weapons = {}
local items = {}
local itemsSociety = {}
local itemsVehicle = {}
local itemsProperty = {}
local vehWeight = 80
local propertyName = nil
local lockCar = false
local _property = nil
Plate = nil
Society = false
Police = true
Vehicle = false
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

RegisterNetEvent("core:RefreshSocietyInventory")
AddEventHandler("core:RefreshSocietyInventory", function(inventory)
    societyInventory = inventory
end)
Vehicle = false
local casierJob = nil
local numberCasier = nil
local open = false

CreateThread(function()
    while true do
        Wait(0)
        if open then
            DisableControlAction(0, 24, true) -- disable attack
            DisableControlAction(0, 25, true) -- disable aim
            DisableControlAction(0, 1, true) -- LookLeftRight
            DisableControlAction(0, 2, true) -- LookUpDown
            DisableControlAction(0, 142, open)
            DisableControlAction(0, 18, open)
            DisableControlAction(0, 322, open)
            DisableControlAction(0, 106, open)
            DisableControlAction(0, 263, true) -- disable melee
            DisableControlAction(0, 264, true) -- disable melee
            DisableControlAction(0, 257, true) -- disable melee
            DisableControlAction(0, 140, true) -- disable melee
            DisableControlAction(0, 141, true) -- disable melee
            DisableControlAction(0, 142, true) -- disable melee
            DisableControlAction(0, 143, true) -- disable melee
        else
            Wait(250)
        end
    end
end)

function OpenInventorySocietyMenu(capacity)
    if open then
        open = false
        SetNuiFocusKeepInput(false)
        EnableControlAction(0, 1, true)
        EnableControlAction(0, 24, true)
        EnableControlAction(0, 25, true)
        EnableControlAction(0, 2, true)
        EnableControlAction(0, 142, true)
        EnableControlAction(0, 18, true)
        EnableControlAction(0, 322, true)
        EnableControlAction(0, 106, true)
        SetNuiFocus(false, false)
        openRadarProperly()
        SendNuiMessage(json.encode({
            type = 'closeWebview'
        }))
        return
    else
        open = true
        if loadedJob.grade[pJobGrade] ~= nil then
            if loadedJob.grade[pJobGrade].coffre ~= nil then
                if loadedJob.grade[pJobGrade].coffre then
                    local invSociety = TriggerServerCallback("core:GetSocietyInventoryItem", pJob)
                    local inv = p:getInventaire()
                    items = {}
                    local clothes = {}
                    weapons = {}
                    itemsSociety = {}
                    for k, v in pairs(inv) do
                        if v.type == "items" or v.type == "weapons" or v.type == "clothes" then
                            table.insert(items,
                                { name = v.name, count = v.count, label = v.label, cols = v.cols, rows = v.rows,
                                    type = v.type,
                                    metadatas = v.metadatas, weight = v.weight })
                        elseif v.type == "clothes" then
                            -- table.insert(clothes,
                            --     { name = k, count = v.count, label = v.label, cols = v.cols, rows = v.rows, type = v.type,
                            --         metadatas = v.metadatas })
                        elseif v.type == "weapons" then
                            -- table.insert(weapons,
                            --     { name =  v.name, count = v.count, label = v.label, cols = v.cols, rows = v.rows, type = v.type,
                            --         metadatas = v.metadatas })
                        end
                    end
                    for k, v in pairs(invSociety) do
                        if v.type == "items" or v.type == "weapons" then
                            table.insert(itemsSociety,
                                { name = v.name, count = v.count, label = v.label, cols = v.cols, rows = v.rows,
                                    type = v.type,
                                    metadatas = v.metadatas, weight = v.weight })
                        end
                    end
                    Society = true
                    Vehicle = false
                    Casier = false
                    Police = false
                    PropertyCoffre = false
                    items = FormulateInventory(items)
                    itemsSociety = FormulateInventory(itemsSociety)

                    isSocietyCoffreUsing = TriggerServerCallback("core:getUsingStatusSocietyCoffre", pJob, true)

                    if not isSocietyCoffreUsing then

                        Citizen.CreateThread(function()
                            SendNUIMessage({
                                type = "openWebview",
                                name = "inventory",
                                data = { items = items, clothes = {}, weapons = Weapons,
                                    target = { items = itemsSociety, maxWeight = capacity and capacity or 1000.0, name = "Coffre " .. pJob } }
                            })
                        end)
                    else
                        --ShowNotification("Quelqu'un est déjà en train de fouiller dans le coffre")
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            -- duration = 5, -- In seconds, default:  4
                            content = "Quelqu'un regarde déjà le coffre"
                        })

                        open = false
                        SetNuiFocusKeepInput(false)
                        EnableControlAction(0, 1, true)
                        EnableControlAction(0, 24, true)
                        EnableControlAction(0, 25, true)
                        EnableControlAction(0, 2, true)
                        EnableControlAction(0, 142, true)
                        EnableControlAction(0, 18, true)
                        EnableControlAction(0, 322, true)
                        EnableControlAction(0, 106, true)
                        SetNuiFocus(false, false)
                        --DisplayRadar(true)
                        SendNuiMessage(json.encode({
                            type = 'closeWebview'
                        }))
                        
                        return
                    end

                else

                    -- ShowNotification("Tu n'as pas accès au coffre de cette société")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Tu n'as ~s pas accès au coffre ~c de cette société"
                    })

                    open = false
                    SetNuiFocusKeepInput(false)
                    EnableControlAction(0, 1, true)
                    EnableControlAction(0, 24, true)
                    EnableControlAction(0, 25, true)
                    EnableControlAction(0, 2, true)
                    EnableControlAction(0, 142, true)
                    EnableControlAction(0, 18, true)
                    EnableControlAction(0, 322, true)
                    EnableControlAction(0, 106, true)
                    SetNuiFocus(false, false)
                    --DisplayRadar(true)
                    SendNuiMessage(json.encode({
                        type = 'closeWebview'
                    }))
                    return
                end
            end
        end
    end
end

local clothes = {}
function OpenInventoryVehicle(plate, model, entity)
    local invVehicle = TriggerServerCallback("core:GetVehicleInventory", plate, model, entity, VehToNet(entity))
    ExecuteCommand("me ouvre le coffre")
    local inv = p:getInventaire()
    items = {}
    clothes = {}
    weapons = {}
    itemsVehicle = {}
    for k, v in pairs(inv) do
        if v.type == "items" or v.type == "weapons" or v.type == "clothes" then
            table.insert(items,
                { name = v.name, count = v.count, label = v.label, cols = v.cols, rows = v.rows, type = v.type,
                    metadatas = v.metadatas, weight = v.weight })
        end
    end
    for k, v in pairs(invVehicle) do
        if v.type == "items" or v.type == "weapons" or v.type == "clothes" then
            table.insert(itemsVehicle,
                { name = v.name, count = v.count, label = v.label, cols = v.cols, rows = v.rows, type = v.type,
                    metadatas = v.metadatas, weight = v.weight })
        end
    end

    Plate = plate
    TriggerServerEvent("core:joinedcoffre", Plate, true)
    Vehicle = true
    Society = false
    Casier = false
    Police = false
    PropertyCoffre = false
    items = FormulateInventory(items)
    itemsVehicle = FormulateInventory(itemsVehicle)
    Citizen.CreateThread(function()
        local name = GetLabelText(GetDisplayNameFromVehicleModel(model))
        if coffre[model] ~= nil then
            SendNUIMessage({
                type = "openWebview",
                name = "inventory",
                data = { items = items, clothes = {}, weapons = Weapons,
                    target = { items = itemsVehicle, maxWeight = coffre[model] / 1000, name = "Coffre " .. name } }
            })
        else
            SendNUIMessage({
                type = "openWebview",
                name = "inventory",
                data = { items = items, clothes = {}, weapons = Weapons,
                    target = { items = itemsVehicle, maxWeight = 100, name = "Coffre " .. name } }
            })
        end
    end)
end

function OpenInventoryProperty(property, property_inventory, player_inventory)
    --if TriggerServerCallback("core:property:canAccessCoffre", property.id) then
        Vehicle = false
        Society = false
        Casier = false
        Police = false
        PropertyCoffre = true

        _property = property

        if open then
            open = false
            SetNuiFocusKeepInput(false)
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 24, true)
            EnableControlAction(0, 25, true)
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 142, true)
            EnableControlAction(0, 18, true)
            EnableControlAction(0, 322, true)
            EnableControlAction(0, 106, true)
            SetNuiFocus(false, false)
            --DisplayRadar(true)
            SendNuiMessage(json.encode({
                type = 'closeWebview'
            }))
            return
        else
            open = true
            player_inventory = FormulateInventory(player_inventory)
            property_inventory = FormulateInventory(property_inventory)
            local propertyName = GetPropertyName(_property.id)
            SendNUIMessage({
                type = "openWebview",
                name = "inventory",
                data = {
                    items = player_inventory,
                    clothes = {},
                    weapons = p:getWeapons(),
                    target = {
                        items = property_inventory,
                        maxWeight = property.weight,
                        name = "Propriété " .. (propertyName or "")
                    }
                }
            })
        end
    --else
    --    -- New notif
    --    exports['vNotif']:createNotification({
    --        type = 'ROUGE',
    --        -- duration = 5, -- In seconds, default:  4
    --        content = "Quelqu'un regarde déjà le coffre"
    --    })
    --end
end

function OpenMailBoxProperty(property, property_mailbox, player_inventory)

    _property = property

    if open then
        open = false
        SetNuiFocusKeepInput(false)
        EnableControlAction(0, 1, true)
        EnableControlAction(0, 24, true)
        EnableControlAction(0, 25, true)
        EnableControlAction(0, 2, true)
        EnableControlAction(0, 142, true)
        EnableControlAction(0, 18, true)
        EnableControlAction(0, 322, true)
        EnableControlAction(0, 106, true)
        SetNuiFocus(false, false)
        SendNuiMessage(json.encode({
            type = 'closeWebview'
        }))
        return
    else
        open = true
        Vehicle = false
        Society = false
        Casier = false
        Police = false
        PropertyCoffre = false
        MailBox = true
        player_inventory = FormulateInventory(player_inventory)
        property_mailbox = FormulateInventory(property_mailbox)
        local propertyName = GetPropertyName(_property.id)
        SendNUIMessage({
            type = "openWebview",
            name = "inventory",
            data = {
                items = player_inventory,
                clothes = {},
                weapons = {},
                target = {
                    items = property_mailbox,
                    maxWeight = 3.0,
                    name = "Boite aux lettres de : " .. (propertyName or "")
                }
            } 
        })
    end
end

function OpenInventoryCasier(job, id)
    if open then
        open = false
        SetNuiFocusKeepInput(false)
        EnableControlAction(0, 1, true)
        EnableControlAction(0, 24, true)
        EnableControlAction(0, 25, true)
        EnableControlAction(0, 2, true)
        EnableControlAction(0, 142, true)
        EnableControlAction(0, 18, true)
        EnableControlAction(0, 322, true)
        EnableControlAction(0, 106, true)
        SetNuiFocus(false, false)
        --DisplayRadar(true)
        SendNuiMessage(json.encode({
            type = 'closeWebview'
        }))
        return
    else
        open = true
        casierJob = job
        numberCasier = id
        local casier = TriggerServerCallback("core:casier:getOneCasier", token, casierJob, numberCasier)
        Wait(100)
        local inv = p:getInventaire()
        items = {}
        clothes = {}
        weapons = {}
        itemsVehicle = {}
        for k, v in pairs(inv) do
            if v.type == "items" or v.type == "weapons" or v.type == "clothes" then
                table.insert(items,
                    { name = v.name, count = v.count, label = v.label, cols = v.cols, rows = v.rows, type = v.type,
                        metadatas = v.metadatas, weight = v.weight })
            end
        end
        for k, v in pairs(casier.inventory) do
            if v.type == "items" or v.type == "weapons" or v.type == "clothes" then
                table.insert(itemsVehicle,
                    { name = v.name, count = v.count, label = v.label, cols = v.cols, rows = v.rows, type = v.type,
                        metadatas = v.metadatas, weight = v.weight })
            end
        end

        Society = false
        Vehicle = false
        Police = false
        PropertyCoffre = false
        Casier = true
        items = FormulateInventory(items)
        itemsVehicle = FormulateInventory(itemsVehicle)
        Citizen.CreateThread(function()
            SendNUIMessage({
                type = "openWebview",
                name = "inventory",
                data = { items = items, clothes = {}, weapons = Weapons,
                    target = { items = itemsVehicle, maxWeight = 500, name = "Casier " .. job .. " n°" .. id } }
            })
        end)
    end
end

local lastIdpolice = nil
local lastNamePolice = nil
function OpenInventoryPolicePlayer(entity, data)
    if open then
        open = false
        SetNuiFocusKeepInput(false)
        EnableControlAction(0, 1, true)
        EnableControlAction(0, 24, true)
        EnableControlAction(0, 25, true)
        EnableControlAction(0, 2, true)
        EnableControlAction(0, 142, true)
        EnableControlAction(0, 18, true)
        EnableControlAction(0, 322, true)
        EnableControlAction(0, 106, true)
        SetNuiFocus(false, false)
        --DisplayRadar(true)
        SendNuiMessage(json.encode({
            type = 'closeWebview'
        }))
        return
    else
        open = true        
        local casier = TriggerServerCallback("core:GetInventoryPlayerPolice", token, entity)
        if casier == false then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Impossible de fouiller cette personne"
            })
            ClearPedTasks(p:ped())
            open = false
            SetNuiFocusKeepInput(false)
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 24, true)
            EnableControlAction(0, 25, true)
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 142, true)
            EnableControlAction(0, 18, true)
            EnableControlAction(0, 322, true)
            EnableControlAction(0, 106, true)
            SetNuiFocus(false, false)
            --DisplayRadar(true)
            SendNuiMessage(json.encode({
                type = 'closeWebview'
            }))
            return
        end

        ExecuteCommand("me fouille la personne")
        RequestAnimDict('custom@police')
        while not HasAnimDictLoaded('custom@police') do
            Wait(0)
        end
        p:PlayAnim('random@train_tracks', 'idle_e', 1)

        lastIdpolice = entity
        lastNamePolice = data
        local inv = p:getInventaire()
        items = {}
        clothes = {}
        weapons = {}
        itemsVehicle = {}
        for k, v in pairs(inv) do
            if v.type == "items" or v.type == "weapons" or v.type == "clothes" then
                table.insert(items,
                    { name = v.name, count = v.count, label = v.label, cols = v.cols, rows = v.rows, type = v.type,
                        metadatas = v.metadatas, weight = v.weight })
            end
        end
        for k, v in pairs(casier) do
            if v.type == "items" or v.type == "weapons" or v.type == "clothes" then
                table.insert(itemsVehicle,
                    { name = v.name, count = v.count, label = v.label, cols = v.cols, rows = v.rows, type = v.type,
                        metadatas = v.metadatas, weight = v.weight })
            end
        end

        local name = "Fouille"

        if data and data.nom then name = data.nom end

        Society = false
        Vehicle = false
        Casier = false
        PropertyCoffre = false
        Police = true
        items = FormulateInventory()
        itemsVehicle = FormulateInventory(itemsVehicle)
        Citizen.CreateThread(function()
            SendNUIMessage({
                type = "openWebview",
                name = "inventory",
                data = { items = items, clothes = {}, weapons = Weapons,
                    target = { items = itemsVehicle, maxWeight = 25.0, name = name} }
            })
        end)

        Modules.UI.RealWait(8000)
        ClearPedTasks(p:ped())
    end

end

local AntiSpam = false

local Count = 0

local LastItemCount = nil

local LastItemName = nil

local LastTime = nil

RegisterNUICallback('inventory-put-item', function(data, cb)
    --print("---")
    --print("put-item", data.item, data.quantity)
    --print("---")
    if Police then
        if p:getJob() ~= "lspd" and p:getJob() ~= "lssd" and p:getJob() ~= "usss" and p:getJob() ~= "gcp" and p:getJob() ~= "boi" and p:getJob() ~= "bp" and p:getJob() ~= "gouv" and p:getJob() ~= "gouv2" then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous ne pouvez pas prendre / poser des items en fouillant"
            })
            return
        end
    end
    if data and data.premium then 
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Impossible de poser un item premium"
        })
        return
    end
    if data.item.metadatas.premium then 
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Impossible de poser un item premium"
        })
        return
    end
    -- for anticheat
    if string.find(data.item.name, "weapon") then 
        if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey(data.item.name) then 
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), 1)
            RemoveWeaponFromPed(PlayerPedId(), GetHashKey(data.item.name))
        end
    end

    local _data = TriggerServerCallback("core:GetPlayerPing")

    PlayerPing = _data.PlayerPing
    OsTime = _data.OsTime
    if data.quantity > 0 then

        if (LastItemCount ~= nil and LastTime ~= nil and LastItemName ~= nil and LastItemCount == data.quantity and LastItemName == data.item.name and LastTime == OsTime or LastItemCount ~= nil and LastTime ~= nil and LastItemName ~= nil and LastItemCount == data.quantity and LastItemName == data.item.name and LastTime == OsTime-1) or (LastItemCount ~= nil and LastTime ~= nil and LastItemName ~= nil and LastItemCount == data.quantity and LastItemName == data.item.name and LastTime == OsTime+1) then
            
            if PropertyCoffre then
                TriggerServerEvent("core:DupplicationDetect", "Put2", data.item.name, data.quantity, Count, "property", _property.id, PlayerPing, LastTime, OsTime)
            elseif Casier then
                TriggerServerEvent("core:DupplicationDetect", "Put2", data.item.name, data.quantity, Count, "casier", numberCasier, PlayerPing, LastTime, OsTime)
            elseif Vehicle then
                local closestVeh, closestDist = GetClosestVehicle(p:pos())
                local plate = vehicle.getProps(closestVeh).plate

                TriggerServerEvent("core:DupplicationDetect", "Put2", data.item.name, data.quantity, Count, "vehicle", plate, PlayerPing, LastTime, OsTime)
            elseif Society then
                TriggerServerEvent("core:DupplicationDetect", "Put2", data.item.name, data.quantity, Count, "society", pJob, PlayerPing, LastTime, OsTime)
            else
                TriggerServerEvent("core:DupplicationDetect", "Put2", data.item.name, data.quantity, Count, "autre", "_Quelque part_", PlayerPing, LastTime, OsTime)
            end

            return

        end

        if LastItemName ~= data.item.name then
            Count = 0
        end

        LastItemName = data.item.name

        LastTime = OsTime

        LastItemCount = data.quantity

        Count = Count + 1

        if TriggerServerCallback("core:isLegit") then
            --print("Legit")
            for k, v in pairs(TriggerServerCallback("core:GetInventory", token)) do

                if v.name == data.item.name then
                    if v.count >= data.quantity then
                        if Count > 1 then                     
                            if PropertyCoffre then
                                TriggerServerEvent("core:DupplicationDetect", "PutAntiSpam", data.item.name, data.quantity, Count, "property", _property.id, PlayerPing, LastTime, OsTime)
                            elseif Casier then
                                TriggerServerEvent("core:DupplicationDetect", "PutAntiSpam", data.item.name, data.quantity, Count, "casier", numberCasier, PlayerPing, LastTime, OsTime)
                            elseif Vehicle then
                                local closestVeh, closestDist = GetClosestVehicle(p:pos())
                                local plate = vehicle.getProps(closestVeh).plate
                
                                TriggerServerEvent("core:DupplicationDetect", "PutAntiSpam", data.item.name, data.quantity, Count, "vehicle", plate, PlayerPing, LastTime, OsTime)
                            elseif Society then
                                TriggerServerEvent("core:DupplicationDetect", "PutAntiSpam", data.item.name, data.quantity, Count, "society", pJob, PlayerPing, LastTime, OsTime)
                            else
                                TriggerServerEvent("core:DupplicationDetect", "PutAntiSpam", data.item.name, data.quantity, Count, "autre", "_Quelque part_", PlayerPing, LastTime, OsTime)
                            end

                            Count = 0
                            
                            return
                        end

                        if Society then
                            if data.item ~= nil then

                                local approuved = TriggerServerCallback("core:addItemToInventorySociety", token, pJob,
                                    data.item.name, data.quantity, data.item.metadatas)
                                if approuved then
                                    for i = 1, 4 do
                                        if Weapons[i] ~= nil then
                                            if data.item.name == Weapons[i].name and
                                                json.encode(data.item.metadatas) == json.encode(Weapons[i].metadatas) then
                                                if HasPedGotWeapon(p:ped(), GetHashKey(data.item.name), false) then
                                                    data.item.metadatas.ammo = GetAmmoInPedWeapon(p:ped(),
                                                        GetHashKey(data.item.name))
                                                end
                                                weaponOut = false
                                                RemoveAllPedWeapons(p:ped(), 1)
                                                Weapons[i] = nil
                                            end
                                        end
                                    end
                                    TriggerServerEvent("core:SetWeaponSave", token, Weapons)
                                    TriggerServerEvent("core:RemoveItemToInventory", token, data.item.name, data.quantity,
                                        data.item.metadatas)

                                    Wait(250)

                                    Count = 0
                                end
                                local inv = TriggerServerCallback("core:GetSocietyInventoryItem", pJob)
                                local pInv = TriggerServerCallback("core:GetInventory", token)
                                itemsSociety = {}

                                for k, v in pairs(inv) do
                                    table.insert(itemsSociety,
                                        { name = v.name, count = v.count, label = v.label, cols = v.cols, rows = v.rows,
                                            type = v.type,
                                            metadatas = v.metadatas, weight = v.weight })

                                end
                                -- TriggerServerEvent("core:UpdateInventoryforall", token, itemsSociety, nil, nil, nil)

                                pInv = FormulateInventory(pInv)
                                itemsSociety = FormulateInventory(itemsSociety)
                                SendNUIMessage({
                                    type = "updateInventory",
                                    data = { items = pInv, clothes = {}, weapons = weapons,
                                        target = { items = itemsSociety, maxWeight = 1000, name = "Coffre " .. pJob } }
                                })
                                return
                            end
                        end
                        if Vehicle then
                            if data.item ~= nil then
                                local invVehicle

                                local closestVeh, closestDist = GetClosestVehicle(p:pos())
                                local model = GetEntityModel(closestVeh)

                                if #(p:pos() - GetWorldPositionOfEntityBone(closestVeh,
                                    GetEntityBoneIndexByName(closestVeh, "platelight"))) then
                                    local plate = vehicle.getProps(closestVeh).plate
                                    local removeItem = TriggerServerCallback("core:AddItemToVehicle", token, data.item.name,
                                        data.quantity, tostring(plate), data.item.metadatas, model)
                                    if removeItem then
                                        for i = 1, 4 do
                                            if Weapons[i] ~= nil then
                                                if data.item.name == Weapons[i].name and
                                                    json.encode(data.item.metadatas) == json.encode(Weapons[i].metadatas) then
                                                    if HasPedGotWeapon(p:ped(), GetHashKey(data.item.name), false) then
                                                        data.item.metadatas.ammo = GetAmmoInPedWeapon(p:ped(),
                                                            GetHashKey(data.item.name))
                                                    end
                                                    weaponOut = false
                                                    RemoveAllPedWeapons(p:ped(), 1)
                                                    Weapons[i] = nil
                                                end
                                            end
                                        end
                                        TriggerServerEvent("core:SetWeaponSave", token, Weapons)
                                        TriggerServerEvent("core:RemoveItemToInventory", token, data.item.name, data.quantity, data.item.metadatas)
                                    
                                        Wait(250)

                                        Count = 0
                                    end
                                    invVehicle = TriggerServerCallback("core:GetVehicleInventory", plate, nil, nil, nil)
                                    TriggerServerEvent("core:depotCoffreVeh", data.item.name, data.quantity)



                                    local pInv = TriggerServerCallback("core:GetInventory", token)

                                    itemsVehicle = {}

                                    for k, v in pairs(invVehicle) do
                                        table.insert(itemsVehicle,
                                            { name = v.name, count = v.count, label = v.label, cols = v.cols, rows = v.rows,
                                                type = v.type,
                                                metadatas = v.metadatas, weight = v.weight })

                                    end

                                    
                                    pInv = FormulateInventory()
                                    itemsVehicle = FormulateInventory(itemsVehicle)
                                    if coffre[model] ~= nil then
                                        SendNUIMessage({
                                            type = "updateInventory",
                                            data = { items = pInv, clothes = {}, weapons = weapons,
                                                target = { items = itemsVehicle, maxWeight = coffre[model] / 1000,
                                                    name = "Coffre " ..
                                                        GetLabelText(GetDisplayNameFromVehicleModel(model)) } }
                                        })
                                    else
                                        SendNUIMessage({
                                            type = "updateInventory",
                                            data = { items = pInv, clothes = {}, weapons = weapons,
                                                target = { items = itemsVehicle, maxWeight = 100,
                                                    name = "Coffre " ..
                                                        GetLabelText(GetDisplayNameFromVehicleModel(model)) } }
                                        })
                                    end
                                end
                                return
                            end
                        end
                        if Casier then
                            if data.item ~= nil then
                                if not IsJobPolice(casierJob) then 
                                    if string.find(data.item.name, "weapon_") then 
                                        exports['vNotif']:createNotification({
                                            type = 'ROUGE',
                                            -- duration = 5, -- In seconds, default:  4
                                            content = "Vous ne pouvez pas déposer d'armes."
                                        })
                                        return 
                                    end
                                end
                                local casier = TriggerServerCallback("core:casier:addItem", token, casierJob,
                                    numberCasier, data.item.name, data.quantity, data.item.metadatas)
                                if casier then
                                    for i = 1, 4 do
                                        if Weapons[i] ~= nil then
                                            if data.item.name == Weapons[i].name and
                                                json.encode(data.item.metadatas) == json.encode(Weapons[i].metadatas) then
                                                if HasPedGotWeapon(p:ped(), GetHashKey(data.item.name), false) then
                                                    data.item.metadatas.ammo = GetAmmoInPedWeapon(p:ped(),
                                                        GetHashKey(data.item.name))
                                                end
                                                weaponOut = false
                                                RemoveAllPedWeapons(p:ped(), 1)
                                                Weapons[i] = nil
                                            end
                                        end
                                    end
                                    TriggerServerEvent("core:SetWeaponSave", token, Weapons)
                                    TriggerServerEvent("core:RemoveItemToInventory", token, data.item.name, data.quantity,
                                        data.item.metadatas)

                                    Wait(250)
                                    Count = 0
                                end
                                local inv = TriggerServerCallback("core:casier:getOneCasier", token, casierJob, numberCasier)
                                Wait(100)
                                local pInv = TriggerServerCallback("core:GetInventory", token)
                                itemsSociety = {}
                                for k, v in pairs(inv.inventory) do
                                    table.insert(itemsSociety,
                                        { name = v.name, count = v.count, label = v.label, cols = v.cols, rows = v.rows,
                                            type = v.type,
                                            metadatas = v.metadatas, weight = v.weight })

                                end
                                -- TriggerServerEvent("core:UpdateInventoryforall", token, nil, nil, nil, itemsSociety)

                                pInv = FormulateInventory(pInv)
                                itemsSociety = FormulateInventory(itemsSociety)
                                SendNUIMessage({
                                    type = "updateInventory",
                                    data = { items = pInv, clothes = {}, weapons = weapons,
                                        target = { items = itemsSociety, maxWeight = 500,
                                            name = "Casier " .. casierJob .. " n°" .. numberCasier } }
                                })
                                return
                            end

                        end
                        if PropertyCoffre then
                            if data.item ~= nil then
                                local approuved = TriggerServerCallback("core:addItemToInvProperty", token, _property.id, data.item, data.quantity)
                                if approuved then
                                    for i = 1, 4 do
                                        if Weapons[i] ~= nil then
                                            if data.item.name == Weapons[i].name and
                                                json.encode(data.item.metadatas) == json.encode(Weapons[i].metadatas) then
                                                if HasPedGotWeapon(p:ped(), GetHashKey(data.item.name), false) then
                                                    data.item.metadatas.ammo = GetAmmoInPedWeapon(p:ped(),
                                                        GetHashKey(data.item.name))
                                                end
                                                weaponOut = false
                                                RemoveAllPedWeapons(p:ped(), 1)
                                                Weapons[i] = nil
                                            end
                                        end
                                    end
                                    TriggerServerEvent("core:depotCoffreProp", data.item.name, data.quantity, _property.id)
                                    TriggerServerEvent("core:SetWeaponSave", token, Weapons)
                                    TriggerServerEvent("core:RemoveItemToInventory", token, data.item.name, data.quantity, data.item.metadatas)
                                    local propertyName = GetPropertyName(_property.id)
                                    
                                    SendNUIMessage({
                                        type = "updateInventory",
                                        data = {
                                            items = p:getInventaire(),
                                            clothes = {},
                                            weapons = {},
                                            target = {
                                                items = TriggerServerCallback("core:property:getPropertyInventory", token, _property.id),
                                                maxWeight = tonumber(_property.weight),
                                                name = "Propriété " .. (_property.name or propertyName or "")
                                            }
                                        }
                                    })
                                    
                                    Wait(100)

                                    Count = 0
                                    
                                    return
                                end
                            end
                        end
                        if MailBox then
                            if data.item ~= nil then
                                local approuved = TriggerServerCallback("core:property:addItemToBoxMail", token, _property.id, data.item, data.quantity)
                                if approuved then
                                    for i = 1, 4 do
                                        if Weapons[i] ~= nil then
                                            if data.item.name == Weapons[i].name and
                                                json.encode(data.item.metadatas) == json.encode(Weapons[i].metadatas) then
                                                if HasPedGotWeapon(p:ped(), GetHashKey(data.item.name), false) then
                                                    data.item.metadatas.ammo = GetAmmoInPedWeapon(p:ped(),
                                                        GetHashKey(data.item.name))
                                                end
                                                weaponOut = false
                                                RemoveAllPedWeapons(p:ped(), 1)
                                                Weapons[i] = nil
                                            end
                                        end
                                    end
                                    TriggerServerEvent("core:SetWeaponSave", token, Weapons)
                                    TriggerServerEvent("core:RemoveItemToInventory", token, data.item.name, data.quantity, data.item.metadatas)

                                    Wait(100)

                                    Count = 0
                                end
                                SendNUIMessage({
                                    type = "updateInventory",
                                    data = {
                                        items = p:getInventaire(),
                                        clothes = {},
                                        weapons = weapons,
                                        target = {
                                            items = TriggerServerCallback("core:property:getMailBox", token, _property.id),
                                            maxWeight = 3.0,
                                            name =  "Boite aux lettres de : " .. propertyName.name
                                        }
                                    }
                                })
                                return
                            end
                        end
                    end
                end
            end
        else 

            if PropertyCoffre then
                TriggerServerEvent("core:DupplicationDetect", "Put", data.item.name, data.quantity, Count, "property", _property.id, PlayerPing, LastTime, OsTime)
            elseif Casier then
                TriggerServerEvent("core:DupplicationDetect", "Put", data.item.name, data.quantity, Count, "casier", numberCasier, PlayerPing, LastTime, OsTime)
            elseif Vehicle then
                local closestVeh, closestDist = GetClosestVehicle(p:pos())
                local plate = vehicle.getProps(closestVeh).plate

                TriggerServerEvent("core:DupplicationDetect", "Put", data.item.name, data.quantity, Count, "vehicle", plate, PlayerPing, LastTime, OsTime)
            elseif Society then
                TriggerServerEvent("core:DupplicationDetect", "Put", data.item.name, data.quantity, Count, "society", pJob, PlayerPing, LastTime, OsTime)
            else
                TriggerServerEvent("core:DupplicationDetect", "Put", data.item.name, data.quantity, Count, "autre", "_Quelque part_", PlayerPing, LastTime, OsTime)
            end

        end
    end
end)

 -- A optimiser
RegisterNUICallback('inventory-take-item', function(data, cb)
    if Police then
        if p:getJob() ~= "lspd" and p:getJob() ~= "lssd" and p:getJob() ~= "usss" and p:getJob() ~= "gcp" and p:getJob() ~= "boi" and p:getJob() ~= "bp" and p:getJob() ~= "gouv" and p:getJob() ~= "gouv2" then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous ne pouvez pas prendre / poser des items en fouillant"
            })
            return
        end
    end

    local _data = TriggerServerCallback("core:GetPlayerPing")
    PlayerPing = _data.PlayerPing
    OsTime = _data.OsTime
    if data.quantity > 0 then

        if LastItemCount ~= nil and LastTime ~= nil and LastItemName ~= nil and LastItemCount == data.quantity and LastItemName == data.item.name and LastTime == OsTime or LastItemCount ~= nil and LastTime ~= nil and LastItemName ~= nil and LastItemCount == data.quantity and LastItemName == data.item.name and LastTime == OsTime-1 or LastItemCount ~= nil and LastTime ~= nil and LastItemName ~= nil and LastItemCount == data.quantity and LastItemName == data.item.name and LastTime == OsTime+1 then
            
            
            if PropertyCoffre then
                TriggerServerEvent("core:DupplicationDetect", "Take2", data.item.name, data.quantity, Count, "property", _property.id, PlayerPing, LastTime, OsTime)
            elseif Casier then
                TriggerServerEvent("core:DupplicationDetect", "Take2", data.item.name, data.quantity, Count, "casier", numberCasier, PlayerPing, LastTime, OsTime)
            elseif Vehicle then
                local closestVeh, closestDist = GetClosestVehicle(p:pos())
                local plate = vehicle.getProps(closestVeh).plate

                TriggerServerEvent("core:DupplicationDetect", "Take2", data.item.name, data.quantity, Count, "vehicle", plate, PlayerPing, LastTime, OsTime)
            elseif Society then
                TriggerServerEvent("core:DupplicationDetect", "Take2", data.item.name, data.quantity, Count, "society", pJob, PlayerPing, LastTime, OsTime)
            else
                TriggerServerEvent("core:DupplicationDetect", "Take2", data.item.name, data.quantity, Count, "autre", "_Quelque part_", PlayerPing, LastTime, OsTime)
            end

            return

        end

        if LastItemName ~= data.item.name then
            Count = 0
        end

        LastItemName = data.item.name

        LastTime = OsTime

        LastItemCount = data.quantity

        -- print(LastItemCount .. " Now : ".. data.quantity .. " Now By LastTime : " .. LastTime .. " Now -1 : " .. OsTime-1 .. " Now : " .. OsTime)

        Count = Count + 1

        if TriggerServerCallback("core:isLegit") then

            if Count > 1 then 
                        
                if PropertyCoffre then
                    TriggerServerEvent("core:DupplicationDetect", "TakeAntiSpam", data.item.name, data.quantity, Count, "property", _property.id, PlayerPing, LastTime, OsTime)
                elseif Casier then
                    TriggerServerEvent("core:DupplicationDetect", "TakeAntiSpam", data.item.name, data.quantity, Count, "casier", numberCasier, PlayerPing, LastTime, OsTime)
                elseif Vehicle then
                    local closestVeh, closestDist = GetClosestVehicle(p:pos())
                    local plate = vehicle.getProps(closestVeh).plate
    
                    TriggerServerEvent("core:DupplicationDetect", "TakeAntiSpam", data.item.name, data.quantity, Count, "vehicle", plate, PlayerPing, LastTime, OsTime)
                elseif Society then
                    TriggerServerEvent("core:DupplicationDetect", "TakeAntiSpam", data.item.name, data.quantity, Count, "society", pJob, PlayerPing, LastTime, OsTime)
                else
                    TriggerServerEvent("core:DupplicationDetect", "TakeAntiSpam", data.item.name, data.quantity, Count, "autre", "_Quelque part_", PlayerPing, LastTime, OsTime)
                end

                Count = 0
                
                return
            end

            if Police then
                if data.item ~= nil then
                    local inv = TriggerServerCallback("core:GetInventoryPlayerPolice", token, lastIdpolice)
                    if inv == false then
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            content = "Impossible de fouiller cette personne"
                        })
                        return
                    end
                    local pInv = TriggerServerCallback("core:GetInventory", token)
                    for k, v in pairs(inv) do
                        if v.name == data.item.name and data.quantity <= v.count then
                            local poulice = TriggerServerCallback("core:RemoveItemToInventoryPolice", token, lastIdpolice,
                                data.item.name, data.quantity, data.item.metadatas)
                            if poulice then
                                TriggerServerEvent("core:logLSPDSearch", data.item.name, data.quantity)
                                TriggerSecurGiveEvent("core:addItemToInventory", token, data.item.name, data.quantity,
                                    data.item.metadatas)
                                goto finshPolice
                            end

                        end
                    end
                    ::finshPolice::
                    inv = TriggerServerCallback("core:GetInventoryPlayerPolice", token, lastIdpolice)
                    if inv == false then
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            content = "Impossible de fouiller cette personne"
                        })
                        return
                    end
                    pInv = TriggerServerCallback("core:GetInventory", token)
                    ExecuteCommand("me vous confisque quelque chose")

                    itemsSociety = {}
                    for k, v in pairs(inv) do
                        table.insert(itemsSociety,
                            { name = v.name, count = v.count, label = v.label, cols = v.cols, rows = v.rows, type = v.type,
                                metadatas = v.metadatas, weight = v.weight })

                    end

                    pInv = FormulateInventory(pInv)
                    itemsSociety = FormulateInventory(itemsSociety)
                    SendNUIMessage({
                        type = "updateInventory",
                        data = { items = pInv, clothes = {}, weapons = weapons,
                            target = { items = itemsSociety, maxWeight = 25.0,
                                name = lastNamePolice.nom} }
                    })

                    Wait(250)
                    Count = 0
                end
            end
            if Society then
                if data.item ~= nil then
                    local inv = TriggerServerCallback("core:GetSocietyInventoryItem", pJob)
                    local pInv = TriggerServerCallback("core:GetInventory", token)

                    for k, v in pairs(inv) do
                        if v.name == data.item.name and data.quantity <= v.count then
                            local societer = TriggerServerCallback("core:RemoveItemToInventorySociety", token, pJob,
                                data.item.name, data.quantity, data.item.metadatas)
                            if societer then
                                TriggerSecurGiveEvent("core:addItemToInventory", token, data.item.name, data.quantity,
                                    data.item.metadatas)
                                goto finshSociety
                            end
                        end
                    end

                    ::finshSociety::
                    inv = TriggerServerCallback("core:GetSocietyInventoryItem", pJob)
                    pInv = TriggerServerCallback("core:GetInventory", token)

                    itemsSociety = {}
                    for k, v in pairs(inv) do
                        table.insert(itemsSociety,
                            { name = v.name, count = v.count, label = v.label, cols = v.cols, rows = v.rows, type = v.type,
                                metadatas = v.metadatas, weight = v.weight })

                    end
                    
                    pInv = FormulateInventory(pInv)
                    itemsSociety = FormulateInventory(itemsSociety)
                    SendNUIMessage({
                        type = "updateInventory",
                        data = { items = pInv, clothes = {}, weapons = weapons,
                            target = { items = itemsSociety, maxWeight = 1000, name = "Coffre " .. pJob } }
                    })

                    Wait(250)
                    Count = 0
                    -- TriggerServerEvent("core:UpdateInventoryforall", token, itemsSociety, nil, nil, nil)
                end
            end
            if Vehicle then
                if data.item ~= nil then
                    local invVehicle
                    local closestVeh, closestDist = GetClosestVehicle(p:pos())
                    local model = GetEntityModel(closestVeh)

                    if #(p:pos() - GetWorldPositionOfEntityBone(closestVeh,GetEntityBoneIndexByName(closestVeh, "platelight"))) then
                        plate = vehicle.getProps(closestVeh).plate
                        invVehicle = TriggerServerCallback("core:GetVehicleInventory", plate, nil, nil, nil)
                        local pInv = TriggerServerCallback("core:GetInventory", token)
                        for k, v in pairs(invVehicle) do
                            if v.name == data.item.name and data.quantity <= v.count then
                                --TriggerServerEvent("core:RemoveItemFromVehicle", token, data.item.name, data.quantity,
                                --    Plate, data.item.metadatas)
                                TriggerSecurGiveEvent("core:addItemToInventory", token, data.item.name, data.quantity,
                                    data.item.metadatas, {plate = plate})
                                TriggerServerEvent("core:logTakeVeh", data.item.name, data.quantity)
                                goto finishVeh
                            end
                        end
                        ::finishVeh::
                        --TriggerServerEvent("core:SyncInvVeh", token, plate,
                        --    GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(closestVeh))))
                        invVehicle = TriggerServerCallback("core:GetVehicleInventory", plate, nil, nil, nil)
                        pInv = TriggerServerCallback("core:GetInventory", token)

                        itemsVehicle = {}

                        for k, v in pairs(invVehicle) do
                            table.insert(itemsVehicle,
                                { name = v.name, count = v.count, label = v.label, cols = v.cols, rows = v.rows,
                                    type = v.type,
                                    metadatas = v.metadatas, weight = v.weight })

                        end
                        -- TriggerServerEvent("core:UpdateInventoryforall", token, nil, itemsVehicle, nil, nil)
                        
                        pInv = FormulateInventory()
                        itemsVehicle = FormulateInventory(itemsVehicle)
                        if coffre[model] ~= nil then
                            SendNUIMessage({
                                type = "updateInventory",
                                data = { items = pInv, clothes = {}, weapons = weapons,
                                    target = { items = itemsVehicle, maxWeight = coffre[model] / 1000,
                                        name = "Coffre " ..
                                            GetLabelText(GetDisplayNameFromVehicleModel(model)) } }
                            })

                            Wait(250)
                            Count = 0
                        else
                            SendNUIMessage({
                                type = "updateInventory",
                                data = { items = pInv, clothes = {}, weapons = weapons,
                                    target = { items = itemsVehicle, maxWeight = 100,
                                        name = "Coffre " ..
                                            GetLabelText(GetDisplayNameFromVehicleModel(model)) } }
                            })

                            Wait(250)
                            Count = 0
                        end
                    end
                end
            end
            if Casier then
                if data.item ~= nil then
                    local inv = TriggerServerCallback("core:casier:getOneCasier", token, casierJob, numberCasier)
                    Wait(100)
                    local pInv = TriggerServerCallback("core:GetInventory", token)

                    for k, v in pairs(inv.inventory) do
                        if v.name == data.item.name and data.quantity <= v.count then
                            TriggerSecurGiveEvent("core:addItemToInventory", token, data.item.name, data.quantity,
                                data.item.metadatas, {casierJob = casierJob, numberCasier = numberCasier})
                            goto finshCasier
                        end
                    end
                    ::finshCasier::
                    inv = TriggerServerCallback("core:casier:getOneCasier", token, casierJob, numberCasier)
                    Wait(100)
                    pInv = TriggerServerCallback("core:GetInventory", token)

                    itemsSociety = {}
                    for k, v in pairs(inv.inventory) do
                        table.insert(itemsSociety,
                            { name = v.name, count = v.count, label = v.label, cols = v.cols, rows = v.rows, type = v.type,
                                metadatas = v.metadatas, weight = v.weight })

                    end
                    -- TriggerServerEvent("core:UpdateInventoryforall", token, nil, nil, nil, itemsSociety)

                    pInv = FormulateInventory(pInv)
                    itemsSociety = FormulateInventory(itemsSociety)
                    SendNUIMessage({
                        type = "updateInventory",
                        data = { items = pInv, clothes = {}, weapons = weapons,
                            target = { items = itemsSociety, maxWeight = 500,
                                name = "Casier " .. casierJob .. " n°" .. numberCasier } }
                    })

                    Wait(250)
                    Count = 0
                end
                -- core:removeItemToInventoryCasier
            end
            if PropertyCoffre then
                if data.item ~= nil then
                    if TriggerServerCallback("core:hasEnoughSpaceInInv", token, data.item.name, data.quantity) then
                        --if TriggerServerCallback("core:removeItemToInventoryProperty", token, _property.id, data.item, data.quantity) then
                            TriggerServerEvent("core:logTakeProperty", data.item.name, data.quantity, _property.id)
                            TriggerSecurGiveEvent("core:addItemToInventory", token, data.item.name, data.quantity, data.item.metadatas, {property = _property.id})
                            
                            Wait(250)
                            Count = 0
                        --end
                    else
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            -- duration = 5, -- In seconds, default:  4
                            content = "~s Vous n'avez pas suffisament de place dans votre inventaire"
                        })
                    end
                end
            end
        else 
            --[[ print("Chef tu tente de duppliquer la ?")  ]]


            if PropertyCoffre then
                TriggerServerEvent("core:DupplicationDetect", "Take", data.item.name, data.quantity, "property", _property.id, PlayerPing, LastTime, OsTime)
            elseif Casier then
                TriggerServerEvent("core:DupplicationDetect", "Take", data.item.name, data.quantity, "casier", numberCasier, PlayerPing, LastTime, OsTime)
            elseif Vehicle then
                local closestVeh, closestDist = GetClosestVehicle(p:pos())
                local plate = vehicle.getProps(closestVeh).plate

                TriggerServerEvent("core:DupplicationDetect", "Take", data.item.name, data.quantity, "vehicle", plate, PlayerPing, LastTime, OsTime)
            elseif Society then
                TriggerServerEvent("core:DupplicationDetect", "Take", data.item.name, data.quantity, "society", pJob, PlayerPing, LastTime, OsTime)
            else
                TriggerServerEvent("core:DupplicationDetect", "Take", data.item.name, data.quantity, "autre", "_Quelque part_", PlayerPing, LastTime, OsTime)
            end
         end
    end
end)

local try = false
local openTrunk = false
Keys.Register("K", "K", "Coffre de véhicule", function()


    local closestVeh, closestDist = GetClosestVehicle(p:pos())
    if closestDist <= 15 then
        if not in_garage then

        local bone = "platelight"
        if GetWorldPositionOfEntityBone(closestVeh, GetEntityBoneIndexByName(closestVeh, bone)) == vector3(0, 0, 0) then
            if tostring(closestVeh) == "826114" or tostring(closestVeh) == "1377794" then -- stockade
                bone = "door_pside_r"
            elseif GetVehicleClass(closestVeh) == 8 then
                bone = "swingarm"
            elseif GetVehicleClass(closestVeh) == 20 then
                bone = "reversinglight_r"
            elseif GetVehicleClass(closestVeh) == 14 then --boat
                bone = "engine"
            elseif GetVehicleClass(closestVeh) == 16 then -- plane
                bone = "airbrake_l"
            elseif GetVehicleClass(closestVeh) == 15 then -- plane
                bone = "engine"
            else
                bone = "boot"
            end
        end
        if (GetVehicleClass(closestVeh) == 15 and #(p:pos() - GetWorldPositionOfEntityBone(closestVeh, GetEntityBoneIndexByName(closestVeh, bone))) <= 3.5) or (#(p:pos() - GetWorldPositionOfEntityBone(closestVeh, GetEntityBoneIndexByName(closestVeh, bone))) <= 2.0) then
            plate = vehicle.getProps(closestVeh).plate
            local vehJob = TriggerServerCallback("core:GetCarJob", plate) 
            if not vehJob or vehJob == p:getJob() or exports["core"]:getPermission() >= 5 then 
                if GetVehicleDoorLockStatus(closestVeh) == 0 then
                    --isUsing = TriggerServerCallback("core:getUsingStatusCoffre", Plate)
                    --if not isUsing then
                        vehWeight = GetEntityModel(closestVeh)
                        TriggerServerEvent("core:setLockCoffreCar", token, plate, true)
                        OpenInventoryVehicle(plate, GetEntityModel(closestVeh), closestVeh)
                        if open then
                            open = false
                            SetNuiFocusKeepInput(false)
                            EnableControlAction(0, 1, true)
                            EnableControlAction(0, 24, true)
                            EnableControlAction(0, 25, true)
                            EnableControlAction(0, 2, true)
                            EnableControlAction(0, 142, true)
                            EnableControlAction(0, 18, true)
                            EnableControlAction(0, 322, true)
                            EnableControlAction(0, 106, true)
                            SetNuiFocus(false, false)
                            --DisplayRadar(true)
                            SendNuiMessage(json.encode({
                                type = 'closeWebview'
                            }))
                            return
                        else
                            open = true
                            openTrunk = true
                        end
                    --else
                    --    --ShowNotification("Quelqu'un est déjà en train de fouiller dans le coffre")
                    --    exports['vNotif']:createNotification({
                    --        type = 'ROUGE',
                    --        -- duration = 5, -- In seconds, default:  4
                    --        content = "Quelqu'un regarde déjà le coffre"
                    --    })
                    --    open = false
                    --    return
                    --end
                else
                    -- ShowNotification("Le véhicule est verrouillé")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'JAUNE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Le véhicule est ~s verrouillé"
                    })
                end
            else
                -- ShowNotification("Ce véhicule ne vous appartient pas")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Ce véhicule ne vous appartient pas"
                })
            end
        else
            if not try then
                try = true
                -- ShowNotification("~r~Vous n'êtes pas au niveau du coffre")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Vous n'êtes pas au niveau du coffre"
                    })

                    Citizen.CreateThread(function()
                        while try do
                            DrawLine(p:pos(), GetWorldPositionOfEntityBone(closestVeh,
                                GetEntityBoneIndexByName(closestVeh, bone)), 255, 255, 255, 170);

                            Wait(1)
                        end
                    end)
                    Wait(5000)
                    try = false
                end
            end
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Vous ne pouvez pas ouvrir de coffre dans un garage"
            })
        end

    end


end)

RegisterNUICallback("focusOut", function()
    if open then
        open = false
        SetNuiFocusKeepInput(false)
        EnableControlAction(0, 1, true)
        EnableControlAction(0, 24, true)
        EnableControlAction(0, 25, true)
        EnableControlAction(0, 2, true)
        EnableControlAction(0, 142, true)
        EnableControlAction(0, 18, true)
        EnableControlAction(0, 322, true)
        EnableControlAction(0, 106, true)
        SetNuiFocus(false, false)
        --DisplayRadar(true)
        Police = true
        Vehicle = false
        Casier = false
        if Plate then
            TriggerServerEvent("core:joinedcoffre", Plate, false)
        end

        if Society then
            TriggerServerCallback("core:getUsingStatusSocietyCoffre", pJob, false)
        end
        
        if PropertyCoffre then
            TriggerServerEvent("core:leaveCoffre", _property.id)
            TriggerServerEvent("core:property:setUsingCoffre", token, _property.id, false)
            PropertyCoffre = false
        end
        if openTrunk == true then
            local closestVeh, closestDist = GetClosestVehicle(p:pos())
            plate = vehicle.getProps(closestVeh).plate
            TriggerServerEvent("core:setLockCoffreCar", token, plate, false)
            if closestDist <= 15 then
                local bone = "platelight"
                if GetWorldPositionOfEntityBone(closestVeh, GetEntityBoneIndexByName(closestVeh, bone)) == vector3(0, 0, 0) then
                    if GetVehicleClass(closestVeh) == 8 then
                        bone = "swingarm"
                    elseif GetVehicleClass(closestVeh) == 20 then
                        bone = "reversinglight_r"
                    else
                        bone = "boot"
                    end
                end
            end
        end
        openTrunk = false
    end
end)

RegisterNetEvent("core:SyncInvVeh")
AddEventHandler("core:SyncInvVeh", function(plate, model, veh)

    if Vehicle then
        if Plate == plate then
            OpenInventoryVehicle(plate, model, veh)
        end
    end
end)
