RegisterNetEvent("core:ambulance:InvitePlayer")
AddEventHandler("core:ambulance:InvitePlayer", function(sID, name, friend)
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
    TriggerClientEvent("core:ambulance:InvitePlayer", tonumber(sID), tableToSend)
end)

RegisterNetEvent("core:ambulance:AcceptInvite")
AddEventHandler("core:ambulance:AcceptInvite", function(sID, myName)
    TriggerClientEvent("core:ambulance:AcceptInvite", sID, myName)
end)

RegisterNetEvent("core:ambulance:StartMission")
AddEventHandler("core:ambulance:StartMission", function(sID, car)
    TriggerClientEvent("core:ambulance:StartMission", sID, car)
end)

RegisterNetEvent("core:ambulance:UpdateInMission")
AddEventHandler("core:ambulance:UpdateInMission", function(sID, job, k)
    TriggerClientEvent("core:ambulance:UpdateInMission", sID, job, k)
end)

RegisterNetEvent("core:ambulance:FinishMission")
AddEventHandler("core:ambulance:FinishMission", function(sID)
    TriggerClientEvent("core:ambulance:FinishMission", sID)
end)

