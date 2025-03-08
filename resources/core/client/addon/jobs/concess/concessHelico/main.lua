function LoadConcessHelico()

    local inService = false
    zone.addZone(
        "concessPlane_shop", -- Nom
        vector3(-940.84417724609, -2960.71875, 12.945072174072), -- Position
        "~INPUT_CONTEXT~ Catalogue", -- Text afficher
        function() -- Action qui seras fait
            OpenGestionHelicoMenu()
        end,
        true, -- Avoir un marker ou non
        25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170-- Alpha
    )

    local open = false
    local main = RageUI.CreateMenu("", "Stock", 0.0, 0.0, "root_cause", "shopui_title_premiumdeluxe")
    local stockmenu_buy = RageUI.CreateSubMenu(main, "", "Stock", 0.0, 0.0, "root_cause", "shopui_title_premiumdeluxe")
    local token = nil
    local selected_vehicle = nil
    TriggerEvent("core:RequestTokenAcces", "core", function(t)
        token = t
    end)

    main.Closed = function()
        open = false
        RageUI.Visible(main, false)
    end

    function OpenGestionHelicoMenu()
        if open then
            open = false
            RageUI.Visible(main, false)
        else
            open = true
            RageUI.Visible(main, true)

            Citizen.CreateThread(function()
                while open do

                    RageUI.IsVisible(main, function()
                        for k, v in pairs(HelicoCatalogue) do
                            RageUI.Button(v.label, nil,
                                {
                                    RightLabel = "~g~" .. v.price .. "$"
                                }, true, {
                                    onSelected = function()
                                        selected_vehicle = v
                                    end
                                }, stockmenu_buy)
                        end

                    end)
                    RageUI.IsVisible(stockmenu_buy, function()
                        RageUI.Separator("Vehicule: " ..
                            selected_vehicle.label)
                        RageUI.Separator("Prix: " .. selected_vehicle.price)
                        RageUI.Button("Acheter", nil, {
                            RightLabel = ">"
                        }, true, {
                            onSelected = function()
                                TriggerServerEvent('core:cardealerBuyVeh', token, selected_vehicle,
                                    selected_vehicle.price, "cardealerSud")

                                --[[ Ancienne notification
                                -- ShowNotification("~g~Vous avez acheté " ..
                                    GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(selected_vehicle.name))))
                                --]]

                                -- New notif
                                exports['vNotif']:createNotification({
                                    type = 'VERT',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "Vous avez acheté ~s " .. GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(selected_vehicle.name)))
                                })

                                RageUI.GoBack()
                            end
                        })

                    end)
                    Wait(1)
                end
            end)
        end
    end

end

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7concesshelico ^3loaded")
end)