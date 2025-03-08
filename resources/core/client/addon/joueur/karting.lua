function LoadKarting()
    local ped = nil
    local created = false
    if not created then
        ped = entity:CreatePedLocal("s_m_y_xmech_01", vector3(-164.50875854492, -2130.1123046875, 15.704847335815),
        199.38961791992)
        created = true
    end
    SetEntityInvincible(ped.id, true)
    ped:setFreeze(true)
    SetEntityAsMissionEntity(ped.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped.id, true)

    local vehicleOut = nil
    local currentVeh = nil

    zone.addZone(
        "karting_garage_vehicle",
        vector3(-164.50875854492, -2130.1123046875, 17.704847335815),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le menu Karting",
        function()
            openKartingMenu()
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        2.5,
        true,
        "bulleVehicule"
    )

    zone.addZone(
        "karting_garage",
        vector3(-161.04832458496, -2131.572265625, 16.704847335815),
        "Appuyer sur ~INPUT_CONTEXT~ pour ranger le kart",
        function()
            if IsPedInAnyVehicle(p:ped(), false) then
                local veh = GetVehiclePedIsIn(p:ped(), false)
                TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                DeleteEntity(veh)

            end
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        2.5,
        true,
        "bulleGarage"
    )

    local open = false
    local karting_main = RageUI.CreateMenu("", "Louer un Kart", 0.0, 0.0, "vision", "Banner_Karting")
    local karting_vehicle = RageUI.CreateSubMenu(karting_main, "", "Louer un Kart", 0.0, 0.0, "vision", "Banner_Karting")
    karting_main.Closed = function()
        open = false
    end

    local allVehicleList = {}
    local selected_vehicle = nil

    local veh = {
        { name = "Kart", model = "veto", price = 20 },
        { name = "Kart avancé", model = "veto2", price = 50 },
        -- {name = "Petit Kart", model = "veto"}
    }
    local vehs = nil
    ---OpenVeh
    local pos = {
        vector4(-164.12837219238, -2133.1064453125, 15.704847335815, 288.86737060547),
        vector4(-163.17570495605, -2135.7614746094, 15.704847335815, 275.03814697266),
        vector4(-161.5182800293, -2139.4555664062, 15.704887390137, 289.57696533203),
        vector4(-160.97682189941, -2142.2302246094, 15.704891204834, 294.86376953125),
        vector4(-160.16033935547, -2144.9357910156, 15.704885482788, 289.24298095703),
    }

    function openKartingMenu()
        if open then
            open = false
            RageUI.Visible(karting_main, false)
            return
        else
            open = true
            RageUI.Visible(karting_main, true)
            Citizen.CreateThread(function()
                while open do
                    RageUI.IsVisible(karting_main, function()
                        for k, v in pairs(veh) do
                            RageUI.Button(v.name, "Appuyer sur entrer pour sortir le véhicule",
                                { RightLabel = "~g~" .. v.price .. "$" }, true, { onSelected = function()
                                    for key, value in pairs(pos) do
                                        if vehicle.IsSpawnPointClear(vector3(value.x, value.y, value.z), 3.0) then
                                            if p:pay(v.price) then
                                                vehs = vehicle.create(v.model, vector4(value), {})
                                                return
                                            end
                                        end
                                    end
                                end,
                                }, nil)
                        end
                    end)
                    Wait(1)
                end
            end)
        end
    end
end

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    LoadKarting()
    print("^3[ACTIVITE]:^7 karting ^3loaded^7")
end)