local open = false
--local main = RageUI.CreateMenu("", "Etage", 0.0, 0.0, "vision", "menu_title_ascenseur")
local pos = {
    { name = "Accueil", pos = vector3(2497.3212890625, -349.40048217773, 94.092300415039), },
    { name = "Niveau 1", pos = vector3(2497.2077636719, -349.44778442383, 101.89334869385), },
    { name = "Niveau 2", pos = vector3(2497.26953125, -349.29458618164, 105.69055938721), },
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

function OpenEtatMajor()
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

for k, v in pairs(pos) do
    zone.addZone(
        "major_ascenseur" .. k,
        vector3(v.pos.x, v.pos.y, v.pos.z),
        "~INPUT_CONTEXT~ Intéragir",
        function()
            OpenEtatMajor()
        end,
        false
    )

end
