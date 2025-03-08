RegisterNetEvent("core:ChangeDoorState")
AddEventHandler("core:ChangeDoorState", function(token, door, state, plys)
    if CheckPlayerToken(source, token) then
        TriggerClientEvents("core:ChangeDoorState", plys, door, state)
    else
        -- TODO: Ac detection
    end
end)

-- local Doors = {}

-- local function round(num)
--     local mult = 10^1
--     return math.floor(num * mult + 0.5) / mult
-- end

-- local function distanceSquared(vec1, vec2)
--     local dx = vec1.x - vec2.x
--     local dy = vec1.y - vec2.y
--     local dz = vec1.z - vec2.z
--     return dx * dx + dy * dy + dz * dz
-- end

-- local function FindDoorName(position, model)
--     local threshold = 0.1 * 0.1  -- Seuil de distance au carré (0.1)^2
--     for id, doorData in pairs(Doors) do
--         local doorPos = vector3(round(doorData.coords.x), round(doorData.coords.y), round(doorData.coords.z))
--         local pos = vector3(round(position.x), round(position.y), round(position.z))
--         if distanceSquared(doorPos, pos) <= threshold and doorData.model == model then
--             return id
--         end
--     end
--     return nil
-- end

-- -- RegisterNetEvent('core:create:doorlock')
-- -- AddEventHandler('core:create:doorlock', function(doorPosition, doorJobName, doorCrewName, doorDistance, doorModel, doorLockStatus)
-- --     local source = source
-- --     if GetPlayer(source):getPermission() < 2 then return end

-- --     if FindDoorName(doorPosition, doorModel) ~= nil then
-- --         TriggerClientEvent("__atoshi::createNotification", source, {
-- --             type = 'ROUGE',
-- --             content = "~c Un doorlock existe déjà à cette position !"
-- --         })
-- --         return
-- --     end

-- --     local jobsArray = {}
-- --     if doorJobName == "Aucun" then 
-- --         jobsArray = nil 
-- --     else
-- --         for str in doorJobName:gmatch("%s*([^,%s]+)%s*,?") do
-- --             table.insert(jobsArray, str)
-- --         end
-- --     end

-- --     local crewsArray = {}
-- --     if doorCrewName == "Aucun" then 
-- --         crewsArray = nil 
-- --     else
-- --         for str in doorCrewName:gmatch("%s*([^,%s]+)%s*,?") do
-- --             table.insert(crewsArray, str)
-- --         end
-- --     end

-- --     local data = {
-- --         model = doorModel,
-- --         crew = crewsArray,
-- --         job = jobsArray,
-- --         coords = doorPosition,
-- --         lockStatus = doorLockStatus,
-- --         distance = doorDistance
-- --     }

-- --     local encodedData = json.encode(data)

-- --     print(encodedData)

-- --     MySQL.Async.execute('INSERT INTO doorlock (data) VALUES (@data)', {
-- --         ['@data'] = encodedData
-- --     }, function(rowsChanged)
-- --         if rowsChanged > 0 then
-- --             MySQL.Async.fetchAll('SELECT * FROM doorlock WHERE data = @data', {
-- --                 ['@data'] = encodedData
-- --             }, function(result)
-- --                 Doors[result[1].id] = data
-- --                 TriggerClientEvent('core:createDoorlock', -1, result[1].id, doorPosition, jobsArray, crewsArray, doorDistance, doorModel, doorLockStatus)
-- --                 TriggerClientEvent("__atoshi::createNotification", source, {
-- --                     type = 'VERT',
-- --                     content = "~c Le doorlock a bien été créé !"
-- --                 })
-- --             end)
-- --         else
-- --             TriggerClientEvent("__atoshi::createNotification", source, {
-- --                 type = 'ROUGE',
-- --                 content = "~c Une erreur s'est produite lors de la création du doorlock."
-- --             })
-- --         end
-- --     end)
    
-- -- end)

-- -- RegisterNetEvent('core:delete:doorlock')
-- -- AddEventHandler('core:delete:doorlock', function(position, model)
-- --     local source = source
-- --     if GetPlayer(source):getPermission() < 2 then return end

-- --     local doorID = FindDoorName(position, model)

-- --     if doorID == nil then
-- --         TriggerClientEvent("__atoshi::createNotification", source, {
-- --             type = 'ROUGE',
-- --             content = "~c Aucun doorlock trouvé à cette position !"
-- --         })
-- --         return
-- --     end

-- --     Doors[doorID] = nil
-- --     TriggerClientEvent('core:deleteDoorlock', -1, doorID)

-- --     TriggerClientEvent("__atoshi::createNotification", source, {
-- --         type = 'VERT',
-- --         content = "~c Le doorlock a bien été supprimé !"
-- --     })

-- --     MySQL.Async.execute('DELETE FROM doorlock WHERE id = @id', {
-- --         ['@id'] = doorID
-- --     })
-- -- end)

-- Citizen.CreateThread(function()
--     MySQL.Async.fetchAll('SELECT * FROM doorlock', {}, function(result)
--         for _, v in ipairs(result) do
--             Doors[v.id] = json.decode(v.data)
--         end
--     end)

--     while RegisterServerCallback == nil do Wait(10) end

--     RegisterServerCallback('core:admin:getAllDoorlock', function()
--         return Doors
--     end)
-- end)