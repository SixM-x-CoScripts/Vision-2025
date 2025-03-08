ManucureShop = {
    cam = nil,
    open = false,
}

local token
local onChair = false
local oldSkin = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

RegisterNUICallback("focusOut", function()
    if ManucureShop.open or onChair then
        ManucureShop.open = false 
        SetNuiFocusKeepInput(false)
        SetNuiFocus(false, false)
        ClearPedTasks(PlayerPedId())
        onChair = false
    end
end)

RegisterNetEvent("core:SheNailsRemovePlayerOnSeat", function()
    onChair = false 
    ManucureShop.open = false 
    ClearPedTasksImmediately(PlayerPedId())
    p:setSkin(oldSkin)
end)

RegisterNetEvent("core:SheNailsPlacePlayerOnSeat")
AddEventHandler("core:SheNailsPlacePlayerOnSeat", function(data)
    local Skin = p:skin()
    oldSkin = Skin
    ApplySkinFake(Skin)
    onChair = true
    TaskGoStraightToCoord(PlayerPedId(), data.sendPlayerPos.x,data.sendPlayerPos.y,data.sendPlayerPos.z, 1.0, 4000, data.headingPlace, 0.0)
    Wait(2500)
    SetEntityHeading(PlayerPedId(), data.headingPlace)
    Wait(500)
    TaskStartScenarioAtPosition(PlayerPedId(), "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", data.chairPos.x, data.chairPos.y, data.chairPos.z, GetEntityHeading(PlayerPedId()), 0, 1, false)
    --Wait(1500)
    --local dict = "anim@amb@clubhouse@bar@drink@idle_a"
    --while (not HasAnimDictLoaded(dict)) do
    --    RequestAnimDict(dict)
    --    Wait(5)
    --end
    --TaskPlayAnim(PlayerPedId(), dict, "idle_a_bartender", 1.0, 4.0, -1, 49, 0, 0, 0, 0)
end)


RegisterNetEvent("core:Menu_manucure_preview_callback")
AddEventHandler("core:Menu_manucure_preview_callback", function(data)
    if data == nil or data.category == nil then return end
    ManucureShop.choice = data.category
    if data.category == "Manucure" then 
        data.category = "decals_1"
        if data.VariationID then
            SkinChangeFake("decals_2", data.VariationID, true)
        end
    end
    if data.category == "Fard à joue" then data.category = "blush_1" SkinChangeFake("blush_2", 10, true) end
    if data.category == "Pilosité" then data.category = "chest_1" SkinChangeFake("chest_2", 10, true) end
    if data.category == "Sourcils" then data.category = "eyebrows_1" SkinChangeFake("eyebrows_2", 10, true) end
    if data.category == "Maquillage" then data.category = "makeup_1" SkinChangeFake("makeup_2", 10, true) end
    if data.category == "Piercing" then 
        data.category = "decals_1" 
        if data.VariationID then
            SkinChangeFake("decals_2", data.VariationID, true)
        end
    end
    if data.category == "Rouge à levre" then data.category = "lipstick_1" SkinChangeFake("lipstick_2", 10, true) end
    SkinChangeFake(data.category, data.id, true)
end)

RegisterNetEvent("core:Menu_manucure_achat_callback")
AddEventHandler("core:Menu_manucure_achat_callback", function(data)
    if data.button and data.button == "Manucure" then 
        while (not HasAnimDictLoaded("anim@amb@clubhouse@bar@drink@idle_a")) do
            RequestAnimDict("anim@amb@clubhouse@bar@drink@idle_a")
            Wait(5)
        end
        TaskPlayAnim(PlayerPedId(), "anim@amb@clubhouse@bar@drink@idle_a", "idle_a_bartender", 1.0, 4.0, -1, 49, 0, 0, 0, 0)
    else
        if IsEntityPlayingAnim(PlayerPedId(), "anim@amb@clubhouse@bar@drink@idle_a", "idle_a_bartender", 3) then
            StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@bar@drink@idle_a", "idle_a_bartender", 1.0)
        end
    end
    if data.type and data.value then -- Color, opacity
        if data.type == "opacity" then 
            if ManucureShop.choice == "Maquillage" then 
                SkinChangeFake("makeup_2", data.value/10, true)
            elseif ManucureShop.choice == "Rouge à levre" then 
                SkinChangeFake("lipstick_2", data.value/10, true)
            elseif ManucureShop.choice == "Fard à joue" then
                SkinChangeFake("blush_2", data.value/10, true)
            elseif ManucureShop.choice == "Pilosité" then
                SkinChangeFake("chest_2", data.value/10, true)
            elseif ManucureShop.choice == "Sourcils" then
                SkinChangeFake("eyebrows_2", data.value/10, true)
            end
        end
        if data.type == "color1" then 
            if ManucureShop.choice == "Maquillage" then 
                SkinChangeFake("makeup_3", data.value-1, true)
            elseif ManucureShop.choice == "Rouge à levre" then 
                SkinChangeFake("lipstick_3", data.value-1, true)
            elseif ManucureShop.choice == "Fard à joue" then
                SkinChangeFake("blush_3", data.value-1, true)
            elseif ManucureShop.choice == "Pilosité" then
                SkinChangeFake("chest_3", data.value-1, true)
            elseif ManucureShop.choice == "Sourcils" then
                SkinChangeFake("eyebrows_3", data.value-1, true)
            end
        end
        if data.type == "colorF" or data.type == "colorFard" then 
            if ManucureShop.choice == "Fard à joue" then
                SkinChangeFake("blush_3", data.value-1, true)
            end
        end
        if data.type == "color2" then 
            if ManucureShop.choice == "Maquillage" then 
                SkinChangeFake("makeup_4", data.value-1, true)
            elseif ManucureShop.choice == "Rouge à levre" then 
                SkinChangeFake("lipstick_4", data.value-1, true)
            elseif ManucureShop.choice == "Sourcils" then
                SkinChangeFake("eyebrows_4", data.value-1, true)
            end
        end
    end
    if data.changedData == nil then return end -- Pas la fin donc skip
    if data.changedData[ManucureShop.choice].item.price == nil then return end -- Si price alors achat
    --if ManucureShop.open then
        --local payed = TriggerServerCallback('core:pay', token, tonumber(data.changedData[ManucureShop.choice].item.price))
        --if payed then
        local skin = GetFakeSkin()
        --local realskin = SkinChangerGetSkin()

        p:setSkin(skin)
        p:saveSkin()
        oldSkin = skin
        if data.changedData[ManucureShop.choice].item.category == "Manucure" then 
            data.changedData[ManucureShop.choice].item.category = "decals_1"
            TriggerSecurGiveEvent("core:addItemToInventory", token, "ongle", 1, {
                renamed = "Ongles N°" .. data.changedData[ManucureShop.choice].item.id,
                drawableId = data.changedData[ManucureShop.choice].item.id,
                variationId = data.changedData[ManucureShop.choice].item.VariationID
            })
        end
        if data.changedData[ManucureShop.choice].item.category == "Fard à joue" then 
            data.changedData[ManucureShop.choice].item.category = "blush_1" 
        end
        if data.changedData[ManucureShop.choice].item.category == "Pilosité" then 
            data.changedData[ManucureShop.choice].item.category = "chest_1" 
        end
        if data.changedData[ManucureShop.choice].item.category == "Sourcils" then 
            data.changedData[ManucureShop.choice].item.category = "eyebrows_1" 
        end
        if data.changedData[ManucureShop.choice].item.category == "Maquillage" then 
            data.changedData[ManucureShop.choice].item.category = "makeup_1" 
        end
        if data.changedData[ManucureShop.choice].item.category == "Piercing" then 
            data.changedData[ManucureShop.choice].item.category = "decals_1" 
            TriggerSecurGiveEvent("core:addItemToInventory", token, "piercing", 1, {
                renamed = "Piercing N°" .. data.changedData[ManucureShop.choice].item.id,
                drawableId = data.changedData[ManucureShop.choice].item.id,
                variationId = data.changedData[ManucureShop.choice].item.VariationID
            })
        end
        if data.changedData[ManucureShop.choice].item.category == "Rouge à levre" then 
            data.changedData[ManucureShop.choice].item.category = "lipstick_1" 
        end
       -- TriggerEvent("skinchanger:change", data.changedData[ManucureShop.choice].item.category, data.changedData[ManucureShop.choice].item.id)
        --print("category, id", data.changedData[ManucureShop.choice].item.category, data.changedData[ManucureShop.choice].item.id)
        --SkinChangerChange(data.changedData[ManucureShop.choice].item.category, data.changedData[ManucureShop.choice].item.id, true)

        --print("fakeskin makeup", fakeskin["makeup_1"])
        --print("realskin makeup", realskin["makeup_1"])
        --for partNameReal, IdReal in pairs(realskin) do 
        --    for partNameFake,IdFake in pairs(fakeskin) do 
        --        if partNameReal == partNameFake then 
        --            if IdReal ~= IdFake then 
        --               -- print("c'est not equal !!!", partNameReal, partNameFake, data.changedData[ManucureShop.choice].item.category, IdReal, IdFake)
        --               -- print("c'est not equal !!!", partNameReal, partNameFake, data.changedData[ManucureShop.choice].item.category, IdReal, IdFake)
        --               -- print("c'est not equal !!!", partNameReal, partNameFake, data.changedData[ManucureShop.choice].item.category, IdReal, IdFake)
        --               -- print("c'est not equal !!!", partNameReal, partNameFake, data.changedData[ManucureShop.choice].item.category, IdReal, IdFake)
        --                if partNameFake == data.changedData[ManucureShop.choice].item.category or partNameReal == data.changedData[ManucureShop.choice].item.category then 
        --                    print("FOUND CHANGED ", data.changedData[ManucureShop.choice].item.category, data.changedData[ManucureShop.choice].item.id)
        --                    IdReal = data.changedData[ManucureShop.choice].item.id
        --                end
        --            end
        --        end
        --    end
        --end
        --p:setSkin(p:skin())
        --else
        --    exports['vNotif']:createNotification({
        --        type = 'ROUGE',
        --        -- duration = 5, -- In seconds, default:  4
        --        content = "~c Vous n'avez ~s pas assez d'argent"
        --    })
        --end
   -- end
end)


DataSendManucure = {
    catalogue = {},
    buttons = {
        {
            name = 'Maquillage',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/maquillage.svg',
            hoverStyle = 'fill-black stroke-black',
        --    opacity= true,
        --    color1= true,
        --    color2= true
        },
        {
            name = 'Rouge à levre',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/rougelevre.svg',
            hoverStyle = 'fill-black stroke-black',
        --    opacity= true,
        --    color1= true,
        --    color2= true
        },
        {
            name = 'Sourcils',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/eyebrow.svg',
            hoverStyle = 'fill-black stroke-black',
        --    opacity= true,
        --    color1= true,
        --    color2= true
        },
        {
            name = 'Fard à joue',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/blush.svg',
            hoverStyle = 'fill-black stroke-black',
        --    opacity= true,
        --    color1= true,
        },
        {
            name = 'Piercing',
            width = 'half',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/piercing.svg',
            hoverStyle = 'fill-black stroke-black',
        },
        {
            name = 'Pilosité',
            width = 'half',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/pilositetorse.svg',
            hoverStyle = 'fill-black stroke-black',
        },
    },
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'Manucure',
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Manicure/header.webp',
    callbackName = 'Menu_manucure_achat_callback',
    showTurnAroundButtons = false,
    disableSubmit= true
}

local function GetDatasManucure()
    local Skin = p:skin()
    ApplySkinFake(Skin)
    local playerType = "Homme"
    if GetEntityModel(PlayerPedId()) == `mp_f_freemode_01` then 
        playerType = "Femme"
        DataSendManucure.buttons = {}
        table.insert(DataSendManucure.buttons,
        { 
            name = 'Manucure', 
            width = 'full', 
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/manucure.svg', 
            hoverStyle = 'fill-black stroke-black'
        })
        Wait(10)
        table.insert(DataSendManucure.buttons,
        {
            name = 'Maquillage',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/maquillage.svg',
            hoverStyle = 'fill-black stroke-black',
        })
        Wait(10)
        table.insert(DataSendManucure.buttons,
        {
            name = 'Rouge à levre',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/rougelevre.svg',
            hoverStyle = 'fill-black stroke-black',
        })
        Wait(10)
        table.insert(DataSendManucure.buttons,
        {
            name = 'Sourcils',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/eyebrow.svg',
            hoverStyle = 'fill-black stroke-black',
        })
        Wait(10)
        table.insert(DataSendManucure.buttons,
        {
            name = 'Fard à joue',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/blush.svg',
            hoverStyle = 'fill-black stroke-black',
        })
        Wait(10)
        table.insert(DataSendManucure.buttons,
        {
            name = 'Piercing',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/piercing.svg',
            hoverStyle = 'fill-black stroke-black',
        })
       -- Wait(10)
       -- table.insert(DataSendManucure.buttons,
       -- {
       --     name = 'Pilosité',
       --     width = 'half',
       --     image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/pilositetorse.svg',
       --     hoverStyle = 'fill-black stroke-black',
       -- })
    end
    DataSendManucure.catalogue = {}
    -- Maquillage
    for i = 0, GetPedHeadOverlayNum(4)-1 do
        table.insert(DataSendManucure.catalogue, {id = i, price=20, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..playerType.."/Maquillage/"..i..".webp",
        category="Maquillage", label = "Maquillage #" .. i, ownCallbackName= 'Menu_manucure_preview_callback'})
    end

    -- fard a joue (blush)
    for i = 0, GetNumHeadOverlayValues(5)-1 do
        table.insert(DataSendManucure.catalogue, {id = i, price=20, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..playerType.."/Blush/"..i..".webp",
        category="Fard à joue", label = "Fard à joue #" .. i, ownCallbackName= 'Menu_manucure_preview_callback'})
    end

    -- pilosité
    for i = 0, GetNumHeadOverlayValues(10)-1 do
        table.insert(DataSendManucure.catalogue, {id = i, price=10, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..playerType.."/PilositeTorse/"..i..".webp",
        category="Pilosité", label = "Pilosité #" .. i, ownCallbackName= 'Menu_manucure_preview_callback'})
    end

    -- Sourcils
    for i = 0, GetNumHeadOverlayValues(2)-1 do 
        table.insert(DataSendManucure.catalogue, {id = i, price=20, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..playerType.."/Sourcils/"..i..".webp",
        category="Sourcils", label = "Sourcils #" .. i, ownCallbackName= 'Menu_manucure_preview_callback'})
    end

    -- Rouge a levre
    for i = 0, GetPedHeadOverlayNum(8)-1 do
        if i ~= 9 then
            table.insert(DataSendManucure.catalogue, {id = i, price=20, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..playerType.."/RougeLevre/"..i..".webp", 
            category="Rouge à levre", label = "Rouge à levre #" .. i, ownCallbackName= 'Menu_manucure_preview_callback'})
        end
    end

    -- piercings seulement femme
    if GetEntityModel(PlayerPedId()) == `mp_f_freemode_01` then 
        for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 10)-1 do
            if i > 196 and i < 232 and i ~= 198 and i ~= 200 and i ~= 202 and i ~= 203 and i ~= 204 and i ~= 205 
            and i ~= 208 and i ~= 214 and i ~= 215 and i ~= 227 and i ~= 230 then
                for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 10, i) do
                    table.insert(DataSendManucure.catalogue, {id = i, price=25, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..playerType.."/Piercing/"..i.."_"..z..".webp", category="Piercing", label="Piercing #" .. i, ownCallbackName= 'Menu_manucure_preview_callback', VariationID = z-1})
                end
            end
        end
        -- piercings seulement homme
    elseif GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then 
        for i = 185, 192 do 
            for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 10, i) do
                table.insert(DataSendManucure.catalogue, {id = i, price=25, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..playerType.."/Piercing/"..i.."_"..z..".webp", category="Piercing", label="Piercing #" .. i, ownCallbackName= 'Menu_manucure_preview_callback', VariationID = z-1})
            end
        end
    end

    -- ongles seulement femme
    local banonglelist = {197, 199, 201, 203, 206, 207, 234}
    for i = 209, 231, 1 do 
        table.insert(banonglelist, i)
    end
    if GetEntityModel(PlayerPedId()) == `mp_f_freemode_01` then 
        for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 10)-1 do
        --    print(i)
            if i > 195 and i < 237 then
                if not tableContains(banonglelist, i) then
                    for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 10, i) do
                        table.insert(DataSendManucure.catalogue, {id = i, price=25, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..playerType.."/Ongles/"..i.."_"..z..".webp", category="Manucure", label="Manucure #" .. i, ownCallbackName= 'Menu_manucure_preview_callback', VariationID = z-1})
                    end
                end
            end
        end
    end

    if p:skin().sex == 0 then
        DataSendManucure.headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp'
        DataSendManucure.headerIconName = 'Homme'
    elseif p:skin().sex == 1 then
        DataSendManucure.headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp'
        DataSendManucure.headerIconName = 'Femme'
    else
        DataSendManucure.headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp'
        DataSendManucure.headerIconName = 'Manucure'
    end

    DataSendManucure.disableSubmit = true

    return true
end


-- local cachedpos = {}
-- local function CreateCameraManucure(typecam, id)
--     if ManucureShop.cam == nil then
--         ManucureShop.cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
--     end
--     SetCamActive(ManucureShop.cam, 1)
--     local coord = GetEntityCoords(PlayerPedId())
--     local formattedcamval = {coord.x, coord.y, coord.z}
--     if typecam == "Rouge à levre" or typecam  == "Maquillage" or typecam == "Accessoires" then 
--         formattedcamval = {coord.x+1.0, coord.y, coord.z+0.9, 20, 0.6}
--     elseif typecam == "Accessoires" then 
--         if id == 211 or id == 212 or id == 213 or id == 219 or id == 220 then -- nombril
--             formattedcamval = {coord.x+1.0, coord.y, coord.z+0.1, 20, 0.6}
--             SkinChangeFake("t_shirt1", 0, true)
--         else
--             formattedcamval = {coord.x+1.0, coord.y, coord.z+0.9, 20, 0.6}
--         end
--     elseif typecam == "Manucure" then 
--         formattedcamval = {coord.x+1.0, coord.y, coord.z, 30, -0.1}
--         if not IsPedUsingScenario(PlayerPedId(), "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER") then
--             cachedpos = formattedcamval
--         end
--     end
--     if not IsPedUsingScenario(PlayerPedId(), "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER") then
--         SetCamCoord(ManucureShop.cam, formattedcamval[1], formattedcamval[2], formattedcamval[3])
--     else
--         SetCamCoord(ManucureShop.cam, cachedpos[1], cachedpos[2], cachedpos[3])
--     end
--     if typecam == "Manucure" then 
--         if not IsPedUsingScenario(PlayerPedId(), "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER") then
--             local BehindPlayer = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0 - 0.5, -0.5)
--             TaskStartScenarioAtPosition(PlayerPedId(), "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", BehindPlayer['x'], BehindPlayer['y'], BehindPlayer['z'], GetEntityHeading(PlayerPedId()), 0, 1, false)
--             Wait(1500)
--             local dict = "anim@amb@clubhouse@bar@drink@idle_a"
--             while (not HasAnimDictLoaded(dict)) do
--                 RequestAnimDict(dict)
--                 Wait(5)
--             end
--             TaskPlayAnim(PlayerPedId(), dict, "idle_a_bartender", 1.0, 4.0, -1, 49, 0, 0, 0, 0)
--             RemoveAnimDict(dict)
--             PointCamAtCoord(ManucureShop.cam, coord.x, coord.y, coord.z + cachedpos[5])
--         end
--     else
--         PointCamAtCoord(ManucureShop.cam, coord.x, coord.y, coord.z + formattedcamval[5])
--     end
--     if not IsPedUsingScenario(PlayerPedId(), "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER") then
--         SetCamFov(ManucureShop.cam, formattedcamval[4] + 0.1)
--     else
--         SetCamFov(ManucureShop.cam, cachedpos[4] + 0.1)        
--     end
--     Wait(20)
--     local p1 = GetCamCoord(ManucureShop.cam)
--     local p2 = GetEntityCoords(PlayerPedId())
--     local dx = p1.x - p2.x
--     local dy = p1.y - p2.y
--     --print("ManucureShop.cam, p1, p2", ManucureShop.cam, p1, p2)
--     local heading = GetHeadingFromVector_2d(dx, dy)
--     if typecam == "Manucure" then 
--         if not IsPedUsingScenario(PlayerPedId(), "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER") then
--             SetEntityHeading(PlayerPedId(), heading-90.0)
--         end
--     else
--         SetEntityHeading(PlayerPedId(), heading)
--     end
--     RenderScriptCams(true, 0, 3000, 1, 0)
-- end



-- RegisterNUICallback("Menu_manucure_preview_callback", function(data)
--     if data == nil or data.category == nil then return end
--     ManucureShop.choice = data.category
--     CreateCameraManucure(data.category, data.id)
--     if  data.category == "Manucure" or data.category == "Accessoires" then 
--         local length = math.floor(math.log10(data.id)+1)
--         local dataid = math.floor(data.id/10)
--         local dataid2 = data.id % 10
--         data.id = dataid
--     end
--     if data.category == "Manucure" then data.category = "decals_1" SkinChangeFake("decals_2", dataid2, true) end
--     if data.category == "Maquillage" then data.category = "makeup_1" SkinChangeFake("makeup_2", 100, true) end
--     if data.category == "Rouge à levre" then data.category = "lipstick_1" SkinChangeFake("lipstick_2", 100, true) end
--     if data.category == "Accessoires" then data.category = "decals_1" SkinChangeFake("decals_2", dataid2, true) end
--     SkinChangeFake(data.category, data.id, true)
-- end)








-- RegisterNUICallback("Menu_manucure_achat_callback", function(data)
--     if data.button then -- Click button
--         CreateCameraManucure(data.button)
--         if data.button ~= "Manucure" then 
--             if IsPedUsingScenario(PlayerPedId(), "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER") then 
--                 ClearPedTasksImmediately(PlayerPedId())
--             end
--         end
--     end
--     if data.reset then -- Reset button (bannière)
--         ClearPedTasks(PlayerPedId())
--         cachedpos = {}
--         RenderScriptCams(false, 0, 3000, 1, 0)
--     end
--     if data.type and data.value then -- Color, opacity
--         if data.type == "opacity" then 
--             if ManucureShop.choice == "Maquillage" then 
--                 SkinChangeFake("makeup_2", data.value/10, true)
--             elseif ManucureShop.choice == "Rouge à levre" then 
--                 SkinChangeFake("lipstick_2", data.value/10, true)
--             end
--         end
--         if data.type == "color1" then 
--             if ManucureShop.choice == "Maquillage" then 
--                 SkinChangeFake("makeup_3", data.value-1, true)
--             elseif ManucureShop.choice == "Rouge à levre" then 
--                 SkinChangeFake("lipstick_3", data.value-1, true)
--             end
--         end
--         if data.type == "color2" then 
--             if ManucureShop.choice == "Maquillage" then 
--                 SkinChangeFake("makeup_4", data.value-1, true)
--             elseif ManucureShop.choice == "Rouge à levre" then 
--                 SkinChangeFake("lipstick_4", data.value-1, true)
--             end
--         end
--     end
--     if data.changedData == nil then return end -- Pas la fin donc skip
--     --print("data.changedData", json.encode(data.changedData))
--     --print("data.changedData.Maquillage", data.changedData.Maquillage)
--     --print("json", json.encode(data.changedData.Maquillage))
--     --print("json 2", json.encode(data.changedData[ManucureShop.choice]))
--     --print("price", data.changedData[ManucureShop.choice].item.price)
--     if data.changedData[ManucureShop.choice].item.price == nil then return end -- Si price alors achat
--     if ManucureShop.open then
--         local payed = TriggerServerCallback('core:pay', token, tonumber(data.changedData[ManucureShop.choice].item.price))
--         if payed then
--             local skin = GetFakeSkin()
--             p:setSkin(skin)
--             p:saveSkin()
--             --if data.category and data.category == "Manucure" then 
--             --    local dataid = math.floor(data.id/10)
--             --    local dataid2 = data.id % 10
--             --    --TriggerSecurGiveEvent("core:addItemToInventory", token, "montre", 1, {
--             --    --    renamed = "Montre #" .. dataid,
--             --    --    drawableId = dataid,
--             --    --    variationId = dataid2 or 0
--             --    --})
--             --end
--         else
--             exports['vNotif']:createNotification({
--                 type = 'ROUGE',
--                 -- duration = 5, -- In seconds, default:  4
--                 content = "~c Vous n'avez ~s pas assez d'argent"
--             })

--         end
--     end
-- end)

--local firstart = false
OpenManucureShopUI = function()
    --if firstart == false then
        --firstart = true 
    local bool = GetDatasManucure()
    while not bool do 
        Wait(1)
    end
    --end
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
    Wait(50)
    ManucureShop.open = true
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'MenuGrosCatalogueColor',
        data = DataSendManucure
    }))
end

local manucure_pos = {
    vector3(226.00, -1544.24, 29.28),
}

CreateThread(function()
    while zone == nil do
        Wait(1)
    end

    for k, v in pairs(manucure_pos) do
        zone.addZone("manucure_shopcata" .. k,
            vector3(v.x, v.y, v.z),
            "~INPUT_CONTEXT~ Catalogue",
            function()
                if not ManucureShop.open then
                    OpenManucureShopUI()
                end
            end, false,
            false, -- Avoir un marker ou non
            25, -- Id / type du marker
            0.6, -- La taille
            { 51, 204, 255 }, -- RGB
            170,-- Alpha
            1.5,
            true,
            "bulleCatalogue"
        )
    end
end)