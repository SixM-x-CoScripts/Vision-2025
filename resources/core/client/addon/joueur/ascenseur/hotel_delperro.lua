local open = false
local main = RageUI.CreateMenu("", "Etage", 0.0, 0.0, "vision", "menu_title_ascenseur")
local pos = {
    { name = "Accueil", pos = vector3(-658.6233, -1110.5697, 15.0633), },
    { name = "Niveau 1", pos = vector3(-655.2101, -1110.6490, 21.8344), },
    { name = "Niveau 2", pos = vector3(-655.7173, -1110.5150, 26.6028), },
    { name = "Niveau 3", pos = vector3(-655.5388, -1110.5977, 31.372), },
    { name = "Niveau 4", pos = vector3(-655.7173, -1110.5150, 36.1360), },
    { name = "Niveau 5", pos = vector3(-655.7173, -1110.5150, 40.9058), },
    { name = "Niveau 6", pos = vector3(-655.7173, -1110.5150, 45.6744), },
}
main.Closed = function()
    RageUI.Visible(main, false)
    open = false
end
function OpenHotelAscenseur()
    if open then
        open = false
        RageUI.Visible(main, false)
        return
    else
        open = true
        RageUI.Visible(main, true)
        CreateThread(function()
            while open do
                RageUI.IsVisible(main, function()
                    for k, v in pairs(pos) do
                        RageUI.Button(v.name, false, {}, true, {
                            onSelected = function()
                                bypassAntiTeleport = true 
                                Wait(100)
                                SetEntityCoords(p:ped(), v.pos.x, v.pos.y, v.pos.z, 0, 0, 1)

                            end
                        }, nil)
                    end
                    Wait(1)
                end)
            end
        end)
    end
end

for k, v in pairs(pos) do
    zone.addZone(
        "hotelDP_ascenseur" .. k,
        vector3(v.pos.x, v.pos.y, v.pos.z),
        "~INPUT_CONTEXT~ Intéragir",
        function()
            OpenHotelAscenseur()
        end,
        false
    )

end
