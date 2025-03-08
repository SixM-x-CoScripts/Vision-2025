-- function RefreshCrewMemberCount(crewName)
--     local mCount = 1
--     for k, v in pairs(crew[crewName].members) do
--         mCount = mCount + 1
--     end

--     crew[crewName].memberCount = mCount
-- end

-- RegisterNetEvent("core:CreateRank")
-- AddEventHandler("core:CreateRank", function(token, nameCrew, name, id)
--     local src = source

--     if CheckPlayerToken(src, token) then
--         crew.createRank(nameCrew, name, id)

--        -- TriggerClientEvent("core:ShowNotification", src, "Vous venez de créer le rank " .. name)

--         -- New notif
--         TriggerClientEvent("__atoshi::createNotification", src, {
--             type = 'JAUNE',
--             -- duration = 5, -- In seconds, default:  4
--             content = "Vous venez de créer le rank ~s" .. name .. "."
--         })

--     else
--         --AC
--     end
-- end)

-- RegisterNetEvent("core:deleteRank")
-- AddEventHandler("core:deleteRank", function(token, nameCrew, id)
--     local src = source

--     if CheckPlayerToken(src, token) then
--         crew.deleteRank(nameCrew, id)

--         -- TriggerClientEvent("core:ShowNotification", src, "Vous venez de supprimer le rank " .. id)

--         -- New notif
--         TriggerClientEvent("__atoshi::createNotification", src, {
--             type = 'VERT',
--             -- duration = 5, -- In seconds, default:  4
--             content = "Vous venez de supprimer le rank ~s " .. id
--         })

--     else
--         --AC
--     end
-- end)

-- RegisterNetEvent("core:setPerm")
-- AddEventHandler("core:setPerm", function(token, nameCrew, rank, perms)
--     local src = source
--     local data = {
--         sellVeh = perms.sellVeh,
--         keyVeh = perms.keyVeh,
--         gest = perms.gest,
--         prop = perms.prop,
--         stockage = perms.stockage,
--     }
--     if CheckPlayerToken(src, token) then
--         crew.setPermRank(nameCrew, rank, data)

--         -- TriggerClientEvent("core:ShowNotification", src, "Vous venez de set les perms " .. rank)
        
--         -- New notif
--         TriggerClientEvent("__atoshi::createNotification", src, {
--             type = 'VERT',
--             -- duration = 5, -- In seconds, default:  4
--             content = "Vous venez de set les perms ~s " .. rank
--         })

--     else
--         --AC
--     end
-- end)

RegisterNetEvent("core:CreateCrew")
AddEventHandler("core:CreateCrew", function(token, data)
    local src = source
    local player = GetPlayer(src)
    if CheckPlayerToken(source, token) then
        if data ~= nil then
            if createCrew(src, data.name, data.color, data.devise, data.typeCrew, data.grade) then
                Wait(500)
                if player:getCrew() ~= "None" then
                    removePlayerFromCrew(player:getCrew(), player:getId())
                end
                if addPlayerInCrew(getRankIdWithRankNumber(data.name, 1), data.name, player:getId()) then
                    player:setCrew(data.name)
                    triggerEventPlayer("core:setCrewPlayer", src, data.name, getCrewByName(data.name):getType())
                else
                    TriggerClientEvent("__atoshi::createNotification", src, {
                        type = 'ROUGE',
                        duration = 10, -- In seconds, default:  4
                        content = "Un problème est survenu lors de la création du crew vous n'avez pas été ajouté a celui la merci de voir avec les supports."
                    })
                end
                TriggerClientEvent("__atoshi::createNotification", src, {
                    type = 'VERT',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous venez de créer le crew ~s" .. data.name
                })
            else
                TriggerClientEvent("__atoshi::createNotification", src, {
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Un problème est survenu lors de la création du crew."
                })
            end
        end
    end
end)

RegisterNetEvent('core:setCrew')
AddEventHandler('core:setCrew', function(time, secu, token, id, name, rank)
    local source = source
    local player = GetPlayer(id)
    rank = tonumber(rank)
    if not rank then rank = 1 end
    if CheckTrigger(source, time, secu, "core:setCrew") then
        if CheckPlayerToken(source, token) then
            if name == "None" then
                if removePlayerFromCrew(player:getCrew(), player:getId()) then
                    player:setCrew("None")
                    TriggerClientEvent('core:setCrew', id, "None")
                    SendDiscordLog("recruitCrew", source, string.sub(GetDiscord(source), 9, -1),
                        GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(),
                        "Personne viré du crew " .. player:getLastname() .. " " .. player:getFirstname() .. " ID (".. id ..")")
                end
            else
                local rankId = getRankIdWithRankNumber(name, rank or 5)
                if rankId == false then return false end
                if player:getCrew() ~= "None" then
                    local currentCrew = player:getCrew()
                    if removePlayerFromCrew(currentCrew, player:getId()) then
                        if addPlayerInCrew(rankId, name, player:getId()) then
                            player:setCrew(name)
                            SendDiscordLog("recruitCrew", source, string.sub(GetDiscord(source), 9, -1),
                                GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(),
                                "La personne a recruté " .. player:getLastname() .. " " .. player:getFirstname() .. " ID (".. id ..") dans le crew " .. name)
                            triggerEventPlayer("core:setCrewPlayer", source, name, getCrewByName(name):getType())
                            TriggerClientEvent('core:setCrew', id, name)
                            TriggerClientEvent("__atoshi::createNotification", source, {
                                type = 'VERT',
                                -- duration = 5, -- In seconds, default:  4
                                content = "Vous avez recruté " .. player:getLastname() .. " " .. player:getFirstname() .. ". Rang : " .. rank
                            })
                            TriggerClientEvent("__atoshi::createNotification", id, {
                                type = 'JAUNE',
                                -- duration = 5, -- In seconds, default:  4
                                content = "Vous avez été ~s recruté ~c dans le crew " .. name .. ", rang : " .. rank
                            })

                        end
                    end
                else
                    if addPlayerInCrew(rankId, name, player:getId()) then
                        player:setCrew(name)
                        SendDiscordLog("recruitCrew", source, string.sub(GetDiscord(source), 9, -1),
                            GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(),
                            "La personne a recruté " .. player:getLastname() .. " " .. player:getFirstname() .. " ID (".. id ..") dans le crew " .. name)
                        triggerEventPlayer("core:setCrewPlayer", source, name, getCrewByName(name):getType())
                        TriggerClientEvent('core:setCrew', id, name)
                        TriggerClientEvent("__atoshi::createNotification", source, {
                            type = 'VERT',
                            -- duration = 5, -- In seconds, default:  4
                                content = "Vous avez recruté " .. player:getLastname() .. " " .. player:getFirstname() .. ". Rang : " .. rank
                        })
                        TriggerClientEvent("__atoshi::createNotification", id, {
                            type = 'JAUNE',
                            -- duration = 5, -- In seconds, default:  4
                            content = "Vous avez été ~s recruté ~c dans le crew " .. name .. ", rang : " .. rank
                        })

                    end
                end
            end
        end
    end
end)

RegisterNetEvent('core:unsetCrew')
AddEventHandler('core:unsetCrew', function(time, secu, token, id)
    -- to unset we just set the crew to None
    local source = source
    local ply = GetPlayer(source)
    if not ply then return end
    if ply:getPermission() < 3 then return end
    local player = GetPlayer(id)
    if CheckTrigger(source, time, secu, "core:unsetCrew") then
        if CheckPlayerToken(source, token) then
            if player:getCrew() ~= "None" then
                local currentCrew = player:getCrew()
                if removePlayerFromCrew(currentCrew, player:getId()) then
                    player:setCrew("None")
                    TriggerClientEvent('core:setCrew', id, "None", 1)
                    TriggerClientEvent("__atoshi::createNotification", source, {
                        type = 'VERT',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous avez retiré " .. player:getLastname() .. " " .. player:getFirstname() .. " de son crew"
                    })
                    TriggerClientEvent("__atoshi::createNotification", id, {
                        type = 'JAUNE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous avez été ~s retiré ~c d'un crew"
                    })
                end
            end
        end
    end
end)