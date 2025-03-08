local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local weapons = {
    [GetHashKey('WEAPON_PISTOL')] = { wpnname = "weapon_pistol", suppressor = GetHashKey('component_at_pi_supp_02'), flashlight = GetHashKey('COMPONENT_AT_PI_FLSH'), grip = nil, skin = GetHashKey('COMPONENT_PISTOL_VARMOD_LUXE') },
    [GetHashKey('WEAPON_PISTOL50')] = { wpnname = "weapon_pistol50", suppressor = GetHashKey('COMPONENT_AT_AR_SUPP_02'), flashlight = GetHashKey('COMPONENT_AT_PI_FLSH'), grip = nil, skin = GetHashKey('COMPONENT_PISTOL50_VARMOD_LUXE') },
    [GetHashKey('WEAPON_COMBATPISTOL')] = { wpnname = "weapon_combatpistol", suppressor = GetHashKey('COMPONENT_AT_PI_SUPP'), flashlight = GetHashKey('COMPONENT_AT_PI_FLSH'), grip = nil, skin = nil },
    [GetHashKey('WEAPON_APPISTOL')] = { wpnname = "weapon_appistol", suppressor = GetHashKey('COMPONENT_AT_PI_SUPP'), flashlight = GetHashKey('COMPONENT_AT_PI_FLSH'), grip = nil, skin = GetHashKey('COMPONENT_APPISTOL_VARMOD_LUXE') },
    [GetHashKey('WEAPON_HEAVYPISTOL')] = { wpnname = "weapon_heavypistol", suppressor = GetHashKey('COMPONENT_AT_PI_SUPP'), flashlight = GetHashKey('COMPONENT_AT_PI_FLSH'), grip = nil, skin = GetHashKey('COMPONENT_HEAVYPISTOL_VARMOD_LUXE') },
    [GetHashKey('WEAPON_VINTAGEPISTOL')] = { wpnname = "weapon_vintagepistol", suppressor = GetHashKey('COMPONENT_AT_PI_SUPP'), flashlight = nil, grip = nil, skin = nil },
    [GetHashKey('WEAPON_SMG')] = { wpnname = "weapon_smg", suppressor = GetHashKey('COMPONENT_AT_PI_SUPP'), flashlight = GetHashKey('COMPONENT_AT_AR_FLSH'), grip = nil, skin = GetHashKey('COMPONENT_SMG_VARMOD_LUXE') },
    [GetHashKey('WEAPON_MICROSMG')] = { wpnname = "weapon_microsmg", suppressor = GetHashKey('COMPONENT_AT_AR_SUPP_02'), flashlight = GetHashKey('COMPONENT_AT_PI_FLSH'), grip = nil, skin = GetHashKey('COMPONENT_MICROSMG_VARMOD_LUXE') },
    [GetHashKey('WEAPON_ASSAULTSMG')] = { wpnname = "weapon_assaultsmg", suppressor = GetHashKey('COMPONENT_AT_AR_SUPP_02'), flashlight = GetHashKey('COMPONENT_AT_AR_FLSH'), grip = nil, skin = nil },
    [GetHashKey('WEAPON_ASSAULTRIFLE')] = { wpnname = "weapon_assaultrifle", suppressor = GetHashKey('COMPONENT_AT_AR_SUPP_02'), flashlight = GetHashKey('COMPONENT_AT_AR_FLSH'), grip = GetHashKey('COMPONENT_AT_AR_AFGRIP'), skin = GetHashKey('COMPONENT_ASSAULTRIFLE_VARMOD_LUXE') },
    [GetHashKey('WEAPON_CARBINERIFLE')] = { wpnname = "weapon_carbinerifle", suppressor = GetHashKey('COMPONENT_AT_AR_SUPP'), flashlight = GetHashKey('COMPONENT_AT_AR_FLSH'), grip = GetHashKey('COMPONENT_AT_AR_AFGRIP'), skin = GetHashKey('COMPONENT_CARBINERIFLE_VARMOD_LUXE') },
    [GetHashKey('WEAPON_HEAVYRIFLE')] = { wpnname = "weapon_heavyrifle", suppressor = GetHashKey('COMPONENT_AT_AR_SUPP'), flashlight = GetHashKey('COMPONENT_AT_AR_FLSH'), grip = GetHashKey('COMPONENT_AT_AR_AFGRIP'), skin = nil },
    [GetHashKey('WEAPON_TACTICALRIFLE')] = { wpnname = "weapon_tacticalrifle", suppressor = GetHashKey('COMPONENT_AT_AR_SUPP_02'), flashlight = GetHashKey('COMPONENT_AT_AR_FLSH_REH'), grip = GetHashKey('COMPONENT_AT_AR_AFGRIP'), skin = nil },
    [GetHashKey('WEAPON_MILITARYRIFLE')] = { wpnname = "weapon_militaryrifle", suppressor = GetHashKey('COMPONENT_MILITARYRIFLE_CLIP_02'), flashlight = GetHashKey('COMPONENT_AT_AR_FLSH'), grip = nil, skin = nil },
    [GetHashKey('WEAPON_ADVANCEDRIFLE')] = { wpnname = "weapon_advancedrifle", suppressor = GetHashKey('COMPONENT_AT_AR_SUPP'), flashlight = GetHashKey('COMPONENT_AT_AR_FLSH'), grip = nil, skin = GetHashKey('COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE') },
    [GetHashKey('WEAPON_SPECIALCARBINE')] = { wpnname = "weapon_specialcarbine", suppressor = GetHashKey('COMPONENT_AT_AR_SUPP_02'), flashlight = GetHashKey('COMPONENT_AT_AR_FLSH'), grip = GetHashKey('COMPONENT_AT_AR_AFGRIP'), skin = nil },
    [GetHashKey('WEAPON_BULLPUPRIFLE')] = { wpnname = "weapon_bullpuprifle", suppressor = GetHashKey('COMPONENT_AT_AR_SUPP'), flashlight = GetHashKey('COMPONENT_AT_AR_FLSH'), grip = GetHashKey('COMPONENT_AT_AR_AFGRIP'), skin = nil },
    [GetHashKey('WEAPON_ASSAULTSHOTGUN')] = { wpnname = "weapon_assaultshotgun", suppressor = GetHashKey('COMPONENT_AT_AR_SUPP'), flashlight = GetHashKey('COMPONENT_AT_AR_FLSH'), grip = GetHashKey('COMPONENT_AT_AR_AFGRIP'), skin = nil },
    [GetHashKey('WEAPON_HEAVYSHOTGUN')] = { wpnname = "weapon_heavyshotgun", suppressor = GetHashKey('COMPONENT_AT_AR_SUPP_02'), flashlight = GetHashKey('COMPONENT_AT_AR_FLSH'), grip = GetHashKey('COMPONENT_AT_AR_AFGRIP'), skin = nil },
    [GetHashKey('WEAPON_BULLPUPSHOTGUN')] = { wpnname = "weapon_bullpupshotgun", suppressor = GetHashKey('COMPONENT_AT_AR_SUPP_02'), flashlight = GetHashKey('COMPONENT_AT_AR_FLSH'), grip = GetHashKey('COMPONENT_AT_AR_AFGRIP'), skin = nil },
    [GetHashKey('WEAPON_PUMPSHOTGUN')] = { wpnname = "weapon_pumpshotgun", suppressor = GetHashKey('COMPONENT_AT_SR_SUPP'), flashlight = GetHashKey('COMPONENT_AT_AR_FLSH'), grip = nil, skin = nil },
    [GetHashKey('WEAPON_SNIPERRIFLE')] = { wpnname = "weapon_sniperrifle", suppressor = GetHashKey('COMPONENT_AT_AR_SUPP_02'), flashlight = nil, grip = nil, skin = nil },
}

local suppressor = {}

-- Use item
RegisterNetEvent('core:weapon:use')
AddEventHandler('core:weapon:use', function(type)
    if weapons[GetSelectedPedWeapon(p:ped())] and weapons[GetSelectedPedWeapon(p:ped())][type] then
        if not HasPedGotWeaponComponent(PlayerPedId(), GetSelectedPedWeapon(p:ped()), weapons[GetSelectedPedWeapon(p:ped())][type]) then
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(p:ped()),
                weapons[GetSelectedPedWeapon(p:ped())][type])

            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez équipé votre ~s " .. type
            })

            local weaponname = weapons[GetSelectedPedWeapon(p:ped())]["wpnname"]

            local pWeapons = p:getWeapons()

            for Count, Value in pairs(pWeapons) do
                if weaponname == Value.name then -- Modif ce if jusqu'a édition du metadata sinon ça fonctionne (Puis faire la détection de si c'est true ou false pour équipé l'arme lors de la prise de l'arme)
                    if type == 'suppressor' then
                        Value.metadatas.suppressor = true


                        p:SetWeaponComponents(Count, "suppressor", true)
                        TriggerServerEvent("core:UpdateWeaponComponents", token, Count, "suppressor", true)

                        -- print('OK SUPPRESSOR !')

                        TriggerServerEvent('core:RemoveItemToInventory', token, 'components_suppressor', 1, {})

                        TriggerSecurEvent("core:RefreshInventory", token, p:getInventaire())
                    elseif type == 'flashlight' then
                        Value.metadatas.flashlight = true
                        -- print('OK FLASHLIGHT !')

                        p:SetWeaponComponents(Count, "flashlight", true)
                        TriggerServerEvent("core:UpdateWeaponComponents", token, Count, "flashlight", true)

                        TriggerServerEvent('core:RemoveItemToInventory', token, 'components_flashlight', 1, {})

                        TriggerSecurEvent("core:RefreshInventory", token, p:getInventaire())
                    elseif type == 'grip' then
                        Value.metadatas.grip = true

                        -- print('OK GRIP !')

                        p:SetWeaponComponents(Count, "grip", true)
                        TriggerServerEvent("core:UpdateWeaponComponents", token, Count, "grip", true)

                        TriggerServerEvent('core:RemoveItemToInventory', token, 'components_grip', 1, {})

                        TriggerSecurEvent("core:RefreshInventory", token, p:getInventaire())
                    end
                end
            end

            local ped = p:ped()

            local playerweapon = GetSelectedPedWeapon(ped)


            for k, v in pairs(p:getInventaire()) do
                if Weapons[IndexAmmooooooo + 1] ~= nil then
                    if GetHashKey(v.name) == playerweapon and
                        v.metadatas.renamed == Weapons[IndexAmmooooooo + 1].metadatas.renamed then
                        if type == 'suppressor' then
                            if v.metadatas.suppressor ~= nil then
                                if Weapons[IndexAmmooooooo + 1].metadatas.suppressor == nil then
                                    Weapons[IndexAmmooooooo + 1].metadatas.suppressor = true
                                else
                                    Weapons[IndexAmmooooooo + 1].metadatas.suppressor = true
                                end
                                v.metadatas.suppressor = true
                                TriggerSecurEvent("core:RefreshInventory", token, p:getInventaire())
                                --return
                            elseif v.metadatas.renamed == Weapons[IndexAmmooooooo + 1].metadatas.renamed then
                                if Weapons[IndexAmmooooooo + 1].metadatas.suppressor == nil then
                                    Weapons[IndexAmmooooooo + 1].metadatas.suppressor = true
                                else
                                    Weapons[IndexAmmooooooo + 1].metadatas.suppressor = true
                                end
                                v.metadatas.suppressor = true
                                TriggerSecurEvent("core:RefreshInventory", token, p:getInventaire())
                                --return
                            end
                        elseif type == 'flashlight' then
                            if v.metadatas.flashlight ~= nil then
                                if Weapons[IndexAmmooooooo + 1].metadatas.flashlight == nil then
                                    Weapons[IndexAmmooooooo + 1].metadatas.flashlight = true
                                else
                                    Weapons[IndexAmmooooooo + 1].metadatas.flashlight = true
                                end
                                v.metadatas.flashlight = true
                                TriggerSecurEvent("core:RefreshInventory", token, p:getInventaire())
                                --return
                            elseif v.metadatas.renamed == Weapons[IndexAmmooooooo + 1].metadatas.renamed then
                                if Weapons[IndexAmmooooooo + 1].metadatas.flashlight == nil then
                                    Weapons[IndexAmmooooooo + 1].metadatas.flashlight = true
                                else
                                    Weapons[IndexAmmooooooo + 1].metadatas.flashlight = true
                                end
                                v.metadatas.flashlight = true
                                TriggerSecurEvent("core:RefreshInventory", token, p:getInventaire())
                                --return
                            end
                            -- print('OK FLASHLIGHT !')
                        elseif type == 'grip' then
                            if v.metadatas.grip ~= nil then
                                if Weapons[IndexAmmooooooo + 1].metadatas.grip == nil then
                                    Weapons[IndexAmmooooooo + 1].metadatas.grip = true
                                else
                                    Weapons[IndexAmmooooooo + 1].metadatas.grip = true
                                end
                                v.metadatas.grip = true
                                TriggerSecurEvent("core:RefreshInventory", token, p:getInventaire())
                                --return
                            elseif v.metadatas.renamed == Weapons[IndexAmmooooooo + 1].metadatas.renamed then
                                if Weapons[IndexAmmooooooo + 1].metadatas.grip == nil then
                                    Weapons[IndexAmmooooooo + 1].metadatas.grip = true
                                else
                                    Weapons[IndexAmmooooooo + 1].metadatas.grip = true
                                end
                                v.metadatas.grip = true
                                TriggerSecurEvent("core:RefreshInventory", token, p:getInventaire())
                                --return
                            end

                            -- print('OK GRIP !')
                        end
                    end
                else
                    return
                end
            end
        else
            if weapons[GetSelectedPedWeapon(p:ped())] then
                for key, value in pairs(p:getWeapons()) do
                    if value.name == Weapons[IndexAmmooooooo + 1].name and
                        Weapons[IndexAmmooooooo + 1].metadatas.renamed == value.metadatas.renamed then
                        if type == 'suppressor' then
                            if value.metadatas.suppressor and not nil then
                                p:SetWeaponComponents(key, type, false)
                                TriggerServerEvent("core:UpdateWeaponComponents", token, key, type, false)
                                value.metadatas.suppressor = false
                                -- print('Inventory : '.. weapons[GetSelectedPedWeapon(p:ped())]["suppressor"])
                                RemoveWeaponComponentFromPed(p:ped(), GetSelectedPedWeapon(p:ped()),
                                    weapons[GetSelectedPedWeapon(p:ped())]["suppressor"])
                                TriggerSecurGiveEvent("core:addItemToInventory", token, "components_suppressor", 1, {})

                                -- print('TEST REMOVE SUPPRESSOR')
                            end
                        elseif type == 'flashlight' then
                            if value.metadatas.flashlight and not nil then
                                p:SetWeaponComponents(key, type, false)
                                TriggerServerEvent("core:UpdateWeaponComponents", token, key, type, false)
                                value.metadatas.flashlight = false
                                -- print('Inventory : '.. weapons[GetSelectedPedWeapon(p:ped())]["flashlight"])
                                RemoveWeaponComponentFromPed(p:ped(), GetSelectedPedWeapon(p:ped()),
                                    weapons[GetSelectedPedWeapon(p:ped())]["flashlight"])
                                TriggerSecurGiveEvent("core:addItemToInventory", token, "components_flashlight", 1, {})
                                -- print('TEST REMOVE FLASHLIGHT')
                            end
                        elseif type == 'grip' then
                            if value.metadatas.grip and not nil then
                                p:SetWeaponComponents(key, type, false)
                                TriggerServerEvent("core:UpdateWeaponComponents", token, key, type, false)
                                value.metadatas.grip = false
                                -- print('Inventory : '.. weapons[GetSelectedPedWeapon(p:ped())]["grip"])
                                RemoveWeaponComponentFromPed(p:ped(), GetSelectedPedWeapon(p:ped()),
                                    weapons[GetSelectedPedWeapon(p:ped())]["grip"])
                                TriggerSecurGiveEvent("core:addItemToInventory", token, "components_grip", 1, {})
                                -- print('TEST REMOVE GRIP')
                            end
                        end
                    end

                    exports['vNotif']:createNotification({
                        type = 'JAUNE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous avez déséquipé votre ~s " .. type
                    })

                    TriggerSecurEvent("core:RefreshInventory", token, p:getInventaire())
                end

                for k, v in pairs(p:getInventaire()) do
                    if v.name == Weapons[IndexAmmooooooo + 1].name and
                        Weapons[IndexAmmooooooo + 1].metadatas.renamed == v.metadatas.renamed then
                        if type == 'suppressor' then
                            if v.metadatas.suppressor and not nil then
                                if v.metadatas.suppressor ~= nil then
                                    if Weapons[IndexAmmooooooo + 1].metadatas.suppressor == nil then
                                        Weapons[IndexAmmooooooo + 1].metadatas.suppressor = false
                                    else
                                        Weapons[IndexAmmooooooo + 1].metadatas.suppressor = false
                                    end
                                    v.metadatas.suppressor = false
                                    TriggerSecurEvent("core:RefreshInventory", token, p:getInventaire())
                                end

                                --[[                     print('Inventory : '.. weapons[GetSelectedPedWeapon(p:ped())]["suppressor"])


                                print('TEST REMOVE SUPPRESSOR') ]]
                            end
                        elseif type == 'flashlight' then
                            if v.metadatas.flashlight and not nil then
                                if v.metadatas.flashlight ~= nil then
                                    if Weapons[IndexAmmooooooo + 1].metadatas.flashlight == nil then
                                        Weapons[IndexAmmooooooo + 1].metadatas.flashlight = false
                                    else
                                        Weapons[IndexAmmooooooo + 1].metadatas.flashlight = false
                                    end
                                    v.metadatas.flashlight = false
                                    TriggerSecurEvent("core:RefreshInventory", token, p:getInventaire())
                                end
                                --[[                     print('Inventory : '.. weapons[GetSelectedPedWeapon(p:ped())]["flashlight"])

                                print('TEST REMOVE FLASHLIGHT') ]]
                            end
                        elseif type == 'grip' then
                            if v.metadatas.grip and not nil then
                                if v.metadatas.grip ~= nil then
                                    if Weapons[IndexAmmooooooo + 1].metadatas.grip == nil then
                                        Weapons[IndexAmmooooooo + 1].metadatas.grip = false
                                    else
                                        Weapons[IndexAmmooooooo + 1].metadatas.grip = false
                                    end
                                    v.metadatas.grip = false
                                    TriggerSecurEvent("core:RefreshInventory", token, p:getInventaire())
                                end

                                --[[                     print('Inventory : '.. weapons[GetSelectedPedWeapon(p:ped())]["grip"])

                                print('TEST REMOVE GRIP') ]]
                            end
                        end
                    end

                    TriggerSecurEvent("core:RefreshInventory", token, p:getInventaire())
                end
            end
        end
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Le " .. type .. "ne s'adapte pas à votre arme..."
        })
    end
end)

Keys.Register("PAGEUP", "PAGEUP", "Déséquiper l'arme", function()
    if weapons[GetSelectedPedWeapon(p:ped())] then
        for key, value in pairs(p:getWeapons()) do
            if value.name == Weapons[IndexAmmooooooo + 1].name and
                Weapons[IndexAmmooooooo + 1].metadatas.renamed == value.metadatas.renamed then
                if value.metadatas.suppressor and not nil then
                    local type = "suppressor"
                    p:SetWeaponComponents(key, type, false)
                    TriggerServerEvent("core:UpdateWeaponComponents", token, key, type, false)
                    value.metadatas.suppressor = false
                    -- print('Inventory : '.. weapons[GetSelectedPedWeapon(p:ped())]["suppressor"])
                    RemoveWeaponComponentFromPed(p:ped(), GetSelectedPedWeapon(p:ped()),
                        weapons[GetSelectedPedWeapon(p:ped())]["suppressor"])
                    TriggerSecurGiveEvent("core:addItemToInventory", token, "components_suppressor", 1, {})

                    -- print('TEST REMOVE SUPPRESSOR')
                end

                if value.metadatas.flashlight and not nil then
                    local type = "flashlight"
                    p:SetWeaponComponents(key, type, false)
                    TriggerServerEvent("core:UpdateWeaponComponents", token, key, type, false)
                    value.metadatas.flashlight = false
                    -- print('Inventory : '.. weapons[GetSelectedPedWeapon(p:ped())]["flashlight"])
                    RemoveWeaponComponentFromPed(p:ped(), GetSelectedPedWeapon(p:ped()),
                        weapons[GetSelectedPedWeapon(p:ped())]["flashlight"])
                    TriggerSecurGiveEvent("core:addItemToInventory", token, "components_flashlight", 1, {})
                    -- print('TEST REMOVE FLASHLIGHT')
                end

                if value.metadatas.grip and not nil then
                    local type = "grip"
                    p:SetWeaponComponents(key, type, false)
                    TriggerServerEvent("core:UpdateWeaponComponents", token, key, type, false)
                    value.metadatas.grip = false
                    -- print('Inventory : '.. weapons[GetSelectedPedWeapon(p:ped())]["grip"])
                    RemoveWeaponComponentFromPed(p:ped(), GetSelectedPedWeapon(p:ped()),
                        weapons[GetSelectedPedWeapon(p:ped())]["grip"])
                    TriggerSecurGiveEvent("core:addItemToInventory", token, "components_grip", 1, {})
                    -- print('TEST REMOVE GRIP')
                end
            end

            TriggerSecurEvent("core:RefreshInventory", token, p:getInventaire())
        end

        for k, v in pairs(p:getInventaire()) do
            if v.name == Weapons[IndexAmmooooooo + 1].name and
                Weapons[IndexAmmooooooo + 1].metadatas.renamed == v.metadatas.renamed then
                if v.metadatas.suppressor and not nil then
                    local type = "suppressor"

                    if v.metadatas.suppressor ~= nil then
                        if Weapons[IndexAmmooooooo + 1].metadatas.suppressor == nil then
                            Weapons[IndexAmmooooooo + 1].metadatas.suppressor = false
                        else
                            Weapons[IndexAmmooooooo + 1].metadatas.suppressor = false
                        end
                        v.metadatas.suppressor = false
                        TriggerSecurEvent("core:RefreshInventory", token, p:getInventaire())
                    end

                    --[[                     print('Inventory : '.. weapons[GetSelectedPedWeapon(p:ped())]["suppressor"])


                    print('TEST REMOVE SUPPRESSOR') ]]
                end

                if v.metadatas.flashlight and not nil then
                    local type = "flashlight"

                    if v.metadatas.flashlight ~= nil then
                        if Weapons[IndexAmmooooooo + 1].metadatas.flashlight == nil then
                            Weapons[IndexAmmooooooo + 1].metadatas.flashlight = false
                        else
                            Weapons[IndexAmmooooooo + 1].metadatas.flashlight = false
                        end
                        v.metadatas.flashlight = false
                        TriggerSecurEvent("core:RefreshInventory", token, p:getInventaire())
                    end
                    --[[                     print('Inventory : '.. weapons[GetSelectedPedWeapon(p:ped())]["flashlight"])

                    print('TEST REMOVE FLASHLIGHT') ]]
                end

                if v.metadatas.grip and not nil then
                    local type = "grip"

                    if v.metadatas.grip ~= nil then
                        if Weapons[IndexAmmooooooo + 1].metadatas.grip == nil then
                            Weapons[IndexAmmooooooo + 1].metadatas.grip = false
                        else
                            Weapons[IndexAmmooooooo + 1].metadatas.grip = false
                        end
                        v.metadatas.grip = false
                        TriggerSecurEvent("core:RefreshInventory", token, p:getInventaire())
                    end

                    --[[                     print('Inventory : '.. weapons[GetSelectedPedWeapon(p:ped())]["grip"])

                    print('TEST REMOVE GRIP') ]]
                end
            end

            TriggerSecurEvent("core:RefreshInventory", token, p:getInventaire())
        end
    end
end)
