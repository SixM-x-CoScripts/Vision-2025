function DoesItemexist(item)
    if items[item] ~= nil then
        return true
    else
        return false
    end
end

local function ItemExistInInventory(source, item)
    if GetPlayer(source):getInventaire()[item] ~= nil then
        return true
    else
        return false
    end
end

function getItemWeight(item)
    return items[item] and items[item].weight or 0.0
end

function getItemCols(item)
    return items[item] and items[item].cols or 1.0
end

function getItemRows(item)
    return items[item] and items[item].rows or 1.0
end

function getItemLabel(item)
    return items[item] and items[item].label or "?"
end

function getItemType(item)
    return items[item] and items[item].type or "items"
end

function getNumberOfKey(table)
    local count = 0
    for k, v in pairs(table) do
        count = count + 1
    end
    return count
end

function getWeaponInventorymetadatas(source, item, metadatas)
    for k, v in pairs(GetPlayer(source):getInventaire()) do
        if v.name == item then
            return v
        end
    end
end

function getItemInventorymetadatas(source, item, metadatas, considerCount)
    for k, v in pairs(GetPlayer(source):getInventaire()) do
        if v.name == item then
            local metadatasame = true
            if v.metadatas ~= nil and metadatas ~= nil and getNumberOfKey(v.metadatas) == getNumberOfKey(metadatas) then
                for i, j in pairs(v.metadatas) do
                    if j ~= metadatas[i] then
                        metadatasame = false
                    end
                end
            else
                metadatasame = v.metadatas == nil and metadatas == nil
            end

            if metadatasame then
                if not considerCount then
                    return v
                else
                    if v.count >= considerCount then 
                        return v
                    end
                end
            end
        end
    end
end

function getClothsInventoryMetadatas(source, clothe, metadatas)
    for k, v in pairs(GetPlayer(source):getInventaire()) do
        if v.name == clothe then
            local metadatasame = true
            if v.metadatas ~= nil and metadatas ~= nil and getNumberOfKey(v.metadatas) == getNumberOfKey(metadatas) then
                if v.metadatas.renamed == metadatas.renamed then
                    for i, j in pairs(v.metadatas.data) do
                        if j ~= metadatas.data[i] then
                            metadatasame = false
                        end
                    end
                else
                    metadatasame = false
                end
            else
                metadatasame = v.metadatas == nil and metadatas == nil
            end

            if metadatasame then
                return v
            end
        end
    end
end

function getIdentityInventoryMetadatas(source, items, metadatas)
    for k, v in pairs(GetPlayer(source):getInventaire()) do

        if v.name == items then
            local metadatasame = true
            if v.metadatas ~= nil and metadatas ~= nil and getNumberOfKey(v.metadatas) == getNumberOfKey(metadatas) then
                if v.metadatas.identity.firstname == metadatas.identity.firstname and v.metadatas.identity.name == metadatas.identity.name and v.metadatas.identity.id == metadatas.identity.id then
                    for i, j in pairs(v.metadatas.identity) do
                        if j ~= metadatas.identity[i] then
                            metadatasame = false
                        end
                    end
                else
                    metadatasame = false
                end
            else
                metadatasame = v.metadatas == nil and metadatas == nil
            end

            if metadatasame then
                return v
            end
        end
    end
end

function getBikeInventoryMetadatas(source, items, metadatas)
    for k, v in pairs(GetPlayer(source):getInventaire()) do
        if v.name == items then

            local metadatasame = true
            if GetItemCount(source, "bike") > 1 then
                if v.metadatas ~= nil and metadatas ~= nil and getNumberOfKey(v.metadatas) == getNumberOfKey(metadatas) then
                    if v.metadatas.plate == metadatas.plate then
                        for i, j in pairs(v.metadatas.props) do
                            if type(j) ~= "table" then
                                if j ~= metadatas.props[i] then
                                    metadatasame = false
                                end
                            end
                        end
                    else
                        metadatasame = false
                    end
                else
                    metadatasame = v.metadatas == nil and metadatas == nil
                end
            else
                metadatasame = true
            end

            if metadatasame then
                return v
            end
        end
    end
end

function getItemInventoryMetadatasPropertyBike(propertyData, etage, item, metadatas)
    for k, v in pairs(propertyList) do
        if v.id == propertyData.id then
            for i, j in pairs(propertyList[k].etage) do
                if j.etage == etage.etage then
                    if propertyList[k].etage[i].inventory then
                        for key, value in pairs(propertyList[k].etage[i].inventory.item) do
                            if value.name == item then
                                local metadatasame = true
                                if value.metadatas ~= nil and metadatas ~= nil and
                                    getNumberOfKey(value.metadatas) == getNumberOfKey(metadatas) then
                                    for index, jouet in pairs(value.metadatas) do
                                        if type(jouet) ~= 'table' then
                                            if jouet ~= metadatas[index] then
                                                metadatasame = false
                                            end
                                        end
                                    end
                                else
                                    metadatasame = value.metadatas == nil and metadatas == nil
                                end

                                if metadatasame then
                                    return value
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function getItemInventoryMetadatasPropertyIdentityCard(propertyData, etage, item, metadatas)
    for k, v in pairs(propertyList) do
        if v.id == propertyData.id then
            for i, j in pairs(propertyList[k].etage) do
                if j.etage == etage.etage then
                    if propertyList[k].etage[i].inventory then
                        for key, value in pairs(propertyList[k].etage[i].inventory.item) do
                            if value.name == item then
                                local metadatasame = true
                                if value.metadatas.identity ~= nil and metadatas ~= nil and
                                    getNumberOfKey(value.metadatas) == getNumberOfKey(metadatas) then
                                    if value.metadatas.identity.firstname == metadatas.identity.firstname and value.metadatas.identity.name == metadatas.identity.name and value.metadatas.identity.id == metadatas.identity.id then
                                        for index, jouet in pairs(value.metadatas.identity) do
                                            if type(jouet) ~= 'table' then
                                                if jouet ~= metadatas.identity[index] then
                                                    metadatasame = false
                                                end
                                            end
                                        end
                                    end
                                else
                                    metadatasame = value.metadatas == nil and metadatas == nil
                                end

                                if metadatasame then
                                    return value
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local function AreDataTheSameForOutfit(item, data1, data2)
    if item == "outfit" then 
        if type(data1) == "table" and type(data2) == "table" then 
            if data1.torso_1 == data2.torso_1 and data1.tshirt_1 == data2.tshirt_1 and data1.pants_1 == data2.pants_1 and data1.pants_2 == data2.pants_2 then 
                return true
            end
        else
            return true
        end
    else
        return true
    end
    return false
end

function getItemInventoryMetadatasProperty(propertyData, etage, item, metadatas)
    for k, v in pairs(propertyList) do
        if v.id == propertyData.id then
            for i, j in pairs(propertyList[k].etage) do
                if j.etage == etage.etage then
                    if propertyList[k].etage[i].inventory then
                        for key, value in pairs(propertyList[k].etage[i].inventory.item) do
                            if value.name == item then
                                local metadatasame = true
                                if value.metadatas ~= nil and metadatas ~= nil and getNumberOfKey(value.metadatas) == getNumberOfKey(metadatas) then
                                    if item ~= "outfit" then
                                        for index, jouet in pairs(value.metadatas) do
                                            if jouet ~= metadatas[index] then
                                                metadatasame = false
                                            end
                                        end
                                    else
                                        for index, jouet in pairs(value.metadatas) do                                            
                                            if type(jouet) == "table" and type(metadatas[index]) == "table" then
                                                metadatasame = AreDataTheSameForOutfit(item, jouet, metadatas[index])
                                            end
                                        end
                                    end
                                else
                                    metadatasame = value.metadatas == nil and metadatas == nil
                                end

                                if metadatasame then
                                    return value
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function getItemInventorymetadatasSociety(name, item, metadatas)
    for k, v in pairs(society[name].inventory.item) do
        if v.name == item then
            local metadatasame = true
            if v.metadatas ~= nil and metadatas ~= nil and getNumberOfKey(v.metadatas) == getNumberOfKey(metadatas) then
                for i, j in pairs(v.metadatas) do
                    if j ~= metadatas[i] then
                        metadatasame = false
                    end
                end
            else
                metadatasame = v.metadatas == nil and metadatas == nil
            end

            if metadatasame then
                return v
            end
        end
    end
end

function getItemInventorymetadatasCasierIdentityCard(name, id, item, metadatas)
    for k, v in pairs(casier[name][id].inv) do
        if v.name == item then
            local metadatasame = true
            if v.metadatas ~= nil and metadatas ~= nil and getNumberOfKey(v.metadatas) == getNumberOfKey(metadatas) then
                if v.metadatas.identity.firstname == metadatas.identity.firstname and v.metadatas.identity.name == metadatas.identity.name and v.metadatas.identity.id == metadatas.identity.id then
                    for i, j in pairs(v.metadatas.identity) do
                        if type(j) ~= "table" then
                            if j ~= metadatas[i] then
                                metadatasame = false
                            end
                        end
                    end
                end
            else
                metadatasame = v.metadatas == nil and metadatas == nil
            end

            if metadatasame then
                return v
            end
        end
    end
end

function getItemInventorymetadatasVehicleIdentityCard(plate, item, metadatas) -- done
    local veh = GetVehicle(plate)
    for k, v in pairs(veh:getInventory().item) do
        if v.name == item then
            local metadatasame = true
            if v.metadatas ~= nil and metadatas ~= nil and getNumberOfKey(v.metadatas) == getNumberOfKey(metadatas) then
                if v.metadatas.identity.firstname == metadatas.identity.firstname and v.metadatas.identity.name == metadatas.identity.name and v.metadatas.identity.id == metadatas.identity.id then
                    metadatasame = true
                end
            else
                metadatasame = v.metadatas == nil and metadatas == nil
            end

            if metadatasame then
                return v
            end
        end
    end
end

function getItemInventorymetadatasCasierCloths(name, id, item, metadatas)
    for k, v in pairs(casier[name][id].inv) do
        if v.name == item then
            local metadatasame = true
            if v.metadatas ~= nil and metadatas ~= nil and getNumberOfKey(v.metadatas) == getNumberOfKey(metadatas) then
                if v.metadatas.renamed == metadatas.renamed then
                    for i, j in pairs(v.metadatas.data) do
                        if j ~= metadatas.data[i] then
                            metadatasame = false
                        end
                    end
                end
            else
                metadatasame = v.metadatas == nil and metadatas == nil
            end

            if metadatasame then
                return v
            end
        end
    end
end

function getItemInventorymetadatasCasierBike(name, id, item, metadatas)
    for k, v in pairs(casier[name][id].inv) do
        if v.name == item then
            local metadatasame = true
            if v.metadatas ~= nil and metadatas ~= nil and getNumberOfKey(v.metadatas) == getNumberOfKey(metadatas) then
                for i, j in pairs(v.metadatas) do
                    if type(j) ~= "table" then
                        if j ~= metadatas[i] then
                            metadatasame = false
                        end
                    end
                end
            else
                metadatasame = v.metadatas == nil and metadatas == nil
            end

            if metadatasame then
                return v
            end
        end
    end
end

function getItemInventorymetadatasCasier(name, id, item, metadatas)
    for k, v in pairs(casier[name][id].inv) do
        if v.name == item then
            local metadatasame = true
            if v.metadatas ~= nil and metadatas ~= nil and getNumberOfKey(v.metadatas) == getNumberOfKey(metadatas) then
                for i, j in pairs(v.metadatas) do
                    if j ~= metadatas[i] then
                        metadatasame = false
                    end
                end
            else
                metadatasame = v.metadatas == nil and metadatas == nil
            end

            if metadatasame then
                return v
            end
        end
    end
end

function getItemInventorymetadatasVehicleBike(plate, item, metadatas) -- done
    local veh = GetVehicle(plate)
    for k, v in pairs(veh:getInventory().item) do
        if v.name == item then
            local metadatasame = true
            if v.metadatas ~= nil and metadatas ~= nil and getNumberOfKey(v.metadatas) == getNumberOfKey(metadatas) then
                for i, j in pairs(v.metadatas) do
                    if type(j) ~= "table" then
                        if j ~= metadatas[i] then
                            metadatasame = false
                        end
                    end
                end
            else
                metadatasame = v.metadatas == nil and metadatas == nil
            end

            if metadatasame then
                return v
            end
        end
    end
end

function getItemInventorymetadatasVehicle(plate, item, metadatas) -- done
    local veh = GetVehicle(plate)
    for k, v in pairs(veh:getInventory().item) do
        if v.name == item then
            local metadatasame = true
            if v.metadatas ~= nil and metadatas ~= nil and getNumberOfKey(v.metadatas) == getNumberOfKey(metadatas) then
                for i, j in pairs(v.metadatas) do
                    if j ~= metadatas[i] then
                        metadatasame = false
                    end
                end
            else
                metadatasame = v.metadatas == nil and metadatas == nil
            end

            if metadatasame then
                return v
            end
        end
    end
end

function getInventoryWeight(source)
    local weight = 0
    if GetPlayer(source) == nil then return 0 end

    if GetPlayer(source):getPermission() > 4 then
        return 0
    end
    
    for k, v in pairs(GetPlayer(source):getInventaire()) do
        local itemWeight = getItemWeight(v.name)
        weight = weight + (itemWeight * v.count)
    end
    return weight
end

function getPropertyInventory(property, etage)
    local weight = 0
    for _, v in pairs(propertyList) do
        if v.id == property.id then
            for _, j in pairs(v.etage) do
                if j.id == etage.id then
                    if j.inventory then
                        for k, l in pairs(j.inventory.item) do
                            local itemWeight = getItemWeight(l.name)
                            weight = weight + (itemWeight * l.count)
                        end
                    end
                end
            end
        end
    end
    return weight
end

function getPropertyMailBox(property)
    local weight = 0
    etage = {etage = 1}
    for _, v in pairs(propertyList) do
        if v.id == property.id then
            for _, j in pairs(v.etage) do
                if j.id == etage.id then
                    if j.mailbox then
                        if j.mailbox.item ~= nil then
                            for k, l in pairs(j.mailbox.item) do
                                local itemWeight = getItemWeight(l.name)
                                weight = weight + (itemWeight * l.count)
                            end
                        end
                    end
                end
            end
        end
    end
    return weight
end

function getInventoryWeightSociety(name)
    local weight = 0
    for k, v in pairs(society[name].inventory.item) do
        local itemWeight = getItemWeight(v.name)
        weight = weight + (itemWeight * v.count)
    end
    return weight
end

function getInventoryWeightCasier(name, id)
    local weight = 0
    for k, v in pairs(casier[name][id].inv) do
        local itemWeight = getItemWeight(v.name)
        weight = weight + (itemWeight * v.count)
    end
    return weight
end

function getInventoryWeightVehicle(plate) -- done
    local weight = 0
    local veh = GetVehicle(plate)
    for k, v in pairs(veh:getInventory().item) do
        local itemWeight = getItemWeight(v.name)
        weight = weight + (itemWeight * v.count)
    end
    return weight
end

function GetItemWeightWithCount(item, count)
    return item and items[item].weight * count or 0
end

function HasEnoughSpaceInInv(source, item, count)
    local itemWeight = GetItemWeightWithCount(item, count)
    if itemWeight ~= 0.0 then
        if getInventoryWeight(source) + itemWeight <= items.maxWeight then
            return true
        else
            return false
        end
    end
    return true
end

RegisterNetEvent("core:updateitweig", function(amount)
    items.maxWeight = amount
end)

function CanPlayerTakeThisItems(source, item, count)
    if DoesItemexist(item) then
        local itemWeight = GetItemWeightWithCount(item, count)
        if itemWeight ~= 0.0 then
            if getInventoryWeight(source) + itemWeight <= items.maxWeight then
                return true
            else
                return false
            end
        else
            return true 
        end
    else
        return false
    end
end

function AddItemToInventory(source, item, count, metadatas)
    local source = tonumber(source)
    local count = tonumber(count)
    if GetPlayer(source) == nil then return 0 end
    if DoesItemexist(item) then
        local itemWeight = GetItemWeightWithCount(item, count)
        if itemWeight ~= 0.0 then
            local isgood = metadatas and metadatas.premium and true or false
            if isgood or getInventoryWeight(source) + itemWeight <= items.maxWeight then
                local itemInventory = getItemInventorymetadatas(source, item, metadatas)
                if itemInventory ~= nil and items[item].type ~= "weapons" then
                    if items[item].notStackable then
                        local itemData = { name = item, label = getItemLabel(item), count = count, type = getItemType(item),
                                weight = getItemWeight(item), cols = getItemCols(item),
                                rows = getItemRows(item), metadatas = metadatas }
                        table.insert(GetPlayer(source):getInventaire(), itemData)
                        triggerEventPlayer("core:addItemPlayer", source, itemData)
                    else
                        itemInventory.count = (itemInventory.count + count)
                        triggerEventPlayer("core:addExistItemPlayer", source, item, count)
                    end
                    return true
                elseif itemInventory == nil and items[item].type ~= "weapons" then
                    local itemData = { name = item, label = getItemLabel(item), count = count, type = getItemType(item),
                            weight = getItemWeight(item), cols = getItemCols(item),
                            rows = getItemRows(item), metadatas = metadatas }
                    table.insert(GetPlayer(source):getInventaire(), itemData)
                    triggerEventPlayer("core:addItemPlayer", source, itemData)
                    return true
                elseif items[item].type == "weapons" then
                    local itemData
                    for i = 1, count do
                        itemData = { name = item, label = getItemLabel(item), count = 1, type = getItemType(item),
                                weight = getItemWeight(item), cols = getItemCols(item),
                                rows = getItemRows(item), metadatas = metadatas }
                        table.insert(GetPlayer(source):getInventaire(), itemData)
                        triggerEventPlayer("core:addItemPlayer", source, itemData)
                    end
                    return true
                end
            else
                return false
            end
        else
            local itemInventory = getItemInventorymetadatas(source, item, metadatas)
            if itemInventory ~= nil and items[item].type ~= "weapons" then
                if items[item].notStackable then
                    local itemData = { name = item, label = getItemLabel(item), count = count, type = getItemType(item),
                            weight = getItemWeight(item), cols = getItemCols(item),
                            rows = getItemRows(item), metadatas = metadatas }
                    table.insert(GetPlayer(source):getInventaire(), itemData)
                    triggerEventPlayer("core:addItemPlayer", source, itemData)
                else
                    itemInventory.count = (itemInventory.count + count)
                    triggerEventPlayer("core:addExistItemPlayer", source, item, count)
                end
                return true
            elseif itemInventory == nil and items[item].type ~= "weapons" then
                local itemData = { name = item, label = getItemLabel(item), count = count, type = getItemType(item),
                        weight = getItemWeight(item), cols = getItemCols(item),
                        rows = getItemRows(item), metadatas = metadatas }
                table.insert(GetPlayer(source):getInventaire(), itemData)
                triggerEventPlayer("core:addItemPlayer", source, itemData)
                return true
            elseif items[item].type == "weapons" then
                local itemData
                for i = 1, count do
                    itemData = { name = item, label = getItemLabel(item), count = 1, type = getItemType(item),
                            weight = getItemWeight(item), cols = getItemCols(item),
                            rows = getItemRows(item), metadatas = metadatas }
                    table.insert(GetPlayer(source):getInventaire(), itemData)
                    triggerEventPlayer("core:addItemPlayer", source, itemData)
                end
                return true
            end
        end
    else
        return false
    end
end

function AddItemToInventoryStaff(source, item, count, metadatas)
    local source = tonumber(source)
    local count = tonumber(count)
    if DoesItemexist(item) then
        local itemInventory = getItemInventorymetadatas(source, item, metadatas)
        if itemInventory ~= nil and items[item].type ~= "weapons" then
            if items[item].notStackable then
                local itemData =  { name = item, label = getItemLabel(item), count = count, type = getItemType(item),
                        weight = getItemWeight(item), cols = getItemCols(item),
                        rows = getItemRows(item), metadatas = metadatas }
                table.insert(GetPlayer(source):getInventaire(), itemData)
                triggerEventPlayer("core:addItemPlayer", source, itemData)
            else
                itemInventory.count = (itemInventory.count + count)
                triggerEventPlayer("core:addExistItemPlayer", source, item, count)
            end
            return true
        elseif itemInventory == nil and items[item].type ~= "weapons" then
            local itemData = { name = item, label = getItemLabel(item), count = count, type = getItemType(item),
                    weight = getItemWeight(item), cols = getItemCols(item),
                    rows = getItemRows(item), metadatas = metadatas }
            table.insert(GetPlayer(source):getInventaire(), itemData)
            triggerEventPlayer("core:addItemPlayer", source, itemData)
            return true
        elseif items[item].type == "weapons" then
            local itemData
            for i = 1, count do
                itemData = { name = item, label = getItemLabel(item), count = 1, type = getItemType(item),
                        weight = getItemWeight(item), cols = getItemCols(item),
                        rows = getItemRows(item), metadatas = metadatas }
                table.insert(GetPlayer(source):getInventaire(), itemData)
                triggerEventPlayer("core:addItemPlayer", source, itemData)
            end
            return true
        end

    else
        return false
    end
end

function getPropertyMaxWeight(propertyData)
    -- print("Premier print",json.encode(propertyData))
    -- for k, v in pairs(Property[etage.type].data) do
    --     print("Deuxieme print", k, " ----- k et v -----",json.encode(v))
    --     if v.name == etage.interior then
    --         return v.weight
    --     end
    -- end
    return propertyData.weight
end


function AddItemToPropertyMailBox(propertyData, etage, item, count, metadatas)
    local count = tonumber(count)
    if DoesItemexist(item) then
        if getPropertyMailBox(propertyData, etage) + getItemWeight(item) * count <= 3.0 then
            local itemInventory = getItemInventoryMetadatasProperty(propertyData, etage, item, metadatas)
            if itemInventory ~= nil and items[item].type ~= "weapons" and (not items[item].notStackable) then
                itemInventory.count = (itemInventory.count + count)
                return true
            elseif ((itemInventory == nil) or items[item].notStackable) and items[item].type ~= "weapons" then
                for k, v in pairs(propertyList) do
                    if v.id == propertyData.id then
                        for o, j in pairs(v.etage) do
                            if j.etage == etage.etage then
                                if j.mailbox then
                                    if j.mailbox.item then
                                        for k, v in pairs(j.mailbox.item) do
                                            if v.name == item then
                                                v.count = v.count + count
                                                v.weight = v.weight + getItemWeight(item) * count
                                                return true
                                            end
                                        end
                                        table.insert(j.mailbox.item,
                                            { name = item, label = getItemLabel(item), count = count,
                                                type = getItemType(item),
                                                weight = getItemWeight(item), cols = getItemCols(item),
                                                rows = getItemRows(item), metadatas = metadatas })
                                        return true
                                    else
                                        j.mailbox.item = {}
                                        for k, v in pairs(j.mailbox.item) do
                                            if v.name == item then
                                                v.count = v.count + count
                                                v.weight = v.weight + getItemWeight(item) * count
                                                return true
                                            end
                                        end
                                        table.insert(j.mailbox.item,
                                            { name = item, label = getItemLabel(item), count = count,
                                                type = getItemType(item),
                                                weight = getItemWeight(item), cols = getItemCols(item),
                                                rows = getItemRows(item), metadatas = metadatas })
                                        return true
                                    end
                                else
                                    j.mailbox = { item = {} }
                                    table.insert(j.mailbox.item,
                                        { name = item, label = getItemLabel(item), count = count,
                                            type = getItemType(item),
                                            weight = getItemWeight(item), cols = getItemCols(item),
                                            rows = getItemRows(item), metadatas = metadatas })
                                    return true
                                end
                            end
                        end
                    end
                end
                return true
            elseif items[item].type == "weapons" then
                for k, v in pairs(propertyList) do
                    if v.id == propertyData.id then
                        for o, j in pairs(v.etage) do
                            if j.etage == etage.etage then
                                for i = 1, count do
                                    if j.mailbox then
                                        table.insert(j.mailbox.item,
                                            { name = item, label = getItemLabel(item), count = 1,
                                                type = getItemType(item),
                                                weight = getItemWeight(item), cols = getItemCols(item),
                                                rows = getItemRows(item), metadatas = metadatas })
                                        return true
                                    else
                                        j.mailbox = { item = {} }
                                        table.insert(j.mailbox.item,
                                            { name = item, label = getItemLabel(item), count = 1,
                                                type = getItemType(item),
                                                weight = getItemWeight(item), cols = getItemCols(item),
                                                rows = getItemRows(item), metadatas = metadatas })
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
                return true
            end
        else
            return false
        end
    else
        return false
    end
end

function AddItemToPropertyInventory(propertyData, etage, item, count, metadatas)
    local count = tonumber(count)
    if DoesItemexist(item) then
        if getPropertyInventory(propertyData, etage) + getItemWeight(item) * count <=
            getPropertyMaxWeight(propertyData, etage) then
            local itemInventory = getItemInventoryMetadatasProperty(propertyData, etage, item, metadatas)
            if itemInventory ~= nil and items[item].type ~= "weapons" and (not items[item].notStackable) then
                itemInventory.count = (itemInventory.count + count)
                return true
            elseif ((itemInventory == nil) or items[item].notStackable) and items[item].type ~= "weapons" then
                for k, v in pairs(propertyList) do
                    if v.id == propertyData.id then
                        for o, j in pairs(v.etage) do
                            if j.etage == etage.etage then
                                if j.inventory then
                                    table.insert(j.inventory.item,
                                        { name = item, label = getItemLabel(item), count = count,
                                            type = getItemType(item),
                                            weight = getItemWeight(item), cols = getItemCols(item),
                                            rows = getItemRows(item), metadatas = metadatas })
                                    return true
                                else
                                    j.inventory = { item = {} }
                                    table.insert(j.inventory.item,
                                        { name = item, label = getItemLabel(item), count = count,
                                            type = getItemType(item),
                                            weight = getItemWeight(item), cols = getItemCols(item),
                                            rows = getItemRows(item), metadatas = metadatas })
                                    return true
                                end
                            end
                        end
                    end
                end
                return true
            elseif items[item].type == "weapons" then
                for k, v in pairs(propertyList) do
                    if v.id == propertyData.id then
                        for o, j in pairs(v.etage) do
                            if j.etage == etage.etage then
                                for i = 1, count do
                                    if j.inventory then
                                        table.insert(j.inventory.item,
                                            { name = item, label = getItemLabel(item), count = 1,
                                                type = getItemType(item),
                                                weight = getItemWeight(item), cols = getItemCols(item),
                                                rows = getItemRows(item), metadatas = metadatas })
                                        return true
                                    else
                                        j.inventory = { item = {} }
                                        table.insert(j.inventory.item,
                                            { name = item, label = getItemLabel(item), count = 1,
                                                type = getItemType(item),
                                                weight = getItemWeight(item), cols = getItemCols(item),
                                                rows = getItemRows(item), metadatas = metadatas })
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
                return true
            end
        else
            return false
        end
    else
        return false
    end
end

function AddItemToInventorySociety(name, item, count, metadatas)
    local count = tonumber(count)
    if DoesItemexist(item) then
        if getInventoryWeightSociety(name) + getItemWeight(item) * count <= 500 then
            local itemInventory = getItemInventorymetadatasSociety(name, item, metadatas)
            if itemInventory ~= nil and items[item].type ~= "weapons" and (not items[item].notStackable) then
                itemInventory.count = (itemInventory.count + count)
                return true
            elseif ((itemInventory == nil) or items[item].notStackable) and items[item].type ~= "weapons" then
                table.insert(society[name].inventory.item,
                    { name = item, label = getItemLabel(item), count = count, type = getItemType(item),
                        weight = getItemWeight(item), cols = getItemCols(item),
                        rows = getItemRows(item), metadatas = metadatas })
                return true
            elseif items[item].type == "weapons" then
                for i = 1, count do
                    table.insert(society[name].inventory.item,
                        { name = item, label = getItemLabel(item), count = 1, type = getItemType(item),
                            weight = getItemWeight(item), cols = getItemCols(item),
                            rows = getItemRows(item), metadatas = metadatas })
                end
                return true
            end
        else
            return false
        end
    else
        return false
    end
end

function AddItemToCasierInventory(name, id, item, count, metadatas)
    local count = tonumber(count)
    if DoesItemexist(item) then
        if getInventoryWeightCasier(name, id) + getItemWeight(item) * count <= 500 then
            local itemInventory = getItemInventorymetadatasCasier(name, id, item, metadatas)
            if itemInventory ~= nil and items[item].type ~= "weapons" and (not items[item].notStackable) then
                itemInventory.count = (itemInventory.count + count)
                return true
            elseif ((itemInventory == nil) or items[item].notStackable) and items[item].type ~= "weapons" then
                table.insert(casier[name][id].inv,
                    { name = item, label = getItemLabel(item), count = count, type = getItemType(item),
                        weight = getItemWeight(item), cols = getItemCols(item),
                        rows = getItemRows(item), metadatas = metadatas })
                return true
            elseif items[item].type == "weapons" then
                for i = 1, count do
                    table.insert(casier[name][id].inv,
                        { name = item, label = getItemLabel(item), count = 1, type = getItemType(item),
                            weight = getItemWeight(item), cols = getItemCols(item),
                            rows = getItemRows(item), metadatas = metadatas })
                end
                return true
            end
        else
            return false
        end
    else
        return false
    end
end

function AddItemToInventoryVehicle(plate, item, count, metadatas, coffresize) -- done
    local count = tonumber(count)
    local veh = GetVehicle(plate)
    if not veh then 
        veh = vehicle:new({
            plate = plate,
            owner = nil,
            name = "tabletteIllegal",
            props = json.encode({}),
            garage = nil,
            stored = 1,
            vente = nil,
            coowner = json.encode({}),
            job = nil,
            inventory = json.encode({}),
            mileage = 0,
            fuel = 100,
            body = json.encode({}),
            currentPlate = plate
        })
    end
    local vehInventory = veh:getInventory()
    if DoesItemexist(item) then
        if getInventoryWeightVehicle(plate) + getItemWeight(item) * count <= coffresize then
            local itemInventory = getItemInventorymetadatasVehicle(plate, item, metadatas)
            if itemInventory ~= nil and items[item].type ~= "weapons" and (not items[item].notStackable) then
                itemInventory.count = (itemInventory.count + count)
                return true
            elseif ((itemInventory == nil) or items[item].notStackable) and items[item].type ~= "weapons" then
                table.insert(vehInventory.item,
                    { name = item, label = getItemLabel(item), count = count, type = getItemType(item),
                        weight = getItemWeight(item), cols = getItemCols(item),
                        rows = getItemRows(item), metadatas = metadatas })
                veh:setVehicleInventory(vehInventory)
                return true
            elseif items[item].type == "weapons" then
                local countdebug = count
                for i = 1, countdebug do
                    table.insert(vehInventory.item,
                        { name = item, label = getItemLabel(item), count = 1, type = getItemType(item),
                            weight = getItemWeight(item), cols = getItemCols(item),
                            rows = getItemRows(item), metadatas = metadatas })
                end
                veh:setVehicleInventory(vehInventory)
                return true

            end
        else
            return false, "full"
        end
    else
        return false
    end
end

function AddItemToInventoryVehicleStaff(plate, item, count, metadatas) -- done
    local count = tonumber(count)
    local veh = GetVehicle(plate)
    if not veh then 
        veh = vehicle:new({
            plate = plate,
            owner = nil,
            name = "tabletteIllegal",
            props = json.encode({}),
            garage = nil,
            stored = 1,
            vente = nil,
            coowner = json.encode({}),
            job = nil,
            inventory = json.encode({}),
            mileage = 0,
            fuel = 100,
            body = json.encode({}),
            currentPlate = plate
        })
    end
    Wait(100)
    local vehInventory = veh:getInventory()
    if DoesItemexist(item) then
        -- if getInventoryWeightVehicle(index, name) + getItemWeight(item) * count <= items.maxWeight then
        local itemInventory = getItemInventorymetadatasVehicle(plate, item, metadatas)
        if itemInventory ~= nil and items[item].type ~= "weapons" and (not items[item].notStackable) then
            itemInventory.count = (itemInventory.count + count)
            return true
        elseif ((itemInventory == nil) or items[item].notStackable) and items[item].type ~= "weapons" then
            table.insert(vehInventory.item,
                { name = item, label = getItemLabel(item), count = count, type = getItemType(item),
                    weight = getItemWeight(item), cols = getItemCols(item),
                    rows = getItemRows(item), metadatas = metadatas })
            veh:setVehicleInventory(vehInventory)
            return true
        elseif items[item].type == "weapons" then
            for i = 1, count do
                table.insert(vehInventory.item,
                    { name = item, label = getItemLabel(item), count = 1, type = getItemType(item),
                        weight = getItemWeight(item), cols = getItemCols(item),
                        rows = getItemRows(item), metadatas = metadatas })
            end
            veh:setVehicleInventory(vehInventory)
            return true

        end
        -- else
        --     return false
        -- end
    else
        return false
    end
end

function renameItem(source, item, name, metadatas)
    for k, v in pairs(GetPlayer(source):getInventaire()) do
        if item == v.name then
            if v.metadatas == nil then
                v.metadatas = {}
            end
            if CompareMetadatas(v.metadatas, metadatas) then
                v.metadatas["renamed"] = name
                if not player:getNeedSave() then
                    --RefreshPlayerData(source)
                    MarkPlayerDataAsNonSaved(source)
                end
            end
        end
    end
end

function ChangeItemName(source, item, name)
    local itemInventory = getItemInventorymetadatas(source, item, nil, true)
    for k, v in pairs(GetPlayer(source):getInventaire()) do
        if item == v.name and json.encode(itemInventory) ~= "null" then
            if v.metadatas == nil then
                v.metadatas = {}
            end
            v.metadatas["renamed"] = name
            if not player:getNeedSave() then
                --RefreshPlayerData(source)
                MarkPlayerDataAsNonSaved(source)
            end
        elseif item == v.name and json.encode(itemInventory) == "null" then
            v.metadatas["renamed"] = name
            if not player:getNeedSave() then
                --RefreshPlayerData(source)
                MarkPlayerDataAsNonSaved(source)
            end
        end
    end
end

function ChangeItemNameCloths(source, item, name, metadatas)
    local itemInventory = getItemInventorymetadatas(source, item, nil)
    for k, v in pairs(GetPlayer(source):getInventaire()) do
        if item == v.name and json.encode(itemInventory) ~= "null" and
            v.metadatas["drawableId"] == metadatas["drawableId"] and v.metadatas["renamed"] == metadatas["renamed"] then
            if v.metadatas == nil then
                v.metadatas = {}
            end
            if v.metadatas == metadatas then
                v.metadatas["renamed"] = name
                if not player:getNeedSave() then
                    --RefreshPlayerData(source)
                    MarkPlayerDataAsNonSaved(source)
                end
            end
        elseif item == v.name and json.encode(itemInventory) == "null" and
            v.metadatas["drawableId"] == metadatas["drawableId"] and v.metadatas["renamed"] == metadatas["renamed"] then
            v.metadatas["renamed"] = name
            if not player:getNeedSave() then
                --RefreshPlayerData(source)
                MarkPlayerDataAsNonSaved(source)
            end
        end
    end
end

function RemoveItemFromInventoryNil(source, item, count, metadatas)
    local count = tonumber(count)
    local inv = GetPlayer(source):getInventaire()
    if DoesItemexist(item) then
        if inv ~= nil then
            for i = 1, #inv do
                if inv[i] ~= nil then
                    if inv[i].name ~= nil and inv[i].metadatas == nil then
                        if inv[i].name == "money" and inv[i].metadatas == nil then
                            table.remove(inv, i)
                            triggerEventPlayer("core:RemoveItemFromInventoryNil", source, itemInventory.name, count, metadatas)
                            return true
                        end
                    end
                end
            end
        end
    else
        return false
    end
end

function UpdateItemMetadata(source, item, count, metadata, newMetadata)
    local count = tonumber(count)
    local inv = GetPlayer(source):getInventaire()
    if DoesItemexist(item) then
        if inv ~= nil then
            for i = 1, #inv do
                if inv[i] ~= nil then
                    if inv[i].name ~= nil and inv[i].metadatas ~= nil then
                        if json.encode(inv[i].name) == json.encode(item) and json.encode(inv[i].metadatas) == json.encode(metadata) then
                            inv[i].metadatas = newMetadata
                            triggerEventPlayer("core:UpdateItemMetadata", source, item, count, metadata, newMetadata)
                            return true
                        end
                    end
                end
            end
        end
    else
        return false
    end
end

function RemoveKevlarFromInventory(source, item, count, metadatas)
    local count = tonumber(count)
    local inv = GetPlayer(source):getInventaire()
    if DoesItemexist(item) then
        if inv ~= nil then
            for i = 1, #inv do
                if inv[i] ~= nil then
                    if inv[i].name ~= nil and inv[i].metadatas ~= nil then
                        if inv[i].name == item and inv[i].metadatas and inv[i].metadatas.id and inv[i].metadatas.id == metadatas.id then
                            triggerEventPlayer("core:RemoveMetadatasInventory", source, inv[i].name, count, inv[i].metadatas)
                            if inv[i].count - count >= 0 then
                                inv[i].count = (inv[i].count - count)
                                if inv[i].count == 0 then
                                    table.remove(inv, i)
                                    return true
                                end
                            end
                            return true
                        end
                    end
                end
            end
        end
        else
        return false
    end
end

function RemoveItemFromInventory(source, item, count, metadatas)
    local count = tonumber(count)
    local inv = GetPlayer(source):getInventaire()

    if DoesItemexist(item) then
        for k, v in pairs(inv) do

            if v.name == item then

                local itemInventory

                local meta

                if v.type == "clothes" or v.name == "keys" then
                    itemInventory = getItemInventorymetadatas(source, item, metadatas, count)
                    meta = metadatas

                else
                    itemInventory = getItemInventorymetadatas(source, item, v.metadatas, count)
                    meta = v.metadatas
                end
                
                if itemInventory ~= nil then
                    if itemInventory.count - count >= 0 then
                        itemInventory.count = (itemInventory.count - count)
                        if itemInventory.count == 0 then
                            if inv ~= nil then
                                for i = 1, #inv do
                                    if inv[i] ~= nil then
                                        if inv[i].name ~= nil and inv[i].metadatas ~= nil then
                                            if inv[i].name == itemInventory.name and inv[i].metadatas == itemInventory.metadatas then

                                                --print(item)
                                                triggerEventPlayer("core:RemoveMetadatasInventory", source, itemInventory.name, count, meta)
                                                table.remove(inv, i)
                                                return true
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        triggerEventPlayer("core:RemoveMetadatasInventory", source, itemInventory.name, count, meta)
                        return true
                    else
                        return false
                    end
                else
                    return false
                end
            end
        end
    else
        return false
    end
end


function RemoveIdentityCardFromInventory(source, items, count, metadatas)
    local count = tonumber(count)
    local inv = GetPlayer(source):getInventaire()
    if DoesItemexist(items) then
        local itemInventory = getIdentityInventoryMetadatas(source, items, metadatas)
        if itemInventory ~= nil then
            if itemInventory.count - count >= 0 then
                itemInventory.count = (itemInventory.count - count)
                if itemInventory.count == 0 then
                    if inv ~= nil then
                        for i = 1, #inv do
                            if inv[i] ~= nil then
                                if inv[i].name ~= nil and inv[i].metadatas ~= nil then
                                    if inv[i].name == itemInventory.name and inv[i].metadatas == itemInventory.metadatas then
                                        table.remove(inv, i)
                                        triggerEventPlayer("core:RemoveMetadatasInventory", source, itemInventory.name, count, metadatas)
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
                triggerEventPlayer("core:RemoveMetadatasInventory", source, itemInventory.name, count, metadatas)
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

function RemoveBikeFromInventory(source, items, count, metadatas)
    local count = tonumber(count)
    local inv = GetPlayer(source):getInventaire()
    if DoesItemexist(items) then
        local itemInventory = getBikeInventoryMetadatas(source, items, metadatas)
        if itemInventory ~= nil then
            if itemInventory.count - count >= 0 then
                itemInventory.count = (itemInventory.count - count)
                if itemInventory.count == 0 then
                    if inv ~= nil then
                        for i = 1, #inv do
                            if inv[i] ~= nil then
                                if inv[i].name ~= nil and
                                    inv[i].metadatas ~= nil then
                                    if inv[i].name == itemInventory.name and
                                        inv[i].metadatas == itemInventory.metadatas then
                                            triggerEventPlayer("core:RemoveMetadatasInventory", source, itemInventory.name, count, metadatas)
                                            table.remove(inv, i)
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
                triggerEventPlayer("core:RemoveMetadatasInventory", source, itemInventory.name, count, metadatas)
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

function RemoveClothFromInventory(source, cloths, count, metadatas)
    local count = tonumber(count)
    local inv = GetPlayer(source):getInventaire()
    if DoesItemexist(cloths) then
        local itemInventory = getClothsInventoryMetadatas(source, cloths, metadatas)
        if itemInventory ~= nil then
            if itemInventory.count - count >= 0 then
                itemInventory.count = (itemInventory.count - count)
                if itemInventory.count == 0 then
                    if inv ~= nil then
                        for i = 1, #inv do
                            if inv[i] ~= nil then
                                if inv[i].name ~= nil and
                                    inv[i].metadatas ~= nil then
                                    if inv[i].name == itemInventory.name and
                                        inv[i].metadatas == itemInventory.metadatas then
                                        triggerEventPlayer("core:RemoveMetadatasInventory", source, itemInventory.name, count, metadatas)                                            
                                        table.remove(inv, i)
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
                triggerEventPlayer("core:RemoveMetadatasInventory", source, itemInventory.name, count, metadatas)
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

function RemoveWeaponFromInventory(source, name, count, metadatas)
    local count = tonumber(count)
    local inv = GetPlayer(source):getInventaire()
    if DoesItemexist(name) then
        local itemInventory = getWeaponInventorymetadatas(source, name, metadatas)
        if itemInventory ~= nil then
            if itemInventory.count - count >= 0 then
                itemInventory.count = (itemInventory.count - count)
                if itemInventory.count == 0 then
                    if inv ~= nil then
                        for i = 1, #inv do
                            if inv[i] ~= nil then
                                if inv[i].name ~= nil and
                                    inv[i].metadatas ~= nil then
                                    if inv[i].name == itemInventory.name then
                                        triggerEventPlayer("core:RemoveMetadatasInventory", source, itemInventory.name, count, metadatas)
                                        table.remove(inv, i)
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
                triggerEventPlayer("core:RemoveMetadatasInventory", source, itemInventory.name, count, metadatas)
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

function RemoveItemFromInventorySociety(name, item, count, metadatas)
    local count = tonumber(count)
    if DoesItemexist(item) then
        local itemInventory = getItemInventorymetadatasSociety(name, item, metadatas)
        if itemInventory ~= nil then
            if itemInventory.count - count >= 0 then
                itemInventory.count = (itemInventory.count - count)
                if itemInventory.count == 0 then
                    for i = 1, #society[name].inventory.item do
                        if society[name].inventory.item[i] ~= nil then
                            if society[name].inventory.item[i].name ~= nil and
                                society[name].inventory.item[i].metadatas ~= nil then
                                if society[name].inventory.item[i].name == itemInventory.name and
                                    society[name].inventory.item[i].metadatas == itemInventory.metadatas then
                                    table.remove(society[name].inventory.item, i)
                                    return true
                                end
                            end
                        end
                    end
                end
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

function RemoveItemFromInventoryCasierBike(name, id, item, count, metadatas)
    local count = tonumber(count)
    if DoesItemexist(item) then
        local itemInventory = getItemInventorymetadatasCasierBike(name, id, item, metadatas)
        if itemInventory ~= nil then
            if itemInventory.count - count >= 0 then
                itemInventory.count = (itemInventory.count - count)
                if itemInventory.count == 0 then
                    for i = 1, #casier[name][id].inv do
                        if casier[name][id].inv[i] ~= nil then
                            if casier[name][id].inv[i].name ~= nil and
                                casier[name][id].inv[i].metadatas ~= nil then
                                if casier[name][id].inv[i].name == itemInventory.name and
                                    casier[name][id].inv[i].metadatas == itemInventory.metadatas then
                                    table.remove(casier[name][id].inv, i)
                                    return true
                                end
                            end
                        end
                    end
                end
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

function RemoveItemFromInventoryCasier(name, id, item, count, metadatas)
    local count = tonumber(count)
    if DoesItemexist(item) then
        local itemInventory = getItemInventorymetadatasCasier(name, id, item, metadatas)
        if itemInventory ~= nil then
            if itemInventory.count - count >= 0 then
                itemInventory.count = (itemInventory.count - count)
                if itemInventory.count == 0 then
                    for i = 1, #casier[name][id].inv do
                        if casier[name][id].inv[i] ~= nil then
                            if casier[name][id].inv[i].name ~= nil and
                                casier[name][id].inv[i].metadatas ~= nil then
                                if casier[name][id].inv[i].name == itemInventory.name and
                                    casier[name][id].inv[i].metadatas == itemInventory.metadatas then
                                    table.remove(casier[name][id].inv, i)
                                    return true
                                end
                            end
                        end
                    end
                end
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

function RemoveItemFromInventoryCasierIdentityCard(name, id, item, count, metadatas)
    local count = tonumber(count)
    if DoesItemexist(item) then
        local itemInventory = getItemInventorymetadatasCasierIdentityCard(name, id, item, metadatas)
        if itemInventory ~= nil then
            if itemInventory.count - count >= 0 then
                itemInventory.count = (itemInventory.count - count)
                if itemInventory.count == 0 then
                    for i = 1, #casier[name][id].inv do
                        if casier[name][id].inv[i] ~= nil then
                            if casier[name][id].inv[i].name ~= nil and
                                casier[name][id].inv[i].metadatas ~= nil then
                                if casier[name][id].inv[i].name == itemInventory.name and
                                    casier[name][id].inv[i].metadatas == itemInventory.metadatas then
                                    table.remove(casier[name][id].inv, i)
                                    return true
                                end
                            end
                        end
                    end
                end
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

function RemoveItemFromInventoryCasierCloth(name, id, item, count, metadatas)
    local count = tonumber(count)
    if DoesItemexist(item) then
        local itemInventory = getItemInventorymetadatasCasierCloths(name, id, item, metadatas)
        if itemInventory ~= nil then
            if itemInventory.count - count >= 0 then
                itemInventory.count = (itemInventory.count - count)
                if itemInventory.count == 0 then
                    for i = 1, #casier[name][id].inv do
                        if casier[name][id].inv[i] ~= nil then
                            if casier[name][id].inv[i].name ~= nil and
                                casier[name][id].inv[i].metadatas ~= nil then
                                if casier[name][id].inv[i].name == itemInventory.name and
                                    casier[name][id].inv[i].metadatas == itemInventory.metadatas then
                                    table.remove(casier[name][id].inv, i)
                                    return true
                                end
                            end
                        end
                    end
                end
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

function RemoveItemToPropertyInventoryBike(propertyData, etage, item, count, metadatas)
    local count = tonumber(count)
    if DoesItemexist(item) then
        local itemInventory = getItemInventoryMetadatasPropertyBike(propertyData, etage, item, metadatas)
        if itemInventory ~= nil then
            if itemInventory.count - count >= 0 then
                itemInventory.count = (itemInventory.count - count)
                if itemInventory.count == 0 then
                    for k, v in pairs(propertyList) do
                        if v.id == propertyData.id then
                            for o, j in pairs(v.etage) do
                                if j.etage == etage.etage then
                                    for i = 1, #j.inventory.item do
                                        if j.inventory.item[i] ~= nil then
                                            if j.inventory.item[i].name ~= nil and j.inventory.item[i].metadatas ~= nil then
                                                if j.inventory.item[i].name == itemInventory.name and
                                                    j.inventory.item[i].metadatas == itemInventory.metadatas then
                                                    table.remove(j.inventory.item, i)
                                                    return true
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

function RemoveItemToPropertyInventoryIdentityCard(propertyData, etage, item, count, metadatas)
    local count = tonumber(count)
    if DoesItemexist(item) then
        local itemInventory = getItemInventoryMetadatasPropertyIdentityCard(propertyData, etage, item, metadatas)
        if itemInventory ~= nil then
            if itemInventory.count - count >= 0 then
                itemInventory.count = (itemInventory.count - count)
                if itemInventory.count == 0 then
                    for k, v in pairs(propertyList) do
                        if v.id == propertyData.id then
                            for o, j in pairs(v.etage) do
                                if j.etage == etage.etage then
                                    for i = 1, #j.inventory.item do
                                        if j.inventory.item[i] ~= nil then
                                            if j.inventory.item[i].name ~= nil and j.inventory.item[i].metadatas ~= nil then
                                                if j.inventory.item[i].name == itemInventory.name and
                                                    j.inventory.item[i].metadatas == itemInventory.metadatas then
                                                    table.remove(j.inventory.item, i)
                                                    return true
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

function RemoveItemToPropertyInventory(propertyData, etage, item, count, metadatas)
    local count = tonumber(count)
    if DoesItemexist(item) then
        local itemInventory = getItemInventoryMetadatasProperty(propertyData, etage, item, metadatas)
        if itemInventory ~= nil then
            if itemInventory.count - count >= 0 then
                itemInventory.count = (itemInventory.count - count)
                if itemInventory.count == 0 then
                    for k, v in pairs(propertyList) do
                        if v.id == propertyData.id then
                            for o, j in pairs(v.etage) do
                                if j.etage == etage.etage then
                                    for i = 1, #j.inventory.item do
                                        if j.inventory.item[i] ~= nil then
                                            if j.inventory.item[i].name ~= nil and j.inventory.item[i].metadatas ~= nil then
                                                if j.inventory.item[i].name == itemInventory.name and
                                                    j.inventory.item[i].metadatas == itemInventory.metadatas then
                                                    table.remove(j.inventory.item, i)
                                                    return true
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

function RemoveItemToVehicle(plate, item, count, metadatas) -- done
    local count = tonumber(count)
    local veh = GetVehicle(plate)
    if not veh then return false end
    local vehInventory = veh:getInventory()
    if DoesItemexist(item) then
        local itemInventory = getItemInventorymetadatasVehicle(plate, item, metadatas)
        if itemInventory ~= nil then
            if itemInventory.count - count >= 0 then
                itemInventory.count = (itemInventory.count - count)
                if itemInventory.count == 0 then
                    for i = 1, #vehInventory.item do
                        if vehInventory.item[i] ~= nil then
                            if vehInventory.item[i].name ~= nil and
                                vehInventory.item[i].metadatas ~= nil then
                                if vehInventory.item[i].name == itemInventory.name and
                                    vehInventory.item[i].metadatas == itemInventory.metadatas then
                                    table.remove(vehInventory.item, i)
                                    veh:setVehicleInventory(vehInventory)
                                    return true
                                end
                            end
                        end
                    end
                end
                veh:setVehicleInventory(vehInventory)
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

function VehicleHasItem(plate, item, count, metadatas) -- done
    local count = tonumber(count)
    local veh = GetVehicle(plate)
    local vehInventory = veh:getInventory()
    if DoesItemexist(item) then
        local itemInventory = getItemInventorymetadatasVehicle(plate, item, metadatas)
        if itemInventory ~= nil then
            if itemInventory.count - count >= 0 then
                itemInventory.count = (itemInventory.count - count)
                if itemInventory.count == 0 then
                    for i = 1, #vehInventory.item do
                        if vehInventory.item[i] ~= nil then
                            if vehInventory.item[i].name ~= nil and
                                vehInventory.item[i].metadatas ~= nil then
                                if vehInventory.item[i].name == itemInventory.name and
                                    vehInventory.item[i].metadatas == itemInventory.metadatas then
                                    return true
                                end
                            end
                        end
                    end
                end
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

function RemoveItemToVehicleBike(plate, item, count, metadatas) -- done
    local count = tonumber(count)
    local veh = GetVehicle(plate)
    local vehInventory = veh:getInventory()
        if DoesItemexist(item) then
        local itemInventory = getItemInventorymetadatasVehicleBike(plate, item, metadatas)
        if itemInventory ~= nil then
            if itemInventory.count - count >= 0 then
                itemInventory.count = (itemInventory.count - count)
                if itemInventory.count == 0 then
                    for i = 1, #vehInventory.item do
                        if vehInventory.item[i] ~= nil then
                            if vehInventory.item[i].name ~= nil and
                                vehInventory.item[i].metadatas ~= nil then
                                if vehInventory.item[i].name == itemInventory.name and
                                    vehInventory.item[i].metadatas == itemInventory.metadatas then
                                    table.remove(vehInventory.item, i)
                                    veh:setVehicleInventory(vehInventory)
                                    return true
                                end
                            end
                        end
                    end
                end
                veh:setVehicleInventory(vehInventory)
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

function RemoveItemToVehicleIdentity(plate, item, count, metadatas) -- done
    local count = tonumber(count)
    local veh = GetVehicle(plate)
    local vehInventory = veh:getInventory()
    if DoesItemexist(item) then
        local itemInventory = getItemInventorymetadatasVehicleIdentityCard(plate, item, metadatas)
        if itemInventory ~= nil then
            if itemInventory.count - count >= 0 then
                itemInventory.count = (itemInventory.count - count)
                if itemInventory.count == 0 then
                    for i = 1, #vehInventory.item do
                        if vehInventory.item[i] ~= nil then
                            if vehInventory.item[i].name ~= nil and
                                vehInventory.item[i].metadatas ~= nil then
                                if vehInventory.item[i].name == itemInventory.name and
                                    vehInventory.item[i].metadatas == itemInventory.metadatas then
                                    table.remove(vehInventory.item, i)
                                    veh:setVehicleInventory(vehInventory)
                                    return true
                                end
                            end
                        end
                    end
                end
                veh:setVehicleInventory(vehInventory)
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

function CanInventoryTakeItem(source, item, count, metadatas)
    local count = tonumber(count)
    if GetPlayer(source) == nil then return false end
    if DoesItemexist(item) then
        if getInventoryWeight(source) + getItemWeight(item) * count <= items.maxWeight then
            return true
        else
            return false
        end
    else
        return false
    end
end
