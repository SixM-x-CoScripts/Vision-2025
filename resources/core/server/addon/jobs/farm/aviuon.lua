RegisterNetEvent("core:avionInvitePlayer")
AddEventHandler("core:avionInvitePlayer", function(sID, name, friend)
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
    TriggerClientEvent("core:avionInvitePlayer", tonumber(sID), tableToSend)
end)

RegisterNetEvent("core:avionAcceptInvite")
AddEventHandler("core:avionAcceptInvite", function(sID, myName)
    TriggerClientEvent("core:avionAcceptInvite", sID, myName)
end)

RegisterNetEvent("core:avionStartMission")
AddEventHandler("core:avionStartMission", function(sID, car)
    TriggerClientEvent("core:avionStartMission", sID, car)
end)

RegisterNetEvent("core:avionUpdateInMission")
AddEventHandler("core:avionUpdateInMission", function(sID, job, k)
    TriggerClientEvent("core:avionUpdateInMission", sID, job, k)
end)

RegisterNetEvent("core:avionFinishMission")
AddEventHandler("core:avionFinishMission", function(sID)
    TriggerClientEvent("core:avionFinishMission", sID)
end)

