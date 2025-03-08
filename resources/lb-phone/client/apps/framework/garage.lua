---Function to find a spawn point for a car
---@param minDist? number Minimum distance from the player. Default 150
---@return nil | vector3
---@return number
local function FindCarLocation(minDist)
    if not minDist then
        minDist = 150
    end

    local plyCoords = GetEntityCoords(PlayerPedId())
    local nth = 0

    local success, position, heading
    repeat
        nth += 1
        success, position, heading = GetNthClosestVehicleNodeWithHeading(plyCoords.x, plyCoords.y, plyCoords.z, nth, 0, 0, 0)
    until #(plyCoords - position) > minDist or success == false

    return position, heading
end

local function BringCar(data, cb)
    local minDist = Config.Valet.Drive and math.random(75, 150) or 0
    local location, heading = FindCarLocation(minDist)
    if not location then
        debugprint("No location found")
        return cb(false)
    end

    if IsPedInAnyVehicle(PlayerPedId(), false) then
        debugprint("Player is in a vehicle")
        return cb(false)
    end

    local plate = data.plate
    local vehicleData = lib.TriggerCallbackSync("phone:garage:valetVehicle", plate, location, heading)
    if not vehicleData then
        return cb(false)
    end

    local vehicle, ped
    if Config.ServerSideSpawn then
        local vehNetId, pedNetId = vehicleData.vehNetId, vehicleData.pedNetId
        if not vehNetId or (Config.Valet.Drive and not pedNetId) then
            debugprint("Server did not create vehicle/ped (no vehNetId/pedNetId)")
            return cb(false)
        end

        vehicle = WaitForNetworkId(vehNetId)
        if Config.Valet.Drive then
            ped = WaitForNetworkId(pedNetId)
        end

        Wait(1000) -- magic wait that fixes issue with ped not being in vehicle?

        if vehicle and TakeControlOfEntity(vehicle) then
            if ped and TakeControlOfEntity(ped) then
                TaskWarpPedIntoVehicle(ped, vehicle, -1)
            end
            ApplyVehicleMods(vehicle, vehicleData)
        end
    else
        vehicle = CreateFrameworkVehicle(vehicleData, location)

        if vehicle and Config.Valet.Drive then
            local model = LoadModel(Config.Valet.Model)
            ped = CreatePedInsideVehicle(vehicle, 4, model, -1, true, false)
        end
    end

    if not vehicle or not DoesEntityExist(vehicle) or not ped or not DoesEntityExist(ped) then
        return cb(false)
    end

    if GetResourceState("jg-advancedgarages") == "started" then
        TriggerServerEvent("jg-advancedgarages:server:register-vehicle-outside", plate, VehToNet(vehicle))
    end

    SetEntityHeading(vehicle, heading)

    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetVehRadioStation(vehicle, "OFF")
    SetVehicleDirtLevel(vehicle, 0.0)
    SetVehicleEngineOn(vehicle, true, true, true)
    SetEntityAsMissionEntity(vehicle, true, true)

    cb(true)


    if not Config.Valet.Drive then
        return
    end

    -- make the ped bring the vehicle
    local plyCoords = GetEntityCoords(PlayerPedId())

    TaskVehicleDriveToCoord(ped, vehicle, plyCoords.x, plyCoords.y, plyCoords.z, 20.0, 0, Config.Valet.Model, 786603, 1.0, 1)
    SetPedKeepTask(ped, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCombatAttributes(ped, 17, true)
    SetPedAlertness(ped, 0)

    -- create blip for the vehicle
    local blip = AddBlipForEntity(vehicle)
    SetBlipSprite(blip, 225)
    SetBlipColour(blip, 5)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Valet")
    EndTextCommandSetBlipName(blip)

    -- wait for the ped to arrive
    while #(GetEntityCoords(ped) - GetEntityCoords(PlayerPedId())) > 10.0 do
        Wait(1000)
    end

    RemoveBlip(blip)

    -- make the ped exit the vehicle, then wander in area, and set as no longer needed
    TaskLeaveVehicle(ped, vehicle, 0)
    TaskWanderStandard(ped, 10.0, 10)
    SetEntityAsNoLongerNeeded(ped)
end

---Function to find a car
---@param plate string
---@return vector3 | false
local function findCar(plate)
    local vehicles = GetGamePool("CVehicle")
    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        if DoesEntityExist(vehicle) and GetVehicleNumberPlateText(vehicle):gsub("%s+", "") == plate:gsub("%s+", "") then
            return GetEntityCoords(vehicle)
        end
    end

    return lib.TriggerCallbackSync("phone:garage:findCar", plate)
end

function GetVehicleLabel(model)
    local vehicleLabel = GetDisplayNameFromVehicleModel(model):lower()

    if not vehicleLabel or vehicleLabel == "null" or vehicleLabel == "carnotfound" then
        vehicleLabel = "Unknown"
    else
        local text = GetLabelText(vehicleLabel)
        if text and text:lower() ~= "null" then
            vehicleLabel = text
        end
    end
    return vehicleLabel
end

RegisterNUICallback("Garage", function(data, cb)
    local action = data.action

    if action == "getVehicles" then
        lib.TriggerCallback("phone:garage:getVehicles", function(cars)
            for i = 1, #cars do
                cars[i].model = GetVehicleLabel(cars[i].model)
                --If you're implementing your own lock system, you can use this to set the locked state
                -- cars[i].locked = true
            end
            cb(cars)
        end)
    elseif action == "valet" then
        if not Config.Valet.Enabled then
            return
        end

        BringCar(data, cb)
    elseif action == "setWaypoint" then
        local coords = findCar(data.plate)
        if coords then
            TriggerEvent("phone:sendNotification", {
                app = "Garage",
                title = L("BACKEND.GARAGE.VALET"),
                content = L("BACKEND.GARAGE.MARKED"),
            })
            SetNewWaypoint(coords.x, coords.y)
        else
            debugprint("not found")
        end
    elseif action == "toggleLocked" then
        --IMPLEMENT YOUR LOCK SYSTEM HERE, don't forget to callback with the new locked state
        -- cb(true)
    end
end)