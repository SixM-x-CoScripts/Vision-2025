local VUI = exports["VUI"]
local main = VUI:CreateMenu("Events", "events", true)
local iplmenu = VUI:CreateSubMenu(main, "Events", "events", true)
local givemenu = VUI:CreateSubMenu(main, "Events", "events", true)
local mapeditor = VUI:CreateSubMenu(main, "Events", "events", true)
local objectListPlaced = VUI:CreateSubMenu(mapeditor, "Events", "events", true)
local eventsmenu = VUI:CreateSubMenu(main, "Events", "events", true)
local illegauxeventsmenu = VUI:CreateSubMenu(main, "Events", "events", true)
local subEventIllegalmenu = VUI:CreateSubMenu(illegauxeventsmenu, "Events", "events", true)
local subSousIPLmenu = VUI:CreateSubMenu(iplmenu, "Events", "events", true)
local subSousTpIPLmenu = VUI:CreateSubMenu(iplmenu, "Events", "events", true)
local subSousEventmenu = VUI:CreateSubMenu(eventsmenu, "Events", "events", true)

local PlacedPropsEvent = {}
local listTpIpl = {}

local CurrentFiltre = nil
local TypeGive = 1

-- EVENT
--  Liste d'events
    --  Lister les events possibles
    --  Si y'a pos TP
    --  Démarré maintenant
--  Liste des ipl
    -- Chargé l'ipl
    -- TP à l'ipl

local EventList = {
    {
        name = "Course de motocross",
        place = "Circuit RedWood",
        active = false,
        tp = vector3(1058.8138427734, 2282.349609375, 59.366733551025),
        --func = CircuitRedwood()
    },
    {
        name = "Shotaro",
        place = "Arena",
        active = false,
        tp = vector3(2800.00, -3800.00, 100.00),
        --func = ShotaroEvent()
    },
    {
        name = "Karting",
        place = "Wardogs",
        active = false,
        tp = vector3(880.72644042969, -2153.18359375, 29.486375808716),
        --func = KartingEvent()
    },
    {
        name = "Chasse au trésor",
        active = false,
        --func = ChasseAuTresor()
    },
}

local EventListIllegaux = {
    {
        name = "Braquage de brinks",
        active = true,
        image = "",
        load = function()
            local orga = KeyboardImput("Type d'org (pf, gang, mc, orga, mafia) Vide = toute le monde", "")
            if not orga or orga == "" then
                orga = "tout le monde"
            end
            local confirmation = ChoiceInput("Voulez vous lancer l'evenement brinks pour les "..string.lower(orga).." ?")
            if confirmation == true then
                SetEntityCoords(PlayerPedId(), -2094.15, -288.24, 12.89)
                TriggerServerEvent("core:events:startBrinks", string.lower(orga))
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    -- duration = 5, -- In seconds, default:  4
                    content = 'Vous avez lancé l\'évenement (Vous avez été téléporté afin d\'activer la zone onesync)'
                })
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = 'Vous avez annulé la saisie'
                })
            end
        end
    },
    {
        name = "conteneur (PF)",
        active = true,
        image = "",
        load = function()
            local orga = KeyboardImput("Type d'org (pf, gang, mc, orga, mafia) Vide = toute le monde", "")
            if not orga or orga == "" then
                orga = "tout le monde"
            end
            local confirmation = ChoiceInput("Voulez vous lancer l'evenement conteneur pour les "..string.lower(orga).." ?")
            if confirmation == true then
                TriggerServerEvent("core:event:conteneur", string.lower(orga))
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    -- duration = 5, -- In seconds, default:  4
                    content = 'Vous avez lancé l\'évenement'
                })
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = 'Vous avez annulé la saisie'
                })
            end
        end
    },
    {
        name = "remorque voitures (Gang)",
        active = true,
        image = "",
        load = function()
            local orga = KeyboardImput("Type d'org (pf, gang, mc, orga, mafia) Vide = toute le monde", "")
            if not orga or orga == "" then
                orga = "tout le monde"
            end
            local confirmation = ChoiceInput("Voulez vous lancer l'evenement remorque voitures pour les "..string.lower(orga).." ?")
            if confirmation == true then
                SetEntityCoords(PlayerPedId(), 1563.55, 875.06, 76.48)
                TriggerServerEvent("core:events:trailer:start", string.lower(orga))
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    -- duration = 5, -- In seconds, default:  4
                    content = 'Vous avez lancé l\'évenement (Vous avez été téléporté afin d\'activer la zone onesync)'
                })
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = 'Vous avez annulé la saisie'
                })
            end
        end
    },
    {
        name = "camion d'armes (Mafia)",
        active = true,
        image = "",
        load = function()
            local orga = KeyboardImput("Type d'org (pf, gang, mc, orga, mafia) Vide = toute le monde", "")
            if not orga or orga == "" then
                orga = "tout le monde"
            end
            local confirmation = ChoiceInput("Voulez vous lancer l'evenement braquage camion armes pour les "..string.lower(orga).." ?")
            if confirmation == true then
                TriggerServerEvent("core:events:camion:start", orga)
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    -- duration = 5, -- In seconds, default:  4
                    content = 'Vous avez lancé l\'évenement'
                })
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = 'Vous avez annulé la saisie'
                })
            end
        end
    },
}

local IplList = {
    {
        name = "Arena",
        tp = vector3(2800.00, -3800.00, 100.00),
        dlc = true,
        load = function()
            RequestArenaIPL()
            print("Loaded Arena IPL")
        end,
        unload = function()
            UnLoadArenaIPL()
            print("UnLoaded Arena IPL")
        end
    },
    {
        name = "NorthYanktown",
        tp = vector3(3203.1237792969, -4827.3466796875, 110.09663391113),
        load = function()
            NorthYanktownIPL()
            print("Loaded North Yanktown IPL")
        end,
        unload = function()
            UnloadNorthYanktownIPL()
            print("UnLoaded Arena IPL")
        end
    },
    {
        name = "Criminal Enterprise",
        dlc = true,
        tp = vector3(850.32891845703, -3001.0517578125, -49.999843597412),
        load = function()
            CriminalEnterpriseIPl()
            print("Loaded Criminal Enterprise IPL")
        end,
        unload = function()
            UnloadCriminalEnterpriseIPl()
            print("UnLoaded Criminal Enterprise IPL")
        end
    },
    {
        name = "The Contract Studio",
        dlc = true,
        tp = vector3(-999.20227050781, -66.02400970459, -100.00311279297),
    },
    {
        name = "Bikers Clubhouse 1",
        dlc = true,
        tp = vector3(1107.04, -3157.399, -37.51859),
    },
    {
        name = "Bikers Clubhouse 2",
        dlc = true,
        tp = vector3(998.4809, -3164.711, -38.90733),
    },
    {
        name = "Bikers Cocaine",
        dlc = true,
        tp = vector3(1093.6, -3196.6, -38.99841),
    },
    {
        name = "Bikers Counterfeit cash factory",
        dlc = true,
        tp = vector3(1121.897, -3195.338, -40.4025),
    },
    {
        name = "Bikers Document forgery",
        dlc = true,
        tp = vector3(1165.0, -3196.6, -39.01306),
    },
    {
        name = "Bikers Meth",
        dlc = true,
        tp = vector3(1009.5, -3196.6, -38.99682),
    },
    {
        name = "Bikers Weed farm",
        dlc = true,
        tp = vector3(1051.491, -3196.536, -39.14842),
    },
    {
        name = "Casino Arcade",
        tp = vector3(2730.0, -380.0, -49.0),
        dlc = true
    },
    {
        name = "Cayo Club",
        tp = vector3(1550.0, 250.0, -48.0),
        dlc = true
    },
    {
        name = "IAA Facility",
        tp = vector3(2155.07, 2920.88, -62.9),
        dlc = true
    },
    {
        name = "IAA Server Room",
        tp = vector3(2154.85, 2921.07, -82.08),
        dlc = true
    },
    {
        name = "Doomsday",
        tp = vector3(460.6, 4815.69, -60.0),
        dlc = true
    },
    {
        name = "Doomsday Bunker",
        tp = vector3(532.79187011719, 5914.458984375, -159.08006286621),
        dlc = true
    },
    {
        name = "Aircraft",
        tp = vector3(3085.1760253906, -4688.5556640625, 26.251892089844),
        dlc = true
    },
    {
        name = "Plane Hangar",
        tp = vector3(-1267.0 -3013.135 -49.5),
        dlc = true
    },
    {
        name = "Import/Export",
        tp = vector3(994.5925, -3002.594, -39.64699),
        dlc = true
    },
    {
        name = "CEO VEHICLES SHOP",
        tp = vector3(730.63916015625, -2993.2373046875, -38.999904632568),
        dlc = true
    },
    {
        name = "Coroner",
        tp = vector3(240.97831726074, -1366.2081298828, 38.534381866455),
    },
    {
        name = "Bunker",
        tp = vector3(901.29949951172, -3223.8515625, -99.25749206543),
    },
    {
        name = "Cinema",
        tp = vector3(-1426.8258056641, -256.29141235352, 15.782796859741),
    }
}

local SelectedEvent = {}
local SelectedIPL = {}

eventsmenu.OnOpen(function()
    renderSubEventMenu()
    --setFooter(nil)
end)

main.OnOpen(function()
    SelectedEvent = {}
    renderEventMenu()
    --setFooter(nil)
end)

subSousEventmenu.OnOpen(function()
    rendersousSubEventMenu()
    --setFooter(nil)
end)

iplmenu.OnOpen(function()
    SelectedIPL = {}
    renderiplmenu()
    --setFooter(nil)
end)

givemenu.OnOpen(function()
    renderGiveMenu()
end)

mapeditor.OnOpen(function()
    rendermapeditor()
end)

objectListPlaced.OnOpen(function()
    renderObjectlist()
end)

subSousIPLmenu.OnOpen(function()
    renderSubiplmenu()
    --setFooter(nil)
end)

subSousTpIPLmenu.OnOpen(function()
    renderSubTpIplmenu()
    --setFooter(nil)
end)

illegauxeventsmenu.OnOpen(function()
    renderEvIllegalMenu()
end)

subEventIllegalmenu.OnOpen(function()
    renderSubEvIllegalMenu()
end)

function renderSubEvIllegalMenu()
    subEventIllegalmenu.Separator(
        "Nom",
        SelectedEvent.name,
        "",
        ""
    )
    subEventIllegalmenu.Button(
        "Démarrer",
        "l'event",
        nil,
        nil,
        false,
        function()
            SelectedEvent.load()
        end
    )
end

function renderObjectlist()
    for k,v in pairs(PlacedPropsEvent) do
        objectListPlaced.Button(
            v.name,
            "",
            nil,
            "chevron",
            false,
            function()

            end
        )
    end
end

function renderEvIllegalMenu()
    for k,v in pairs(EventListIllegaux) do
        illegauxeventsmenu.Button(
            "Event",
            v.name,
            nil,
            v.active and "chevron" or "lock",
            false,
            function()
                SelectedEvent = v
            end,
            subEventIllegalmenu
        )
    end
end

function renderSubiplmenu()
    subSousIPLmenu.Separator(
        "Nom",
        SelectedIPL.name,
        "",
        ""
    )
    subSousIPLmenu.Button(
        "Se téléporter",
        "",
        nil,
        "chevron",
        false,
        function()
            SetPedCoordsKeepVehicle(PlayerPedId(), SelectedIPL.tp.x, SelectedIPL.tp.y, SelectedIPL.tp.z)
        end
    )
    local iplAlreadyInUse = false
    for k,v in pairs(listTpIpl) do
        if v.ipl.name == SelectedIPL.name then
            iplAlreadyInUse = true
        end
    end
    subSousIPLmenu.Button(
        "Créer",
        "un point de tp",
        nil,
        "chevron",
        iplAlreadyInUse,
        function()
            local name = KeyboardImput("Nom du point de tp")
            if name ~= nil and name ~= "" then
                TriggerServerEvent("core:event:addtpipl", name, GetEntityCoords(PlayerPedId()), SelectedIPL)
                subSousIPLmenu.refresh()
            end
        end
    )
    if SelectedIPL.load then
        subSousIPLmenu.Button(
            "Charger",
            "l'IPL",
            nil,
            "chevron",
            false,
            function()
                SelectedIPL.load()
            end
        )
        subSousIPLmenu.Button(
            "Décharger",
            "l'IPL",
            nil,
            "chevron",
            false,
            function()
                SelectedIPL.unload()
            end
        )
    end
end

function renderSubTpIplmenu()
    for k,v in pairs(listTpIpl) do
        local tableTpIpl, IdtblTpIpl = { "TP", "Supprimer" }, 1

        subSousTpIPLmenu.List(
            k,
            v.ipl.name,
            p:getPermission() <= 2,
            tableTpIpl,
            IdtblTpIpl,
            function(index, item)
                if item == "TP" then
                    SetPedCoordsKeepVehicle(PlayerPedId(), vector3(v.enter.x, v.enter.y, v.enter.z - 1.0))
                elseif item == "Supprimer" then
                    local confirmation = ChoiceInput("Êtes vous sur de supprimer ce point de tp ?")
                    if confirmation == true then
                        TriggerServerEvent("core:event:removetpipl", k)
                        Wait(200)
                        subSousTpIPLmenu.refresh()
                    end
                end
            end
        )
    end
    if listTpIpl == nil or next(listTpIpl) == nil then
        subSousTpIPLmenu.Separator(" ")
        subSousTpIPLmenu.Separator("Aucun point de tp trouvé")
        subSousTpIPLmenu.Separator(" ")
    end
end

function renderGiveMenu()
    print("renderGiveMenu", TypeGive)
    givemenu.Button(
        "Give",
        "un item par nom",
        nil,
        "chevron",
        false,
        function()
            local item = KeyboardImput("ID de l'item")

            if item ~= nil or item ~= "" then

                if checkIfItemIsBlacklisted(item) then return end

                local playerId, radius = nil, nil

                if TypeGive == 1 then
                    playerId = KeyboardImput("ID du joueur", "")
                    if tonumber(playerId) == nil then
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            content = 'Veuillez entrer un ID valide'
                        })
                        return
                    end
                else
                    radius = KeyboardImput("Rayon", "")
                    if tonumber(radius) == nil then
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            content = 'Veuillez entrer un rayon valide'
                        })
                        return
                    end
                    if tonumber(radius) > 75 and p:getPermission() < 5 then
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            content = 'Le rayon ne peut pas être supérieur à 50 metres'
                        })
                        return
                    elseif tonumber(radius) > 100 and p:getPermission() < 6 then
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            content = 'Le rayon ne peut pas être supérieur à 100 metres'
                        })
                        return
                    end
                end

                local count = KeyboardImput("Quantité", "")
                if tonumber(count) == nil then
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        content = 'Veuillez entrer une quantité valide'
                    })
                    return
                end

                local duration = KeyboardImput("Durée en minutes", "")
                if tonumber(duration) == nil then
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        content = 'Veuillez entrer une durée valide'
                    })
                    return
                end

                if tonumber(duration) > 600 then
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        content = 'La durée ne peut pas être supérieure à 10 heures'
                    })
                    return
                end

                if TypeGive == 1 and tonumber(playerId) and item and tonumber(count) and tonumber(duration) then
                    ExecuteCommand("giveitemtemporarily " .. tonumber(playerId) .. " " .. item .. " " .. tonumber(count) .. " " .. tonumber(duration))
                elseif TypeGive == 2 and tonumber(radius) and item and tonumber(count) and tonumber(duration) then
                    ExecuteCommand("giveitemradiustemporarily " .. tonumber(radius) .. " " .. item .. " " .. tonumber(count) .. " " .. tonumber(duration))
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        content = 'Veuillez entrer des informations valides'
                    })
                    return
                end
            end
        end
    )
    if CurrentFiltre == nil then
        givemenu.Button(
            "Rechercher",
            "un item par nom",
            nil,
            "search",
            false,
            function()
                CurrentFiltre = nil
                local TargetItem = KeyboardImput("Entrer un nom d'item")
                TargetItem = tostring(TargetItem)
                if TargetItem ~= nil and string.len(TargetItem) ~= 0 then
                    if type(TargetItem) == 'string' then
                        CurrentFiltre = TargetItem

                        givemenu.refresh()
                    end
                else
                    CurrentFiltre = nil

                    givemenu.refresh()
                end
            end
        )
    else
        givemenu.Button(
            CurrentFiltre,
            nil,
            nil,
            "search",
            false,
            function()
                CurrentFiltre = nil

                givemenu.refresh()
            end
        )
    end

    givemenu.Separator(nil)

    for k, v in pairs(items) do
        if k ~= "maxWeight" then
            if CurrentFiltre ~= nil then
                if k == tonumber(CurrentFiltre) or string.find(string.lower(k), string.lower(tostring(CurrentFiltre))) or string.find(string.lower(v.label), string.lower(tostring(CurrentFiltre))) then
                    givemenu.Button(
                        v.label or "Inconnu",
                        k or "Inconnu",
                        v.weight .. " kg" or "Inconnu",
                        nil,
                        false,
                        function()

                            if k ~= nil or k ~= "" then

                                if checkIfItemIsBlacklisted(k) then return end

                                local playerId, radius = nil, nil

                                if TypeGive == 1 then
                                    playerId = KeyboardImput("ID du joueur", "")
                                    if tonumber(playerId) == nil then
                                        exports['vNotif']:createNotification({
                                            type = 'ROUGE',
                                            content = 'Veuillez entrer un ID valide'
                                        })
                                        return
                                    end
                                else
                                    radius = KeyboardImput("Rayon", "")
                                    if tonumber(radius) == nil then
                                        exports['vNotif']:createNotification({
                                            type = 'ROUGE',
                                            content = 'Veuillez entrer un rayon valide'
                                        })
                                        return
                                    end
                                    if tonumber(radius) > 75 and p:getPermission() < 5 then
                                        exports['vNotif']:createNotification({
                                            type = 'ROUGE',
                                            content = 'Le rayon ne peut pas être supérieur à 50 metres'
                                        })
                                        return
                                    elseif tonumber(radius) > 100 and p:getPermission() < 6 then
                                        exports['vNotif']:createNotification({
                                            type = 'ROUGE',
                                            content = 'Le rayon ne peut pas être supérieur à 100 metres'
                                        })
                                        return
                                    end
                                end

                                local count = KeyboardImput("Quantité", "")
                                if tonumber(count) == nil then
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        content = 'Veuillez entrer une quantité valide'
                                    })
                                    return
                                end

                                local duration = KeyboardImput("Durée en minutes", "")
                                if tonumber(duration) == nil then
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        content = 'Veuillez entrer une durée valide'
                                    })
                                    return
                                end

                                if tonumber(duration) > 600 then
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        content = 'La durée ne peut pas être supérieure à 10 heures'
                                    })
                                    return
                                end

                                if TypeGive == 1 and tonumber(playerId) and k and tonumber(count) and tonumber(duration) then
                                    ExecuteCommand("giveitemtemporarily " .. tonumber(playerId) .. " " .. k .. " " .. tonumber(count) .. " " .. tonumber(duration))
                                elseif TypeGive == 2 and tonumber(radius) and k and tonumber(count) and tonumber(duration) then
                                    ExecuteCommand("giveitemradiustemporarily " .. tonumber(radius) .. " " .. k .. " " .. tonumber(count) .. " " .. tonumber(duration))
                                else
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        content = 'Veuillez entrer des informations valides'
                                    })
                                    return
                                end
                            end
                        end
                    )
                end
            else
                givemenu.Button(
                    v.label or "Inconnu",
                    k or "Inconnu",
                    v.weight .. " kg" or "Inconnu",
                    nil,
                    false,
                    function()

                        if k ~= nil or k ~= "" then

                            if checkIfItemIsBlacklisted(k) then return end

                            local playerId, radius = nil, nil

                            if TypeGive == 1 then
                                playerId = KeyboardImput("ID du joueur", "")
                                if tonumber(playerId) == nil then
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        content = 'Veuillez entrer un ID valide'
                                    })
                                    return
                                end
                            else
                                radius = KeyboardImput("Rayon", "")
                                if tonumber(radius) == nil then
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        content = 'Veuillez entrer un rayon valide'
                                    })
                                    return
                                end
                                if tonumber(radius) > 75 and p:getPermission() < 5 then
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        content = 'Le rayon ne peut pas être supérieur à 50 metres'
                                    })
                                    return
                                elseif tonumber(radius) > 100 and p:getPermission() < 6 then
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        content = 'Le rayon ne peut pas être supérieur à 100 metres'
                                    })
                                    return
                                end
                            end

                            local count = KeyboardImput("Quantité", "")
                            if tonumber(count) == nil then
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    content = 'Veuillez entrer une quantité valide'
                                })
                                return
                            end

                            local duration = KeyboardImput("Durée en minutes", "")
                            if tonumber(duration) == nil then
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    content = 'Veuillez entrer une durée valide'
                                })
                                return
                            end

                            if tonumber(duration) > 600 then
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    content = 'La durée ne peut pas être supérieure à 10 heures'
                                })
                                return
                            end

                            if TypeGive == 1 and tonumber(playerId) and k and tonumber(count) and tonumber(duration) then
                                ExecuteCommand("giveitemtemporarily " .. tonumber(playerId) .. " " .. k .. " " .. tonumber(count) .. " " .. tonumber(duration))
                            elseif TypeGive == 2 and tonumber(radius) and k and tonumber(count) and tonumber(duration) then
                                ExecuteCommand("giveitemradiustemporarily " .. tonumber(radius) .. " " .. k .. " " .. tonumber(count) .. " " .. tonumber(duration))
                            else
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    content = 'Veuillez entrer des informations valides'
                                })
                                return
                            end
                        end
                    end
                )
            end
        end
    end
end

local boolFreeze = false
function rendermapeditor()
    mapeditor.Separator(
        "Editeur de map",
        "",
        "",
        ""
    )
    mapeditor.Button(
        "Objets",
        "placés",
        nil,
        "chevron",
        false,
        function()
        end,
        objectListPlaced
    )
    mapeditor.Checkbox(
        "Freeze",
        "le prochain objet",
        p:getPermission() <= 2,
        boolFreeze,
        function(checked)
            boolFreeze = checked
        end
    )
    mapeditor.Button(
        "Placer",
        "un props",
        nil,
        "",
        false,
        function()
            local object = KeyboardImput("Nom du props (forge.plebmasters.de/objects)", "")
            SpawnEventProp(object, boolFreeze)
        end
    )
end

function SpawnEventProp(prop, freeze)
    if not prop then return end
    if prop == "" then return end
    local prophash = type(prop) == "number" and prop or GetHashKey(prop)
    if IsModelInCdimage(prophash) then
        TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
        local coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
        local camCoords = (coords + forward * 2.0)
        local placed = false
        local objS = entity:CreateObject(prop, camCoords)
        local objCoords = camCoords
        local heading = GetEntityHeading(p:ped())
        mapeditor.close()
        objS:setPos(objCoords)
        objS:setHeading(heading)
        PlaceObjectOnGroundProperly(objS.id)
        while not placed do
            coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
            objCoords = (coords + forward * 2.5)
            objS:setPos(objCoords)
            PlaceObjectOnGroundProperly(objS.id)
            objS:setAlpha(170)
            SetEntityCollision(objS.id, false, true)

            if IsControlPressed(0, 190) then
                heading = heading + 0.5
            elseif IsControlPressed(0, 189) then
                heading = heading - 0.5
            end

            SetEntityHeading(objS.id, heading)

            ShowHelpNotification(
                "~INPUT_CONTEXT~ Valider\n~INPUT_FRONTEND_LEFT~ ou ~INPUT_FRONTEND_RIGHT~ Pivoter")
            if IsControlJustPressed(0, 38) then
                placed = true
            end
            Wait(0)
        end
        SetEntityCollision(objS.id, true, true)
        objS:resetAlpha()
        local netId = objS:getNetId()
        if netId == 0 then
            objS:delete()
        end
        mapeditor.open()
        SetNetworkIdCanMigrate(netId, true)
        SetNetworkIdExistsOnAllMachines(netId, true)
        FreezeEntityPosition(objS.id, freeze)
        InsertContextObjectHandler(objS.id, {
            { icon = "ramasser", label = "Ramasser", action = "ramasserPropsDeco" }
        })
        table.insert(PlacedPropsEvent, {
            id = objS.id,
            name = prop
        })
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = 'Cet objet n\'existe pas'
        })
    end
end

function renderiplmenu()
    iplmenu.Button(
        "Afficher",
        "la liste des points TP",
        nil,
        "chevron",
        false,
        function()
        end,
        subSousTpIPLmenu
    )
    for k,v in pairs(IplList) do
        iplmenu.Button(
            v.dlc and "DLC" or "",
            v.name,
            nil,
            "chevron",
            false,
            function()
                SelectedIPL = v
            end,
            subSousIPLmenu
        )
    end
end

function rendersousSubEventMenu()
    subSousEventmenu.Separator(
        "Nom",
        SelectedEvent.name,
        "",
        ""
    )
end

function renderSubEventMenu()
    for k,v in pairs(EventList) do
        eventsmenu.Button(
            "Event",
            v.name,
            nil,
            v.active and "chevron" or "lock",
            false,
            function()
                SelectedEvent = v
            end,
            subSousEventmenu
        )
    end
end

local tableGive, IdtblGive = {"Joueur", "Radius"}, 1

function renderEventMenu()
    main.Button(
        "Liste des",
        "events légaux",
        nil,
        "chevron",
        false,
        function()
        end,
        eventsmenu
    )
    main.Button(
        "Liste des",
        "events illégaux",
        nil,
        "chevron",
        false,
        function()
        end,
        illegauxeventsmenu
    )
    main.Button(
        "Liste des",
        "IPL",
        nil,
        "chevron",
        false,
        function()
        end,
        iplmenu
    )
    main.List(
        "Effectuer",
        "un give temporaire",
        p:getPermission() <= 3,
        tableGive,
        IdtblGive,
        function(index, item)
            TypeGive = index
            givemenu.open()
        end
    )
    main.Button(
        "MAP",
        "Editor",
        nil,
        "chevron",
        false,
        function()
        end,
        mapeditor
    )
end

function OpenEventMenu()
    --renderEventMenu()
    main.open()
end

RegisterCommand("events", function()
    if p:getPermission() > 2 then
        OpenEventMenu()
    end
end)



-- TP Ipl

local function createTpIp(name, enterCoords, ipl)
    zone.addZone("tpipl_enter_" .. name,
        enterCoords,
        "~INPUT_CONTEXT~ Entrer",
        function()
            SetEntityCoords(PlayerPedId(), ipl.tp)
        end, false,
        27,
        0.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleEntrer"
    )
    zone.addZone("tpipl_exit_" .. name,
        vector3(ipl.tp.x, ipl.tp.y, ipl.tp.z + 1.0),
        "~INPUT_CONTEXT~ Sortir",
        function()
            SetEntityCoords(PlayerPedId(), vector3(enterCoords.x, enterCoords.y, enterCoords.z - 1.0))
        end, false,
        27,
        0.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleSortir"
    )
end

Citizen.CreateThread(function()
    Wait(1103)
    listTpIpl = TriggerServerCallback('core:events:getListTpIpl')

    while p == nil do Wait(1) end
    while listTpIpl == nil or next(listTpIpl) == nil do Wait(100) end

    for k,v in pairs(listTpIpl) do
        createTpIp(k, v.enter, v.ipl)
    end
end)

RegisterNetEvent('core:events:createTpIpl')
AddEventHandler('core:events:createTpIpl', function(name, enterCoords, ipl)
    listTpIpl[name] = {
        enter = enterCoords,
        ipl = ipl
    }
    createTpIp(name, enterCoords, ipl)
    --subSousIPLmenu.refresh()
end)

RegisterNetEvent('core:events:deleteTpIpl')
AddEventHandler('core:events:deleteTpIpl', function(name)
    listTpIpl[name] = nil
    zone.removeZone("tpipl_enter_" .. name)
    zone.removeBulle("tpipl_enter_" .. name)
    zone.removeZone("tpipl_exit_" .. name)
    zone.removeBulle("tpipl_exit_" .. name)
    --subSousIPLmenu.refresh()
    --subSousTpIPLmenu.refresh()
end)
