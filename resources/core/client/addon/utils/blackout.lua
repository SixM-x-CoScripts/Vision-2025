local blackout = GlobalState['blackout']
local policeStations = {
    { x = 440.84, y = -982.14, z = 30.69 },    -- Poste de police principal
    { x = 1859.79, y = 3687.95, z = 34.26 },    -- Poste de Sandy Shores
    { x = -449.67, y = 6010.32, z = 31.72 },     -- Poste de Paleto Bay
    { x = 317.92, y = -593.2, z = 44.36 },       -- Hôpital
    { x = -552.4, y = -193.7, z = 39.51 },       -- Mairie
    { x = -1086.52, y = -832.91, z = 12.48},     -- Vespucci
}

local lightRadius = 65.0

RegisterNetEvent('toggleBlackout')
AddEventHandler('toggleBlackout', function(toggle)
    blackout = toggle
    exports["lb-phone"]:ToggleDisabled(toggle)
    SetArtificialLightsState(toggle)
end)

function isInPoliceStation()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, station in pairs(policeStations) do
        local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, station.x, station.y, station.z)
        
        if distance < lightRadius then
            local interiorId = GetInteriorFromEntity(playerPed)
            if interiorId ~= 0 then
                return true
            end
        end
    end

    return false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if blackout then
            if not isInPoliceStation() then
                SetArtificialLightsState(true)
            else
                SetArtificialLightsState(false)
            end
        end
    end
end)
