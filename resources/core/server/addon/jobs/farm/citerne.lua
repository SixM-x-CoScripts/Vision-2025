RegisterNetEvent("core:citerneInvitePlayer")
AddEventHandler("core:citerneInvitePlayer", function(sID, name, friend)
    local tableToSend = {
        name = name,
        friendLocal = friend
    }
    TriggerClientEvent("core:citerneInvitePlayer", tonumber(sID), tableToSend)
end)

RegisterNetEvent("core:citerneAcceptInvite")
AddEventHandler("core:citerneAcceptInvite", function(sID, myName)
    TriggerClientEvent("core:citerneAcceptInvite", sID, myName)
end)

RegisterNetEvent("core:citerneStartMission")
AddEventHandler("core:citerneStartMission", function(sID, job, car)
    TriggerClientEvent("core:citerneStartMission", sID, job, car)
end)

RegisterNetEvent("core:citerneUpdate")
AddEventHandler("core:citerneUpdate", function(sID, finish, newpos, amount)
    TriggerClientEvent("core:citerneUpdate", sID, finish, newpos, amount)
end)

RegisterNetEvent("core:citerneUpdateInMission")
AddEventHandler("core:citerneUpdateInMission", function(sID, job, k)
    TriggerClientEvent("core:citerneUpdateInMission", sID, job, k)
end)

RegisterNetEvent("core:citerneFinishMission")
AddEventHandler("core:citerneFinishMission", function(sID, finish)
    TriggerClientEvent("core:citerneFinishMission", sID, finish)
end)