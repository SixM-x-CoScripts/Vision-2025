-- RegisterNetEvent("core:excludeCrewMember")
-- AddEventHandler("core:excludeCrewMember", function(token, data, allPlayers)
--     if CheckPlayerToken(source, token) then
--         local result = crew.removePlayerInCrew(data.player_id, data.crew_id)
--         if result then
--             print(result)
--             for k, v in pairs(allPlayers) do
--                 print(data.player_id, GetPlayer(v):getId())
--                 if GetPlayer(v):getId() == data.player_id then
--                     GetPlayer(v):setCrew('None')
--                     triggerEventPlayer("core:setCrewPlayer", v, 'None')
--                     --RefreshPlayerData(v)
--                 end
--             end
--         end
--     end
-- end)
-- RegisterNetEvent("core:DeleteCrew")
-- AddEventHandler("core:DeleteCrew", function(token, crewS)
--     if CheckPlayerToken(source, token) then
--         if crew.DoesCrewExist(crewS) then
--             local id = crew.getCrewId(crewS)
--             crew.deleteMembers(id)
--             crew.deleteCrew(crewS)
--         end
--     end
-- end)

-- RegisterNetEvent("core:promoteCrewMember")
-- AddEventHandler("core:promoteCrewMember", function(token, data, rank, allPlayers)
--     if CheckPlayerToken(source, token) then
--         local result = crew.changePlayerRankInCrew(data.player_id, data.crew_id, rank)
--         -- if result then
--         --     for k, v in pairs(allPlayers) do
--         --         if GetPlayer(v):getId() == data.player_id then
--         --             RefreshPlayerData(v)
--         --         end
--         --     end
--         -- end
--     end
-- end)

-- Citizen.CreateThread(function()
--     while RegisterServerCallback == nil do Wait(1) end

--     RegisterServerCallback("core:getCrewInfo", function(source, token, crewName)
--         if CheckPlayerToken(source, token) then
--             local info = crew.getAllCrewInfoByName(crewName)
--             local members = crew.getAllCrewMembersByCrewName(crewName)
--             local grade = crew.getAllCrewGradeByCrewName(crewName)
--             return info, members, grade
--         end
--     end)
-- end)

-- Citizen.CreateThread(function()
--     while RegisterServerCallback == nil do Wait(1) end

--     RegisterServerCallback("core:getCrewVeh", function(source, token, crewName)
--         if CheckPlayerToken(source, token) then
--             local veh = crew.getAllCrewVehByName(crewName)
--             return veh
--         end
--     end)
-- end)

-- Citizen.CreateThread(function()
--     while RegisterServerCallback == nil do Wait(1) end

--     RegisterServerCallback("core:getCrewProperty", function(source, token, crewName)
--         if CheckPlayerToken(source, token) then
--             local property = crew.getAllCrewPropertyByName(crewName)
--             return property
--         end
--     end)
-- end)

-- RegisterNetEvent("core:changePerms")
-- AddEventHandler("core:changePerms", function(token, crewName, perms)
--     if CheckPlayerToken(source, token) then
--         local result = crew.changeCrewPerms(crewName, perms)
--         if result then
--             return 0
--         end
--     end
-- end)

-- exports("getCrew", function(id)
--     return GetPlayer(id):getCrew()
-- end)