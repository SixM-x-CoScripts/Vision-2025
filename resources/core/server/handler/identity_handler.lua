RegisterNetEvent("core:CreateIdentity")
AddEventHandler("core:CreateIdentity", function(nom, prenom, age, sexe, taille, birthplaces)
    print("[DEBUG] Creation perso : ", nom, prenom, age, sexe, taille, birthplaces)
    local _src = source
    local player = GetPlayer(_src)
    player:setLastname(nom)
    player:setFirstname(prenom)
    player:setAge(age)
    player:setSex(sexe)
    player:setSize(taille)
    player:setBirthplaces(birthplaces)
    player:setNeedSave(true)
    -- update id getIdPerso 
    local ids = player:getIdPerso()
    if ids and ids.characterList then
        for k,v in pairs(ids.characterList) do 
            if player:getId() == v.id then 
                v.name = prenom .. " " .. nom
            end
        end
        player:setIdPerso(ids)
    end
    TriggerClientEvent("core:setIdentityPlayer", _src, nom, prenom, age, sexe, taille, birthplaces)    
    --RefreshPlayerData(_src)
    MarkPlayerDataAsNonSaved(_src)
    SavePlayerData(_src, true)

    -- Save in BDD the firstname and lastname
    MySQL.Async.execute("UPDATE players SET firstname=@firstname, lastname=@lastname WHERE id = @id"
    , {
        ["@id"] = player:getId(),
        ["@firstname"] = prenom,
        ["@lastname"] = nom,
    })

	local mdtParams = {
		identifier = player:getId(),
		name = string.capitalize(prenom) .. " " .. string.upper(nom) .. " ("..sexe..")",
		birthdate = age,
	}

	exports['knid-mdt']:api().people.create(mdtParams,
	function(cb)
		if cb == 201 then
			print('[' .. cb .. '] MDT: Person created : ', json.encode(mdtParams))
		else
			print('[' .. cb .. '] MDT: Error creating person : ', json.encode(mdtParams))	
		end
	end)
end)


-- Changement du nom et prénom en BDD

RegisterCommand("identitycorrection", function(token, source)

    local nom = GetPlayer(token):getLastname()

    local prenom = GetPlayer(token):getFirstname()

    print('Nom : '..nom .. ' | Prénom : '.. prenom )

    GetPlayer(token):setLastname(prenom)
    GetPlayer(token):setFirstname(nom)

    local newnom = GetPlayer(token):getLastname()

    local newprenom = GetPlayer(token):getFirstname()

    print('New Nom : '..newnom .. ' | New Prénom : '.. newprenom )

end)

RegisterCommand("changeName", function(source, args)
    if GetPlayer(source):getPermission() < 5 then return end
    local player = args[1] and tonumber(args[1]) or nil 
    local prenom = args[2] and args[2] or nil 
    local nom = args[3] and args[3] or nil 
    if player and GetPlayerName(player) and prenom and nom then
        GetPlayer(player):setLastname(nom)
        GetPlayer(player):setFirstname(prenom)
        TriggerClientEvent("core:changedname", player, prenom, nom)
        print("Vous avez changé le prénom et nom de " .. GetPlayerName(player) .. ". En " .. prenom, nom)
    else
        print("Le joueur n'existe pas ou vous n'avez pas saisie de prenom & nom")
    end
end)

RegisterCommand("changeAge", function(source, args)
    if GetPlayer(source):getPermission() < 5 then return end
    local player = args[1] and tonumber(args[1]) or nil 
    local age = args[2] and args[2] or nil 
    if player and GetPlayerName(player) and age then
        GetPlayer(player):setAge(age)
        print("Vous avez changé l'age de " .. GetPlayerName(player) .. ". En " .. age)
    else
        print("Le joueur n'existe pas ou vous n'avez pas saisie d'age")
    end
end)

RegisterNetEvent("core:InstancePlayer")
AddEventHandler("core:InstancePlayer", function(token, instance, reason)
    local src = source
    SetPlayerRoutingBucket(src, tonumber(instance))
    ChangePlayerBucket(src, tonumber(instance))

    TriggerClientEvent("Core:PrintChangeInstance", src, src, tonumber(instance), reason)
end)

Citizen.CreateThread(function()
    while RegisterServerCallback == nil do
        Wait(0)
    end
    RegisterServerCallback("core:CheckInstance", function(source)
        --if CheckPlayerToken(source, token) then
            if GetPlayerRoutingBucket(source) == 0 then
                return true
            else
                return false
            end
        --else
        --    ---ACEvent
        --end
    end)
    
    RegisterServerCallback("core:GetInstanceID", function(source)
        return GetPlayerRoutingBucket(source)
    end)
end)

RegisterCommand("getInstance", function(source, args, rawCommand)
    print(GetPlayerRoutingBucket(source))
end, false)

RegisterCommand("leaveinstance", function(source, args, rawCommand)
    SetPlayerRoutingBucket(source, 0)
    ChangePlayerBucket(source, 0)
end, false)

RegisterCommand("instance", function(source, args, rawCommand)
    if tonumber(args[1]) and tonumber(args[2]) then
        if GetPlayer(source):getPermission() >= 3 then
            SetPlayerRoutingBucket(tonumber(args[1]), tonumber(args[2]))
            ChangePlayerBucket(tonumber(args[1]), tonumber(args[2]))
        end
    else
        SetPlayerRoutingBucket(source, 0)
        ChangePlayerBucket(source, 0)
    end
end, false)

exports("playerIdentity", function(playerid)
    return {prenom = GetPlayer(playerid):getFirstname(), nom = GetPlayer(playerid):getLastname()}
    --return GetPlayer(playerid):getIdentity()
end)

exports("getId", function(playerid)
    return GetPlayer(playerid):getId()
end)
