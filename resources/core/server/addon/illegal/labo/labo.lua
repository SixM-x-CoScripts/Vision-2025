--[[Laboratory = {}   
PlayersInLabo = {}

CreateThread(function()
    while (GetResourceState("core") ~= "started") do 
        Wait(0)
    end
    while not MySQL do Wait(1) end
    FetchLabs()
end)

Citizen.CreateThread(function()
    while true do
        TriggerEvent("watcher:server:SendTableInfo", "labo:PlayersInLabo", PlayersInLabo)
        Wait(5000)
    end
end)

function FetchLabs(shouldsend)
    if not shouldsend then
        Laboratory = {}
        MySQL.Async.fetchAll("SELECT * FROM laboratory", {}, function(result)
            if result ~= nil then
                for i = 1, #result do
                    local newdata = json.decode(result[i].data)

                    if result[i].InAction then
                        MakeDrugs(result[i].id, result[i].InAction, true)
                    end

                    table.insert(Laboratory, {
                        id = result[i].id,
                        crew = result[i].crew,
                        laboType = result[i].laboType,
                        inAction = result[i].InAction,
                        data = result[i].data,
                        minutes = newdata.minutes,
                        maxTime = newdata.maxTime,
                        quantityDrugs = newdata.quantityDrugs,
                        blocked = newdata.blocked,
                        percentages = newdata.percentages,
                    })
                end
                CorePrint("Laboratory loaded")
            else
                CoreError("Laboratory not loaded")
            end
        end)
    end
    Wait(200)
    if shouldsend then 
        TriggerClientEvents("core:labo:updateLabs", GetAllCrewIds())
    end
end

RegisterNetEvent("core:labo:ClearKPosWork", function(labid, kid)
    for k,v in pairs(Laboratory) do 
        if v.id == labid then
            TriggerClientEvents("core:labo:ClearKPosWork", GetAllCrewIds(v.crew), labid, kid)
        end
    end
end)

--RegisterCommand("tstComm", function(source)
--    local src = source
--    TriggerClientEvent("core:labo:sendnotif", src, "Families ", "Hey, il te manque des ingrédients pour ta came", 63, true)
--end)

FinishedLabs = {}

function MakeDrugs(id, minutes, shouldUseNewInfo) -- ## 2 instances qui se créer 
    Citizen.CreateThread(function()
        if shouldUseNewInfo then
            for k,v in pairs(Laboratory) do 
                if v.id == id then 
                    v.launched = true
                    v.minutes = minutes
                end
            end
        end
        while true do
            Citizen.Wait(60000)
            for k,v in pairs(Laboratory) do 
                if not v.minutes then 
                    v.minutes = minutes
                end
                if v.id == id then
                    if v.minutes <= 0 then 
                        if v.state ~= 2 then
                            v.state = 2
                            FinishedLabs[v.id] = v.quantityDrugs
                            v.minutes = 0
                            v.quantityDrugs = v.quantity
                            v.launched = false
                            TriggerClientEvents("core:labo:finished", GetAllCrewIds(), v.id, v.percentages, v.quantity, v.laboType)
                            TriggerClientEvents("core:labo:sendnotif", GetAllCrewIds(v.crew), v.crew, "Votre production de " .. v.laboType .. " est terminée", v.id, true)
                            break
                        end
                    else
                        v.state = 1
                        v.launched = true
                        if not v.blocked then
                            if not v.percentages then -- bizarre mais azy on le trust
                                v.minutes = v.minutes - 1
                            else
                                if v.percentages[1] > 0 and v.percentages[2] > 0 and v.percentages[3] > 0 then  
                                    v.minutes = v.minutes - 1
                                    v.sentNotif = false
                                    if math.fmod(v.minutes, 2) == 0 then -- modulo
                                        local percen = (v.minutes/v.maxTime)*100
                                        v.percentages[1] = math.floor(percen)+1.0 --v.percentages[1] - 0.5
                                        v.percentages[2] = math.floor(percen)+1.0 --v.percentages[2] - 0.5
                                        v.percentages[3] = math.floor(percen)+1.0 --v.percentages[3] - 0.5
                                    end
                                else
                                    if not v.sentNotif then -- don't spam
                                        v.state = 0
                                        v.sentNotif = true
                                        TriggerClientEvents("core:labo:changeState", GetAllCrewIds(), 0, v.id, v.minutes, false, v.percentages)
                                        TriggerClientEvents("core:labo:sendnotif", GetAllCrewIds(v.crew), v.crew, "Hey, il te manque des ingrédients pour ta came", v.id, true)
                                    end
                                end
                            end
                            if v.minutes == math.floor(v.maxTime/2) then
                                v.blocked = true
                                v.hasPlantTreated = false
                                TriggerClientEvents("core:labo:sendnotif", GetAllCrewIds(v.crew), v.crew, "Hey, la permière tournée de came est finis, viens compléter ta production", v.id, true)
                                TriggerClientEvents("core:labo:changeState", GetAllCrewIds(), 0, v.id, v.minutes, true, v.percentages)        
                            end
                        end
                    end
                end
            end
        end
    end)
end

RegisterNetEvent("core:labo:PosWork", function(id, PosWork)    
    for k,v in pairs(Laboratory) do 
        if v.id == id then 
            v.PosWork = PosWork
            if #PosWork == 0 then 
                v.hasPlantTreated = true
            end
        end
    end
end)

RegisterNetEvent("core:labo:update", function(time, secu, id, quantitydrogue, state, min)
    local src = source
    if CheckTrigger(src, time, secu, "core:labo:update") then
        for k,v in pairs(Laboratory) do 
            if v.id == id then 
                v.quantityDrugs = quantitydrogue
                v.state = state
                v.minutes = min
            end
        end
    end
end)

RegisterNetEvent("core:labo:setOpen", function(token, id, open)
    for k,v in pairs(Laboratory) do 
        if v.id == id then 
            v.open = open
            TriggerClientEvents("core:labo:setOpen", GetAllCrewIds(), id, open)
        end
    end
end)

RegisterNetEvent("core:labo:alertCrew", function(token,id,crew)
    TriggerClientEvents("core:labo:alertCrew", GetAllCrewIds(crew), id, crew)
end)

CreateThread(function()
    while true do 
        Wait(2 * 60000)
        for k,v in pairs(Laboratory) do
            local dec = json.decode(v.data)
            local InAction
            if v.state == 1 and v.minutes then InAction = v.minutes end
            local datae = {coords = dec.coords, state = v.state, minutes = v.minutes, percentages = v.percentages, quantityDrugs = v.quantityDrugs, blocked = v.blocked, PosWork = json.encode(v.PosWork), maxTime = v.maxTime}
       --     print("[Labo] SAVE inaction, ", InAction, v.id, json.encode(datae))
            MySQL.Async.execute("UPDATE laboratory SET data=@data, InAction=@action WHERE id=@id",
            {
                ['@data'] = json.encode(datae),
                ['@action'] = InAction,
                ['@id'] = v.id,
            })
        end
    end
end)

CreateThread(function()
    while RegisterServerCallback == nil do Wait(0) end

    RegisterServerCallback('core:getLaboratory', function(source, token)
        if CheckPlayerToken(source, token) then
            return Laboratory
        end
    end)

    RegisterServerCallback("core:IsFinishedLab", function(source, token, id)
        if CheckPlayerToken(source, token) then
            return FinishedLabs[id]
        end    
    end)

    RegisterServerCallback("core:labo:getPosWork", function(source, id)
        local toreturn = nil
        for k, v in pairs(Laboratory) do 
            if v.id == id then 
                if v.PosWork then 
                    toreturn = v.PosWork
                end
            end
        end
        return toreturn        
    end)

    RegisterServerCallback("core:getInstancedEntities", function(source, token, id)
        local toreturn = nil
        if CheckPlayerToken(source, token) then
            for k, v in pairs(Laboratory) do 
                if v.id == id then 
                    if v.instancedentities then 
                        toreturn = v.instancedentities
                    end
                end
            end
        end
        return toreturn
    end)

    RegisterServerCallback("core:getLabProduction", function(source, token, id)
        local toreturn = nil
        local toreturn2 = nil
        if CheckPlayerToken(source, token) then
            for k, v in pairs(Laboratory) do 
                if v.id == id then 
                    if v.minutes then 
                        toreturn = v.minutes
                    end
                    if v.percentages then 
                        toreturn2 = v.percentages
                    end
                end
            end
        end
        return toreturn, toreturn2
    end)

    RegisterServerCallback("core:labo:getCrews", function(token)
        return CrewAcces
    end)
end)

-- Creation laboratory
RegisterNetEvent("core:CreateLaboratory", function(nameCrew, entry, typeLabs)
    local crew = nameCrew
    local _src = source
    local cango = true
    for k,v in pairs(Laboratory) do 
        if v.crew == nameCrew then 
            TriggerClientEvent("__atoshi::createNotification", _src, {
                type = 'ROUGE',
                content = "Impossible de créer un deuxieme laboratoire pour le crew ".. nameCrew .." !"
            })
            cango = false
        end
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
            MySQL.Async.execute("INSERT INTO laboratory (crew, laboType, data) VALUES (@crew, @laboType, @data)"
                , {
                    ['@crew'] = crew,
                    ['@laboType'] = typeLabs,
                    ['@data'] = json.encode(datas)
                }, function(affectedRows)
                CorePrint("Labo created")
                if affectedRows then
                    TriggerClientEvent("__atoshi::createNotification", _src, {
                        type = 'VERT',
                        content = "Vous avez bien créé le laboratoire !"
                    })
                else
                    TriggerClientEvent("__atoshi::createNotification", _src, {
                        type = 'ROUGE',
                        content = "ERREUR SQL !"
                    })
                end
            end)
            Wait(150)
            local newid = nil
            MySQL.Async.fetchAll("SELECT id FROM laboratory WHERE crew=@crew", {
                ['@crew'] = crew
            }, function(result)
                if result ~= nil then
                    if result[1] and result[1].id then 
                        newid = result[1].id
                    end
                end
            end)
            Wait(50)
            if newid then
                table.insert(Laboratory, {
                    id = newid,
                    crew = crew,
                    laboType = typeLabs,
                    data = json.encode({coords = entry, state = 0}),
                })
            end
            Wait(20)
            FetchLabs(true)
        end
    end
end)

RegisterServerCallback("core:labo:HasAlreadyLaunched", function()
    
end)

RegisterNetEvent("core:labo:LaunchProduction", function(token, ItemsToRemove, LaboType, LaboQuantity, percentages, labid, LaboState, LaboImage, LaboCrewLevel, MaxTimeProd, quantitydrugs, Minutes, poswork)
    local src = source
    if CheckPlayerToken(src, token) then
        for k,v in pairs(Laboratory) do 
            if v.id == labid then 
                v.PosWork = poswork
                --print("LaboType, LaboQuantity, percentages, labid, LaboState, LaboImage, LaboCrewLevel, MaxTimeProd, quantitydrugs, Minutes")
                --print(LaboType, LaboQuantity, percentages, labid, LaboState, LaboImage, LaboCrewLevel, MaxTimeProd, quantitydrugs, Minutes)
                if v.hasPlantTreated == true then
                    v.percentages = percentages
                    v.maxTime = MaxTimeProd
                    if v.percentages[1] <= 0 or v.percentages[2] <= 0 or v.percentages[3] <= 0 then
                        TriggerClientEvents("core:labo:changeState", GetAllCrewIds(), 0, labid, v.minutes, false, v.percentages)
                        v.state = 0
                    else
                        if v.state == 1 or v.blocked then 
                            if not v.launched then
                                MakeDrugs(labid, v.minutes)
                            end
                        else
                            v.state = 1
                            if Minutes and Minutes ~= 0 then
                                v.minutes = Minutes
                                if not v.launched then
                                    MakeDrugs(labid, Minutes)
                                end
                            else
                                if MaxTimeProd == 0 then 
                                    v.minutes = 105
                                    if not v.launched then
                                        MakeDrugs(labid, 105, 105)
                                    end
                                else
                                    v.minutes = MaxTimeProd
                                    if not v.launched then
                                        MakeDrugs(labid, MaxTimeProd)
                                    end
                                end
                            end
                        end
                        Wait(50)
                        v.state = 1
                        v.blocked = false
                        v.quantityDrugs = quantitydrugs
                        LaboState = 1
                        TriggerClientEvents("core:labo:StartProduction", GetAllCrewIds(), labid, {percentages = percentages, activityPercentage = v.minutes, LabStatee = LaboState, LaboImage = LaboImage, LaboType = LaboType, LaboCrewLevel = LaboCrewLevel, LaboQuantity = LaboQuantity, src = src, quantityDrugs = v.quantityDrugs, ItemsToRemove = ItemsToRemove})
                    end
                else 
                    if v.PosWork == nil then
                        TriggerClientEvents("core:labo:sendnotif", GetAllCrewIds(v.crew), v.crew, LaboType == "weed" and "Vous devez travailler sur vos plantes avant de démarrer la production" or "Vous devez travailler votre drogue avant de démarrer la production", v.id, false, true)
                        TriggerClientEvents("core:labo:changeState", GetAllCrewIds(), 0, labid, v.minutes, true, v.percentages, true)
                    else
                        TriggerClientEvent("__atoshi::createNotification", src, {
                            type = 'ROUGE',
                            content = "Vous devez d'abord finir de travailler votre drogue"
                        })
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("core:labo:PosWorkFinished", function(id)
    for k,v in pairs(Laboratory) do 
        if v.id == id then 
            v.hasPlantTreated = true
            v.PosWork = nil
        end
    end
end)

RegisterServerCallback("core:labo:getWorkPos", function(id)
    for k,v in pairs(Laboratory) do 
        if v.id == id then 
            return v.PosWork
        end
    end
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

RegisterNetEvent('core:labo:instance', function(netid,id)
    if type(netid) ~= "table" then
        local entity = NetworkGetEntityFromNetworkId(netid)
        SetEntityRoutingBucket(entity, id)

        for k,v in pairs(Laboratory) do 
            if v.id == id then 
                if v.instancedentities then
                    table.insert(v.instancedentities, netid)
                else
                    v.instancedentities = {}
                    table.insert(v.instancedentities, netid)
                end
            end
        end
    else
        for i, v in ipairs(netid) do
            local entity = NetworkGetEntityFromNetworkId(v)
            SetEntityRoutingBucket(entity, id)
            for k,v in pairs(Laboratory) do 
                if v.id == id then 
                    if v.instancedentities then
                        table.insert(v.instancedentities, v)
                    else
                        v.instancedentities = {}
                        table.insert(v.instancedentities, v)
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('core:labo:rminstance', function(netid,id)
    for k,v in pairs(Laboratory) do 
        if v.id == id then 
            if v.instancedentities then 
                for i,y in pairs(v.instancedentities) do 
                    if y == netid then 
                        table.remove(v.instancedentities, i)
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("core:updateLastLabo")
AddEventHandler("core:updateLastLabo", function(token, enter, labid, labo)
    local source = source
    local ID = GetPlayer(source):getId()
    if CheckPlayerToken(source, token) then
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
    if CheckPlayerToken(source, token) then
        for k, v in pairs(GetPlayer(source):getInventaire()) do
            if not DoesPlayerHaveItemCount(source, item, count) then
                vall = GiveItemToPlayer(source, item, count, metadata)
                goto finish
            elseif v.name == item and v.metadatas ~= nil and item ~= "outfit" and item ~= 'tshirt' and item ~= 'ptshirt' and
                item ~= 'pglasses' and item ~= 'phat' and item ~= 'paccs' and item ~= 'ppant' and item ~= 'ppant' and item ~= 'mask' and
                item ~= 'pant' and item ~= 'hat' and item ~= 'access' and item ~= 'glasses' and item ~= 'feet' and item ~= "montre" and
                item ~= "bracelet" and item ~= "bague" and item ~= "bouclesoreilles" and item ~= "collier" and item ~= "ongle" and item ~= "piercing" then
                if items[item].notStackable then
                    vall = GiveItemToPlayer(source, item, count, metadata)
                else
                    vall = GiveItemToPlayer(source, item, count, v.metadatas)
                end
                goto finish
            elseif v.name == item and v.metadatas == nil and item ~= "outfit" and item ~= 'tshirt' and item ~= 'ptshirt' and
                item ~= 'pglasses' and item ~= 'phat' and item ~= 'paccs' and item ~= 'ppant' and item ~= 'mask' and
                item ~= 'pant' and item ~= 'hat' and item ~= 'access' and item ~= 'glasses' and item ~= 'feet' and item ~= "montre" and
                item ~= "bracelet" and item ~= "bague" and item ~= "bouclesoreilles" and item ~= "collier" and item ~= "ongle" and item ~= "piercing" then
                if json.encode(metadata) == "[]" or metadata == nil then
                    metadata = {}
                end
                vall = GiveItemToPlayer(source, item, count, metadata)
                goto finish
            end
        end
        --RefreshPlayerData(source)
        MarkPlayerDataAsNonSaved(source)
    end
    ::finish::
    if vall then
        for k,vs in pairs(Laboratory) do 
            if vs.id == idlabo then 
                if vs.quantityDrugs ~= nil then
                    if vs.quantityDrugs - count >= 0 then
                        local newcount = vs.quantityDrugs - count
                        vs.quantityDrugs = newcount
                        FinishedLabs[vs.id] = newcount
                        TriggerClientEvents("core:receiveAddItemLabo", GetAllCrewIds(), idlabo, newcount) 
                        TriggerClientEvent("__atoshi::createNotification", source, {
                            type = 'VERT',
                            content = "Vous avez bien récupéré x".. count .." ".. item .." !"
                        })
                        vs.state = 2
                    end
                else
                    vs.quantityDrugs = quantityDrugs
                    if vs.quantityDrugs - count >= 0 then
                        local newcount = vs.quantityDrugs - count
                        vs.quantityDrugs = newcount
                        FinishedLabs[vs.id] = newcount
                        TriggerClientEvents("core:receiveAddItemLabo", GetAllCrewIds(), idlabo, newcount) 
                        TriggerClientEvent("__atoshi::createNotification", source, {
                            type = 'VERT',
                            content = "Vous avez bien récupéré x".. count .." ".. item .." !"
                        })
                        vs.state = 2
                    else
                        TriggerClientEvent("__atoshi::createNotification", source, {
                            type = 'VERT',
                            content = "Impossible de prendre plus de drogue que votre labo en dispose !"
                        })
                    end
                end                
                if quantityDrugs - count <= 0 then 
                    vs.percentages[1] = 0 
                    vs.percentages[2] = 0 
                    vs.percentages[3] = 0
                    vs.quantityDrugs = 0
                    vs.state = 0
                    vs.hasPlantTreated = false
                    FinishedLabs[vs.id] = nil
                    TriggerClientEvent("core:labo:sendnotif", source, vs.crew, 55, vs.id)
                end
            end
        end
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
    if CheckPlayerToken(source, token) then
        for k,v in pairs(Laboratory) do 
            if v.id == laboid then 
                MySQL.Async.execute("DELETE FROM laboratory WHERE id = @laboid", { ['@laboid'] = laboid })
                TriggerClientEvents("core:labo:gotDeleted", GetAllCrewIds(), laboid)
                table.remove(Laboratory, k)
                TriggerClientEvent("__atoshi::createNotification", source, {
                    type = 'VERT',
                    content = "Vous avez supprimé le laboratoire n°" .. laboid
                })
            end
        end
    end
end)]]