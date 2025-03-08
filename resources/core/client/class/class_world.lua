World = {}


function World.GetDistanceBetweenCoords(coords1, coords2)
    local coords1 = vector3(coords1.x, coords1.y, coords1.z)
    local coords2 = vector3(coords2.x, coords2.y, coords2.z)
    return #(coords1 - coords2)
end

function World.GetPlayersServerIdsInZone(size)
    local players = {}

    local currentPosition = p:getPos()
    for k,v in pairs(GetActivePlayers()) do
        local position = GetEntityCoords(GetPlayerPed(v))
        if World.GetDistanceBetweenCoords(currentPosition, position) <= size then
            table.insert(players, GetPlayerServerId(v))
        end
    end
    return players
end

function World.LoadModel(modelName)
    local model = GetHashKey(modelName)
    if IsModelInCdimage(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end
        return model
    else
        return false
    end
end

function World.CreatePed(modelName, position)
    local model = World.LoadModel(modelName)
    if model ~= false then
        local ped = CreatePed(4, model, position.x, position.y, position.z, position.w, false, false)
        SetEntityAsMissionEntity(ped, true, true)
        return ped
    else
        return false
    end
end

function World.CreateVehicle(modelName, position, networked)
    if networked then 
        TriggerSWEvent("TREFSDFD5156FD", "VZEFDSF", 5000)
    end
    local model = World.LoadModel(modelName)
    if model ~= false then
        local vehicle = CreateVehicle(model, position.x, position.y, position.z, position.w, networked, true)
        SetEntityAsMissionEntity(vehicle, true, true)
        return vehicle
    else
        return false
    end
end

function World.CreateVehicleWithPlayerHeading(modelName, position, networked)
    if networked then 
        TriggerSWEvent("TREFSDFD5156FD", "VZEFDSF", 5000)
    end
    local model = World.LoadModel(modelName)
    if model ~= false then
        local vehicle = CreateVehicle(model, position.x, position.y, position.z, p:heading(), networked, true)
        SetEntityAsMissionEntity(vehicle, true, true)
        return vehicle
    else
        return false
    end
end

function World.DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end