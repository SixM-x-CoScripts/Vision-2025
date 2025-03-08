local token = nil 

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

insideMission = false

function getWinRange(job, winMin, winMax)
    local jobcenter = GetVariable("jobcenter")

    if jobcenter and jobcenter[job] and tonumber(jobcenter[job].winMin) and tonumber(jobcenter[job].winMax) then
        return tonumber(jobcenter[job].winMin), tonumber(jobcenter[job].winMax)
    elseif tonumber(winMin) and tonumber(winMax) then
        return tonumber(winMin), tonumber(winMax)
    else
        return false, false
    end
end

RegisterNetEvent("core:activities:askJob", function(job, psource, name)
    local jobConfirmation = ChoiceInput("Souhaitez vous rejoindre l'activité " .. job .. " avec " .. name .. " ?")
    if jobConfirmation then 
        if not insideMission then
            insideMission = true
            TriggerServerEvent("core:activities:acceptJob", psource)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous êtes déjà dans l'activité."
            })   
        end
    end
end)

function onMissionFinished()
    insideMission = false
end 

ActivityPlayersId = {}
ActivityPlayersInJob = {}

function InitializeActivity(typeJob)
    ActivityPlayersId = {}
    for k, v in pairs(ActivityPlayersInJob) do 
        table.insert(ActivityPlayersId, v.id)
    end
    TriggerServerEvent("core:activities:create", token, ActivityPlayersId, typeJob)
end

function ActivityAskPlayer(rad, typeJob)
    local closestPlayer = ChoicePlayersInZone(rad, false)
    if closestPlayer == nil then
        return
    end
    if closestPlayer == PlayerId() then return end
    local sID = GetPlayerServerId(closestPlayer)
    TriggerServerEvent("core:activities:askJob", sID, typeJob)
end

RegisterNetEvent("stopScript", function()
    onMissionFinished()
end)