local allZone = {}

RegisterNetEvent("core:territoire:UpdateTerritoire")
AddEventHandler("core:territoire:UpdateTerritoire", function(crew, zone, influence)
    local tableExistG, tableExistW, tableExistM = false, false, false
    if not allZone[zone] then return end
    influence = tonumber(influence)
    if influence == nil then return end
    if influence < 1 then return end
    local color = getCrewByName(crew):getColor()
    for k,v in pairs(allZone[zone].global) do
        if v.leader == crew then
            allZone[zone].global[k].influence += influence
            tableExistG = true
        end
    end
    for k,v in pairs(allZone[zone].week) do
        if v.leader == crew then
            allZone[zone].week[k].influence += influence
            tableExistW = true
        end
    end
    for k,v in pairs(allZone[zone].month) do
        if v.leader == crew then
            allZone[zone].month[k].influence += influence
            tableExistM = true
        end
    end
    if tableExistG == false then
        table.insert(allZone[zone].global, {
            leader = crew,
            influence = influence,
            color = color
        })
    end
    if tableExistW == false then
        table.insert(allZone[zone].week, {
            leader = crew,
            influence = influence,
            color = color
        })
    end
    if tableExistM == false then
        table.insert(allZone[zone].month, {
            leader = crew,
            influence = influence,
            color = color
        })
    end
    allZone[zone].needSave = true
    TriggerClientEvent("core:territoire:UpdateTerritoire", -1, crew, zone, influence, allZone[zone].inSouth, color)
end)

local function formatNumber(num)
    if num then
        return tonumber(string.format("%.1f", num))
    end
    return nil
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        for k,v in pairs(allZone) do
            if v.needSave == true then
                MySQL.Async.execute("UPDATE influence SET global = @global, month = @month, week = @week WHERE zone = @zone", {
                    ["@zone"] = v.id,
                    ["@global"] = json.encode(v.global),
                    ["@month"] = json.encode(v.month),
                    ["@week"] = json.encode(v.week)
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        print("Territoire "..k.." sauvegardé")
                        allZone[k].needSave = false
                    end
                end)
            end
        end
    end
end)

function UpdateTerritoireOnWipeCrew(crew)
    local needSaveI = false
    for k,v in pairs(allZone) do 
        for x,z in pairs(v.week) do 
            if z.leader == crew then
                print("Remove weekly influence for crew ", crew)
                table.remove(v.week, x)
                needSaveI = true
            end
        end
        for x,z in pairs(v.global) do 
            if z.leader == crew then
                print("Remove global influence for crew ", crew)
                table.remove(v.global, x)
                needSaveI = true
            end
        end
        for x,z in pairs(v.month) do 
            if z.leader == crew then
                print("Remove month influence for crew ", crew)
                table.remove(v.month, x)
                needSaveI = true
            end
        end
        if needSaveI then
            allZone[k].needSave = true
        end
    end
end

RegisterNetEvent("core:territoire:Notification")
AddEventHandler("core:territoire:Notification", function(leader, action, zone, coords)
    local color
    if leader == "Aucun" then 
        color = "#a2a2a3"
    else
        color = getCrewByName(leader) and getCrewByName(leader):getColor() or "#a2a2a3"
    end
    TriggerClientEvents("core:territoire:Notification", GetAllCrewIds(leader), leader, action, zone, color, coords)
end)


RegisterNetEvent("core:Territoire:creation")
AddEventHandler("core:Territoire:creation", function(name, zone, inSouth)
    if name == nil then return end 
    if zone == nil then return end 
    allZone[name] = {
        ["zone"] = zone,
        ["inSouth"] = inSouth,
        ["global"] = {},
        ["month"] = {},
        ["week"] = {},
        ["needSave"] = false
    }

    for k,v in pairs(zone) do 
        local x,y,z = formatNumber(v.x), formatNumber(v.y), formatNumber(v.z)
        v = vector3(x,y,z)
    end

    MySQL.Async.execute("INSERT INTO territoire (name, zone, south) VALUES (@name, @zone, @south)", {
        ["@name"] = name,
        ["@zone"] = json.encode(zone),
        ["@south"] = inSouth
    }, function(rowsChanged)
        if rowsChanged > 0 then
            MySQL.Async.fetchAll("SELECT id FROM territoire WHERE name = @name", {
                ["@name"] = name
            }, function(result)
                if result[1] ~= nil then
                    allZone[name].id = result[1].id
                    MySQL.Async.execute("INSERT INTO influence (zone, global,month, week) VALUES (@zone, @global, @month, @week)", {
                        ["@zone"] = result[1].id,
                        ["@global"] = json.encode({}),
                        ["@month"] = json.encode({}),
                        ["@week"] = json.encode({})
                    }, function(rowsChanged)
                        if rowsChanged > 0 then
                            print("Territoire "..name.." créé")
                        end
                    end)
                end
            end)
        end
    end)
    TriggerClientEvent("core:territoire:AddTerritoire", -1, name, allZone[name])
end)

RegisterNetEvent("core:Territoire:suppressionInfluence")
AddEventHandler("core:Territoire:suppressionInfluence", function(name,id)
    local src = source 
    local ply = GetPlayer(src)
    if ply:getPermission() < 2 then return end
    MySQL.Async.execute("UPDATE influence SET month=@month, global=@global2, week=@week WHERE zone = @id", {
        ['@id'] = tonumber(id),
        ['@month'] = "[]",
        ['@global2'] = "[]",
        ['@week'] = "[]",
    }, function()
    end)
    if (allZone[name]) then 
        if allZone[name] ~= nil then
            if allZone[name].global then
                for k,v in pairs(allZone[name].global) do
                    table.remove(allZone[name].global, k)
                end
            end
            if allZone[name].week then
                for k,v in pairs(allZone[name].week) do
                    table.remove(allZone[name].week, k)
                end
            end
            if allZone[name].month then
                for k,v in pairs(allZone[name].month) do
                    table.remove(allZone[name].month, k)
                end
            end
        end
    end
    TriggerClientEvent("core:Territoire:ResetInfluence", -1, name, allZone[name] and allZone[name].inSouth or true)
end)

RegisterNetEvent("core:Territoire:suppression")
AddEventHandler("core:Territoire:suppression", function(name,id)
    local src = source 
    local ply = GetPlayer(src)
    if ply:getPermission() < 2 then return end
    MySQL.Async.execute("DELETE FROM influence WHERE zone = @id", {
        ["@id"] = id
    }, function(rowsChanged)
        if rowsChanged > 0 then
            MySQL.Async.execute("DELETE FROM territoire WHERE id = @id", {
                ["@id"] = id
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    print("Territoire "..name.." supprimé")
                    -- send notification to source
                    TriggerClientEvent("__atoshi::createNotification", src, {
                        type = "VERT",
                        content = (name or "?").." a été supprimé",
                    })
                end
            end)
        end
    end)
    allZone[name] = nil
    TriggerClientEvent("core:Territoire:DeleteTerritoire", -1, name)
end)

local function GrosNibarsInfluence(table)
    local returnTable = table

    for k, v in pairs(returnTable) do
        print("v.influence", v.influence)
        if v.influence == nil then
            returnTable[k].influence = 0
        end
    end

    return returnTable
end


AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        MySQL.Async.fetchAll("SELECT t.*, i.global, i.month, i.week FROM territoire t, influence i WHERE t.id = i.zone", {}, function(result)
            if result[1] ~= nil then
                local date = os.date("*t") 
                local jour = date.wday-1
                local jourDuMois = date.day 
                print("Jour semaine num "..jour.." Jour "..jourDuMois)
                if jour == 1 then -- LUNDI, reset la semaine derniere
                    for k,v in pairs(result) do
                        allZone[v.name] = {
                            ["id"] = v.id,
                            ["name"] = v.name,
                            ["zone"] = json.decode(v.zone),
                            ["inSouth"] = v.south,
                            ["global"] = GrosNibarsInfluence(json.decode(v.global)),
                            ["month"] = GrosNibarsInfluence(json.decode(v.month)),
                            ["week"] = {}
                        }
                        allZone[v.name].needSave = true
                    end
                    CorePrint("Les "..#result.." territoires ont été chargés")
                    CorePrint("Les influence de la semaine ont été reset")
                elseif jourDuMois == 1 then -- Premier jour du mois, reset le mois dernier
                    for k,v in pairs(result) do
                        allZone[v.name] = {
                            ["id"] = v.id,
                            ["name"] = v.name,
                            ["zone"] = json.decode(v.zone),
                            ["inSouth"] = v.south,
                            ["global"] = GrosNibarsInfluence(json.decode(v.global)),
                            ["month"] = {},
                            ["week"] = GrosNibarsInfluence(json.decode(v.week))
                        }
                        allZone[v.name].needSave = true
                    end
                    CorePrint("Les "..#result.." territoires ont été chargés")
                    CorePrint("Les influence du mois ont été reset")
                else
                    for k,v in pairs(result) do
                        allZone[v.name] = {
                            ["id"] = v.id,
                            ["name"] = v.name,
                            ["zone"] = json.decode(v.zone),
                            ["inSouth"] = v.south,
                            ["global"] = GrosNibarsInfluence(json.decode(v.global)),
                            ["month"] = GrosNibarsInfluence(json.decode(v.month)),
                            ["week"] = GrosNibarsInfluence(json.decode(v.week))
                        }
                    end
                    CorePrint("Les "..#result.." territoires ont été chargés")
                end
            end
        end)
        Wait(15000)
        local needSaveI = false
        for k,v in pairs(allZone) do 
            for x,z in pairs(v.week) do 
                if not crewTab[z.leader] then
                    print("Remove weekly influence for crew ", z.leader)
                    table.remove(v.week, x)
                    needSaveI = true
                end
            end
            for x,z in pairs(v.global) do 
                if not crewTab[z.leader] then
                    print("Remove global influence for crew ", z.leader)
                    table.remove(v.global, x)
                    needSaveI = true
                end
            end
            for x,z in pairs(v.month) do 
                if not crewTab[z.leader] then
                    print("Remove month influence for crew ", z.leader)
                    table.remove(v.month, x)
                    needSaveI = true
                end
            end
            if needSaveI then
                allZone[k].needSave = true
            end
        end

        InitZoneTerritoire()
    end
end)

function InitZoneTerritoire()
    for k,v in pairs(allZone) do 
        if allZone[k].zone then 
            for a,z in pairs(allZone[k].zone) do 
                z.x = formatNumber(z.x)
                z.y = formatNumber(z.y)
                z.z = formatNumber(z.z)
            end
        end
    end
end

function isPlayerInsideZone(zonePoints, x,y)
    local inZone = false
    local j = #zonePoints

    for i = 1, #zonePoints do
        if zonePoints[i] and zonePoints[j] then
            if ((zonePoints[i].y < y and zonePoints[j].y >= y) or (zonePoints[j].y < y and zonePoints[i].y >= y)) and (zonePoints[i].x <= x or zonePoints[j].x <= x) then
                if zonePoints[i].x + (y - zonePoints[i].y) / (zonePoints[j].y - zonePoints[i].y) * (zonePoints[j].x - zonePoints[i].x) < x then
                    inZone = not inZone
                end
            end
        end
        j = i
    end

    return inZone
end

local RevendiqueZone = {}
RegisterServerCallback("core:Territoire:GetTerritoires", function()
    return allZone
end)

RegisterServerCallback("core:GetCrewTable", function()
    return getCrewInTablet()
end)

RegisterServerCallback("core:getTerritoire", function(source, named)
    return allZone[named]
end)

RegisterServerCallback("core:Territoire:findzone", function(source, pX, pY)
    for k,v in pairs(allZone) do 
        if isPlayerInsideZone(v.zone, pX, pY) then 
            return k
        end
    end
    return nil
end)

RegisterServerCallback("core:getTerritoireGlobal", function(source, named)
    return allZone[named].global
end)

RegisterServerCallback("core:hasZoneBeenTaken", function(source, zonename)
    if not RevendiqueZone[zonename] then 
        RevendiqueZone[zonename] = true
        SetTimeout(15*60000,function()
            RevendiqueZone[zonename] = nil
        end)
        return false
    else
        return true
    end
end)
