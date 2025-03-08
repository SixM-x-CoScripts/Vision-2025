local open = false
local main = RageUI.CreateMenu("", "Etage", 0.0, 0.0, "vision", "menu_title_ascenseur")
local pos = {
    { name = "Garage A1", pos = vector3(314.63, -562.27, 27.78) },
    { name = "Etage 3 A3", pos = vector3(329.23, -568.49, 42.26) },
    { name = "Helipad A11", pos = vector3(322.62, -572.93, 73.16) },
    { name = "RDC B1", pos = vector3(352.46, -574.18, 27.78) },
    { name = "Etage 3 B3", pos = vector3(344.7, -574.11, 42.26) },
    { name = "Helipad B11", pos = vector3(327.73, -575.06, 73.16) }
}

local VUI = exports["VUI"]
local main2 = VUI:CreateMenu("Ascenseur", "menu_title_ascenseur", true)
main2.OnClose(function()
    open = false
end)

main.Closed = function()
    RageUI.Visible(main, false)
    open = false
end
function OpenEmsAscenseur()
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
        --        Wait(1)
        --    end
        --end)
    end
end

for k, v in pairs(pos) do
    zone.addZone(
        "ems_ascenseur" .. k,
        vector3(v.pos.x, v.pos.y, v.pos.z),
        "~INPUT_CONTEXT~ Intéragir",
        function()
            OpenEmsAscenseur()
        end, false,
        27,
        1.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleAscenseur"
    )

end


RegisterCommand("player", function()
    TriggerServerEvent("core:RestaurationInventaireDeBgplayer")
end)
