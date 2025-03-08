PlayersInLabo = {}

CreateThread(function()
    while (GetResourceState("core") ~= "started") do 
        Wait(0)
    end
    while not MySQL do Wait(1) end
    MySQL.Async.fetchAll("SELECT * FROM laboratory", {}, function(result)
        if result ~= nil then
            for i = 1, #result do
                local newdata = json.decode(result[i].data)
                laboratory:new({
                    id = result[i].id,
                    crew = result[i].crew,
                    laboType = result[i].laboType,
                    inAction = result[i].InAction,
                    coords = newdata.coords,
                    state = newdata.state,
                    PosWork = nil,
                    minutes = newdata.minutes,
                    maxTime = newdata.maxTime,
                    quantityDrugs = newdata.quantityDrugs,
                    blocked = newdata.blocked,
                    percentages = newdata.percentages,
                    needSave = false
                })                
                if result[i].InAction or newdata.state == 1 then
                    local labo = GetLabo(result[i].id)
                    labo:makeDrug(result[i].id, newdata.minutes, true)
                end
            end
            CorePrint("Loaded all laboratories")
        else
            CoreError("Couldn't load laboratory, empty table or no sql")
        end
    end)
end)

-- Creation laboratory
RegisterNetEvent("core:CreateLaboratory", function(nameCrew, entry, typeLabs)
    local crew = nameCrew
    local _src = source
    local cango = true
    if GetLaboByCrew(nameCrew) then
        TriggerClientEvent("__atoshi::createNotification", _src, {
            type = 'ROUGE',
            content = "Impossible de créer un deuxieme laboratoire pour le crew ".. nameCrew .." !"
        })
        cango = false
    end
    Wait(50)
    if cango then
        if crew == nil then
            TriggerClientEvent("__atoshi::createNotification", _src, {
                type = 'ROUGE',
                content = "Le crew n'existe pas !"
            })
        else
            local datas = {coords = entry, state = 0}
            MySQL.Async.insert("INSERT INTO laboratory (crew, laboType, data) VALUES (@crew, @laboType, @data)"
                , {
                    ['@crew'] = crew,
                    ['@laboType'] = typeLabs,
                    ['@data'] = json.encode(datas)
                }, function(affectedRows)
                    laboratory:new({
                        id = affectedRows,
                        crew = crew,
                        laboType = typeLabs,
                        inAction = 0,
                        coords = entry,
                        state = 0,
                        PosWork = nil,
                        minutes = 0,
                        maxTime = 120,
                        quantityDrugs = 180,
                        blocked = false,
                        percentages = {},
                    })
                    TriggerClientEvent("__atoshi::createNotification", _src, {
                        type = 'VERT',
                        content = "Vous avez bien créé le laboratoire !"
                    })
                    TriggerClientEvent("core:createNewLab", -1, affectedRows, crew, typeLabs, entry)
            end)
        end
    end
end)

RegisterNetEvent("core:labo:ClearKPosWork", function(labid, kid)
    local labo = GetLabo(labid)
    TriggerClientEvents("core:labo:ClearKPosWork", GetAllCrewIds(labo.crew), labid, kid)
end)

RegisterNetEvent("core:labo:PosWork", function(id, PosWork)   
    local labo = GetLabo(id)
    labo:updatePosWork(PosWork)
    if #PosWork == 0 then 
        labo:updateTreated(true)
    end
end)

RegisterNetEvent("core:labo:update", function(time, secu, id, quantitydrogue, state, min)
    local src = source
    local labo = GetLabo(id)
    if CheckTrigger(src, time, secu, "core:labo:update") then
        labo:updateQuantityDrugs(quantitydrogue)
        labo:updateState(state)
        labo:updateMinutes(min)
    end
end)

RegisterNetEvent("core:labo:setOpen", function(token, id, open)
    local labo = GetLabo(id)
    labo:setOpen(open)
    TriggerClientEvents("core:labo:setOpen", GetAllCrewIds(), id, open)
end)

RegisterNetEvent("core:labo:alertCrew", function(token,id,crew)
    TriggerClientEvents("core:labo:alertCrew", GetAllCrewIds(crew), id, crew)
end)


CreateThread(function()
    while RegisterServerCallback == nil do Wait(0) end

    RegisterServerCallback('core:getLaboratory', function(source, token)
        if CheckPlayerToken(source, token) then
            return classlabo
        end
    end)
    
    RegisterServerCallback('core:getMyLab', function(source, token, id)
        if CheckPlayerToken(source, token) then
            local labo = GetLabo(id)
            if labo == nil then return end
            
            return labo
        end
    end)

    RegisterServerCallback("core:IsFinishedLab", function(source, token, id)
        if CheckPlayerToken(source, token) then
            local labo = GetLabo(id)
            labo:updateBlocked(false)
            if labo:getMinutes() <= 0 and labo:getState() == 2 then 
                return labo:getQuantityDrugs()
            else
                return false
            end
        end    
    end)

    RegisterServerCallback("core:labo:getPosWork", function(source, id)
        local labo = GetLabo(id)
        if labo == nil then return end
        
        return labo:getPosWork() 
    end)

    RegisterServerCallback("core:getLabProduction", function(source, token, id)
        local minutesRet = nil
        local percentagesRet = nil
        if CheckPlayerToken(source, token) then
            local labo = GetLabo(id)
            minutesRet = labo:getMinutes()
            percentagesRet = labo:getPercentages()
        end
        return minutesRet, percentagesRet
    end)
end)

RegisterNetEvent("core:labo:LaunchProduction", function(token, ItemsToRemove, LaboType, LaboQuantity, percentages, labid, LaboState, LaboImage, LaboCrewLevel, MaxTimeProd, quantitydrugs, Minutes, poswork)
    local src = source
    if CheckPlayerToken(src, token) then
        local labo = GetLabo(labid)
        labo:updatePosWork(poswork)
        print("labo:getTreated()", labo:getTreated())
        --if labo:getTreated() then 
            labo:updatePercentages(percentages)
            labo:updateMaxTime(MaxTimeProd)
            if percentages[1] <= 0 or percentages[2] <= 0 or percentages[3] <= 0 then
                TriggerClientEvents("core:labo:changeState", GetAllCrewIds(), 0, labid, labo:getMinutes(), false, labo:getPercentages())
                labo:updateState(0)
            else
                print("labo:getState()", labo:getState())
                print("labo:getBlocked()", labo:getBlocked())
                if labo:getState() == 1 or labo:getBlocked() then 
                    print("labo:getLaunched()", labo:getLaunched())
                    if not labo:getLaunched() then
                        print("makeDrug labo:getMinutes()", labo:getMinutes())
                        labo:makeDrug(labid, labo:getMinutes())
                    end
                else
                    labo:updateState(1)
                    print("Minutes", Minutes)
                    if Minutes and Minutes > 2 then
                        labo:updateMinutes(Minutes)
                        if not labo:getLaunched() then
                            labo:makeDrug(labid, Minutes)
                        end
                    else
                        print("MaxTimeProd", MaxTimeProd)
                        if MaxTimeProd == 0 then 
                            labo:updateMinutes(105)
                            print("labo:getLaunched() 1", labo:getLaunched())
                            if not labo:getLaunched() then
                                labo:makeDrug(labid, 105, 105)
                            end
                        else
                            if MaxTimeProd > 20 then
                                labo:updateMinutes(MaxTimeProd)
                                print("labo:getLaunched() 2", labo:getLaunched())
                                if not labo:getLaunched() then
                                    labo:makeDrug(labid, MaxTimeProd)
                                end
                            else
                                labo:updateMinutes(105)
                                print("labo:getLaunched() 3", labo:getLaunched())
                                if not labo:getLaunched() then
                                    labo:makeDrug(labid, MaxTimeProd)
                                end
                            end
                        end
                    end
                end
                Wait(50)
                labo:updateState(1)
                labo:updateBlocked(false)
                labo:updateQuantityDrugs(quantitydrugs)
                LaboState = 1
                print("send", LaboState, quantitydrugs, labid)
                TriggerClientEvents("core:labo:StartProduction", GetAllCrewIds(), labid, {percentages = percentages, activityPercentage = labo:getMinutes(), LabStatee = LaboState, LaboImage = LaboImage, LaboType = LaboType, LaboCrewLevel = LaboCrewLevel, LaboQuantity = LaboQuantity, src = src, quantityDrugs = labo:getQuantityDrugs(), ItemsToRemove = ItemsToRemove})
            end
        --else
        --    print("labo:getPosWork()", labo:getPosWork())
        --    if labo:getPosWork() == nil or next(labo:getPosWork()) == nil then
        --        TriggerClientEvents("core:labo:sendnotif", GetAllCrewIds(labo:getCrew()), labo:getCrew(), LaboType == "weed" and "Vous devez travailler sur vos plantes avant de démarrer la production" or "Vous devez travailler votre drogue avant de démarrer la production", labid, false, true)
        --        TriggerClientEvents("core:labo:changeState", GetAllCrewIds(), 0, labid, labo:getMinutes(), true, labo:getPercentages(), true)
        --    else
        --        TriggerClientEvent("__atoshi::createNotification", src, {
        --            type = 'ROUGE',
        --            content = "Vous devez d'abord finir de travailler votre drogue"
        --        })
        --    end
        --end
    end
end)

RegisterNetEvent("core:labo:PosWorkFinished", function(id)
    local labo = GetLabo(id)
    if labo == nil then return end

    labo:updateTreated(true)
    labo:updatePosWork(nil)
end)

RegisterServerCallback("core:labo:getWorkPos", function(id)
    local labo = GetLabo(id)
    if labo == nil then return end

    return labo:getPosWork()
end)

RegisterNetEvent("core:labo:sonne", function(id, crew)
    local _src = source
    TriggerClientEvent("__atoshi::createNotification", _src, {
        type = 'VERT',
        content = "Vous avez sonné"
    })
    TriggerClientEvents("core:labo:sonne", GetAllCrewIds(crew), id, _src)
end)

RegisterNetEvent("core:labo:acceptsonnette", function(token, id, plyid)
    local src = source
    if CheckPlayerToken(src, token) then
        TriggerClientEvent("core:labo:acceptedsonette", tonumber(plyid), id)
    end
end)

RegisterNetEvent("core:AddPlayerInLabo")
AddEventHandler("core:AddPlayerInLabo", function(token, player, lab)
    if CheckPlayerToken(source, token) then
        if PlayersInLabo[lab] == nil then
            PlayersInLabo[lab] = {}
            table.insert(PlayersInLabo[lab], source)
        else
            table.insert(PlayersInLabo[lab], source)
        end
    end
end)

RegisterNetEvent("core:rmvPlayerInLabo")
AddEventHandler("core:rmvPlayerInLabo", function(token, player, lab)
    if CheckPlayerToken(source, token) then
        for k,v in pairs(PlayersInLabo[lab]) do
            if v == source then
                table.remove(PlayersInLabo[lab], k)
            end
        end
    end
    collectgarbage("collect")
end)

RegisterNetEvent("core:updateLastLabo")
AddEventHandler("core:updateLastLabo", function(token, enter, labid, labo)
    local src = source
    local ID = GetPlayer(src):getId()
    if CheckPlayerToken(src, token) then
        if enter then
            local lastProperty = {}
            table.insert(lastProperty, { id = labid, labo = labo })
            MySQL.Async.execute("UPDATE players SET last_property = @1 WHERE id = @id", {
                ["@1"] = json.encode(lastProperty),
                ["@id"] = ID
            }, function()
            end)
        else
            MySQL.Async.execute("UPDATE players SET last_property = @1 WHERE id = @id", {
                ["@1"] = '',
                ["@id"] = ID
            }, function()
            end)
        end
    end
end)

RegisterNetEvent("core:addItemLabo")
AddEventHandler("core:addItemLabo", function(token, item, count, metadata, idlabo, quantityDrugs)
    local source = source
    local vall = nil
    if not count then return end
    local labo = GetLabo(idlabo)
    if not labo then return end
    Wait(math.random(100, 500)) -- ANTI DUPPLICATION
    local quantityDrugs = labo:getQuantityDrugs()
    if count <= quantityDrugs then 
        for k, v in pairs(GetPlayer(source):getInventaire()) do
            if not DoesPlayerHaveItemCount(source, item, count) then
                vall = GiveItemToPlayer(source, item, count, metadata)
            elseif v.name == item and v.metadatas ~= nil and item ~= "outfit" and item ~= 'tshirt' and item ~= 'ptshirt' and
                item ~= 'pglasses' and item ~= 'phat' and item ~= 'paccs' and item ~= 'ppant' and item ~= 'ppant' and item ~= 'mask' and
                item ~= 'pant' and item ~= 'hat' and item ~= 'access' and item ~= 'glasses' and item ~= 'feet' and item ~= "montre" and
                item ~= "bracelet" and item ~= "bague" and item ~= "bouclesoreilles" and item ~= "collier" and item ~= "ongle" and item ~= "piercing" then
                if items[item].notStackable then
                    vall = GiveItemToPlayer(source, item, count, metadata)
                else
                    vall = GiveItemToPlayer(source, item, count, v.metadatas)
                end
            elseif v.name == item and v.metadatas == nil and item ~= "outfit" and item ~= 'tshirt' and item ~= 'ptshirt' and
                item ~= 'pglasses' and item ~= 'phat' and item ~= 'paccs' and item ~= 'ppant' and item ~= 'mask' and
                item ~= 'pant' and item ~= 'hat' and item ~= 'access' and item ~= 'glasses' and item ~= 'feet' and item ~= "montre" and
                item ~= "bracelet" and item ~= "bague" and item ~= "bouclesoreilles" and item ~= "collier" and item ~= "ongle" and item ~= "piercing" then
                if json.encode(metadata) == "[]" or metadata == nil then
                    metadata = {}
                end
                vall = GiveItemToPlayer(source, item, count, metadata)
            end
        end
        --RefreshPlayerData(source)
        MarkPlayerDataAsNonSaved(source)   
        if vall then  
            local newcount = quantityDrugs - count
            labo:updateQuantityDrugs(newcount)
            TriggerClientEvents("core:receiveAddItemLabo", GetAllCrewIds(), idlabo, newcount, labo:getPercentages(), labo:getlaboType())   
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = 'VERT',
                content = "Vous avez bien récupéré x".. count .." ".. item .." !"
            })
            labo:updateState(2)
            if quantityDrugs - count <= 0 then 
                labo:updatePercentages({0, 0, 0})
                labo:updateQuantityDrugs(0)
                labo:updateState(0)
                labo:updateTreated(false)
                TriggerClientEvent("core:labo:sendnotif", source, labo:getCrew(), 55, idlabo)
            end
        end
    else
        TriggerClientEvent("__atoshi::createNotification", source, {
            type = 'ROUGE',
            content = "Impossible de prendre plus de drogue que votre labo en dispose !"
        })
    end
end)


local WhoCanPickup = {}

RegisterNetEvent("core:labo:ICanPickup", function(id)
    local src = source 
    WhoCanPickup[id] = src
end)

RegisterNetEvent("core:labo:RMCanPickup", function(id)
    local src = source 
    WhoCanPickup[id] = nil
end)

RegisterServerCallback("core:labo:getWhoCanRecup", function(id)
    return WhoCanPickup[id]
end)

RegisterNetEvent("core:labo:deleteLabo", function(token, laboid)
    local source = source 
    local ply = GetPlayer(source)
    if ply:getPermission() < 3 then 
        SunWiseKick(source, "Tried exec core:labo:deleteLabo")
        return
    end
    if CheckPlayerToken(source, token) then
        local labo = GetLabo(laboid)
        labo:deleteLabo()
        TriggerClientEvents("core:labo:gotDeleted", GetAllCrewIds(), laboid)
        TriggerClientEvent("__atoshi::createNotification", source, {
            type = 'VERT',
            content = "Vous avez supprimé le laboratoire n°" .. laboid
        })
    end
end)

RegisterNetEvent("core:labo:rmpeds", function(id)
    local labo = GetLabo(id)
    labo:removeEntities()
end)

RegisterNetEvent('core:labo:instance', function(netid,id)
    local labo = GetLabo(id)
    labo:addEntity(netid)
    local entity = NetworkGetEntityFromNetworkId(netid)
    SetEntityRoutingBucket(entity, id)
end)