if Config.HouseScript ~= "qs-housing" then
    return
end

local function getNameFromIdentifier(identifier)
    if Config.Framework == "esx" then
        local name = MySQL.Sync.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", {
            ["@identifier"] = identifier
        })

        if name and name[1]?.firstname and name[1]?.lastname then
            return name[1].firstname .. " " .. name[1].lastname
        end
    elseif Config.Framework == "qb" then
        local charinfo = MySQL.Sync.fetchAll("SELECT charinfo FROM players WHERE citizenid = @identifier", {
            ["@identifier"] = identifier
        })

        if charinfo and charinfo[1]?.charinfo then
            charinfo = json.decode(charinfo[1].charinfo)
            if charinfo.firstname and charinfo.lastname then
                return charinfo.firstname .. " " .. charinfo.lastname
            end
        end
    end

    return identifier
end

local function formatKeyholders(keyholders)
    local formatted = {}

    for i = 1, #keyholders do
        local identifier = keyholders[i]
        formatted[#formatted + 1] = {
            identifier = identifier,
            name = getNameFromIdentifier(identifier)
        }
    end

    return formatted
end

lib.RegisterCallback("phone:home:getOwnedHouses", function(source, cb)
    local identifier = GetIdentifier(source)
    local identifierColumn = Config.Framework == "esx" and "identifier" or "citizenid"
    local formattedHouses = {}
    local houses = MySQL.Sync.fetchAll(([[
        SELECT 
            ph.house, ph.houseId, ph.keyholders, hl.label, hl.coords
        FROM player_houses ph
        JOIN houselocations hl ON hl.houseID = ph.houseID
        WHERE ph.%s = @identifier
    ]]):format(identifierColumn), {
        ["@identifier"] = identifier
    })

    for i = 1, #houses do
        local house = houses[i]
        house.keyholders = house.keyholders and json.decode(house.keyholders) or {}
        if type(house.keyholders) ~= "table" then
            house.keyholders = {}
        end

        formattedHouses[#formattedHouses + 1] = {
            label = house.label,
            keyholders = formatKeyholders(house.keyholders),
            id = tonumber(house.houseId),
            uniqueId = house.house,

            coords = house.coords
        }
    end

    cb(formattedHouses)
end)

lib.RegisterCallback("phone:home:getKeyholders", function(source, cb, house)
    local identifierColumn = Config.Framework == "esx" and "identifier" or "citizenid"
    local keyholders = MySQL.Sync.fetchScalar("SELECT keyholders FROM player_houses WHERE house = @house AND " .. identifierColumn .. " = @identifier", {
        ["@house"] = house,
        ["@identifier"] = GetIdentifier(source)
    })

    if not keyholders then
        return cb(false)
    end

    keyholders = json.decode(keyholders)

    cb(formatKeyholders(keyholders))
end)

lib.RegisterCallback("phone:home:removeKeyholder", function(source, cb, house, identifier)
    if identifier == GetIdentifier(source) or not house then
        return cb(false)
    end

    local identifierColumn = Config.Framework == "esx" and "identifier" or "citizenid"
    local keyholders = MySQL.Sync.fetchScalar("SELECT keyholders FROM player_houses WHERE house = @house AND " .. identifierColumn .. " = @identifier", {
        ["@house"] = house,
        ["@identifier"] = GetIdentifier(source)
    })

    if not keyholders then
        return cb(false)
    end

    keyholders = json.decode(keyholders)

    local removed = false
    for i = 1, #keyholders do
        if keyholders[i] == identifier then
            table.remove(keyholders, i)
            removed = true
            break
        end
    end

    if not removed then
        return cb(false)
    end

    MySQL.Async.execute("UPDATE player_houses SET keyholders = @keyholders WHERE house = @house AND " .. identifierColumn .. " = @identifier", {
        ["@keyholders"] = json.encode(keyholders),
        ["@house"] = house,
        ["@identifier"] = GetIdentifier(source)
    })

    cb(formatKeyholders(keyholders))
end)

lib.RegisterCallback("phone:home:addKeyholder", function(source, cb, house, addSource)
    if addSource == source or not house then
        return cb(false)
    end

    local addIdentifier = GetIdentifier(addSource)
    if not addIdentifier then
        return cb(false)
    end

    local identifierColumn = Config.Framework == "esx" and "identifier" or "citizenid"
    local keyholders = MySQL.Sync.fetchScalar("SELECT keyholders FROM player_houses WHERE house = @house AND " .. identifierColumn .. " = @identifier", {
        ["@house"] = house,
        ["@identifier"] = GetIdentifier(source)
    })

    if not keyholders then
        return cb(false)
    end

    keyholders = json.decode(keyholders)

    if contains(keyholders, addIdentifier) then
        return cb(false)
    end

    keyholders[#keyholders + 1] = addIdentifier

    MySQL.Async.execute("UPDATE player_houses SET keyholders = @keyholders WHERE house = @house AND " .. identifierColumn .. " = @identifier", {
        ["@keyholders"] = json.encode(keyholders),
        ["@house"] = house,
        ["@identifier"] = GetIdentifier(source)
    })

    cb(formatKeyholders(keyholders))
end)
