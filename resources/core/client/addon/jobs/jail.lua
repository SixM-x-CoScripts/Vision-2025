local prisonLocation = vector3(1685.99, 2583.93, 50.5)
local prisonEntrance = vector3(1775.62, 2551.88, 44.57)
local releaseLocation = vector3(1845.77, 2585.93, 44.67)
local remainingJailTime = 0
local isInJail = false

while p == nil do Wait(1) end

local jailDoors = {
    {hash = 241550507, pos = vector4(1775.4141845703, 2491.025390625, 49.840057373047, 29.999996185303)},
    {hash = 241550507, pos = vector4(1772.9385986328, 2495.3132324219, 49.840057373047, 29.999996185303)},

    {hash = -1156020871, pos = vector4(1681.2083740234, 2564.7822265625, 46.252220153809, 269.30627441406)},
    {hash = -1156020871, pos = vector4(1618.3304443359, 2573.6110839844, 46.252220153809, 134.24517822266)},
    {hash = -1156020871, pos = vector4(1618.3071289062, 2533.8703613281, 46.252220153809, 225.06985473633)},
    {hash = -1156020871, pos = vector4(1623.3203125, 2519.109375, 46.252220153809, 185.64677429199)},
    {hash = -1156020871, pos = vector4(1653.7633056641, 2493.5766601562, 46.252220153809, 275.06982421875)},
    {hash = -1156020871, pos = vector4(1673.0327148438, 2489.5812988281, 46.252220153809, 224.84396362305)},
    {hash = -1156020871, pos = vector4(1712.7598876953, 2489.6130371094, 46.252220153809, 313.96069335938)},
    {hash = -1156020871, pos = vector4(1727.015625, 2509.4235839844, 46.062404632568, 255.21278381348)},
    {hash = -1156020871, pos = vector4(1761.3977050781, 2529.3381347656, 46.252220153809, 344.50881958008)},
    {hash = -1156020871, pos = vector4(1744.181640625, 2562.525390625, 46.252220153809, 269.50003051758)},
    {hash = -1156020871, pos = vector4(1708.4818115234, 2564.7824707031, 46.252220153809, 269.50003051758)},
    {hash = -1156020871, pos = vector4(1798.0900878906, 2591.6872558594, 46.417839050293, 179.99987792969)},
    {hash = -1156020871, pos = vector4(1797.7608642578, 2596.5649414062, 46.387306213379, 179.99987792969)},
    {hash = 1373390714, pos = vector4(1819.0743408203, 2594.8745117188, 46.086990356445, 270.31356811523)},
    {hash = 2074175368, pos = vector4(1772.8133544922, 2570.2963867188, 45.744674682617, 4.8494572639465)},
}

local function cuff(status)
    if not status then
        if isCuffed then
            TriggerEvent('core:CuffPlayer')
        end
    else
        if not isCuffed then
            TriggerEvent('core:CuffPlayer')
        end
    end
end

RegisterNetEvent('jail:sendToJail')
AddEventHandler('jail:sendToJail', function(time)
    remainingJailTime = time
    isInJail = true
    SetEntityCoords(PlayerPedId(), prisonEntrance.x, prisonEntrance.y, prisonEntrance.z)

    cuff(true)

    exports['vNotif']:createNotification({
        type = 'ROUGE',
        content = "Vous avez été emprisonné pour " .. tostring(disp_time(time)) .. "."
    }) 
end)

RegisterNetEvent('jail:releaseFromJail')
AddEventHandler('jail:releaseFromJail', function()
    releaseFromJail()
end)

function releaseFromJail()
    remainingJailTime = 0
    isInJail = false

    cuff(false)
    
    SetEntityCoords(PlayerPedId(), releaseLocation.x, releaseLocation.y, releaseLocation.z)

    exports['vNotif']:createNotification({
        type = 'VERT',
        content = "Vous avez été libéré de prison."
    })
end

CreateThread(function()
    while true do
        if isInJail then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - prisonLocation)

            if distance > 125.0 then
                SetEntityCoords(playerPed, prisonEntrance.x, prisonEntrance.y, prisonEntrance.z)
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Vous avez été téléporté à l'entrée de la prison car vous étiez trop loin."
                })
            end

            remainingJailTime = remainingJailTime - 1
            if remainingJailTime <= 0 then
                TriggerServerEvent('jail:releasePlayer')
            end

            for k, v in pairs(jailDoors) do
                local door = GetClosestObjectOfType(v.pos.x, v.pos.y, v.pos.z, 1.0, v.hash, false, false, false)
                SetEntityHeading(door, v.pos.w)
                FreezeEntityPosition(door, true)
            end

            Wait(500)
        else
            Wait(5000)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if isInJail and remainingJailTime > 0 then
            DrawSpecialText("Libération dans ".. tostring(disp_time(remainingJailTime)), 1, 0.025)
        end
    end
end)


RegisterNetEvent('jail:getRemainingTime')
AddEventHandler('jail:getRemainingTime', function(cb)
    cb(remainingJailTime)
end)
