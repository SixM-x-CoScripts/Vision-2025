--[[ local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local prison_guard = {
    outfit = {
        male = {
            ['tshirt_1'] = 274, ['tshirt_2'] = 0,
            ['torso_1'] = 428, ['torso_2'] = 2,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 4,
            ['pants_1'] = 122, ['pants_2'] = 0,
            ['shoes_1'] = 24, ['shoes_2'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['ears_1'] = -1, ['ears_2'] = 0,
            ['bproof_1'] = 0, ['bproof_2'] = 0,
            ['bags_1'] = 0, ['bags_2'] = 0,
            ['glasses_1'] = -1, ['glasses_2'] = 0,
            ['chain_1'] = -1, ['chain_2'] = 0,
            ['mask_1'] = 0, ['mask_2'] = 0
        },
        female = {
            ['tshirt_1'] = 275, ['tshirt_2'] = 0,
            ['torso_1'] = 430, ['torso_2'] = 2,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 3,
            ['pants_1'] = 128, ['pants_2'] = 0,
            ['shoes_1'] = 24, ['shoes_2'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['ears_1'] = -1, ['ears_2'] = 0,
            ['bproof_1'] = 0, ['bproof_2'] = 0,
            ['bags_1'] = 0, ['bags_2'] = 0,
            ['glasses_1'] = -1, ['glasses_2'] = 0,
            ['chain_1'] = -1, ['chain_2'] = 0,
            ['mask_1'] = 0, ['mask_2'] = 0
        },
    },
}

local prison = {
    outfit = {
        male = {
            ['tshirt_1'] = 15,
            ['tshirt_2'] = 0,
            ['torso_1'] = 578,
            ['torso_2'] = 5,
            ['decals_1'] = 0,
            ['decals_2'] = -1,
            ['arms'] = 5,
            ['pants_1'] = 194,
            ['pants_2'] = 0,
            ['shoes_1'] = 27,
            ['shoes_2'] = 0,
            ['helmet_1'] = -1,
            ['helmet_2'] = 0,
            ['ears_1'] = -1,
            ['ears_2'] = 0,
            ['bproof_1'] = 0,
            ['bproof_2'] = 0,
            ['bags_1'] = 0,
            ['bags_2'] = 0,
            ['glasses_1'] = 0,
            ['glasses_2'] = 0,
            ['chain_1'] = -1,
            ['chain_2'] = 0,
            ['mask_1'] = -1,
            ['mask_2'] = 0
        },
    
        female = {
            ['tshirt_1'] = 15,
            ['tshirt_2'] = 0,
            ['torso_1'] = 5,
            ['torso_2'] = 0,
            ['decals_1'] = 0,
            ['decals_2'] = 0,
            ['arms'] = 15,
            ['pants_1'] = 222,
            ['pants_2'] = 0,
            ['shoes_1'] = 26,
            ['shoes_2'] = 0,
            ['helmet_1'] = -1,
            ['helmet_2'] = 0,
            ['ears_1'] = -1,
            ['ears_2'] = 0,
            ['bproof_1'] = 0,
            ['bproof_2'] = 0,
            ['bags_1'] = 30,
            ['bags_2'] = 0,
            ['glasses_1'] = -1,
            ['glasses_2'] = 0,
            ['chain_1'] = 0,
            ['chain_2'] = 0,
            ['mask_1'] = 0,
            ['mask_2'] = 0
        }
    }, 
}

local open = false
local outfitmenu = RageUI.CreateMenu("Prison", "Tenue de prisonnier", 0.0, 0.0)
outfitmenu.Closed = function()
    open = false
end

function openprisonOutfitMenu()
    if open then
        open = false
        RageUI.Visible(outfitmenu, false)
    else
        open = true
        RageUI.Visible(outfitmenu, true)
        Citizen.CreateThread(function()
            while open do
                RageUI.IsVisible(outfitmenu, function()
                    RageUI.Button("Tenue", nil, {}, true, {
                        onSelected = function()
                            TriggerEvent('skinchanger:getSkin', function(skin)
                                if skin.sex == 0 then
                                    TriggerEvent('skinchanger:loadClothes', skin, prison.outfit.male)
                                    p:saveSkin()
                                    TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1,
                                        { renamed = Prisonnier,
                                            data = p:skin(), })
                                else
                                    TriggerEvent('skinchanger:loadClothes', skin, prison.outfit.female)
                                    p:saveSkin()
                                    TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1,
                                        { renamed = Prisonnier,
                                            data = p:skin(), })
                                end
                            end)
                        end
                    })
                end)
                Wait(1)
            end
        end)
    end
end


zone.addZone(
    "prison.Outfit" .. math.random(0, 156465654),
    vector3(1840.322265625, 2579.4418945313, 46.01432800293),
    "~INPUT_CONTEXT~ Intéragir",
    function()
        openprisonOutfitMenu()
    end,
    false
)

local outfitmenu_guard = RageUI.CreateMenu("Prison", "Tenue de garde", 0.0, 0.0)
outfitmenu_guard.Closed = function()
    open = false
end

function openprisonguardOutfitMenu()
    if open then
        open = false
        RageUI.Visible(outfitmenu_guard, false)
    else
        open = true
        RageUI.Visible(outfitmenu_guard, true)
        Citizen.CreateThread(function()
            while open do
                RageUI.IsVisible(outfitmenu_guard, function()
                    RageUI.Button("Tenue", nil, {}, true, {
                        onSelected = function()
                            TriggerEvent('skinchanger:getSkin', function(skin)
                                if skin.sex == 0 then
                                    TriggerEvent('skinchanger:loadClothes', skin, prison_guard.outfit.male)
                                    p:saveSkin()
                                    TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1,
                                        { renamed = Garde,
                                            data = p:skin(), })
                                else
                                    TriggerEvent('skinchanger:loadClothes', skin, prison_guard.outfit.female)
                                    p:saveSkin()
                                    TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1,
                                        { renamed = Garde,
                                            data = p:skin(), })
                                end
                            end)
                        end
                    })
                end)
                Wait(1)
            end
        end)
    end
end


zone.addZone(
    "prison_guard.Outfit" .. math.random(0, 156465654),
    vector3(1834.3203125, 2572.0861816406, 45.014343261719),
    "~INPUT_CONTEXT~ Intéragir",
    function()
        openprisonguardOutfitMenu()
    end,
    true,
    25, -- Id / type du marker
    0.6, -- La taille
    { 51, 204, 255 }, -- RGB
    170-- Alpha
)

Citizen.CreateThread(function()
    local ped = entity:CreatePedLocal("s_m_m_prisguard_01", vector3(1840.4178466797, 2577.2375488281, 45.014354705811),
        357.03469848633)
    SetEntityInvincible(ped.id, true)
    ped:setFreeze(true)
    TaskStartScenarioInPlace(ped.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
    SetEntityAsMissionEntity(ped.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped.id, true)
end) ]]