local token = nil
local TattooPNJ = nil
local tattoopeds = {}
local VUI = exports["VUI"]

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)


local TattooSoloMenu = VUI:CreateMenu("Partie du corps", "tattooshop", true)
local TattooSoloMenuItem = VUI:CreateSubMenu(TattooSoloMenu, "Tatouages", "tattooshop", true)

local translate = {
    ["ZONE_HEAD"] = "Tête",
    ["ZONE_LEFT_ARM"] = "Bras gauche",
    ["ZONE_RIGHT_ARM"] = "Bras droit",
    ["ZONE_LEFT_LEG"] = "Jambe gauche",
    ["ZONE_RIGHT_LEG"] = "Jambe droit",
    ["ZONE_TORSO"] = "Torse/Dos",
}

local TattooZone = {
    ZONE_HEAD = {},
    ZONE_LEFT_ARM = {},
    ZONE_RIGHT_ARM = {},
    ZONE_LEFT_LEG = {},
    ZONE_RIGHT_LEG = {},
    ZONE_TORSO = {},
}

local open = false
local plys = {}
local tattoos_menu = RageUI.CreateMenu("", "Salon de tatouage", 0.0, 0.0, "shopui_title_tattoos4",
    "shopui_title_tattoos4")
local tattoos_zone = RageUI.CreateSubMenu(tattoos_menu, "", "Salon de tatouage", 0.0, 0.0, "shopui_title_tattoos4",
    "shopui_title_tattoos4")
local buy_or_show = RageUI.CreateSubMenu(tattoos_zone, "", "Salon de tatouage", 0.0, 0.0, "shopui_title_tattoos4",
    "shopui_title_tattoos4")
local oldSkin = {}
local index = {}
playerTattoos = {}
local TattooPNJ = nil
local isMale = true
local indexx = nil

local open1 = false
local choose_menu = RageUI.CreateMenu("", "Salon de tatouage", 0.0, 0.0, "shopui_title_tattoos4",
    "shopui_title_tattoos4")
local menu_choosehf = RageUI.CreateSubMenu(choose_menu, "", "Salon de tatouage", 0.0, 0.0, "shopui_title_tattoos4",
"shopui_title_tattoos4")
local menu_deltattoo1 = RageUI.CreateSubMenu(choose_menu, "", "Salon de tatouage", 0.0, 0.0, "shopui_title_tattoos4",
"shopui_title_tattoos4")
local menu_deltattoo2 = RageUI.CreateSubMenu(menu_deltattoo1, "", "Supression de tatouage", 0.0, 0.0, "shopui_title_tattoos4",
"shopui_title_tattoos4")
local chosenPlayer = nil
local plyTattoos = nil

local function tattooGetNameFromZoneSolo(name)
    if name == "ZONE_TORSO" then 
        name = "Torse"
    elseif name == "ZONE_RIGHT_ARM" then 
        name = "Bras droit"
    elseif name == "ZONE_LEFT_ARM" then 
        name = "Bras gauche"
    elseif name == "ZONE_HEAD" then 
        name = "Tête"
    elseif name == "ZONE_LEFT_LEG" then
        name = "Jambe gauche"
    elseif name == "ZONE_RIGHT_LEG" then
        name = "Jambe droite"
    end
    return name
end

local gotData = nil
local DataToSendTattoo = nil
local function GetDatasTattoo()
    local male = GetEntityModel(PlayerPedId()) == `mp_m_freemode_01`
    gotData = male
    DataToSendTattoo = {
        buttons= {
            {
                name= 'Torse',
                width= 'full',
                type = 'coverBackground',
                image= male and 'https://cdn.sacul.cloud/v2/vision-cdn/Tattoo/Homme/Torse.webp' or 'https://cdn.sacul.cloud/v2/vision-cdn/Tattoo/Femme/Torse.webp',
                hoverStyle= 'fill-black stroke-black',
                opacity= false,
                color1= false,
                color2= false
            },
            {
                name= 'Dos',
                width= 'full',
                type = 'coverBackground',
                image= male and 'https://cdn.sacul.cloud/v2/vision-cdn/Tattoo/Homme/Dos.webp' or 'https://cdn.sacul.cloud/v2/vision-cdn/Tattoo/Femme/Dos.webp',
                hoverStyle= 'fill-black stroke-black',
                opacity= false,
                color1= false,
                color2= false
            },
            {
                name= 'Visage',
                width= 'full',
                type = 'coverBackground',
                image= male and 'https://cdn.sacul.cloud/v2/vision-cdn/Tattoo/Homme/Visage.webp' or 'https://cdn.sacul.cloud/v2/vision-cdn/Tattoo/Femme/Visage.webp',
                hoverStyle= 'fill-black stroke-black',
                opacity= false,
                color1= false,
                color2= false
            },
            {
                name= 'Bras gauche',
                width= 'half',
                type = 'coverBackground',
                image= male and 'https://cdn.sacul.cloud/v2/vision-cdn/Tattoo/Homme/BrasGauche.webp' or 'https://cdn.sacul.cloud/v2/vision-cdn/Tattoo/Femme/BrasGauche.webp',
                hoverStyle= 'fill-black stroke-black',
                opacity= false,
                color1= false,
                color2= false
            },
            {
                name= 'Bras droit',
                width= 'half',
                type = 'coverBackground',
                image= male and 'https://cdn.sacul.cloud/v2/vision-cdn/Tattoo/Homme/BrasDroit.webp' or 'https://cdn.sacul.cloud/v2/vision-cdn/Tattoo/Femme/BrasDroit.webp',
                hoverStyle= 'fill-black stroke-black',
                opacity= false,
                color1= false,
                color2= false
            },
            {
                name= 'Jambe gauche',
                width= 'half',
                type = 'coverBackground',
                image= male and 'https://cdn.sacul.cloud/v2/vision-cdn/Tattoo/Homme/JambeGauche.webp' or 'https://cdn.sacul.cloud/v2/vision-cdn/Tattoo/Femme/JambeGauche.webp',
                hoverStyle= 'fill-black stroke-black',
                opacity= false,
                color1= false,
                color2= false
            },
            {
                name= 'Jambe droite',
                width= 'half',
                type = 'coverBackground',
                image= male and 'https://cdn.sacul.cloud/v2/vision-cdn/Tattoo/Homme/JambeDroite.webp' or 'https://cdn.sacul.cloud/v2/vision-cdn/Tattoo/Femme/JambeDroite.webp',
                hoverStyle= 'fill-black stroke-black',
                opacity= false,
                color1= false,
                color2= false
            },
        },
        catalogue = {},
    }
    local tattoos = GetTattoos()
    -- create tattoos list by zone
    for i = 1, #tattoos, 1 do
        if tattoos[i].Zone == "ZONE_HEAD" then
            if male and tattoos[i].HashNameMale then
                table.insert(TattooZone.ZONE_HEAD, tattoos[i])
            elseif not male and tattoos[i].HashNameFemale ~= "" then

                table.insert(TattooZone.ZONE_HEAD, tattoos[i])
            end
        elseif tattoos[i].Zone == "ZONE_LEFT_ARM" then
            if male and tattoos[i].HashNameMale ~= "" then
                table.insert(TattooZone.ZONE_LEFT_ARM, tattoos[i])
            elseif not male and tattoos[i].HashNameFemale ~= "" then

                table.insert(TattooZone.ZONE_LEFT_ARM, tattoos[i])
            end
        elseif tattoos[i].Zone == "ZONE_RIGHT_ARM" then
            if male and tattoos[i].HashNameMale ~= "" then
                table.insert(TattooZone.ZONE_RIGHT_ARM, tattoos[i])
            elseif not male and tattoos[i].HashNameFemale ~= "" then

                table.insert(TattooZone.ZONE_RIGHT_ARM, tattoos[i])
            end
        elseif tattoos[i].Zone == "ZONE_LEFT_LEG" then
            if male and tattoos[i].HashNameMale ~= "" then
                table.insert(TattooZone.ZONE_LEFT_LEG, tattoos[i])
            elseif not male and tattoos[i].HashNameFemale ~= "" then

                table.insert(TattooZone.ZONE_LEFT_LEG, tattoos[i])
            end
        elseif tattoos[i].Zone == "ZONE_RIGHT_LEG" then
            if male and tattoos[i].HashNameMale ~= "" then
                table.insert(TattooZone.ZONE_RIGHT_LEG, tattoos[i])
            elseif not male and tattoos[i].HashNameFemale ~= "" then
                table.insert(TattooZone.ZONE_RIGHT_LEG, tattoos[i])
            end
        elseif tattoos[i].Zone == "ZONE_TORSO" then
            if male then
                if tattoos[i].HashNameMale ~= "" then
                    table.insert(TattooZone.ZONE_TORSO, tattoos[i])
                end
            elseif not male then
                if tattoos[i].HashNameFemale ~= "" then
                    table.insert(TattooZone.ZONE_TORSO, tattoos[i])
                end
            end
        end
    end
    for k, v in pairs(TattooZone.ZONE_TORSO) do 
        table.insert(DataToSendTattoo.catalogue, {id = k, data = v, price = v.Price, label=GetLabelText(v.Name), image ='', category="Torse", subCategory="Torse", ownCallbackName = 'previewTattoo' })
    end
    for k, v in pairs(TattooZone.ZONE_TORSO) do 
        table.insert(DataToSendTattoo.catalogue, {id = k, data = v, price = v.Price, label=GetLabelText(v.Name), image ='', category="Dos", subCategory="Dos", ownCallbackName = 'previewTattoo' })
    end
    for k, v in pairs(TattooZone.ZONE_RIGHT_LEG) do 
        table.insert(DataToSendTattoo.catalogue, {id = k, data = v, price = v.Price, label=GetLabelText(v.Name), image ='', category="Jambe droite", subCategory="Jambe droite", ownCallbackName = 'previewTattoo' })
    end
    for k, v in pairs(TattooZone.ZONE_LEFT_LEG) do 
        table.insert(DataToSendTattoo.catalogue, {id = k, data = v, price = v.Price, label=GetLabelText(v.Name), image ='', category="Jambe gauche", subCategory="Jambe gauche", ownCallbackName = 'previewTattoo' })
    end
    for k, v in pairs(TattooZone.ZONE_RIGHT_ARM) do 
        table.insert(DataToSendTattoo.catalogue, {id = k, data = v, price = v.Price, label=GetLabelText(v.Name), image ='', category="Bras droit", subCategory="Bras droit", ownCallbackName = 'previewTattoo' })
    end
    for k, v in pairs(TattooZone.ZONE_LEFT_ARM) do 
        table.insert(DataToSendTattoo.catalogue, {id = k, data = v, price = v.Price, label=GetLabelText(v.Name), image ='', category="Bras gauche", subCategory="Bras gauche", ownCallbackName = 'previewTattoo' })
    end
    for k, v in pairs(TattooZone.ZONE_HEAD) do 
        table.insert(DataToSendTattoo.catalogue, {id = k, data = v, price = v.Price, label=GetLabelText(v.Name), image ='', category="Visage", subCategory="Visage", ownCallbackName = 'previewTattoo' })
    end
end

--[[ RegisterNUICallback("MenuTattoo", function(data)
    print("data.price", data.price, data.data.HashNameMale, data.data.Collection)
    if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
        if data.data.HashNameMale ~= "" then
            open = false
            if p:pay(tonumber(data.price)) then 
                TriggerServerEvent('core:addTattooToPlayer', token, GetPlayerServerId(PlayerId()),
                    { Collection = data.data.Collection, HashName = data.data.HashNameMale })
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "Vous avez acheté un tattouage"
                })
                SendNuiMessage(json.encode({
                    type = 'closeWebview'
                }))
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "~c Vous n'avez ~s pas assez d'argent"
                })
            end
        end
    else
        if data.data.HashNameFemale ~= "" then
            open = false
            if p:pay(tonumber(data.price)) then 
                TriggerServerEvent('core:addTattooToPlayer', token, GetPlayerServerId(PlayerId()),
                    { Collection = data.data.Collection, HashName = data.data.HashNameFemale })
                SendNuiMessage(json.encode({
                    type = 'closeWebview'
                }))
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "Vous avez acheté un tattouage"
                })
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "~c Vous n'avez ~s pas assez d'argent"
                })
            end
        end
    end
end) ]]

RegisterNUICallback("focusOut", function()
    if insideTattoo then 
        local playerSkin = p:skin()
        ApplySkin(playerSkin)
        insideTattoo = false
    end
end)

local selectedCatalogue = nil
local selectedCatalogueData = {}
local previewedTattoo = nil
TattooSoloMenu.OnOpen(function()
    FreezeEntityPosition(PlayerPedId(), true)
    for k, v in pairs(DataToSendTattoo.buttons) do
        TattooSoloMenu.ImageButton(
            v.name,
            v.image,
            false,
            function()
                selectedCatalogue = v.name
            end,
            TattooSoloMenuItem
        )
    end
end)

TattooSoloMenuItem.OnOpen(function()
    FreezeEntityPosition(PlayerPedId(), true)

    if selectedCatalogue ~= nil and #DataToSendTattoo.catalogue > 0 then
        TattooSoloMenuItem.SearchInput("Rechercher un tatouage", false)
    end

    print(json.encode(DataToSendTattoo.catalogue))

    for k, v in pairs(DataToSendTattoo.catalogue) do
        if v.category == selectedCatalogue and v.label ~= "NULL" then
            TattooSoloMenuItem.Button(
                v.label,
                nil,
                "$ " .. v.price,
                "chevron",
                false,
                function()
                    local confirmation = ChoiceInput("Souhaitez-vous acheter ce tatouage pour " .. v.price .. "$ ?")

                    if confirmation then
                        if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
                            if v.data.HashNameMale ~= "" then
                                open = false -- jsp c quoi mais dans le doute
                                if p:pay(tonumber(v.price)) then
                                    TriggerServerEvent('core:addTattooToPlayer', token, GetPlayerServerId(PlayerId()),
                                        { Collection = v.data.Collection, HashName = v.data.HashNameMale })

                                    exports['vNotif']:createNotification({
                                        type = 'VERT',
                                        content = "Vous avez acheté un tattouage"
                                    })
                                    TattooSoloMenuItem.close()
                                else
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        content = "~c Vous n'avez ~s pas assez d'argent"
                                    })
                                end
                            end
                        else
                            if v.data.HashNameFemale ~= "" then
                                open = false -- jsp c quoi mais dans le doute
                                if p:pay(tonumber(v.price)) then
                                    TriggerServerEvent('core:addTattooToPlayer', token, GetPlayerServerId(PlayerId()),
                                        { Collection = v.data.Collection, HashName = v.data.HashNameFemale })

                                    exports['vNotif']:createNotification({
                                        type = 'VERT',
                                        content = "Vous avez acheté un tattouage"
                                    })
                                    TattooSoloMenuItem.close()
                                else
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        content = "~c Vous n'avez ~s pas assez d'argent"
                                    })
                                end
                            end
                        end
                    end
                end
            )
        end
    end
end)

TattooSoloMenu.OnClose(function()
    FreezeEntityPosition(PlayerPedId(), false)
end)

TattooSoloMenuItem.OnClose(function()
    FreezeEntityPosition(PlayerPedId(), false)

    if previewedTattoo then
        ClearPedDecorations(PlayerPedId())
        previewedTattoo = nil
    end
end)

TattooSoloMenuItem.OnIndexChange(function(index, item)
    print("index", index, json.encode(item))
    for k, v in pairs(DataToSendTattoo.catalogue) do
        if v.label == item.props.title and v.category == selectedCatalogue then
            previewedTattoo = v.data.HashNameMale
            if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
                if GetHashKey(v.data.HashNameMale) ~= last then
                    last = GetHashKey(v.data.HashNameMale)
                    ClearPedDecorations(PlayerPedId())
                    SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2)
                    SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)
                    SetPedComponentVariation(PlayerPedId(), 11, 15, 0, 2)
                    SetPedComponentVariation(PlayerPedId(), 4, 21, 0, 2)
                    AddPedDecorationFromHashes(PlayerPedId(), GetHashKey(v.data.Collection)
                        , GetHashKey(v.data.HashNameMale))
                end
            else
                if GetHashKey(v.data.HashNameMale) ~= last then
                    last = GetHashKey(v.data.HashNameMale)
                    ClearPedDecorations(PlayerPedId())
                    SetPedComponentVariation(PlayerPedId(), 8, 34, 0, 0)
                    SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 0)
                    SetPedComponentVariation(PlayerPedId(), 11, 15, 0, 0)
                    SetPedComponentVariation(PlayerPedId(), 4, 15, 0, 0)
                    AddPedDecorationFromHashes(PlayerPedId(), GetHashKey(v.data.Collection)
                        , GetHashKey(v.data.HashNameMale))
                end
            end
        end
    end
end)

function chooseMenuSolo()
    if DataToSendTattoo == nil then 
        GetDatasTattoo()
    end

    TattooSoloMenu.open()
end

function chooseMenuSoloOLD()
    local TattooList = GetTattoos()
    if open1 then
        open1 = false
        RageUI.Visible(choose_menu, false)
    else
        open1 = true
        RageUI.Visible(choose_menu, true)
        CreateThread(function()
            while open1 do
                Wait(1)
                RageUI.IsVisible(choose_menu, function()
                    RageUI.Button("Ajouter un tatouage", nil, { RightLabel = "→→→" }, true, {
                        onSelected = function()
                        end
                    }, menu_choosehf)
                    RageUI.Button("Supprimer un tatouage", nil, { RightLabel = "→→→" }, true, {
                        onSelected = function()
                            GetAllPlayersInAreaWithDatatattooSudSolo()
                        end
                    }, menu_deltattoo1)
                end)
                RageUI.IsVisible(menu_choosehf, function()
                    RageUI.Button("Homme", nil, { RightLabel = "→→→" }, true, {
                        onSelected = function()
                            open1 = false
                            RageUI.CloseAll()
                            starttattooSudSolo(true)
                        end
                    }, nil)
                    RageUI.Button("Femme", nil, { RightLabel = "→→→" }, true, {
                        onSelected = function()
                            open1 = false
                            RageUI.CloseAll()
                            starttattooSudSolo(false)
                        end
                    }, nil)
                end)
                RageUI.IsVisible(menu_deltattoo1, function()
                    if plys then
                        for k, v in pairs(plys) do
                            RageUI.Button("~o~" .. v.player .. "~s~ | ~o~" .. v.name, nil, {}, true, {
                                onSelected = function()
                                    chosenPlayer = v
                                    plyTattoos = TriggerServerCallback("core:getPlayerTattoos", v.player)
                                end
                            }, menu_deltattoo2)
                        end
                    else
                        RageUI.Button("Aucun joueur dans la zone", nil, {}, true, {})
                    end
                end)
                RageUI.IsVisible(menu_deltattoo2, function()
                    if chosenPlayer then
                      --  print("GetPlayerPedDecorations", json.encode(plyTattoos))
                        for k,v in pairs(plyTattoos) do 
                            for z,x in pairs(TattooList) do
                                if x.HashNameMale == v.HashName or x.HashNameFemale == v.HashName then
                                    RageUI.Button(GetLabelText(x.Name), nil, {RightLabel= tattooGetNameFromZoneSolo(x.Zone)}, true, {
                                        onSelected = function()
                                            table.remove(plyTattoos, k)
                                            TriggerServerEvent("core:deleteTattooToPlayer", token, chosenPlayer.player, {HashName = v.HashName, Collection = v.Collection})
                                        end
                                    })
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
end

tattoos_menu.Closed = function()
    -- delete the spawned TattooPNJ
    if TattooPNJ ~= nil then
        DeleteEntity(TattooPNJ.id)
        TattooPNJ = nil
    end
    open = false
    collectgarbage("collect")
end

local function GetClosestDistanceToPedTableIDSolo(ped, tbl)
    local pedCoords = GetEntityCoords(ped)
    local closestDistance = -1
    local tblid = 1

    for i, coords in pairs(tbl) do
        local distance = GetDistanceBetweenCoords(pedCoords.x, pedCoords.y, pedCoords.z, coords.x, coords.y, coords.z)
        if closestDistance == -1 or distance < closestDistance then
            closestDistance = distance
            tblid = i
        end
    end

    return closestDistance, tblid
end

function starttattooSudSolo(isMale)
    if open then
        open = false
        -- delete the spawned ped
        if TattooPNJ ~= nil then
            DeleteEntity(TattooPNJ.id)
            TattooPNJ = nil
        end
        RageUI.Visible(tattoos_menu, false)
    else
        open = true
        RageUI.Visible(tattoos_menu, true)
        local tattoos = GetTattoos()
        if isMale then
            model = "mp_m_freemode_01"
        else
            model = "mp_f_freemode_01"
        end
        RequestModel(GetHashKey(model))
        while not HasModelLoaded(GetHashKey(model)) do
            Wait(0)
        end
        TriggerSWEvent("TREFSDFD5156FD", "ADSFDF", 10000)

        if p:getJob() == 'tattooSud' then
            local pedscoords = {
                {x=320.53244018555, y=181.13461303711,  z=97.349449157715,  h=171.33345031738},
                {x=316.49572753906, y=182.59222412109,  z=97.349456787109,  h=166.21144104004},
                {x=-2137.8527832031, y=-473.05581665039,  z=3.2003273963928,   h=201.84226989746}, --event plage

                {x=316.42022705078, y=182.44577026367,  z=97.349487304688,  h=175.12403869629},
                {x=312.47360229492, y=183.84725952148,  z=97.349472045898,  h=188.06831359863},
                {x=312.42922973633, y=180.31547546387,  z=97.349464416504,  h=344.24670410156},
                {x=316.89916992188, y=178.46746826172,  z=97.349472045898,  h=338.32098388672},
                {x=320.96435546875, y=177.05744934082,  z=97.349472045898,  h=350.12808227539},

                {x=5154.3271484375, y=-5122.8505859375,  z=1.4042932987213,  h=350.12808227539},

                --{x=312.66751098633, y=184.11888122559,  z=97.34944152832,   h=168.90376281738}
            }
            local closdist, idtabl = GetClosestDistanceToPedTableIDSolo(PlayerPedId(), pedscoords)
            Wait(50)
            TattooPNJ = entity:CreatePed(model, vector3(pedscoords[idtabl].x, pedscoords[idtabl].y, pedscoords[idtabl].z ), pedscoords[idtabl].h)
        else
            TattooPNJ = entity:CreatePed(model, vector3( -294.60705566406, 6200.3481445313, 30.562995910645 ), 42.8174)
        end
    
        SetEntityAsMissionEntity(TattooPNJ.id, 1, 1)
        -- remove the shirt if the TattooPNJ is male
        SetPedComponentVariation(TattooPNJ.id, 11, 15, 0, 0)
        -- remove the pants
        if isMale then
            SetPedComponentVariation(TattooPNJ.id, 4, 21, 0, 0)
        else
            SetPedComponentVariation(TattooPNJ.id, 4, 15, 0, 0)
        end
        -- remove the shoes
        if isMale then
            SetPedComponentVariation(TattooPNJ.id, 6, 34, 0, 0)
        else
            SetPedComponentVariation(TattooPNJ.id, 6, 35, 0, 0)
        end
        -- set the torso to have full arms
        SetPedComponentVariation(TattooPNJ.id, 3, 15, 0, 0)

        -- set the shirt overlay to have none
        SetPedComponentVariation(TattooPNJ.id, 8, 15, 0, 0)

        SetCanAttackFriendly(TattooPNJ.id, false, false)
        FreezeEntityPosition(TattooPNJ.id, true)
        SetEntityInvincible(TattooPNJ.id, true)
        SetBlockingOfNonTemporaryEvents(TattooPNJ.id, true)

        -- create tattoos list by zone
        for i = 1, #tattoos, 1 do
            if tattoos[i].Zone == "ZONE_HEAD" then
                if isMale and tattoos[i].HashNameMale then
                    table.insert(TattooZone.ZONE_HEAD, tattoos[i])
                elseif not isMale and tattoos[i].HashNameFemale ~= "" then

                    table.insert(TattooZone.ZONE_HEAD, tattoos[i])
                end
            elseif tattoos[i].Zone == "ZONE_LEFT_ARM" then
                if isMale and tattoos[i].HashNameMale ~= "" then
                    table.insert(TattooZone.ZONE_LEFT_ARM, tattoos[i])
                elseif not isMale and tattoos[i].HashNameFemale ~= "" then

                    table.insert(TattooZone.ZONE_LEFT_ARM, tattoos[i])
                end
            elseif tattoos[i].Zone == "ZONE_RIGHT_ARM" then
                if isMale and tattoos[i].HashNameMale ~= "" then
                    table.insert(TattooZone.ZONE_RIGHT_ARM, tattoos[i])
                elseif not isMale and tattoos[i].HashNameFemale ~= "" then

                    table.insert(TattooZone.ZONE_RIGHT_ARM, tattoos[i])
                end
            elseif tattoos[i].Zone == "ZONE_LEFT_LEG" then
                if isMale and tattoos[i].HashNameMale ~= "" then
                    table.insert(TattooZone.ZONE_LEFT_LEG, tattoos[i])
                elseif not isMale and tattoos[i].HashNameFemale ~= "" then

                    table.insert(TattooZone.ZONE_LEFT_LEG, tattoos[i])
                end
            elseif tattoos[i].Zone == "ZONE_RIGHT_LEG" then
                if isMale and tattoos[i].HashNameMale ~= "" then
                    table.insert(TattooZone.ZONE_RIGHT_LEG, tattoos[i])
                elseif not isMale and tattoos[i].HashNameFemale ~= "" then
                    table.insert(TattooZone.ZONE_RIGHT_LEG, tattoos[i])
                end
            elseif tattoos[i].Zone == "ZONE_TORSO" then
                if isMale then
                    if tattoos[i].HashNameMale ~= "" then
                        table.insert(TattooZone.ZONE_TORSO, tattoos[i])
                    end
                elseif not isMale then
                    if tattoos[i].HashNameFemale ~= "" then
                        table.insert(TattooZone.ZONE_TORSO, tattoos[i])
                    end
                end
            end
        end

        Citizen.CreateThread(function()
            while open do
                Citizen.Wait(10000)
                if not DoesEntityExist(PlayerPedId()) then
                    -- Player crashed, delete NPC
                    if TattooPNJ ~= nil then
                        DeleteEntity(TattooPNJ)
                        TattooPNJ = nil
                    end
                end
            end
        end)

        CreateThread(function()
            while open do
                RageUI.IsVisible(tattoos_menu, function()
                    for k, v in pairs(TattooZone) do
                        RageUI.Button(translate[k], nil, {}, true, {
                            onSelected = function()
                                index = v
                            end
                        }, tattoos_zone)
                    end
                end)
                RageUI.IsVisible(tattoos_zone, function()
                    for i = 1, #index, 1 do
                        local label = nil
                        label = GetLabelText(index[i].Name)
                        if label == "NULL" then
                            label = "Tatouage " .. i
                        end
                        RageUI.Button(label, nil, { RightLabel = "~g~" .. Round(index[i].Price) .. "$" }, true,
                            {
                                onActive = function()

                                    if isMale then

                                        if GetHashKey(index[i].HashNameMale) ~= last then
                                            last = GetHashKey(index[i].HashNameMale)
                                            ClearPedDecorations(TattooPNJ.id)
                                            SetPedComponentVariation(TattooPNJ.id, 8, 15, 0, 2)
                                            SetPedComponentVariation(TattooPNJ.id, 3, 15, 0, 2)
                                            SetPedComponentVariation(TattooPNJ.id, 11, 15, 0, 2)
                                            SetPedComponentVariation(TattooPNJ.id, 4, 21, 0, 2)
                                            AddPedDecorationFromHashes(TattooPNJ.id, GetHashKey(index[i].Collection)
                                                , GetHashKey(index[i].HashNameMale))
                                        end
                                    else
                                        if GetHashKey(index[i].HashNameFemale) ~= last then
                                            last = GetHashKey(index[i].HashNameMale)
                                            ClearPedDecorations(TattooPNJ.id)
                                            SetPedComponentVariation(TattooPNJ.id, 8, 34, 0, 0)
                                            SetPedComponentVariation(TattooPNJ.id, 3, 15, 0, 0)
                                            SetPedComponentVariation(TattooPNJ.id, 11, 15, 0, 0)
                                            SetPedComponentVariation(TattooPNJ.id, 4, 15, 0, 0)
                                            AddPedDecorationFromHashes(TattooPNJ.id, GetHashKey(index[i].Collection)
                                                , GetHashKey(index[i].HashNameFemale))
                                        end
                                    end

                                end,
                                onSelected = function()
                                    indexx = i
                                end
                            }, buy_or_show)
                    end
                end)

                RageUI.IsVisible(buy_or_show, function()
                    i = indexx
                    RageUI.Button("Acheter le tatouage", nil, { RightLabel = "~g~" .. Round(index[i].Price) .. "$" }, true,
                        {
                            onSelected = function()
                                if isMale then
                                    if index[i].HashNameMale ~= "" then
                                        GetAllPlayersInAreaWithDatatattooSudSolo()
                                        open = false
                                        RageUI.CloseAll()
                                        AddTattooMaleSolo(index[i].Collection, index[i].HashNameMale, Round(index[i].Price))
                                    end
                                else
                                    if index[i].HashNameFemale ~= "" then
                                        GetAllPlayersInAreaWithDatatattooSudSolo()
                                        open = false
                                        RageUI.CloseAll()
                                        AddTattooFemaleSolo(index[i].Collection, index[i].HashNameFemale, Round(index[i].Price))
                                    end
                                end
                            end
                        })
                    RageUI.Button("Montrer le tatouage", nil, {}, true,
                    {
                        onSelected = function()
                            local targets = GetAllPlayersInArea(p:pos(), 25.0)
                            -- create a list of server ids to send to the server
                            local serverIds = {}
                            for i = 1, #targets do
                                table.insert(serverIds, GetPlayerServerId(targets[i]))
                            end
                            if isMale then
                                if index[i].HashNameMale ~= "" then
                                    ClearPedDecorations(TattooPNJ.id)
                                    SetPedComponentVariation(TattooPNJ.id, 8, 15, 0, 2)
                                    SetPedComponentVariation(TattooPNJ.id, 3, 15, 0, 2)
                                    SetPedComponentVariation(TattooPNJ.id, 11, 15, 0, 2)
                                    SetPedComponentVariation(TattooPNJ.id, 4, 21, 0, 2)
                                    TriggerServerEvent("tattoos:update", token, PedToNet(TattooPNJ.id), index[i].Collection, index[i].HashNameMale, serverIds)
                                end
                            else
                                if index[i].HashNameFemale ~= "" then
                                    ClearPedDecorations(TattooPNJ.id)
                                    SetPedComponentVariation(TattooPNJ.id, 8, 34, 0, 0)
                                    SetPedComponentVariation(TattooPNJ.id, 3, 15, 0, 0)
                                    SetPedComponentVariation(TattooPNJ.id, 11, 15, 0, 0)
                                    SetPedComponentVariation(TattooPNJ.id, 4, 15, 0, 0)
                                    TriggerServerEvent("tattoos:update", token, PedToNet(TattooPNJ.id), index[i].Collection, index[i].HashNameMale, serverIds)
                                end
                            end
                        end
                    })
                end)
                Wait(1)
            end
        end)
    end
end

local add_tattoo = RageUI.CreateMenu("", "Salon de tatouage", 0.0, 0.0, "shopui_title_tattoos4",
    "shopui_title_tattoos4")
local open2 = false
add_tattoo.Closed = function()
    open2 = false
    RageUI.Visible(add_tattoo, false)
    DeleteEntity(TattooPNJ.id)
    TattooPNJ = nil
end

function AddTattooMaleSolo(collection, hashName, price)
    if open2 then
        open2 = false
        RageUI.Visible(add_tattoo, false)
    else
        open2 = true
        RageUI.Visible(add_tattoo, true)
        CreateThread(function()
            while open2 do
                RageUI.IsVisible(add_tattoo, function()
                    if plys then
                        for k, v in pairs(plys) do
                            if v.isMale then
                                RageUI.Button("~o~" .. v.player .. "~s~ | ~o~" .. v.name, nil, {}, true, {
                                    onSelected = function()
                                        if p:pay(tonumber(price)) then 
                                            TriggerServerEvent('core:addTattooToPlayer', token, v.player,
                                                { Collection = collection, HashName = hashName })
                                            else
                                                exports['vNotif']:createNotification({
                                                    type = 'ROUGE',
                                                    content = "~c Vous n'avez ~s pas assez d'argent"
                                                })
                                            end
                                        open2 = false
                                        DeleteEntity(TattooPNJ.id)
                                        TattooPNJ = nil
                                        RageUI.CloseAll()
                                    end
                                }, nil)
                            end
                        end
                    else
                        RageUI.Button("Aucun joueur dans la zone", nil, {}, true, {})
                    end
                end)
                Wait(1)
            end
        end)
    end
end

function AddTattooFemaleSolo(collection, hashName, price)
    if open2 then
        open2 = false
        RageUI.Visible(add_tattoo, false)
    else
        open2 = true
        RageUI.Visible(add_tattoo, true)
        CreateThread(function()
            while open2 do
                RageUI.IsVisible(add_tattoo, function()
                    if plys then
                        for k, v in pairs(plys) do
                            if not v.isMale then
                                RageUI.Button("~o~" .. v.player .. "~s~ | ~o~" .. v.name, nil, {}, true, {
                                    onSelected = function()
                                        if p:pay(tonumber(price)) then 
                                            TriggerServerEvent('core:addTattooToPlayer', token, v.player,
                                                { Collection = collection, HashName = hashName })
                                        else
                                            exports['vNotif']:createNotification({
                                                type = 'ROUGE',
                                                content = "~c Vous n'avez ~s pas assez d'argent"
                                            })
                                        end
                                        open2 = false
                                        DeleteEntity(TattooPNJ.id)
                                        TattooPNJ = nil
                                        RageUI.CloseAll()
                                    end
                                }, nil)
                            end
                        end
                    else
                        RageUI.Button("Aucun joueur dans la zone", nil, {}, true, {})
                    end
                end)
                Wait(1)
            end
        end)
    end
end

RegisterNetEvent('core:addTattooToPlayer')
AddEventHandler('core:addTattooToPlayer', function(data)
    if data then
        if data.Collection ~= "" and data.HashName ~= "" then
            AddPedDecorationFromHashes(PlayerPedId(), GetHashKey(data.Collection), GetHashKey(data.HashName))
        end
    end
end)

RegisterNetEvent('tattoos:update')
AddEventHandler('tattoos:update', function(ped_net, collection, hashName)
    if ped_net then
        if collection ~= "" and hashName ~= "" then
            local ped_ent = NetworkGetEntityFromNetworkId(ped_net)
            AddPedDecorationFromHashes(ped_ent, GetHashKey(collection), GetHashKey(hashName))
        end
    end
end)

RegisterNetEvent('core:updateTattoo')
AddEventHandler('core:updateTattoo', function(tattoos)
    ClearPedDecorations(p:ped())
    for i = 1, #tattoos, 1 do
        if tattoos[i] ~= nil then
            AddPedDecorationFromHashes(p:ped(), GetHashKey(tattoos[i].Collection),
                GetHashKey(tattoos[i].HashName))
        end
    end
end)

function GetAllPlayersInAreaWithDatatattooSudSolo()
    local players = GetAllPlayersInArea(p:pos(), 5.0)
    plys = {}
    
    for k, v in pairs(players) do
        if v == PlayerId() then
            local src = GetPlayerServerId(v)
            local name = TriggerServerCallback("core:GetPlayerAreaName", src)

            -- local isMale = p:getSex()

    --[[         if p:getSex() == "M" then
                local isMale = true
            else
                local isMale = false
            end ]]

    --[[         local sex

            if p:skin(players).sex == 0 then
                sex = true
            elseif p:skin(players).sex == 1 then
                sex = false
            end
            ]]


            local isMale = TriggerServerCallback("core:GetPlayerAreaSex", src)

            if isMale == "M" then

                table.insert(plys, {
                    player = src,
                    name = name,
                    isMale = true
                })
                
            else

                table.insert(plys, {
                    player = src,
                    name = name,
                    isMale = false
                })
            end
        end
    end
end


local posTattoo = {
        vector4(324.56845092773, 180.16107177734, 102.58, 258.7401),
        vector4(-294.60705566406, 6200.3481445313, 30.462995910645, 42.8174),
        vector4(5153.0703125, -5123.8017578125, 0.9042236804962, 42.8174),
        vector4(-1154.7370605469, -1428.2138671875, 3.4559540748596, 5.8383603096008),

    -- dev 
    --vector3(323.78192138672, 179.767578125, 102.58670043945)
}

function LoadTattooSolo()
    for k, v in pairs(posTattoo) do
        tattoopeds[k] = entity:CreatePedLocal("u_m_y_tattoo_01", v.xyz, v.w)
        tattoopeds[k]:setFreeze(true)
        SetEntityInvincible(tattoopeds[k].id, true)
        SetEntityAsMissionEntity(tattoopeds[k].id, 0, 0)
        SetBlockingOfNonTemporaryEvents(tattoopeds[k].id, true)
        --TaskStartScenarioInPlace(tattoopeds[k].id, "WORLD_HUMAN_AA_COFFEE", -1, true)
        zone.addZone(
            "posTattoo" .. k,
            v.xyz + vector3(0.0, 0.0, 2.0),
            "Appuyer sur ~INPUT_CONTEXT~ pour interagir",
            function()
                chooseMenuSolo()
            end,
            false, -- Avoir un marker ou non
            -1, -- Id / type du marker
            0.6, -- La taille
            { 0, 0, 0 }, -- RGB
            0, -- Alpha
            2.5,
            true,
            "bulleCatalogue"
        )
    end
end

function unloadTattooSolo()
    for k, v in pairs(posTattoo) do
        zone.removeZone("posTattoo" .. k)
        Bulle.remove("posTattoo" .. k)
    end
    for k, v in pairs(tattoopeds) do
        DeleteEntity(tattoopeds[k].id)
    end
end

local alreadyLoaded = false
CreateThread(function()
    local inDuty
    Wait(1000)
    while true do
        inDuty = (GlobalState['serviceCount_tattooNord'] or 0) + (GlobalState['serviceCount_tattooSud'] or 0) + (GlobalState['serviceCount_tattooCayo'] or 0) + (GlobalState['serviceCount_amerink'] or 0)
        if inDuty == 0 then 
            if not alreadyLoaded then
                LoadTattooSolo()
                alreadyLoaded = true
            end
        else
            if alreadyLoaded then
                unloadTattooSolo()
                alreadyLoaded = false
            end
        end
        Wait(20500)
    end
end)