local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)
local tenue = {
    male = {
        ['tshirt_1'] = 15,
        ['tshirt_2'] = 0,
        ['torso_1'] = 578,
        ['torso_2'] = 5,
        ['decals_1'] = 0,
        ['decals_2'] = -1,
        ['arms'] = 5,
        ['pants_1'] = 194,
        ['pants_2'] = 0,
        ['shoes_1'] = 27,
        ['shoes_2'] = 0,
        ['helmet_1'] = -1,
        ['helmet_2'] = 0,
        ['ears_1'] = -1,
        ['ears_2'] = 0,
        ['bproof_1'] = 0,
        ['bproof_2'] = 0,
        ['bags_1'] = 0,
        ['bags_2'] = 0,
        ['glasses_1'] = 0,
        ['glasses_2'] = 0,
        ['chain_1'] = -1,
        ['chain_2'] = 0,
        ['mask_1'] = -1,
        ['mask_2'] = 0
    },

    female = {
        ['tshirt_1'] = 15,
        ['tshirt_2'] = 0,
        ['torso_1'] = 5,
        ['torso_2'] = 0,
        ['decals_1'] = 0,
        ['decals_2'] = 0,
        ['arms'] = 15,
        ['pants_1'] = 222,
        ['pants_2'] = 0,
        ['shoes_1'] = 26,
        ['shoes_2'] = 0,
        ['helmet_1'] = -1,
        ['helmet_2'] = 0,
        ['ears_1'] = -1,
        ['ears_2'] = 0,
        ['bproof_1'] = 0,
        ['bproof_2'] = 0,
        ['bags_1'] = 30,
        ['bags_2'] = 0,
        ['glasses_1'] = -1,
        ['glasses_2'] = 0,
        ['chain_1'] = 0,
        ['chain_2'] = 0,
        ['mask_1'] = 0,
        ['mask_2'] = 0
    }
}


local pos = {
    vector3(1840.3818359375, 2579.2216796875, 45.014350891113)
}

CreateThread(function()

    local ped = entity:CreatePedLocal("s_m_m_prisguard_01", vector3(1840.4178466797, 2577.2375488281, 45.014354705811),
        357.03469848633)
    SetEntityInvincible(ped.id, true)
    ped:setFreeze(true)
    TaskStartScenarioInPlace(ped.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
    SetEntityAsMissionEntity(ped.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped.id, true)

    while zone == nil do Wait(1) end

    for k,v in pairs(pos) do
        zone.addZone(
            "patient"..math.random(0, 100),
            v,
            "Appuyer sur ~INPUT_CONTEXT~ pour prendre la tenue",
            function ()
                RecupTenuePrison()
            end,
            false, -- Avoir un marker ou non
            -1, -- Id / type du marker
            0.6, -- La taille
            { 0, 0, 0 }, -- RGB
            0, -- Alpha
            2.5,
            true,
            "bulleGarage"
        )
    end
end)

function RecupTenuePrison()
    if p:skin().sex == 0 then
        TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1, { renamed = "Tenue Prison", data = tenue.male})
        -- ShowNotification("Vous venez de récupérer une tenue")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous venez de récupérer ~s une tenue"
        })

    elseif p:skin().sex == 1 then
        TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1, { renamed = "Tenue Prison",data = tenue.female})
        -- ShowNotification("Vous venez de récupérer une tenue")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous venez de récupérer ~s une tenue"
        })

    end
end