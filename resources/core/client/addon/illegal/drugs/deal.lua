local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)


function GetClosestNPC(dist)
    local coords = GetEntityCoords(PlayerPedId())
    local closestPed = nil
    local shortestDistance = dist
    for ped in EnumeratePeds() do
        if IsPedHuman(ped) and IsPedOnFoot(ped) and not IsPedAPlayer(ped) then
            local pedCoords = GetEntityCoords(ped)
            local distance = GetDistanceBetweenCoords(pedCoords, coords, true)
            if shortestDistance > distance then
                closestPed = ped
                shortestDistance = distance
            end
        end
    end
    return closestPed
end

function tableContains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function tablekeycontains(table, element)
    for key, value in pairs(table) do
        if key == element then
            return true
        end
    end
    return false
end

local policeMans


