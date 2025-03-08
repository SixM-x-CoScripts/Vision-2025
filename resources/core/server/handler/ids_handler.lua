local AllIds = {}

GetAllCrewIds = function(specificCrew, crewType)
    local Tbl = {}
    for k,v in pairs(AllIds) do 
        if specificCrew then
            if v.crew and v.crew == specificCrew then 
                table.insert(Tbl, v.id)
            end
        elseif crewType then 
            if v.crewType and v.crewType == crewType then 
                table.insert(Tbl, v.id)
            end
        else
            if v.crew then
                table.insert(Tbl, v.id)
            end
        end
    end
    return Tbl
end

GetAllSouthIds = function()
    local Tbl = {}
    for k,v in pairs(AllIds) do 
        if v.IsInSouth then 
            table.insert(Tbl, v.id)
        end
    end
    return Tbl
end

GetAllStaff = function()
    local Tbl = {}
    for k,v in pairs(AllIds) do 
        if v.perm ~= 0 and v.perm ~= 1 then 
            table.insert(Tbl, v.id)
        end
    end
    return Tbl
end

GetAllNorthIds = function()
    local Tbl = {}
    for k,v in pairs(AllIds) do 
        if not v.IsInSouth then 
            table.insert(Tbl, v.id)
        end
    end
    return Tbl
end

GetAllBucketIds = function(bucket)
    local Tbl = {}
    for k,v in pairs(AllIds) do 
        if v.Bucket == bucket then 
            table.insert(Tbl, v.id)
        end
    end
    return Tbl
end

GetAllBucketIdsExcept = function(exeptBucket)
    local Tbl = {}
    for k,v in pairs(AllIds) do 
        if v.Bucket ~= exeptBucket then 
            table.insert(Tbl, v.id)
        end
    end
    return Tbl
end

GetAllJobsIds = function(specificJob)
    local Tbl = {}
    for k,v in pairs(AllIds) do 
        if specificJob then
            if type(specificJob) == "string" then
                if v.job and v.job == specificJob then 
                    table.insert(Tbl, v.id)
                end
            elseif type(specificJob) == "table" then
                for q,c in pairs(specificJob) do
                    if v.job and v.job == c then 
                        table.insert(Tbl, v.id)
                    end
                end
            end
        else
            if v.job then
                table.insert(Tbl, v.id)
            end
        end
    end
    return Tbl
end

TriggerClientEvents = function(name, ids, ...)
    if type(ids) == "table" then
        if next(ids) then
            for i,v in ipairs(ids) do
                TriggerClientEvent(name, v, ...)
            end
        end
    else
        if ids and ids == -1 then
            TriggerClientEvent(name, -1, ...)
        else
            print("[Core] Erreur lors d'un TriggerClientEvents, les ids ne sont pas une table. Type : " .. ids .. ". Nom de l'event : " .. name)
        end
    end
end

ChangePlayerBucket = function(src, bucket)
    for i,v in ipairs(AllIds) do 
        if v.id == src then 
            v.bucket = bucket
            return
        end
    end
end

RegisterNetEvent("core:RegisterPlayer", function(crew, job, isInSouth)
    local src = source
    local found = false
    local perm = GetPlayer(src) and GetPlayer(src):getPermission() or 0
    if next(AllIds) then
        for i,v in ipairs(AllIds) do 
            if v.id == src then 
                found = true
                if crew ~= nil and crew ~= "None" then 
                    v.crew = crew 
                end
                if crew ~= nil then 
                    if crew ~= "None" then
                        v.crewType = getCrewByName(crew) and getCrewByName(crew):getType() or "normal"
                    else
                        v.crew = nil
                    end
                end
                if job ~= nil then v.job = job end
                if isInSouth ~= nil then v.IsInSouth = isInSouth end
                v.perm = perm
                return
            end
        end
    end
    if not found then 
        if crew == "None" then
            table.insert(AllIds, {job = job, id = src, IsInSouth = isInSouth, perm = perm})
        else
            local crewtype = getCrewByName(crew) and getCrewByName(crew):getType() or "normal"
            table.insert(AllIds, {crew = crew, crewType = crewtype, job = job, id = src, IsInSouth = isInSouth, perm = perm})
        end
    end
end)

RegisterCommand("getAllIds", function(source)
    if source == 0 then 
    end
end)

AddEventHandler("playerDropped", function(source)
    for i,v in ipairs(AllIds) do 
        if v.src == source then 
            table.remove(AllIds,k)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(5 * 60000)
        for k, v in pairs(AllIds) do
            if GetPlayerPing(k) == 0 then
                table.remove(AllIds,k)
            end
            Wait(1000)
        end
    end
end)