-- local token = nil

-- TriggerEvent("core:RequestTokenAcces", "core", function(t)
--     token = t
-- end)

-- function LoadDigiten()
--     local ped = nil 
--     -- local ped2 = nil
--     local created = false
--     if not created then
--         ped = entity:CreatePedLocal("a_f_y_business_01", vector3(-1208.14453125, -1501.9516601563, 3.373884677887),
--             128.97775268555)
--         -- ped2 = entity:CreatePedLocal("mp_m_shopkeep_01", vector3(-1209.6229248047, -1498.8590087891, 3.3738832473755),
--         --     177.16952514648)
--         created = true
--     end
--     SetEntityInvincible(ped.id, true)
--     ped:setFreeze(true)
--     SetEntityAsMissionEntity(ped.id, 0, 0)
--     SetBlockingOfNonTemporaryEvents(ped.id, true)
--     -- SetEntityInvincible(ped2.id, true)
--     -- ped2:setFreeze(true)
--     -- SetEntityAsMissionEntity(ped2.id, 0, 0)
--     -- SetBlockingOfNonTemporaryEvents(ped2.id, true)

--     zone.addZone("digiten",
--         vector3(-1208.7711181641, -1502.4432373047, 4.3961138725281),
--         "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le magasin d'électronique",
--         function()
--             openDigiten()
--         end, 
--         false
--     )
-- end

-- local open = false
-- local digiten_main = RageUI.CreateMenu("", "Digiten", 0.0, 0.0, "vision", "Banner_DigitalDen")
-- local digiten_sub = RageUI.CreateSubMenu(digiten_main, "", "Produits", 0.0, 0.0, "vision", "Banner_DigitalDen")
-- digiten_main.Closed = function()
--     open = false
-- end

-- local digitencfg = {
--     {
--         item = "phone",
--         price = 300,
--     },
--     {
--         item = "radio",
--         price = 80,
--     },
--     {
--         item = "laptop",
--         price = 1500,
--     },
--     {
--         item = "gps",
--         price = 300,
--     },
-- }

-- local digItem = {}
-- for i = 1, 10 do
--     table.insert(digItem, i)
-- end


-- function GetItemLabel(item)
--     return items[item].label
-- end

-- function openDigiten()
--     if open then
--         open = false
--         RageUI.Visible(digiten_main, false)
--         return
--     else
--         open = true
--         RageUI.Visible(digiten_main, true)
--         Citizen.CreateThread(function()        
--             while open do
--                 RageUI.IsVisible(digiten_main, function()
--                     for k,v in pairs(digitencfg) do  
--                         RageUI.Button(GetItemLabel(v.item) , nil, {RightLabel = "~g~"..v.price.."$"}, true, {
--                             onSelected = function()
--                                 TriggerSecurEvent("core:marketBuyItem", v.item, v.price, 1)
--                             end
--                         }, nil)
--                     end
--                 end)
--                 Wait(1)
--             end
--         end)
--     end
-- end


-- Citizen.CreateThread(function()
--     while p == nil do Wait(1000) end
--     Wait(1000)
--     LoadDigiten()
--     print("[INFO] Le magasin digiten a été chargé correctement")
-- end)