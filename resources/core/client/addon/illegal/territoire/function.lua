territoireSud = {}
territoireNord = {}
crewTab = {}
local TerritoriesNeedSave = {}

NotifImageIA = {
    {name = "Howard", lien = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/11871954819531448521187719711790727268image.webp"},
    {name = "Shawn", lien = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/11871954819531448521187719763242254376image.webp"},
    {name = "Denise", lien = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/11871954819531448521187719811581628517image.webp"},
    {name = "Miguel", lien = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/11871954819531448521187719857416962099image.webp"},
    {name = "Allison", lien = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/11871954819531448521187719913427714168image.webp"},
    {name = "Jerry", lien = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/11871954819531448521187720076607098911image.webp"},
    {name = "Lester", lien = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/11871954819531448521187719957442744320image.webp"},
    --{name = "Bruce", lien = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/11871954819531448521187720455784763454image.webp"},
    {name = "Emma", lien = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/11871954819531448521187720160707084380image.webp"},
    {name = "Bonnie", lien = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/11871954819531448521187720276474073248image.webp"},
    {name = "Kenji", lien = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/11871954819531448521187720365225545800image.webp"},
    {name = "Franck", lien = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/11871954819531448521187720396473126943image.webp"},
    {name = "Andrew", lien = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/11871954819531448521187720455784763454image.webp"},
    {name = "Ricky", lien = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/11871954819531448521187720545312198726image.webp"},
    {name = "Jimmy", lien = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/11871954819531448521187720600668610681image.webp"},
    {name = "Crystal", lien = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/11871954819531448521187720700258164756image.webp"},
}

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

function InsertTerritoireInTable(name, zone)
    if zone.inSouth == true then
        territoireSud[name] = zone
    else
        territoireNord[name] = zone
    end
end

function DeleteTerritoireInTable(name)
    if territoireSud[name] ~= nil then
        territoireSud[name] = nil
    else
        territoireNord[name] = nil
    end
end

function GetZoneByName(name)
    local foundzone
    if territoireSud[name] or territoireNord[name] then
        if TerritoriesNeedSave[name] then 
            TerritoriesNeedSave[name] = nil
            --print("GetZoneByName | needSave", name)
            foundzone = TriggerServerCallback("core:getTerritoire", name)
            --print("GetZoneByName | foundzone.inSouth", foundzone.inSouth)
            if foundzone.inSouth then 
                foundzone = territoireSud[name]
            else 
                foundzone = territoireNord[name]
            end
        else
            if territoireSud[name] then
                foundzone = territoireSud[name]
            elseif territoireNord[name] then
                foundzone = territoireNord[name]
            end
        end
    else
        foundzone = TriggerServerCallback("core:getTerritoire", name)
        --print("GetZoneByName | foundzone", foundzone)
        if foundzone.inSouth then 
            territoireSud[name] = foundzone
        else
            territoireNord[name] = foundzone
        end
    end
    return foundzone
end

function GetZoneByPlayer()
    local pX, pY, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
    local foundzone = TriggerServerCallback("core:Territoire:findzone", pX, pY)
    return foundzone
end



function DrawWall(x1, y1, z1, x2, y2, z2, r, g, b, a)

    local color = {r, g, b, a}

    local a = {x = x1, y = y1, z = z1}
    local b = {x = x1, y = y1, z = z1+50.0}
    local c = {x = x2, y = y2, z = z2}
    local d = {x = x2, y = y2, z = z2+50.0}

    DrawPoly(a.x, a.y, a.z, 
             b.x, b.y, b.z, 
             c.x, c.y, c.z, 
             color[1], color[2], color[3], color[4])

    DrawPoly(c.x, c.y, c.z, 
             b.x, b.y, b.z, 
             a.x, a.y, a.z,
             color[1], color[2], color[3], color[4])

    DrawPoly(b.x, b.y, b.z, 
             c.x, c.y, c.z, 
             d.x, d.y, d.z, 
             color[1], color[2], color[3], color[4])

    DrawPoly(d.x, d.y, d.z,
             c.x, c.y, c.z,
             b.x, b.y, b.z,
             color[1], color[2], color[3], color[4])
end

function InitTerritoire()
    --local territoires = TriggerServerCallback("core:Territoire:GetTerritoires")
    --while territoires == nil do Wait(0) end
    --for k,v in pairs(territoires) do
    --    InsertTerritoireInTable(k,v)
    --end
end

RegisterNetEvent("core:territoire:AddTerritoire")
AddEventHandler("core:territoire:AddTerritoire", function(name, zone)
    InsertTerritoireInTable(name, zone)
end)

RegisterNetEvent("core:Territoire:DeleteTerritoire")
AddEventHandler("core:Territoire:DeleteTerritoire", function(name)
    DeleteTerritoireInTable(name)
end)

RegisterNetEvent("core:Territoire:ResetInfluence", function(name, south)
    TerritoriesNeedSave[zone] = true
    ResetInfluenceInTerritoireClient(name, south)
end)

RegisterNetEvent("core:territoire:UpdateTerritoire")
AddEventHandler("core:territoire:UpdateTerritoire", function(crew, zone, influence, south, color)
    TerritoriesNeedSave[zone] = true
    AddInfluenceInTerritoireClient(crew, zone, influence, south, color)
end)

CreateThread(function()
    Wait(10000)
    --InitTerritoire()
    crewTab = TriggerServerCallback("core:GetCrewTable")
end)

RegisterNetEvent("core:UpdateCrewTable")
AddEventHandler("core:UpdateCrewTable", function(name)
    crewTab[name] = true
end)

function AddInfluenceInTerritoireClient(crew, zone, influence, south, color)
    local shouldgo = true
    if not territoireSud[zone] and not territoireNord[zone] then 
        local territoire = TriggerServerCallback("core:getTerritoire", zone)
        if territoire then 
            if territoire.inSouth then 
                territoireSud[zone] = territoire
            else
                territoireSud[zone] = territoire
            end
        else
            shouldgo = false
            return
        end
    end
    if not shouldgo then return end
    local tableExistG, tableExistW, tableExistM = false, false, false
    if south then
        if territoireSud[zone] ~= nil then
            for k,v in pairs(territoireSud[zone].global) do
                if v.leader == crew then
                    territoireSud[zone].global[k].influence += influence
                    tableExistG = true
                end
            end
            for k,v in pairs(territoireSud[zone].week) do
                if v.leader == crew then
                    territoireSud[zone].week[k].influence += influence
                    tableExistW = true
                end
            end
            for k,v in pairs(territoireSud[zone].month) do
                if v.leader == crew then
                    territoireSud[zone].month[k].influence += influence
                    tableExistM = true
                end
            end
            if tableExistG == false then
                table.insert(territoireSud[zone].global, {
                    leader = crew,
                    influence = influence,
                    color = color
                })
            end
            if tableExistW == false then
                table.insert(territoireSud[zone].week, {
                    leader = crew,
                    influence = influence,
                    color = color
                })
            end
            if tableExistM == false then
                table.insert(territoireSud[zone].month, {
                    leader = crew,
                    influence = influence,
                    color = color
                })
            end
        end
    else
        if territoireNord[zone] ~= nil then
            for k,v in pairs(territoireNord[zone].global) do
                if v.leader == crew then
                    territoireNord[zone].global[k].influence += influence
                    tableExistG = true
                end
            end
            for k,v in pairs(territoireNord[zone].week) do
                if v.leader == crew then
                    territoireNord[zone].week[k].influence += influence
                    tableExistW = true
                end
            end
            for k,v in pairs(territoireNord[zone].month) do
                if v.leader == crew then
                    territoireNord[zone].month[k].influence += influence
                    tableExistM = true
                end
            end
            if tableExistG == false then
                table.insert(territoireNord[zone].global, {
                    leader = crew,
                    influence = influence,
                    color = color
                })
            end
            if tableExistW == false then
                table.insert(territoireNord[zone].week, {
                    leader = crew,
                    influence = influence,
                    color = color
                })
            end
            if tableExistM == false then
                table.insert(territoireNord[zone].month, {
                    leader = crew,
                    influence = influence,
                    color = color
                })
            end
        end
    end
    ResetNoSpamSecuro()
end

function ResetInfluenceInTerritoireClient(zone, south)
    if not territoireSud[zone] and not territoireNord[zone] then 
        territoire = TriggerServerCallback("core:getTerritoire", zone)
        if territoire then
            if territoire.inSouth then 
                territoireSud[zone] = territoire
            else
                territoireSud[zone] = territoire
            end
        else
            return
        end
    end
    if south then
        if territoireSud[zone] ~= nil then
            for k,v in pairs(territoireSud[zone].global) do
                territoireSud[zone].global[k].influence = 0
            end
            for k,v in pairs(territoireSud[zone].week) do
                territoireSud[zone].week[k].influence = 0
            end
            for k,v in pairs(territoireSud[zone].month) do
                territoireSud[zone].month[k].influence = 0
            end
        else
            if territoireNord[zone] ~= nil then
                for k,v in pairs(territoireNord[zone].global) do
                    territoireNord[zone].global[k].influence = 0
                end
                for k,v in pairs(territoireNord[zone].week) do
                    territoireNord[zone].week[k].influence = 0
                end
                for k,v in pairs(territoireNord[zone].month) do
                    territoireNord[zone].month[k].influence = 0
                end
            end
        end
    else
        if territoireNord[zone] ~= nil then
            for k,v in pairs(territoireNord[zone].global) do
                territoireNord[zone].global[k].influence = 0
            end
            for k,v in pairs(territoireNord[zone].week) do
                territoireNord[zone].week[k].influence = 0
            end
            for k,v in pairs(territoireNord[zone].month) do
                territoireNord[zone].month[k].influence = 0
            end
        end
    end
    ResetNoSpamSecuro()
end


function ActionInTerritoire(crew, zone, influence, action, south)
    local territoire
    printDev('Zone :', zone)
    if not territoireNord[zone] and not territoireSud[zone] then
        territoire = TriggerServerCallback("core:getTerritoire", zone)
        printDev("territoire", json.encode(territoire), zone)
        if territoire then
            if territoire.inSouth then 
                territoireSud[zone] = territoire
            else
                territoireSud[zone] = territoire
            end
        end
    end
    if territoire or territoireSud[zone] or territoireNord[zone] then
        local zoneSelect = nil
        if crewTab[crew] ~= nil then
            TriggerServerEvent("core:territoire:UpdateTerritoire", crew, zone, tonumber(influence), south)
        end
        printDev("Been to crewTab")
        if south then
            printDev("Go check sud")
            if territoireSud[zone] then
                zoneSelect = territoireSud[zone].global
            end
        else
            printDev("Go check north")
            if territoireNord[zone] then
                zoneSelect = territoireNord[zone].global
            end
        end
        ResetNoSpamSecuro()
        printDev("Good checks")
        printDev("zoneSelect", zoneSelect, json.encode(zoneSelect))
        local first = getFirstZone(zoneSelect)
        printDev("Check first")
        if first and first[1] then
            if first[1].leader ~= "Aucun" then
                printDev("first[1].leader et ton crew", first[1].leader, crew)
                if first[1].leader ~= crew then
                    printDev("Envoi notif au leader")
                    TriggerServerEvent("core:territoire:Notification", first[1].leader, action, zone, GetEntityCoords(PlayerPedId()))
                end 
            end
        end
    end
end



function getTopFiveTerritoire(zone)
    local result = {}
    
    table.sort(zone, function(a,b) return a.influence>b.influence end)
    
    print("Top Five Territoire")
    for i = 1, 5 do
        print(json.encode(zone[i]))
        if zone[i] then
            if zone[i].influence ~= 12000 then
                table.insert(result, zone[i])
            end
        else
            table.insert(result, { leader= "Aucun", influence = 0, color = "#a2a2a3"})
        end
    end
    
    return result
end

function getFirstZone(zone)
    local result = {}

    if not zone then return end
    
    table.sort(zone, function(a,b) 
        if not a or not b then return end
        return a.influence>b.influence 
    end)
    
    for i = 1, 1 do
        if zone[i] then
            table.insert(result, zone[i])
        else
            table.insert(result, { leader= "Aucun", influence = 0, color = "#a2a2a3"})
        end
    end
    
    return result
end

RegisterNetEvent("core:territoire:Notification")
AddEventHandler("core:territoire:Notification", function(leader, action, zone, color, coords)
    if p:getCrew() == leader then
        DonneLaNotif(action, zone, color, coords)
    end
end)

function DonneLaNotif(type, zone, color, coords)
    local notifdata = NotifImageIA[math.random(1, #NotifImageIA)]
    if type == 1 then -- Braquage Binco
        exports['vNotif']:createNotification({
            type = "ILLEGAL",
            name = notifdata.name,
            label = zone,
            labelColor = color,
            logo = notifdata.lien,
            mainMessage = "Yo, y’a un mec qui est en train de voler l’oseille du Binco !",
            duration = 10,
        })

    elseif type == 2 then -- Braque Supérette
        exports['vNotif']:createNotification({
            type = "ILLEGAL",
            name = notifdata.name,
            label = zone,
            labelColor = color,
            logo = notifdata.lien,
            mainMessage = "Hey, y'a un man qui braque ta supérette !",
            duration = 10,
        })

    elseif type == 3 then -- Braquage Fleeca
        exports['vNotif']:createNotification({
            type = "ILLEGAL",
            name = notifdata.name,
            label = zone,
            labelColor = color,
            logo = notifdata.lien,
            mainMessage = "Salut, des gens braque la fleeca de chez toi !",
            duration = 10,
        })

    elseif type == 4 then -- Braquage Brinks
        exports['vNotif']:createNotification({
            type = "ILLEGAL",
            name = notifdata.name,
            label = zone,
            labelColor = color,
            logo = notifdata.lien,
            mainMessage = "Yo, des mecs vole un camion sur ta zone !",
            duration = 10,
        })

    elseif type == 5 then -- Vol à l'arracher
        exports['vNotif']:createNotification({
            type = "ILLEGAL",
            name = notifdata.name,
            label = zone,
            labelColor = color,
            logo = notifdata.lien,
            mainMessage = "Big up, j'ai cru voir des gens voler des sacs à main des tantines de chez toi !",
            duration = 10,
        })

    elseif type == 6 then -- Vol de véhicules
        exports['vNotif']:createNotification({
            type = "ILLEGAL",
            name = notifdata.name,
            label = zone,
            labelColor = color,
            logo = notifdata.lien,
            mainMessage = "Yo, un mec vole un véhicule dans les parages, viens vérifier !",
            duration = 10,
        })

    elseif type == 7 then -- Vente de drogue
        exports['vNotif']:createNotification({
            type = "ILLEGAL",
            name = notifdata.name,
            label = zone,
            labelColor = color,
            logo = notifdata.lien,
            mainMessage = "Hey, j'ai cru apercevoir des gars vendre de la cam dans le coin, amènes toi !",
            duration = 10,
        })
    elseif type == 8 then -- Tag
        exports['vNotif']:createNotification({
            type = "ILLEGAL",
            name = notifdata.name,
            label = zone,
            labelColor = color,
            logo = notifdata.lien,
            mainMessage = "Salut, y'a des tags sur mon mur, viens t'en occuper !",
            duration = 10,
        })
    elseif type == 9 then -- Braquage Entreprise
        exports['vNotif']:createNotification({
            type = "ILLEGAL",
            name = notifdata.name,
            label = zone,
            labelColor = color,
            logo = notifdata.lien,
            mainMessage = "Holà, quelqu'un braque une entreprise de ton territoire !",
            duration = 10,
        })
    elseif type == 10 then -- ATM
        exports['vNotif']:createNotification({
            type = "ILLEGAL",
            name = notifdata.name,
            label = zone,
            labelColor = color,
            logo = notifdata.lien,
            mainMessage = "Bonjour, l'ATM de chez toi ce fait braquer !",
            duration = 10,
        })
    elseif type == 11 then -- Vangelico
        exports['vNotif']:createNotification({
            type = "ILLEGAL",
            name = notifdata.name,
            label = zone,
            labelColor = color,
            logo = notifdata.lien,
            mainMessage = "Coucou, des voyous braquent le Vangelico !",
            duration = 10,
        })
    elseif type == 12 then -- Raquette
        exports['vNotif']:createNotification({
            type = "ILLEGAL",
            name = notifdata.name,
            label = zone,
            labelColor = color,
            logo = notifdata.lien,
            mainMessage = "Yo, y'a une agression au couteau vers chez toi !",
            duration = 10,
        })
    elseif type == 13 then -- Cambriolage
    elseif type == 14 then -- Debut Revendication
        exports['vNotif']:createNotification({
            type = "ILLEGAL",
            name = notifdata.name,
            label = zone,
            labelColor = color,
            logo = notifdata.lien,
            mainMessage = "Hey, un crew revendique ta zone, va les dégager !",
            duration = 10,
        })
        CreateThread(function()
            blipRevendication = AddBlipForRadius(coords + vector3(math.random(1,5), math.random(1,5), math.random(1,5)), 100.0)
            SetBlipSprite(blipRevendication, 9)
            SetBlipColour(blipRevendication, findClosestBlipColor(color) or 22)
            SetBlipAlpha(blipRevendication, 100)
            --StartDrugsDeliveries()
            Modules.UI.RealWait(2*60000)
            RemoveBlip(blipRevendication)
        end)
    elseif type == 15 then -- Fin Revendication
        exports['vNotif']:createNotification({
            type = "ILLEGAL",
            name = notifdata.name,
            label = zone,
            labelColor = color,
            logo = notifdata.lien,
            mainMessage = "Un crew revendique désormais ta zone !",
            duration = 10,
        })
    end
end

local blipColors = {
    {id = 0, color = {255, 255, 255}}, -- Blanc
    {id = 1, color = {255, 0, 0}},     -- Rouge
    {id = 2, color = {0, 255, 0}},     -- Vert
    {id = 3, color = {0, 255, 255}},   -- Bleu clair
    {id = 7, color = {153, 0, 153}},   -- Violet
    {id = 5, color = {0, 0, 255}},     -- Bleu
    {id = 17, color = {255, 102, 0}},   -- Orange
    {id = 15, color = {0, 255, 255}},   -- Cyan
    {id = 22, color = {128, 128, 128}}, -- Gris
    {id = 8, color = {255, 0, 255}},  -- Rose
    {id = 11, color = {144, 238, 144}},-- Vert clair
    {id = 40, color = {169, 169, 169}},-- Gris foncé
    {id = 31, color = {139, 69, 19}},  -- Marron
    {id = 29, color = {0, 0, 139}},    -- Bleu foncé
    {id = 43, color = {50, 205, 50}},  -- Vert fluo
}

function colorDistanceRGB(color1, color2)
    return math.sqrt((color1[1] - color2[1])^2 + (color1[2] - color2[2])^2 + (color1[3] - color2[3])^2)
end

function hexToRGB(hex)
    hex = hex:gsub("#", "")
    return {tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))}
end

function findClosestBlipColor(hex)
    local rgb = hexToRGB(hex)
    local closestBlip = blipColors[1]
    local minDistance = colorDistanceRGB(rgb, closestBlip.color)

    for _, blip in ipairs(blipColors) do
        local dist = colorDistanceRGB(rgb, blip.color)
        if dist < minDistance then
            minDistance = dist
            closestBlip = blip
        end
    end

    return closestBlip.id
end

function DrawTerritoires(coords, color)    
    -- Max & min vals
    local minX, maxX = coords[1].x, coords[1].x
    local minY, maxY = coords[1].y, coords[1].y
    
    -- Minimal vals for x and y
    for _, coord in ipairs(coords) do
        if coord.x < minX then minX = coord.x end
        if coord.x > maxX then maxX = coord.x end
        if coord.y < minY then minY = coord.y end
        if coord.y > maxY then maxY = coord.y end
    end
    
    --print("MinX:", minX, "MaxX:", maxX, "MinY:", minY, "MaxY:", maxY)

    -- Center zone
    local centerX = (minX + maxX) / 2
    local centerY = (minY + maxY) / 2

    -- Lenght & width
    local width = (maxX - minX) / 1.1
    local height = (maxY - minY) / 1.1

    local blip = AddBlipForArea(centerX, centerY, 0.0, width, height)

    SetBlipColour(blip, color)
    SetBlipSprite(blip, 806)
    SetBlipAlpha(blip, 128)
    SetBlipDisplay(blip, 3)
    SetBlipRotation(blip, 0)
    SetBlipSquaredRotation(blip, 0)
    SetBlipAsShortRange(blip, true)
end

-- RegisterCommand("drawZone", function()
--     local territoire = GetZoneByName(GetZoneByPlayer())
--     local leaderColor = next(GetZoneByName(GetZoneByPlayer()).global) and GetZoneByName(GetZoneByPlayer()).global[1].color or nil
--     print("leaderColor", leaderColor)
--     print(json.encode(territoire))
--     print(leaderColor and findClosestBlipColor(leaderColor) or 22)
--     DrawTerritoires(territoire.zone, leaderColor and findClosestBlipColor(leaderColor) or 22)
-- end)

RegisterCommand("addInfluence", function()
    if p:getPermission() > 5 then
        ActionInTerritoire(p:getCrew(), GetZoneByPlayer(), 60, 2, coordsIsInSouth(GetEntityCoords(PlayerPedId())))
    else
        print("lol non pas toi")
    end
end)