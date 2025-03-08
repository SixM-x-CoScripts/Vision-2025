properties = {} ---@type property

local loadedProperties = false

MySQL.ready(function()
    -- get all properties joined with the players table to get the concatenation of firstname and lastname
    MySQL.Async.fetchAll("SELECT property.*, CONCAT(players.firstname, ' ', players.lastname) AS owner_name FROM property LEFT JOIN players ON property.owner = players.id", {}, function(result)
        for _, prop in pairs(result) do
            if prop then
                local property = property:new({
                    id = prop.id,
                    name = prop.name,
                    enter_pos = json.decode(prop.enter_pos),
                    data = json.decode(prop.data),
                    inventory = json.decode(prop.inventory),
                    garage = json.decode(prop.garage),
                    co_owner = json.decode(prop.co_owner),
                    owner = prop.owner,
                    type = prop.type,
                    rentedAt = prop.rentedat,
                    rentalEnd = prop.rentalEnd,
                    crew = prop.crew,
                    weight = prop.weight,
                    owner_fullname = prop.owner_name
                }, true)
                if prop.id then
                    properties[prop.id] = property
                    local propdata = json.decode(prop.data)
                    GlobalState["propertyDoorState_"..tostring(prop.id)] = false
                end
            end
        end
        CorePrint("Loaded all properties")
        loadedProperties = true
    end)
end)

CreateThread(function()
    while true do
        Wait(60000)
        for _, prop in pairs(properties) do
            if prop.rentalEnd and (((tonumber(prop.rentalEnd) - os.time())/86400) < -7.0) then
                DeleteProperty(prop.id)
            end
            if prop.needs_save == true then
                MySQL.Async.execute("UPDATE property SET name = @name, enter_pos = @enter_pos, data = @data, inventory = @inventory, garage = @garage, owner = @owner, `type` = @_type, rentedat = @rentedAt, rentalEnd = @rentalEnd, crew = @crew, weight = @weight, co_owner = @co_owner WHERE id = @id", {
                    ["@id"] = prop.id,
                    ["@name"] = prop.name,
                    ["@enter_pos"] = json.encode(prop.enter_pos),
                    ["@data"] = json.encode(prop.data),
                    ["@inventory"] = json.encode(prop.inventory),
                    ["@garage"] = json.encode(prop.garage),
                    ["@owner"] = prop.owner,
                    ["@_type"] = prop.type,
                    ["@rentedAt"] = prop.rentedAt,
                    ["@rentalEnd"] = prop.rentalEnd,
                    ["@crew"] = prop.crew,
                    ["@weight"] = prop.weight,
                    ["@co_owner"] = json.encode(prop.co_owner)
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        prop.needs_save = false
                    end
                end)
                Wait(1000)
            end
        end
    end
end)

---@return property
function GetProperty(id)
    return properties[id]
end

function RemoveProperty(id)
    properties[id] = nil
    GlobalState["propertyDoorState_"..tostring(id)] = nil
end

function AllProperties()
    return properties
end

-- function AllPropertiesOnlyNecessaryData()
--     local props = {}
--     for _, prop in pairs(properties) do
--         table.insert(props, {
--             id = prop.id,
--             enter_pos = prop.enter_pos,
--             owner = prop.owner,
--             type = prop.type,
--             co_owner = prop.co_owner,
--             data = { type = prop.data.type },
--             name = prop.name,
--             crew = prop.crew,
--             rentalEnd = prop.rentalEnd,
--         })
--     end
--     return props
-- end

-- Maybe one day, do it by zone
function AllPropertiesOnlyNecessaryData()
    local timer = 1
    local hasWaited = false
    while not loadedProperties and timer < 200 do Wait(200) timer += 1 hasWaited = true end
    if hasWaited then 
        CorePrint("A player has waited to have all properties ! ^1Slow SQL !^7")
    end
    local props = {}
    for _, prop in pairs(properties) do
        table.insert(props, {
            id = prop.id,
            owner = prop.owner,
            type = prop.type,
            crew = prop.crew,
            enter_pos = prop.enter_pos,
            name = prop.name,
            typeint = prop.data.type,
            co_owner = prop.co_owner,
        })
    end
    return props
end

function getAllPropertiesCrew(crew)
    local props = {}
    for _, prop in pairs(properties) do
        if prop.crew == crew then
            table.insert(props, {
                id = prop.id,
                enter_pos = prop.enter_pos,
                type = prop.data.type,
                name = prop.name,
            })
        end
    end
    return props
end

function getAllPropertiesPlayer(owner)
    local props = {}
    for _, prop in pairs(properties) do
        if prop.owner == owner then
            table.insert(props, {
                id = prop.id,
                enter_pos = prop.enter_pos,
                type = prop.data.type,
                name = prop.name,
                locked = prop.doorState
            })
        end
    end
    return props
end

-- function to get all the plates for vehiicle_handler
function AllPropertiesPlate()
    local props = {}
    for _, prop in pairs(properties) do
        if prop.data.type == "garage" then
            for _, plate in pairs(prop.garage) do
                table.insert(props, plate)
            end
        end
    end
    return props
end

-- Here i'm forced to insert it in database directly because i need the id of the property
function CreateProperty(prop) ---@return property

    local time = os.time()
    local created_property = property:new({
        id = MySQL.Sync.insert("INSERT INTO property (name, enter_pos, data, weight, owner, type, rentedAt, rentalEnd, crew) \
            VALUES (@name, @enter_pos, @data, @weight, @owner, @type, @rentedAt, @rentalEnd, @crew)",
        {
            ["@name"] = prop.name,
            ["@enter_pos"] = json.encode(prop.enter_pos),
            ["@data"] = json.encode(prop.data),
            ["@weight"] = prop.weight,
            ["@owner"] = prop.owner,
            ["@type"] = "Individuel",
            ["@rentedAt"] = time,
            ["@rentalEnd"] = time + (prop.data.duration * 86400),
            ["@crew"] = "NULL"
        }),
        name = prop.name,
        enter_pos = prop.enter_pos,
        data = prop.data,
        inventory = {},
        garage = {},
        owner = prop.owner,
        co_owner = {},
        type = "Individuel",
        rentedAt = time,
        rentalEnd = time + (prop.data.duration * 86400),
        crew = "",
        weight = prop.weight
    }, true)

    properties[created_property.id] = created_property
    GlobalState["propertyDoorState_"..created_property.id] = false
    return created_property
end

function DeleteProperty(id)
    MySQL.Async.execute("DELETE FROM property WHERE id = @id", {
        ["@id"] = id
    }, function(rowsChanged)
        if rowsChanged > 0 then
            RemoveProperty(id)
        end
    end)
end

local AllUsingCoffreProp = {}

RegisterServerCallback("core:property:IsUsingCoffre", function(source, token, id)
    local fuund
    if CheckPlayerToken(source, token) then 
        for i, v in ipairs(AllUsingCoffreProp) do 
            if v.id == id then
                fuund = v.using
            end
        end
    end
    return fuund
end)

RegisterServerCallback("core:property:getInteriorType", function(source, propId)
    local prop = GetProperty(propId)
    if prop then
        return prop.data.type
    end
    return nil
end)

RegisterServerCallback("core:property:getInterior", function(source, propId)
    local prop = GetProperty(propId)
    if prop then
        return prop.data.interior
    end
    return nil
end)

-- get property owner
RegisterServerCallback("core:property:getOwner", function(source, propId)
    local prop = GetProperty(propId)
    if prop then
        return prop.owner
    end
    return nil
end)

-- core:property:getType
RegisterServerCallback("core:property:getType", function(source, propId)
    local prop = GetProperty(propId)
    if prop then
        return prop.type
    end
    return nil
end)

-- core:property:getCrew
RegisterServerCallback("core:property:getCrew", function(source, propId)
    local prop = GetProperty(propId)
    if prop then
        return prop.crew
    end
    return nil
end)

-- core:property:getOwnerFullname
RegisterServerCallback("core:property:getOwnerFullname", function(source, propId)
    local prop = GetProperty(propId)
    if prop then
        return prop.owner_fullname
    end
    return nil
end)

-- core:property:getRentalEnd
RegisterServerCallback("core:property:getRentalEnd", function(source, propId)
    local prop = GetProperty(propId)
    if prop then
        return prop.rentalEnd
    end
    return nil
end)

-- core:property:getName
RegisterServerCallback("core:property:getName", function(source, propId)
    local prop = GetProperty(propId)
    if prop then
        return prop.name
    end
    return nil
end)

RegisterNetEvent("core:property:setUsingCoffre", function(token, id, bool)
    local source = source
    if CheckPlayerToken(source, token) then 
        if bool then 
            table.insert(AllUsingCoffreProp, {using = true, id = id, src = source})
        else
            for i, v in ipairs(AllUsingCoffreProp) do 
                if v.id == id then
                    table.remove(AllUsingCoffreProp, i)
                end
            end
        end
    end
end)

AddEventHandler("playerDropped", function()
    local src = source 
    for i, v in ipairs(AllUsingCoffreProp) do 
        if v.src == src then
            table.remove(AllUsingCoffreProp, i)
        end
    end
end)

-- function IsVehicleInGarage(plate)
--     for _, prop in pairs(properties) do
--         if prop.data.type == "garage" then
--             for _, veh in pairs(prop.garage) do
--                 if json.decode(veh) == nil or type(json.decode(veh)) ~= "table" then 
--                     if veh == plate then
--                         return true
--                     end
--                 else
--                     veh = json.decode(veh)
--                     if veh ~= nil and veh ~= 0 and veh.props ~= nil and veh.props.plate ~= nil then
--                         if veh.props.plate == plate then
--                             return true
--                         end
--                     end
--                 end
--             end
--         end
--     end
--     return false
-- end

CreateThread(function()
    while RegisterServerCallback == nil do Wait(0) end

    RegisterServerCallback('core:getPropertyCrew', function(source, crewName)
        return getAllPropertiesCrew(crewName)
    end)

    RegisterServerCallback("core:getPropertyPlayer", function(source)
        return GetPlayer(source) and getAllPropertiesPlayer(GetPlayer(source):GetId()) or {}
    end)

    RegisterServerCallback("core:getPropertyPosition", function(source, propid)
        return GetProperty(propid):getEnterPos()
    end)
end)