local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)


local sleep = 5
local deepSleep = 100
local superDeepSleep = 1500
local antiSpam = false
local checkItem = false

Citizen.CreateThread(function()
	while true do
		Wait(sleep)

		if IsPedArmed(PlayerPedId(), 4|2) then
			local check, hash = GetCurrentPedWeapon(PlayerPedId(), 1)
			local clipSize = GetWeaponClipSize(hash)
			local ammoInWeapon = GetAmmoInPedWeapon(PlayerPedId(), hash)

			if ammoInWeapon > clipSize then
				SetAmmoInClip(PlayerPedId(), hash, 0)
				SetPedAmmo(PlayerPedId(), hash, clipSize)
			end

			if not antiSpam then
				if IsControlJustReleased(0, 45) then

                    local weapon_selected = GetSelectedPedWeapon(PlayerPedId())
        
                    local weapon_category = GetWeapontypeGroup(weapon_selected)
                
                    -- print(weapon_category)
                
                    if weapon_category == 416676503 then
                        -- print("Handgun")
                        if weapon_selected == 1198879012 then
                            weapon_munition = 'ammo_flare'
                        else
                            weapon_munition = 'ammo_pistol'
                        end
                    elseif weapon_category == -957766203 or weapon_category == 1159398588 then
                        -- print("Submachine")
                        weapon_munition = 'ammo_sub'
                    elseif weapon_category == 860033945 then
                        -- print("Shotgun")
                        if weapon_selected == -1534026924 then
                            weapon_munition = 'ammo_beambag'
                        else
                            weapon_munition = 'ammo_shotgun'
                        end
                    elseif weapon_category == 970310034 then
                        -- print("Rifle or Heavy")
                        weapon_munition = 'ammo_rifle'
                    elseif weapon_category == 3082541095 or weapon_category == -1212426201 then
                        if weapon_selected == -1466123874 then
                            weapon_munition = 'ammo_musquet'
                        else
                            -- print("Sniper")
                            weapon_munition = 'ammo_snip'
                        end
                    elseif weapon_category == 2725924767 then
                        -- print("Rifle or Heavy")
                        weapon_munition = 'ammo_heavy'
                    elseif weapon_category == -1569042529 then
                        -- print("Rocket")
                        weapon_munition = 'ammo_rocket'
                    end

                    local getitem = p:getItemCount(weapon_munition)

                    if getitem or p:getPermission() > 5 then
                        TriggerEvent("vWeapon:reload", true)
                    else
                        TriggerEvent("vWeapon:reload", false)
                    end	
                end
			end

		else
			Wait(deepSleep)
		end
	end
end)

RegisterNetEvent("vWeapon:reload")
AddEventHandler("vWeapon:reload", function(checkItem)

    local ammoGive = false

	if IsPedArmed(PlayerPedId(), 4|2) then

		if checkItem then
			local check1, hash = GetCurrentPedWeapon(PlayerPedId(), 1)
			local clipSize = GetWeaponClipSize(hash)
			local check2, ammoInClip = GetAmmoInClip(PlayerPedId(), hash)

            local weapon_selected = GetSelectedPedWeapon(PlayerPedId())
        
            local weapon_category = GetWeapontypeGroup(weapon_selected)

            local ped = p:ped()
            local weapon = GetSelectedPedWeapon(ped)
        
            -- print(weapon_category)
        
            if weapon_category == 416676503 then
                -- print("Handgun")
                if weapon_selected == 1198879012 then
                    weapon_munition = 'ammo_flare'
                else
                    weapon_munition = 'ammo_pistol'
                end
            elseif weapon_category == -957766203 or weapon_category == 1159398588 then
                -- print("Submachine")
                weapon_munition = 'ammo_sub'
            elseif weapon_category == 860033945 then
                -- print("Shotgun")
                if weapon_selected == -1534026924 then
                    weapon_munition = 'ammo_beambag'
                else
                    weapon_munition = 'ammo_shotgun'
                end
            elseif weapon_category == 970310034 then
                -- print("Rifle or Heavy")
                weapon_munition = 'ammo_rifle'
            elseif weapon_category == 3082541095 or weapon_category == -1212426201 then
                if weapon_selected == -1466123874 then
                    weapon_munition = 'ammo_musquet'
                else
                    -- print("Sniper")
                    weapon_munition = 'ammo_snip'
                end
            elseif weapon_category == 2725924767 then
                -- print("Rifle or Heavy")
                weapon_munition = 'ammo_heavy'
            elseif weapon_category == -1569042529 then
                -- print("Rocket")
                weapon_munition = 'ammo_rocket'
            end

            if not IsPedReloading() then

                if ammoInClip ~= clipSize then

                    for k, v in pairs(p:getInventaire()) do

                        if v.name == weapon_munition then
                            if v.metadatas and tonumber(v.metadatas.removeTimestamp) then
                                local timestamp = GlobalState.OsTime
                                if tonumber(v.metadatas.removeTimestamp) < tonumber(timestamp) then
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        content = "Cet item n'est plus utilisable !"
                                    })
                                    TriggerServerEvent("core:RemoveItemToInventory", token, v.name, v.count, v.metadatas)
                                    updateInventoryNui()
                                    return
                                end
                            end
                            TriggerServerEvent('core:RemoveItemToInventory', token, weapon_munition, 1, v.metadatas)
                            break;
                        end

                    end
                    

                    SetAmmoInClip(PlayerPedId(), hash, 0)
                    SetPedAmmo(PlayerPedId(), hash, clipSize)
                    
                    antiSpam = true
                    Wait(superDeepSleep)
                    antiSpam = false

                    if weapon ~= nil and weapon ~= GetHashKey("WEAPON_UNARMED") then
                        --ShowNotification(" ~g~+30~s~ munition")
                        for k, v in pairs(p:getInventaire()) do
                            if Weapons[IndexAmmooooooo + 1] ~= nil then
                                if GetHashKey(v.name) == weapon and
                                    v.metadatas.renamed == Weapons[IndexAmmooooooo + 1].metadatas.renamed and not ammoGive then
                                    if v.metadatas.ammo ~= nil then
                                        if Weapons[IndexAmmooooooo + 1].metadatas.ammo == nil then
                                            Weapons[IndexAmmooooooo + 1].metadatas.ammo = clipSize
                                        else
                                            Weapons[IndexAmmooooooo + 1].metadatas.ammo = clipSize
                                        end
                                        v.metadatas.ammo = clipSize
                                        ammoGive = true
                                        TriggerServerCallback("core:RefreshInventory", token, p:getInventaire())
                                        --return
                                    elseif v.metadatas.renamed == Weapons[IndexAmmooooooo + 1].metadatas.renamed then
                                        if Weapons[IndexAmmooooooo + 1].metadatas.ammo == nil then
                                            Weapons[IndexAmmooooooo + 1].metadatas.ammo = clipSize
                                        else
                                            Weapons[IndexAmmooooooo + 1].metadatas.ammo = clipSize
                                        end
                                        v.metadatas.ammo = clipSize
                                        ammoGive = true
                                        TriggerServerCallback("core:RefreshInventory", token, p:getInventaire())
                                        --return
                                    end
                                end
            
                            else
                                
                                return
                            end
                        end
                    else
                        
                        return
                    end

                else

                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        content = " ~c Chargeur de l'arme complet."
                    })

                    antiSpam = true
                    Wait(superDeepSleep)
                    antiSpam = false
                end
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Vous êtes ~s déjà entrain de recharger."
                })
            end
		else

            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous n'avez ~c pas assez ~s de chargeur."
            })

			antiSpam = true
			Wait(superDeepSleep)
			antiSpam = false
		end
	end
end)

-- DEBUG

--[[ Citizen.CreateThread(function()
	while true do
		Wait(5000)

		local check, hash = GetCurrentPedWeapon(PlayerPedId(), 1)
		local clipSize = GetWeaponClipSize(hash)
		local ammoInWeapon = GetAmmoInPedWeapon(PlayerPedId(), hash)
		local check2, ammoInClip = GetAmmoInClip(PlayerPedId(), hash)
		local ammoType = GetWeapontypeModel(hash)
		local check3, maxAmmo = GetMaxAmmo(PlayerPedId(), hash)

        local weapon_category = GetWeapontypeGroup(hash)

		print(" ")
		print(" ")
		print(" ")
		print(" ")
		print(" ")
		print(" ")
		print(" ")
		print(" ")
		print("Weapon Hash  : " .. hash)
        print("Weapon Category  : " .. weapon_category)
		print("Max Ammo     : " .. maxAmmo)
		print("Total Ammo   : " .. ammoInWeapon)
		print("Ammo Type    : " .. ammoType)
		print("--------------------------")
		print("Clip Size    : " .. clipSize)
		print("Ammo In clip : " .. ammoInClip)
	end
end) ]]

function UseMunition(type, count)
    local ammoGive = false

    local ped = p:ped()
    local weapon = GetSelectedPedWeapon(ped)

--[[     print('Arme : '..weapon) ]]

    local weapon_category = GetWeapontypeGroup(weapon)

--[[     print("Catégorie : "..weapon_category) ]]

--[[     if p:haveItemWithCount(type, 1) then
        for k, v in pairs(p:getInventaire()) do ]]
 
            if type == "ammobox_pistol" and not ammoGive then
                -- print("Handgun")
                TriggerSecurGiveEvent("core:addItemToInventory", token, "ammo_pistol", 3, {})

                --[[ TriggerServerEvent("core:RemoveItemToInventory", token, "ammobox_pistol", 1, v.metadatas) ]]

                ammoGive = true

            elseif type == "ammobox_sub" and not ammoGive then
                -- print("Submachine")
                TriggerSecurGiveEvent("core:addItemToInventory", token, "ammo_sub", 3, {})

                --[[ TriggerServerEvent("core:RemoveItemToInventory", token, "ammobox_sub", 1, v.metadatas) ]]

                ammoGive = true

            elseif type == "ammobox_shotgun" and not ammoGive then
                -- print("Shotgun")
                TriggerSecurGiveEvent("core:addItemToInventory", token, "ammo_shotgun", 3, {})

                --[[ TriggerServerEvent("core:RemoveItemToInventory", token, "ammobox_shotgun", 1, v.metadatas) ]]

                ammoGive = true

            elseif type == "ammobox_rifle" and not ammoGive then
                -- print("Rifle or Heavy")
                TriggerSecurGiveEvent("core:addItemToInventory", token, "ammo_rifle", 3, {})

                --[[ TriggerServerEvent("core:RemoveItemToInventory", token, "ammobox_rifle", 1, v.metadatas) ]]
                
                ammoGive = true

            elseif type == "ammobox_snip" and not ammoGive then
                -- print("Sniper")
                TriggerSecurGiveEvent("core:addItemToInventory", token, "ammo_snip", 3, {})

                --[[ TriggerServerEvent("core:RemoveItemToInventory", token, "ammobox_snip", 1, v.metadatas) ]]

                ammoGive = true

            elseif type == "ammobox_heavy" and not ammoGive then
                -- print("Rifle or Heavy")
                TriggerSecurGiveEvent("core:addItemToInventory", token, "ammo_heavy", 3, {})

                --[[ TriggerServerEvent("core:RemoveItemToInventory", token, "ammobox_heavy", 1, v.metadatas) ]]

                ammoGive = true
                
            elseif type == "ammobox_rocket" and not ammoGive then
                -- print("Rocket")
                TriggerSecurGiveEvent("core:addItemToInventory", token, "ammo_rocket", 3, {})

                --[[ TriggerServerEvent("core:RemoveItemToInventory", token, "ammobox_rocket", 1, v.metadatas) ]]

                ammoGive = true

            elseif type == "ammobox_beambag" and not ammoGive then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "ammo_beambag", 3, {})

                --[[ TriggerServerEvent("core:RemoveItemToInventory", token, "ammobox_beambag", 1, v.metadatas) ]]

                ammoGive = true

            
            elseif type == "ammobox_musquet" and not ammoGive then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "ammo_musquet", 3, {})

                --[[ TriggerServerEvent("core:RemoveItemToInventory", token, "ammobox_musquet", 1, v.metadatas) ]]

                ammoGive = true

            
            elseif type == "ammobox_flare" and not ammoGive then
                -- print("Rifle or Heavy")
                TriggerSecurGiveEvent("core:addItemToInventory", token, "ammo_flare", 3, {})

                --[[ TriggerServerEvent("core:RemoveItemToInventory", token, "ammobox_flare", 1, v.metadatas) ]]

                ammoGive = true

            elseif type == "ammobox_global" and not ammoGive then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "ammo_pistol", 3, {})
                TriggerSecurGiveEvent("core:addItemToInventory", token, "ammo_pistol", 3, {})
                TriggerSecurGiveEvent("core:addItemToInventory", token, "ammo_sub", 3, {})
                TriggerSecurGiveEvent("core:addItemToInventory", token, "ammo_shotgun", 3, {})
                TriggerSecurGiveEvent("core:addItemToInventory", token, "ammo_rifle", 3, {})
                TriggerSecurGiveEvent("core:addItemToInventory", token, "ammo_snip", 3, {})
                TriggerSecurGiveEvent("core:addItemToInventory", token, "ammo_heavy", 3, {})
                TriggerSecurGiveEvent("core:addItemToInventory", token, "ammo_rocket", 3, {})
                TriggerSecurGiveEvent("core:addItemToInventory", token, "ammo_beambag", 3, {})
                TriggerSecurGiveEvent("core:addItemToInventory", token, "ammo_flare", 3, {})
                

                --[[ TriggerServerEvent("core:RemoveItemToInventory", token, "ammobox_global", 1, v.metadatas) ]]

                ammoGive = true

            end
        --[[ end ]]
    --[[ end ]]
    
end

RegisterNetEvent("core:UseMunition")
AddEventHandler("core:UseMunition", function(type, count)

    UseMunition(type, count)

end)

RegisterNetEvent("core:TransformMunition")
AddEventHandler("core:TransformMunition", function(count)

    TriggerSecurGiveEvent("core:addItemToInventory", token, "ammo_pistol", 3, {})
    TriggerServerEvent("core:RemoveItemToInventory", token, "ammo30", 1, {})

    -- UseMunition(count)
end)

RegisterNetEvent("core:TransformCan")
AddEventHandler("core:TransformCan", function(count)

    TriggerSecurGiveEvent("core:addItemToInventory", token, "weapon_canette", 1, {})

    exports['vNotif']:createNotification({
        type = 'JAUNE',
        content = "Vous venez ~sd'écraser~c votre canette."
    })

end)


RegisterNetEvent("core:RemoveWeapon")
AddEventHandler("core:RemoveWeapon", function(weapon)
    for k, v in pairs(Weapons) do
        if v.name == weapon then
            Weapons[k] = nil
            TriggerServerEvent("core:SetWeaponSave", token, Weapons)
        end
    end 
end)
