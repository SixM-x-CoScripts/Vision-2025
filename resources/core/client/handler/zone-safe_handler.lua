AllSafeZone = {}

local inter = 700

RegisterNetEvent('core:createZoneSafe')
AddEventHandler('core:createZoneSafe', function(name, pos)
    AllSafeZone[name] = {
        pos = pos
    }
end)

RegisterNetEvent('core:deleteZoneSafe')
AddEventHandler('core:deleteZoneSafe', function(name)
    AllSafeZone[name] = nil
end)

function GetZoneSafeTableCount()
    -- POURQUOI #AllSafeZone EST EGAL A 0 PUTAIN
    local count = 0
    for k,v in pairs(AllSafeZone) do
        count += 1
    end
    return count
end

local count = 0
local shownHUD = false
Citizen.CreateThread(function()
    while p == nil do Wait(100) end
    Wait(2300)

    AllSafeZone = TriggerServerCallback('core:admin:getAllZoneSafe')
    while AllSafeZone == nil do Wait(100) end

    while true do
        Wait(inter)
        playerCoords = GetEntityCoords(PlayerPedId())

        for k,v in pairs(AllSafeZone) do
            local pX, pY, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
            if isPlayerInsideZone(v.pos, pX, pY) then
                inter = 1
                if p:getJob() ~= "lspd" and p:getJob() ~= "lssd" and p:getJob() ~= "usss" and p:getJob() ~= "ems" and p:getJob() ~= "lsfd" and p:getJob() ~= "gouv" and p:getJob() ~= "gouv2" and p:getJob() ~= "g6" and p:getJob() ~= "usmc" and p:getPermission() < 3 then
                    SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), 1)
                end
                if GetWeaponDamageModifier(GetHashKey("weapon_unarmed")) ~= 0.0 then
                    SetWeaponDamageModifier(GetHashKey("weapon_unarmed"), 0.0)
                end
                SetEntityCanBeDamaged(PlayerPedId(), false)
                SetWeaponDamageModifier(-1553120962, 0.0)
                if not shownHUD then
                    shownHUD = true
                    SetWeaponDamageModifier(GetHashKey("weapon_unarmed"), 0.0)
                    -- Disable car damage
                    SetWeaponDamageModifier(-1553120962, 0.0)
                    exports["aHUD"]:toggleSafeZoneIndicator(true)
                end
            else
                count += 1
            end
        end
        --print(GetZoneSafeTableCount(), count)
        if GetZoneSafeTableCount() == count then
            if shownHUD then
                shownHUD = false
                SetWeaponDamageModifier(-1553120962, 1.0)
                SetEntityCanBeDamaged(PlayerPedId(), true)
                SetWeaponDamageModifier(GetHashKey("weapon_unarmed"), 1.0)
                exports["aHUD"]:toggleSafeZoneIndicator(false)
                if GetWeaponDamageModifier(GetHashKey("weapon_unarmed")) ~= 1.0 then
                    SetWeaponDamageModifier(GetHashKey("weapon_unarmed"), 1.0)
                end
                if GetWeaponDamageModifier(-1553120962) ~= 1.0 then
                    SetWeaponDamageModifier(-1553120962, 1.0)
                end
            end
            inter = 700
            count = 0
        end
        count = 0
    end
end)
