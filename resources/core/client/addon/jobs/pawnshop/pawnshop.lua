local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function loadPawnshop()
    local ped = nil
    local created = false
    if not created then
        ped = entity:CreatePedLocal("mp_m_shopkeep_01", vector3(-322.23556518555, -100.54807281494, 46.047378540039), 332.63122558594)
        created = true
    end
    SetEntityInvincible(ped.id, true)
    ped:setFreeze(true)
    SetEntityAsMissionEntity(ped.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped.id, true)

    zone.addZone("pawnshop",
        vector3(-322.23556518555, -100.54807281494, 46.047378540039),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le pawnshop",
        function()
            openPawnshop()
        end,
        false
    )
end

local open = false
local pawnshop_main = RageUI.CreateMenu("", "Que propose tu a vendre ?", 0.0, 0.0, "root_cause", "Banner-PanShop")
local pawnshop_sub = RageUI.CreateSubMenu(pawnshop_main, "", "Produits", 0.0, 0.0, "root_cause", "Banner-PanShop")
pawnshop_main.Closed = function()
    open = false
end


local VUI = exports["VUI"]
local main2 = VUI:CreateMenu("Pawnshop", "banner_pawnshop", true)

main2.OnClose(function()
    open = false
end)

local pawnshopCfg = {
    {
        item = "consolejv",
        price_min = 500,
        price_max = 1000,
    },
    {
        item = "tv",
        price_min = 1500,
        price_max = 3000,
    },
    {
        item = "tv2",
        price_min = 1000,
        price_max = 2000,
    },
    --{
    --    item = "laptop",
    --    price_min = 1400,
    --    price_max = 1900,
    --},
    {
        item = "jewel",
        price_min = 1000,
        price_max = 2000,
    },
    {
        item = "perfume",
        price_min = 500,
        price_max = 1000,
    },
    {
        item = "camera",
        price_min = 500,
        price_max = 1000,
    },
    {
        item = "enceinte",
        price_min = 1000,
        price_max = 2000,
    },
    {
        item = "manettejv",
        price_min = 500,
        price_max = 1000,
    },
    {
        item = "weapon_bouteille",
        price_min = 500,
        price_max = 1000,
    },
    {
        item = "guitar",
        price_min = 1000,
        price_max = 2000,
    },
    {
        item = "bouteille2",
        price_min = 1000,
        price_max = 2000,
    },
    {
        item = "champagne_pack",
        price_min = 500,
        price_max = 1000,
    },
    {
        item = "golf_bag",
        price_min = 500,
        price_max = 1000,
    }, 
    {
        item = "champagne",
        price_min = 500,
        price_max = 1000,
    },
    {
        item = "champ",
        price_min = 500,
        price_max = 1000,
    },
    {
        item = "diamond",
        price_min = 8000,
        price_max = 16000,
    },
    {
        item = "phone",
        price_min = 150,
        price_max = 300,
    },
    {
        item = "boombox",
        price_min = 150,
        price_max = 300,
    },
    {
        item = "weapon_bouteille",
        price_min = 500,
        price_max = 1000,
    },
    {
        item = "weapon_poolcue",
        price_min = 500,
        price_max = 1000,
    },
    {
        item = "weapon_dagger",
        price_min = 3000,
        price_max = 6000,
    },
    {
        item = "penden2",
        price_min = 300,
        price_max = 1000,
    },
}

local pawnshopItem = {}
for i = 1, 10 do
    table.insert(pawnshopItem, i)
end

function GetItemLabel(item)
    return items[item].label
end

function openPawnshop()
    if not pawnshopCfg then return end
    if open then
        open = false
        --RageUI.Visible(pawnshop_main, false)
        return
    else
        open = true
        for k, v in pairs(pawnshopCfg) do
            if not v then return end
            if not v.price_min then return end
            if not v.item then return end
            main2.Button(
                GetItemLabel(v.item),
                "",
                v.price_min .. "$",
                nil,
                false,
                function()
                    if p:getJob() == "pawnshop" and PawnShop.Duty then
                        local price = v.price_max
                        TriggerServerEvent("core:pawnshoplog", v.item, price)
                        TriggerServerEvent("core:pawnshopSell", token, v.item, price)
                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            -- duration = 5, -- In seconds, default:  4
                            content = "Vous avez reçu " .. price .. "$"
                        })
                    else
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            -- duration = 5, -- In seconds, default:  4
                            content = "Vous n'êtes ~s pas en service"
                        })
                    end
                end
            )
        end

        --[[RageUI.Visible(pawnshop_main, true)
        CreateThread(function()
            while open do
                RageUI.IsVisible(pawnshop_main, function()
                    for k, v in pairs(pawnshopCfg) do
                        if not v then return end
                        if not v.price_min then return end
                        RageUI.Button(v.item and GetItemLabel(v.item) or "?", false,
                            { RightLabel = v.price_min .. "$", }, true,
                            {
                                onSelected = function()
                                    if p:getJob() == "pawnshop" then
                                        local price = v.price_max
                                        TriggerServerEvent("core:pawnshoplog", v.item, price)
                                        TriggerServerEvent("core:pawnshopSell", token, v.item, price)
                                    else
                                        local price = v.price_min
                                        TriggerServerEvent("core:RemoveItemToInventory", token, v.item, 1, {})
                                        TriggerSecurGiveEvent("core:addItemToInventory", token, "money", v.price_min, {})
                                    end
                                end
                            }, nil)
                    end
                end)
                Wait(1)
            end
        end)]]
        main2.open()
    end
end

-- local haspressed = false
-- local hasZone = false
-- CreateThread(function()
--     while true do 
--         Wait(60000)
--         local job = TriggerServerCallback("core:getNumberOfDuty", token, 'pawnshop')
--         if job > 0 then 
--             zone.removeZone("pawnshopPublic")
--             hasZone = false
--         else
--             if not hasZone then
--                 hasZone = true
--                 zone.addZone("pawnshopPublic",
--                     vector3(-322.23556518555, -100.54807281494, 46.047378540039),
--                     "~INPUT_CONTEXT~ Vendre vos objets au pawnshop",
--                     function()
--                         if not haspressed then
--                             haspressed = true -- NO DUPLI
--                             local totalp = 0
--                             for k,v in pairs(p:getInventaire()) do 
--                                 for z, x in pairs(pawnshopCfg) do 
--                                     if v.name == x.item then 
--                                         TriggerServerEvent("core:RemoveItemToInventory", token, v.name, v.count, {})
--                                         TriggerSecurGiveEvent("core:addItemToInventory", token, "money", x.price_min*v.count, {})
--                                         totalp = totalp + x.price_min*v.count
--                                     end
--                                 end
--                             end
--                             if totalp ~= 0 then
--                                 exports['vNotif']:createNotification({
--                                     type = 'VERT',
--                                     -- duration = 5, -- In seconds, default:  4
--                                     content = "Vous avez reçu " .. totalp .. "$"
--                                 })    
--                             end
--                             haspressed = false
--                         end
--                     end,
--                     false
--                 )
--             end
--         end
--     end
-- end)