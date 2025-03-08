property = {
    id = 0,
    name = "",
    enter_pos = vector3(0, 0, 0),
    data = {},
    inventory = {},
    garage = {},
    owner = 0,
    type = "",
    co_owner = {},
    rentedAt = 0,
    rentalEnd = 0,
    crew = '',
    weight = 0,
    needs_save = false
}
property.__index = property

---@return property
function property:new(data)
    local self = setmetatable({}, property)
    self.id = data.id or 0
    self.name = data.name or ""
    self.enter_pos = data.enter_pos or vector3(0, 0, 0)
    self.data = data.data or {}
    self.inventory = data.inventory or {}
    self.garage = data.garage or {}
    self.owner = data.owner
    self.type = data.type or "Individuel"
    self.co_owner = data.co_owner or {}
    self.rentedAt = data.rentedAt or 0
    self.rentalEnd = data.rentalEnd or 0
    self.crew = data.crew or ''
    self.weight = data.weight or 0
    self.owner_fullname = data.owner_fullname or "Inconnu"
    self.needs_save = false
    return self
end

function property:_id(id)
    if id then
        self.id = id
        self.needs_save = true
    end
    return self.id
end

function property:_name(name)
    if name then
        self.name = name
        self.needs_save = true
    end
    return self.name
end


function property:_enter_pos(enter_pos)
    if enter_pos then
        self.enter_pos = enter_pos
        self.needs_save = true
    end
    return self.enter_pos
end

function property:getEnterPos()
    return self.enter_pos
end

function property:_data(data)
    if data then
        self.data = data
        self.needs_save = true
    end
    return self.data
end

function property:_inventory(inventory)
    if inventory then
        self.inventory = inventory
        self.needs_save = true
    end
    return self.inventory
end

function property:_garage(garage)
    if garage then
        self.garage = garage
        self.needs_save = true
    end
    return self.garage
end

function property:_owner(owner)
    if owner then
        self.owner = owner
        self.needs_save = true
    end
    return self.owner
end

function property:_owner_fullname(owner_fullname)
    if owner_fullname then
        self.owner_fullname = owner_fullname
    end
    return self.owner_fullname
end

-- The _ is to avoid conflict with the lua keyword type
function property:_type(_type)
    if _type then
        self.type = _type
        self.needs_save = true
    end
    return self.type
end

function property:_co_owner(co_owner)
    if co_owner then
        self.co_owner = co_owner
        self.needs_save = true
    end
    return self.co_owner
end

function property:_rentedAt(rentedAt)
    if rentedAt then
        self.rentedAt = rentedAt
        self.needs_save = true
    end
    return self.rentedAt
end

function property:_rentalEnd(_rentalEnd)
    if _rentalEnd then
        self.rentalEnd = _rentalEnd
        self.needs_save = true
    end
    return self.rentalEnd
end

function property:_crew(crew)
    if crew then
        self.crew = crew
        self.needs_save = true
    end
    return self.crew
end

function property:_weight(weight)
    if weight then
        self.weight = weight
        self.needs_save = true
    end
    return self.weight
end

function property:UpdateDoorState(state)
    local data = self:_data()
    data.doorState = state
    self:_data(data)
    return data.doorState
end

function property:AddCoOwner(id)
    local co_owner = self:_co_owner()
    table.insert(co_owner, id)
    self:_co_owner(co_owner)
    return co_owner
end

function property:RemoveCoOwner(id)
    local co_owner = self:_co_owner()
    for k, v in pairs(co_owner) do
        if v == id then
            table.remove(co_owner, k)
            break
        end
    end
    self:_co_owner(co_owner)
    return self.co_owner
end

function property:EmptyMailbox()
    local data = self:_data()
    data.mailbox = {}
    self:_data(data)
    return data.mailbox
end

function property:UpdateRentDuration(duration)
    -- self.rentalEnd is a timestamp
    -- duration is in days
    local rentalEnd = self:_rentalEnd()
    rentalEnd = rentalEnd + (duration * 86400)
    self:_rentalEnd(rentalEnd)
    return rentalEnd
end

function property:AddInventoryItemProperty(item)
    local inventory = self:_inventory()
    local found = false
    -- if item is already in inventory, add to quantity
    for k, v in pairs(inventory) do
        if v.name == item.name then
            -- if item has metadatas, check if they are the same
            --if CompareItemMetadatas(v.metadatas, item.metadatas) then
            if CompareMetadatas(v.metadatas, item.metadatas) then
                v.count = v.count + item.count
                found = true
            end
            break
        end
    end
    -- else add item to inventory
    if not found then
        table.insert(inventory, item)
    end
    -- Then save it
    self:_inventory(inventory)
    return inventory
end

function property:RemoveInventoryItemProperty(item)
    local inventory = self:_inventory()
    for k, v in pairs(inventory) do
        if v.name == item.name then
           --if CompareItemMetadatas(v.metadatas, item.metadatas) then
            if CompareMetadatas(v.metadatas, item.metadatas) then
                if v.count - item.count < 0 then 
                    return false
                elseif v.count - item.count == 0 then
                    table.remove(inventory, k)
                end
                v.count = v.count - item.count
                self:_inventory(inventory)
                return true
            end
        end
    end
    return false
end

function property:HasInventoryItemProperty(item)
    local inventory = self:_inventory()
    for k, v in pairs(inventory) do
        if v.name == item.name then
            if CompareMetadatas(v.metadatas, item.metadatas) then
                if v.count - item.count >= 0 then
                    return true
                end
            end
        end
    end
    return false
end

function property:AddVehicle(vehicle)
    local garage = self:_garage()
    table.insert(garage, vehicle)
    self:_garage(garage)
    return garage
end

function property:RemoveVehicle(vehicle)
    local garage = self:_garage()
    for k, v in pairs(garage) do
        if json.decode(v) == nil or type(json.decode(v)) ~= "table" then
            if v == vehicle then
                table.remove(garage, k)
                break
            end
        else
            v = json.decode(v)
            if v.props.plate == vehicle then
                table.remove(garage, k)
                break
            end
        end
    end
    self:_garage(garage)
    return garage
end

function property:AddItemToMailBox(item)
    local data = self:_data()

    if not data.mailbox then
        data.mailbox = {}
    end

    for k, v in pairs(data.mailbox) do
        if v.name == item.name then
            if CompareMetadatas(v.metadatas, item.metadatas) then
            --if CompareItemMetadatas(v.metadatas, item.metadatas) then
                v.count = v.count + item.count
                self:_data(data)
                return data.mailbox
            end
        end
    end

    table.insert(data.mailbox, item)

    self:_data(data)

    return data.mailbox
end



-- Compare item metadatas
function CompareItemMetadatas(metadata, metadata2)
    if metadata == nil or metadata2 == nil then
        return false
    end
    if #metadata ~= #metadata2 then
        return false
    end
    for k, v in pairs(metadata) do        
        if v ~= metadata2[k] then
            return false
        end
    end
    return true
end