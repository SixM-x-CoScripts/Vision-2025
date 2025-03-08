function loadAllCasier()
    MySQL.Async.fetchAll("SELECT * FROM casier", {}, function(result)
        local casier
        for k, v in pairs(result) do
            casier = casierClass:new(v)
        end

    end)
end
MySQL.ready(function()
    Wait(1000)
    loadAllCasier()
end)

function createCasier(c) ---@return casier
    local casier = casierClass:new({
        id = MySQL.Sync.insert("INSERT INTO casier (num, job, inventory) VALUES (@num, @job, @inventory)", {
            ['num'] = c.num,
            ['job'] = c.job,
            ['inventory'] = json.encode({}),
        }),
        num = c.num,
        job = c.job,
        inventory = json.encode({})
    })
    return casier
end

function addItemInventoryCasier(casierId, itemName, count, metadatas, src)
    local source = src
    casierId:addInventoryItemCasier(itemName, count, metadatas)
    SendDiscordLog("casier", source, string.sub(GetDiscord(source), 9, -1),
        GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(),
        GetPlayer(source):getJob(), "La personne a **ajouté** l'item " .. itemName .. " du casier n°" .. casierId:getNum() .. " pour le job " .. casierId:getJob())
    return true
end

function removeItemInventoryCasier(casierId, itemName, count, metadatas, src)
    local source = src
    casierId:removeInventoryItemCasier(itemName, count, metadatas)
    SendDiscordLog("casier", source, string.sub(GetDiscord(source), 9, -1),
        GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(),
        GetPlayer(source):getJob(), "La personne a **retiré** l'item " .. itemName .. " du casier n°" .. casierId:getNum() .. " pour le job " .. casierId:getJob())
    return true
end

--trigger event
RegisterNetEvent("core:casier:addItem")
AddEventHandler("core:casier:addItem", function(source, token, job, num, itemName, count, metadatas)
    local source = source
    if not CheckPlayerToken(source, token) then return end
    return addItemInventoryCasier(GetCasierFromNumJob(num, job), itemName, count, metadatas, source)
end)

RegisterNetEvent("core:casier:removeItem")
AddEventHandler("core:casier:removeItem", function(source, token, job, num, itemName, count, metadatas)
    if not CheckPlayerToken(source, token) then return end
    return removeItemInventoryCasier(GetCasierFromNumJob(num, job), itemName, count, metadatas, source)
end)

function ClearCasierInventory(job) 
    if job == nil then return end
    local casiers = GetAllCasiersByJob(job)
    if casiers == nil then return end
    for k, v in pairs(casiers) do
        v:setInventory({})
    end
    print("Casier "..job.."inventory cleared")
    return true
end



--server callback
CreateThread(function()
    -- Wait for coffres and functions to be loaded
    Wait(3000)

    RegisterServerCallback("core:casier:getOneCasier", function(source, token, job, num)
        if not CheckPlayerToken(source, token) then return end
        local casier = GetCasierFromNumJob(num, job)
        if casier == nil then casier = createCasier({num = num, job = job}) end
        return casier
    end)

    RegisterServerCallback("core:casier:addItem", function(source, token, job, num, itemName, count, metadatas)
        local source = source
        if not CheckPlayerToken(source, token) then return end
        return addItemInventoryCasier(GetCasierFromNumJob(num, job), itemName, count, metadatas, source)
    end)

    RegisterServerCallback("core:casier:removeItem", function(source, token, job, num, itemName, count, metadatas)
        local source = source
        if not CheckPlayerToken(source, token) then return end
        return removeItemInventoryCasier(GetCasierFromNumJob(num, job), itemName, count, metadatas, source)
    end)
end)

--save casier
CreateThread(function()
    while true do
        Wait(55000)
        for _, c in pairs(GetAllCasiers()) do
            if c.needSave == true then
                c:updateCasier()
                Wait(1000)
            end
        end
    end
end)

-- resource stop

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        CorePrint("Resource stopping, saving crew.")
        for k, v in pairs(GetAllCasiers()) do
            v:updateCasier()
        end
    end
end)