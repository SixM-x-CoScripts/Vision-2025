local ActiveEvents = true

-- Conteneurs
RegisterNetEvent("core:rm:conteneurevent", function()
    TriggerClientEvent("core:rm:conteneurevent", -1)
end)

RegisterNetEvent("core:event:conteneur", function(type)
    local src = source
    local ply = GetPlayer(src)
    if ply:getPermission() > 2 then
        TriggerClientEvent("core:startevent:conteneur", -1, type)
    end
end)

CreateThread(function()
    if not ActiveEvents then return end
    local sentEvent = '1'
    while true do
        Wait(30 * 60000)
        local hour = os.date('%H', os.time())
        if hour == math.random(16, 17) or hour == math.random(01, 03) and sentEvent ~= hour then
            TriggerClientEvent("core:startevent:conteneur", -1, 'pf')
            sentEvent = hour
        end
    end
end)

-- Trailer heist

local DiffPos = {
    {
        start = vector4(1544.3093261719, 861.35357666016, 76.452033996582, 328.12606811523),
        finish = vector3(140.12171936035, 6580.1157226562, 30.959951400757),
    }
}

local RandomVeh = {
    "tenf",
    "zion",
    "sultan",
    "sentinel",
    "vectre",
    "sultanrs"
}

RegisterNetEvent("core:events:trailer:finished", function()
    TriggerClientEvent("core:events:trailer:finished", -1)
end)


RegisterNetEvent("core:events:trailer:start", function(typeorg)
    local src = source
    local ply = GetPlayer(src)
    if ply:getPermission() > 2 then
        CreateEventTrailer(typeorg)
    else
		TriggerClientEvent("__atoshi::createNotification", src, {
			type = 'ROUGE',
			-- duration = 5, -- In seconds, default:  4
			content = "Vous n'avez pas les permissions."
		})
    end
end)

RegisterNetEvent("core:events:trailer:cl:start", function(typeorg)
    local src = source
    local ply = GetPlayer(src)
    if RemoveItemFromInventory(src, "laptop", 1, {}) then
        CreateEventTrailer(typeorg)
    else
		TriggerClientEvent("__atoshi::createNotification", src, {
			type = 'ROUGE',
			-- duration = 5, -- In seconds, default:  4
			content = "Vous n'avez pas d'ordinateur portable."
		})
    end
end)

RegisterNetEvent("core:events:train:start", function(group)
    local src = source
    local train = TriggerClientCallback(src, "core:createtrainheist")
    local entity = NetworkGetEntityFromNetworkId(train)

    TriggerClientEvent("core:events:train:start", -1, NetworkGetNetworkIdFromEntity(entity), group)

    while DoesEntityExist(entity) do
        Wait(10000)
        TriggerClientEvent("core:event:trainupdate", -1, GetEntityCoords(entity))
    end
    TriggerClientEvent("core:event:trainfinish", -1)
end)

function CreateEventTrailer(typeorg)
    local randomtrajet = DiffPos[math.random(1, #DiffPos)]
    local start = randomtrajet.start
    local truk = CreateVehicle(GetHashKey("packer"), start, true, true)
    local trailer = CreateVehicle(GetHashKey("tr2"), start + vector4(6.5, 0.0, 0.0, 0.0), true, true)
    local randomname = RandomVeh[math.random(1, #RandomVeh)]
    local vehone = CreateVehicle(GetHashKey(randomname), start - vector4(3.5, 0.0, 0.0, 0.0), true, true)
    Wait(3000)
    local randomname = RandomVeh[math.random(1, #RandomVeh)]
    local vehtwo = CreateVehicle(GetHashKey(randomname), start - vector4(4.4, 0.0, 0.0, 0.0), true, true)
    Wait(3000)
    local randomname = RandomVeh[math.random(1, #RandomVeh)]
    local vehthree = CreateVehicle(GetHashKey(randomname), start - vector4(5.6, 0.0, 0.0, 0.0), true, true)

    while not DoesEntityExist(truk) or not DoesEntityExist(trailer) or not DoesEntityExist(vehone) or not DoesEntityExist(vehtwo)
    or not DoesEntityExist(vehthree) do
        Wait(50)
    end

    local pedone = CreatePedInsideVehicle(truk, 1, GetHashKey("s_m_m_trucker_01"), -1, true, true)
    local timer = 1
    while not DoesEntityExist(pedone) do
        Wait(1)
        timer += 1
        print(timer)
        if timer > 50 then break end
    end

    -- OneSync
    SetEntityDistanceCullingRadius(truk, 9999.9)
    SetEntityDistanceCullingRadius(trailer, 9999.9)
    SetEntityDistanceCullingRadius(vehone, 9999.9)
    SetEntityDistanceCullingRadius(vehtwo, 9999.9)
    SetEntityDistanceCullingRadius(vehthree, 9999.9)

    TriggerClientEvent("core:event:trailer", -1, NetworkGetNetworkIdFromEntity(truk), NetworkGetNetworkIdFromEntity(trailer),
        NetworkGetNetworkIdFromEntity(vehone), NetworkGetNetworkIdFromEntity(vehtwo), NetworkGetNetworkIdFromEntity(vehthree),
        randomtrajet.finish, typeorg, start, (DoesEntityExist(pedone) and NetworkGetNetworkIdFromEntity(pedone) or nil))

    while DoesEntityExist(truk) do
        Wait(10000)
        TriggerClientEvent("core:event:trailerupdate", -1, GetEntityCoords(truk))
    end
end

CreateThread(function()
    if not ActiveEvents then return end
    local sentEvent = '1'
    while true do
        Wait(30 * 60000)
        local hour = os.date('%H', os.time())
        if hour == math.random(16, 17) or hour == math.random(01, 03) and sentEvent ~= hour then
            CreateEventTrailer("gang")
            sentEvent = hour
        end
    end
end)

RegisterCommand("createTrailer", function(source, args)
    if source == 0 then

    end
end)

-- CAMION EVENT ARMES

local RandomStartPos = {
    vector4(1433.7877197266, -2590.2590332031, 47.077598571777, 4.6560530662537)
}
local RandomWeapons = {
    "weapon_machinepistol",
    "weapon_pistol",
    "weapon_combatpistol",
}
function CreateEventCamion(typeorg)
    local pos = RandomStartPos[math.random(1, #RandomStartPos)]
    print("pos", pos)
    local camion = CreateVehicle(GetHashKey("pounder2"), pos, true, true)
    local ped1 = CreatePedInsideVehicle(camion, 1, GetHashKey("s_m_m_trucker_01"), -1, true, true)
    while not DoesEntityExist(camion) do
        Wait(100)
    end
    while not DoesEntityExist(ped1) do
        Wait(100)
    end
    SetEntityDistanceCullingRadius(camion, 9999.9)
    local plate = GetVehicleNumberPlateText(camion)
    vehicle:new({
        plate = plate,
        owner = nil,
        name = "pounder2",
        props = json.encode({}),
        garage = nil,
        stored = 1,
        vente = nil,
        coowner = json.encode({}),
        job = nil,
        inventory = json.encode({}),
        mileage = 0,
        fuel = 100,
        body = json.encode({}),
        currentPlate = plate
    })
    local newpistol = RandomWeapons[math.random(1, #RandomWeapons)]
    print("newpistol", newpistol)
    AddItemToInventoryVehicleStaff(plate, newpistol, 1, {})
    math.randomseed(os.time())
    local newpistol2 = RandomWeapons[math.random(1, #RandomWeapons)]
    if newpistol == newpistol2 then
        newpistol2 = RandomWeapons[math.random(1, #RandomWeapons)]
    end
    print("newpistol2", newpistol2)
    AddItemToInventoryVehicleStaff(plate, newpistol2, 1, {})
    TriggerClientEvent("core:events:camion", -1, typeorg, NetworkGetNetworkIdFromEntity(camion), NetworkGetNetworkIdFromEntity(ped1), GetEntityCoords(camion))

    while DoesEntityExist(camion) do
        Wait(10000)
        TriggerClientEvent("core:event:camionupdate", -1, GetEntityCoords(camion))
    end
end

CreateThread(function()
    if not ActiveEvents then return end
    local sentEvent = '1'
    while true do
        Wait(30 * 60000)
        local hour = os.date('%H', os.time())
        if hour == math.random(16, 17) or hour == math.random(01, 03) and sentEvent ~= hour then
            CreateEventCamion("mafia")
            sentEvent = hour
        end
    end
end)

RegisterNetEvent("core:events:camion:start", function(typeorg)
    local src = source
    local ply = GetPlayer(src)
    if ply:getPermission() > 2 then
        CreateEventCamion(typeorg)
    end
end)

-- BRINKS
CreateThread(function()
    local sentEvent = '1'
    while true do
        Wait(30 * 60000)
        local hour = os.date('%H', os.time())
        if (hour == math.random(16, 17) or hour == math.random(01, 03)) and sentEvent ~= hour then
            CreateBrinksbraquage("orga")
            sentEvent = hour
        end
    end
end)

-- TP IPL
local listTpIpl = {}

RegisterNetEvent("core:event:addtpipl", function(name, enterCoords, ipl)
    local src = source
    local ply = GetPlayer(src)
    if ply:getPermission() > 2 then
        if listTpIpl[name] then
            TriggerClientEvent("__atoshi::createNotification", src, {
                type = 'ROUGE',
                content = "Le point de téléportation existe déjà."
            })
            return
        end
        for k,v in pairs(listTpIpl) do
            print("v.ipl", v.ipl)
            if v.ipl.name == ipl.name then
                print("le ipl existe déjà")
                TriggerClientEvent("__atoshi::createNotification", src, {
                    type = 'ROUGE',
                    content = "L'IPL sélectionné possède déjà un point de téléportation."
                })
                return
            end
        end

        listTpIpl[name] = {
            enter = enterCoords,
            ipl = ipl
        }
        TriggerClientEvent("__atoshi::createNotification", src, {
            type = 'VERT',
            content = "Le point de téléportation a été crée avec succès."
        })
        TriggerClientEvent("core:events:createTpIpl", -1, name, enterCoords, ipl)
    end
end)

RegisterNetEvent("core:event:removetpipl", function(name)
    local src = source
    local ply = GetPlayer(src)
    if ply:getPermission() > 2 then
        listTpIpl[name] = nil
        TriggerClientEvent("__atoshi::createNotification", src, {
            type = 'VERT',
            content = "Le point de téléportation a été supprimé avec succès."
        })
        TriggerClientEvent("core:events:deleteTpIpl", -1, name)
    end
end)

RegisterServerCallback('core:events:getListTpIpl', function()
    return listTpIpl
end)
