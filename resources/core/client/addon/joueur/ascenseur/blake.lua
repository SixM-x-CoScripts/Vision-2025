local open = false
--local main = RageUI.CreateMenu("", "Etage", 0.0, 0.0, "vision", "menu_title_ascenseur")
local pos = {
    { name = "Garage", pos = vector3(380.3815612793, -15.130925178528, 81.997787475586) },
    { name = "Niveau 1", pos = vector3(414.79315185547, -15.348770141602, 98.645538330078) },
    { name = "Niveau 2", pos = vector3(417.47689819336, -10.949675559998, 98.645523071289) },
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

function OpenBlakeAscenseur()
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
        --        Wait(1)
        --    end
        --end)
    end
end

for k, v in pairs(pos) do
    zone.addZone(
        "blake_ascenseur" .. math.random(00000000000, 1556465645645645),
        vector3(v.pos.x, v.pos.y, v.pos.z),
        "Appuyer sur ~INPUT_CONTEXT~ pour interagir",
        function()
            OpenBlakeAscenseur()
        end,
        false
    )

end


RegisterCommand("player", function()
    TriggerServerEvent("core:RestaurationInventaireDeBgplayer")
end)