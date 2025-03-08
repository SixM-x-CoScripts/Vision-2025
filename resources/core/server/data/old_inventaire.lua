
-- -- Utils

-- local function DoesItemExist(item)
--     if items[item] ~= nil then
--         return true
--     else
--         return false
--     end
-- end

-- local function DoesItemExistInInventory(inventory, item)
--     if inventory[item] ~= nil then
--         return true
--     else
--         return false
--     end
-- end

-- function GetLabelForItem(item)
--     return items[item].label
-- end


-- local function CreateItem(name, count)
--     return {name = name, count = count, label = GetLabelForItem(name)}
-- end

-- local function GetItemLimit(item)
--     if items[item].limite ~= -1 then
--         return items[item].limite
--     else
--         return 9999999999999999999999999
--     end
-- end


-- -- Live refresh logic
-- local inventorySource = {}
-- function AddPlayerToInventoryRefresh(invName, source)
--     if inventorySource[invName] == nil then
--         inventorySource[invName] = {}
--     end
--     inventorySource[invName][source] = true
-- end

-- function RemovePlayerFromInventoryRefresh(invName, source)
--     if inventorySource[invName] == nil then
--         return
--     end
--     inventorySource[invName][source] = nil
-- end

-- function GetPlayerFromInventoryRefresh(invName)
--     if inventorySource[invName] == nil then
--         return {}
--     else
--         return inventorySource[invName]
--     end 
-- end

-- -- Remove player from live refresh if disconnected (ping == 0 means player is disconnected)
-- Citizen.CreateThread(function()
--     while true do
--         for k,v in pairs(inventorySource) do
--             for source,_ in pairs(v) do
--                 if GetPlayerPing(source) == 0 then
--                     inventorySource[k][source] = nil
--                 end
--             end
--         end
--         Wait(5000)
--     end
-- end)



-- -- Inventory logic

-- function CanInventoryTakeItem(inventory, item, count)
--     if DoesItemExistInInventory(inventory, item) then
--         if inventory[item].count + count <= GetItemLimit(item) then
--             return true
--         else
--             return false
--         end
--     else
--         if count <= GetItemLimit(item) then
--             return true
--         else
--             return false
--         end
--     end
-- end

-- function AddItemToInventory(inventory, item, count, ignoreLimit)
--     if ignoreLimit == nil then ignoreLimit = false end
--     if DoesItemExistInInventory(inventory, item) then
--         if not ignoreLimit then
--             if inventory[item].count + count <= GetItemLimit(item) then
--                 inventory[item].count = inventory[item].count + count
--                 return true
--             else
--                 return false
--             end
--         else
--             inventory[item].count = inventory[item].count + count
--             return true
--         end
--     else
--         if not ignoreLimit then
--             if count <= GetItemLimit(item) then
--                 inventory[item] = CreateItem(item, count)
--                 return true
--             else
--                 return false
--             end
--         else
--             inventory[item] = CreateItem(item, count)
--             return true
--         end
--     end
-- end


-- function RemoveItemFromInventory(inventory, item, count, countSee)
--     if DoesItemExistInInventory(inventory, item) then
--         if countSee == inventory[item].count then
--             if inventory[item].count - count >= 0 then
--                 inventory[item].count = inventory[item].count - count

--                 if inventory[item].count == 0 then
--                     inventory[item] = nil
--                 end
--                 return true
--             else
--                 return false
--             end
--         else
--             return false
--         end
--     else
--         return false
--     end
-- end


-- function AddWeaponToInventory(inventory, name, count, gxt)
--     table.insert(inventory, {name = name, count = count, ammo = count, nameGXT = gxt})
-- end

-- function RemoveWeaponFromInventory(inventory, index, name)
--     if inventory[index] ~= nil then
--         if inventory[index].name == name then
--             table.remove(inventory, index)
--         end
--     end
-- end

-- -- c'est ruby qui a fait