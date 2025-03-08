casierClass = {
    id = 0,
    num = 0,
    job = "",
    inventory = {},
    needSave = false
}

casierClass.__index = casierClass

local casier = {} ---@type casier

---@return casierClass
function GetCasier(id)
    return casier[id]
end

function RemoveCasier(id)
    casier[id] = nil
end

function GetAllCasiers()
    return casier
end

function GetAllCasiersByJob(job)
    local casiers = {}
    for k, v in pairs(casier) do
        if v.job == job then
            table.insert(casiers, v)
        end
    end
    return casiers
end


---@return casierClass
function casierClass:new(data)
    local self = setmetatable({}, casierClass)
    self.id = data.id
    self.num = data.num
    self.job = data.job
    self.inventory = json.decode(data.inventory) or {}
    self.needSave = false
    --print(data.id, json.encode(self))
    casier[data.id] = self
    return self
end

--casierClass methods

function casierClass:getId()
    return self.id
end

function casierClass:getNum()
    return self.num
end

function casierClass:getJob()
    return self.job
end
---@private
function casierClass:setInventory(inventory)
    self:setNeedSave(true)
    self.inventory = inventory
end

function casierClass:getInventory()
    return self.inventory
end

---@private
function casierClass:setNeedSave(needSave)
    self.needSave = needSave
end

function casierClass:getNeedSave()
    return self.needSave
end
--
function casierClass:addInventoryItemCasier(itemName, count, metadatas)
    local inventory = self:getInventory()
    local found = false
    -- if item is already in inventory, add to quantity
    for k, v in pairs(inventory) do
        if v.name == itemName then
            if CompareMetadatas(v.metadatas, metadatas) then
                v.count = v.count + count
                found = true
                break
            end
        end
    end
    -- else add item to inventory
    if not found then
        table.insert(inventory, { name = itemName, label = getItemLabel(itemName), count = count, type = getItemType(itemName),
            weight = getItemWeight(itemName), cols = getItemCols(itemName),
            rows = getItemRows(itemName), metadatas = metadatas })
    end
    -- Then save it
    self:setInventory(inventory)
    return true
end

function casierClass:removeInventoryItemCasier(itemName, count, metadatas)
    local inventory = self:getInventory()
    for k, v in pairs(inventory) do
        if v.name == itemName then
            if CompareMetadatas(v.metadatas, metadatas) then
                v.count = v.count - count
                if v.count <= 0 then
                    table.remove(inventory, k)
                end
                self:setInventory(inventory)
                return true
            end
        end
    end
    return false
end

function GetCasierFromNumJob(num, job)
    for k, v in pairs(GetAllCasiers()) do
        if v.num == num and v.job == job then return v end
    end
    return nil
end

function casierClass:updateCasier()
    MySQL.Async.execute("UPDATE casier SET inventory = @inventory WHERE id = @id",
        {
            ['@inventory'] = json.encode(self.inventory),
            ['@id'] = self.id,

        },
        function(affectedRows)
            self:setNeedSave(false)
            print("casier " .. self.id .. " mis a jour")
        end
    )
end
