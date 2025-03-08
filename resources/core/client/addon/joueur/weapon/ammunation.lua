local zoneAmmunation = {
    {
        position = vector3(16.340728759766, -1109.4506835938, 29.797199249268),
        blip = vector3(12.806353569031, -1102.8748779297, 29.797027587891)
    }
}
local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function OpenAmmunation()
    SendNUIMessage({
        type = "openWebview",
        name = "ammunation",
        data = ammunation["weapons"].nibard
    })
    TriggerScreenblurFadeIn(0.5)
    forceHideRadar()
end



RegisterNUICallback("ammunation__callback", function (data, cb)
    local have = false
    if p:pay(data.price) then
        for k, v in pairs(p:inventory()) do
            if v.name == string.lower(data.action) then
                TriggerSecurGiveEvent("core:addItemToInventory", token, string.lower(data.action), 1, {})
                -- ShowNotification("Vous venez d'acheter un(e)"..GetItemLabel(string.lower(data.action)))

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'DOLLAR',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous venez d'acheter ~s un(e)" .. GetItemLabel(string.lower(data.action))
                })

                have = true
                return
            end
        end
        if not have then
            TriggerSecurGiveEvent("core:addItemToInventory", token, string.lower(data.action), 1, {})
            -- ShowNotification("Vous venez d'acheter un(e)"..GetItemLabel(string.lower(data.action)))

            -- New notif
            exports['vNotif']:createNotification({
                type = 'DOLLAR',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous venez d'acheter ~s un(e)" .. GetItemLabel(string.lower(data.action))
            })


        end
    end
end)

RegisterNUICallback("focusOut", function (data, cb)
    TriggerScreenblurFadeOut(0.5)
    openRadarProperly()

end)


--for k, v in pairs(zoneAmmunation) do
--    Citizen.CreateThread(function()
--        while zone == nil do Wait(1) end
--
--        zone.addZone(
--            "Armurie"..math.random(1, 9999999), -- Nom
--            v.position,-- Position
--            "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir l'armurie",  -- Text afficher
--            function() -- Action qui seras fait
--                OpenAmmunation() -- Ouvrir le menu
--            end,
--            true, -- Avoir un marker ou non
--            29, -- Id / type du marker
--            0.4, -- La taille
--            {50, 168, 82}, -- RGB
--            170 -- Alpha
--        )
--        --AddBlip(v.blip,110,2,0.4, 5,'Armurie')
--    end)
--end
--zone.addZone(
--    "Armurie"..math.random(1, 9999999), -- Nom
--    vector3(13.762851715088, -1111.4958496094, 28.797216415405),-- Position
--    "Appuyer sur ~INPUT_CONTEXT~ pour acheter une boite de munition (~g~50$~s~)",  -- Text afficher
--    function() -- Action qui seras fait
--        if p:pay(50) then
--            TriggerSecurGiveEvent("core:addItemToInventory", token, "ammo30", 1, {}) -- Ouv le menu
--        else
--            -- ShowNotification("Vous n'avez ~r~pas assez d'argent~s~")

            -- New notif
            -- exports['vNotif']:createNotification({
            --     type = 'ROUGE',
            --     duration = 5, -- In seconds, default:  4
            --     content = "Vous n'avez ~s pas assez d'argent"
            -- })
--
--
--        end
--    end,
--    true, -- Avoir un marker ou non
--    25, -- Id / type du marker
--    0.4, -- La taille
--    {50, 168, 82}, -- RGB
--    170 -- Alpha
--)

function OpenMyNibardWeapon()
    local nibard = {}
    for k, v in pairs(p:getInventaire()) do
        if v.type == "weapons" then
            table.insert(nibard, {name = v.label, category = "Mon armes", hash = GetHashKey(v.name), picture = "https://cdn.sacul.cloud/v2/vision-cdn/Ammunation/"..v.name})
        end
    end
    SendNUIMessage({
        type = "openWebview",
        name = "ammunation_inventory",
        data = table.unpack(nibard)
    })
    TriggerScreenblurFadeIn(0.5)
    forceHideRadar()
end

