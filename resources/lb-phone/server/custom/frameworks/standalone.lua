if Config.Framework ~= "standalone" then
    return
end

--- @param source number
--- @return string | nil
function GetIdentifier(source)
    return exports.core:GetPlayerIdbdd(source)
end

---Check if a player has a phone with a specific number
---@param source any
---@param number string
---@return boolean
function HasPhoneItem(source, number)
    if not Config.Item.Require then
        return true
    end

    if GetResourceState("ox_inventory") == "started" then
        return (exports.ox_inventory:Search(source, "count", Config.Item.Name) or 0) > 0
    end

    return true
end

---Get a player's character name
---@param source any
---@return string # Firstname
---@return string # Lastname
function GetCharacterName(source)
    local identity = exports.core:playerIdentity(source)
    return identity.nom, identity.prenom
end

---Get an array of player sources with a specific job
---@param job string
---@return table # Player sources
function GetEmployees(job)
    local AppelsEnCours = {}
    local onDuty = exports.core:getOnDuty(job)
    if onDuty and type(onDuty) == "table" then 
        for k, v in pairs(onDuty) do 
            table.insert(AppelsEnCours, k)
        end
    end
    return AppelsEnCours
end

---Get the bank balance of a player
---@param source any
---@return integer
function GetBalance(source)
    local bank = exports.core:getMoneyPhone(source)
    return bank.balance
end

---Add money to a player's bank account
---@param source any
---@param amount integer
---@return boolean # Success
function AddMoney(source, amount)
    if exports.core:GetPlayerTarget(source) == nil then
        return false
    else
        TriggerEvent("core:bankPlayerUpdatePhone", "putaintelephonedemerdeatoutmomentonestbaiser", source, "add", amount)
        return true
    end
end

---Remove money from a player's bank account
---@param source any
---@param amount integer
---@return boolean # Success
function RemoveMoney(source, amount)
    local bank = exports.core:getMoneyPhone(source)
    if (bank.balance - amount) >= 0 then
        TriggerEvent("core:bankPlayerUpdatePhone", "putaintelephonedemerdeatoutmomentonestbaiser", source, "remove", amount)
        return true
    else
        return false
    end
end

---Send a message to a player
---@param source number
---@param message string
function Notify(source, message)
    TriggerClientEvent("__atoshi::createNotification", source, {
        type = 'BLANC',
        content = message,
    })
end

-- GARAGE APP

---@param source number
---@return VehicleData[] vehicles An array of vehicles that the player owns
function GetPlayerVehicles(source)
    return {}
end

---Get a specific vehicle
---@param source number
---@param plate string
---@return table? vehicleData
function GetVehicle(source, plate)
end

function IsAdmin(source)
    return exports.core:GetPlayerPerm(source) >= 5
end

-- COMPANIES APP
function GetJob(source)
    return exports.core:GetPlayerJob(source)
end

function RefreshCompanies()
    for i = 1, #Config.Companies.Services do
        local jobData = Config.Companies.Services[i]
        Config.Companies.Services[i].open = #GetEmployees(jobData.job) > 0
    end
    return true
end
