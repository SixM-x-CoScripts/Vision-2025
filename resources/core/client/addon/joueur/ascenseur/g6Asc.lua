local open1 = false
local open2 = false
local open3 = false
local main1 = RageUI.CreateMenu("", "Etage", 0.0, 0.0, "vision", "menu_title_ascenseur")
local main2 = RageUI.CreateMenu("", "Etage", 0.0, 0.0, "vision", "menu_title_ascenseur")
local main3 = RageUI.CreateMenu("", "Etage", 0.0, 0.0, "vision", "menu_title_ascenseur")
local pos1 = {
    { name = "Accueil", pos = vector3(10.185568809509, -667.89343261719, 33.449153900146), },
    { name = "Niveau -1", pos = vector3(1.3630350828171, -703.4384765625, 16.131050109863), },
}
local pos2 = {
    { name = "Accueil", pos = vector3(2518.4682617188, -279.15686035156, -64.722846984863), },
    { name = "Niveau 1", pos = vector3(2520.98828125, -279.42196655273, -58.722988128662), },
    { name = "Niveau -1", pos = vector3(2521.5817871094, -279.19100952148, -70.720626831055), },
}
local pos3 = {
    { name = "Accueil", pos = vector3(2517.5678710938, -263.52798461914, -58.716407775879), },
    { name = "Niveau 1", pos = vector3(2517.4526367188, -260.8278503418, -55.123165130615), },
    { name = "Niveau 2", pos = vector3(2518.7060546875, -261.98034667969, -39.124980926514), },
}

--asc numero1
main1.Closed = function()
    RageUI.Visible(main1, false)
    open1 = false
end
function OpenG61()
    if open1 then
        open1 = false
        RageUI.Visible(main1, false)
        return
    else
        open1 = true
        RageUI.Visible(main1, true)
        CreateThread(function()
            while open1 do
                RageUI.IsVisible(main1, function()
                    for k, v in pairs(pos1) do
                        RageUI.Button(v.name, false, {}, true, {
                            onSelected = function()
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

for k, v in pairs(pos1) do
    zone.addZone(
        "g61_ascenseur" .. k,
        vector3(v.pos.x, v.pos.y, v.pos.z),
        "~INPUT_CONTEXT~ Intéragir",
        function()
            OpenG61()
        end,
        false
    )
end

--asc numero 2
main2.Closed = function()
    RageUI.Visible(main2, false)
    open2 = false
end
function OpenG62()
    if open2 then
        open2 = false
        RageUI.Visible(main2, false)
        return
    else
        open2 = true
        RageUI.Visible(main2, true)
        CreateThread(function()
            while open2 do
                RageUI.IsVisible(main2, function()
                    for k, v in pairs(pos2) do
                        RageUI.Button(v.name, false, {}, true, {
                            onSelected = function()
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

for k, v in pairs(pos2) do
    zone.addZone(
        "g62_ascenseur" .. k,
        vector3(v.pos.x, v.pos.y, v.pos.z),
        "~INPUT_CONTEXT~ Intéragir",
        function()
            OpenG62()
        end,
        false
    )
end

--asc numero 3
main3.Closed = function()
    RageUI.Visible(main3, false)
    open3 = false
end
function OpenG63()
    if open3 then
        open3 = false
        RageUI.Visible(main3, false)
        return
    else
        open3 = true
        RageUI.Visible(main3, true)
        CreateThread(function()
            while open3 do
                RageUI.IsVisible(main3, function()
                    for k, v in pairs(pos3) do
                        RageUI.Button(v.name, false, {}, true, {
                            onSelected = function()
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

for k, v in pairs(pos3) do
    zone.addZone(
        "g63_ascenseur" .. k,
        vector3(v.pos.x, v.pos.y, v.pos.z),
        "~INPUT_CONTEXT~ Intéragir",
        function()
            OpenG63()
        end,
        false
    )
end