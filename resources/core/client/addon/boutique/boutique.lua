local BoutiqueOpen = false
local currentOrder = nil
local current_category = 1
local isLiveries = false
local custom = false

CatalogueIndexes = { "AddonVetements", "AddonBijoux", "Custom", "Liveries", "AddonVehicules", "VehiculesBoutique" }

BoutiqueCatalogue = {}

--[[BoutiqueCatalogue = {
    { -- Vetement
        {
            title = "Pull",
            subtitle = "Haut",
            image = "https://cdn.discordapp.com/attachments/667855303840235531/1151169940754272276/image.webp",
            new = true,
            items = {
                {
                    name = "Casablanca",
                    image = "https://cdn.discordapp.com/attachments/667855303840235531/1151161029087211520/image.webp",
                    image2 = "https://cdn.discordapp.com/attachments/667855303840235531/1151169940754272276/image.webp",
                    variations = {
                        { color = "#FB0", label = "Orange" },
                        { color = "#2F8F38", label = "Green" },
                        { color = "#32DFB6", label = "Blue" },
                    },
                    customFields = { "Numéro", "Nom" }
                },
                {
                    name = "Casablanca 2",
                    image = "https://cdn.discordapp.com/attachments/667855303840235531/1151174615591301230/image.webp",
                    variations = {
                        { color = "#FFF", label = "White", image = "https://cdn.discordapp.com/attachments/667855303840235531/1151192161405128755/image.webp" },
                        { color = "#000", label = "Black" },
                        { color = "#FF0000", label = "Red" },
                    }
                }
            }
        },
        {
            title = "T-shirt",
            subtitle = "Haut",
            image = "https://media.discordapp.net/attachments/667855303840235531/1150637454546718841/image.webp",
            new = false,
            items = {}
        },
        {
            title = "Longue",
            subtitle = "Manche",
            image = "https://cdn.discordapp.com/attachments/667855303840235531/1151169940754272276/image.webp",
            new = false,
            items = {}
        },
        {
            title = "Chemise",
            subtitle = "Haut",
            image = "https://cdn.discordapp.com/attachments/667855303840235531/1151169940754272276/image.webp",
            new = false,
            items = {}
        },
    },
    { -- bijoux
        {
            title = "Collier",
            subtitle = "Bijoux",
            image = "https://cdn.discordapp.com/attachments/667855303840235531/1151169940754272276/image.webp",
            new = false,
            items = {}
        },
        {
            title = "Bague",
            subtitle = "Bijoux",
            image = "https://cdn.discordapp.com/attachments/667855303840235531/1151169940754272276/image.webp",
            new = false,
            items = {}
        },
        {
            title = "Bracelet",
            subtitle = "Bijoux",
            image = "https://cdn.discordapp.com/attachments/667855303840235531/1151169940754272276/image.webp",
            new = false,
            items = {}
        },
    },
    { -- cars
        {
            title = "Voiture 1",
            subtitle = "Vehicules",
            image = "https://cdn.discordapp.com/attachments/667855303840235531/1154272790673903666/image.webp",
            new = false,
            items = {}
        },
        {
            title = "Voiture 2",
            subtitle = "Vehicules",
            image = "https://cdn.discordapp.com/attachments/667855303840235531/1154272790673903666/image.webp",
            new = false,
            items = {}
        },
        {
            title = "Voiture 3",
            subtitle = "Vehicules",
            image = "https://cdn.discordapp.com/attachments/667855303840235531/1154272790673903666/image.webp",
            new = false,
            items = {}
        },
    },
    {},
    {},
    {},
    {}
}]]

TriggerServerEvent("core:boutique:getCatalogue")

function OpenBoutiqueCustom(typeValue)
    closeUI()
    Wait(50)
    TriggerScreenblurFadeIn(1000)
    forceHideRadar()
    BoutiqueOpen = true
    SendNUIMessage({
        type = 'openWebview',
        name = 'Boutique',
        data = {
            type = typeValue,
            catalogue = {},
            balance = p:getBalance(),
            premium = p:getSubscription(),
            unique_id = p:getUniqueId(),
            nextCollection = "10/09/2023"
        }
    })
end

function OpenPremiumMenu(sub)
    Wait(50)
    TriggerScreenblurFadeIn(1000)
    forceHideRadar()
    SendNUIMessage({
        type = 'openWebview',
        name = sub,
        data = {
            premium = p:getSubscription(),
            balance = p:getBalance(),
            unique_id = p:getUniqueId(),
            features = {
                {
                    name = "Sauvegarder vos tenues",
                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/SubPremium/cloth.webp",
                    text = "Menu Binco",
                    colors = { "#F90", "#FF5C00" }
                },
                {
                    name = 'Animal de compagnie',
                    icon = 'https://cdn.sacul.cloud/v2/vision-cdn/SubPremium/coif.webp',
                    text = 'Menu Animal',
                    colors =  {'#CA56BE', '#EC66AE' }
                },
                {
                    name = 'Décoration d\'intérieur',
                    icon = 'https://cdn.sacul.cloud/v2/vision-cdn/SubPremium/deco.webp',
                    text = 'Menu Props',
                    colors =  {'#4F6BD6', '#389FFE' }
                },
                {
                    name = 'Plaque d\'immatriculation',
                    icon = 'https://cdn.sacul.cloud/v2/vision-cdn/SubPremium/immat.webp',
                    text = 'Menu Custom',
                    colors =  {'#6BCB3E', '#00A424' }
                },
                {
                    name = 'Double personnage',
                    icon = 'https://cdn.sacul.cloud/v2/vision-cdn/SubPremium/dp.webp',
                    text = 'Menu /Personnage',
                    colors =  {'#FF4545', '#F00' }
                },
                {
                    name = 'Personnage peds GTA V',
                    icon = 'https://cdn.sacul.cloud/v2/vision-cdn/SubPremium/peds.webp',
                    text = 'Création de Personnage',
                    colors =  {'#5AA3F2', '#6789DD' }
                },
                {
                    name = 'Prioritaire liste d\'attente',
                    icon = 'https://cdn.sacul.cloud/v2/vision-cdn/SubPremium/chevron.webp',
                    text = 'Menu Connexion',
                    colors =  {'#FF005F', '#F47070' }
                },
            }
        }
    })
end

function OpenShopPacksMenu()
    SendNUIMessage({
        type = 'openWebview',
        name = 'ShopPacks',
        data = {
            credit = p:getBalance(),
            premium = p:getSubscription(),
            unique_id = p:getUniqueId(),
            packs = {
                {
			price = 10,
			value = 1000,
			name = "PACK 1",
			level = 'yellow',
			url = "https://absoluterp.tebex.io/package/5961280",
		},
		{
			price = 20,
			value = 3000,
			name = "PACK 2",
			level = 'orange',
			url = "https://absoluterp.tebex.io/package/5961281",
		},
		{
			price = 35,
			value = 5000,
			name = "PACK 3",
			level = 'red',
			url = "https://absoluterp.tebex.io/package/5961282",
		},
		{
			price = 50,
			value = 10000,
			name = "PACK 4",
			level = 'purple',
			url = "https://absoluterp.tebex.io/package/5961283",
		},
		{
			price = 100,
			value = 25000,
			name = "PACK 5",
			level = 'diamond',
			url = "https://absoluterp.tebex.io/package/6067238",
		},
		{
			price = 300,
			value = 100000,
			name = "PACK 6",
            bonus = true,
			level = 'black',
			url = "https://absoluterp.tebex.io/package/6226825",
			text = true,
		},
            }
        }
    })
    Wait(50)
    forceHideRadar()
end

local packopen = false

AddEventHandler("debug", function()
    if BoutiqueOpen then 
        TriggerScreenblurFadeOut(1000)
        BoutiqueOpen = false
    end
end)

RegisterNUICallback("focusOut", function()
    if BoutiqueOpen then 
        ClearFocus()
        TriggerScreenblurFadeOut(1000)
        BoutiqueOpen = false
    end
    if packopen then 
        TriggerScreenblurFadeOut(1000)
        packopen = false
    end
end)

RegisterNUICallback("buyBoutiquePack", function(data)
    TriggerServerEvent("core:boutique:buypack", tonumber(data.pack))
end)

RegisterNUICallback("confirmSubPremium", function(data)

    closeUI()

    Wait(50)

    forceHideRadar()
    TriggerScreenblurFadeIn(1000)

    currentOrder = "premium"

    SendNUIMessage({
        type = 'openWebview',
        name = 'OrderConfirmation',
        data = {
            premium = p:getSubscription(),
            unique_id = p:getUniqueId(),
            credit = p:getBalance(),
            price = 1500,
            showHelpText = "premium",
            item = {
                subscription = true,
            }
        }
    })
end)

RegisterNUICallback("subPremium", function(data)
    TriggerServerEvent("core:boutique:buyprenium")
end)

RegisterNUICallback("buyVCoins", function(data)
    -- open front pour acheter des vcoins
    closeUI()
    Wait(100)
    TriggerScreenblurFadeIn(1000)
    OpenShopPacksMenu()
    packopen = true
end)

RegisterNUICallback("buyPremium", function(data)
    -- open front pour acheter des vcoins
    closeUI()
    Wait(50)
    OpenPremiumMenu("SubPremium")
    packopen = true
end)

RegisterNUICallback("buyPremiumPlus", function(data)
    -- open front pour acheter des vcoins
    closeUI()
    Wait(50)
    OpenPremiumMenu("SubPremiumPlus")
    packopen = true
end)

RegisterNUICallback("buyItem", function(data)
    if BoutiqueOpen or packopen then
        TriggerServerEvent("core:trybuyBoutiqueItem", data)
        --closeUI()
    end
end)

RegisterNUICallback("openCustomBoutique", function()
    OpenBoutiqueCustom("customBoutique")
end)

RegisterNUICallback("BoutiqueCategory", function(data)
    local idx = 1
    local catalogue = {}
    local selectedCategory = 1;
    local isVehicle = false
    isLiveries = false
    custom = false

    if string.find(data.button, "Custom") then 
        custom = true

        local customCategory = string.sub(data.button, 7)

        if next(BoutiqueCatalogue) == nil then 
            SendNUIMessage({
                type = 'openWebview',
                name = 'OrderConfirmation',
                data = {
                    premium = p:getSubscription(),
                    unique_id = p:getUniqueId(),
                    credit = p:getBalance(),
                    status = "failed"
                }
            })
            print("[^1Boutique Erreur^7] La boutique n'a pas eu le temps de charger, veuillez attendre un peu.")
            return
        end

        if customCategory == "Vehicules" then
            catalogue = BoutiqueCatalogue[data.sex + 1][4]
            current_category = 4
            isLiveries = true
        else
            catalogue = BoutiqueCatalogue[data.sex + 1][3]
            current_category = 3
            if customCategory == "Liveries" then
                isLiveries = true
            elseif customCategory == "Masque" then
                selectedCategory = 2
            elseif customCategory == "Tatouage" then
                selectedCategory = 4
            end
        end

        for k,v in pairs(catalogue) do
            if not v then return end
            if not v.title then return end 
            if not customCategory then return end
            if string.lower(v.title) == string.lower(customCategory) then
                selectedCategory = k
                break
            end
        end

    else
        -- if category is AddonVehicules
        if data.button == "AddonVehicules" then
            isVehicle = true
            idx = 3

            catalogue = BoutiqueCatalogue[idx][2]
            current_category = 2
        elseif data.button == "VehiculesBoutique" then
            isVehicle = true
            idx = 3

            --catalogue = BoutiqueCatalogue[idx][3]
            --catalogue = nil
            current_category = 3
        elseif data.button == "Liveries" then
            isLiveries = true
            idx = 3

            catalogue = BoutiqueCatalogue[idx][1]
            current_category = 1
        else 
            idx = data.sex + 1

            for k,v in pairs(BoutiqueCatalogue[idx]) do
                if string.lower(CatalogueIndexes[k]) == string.lower(data.button) then 
                    catalogue = v
                    current_category = k
                    break
                end
            end
        end

    end

    if isVehicle then
        print("openWebview: BoutiqueVehicules")
        TriggerScreenblurFadeOut(1000)
        SendNUIMessage({
            type = 'openWebview',
            name = 'BoutiqueVehicules',
            data = {
                premium = p:getSubscription(),
                unique_id = p:getUniqueId(),
                balance = p:getBalance(),
                license = p:getLicense(),
            }
        })
    else
        SendNUIMessage({
            type = 'openWebview',
            name = 'BoutiqueItem',
            data = {
                type = custom and "custom" or "",
                isLiveries = isLiveries,
                premium = p:getSubscription(),
                unique_id = p:getUniqueId(),
                credit = p:getBalance(),
                categories = catalogue,
                selectedCategory = selectedCategory - 1,
                isVeh = isVehicle
            }
        })
    end
end)

RegisterNUICallback("backToBoutique", function(data)
    if data and data.custom then
        local typeOfBoutique = "custom"
        if data.custom == "" or not data.custom then typeOfBoutique = "premium" end
        OpenBoutiqueCustom(typeOfBoutique)
    else
        OpenBoutiqueCustom()
    end
end)

RegisterNUICallback("backToEscape", function()
    OpenEscapeMenu()
end)

RegisterNUICallback("confirmBuyItem", function(data)
    closeUI()
    Wait(50)
    currentOrder = data
    forceHideRadar()
    TriggerScreenblurFadeIn(1000)

    local customFields = {}

    if not data.item then 
        SendNUIMessage({
            type = 'openWebview',
            name = 'OrderConfirmation',
            data = {
                premium = p:getSubscription(),
                unique_id = p:getUniqueId(),
                credit = p:getBalance(),
                status = "failed"
            }
        })
        print("[^1Boutique Erreur^7] L'item boutique selectionné n'est pas complet, il doit etre modifié par le staff merci de les prévenirs.")
        return
    end

    local image = data.item.image
    local name = data.item.name

    if data.item.variations[data.variation + 1].icon and
        data.item.variations[data.variation + 1].icon ~= ""
    then
        image = data.item.variations[data.variation + 1].icon
    end

    if data.item.variations[data.variation + 1].name then 
        name = data.item.variations[data.variation + 1].name
    end

    for k,v in pairs(data.customFields) do
        customFields[v.name] = v.value
    end

    SendNUIMessage({
        type = 'openWebview',
        name = 'OrderConfirmation',
        data = {
            premium = p:getSubscription(),
            unique_id = p:getUniqueId(),
            credit = p:getBalance(),
            price = data.item.price or 2500,
            showHelpText = "custom",
            item = {
                subscription = false,
                name = name,
                image = image,
                customFields = customFields
            }
        }
    })
end)

RegisterNUICallback("validateOrder", function()
    if currentOrder == "premium" then
        TriggerServerEvent("core:boutique:buyprenium", currentOrder)
    else
        TriggerServerEvent("core:trybuyBoutiqueItem", currentOrder)
    end
end)

RegisterNUICallback("cancelOrder", function()

    closeUI()
    Wait(50)

    if currentOrder == "premium" then 
        return OpenPremiumMenu()
    end

    SendNUIMessage({
        type = 'openWebview',
        name = 'BoutiqueItem',
        data = {
            type = custom and "custom" or "",
            premium = p:getSubscription(),
            unique_id = p:getUniqueId(),
            credit = p:getBalance(),
            isLiveries = isLiveries,
            categories = BoutiqueCatalogue[current_category],
            selectedItem = currentOrder.selectedItem,
            selectedCategory = currentOrder.category,
            selectedVariation = currentOrder.variation
        }
    })
end)

RegisterNetEvent("aeceoereasdqxdfgjh", function(solde, nbr, buyType) -- que pour le front ehh
    p:setBalance(tonumber(solde))

    if buyType == "set" then 
        exports['vNotif']:createNotification({
            type = 'ILLEGAL',
            name = "V Coins",
            label = nbr,
            labelColor = "#38DC66",
            logo = "https://dunb17ur4ymx4.cloudfront.net/webstore/logos/7d143782ef903a98873a58e52216a6ea8e1ba433.png",
            mainMessage = "Votre solde a été mis à jour avec succès, merci!",
            duration = 20,
        })
    elseif buyType == "buy" then
        exports['vNotif']:createNotification({
            type = 'ILLEGAL',
            name = "V Coins",
            label = "Achat Véhicule",
            labelColor = "#38DC66",
            logo = "https://dunb17ur4ymx4.cloudfront.net/webstore/logos/7d143782ef903a98873a58e52216a6ea8e1ba433.png",
            mainMessage = "Achat effectué avec succès, merci!",
            duration = 20,
        })
    elseif buyType == "remove" then
        exports['vNotif']:createNotification({
            type = 'ILLEGAL',
            name = "V Coins",
            label = "-" .. nbr,
            labelColor = "#EB4034",
            logo = "https://dunb17ur4ymx4.cloudfront.net/webstore/logos/7d143782ef903a98873a58e52216a6ea8e1ba433.png",
            mainMessage = "Votre solde a été débité avec succès.",
            duration = 20,
        })
    else
        exports['vNotif']:createNotification({
            type = 'ILLEGAL',
            name = "V Coins",
            label = "+" .. nbr,
            labelColor = "#38DC66",
            logo = "https://dunb17ur4ymx4.cloudfront.net/webstore/logos/7d143782ef903a98873a58e52216a6ea8e1ba433.png",
            mainMessage = "Achat effectué avec succès, merci!",
            duration = 20,
        })
    end

    
end)

RegisterNetEvent("odsfnbgdfngdfbgiudfsbgiurftdboh", function()
    p:setSubscription(0)
    p:setBuyendDate(0)

    exports['vNotif']:createNotification({
        type = 'ILLEGAL',
        name = "Premium",
        label = "Annulation",
        labelColor = "#EB4034",
        logo = "https://dunb17ur4ymx4.cloudfront.net/webstore/logos/7d143782ef903a98873a58e52216a6ea8e1ba433.png",
        mainMessage = "Votre abonnement a été annulé avec succès.",
        duration = 20,
    })
end)

RegisterNetEvent("aeceoereasdqxdfgjdqsd", function(bal, days, ahb)
    if ahb then 
        p:setSubscription(2) 
    else
        p:setSubscription(1) 
    end
    SetPremiumKey()
    p:setBalance(tonumber(bal))

    if not days then days = 30 end

    -- get month from days (need to be fixed to avoid decimal number)
    local months = math.floor(days / 30)
    exports['vNotif']:createNotification({
        type = 'ILLEGAL',
        name = "Premium",
        label = months .. " mois",
        labelColor = "#38DC66",
        logo = "https://dunb17ur4ymx4.cloudfront.net/webstore/logos/7d143782ef903a98873a58e52216a6ea8e1ba433.png",
        mainMessage = "Achat effectué avec succès, merci!",
        duration = 20,
    })
end)

RegisterNetEvent("aeceoereasdqxdfgjd", function(bal, ignore)
    if not ignore then 
        p:setSubscription(1) 
        SetPremiumKey()
    end
    p:setBalance(tonumber(bal))

    exports['vNotif']:createNotification({
        type = 'ILLEGAL',
        name = "Premium",
        label = "Achat",
        labelColor = "#38DC66",
        logo = "https://dunb17ur4ymx4.cloudfront.net/webstore/logos/7d143782ef903a98873a58e52216a6ea8e1ba433.png",
        mainMessage = "Achat effectué avec succès, merci!",
        duration = 20,
    })
end)

RegisterNetEvent("core:boutique:update", function(data)
    BoutiqueCatalogue = data
end)

RegisterNetEvent("core:boutique:validatedOrder", function()
    SendNUIMessage({
        type = 'openWebview',
        name = 'OrderConfirmation',
        data = {
            premium = p:getSubscription(),
            unique_id = p:getUniqueId(),
            credit = p:getBalance(),
            status = "validated"
        }
    })
end)

RegisterNetEvent("core:boutique:cancelledOrder", function()
    SendNUIMessage({
        type = 'openWebview',
        name = 'OrderConfirmation',
        data = {
            premium = p:getSubscription(),
            unique_id = p:getUniqueId(),
            credit = p:getBalance(),
            status = "failed"
        }
    })
end)

RegisterCommand("getuniqueID", function(source)
    local uniqueID = TriggerServerCallback("core:getUniqueID")
    print("Id unique : " .. uniqueID)
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        -- duration = 5, -- In seconds, default:  4
        content = "Votre ID unique est ~c" .. uniqueID
    })    
end)

RegisterCommand("idboutique", function(source)
    local uniqueID = TriggerServerCallback("core:getUniqueID")
    print("Id boutique : " .. uniqueID)
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        -- duration = 5, -- In seconds, default:  4
        content = "Votre ID boutique est ~c" .. uniqueID
    })    
end)

RegisterNetEvent("core:sendnotifboutiquecaduc", function()
    Wait(3000)
    exports['vNotif']:createNotification({
        type = 'ILLEGAL',
        name = "Boutique",
        label = "Abonnement Caduc",
        labelColor = "#F0E68C",
        logo = "https://dunb17ur4ymx4.cloudfront.net/webstore/logos/7d143782ef903a98873a58e52216a6ea8e1ba433.png",
        mainMessage = "Votre abonnement vient d'expirer, vos avantages ne vous sont plus accessible !",
        duration = 30,
    })
end)