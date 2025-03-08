local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)
local tenue = {
    male = {
        ['tshirt_1'] = 15,
        ['tshirt_2'] = 0,
        ['torso_1'] = 505,
        ['torso_2'] = 0,
        ['decals_1'] = 0,
        ['decals_2'] = -1,
        ['arms'] = 3,
        ['pants_1'] = 61,
        ['pants_2'] = 0,
        ['shoes_1'] = 34,
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
        ['torso_1'] = 546,
        ['torso_2'] = 0,
        ['decals_1'] = 0,
        ['decals_2'] = 0,
        ['arms'] = 9,
        ['pants_1'] = 15,
        ['pants_2'] = 0,
        ['shoes_1'] = 35,
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
    vector3(1133.5166015625, -1570.9516601563, 34.032711029053),
    vector3(-259.38, 6308.38, 31.45),
    vector3(-81.300178527832, 6511.3891601563, 35.268520355225),
}

CreateThread(function()
    while zone == nil do Wait(1) end

    for k,v in pairs(pos) do
        zone.addZone(
            "patient"..math.random(0, 100),
            v,
            "Appuyer sur ~INPUT_CONTEXT~ pour prendre la tenue",
            function ()
                RecupTenuePatient()
            end,
            false, -- Avoir un marker ou non
            -1, -- Id / type du marker
            0.6, -- La taille
            { 0, 0, 0 }, -- RGB
            0, -- Alpha
            2.5,
            true,
            "bulleVetement"
        )
    end
end)

function RecupTenuePatient()
    if p:skin().sex == 0 then
        TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1, { renamed = "Tenue patient", data = tenue.male})
        -- ShowNotification("Vous venez de récupérer une tenue")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous venez de récupérer ~s une tenue"
        })

    elseif p:skin().sex == 1 then
        TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1, { renamed = "Tenue patient",data = tenue.female})
        -- ShowNotification("Vous venez de récupérer une tenue")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous venez de récupérer ~s une tenue"
        })

    end
end