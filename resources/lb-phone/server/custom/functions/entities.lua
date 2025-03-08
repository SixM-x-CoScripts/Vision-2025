if not Config.ServerSideSpawn then
    return
end

local phoneModel = Config.PhoneModel or `prop_amb_phone`

---Wait for an entity to exist
---@param entity number
---@return boolean exists
local function waitForEntity(entity)
    local timer = GetGameTimer() + 5000
    while not DoesEntityExist(entity) and timer > GetGameTimer() do
        Wait(0)
    end

    return DoesEntityExist(entity)
end

---Creates a phone object and attaches it to the player
---@param source any
---@return number? phoneEntity
function CreatePhoneObject(source)
    local playerPed = GetPlayerPed(source)
    local coords = GetEntityCoords(playerPed)
    local phone = CreateObjectNoOffset(phoneModel, coords.x, coords.y, coords.z, true, true, false)

    if not waitForEntity(phone) then
        return
    end

    -- allow the player to take control of the phone, so they can attach it
    SetEntityIgnoreRequestControlFilter(phone, true)

    return phone
end

lib.RegisterCallback("phone:createPhoneObject", function(source, cb)
    debugprint("Creating phone object for player "..source)
    local phone = CreatePhoneObject(source)

    if phone then
        cb(NetworkGetNetworkIdFromEntity(phone))
    else
        cb(false)
    end
end)

RegisterNetEvent("phone:failedControl", function(netId)
    local entity = NetworkGetEntityFromNetworkId(netId)

    if GetEntityModel(entity) == phoneModel then
        debugprint("Failed to take control of phone object, deleting")
        DeleteEntity(entity)
    end
end)

---@param model number
---@param coords vector3
---@param heading? number
---@return number? vehicle
function CreateServerVehicle(model, coords, heading)
    heading = heading or 0
    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, true)

    if not waitForEntity(vehicle) then
        return
    end

    -- allow the player to take control of the vehicle, so they can set mods
    SetEntityIgnoreRequestControlFilter(vehicle, true)

    return vehicle
end

---@param model number
---@param coords vector3
---@param heading? number
---@return number? ped
function CreateServerPed(model, coords, heading)
    heading = heading or 0

    local ped = CreatePed(4, model, coords.x, coords.y, coords.z, heading, true, true)

    if not waitForEntity(ped) then
        return
    end

    SetEntityIgnoreRequestControlFilter(ped, true)

    return ped
end
