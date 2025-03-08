local VUI = exports["VUI"]

RegisterCommand("gestionboutique", function()
    if not p then return end
    if p:getPermission() >= 5 then 
        OpenCreaBoutique()
    else
        print("Permissions manquantes")
    end
end)

local selectedBoutique = 1; -- 1 = Boutique Vêtements Homme, 2 = Boutique Vêtemes Femme, 3 = Boutique de tout sauf vêtements
local selectedCategory = 1;
local selectedGlobalCategory = 1;
local selectedItem = 1;
local selectedVariation = 1;

local index = 1;

-- Menu

local main = VUI:CreateMenu("Gestion Boutique", "boutique", true)
local catalogues = VUI:CreateSubMenu(main, "Catalogue", "boutique", true)
local categories = VUI:CreateSubMenu(catalogues, "Catalogue / Catégories", "boutique", true)
local category = VUI:CreateSubMenu(categories, "Catégorie", "boutique", true)
local items = VUI:CreateSubMenu(category, "Catégorie / Items", "boutique", true)
local item = VUI:CreateSubMenu(items, "Item", "boutique", true)
local customFields = VUI:CreateSubMenu(item, "Custom Fields", "boutique", true)
local variations = VUI:CreateSubMenu(item, "Item / Variations", "boutique", true)
local variation = VUI:CreateSubMenu(variations, "Item / Varation", "boutique", true)

local function UpdateBoutique()
    --TriggerServerEvent("core:boutique:update", BoutiqueCatalogue)
    TriggerLatentServerEvent("core:boutique:update", 5000, BoutiqueCatalogue)

    exports['vNotif']:createNotification({
        type = 'VERT',
        content = "Boutique mise à jour !"
    })
end

function renderMainMenu()
    main.Button(
        "Catalogue",
        "Homme",
        nil,
        "chevron",
        false,
        function()
            selectedBoutique = 1
        end,
        catalogues
    )
    main.Button(
        "Catalogue",
        "Femme",
        nil,
        "chevron",
        false,
        function()
            selectedBoutique = 2
        end,
        catalogues
    )
    main.Button(
        "Catalogue",
        "Autre",
        nil,
        "chevron",
        false,
        function()
            selectedBoutique = 3
        end,
        catalogues
    )

    main.Separator(nil)

    main.Button(
        "Sauvegarder",
        "les modifications",
        nil,
        "check",
        false,
        function()
            UpdateBoutique()
        end
    )
end

function renderCatalogues()
    for k,v in pairs(BoutiqueCatalogue) do
        local cataName = "Inconnu"

        if selectedBoutique == 1 then
            cataName = CatalogueIndexes[k] or "Inconnu"
        elseif selectedBoutique == 2 then
            cataName = CatalogueIndexes[k] or "Inconnu"
        elseif selectedBoutique == 3 then
            cataName = CatalogueIndexes[k + 3] or "Inconnu"
        end

        catalogues.Button(
            cataName,
            nil,
            nil,
            "chevron",
            false,
            function()
                selectedGlobalCategory = k
            end,
            categories
        )
    end
end

function renderCategories()
    if BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory] == nil then
        BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory] = {}

        categories.Separator("Aucunes", "catégories à afficher")
    end

    for k,v in pairs(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory]) do
        categories.Button(
            v.title,
            nil,
            nil,
            "chevron",
            false,
            function()
                selectedCategory = k
            end,
            category
        )
    end

    categories.Button(
        "Ajouter",
        "une catégorie",
        nil,
        "chevron",
        false,
        function()
            print("Ajout d'une catégorie")
            local newTitle = KeyboardImput("Spécifiez un titre", "")
            if not newTitle then return end

            local newSubtitle = KeyboardImput("Spécifiez un sous-titre", "")
            if not newSubtitle then return end

            local newImage = KeyboardImput("Spécifiez une image (URL)", "")
            if not newImage then return end

            table.insert(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory], {
                title = newTitle,
                subtitle = newSubtitle,
                image = newImage,
                new = false,
                items = {}
            })
        end
    )
end

function renderCategory()
    category.Separator("Catégorie", "", BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].title)

    if BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].image ~= nil then
        category.Imagebox(
            BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].image,
            BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].image2 or nil,
            false
        )
    end

    category.Button(
        "Modifier",
        "le titre",
        BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].title,
        "chevron",
        false,
        function()
            local newTitle = KeyboardImput("Spécifiez un titre", "")
            if not newTitle then return end

            if newTitle then 
                BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].title = newTitle
            end
        end
    )

    if BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].subtitle ~= nil then
        category.Button(
            "Modifier",
            "le sous-titre",
            BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].subtitle,
            "chevron",
            false,
            function()
                local newSubtitle = KeyboardImput("Spécifiez un sous-titre", "")
                if not newSubtitle then return end
    
                if newSubtitle then
                    BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].subtitle = newSubtitle
                end
            end
        )
    else
        category.Button(
            "Ajouter",
            "un sous-titre",
            nil,
            "chevron",
            false,
            function()
                local newSubtitle = KeyboardImput("Spécifiez un sous-titre", "")
                if not newSubtitle then return end
    
                if newSubtitle then
                    BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].subtitle = newSubtitle
                end
            end
        )
    end

    category.Button(
        "Modifier",
        "l'image",
        BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].image,
        "chevron",
        false,
        function()
            local newImage = KeyboardImput("Spécifiez une image (URL)", "")
            if not newImage then return end

            if newImage then
                BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].image = newImage
            end
        end
    )
    category.Checkbox(
        "Bandeau",
        "nouveauté",
        false,
        BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].new,
        function(checked)
            BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].new = checked
        end
    )
    category.Button(
        "Voir",
        "les items",
        nil,
        "chevron",
        false,
        function()end,
        items
    )
    category.Button(
        "Supprimer",
        "la catégorie",
        nil,
        "chevron",
        false,
        function()
            table.remove(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory], selectedCategory)
            selectedCategory = 1
        end,
        categories
    )
end

function renderItems()
    items.Separator("Catégorie", "", BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].title)

    for k,v in pairs(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items) do
        items.Button(
            v.name,
            nil,
            nil,
            "chevron",
            false,
            function()
                selectedItem = k
            end,
            item
        )
    end
    
    items.Separator(nil)

    items.Button(
        "Ajouter",
        "un item",
        nil,
        "chevron",
        false,
        function()
            local newName = KeyboardImput("Spécifiez un nom", "")
            if not newName then return end

            local newImage = KeyboardImput("Spécifiez une image", "")
            if not newImage then return end

            if selectedGlobalCategory == 4 then
                table.insert(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items, {
                    name = newName,
                    image = newImage,
                    customFields = {"Ecriture", "Logo"},
                    variations = {
                        {
                            icon = "",
                            color = "#AFC0B6",
                            color2 = "#FFFFFF",
                            label = "White"
                        },
                        {
                            icon = "",
                            label = "Blue",
                            color = "#051A66",
                            color2 = "#0362F1"
                        },
                        {
                            icon = "",
                            label = "Green",
                            color = "#0E551D",
                            color2 = "#00C92C",
                        },
                        {
                            icon = "",
                            label = "Red",
                            color = "#7A2929",
                            color2 = "#D70909"
                        },
                        {
                            icon = "",
                            label = "Black",
                            color = "#000000",
                            color2 = "#7D7D7D"
                        }
                    },
                    price = 2500
                })
            else
                table.insert(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items, { name = newName, image = newImage, customFields = {}, variations = {} })
            end
        end
    )

end

function renderItem()
    item.Separator("Item", "", BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].name)

    if BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].image ~= nil then
        item.Imagebox(
            BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].image,
            BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].image2 or nil,
            false
        )
    end

    item.Button(
        "Modifier",
        "le nom",
        BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].name,
        nil,
        false,
        function()
            local newName = KeyboardImput("Spécifiez un nom", "")
            if not newName then return end

            if newName then
                BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].name = newName
            end
        end
    )
    item.Button(
        "Modifier",
        "l'image",
        BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].image,
        nil,
        false,
        function()
            local newImage = KeyboardImput("Spécifiez une image (URL)", "")
            if not newImage then return end

            if newImage then
                BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].image = newImage
            end
        end
    )

    if BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].image2 then
        item.Button(
            "Modifier",
            "l'image 2",
            BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].image2,
            nil,
            false,
            function()
                local newImage = KeyboardImput("Spécifiez une image (URL)", "")
                if not newImage then return end
    
                if newImage then
                    BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].image2 = newImage
                end
            end
        )
    else 
        item.Button(
            "Ajouter",
            "une image 2",
            nil,
            nil,
            false,
            function()
                local newImage = KeyboardImput("Spécifiez une image (URL)", "")
                if not newImage then return end
    
                if newImage then
                    BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].image2 = newImage
                end
            end
        )
    end

    if BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].price == nil then
        BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].price = 2500
    end

    item.Button(
        "Modifier",
        "le prix",
        BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].price,
        nil,
        false,
        function()
            local newPrice = KeyboardImput("Spécifiez un prix", "")
            if not newPrice then return end

            if newPrice then
                BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].price = newPrice
            end
        end
    )

    if BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].reduction ~= nil then
        item.Button(
            "Modifier",
            "la réduction",
            BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].reduction,
            nil,
            false,
            function()
                local newReduction = KeyboardImput("Spécifiez une réduction", "")
                if not newReduction then return end
    
                if newReduction then
                    BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].reduction = newReduction
                else 
                    BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].reduction = nil
                end
            end
        )
    else
        item.Button(
            "Ajouter",
            "une réduction",
            nil,
            nil,
            false,
            function()
                local newReduction = KeyboardImput("Spécifiez une réduction", "")
                if not newReduction then return end
    
                if newReduction then
                    BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].reduction = newReduction
                end
            end
        )
    end

    item.Button(
        "Voir",
        "les champs personnalisés",
        nil,
        "chevron",
        false,
        function()end,
        customFields
    )
    item.Button(
        "Voir",
        "les variations",
        nil,
        "chevron",
        false,
        function()end,
        variations
    )

    item.Button(
        "Supprimer",
        "l'item",
        nil,
        "chevron",
        false,
        function()
            table.remove(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items, selectedItem)
            selectedItem = 1
        end,
        items
    )
end

function renderCustomFields()
    customFields.Separator(
        "Item", 
        BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].name
    )

    if #BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].customFields == 0 then
        BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].customFields = {}
    end

    for k,v in pairs(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].customFields) do
        customFields.List(
            v,
            nil,
            false,
            {"Modifier", "Supprimer"},
            index,
            function(index, item)
                if index == 1 then
                    local newCustomField = KeyboardImput("Spécifiez un champ personnalisé", "")
                    if not newCustomField then return end

                    if newCustomField then
                        BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].customFields[k] = newCustomField
                    end
                elseif index == 2 then
                    table.remove(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].customFields, k)
                end
            end
        )
    end
    
    customFields.Separator(nil)

    customFields.Button(
        "Ajouter",
        "un champ personnalisé",
        nil,
        "chevron",
        false,
        function()
            local newCustomField = KeyboardImput("Spécifiez un champ personnalisé", "")
            if not newCustomField then return end

            if newCustomField then  
                table.insert(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].customFields, newCustomField)
            end
        end
    )
end

function renderVariations()
    variations.Separator("Item", "", BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].name)

    for k,v in pairs(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations) do
        variations.Button(
            v.label,
            nil,
            nil,
            "chevron",
            false,
            function()
                selectedVariation = k
            end,
            variation
        )
    end
    
    variations.Separator(nil)

    variations.Button(
        "Ajouter",
        "une variation",
        nil,
        "chevron",
        false,
        function()
            local newLabel = KeyboardImput("Nouveau label", "")
            if not newLabel then return end

            local colorAutoAdded = false
          
            if newLabel == "black" then
                colorAutoAdded = true
                table.insert(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations, { name = BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].name,label = newLabel, color = "#000000", color2 = "#7D7D7D" })
            elseif newLabel == "white" then
                colorAutoAdded = true
                table.insert(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations, { name = BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].name,label = newLabel, color = "#AFC0B6", color2 = "#FFFFFF" })
            elseif newLabel == "blue" then
                colorAutoAdded = true
                table.insert(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations, { name = BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].name,label = newLabel, color = "#051A66", color2 = "#0362F1" })
            elseif newLabel == "grey" then
                colorAutoAdded = true
                table.insert(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations, { name = BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].name,label = newLabel, color = "#585353", color2 = "#A5A5A5" })
            elseif newLabel == "orange" then
                colorAutoAdded = true
                table.insert(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations, { name = BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].name,label = newLabel, color = "#DC5C16", color2 = "#FF906D" })
            elseif newLabel == "cyan" then
                colorAutoAdded = true
                table.insert(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations, { name = BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].name,label = newLabel, color = "#075D70", color2 = "#07B7EF" })
            elseif newLabel == "purple" then
                colorAutoAdded = true
                table.insert(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations, { name = BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].name,label = newLabel, color = "#434692", color2 = "#9373FF" })
            elseif newLabel == "yellow" then
                colorAutoAdded = true
                table.insert(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations, { name = BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].name, label = newLabel, color = "#FFBA00", color2 = "#FFC731" })
            elseif newLabel == "brown" then
                colorAutoAdded = true
                table.insert(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations, {name = BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].name, label = newLabel, color = "#371807", color2 = "#B76232" })
            elseif newLabel == "green" then
                colorAutoAdded = true
                table.insert(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations, {name = BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].name, label = newLabel, color = "#0E551D", color2 = "#00C92C" })
            elseif newLabel == "red" then
                colorAutoAdded = true
                table.insert(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations, {name = BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].name, label = newLabel, color = "#7A2929", color2 = "#D70909" })
            elseif newLabel == "pink" then
                colorAutoAdded = true
                table.insert(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations, {name = BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].name, label = newLabel, color = "#9E1190", color2 = "#FF6AF9" })
            elseif newLabel == "beige" then
                colorAutoAdded = true
                table.insert(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations, {name = BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].name, label = newLabel, color = "#D19878", color2 = "#FFD7CB" })
            elseif newLabel == "kaki" then
                colorAutoAdded = true
                table.insert(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations, {name = BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].name, label = newLabel, color = "#4A562F", color2 = "#71AE55" })
            elseif newLabel == "bordeaux" then
                colorAutoAdded = true
                table.insert(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations, {name = BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].name, label = newLabel, color = "#260D0D", color2 = "#A21313" })
            end 

            if newLabel and not colorAutoAdded then
                local newColor = KeyboardImput("Nouvelle couleur", "")
                if not newColor then return end

                if newColor then
                    table.insert(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations, { name = BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].name,label = newLabel, color = newColor })
                end
            end
        end
    )
end

function renderVariation()
    variation.Separator(
        "Item", 
        BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].name, 
        "Variation",
        BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].label
    )

    if BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].icon ~= nil then
        variation.Imagebox(
            BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].icon,
            BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].icon2 or nil,
            false
        )
    end

    if BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].name ~= nil then
        variation.Button(
            "Modifier",
            "le nom",
            BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].name,
            nil,
            false,
            function()
                local newName = KeyboardImput("Nouveau nom", "")
                if not newName then return end

                if newName then
                    BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].name = newName
                end
            end
        )
    else
        variation.Button(
            "Ajouter",
            "un nom",
            nil,
            nil,
            false,
            function()
                local newName = KeyboardImput("Nouveau nom", "")
                if not newName then return end

                if newName then
                    BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].name = newName
                end
            end
        )
    end


    variation.Button(
        "Modifier",
        "le label",
        BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].label,
        nil,
        false,
        function()
            local newLabel = KeyboardImput("Nouveau label", "")
            if not newLabel then return end

            if newLabel then
                BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].label = newLabel
            end
        end
    )
    variation.Button(
        "Modifier",
        "la couleur",
        BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].color,
        nil,
        false,
        function()
            local newColor = KeyboardImput("Nouvelle couleur", "")
            if not newColor then return end

            if newColor then
                BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].color = newColor
            end
        end
    )

    if BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].color2 ~= nil then
        variation.Button(
            "Modifier",
            "la couleur 2",
            BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].color2,
            nil,
            false,
            function()
                local newColor = KeyboardImput("Nouvelle couleur", "")
                if not newColor then return end

                if newColor then
                    BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].color2 = newColor
                end
            end
        )
    else
        variation.Button(
            "Ajouter",
            "une couleur 2",
            nil,
            nil,
            false,
            function()
                local newColor = KeyboardImput("Nouvelle couleur", "")
                if not newColor then return end

                if newColor then
                    BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].color2 = newColor
                end
            end
        )
    end

    if BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].image ~= nil then
        variation.Button(
            "Modifier",
            "l'image",
            BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].image,
            nil,
            false,
            function()
                local newImage = KeyboardImput("Nouvelle image", "")
                if not newImage then return end

                if newImage then
                    BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].image = newImage
                end
            end
        )
    else
        variation.Button(
            "Ajouter",
            "une image",
            nil,
            nil,
            false,
            function()
                local newImage = KeyboardImput("Nouvelle image", "")
                if not newImage then return end

                if newImage then
                    BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].image = newImage
                end
            end
        )
    end

    if BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].icon == nil then
        BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].icon = ""
    end
    variation.Button(
        "Modifier",
        "l'icon 1",
        BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].icon,
        nil,
        false,
        function()
            local newImage = KeyboardImput("Nouvelle icon 1", "")
            if not newImage then return end

            if newImage then
                BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].icon = newImage
            end
        end
    )

    if BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].icon2 == nil then
        BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].icon2 = ""
    end
    variation.Button(
        "Modifier",
        "l'icon 2",
        BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].icon2,
        nil,
        false,
        function()
            local newImage = KeyboardImput("Nouvelle icon 2", "")
            if not newImage then return end
            if newImage then
                BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation].icon2 = newImage
            end
        end
    )

    if BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].customFields == nil then
        BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].customFields = {}
    end
    for k,v in pairs(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].customFields) do
        variation.Button(
            "Modifier",
            "la valeur",
            BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation][v],
            nil,
            false,
            function()
                local newValue = KeyboardImput("Nouvelle valeur", "")
                if not newValue then return end

                if newValue then
                    BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations[selectedVariation][v] = newValue
                end
            end
        )
    end

    variation.Button(
        "Supprimer",
        "la variation",
        nil,
        nil,
        false,
        function()
            table.remove(BoutiqueCatalogue[selectedBoutique][selectedGlobalCategory][selectedCategory].items[selectedItem].variations, selectedVariation)
            selectedVariation = 1
        end,
        variations
    )
end

function OpenCreaBoutique()
    main.open()
end

main.OnOpen(function()
    renderMainMenu()
end)

catalogues.OnOpen(function()
    renderCatalogues()
end)

categories.OnOpen(function()
    renderCategories()
end)

category.OnOpen(function()
    renderCategory()
end)

items.OnOpen(function()
    renderItems()
end)

item.OnOpen(function()
    renderItem()
end)

customFields.OnOpen(function()
    renderCustomFields()
end)

variations.OnOpen(function()
    renderVariations()
end)

variation.OnOpen(function()
    renderVariation()
end)