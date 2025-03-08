BijouterieShop = {
    cam = nil,
    open = false,
    Preopen = false,
}

local PremiumMontres = {48, 49, 51}
--local PremiumMontres = {38, 39}
local BijouteriePed = nil

local BijouterieShopPreopen = false

local oldSkin = nil

local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

RegisterNUICallback("focusOut", function()
    if BijouterieShop.open then
        --zone.showNotif(BijouterieId)
        Bulle.show(BijouterieId)
        SetNuiFocusKeepInput(false)
        SetNuiFocus(false, false)
        ClearPedTasks(PlayerPedId())
        FreezeEntityPosition(PlayerPedId(), false)
        BijouterieShop.open = false
        p:setSkin(oldSkin)
        if BijouteriePed then 
            DeleteEntity(BijouteriePed.id)
            BijouteriePed = nil
        end
    end
    if BijouterieShop.cam then 
        DestroyCam(BijouterieShop.cam)
        SetNuiFocusKeepInput(false)
		RenderScriptCams(false, false, 3000, 1, 0, 0)
        BijouterieShop.cam = nil
        ClearPedTasks(PlayerPedId())
        SetNuiFocus(false, false)
        FreezeEntityPosition(PlayerPedId(), false)
    end
    if BijouterieShopPreopen then 
      --  print("If BijouterieShopPreopen")
        SetNuiFocusKeepInput(false)
        SetNuiFocus(false, false)
        ClearPedTasks(PlayerPedId())
        FreezeEntityPosition(PlayerPedId(), false)
        BijouterieShopPreopen = false
        if BijouteriePed then 
            DeleteEntity(BijouteriePed.id)
            BijouteriePed = nil
        end
    end
end)

function WatchesAnimOnPed(ped)
    RequestAnimDict("anim@random@shop_clothes@watches")
    while not HasAnimDictLoaded("anim@random@shop_clothes@watches") do Wait(1) end
    TaskPlayAnim(ped and ped or PlayerPedId(), "anim@random@shop_clothes@watches", "base", 8.0, -8.0, -1, 1, 0, 0, 0, 0)
    RemoveAnimDict("anim@random@shop_clothes@watches")
end

local function GetDatas()
    local Skin = p:skin()
    ApplySkinFake(Skin)
    DataSendVangelico.catalogue = {}
    -- Montres
    local playerType = "Homme"
    if Skin.sex == 1 then
        playerType = "Femme"
    end

	local playerSex = Skin.sex == 0 and "male" or "female"

    local montresbanlistfemme = {0, 1, 11, 12, 13, 14, 15, 16, 17, 18, 29, 30, 31,32,33,34,35}
    local montresbanlisthomme = {49, 51}

    for i = 0, GetNumberOfPedPropDrawableVariations(PlayerPedId(), 6) - 1 do 
		local imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/props/watch/"..i..".webp"

        if playerType == "Homme" and (i ~= 40 and i ~= 2 and i ~= 22 and i ~= 23 and i ~= 24 and i ~= 25 and i ~= 26 and i ~= 27 and i ~= 28 and i ~= 29) and i < 53 then
			for z = 1, GetNumberOfPedPropTextureVariations(PlayerPedId(), 6, i) do
				if (i == 0 and z > 1) then elseif (i == 1 and z > 1) then else
					if not tableContains(PremiumMontres, i) then
						if not tableContains(montresbanlisthomme, i) then
							if z - 1 ~= 0 then
								imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/props/watch/"..i.."_"..(z -1)..".webp"
							end

							table.insert(DataSendVangelico.catalogue, {id = i, price = BijouteriePrices["Montres"][playerType][tostring(i.."_"..z)] or 200000, image=imageURL, category="Montres", label =  i, ownCallbackName= 'Menu_Vangelico_preview_callback', VariationID = z-1})
						end
					end
				end
			end
        elseif playerType == "Femme" then 
            for z = 1, GetNumberOfPedPropTextureVariations(PlayerPedId(), 6, i) do
                if not tableContains(montresbanlistfemme, i) then
					if z - 1 ~= 0 then
						imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/props/watch/"..i.."_"..(z -1)..".webp"
					end

                    table.insert(DataSendVangelico.catalogue, {id = i, price = BijouteriePrices["Montres"][playerType][tostring(i.."_"..z)] or 200000, image=imageURL, category="Montres", label =  i, ownCallbackName= 'Menu_Vangelico_preview_callback', VariationID = z-1})
                end
            end
        end
    end

    for k,v in pairs(PremiumMontres) do 
        for z = 1, GetNumberOfPedPropTextureVariations(PlayerPedId(), 6, v) do
			local imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/props/watch/"..v..".webp"
			if z - 1 ~= 0 then
				imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/props/watch/"..v.."_"..(z - 1)..".webp"
			end

            table.insert(DataSendVangelico.catalogue, {id = v, price = BijouteriePrices["Montres"][playerType][tostring(v.."_"..z)] or 15000, isPremium = true, image=imageURL, category="Premium", label =  v, ownCallbackName= 'Menu_Vangelico_preview_callback', VariationID = z-1})
        end
    end
    
    -- Colliers
    local listbanfemmecollier = {209, 196, 195, 194}
    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 7)-1 do
		local imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/clothing/accessory/"..i..".webp"

        if playerType == "Homme" and i > 224 and i < 267 and i ~= 228 and i ~= 246 and i ~= 249 and i ~= 229 and i ~= 233 and i ~= 234 and i ~= 235 and i ~= 236 then
            for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 7, i) do
				if z - 1 ~= 0 then
					imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/clothing/accessory/"..i.."_"..(z - 1)..".webp"
				end

                table.insert(DataSendVangelico.catalogue, {id = i, price = BijouteriePrices["Colliers"][playerType][tostring(i.."_"..z)], image=imageURL, category="Colliers", label="Colier #" .. i, ownCallbackName= 'Menu_Vangelico_preview_callback', VariationID = z-1})
            end
        elseif playerType == "Femme" and i > 172 and i < 217 then
            if not tableContains(listbanfemmecollier, i) then
                for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 7, i) do
					if z - 1 ~= 0 then
						imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/clothing/accessory/"..i.."_"..(z - 1)..".webp"
					end
                    if i == 114 and z > 2 then else
                        table.insert(DataSendVangelico.catalogue, {id = i, price = BijouteriePrices["Colliers"][playerType][tostring(i.."_"..z)], image=imageURL, category="Colliers", label="Colier #" .. i, ownCallbackName= 'Menu_Vangelico_preview_callback', VariationID = z-1})
                    end
                end
            end
        end
    end

    -- Bracelets
    for i = 0, GetNumberOfPedPropDrawableVariations(PlayerPedId(), 7)-1 do
		local imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/props/bracelet/"..i..".webp"
        for z = 1, GetNumberOfPedPropTextureVariations(PlayerPedId(), 7, i) do
			if z - 1 ~= 0 then
				imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/props/bracelet/"..i.."_"..(z - 1)..".webp"
			end
            if playerType == "Femme" then 
                if i ~= 15 then 
                    table.insert(DataSendVangelico.catalogue, {id = i, image=imageURL, category="Bracelets", label="Bracelet #" .. i, ownCallbackName= 'Menu_Vangelico_preview_callback', VariationID = z-1})
                end
            else
                table.insert(DataSendVangelico.catalogue, {id = i, image=imageURL, category="Bracelets", label="Bracelet #" .. i, ownCallbackName= 'Menu_Vangelico_preview_callback', VariationID = z-1})
            end
        end
    end

    -- Boucle d'oreille
    for i = 0, GetNumberOfPedPropDrawableVariations(PlayerPedId(), 2)-1 do
		local imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/props/ear/"..i..".webp"
        for z = 1, GetNumberOfPedPropTextureVariations(PlayerPedId(), 2, i) do
			if z - 1 ~= 0 then
				imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/props/ear/"..i.."_"..(z - 1)..".webp"
			end

            if playerType == "Femme" and i > 2 then
                table.insert(DataSendVangelico.catalogue, {id = i, image=imageURL, category="Boucles d\'oreilles", label="Boucles d\'oreilles #" .. i, ownCallbackName= 'Menu_Vangelico_preview_callback', VariationID = z-1})
            elseif playerType == "Homme" then
                table.insert(DataSendVangelico.catalogue, {id = i, image=imageURL, category="Boucles d\'oreilles", label="Boucles d\'oreilles #" .. i, ownCallbackName= 'Menu_Vangelico_preview_callback', VariationID = z-1})
            end
        end
    end

    -- bagues
    local bannedidbaguefemme = {115, 116, 122, 117, 118, 124}
    local bannedidbaguehomme = {141}
    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 9) - 1 do
        if playerType == "Homme" and i > 136 and i < 145 then
            for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 7, i) do
                local add = i+1
                if not tableContains(bannedidbaguehomme, i) then
                    -- DarkyGM, empale toi sur un cone VLC stp
					if i == 137 and z > 2 then else
                        if i == 138 and z > 2 then else
                            if i == 139 and z > 1 then else
                                if i == 140 and z > 2 then else
                                    if i == 144 and z > 3 then else
                                        if i == 143 and z > 1 then else
                                            table.insert(DataSendVangelico.catalogue, {id = i, image="https://cdn.sacul.cloud/v2/vision-cdn/Vangelico/"..playerType.."/Bagues/"..add.."_"..z..".webp", category="Bagues", label="Bague #" .. i, ownCallbackName= 'Menu_Vangelico_preview_callback', VariationID = z-1})
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        elseif playerType == "Femme" and i > 111 and i < 126 then
            if not tableContains(bannedidbaguefemme, i) then
                for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 7, i) do
                    if i == 119 and z > 2 then else
                        table.insert(DataSendVangelico.catalogue, {id = i, image="https://cdn.sacul.cloud/v2/vision-cdn/Vangelico/"..playerType.."/Bagues/"..i.."_"..z..".webp", category="Bagues", label="Bague #" .. i, ownCallbackName= 'Menu_Vangelico_preview_callback', VariationID = z-1})
                    end
                end
            end
        end
    end
    
    DataSendVangelico.headerIconName = "Vangelico"
    --if p:getJob() == "vangelico" then
   	--    DataSendVangelico.disableSubmit = false
    --else
    --    DataSendVangelico.disableSubmit = true
    --end

    return true
end

local function CreateCameraBijouterie(typecam)
    if BijouterieShop.cam == nil then
        BijouterieShop.cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    end
    SetCamActive(BijouterieShop.cam, 1)

    local ped = BijouteriePed and BijouteriePed.id or PlayerPedId()
    local coord = GetEntityCoords(ped)
    local formattedcamval = {coord.x, coord.y, coord.z}
    if typecam == "Bracelets" then 
        formattedcamval = {coord.x+1.0, coord.y, coord.z+0.45, 55, -0.2}
        --if not IsEntityPlayingAnim(PlayerPedId(), "amb@code_human_wander_idles_fat@male@idle_a", "idle_a_wristwatch", 3) then
        --    PlayEmote("amb@code_human_wander_idles_fat@male@idle_a", "idle_a_wristwatch", 49, -1)
        --end
    elseif typecam == "Bagues" then         
        formattedcamval = {coord.x+1.0, coord.y, coord.z-0.1, 65, -0.3}
    elseif typecam == "Montres" then 
        formattedcamval = {coord.x+1.0, coord.y, coord.z+0.49, 60, 0.2}
        if not IsEntityPlayingAnim(ped, "anim@random@shop_clothes@watches", "intro", 3) then
            if not IsEntityPlayingAnim(ped, "anim@random@shop_clothes@watches", "idle_d", 3) then
                WatchesAnimOnPed(ped)
            end
        end
    elseif typecam == "Colliers" then 
        formattedcamval = {coord.x+1.0, coord.y, coord.z+0.75, 60, 0.26}
        if not IsEntityPlayingAnim(ped, "clothingtie", "idle_a_wristwatch", 3) then
            PlayEmote("clothingtie", "try_tie_base", 49, -1)
        end
    elseif typecam == "Boucles d\'oreilles" then 
        formattedcamval = {coord.x+1.0, coord.y, coord.z+0.85, 30, 0.5}
        ClearPedTasks(ped)
    end
    if BijouteriePed and BijouteriePed.id then
        SetCamCoord(BijouterieShop.cam, -624.16827392578, -232.26432800293, 38.557010650635)
    else
        SetCamCoord(BijouterieShop.cam, formattedcamval[1], formattedcamval[2], formattedcamval[3])
    end
    PointCamAtCoord(BijouterieShop.cam, coord.x, coord.y, coord.z + formattedcamval[5])
    SetCamFov(BijouterieShop.cam, formattedcamval[4] + 0.1)
    Wait(20)
    local p1 = GetCamCoord(BijouterieShop.cam)
    local p2 = GetEntityCoords(ped)
    local dx = p1.x - p2.x
    local dy = p1.y - p2.y
    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(ped, heading)
    RenderScriptCams(true, 0, 3000, 1, 0)
end

RegisterNUICallback("buyItem", function(data)
    if BijouterieShop.open then 
        if data.category and data.id then 
            if data.category == "Premium" then
                if p:getSubscription() >= 1 then
                    if p:pay(tonumber(data.price)) then
                        TriggerSecurGiveEvent("core:addItemToInventory", token, "montre", 1, {
                            renamed = "Montre #" .. data.id,
                            drawableId = data.id,
                            variationId = data.VariationID or 0,
                            premium = true,
                        })
                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            -- duration = 5, -- In seconds, default:  4
                            content = "~c Vous avez récupéré votre montre"
                        })                
                        local skin = GetFakeSkin()
                        p:setSkin(skin)
                        p:saveSkin()
                        oldSkin = p:skin()
                    else
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            content = "~c Vous n'avez ~s pas assez d'argent"
                        })

                    end
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous devez avoir l'abonnement premium pour pouvoir acheter cette montre"
                    })
                end
            end
        end
    end
end)

RegisterNUICallback("Menu_Vangelico_achat_callback", function(data)
    --print("Menu_Vangelico_achat_callback", json.encode(data), data.price)
    if data.button then 
        CreateCameraBijouterie(data.button)
    end
    if data.reset then 
        ClearPedTasks(PlayerPedId())
        RenderScriptCams(false, 0, 3000, 1, 0)
    end
   -- if data.price == nil then return end
    if BijouterieShop.open and data.category and data.id then
        --local skin = GetFakeSkin()
        --p:setSkin(skin)
        --p:saveSkin()
        --oldSkin = p:skin()
        print("Achat : ", data.category, data.id, data.VariationID)
        if p:getJob() == "vangelico" then
            TriggerServerEvent("core:achatvangelico", data.category, 1)
            if data.category and data.category == "Montres" then 
                TriggerSecurGiveEvent("core:addItemToInventory", token, "montre", 1, {
                    renamed = "Montre #" .. data.id,
                    drawableId = data.id,
                    variationId = data.VariationID or 0
                })
            elseif data.category == "Bracelets" then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "bracelet", 1, {
                    renamed = "Bracelets #" .. data.id,
                    drawableId = data.id,
                    variationId = data.VariationID or 0
                })
            elseif data.category == "Boucles d\'oreilles" then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "bouclesoreilles", 1, {
                    renamed = "Boucles d\'oreilles #" .. data.id,
                    drawableId = data.id,
                    variationId = data.VariationID or 0
                })
            elseif data.category == "Colliers" then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "collier", 1, {
                    renamed = "Collier #" .. data.id,
                    drawableId = data.id,
                    variationId = data.VariationID or 0
                })
            elseif data.category == "Bagues" or data.category == "Bague" then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "bague", 1, {
                    renamed = "Bague #" .. data.id,
                    drawableId = data.id,
                    variationId = data.VariationID or 0
                })
            end
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "~c Vous avez récupéré le bijoux " .. data.category
            })          
        else
            if data.category and data.category == "Premium" then 
                TriggerSecurGiveEvent("core:addItemToInventory", token, "montre", 1, {
                    renamed = "Montre #" .. data.id,
                    drawableId = data.id,
                    variationId = data.VariationID or 0,
                    premium = true
                })
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Veuillez contacter un bijoutier pour pouvoir acheter des bijoux"
                })
            end
        end
    end
end)

RegisterNUICallback("Menu_Vangelico_preview_callback", function(data)
   -- print("Menu_Vangelico_preview_callback", json.encode(data))
    if data == nil or data.category == nil then return end
    if data.VariationID == nil then data.VariationID = 0 end
    if data.category == "Montres" or data.category == "Premium" then 
        CreateCameraBijouterie("Montres") 
        data.category = "watches_1"
        if data.VariationID then
            if not BijouteriePed then
                SkinChangeFake("watches_2", data.VariationID, true)
            else
                SkinChangeFakePed(BijouteriePed.id, "watches_2", data.VariationID, true)
            end
        end
    end
    if data.category == "Bracelets" then 
        CreateCameraBijouterie("Bracelets") 
        data.category = "bracelets_1"
        if data.VariationID then
            if not BijouteriePed then
                SkinChangeFake("bracelets_2", data.VariationID, true)
            else
                SkinChangeFakePed(BijouteriePed.id, "bracelets_2", data.VariationID, true)
            end
        end
    end
    if data.category == "Bagues" or data.category == "Bague" then
        CreateCameraBijouterie("Bagues") 
        data.category = "bproof_1"
        if data.VariationID then
            if not BijouteriePed then
                SkinChangeFake("bproof_2", data.VariationID, true)
            else
                SkinChangeFakePed(BijouteriePed.id, "bproof_2", data.VariationID, true)
            end
        end
    end
    if data.category == "Boucles d\'oreilles" then 
        CreateCameraBijouterie("Boucles d\'oreilles") 
        data.category = "ears_1"
        if data.VariationID then
            if not BijouteriePed then
                SkinChangeFake("ears_2", data.VariationID, true)
            else
                SkinChangeFakePed(BijouteriePed.id, "ears_2", data.VariationID, true)
            end
        end
    end
    if data.category == "Colliers" then 
        CreateCameraBijouterie("Colliers") 
        data.category = "chain_1" 
        if data.VariationID then
            if not BijouteriePed then
                SkinChangeFake("chain_2", data.VariationID, true)
            else
                SkinChangeFakePed(BijouteriePed.id, "chain_2", data.VariationID, true)
            end
        end
    end
    if not BijouteriePed then
        SkinChangeFake(data.category, data.id, true)
    else
        SkinChangeFakePed(BijouteriePed.id, data.category, data.id, true)
        Wait(100)
        SetPedComponentVariation(BijouteriePed.id, 3, 15, 0, 2) -- Amrs
        SetPedComponentVariation(BijouteriePed.id, 8, 15, 0, 2) -- Shirt
        SetPedComponentVariation(BijouteriePed.id, 11, 15, 0, 2) -- torso
        SetPedComponentVariation(BijouteriePed.id, 4, 61, 4, 2) -- Pants
        SetPedComponentVariation(BijouteriePed.id, 6, 34, 0, 2) -- Pants
        SetPedPropIndex(BijouteriePed.id, 1, 0, 0, 2) -- Glasses
    end
end)


DataSendVangelico = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Discord/banner_vangelico.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/bague.webp',
    headerIconName = 'Bijouterie',
    catalogue = {},
    buttons = {
        {
            name = 'Premium',
            width = 'full',
            isPremium = true,
            --image = 'https://cdn.sacul.cloud/v2/vision-cdn/Vangelico/logo_montre.svg',
            --hoverStyle = 'fill-black stroke-black',
            hoverStyle = 'stroke-black',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Discord/PremiumVangelico.webp',
            type = 'coverBackground',
        },
        {
            name = 'Montres',
            width = 'full',
            --image = 'https://cdn.sacul.cloud/v2/vision-cdn/Vangelico/logo_montre.svg',
            --hoverStyle = 'fill-black stroke-black',
            hoverStyle = 'stroke-black',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951144402242640826379image.webp',
            type = 'coverBackground',
        },
        {
            name = 'Colliers',
            width = 'full',
            --image = 'https://cdn.sacul.cloud/v2/vision-cdn/Vangelico/logo_colliers.svg',
            --hoverStyle = 'fill-black stroke-black',
            hoverStyle = 'stroke-black',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951144402327164428429image.webp',
            type = 'coverBackground',
        },
        {
            name = 'Boucles d\'oreilles',
            width = 'full',
            --image = 'https://cdn.sacul.cloud/v2/vision-cdn/Vangelico/logo_boucles_oreilles.svg',
            --hoverStyle = 'fill-black stroke-black',
            hoverStyle = 'stroke-black',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951144402392880791663image.webp',
            type = 'coverBackground',
        },
        {
            name = 'Bracelets',
            width = 'full',
            --image = 'https://cdn.sacul.cloud/v2/vision-cdn/Vangelico/logo_bracelets.svg',
            --hoverStyle = 'fill-black stroke-black',
            hoverStyle = 'stroke-black',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951144402467136733234image.webp',
            type = 'coverBackground',
        },
        {
            name = 'Bagues',
            width = 'full',
            --image = 'https://cdn.sacul.cloud/v2/vision-cdn/Vangelico/logo_bagues.svg',
            --hoverStyle = 'fill-black stroke-black',
            hoverStyle = 'stroke-black',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951144402539907924118image.webp',
            type = 'coverBackground',
        },
    },
    hideItemList= {'Bagues'},
    callbackName = 'Menu_Vangelico_achat_callback',
    showTurnAroundButtons = true
}

OpenBijouterieShopUI = function()
    if hasBraquerVangelico then return end
    local bool = GetDatas()
    oldSkin = p:skin()
    while not bool do 
        Wait(1)
    end
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
    Wait(50)
    BijouterieShop.open = true
    DataSendVangelico.isUserPremium = p:getSubscription()
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'MenuGrosCatalogue',
        data = DataSendVangelico
    }))
    forceHideRadar()
    SetNuiFocusKeepInput(true)
    CreateThread(function()
        while BijouterieShop.open do 
            Wait(1)
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 18, true)
            DisableControlAction(0, 322, true)
            DisableControlAction(0, 106, true)
            DisableControlAction(0, 24, true) 
            DisableControlAction(0, 25, true) 
            DisableControlAction(0, 263, true) 
            DisableControlAction(0, 264, true) 
            DisableControlAction(0, 257, true) 
            DisableControlAction(0, 140, true) 
            DisableControlAction(0, 141, true) 
            DisableControlAction(0, 142, true) 
            DisableControlAction(0, 143, true)
            DisableControlAction(0, 38, true)
            DisableControlAction(0, 44, true)
            if IsDisabledControlPressed(0, 38) then 
                SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId())+0.8)
            elseif IsDisabledControlPressed(0, 44) then 
                SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId())-0.8)
            end
        end
    end)
end

bijouterie_pos = {
    vector3(-624.09, -232.08, 38.05),
    vector3(-627.64898681641, -233.17517089844, 38.057056427002),
    vector3(-626.08679199219, -235.16400146484, 38.057056427002),
    vector3(-620.01361083984, -233.81510925293, 38.057048797607),
    vector3(-624.19934082031, -227.93943786621, 38.057010650635),
}

local function closePreviewMenu()
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
end

RegisterNUICallback("Pre_vangelico_callback", function(data)
    
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
    TriggerSWEvent("TREFSDFD5156FD", "ADSFDF", 5000)
    Wait(500)
    if data.button and data.button == "Catalogue homme" then 
        BijouteriePed = entity:CreatePed("mp_m_freemode_01", vector3(-623.28686523438, -231.65669250488, 37.057060241699), 124.80)
        AddRelationshipGroup("bijout")
        SetPedRelationshipGroupHash(BijouteriePed.id, GetHashKey("bijout"))
        SetRelationshipBetweenGroups(2, GetHashKey("bijout"), GetHashKey("PLAYER")) 
        SetPedComponentVariation(BijouteriePed.id, 3, 15, 0, 2) -- Amrs
        SetPedComponentVariation(BijouteriePed.id, 8, 15, 0, 2) -- Shirt
        SetPedComponentVariation(BijouteriePed.id, 11, 15, 0, 2) -- torso
        SetPedComponentVariation(BijouteriePed.id, 4, 61, 4, 2) -- Pants
        SetPedComponentVariation(BijouteriePed.id, 6, 34, 0, 2) -- Pants
        SetPedPropIndex(BijouteriePed.id, 1, 0, 0, 2) -- Glasses
        OpenBijouterieHommeShopUI(BijouteriePed.id)
        ClearPedDecorations(PlayerId())
    elseif data.button == "Catalogue femme" then 
        BijouteriePed = entity:CreatePed("mp_f_freemode_01", vector3(-623.28686523438, -231.65669250488, 37.057060241699), 124.80)
        SetPedComponentVariation(BijouteriePed.id, 3, 15, 0, 2) -- Amrs
        SetPedComponentVariation(BijouteriePed.id, 8, 15, 0, 2) -- Shirt
        SetPedComponentVariation(BijouteriePed.id, 11, 15, 0, 2) -- torso
        SetPedComponentVariation(BijouteriePed.id, 4, 61, 4, 2) -- Pants
        SetPedComponentVariation(BijouteriePed.id, 6, 34, 0, 2) -- Pants
        SetPedPropIndex(BijouteriePed.id, 1, 0, 0, 2) -- Glasses
        OpenBijouterieFemmeShopUI(BijouteriePed.id)
    end
    local isMale = data.button == "Catalogue homme"
    if BijouteriePed then
        SetEntityAsMissionEntity(BijouteriePed.id, 1, 1)
        SetCanAttackFriendly(BijouteriePed.id, false, false)
        FreezeEntityPosition(BijouteriePed.id, true)
        SetBlockingOfNonTemporaryEvents(BijouteriePed.id, true)
        --SetPedComponentVariation(BijouteriePed.id, 11, 15, 0, 0)
        --SetPedComponentVariation(BijouteriePed.id, 4, 9, 0, 0)
        SetPedConfigFlag(BijouteriePed.id, 140, false)
        SetPedConfigFlag(BijouteriePed.id, 17, true)
        --SetPedComponentVariation(BijouteriePed.id, 0, 0, 0, 2)
        --SetPedComponentVariation(BijouteriePed.id, 2, 0, 0, 2)
        WatchesAnimOnPed(BijouteriePed.id)
    end
end)

PreVangelico = {
    catalogue = {},
    buttons = {
        {
            name = 'Catalogue homme',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/barber/barbe.svg',
            hoverStyle = 'fill-black stroke-black',
        },
        {
            name = 'Catalogue femme',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/barber/cheveux.svg',
            hoverStyle = 'fill-black stroke-black',
        },
    },
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Discord/banner_vangelico.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/bague.webp',
    headerIconName = 'Bijouterie',
    callbackName = 'Pre_vangelico_callback'
}

local function AskVangelicoWhatChoose()
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
    Wait(50)
    BijouterieShopPreopen = true
    PreVangelico.isUserPremium = p:getSubscription()
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'MenuGrosCatalogue',
        data = PreVangelico
    }))
    forceHideRadar()
    SetNuiFocusKeepInput(true)
    CreateThread(function()
        while BijouterieShopPreopen do 
            Wait(1)
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 18, true)
            DisableControlAction(0, 322, true)
            DisableControlAction(0, 106, true)
            DisableControlAction(0, 24, true) 
            DisableControlAction(0, 25, true) 
            DisableControlAction(0, 263, true) 
            DisableControlAction(0, 264, true) 
            DisableControlAction(0, 257, true) 
            DisableControlAction(0, 140, true) 
            DisableControlAction(0, 141, true) 
            DisableControlAction(0, 142, true) 
            DisableControlAction(0, 143, true)
            DisableControlAction(0, 38, true)
            DisableControlAction(0, 44, true)
            if IsDisabledControlPressed(0, 38) then 
                SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId())+0.8)
            elseif IsDisabledControlPressed(0, 44) then 
                SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId())-0.8)
            end
        end
    end)
end

BijouterieId = 0

CreateThread(function()
    while zone == nil do
        Wait(1)
    end
    while p == nil do
        Wait(1)
    end

    for k, v in pairs(bijouterie_pos) do
        zone.addZone("bijouterie_shop" .. k,
            vector3(v.x, v.y, v.z),
            "~INPUT_CONTEXT~ Bijouterie",
            function()
                BijouterieId = "bijouterie_shop" .. k
                Bulle.hide(BijouterieId)
                if p:getJob() == "vangelico" then
                    if not BijouterieShopPreopen then
                        AskVangelicoWhatChoose()
                    end
                else
                    if not BijouterieShop.open then
                        OpenBijouterieShopUI()
                    end
                end
            end, 
            false,
            27,
            0.5,
            { 255, 255, 255 },
            170,
            2.5,
            true,
            "bulleBijouterie",
            true
        )
    end
end)

function firstToUpper(str) return (str:gsub("^%l", string.upper)) end

RegisterNetEvent("core:tempgiveiditem", function(player, dataid, name, variation)
    print("player, dataid, name, variation", player, dataid, name, variation)
    if name == "bouclesoreilles" then
        TriggerSecurGiveEvent("core:addItemToInventory", token, name, 1, {
			renamed = "Boucles d\'oreilles #" .. tonumber(dataid),
            drawableId = tonumber(dataid),
            variationId = tonumber(variation) or 0
        })
    elseif name == "sac" then 
        TriggerSecurGiveEvent("core:addItemToInventory", token, "access", 1, {
            renamed = "Sac #" .. tonumber(dataid),
            drawableId = tonumber(dataid),
            variationId = tonumber(variation) or 0,
            name = "sac"
        })
    else
        TriggerSecurGiveEvent("core:addItemToInventory", token, name, 1, {
            renamed = firstToUpper(name) .. " #" .. tonumber(dataid),
            drawableId = tonumber(dataid),
            variationId = tonumber(variation) or 0
        })
    end
end)

local function GetDatasType(playerTypef, ped)
    local Skin = p:skin()    
    ApplySkinFake(Skin)
    DataSendVangelico.catalogue = {}
    -- Montres

	local playerSex = playerTypef == "Homme" and "male" or "female"
	local montresbanlistfemme = {0, 1, 11, 12, 13, 14, 15, 16, 17, 18, 29, 30, 31,32,33,34,35}

    for i = 0, GetNumberOfPedPropDrawableVariations(ped, 6) - 1 do 
        local imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/props/watch/"..i..".webp"

		if playerTypef == "Homme" and (i ~= 40 and i ~= 2 and i ~= 22 and i ~= 23 and i ~= 24 and i ~= 25 and i ~= 26 and i ~= 27 and i ~= 28 and i ~= 29) and i < 53 then
			for z = 1, GetNumberOfPedPropTextureVariations(ped, 6, i) do
				if z - 1 ~= 0 then
					imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/props/watch/"..i.."_"..(z - 1)..".webp"
				end
				
				if (i == 0 and z > 1) then elseif (i == 1 and z > 1) then else
					table.insert(DataSendVangelico.catalogue, {id = i, price = 0, image=imageURL, category="Montres", label = "Montre #" .. i, ownCallbackName= 'Menu_Vangelico_preview_callback', VariationID = z-1})
				end
			end
        elseif playerTypef == "Femme" then 
            for z = 1, GetNumberOfPedPropTextureVariations(ped, 6, i) do
                if z - 1 ~= 0 then
					imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/props/watch/"..i.."_"..(z - 1)..".webp"
				end
				
				if not tableContains(montresbanlistfemme, i) then
                    table.insert(DataSendVangelico.catalogue, {id = i, price = 0, image=imageURL, category="Montres", label = "Montre #" .. i, ownCallbackName= 'Menu_Vangelico_preview_callback', VariationID = z-1})
                end
            end
        end
    end
    
    for k,v in pairs(PremiumMontres) do 
		local imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/props/watch/"..v..".webp"
        for z = 1, GetNumberOfPedPropTextureVariations(PlayerPedId(), 6, v) do
            if z - 1 ~= 0 then
				imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/props/watch/"..v.."_"..(z - 1)..".webp"
			end
			
			table.insert(DataSendVangelico.catalogue, {id = v, price = 100, isPremium = true, image=imageURL, label =  v, ownCallbackName= 'Menu_Vangelico_preview_callback', VariationID = z-1})
        end
    end
    
    -- Colliers
    local listbanfemmecollier = {209, 196, 195, 194}
    for i = 0, GetNumberOfPedDrawableVariations(ped, 7)-1 do
		local imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/clothing/accessory/"..i..".webp"

        if playerTypef == "Homme" and i > 224 and i < 266 and i ~= 228 and i ~= 246 and i ~= 249 and i ~= 229 and i ~= 233 and i ~= 234 and i ~= 235 and i ~= 236 then
            for z = 1, GetNumberOfPedTextureVariations(ped, 7, i) do
                if z - 1 ~= 0 then
					imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/clothing/accessory/"..i.."_"..(z - 1)..".webp"
				end

                table.insert(DataSendVangelico.catalogue, {id = i, price = 0, image=imageURL, category="Colliers", label="Colier #" .. i, ownCallbackName= 'Menu_Vangelico_preview_callback', VariationID = z-1})
            end
        elseif playerTypef == "Femme" and i > 172 and i < 217 then
            if not tableContains(listbanfemmecollier, i) then
                for z = 1, GetNumberOfPedTextureVariations(ped, 7, i) do
                   	if z - 1 ~= 0 then
						imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/clothing/accessory/"..i.."_"..(z - 1)..".webp"
					end
					
					if i == 114 and z > 2 then else
                        table.insert(DataSendVangelico.catalogue, {id = i, price = 0, image=imageURL, category="Colliers", label="Colier #" .. i, ownCallbackName= 'Menu_Vangelico_preview_callback', VariationID = z-1})
                    end
                end
            end
        end
    end

    -- Bracelets
    for i = 0, GetNumberOfPedPropDrawableVariations(ped, 7)-1 do
		local imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/props/bracelet/"..i..".webp"

        for z = 1, GetNumberOfPedPropTextureVariations(ped, 7, i) do
			if z - 1 ~= 0 then
				imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/props/bracelet/"..i.."_"..(z - 1)..".webp"
			end

            if playerTypef == "Femme" then 
				if i ~= 15 then 
                    table.insert(DataSendVangelico.catalogue, {id = i, price = 0, image=imageURL, category="Bracelets", label="Bracelet #" .. i, ownCallbackName= 'Menu_Vangelico_preview_callback', VariationID = z-1})
                end
            else
                table.insert(DataSendVangelico.catalogue, {id = i, price = 0, image=imageURL, category="Bracelets", label="Bracelet #" .. i, ownCallbackName= 'Menu_Vangelico_preview_callback', VariationID = z-1})
            end
        end
    end

    -- Boucle d'oreille
    for i = 0, GetNumberOfPedPropDrawableVariations(ped, 2)-1 do
		local imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/props/ear/"..i..".webp"

        for z = 1, GetNumberOfPedPropTextureVariations(ped, 2, i) do
            if z - 1 ~= 0 then
				imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/"..playerSex.."/props/ear/"..i.."_"..(z - 1)..".webp"
			end
			
			if playerTypef == "Femme" and i > 2 then
                table.insert(DataSendVangelico.catalogue, {id = i, price = 0, image=imageURL, category="Boucles d\'oreilles", label="Boucles d\'oreilles #" .. i, ownCallbackName= 'Menu_Vangelico_preview_callback', VariationID = z-1})
            elseif playerTypef == "Homme" then
                table.insert(DataSendVangelico.catalogue, {id = i, price = 0, image=imageURL, category="Boucles d\'oreilles", label="Boucles d\'oreilles #" .. i, ownCallbackName= 'Menu_Vangelico_preview_callback', VariationID = z-1})
            end
        end
    end

    -- bagues
    local bannedidbaguefemme = {115, 116, 122, 117, 118, 124}
    local bannedidbaguehomme = {141}
    for i = 0, GetNumberOfPedDrawableVariations(ped, 9) - 1 do
        if playerTypef == "Homme" and i > 136 and i < 145 then
            for z = 1, GetNumberOfPedTextureVariations(ped, 7, i) do
                local add = i+1
                if not tableContains(bannedidbaguehomme, i) then
                    if i == 137 and z > 2 then else
                        if i == 138 and z > 2 then else
                            if i == 139 and z > 1 then else
                                if i == 140 and z > 2 then else
                                    if i == 144 and z > 1 then else
                                        if i == 143 and z > 1 then else
                                            table.insert(DataSendVangelico.catalogue, {id = i, price = 0, image="https://cdn.sacul.cloud/v2/vision-cdn/Vangelico/"..playerTypef.."/Bagues/"..add.."_"..z..".webp", category="Bagues", label="Bague #" .. i, ownCallbackName= 'Menu_Vangelico_preview_callback', VariationID = z-1})
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        elseif playerTypef == "Femme" and i > 113 and i < 127 then
            if not tableContains(bannedidbaguefemme, i) then
                for z = 1, GetNumberOfPedTextureVariations(ped, 7, i) do
                    if i == 119 and z > 2 then else
                        table.insert(DataSendVangelico.catalogue, {id = i, price = 0, image="https://cdn.sacul.cloud/v2/vision-cdn/Vangelico/"..playerTypef.."/Bagues/"..i.."_"..z..".webp", category="Bagues", label="Bague #" .. i, ownCallbackName= 'Menu_Vangelico_preview_callback', VariationID = z-1})
                    end
                end
            end
        end
    end
    
    DataSendVangelico.headerIconName = playerTypef
    DataSendVangelico.disableSubmit = false

    return true
end

OpenBijouterieHommeShopUI = function(ped)
    if p:getJob() == "vangelico" then
        local bool = GetDatasType("Homme", ped)
        oldSkin = p:skin()
      --  print("YESSS 3")
        while not bool do 
            Wait(1)
        end
      --  print("YESSS 4")
        BijouterieShop.open = true
        DataSendVangelico.isUserPremium = p:getSubscription()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuGrosCatalogue',
            data = DataSendVangelico
        }))
        forceHideRadar()
        SetNuiFocusKeepInput(true)
        CreateThread(function()
            local disablekeys = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 23, 24, 25, 26, 32, 33, 34, 35, 37, 44, 45, 61, 268,270, 269,266,281,280,278,279,71,72,73,74,77,87,232,62, 63,69, 70, 140, 141, 142, 257, 263, 264}
            while BijouterieShop.open do 
                Wait(1)
                for k,v in pairs(disablekeys) do 
                    DisableControlAction(0, v, true)
                end
                if IsDisabledControlPressed(0, 38) then 
                    SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId())+0.8)
                elseif IsDisabledControlPressed(0, 44) then 
                    SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId())-0.8)
                end
            end
        end)
    end
end

OpenBijouterieFemmeShopUI = function(ped)
    if p:getJob()  == "vangelico" then
        local bool = GetDatasType("Femme", ped)
        oldSkin = p:skin()
        while not bool do 
            Wait(1)
        end
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
        Wait(50)
        BijouterieShop.open = true
        DataSendVangelico.isUserPremium = p:getSubscription()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuGrosCatalogue',
            data = DataSendVangelico
        }))
        forceHideRadar()
        SetNuiFocusKeepInput(true)
        CreateThread(function()
            local disablekeys = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 23, 24, 25, 26, 32, 33, 34, 35, 37, 44, 45, 61, 268,270, 269,266,281,280,278,279,71,72,73,74,77,87,232,62, 63,69, 70, 140, 141, 142, 257, 263, 264}
            while BijouterieShop.open do 
                Wait(1)
                for k,v in pairs(disablekeys) do 
                    DisableControlAction(0, v, true)
                end
                if IsDisabledControlPressed(0, 38) then 
                    SetEntityHeading(BijouteriePed and BijouteriePed.id or PlayerPedId(), GetEntityHeading(BijouteriePed and BijouteriePed.id or PlayerPedId())+0.8)
                elseif IsDisabledControlPressed(0, 44) then 
                    SetEntityHeading(BijouteriePed and BijouteriePed.id or PlayerPedId(), GetEntityHeading(BijouteriePed and BijouteriePed.id or PlayerPedId())-0.8)
                end
            end
        end)
    end
end

RegisterCommand("bijouteriefemme", OpenBijouterieFemmeShopUI)