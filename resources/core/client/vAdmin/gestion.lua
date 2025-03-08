local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

RegisterCommand("gestionstock", function()
    if not p then return end
    if p:getPermission() >= 4 then
        OpenGestStock()
    end
end)

local idInstructionalButtons = {
    [1] = generateUniqueID(),
    [2] = generateUniqueID()
}

local open = false
local idToChange = 0
local SelectedCar
local previewCar

local main = RageUI.CreateMenu("", "Menu de gestion des stocks", 0.0, 0.0, "vision", "menu_gestion_item")
local Vetements = RageUI.CreateSubMenu(main, "", "Menu de gestion des stocks", 0.0, 0.0, "vision", "menu_gestion_item")
local Accessoires = RageUI.CreateSubMenu(main, "", "Menu de gestion des stocks", 0.0, 0.0, "vision", "menu_gestion_item")
local Masques = RageUI.CreateSubMenu(main, "", "Menu de gestion des stocks", 0.0, 0.0, "vision", "menu_gestion_item")
local Vehicules = RageUI.CreateSubMenu(main, "", "Menu de gestion des stocks", 0.0, 0.0, "vision", "menu_gestion_item")
local Tattouages = RageUI.CreateSubMenu(main, "", "Menu de gestion des stocks", 0.0, 0.0, "vision", "menu_gestion_item")
local TattouagesSubv = RageUI.CreateSubMenu(Tattouages, "", "Menu de gestion des stocks", 0.0, 0.0, "vision", "menu_gestion_item")
local VehiculesInside = RageUI.CreateSubMenu(Vehicules, "", "Menu de gestion des stocks", 0.0, 0.0, "vision", "menu_gestion_item")
local VehiculesInsideSelect = RageUI.CreateSubMenu(VehiculesInside, "", "Menu de gestion des stocks", 0.0, 0.0, "vision", "menu_gestion_item")
local liveries = RageUI.CreateSubMenu(VehiculesInsideSelect, "", "Action disponible", 0.0, 0.0, "vision", "menu_gestion_item")
local stickers = RageUI.CreateSubMenu(VehiculesInsideSelect, "", "Action disponible", 0.0, 0.0, "vision", "menu_gestion_item")
local extra = RageUI.CreateSubMenu(VehiculesInsideSelect, "", "Action disponible", 0.0, 0.0, "vision", "menu_gestion_item")

main:DisplayInstructionalButton(false)
Vetements:DisplayInstructionalButton(false)
Accessoires:DisplayInstructionalButton(false)
Masques:DisplayInstructionalButton(false)
Vehicules:DisplayInstructionalButton(false)
Tattouages:DisplayInstructionalButton(false)
TattouagesSubv:DisplayInstructionalButton(false)
VehiculesInside:DisplayInstructionalButton(false)
VehiculesInsideSelect:DisplayInstructionalButton(false)
liveries:DisplayInstructionalButton(false)
stickers:DisplayInstructionalButton(false)
extra:DisplayInstructionalButton(false)

local CurrentClassVeh = 1

local IdListRageUI = {
    ["Hauts"] = {},
    ["hautindex"] = 1,
    ["T-Shirt"] = {},
    ["shirtindex"] = 1,
    ["Bras"] = {},
    ["brasindex"] = 1,
    ["Pantalon"] = {},
    ["pantalonindex"] = 1,
    ["Chaussures"] = {},
    ["Chaussuresindex"] = 1,
    ["Gilet Par Balles"] = {},
    ["gpbindex"] = 1,
    ["Sac"] = {},
    ["sacindex"] = 1,
    ["Montres"] = {},
    ["montreindex"] = 1,
    ["Lunettes"] = {},
    ["lunettesindex"] = 1,
    ["Casques"] = {},
    ["casqueindex"] = 1,
    ["Oreilles"] = {},
    ["Oreillesindex"] = 1,
    ["Bracelets"] = {},
    ["Braceletsindex"] = 1,
    ["Chaines"] = {},
    ["Chainesindex"] = 1,
    ["Calques"] = {},
    ["Calquesindex"] = 1,
    ["Masques"] = {},
    ["Masquesindex"] = 1,
}

local CurrentSelection = {
    ["Hauts"] = {id = 0, vars = 0},
    ["T-Shirt"] = {id = 0, vars = 0},
    ["Bras"] = {id = 0, vars = 0},
    ["Pantalon"] = {id = 0, vars = 0},
    ["Chaussures"] = {id = 0, vars = 0},
    ["Gilet Par Balles"] = {id = 0, vars = 0},
    ["Sac"] = {id = 0, vars = 0},
    ["Montres"] = {id = 0, vars = 0},
    ["Lunettes"] = {id = 0, vars = 0},
    ["Casques"] = {id = 0, vars = 0},
    ["Oreilles"] = {id = 0, vars = 0},
    ["Bracelets"] = {id = 0, vars = 0},
    ["Chaines"] = {id = 0, vars = 0},
    ["Calques"] = {id = 0, vars = 0},
    ["Masques"] = {id = 0, vars = 0},
}

local Habits = {
    ["Hauts"] = {},
    ["T-Shirt"] = {},
    ["Bras"] = {},
    ["Pantalon"] = {},
    ["Chaussures"] = {},
    ["Gilet Par Balles"] = {},
    ["Sac"] = {},
    ["Montres"] = {},
    ["Lunettes"] = {},
    ["Casques"] = {},
    ["Oreilles"] = {},
    ["Bracelets"] = {},
    ["Chaines"] = {},
    ["Calques"] = {},
    ["Masques"] = {},
}

local ConfigVetements = {
    {
        name = "Hauts",
        index = "hautindex",
        item = "tshirt",
        text = "/addPermaItem IDJoueur tshirt %s %s IDBras IDtshirt2 IDCouleurtshirt2",
        category = "Vetements",
        id = 11,
    },
    {
        name = "T-Shirt",
        index = "shirtindex",
        item = "tshirt",
        text = "/addPermaItem IDJoueur tshirt2 %s %s IDBras",
        category = "Vetements",
        id = 8,
    },
    {
        name = "Bras",
        index = "brasindex",
        category = "Vetements",
        id = 3,
    },
    {
        name = "Pantalon",
        index = "pantalonindex",
        item = "pant",
        text = "/addPermaItem IDJoueur pant %s %s",
        category = "Vetements",
        id = 4,
    },
    {
        name = "Chaussures",
        index = "Chaussuresindex",
        item = "feet",
        text = "/addPermaItem IDJoueur feet %s %s",
        category = "Vetements",
        id = 6,
    },
    {
        name = "Gilet Par Balles",
        text = "/addPermaItem IDJoueur bague %s %s",
        item = "bague",
        index = "gpbindex",
        category = "Vetements",
        id = 9,
    },
    {
        name = "Sac",
        index = "sacindex",
        item = "access",
        text = "/addPermaItem IDJoueur sac %s %s",
        category = "Vetements",
        id = 5,
    },
    {
        name = "Chaines",
        index = "Chainesindex",
        item = "collier",
        text = "/addPermaItem IDJoueur collier %s %s",
        category = "Vetements",
        id = 7,
    },
    {
        name = "Calques",
        index = "Calquesindex",
        category = "Vetements",
        id = 10,
    },

    --

    {
        name = "Montres",
        index = "montreindex",
        item = "montre",
        text = "/addPermaItem IDJoueur montre %s %s",
        category = "Accessoires",
        type = "Prop",
        id = 6,
    },
    {
        name = "Lunettes",
        index = "lunettesindex",
        item = "glasses",
        text = "/addPermaItem IDJoueur glasses %s %s",
        category = "Accessoires",
        type = "Prop",
        id = 1,
    },
    {
        name = "Casques",
        index = "casqueindex",
        item = "hat",
        text = "/addPermaItem IDJoueur hat %s %s",
        category = "Accessoires",
        type = "Prop",
        id = 0,
    },
    {
        name = "Oreilles",
        index = "Oreillesindex",
        item = "bouclesoreilles",
        text = "/addPermaItem IDJoueur bouclesoreilles %s %s",
        category = "Accessoires",
        type = "Prop",
        id = 2,
    },
    {
        name = "Bracelets",
        index = "Braceletsindex",
        item = "bracelet",
        text = "/addPermaItem IDJoueur bracelet %s %s",
        category = "Accessoires",
        type = "Prop",
        id = 7,
    },

    --

    {
        name = "Masques",
        index = "Masquesindex",
        item = "mask",
        text = "/addPermaItem IDJoueur mask %s %s",
        category = "Masques",
        id = 1,
    },

}


-- 5 eme category tattouages

function LoadVetements()
    for k, v in pairs(ConfigVetements) do
        if v.type and v.type == "Prop" then
            for i = 0, GetNumberOfPedPropDrawableVariations(PlayerPedId(), v.id) - 1 do
                Habits[v.name][i] = { id = i }
                table.insert(IdListRageUI[v.name], i)
                for z = 1, GetNumberOfPedPropTextureVariations(PlayerPedId(), v.id, i) - 1 do
                    if not Habits[v.name][i].vars then
                        Habits[v.name][i].vars = {}
                    end
                    table.insert(Habits[v.name][i].vars, z)
                end
            end
        else
            for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), v.id) - 1 do
                Habits[v.name][i] = { id = i }
                table.insert(IdListRageUI[v.name], i)
                for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), v.id, i) - 1 do
                    if not Habits[v.name][i].vars then
                        Habits[v.name][i].vars = {}
                    end
                    table.insert(Habits[v.name][i].vars, z)
                end
            end
        end
    end
end

main.Closed = function()
    local playerSkin = p:skin()
    ApplySkin(playerSkin)
    instructionalButtons[idInstructionalButtons[1]] = {}
    open = false
end

VehiculesInsideSelect.Closed = function()
    UpdateOrCreateClone()
    HasCreatedCar = false
end


function getSkin(id, prop)
    local playerPed = PlayerPedId()
    if prop then
        return { [1] = GetPedPropIndex(playerPed, id), [2] = GetPedPropTextureIndex(playerPed, id) }
    else
        return { [1] = GetPedDrawableVariation(playerPed, id), [2] = GetPedTextureVariation(playerPed, id) }
    end
end

function getTenue()
    local playerPed = PlayerPedId()
                        
    local clothesComponents = {
        ["tshirt"] = { [1] = nil, [2] = nil, id = 8 },
        ["torso"] = { [1] = nil, [2] = nil, id = 11 },
        ["decals"] = { [1] = nil, [2] = nil, id = 10 },
        ["arms"] = { [1] = nil, [2] = nil, id = 3 },
        ["pants"] = { [1] = nil, [2] = nil, id = 4 },
        ["shoes"] = { [1] = nil, [2] = nil, id = 6 },
        ["bags"] = { [1] = nil, [2] = nil, id = 5 },
        ["chain"] = { [1] = nil, [2] = nil, id = 7 },
        ["helmet"] = { [1] = nil, [2] = nil, id = 0, prop = true },
        ["ears"] = { [1] = nil, [2] = nil, id = 2, prop = true },
        ["mask"] = { [1] = nil, [2] = nil, id = 1 },
        ["glasses"] = { [1] = nil, [2] = nil, id = 1, prop = true },
        ["bproof"] = { [1] = nil, [2] = nil, id = 9 }
    }
    
    for k, component in pairs(clothesComponents) do
        clothesComponents[k] = getSkin(component.id, component.prop)                   
    end

    local tenue = {
        ['tshirt_1'] = clothesComponents['tshirt'][1],
        ['tshirt_2'] = clothesComponents['tshirt'][2],
        ['torso_1'] = clothesComponents['torso'][1],
        ['torso_2'] = clothesComponents['torso'][2],
        ['decals_1'] = clothesComponents['decals'][1],
        ['decals_2'] = clothesComponents['decals'][2],
        ['arms'] = clothesComponents['arms'][1],
        ['arms_2'] = clothesComponents['arms'][2],
        ['pants_1'] = clothesComponents['pants'][1],
        ['pants_2'] = clothesComponents['pants'][2],
        ['shoes_1'] = clothesComponents['shoes'][1],
        ['shoes_2'] = clothesComponents['shoes'][2],
        ['bags_1'] = clothesComponents['bags'][1],
        ['bags_2'] = clothesComponents['bags'][2],
        ['chain_1'] = clothesComponents['chain'][1],
        ['chain_2'] = clothesComponents['chain'][2],
        ['helmet_1'] = clothesComponents['helmet'][1],
        ['helmet_2'] = clothesComponents['helmet'][2],
        ['ears_1'] = clothesComponents['ears'][1],
        ['ears_2'] = clothesComponents['ears'][2],
        ['mask_1'] = clothesComponents['mask'][1],
        ['mask_2'] = clothesComponents['mask'][2],
        ['glasses_1'] = clothesComponents['glasses'][1],
        ['glasses_2'] = clothesComponents['glasses'][2],
        ['bproof_1'] = clothesComponents['bproof'][1],
        ['bproof_2'] = clothesComponents['bproof'][2],
    }

    return tenue
end

function OpenGestStock()
    LoadVetements()
    if open then
        open = false
        instructionalButtons[idInstructionalButtons[1]] = {}
        RageUI.CloseAll()
        return
    else
        open = true
        RageUI.Visible(main, true)
        Citizen.CreateThread(function()
            while open do
                Wait(1)
                RageUI.IsVisible(main, function()
                    RageUI.Button("Vêtements", nil, { RightLabel = ">" }, true, {}, Vetements)
                    RageUI.Button("Accessoires", nil, { RightLabel = ">" }, true, {}, Accessoires)
                    RageUI.Button("Masques", nil, { RightLabel = ">" }, true, {}, Masques)
                    RageUI.Button("Tattoo", nil, { RightLabel = ">" }, true, {}, Tattouages)
                    RageUI.Button("Véhicules", nil, { RightLabel = ">" }, true, {}, Vehicules)
                    RageUI.Button("Crée une tenue", nil, { RightLabel = ">" }, true, {
                        onSelected = function()
                            local tenue = getTenue()

                            TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1, { premium = true, renamed = "Tenue N°"..tenue['tshirt_1'], data = tenue })
                        end})
                    RageUI.Button("Copier le code la tenue", nil, { RightLabel = ">" }, true, {
                        onSelected = function()
                            local tenue = getTenue()

                            local tenueData = {
                                id = "ID_HERE",
                                varHaut = tenue['torso_2'],
                                sac = tenue['bags_1'],
                                varSousHaut = tenue['tshirt_2'],
                                chaussures = tenue['shoes_1'],
                                gpb = tenue['bproof_1'],
                                chaine = tenue['chain_1'],
                                haut = tenue['torso_1'],
                                varDecals = tenue['decals_2'],
                                varChaine = tenue['chain_2'],
                                varBras = tenue['arms_2'],
                                bras = tenue['arms'],
                                varChaussures = tenue['shoes_2'],
                                varSac = tenue['bags_2'],
                                varGpb = tenue['bproof_2'],
                                varPantalon = tenue['pants_2'],
                                sousHaut = tenue['tshirt_1'],
                                decals = tenue['decals_1'],
                                pantalon = tenue['pants_1'],
                            }

                            local tenueJSON = json.encode(tenueData)

                            TriggerEvent("addToCopy", tenueJSON)
                        end})
                    end)
                RageUI.IsVisible(Tattouages, function()
                    RageUI.Button("Tête", false, { RightLabel = ">" }, true, {
                        onSelected = function()
                            SelectedTattooCat = "ZONE_HEAD"
                        end
                    }, TattouagesSubv)
                    RageUI.Button("Torse/Dos", false, { RightLabel = ">" }, true, {
                        onSelected = function()
                            SelectedTattooCat = "ZONE_TORSO"
                        end
                    }, TattouagesSubv)
                    RageUI.Button("Bras droit", false, { RightLabel = ">" }, true, {
                        onSelected = function()
                            SelectedTattooCat = "ZONE_RIGHT_ARM"
                        end
                    }, TattouagesSubv)
                    RageUI.Button("Bras gauche", false, { RightLabel = ">" }, true, {
                        onSelected = function()
                            SelectedTattooCat = "ZONE_LEFT_ARM"
                        end
                    }, TattouagesSubv)
                    RageUI.Button("Jambe gauche", false, { RightLabel = ">" }, true, {
                        onSelected = function()
                            SelectedTattooCat = "ZONE_LEFT_LEG"
                        end
                    }, TattouagesSubv)
                    RageUI.Button("Jambe droite", false, { RightLabel = ">" }, true, {
                        onSelected = function()
                            SelectedTattooCat = "ZONE_RIGHT_LEG"
                        end
                    }, TattouagesSubv)
                end)
                RageUI.IsVisible(TattouagesSubv, function()
                    for k, v in pairs(GetTattoos()) do
                        if v.Zone == SelectedTattooCat then
                            RageUI.Button(v.LocalizedName,
                                "Numéro tattoo : " .. k .. "\nCommande Give : /addTattoo IDJoueur " .. k,
                                { RightLabel = ">" }, true, {
                                    onSelected = function()
                                    end,
                                    onActive = function()
                                        ClearPedDecorations(PlayerPedId())
                                        if GetEntityModel(PlayerPedId()) == "mp_m_freemode_01" then
                                            AddPedDecorationFromHashes(PlayerPedId(), GetHashKey(v.Collection),
                                                GetHashKey(v.HashNameMale))
                                        elseif GetEntityModel(PlayerPedId()) == "mp_f_freemode_01" then
                                            AddPedDecorationFromHashes(PlayerPedId(), GetHashKey(v.Collection),
                                                GetHashKey(v.HashNameFemale))
                                        end
                                    end,
                                })
                        end
                    end
                end)
                RageUI.IsVisible(Vehicules, function()
                    for cat = 0, 22, 1 do
                        RageUI.Button(GetLabelText("VEH_CLASS_" .. cat), nil, { RightLabel = ">" }, true, {
                            onSelected = function()
                                CurrentClassVeh = cat
                            end
                        }, VehiculesInside)
                    end
                end)
                RageUI.IsVisible(VehiculesInside, function()
                    for k, v in ipairs(ConfigStock.Vehicles[CurrentClassVeh + 1]) do
                        RageUI.Button(GetLabelText(v) == "NULL" and v or GetLabelText(v), nil, { RightLabel = ">" }, true,
                            {
                                onSelected = function()
                                    SelectedCar = v
                                end
                            }, VehiculesInsideSelect)
                    end
                end)
                RageUI.IsVisible(VehiculesInsideSelect, function()
                    if SelectedCar then
                        if IsModelInCdimage(GetHashKey(SelectedCar)) then
                            if not HasCreatedCar then
                                HasCreatedCar = true
                                RequestModel(GetHashKey(SelectedCar))
                                while not HasModelLoaded(GetHashKey(SelectedCar)) do Wait(1) end
                                UpdateOrCreateClone(SelectedCar)
                            end
                            RageUI.Button("Motifs (Liveries)", false, { RightLabel = ">" }, true, {
                                onSelected = function()
                                end
                            }, liveries)
                            RageUI.Button("Stickers", false, { RightLabel = ">" }, true, {
                                onSelected = function()
                                end
                            }, stickers)
                            RageUI.Button("Extras", false, { RightLabel = ">" }, true, {
                                onSelected = function()
                                end
                            }, extra)
                        else
                            RageUI.Button("Le véhicule n'existe pas", nil, {}, true, {})
                        end
                    end
                end)
                RageUI.IsVisible(liveries, function()
                    if GetNumVehicleMods(previewCar, 48) == 0 then
                        RageUI.Separator("Pas de modification disponible")
                    else
                        for i = 1, GetNumVehicleMods(previewCar, 48) do
                            local name = GetLabelText(GetModTextLabel(previewCar, 48, i))
                            if name == "NULL" then
                                name = "Original"
                            end
                            if index == i then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end

                            RageUI.Button(name,
                                "Entrez la commande \"/addcarcustom IDJoueur " .. SelectedCar .. " " .. i .. "\"",
                                { RightBadge = Rightbadge }, true, {
                                    onActive = function()
                                        SetVehicleMod(previewCar, 48, i, 0)
                                    end,
                                    onSelected = function()
                                        index = i
                                        SetVehicleMod(previewCar, 48, i, 0)
                                    end
                                }, nil)
                        end
                    end
                end)
                RageUI.IsVisible(stickers, function()
                    if GetVehicleLiveryCount(previewCar) == -1 then
                        RageUI.Separator("Pas de modification disponible")
                    else
                        for i = 1, GetVehicleLiveryCount(previewCar) do
                            local name = GetLabelText(GetLiveryName(previewCar, i))
                            if name == "NULL" then
                                name = "Original"
                            end
                            if index == i then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end

                            RageUI.Button(name, false, { RightBadge = Rightbadge }, true, {
                                onActive = function()
                                    SetVehicleLivery(previewCar, i)
                                end,
                                onSelected = function()
                                    index = i
                                    SetVehicleLivery(previewCar, i)
                                end
                            }, nil)
                        end
                    end
                end)
                RageUI.IsVisible(extra, function()
                    local availableExtras = {}
                    extrasExist = false
                    for extra = 0, 20 do
                        if DoesExtraExist(previewCar, extra) then
                            availableExtras[extra] = extra
                            extrasExist = true
                        end
                    end

                    if not extrasExist then
                        RageUI.Separator("Pas de modification disponible")
                    else
                        for i in pairs(availableExtras) do
                            name = 'ORIGINAL'
                            if index == i then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end
                            RageUI.Button(name, false, { RightBadge = Rightbadge }, true, {

                                onSelected = function()
                                    if IsVehicleExtraTurnedOn(previewCar, i) then
                                        SetVehicleExtra(previewCar, i, 1)
                                    else
                                        index = i
                                        SetVehicleExtra(previewCar, i, 0)
                                    end
                                end
                            }, nil)
                        end
                    end
                end)
                RageUI.IsVisible(Vetements, function()
                    for k, v in pairs(ConfigVetements) do
                        if v.category == "Vetements" then
                            local command = ""
                            if v.text and v.text ~= "" then
                                command = "\nCommande Give : "..string.format(v.text, IdListRageUI[v.name][IdListRageUI[v.index]], CurrentSelection[v.name].vars)
                            end
                            RageUI.List(v.name, IdListRageUI[v.name], IdListRageUI[v.index],
                            "Variation actuelle : " .. CurrentSelection[v.name].vars .. command, {}
                            , true, {
                                
                                    onListChange = function(Index, Item)
                                        IdListRageUI[v.index] = Index
                                        CurrentSelection[v.name].id = IdListRageUI[v.name][IdListRageUI[v.index]]
                                        CurrentSelection[v.name].vars = 0
                                        SetPedComponentVariation(PlayerPedId(), v.id, IdListRageUI[v.name][IdListRageUI[v.index]], 0, 2)
                                    end,
                                    onSelected = function()
                                        if v.item == "tshirt" or v.item == "tshirt2" or v.item == "pant" or v.item == "feet" or v.item == "collier" or v.item == "access" or v.item == "bague" then
                                            local playerId = tonumber(GetPlayerServerId(PlayerId()))
                                            if v.item == "tshirt" then
                                                if FindIDintable(MaillotsPremium, v.index1) or FindIDintable(MaillotsCustom, v.index1) then
                                                    TriggerServerEvent("core:addItemToInventoryStaff", token, tonumber(playerId), v.item, 1, {
                                                        renamed = "Haut N°" .. CurrentSelection["Hauts"].id,
                                                        drawableTorsoId = CurrentSelection["Hauts"].id,
                                                        variationTorsoId = CurrentSelection["Hauts"].vars,
                                                        drawableArmsId = CurrentSelection["Bras"].id,
                                                        variationArmsId = CurrentSelection["Bras"].vars,
                                                        drawableTshirtId = CurrentSelection["T-Shirt"].id,
                                                        variationTshirtId = CurrentSelection["T-Shirt"].vars
                                                    })
                                                else
                                                    TriggerServerEvent("core:addItemToInventoryStaff", token, tonumber(playerId), v.item, 1, {
                                                        renamed = "Haut N°" .. CurrentSelection["Hauts"].id,
                                                        drawableTorsoId = CurrentSelection["Hauts"].id,
                                                        variationTorsoId = CurrentSelection["Hauts"].vars,
                                                        drawableArmsId = CurrentSelection["Bras"].id,
                                                        variationArmsId = CurrentSelection["Bras"].vars,
                                                        drawableTshirtId = CurrentSelection["T-Shirt"].id,
                                                        variationTshirtId = CurrentSelection["T-Shirt"].vars
                                                    })
                                                end
                                            elseif v.item == "tshirt2" then
                                                TriggerServerEvent("core:addItemToInventoryStaff", token, tonumber(playerId), v.item, 1, {
                                                    renamed = "T-Shirt N°" .. CurrentSelection["T-Shirt"].id,
                                                    drawableTorsoId = 15,
                                                    variationTorsoId = 0,
                                                    drawableArmsId = CurrentSelection["Bras"].id or 5,
                                                    variationArmsId = CurrentSelection["Bras"].vars or 0,
                                                    drawableTshirtId = CurrentSelection["T-Shirt"].id or 15,
                                                    variationTshirtId = CurrentSelection["T-Shirt"].vars or 0
                                                })
                                            elseif v.item == "access" then
                                                TriggerServerEvent("core:addItemToInventoryStaff", token, tonumber(playerId), "access", 1, {
                                                    renamed = firstToUpper(v.item) .. " #" .. tonumber(CurrentSelection[v.name].id),
                                                    drawableId = tonumber(CurrentSelection[v.name].id),
                                                    variationId = tonumber(CurrentSelection[v.name].vars),
                                                    name = 'sac'
                                                })
                                            else
                                                TriggerServerEvent("core:addItemToInventoryStaff", token, tonumber(playerId), v.item, 1, {
                                                    renamed = firstToUpper(v.item) .. " #" .. tonumber(CurrentSelection[v.name].id),
                                                    drawableId = tonumber(CurrentSelection[v.name].id),
                                                    variationId = tonumber(CurrentSelection[v.name].vars)
                                                })
                                            end
                                            exports['vNotif']:createNotification({
                                                type = 'VERT',
                                                content = "Vous avez donné un ".. v.item .. " à " .. playerId .. " avec succès !"
                                            })
                                        else
                                            exports['vNotif']:createNotification({
                                                type = 'ROUGE',
                                                content = "Vous ne pouvez pas donner cet item !"
                                            })
                                        end
                                    end,
                                    onActive = function()
                                        if v.item == "tshirt" or v.item == "tshirt2" or v.item == "pant" or v.item == "feet" or v.item == "collier" or v.item == "access" or v.item == "bague" then
                                            instructionalButtons[idInstructionalButtons[1]] = {
                                                { control = 38, label = "" },
                                                { control = 107, label = "Changer la variation" },
                                                { control = 191, label = "Obtenir la tenue" },
                                                { control = 121, label = "Entrez un numéro d'item" },
                                                { control = 47, label = "Recupérer les identifiants" }
                                            }
                                        else
                                            instructionalButtons[idInstructionalButtons[1]] = {
                                                { control = 38, label = "" },
                                                { control = 107, label = "Changer la variation" },
                                                { control = 121, label = "Entrez un numéro d'item" },
                                                { control = 47, label = "Recupérer les identifiants" }
                                            }
                                        end
                                        if IsControlJustReleased(0,107) or IsControlJustReleased(0,38) then
                                            if Habits[v.name][IdListRageUI[v.name][IdListRageUI[v.index]]].vars then
                                                if Habits[v.name][IdListRageUI[v.name][IdListRageUI[v.index]]].vars[CurrentSelection[v.name].vars + 1] then
                                                    CurrentSelection[v.name].vars += 1
                                                else
                                                    CurrentSelection[v.name].vars = 0
                                                end
                                                SetPedComponentVariation(PlayerPedId(), v.id, IdListRageUI[v.name][IdListRageUI[v.index]], Habits[v.name][IdListRageUI[v.name][IdListRageUI[v.index]]].vars[CurrentSelection[v.name].vars], 2)
                                            end
                                        elseif IsControlJustReleased(0,108) then
                                            if Habits[v.name][IdListRageUI[v.name][IdListRageUI[v.index]]].vars then
                                                if Habits[v.name][IdListRageUI[v.name][IdListRageUI[v.index]]].vars[CurrentSelection[v.name].vars - 1] then
                                                    CurrentSelection[v.name].vars -= 1
                                                else
                                                    CurrentSelection[v.name].vars = #Habits[v.name][IdListRageUI[v.name][IdListRageUI[v.index]]].vars
                                                end
                                                SetPedComponentVariation(PlayerPedId(), v.id, IdListRageUI[v.name][IdListRageUI[v.index]], Habits[v.name][IdListRageUI[v.name][IdListRageUI[v.index]]].vars[CurrentSelection[v.name].vars], 2)
                                            end
                                        elseif IsControlJustReleased(0, 121) then
                                            local newIndex = KeyboardImput("Entrez le numéro de l'item", "", 3)
                                            if newIndex and tonumber(newIndex) then
                                                newIndex = tonumber(newIndex) + 1
                                                if Habits[v.name][newIndex] then
                                                    IdListRageUI[v.index] = newIndex
                                                    CurrentSelection[v.name].id = IdListRageUI[v.name][IdListRageUI[v.index]]
                                                    SetPedComponentVariation(PlayerPedId(), v.id, IdListRageUI[v.name][IdListRageUI[v.index]], 0, 2)
                                                    -- idToChange = 0
                                                    CurrentSelection[v.name].vars = 0
                                                else
                                                    exports['vNotif']:createNotification({
                                                        type = 'ROUGE',
                                                        content = "Numéro d'item invalide !"
                                                    })
                                                end
                                            end
                                        elseif IsControlJustReleased(0, 47) then
                                            local skin = getSkin(v.id, false)

                                            IdListRageUI[v.index] = skin[1] + 1
                                            CurrentSelection[v.name].id = IdListRageUI[v.name][IdListRageUI[v.index]]
                                            CurrentSelection[v.name].vars = skin[2]
                                        end
                                    end
                                })
                        end
                    end
                end)
                RageUI.IsVisible(Masques, function()
                    for k, v in pairs(ConfigVetements) do
                        local command = ""
                        if v.text and v.text ~= "" then
                            command = "\nCommande Give : "..string.format(v.text, IdListRageUI[v.name][IdListRageUI[v.index]], CurrentSelection[v.name].vars)
                        end
                        if v.category == "Masques" then
                            RageUI.List(v.name, IdListRageUI[v.name], IdListRageUI[v.index],
                                "Variation actuelle : " .. CurrentSelection[v.name].vars .. command, {}
                                , true, {
                                    onListChange = function(Index, Item)
                                        IdListRageUI[v.index] = Index
                                        CurrentSelection[v.name].id = IdListRageUI[v.name][IdListRageUI[v.index]]
                                        CurrentSelection[v.name].vars = 0
                                        SetPedComponentVariation(PlayerPedId(), v.id, IdListRageUI[v.name][IdListRageUI[v.index]], 0, 2)
                                    end,
                                    onSelected = function()
                                        local playerId = tonumber(GetPlayerServerId(PlayerId()))
                                        TriggerServerEvent("core:addItemToInventoryStaff", token, tonumber(playerId), v.item, 1, {
                                            renamed = "Masques #" .. tonumber(IdListRageUI[v.name][IdListRageUI[v.index]]),
                                            drawableId = tonumber(IdListRageUI[v.name][IdListRageUI[v.index]]),
                                            variationId = tonumber(CurrentSelection[v.name].vars) or 0
                                        })
                                        exports['vNotif']:createNotification({
                                            type = 'VERT',
                                            content = "Vous avez donné un masque à " .. playerId .. " avec succès !"
                                        })
                                    end,
                                    onActive = function()
                                        instructionalButtons[idInstructionalButtons[1]] = {
                                            { control = 38, label = "" },
                                            { control = 107, label = "Changer la variation" },
                                            { control = 191, label = "Obtenir la tenue" },
                                            { control = 121, label = "Entrez un numéro d'item" },
                                            { control = 47, label = "Recupérer les identifiants" }
                                        }
                                        if IsControlJustReleased(0,107) or IsControlJustReleased(0,38) then
                                            if Habits[v.name][IdListRageUI[v.name][IdListRageUI[v.index]]].vars then
                                                if Habits[v.name][IdListRageUI[v.name][IdListRageUI[v.index]]].vars[CurrentSelection[v.name].vars + 1] then
                                                    CurrentSelection[v.name].vars += 1
                                                else
                                                    CurrentSelection[v.name].vars = 0
                                                end
                                                SetPedComponentVariation(PlayerPedId(), v.id, IdListRageUI[v.name][IdListRageUI[v.index]], Habits[v.name][IdListRageUI[v.name][IdListRageUI[v.index]]].vars[CurrentSelection[v.name].vars], 2)
                                            end
                                        elseif IsControlJustReleased(0,108) then
                                            if Habits[v.name][IdListRageUI[v.name][IdListRageUI[v.index]]].vars then
                                                if Habits[v.name][IdListRageUI[v.name][IdListRageUI[v.index]]].vars[CurrentSelection[v.name].vars - 1] then
                                                    CurrentSelection[v.name].vars -= 1
                                                else
                                                    CurrentSelection[v.name].vars = #Habits[v.name][IdListRageUI[v.name][IdListRageUI[v.index]]].vars
                                                end
                                                SetPedComponentVariation(PlayerPedId(), v.id, IdListRageUI[v.name][IdListRageUI[v.index]], Habits[v.name][IdListRageUI[v.name][IdListRageUI[v.index]]].vars[CurrentSelection[v.name].vars], 2)
                                            end
                                        elseif IsControlJustReleased(0, 121) then
                                            local newIndex = KeyboardImput("Entrez le numéro de l'item", "", 3)
                                            if newIndex and tonumber(newIndex) then
                                                newIndex = tonumber(newIndex) + 1
                                                if Habits[v.name][newIndex] then
                                                    IdListRageUI[v.index] = newIndex
                                                    CurrentSelection[v.name].id = IdListRageUI[v.name][IdListRageUI[v.index]]
                                                    SetPedComponentVariation(PlayerPedId(), v.id, IdListRageUI[v.name][IdListRageUI[v.index]], 0, 2)
                                                    -- idToChange = 0
                                                    CurrentSelection[v.name].vars = 0
                                                else
                                                    exports['vNotif']:createNotification({
                                                        type = 'ROUGE',
                                                        content = "Numéro d'item invalide !"
                                                    })
                                                end
                                            end
                                        elseif IsControlJustReleased(0, 47) then
                                            local skin = getSkin(v.id, false)

                                            IdListRageUI[v.index] = skin[1] + 1
                                            CurrentSelection[v.name].id = IdListRageUI[v.name][IdListRageUI[v.index]]
                                            CurrentSelection[v.name].vars = skin[2]
                                        end
                                    end
                                })
                        end
                    end
                end)
                RageUI.IsVisible(Accessoires, function()
                    for k, v in pairs(ConfigVetements) do
                        if v.category == "Accessoires" then
                            RageUI.List(v.name, IdListRageUI[v.name], IdListRageUI[v.index],
                                "Appuyez sur ENTRER pour changer les variations\nVariation actuelle : " ..
                                CurrentSelection[v.name].vars ..
                                "\n\nCommande Give : " ..
                                string.format(v.text, IdListRageUI[v.name][IdListRageUI[v.index]], CurrentSelection[v.name].vars), {}
                                , true, {
                                    onListChange = function(Index, Item)
                                        IdListRageUI[v.index] = Index
                                        CurrentSelection[v.name].id = IdListRageUI[v.name][IdListRageUI[v.index]]
                                        CurrentSelection[v.name].vars = 0
                                        SetPedPropIndex(PlayerPedId(), v.id, IdListRageUI[v.name][IdListRageUI[v.index]], 0, 2)
                                    end,
                                    onSelected = function()
                                        local playerId = tonumber(GetPlayerServerId(PlayerId()))
                                        TriggerServerEvent("core:addItemToInventoryStaff", token, tonumber(playerId), v.item, 1, {
                                            renamed = firstToUpper(v.item) .. " #" .. tonumber(IdListRageUI[v.name][IdListRageUI[v.index]]),
                                            drawableId = tonumber(IdListRageUI[v.name][IdListRageUI[v.index]]),
                                            variationId = tonumber(CurrentSelection[v.name].vars) or 0
                                        })
                                        exports['vNotif']:createNotification({
                                            type = 'VERT',
                                            content = "Vous avez donné un accessoire à " .. playerId .. " avec succès !"
                                        })
                                    end,
                                    onActive = function()
                                        instructionalButtons[idInstructionalButtons[1]] = {
                                            { control = 38, label = "" },
                                            { control = 107, label = "Changer la variation" },
                                            { control = 191, label = "Obtenir la tenue" },
                                            { control = 121, label = "Entrez un numéro d'item" },
                                            { control = 47, label = "Recupérer les identifiants" }
                                        }
                                        if IsControlJustReleased(0,107) or IsControlJustReleased(0,38) then
                                            if Habits[v.name][IdListRageUI[v.name][IdListRageUI[v.index]]].vars then
                                                if Habits[v.name][IdListRageUI[v.name][IdListRageUI[v.index]]].vars[CurrentSelection[v.name].vars + 1] then
                                                    CurrentSelection[v.name].vars += 1
                                                else
                                                    CurrentSelection[v.name].vars = 0
                                                end
                                                SetPedPropIndex(PlayerPedId(), v.id, IdListRageUI[v.name][IdListRageUI[v.index]], Habits[v.name][IdListRageUI[v.name][IdListRageUI[v.index]]].vars[CurrentSelection[v.name].vars], 2)
                                            end
                                        elseif IsControlJustReleased(0,108) then
                                            if Habits[v.name][IdListRageUI[v.name][IdListRageUI[v.index]]].vars then
                                                if Habits[v.name][IdListRageUI[v.name][IdListRageUI[v.index]]].vars[CurrentSelection[v.name].vars - 1] then
                                                    CurrentSelection[v.name].vars -= 1
                                                else
                                                    CurrentSelection[v.name].vars = #Habits[v.name][IdListRageUI[v.name][IdListRageUI[v.index]]].vars
                                                end
                                                SetPedPropIndex(PlayerPedId(), v.id, IdListRageUI[v.name][IdListRageUI[v.index]], Habits[v.name][IdListRageUI[v.name][IdListRageUI[v.index]]].vars[CurrentSelection[v.name].vars], 2)
                                            end
                                        elseif IsControlJustReleased(0, 121) then
                                            local newIndex = KeyboardImput("Entrez le numéro de l'item", "", 3)
                                            if newIndex and tonumber(newIndex) then
                                                newIndex = tonumber(newIndex) + 1
                                                if Habits[v.name][newIndex] then
                                                    IdListRageUI[v.index] = newIndex
                                                    CurrentSelection[v.name].id = IdListRageUI[v.name][IdListRageUI[v.index]]
                                                    SetPedPropIndex(PlayerPedId(), v.id, IdListRageUI[v.name][IdListRageUI[v.index]], 0, 2)
                                                    -- idToChange = 0
                                                    CurrentSelection[v.name].vars = 0
                                                else
                                                    exports['vNotif']:createNotification({
                                                        type = 'ROUGE',
                                                        content = "Numéro d'item invalide !"
                                                    })
                                                end
                                            end
                                        elseif IsControlJustReleased(0, 47) then
                                            local skin = getSkin(v.id, true)

                                            IdListRageUI[v.index] = skin[1] + 1
                                            CurrentSelection[v.name].id = IdListRageUI[v.name][IdListRageUI[v.index]]
                                            CurrentSelection[v.name].vars = skin[2]
                                        end
                                    end
                                })
                        end
                    end
                end)
            end
        end)
    end
end

local function createVehGestion(veh)
    local cart = CreateVehicle(GetHashKey(veh), vector(0, 0, 0), 0)
    -- Freeze the ped so it doesn't move
    FreezeEntityPosition(cart, true)
    -- Dont despawn
    SetEntityAsMissionEntity(cart, true, true)
    -- Set the ped to be invisible
    SetEntityVisible(cart, false, false)
    -- Set the ped to be invincible
    SetEntityInvincible(cart, true)
    -- Set the ped to be untargetable
    SetEntityCanBeDamaged(cart, false)
    return cart
end

local function abs(n)
    if n < 0 then
        return -n
    end
    return n
end

local function RotationToDirection(rotation)
    local adjustedRotation = vec3(
        (math.pi / 180) * rotation.x,
        (math.pi / 180) * rotation.y,
        (math.pi / 180) * rotation.z
    )
    local direction = vec3(
        -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        math.sin(adjustedRotation.x)
    )
    return direction
end

function UpdateOrCreateClone(veh)
    -- Delete the previous clone
    if previewCar ~= nil then
        DeleteEntity(previewCar)
        previewCar = nil
    end
    if veh then
        previewCar = createVehGestion(veh)
    end
end

local rotToChange = 90
CreateThread(function()
    while true do
        Wait(10)
        if open then
            if previewCar ~= nil then
                local _ = GetGameplayCamCoord()
                -- Get the coordinates that are 5 units forward, 1 unit up and 1 unit right the coords _ depending on the rotation of the camera
                local rot = GetGameplayCamRot()
                local forward = RotationToDirection(rot)
                local right = RotationToDirection(vec3(rot.x, rot.y, rot.z - 90.0))
                local up = vec3(0.0, 0.0, 1.5)
                local coords = _ + forward * 8.5 + up * 0.8 + right * -1.2
                SetPedConfigFlag(previewCar, 223, false)
                -- Set the ped coords to the coords we calculated
                SetEntityCoordsNoOffset(previewCar, coords, false, false, false)
                -- Make the ped look at the inverse of the camera
                rotToChange += 0.18
                SetEntityHeading(previewCar, rot.z + rotToChange)
                SetEntityVisible(previewCar, true, false)
            end
        else
            Wait(2000)
        end
    end
end)

RegisterCommand("addcarcustom", function(source, args)
    if p:getPermission() >= 4 then
        if checkIfVehiculeIsBlacklisted(args[2]) then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Ce véhicule est blacklisté !"
            })
            return
        end
        TriggerServerEvent("core:boutique:buyCar", tonumber(args[1]), tostring(args[2]), tonumber(args[3]))
    end
end)

RegisterNetEvent("core:spawnboutiquecar")
AddEventHandler("core:spawnboutiquecar", function(model, plate, color, liveries, iscasino)
    local Coords = GetEntityCoords(PlayerPedId())
    local Heading = GetEntityHeading(PlayerPedId())
    local vec = vector4(Coords.x, Coords.y, Coords.z, Heading)
    if iscasino then
        vec = vector4(938.83, -13.61, 77.76, 59.17)
        DeletePedsCasino()
    end
    local vehicle = vehicle.create(model, vec,
        {
            plate = plate,
            modLivery = liveries,
            modLiverys = liveries
        })
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    TriggerServerEvent("core:SetVehicleOut", string.upper(plate), VehToNet(vehicle), vehicle)
end)

RegisterCommand("addTattoo", function(source, args)
    if p:getPermission() >= 3 then
        if args[1] and args[2] then
            args[2] = tonumber(args[2])
            if GetEntityModel(GetPlayerPed(GetPlayerFromServerId(tonumber(args[1])))) == `mp_m_freemode_01` then
                TriggerServerEvent('core:addTattooToPlayer', token, tonumber(args[1]),
                    { Collection = GetTattoos()[args[2]].Collection, HashName = GetTattoos()[args[2]].HashNameMale })
            elseif GetEntityModel(GetPlayerPed(GetPlayerFromServerId(tonumber(args[1])))) == `mp_f_freemode_01` then
                TriggerServerEvent('core:addTattooToPlayer', token, tonumber(args[1]),
                    { Collection = GetTattoos()[args[2]].Collection, HashName = GetTattoos()[args[2]].HashNameFemale })
            else
            end
        else
        end
    end
end)
