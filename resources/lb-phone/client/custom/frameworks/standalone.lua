if Config.Framework ~= "standalone" then
    return
end

while not NetworkIsSessionStarted() do
    Wait(500)
end

loaded = true

function HasPhoneItem(number)
    if not Config.Item.Require then
        return true
    end

    if Config.Item.Unique then
        return HasPhoneNumber(number)
    end

    for k, v in pairs(exports["core"]:GetInventoryPlayer()) do
        if v.name == "phone" then
            if v.count >= 1 then
                return true
            else
                return false
            end
        end
    end
end

function HasJob(jobs)
    local pJob = exports["core"]:GetJobPlayer()
    if pJob == jobs then
        return true
    else
        return false
    end
end

---Apply vehicle mods
---@param vehicle number
---@param vehicleData table
function ApplyVehicleMods(vehicle, vehicleData)
    return false
end

---Create a vehicle and apply vehicle mods
---@param vehicleData table
---@param coords vector3
---@return number? vehicle
function CreateFrameworkVehicle(vehicleData, coords)
    return false
end

-- Company app
function GetCompanyData(cb)
    cb {}
end

function DepositMoney(amount, cb)
    cb(false)
end

function WithdrawMoney(amount, cb)
    cb(false)
end

function HireEmployee(source, cb)
    cb(false)
end

function FireEmployee(identifier, cb)
    cb(false)
end

function SetGrade(identifier, newGrade, cb)
    cb(false)
end

function ToggleDuty()
    return false
end
