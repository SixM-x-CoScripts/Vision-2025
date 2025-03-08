RegisterNetEvent("brinksSendStart", function(netVeh)
    TriggerClientEvent("brinksStartAttack", -1, netVeh)
end)

local BrinksPeds = {}
RegisterNetEvent("core:sendInfoBrinksPed", function(token, ped)
    if not BrinksPeds[ped] then
        BrinksPeds[ped] = 1
    else
        BrinksPeds[ped] = BrinksPeds[ped] + 1
    end
end)

local BrinksMeuled = {}
RegisterServerCallback("core:hasallAimedAt", function(source, ped)
    return BrinksPeds[ped]
end)

RegisterServerCallback("core:HasBeenMeuled", function(source, netid)
    if not BrinksMeuled[netid] then
        BrinksMeuled[netid] = true
        return false
    end
    return BrinksMeuled[netid]
end)

RegisterNetEvent("core:brinksPeds", function(p,p2,veh)
    TriggerClientEvent("core:brinksPeds", -1,p,p2,veh)
end)

RegisterNetEvent("core:brinks:sync", function(crew, route)
    TriggerClientEvents("core:sync:brinks", GetAllCrewIds(crew), route)
end)

local FourgonsPos = {
    --vector4(-1536.1837158203, 1376.0681152344, 124.19680786133, 125.20016479492),
    vector4(-2066.9055175781, -307.66461181641, 12.14292049408, 83.783744812012),
    --vector4(-977.11553955078, -1534.8530273438, 4.002140045166, 106.53971099854),
    --vector4(-460.68707275391, -2788.5322265625, 5.0003843307495, 315.97689819336),
    --vector4(1952.9693603516, -947.10168457031, 78.093482971191, 347.14334106445),
    --vector4(762.865234375, -3067.7446289062, 5.2253580093384, 349.13873291016),
    --vector4(242.34387207031, -2731.193359375, 16.688117980957, 332.322265625),
}

local FourgonFinish = {
    vector3(-61.264419555664, 6553.1528320312, 30.490814208984),
    vector3(-773.30035400391, 5552.6372070312, 32.49055480957),
}

function CreateBrinksbraquage(group)
    local start = FourgonsPos[math.random(1, #FourgonsPos)]
    local veh = CreateVehicle(GetHashKey("stockade"), start, true, true)
    while not DoesEntityExist(veh) do
        Wait(0)
    end
    local ped1 = CreatePedInsideVehicle(veh, 1, GetHashKey("mp_s_m_armoured_01"), -1, true, true)
    local ped2 = CreatePedInsideVehicle(veh, 1, GetHashKey("mp_s_m_armoured_01"), 0, true, true)
    local timer = 1
    while not DoesEntityExist(ped1) or not DoesEntityExist(ped2) do
        Wait(0)
        timer += 1
        if timer > 600 then
            ped1 = CreatePed(4, GetHashKey("mp_s_m_armoured_01"), start, true, true)
            ped2 = CreatePed(4, GetHashKey("mp_s_m_armoured_01"), start, true, true)
            TaskWarpPedIntoVehicle(ped1, veh, -1)
            TaskWarpPedIntoVehicle(ped2, veh, 0)
            break
        end
    end
    -- Augmente le scope onesync
    SetEntityDistanceCullingRadius(ped1, 9999.9)
    SetEntityDistanceCullingRadius(ped2, 9999.9)
    SetEntityDistanceCullingRadius(veh, 9999.9)
    --print(veh, start, FourgonFinish[math.random(1, #FourgonFinish)], ped1, ped2, GetEntityCoords(ped1), GetEntityCoords(ped2))
    TriggerClientEvent("core:brinks:allCrewSpawn", -1, NetworkGetNetworkIdFromEntity(veh), start, FourgonFinish[math.random(1, #FourgonFinish)], NetworkGetNetworkIdFromEntity(ped1), NetworkGetNetworkIdFromEntity(ped2), group)

    TriggerClientEvent("brinksStartAttack", -1, NetworkGetNetworkIdFromEntity(veh), nil, group)
    -- Update pos while entity exists
    while DoesEntityExist(veh) do
        Wait(5000)
        TriggerClientEvent("core:events:brinks:updatepos", -1, GetEntityCoords(veh))
        print("Update events brinks pos", GetEntityCoords(veh))
    end
end

RegisterNetEvent("core:events:startBrinks", function(orga)
    local src = source
    if GetPlayer(src):getPermission() >= 2 then
        CreateBrinksbraquage(orga)
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Vous n'avez pas les permissions"
        })
    end
end)

RegisterNetEvent("core:brinks:illegal:finish", function()
    TriggerClientEvent("core:brinks:illegal:finish", -1)
end)
