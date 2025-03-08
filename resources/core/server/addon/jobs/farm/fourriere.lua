RegisterNetEvent("core:fourriereInvitePlayer")
AddEventHandler("core:fourriereInvitePlayer", function(sID, name, friend)
    local src = source
    local tableToSend = {
        name = name,
        friendLocal = friend
    }
    if GetPlayer(sID):getSubscription() == 0 then 
        TriggerClientEvent("__atoshi::createNotification", src, {
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Votre ami doit avoir le premium pour pouvoir participer."
        })
        return
    end
    TriggerClientEvent("core:fourriereInvitePlayer", tonumber(sID), tableToSend)
end)

RegisterNetEvent("core:fourriereAcceptInvite")
AddEventHandler("core:fourriereAcceptInvite", function(sID, myName)
    TriggerClientEvent("core:fourriereAcceptInvite", sID, myName)
end)

RegisterNetEvent("core:fourriereStartMission")
AddEventHandler("core:fourriereStartMission", function(sID, car)
    TriggerClientEvent("core:fourriereStartMission", sID, car)
end)

RegisterNetEvent("core:fourriereUpdateInMission")
AddEventHandler("core:fourriereUpdateInMission", function(sID, job, k)
    TriggerClientEvent("core:fourriereUpdateInMission", sID, job, k)
end)

RegisterNetEvent("core:fourriereFinishMission")
AddEventHandler("core:fourriereFinishMission", function(sID)
    TriggerClientEvent("core:fourriereFinishMission", sID)
end)

