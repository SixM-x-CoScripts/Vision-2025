local hospitalBeds = {
    {id = 1, x = 327.57, y = -583.75, z = 42.27, heading = 340.0, pedPos = 1.20, occupied = false, player = nil},
    {id = 2, x = 330.68, y = -584.90, z = 42.27, heading = 340.0, pedPos = -1.20, occupied = false, player = nil},
    {id = 3, x = 328.44, y = -588.82, z = 42.27, heading = 160.0, pedPos = -1.20, occupied = false, player = nil},
    {id = 4, x = 325.60, y = -587.79, z = 42.27, heading = 160.0, pedPos = 1.20, occupied = false, player = nil},
    {id = 5, x = 322.64, y = -586.71, z = 42.27, heading = 160.0, pedPos = 1.20, occupied = false, player = nil},
    {id = 6, x = 319.78, y = -585.60, z = 42.27, heading = 160.0, pedPos = -1.20, occupied = false, player = nil},
    {id = 7, x = 316.90, y = -584.56, z = 42.27, heading = 160.0, pedPos = -1.20, occupied = false, player = nil},
    {id = 8, x = 318.39, y = -580.50, z = 42.27, heading = 340.0, pedPos = 1.20, occupied = false, player = nil},
    {id = 9, x = 321.27, y = -581.55, z = 42.27, heading = 340.0, pedPos = -1.20, occupied = false, player = nil}
}

local nurseReception = {x = 311.03, y = -586.06, z = 42.27, heading = 157.57}

RegisterServerEvent('hospital:requestTreatment')
AddEventHandler('hospital:requestTreatment', function(amount, emsInDuty)
    local source = source
    local freeBed = nil

    if amount > 0 and emsInDuty > 0 then
        print("Infirmière | Ajout de " .. amount/2 .. "$ à la société ems")
        AddMoneyToSociety(amount/2, "ems")
    end

    for _, bed in ipairs(hospitalBeds) do
        if not bed.occupied then
            freeBed = bed
            bed.occupied = true
            bed.player = source
            break
        end
    end

    if freeBed then
        TriggerClientEvent('hospital:startTreatment', source, freeBed)
        Citizen.CreateThread(function()
            Citizen.Wait(5 * 60 * 1000)
            if freeBed.occupied and freeBed.player == source then
                freeBed.occupied = false
                freeBed.player = nil
            end
        end)
    else
        TriggerClientEvent("__atoshi::createNotification", source, {
            type = 'ROUGE',
            content = "Aucun lit libre disponible actuellement."
        })
    end
end)

RegisterCommand("resetbed", function(source, args, rawCommand)
    if source == 0 or HasPermission(source, 5) then
        for _, bed in ipairs(hospitalBeds) do
            bed.occupied = false
            bed.player = nil
        end
    end
end, false)

RegisterServerEvent('hospital:freeBed')
AddEventHandler('hospital:freeBed', function(bed)
    for _, b in ipairs(hospitalBeds) do
        if b.x == bed.x and b.y == bed.y and b.z == bed.z then
            b.occupied = false
            b.player = nil
            break
        end
    end
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    for _, bed in ipairs(hospitalBeds) do
        if bed.occupied and bed.player == source then
            bed.occupied = false
            bed.player = nil
            break
        end
    end
end)
