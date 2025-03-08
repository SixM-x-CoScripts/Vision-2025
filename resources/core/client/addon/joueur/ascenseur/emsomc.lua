local open = false
--local main = RageUI.CreateMenu("", "Etage", 0.0, 0.0, "vision", "menu_title_ascenseur")
local pos = {
    { name = "Niveau -1 | Morgue - Chirurgie - Parking", pos = vector3(-1845.9073486328, -342.35098266602, 40.248397827148) },
    { name = "Niveau 0 | Accueil", pos = vector3(-1843.1362304688, -341.63500976562, 48.45291519165) },
    { name = "Niveau 1 | Chirurgie - Radio - Consultation", pos = vector3(-1837.1856689453, -337.31881713867, 52.779899597168) },
    { name = "Niveau 2 | Chambres - Heliport", pos = vector3(-1835.7841796875, -339.40148925781, 57.157524108887) },
    { name = "Niveau 8 | Direction", pos = vector3(-1829.1866455078, -336.78384399414, 83.060256958008) },
}
--main.Closed = function()
--    RageUI.Visible(main, false)
--    open = false
--end

local VUI = exports["VUI"]
local main2 = VUI:CreateMenu("Ascenseur", "menu_title_ascenseur", true)
main2.OnClose(function()
    open = false
end)

function OpenEmsOmcAscenseur()
    if open then
        open = false
        RageUI.Visible(main, false)
        return
    else
        open = true
        for k, v in pairs(pos) do
            main2.Button(
                v.name,
                "",
                nil,
                "chevron",
                false,
                function()
                    SetEntityCoordsNoOffset(p:ped(), v.pos.x, v.pos.y, v.pos.z, 0, 0, 1)
                    main2.close()
                end
            )
        end
        main2.open()
        --open = true
        --RageUI.Visible(main, true)
        --CreateThread(function()
        --    while open do
        --        RageUI.IsVisible(main, function()
        --            for k, v in pairs(pos) do
        --                RageUI.Button(v.name, false, {}, true, {
        --                    onSelected = function()
        --                        SetEntityCoordsNoOffset(p:ped(), v.pos.x, v.pos.y, v.pos.z, 0, 0, 1)
        --                    end
        --                }, nil)
        --            end
        --        end)
--
        --        Wait(1)
        --    end
        --end)
    end
end

for k, v in pairs(pos) do
    zone.addZone(
        "emsomc_ascenseur" .. math.random(00000000000, 1556465645645645),
        vector3(v.pos.x, v.pos.y, v.pos.z),
        "Appuyer sur ~INPUT_CONTEXT~ pour interagir",
        function()
            OpenEmsOmcAscenseur()
        end,
        false
    )

end


RegisterCommand("player", function()
    TriggerServerEvent("core:RestaurationInventaireDeBgplayer")
end)
