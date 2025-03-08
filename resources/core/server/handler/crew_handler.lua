--global variables
-- local ExpLevel = {
--     [1] = 0,
--     [2] = 40000,
--     [3] = 80000,
--     [4] = 120000,
--     [5] = 160000, 
-- }

--init 
local function LoadAllCrew() -- done
    MySQL.Async.fetchAll('SELECT * FROM crew', {}, function(result)
        local crewLoad
        for k, v in pairs(result) do
            crewLoad = crew:new(v)
        end
    end)
    CorePrint("Tous les crew de la bdd ont été load.")
end

MySQL.ready(function()
    Wait(1000)
    LoadAllCrew()
end)

function getMembers(crew_id)
    local members = {}
    MySQL.Async.fetchAll('SELECT crew_members.*, players.id AS id, players.license AS license, players.firstName AS firstName, players.lastName AS lastName, crew_rank.rank AS crewRank FROM crew_members LEFT JOIN players ON crew_members.player_id = players.id LEFT JOIN crew_rank ON crew_members.rank_id = crew_rank.id WHERE crew_members.crew_id = @crew_id', { ['@crew_id'] = crew_id }, function(result)
        if result[1] then
            for k, v in pairs(result) do
                table.insert(members, v)
            end
        end
    end)
    return members
end

function getRoles(crew_id)
    local roles = {}
    MySQL.Async.fetchAll('SELECT * FROM crew_rank WHERE crew_id = @crew_id', { ['@crew_id'] = crew_id }, function(result)
        if result[1] then
            for k, v in pairs(result) do
                table.insert(roles, v)
            end
        end
    end)
    return roles
end

-- function

function createCrew(source, name, color, devise, typeCrew, grades)
    local result = MySQL.Sync.insert("INSERT INTO crew (`name`, `color`, `perms`, `devise`, `typeCrew`) VALUES (@name, @color, @perms, @devise, @typeCrew)"
        , {
        ['@name'] = name,
        ['@color'] = color,
        ['@perms'] = json.encode({exclure = 1, sendDm = 1, editPerm = 1, editMembres = 1, recrute = 1}),
        ['@devise'] = devise,
        ['@typeCrew'] = typeCrew or "normal"
    })  
    if result then
        CorePrint("Crew ^2" .. name .. "^7 created")
        local rankId
        for k, v in pairs(grades) do
            rankId = createRanks(result, v.name, v.id)
            if rankId == false then return false end
        end
        crew:new({
            id = result,
            name = name,
            devise = devise,
            perms = json.encode({exclure = 1, sendDm = 1, editPerm = 1, editMembres = 1, recrute = 1}),
            typeCrew = typeCrew or "normal",
            color = color or "#ffffff",
            xp = 0,
            members = getMembers(result),
            roles = getRoles(result),
            needSave = false,
            needSaveMembers = false,
            needSaveRoles = false,
        })
        return true
    else
        CorePrint("Error while creating crew" .. name)
        return false
    end
end

function createRanks(crew_id, name, id)
    local result = MySQL.Sync.insert("INSERT INTO crew_rank (`crew_id`, `name`, `rank`) VALUES (@crewId, @name, @rank)"
        , {
        ['@crewId'] = crew_id,
        ['@name'] = name,
        ['@rank'] = id,
    })
    if result then
        CorePrint("Rank ^2" .. name .. "^7 created")
        return result
    else
        CorePrint("Error while creating rank")
        return false
    end
end

function deleteCrew(name, changeCrew)
    local crew = getCrewByName(name)
    local result = MySQL.Sync.execute("DELETE FROM crew WHERE id = @crewId"
        , {
        ['@crewId'] = crew.id,
    })
    if result then
        UpdateTerritoireOnWipeCrew(name)
        if changeCrew then changePlayerCrew(crew.members) end
        --delete property
        result = MySQL.Sync.execute("DELETE FROM property WHERE crew = @crewName"
            , {
            ['@crewName'] = crew.name,
        })
        --delete veh
        result = MySQL.Sync.execute("DELETE FROM vehicles WHERE vente = @vente"
            , {
            ['@vente'] = crew.name,
        })
        --delete tablet_armes
        result = MySQL.Sync.execute("DELETE FROM tablet_armes WHERE crew_name = @crewName"
            , {
            ['@crewName'] = crew.name,
        })
        --delete command_tablet
        result = MySQL.Sync.execute("DELETE FROM command_tablet WHERE crewName = @crewName"
            , {
            ['@crewName'] = crew.name,
        })
        CorePrint("Crew ^2" .. crew.name .. "^7 deleted")
        RemoveCrew(crew.id)
        return true
    else
        CorePrint("Error while deleting Crew : " .. crewName)
        return false
    end
    --deleteRoles(crew.id)
    --deleteAllMembers(crew.id)
    
end

function changePlayerCrew(members)
    local playerSource
    for k, v in pairs(members) do
        playerSource = GetPlayerFromLicenseIfExist(v.license)
        if playerSource ~= false then -- Connected
			GetPlayer(tonumber(playerSource)):setCrew("None")
            TriggerClientEvent('core:setCrew', tonumber(playerSource), "None")
		else -- Not connected
			MySQL.Async.execute("UPDATE players SET crew = 'None' WHERE id = @id", {
                ['@id'] = v.id,
            },
            function(affectedRows)
                print("player offline to none")
            end)
        end
    end
end

function deleteRoles(id)
    local result = MySQL.Sync.execute("DELETE FROM crew_rank WHERE crew_id = @crewId"
        , {
        ['@crewId'] = id
    })
    if result then
        CorePrint("Rank deleted")
        return true
    else
        CorePrint("Error while deleting rank")
        return false
    end
end

function deleteAllMembers(id)
    MySQL.Async.execute("DELETE FROM crew_members WHERE crew_id = @crewId", {
        ['@crewId'] = id,
        ['@playerId'] = playerId
    }, function(affectedRows)
        CorePrint("Players removed from crew")
    end)
    --todo remove crew from all players table ingame and offline
    return true
end

function addPlayerInCrew(rank_id, name, playerId)
    local crew = getCrewByName(name)
    local crewType = crew:getType()

    local maxMembers = 20
    if crewType == "pf" then 
        maxMembers = 10
    elseif crewType == "gang" then
        maxMembers = 30
    elseif crewType == "mc" then
        maxMembers = 30
    elseif crewType == "orga" then
        maxMembers = 30
    elseif crewType == "mafia" then
        maxMembers = 35
    else
        maxMembers = 20
    end
    
    print("crewType, maxMembers", crewType, maxMembers)
    if tonumber(crew:getCountNumberMembers()) >= tonumber(maxMembers) then
        TriggerClientEvent("__atoshi::createNotification", source, {
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Le crew est complet, vous ne pouvez pas recruter plus de " .. maxMembers .. " membres en tant que "..crewType..". (Vous êtes "..crew:getCountNumberMembers().." membres)"
        })

        return false
    else 
        MySQL.Async.execute("INSERT INTO crew_members (crew_id, player_id, rank_id) VALUES (@crewId, @playerID, @rankId)"
                , {
                    ['@crewId'] = crew.id,
                    ['@playerID'] = playerId,
                    ['@rankId'] = rank_id
                }, function(affectedRows)
                CorePrint("Player added in crew", name)
                crew:setMembers(getMembers(crew.id))
            end)
        return true
    end
end

RegisterNetEvent("core:crew:getPlayerInfo", function(token, crew, idbdd)
    local source = source
    if crew == "None" then return end 
    local ply = GetPlayer(source)
    if ply:getCrew() == "None" then return end 
    if CheckPlayerToken(source, token) then
        local player = GetPlayerFromId(idbdd)
        local crewRank = getPlayerCrewRank(crew, idbdd)
        -- show notification 
        crewRank = crewRank or 1
        if player then
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4.
                content = "Nom : " .. player.lastname .. " " .. player.firstname .. "\nMétier " .. player.job .. "\nCrew : " .. crew .. "\nGrade : " .. crewRank
            })
        else
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Personne inconnu"
            })
        end
    end
end)

function removePlayerFromCrew(name, playerId, license, source)
    local crew = getCrewByName(name)
    if not crew then return true end
    if not playerId then return end
    MySQL.Async.execute("DELETE FROM crew_members WHERE crew_id = @crewId AND player_id = @playerId", {
        ['@crewId'] = crew.id,
        ['@playerId'] = playerId
    }, function(affectedRows)
        crew:setMembers(getMembers(crew.id))
        local playerId = GetPlayerFromLicenseIfExist(license)
        if playerId and GetPlayerName(playerId) then 
            local player = GetPlayer(tonumber(playerId))
            player:setCrew("None")
            CorePrint("Player "..playerId.." removed from crew in game.")
            TriggerClientEvent("core:setCrewPlayer", playerId, "None") 
        else
            -- UPDATE EN SQL LE PLAYER SI IL EST PAS CO set crew=None
            MySQL.Async.execute("UPDATE players SET crew = 'None' WHERE id = @playerId", {
                ['@playerId'] = playerId
            }, function(affectedRows)
                CorePrint("Player "..playerId.." removed from crew inside database.")
            end)
        end
        if source then 
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez bien retiré la personne du crew"
            })
        end
    end)
    return true
end

function changePlayerRankInCrew(name, playerId, rankId)
    local crew = getCrewByName(name)
    MySQL.Async.execute("UPDATE crew_members SET rank_id = @rankId WHERE crew_id = @crewId AND player_id = @playerId"
        , {
            ['@crewId'] = crew.id,
            ['@playerId'] = playerId,
            ['@rankId'] = rankId
        }, function(affectedRows)
            CorePrint("Player rank changed in crew")
            crew:setMembers(getMembers(crew.id))
    end)
    return true
end

function changeRankName(name, rankId)
    local crew = getCrewByName(name)
    local result = MySQL.Sync.execute("UPDATE crew_rank SET name = @name WHERE id = @id"
        , {
        ['@name'] = name,
        ['@id'] = rankId,
    })
    if result then
        CorePrint("new name for rank ^2" .. name .. "^7")
        crew:setRoles(getRoles(crew.id))
        return true
    else
        CorePrint("Error while setting perm for : " .. name .. " rank : " .. rankId)
        return false
    end
end

function changePerms(name, perms)
    getCrewByName(name):setPerms(perms)
end

function getRankIdWithRankNumber(name, rankNumber)
    local crew = getCrewByName(name)
    
    if crew then
        for k, v in pairs(crew.roles) do
            if v.rank == rankNumber then return v.id end
        end
    else 
        return false 
    end
end


function updateXp(amount, action, name, kind)
    local crew = getCrewByName(name)
    if crew == nil then return false end

    TriggerEvent("core:UpdateCrewXp", name, amount, action)

    if action == "remove" then
        crew:removeXp(amount)
    elseif action == "add" then
        crew:addXp(amount)
    end
    crew:setNeedSave(true)
    return true
end

function getLevel(xp)
    local xpVariable = GetVariable("xpTablette")
    if xp == nil then return 1 end
    if xpVariable then
        -- Worst thing i've seen gg prestor
        --for k, v in pairs(xpVariable) do
        --    print(k,v,xp)
        --    if tonumber(xp) <= tonumber(v) then 
        --        return tonumber(k) - 1 
        --    end
        --end

        local level = 1
        for k, v in pairs(xpVariable) do
            local nextLevel = tonumber(k) + 1
            local nextXp = tonumber(xpVariable[tostring(nextLevel)])
            if xp >= v and (not nextXp or xp < nextXp) then
                level = tonumber(k)
                break
            end
        end
    
        return level
    else
        return 1
    end
end

function changeName(name, newName)
    local crew = getCrewByName(name)
    local playerSource
    for k, v in pairs(crew:getMembers()) do
        playerSource = GetPlayerFromLicenseIfExist(v.license)
        if playerSource ~= false then -- Connected
			GetPlayer(tonumber(playerSource)):setCrew(newName)
            TriggerClientEvent('core:setCrew', tonumber(playerSource), newName)
		else -- Not connected
			MySQL.Async.execute("UPDATE players SET crew = @name WHERE id = @id", {
                ['@id'] = v.id,
                ['@name'] = newName,
            },
            function(affectedRows)
                print("player offline to " .. newName)
            end)
        end
    end
    crew:setName(newName)
end

function changeDevise(name, newDevise)
    getCrewByName(name):setDevise(newDevise)
end

function changeTypeCrew(name, newTypeCrew)
    getCrewByName(name):setType(newTypeCrew)
    if newTypeCrew ~= "normal" then
        crewTab[name] = true
    else
        crewTab[name] = nil
    end
end

function changeColor(name, newColor)
    getCrewByName(name):setColor(newColor)
end

function getSameKindCrews(typeCrew)
    local crews = {}
    for k, v in pairs(GetAllCrews()) do
        if v.typeCrew == typeCrew then table.insert(crews, v.name) end
    end
    return crews
end

function getSameKindCrewsFromName(name)
    local typeCrew = getCrewByName(name):getType()
    local crews = {}
    for k, v in pairs(GetAllCrews()) do
        if v.typeCrew == typeCrew then table.insert(crews, v.name) end
    end
    return crews
end

function getCrewMemberByName(name, id)
    for k, v in pairs(getCrewByName(name):getMembers()) do
        if v.id == id then return v end
    end
    return nil
end

function getPlayerCrewRank(name, id)
    if not getCrewByName(name) then return nil end
    for k, v in pairs(getCrewByName(name):getMembers()) do
        if v.id == id then return v.crewRank end
    end
    return nil
end

-- event

RegisterNetEvent("core:AddCrewTable")
AddEventHandler("core:AddCrewTable", function(name)
    crewTab[name] = true
    TriggerClientEvent("core:UpdateCrewTable", -1, name)
end)

RegisterNetEvent("core:crew:createCrew")
AddEventHandler("core:crew:createCrew", function(token, name, color, devise, typeCrew)
    local source = source
    if CheckPlayerToken(source, token) then
        createCrew(source, name, color, devise, typeCrew)
    end
end)

RegisterNetEvent("core:crew:deleteCrew")
AddEventHandler("core:crew:deleteCrew", function(token, name, changeCrew)
    local source = source
    local ply = GetPlayer(source)
    if ply then 
        local perm = ply:getPermission()
        if CheckPlayerToken(source, token) and perm > 2 then
            deleteCrew(name, changeCrew)
        else
			TriggerClientEvent("__atoshi::createNotification", source, {
				type = 'ROUGE',
				-- duration = 5, -- In seconds, default:  4
				content = "Vous n'avez pas les perms"
			})
        end
    end
end)

RegisterNetEvent("core:crew:addPlayerInCrew")
AddEventHandler("core:crew:addPlayerInCrew", function(token, rank_id, name, player_id)
    if CheckPlayerToken(source, token) then
        addPlayerInCrew(rank_id, name, player_id)
    end
end)

local function isJson(perm)
    if type(perm) == "string" then
        return json.decode(perm) 
    end
    return perm
end

RegisterNetEvent("core:crew:removePlayerFromCrew")
AddEventHandler("core:crew:removePlayerFromCrew", function(token, name, playerId, license)
    local source = source
    if CheckPlayerToken(source, token) then
        local ply = GetPlayer(source)
        if not ply then return end 
        if ply:getCrew() ~= name then 
            return 
        end
        local idbdd = ply:getId()
        if idbdd == playerId then 
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous ne pouvez pas vous exclure vous même"
            })
            return
        end
        local crewRank = getPlayerCrewRank(name, idbdd)
        local crewInfo = getCrewByName(name)
        local crewPerms = isJson(crewInfo.perms)
        crewRank = crewRank or 1
        if crewRank >= crewPerms.exclure then
            --print("playerId", playerId)
            --local player = GetPlayer(playerId)
            --player:setCrew("None")
            --triggerEventPlayer("core:setCrewPlayer", playerId, "None")
            removePlayerFromCrew(name, playerId, license, source)
        else
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous n'avez pas les permissions pour exclure cette personne (Permission nécessaire : "..crewPerms.exclure..", la votre : "..crewRank..")"
            })
        end
    end
end)

RegisterNetEvent("core:crew:changePlayerRankInCrew")
AddEventHandler("core:crew:changePlayerRankInCrew", function(token, name, playerId, rankNumber)
    if CheckPlayerToken(source, token) then
        changePlayerRankInCrew(name, playerId, getRankIdWithRankNumber(name, rankNumber))
    end
end)

RegisterNetEvent("core:crew:changeRankName")
AddEventHandler("core:crew:changeRankName", function(token)
    if CheckPlayerToken(source, token) then
        changeRankName(name, playerId, rankId)
    end
end)

RegisterNetEvent("core:crew:changePerms")
AddEventHandler("core:crew:changePerms", function(token, name, perms)
    if CheckPlayerToken(source, token) then
        changePerms(name, perms)
    end
end)

RegisterNetEvent("core:crew:changeName")
AddEventHandler("core:crew:changeName", function(token, name, newName)
    local src = source 
    local ply = GetPlayer(src)
    if not ply then return end 
    if ply:getPermission() < 3 then 
        SunWiseKick(src, "Tried execute core:crew:changeName without permission")
        return
    end
    if CheckPlayerToken(src, token) then
        changeName(name, newName)
    end
end)

RegisterNetEvent("core:crew:changeDevise")
AddEventHandler("core:crew:changeDevise", function(token, name, devise)
    local src = source 
    local ply = GetPlayer(src)
    if not ply then return end 
    if ply:getPermission() < 3 then 
        SunWiseKick(src, "Tried execute core:crew:changeName without permission")
        return
    end
    if CheckPlayerToken(src, token) then
        changeDevise(name, devise)
    end
end)

RegisterNetEvent("core:crew:changeTypeCrew")
AddEventHandler("core:crew:changeTypeCrew", function(token, name, typeCrew)
    local src = source 
    local ply = GetPlayer(src)
    if not ply then return end 
    if ply:getPermission() < 3 then 
        SunWiseKick(src, "Tried execute core:crew:changeName without permission")
        return
    end
    if CheckPlayerToken(src, token) then
        changeTypeCrew(name, typeCrew)
    end
end)

RegisterNetEvent("core:crew:changeColor")
AddEventHandler("core:crew:changeColor", function(token, name, color)
    local src = source 
    local ply = GetPlayer(src)
    if not ply then return end 
    if ply:getPermission() < 3 then 
        SunWiseKick(src, "Tried execute core:crew:changeName without permission")
        return
    end
    if CheckPlayerToken(src, token) then
        changeColor(name, color)
    end
end)

RegisterNetEvent("core:crew:updateXp")
AddEventHandler("core:crew:updateXp", function(time, secu, token, amount, action, name, kind)
    local source = source
    if name == "none" then return end
    if CheckTrigger(source, time, secu, "core:crew:updateXp") then
        if CheckPlayerToken(source, token) then
            if updateXp(amount, action, name, kind) then
                if action == "add" then
                    TriggerClientEvent("__atoshi::createNotification", source, {
                        type = 'VERT',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Réputation du crew ~s" .. name .. " ~c augmenté ~c de ~s".. amount .."~c point(s) !"
                    })
                elseif action == "remove" then
                    TriggerClientEvent("__atoshi::createNotification", source, {
                        type = 'VERT',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Réputation du crew ~s " .. name .. " ~c baissé ~c de ~s".. amount .."~c point(s) !"
                    })
                end
                SendDiscordLog("xp", source, string.sub(GetDiscord(source), 9, -1),
                GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(), name, amount, kind)
            else
                TriggerClientEvent("__atoshi::createNotification", source, {
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~c erreur d'ajout d'xp pour ~s " .. name
                })
            end
        end
    end
end)

--callback

Citizen.CreateThread(function()
    while RegisterServerCallback == nil do
        Wait(1000)
    end

    RegisterServerCallback("core:crew:getAllCrew", function(source) -- done
        return GetAllCrews()
    end)

    RegisterServerCallback("core:crew:getCrewByName", function(source, name) -- done
        return getCrewByName(name)
    end)

    RegisterServerCallback("core:crew:getCrewById", function(source, id) -- done
        return GetCrew(id)
    end)

    RegisterServerCallback("core:crew:getCrewMembersByName", function(source, name) -- done
        return getCrewByName(name):getMembers()
    end)

    RegisterServerCallback("core:crew:getCrewMemberByName", function(source, name, id) -- done
        return getCrewMemberByName(name, id)
    end)

    RegisterServerCallback("core:crew:getCrewMembersById", function(source, id) -- done
        return GetCrew(id):getMembers()
    end)

    RegisterServerCallback("core:crew:getCrewRolesByName", function(source, name) -- done
        return getCrewByName(name):getRoles()
    end)

    RegisterServerCallback("core:crew:getCrewRolesById", function(source, id) -- done
        return GetCrew(id):getRoles()
    end)

    RegisterServerCallback("core:crew:getCrewVehByName", function(source, name) -- done
        return getAllCrewVehicle(name)
    end)

    RegisterServerCallback("core:crew:getCrewVehById", function(source, id) -- done
        return getAllCrewVehicle(GetCrew(id):getName())
    end)

    RegisterServerCallback("core:crew:getCrewPropertiesByName", function(source, name) -- done
        return getAllPropertiesCrew(name)
    end)

    RegisterServerCallback("core:crew:getCrewPropertiesById", function(source, id) -- done
        return getAllPropertiesCrew(GetCrew(id):getName())
    end)

    RegisterServerCallback("core:crew:getCrewPlayerRankByName", function(source, name, playerId) -- done
        for k,v in pairs(getCrewByName(name):getMembers()) do
            if v.id == playerId then return v.crewRank end
        end
        return false
    end)

    RegisterServerCallback("core:crew:getCrewPlayerRankById", function(source, id, playerId) -- done
        for k,v in pairs(GetCrew(id):getMembers()) do
            if v.id == playerId then return v.crewRank end
        end
        return false
    end)

    RegisterServerCallback("core:crew:canRecruiteByName", function(source, name, playerId) -- done
        for k,v in pairs(getCrewByName(name):getMembers()) do
            if v.id == playerId then 
                if getCrewByName(name):getPerms().recrute >= v.crewRank then
                    return true
                else
                    return false
                end
            end
        end
        return false
    end)

    RegisterServerCallback("core:crew:canRecruiteById", function(source, id, playerId) -- done
        for k,v in pairs(GetCrew(id):getMembers()) do
            if v.id == playerId then 
                if GetCrew(id):getPerms().recrute >= v.crewRank then
                    return true
                else
                    return false
                end
            end
        end
        return false
    end)

    RegisterServerCallback("core:crew:getCrewTypeByName", function(source, name) -- done
        if name == nil then return end
        return getCrewByName(name):getType()
    end)

    RegisterServerCallback("core:crew:getCrewTypeById", function(source, id) -- done
        return GetCrew(id):getType()
    end)

    RegisterServerCallback("core:crew:getCrewXpByName", function(source, name) -- done
        local xp = getCrewByName(name) and getCrewByName(name):getXp() or 5
        return xp
    end)

    RegisterServerCallback("core:crew:getCrewXpById", function(source, id) -- done
        local xp = GetCrew(id):getXp()
        return xp
    end)

    RegisterServerCallback("core:crew:getCrewLevelByName", function(source, name) -- done
        local xp = getCrewByName(name) and getCrewByName(name):getXp() or nil
        local levle = getLevel(xp)
        return levle
    end)

    RegisterServerCallback("core:crew:getCrewLevelById", function(source, id) -- done
        local xp = GetCrew(id):getXp()
        return getLevel(xp)
    end)

    RegisterServerCallback("core:crew:getSameKindCrews", function(source, name) -- done
        local typeCrew = getCrewByName(name):getType()
        return getSameKindCrews(typeCrew)
    end)

    RegisterServerCallback("core:crew:getGlobalXp", function(source) -- done
        return GetVariable("xpTablette")
    end)

    RegisterServerCallback("core:crew:getCrewInfosForRadial", function(source, name)
        local crew = getCrewByName(name)
        local xp = crew and crew:getXp() or nil
        local colour = crew and crew:getColor() or nil
        return xp, colour
    end)

end)

-- Loops

Citizen.CreateThread(function()  -- done
    while true do
        Wait(1 * 60000) -- 1min
        local crew = GetAllCrews()
        for k, v in pairs(crew) do
            if v.needSave then
                v:updateCrew()
                Wait(1000)
            end
        end
    end
end)

--export

exports("getCrew", function(id)
    return GetPlayer(id):getCrew()
end)

-- resource stop

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        CorePrint("Resource stopping, saving crew.")
        for k, v in pairs(GetAllCrews()) do
            v:updateCrew()
        end
    end
end)