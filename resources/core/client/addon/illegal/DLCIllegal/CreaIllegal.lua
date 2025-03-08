local VUI = exports["VUI"]

local Chosen = {}
local TableRank = {"S", "A", "B", "C", "D"}
local TableRisque = {"1", "2", "3", "4", "5"}
local TableJoueurs = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"}

AllScripts = {
    ["Braquage"] = {
        func = function()

        end
    },
    ["Vol"] = {
        func = function()

        end
    },
    ["Vente"] = {
        func = function()

        end
    },
    ["Tag"] = {
        func = function()

        end
    },
    ["Pyromane"] = {
        func = function()

        end
    },
    ["Transport"] = {
        func = function()

        end
    },
    ["Otage"] = {
        func = function()

        end
    },
}

AllScriptNames = {}
for k,v in pairs(AllScripts) do 
    table.insert(AllScriptNames, k)
end

local main = VUI:CreateMenu("Gestion Illegale", "administration", true)
local missions = VUI:CreateSubMenu(main, "Gestion Illegale", "administration", true)
local tags = VUI:CreateSubMenu(missions, "Gestion Illegale", "administration", true)

RegisterCommand("illegal", function()
    if p and p:getPermission() >= 4 then 
        main.open()        
    else
        print("Vous n'avez pas les permissions")
    end
end)


main.OnOpen(function()
    main.Button(
        "Créer une mission",
        "illégale",
        nil,
        "chevron",
        false,
        function()

        end,
        missions
    )
    main.Separator(nil)
    main.Button(
        "Liste des missions",
        "illégales",
        nil,
        "chevron",
        false,
        function()
            
        end
    )
end)


missions.OnOpen(function()
    missions.Button(
        "Créer une mission",
        nil,
        nil,
        "chevron",
        false,
        function()

        end,
        tags
    )
end)

local typeD = "Mission"

local function makeDefaultButtons(typefunc)
    typefunc.Button(
        "Nom de la mission",
        typeD and typeD or "Aucun",
        nil,
        "chevron",
        false,
        function()
            local gainS = KeyboardImput("Nom de la mission", "")
            if not gainS then return end
            if gainS == "" then return end
            typeD = gainS
            Chosen[typeD] = {}
            tags.refresh()
        end
    )
    typefunc.Button(
        "Banniere de la mission",
        Chosen[typeD] and Chosen[typeD].Banniere and Chosen[typeD].Banniere or "Aucune",
        nil,
        "chevron",
        false,
        function()
            local gainS = KeyboardImput("URL de la bannière", "")
            if not gainS then return end
            if gainS == "" then return end
            Chosen[typeD].Banniere = gainS
            tags.refresh()
        end
    )
    typefunc.Button(
        "Gains",
        Chosen[typeD] and Chosen[typeD].Gain or "0",
        nil,
        "chevron",
        false,
        function()
            if not Chosen[typeD] then 
                Chosen[typeD] = {}
            end
            local gainS = KeyboardImput("Gains", "")
            if not gainS then return end
            if gainS == "" then return end
            Chosen[typeD].Gain = gainS
            tags.refresh()
        end
    ) 
    typefunc.List(
        "Rang",
        nil,
        --Chosen[typeD] and Chosen[typeD].Rank or "D",
        nil,
        TableRank,
        false,
        function(index, item)
            if not Chosen[typeD] then 
                Chosen[typeD] = {}
            end
            Chosen[typeD].Rank = TableRank[index]
        end
    )
    typefunc.List(
        "Risque",
        nil,
        --Chosen[typeD] and Chosen[typeD].Risque or "1",
        nil,
        TableRisque,
        false,
        function(index, item)
            if not Chosen[typeD] then 
                Chosen[typeD] = {}
            end
            Chosen[typeD].Risque = TableRisque[index]
        end
    )
    typefunc.Button(
        "Influence",
        Chosen[typeD] and Chosen[typeD].Influence or "0",
        nil,
        "chevron",
        false,
        function()
            if not Chosen[typeD] then 
                Chosen[typeD] = {}
            end
            local influ = KeyboardImput("Influence a attribué", "")
            if not influ then return end
            if influ == "" then return end
            Chosen[typeD].Influence = influ
            tags.refresh()
        end
    )
    typefunc.Button(
        "Item nécessaires",
        Chosen[typeD] and Chosen[typeD].ItemNeeded and #Chosen[typeD].ItemNeeded .. " Items" or "Aucun",
        nil,
        "chevron",
        false,
        function()
            if not Chosen[typeD] then 
                Chosen[typeD] = {}
            end
            local itrem = KeyboardImput("Nom de l'item nécessaire pour la mission", "")
            if not itrem then return end
            if itrem == "" then return end
            if not Chosen[typeD].ItemNeeded then 
                Chosen[typeD].ItemNeeded = {}
            end
            table.insert(Chosen[typeD].ItemNeeded, itrem)
            tags.refresh()
        end
    )
    typefunc.List(
        "Joueurs nécessaires",
        Chosen[typeD] and Chosen[typeD].PlayersNeeded or "1",
        nil,
        TableJoueurs,
        false,
        function(index, item)
            if not Chosen[typeD] then 
                Chosen[typeD] = {}
            end
            Chosen[typeD].PlayersNeeded = TableJoueurs[index]
        end
    )
    typefunc.List(
        "Etat",
        nil,
        nil,
        {"Solo", "Crew"},
        false,
        function(index, item)
            if not Chosen[typeD] then 
                Chosen[typeD] = {}
            end
            if index == 1 then 
                Chosen[typeD].Etat = "Solo"
            elseif index == 2 then
                Chosen[typeD].Etat = "Crew"
            end
            tags.refresh()
        end
    )
    typefunc.List(
        "Type de script",
        nil,
        nil,
        AllScriptNames,
        false,
        function(index, item)
            if not Chosen[typeD] then 
                Chosen[typeD] = {}
            end
            Chosen[typeD].Script = AllScripts[AllScriptNames[index]].func
            tags.refresh()
        end
    )
    --if Chosen[typeD].ItemNeeded then 
    --    for k,v in pairs(Chosen[typeD].ItemNeeded) do 
    --        
    --    end
    --end
end

tags.OnOpen(function()
    -- Ajouter 5 pos choisi par les staff
    -- Position du PNJ
    -- Mot qu'il doit tag
    makeDefaultButtons(tags)

    tags.Separator(nil)

    TriggerServerEvent("core:SendInfoMissionillegal", Chosen)

    if tag then
        tags.Button(
            "Choisir la position du PNJ",
            Chosen[typeD] and Chosen[typeD].PNJPos and "Placé" or "Non Placé",
            nil,
            "chevron",
            false,
            function()
                if not Chosen[typeD] then 
                    Chosen[typeD] = {}
                end
                local pos = KeyboardImput("Coller la position ex : -139.32, 55.51, 3.52", "")
                if not pos then return end
                if pos == "" then return end
                local x, y, z = pos:match("([^,]+),([^,]+),([^,]+)")
                print("x, y, z", x, y, z)
                Chosen[typeD].PNJPos = {}
                Chosen[typeD].PNJPos.x, Chosen[typeD].PNJPos.y, Chosen[typeD].PNJPos.z = x, y, z
                tags.refresh()
            end
        )
        
        tags.Button(
            "Choisir le mot à tagger",
            Chosen[typeD] and Chosen[typeD].MotATagger or "Mot",
            nil,
            "chevron",
            false,
            function()
                if not Chosen[typeD] then 
                    Chosen[typeD] = {}
                end
                local newMot = KeyboardImput("Spécifiez un titre", "")
                if not newMot then return end
                if newMot == "" then return end
                Chosen[typeD].MotATagger = newMot
                tags.refresh()
            end
        )

        tags.Button(
            "Position 1",
            Chosen[typeD] and Chosen[typeD].PositionUne and "Placé" or "Non Placé",
            nil,
            "chevron",
            false,
            function()
                if not Chosen[typeD] then 
                    Chosen[typeD] = {}
                end
                local pos = KeyboardImput("Coller la position ex : -139.32, 55.51, 3.52", "")
                if not pos then return end
                if pos == "" then return end
                local x, y, z = pos:match("([^,]+),([^,]+),([^,]+)")
                print("x, y, z", x, y, z)
                Chosen[typeD].PositionUne = {}
                Chosen[typeD].PositionUne.x, Chosen[typeD].PositionUne.y, Chosen[typeD].PositionUne.z = x, y, z
                tags.refresh()
            end
        )
        
        tags.Button(
            "Position 2",
            Chosen[typeD] and Chosen[typeD].PositionDeux and "Placé" or "Non Placé",
            nil,
            "chevron",
            false,
            function()
                if not Chosen[typeD] then 
                    Chosen[typeD] = {}
                end
                local pos = KeyboardImput("Coller la position ex : -139.32, 55.51, 3.52", "")
                if not pos then return end
                if pos == "" then return end
                local x, y, z = pos:match("([^,]+),([^,]+),([^,]+)")
                print("x, y, z", x, y, z)
                Chosen[typeD].PositionDeux = {}
                Chosen[typeD].PositionDeux.x, Chosen[typeD].PositionDeux.y, Chosen[typeD].PositionDeux.z = x, y, z
                tags.refresh()
            end
        )

        tags.Button(
            "Position 3",
            Chosen[typeD] and Chosen[typeD].PositionTrois and "Placé" or "Non Placé",
            nil,
            "chevron",
            false,
            function()
                if not Chosen[typeD] then 
                    Chosen[typeD] = {}
                end
                local pos = KeyboardImput("Coller la position ex : -139.32, 55.51, 3.52", "")
                if not pos then return end
                if pos == "" then return end
                local x, y, z = pos:match("([^,]+),([^,]+),([^,]+)")
                print("x, y, z", x, y, z)
                Chosen[typeD].PositionTrois = {}
                Chosen[typeD].PositionTrois.x, Chosen[typeD].PositionTrois.y, Chosen[typeD].PositionTrois.z = x, y, z
                tags.refresh()
            end
        )

        tags.Button(
            "Position 4",
            Chosen[typeD] and Chosen[typeD].PositionQuatre and "Placé" or "Non Placé",
            nil,
            "chevron",
            false,
            function()
                if not Chosen[typeD] then 
                    Chosen[typeD] = {}
                end
                local pos = KeyboardImput("Coller la position ex : -139.32, 55.51, 3.52", "")
                if not pos then return end
                if pos == "" then return end
                local x, y, z = pos:match("([^,]+),([^,]+),([^,]+)")
                print("x, y, z", x, y, z)
                Chosen[typeD].PositionQuatre = {}
                Chosen[typeD].PositionQuatre.x, Chosen[typeD].PositionQuatre.y, Chosen[typeD].PositionQuatre.z = x, y, z
                tags.refresh()
            end
        )

        tags.Button(
            "Position 5",
            Chosen[typeD] and Chosen[typeD].PositionCinq and "Placé" or "Non Placé",
            nil,
            "chevron",
            false,
            function()
                if not Chosen[typeD] then 
                    Chosen[typeD] = {}
                end
                local pos = KeyboardImput("Coller la position ex : -139.32, 55.51, 3.52", "")
                if not pos then return end
                if pos == "" then return end
                local x, y, z = pos:match("([^,]+),([^,]+),([^,]+)")
                print("x, y, z", x, y, z)
                Chosen[typeD].PositionCinq = {}
                Chosen[typeD].PositionCinq.x, Chosen[typeD].PositionCinq.y, Chosen[typeD].PositionCinq.z = x, y, z
                tags.refresh()
            end
        )
    end

end)