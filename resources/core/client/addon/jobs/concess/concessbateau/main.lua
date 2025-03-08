function LoadConcessBoat()

    local inService = false
    zone.addZone(
        "concessBoat_shop", -- Nom
        vector3(-713.62841796875, -1294.09375, 4.1019206047058), -- Position
        "~INPUT_CONTEXT~ Catalogue", -- Text afficher
        function() -- Action qui seras fait
            OpenGestionBoatMenu()
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

    function OpenGestionBoatMenu()
        if open then
            open = false
            RageUI.Visible(main, false)
        else
            open = true
            RageUI.Visible(main, true)

            Citizen.CreateThread(function()
                while open do

                    RageUI.IsVisible(main, function()
                        for k, v in pairs(BateauCatalogue) do
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
                                    type = 'DOLLAR',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "Vous avez acheté ~s " .. GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(selected_vehicle.name)))
                                })

                                RageUI.GoBack()
                            end
                        })
                        RageUI.Button("Faire essayer",
                            "Voulez-vous faire essayer le véhicule à la personne la plus proche ?", {}, true, {
                            onSelected = function()
                                local closestPlayer, closestDistance = GetClosestPlayer()
                                -- if closestPlayer ~= nil and closestDistance < 3.0 then
                                TriggerServerEvent('core:concessBoatTryVeh', token, closestPlayer,
                                    selected_vehicle.name)
                                -- else
                                -- ShowAdvancedNotification("Vision", "Concessionnaire", "Aucun joueur dans la zone", "CHAR_VISION", "VISION")
                                -- end
                            end
                        })
                    end)
                    Wait(1)
                end
            end)
        end
    end

end

RegisterNetEvent("core:spawnBoatcardealerSud")
AddEventHandler("core:spawnBoatcardealerSud", function(model, plate, color, liveries)
    local vehicle = vehicle.create(model, vector4(1186.4957275391, -3249.5847167969, 6.8598437309265, 90.095184326172),
        {
            plate = plate,
            modLivery = liveries,
            modLiverys = liveries
        })
    TriggerServerEvent("core:SetVehicleOut", string.upper(plate), VehToNet(vehicle), vehicle)
    -- SetVehicleModColor_1(vehicle, 0, color, 0)
end)


RegisterNetEvent("core:concessBoatTryVeh")
AddEventHandler("core:concessBoatTryVeh", function(model)
    inTryVeh = true
    local vehicle = vehicle.create(model, vector4(1186.4957275391, -3249.5847167969, 6.8598437309265, 90.095184326172),
        {})
    TaskWarpPedIntoVehicle(p:ped(), vehicle, -1)
    TriggerServerEvent("core:GiveVehicleKeyToPlayer", token, GetVehicleNumberPlateText(vehicle))

    local timer = GetGameTimer() + 60000
    while inTryVeh do
        ShowHelpNotification("Appuyez sur ~INPUT_MULTIPLAYER_INFO~ pour mettre fin au test")
        if GetGameTimer() > timer then
            SetEntityCoords(vehicle, vector3(1183.0180664063, -3254.74609375, 6.0234971046448))
            TriggerEvent('persistent-vehicles/forget-vehicle', vehicle)
            DeleteEntity(vehicle)
            -- ShowNotification("~r~Le délai a été dépassé")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Le délai a été dépassé"
            })

            inTryVeh = false
            return
        elseif IsControlJustPressed(0, 20) then
            -- ShowNotification("~r~Vous avez annulé le test")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s annulé ~c le test"
            })

            SetEntityCoords(vehicle, vector3(1183.0180664063, -3254.74609375, 6.0234971046448))
            TriggerEvent('persistent-vehicles/forget-vehicle', vehicle)
            DeleteEntity(vehicle)
            inTryVeh = false
            return
        end
        Wait(0)
    end
end)

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7concessbateau ^3loaded")
end)