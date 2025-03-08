local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local InsideGestionCrew = false
local sourcePlayer, playerCrew, crewInfo, crewMembers, crewGrade, crewVah, crewProperty, perms, players
-- RegisterCommand("crewGestion", function()
--     if p:getCrew() ~= "None" then
--         openCrewGestion()
--     end
-- end)

local function listMember(crewMembersN, crewGrade)
    local players = {}
    crewMembers = crewMembersN
    for i = 1, #crewMembersN, 1 do
        players[i] = {}
        players[i]["lname"] = crewMembersN[i].lastName
        players[i]["fname"] = crewMembersN[i].firstName
        players[i]["license"] = crewMembersN[i].license
        players[i]["id"] = crewMembersN[i].id
        players[i]["rank"] = crewMembersN[i].crewRank or 1
        if p:getLicense() == crewMembersN[i].license then sourcePlayer = i end
    end
    return players, sourcePlayer
end

local function listVeh(crewVeh)
    local veh = {}

    for i = 1, #crewVeh, 1 do
        veh[i] = {}
        veh[i]["vehName"] = crewVeh[i].name
        veh[i]["pounded"] = crewVeh[i].stored == 2 and true or false
        veh[i]["plate"] = crewVeh[i].plate
    end
    return veh
end

local function listProperty(crewProperty)
    local property = {}
    for i = 1, #crewProperty, 1 do
        local coords = crewProperty[i].enter_pos
        local var1, var2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
        local street = GetStreetNameFromHashKey(var1);
        local quarter = GetStreetNameFromHashKey(var2);
        property[i] = {}
        property[i]["type"] = crewProperty[i].type
        property[i]["address"] = street
        property[i]["id"] = crewProperty[i].id
    end
    return property
end

function isJson(perm)
    if type(perm) == "string" then
        return json.decode(perm) 
    end
    return perm
end

function openCrewGestion()
    if openCrewRadial then
        openCrewRadial = false
        closeUI()
    end
    if p:getCrew() == "None" then
        return
    end
    playerCrew = p:getCrew()
    crewInfo = TriggerServerCallback("core:crew:getCrewByName", playerCrew)
    crewVeh = {}--TriggerServerCallback("core:crew:getCrewVehByName", playerCrew)
    crewProperty = TriggerServerCallback("core:crew:getCrewPropertiesByName", playerCrew)
    perms = isJson(crewInfo.perms)
    players, sourcePlayer = listMember(crewInfo.members, crewInfo.roles)

    DisableControlAction(0, 24, true) -- disable attack
    DisableControlAction(0, 25, true) -- disable aim
    DisableControlAction(0, 1, true) -- LookLeftRight
    DisableControlAction(0, 2, true) -- LookUpDown
    DisableControlAction(0, 142, true)
    DisableControlAction(0, 18, true)
    DisableControlAction(0, 322, true)
    DisableControlAction(0, 106, true)
    DisableControlAction(0, 263, true) -- disable melee
    DisableControlAction(0, 264, true) -- disable melee
    DisableControlAction(0, 257, true) -- disable melee
    DisableControlAction(0, 140, true) -- disable melee
    DisableControlAction(0, 141, true) -- disable melee
    DisableControlAction(0, 142, true) -- disable melee
    DisableControlAction(0, 143, true) -- disable melee

    InsideGestionCrew = true
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'CrewMenuGestion',
        data = {
            color_title = crewInfo.color,
            background = crewInfo.color,
            crewName = crewInfo.name,
            crewDevise = crewInfo.devise,
            membres = #players,
            rang = (players[sourcePlayer] and players[sourcePlayer]["rank"] or 1),
            territoires = 3,
            recrute = perms.recrute or 1,
            exclure = perms.exclure or 1,
            editPerm = perms.editPerm or 1,
            editMembres = perms.editMembres or 1,
            sendDm = perms.sendDm or 1,
            crewOrEnterprise = true,
            nbrRank = 5,
            jobLabel = "",
            players = players,
            properties = listProperty(crewProperty),
            vehs = listVeh(crewVeh)
        }
    }));
end

local function getIdFromlicense(license)
    for i = 1, #crewMembers, 1 do
        if (crewMembers[i].license == license) then
            return crewMembers[i].id

        end
    end
    return "error cant find member id"
end

RegisterNUICallback("crewMember_callback", function(data)
    local tablee = {}
    for k, v in pairs(GetActivePlayers()) do
        table.insert(tablee, GetPlayerServerId(v))
    end
    local playerId = getIdFromlicense(data.player.license)
    if playerId == "error cant find member id" then
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "La personne n'a pas été trouvée."
        })
        return
    end
    local crewName = p:getCrew()
    if data.action == "infoPlayer" then
        TriggerServerEvent("core:crew:getPlayerInfo", token, crewName, playerId)
        return
    elseif data.action == "upPlayer" then
        if (players[sourcePlayer] and players[sourcePlayer]["rank"] or 1) <= perms.editMembres then
            TriggerServerEvent("core:crew:changePlayerRankInCrew", token, crewName, playerId, data.player.rank - 1)
            return
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous n'avez pas les permissions pour faire cela."
            })
            return
        end
    elseif data.action == "downPlayer" then
        if (players[sourcePlayer] and players[sourcePlayer]["rank"] or 1) <= perms.editMembres then
            TriggerServerEvent("core:crew:changePlayerRankInCrew", token, crewName, playerId, data.player.rank + 1)
            return
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous n'avez pas les permissions pour faire cela."
            })
            return
        end
    elseif data.action == "kickPlayer" then
        TriggerServerEvent("core:crew:removePlayerFromCrew", token, crewName, playerId, data.player.license)
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Erreur lors du callback crew : Action : " .. (data.action or "?")
        })
        return
    end
    openCrewGestion()
end)

local function checkModificationPerms(data)
    if type(data) ~= "table" then return perms end
    if data.recrute == perms.recrute and data.exclure == perms.exclure and data.editPerm == perms.editPerm and
        data.editMembres == perms.editMembres and data.sendDm == perms.sendDm then return 0 end
    if perms.recrute ~= data.recrute then perms.recrute = data.recrute end
    if perms.exclure ~= data.exclure then perms.exclure = data.exclure end
    if perms.editPerm ~= data.editPerm then perms.editPerm = data.editPerm end
    if perms.editMembres ~= data.editMembres then perms.editMembres = data.editMembres end
    if perms.sendDm ~= data.sendDm then perms.sendDm = data.sendDm end
    return perms
end

RegisterNUICallback("crewGestion_callback", function(data)
    print(json.encode(data, {indent = true}))
    local permedit = perms.editPerm or 1
    print(sourcePlayer, json.encode(players[sourcePlayer]), permedit)
    if (players[sourcePlayer] and players[sourcePlayer]["rank"] or 1) >= permedit then
        newPerms = checkModificationPerms(data)
        if (newPerms == 0) then 
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Les permissions sont les mêmes qu'avant."
            })
            return 
        end
        if (playerCrew) then
            TriggerServerEvent("core:crew:changePerms", token, playerCrew, newPerms)
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez changé les permissions de votre crew."
            })
        else
            print("Vous n'avez pas de crew")
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous n'avez pas de crew"
            })
            return
        end
    else
        print("Vous n'avez pas les autorisations pour faire cette action")
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Vous n'avez pas les autorisations pour faire cette action"
        })
        return
    end
    openCrewGestion()
end)

RegisterNUICallback("focusOut", function(data, cb)
    if InsideGestionCrew then
        InsideGestionCrew = false
        EnableControlAction(0, 24, true) -- disable attack
        EnableControlAction(0, 25, true) -- disable aim
        EnableControlAction(0, 1, true) -- LookLeftRight
        EnableControlAction(0, 2, true) -- LookUpDown
        EnableControlAction(0, 142, true)
        EnableControlAction(0, 18, true)
        EnableControlAction(0, 322, true)
        EnableControlAction(0, 106, true)
        EnableControlAction(0, 263, true) -- disable melee
        EnableControlAction(0, 264, true) -- disable melee
        EnableControlAction(0, 257, true) -- disable melee
        EnableControlAction(0, 140, true) -- disable melee
        EnableControlAction(0, 141, true) -- disable melee
        EnableControlAction(0, 142, true) -- disable melee
        EnableControlAction(0, 143, true) -- disable melee
        SetNuiFocus(false, false)
    end
end)