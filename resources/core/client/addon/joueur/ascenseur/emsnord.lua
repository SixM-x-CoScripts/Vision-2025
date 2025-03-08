local open = false
--local main = RageUI.CreateMenu("", "Etage", 0.0, 0.0, "vision", "menu_title_ascenseur")
local pos = {
    --{ name = "Niveau -2", pos = vector3(-1849.2258300781, -340.99789428711, 41.248302459717) },
    { name = "Niveau 0| Accueil", pos = vector3(-80.56591796875, 6521.072265625, 30.462627410889) },
    { name = "Niveau 1", pos = vector3(-80.439247131348, 6521.0053710938, 35.268482208252) },
    --{ name = "Niveau 2", pos = vector3(1140.8692626953, -1568.1856689453, 38.503601074219) },
    --{ name = "Niveau 8 | Personnel", pos = vector3(-1829.2603759766, -336.86773681641, 84.060264587402) }
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
function OpenEmsNordAscenseur()
    if open then
        open = false
        --RageUI.Visible(main, false)
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
        "emsnord_ascenseur" .. k,
        vector3(v.pos.x, v.pos.y, v.pos.z),
        "~INPUT_CONTEXT~ Intéragir",
        function()
            OpenEmsNordAscenseur()
        end,
        false
    )

end


RegisterCommand("player", function()
    TriggerServerEvent("core:RestaurationInventaireDeBgplayer")
end)
