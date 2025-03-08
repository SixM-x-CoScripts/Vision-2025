local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local ChangeIndex = {male = 5, female = 5}
local inUse = {}
local save = {}

local countCheck = 0

local KevlarConfigs = {
    --- LSPD ---
    lspdgiletj = {male = {71, 0}, female = {67, 0}},

    lspdkevle1 = {male = {57, 0}, female = {58, 0}},
    lspdkevle2 = {male = {57, 5}, female = {58, 5}},
    lspdkevle3 = {male = {79, 2}, female = {82, 5}},
    
    lspdriot = {male = {58, 2}, female = {57, 2}},

    lspdkevm1 = {male = {80, 0}, female = {65, 0}},

    lspdkevlo1 = {male = {78, 1}, female = {82, 2}},
    lspdkevlo2 = {male = {79, 0}, female = {81, 2}},
    lspdkevlo3 = {male = {69, 2}, female = {84, 0}},
    lspdkevlo4 = {male = {68, 10}, female = {69, 10}},

    lspdkevlourd = {male = {114, 0}, female = {70, 0}},
    lspdkevsupervisor = {male = {114, 1}, female = {70, 0}},
    lspdkevdb = {male = {114, 2}, female = {70, 0}},
    lspdkevnegotiator = {male = {114, 3}, female = {70, 0}},
    lspdkevswat = {male = {114, 4}, female = {70, 0}},
    lspdkevcs = {male = {114, 5}, female = {70, 0}},
    lspdkevco = {male = {114, 6}, female = {70, 0}},
    lspdkevfieldsup = {male = {114, 7}, female = {70, 0}},

    lspdkeviad = {male = {120, 0}, nil},

    lspdswat = {male = {122, 0}, female = {111, 0}},
    lspdswat2 = {male = {85, 0}, female = {85, 0}},
    lspdmetro = {male = {85, 2}, female = {85, 3}},
    lspdmetrole = {male = {57, 7}, female = {58, 11}},
    lspdk9 = {male = {86, 0}, female = {82, 2}},
    lspdtd = {male = {86, 2}, female = {82, 2}},
    lspdtdj = {male = {65, 0}, female = {82, 2}},

    lspdcnt1 = {male = {85, 1}, female = {85, 2}},

    lspdgnd = {male = {82, 0}, female = {83, 0}},
    lspdkevpc2 = {male = {68, 10}, female = {83, 0}},

    lspdkevpc = {male = {82, 1}, female = {83, 1}},



    --- USSS ---
    insigneKevUsss = {male = {72, 3}, female = {71, 7}},

    ussskev1 = {male = {66, 0}, female = {81, 1}},
    ussskev2 = {male = {67, 0}, female = {82, 1}},
    ussskev3 = {male = {69, 0}, female = {82, 1}},
    ussskev4 = {male = {128, 0}, female = {58, 7}},



    --- LSSD ---
    lssdgiletj = {male = {71, 1}, female = {67, 1}},

    lssdkevle1 = {male = {57, 1}, female = {58, 2}},
    lssdkevle2 = {male = {68, 1}, female = {69, 1}},

    lssdkevlo1 = {male = {69, 1}, female = {81, 0}},
    lssdkevlo2 = {male = {78, 0}, female = {81, 0}},
    lssdkevlo3 = {male = {79, 0}, female = {82, 0}},
    lssdkevlo4 = {male = {78, 2}, female = {82, 3}},
    lssdkevlo5 = {male = {101, 0}, nil},
    lssdkevlo6 = {male = {101, 1}, nil},
    lssdkevlo7 = {male = {101, 2}, nil},

    lssdinsigne = {male = {73, 1}, female = {72, 1}},

    lssdriot = {male = {58, 3}, female = {57, 3}},



    --- G6 ---
    g6kev = {male = {92, 0}, female = {91, 0}},
    g6kev2 = {male = {92, 1}, female = {91, 1}},



    --- USBP ---
    usbpkevlo1 = {male = {77, 10}, female = {76, 10}},
    usbpkevlo2 = {male = {59, 8}, female = {59, 8}},
    usbpkevlo3 = {male = {70, 6}, female = {70, 6}},
    usbpkevlo4 = {male = {70, 7}, female = {70, 7}},
    usbpkevlo5 = {male = {75, 10}, female = {74, 10}},

    usbpkevpc = {male = {68, 12}, female = {69, 12}},

    usbpgiletb = {male = {60, 3}, female = {60, 5}},

    usbpgiletj = {male = {71, 8}, female = {67, 8}},

    usbpinsigne = {male = {72, 1}, female = {71, 1}},



    --- SAMS ---
    samskev = {male = {93, 0}, female = {92, 0}},
    samskev2 = {male = {94, 1}, female = {93, 1}},
    samskev3 = {male = {94, 3}, female = {93, 3}},
    samskev4 = {male = {95, 0}, female = {90, 0}},
    samskev5 = {male = {68, 6}, female = {90, 0}},



    --- LSFD ---
    lsfdkev = {male = {94, 0}, female = {92, 0}},
    lsfdkev2 = {male = {94, 2}, female = {93, 0}},
    lsfdkev3 = {male = {95, 1}, female = {93, 2}},
    lsfdkev4 = {male = {68, 5}, female = {93, 2}},
    lsfdkev5 = {male = {68, 2}, female = {93, 2}},
    lsfdradio = {male = {115, 0}, female = {92, 0}},



    --- GOUV  & AUTRES
    gouvkev = {male = {147, 2}, female = {58, 8}},
    gouvernorkev = {male = {147, 3}, female = {58, 8}},

    irskev = {male = {147, 1}, female = {58, 8}},
    irscikev = {male = {147, 0}, female = {58, 8}},

    dojkev = {male = {69, 3}, female = {58, 8}},
    boikev = {male = {69, 4}, female = {58, 9}},

    wzkev = {male = {93, 4}, female = {92, 4}},

    lstcard = {male = {109, 0}, nil},



    --- ILLÉGAL ---
    keville1 = {male = {134, 0}, female = {122, 0}},
    keville2 = {male = {125, 0}, female = {126, 0}},
    keville3 = {male = {125, 1}, female = {126, 1}},
    keville4 = {male = {125, 2}, female = {126, 2}},
    keville5 = {male = {130, 0}, female = {127, 0}},
    keville6 = {male = {130, 1}, female = {127, 1}},
    keville7 = {male = {130, 2}, female = {127, 2}},
    keville8 = {male = {130, 3}, female = {127, 3}},
    keville9 = {male = {131, 0}, female = {128, 0}},
    keville10 = {male = {131, 1}, female = {128, 1}},
    keville11 = {male = {131, 2}, female = {128, 2}},
    keville12 = {male = {131, 3}, female = {128, 3}},
    giletc4 = {male = {145, 0}, female = {129, 0}},
}

function generateMetadataId(idList)
    local idList = {}
    for k, v in pairs(p:getInventaire()) do
        if KevlarConfigs[v.name] and v.metadatas and v.metadatas.id then
            table.insert(idList, v.metadatas.id)
        end
    end
    local id = math.random(100000, 999999)
    while idList[id] do
        id = math.random(100000, 999999)
    end
    return id
end

local antispam = nil

RegisterNetEvent("core:UseKevlar")
AddEventHandler("core:UseKevlar", function(item, shield, metadatas)
    if antispam and GetGameTimer() - antispam < 750 then 
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Veuillez patienter avant de réutiliser un équipement."
        })
        return 
    else
        antispam = GetGameTimer()
    end

    local inventory = p:getInventaire()
    local itemData = nil

    local id = {}
    for k, v in pairs(p:getInventaire()) do
        if KevlarConfigs[v.name] then
            if v.metadatas and v.metadatas.id then
                table.insert(id, v.metadatas.id)
            else
                local metadataUpdate = json.decode(json.encode(v.metadatas))
                metadataUpdate.id = generateMetadataId(id)
                TriggerServerEvent('core:UpdateItemMetadata', token, v.name, v.count, v.metadatas, metadataUpdate)
                metadatas.id = metadataUpdate.id
            end
        end
    end

    for _, v in pairs(inventory) do
        if v.name == item and v.metadatas and v.metadatas.id == metadatas.id then
            itemData = v
            break
        end
    end

    if not itemData then
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Vous n'avez pas cet item."
        })
        return
    end

    printDev(json.encode(inUse), item, inUse.item, metadatas.id, inUse.id)
    if inUse.item == item and itemData.metadatas.id == inUse.id then
        p:setShield(0)
        inUse = {}
        p:setCloth("bproof_1", 0)
        p:setCloth("bproof_2", 0)
        return
    elseif inUse.item then
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Vous avez déjà un équipement en cours d'utilisation."
        })
        return
    end

    local metadatas = itemData.metadatas or {}
    local count = itemData.count

    if count > 1 then
        local id = generateMetadataId()
        TriggerServerEvent("core:RemoveKevlarToInventory", token, item, 1, metadatas)
        TriggerSecurGiveEvent("core:addItemToInventory", token, item, 1, {id = id, durability = shield})
        metadatas = {id = id, durability = shield}
    end

    local sex = p:skin().sex == 0 and "male" or "female"
    local config = KevlarConfigs[item] and KevlarConfigs[item][sex]

    if config then
        inUse = { item = item, metadatas = metadatas, count = count, id = metadatas.id }
        local index = ChangeIndex[sex]
        p:setCloth("bproof_1", config[1] + index)
        p:setCloth("bproof_2", config[2])

        if not metadatas.durability then
            local metadataUpdate = json.decode(json.encode(metadatas))
            metadataUpdate.durability = shield

            TriggerServerEvent('core:UpdateItemMetadata', token, item, 1, metadatas, metadataUpdate)
            metadatas.durability = shield
        end

        p:setShield(metadatas.durability)

        Citizen.CreateThread(function()
            while inUse.item == item do
                Wait(250)
                if countCheck > 5 then
                    local find = false
                    for k, v in pairs(p:getInventaire()) do
                        if v.name == item and v.metadatas.id == metadatas.id then
                            find = true
                        end
                    end

                    if not find then
                        inUse = {}
                        p:setShield(0)
                        p:setCloth("bproof_1", 0)
                        p:setCloth("bproof_2", 0)
                    end
                    countCheck = 0
                else
                    countCheck = countCheck + 1
                end

                if not inUse.item then break end

                local currentArmor = GetPedArmour(p:ped())

                    if currentArmor ~= metadatas.durability then
                    local metadataUpdate = json.decode(json.encode(metadatas))
                    metadataUpdate.durability = currentArmor
                    TriggerServerEvent('core:UpdateItemMetadata', token, item, 1, metadatas, metadataUpdate)
                    metadatas.durability = GetPedArmour(p:ped())
                end
                if currentArmor < 1 then
                    if not inUse.item then break end
                    p:setShield(0)
                    p:setCloth("bproof_1", 0)
                    p:setCloth("bproof_2", 0)
                    for k, v in pairs(p:getInventaire()) do
                        if v.name == item and v.metadatas.id == metadatas.id then
                            itemData = v
                            break
                        end
                    end
                    save = itemData
                    printDev("RemoveKevlarToInventory", item, 1, json.encode(itemData.metadatas), json.encode(metadatas))
                    TriggerServerEvent('core:RemoveKevlarToInventory', token, itemData.name, itemData.count, itemData.metadatas)
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        content = "Votre gilet pare-balles est inutilisable."
                    })
                    inUse = {}
                    metadatas = nil
                    count = nil
                    itemData = nil
                    break
                end
            end
            Wait(500)
            for k, v in pairs(p:getInventaire()) do
                if v and v.metadatas and v.metadatas.id and save and save.metadatas and save.metadatas.id then
                    if v.metadatas.id == save.metadatas.id then
                        TriggerServerEvent('core:RemoveKevlarToInventory', token, v.name, v.count, v.metadatas)
                    end
                else
                end                
            end
        end)
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Cet équipement n'est pas adapté pour vous."
        })
    end
end)

while p == nil do Wait(1000) end

function startMetadataIdKevalarVerification()
    local id = {}
    for k, v in pairs(p:getInventaire()) do
        if KevlarConfigs[v.name] then
            if v.metadatas and v.metadatas.id then
                table.insert(id, v.metadatas.id)
            else
                local metadataUpdate = json.decode(json.encode(v.metadatas))
                metadataUpdate.id = generateMetadataId(id)
                TriggerServerEvent('core:UpdateItemMetadata', token, v.name, v.count, v.metadatas, metadataUpdate)
            end
        end
    end
end 

startMetadataIdKevalarVerification()