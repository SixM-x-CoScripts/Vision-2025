local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)
local societyMember
local InsideJobGestion
local jobInfo, jobVeh, jobProperty, property, jobLabel, playerJob, sourcePlayer, perms, players
RegisterCommand("jobGestion", function()
    openJobGestion()
end)

local function listMember()
    local players = {}
    for i = 1, #societyMember, 1 do
        if not societyMember[i] then 
            societyMember[i] = {}
        end
        players[i] = {}
        players[i]["lname"] = societyMember[i].nom
        players[i]["fname"] = societyMember[i].prenom
        players[i]["id"] = societyMember[i].id
        players[i]["license"] = societyMember[i].license
        players[i]["rank"] = societyMember[i].grade
        if societyMember[i].grade and loadedJob.grade[societyMember[i].grade] and loadedJob.grade[societyMember[i].grade].label then
            players[i]["jobLabel"] = tostring(loadedJob.grade[societyMember[i].grade].label)
        else
            players[i]["jobLabel"] = societyMember[i].grade
        end
        if p:getId() == societyMember[i].id then 
            sourcePlayer = i 
            if societyMember[i].grade and loadedJob.grade[societyMember[i].grade] and loadedJob.grade[societyMember[i].grade].label then
                jobLabel = tostring(loadedJob.grade[societyMember[i].grade].label)
            else
                jobLabel = societyMember[i].grade
            end
        end
    end
    return players, sourcePlayer
end


RegisterNetEvent("core:GetEmployeeList")
AddEventHandler("core:GetEmployeeList", function(list)
    societyMember = list
    listMember()
end)

RegisterNetEvent("core:getJobInfo")
AddEventHandler("core:getJobInfo", function(list)
    jobInfo = list[1]
end)

RegisterNetEvent("core:getJobVeh")
AddEventHandler("core:getJobVeh", function(list)
    jobVeh = list
end)

RegisterNetEvent("core:getJobProperty")
AddEventHandler("core:getJobProperty", function(list)
    jobProperty = list
end)

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
        if not crewProperty[i] then 
            crewProperty[i] = {}
        end
        local coords = json.decode(crewProperty[i].enter_pos)
        local data = json.decode(crewProperty[i].data)
        local var1, var2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(),
            Citizen.ResultAsInteger())
        local street = GetStreetNameFromHashKey(var1);
        local quarter = GetStreetNameFromHashKey(var2);
        property[i] = {}
        property[i]["type"] = data and data.type or "Inconnu"
        property[i]["address"] = street or "Inconnu"
        property[i]["id"] = crewProperty[i].id
    end

    return property
end

function openJobGestion()
    if p:getJob() == "aucun" then
        return
    end
    playerJob = p:getJob()
    TriggerServerEvent("core:GetEmployeeList", token, playerJob)
    TriggerServerEvent("core:getJobInfo", token, playerJob)
    TriggerServerEvent("core:getJobVeh", token, playerJob)
    TriggerServerEvent("core:getJobProperty", token, playerJob)
    while not societyMember or not jobInfo or not jobVeh or not jobProperty do 
        Wait(1)
    end
    printDev("jobInfo", json.encode(jobInfo))
    perms = json.decode(jobInfo.perm)
    printDev("Loaded job perm", jobInfo.perm)
    players, sourcePlayer = listMember()
    printDev("players, sourcePlayer", players, sourcePlayer)
    property = listProperty(jobProperty)
    printDev("property", property)

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

    InsideJobGestion = true
    printDev(jobInfo.color and jobInfo.color or "Could not load color, choosing default color : #00FF00")
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'CrewMenuGestion',
        data = {
            color_title = jobInfo.color or "#00FF00",
            background = jobInfo.color or "#00FF00",
            crewName = p:getJob(),
            crewDevise = jobInfo.devise or "",
            membres = players ~= nil and #players or 0,
            rang = GlobalState['serviceCount_' .. p:getJob()] or 0,
            territoires = property ~= nil and #property or 0,
            recrute = perms.recrute or 1,
            exclure = perms.exclure or 1,
            editPerm = perms.editPerm or 1,
            editMembres = perms.editMembres or 1,
            sendDm = perms.sendDm or 1,
            crewOrEnterprise = false,
            nbrRank = 5,
            jobLabel = jobLabel or p:getJob(),
            players = players,
            properties = property,
            vehs = listVeh(jobVeh)
        }
    }));
end

RegisterNUICallback("jobMember_callback", function(data)
    printDev(json.encode(data, {indent = true}))
    if data.action == "infoPlayer" then
        --print(json.encode(data, {indent = true}))
        exports['vNotif']:createNotification({
            type = 'VERT',
            -- duration = 5, -- In seconds, default:  4
            content = "L'employé " ..  data.player.fname .. " " .. data.player.lname .. " est " .. data.player.jobLabel .. " (" .. data.player.rank .. ")."
        })
    elseif data.action == "upPlayer" then
        if players[sourcePlayer]["rank"] >= perms.editMembres then
            TriggerServerEvent("core:PromotePlayer", token, data.player.license, data.player.id, playerJob, data.player.rank + 1)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous n'avez pas les permissions."
            })
            return
        end
    elseif data.action == "downPlayer" then
        if players[sourcePlayer]["rank"] >= perms.editMembres then
            TriggerServerEvent("core:PromotePlayer", token, data.player.license, data.player.id, playerJob, data.player.rank - 1)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous n'avez pas les permissions."
            })
            return
        end
    elseif data.action == "kickPlayer" then
        print("Rank", players[sourcePlayer]["rank"])
        print("perms.exclure", perms.exclure)
        if (players[sourcePlayer] and players[sourcePlayer]["rank"]) >= (perms and perms.exclure or 5) then
            TriggerServerEvent("core:KickPlayerFromJob", token, data.player.license, data.player.id, playerJob)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous n'avez pas les permissions."
            })
            return
        end
    else
    end
    openJobGestion()
end)

local function checkModificationPerms(data)
    if data.recrute == perms.recrute and data.exclure == perms.exclure and data.editPerm == perms.editPerm and
        data.editMembres == perms.editMembres and data.sendDm == perms.sendDm then return 0 end
    if perms.recrute ~= data.recrute then perms.recrute = data.recrute end
    if perms.exclure ~= data.exclure then perms.exclure = data.exclure end
    if perms.editPerm ~= data.editPerm then perms.editPerm = data.editPerm end
    if perms.editMembres ~= data.editMembres then perms.editMembres = data.editMembres end
    if perms.sendDm ~= data.sendDm then perms.sendDm = data.sendDm end
    return perms
end

RegisterNUICallback("jobGestion_callback", function(data)
    printDev("sourcePlayer", sourcePlayer)
    printDev("rank", players[sourcePlayer]["rank"])
    printDev("editPerm", perms.editPerm)
    if players[sourcePlayer]["rank"] >= perms.editPerm then
        newPerms = checkModificationPerms(data)
        if (newPerms == 0) then print("perms not modified") return end
        if (playerJob) then
            TriggerServerEvent("core:changePermsJob", token, playerJob, newPerms)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous n'avez pas les permissions."
            })
            return
        end
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous n'avez pas les permissions."
        })
        return
    end
    openJobGestion()
end)

RegisterNUICallback("focusOut", function(data, cb)
    if InsideJobGestion then
        InsideJobGestion = false
        societyMember, jobInfo, jobVeh, jobProperty = nil, nil, nil, nil
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
    end
end)
