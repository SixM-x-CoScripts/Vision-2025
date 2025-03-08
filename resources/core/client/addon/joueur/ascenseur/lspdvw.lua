local open = false
local main = RageUI.CreateMenu("", "Etage", 0.0, 0.0, "vision", "menu_title_ascenseur")
local pos = {
    { name = "Garage", pos = vector3(613.01, -10.98, 74.05) },
    { name = "RDC", pos = vector3(613.14, -11.15, 82.64) },
    { name = "Etage 1", pos = vector3(613.02, -11.21, 86.8) },
    { name = "Helipad", pos = vector3(602.39, -18.37, 100.34) },
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
function OpenLspdVWAscenseur()
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
        "lspd_ascenseur" .. k,
        vector3(v.pos.x, v.pos.y, v.pos.z),
        "~INPUT_CONTEXT~ Intéragir",
        function()
            OpenLspdVWAscenseur()
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
