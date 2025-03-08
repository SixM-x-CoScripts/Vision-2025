local Config = {
    VehiclesToRemove = {
        -- {model = "model", compensation = 100000, refund = "money"},
        -- {model = "model", compensation = 1000, refund = "vcoins"},

        {model = "citi", compensation = 7150, refund = "money"},
        {model = "acknodlow", compensation = 31000, refund = "money"},
        {model = "bf900", compensation = 117000, refund = "money"},
        {model = "dyna", compensation = 61000, refund = "money"},
        {model = "dyne", compensation = 71000, refund = "money"},
        {model = "enforcer", compensation = 62000, refund = "money"},
        {model = "lpbagger", compensation = 32000, refund = "money"},
        {model = "lpchopper", compensation = 143000, refund = "money"},
        {model = "na25", compensation = 57000, refund = "money"},
        {model = "softail1", compensation = 25000, refund = "money"},
        {model = "sombrero", compensation = 66000, refund = "money"},
        {model = "spirit1", compensation = 46000, refund = "money"},
        {model = "templar", compensation = 52000, refund = "money"},
        {model = "trig", compensation = 29000, refund = "money"},
        {model = "crowdrunner", compensation = 123000, refund = "money"},
        {model = "eudorac", compensation = 67000, refund = "money"},
        {model = "gauntlet4c", compensation = 322000, refund = "money"},
        {model = "jdvigerord", compensation = 650000, refund = "money"},
        {model = "ratdemon", compensation = 180000, refund = "money"},
        {model = "savannasa", compensation = 21000, refund = "money"},
        {model = "bfbenito", compensation = 34460, refund = "money"},
        {model = "bobcatxl3", compensation = 98000, refund = "money"},
        {model = "gstyosemite1", compensation = 302460, refund = "money"},
        {model = "mesaxl", compensation = 170000, refund = "money"},
        {model = "riatao", compensation = 124000, refund = "money"},
        {model = "terl300", compensation = 280000, refund = "money"},
        {model = "panoramab", compensation = 22000, refund = "money"},
        {model = "panoramas", compensation = 103000, refund = "money"},
        {model = "20fttrailer", compensation = 65000, refund = "money"},
        {model = "sr510", compensation = 470203.5, refund = "money"},
        {model = "yacht2", compensation = 442068, refund = "money"},
        {model = "peacemaker", compensation = 123500, refund = "money"},
        {model = "auroras", compensation = 1250680, refund = "money"},
        {model = "auroras2", compensation = 1250680, refund = "money"},
        {model = "cycloneex0", compensation = 1144000, refund = "money"},
        {model = "italirsxrod", compensation = 1144000, refund = "money"},
        {model = "osirisfr", compensation = 1210460, refund = "money"},
        {model = "tempestafr", compensation = 1230820, refund = "money"},
        {model = "turismoc", compensation = 403000, refund = "money"},
        {model = "turismocs", compensation = 585000, refund = "money"},
        {model = "stardust", compensation = 227500, refund = "money"},
        {model = "swindler", compensation = 97000, refund = "money"},
        {model = "weevilf6", compensation = 84000, refund = "money"},
        {model = "asteropers", compensation = 299000, refund = "money"},
        {model = "as_zr350", compensation = 317050, refund = "money"},
        {model = "bansheeas", compensation = 431000, refund = "money"},
        {model = "buffalo4h", compensation = 357120, refund = "money"},
        {model = "comet3s", compensation = 317730, refund = "money"},
        {model = "contenderc", compensation = 192000, refund = "money"},
        {model = "elegy4", compensation = 357000, refund = "money"},
        {model = "hachurac", compensation = 260000, refund = "money"},
        {model = "jd_oraclev12", compensation = 123500, refund = "money"},
        {model = "komodafr", compensation = 310000, refund = "money"},
        {model = "paragonxr", compensation = 338000, refund = "money"},
        {model = "remusvert", compensation = 87100, refund = "money"},
        {model = "rh82", compensation = 350000, refund = "money"},
        {model = "roxanne", compensation = 233325, refund = "money"},
        {model = "sentinelsg4d", compensation = 211000, refund = "money"},
        {model = "taranis", compensation = 230000, refund = "money"},
        {model = "zr390", compensation = 245000, refund = "money"},

        {model = "patriots2", compensation = 2000, refund = "vcoins"},
    },
    ItemsToRemove = {
        -- {item = "item", compensation = 100, refund = "money"},
    },
    
    
    VehicleTable = "vehicles",
    UserTable = "players",
    InventoryTable = "players",
    InventoryColumn = "inventaire",
    UserIDColumn = "id",
    UniqueTable = "players_unique",
    LicenseColumn = "license",
    BalanceColumn = "balance",
    BatchSize = 1000
}

local scriptActive = false
local vehiclesProcessed = 0
local itemsProcessed = 0

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    if scriptActive then
        deferrals.defer()
        deferrals.done("Le serveur est actuellement en maintenance. Veuillez réessayer plus tard.")
    end
end)

local function removeVehiclesAndCompensate()
    vehiclesProcessed = 0
    local totalVehicles = #Config.VehiclesToRemove

    for _, vehicleConfig in ipairs(Config.VehiclesToRemove) do
        local model = vehicleConfig.model
        local compensation = vehicleConfig.compensation
        local refundItem = vehicleConfig.refund

        MySQL.Async.fetchAll('SELECT owner FROM ' .. Config.VehicleTable .. ' WHERE name = ?', {model}, function(owners)
            local userCompensation = {}

            for _, ownerData in ipairs(owners) do
                local ownerId = ownerData.owner
                if not userCompensation[ownerId] then
                    userCompensation[ownerId] = 0
                end
                userCompensation[ownerId] = userCompensation[ownerId] + compensation
            end

            MySQL.Async.execute('DELETE FROM ' .. Config.VehicleTable .. ' WHERE name = ?', {model}, function(affectedRows)
                print('Véhicules ' .. model .. ' retirés : ' .. affectedRows)

                for userId, totalCompensation in pairs(userCompensation) do
                    MySQL.Async.fetchAll('SELECT ' .. Config.InventoryColumn .. ', ' .. Config.LicenseColumn .. ' FROM ' .. Config.UserTable .. ' WHERE ' .. Config.UserIDColumn .. ' = ?', {userId}, function(result)
                        local inventoryData = result[1][Config.InventoryColumn]
                        local userLicense = result[1][Config.LicenseColumn]

                        local inventory = {}
                        if inventoryData and inventoryData ~= '' then
                            inventory = json.decode(inventoryData)
                            if not inventory then
                                print('Erreur: L\'inventaire de l\'utilisateur ' .. userId .. ' est mal formaté.')
                                inventory = {}
                            end
                        end

                        if refundItem == "vcoins" then
                            MySQL.Async.fetchAll('SELECT ' .. Config.BalanceColumn .. ' FROM ' .. Config.UniqueTable .. ' WHERE ' .. Config.LicenseColumn .. ' = ?', {userLicense}, function(balanceResult)
                                if #balanceResult > 0 then
                                    local currentBalance = balanceResult[1][Config.BalanceColumn] or 0
                                    local newBalance = currentBalance + totalCompensation

                                    MySQL.Async.execute('UPDATE ' .. Config.UniqueTable .. ' SET ' .. Config.BalanceColumn .. ' = ? WHERE ' .. Config.LicenseColumn .. ' = ?', {newBalance, userLicense}, function()
                                        print('Compensation de ' .. totalCompensation .. ' vCoins ajoutée à l\'utilisateur ' .. userId)
                                    end)
                                end
                            end)
                        else
                            local found = false
                            for _, item in ipairs(inventory) do
                                if item.name == refundItem then
                                    item.count = item.count + totalCompensation
                                    found = true
                                    break
                                end
                            end

                            if not found then
                                table.insert(inventory, {name = refundItem, count = totalCompensation})
                            end

                            MySQL.Async.execute('UPDATE ' .. Config.UserTable .. ' SET ' .. Config.InventoryColumn .. ' = ? WHERE ' .. Config.UserIDColumn .. ' = ?', {json.encode(inventory), userId})
                            print('Compensation de ' .. totalCompensation .. ' ' .. refundItem .. ' ajoutée à l\'utilisateur ' .. userId)
                        end
                    end)
                end
                if vehiclesProcessed < totalVehicles then vehiclesProcessed = vehiclesProcessed + 1 end
                if vehiclesProcessed == totalVehicles then
                    print('Tous les véhicules configurés ont été retirés et les utilisateurs ont été compensés.')
                end
            end)
        end)
    end
end

local function removeItemsAndCompensate()
    local offset = 0
    itemsProcessed = 0
    local totalItems = #Config.ItemsToRemove

    local function processBatch()
        MySQL.Async.fetchAll('SELECT ' .. Config.UserIDColumn .. ', ' .. Config.InventoryColumn .. ' FROM ' .. Config.InventoryTable .. ' LIMIT ? OFFSET ?', {Config.BatchSize, offset}, function(inventories)
            if #inventories > 0 then
                for _, inventoryData in ipairs(inventories) do
                    local userId = inventoryData[Config.UserIDColumn]
                    local inventoryDataRaw = inventoryData[Config.InventoryColumn]

                    local inventory = {}
                    if inventoryDataRaw and inventoryDataRaw ~= '' then
                        inventory = json.decode(inventoryDataRaw)
                        if not inventory then
                            print('Erreur: L\'inventaire de l\'utilisateur ' .. userId .. ' est mal formaté.')
                            inventory = {}
                        end
                    end

                    local compensationDetails = {}

                    for _, itemConfig in ipairs(Config.ItemsToRemove) do
                        local itemToRemove = itemConfig.item
                        local itemCount = 0

                        for i = #inventory, 1, -1 do
                            if inventory[i].name == itemToRemove then
                                itemCount = inventory[i].count
                                table.remove(inventory, i)
                                break
                            end
                        end

                        if itemCount > 0 then
                            if not compensationDetails[itemConfig.refund] then
                                compensationDetails[itemConfig.refund] = 0
                            end
                            compensationDetails[itemConfig.refund] = compensationDetails[itemConfig.refund] + (itemCount * itemConfig.compensation)
                            print('Removed ' .. itemCount .. ' of ' .. itemToRemove .. ' from user ' .. userId)
                        end
                    end

                    if next(compensationDetails) ~= nil then
                        for refundItem, totalCompensation in pairs(compensationDetails) do
                            local found = false

                            for _, item in ipairs(inventory) do
                                if item.name == refundItem then
                                    item.count = item.count + totalCompensation
                                    found = true
                                    break
                                end
                            end

                            if not found then
                                table.insert(inventory, {name = refundItem, count = totalCompensation})
                            end

                            print('Added total compensation of ' .. totalCompensation .. ' ' .. refundItem .. ' to user ' .. userId)
                        end

                        MySQL.Async.execute('UPDATE ' .. Config.InventoryTable .. ' SET ' .. Config.InventoryColumn .. ' = ? WHERE ' .. Config.UserIDColumn .. ' = ?', {json.encode(inventory), userId})
                    end
                end

                offset = offset + Config.BatchSize
                processBatch()
            else
                if itemsProcessed < totalItems then itemsProcessed = itemsProcessed + 1 end
                if itemsProcessed == totalItems then
                    print('Tous les objets configurés ont été retirés et les utilisateurs ont été compensés.')
                end
            end
        end)
    end
    processBatch()
end

scriptActive = true

print("Le script est actif. Les véhicules et les objets configurés seront retirés et les utilisateurs seront compensés au démarrage du serveur dans 10 secondes.")

Citizen.Wait(10000)

removeVehiclesAndCompensate()
removeItemsAndCompensate()

Citizen.CreateThread(function()
    while scriptActive do
        Citizen.Wait(1000)
        print('Véhicules traités : ' .. vehiclesProcessed .. ' / ' .. #Config.VehiclesToRemove)
        print('Objets traités : ' .. itemsProcessed .. ' / ' .. #Config.ItemsToRemove)
        if vehiclesProcessed == #Config.VehiclesToRemove and itemsProcessed == #Config.ItemsToRemove then
            scriptActive = false
            print('Toutes les tâches sont terminées. Les joueurs peuvent maintenant se connecter.')
        end
    end
end)

print('Script chargé : Les véhicules et items seront retirés, et les compensations seront effectuées au démarrage du serveur.')