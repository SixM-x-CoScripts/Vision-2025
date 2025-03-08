RegisterNetEvent("core:activities:create", function(token, players, typejob)
    TriggerClientEvents("core:activities:create", players, typejob, players)
end)

RegisterNetEvent("core:activities:update", function(players, typejob, data)
    local src = source
    TriggerClientEvents("core:activities:update", players, typejob, data, src)
end)

RegisterNetEvent("core:activities:liveupdate", function(players, typejob, data)
    local src = source
    TriggerClientEvents("core:activities:liveupdate", players, typejob, data, src)
end)

RegisterNetEvent("core:activities:askJob", function(ply, label, forcePremium)
    local src = source
    if forcePremium then 
        if GetPlayer(ply):getSubscription() == 0 then 
            TriggerClientEvent("__atoshi::createNotification", src, {
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Votre ami doit avoir le premium pour pouvoir participer."
            })
            return
        end
    end
    TriggerClientEvent("core:activities:askJob", ply, label, src, GetPlayer(src):getFirstname())
end)

RegisterNetEvent("core:activities:acceptJob", function(psource)
    local src = source
    TriggerClientEvent("core:activities:acceptedJob", src, psource, GetPlayer(psource):getFirstname())
    TriggerClientEvent("core:activities:acceptedJob", psource, src, GetPlayer(src):getFirstname())
end)

RegisterNetEvent("core:activities:kickPlayers", function(tablePly, typeJob, proper, info)
    local src = source
    if not proper then
        for k,v in pairs(tablePly) do 
            if v then
                if type(v) == "number" then 
                    TriggerClientEvent("core:activities:kickPlayer", v, typeJob, info)
                else
                    TriggerClientEvent("core:activities:kickPlayer", v.id, typeJob, info)
                end
            end
        end
    else
        TriggerClientEvents("core:activities:kickPlayer", tablePly, typeJob, info)
    end
end)

RegisterNetEvent("core:activities:SelectedKickPlayer", function(player, typeJob,info)
    local src = source
    TriggerClientEvent("core:activities:kickPlayer", player, typeJob, info)
end)