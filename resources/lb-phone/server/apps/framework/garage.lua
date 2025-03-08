---@alias VehicleStatistics { engine?: number, body?: number, fuel?: number }
---@alias ImpoundReason { reason?: string, retrievable?: number, price?: number, impounder?: string }
---@alias VehicleData { plate: string, type: string, location: string, model: number, impounded: boolean, statistics: VehicleStatistics, impoundReason?: ImpoundReason }

---Check if a vehicle is out
---@param plate string
---@param vehicles any
---@return boolean out
---@return number | nil vehicle
local function IsVehicleOut(plate, vehicles)
    if not vehicles then
        vehicles = GetAllVehicles()
    end

    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        if DoesEntityExist(vehicle) and GetVehicleNumberPlateText(vehicle):gsub("%s+", "") == plate:gsub("%s+", "") then
            return true, vehicle
        end
    end

    return false
end

lib.RegisterCallback("phone:garage:findCar", function(source, cb, plate)
    local phoneNumber = GetEquippedPhoneNumber(source)

    local out, vehicle = IsVehicleOut(plate)
    if out and vehicle then
        return cb(GetEntityCoords(vehicle))
    end

    if phoneNumber then
        SendNotification(phoneNumber, {
            source = source,
            app = "Garage",
            title = L("BACKEND.GARAGE.VALET"),
            content = L("BACKEND.GARAGE.COULDNT_FIND"),
        })
    end

    cb(false)
end)

lib.RegisterCallback("phone:garage:getVehicles", function(source, cb)
    local vehicles = GetPlayerVehicles(source)

    local allVehicles = #vehicles > 0 and GetAllVehicles() or {}
    for i = 1, #vehicles do
        if IsVehicleOut(vehicles[i].plate, allVehicles) then
            vehicles[i].location = "out"
        end
    end

    cb(vehicles)
end)

lib.RegisterCallback("phone:garage:valetVehicle", function(source, cb, plate, coords, heading)
    local phoneNumber = GetEquippedPhoneNumber(source)
    if not phoneNumber then
        return cb()
    end

    if IsVehicleOut(plate) then
        SendNotification(phoneNumber, {
            app = "Garage",
            title = L("BACKEND.GARAGE.VALET"),
            content = L("BACKEND.GARAGE.ALREADY_OUT"),
        })
        return cb()
    end

    if Config.Valet.Price and GetBalance(source) < Config.Valet.Price then
        SendNotification(phoneNumber, {
            app = "Garage",
            title = L("BACKEND.GARAGE.VALET"),
            content = L("BACKEND.GARAGE.NO_MONEY"),
        })
        return cb()
    end

    local vehicleData = GetVehicle(source, plate)
    if not vehicleData then
        return cb()
    end

    if Config.Valet.Price and not RemoveMoney(source, Config.Valet.Price) then
        SendNotification(phoneNumber, {
            app = "Garage",
            title = L("BACKEND.GARAGE.VALET"),
            content = L("BACKEND.GARAGE.NO_MONEY"),
        })
        return cb()
    end

    SendNotification(phoneNumber, {
        app = "Garage",
        title = L("BACKEND.GARAGE.VALET"),
        content = L("BACKEND.GARAGE.ON_WAY"),
    })

    if Config.ServerSideSpawn then
        local vehicle = CreateServerVehicle(vehicleData.model, coords, heading)
        if not vehicle then
            AddMoney(source, Config.Valet.Price)
            debugprint("Failed to create vehicle")
            return cb()
        end

        vehicleData.vehNetId = NetworkGetNetworkIdFromEntity(vehicle)

        if Config.Valet.Drive then
            ---@diagnostic disable-next-line: param-type-mismatch
            local ped = CreateServerPed(Config.Valet.Model, coords + vector3(0.0, 1.0, 1.0), heading)
            if not ped then
                AddMoney(source, Config.Valet.Price)
                DeleteEntity(vehicle)
                debugprint("Failed to create ped")
                return cb()
            end

            vehicleData.pedNetId = NetworkGetNetworkIdFromEntity(ped)
        end
    end

    cb(vehicleData)
end)