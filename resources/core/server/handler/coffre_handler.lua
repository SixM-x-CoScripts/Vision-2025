chests = {} ---@type coffre

CreateThread(function()
    Wait(3000)
    MySQL.Async.fetchAll("SELECT * FROM coffre", {}, function(result)
        for _, c in pairs(result) do
            chests[c.id] = chest:new({
                id = c.id,
                name = c.name,
                pos = c.pos,
                inventory = c.inventory,
                weight = c.weight,
                code = c.code
            }, true)
        end
    end)

    while true do
        Wait(50000)
        for _, c in pairs(chests) do
            if c.needs_save == true then
                MySQL.Async.execute("UPDATE `coffre` SET `name`=@name,`pos`=@pos,`inventory`=@inventory,`weight`=@weight,`code`=@code WHERE id=@id", {
                    ["@id"] = c.id,
                    ["@name"] = c.name,
                    ["@pos"] = json.encode(c.pos),
                    ["@inventory"] = json.encode(c.inventory),
                    ["@weight"] = c.weight,
                    ["@code"] = c.code
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        c.needs_save = false
                    end
                end)
                Wait(1000)
            end
        end
    end
end)

---@return chest
function GetCoffre(id)
    return chests[id]
end

function RemoveCoffre(id)
    chests[id] = nil
end

function AllCoffres()
    return chests
end

function AllCoffresOnlyNecessaryData()
    local c = {}
    for _, _coffre in pairs(chests) do
        table.insert(c, {
            id = _coffre.id,
            pos = _coffre.pos,
            code = _coffre.code
        })
    end
    return c
end

-- Here i'm forced to insert it in database directly because i need the id of the property
function CreateCoffre(c) ---@return chest

    local created_coffre = chest:new({
        id = MySQL.Sync.insert("INSERT INTO coffre (name, pos, inventory, weight, code) VALUES (@name, @pos, @inventory, @weight, @code)", {
            ["@name"] = c.name,
            ["@pos"] = json.encode(c.pos),
            ["@inventory"] = json.encode({}),
            ["@weight"] = c.weight,
            ["@code"] = c.code
        }),
        name = c.name,
        pos = json.encode(c.pos),
        inventory = json.encode({}),
        weight = c.weight,
        code = c.code
    }, true)

    chests[created_coffre.id] = created_coffre

    return created_coffre
end

function DeleteCoffre(id)
    MySQL.Async.execute("DELETE FROM coffre WHERE id = @id", {
        ["@id"] = id
    }, function(rowsChanged)
        if rowsChanged > 0 then
            RemoveCoffre(id)
        end
    end)
end