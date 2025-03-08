-- local token = nil

-- TriggerEvent("core:RequestTokenAcces", "core", function(t)
--     token = t 
-- end)

-- --TODO: remove this and make reel admin menu

-- local open = false
-- local selectedItem = nil
-- local selectedVetement = nil
-- local selectedArme = nil


-- local main = RageUI.CreateMenu("Menu principal", "~b~Menu d'action joueur")
-- -- local inventaire = RageUI.CreateSubMenu(main, "Inventaire", "~b~Menu d'action joueur")
-- -- local inventaire_sub = RageUI.CreateSubMenu(inventaire, "Action sur item", "~b~Menu d'action joueur")
-- -- local vetement = RageUI.CreateSubMenu(main, "Vetement", "~b~Menu d'action joueur")
-- -- local vetementAction = RageUI.CreateSubMenu(vetement, "Vetement", "~b~Menu d'action joueur")
-- -- local arme = RageUI.CreateSubMenu(main, "Arme", "~b~Menu d'action joueur")
-- -- local armeAction = RageUI.CreateSubMenu(arme, "Arme", "~b~Menu d'action joueur")
-- local staff = RageUI.CreateSubMenu(main, "Menu staff", "~b~Menu d'action joueur")
-- local jobCreate
-- local gradeCreate
-- local tenueCreate
-- local jobList
-- local jobEdit
-- local jobEditGrade
-- local jobEditCloths
-- for k,v in pairs(staff_menu) do
-- 	local m = RageUI.CreateSubMenu(staff, "Menu staff", "~b~Menu d'action joueur")
-- 	staff_menu[k].menu = m
-- 	if v.label == "Jobs" then
-- 		jobCreate = RageUI.CreateSubMenu(m, "Menu staff", "~b~Menu d'action joueur")
-- 		gradeCreate = RageUI.CreateSubMenu(jobCreate, "Menu staff", "~b~Menu d'action joueur")
-- 		tenueCreate = RageUI.CreateSubMenu(jobCreate, "Menu staff", "~b~Menu d'action joueur")

-- 		jobList = RageUI.CreateSubMenu(m, "Menu staff", "~b~Menu d'action joueur")
-- 		jobEdit = RageUI.CreateSubMenu(jobList, "Menu staff", "~b~Menu d'action joueur")
-- 		jobEditGrade = RageUI.CreateSubMenu(jobEdit, "Menu staff", "~b~Menu d'action joueur")
-- 		jobEditCloths = RageUI.CreateSubMenu(jobEdit, "Menu staff", "~b~Menu d'action joueur")
-- 	end
-- end


-- main.Closed = function()
-- 	open = false
-- 	FullCloseMenu()
-- end

-- function FullCloseMenu() -- Petit debug au cas ou
-- 	RageUI.Visible(main, false)
-- 	-- RageUI.Visible(inventaire, false)
-- 	-- RageUI.Visible(inventaire_sub, false)
-- 	RageUI.Visible(staff, false)
-- 	for k,v in pairs(staff_menu) do
-- 		RageUI.Visible(staff_menu[k].menu, false)
-- 	end
-- end

-- function OpenF5Menu()
-- 	if open then
-- 		open = false
		
-- 		FullCloseMenu()
-- 		return
-- 	else
-- 		open = true
-- 		RageUI.Visible(main, true)

-- 		Citizen.CreateThread(function()
-- 			while open do
-- 				RageUI.IsVisible(main, function()
-- 					-- RageUI.Button('Inventaire', "Ouvre l'inventaire du joueur", {}, true, {}, inventaire)
-- 					-- RageUI.Button('Vetement', "Ouvre l'inventaire de vetement du joueur", {}, true, {}, vetement)
-- 					-- RageUI.Button('Armes', "Ouvre l'inventaire d'armes du joueur", {}, true, {}, arme)
-- 					RageUI.Button('Modération', nil, {}, p:getPermission() > 1, {}, staff)
-- 				end)

-- 				-- RageUI.IsVisible(inventaire, function()
-- 				-- 	for k,v in pairs(p:getInventaire()) do
-- 				-- 		RageUI.Button("[~b~"..v.count.."~s~] " ..v.label, nil, {}, true, {
--                 -- 			onSelected = function()
--                 -- 			    selectedItem = v
--                 -- 			end,
--             	-- 		}, inventaire_sub)
-- 				-- 	end
-- 				-- end)

-- 				-- RageUI.IsVisible(inventaire_sub, function()
-- 				-- 	RageUI.Button("Utiliser", nil, {}, true, {
--                 -- 		onSelected = function()
--                 -- 		    TriggerServerEvent("core:UseItem", token, selectedItem.name)
--                 -- 		end,
-- 				-- 	})
-- 				-- 	RageUI.Button("Donner", nil, {}, true, {
--                 -- 		onSelected = function()
-- 				-- 			if p:isNearPlayer() then
-- 				-- 				local target = GetPlayerServerId(GetClosestPlayer())
-- 				-- 				local amount = tonumber(KeyboardImput("Montant à donner"))

-- 				-- 				if amount ~= nil and amount <= selectedItem.count and amount ~= 0 then
-- 				-- 					TriggerServerEvent("core:GiveItemToPlayer", token, selectedItem.name, amount, target)
-- 				-- 				else
-- 				-- 					ShowNotification("Mauvais montant")

-- 									-- New notif
-- --[[ 									exports['vNotif']:createNotification({
-- 										type = 'ROUGE',
-- 										-- duration = 5, -- In seconds, default:  4
-- 										content = "~s Mauvais montant"
-- 									}) ]]

-- 				-- 				end
-- 				-- 			else

-- 				-- 			end
-- 				-- 		end,
-- 				-- 		onActive = function()
-- 				-- 			DisplayClosetPlayer()
-- 				-- 		end
--             	-- 	})
-- 				-- 	RageUI.Button("Jeter", nil, {}, true, {
--                 -- 		onSelected = function()
                		    
--                 -- 		end,
--             	-- 	})
-- 				-- end)

-- 				-- RageUI.IsVisible(vetement, function()
-- 				-- 	for k,v in pairs(p:getCloths().cloths) do
-- 				-- 		RageUI.Button(v.name, nil, {}, true, {
-- 				-- 			onSelected = function()
-- 				-- 				selectedVetement = k
--                 -- 			end,
--             	-- 		}, vetementAction)
-- 				-- 	end
-- 				-- end)

-- 				-- RageUI.IsVisible(vetementAction, function()
-- 				-- 	RageUI.Button("Mettre / Enlever", nil, {}, true, {
-- 				-- 		onSelected = function()
-- 				-- 			self = p:getCloths().cloths[selectedVetement]
-- 				-- 			TriggerEvent("skinchanger:getData", function(comp, max)
-- 				-- 				local directTable = {}
-- 				-- 				for k,v in pairs(comp) do
-- 				-- 					if v.componentId == 0 then
-- 				-- 						comp[k].value = GetPedPropIndex(PlayerPedId(), v.componentId)
-- 				-- 					end
					
-- 				-- 					directTable[v.name] = comp[k]
-- 				-- 				end

-- 				-- 				for k,v in pairs(self.data) do
-- 				-- 					if cloths_animation[k] ~= nil then
-- 				-- 						local obj = 0
-- 				-- 						if cloths_animation[k].props ~= nil then
-- 				-- 							local pos = GetOffsetFromEntityInWorldCoords(p:ped(), 0.0, 1.0, 0.0)
-- 				-- 							obj = entity:CreateObject(cloths_animation[k].props, pos, 100.0)
-- 				-- 							PlaceObjectOnGroundProperly(obj:getEntityId())
-- 				-- 						end
-- 				-- 						LoadDict(cloths_animation[k].dict)
-- 				-- 						TaskPlayAnim(p:ped(), cloths_animation[k].dict, cloths_animation[k].anim, 8.0, 1.0, -1, cloths_animation[k].flag, 0, 0, 0, 0 )
-- 				-- 						Wait((GetAnimDuration(cloths_animation[k].dict, cloths_animation[k].anim) * 1000) - cloths_animation[k].remove) 
-- 				-- 						RemoveAnimDict(cloths_animation[k].dict)
-- 				-- 						ClearPedTasks(p:ped())
-- 				-- 						if cloths_animation[k].props ~= nil then
-- 				-- 							obj:delete()
-- 				-- 						end
-- 				-- 					end

-- 				-- 				end

-- 				-- 				for k,v in pairs(self.data) do

-- 				-- 					if directTable[k].value == v then
-- 				-- 						if defaultSkinValues[k] == nil then
-- 				-- 							p:setCloth(k, directTable[k].min) -- TODO Mettre le joueur nue
-- 				-- 						else
-- 				-- 							p:setCloth(k, defaultSkinValues[k])
-- 				-- 						end
-- 				-- 					else
-- 				-- 						p:setCloth(k,v)
-- 				-- 					end
-- 				-- 				end
-- 				-- 				p:saveSkin()
-- 				-- 			end)
--                 -- 		end,
-- 				-- 	})
-- 				-- 	RageUI.Button("Donner", nil, {}, true, {
-- 				-- 		onSelected = function() 
-- 				-- 			if p:isNearPlayer() then

-- 				-- 				TriggerEvent("skinchanger:getData", function(comp, max)
-- 				-- 					local directTable = {}
-- 				-- 					for k,v in pairs(comp) do
-- 				-- 						if v.componentId == 0 then
-- 				-- 							comp[k].value = GetPedPropIndex(PlayerPedId(), v.componentId)
-- 				-- 						end
						
-- 				-- 						directTable[v.name] = comp[k]
-- 				-- 					end

-- 				-- 					self = p:getCloths().cloths[selectedVetement]
-- 				-- 					for k,v in pairs(self.data) do
-- 				-- 						if directTable[k].value == v then
-- 				-- 							if defaultSkinValues[k] ~= nil then
-- 				-- 								p:setCloth(k, defaultSkinValues[k])
-- 				-- 							else
-- 				-- 								p:setCloth(k, directTable[k].min)
-- 				-- 							end
-- 				-- 						end
-- 				-- 					end
-- 				-- 					TriggerServerEvent("core:GiveCloth", token, GetPlayerServerId(GetClosestPlayer()), selectedVetement)
									
-- 				-- 				end)
-- 				-- 				RageUI.GoBack()
-- 				-- 			else
-- 				-- 				ShowNotification("Aucun joueur proche")

-- 							-- New notif
-- --[[ 							['vNotif']:createNotification({
-- 								type = 'ROUGE',
-- 								-- duration = 5, -- In seconds, default:  4
-- 								content = "~s Aucun joueur proche"
-- 							}) ]]

-- 				-- 			end
--                 -- 		end,
-- 				-- 	})
-- 				-- 	RageUI.Button("Jeter", "Cela supprime définitivement la tenue / accessoire", {Color = { BackgroundColor = { 255, 107, 107, 160 } }}, true, {
-- 				-- 		onSelected = function()
-- 				-- 			TriggerServerEvent("core:RemoveCloth", token, selectedVetement)
-- 				-- 			RageUI.GoBack()
--                 -- 		end,
--             	-- 	})
-- 				-- end)

-- 				-- RageUI.IsVisible(arme, function()
-- 				-- 	for k,v in pairs(p:getWeapons()) do
-- 				-- 		RageUI.Button("[~b~"..v.ammo.."~s~] " ..GetLabelText(v.nameGXT), GetLabelText(v.descGXT), {}, true, {
-- 				-- 			onSelected = function()
-- 				-- 				selectedArme = k
--                 -- 			end,
--             	-- 		}, armeAction)
-- 				-- 	end
-- 				-- end)
				
-- 				-- RageUI.IsVisible(armeAction, function()
-- 				-- 	RageUI.Separator("[~b~"..p:getWeapons()[selectedArme].ammo.."~s~] " ..GetLabelText(p:getWeapons()[selectedArme].nameGXT))
-- 				-- 	RageUI.Button("Donner", nil, {}, true, {
-- 				-- 		onSelected = function()
-- 				-- 			if p:isNearPlayer() then
-- 				-- 				local target = GetPlayerServerId(GetClosestPlayer())
-- 				-- 				TriggerServerEvent("core:GiveWeaponToPlayer", token, selectedArme, target)
-- 				-- 			else
-- 				-- 				ShowNotification("Pas de joueur proche ...")

-- 							-- New notif
-- --[[ 							['vNotif']:createNotification({
-- 								type = 'ROUGE',
-- 								-- duration = 5, -- In seconds, default:  4
-- 								content = "~s Pas de joueur proche ..."
-- 							}) ]]

-- 				-- 			end
-- 				-- 		end,
-- 				-- 	})
-- 				-- end)


-- 				HandleStaffMenu(staff, jobCreate, gradeCreate, tenueCreate, jobList, jobEdit, jobEditGrade, jobEditCloths)
-- 				Wait(1)
-- 			end
-- 		end)
-- 	end
-- end

-- -- function ChangeCloths(index)
-- -- 	self = p:getCloths().cloths[index]
-- -- 	TriggerEvent("skinchanger:getData", function(comp, max)
-- -- 		local directTable = {}
-- -- 		for k,v in pairs(comp) do
-- -- 			if v.componentId == 0 then
-- -- 				comp[k].value = GetPedPropIndex(PlayerPedId(), v.componentId)
-- -- 			end

-- -- 			directTable[v.name] = comp[k]
-- -- 		end

-- -- 		for k,v in pairs(self.data) do
-- -- 			if cloths_animation[k] ~= nil then
-- -- 				local obj = 0
-- -- 				if cloths_animation[k].props ~= nil then
-- -- 					local pos = GetOffsetFromEntityInWorldCoords(p:ped(), 0.0, 1.0, 0.0)
-- -- 					obj = entity:CreateObject(cloths_animation[k].props, pos, 100.0)
-- -- 					PlaceObjectOnGroundProperly(obj:getEntityId())
-- -- 				end
-- -- 				LoadDict(cloths_animation[k].dict)
-- -- 				TaskPlayAnim(p:ped(), cloths_animation[k].dict, cloths_animation[k].anim, 8.0, 1.0, -1, cloths_animation[k].flag, 0, 0, 0, 0 )
-- -- 				Wait((GetAnimDuration(cloths_animation[k].dict, cloths_animation[k].anim) * 1000) - cloths_animation[k].remove) 
-- -- 				RemoveAnimDict(cloths_animation[k].dict)
-- -- 				ClearPedTasks(p:ped())
-- -- 				if cloths_animation[k].props ~= nil then
-- -- 					obj:delete()
-- -- 				end
-- -- 			end

-- -- 		end

-- -- 		for k,v in pairs(self.data) do

-- -- 			if directTable[k].value == v then
-- -- 				if defaultSkinValues[k] == nil then
-- -- 					p:setCloth(k, directTable[k].min) -- TODO Mettre le joueur nue
-- -- 				else
-- -- 					p:setCloth(k, defaultSkinValues[k])
-- -- 				end
-- -- 			else
-- -- 				p:setCloth(k,v)
-- -- 			end
-- -- 		end
-- -- 		p:saveSkin()
-- -- 	end)
-- -- end


-- -- Keys.Register("F5", "F5", "Ouvre le menu principal", function()
-- -- 	if not p:getInAction() then
-- -- 		OpenF5Menu()
-- -- 	else
-- -- 		ShowNotification("Tu ne peu pas regarder tes poches maintenant ...")

-- 		-- New notif
--  		-- ['vNotif']:createNotification({
-- 		--[[	type = 'ROUGE',
-- 			-- duration = 5, -- In seconds, default:  4
-- 			content = "~s Tu ne peux pas regarder tes poches maintenant ..."
-- 		}) ]]

-- -- 	end
-- -- end)
