local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

RegisterNUICallback("progressMenuUSMC", function(data)
    local gradeTenue = nil
    local typeTenue = nil
    local tenue = nil
    if data.sousCategory == "Tenues" then
        gradeTenue = data.TenueGrade
        typeTenue = data.label
        if p:isMale() then
            tenue = listGradeM[gradeTenue].tenues[typeTenue]
        else
            tenue = listGradeF[gradeTenue].tenues[typeTenue]
        end
        TriggerEvent('skinchanger:change', "shoes_1", tenue.chaussures)
        TriggerEvent('skinchanger:change', "shoes_2", tenue.varChaussures)

        TriggerEvent('skinchanger:change', "bags_1", tenue.sac)
        TriggerEvent('skinchanger:change', "bags_2", tenue.varSac)

        TriggerEvent('skinchanger:change', "decals_1", tenue.decals)
        TriggerEvent('skinchanger:change', "decals_2", tenue.varDecals)

        TriggerEvent('skinchanger:change', "pants_1", tenue.pantalon)
        TriggerEvent('skinchanger:change', "pants_2", tenue.varPantalon)

        TriggerEvent('skinchanger:change', "chain_1", tenue.chaine)
        TriggerEvent('skinchanger:change', "chain_2", tenue.varChaine)

        TriggerEvent('skinchanger:change', "torso_1", tenue.haut)
        TriggerEvent('skinchanger:change', "torso_2", tenue.varHaut)

        TriggerEvent('skinchanger:change', "tshirt_1", tenue.sousHaut)
        TriggerEvent('skinchanger:change', "tshirt_2", tenue.varSousHaut)

        TriggerEvent('skinchanger:change', "mask_1", tenue.mask)
        TriggerEvent('skinchanger:change', "mask_2", tenue.varMask)

        if tenue.gpb ~= 0 then
            TriggerEvent('skinchanger:change', "bproof_1", tenue.gpb)
            TriggerEvent('skinchanger:change', "bproof_2", tenue.varGpb)
        else
            TriggerEvent('skinchanger:change', "bproof_1", 0)
            TriggerEvent('skinchanger:change', "bproof_2", 0)
        end

        TriggerEvent('skinchanger:change', "arms", tenue.bras)
        TriggerEvent('skinchanger:change', "arms_2", tenue.varBras)
    end
    if data.name then
        local skin = SkinChangerGetSkin()
        local tenue = {
            ['tshirt_1'] = skin["tshirt_1"],
            ['tshirt_2'] = skin["tshirt_2"],
            ['torso_1'] = skin["torso_1"],
            ['torso_2'] = skin["torso_2"],
            ['decals_1'] = skin["decals_1"],
            ['decals_2'] = skin["decals_2"],
            ['arms'] = skin["arms"],
            ['arms_2'] = skin["arms_2"],
            ['pants_1'] = skin["pants_1"],
            ['pants_2'] = skin["pants_2"],
            ['shoes_1'] = skin["shoes_1"],
            ['shoes_2'] = skin["shoes_2"],
            ['bags_1'] = skin['bags_1'],
            ['bags_2'] = skin['bags_2'],
            ['chain_1'] = skin['chain_1'],
            ['chain_2'] = skin['chain_2'],
            ['helmet_1'] = skin['helmet_1'],
            ['helmet_2'] = skin['helmet_2'],
            ['ears_1'] = skin['ears_1'],
            ['ears_2'] = skin['ears_2'],
            ['mask_1'] = skin['mask_1'],
            ['mask_2'] = skin['mask_2'],
            ['glasses_1'] = skin['glasses_1'],
            ['glasses_2'] = skin['glasses_2'],
            ['bproof_1'] = skin['bproof_1'],
            ['bproof_2'] = skin['bproof_2'],
        }
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            content = "Vous venez de récupérer votre tenue ~s " .. data.name
        })
        TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1, { renamed = data.name, data = tenue })
        closeUI()
    end
end)

function LoadVestiaireUSMC()
    dataVestiaireUSMC = {}
    dataVestiaireUSMC = {
        catalogue = {},
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
        headerIconName = 'Vestiaire',
        callbackName = 'progressMenuUSMC',
        progressBar = {
            {
                name = 'Grades'
            },
            {
                name = 'Tenues'
            }
        },
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_usmc.webp'
    }

    if p:isMale() then
        listGradeM = {
            ["Militaire"] = {
                id = 1,
                tenues = {
                    ["Tenue légére 1"] = {
                        varHaut = 0,
                        sac = 0,
                        varSousHaut = 0,
                        chaussures = 25,
                        gpb = 0,
                        id = 0,
                        chaine = 189,
                        haut = 462,
                        varBras = 0,
                        varChaine = 0,
                        varDecals = 0,
                        decals = 0,
                        bras = 0,
                        varSac = 0,
                        varGpb = 0,
                        pantalon = 176,
                        sousHaut = 289,
                        varPantalon = 0,
                        varChaussures = 0,
                    },
                    ["Tenue légére 2"] = {
                        varHaut = 0,
                        sac = 0,
                        varSousHaut = 0,
                        chaussures = 25,
                        gpb = 0,
                        id = 0,
                        chaine = 0,
                        haut = 462,
                        varBras = 0,
                        varChaine = 0,
                        varDecals = 0,
                        decals = 0,
                        bras = 0,
                        varSac = 0,
                        varGpb = 0,
                        pantalon = 176,
                        sousHaut = 15,
                        varPantalon = 0,
                        varChaussures = 0,
                    },
                    ["Tenue d'opération"] = {
                        varHaut = 0,
                        sac = 205,
                        varSousHaut = 0,
                        chaussures = 25,
                        gpb = 127,
                        id = 0,
                        chaine = 189,
                        haut = 563,
                        varBras = 0,
                        varChaine = 0,
                        varDecals = 0,
                        decals = 0,
                        bras = 200,
                        varSac = 0,
                        varGpb = 0,
                        pantalon = 176,
                        sousHaut = 209,
                        varPantalon = 0,
                        varChaussures = 0,
                    },
                },
            },
        }
        for k, v in pairs(listGradeM) do
            table.insert(dataVestiaireUSMC.catalogue, {
                id = v.id,
                label = k,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Vestiaire/USMC/Grades/" .. v.id .. ".webp",
                category = "Grades",
                subCategory = "Grades",
                idVariation = v.id,
            })
            for i, j in pairs(v.tenues) do
                if j.id ~= nil then
                    table.insert(dataVestiaireUSMC.catalogue, {
                        id = j.id,
                        label = i,
                        image = "https://cdn.sacul.cloud/v2/vision-cdn/Vestiaire/USMC/Tenues/Homme/" ..
                            v.id .. "/" .. j.id .. ".webp",
                        category = "Tenues",
                        sousCategory = "Tenues",
                        idVariation = j.id,
                        targetId = v.id,
                        TenueGrade = k,
                    })
                end
            end
        end
    else
        listGradeF = {
            ["Militaire"] = {
                id = 1,
                tenues = {
                    ["Tenue légére 1"] = {
                        varHaut = 0,
                        sac = 0,
                        varSousHaut = 0,
                        chaussures = 25,
                        gpb = 0,
                        id = 0,
                        chaine = 189,
                        haut = 462,
                        varBras = 0,
                        varChaine = 0,
                        varDecals = 0,
                        decals = 0,
                        bras = 0,
                        varSac = 0,
                        varGpb = 0,
                        pantalon = 176,
                        sousHaut = 289,
                        varPantalon = 0,
                        varChaussures = 0,
                    },
                    ["Tenue légére 2"] = {
                        varHaut = 0,
                        sac = 0,
                        varSousHaut = 0,
                        chaussures = 25,
                        gpb = 0,
                        id = 0,
                        chaine = 0,
                        haut = 462,
                        varBras = 0,
                        varChaine = 0,
                        varDecals = 0,
                        decals = 0,
                        bras = 0,
                        varSac = 0,
                        varGpb = 0,
                        pantalon = 176,
                        sousHaut = 15,
                        varPantalon = 0,
                        varChaussures = 0,
                    },
                    ["Tenue d'opération"] = {
                        varHaut = 0,
                        sac = 205,
                        varSousHaut = 0,
                        chaussures = 25,
                        gpb = 127,
                        id = 0,
                        chaine = 189,
                        haut = 563,
                        varBras = 0,
                        varChaine = 0,
                        varDecals = 0,
                        decals = 0,
                        bras = 200,
                        varSac = 0,
                        varGpb = 0,
                        pantalon = 176,
                        sousHaut = 209,
                        varPantalon = 0,
                        varChaussures = 0,
                    },
                },
            },
        }
        for k, v in pairs(listGradeF) do
            table.insert(dataVestiaireUSMC.catalogue, {
                id = v.id,
                label = k,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Vestiaire/USMC/Grades/" .. v.id .. ".webp",
                category = "Grades",
                subCategory = "Grades",
                idVariation = v.id,
            })
            for i, j in pairs(v.tenues) do
                if j.id ~= nil then
                    table.insert(dataVestiaireUSMC.catalogue, {
                        id = j.id,
                        label = i,
                        image = "https://cdn.sacul.cloud/v2/vision-cdn/Vestiaire/USMC/Tenues/Femme/" ..
                            v.id .. "/" .. j.id .. ".webp",
                        category = "Tenues",
                        sousCategory = "Tenues",
                        idVariation = j.id,
                        targetId = v.id,
                        TenueGrade = k,
                    })
                end
            end
        end
    end

    Wait(500)
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'MenuProgress',
        data = dataVestiaireUSMC
    }))
end
