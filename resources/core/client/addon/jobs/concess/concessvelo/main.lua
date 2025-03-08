-- Désactivation du Job Vespucci Bike

--[[ local stockGestion = {}
local colors_list = {
    { id = 1, name = "Noir" },
    { id = 5, name = "Gris" },
    { id = 74, name = "Blanc" },
}

local color = 1
function LoadVespucciBike()

    local inService = false
    zone.addZone(
        "vespuccibike_shop" .. math.random(1, 99999999), -- Nom
        vector3(-1319.1618652344, -1521.3093261719, 4.4247517585754), -- Position
        "~INPUT_CONTEXT~ Catalogue", -- Text afficher
        function() -- Action qui seras fait
            OpenGestionMenu()
        end,
        false, -- Avoir un marker ou non
        25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170-- Alpha
    )


    zone.addZone("vespucci_gestionsociety", -- Nom
        vector3(-1327.3726806641, -1521.0057373047, 3.4332332611084), -- Position
        "~INPUT_CONTEXT~ Intéragir", -- Text afficher
        function() -- Action qui seras fait
            if inService then
                OpenSocietyMenu()
            else
                -- ShowNotification("~r~Vous n'êtes pas en service")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous n'êtes ~s pas en service"
                })

            end
        end, false, -- Avoir un marker ou non
        25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170-- Alpha
    )
    zone.addZone("vestpucci_gestionsocietysss", -- Nom
        vector3(-1319.2653808594, -1513.2103271484, 3.43675518035893), -- Position
        "~INPUT_CONTEXT~ Intéragir", -- Text afficher
        function() -- Action qui seras fait
            if inService then
                OpenInventorySocietyMenu()
            else
                -- ShowNotification("~r~Vous n'êtes pas en service")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous n'êtes ~s pas en service"
                })

            end
        end, true, -- Avoir un marker ou non
        25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170-- Alpha
    )


    zone.addZone("vespuccibike_service", vector3(-1311.2595214844, -1521.5772705078, 3.4167666435242),
        "Appuyer sur ~INPUT_CONTEXT~ pour prendre/quitter votre service", function()
            if not inService then
                -- ShowNotification("~g~Vous avez pris votre service")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous avez ~s pris ~c votre service"
                })

                TriggerServerEvent('core:DutyOn', 'concessvelo')
                inService = true
                Wait(5000)
            else
                -- ShowNotification("~r~Vous avez quitté votre service")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous avez ~s quitté ~c votre service"
                })

                TriggerServerEvent('core:DutyOff', 'concessvelo')
                inService = false
                Wait(5000)

            end
        end, false)

    local open = false
    local main = RageUI.CreateMenu("", "Stock", 0.0, 0.0, "vision", "Banner_VespucciBike")
    local stockmenu_buy = RageUI.CreateSubMenu(main, "", "Stock", 0.0, 0.0, "vision", "Banner_VespucciBike")
    local token = nil
    local selected_vehicle = nil
    TriggerEvent("core:RequestTokenAcces", "core", function(t)
        token = t
    end)

    main.Closed = function()
        open = false
        RageUI.Visible(main, false)
    end

    function OpenGestionMenu()
        if open then
            open = false
            RageUI.Visible(main, false)
        else
            open = true
            RageUI.Visible(main, true)

            Citizen.CreateThread(function()
                while open do

                    RageUI.IsVisible(main, function()
                        RageUI.Button("Skate", false, { RightLabel = "~g~25$" }, true, {
                            onSelected = function()
                                local removed = TriggerServerCallback("core:BuySKate", token, 25)
                                TriggerSecurGiveEvent("core:addItemToInventory", token, "skate", 1, {})
                                -- ShowNotification("Vous venez d'acheter un skate")

                                -- New notif
                                exports['vNotif']:createNotification({
                                    type = 'JAUNE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "Vous venez d'acheter ~s un skate"
                                })

                            end
                        }, nil)
                        RageUI.Button("Planche de surf", false, { RightLabel = "~g~1000$" }, true, {
                            onSelected = function()
                                local removed = TriggerServerCallback("core:BuySKate", token, 1000)
                                TriggerSecurGiveEvent("core:addItemToInventory", token, "surfboard", 1, {})
                                -- ShowNotification("Vous venez d'acheter un skate")

                                -- New notif
                                exports['vNotif']:createNotification({
                                    type = 'JAUNE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "Vous venez d'acheter ~s une Planche de surf"
                                })

                            end
                        }, nil)
                        for k, v in pairs(VespucciBike) do
                            if v.model ~= "surfboard" then
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.model)), nil,
                                    {
                                        RightLabel = "~g~" .. v.price .. "$"
                                    }, true, {
                                        onSelected = function()
                                            selected_vehicle = v
                                        end
                                    }, stockmenu_buy)
                            end
                        end

                    end)
                    RageUI.IsVisible(stockmenu_buy, function()
                        RageUI.Separator("Vehicule: " ..
                            GetLabelText(GetDisplayNameFromVehicleModel(selected_vehicle.name)))
                        RageUI.Separator("Prix: " .. selected_vehicle.price)
                        RageUI.Button("Acheter", nil, {
                            RightLabel = ">"
                        }, true, {
                            onSelected = function()
                                TriggerServerEvent('core:VespucciBikeAddStock', token, selected_vehicle,
                                    selected_vehicle.price)

                                --[[ Ancienne notification
                                -- ShowNotification("~g~Vous avez acheté " ..
                                --    GetLabelText(GetDisplayNameFromVehicleModel(selected_vehicle.name)))
                                

                                -- New notif
                                exports['vNotif']:createNotification({
                                    type = 'JAUNE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "Vous venez d'acheter ~s " .. GetLabelText(GetDisplayNameFromVehicleModel(selected_vehicle.name))
                                })
                                    
                                RageUI.GoBack()
                            end
                        })
                        RageUI.Button("Faire essayer",
                            "Voulez-vous faire essayer le véhicule à la personne la plus proche ?", {}, true, {
                            onSelected = function()
                                local closestPlayer, closestDistance = GetClosestPlayer()
                                -- if closestPlayer ~= nil and closestDistance < 3.0 then
                                TriggerServerEvent('core:concessVeloTryVeh', token, closestPlayer,
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

    local open = false
    local cardealerSudMenu_main = RageUI.CreateMenu("", "Concessionnaire", 0.0, 0.0, "vision",
        "Banner_VespucciBike")
    local cardealerSudMenu_giveVehicle = RageUI.CreateSubMenu(cardealerSudMenu_main, "", "Concessionnaire", 0.0, 0.0,
        "vision", "Banner_VespucciBike")
    local cardealerSudMenu_select_buyer = RageUI.CreateSubMenu(cardealerSudMenu_giveVehicle, "", "Concessionnaire", 0.0, 0.0,
        "vision", "Banner_VespucciBike")
    local cardealerSudMenu_select_color = RageUI.CreateSubMenu(cardealerSudMenu_giveVehicle, "", "Concessionnaire", 0.0, 0.0,
        "vision", "Banner_VespucciBike")
    local cardealerSudMenu_billing = RageUI.CreateSubMenu(cardealerSudMenu_main, "", "Concessionnaire", 0.0, 0.0,
        "vision", "Banner_VespucciBike")
    cardealerSudMenu_main.Closed = function()
        open = false
    end

    local vehicle_selected_to_give = {}
    local plys = {}
    local billing_price = 0
    local billing_reason = ""
    local ACrew = true
    function openVespucciMenu()
        if open then
            open = false
            RageUI.Visible(cardealerSudMenu_main, false)
        else
            open = true
            RageUI.Visible(cardealerSudMenu_main, true)
            stockGestion = TriggerServerCallback("core:GestionVespucciBike", token)
            plys = {}

            Citizen.CreateThread(function()
                while open do
                    RageUI.IsVisible(cardealerSudMenu_main, function()
                        RageUI.Button("Attribuer un véhicule", nil, {}, true, {
                            onSelected = function()
                                ACrew = false
                                stockGestion = TriggerServerCallback("core:GestionVespucciBike", token)
                            end
                        }, cardealerSudMenu_giveVehicle)
                        RageUI.Button("Attribuer un véhicule au crew", nil, {}, true, {
                            onSelected = function()
                                ACrew = true
                                stockGestion = TriggerServerCallback("core:GestionVespucciBike", token)
                            end
                        }, cardealerSudMenu_giveVehicle)
                        RageUI.Button("Faire une facture", nil, {}, true, {
                            onSelected = function()
                                billing_price = 0
                                billing_reason = ""
                            end
                        }, cardealerSudMenu_billing)
                    end)
                    RageUI.IsVisible(cardealerSudMenu_giveVehicle, function()
                        if stockGestion ~= nil then
                            for k, v in pairs(stockGestion) do
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.name)), nil, {}, true, {
                                    onSelected = function()
                                        vehicle_selected_to_give = v
                                    end
                                }, cardealerSudMenu_select_color)
                            end
                        end
                    end)
                    RageUI.IsVisible(cardealerSudMenu_select_color, function()
                        RageUI.Separator("Vehicule: " ..
                            GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(vehicle_selected_to_give.name))))
                        RageUI.Separator("Prix: " .. vehicle_selected_to_give.price)
                        for k, v in pairs(colors_list) do
                            RageUI.Button("Couleur " .. v.name, nil, {}, true, {
                                onSelected = function()
                                    color = v.id
                                    GetAllPlayersInAreaWithDataVelo()
                                end
                            }, cardealerSudMenu_select_buyer)
                        end
                    end)
                    RageUI.IsVisible(cardealerSudMenu_select_buyer, function()
                        if plys then
                            for k, v in pairs(plys) do
                                RageUI.Button("~o~" .. v.player .. "~s~ | ~o~" .. v.name, nil, {}, true, {
                                    onSelected = function()
                                        if ACrew then
                                            TriggerServerEvent('core:assignBuyerToBike', token,
                                                vehicle_selected_to_give, v.player, v.crew, color)
                                            RageUI.CloseAll()
                                            open = false
                                        else
                                            TriggerServerEvent('core:assignBuyerToBike', token,
                                                vehicle_selected_to_give, v.player, "None", color)
                                            RageUI.CloseAll()
                                            open = false
                                        end
                                    end
                                }, nil)
                            end
                        else
                            RageUI.Button("Aucun joueur dans la zone", nil, {}, true, {})
                        end
                    end)
                    RageUI.IsVisible(cardealerSudMenu_billing, function()
                        if billing_price ~= 0 then
                            RageUI.Separator("Prix: ~g~" .. billing_price .. "$")
                        else
                            RageUI.Separator("Prix: ~r~À définir")
                        end
                        RageUI.Separator("Raison: ~o~" .. billing_reason)
                        RageUI.Button("Modifier le prix", nil, {
                            RightLabel = ">"
                        }, true, {
                            onSelected = function()
                                local price = KeyboardImput("Entrez le prix")
                                if price and type(tonumber(price)) == "number" then
                                    billing_price = tonumber(price)
                                else
                                    --[[ ShowAdvancedNotification("Vision", "Concessionnaire", "Veuillez entrer un nombre",
                                    --    "CHAR_VISION", "VISION") 

                                    -- New notif
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        -- duration = 5, -- In seconds, default:  4
                                        content = "~s Veuillez entrer un nombre"
                                    })

                                end
                            end
                        }, nil)
                        RageUI.Button("Modifier la raison", nil, {
                            RightLabel = ">"
                        }, true, {
                            onSelected = function()
                                local reason = KeyboardImput("Entrez la raison")
                                if reason then
                                    billing_reason = tostring(reason)
                                end
                            end
                        }, nil)
                        RageUI.Button("Faire une facture", nil, {
                            RightLabel = ">"
                        }, billing_price > 0, {
                            onSelected = function()
                                local closestPlayer, closestDistance = GetClosestPlayer()
                                if closestPlayer ~= nil and closestDistance < 3.0 then
                                    TriggerServerEvent('core:sendbilling', token, GetPlayerServerId(closestPlayer),
                                        'concessvelo', billing_price, billing_reason)
                                    RageUI.CloseAll()
                                    open = false
                                else
                                    --[[ ShowAdvancedNotification("Vision", "Concessionnaire", "Aucun joueur dans la zone",
                                    --    "CHAR_VISION", "VISION")

                                    -- New notif
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        -- duration = 5, -- In seconds, default:  4
                                        content = "~s Aucun joueur dans la zone"
                                    })
                                        
                                end
                            end
                        }, nil)
                    end)
                    Wait(1)
                end
            end)
        end
    end

    RegisterJobMenu(openVespucciMenu)


    function GetAllPlayersInAreaWithDataVelo()
        local players = GetAllPlayersInArea(p:pos(), 5.0)
        plys = {}

        for k, v in pairs(players) do
            local src = GetPlayerServerId(v)
            local name = TriggerServerCallback("core:GetPlayerAreaName", src)
            local crew = TriggerServerCallback("core:GetPlayerCrewArea", src)
            table.insert(plys, {
                player = src,
                name = name,
                crew = crew
            })
        end
    end

end

RegisterNetEvent("core:spawnBikecardealerSud")
AddEventHandler("core:spawnBikecardealerSud", function(model, plate, color)
    local vehicle = vehicle.create(model, vector4(-1329.3978271484, -1511.8454589844, 4.3747210502625, 310.18414306641),
        {
            plate = plate
        })
    TriggerServerEvent("core:SetVehicleOut", string.upper(plate), VehToNet(vehicle), vehicle)
    SetVehicleModColor_1(vehicle, 0, color, 0)
end)


RegisterNetEvent("core:concessVeloTryVeh")
AddEventHandler("core:concessVeloTryVeh", function(model)
    inTryVeh = true
    local vehicle = vehicle.create(model, vector4(-1305.7052001953, -1522.2045898438, 3.7191114425659, 346.74743652344),
        {})
    TaskWarpPedIntoVehicle(p:ped(), vehicle, -1)
    TriggerServerEvent("core:GiveVehicleKeyToPlayer", token, GetVehicleNumberPlateText(vehicle))

    local timer = GetGameTimer() + 60000
    while inTryVeh do
        ShowHelpNotification("Appuyez sur ~INPUT_MULTIPLAYER_INFO~ pour mettre fin au test")
        if GetGameTimer() > timer then
            SetEntityCoords(vehicle, vector3(-1309.4404296875, -1521.5200195313, 3.4167618751526))
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

            SetEntityCoords(vehicle, vector3(-1309.4404296875, -1521.5200195313, 3.4167618751526))
            TriggerEvent('persistent-vehicles/forget-vehicle', vehicle)
            DeleteEntity(vehicle)
            inTryVeh = false
            return
        end
        Wait(0)
    end
end)
 ]]