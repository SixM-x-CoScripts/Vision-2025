local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

-- local open = false
-- local crewInfo_main = RageUI.CreateMenu("", "Crew", 0.0, 0.0, "vision", "menu_title_crew")
-- local crewInfo_info = RageUI.CreateSubMenu(crewInfo_main, "", "Crew", 0.0, 0.0, "vision", "menu_title_crew")
-- local crewInfo_members = RageUI.CreateSubMenu(crewInfo_main, "", "Crew", 0.0, 0.0, "vision", "menu_title_crew")
-- local crewInfo_members_actions = RageUI.CreateSubMenu(crewInfo_members, "", "Crew", 0.0, 0.0, "vision", "menu_title_crew")
-- local crewInfo_members_promute = RageUI.CreateSubMenu(crewInfo_members_actions, "", "Crew", 0.0, 0.0, "vision",
--     "menu_title_crew")
-- local crewInfo_grade_gestion = RageUI.CreateSubMenu(crewInfo_main, "", "Crew", 0.0, 0.0, "vision",
--     "menu_title_crew")
-- local perm_grade = RageUI.CreateSubMenu(crewInfo_main, "", "Crew", 0.0, 0.0, "vision",
--     "menu_title_crew")

-- crewInfo_main.Closed = function()
--     open = false
-- end
-- local crewPermission = {
--     sellVeh = false,
--     keyVeh = false,
--     gest = false,
--     prop = false,
--     stockage = false,
-- }
-- local crewInfo = {}
-- local crewMembers = {}
-- local crewGrade = {}
-- local selected_member = nil
-- local exlureIndex = 1
-- local ExclureTable = {
--     { Name = "Non" },
--     { Name = "Oui" },
-- }
-- local data = {}
-- function openCrewInfo()
--     if open then
--         open = false
--         RageUI.Visible(crewInfo_main, false)
--     else
--         open = true
--         RageUI.Visible(crewInfo_main, true)
--         if p:getCrew() ~= "None" then
--             crewInfo, crewMembers, crewGrade = TriggerServerCallback("core:getCrewInfo", token, p:getCrew())
--         end

--         Citizen.CreateThread(function()
--             while open do
--                 RageUI.IsVisible(crewInfo_main, function()
--                     RageUI.Button("Information", nil, {}, true, {}, crewInfo_info)
--                     RageUI.Button("Liste des membres", nil, {}, true, {}, crewInfo_members)
--                     if crewInfo.rank == 1 then
--                         RageUI.Button("Gestion des rangs", nil, {}, true, {}, crewInfo_grade_gestion)
--                     else
--                         RageUI.Button("Gestion des rangs", nil, {}, false, {}, nil)
--                     end
--                 end)
--                 RageUI.IsVisible(crewInfo_info, function()
--                     RageUI.Button("Nom du crew", nil, { RightLabel = "~o~" .. crewInfo.name }, true, {}, nil)
--                     RageUI.Button("Tag du crew", nil, { RightLabel = "~o~" .. crewInfo.tag }, true, {}, nil)
--                     RageUI.Button("ID du crew", nil, { RightLabel = "~o~" .. crewInfo.id }, true, {}, nil)
--                     RageUI.Button("Niveau du crew", nil, { RightLabel = "~o~" .. crewInfo.rank }, true, {}, nil)
--                 end)
--                 RageUI.IsVisible(crewInfo_members, function()
--                     for i = 1, #crewMembers, 1 do
--                         RageUI.Button(json.decode(crewMembers[i].identity).prenom ..
--                             " " .. json.decode(crewMembers[i].identity).nom, nil,
--                             { RightLabel = "~o~" .. crewMembers[i].name }, true, {
--                                 onSelected = function()
--                                     selected_member = crewMembers[i]
--                                 end
--                             }, crewInfo_members_actions)
--                     end
--                 end)
--                 RageUI.IsVisible(crewInfo_members_actions, function()
--                     RageUI.Button("Nom:", nil,
--                         { RightLabel = "~o~" ..
--                             json.decode(selected_member.identity).prenom ..
--                             " " .. json.decode(selected_member.identity).nom }, true, {})
--                     RageUI.Button("Promouvoir:", nil, { RightLabel = ">" }, true, {}, crewInfo_members_promute)
--                     if crewInfo.rank == 1 then
--                         RageUI.List("Exclure", ExclureTable, exlureIndex, nil, {}, true, {
--                             onListChange = function(index)
--                                 exlureIndex = index
--                             end,
--                             onSelected = function()
--                                 if exlureIndex == 2 then
--                                     local tablee = {}
--                                     for k, v in pairs(GetActivePlayers()) do
--                                         table.insert(tablee, GetPlayerServerId(v))
--                                     end
--                                     TriggerServerEvent("core:excludeCrewMember", token, selected_member, tablee)
--                                     RageUI.CloseAll()
--                                     open = false

--                                     --[[ Ancienne notification
--                                     -- ShowNotification("~o~" ..
--                                         json.decode(selected_member.identity).prenom ..
--                                         " " .. json.decode(selected_member.identity).nom .. " a été exclu du crew")
--                                     --]]

--                                     -- New notif
--                                     exports['vNotif']:createNotification({
--                                         type = 'JAUNE',
--                                         -- duration = 5, -- In seconds, default:  4
--                                         content = "~s " .. json.decode(selected_member.identity).prenom .. " " .. json.decode(selected_member.identity).nom .. " ~c a été ~s exclu ~c du crew"
--                                     })

--                                 end
--                             end,
--                         })
--                     end


--                 end)

--                 RageUI.IsVisible(crewInfo_members_promute, function()
--                     for k, v in pairs(crewGrade) do
--                         RageUI.Button(v.name, nil, { RightLabel = "~o~" .. v.rank }, v.rank ~= 1, {
--                             onSelected = function()
--                                 local tablee = {}
--                                 for k, v in pairs(GetActivePlayers()) do
--                                     table.insert(tablee, GetPlayerServerId(v))
--                                 end
--                                 TriggerServerEvent("core:promoteCrewMember", token, selected_member, v.rank, tablee)
--                                 RageUI.CloseAll()
--                                 open = false
                                
--                                 --[[ Ancienne notification
--                                 -- ShowNotification("~o~" ..
--                                     json.decode(selected_member.identity).prenom ..
--                                     " " .. json.decode(selected_member.identity).nom .. " a été promu au niveau " ..
--                                     v.rank)
--                                 --]]

--                                 -- New notif
--                                 exports['vNotif']:createNotification({
--                                     type = 'JAUNE',
--                                     -- duration = 5, -- In seconds, default:  4
--                                     content = "~s " .. json.decode(selected_member.identity).prenom .. " " .. json.decode(selected_member.identity).nom .. "~c a été ~s promu ~c au niveau ~s " .. v.rank
--                                 })

--                                 data = {
--                                     crew = crewInfo.name,
--                                     name = v.name,
--                                     rank = v.rank,
--                                     id = v.id
--                                 }

--                                 crewPermission = {
--                                     sellVeh = json.decode(crewGrade[k].perm)["sellVeh"],
--                                     keyVeh = json.decode(crewGrade[k].perm)["keyVeh"],
--                                     gest = json.decode(crewGrade[k].perm)["gest"],
--                                     prop = json.decode(crewGrade[k].perm)["prop"],
--                                     stockage = json.decode(crewGrade[k].perm)["stockage"]
--                                 }
--                             end
--                         }, nil)
--                     end
--                 end)

--                 RageUI.IsVisible(crewInfo_grade_gestion, function()
--                     RageUI.Button("~g~Créer d'autres rangs", nil, { RightLabel = ">" }, true, {
--                         onSelected = function()
--                             if #crewGrade < 5 and (#crewGrade + 1) <= 5 then
--                                 local newGrade = KeyboardImput("Saissisez le nom du rang")
--                                 TriggerServerEvent("core:CreateRank", token, crewInfo.name, newGrade, #crewGrade + 1)
--                                 crewInfo, crewMembers, crewGrade = TriggerServerCallback("core:getCrewInfo", token,
--                                     p:getCrew())

--                             else
--                                 -- ShowNotification("~r~Vous ne pouvez pas créer plus de 5 rangs")

--                                 -- New notif
--                                 exports['vNotif']:createNotification({
--                                     type = 'ROUGE',
--                                     -- duration = 5, -- In seconds, default:  4
--                                     content = "~s Vous ne pouvez pas créer plus de 5 rangs"
--                                 })

--                             end
--                         end
--                     }, nil)
--                     for k, v in pairs(crewGrade) do
--                         RageUI.Button(v.name, nil, { RightLabel = "~o~" .. v.rank }, v.rank ~= 1, {
--                             onSelected = function()

--                                 -- local tablee = {}
--                                 -- for k, v in pairs(GetActivePlayers()) do
--                                 --     table.insert(tablee, GetPlayerServerId(v))
--                                 -- end
--                                 -- TriggerServerEvent("core:promoteCrewMember", token, selected_member, v.rank, tablee)
--                                 -- RageUI.CloseAll()
--                                 -- open = false
--                                 -- ShowNotification("~o~" ..
--                                 --     json.decode(selected_member.identity).prenom ..
--                                 --     " " .. json.decode(selected_member.identity).nom .. " a été promu au niveau " ..
--                                 --     v.rank)
--                                 data = {
--                                     crew = crewInfo.name,
--                                     name = v.name,
--                                     rank = v.rank,
--                                     id = v.id
--                                 }

--                                 crewPermission = {
--                                     sellVeh = json.decode(crewGrade[k].perm)["sellVeh"],
--                                     keyVeh = json.decode(crewGrade[k].perm)["keyVeh"],
--                                     gest = json.decode(crewGrade[k].perm)["gest"],
--                                     prop = json.decode(crewGrade[k].perm)["prop"],
--                                     stockage = json.decode(crewGrade[k].perm)["stockage"]
--                                 }
--                                 -- end

--                             end
--                         }, perm_grade)
--                     end
--                 end)
--                 RageUI.IsVisible(perm_grade, function()
--                     RageUI.Separator(data.name .. " rank " .. data.rank .. " id " .. data.id)
--                     RageUI.Checkbox("Vente véhicules", false, crewPermission.sellVeh, {}, {
--                         onChecked = function()
--                             crewPermission.sellVeh = true
--                         end,
--                         onUnChecked = function()
--                             crewPermission.sellVeh = false
--                         end
--                     })
--                     RageUI.Checkbox("Clés du véhicule", false, crewPermission.keyVeh, {},
--                         { onChecked = function()
--                             crewPermission.keyVeh = true
--                         end,
--                             onUnChecked = function()
--                                 crewPermission.keyVeh = false
--                             end })
--                     RageUI.Checkbox("Gestion du crew", false, crewPermission.gest, {},
--                         { onChecked = function()
--                             crewPermission.gest = true
--                         end,
--                             onUnChecked = function()
--                                 crewPermission.gest = false
--                             end })
--                     RageUI.Checkbox("Accès aux propriétés", false, crewPermission.prop, {},
--                         { onChecked = function()
--                             crewPermission.prop = true
--                         end,
--                             onUnChecked = function()
--                                 crewPermission.prop = false
--                             end })
--                     RageUI.Checkbox("Accès aux stockages", false, crewPermission.stockage, {},
--                         { onChecked = function()
--                             crewPermission.stockage = true
--                         end,
--                             onUnChecked = function()
--                                 crewPermission.stockage = false
--                             end })
--                     RageUI.Button("~g~Valider le changement", false, {}, true, {
--                         onSelected = function()
--                             TriggerServerEvent("core:setPerm", token, data.crew, data.rank, crewPermission)
--                         end
--                     }, nil)

--                     RageUI.Button("~r~Supprimer le rang", false, {}, true, {
--                         onSelected = function()
--                             TriggerServerEvent("core:deleteRank", token, data.crew, data.rank)
--                             -- ShowNotification("Vous venez de supprimer le rang " .. data.name)

--                             -- New notif
--                             exports['vNotif']:createNotification({
--                                 type = 'JAUNE',
--                                 -- duration = 5, -- In seconds, default:  4
--                                 content = "Vous venez de supprimer le rang ~s " .. data.name
--                             })

--                         end
--                     }, nil)


--                     -- RageUI.Button(v.name, nil, { RightLabel = "~o~" .. v.rank }, v.rank ~= 1, {
--                     --     onSelected = function()

--                     --     end
--                     -- }, nil)

--                 end)
--                 Wait(1)
--             end
--         end)
--     end
-- end

-- -- RegisterCommand("crew", function()
-- --     if p:getCrew() ~= "None" then
-- --         openCrewInfo()
-- --     end
-- -- end)

-- local inChoice = false
-- local selectedPlayer = nil



-- RegisterCommand("recruter", function()
--     if loadedJob ~= nil then
--         print(json.encode(loadedJob.grade[pJobGrade]))
--         if loadedJob.grade[pJobGrade].gestion ~= nil and loadedJob.grade[pJobGrade].gestion then
--             local player = GetAllPlayersInArea(p:pos(), 1.5)
--             for k, v in pairs(player) do
--                 if v == PlayerId() then
--                     table.remove(player, k)
--                 end
--             end
--             if player ~= nil then
--                 if next(player) then
--                     inChoice = true
--                     StartChoiceRecruter(player)
--                     if selectedPlayer ~= nil then
--                         TriggerServerEvent("core:RecruitPlayer", token, GetPlayerServerId(selectedPlayer), pJob, 0)
--                     end
--                 else
--                     ShowNotification("~r~Il n'y a personne autour de vous")

--                      -- New notif
--                      exports['vNotif']:createNotification({
--                          type = 'ROUGE',
--                          -- duration = 5, -- In seconds, default:  4
--                          content = "~s Il n'y a personne autour de vous"
--                      })

--                 end
--             else
--                 -- ShowNotification("~r~Il n'y a personne autour de vous")

--                     New notif
--                    exports['vNotif']:createNotification({
--                        type = 'ROUGE',
--                        -- duration = 5, -- In seconds, default:  4
--                        content = "~s Il n'y a personne autour de vous"
--                    })
--             end
--         end
--     end
-- end)

local function StartChoiceRecruterCrew(players)
    exports['aHUD']:toggleHotkeys(true)
    local timer = GetGameTimer() + 10000
    while inChoice do
        if next(players) then
            local mCoors = GetEntityCoords(GetPlayerPed(players[1]))
            DrawMarker(20, mCoors.x, mCoors.y, mCoors.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255
                , 120, 0, 1, 2, 0, nil, nil, 0)
            if GetGameTimer() > timer then
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Le délai est dépassé"
                })

                inChoice = false
                exports['aHUD']:toggleHotkeys(false)
                return
            elseif IsControlJustPressed(0, 51) then -- E
                selectedPlayer = players[1]
                inChoice = false
                exports['aHUD']:toggleHotkeys(false)
                return
            elseif IsControlJustPressed(0, 182) then -- C
                table.remove(players, 1)
                if next(players) then
                    timer = GetGameTimer() + 10000
                end
            elseif IsControlJustPressed(0, 73) then -- X
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous avez ~s annulé"
                })

                exports['aHUD']:toggleHotkeys(false)
                inChoice = false
                return
            end
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Il n'y a personne autour de vous"
            })

            exports['aHUD']:toggleHotkeys(false)
            inChoice = false
            return
        end
        Wait(0)
    end
    exports['aHUD']:toggleHotkeys(false)
end

--RegisterCommand("invitecrew", function()
function inviteCrew()
    if openCrewRadial then
        openCrewRadial = false
        closeUI()
    end
    if p:getCrew() ~= "None" then
        local canRecruit = TriggerServerCallback("core:crew:canRecruiteByName", p:getCrew(), p:getId())
        if canRecruit then
            local player = GetAllPlayersInArea(p:pos(), 1.5)
            for k, v in pairs(player) do
                if v == PlayerId() then
                    table.remove(player, k)
                end
            end
            if player ~= nil then
                if next(player) then
                    inChoice = true
                    StartChoiceRecruterCrew(player)
                    if selectedPlayer ~= nil then
                        TriggerSecurEvent("core:setCrew", token, GetPlayerServerId(selectedPlayer), p:getCrew(), 1)
                    end
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Il n'y a personne autour de vous"
                    })

                end
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Il n'y a personne autour de vous"
                })

            end
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s tu n'as pas le droit de recruter"
            })
        end
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Tu n'es pas dans un crew"
        })

    end
end--)

--RegisterCommand("leavecrew", function()
function leaveCrew()
    if openCrewRadial then
        openCrewRadial = false
        closeUI()
    end
    if p:getCrew() ~= "None" then
        TriggerSecurEvent("core:setCrew", token, GetPlayerServerId(PlayerId()), "None", 0)
        -- ShowNotification("Vous avez quitté le crew")

        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez ~s quitté ~c le crew"
        })

    end
end--)