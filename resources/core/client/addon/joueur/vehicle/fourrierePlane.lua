local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local open = false
local main = RageUI.CreateMenu('', "Vehicule", 0.0, 0.0, "root_cause", "Banner-Fourriere")
local stock = {}

main.onClosed = function()
    open = false
    RageUI.Visible(main, false)
end

local spawnHeli = {
    vector4(-1145.7640380859, -2864.3999023438, 12.946008682251, 326.39483642578),
    vector4(-1112.7847900391, -2883.8640136719, 12.946004867554, 320.01376342773),
    vector4(-1178.4759521484, -2845.8122558594, 12.945762634277, 329.42330932617),
}

local spawnPlane = {
    vector4(-1119.6589355469, -2951.5, 12.94501209259, 326.18923950195),
    vector4(-1156.0045166016, -2927.650390625, 12.945034980774, 329.17071533203),
}

function OpenFourrierePlane() -- TODO : Add detection of player's car that disappeared to add them back to fourrière
    if open then
        open = false
        RageUI.Visible(main, false)
        return
    else
        open = true
        RageUI.Visible(main, true)
        stock = TriggerServerCallback("core:GetVehicles")
        CreateThread(function()
            while open do
                RageUI.IsVisible(main, function()
                    if stock ~= nil then
                        RageUI.Separator("↓ Avions ↓")
                        for k, v in pairs(stock) do
                            if GetVehicleClassFromName(v.name) == 16 then
                                RageUI.Button("[~r~" .. v.currentPlate .. "~s~] " .. GetLabelText(v.name), false,
                                    { RightLabel = "~g~100$" }, true, {
                                    onSelected = function()
                                        for key, value in pairs(spawnPlane) do
                                            if vehicle.IsSpawnPointClear(vector3(value.x, value.y, value.z), 3.0) then
                                                if p:pay(100) then
                                                    local veh = vehicle.create(v.name, value, v.props)
                                                    TaskWarpPedIntoVehicle(p:ped(), veh, -1)
                                                    TriggerServerEvent("core:SetVehicleOut", string.upper(vehicle.getPlate(veh)), VehToNet(veh), veh)
                                                    open = false
                                                    RageUI.CloseAll()
                                                    return
                                                else
                                                    ShowNotification("Vous n'avez ~r~pas assez d'argent~s~")
                                                end
                                            else
                                                ShowNotification("~r~Le véhicule ne peut pas sortir")
                                            end
                                        end
                                    end
                                })
                            end
                        end
                        RageUI.Separator("↓ Hélicoptères ↓")
                        for k, v in pairs(stock) do
                            if GetVehicleClassFromName(v.name) == 15 then
                                RageUI.Button("[~r~" .. v.currentPlate .. "~s~] " .. GetLabelText(v.name), false,
                                    { RightLabel = "~g~100$" }, true, {
                                    onSelected = function()
                                        for key, value in pairs(spawnHeli) do
                                            if vehicle.IsSpawnPointClear(vector3(value.x, value.y, value.z), 3.0) then
                                                if p:pay(100) then
                                                    local veh = vehicle.create(v.name, value, v.props)
                                                    TaskWarpPedIntoVehicle(p:ped(), veh, -1)
                                                    TriggerServerEvent("core:SetVehicleOut", string.upper(vehicle.getPlate(veh), veh)
                                                        , VehToNet(veh))
                                                    open = false
                                                    RageUI.CloseAll()
                                                    return
                                                else
                                                    ShowNotification("Vous n'avez ~r~pas assez d'argent~s~")
                                                end
                                            else
                                                ShowNotification("~r~Le véhicule ne peut pas sortir")
                                            end
                                        end
                                    end
                                })
                            end
                        end
                    else
                        RageUI.Separator("Aucun véhicule")
                    end
                end)
                Wait(1)
            end
        end)
    end
end

CreateThread(function()
    while zone == nil do Wait(1) end
    zone.addZone(
        "fourrièrePlane", -- Nom
        vector3(-1078.1488037109, -2863.1496582031, 13.950980186462), -- Position
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir la fourrière", -- Text affiché
        function()
            OpenFourrierePlane()
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.8, -- La taille
        { 235, 192, 15 }, -- RGB
        170, -- Alpha
        3, -- Interact Dist
        true,
        "bulleFourriere"
    )     
end)
