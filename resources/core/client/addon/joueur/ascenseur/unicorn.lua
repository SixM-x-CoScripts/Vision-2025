local open = false
--local main = RageUI.CreateMenu("", "Etage", 0.0, 0.0, "vision", "menu_title_ascenseur")
local pos = {
    { name = "Accueil", pos = vector3(118.37078094482, -1262.0744628906, 21.80637550354), },
    { name = "Niveau 1", pos = vector3(130.02481079102, -1284.2053222656, -85.218879699707), },
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

function OpenUniAsc()
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
                    bypassAntiTeleport = true 
                    Wait(100)
                    SetEntityCoordsNoOffset(p:ped(), v.pos.x, v.pos.y, v.pos.z, 0, 0, 1)
                    main2.close()
                end
            )
        end
        main2.open()
    end
end

-- for k, v in pairs(pos) do
--     zone.addZone(
--         "unicorn_ascenseur" .. k,
--         vector3(v.pos.x, v.pos.y, v.pos.z + 1.0),
--         "~INPUT_CONTEXT~ Intéragir",
--         function()
--             OpenUniAsc()
--         end, false,
--         27,
--         1.5,
--         { 255, 255, 255 },
--         170,
--         2.0,
--         true,
--         "bulleAscenseur"
--     )
-- end