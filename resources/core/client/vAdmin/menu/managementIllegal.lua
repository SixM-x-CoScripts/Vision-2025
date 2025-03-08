local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local CurrentFiltre5 = nil

local crewTypes = {"normal", "pf", "gang", "mc", "orga", "mafia"}
local crewTypesList = 1

local typeLabs, labs = nil, nil
local labsType = {"coke", "weed", "meth", "fentanyl"}
local labsTypeList = 1

local selected = 1
local options = {"TP", "Supprimer"}

local isPermFive = false

function renderManagementIllegal()
    vAdminManagementIllegal.Button(
        "Créer",
        "un crew",
        nil,
        "chevron",
        false,
        function()
            local typeCrew = KeyboardImput("normal - pf - gang - mc - orga - mafia")
            local idPlayer = KeyboardImput("ID Joueur In Game")
            if typeCrew and idPlayer and (string.lower(typeCrew) == "normal" or string.lower(typeCrew) == "pf" or string.lower(typeCrew) == "gang" or string.lower(typeCrew) == "mc" or string.lower(typeCrew) == "orga" or string.lower(typeCrew) == "mafia") then
                if p:getPermission() >= 3 then
                    TriggerServerEvent("core:createCrewCreation", idPlayer, string.lower(typeCrew))
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "vous n'avez pas les permissions"
                    })
                end
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Commande incomplète remplir les deux champs avec les bonnes infos"
                })
            end
        end
    )
    vAdminManagementIllegal.Button(
        "Gestion",
        "des crew",
        nil,
        "chevron",
        false,
        function()end,
        vAdminManagementIllegalCrew
    )

    vAdminManagementIllegal.Button(
        "Gestion",
        "des territoires",
        nil,
        "chevron",
        false,
        function()end,
        vAdminManagementTerritoire
    )
end

function renderManagementTerritoire()
    vAdminManagementTerritoire.Button(
        "Liste",
        "des territoires",
        nil,
        "chevron",
        false,
        function()end,
        vAdminManagementTerritoireGestion
    )
    vAdminManagementTerritoire.Button(
        "Créer",
        "un territoire",
        nil,
        "chevron",
        false,
        function()end,
        vAdminManagementTerritoireCreation
    )
end

local terName = "Aucun"
local nbPoint = 0
local coords = nil
local showZone = false
local zonePoints = {}

local x1, y1, z1, x2, y2, z2 = nil, nil, nil, nil, nil, nil
local j = 0

function renderManagementTerritoireCreation()

    vAdminManagementTerritoireCreation.Separator("      Nom  : "..terName)

    vAdminManagementTerritoireCreation.Button(
        "Définir",
        "un nom",
        nil,
        "chevron",
        false,
        function()
            terName = KeyboardImput("Entrer un nom de territoire")
            terName = tostring(terName)
            vAdminManagementTerritoireCreation.refresh()
        end
    )
    vAdminManagementTerritoireCreation.Button(
        "Définir",
        "les points",
        nil,
        "chevron",
        false,
        function()end,
        vAdminManagementTerritoireCreationZone
    )
    
    if terName ~= "Aucun" and #zonePoints >=3 then
        vAdminManagementTerritoireCreation.Separator()
        vAdminManagementTerritoireCreation.Button(
            "Créer",
            "la zone "..terName,
            nil,
            "chevron",
            false,
            function()
                DrawZoneValue = false
                showZone = false
                local inSouth = coordsIsInSouth(zonePoints[1])
                TriggerServerEvent("core:Territoire:creation", terName, zonePoints, inSouth)
                Citizen.Wait(200)
                nbPoint = 0
                terName = "Aucun"
                zonePoints = {}
            end,
            vAdminManagementTerritoire
        )
    end
end

function renderManagementTerritoireCreationZone()

    vAdminManagementTerritoireCreationZone.Checkbox(
        "Afficher",
        "la zone",
        false,
        showZone,
        function(checked)
            showZone = checked
            if showZone then
                DrawZoneValue = true
                Citizen.CreateThread(function()
                    while DrawZoneValue do
                        Citizen.Wait(0)
                        for i = 1, #zonePoints do
                            j = i + 1
                            if j > #zonePoints then
                                j = 1
                            end
                    
                            x1, y1, z1 = zonePoints[i].x, zonePoints[i].y, zonePoints[i].z-20.0
                            x2, y2, z2 = zonePoints[j].x, zonePoints[j].y, zonePoints[j].z-20.0
                            DrawWall(x1, y1, z1, x2, y2, z2, 0, 255, 0, 180)
                        end
                    end
                end)
            else
                DrawZoneValue = false
            end
        end
    )

    vAdminManagementTerritoireCreationZone.Button(
        "Ajouter",
        "un point",
        nil,
        "chevron",
        false,
        function()
            nbPoint += 1
            coords = GetEntityCoords(PlayerPedId())
            zonePoints[nbPoint] = coords
        end
    )

    vAdminManagementTerritoireCreationZone.Button(
        "Supprimer",
        "le dernier point",
        nil,
        "chevron",
        false,
        function()
            zonePoints[nbPoint] = nil
            nbPoint -= 1
            for k,v in pairs(zonePoints) do
                print(k, v)
            end
        end
    )
end

local territoires = nil
local terSelect = nil 

function renderManagementTerritoireGestion(territoires)
    territoires = nil 
    territoires = TriggerServerCallback("core:Territoire:GetTerritoires")
    while territoires == nil do Citizen.Wait(0) end

    if territoires == nil then
        vAdminManagementTerritoireGestion.Separator("Aucun", "territoire à afficher")
    else
        for k,v in pairs(territoires) do
            vAdminManagementTerritoireGestion.Button(
                "",
                k,
                v.id,
                "chevron",
                false,
                function()
                    terSelect = nil
                    v.name = k
                    terSelect = v
                end,
                vAdminManagementTerritoireGestionInfo
            )
        end
    end
end

local deleteConfirmation = nil

function renderManagementTerritoireGestionInfo()
    while terSelect == nil do Citizen.Wait(10) end
    vAdminManagementTerritoireGestionInfo.Title(
        "",
        terSelect.name,
        "ID",
        terSelect.id
    )
    vAdminManagementTerritoireGestionInfo.Separator()
    
    vAdminManagementTerritoireGestionInfo.Button(
        "Ajouter de",
        "l'influence",
        nil,
        "chevron",
        false,
        function()
            local confirmInfluence = KeyboardImput("Nom du crew")
            local nombreinfluence = KeyboardImput("Nombre d'influence à supprimé")

            if confirmInfluence and confirmInfluence ~= "" then
                local crewExists = TriggerServerCallback("core:crew:getCrewByName", confirmInfluence)
                if crewExists then
                    TriggerServerEvent("core:territoire:UpdateTerritoire", confirmInfluence, terSelect.name, tonumber(nombreinfluence))
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        content = "~c Vous avez rajouté "..nombreinfluence.." d'influence au crew " .. confirmInfluence
                    })
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        content = "Le crew n'existe pas, vérifiez les bonnes majuscules etc..."
                    })
                end
            end
        end
    
    )
    
    
    vAdminManagementTerritoireGestionInfo.Button(
        "Supprimer de",
        "l'influence",
        nil,
        "chevron",
        false,
        function()
            local confirmInfluence = KeyboardImput("Nom du crew")
            local nombreinfluence = KeyboardImput("Nombre d'influence à enlever")

            if confirmInfluence and confirmInfluence ~= "" then
                local crewExists = TriggerServerCallback("core:crew:getCrewByName", confirmInfluence)
                if crewExists then
                    local newnbr = tonumber(nombreinfluence)
                    TriggerServerEvent("core:territoire:UpdateTerritoire", confirmInfluence, terSelect.name, -newnbr)
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        content = "~c Vous avez enlevé "..nombreinfluence.." d'influence au crew " .. confirmInfluence
                    })
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        content = "Le crew n'existe pas, vérifiez les bonnes majuscules etc..."
                    })
                end
            end
        end
    
    )

    vAdminManagementTerritoireGestionInfo.Button(
        "Supprimer",
        "l'influence",
        nil,
        "chevron",
        false,
        function()
            local confirmInfluence = KeyboardImput("Confirmer la suppression de l'influence du territoire ? (oui/non)")

            if string.lower(confirmInfluence) == "oui" then
                TriggerServerEvent("core:Territoire:suppressionInfluence", terSelect.name, terSelect.id)
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~c Influence supprimée"
                })
            end
        end
    
    )

    vAdminManagementTerritoireGestionInfo.Button(
        "Supprimer",
        "le territoire",
        nil,
        "chevron",
        false,
        function()
            deleteConfirmation = KeyboardImput("Confirmer la suppression du territoire ? (oui/non)")

            if string.lower(deleteConfirmation) == "oui" then
                TriggerServerEvent("core:Territoire:suppression", terSelect.name, terSelect.id)
                vAdminManagementTerritoireGestion.open()
            end
        end
    
    )
end

function renderManagementIllegalCrew()

    if vAdminAllCrews == nil then
        vAdminManagementIllegalCrew.Separator("Aucun", "crew à afficher")
        return
    end

    vAdminManagementIllegalCrew.Button(
        CurrentFiltre5 == nil and "Rechercher" or "Recherche",
        CurrentFiltre5 == nil and "un crew par nom" or CurrentFiltre5,
        nil,
        "search",
        false,
        function()
            if CurrentFiltre5 == nil then
                CurrentFiltre5 = nil
                local TargetCrew = KeyboardImput("Entrer un nom de crew")
                TargetCrew = tostring(TargetCrew)
                if TargetCrew ~= nil and string.len(TargetCrew) ~= 0 then
                    if type(TargetCrew) == 'string' then
                        CurrentFiltre5 = TargetCrew
                    
                        vAdminManagementIllegalCrew.refresh()
                    end
                else
                    CurrentFiltre5 = nil
                
                    vAdminManagementIllegalCrew.refresh()
                end
            else
                CurrentFiltre5 = nil

                vAdminManagementIllegalCrew.refresh()
            end
        end
    )
    
    vAdminManagementIllegalCrew.Separator(nil)
    
    print(json.encode(vAdminAllCrews))

    for k,v in pairs(vAdminAllCrews) do
        if CurrentFiltre5 ~= nil then
            if v == tonumber(CurrentFiltre5) or string.find(string.lower(v.name), string.lower(tostring(CurrentFiltre5))) then
                vAdminManagementIllegalCrew.Button(
                    v.typeCrew or "Inconnu",
                    v.name or "Inconnu",
                    v.id or "Inconnu",
                    "chevron",
                    false,
                    function()
                        vAdminCrewInfo = TriggerServerCallback("core:crew:getCrewByName", v.name)
                        vAdminLevelCrew = TriggerServerCallback("core:crew:getCrewLevelByName", v.name)
                        vAdminXpCrew = TriggerServerCallback("core:crew:getCrewXpByName", v.name)
                    end,
                    vAdminManagementIllegalCrewInfo
                )
            end
        else
            vAdminManagementIllegalCrew.Button(
                v.typeCrew or "Inconnu",
                v.name or "Inconnu",
                v.id or "Inconnu",
                "chevron",
                false,
                function()
                    vAdminCrewInfo = TriggerServerCallback("core:crew:getCrewByName", v.name)
                    vAdminLevelCrew = TriggerServerCallback("core:crew:getCrewLevelByName", v.name)
                    vAdminXpCrew = TriggerServerCallback("core:crew:getCrewXpByName", v.name)
                end,
                vAdminManagementIllegalCrewInfo
            )
        end
    end
end

function renderManagementIllegalCrewInfo()
    isPermFive = p:getPermission() >= 5

    vAdminManagementIllegalCrewInfo.Title(vAdminCrewInfo.typeCrew, vAdminCrewInfo.name, "ID", vAdminCrewInfo.id)
    vAdminManagementIllegalCrewInfo.Textbox(vAdminCrewInfo.devise, "Devise")
    vAdminManagementIllegalCrewInfo.Separator(
        "Expérience",
        vAdminXpCrew,
        "Level",
        vAdminLevelCrew
    )

    vAdminManagementIllegalCrewInfo.Button(
        "Membres",
        "du crew",
        nil,
        "chevron",
        false,
        function() 
            vAdminPlayersInfo = vAdminCrewInfo.members
        end,
        vAdminManagementIllegalCrewMembers
    )
    vAdminManagementIllegalCrewInfo.Button(
        "Changer",
        "le nom",
        nil,
        "chevron",
        false,
        function() 
            if isPermFive then 
                local newName = KeyboardImput("Nouveau Nom")
                if not newName or string.len(newName) == 0 then return end
                TriggerServerEvent("core:crew:changeName", token, vAdminCrewInfo.name, newName)
                vAdminCrewInfo.name = newName

                vAdminManagementIllegalCrewInfo.refresh()

                exports['vNotif']:createNotification({
                    type = "VERT",
                    content = "Le nom du crew a été changé avec succès en " .. newName .. " !"
                })
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Vous n'avez pas la permission de faire cela !"
                })
            end
        end
    )
    vAdminManagementIllegalCrewInfo.Button(
        "Changer",
        "la devise",
        nil,
        "chevron",
        false,
        function() 
            if isPermFive then 
                local devise = KeyboardImput("Nouvelle Devise")
                if not devise or string.len(devise) == 0 then return end
                TriggerServerEvent("core:crew:changeDevise", token, vAdminCrewInfo.name, devise)
                vAdminCrewInfo.devise = devise

                vAdminManagementIllegalCrewInfo.refresh()

                exports['vNotif']:createNotification({
                    type = "VERT",
                    content = "La devise du crew a été changé avec succès en " .. devise .. " !"
                })
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Vous n'avez pas la permission de faire cela !"
                })
            end
        end
    )
    vAdminManagementIllegalCrewInfo.Button(
        "Changer",
        "la couleur",
        vAdminCrewInfo.color,
        "chevron",
        false,
        function() 
            if isPermFive then 
                local color = KeyboardImput("Nouvelle Couleur")
                if not color or string.len(color) == 0 then return end
                TriggerServerEvent("core:crew:changeColor", token, vAdminCrewInfo.name, color)
                vAdminCrewInfo.color = color

                vAdminManagementIllegalCrewInfo.refresh()

                exports['vNotif']:createNotification({
                    type = "VERT",
                    content = "La couleur du crew a été changé avec succès en " .. color .. " !"
                })
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Vous n'avez pas la permission de faire cela !"
                })
            end
        end
    )
    vAdminManagementIllegalCrewInfo.Button(
        "Ajouter",
        "de l'expérience",
        nil,
        "chevron",
        false,
        function() 
            if isPermFive then 
                local xp = KeyboardImput("Expérience à ajouter")
                if not xp or string.len(xp) == 0 then return end
                TriggerSecurEvent("core:crew:updateXp", token, tonumber(xp), "add", vAdminCrewInfo.name, "admin")
                vAdminLevelCrew = TriggerServerCallback("core:crew:getCrewLevelByName", vAdminCrewInfo.name)
                vAdminXpCrew = TriggerServerCallback("core:crew:getCrewXpByName", vAdminCrewInfo.name)

                vAdminManagementIllegalCrewInfo.refresh()

                exports['vNotif']:createNotification({
                    type = "VERT",
                    content = xp .. " d'expérience a été ajouté avec succès au crew !"
                })
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Vous n'avez pas la permission de faire cela !"
                })
            end
        end
    )
    vAdminManagementIllegalCrewInfo.Button(
        "Retirer",
        "de l'expérience",
        nil,
        "chevron",
        false,
        function() 
            if isPermFive then 
                local xp = KeyboardImput("Expérience à retirer")
                if not xp or string.len(xp) == 0 then return end
                TriggerSecurEvent("core:crew:updateXp", token, tonumber(xp), "remove", vAdminCrewInfo.name, "admin")
                vAdminLevelCrew = TriggerServerCallback("core:crew:getCrewLevelByName", vAdminCrewInfo.name)
                vAdminXpCrew = TriggerServerCallback("core:crew:getCrewXpByName", vAdminCrewInfo.name)

                vAdminManagementIllegalCrewInfo.refresh()

                exports['vNotif']:createNotification({
                    type = "VERT",
                    content = xp .. " d'expérience a été retiré avec succès au crew !"
                })
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Vous n'avez pas la permission de faire cela !"
                })
            end
        end
    )
    vAdminManagementIllegalCrewInfo.List(
        "Changer",
        "le type de crew",
        false,
        crewTypes,
        crewTypesList,
        function(index, item)
            if isPermFive then
                TriggerServerEvent("core:crew:changeTypeCrew", token, vAdminCrewInfo.name, crewTypes[index])

                vAdminManagementIllegalCrewInfo.refresh()

                exports['vNotif']:createNotification({
                    type = "VERT",
                    content = "Le type de crew a été changé avec succès en " .. crewTypes[index] .. " !"
                })
            else
                exports['vNotif']:createNotification({
                    type = "ROUGE",
                    content = "Vous n'avez pas la permission de faire cela !"
                })
            end
        end
    )

    vAdminManagementIllegalCrewInfo.Button(
        "Laboratoires",
        "",
        nil,
        "lock",
        true,
        function() 
            vAdminLabs = TriggerServerCallback("core:labo:hasLabs", vAdminCrewInfo.name)
        end,
        vAdminManagementIllegalCrewLabs
    )
    vAdminManagementIllegalCrewInfo.Button(
        "Propriétés",
        "",
        nil,
        "chevron",
        false,
        function() 
            vAdminProperty = TriggerServerCallback("core:getPropertyCrew", vAdminCrewInfo.name)
        end,
        vAdminManagementIllegalCrewProperty
    )
    vAdminManagementIllegalCrewInfo.Button(
        "Véhicules",
        "",
        nil,
        "chevron",
        false,
        function() 
            vAdminVehicle = TriggerServerCallback("core:vehicle:getCrewVeh", vAdminCrewInfo.name)
        end,
        vAdminManagementIllegalCrewVehicle
    )

    vAdminManagementIllegalCrewInfo.Separator(nil)

    vAdminManagementIllegalCrewInfo.Button(
        "Supprimer",
        "le crew",
        nil,
        "chevron",
        false,
        function() 
            if isPermFive then 
                local deleteConfirmation = KeyboardImput("Confirmer la suppression du crew ? (oui/non)")

                if string.lower(deleteConfirmation) == 'oui' then 
                    TriggerServerEvent("core:crew:deleteCrew", token, vAdminCrewInfo.name, true)

                    exports['vNotif']:createNotification({
                        type = "VERT",
                        content = "Le crew a été supprimé avec succès !"
                    })
                    
                    vAdminAllCrews = nil
                    vAdminAllCrews = TriggerServerCallback("core:crew:getAllCrew")

                    vAdminManagementIllegalCrew.open()
                end
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Vous n'avez pas la permission de faire cela !"
                })
            end
        end
    )
    vAdminManagementIllegalCrewInfo.Button(
        "Supprimer",
        "le crew et wipe les joueurs",
        nil,
        "chevron",
        false,
        function() 
            if isPermFive then 
                local deleteConfirmation = ChoiceInput("Confirmer la suppression du crew et wipe les joueurs ? (Avec accord STAFF)")

                if deleteConfirmation == true then 
                    local idbdds = {}

                    for k, v in pairs(vAdminCrewInfo.members) do
                        table.insert(idbdds, v.id)
                    end

                    TriggerServerEvent("core:crew:wipePlayers", token, idbdds)
                    TriggerServerEvent("core:crew:deleteCrew", token, vAdminCrewInfo.name, false)

                    exports['vNotif']:createNotification({
                        type = "VERT",
                        content = "Le crew et les joueurs ont été supprimé avec succès !"
                    })

                    vAdminAllCrews = nil
                    vAdminAllCrews = TriggerServerCallback("core:crew:getAllCrew")

                    vAdminManagementIllegalCrew.open()
                end
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Vous n'avez pas la permission de faire cela !"
                })
            end
        end
    )

end

function renderManagementIllegalCrewLabs()

    vAdminManagementIllegalCrewLabs.Title(
        "Laboratoires",
        vAdminCrewInfo.name or "Inconnu"
    )

    if not vAdminLabs then
        vAdminManagementIllegalCrewLabs.List(
            "Créer",
            "un labo de type",
            false,
            labsType,
            labsTypeList,
            function(index, item)
                TriggerServerEvent("core:CreateLaboratory", vAdminCrewInfo.name, GetEntityCoords(PlayerPedId()), labsType[index])
            
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "Le labo a été créé !"
                })

                vAdminManagementIllegalCrewLabs.refresh()
            end
        )
    else
        if vAdminLabs.minutes and vAdminLabs.minutes ~= 0 then
            vAdminManagementIllegalCrewLabs.Title(
                "Production",
                "en cours",
                "Temps restant",
                vAdminLabs.minutes
            )
        end

        vAdminManagementIllegalCrewLabs.Button(
            "TP",
            "au laboratoire",
            nil,
            "chevron",
            false,
            function()
                local posLabs = json.decode(vAdminLabs.data).coords
                SetEntityCoords(PlayerPedId(), posLabs.x, posLabs.y, posLabs.z)
            end
        )

        vAdminManagementIllegalCrewLabs.Separator(nil)

        vAdminManagementIllegalCrewLabs.Button(
            "Supprimer",
            "le laboratoire",
            nil,
            "chevron",
            false,
            function()
                local deleteConfirmation = KeyboardImput("Confirmer la suppression du labo ? (oui/non)")

                if string.lower(deleteConfirmation) == "oui" then
                    TriggerServerEvent("core:labo:deleteLabo", token, vAdminLabs.id)
                    vAdminManagementIllegalCrewInfo.open()
                end
            end
        )
    end

end

function renderManagementIllegalCrewMembers()

    vAdminManagementIllegalCrewMembers.Title(
        "Membres du Crew",
        vAdminCrewInfo.name or "Inconnu"
    )

    for k, v in pairs(vAdminPlayersInfo) do
        vAdminManagementIllegalCrewMembers.Button(
            v.firstName .. " " .. v.lastName,
            "",
            v.id,
            "chevron",
            false,
            function()
                TriggerServerEvent("core:crew:removePlayerFromCrew", token, vAdminCrewInfo.name, v.id)
                vAdminCrewInfo = TriggerServerCallback("core:crew:getCrewByName", vAdminCrewInfo.name)
                vAdminPlayerInfo = vAdminCrewInfo.members

                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "Le joueur a été retiré du crew !"
                })

                vAdminManagementIllegalCrewMembers.refresh()
            end
        )
    end

end

function renderManagementIllegalCrewProperty()

    vAdminManagementIllegalCrewProperty.Title(
        "Propriétés du Crew",
        vAdminCrewInfo.name or "Inconnu"
    )

    for k, v in pairs(vAdminProperty) do
        vAdminManagementIllegalCrewProperty.List(
            v.name,
            v.type,
            false,
            options,
            selected,
            function(index, item)
                if index == 1 then
                    SetEntityCoords(PlayerPedId(), vAdminProperty.enter_pos.x, vAdminProperty.enter_pos.y, vAdminProperty.enter_pos.z)
                elseif index == 2 then
                    local deleteConfirmation = KeyboardImput("Supprimer la propriété ? (oui/non)")

                    if string.lower(deleteConfirmation) ~= "oui" then return end

                    TriggerServerEvent("core:property:delete", token, vAdminProperty.id)
                    vAdminProperty = TriggerServerCallback("core:getPropertyCrew", vAdminCrewInfo.name)

                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        content = "La propriété a été retiré du crew !"
                    })

                    vAdminManagementIllegalCrewProperty.refresh()
                end
            end
        )
    end

end

function renderManagementIllegalCrewVehicle()

    vAdminManagementIllegalCrewVehicle.Title(
        "Véhicules du Crew",
        vAdminCrewInfo.name or "Inconnu"
    )

    for k, v in pairs(vAdminVehicle) do
        vAdminManagementIllegalCrewVehicle.Button(
            v.name,
            "",
            v.currentPlate,
            "chevron",
            false,
            function()
                TriggerServerEvent("core:deleteVehCrew", v.plate)
                vAdminVehicle = TriggerServerCallback("core:vehicle:getCrewVeh", vAdminCrewInfo.name)

                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "Le véhicule a été retiré du crew !"
                })

                vAdminManagementIllegalCrewVehicle.refresh()
            end
        )
    end

end