RegisterNetEvent("core:RevivePlayer")
AddEventHandler("core:RevivePlayer", function(token, player, isStaff)
    local source = source
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >=2 or GetPlayer(source):getJob() == "bcms" or GetPlayer(source):getJob() == "ems" or GetPlayer(source):getJob() == "lsfd" or GetPlayer(source):getJob() == "sams" or GetPlayer(source):getJob() == "cayoems" then 
        --si tu veux rajouter des genres de récompenses au mec qui l'a réa tu peux le faire ici
            if isStaff then
                TriggerClientEvent('core:RevivePlayer', player, isStaff)
            else 
                TriggerClientEvent('core:RevivePlayer', player)
            end
        else
            SunWiseKick(source, "Tried exec core:RevivePlayer")
        end
    end
end)

RegisterNetEvent("core:HealthPlayer")
AddEventHandler("core:HealthPlayer", function(token, player)
    if CheckPlayerToken(source, token) then
        TriggerClientEvent('core:HealthPlayer', player)
    end
end)

RegisterNetEvent("core:KillPlayer")
AddEventHandler("core:KillPlayer", function(token, player)
    if CheckPlayerToken(source, token) then

        if GetPlayer(player):getPermission() >= 6 then
            TriggerClientEvent('core:KillPlayer', source)
            TriggerClientEvent("__atoshi::createNotification", player, {
                type = 'ROUGE',
                content = "Coucou loulou, "..GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname() .. " a essayé de te tuer, mais il a échoué !"
            })
            return
        end

        TriggerClientEvent('core:KillPlayer', player)
    end
end)

RegisterNetEvent("core:unset")
AddEventHandler("core:unset", function(player)
    print("unnoclip", player)
    TriggerClientEvent('core:unset', player)
end)

RegisterNetEvent("core:GetPatientIdentity")
AddEventHandler("core:GetPatientIdentity", function(token, player)
    local src = source
    if CheckPlayerToken(src, token) then
        local player = GetPlayer(player)
        if player ~= nil then
            TriggerClientEvent('core:GetPatientIdentity', src, {prenom = player:getFirstname(), nom = player:getLastname(), age = player:getAge(), sexe = player:getSex()})
        end
    end
end)

RegisterNetEvent("core:GetCauseOfDeath")
AddEventHandler("core:GetCauseOfDeath", function(token, player)
    local src = source
    if CheckPlayerToken(src, token) then
        local _player = GetPlayer(player)
        if _player ~= nil then
            local death = TriggerClientCallback(player, 'core:GetCauseOfDeath')
            TriggerClientEvent('core:GetCauseOfDeath', src, death)
        end
    else
        --AC:Todo
    end
end)

RegisterNetEvent("core:reviveanimrevived")
AddEventHandler("core:reviveanimrevived", function(players, playerheading, coords, playerlocation)
    local src = source
    SendDiscordLog("reviveems", src, string.sub(GetDiscord(src), 9, -1),
        GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
         coords, 
         GetPlayer(players):getLastname() .. " " .. GetPlayer(players):getFirstname(), 
         string.sub(GetDiscord(players), 9, -1))
    TriggerClientEvent("core:anim:revived", players, playerheading, coords, playerlocation, src)
    
end)

RegisterNetEvent("core:reviveanimreviver")
AddEventHandler("core:reviveanimreviver", function(players, playerheading, coords, playerlocation)
    local src = source
    TriggerClientEvent("core:anim:reviver", players)
end)

local brancardlist = {}

--Precondition : model de brancard valide et existe
--Postcondition : Ajoute le brancard concerné avec le joueur dessus à la table brancardlist
RegisterNetEvent("core:tableinsertplayer")
AddEventHandler("core:tableinsertplayer",function(model)
    local player = source
    if brancardlist[model] == nil then
        brancardlist[model] = {}
    end
	table.insert(brancardlist[model], player)
   -- print(json.encode(brancardlist))
end)

--Precondition : model de brancard valide et existe
--Postcondition : Retire le brancard concerné avec le joueur dessus à la table brancardlist
RegisterNetEvent("core:tableremoveplayer")
AddEventHandler("core:tableremoveplayer",function(model)
    local player = source
    if brancardlist[model] ~= nil then
        -- DOUBLE CHECK
        for k,v in pairs(brancardlist) do 
            if k == model then 
                table.remove(brancardlist, k)
            end
        end
        brancardlist[model] = nil
    end
   -- print(json.encode(brancardlist))
end)


--Precondition : model de brancard valide et existe, source valide
--Postcondition : Check si le brancard est dans la table brancardlist et renvoie l'id du joueur dessus si oui. Aussi non retourne nil
Citizen.CreateThread(function()
    while RegisterServerCallback == nil do Wait(1000) end
    RegisterServerCallback("core:tablecheckplayer", function(source, model)
       -- print("test: " ..json.encode(model))
        if brancardlist[model] == nil then
            return nil
        else
           -- print(brancardlist[model][1])
            return brancardlist[model][1]
        end
    end)
end)

--Precondition : player , un id joueur valide, model, un brancard valide, raison e {"baisserbrancard", "releverbrancard", nil} 
--Postcondition : Appel côté client l'allongement du joueur sur le brancard 
RegisterNetEvent("core:leanbrancardserver")
AddEventHandler("core:leanbrancardserver",function(player, model, raison)
    local model = NetworkGetEntityFromNetworkId(model)
    local model = NetworkGetNetworkIdFromEntity(model)
    TriggerClientEvent("core:leanbrancard", player, nil ,model, raison)
end)


--Precondition : player , un id joueur valide, model, un brancard valide
--Postcondition : Appel côté client le relèvement du joueur sur le brancard 
RegisterNetEvent("core:leanoffbrancardserver")
AddEventHandler("core:leanoffbrancardserver",function(player, model)
    local model = NetworkGetEntityFromNetworkId(model)
    local model = NetworkGetNetworkIdFromEntity(model)
    TriggerClientEvent("core:releaseleanbrancard", player, model)
end)

RegisterNetEvent("core:reposbrancard")
AddEventHandler("core:reposbrancard",function(player, model)
    local model = NetworkGetEntityFromNetworkId(model)
    local model = NetworkGetNetworkIdFromEntity(model)
    TriggerClientEvent("core:reposbrancard", player, model)
end)