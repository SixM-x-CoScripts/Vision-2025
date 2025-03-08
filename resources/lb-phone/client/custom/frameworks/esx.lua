if Config.Framework ~= "esx" then
    return
end

debugprint("Loading ESX")
local export, obj = pcall(function()
    return exports.es_extended:getSharedObject()
end)

if export then
    ESX = obj
else
    while not ESX do
        TriggerEvent("esx:getSharedObject", function(obj)
            ESX = obj
        end)
        Wait(500)
    end
end

local isFirst = true
RegisterNetEvent("esx:playerLoaded", function(playerData)
    ESX.PlayerData = playerData
    ESX.PlayerLoaded = true

    if not isFirst then
        FetchPhone()
    end

    isFirst = false
end)

RegisterNetEvent("esx:onPlayerLogout", function()
    LogOut()
end)

while not ESX.PlayerLoaded do
    Wait(500)
end

RegisterNetEvent("esx:setJob", function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent("esx:setAccountMoney", function(account)
    if account.name ~= "bank" then
        return
    end

    SendReactMessage("wallet:setBalance", math.floor(account.money))
end)

debugprint("ESX loaded")
loaded = true

---Check if the player has a phone
---@return boolean
function HasPhoneItem(number)
    if not Config.Item.Require then
        return true
    end

    if Config.Item.Unique then
        return HasPhoneNumber(number)
    end

    if GetResourceState("ox_inventory") == "started" then
        return (exports.ox_inventory:Search("count", Config.Item.Name) or 0) > 0
    elseif GetResourceState("qs-inventory") then
        local exportExists, result = pcall(function()
            return exports["qs-inventory"]:Search(Config.Item.Name)
        end)

        if exportExists then
            return (result or 0) > 0
        end
    end

    local inventory = ESX.GetPlayerData()?.inventory
    if not inventory then
        infoprint("warning", "Unsupported inventory, tell the inventory author to add support for it.")
        return false
    end

    for i = 1, #inventory do
        local item = inventory[i]
        if item.name == Config.Item.Name and item.count > 0 then
            return true
        end
    end

    return false
end

---Check if the player has a job
---@param jobs table
---@return boolean
function HasJob(jobs)
    local job = ESX.PlayerData.job.name
    for i = 1, #jobs do
        if jobs[i] == job then
            return true
        end
    end
    return false
end

---Apply vehicle mods
---@param vehicle number
---@param vehicleData table
function ApplyVehicleMods(vehicle, vehicleData)
    if type(vehicleData.vehicle) == "string" then
        vehicleData.vehicle = json.decode(vehicleData.vehicle)
    end

    SetVehicleOnGroundProperly(vehicle)
    SetVehicleNumberPlateText(vehicle, vehicleData.vehicle.plate)

    ESX.Game.SetVehicleProperties(vehicle, vehicleData.vehicle)

    if vehicleData.damages and not Config.Valet.DisableDamages then
        SetVehicleEngineHealth(vehicle, vehicleData.damages.engineHealth)
        SetVehicleBodyHealth(vehicle, vehicleData.damages.bodyHealth)
    end

    if vehicleData.vehicle.fuel then
        SetVehicleFuelLevel(vehicle, vehicleData.vehicle.fuel)
    end

    if Config.Valet.FixTakeOut then
        SetVehicleFixed(vehicle)
    end
end

---Create a vehicle and apply vehicle mods
---@param vehicleData table
---@param coords vector3
---@return number? vehicle
function CreateFrameworkVehicle(vehicleData, coords)
    vehicleData.vehicle = json.decode(vehicleData.vehicle)
    if vehicleData.damages then
        vehicleData.damages = json.decode(vehicleData.damages)
    end

    local model = LoadModel(vehicleData.vehicle.model)
    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, 0.0, true, false)

    SetVehicleOnGroundProperly(vehicle)
    ApplyVehicleMods(vehicle, vehicleData)
    SetModelAsNoLongerNeeded(model)

    return vehicle
end

-- Company app
function GetCompanyData(cb)
    local jobData = {
        job = ESX.PlayerData.job.name,
        jobLabel = ESX.PlayerData.job.label,
        isBoss = ESX.PlayerData.job.grade_name == "boss"
    }

    if not jobData.isBoss then
        for cId = 1, #Config.Companies.Services do
            local company = Config.Companies.Services[cId]
            if company.job == jobData.job then
                if not company.bossRanks then
                    break
                end

                for i = 1, #company.bossRanks do
                    if company.bossRanks[i] == ESX.PlayerData.job.grade_name then
                        jobData.isBoss = true
                        break
                    end
                end

                break
            end
        end
    end

    if jobData.isBoss then
        local moneyPromise = promise.new()

        ESX.TriggerServerCallback("esx_society:getSocietyMoney", function(money)
            jobData.balance = money
            moneyPromise:resolve()
        end, jobData.job)

        Citizen.Await(moneyPromise)

        local employeesPromise = promise.new()

        ESX.TriggerServerCallback("esx_society:getEmployees", function(employees)
            jobData.employees = employees

            for i = 1, #employees do
                local employee = employees[i]

                employees[i] = {
                    name = employee.name,
                    id = employee.identifier,

                    gradeLabel = employee.job.grade_label,
                    grade = employee.job.grade,

                    canInteract = employee.job.grade_name ~= "boss"
                }
            end
            employeesPromise:resolve()
        end, jobData.job)

        Citizen.Await(employeesPromise)

        local gradesPromise = promise.new()

        ESX.TriggerServerCallback("esx_society:getJob", function(job)
            local grades = {}
            for i = 1, #job.grades do
                local grade = job.grades[i]
                grades[i] = {
                    label = grade.label,
                    grade = grade.grade
                }
            end
            jobData.grades = grades
            gradesPromise:resolve()
        end, jobData.job)

        Citizen.Await(gradesPromise)
    end

    cb(jobData)
end

function DepositMoney(amount, cb)
    TriggerServerEvent("esx_society:depositMoney", ESX.PlayerData.job.name, amount)
    SetTimeout(500, function()
        ESX.TriggerServerCallback("esx_society:getSocietyMoney", cb, ESX.PlayerData.job.name)
    end)
end

function WithdrawMoney(amount, cb)
    TriggerServerEvent("esx_society:withdrawMoney", ESX.PlayerData.job.name, amount)
    SetTimeout(500, function()
        ESX.TriggerServerCallback("esx_society:getSocietyMoney", cb, ESX.PlayerData.job.name)
    end)
end

function HireEmployee(source, cb)
    ESX.TriggerServerCallback("esx_society:getOnlinePlayers", function(players)
        for i = 1, #players do
            local player = players[i]
            if player.source == source then
                ESX.TriggerServerCallback("esx_society:setJob", function()
                    cb({
                        name = player.name,
                        id = player.identifier
                    })
                end, player.identifier, ESX.PlayerData.job.name, 0, "hire")
                return
            end
        end
    end)
end

function FireEmployee(identifier, cb)
    ESX.TriggerServerCallback("esx_society:setJob", function()
        cb(true)
    end, identifier, "unemployed", 0, "fire")
end

function SetGrade(identifier, newGrade, cb)
    ESX.TriggerServerCallback("esx_society:getJob", function(job)
        if newGrade > #job.grades - 1 then
            return cb(false)
        end

        ESX.TriggerServerCallback("esx_society:setJob", function()
            cb(true)
        end, identifier, ESX.PlayerData.job.name, newGrade, "promote")
    end, ESX.PlayerData.job.name)
end

--IMPLEMENT DUTY SYSTEM FOR ESX HERE
-- function ToggleDuty()
-- end

RegisterNetEvent("esx:removeInventoryItem", function(item, count)
    if not Config.Item.Require or Config.Item.Unique or item ~= Config.Item.Name or count > 0 then
        return
    end

    Wait(500)

    if not HasPhoneItem() then
        OnDeath()
    end
end)
