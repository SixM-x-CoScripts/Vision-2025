chest = {
    id = 0,
    name = "",
    enter_pos = vector3(0, 0, 0),
    inventory = {},
    weight = 0,
    code = "1234",
    needs_save = false
}
chest.__index = chest

---@return chest
function chest:new(data)
    local self = setmetatable({}, chest)
    self.id = data.id or 0
    self.name = data.name or ""
    self.pos = json.decode(data.pos) or vector3(0, 0, 0)
    self.inventory = json.decode(data.inventory) or {}
    self.weight = data.weight or 0
    self.code = data.code or "1234"
    self.needs_save = false
    return self
end

function chest:_id(id)
    if id then
        self.id = id
        self.needs_save = true
    end
    return self.id
end

function chest:_name(name)
    if name then
        self.name = name
        self.needs_save = true
    end
    return self.name
end

function chest:_pos(pos)
    if pos then
        self.pos = pos
        self.needs_save = true
    end
    return self.pos
end

function chest:_inventory(inventory)
    if inventory then
        self.inventory = inventory
        self.needs_save = true
    end
    return self.inventory
end

function chest:_weight(weight)
    if weight then
        self.weight = weight
        self.needs_save = true
    end
    return self.weight
end

function chest:_code(code)
    if code then
        self.code = code
        self.needs_save = true
    end
    return self.code
end

function chest:AddInventoryItemCoffre(item)
    local inventory = self:_inventory()
    local found = false
    -- if item is already in inventory, add to quantity
    for k, v in pairs(inventory) do
        if v.name == item.name then
            if CompareMetadatas(v.metadatas, item.metadatas) then
                v.count = v.count + item.count
                found = true
                break
            end
        end
    end
    -- else add item to inventory
    if not found then
        table.insert(inventory, item)
    end
    -- Then save it
    return self:_inventory(inventory)
end

function chest:RemoveInventoryItemCoffre(item)
    local inventory = self:_inventory()
    for k, v in pairs(inventory) do
        if v.name == item.name then
            if CompareMetadatas(v.metadatas, item.metadatas) then
                v.count = v.count - item.count
                if v.count <= 0 then
                    table.remove(inventory, k)
                end
                self:_inventory(inventory)
                return true
            end
        end
    end
    return false
end
