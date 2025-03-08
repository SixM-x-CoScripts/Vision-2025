local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)


RegisterNUICallback("progressMenuLST", function(data)
        local gradeTenue = nil
        local typeTenue = nil 
        local tenue = nil
        if data.sousCategory == "Tenues" then
            gradeTenue = data.TenueGrade
            typeTenue = data.label
            if p:isMale() then
                tenue = listGradeM_LST[gradeTenue].tenues[typeTenue]
            else
                tenue = listGradeF_LST[gradeTenue].tenues[typeTenue]
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

            TriggerEvent('skinchanger:change', "helmet_1", tenue.helmet)
            TriggerEvent('skinchanger:change', "helmet_2", tenue.varHelmet)

            TriggerEvent('skinchanger:change', "glasses_1", tenue.glasses)
            TriggerEvent('skinchanger:change', "glasses_2", tenue.varGlasses)
        
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
                content = "Vous venez de récupérer votre tenue ~s "..data.name
            })
            TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1, {renamed = data.name, data = tenue})
            closeUI()
        end
end)

function LSTVestiaireDev()
    local dataVestiaireLST = {}
    dataVestiaireLST = {
        catalogue= {},
        headerIcon= 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
        headerIconName= 'Vestiaire',
        callbackName= 'progressMenuLST',
        progressBar= {
            {
                name= 'Grades'
            }, 
            {
                name= 'Tenues'
           }
        },
        headerImage= 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_lst.webp'
    }

    if p:isMale() then
        listGradeM_LST = {
            ["LST - MC"] = {
                tenues = {
                    Blanc = {
                        id = 2,
                        varHaut = 11,
                        helmet = -1,
                        decals = 0,
                        varBras = 0,
                        varChaine = 0,
                        varDecals = 0,
                        varMask = 0,
                        bras = 11,
                        haut = 600,
                        varGpb = 0,
                        varHelmet = 0,
                        mask = 0,
                        varPantalon = 2,
                        chaine = 0,
                        sousHaut = 302,
                        gpb = 136,
                        sac = 166,
                        pantalon = 235,
                        varSac = 0,
                        chaussures = 109,
                        varChaussures = 1,
                        varSousHaut = 0,
                    },
                    Bleu = {
                        id = 3,
                        varHaut = 10,
                        helmet = -1,
                        decals = 0,
                        varBras = 0,
                        varChaine = 0,
                        varDecals = 0,
                        varMask = 0,
                        bras = 11,
                        haut = 600,
                        varGpb = 0,
                        varHelmet = 0,
                        mask = 0,
                        varPantalon = 2,
                        chaine = 0,
                        sousHaut = 302,
                        gpb = 136,
                        sac = 166,
                        pantalon = 235,
                        varSac = 0,
                        chaussures = 109,
                        varChaussures = 1,
                        varSousHaut = 0,
                    },
                    Gris = {
                        id = 1,
                        varHaut = 12,
                        helmet = -1,
                        decals = 197,
                        varBras = 0,
                        varChaine = 0,
                        varDecals = 0,
                        varMask = 0,
                        bras = 11,
                        haut = 600,
                        varGpb = 0,
                        varHelmet = 0,
                        mask = 0,
                        varPantalon = 0,
                        chaine = 0,
                        sousHaut = 302,
                        gpb = 136,
                        sac = 166,
                        pantalon = 235,
                        varSac = 0,
                        chaussures = 109,
                        varChaussures = 1,
                        varSousHaut = 0,
                    },
                },
                id = 2,
            },
            ["LST - ML"] = {
                tenues = {
                    Blanc = {
                        id = 2,
                        varHaut = 12,
                        helmet = -1,
                        decals = 0,
                        varBras = 0,
                        varChaine = 0,
                        varDecals = 0,
                        varMask = 0,
                        bras = 4,
                        haut = 601,
                        varGpb = 0,
                        varHelmet = 0,
                        mask = 0,
                        varPantalon = 2,
                        chaine = 0,
                        sousHaut = 302,
                        gpb = 136,
                        sac = 166,
                        pantalon = 235,
                        varSac = 0,
                        chaussures = 109,
                        varChaussures = 1,
                        varSousHaut = 0,
                    },
                    Bleu = {
                        id = 3,
                        varHaut = 10,
                        helmet = -1,
                        decals = 0,
                        varBras = 0,
                        varChaine = 0,
                        varDecals = 0,
                        varMask = 0,
                        bras = 4,
                        haut = 601,
                        varGpb = 0,
                        varHelmet = 0,
                        mask = 0,
                        varPantalon = 2,
                        chaine = 0,
                        sousHaut = 302,
                        gpb = 136,
                        sac = 166,
                        pantalon = 235,
                        varSac = 0,
                        chaussures = 109,
                        varChaussures = 1,
                        varSousHaut = 0,
                    },
                    Gris = {
                        id = 1,
                        varHaut = 11,
                        helmet = -1,
                        decals = 197,
                        varBras = 0,
                        varChaine = 0,
                        varDecals = 0,
                        varMask = 0,
                        bras = 4,
                        haut = 601,
                        varGpb = 0,
                        varHelmet = 0,
                        mask = 0,
                        varPantalon = 0,
                        chaine = 0,
                        sousHaut = 302,
                        gpb = 136,
                        sac = 166,
                        pantalon = 235,
                        varSac = 0,
                        chaussures = 109,
                        varChaussures = 1,
                        varSousHaut = 0,
                    },
                },
                id = 1,
            },
        }
            for k,v in pairs(listGradeM_LST) do
            table.insert(dataVestiaireLST.catalogue, {
                    id= v.id,
                    label = k,
                    image= "https://cdn.sacul.cloud/v2/vision-cdn/Vestiaire/LST/Grades/"..v.id..".webp",
                    category= "Grades",
                    subCategory = "Grades",
                    idVariation= v.id,
            })
            for i,j in pairs(v.tenues) do
                if j.id ~= nil then
                    table.insert(dataVestiaireLST.catalogue, {
                        id= j.id,
                        label = i,
                        --image= "https://cdn.sacul.cloud/v2/vision-cdn/Vestiaire/LST/Tenues/Homme/"..v.id.."/"..j.id..".webp",
                        "https://cdn.sacul.cloud/v2/vision-cdn/Vestiaire/LST/Tenues/Homme/"..v.id.."/"..j.id..".webp",
                        category= "Tenues",
                        sousCategory= "Tenues",
                        idVariation= j.id,
                        targetId = v.id,
                        TenueGrade = k,
                    })
                end
            end
        end
    else
        listGradeF_LST = {
            ["LST - MC"] = {
                tenues = {
                    Blanc = {
                        id = 2,
                        varHaut = 11,
                        helmet = -1,
                        decals = 234,
                        varBras = 0,
                        varChaine = 0,
                        varDecals = 0,
                        varMask = 0,
                        bras = 9,
                        haut = 626,
                        varGpb = 0,
                        varHelmet = 0,
                        mask = 0,
                        varPantalon = 0,
                        chaine = 0,
                        sousHaut = 306,
                        gpb = 0,
                        sac = 161,
                        pantalon = 257,
                        varSac = 0,
                        chaussures = 182,
                        varChaussures = 1,
                        varSousHaut = 0,
                    },
                    Bleu = {
                        id = 3,
                        varHaut = 10,
                        helmet = -1,
                        decals = 234,
                        varBras = 0,
                        varChaine = 0,
                        varDecals = 0,
                        varMask = 0,
                        bras = 9,
                        haut = 626,
                        varGpb = 0,
                        varHelmet = 0,
                        mask = 0,
                        varPantalon = 1,
                        chaine = 0,
                        sousHaut = 306,
                        gpb = 0,
                        sac = 161,
                        pantalon = 234,
                        varSac = 0,
                        chaussures = 182,
                        varChaussures = 1,
                        varSousHaut = 0,
                    },
                    Gris = {
                        id = 1,
                        varHaut = 12,
                        helmet = -1,
                        decals = 234,
                        varBras = 0,
                        varChaine = 0,
                        varDecals = 0,
                        varMask = 0,
                        bras = 9,
                        haut = 626,
                        varGpb = 0,
                        varHelmet = 0,
                        mask = 0,
                        varPantalon = 0,
                        chaine = 0,
                        sousHaut = 306,
                        gpb = 0,
                        sac = 161,
                        pantalon = 257,
                        varSac = 0,
                        chaussures = 182,
                        varChaussures = 1,
                        varSousHaut = 0,
                    },
                },
                id = 2,
            },
            ["LST - ML"] = {
                tenues = {
                    Blanc = {
                        id = 2,
                        varHaut = 12,
                        helmet = -1,
                        decals = 0,
                        varBras = 0,
                        varChaine = 0,
                        varDecals = 0,
                        varMask = 0,
                        bras = 3,
                        haut = 627,
                        varGpb = 0,
                        varHelmet = 0,
                        mask = 0,
                        varPantalon = 1,
                        chaine = 0,
                        sousHaut = 306,
                        gpb = 0,
                        sac = 161,
                        pantalon = 234,
                        varSac = 0,
                        chaussures = 182,
                        varChaussures = 1,
                        varSousHaut = 0,
                    },
                    Bleu = {
                        id = 3,
                        varHaut = 10,
                        helmet = -1,
                        decals = 0,
                        varBras = 0,
                        varChaine = 0,
                        varDecals = 0,
                        varMask = 0,
                        bras = 3,
                        haut = 627,
                        varGpb = 0,
                        varHelmet = 0,
                        mask = 0,
                        varPantalon = 1,
                        chaine = 0,
                        sousHaut = 306,
                        gpb = 0,
                        sac = 161,
                        pantalon = 234,
                        varSac = 0,
                        chaussures = 182,
                        varChaussures = 1,
                        varSousHaut = 0,
                    },
                    Gris = {
                        id = 1,
                        varHaut = 11,
                        helmet = -1,
                        decals = 234,
                        varBras = 0,
                        varChaine = 0,
                        varDecals = 0,
                        varMask = 0,
                        bras = 3,
                        haut = 627,
                        varGpb = 0,
                        varHelmet = 0,
                        mask = 0,
                        varPantalon = 0,
                        chaine = 0,
                        sousHaut = 306,
                        gpb = 0,
                        sac = 161,
                        pantalon = 257,
                        varSac = 0,
                        chaussures = 182,
                        varChaussures = 1,
                        varSousHaut = 0,
                    },
                },
                id = 1,
            },
        }
        for k,v in pairs(listGradeF_LST) do
            table.insert(dataVestiaireLST.catalogue, {
                    id= v.id,
                    label = k,
                    image= "https://cdn.sacul.cloud/v2/vision-cdn/Vestiaire/LST/Grades/"..v.id..".webp",
                    category= "Grades",
                    subCategory = "Grades",
                    idVariation= v.id,
            })
            for i,j in pairs(v.tenues) do
                if j.id ~= nil then
                    table.insert(dataVestiaireLST.catalogue, {
                        id= j.id,
                        label = i,
                        image= "https://cdn.sacul.cloud/v2/vision-cdn/Vestiaire/LST/Tenues/Femme/"..v.id.."/"..j.id..".webp",
                        category= "Tenues",
                        sousCategory= "Tenues",
                        idVariation= j.id,
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
        data = dataVestiaireLST
    }))
end
