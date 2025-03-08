local stockGestion = {}
local colors_list = {
	{ id = 1,  name = "Noir" },
	{ id = 5,  name = "Gris" },
	{ id = 74, name = "Blanc" },
}
local color = 1
local liveries = 0
local AJob = false
function LoadConcessEntreprise()
	local inService = false
	zone.addZone(
		"concessEntrepise_shop",                                     -- Nom
		vector3(1197.0632324219, -3254.0590820313, 7.0951867103577), -- Position
		"~INPUT_CONTEXT~ Catalogue",                                 -- Text afficher
		function()                                                   -- Action qui seras fait
			OpenGestionMenu()
		end,
		false,            -- Avoir un marker ou non
		25,               -- Id / type du marker
		0.6,              -- La taille
		{ 51, 204, 255 }, -- RGB
		170               -- Alpha
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
						for k, v in pairs(catalogueEnterprise) do
							RageUI.Button(v.name, nil,
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
							selected_vehicle.name)
						RageUI.Separator("Prix: " .. selected_vehicle.price)
						RageUI.Button("Acheter", nil, {
							RightLabel = ">"
						}, true, {
							onSelected = function()
								TriggerServerEvent('core:EntrepriseAddStock', token, selected_vehicle,
									selected_vehicle.price)

								--[[ Ancienne notification
                                -- ShowNotification("~g~Vous avez acheté " ..
                                    selected_vehicle.name)
                                --]]

								-- New notif
								exports['vNotif']:createNotification({
									type = 'DOLLAR',
									-- duration = 5, -- In seconds, default:  4
									content = "Vous avez acheté ~s " .. selected_vehicle.name
								})

								RageUI.GoBack()
							end
						})
						RageUI.Button("Faire essayer",
							"Voulez-vous faire essayer le véhicule à la personne la plus proche ?", {}, true, {
								onSelected = function()
									local closestPlayer, closestDistance = GetClosestPlayer()
									-- if closestPlayer ~= nil and closestDistance < 3.0 then
									TriggerServerEvent('core:concessEntrepriseTryVeh', token, closestPlayer,
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

	--[[local open = false
    local cardealerSudMenu_main = RageUI.CreateMenu("", "Concessionnaire", 0.0, 0.0, "root_cause",
        "shopui_title_premiumdeluxe")
    local cardealerSudMenu_giveVehicle = RageUI.CreateSubMenu(cardealerSudMenu_main, "", "Concessionnaire", 0.0, 0.0,
        "root_cause", "shopui_title_premiumdeluxe")
    local cardealerSudMenu_select_buyer = RageUI.CreateSubMenu(cardealerSudMenu_giveVehicle, "", "Concessionnaire", 0.0, 0.0,
        "root_cause", "shopui_title_premiumdeluxe")
    local cardealerSudMenu_select_color = RageUI.CreateSubMenu(cardealerSudMenu_giveVehicle, "", "Concessionnaire", 0.0, 0.0,
        "root_cause", "shopui_title_premiumdeluxe")
    local cardealerSudMenu_billing = RageUI.CreateSubMenu(cardealerSudMenu_main, "", "Concessionnaire", 0.0, 0.0,
        "root_cause", "shopui_title_premiumdeluxe")
    cardealerSudMenu_main.Closed = function()
        open = false
    end

    local vehicle_selected_to_give = {}
    local plys_ent = {}
    local billing_price = 0
    local billing_reason = ""
    local ACrew = true
    function openEntrepriseMenu()
        if open then
            open = false
            RageUI.Visible(cardealerSudMenu_main, false)
        else
            open = true
            RageUI.Visible(cardealerSudMenu_main, true)
            stockGestion = TriggerServerCallback("core:GestionEntreprise", token)
            plys_ent = {}

            Citizen.CreateThread(function()
                while open do
                    RageUI.IsVisible(cardealerSudMenu_main, function()
                        RageUI.Button("Attribuer un véhicule", nil, {}, true, {
                            onSelected = function()
                                ACrew = false
                                AJob = false
                                stockGestion = TriggerServerCallback("core:GestionEntreprise", token)
                            end
                        }, cardealerSudMenu_giveVehicle)
                        RageUI.Button("Attribuer un véhicule au crew", nil, {}, true, {
                            onSelected = function()
                                ACrew = true
                                AJob = false
                                stockGestion = TriggerServerCallback("core:GestionEntreprise", token)
                            end
                        }, cardealerSudMenu_giveVehicle)
                        RageUI.Button("Attribuer un véhicule a l'entreprise", nil, {}, true, {
                            onSelected = function()
                                ACrew = false
                                AJob = true
                                stockGestion = TriggerServerCallback("core:GestionEntreprise", token)
                            end
                        }, cardealerSudMenu_giveVehicle)
                        RageUI.Button("Faire une facture", nil, {}, true, {
                            onSelected = function()
                                --billing_price = 0
                                --billing_reason = ""
                                TriggerEvent("nuiPapier:client:startCreation",2)
                                RageUI.CloseAll()
                            end
                        })
                    end)
                    RageUI.IsVisible(cardealerSudMenu_giveVehicle, function()
                        if stockGestion ~= nil then
                            for k, v in pairs(stockGestion) do
                                RageUI.Button(v.name, nil, {}, true, {
                                    onSelected = function()
                                        vehicle_selected_to_give = v
                                        liveries = v.liveries
                                        GetAllPlayersInAreaWithDataEntreprise()
                                    end
                                }, cardealerSudMenu_select_buyer)
                            end
                        end
                    end)
                    RageUI.IsVisible(cardealerSudMenu_select_buyer, function()
                        if plys_ent then
                            for k, v in pairs(plys_ent) do
                                RageUI.Button("~o~" .. v.player .. "~s~ | ~o~" .. v.name, nil, {}, true, {
                                    onSelected = function()
                                        if ACrew then
                                            TriggerServerEvent('core:assignBuyerToEntreprise', token,
                                                vehicle_selected_to_give, v.player, v.crew, color, liveries, "aucun")
                                            RageUI.CloseAll()
                                            open = false
                                        elseif AJob then
                                            TriggerServerEvent('core:assignBuyerToEntreprise', token,
                                                vehicle_selected_to_give, v.player, "None", color, liveries, v.job)
                                            RageUI.CloseAll()
                                            open = false
                                        else
                                            TriggerServerEvent('core:assignBuyerToEntreprise', token,
                                                vehicle_selected_to_give, v.player, "None", color, liveries, "aucun")
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
                                        "CHAR_VISION", "VISION")

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
                                        'concessentreprise', billing_price, billing_reason)
                                    RageUI.CloseAll()
                                    open = false
                                else
                                    --[[ ShowAdvancedNotification("Vision", "Concessionnaire", "Aucun joueur dans la zone",
                                        "CHAR_VISION", "VISION")

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

    Keys.Register("F4", "F4", "Gestion Concess Entreprise", function()
        openEntrepriseMenu()
    end)]]

	function GetAllPlayersInAreaWithDataEntreprise()
		local players = GetAllPlayersInArea(p:pos(), 5.0)
		plys_ent = {}

		for k, v in pairs(players) do
			local src = GetPlayerServerId(v)
			local name = TriggerServerCallback("core:GetPlayerAreaName", src)
			local crew = TriggerServerCallback("core:GetPlayerCrewArea", src)
			local job = TriggerServerCallback("core:GetPlayerJobArea", src)
			table.insert(plys_ent, {
				player = src,
				name = name,
				crew = crew,
				job = job
			})
		end
	end
end

RegisterNetEvent("core:spawnEntreprisecardealerSud")
AddEventHandler("core:spawnEntreprisecardealerSud", function(model, plate, color, liveries)
	local vehicle = vehicle.create(model, vector4(-33.84, -1080.8, 26.04, 71.55),
		{
			plate = plate,
			modLivery = liveries,
			modLiverys = liveries
		})
	TriggerServerEvent("core:SetVehicleOut", string.upper(plate), VehToNet(vehicle), vehicle)
	-- SetVehicleModColor_1(vehicle, 0, color, 0)
end)


RegisterNetEvent("core:concessEntrepriseTryVeh")
AddEventHandler("core:concessEntrepriseTryVeh", function(model)
	inTryVeh = true
	local vehicle = vehicle.create(model, vector4(-14.420570373535, -1081.7213134766, 25.653465270996, 68.889167785645),
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
