local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local pushingbrancard = false
local leanonbrancard = false

-- Precondition : /
-- Postcondition : Fait spawn un brancard par Spawnbrancard()
RegisterCommand("brancard", function(source)
    if p:getJob() == "ems" or p:getJob() == "lsfd" then
        Spawnbrancard()
    else 
        print("Tu n'es pas ems ou lsfd")
    end
end)

-- Precondition : /
-- Postcondition : Spawn un brancard devant le joueur
function Spawnbrancard()
    LoadModel('fernocot')
    local px, py, pz = table.unpack(p:pos()) -- Les coords du joueurs unpack
    local vx, vy , vz = table.unpack(GetEntityForwardVector(p:ped())) -- Le vecteur unitaire de direction du joueur unpack
    local x = px + vx  -- Utilise le vecteur unitaire pour mettre les props à 1 unité de lui grace au vecteur unitaire + ces coords
    local y = py + vy
    local z = pz + vz 
    local brancard = CreateObject(GetHashKey('fernocot'), x, y , z , true)
    if brancard == 0 then
        print("Error brancard ID 1 : le brancard n'a pas spawn !")
        return -1
    end
    print("Infos brancard ID 1 : 'id' : " ..brancard.. " 'Netid' : " ..NetworkGetNetworkIdFromEntity(brancard))
    SetEntityHeading(brancard, GetEntityHeading(p:ped()))
    PlaceObjectOnGroundProperly(brancard)
    SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(brancard), true)
end

-- Déclare Spawn brancard Appelable
RegisterNetEvent("core:Spawnbrancard")
AddEventHandler('core:Spawnbrancard', Spawnbrancard)

--Precondition : brancard existe et valide
--Postcondition : Supprime le brancard et release le joueur dessus si il y en a 1.
function deletebrancard(brancard)
    
    if pushingbrancard then
        releasebrancard(brancard)
    end

    local player = triggerleanplayerleanbrancard(brancard)
    print("Infos brancard ID 2 : 'id' : " ..brancard.. " 'Netid' : " ..NetworkGetNetworkIdFromEntity(brancard))
    TriggerServerEvent("DeleteEntity", token, {NetworkGetNetworkIdFromEntity(brancard)})

    if player ~= nil then
        return player
    else 
        return nil
    end
end

-- Precondition : /
-- Postcondition : Relève le brancard et reset le player attaché au brancard relevé si il était
function releverbrancard(brancard)
    print("Infos brancard ID 3 : 'id' : " ..brancard.. " 'Netid' : " ..NetworkGetNetworkIdFromEntity(brancard))
    local x, y, z = table.unpack(GetEntityCoords(brancard))  
    LoadModel('fernocot')
    local heading = GetEntityHeading(brancard)
    local playerwasleanonbrancard = deletebrancard(brancard)
    Wait(40)
    local newbrancard = CreateObject(GetHashKey('fernocot'), x, y , z , true)
    if newbrancard == 0 then
        print("Error brancard ID 3 : le brancard n'a pas spawn !")
        return -1
    end
    print("Infos brancard ID 4 : 'id' : " ..newbrancard.. " 'Netid' : " ..NetworkGetNetworkIdFromEntity(newbrancard))
    SetEntityHeading(newbrancard, heading)
    Wait(150)
    PlaceObjectOnGroundProperly(newbrancard)
    SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(newbrancard), true)
    if playerwasleanonbrancard  ~= nil then
        Wait(200)
        TriggerServerEvent("core:leanbrancardserver", playerwasleanonbrancard, NetworkGetNetworkIdFromEntity(newbrancard), "brancardrelever")
    end
end





-- Precondition : brancard existe
-- Postcondition : Descend le bracanrt (change de props) et descend le joueur également dessus si il y en a un
function baisserbrancard(brancard)
    print("Infos brancard ID 5 : 'id' : " ..brancard.. " 'Netid' : " ..NetworkGetNetworkIdFromEntity(brancard))
    local x, y, z = table.unpack(GetEntityCoords(brancard))  
    LoadModel('loweredfernocot')
    local heading = GetEntityHeading(brancard)
    local playerwasleanonbrancard = deletebrancard(brancard)
    Wait(40)
    local newbrancard = CreateObject(GetHashKey('loweredfernocot'), x, y , z , true)
    if newbrancard == 0 then
        print("Error brancard ID 4 : le brancard n'a pas spawn !")
        return -1
    end
    print("Infos brancard ID 6 : 'id' : " ..newbrancard.. " 'Netid' : " ..NetworkGetNetworkIdFromEntity(newbrancard))
    SetEntityHeading(newbrancard, heading)
    Wait(150)
    PlaceObjectOnGroundProperly(newbrancard)
    SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(newbrancard), true)
    if playerwasleanonbrancard  ~= nil then
        Wait(200)
        TriggerServerEvent("core:leanbrancardserver", playerwasleanonbrancard, NetworkGetNetworkIdFromEntity(newbrancard), "brancardbaisser")
    end

end



-- Precondition : brancard ~= nil, brancard étant l'id d'une entité "brancard" existant", la raison : nil (allonger), "brancardrelever", "brancardbaisser"
-- Postcondition : allonge le joueur qui le trigger sur le brancard pris en entrée et le déclare comme allongé sur le brancard côté serveur
function leanbrancard(brancardclient, brancardserveur, raison)
    local brancard = nil
    local networkbrancard = nil
    if brancardclient == nil or brancardclient == 0 then
       -- print(brancardserveur)
        networkbrancard = brancardserveur
        brancard = NetworkGetEntityFromNetworkId(brancardserveur)
       -- print(brancard)
    elseif brancardserveur == nil or brancardserveur == 0 then
        brancard = brancardclient
        networkbrancard = NetworkGetNetworkIdFromEntity(brancard)
    end
    print("Infos brancard ID 8 : 'id' : " ..brancard.. " 'Netid' : " ..networkbrancard)
    local source = source
    RequestAnimDict("switch@trevor@annoys_sunbathers")
    while not HasAnimDictLoaded("switch@trevor@annoys_sunbathers") do Wait(20) end
    TaskPlayAnim(p:ped(), 'switch@trevor@annoys_sunbathers', "trev_annoys_sunbathers_loop_girl", 8.0, -8.0, -1, 1, 0, false, false, false)

    if raison == nil or raison == "brancardbaisser" then
        AttachEntityToEntity(PlayerPedId(), brancard, GetPedBoneIndex(brancard, 1), -0.00, -0.2, 1.5, 180.0, 165.0, -90.0, false, true, true, true, 2, true)
    else
        AttachEntityToEntity(PlayerPedId(), brancard, GetPedBoneIndex(brancard, 1), -0.00, -0.2, 2.15, 180.0, 165.0, -90.0, false, true, true, true, 2, true)
    end
    TriggerServerEvent("core:tableinsertplayer", networkbrancard)
    leanonbrancard = true
    while true do 
        Wait(500)
        local obj = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.5, GetHashKey("loweredfernocot"), true)
        local obj2 = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.5, GetHashKey("fernocot"), true)
        local obj3 = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.5, GetHashKey("loweredfernocot"))
        local obj4 = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.5, GetHashKey("fernocot"))
        if obj == 0 and obj2 == 0 and obj3 == 0 and obj4 == 0 then 
            print("Stop get out")
            StopAnimTask(p:ped(), 'switch@trevor@annoys_sunbathers', 'trev_annoys_sunbathers_loop_girl', 1.0)
            ClearPedTasks(p:ped())
            DetachEntity(PlayerPedId(), true, true)
            break
        end
    end
         
end

-- Déclare leanbrancard comme appelable server sided pour bien s'occuper du joueur sur le brancard
RegisterNetEvent("core:leanbrancard")
AddEventHandler("core:leanbrancard", leanbrancard)

-- Precondition : brancard.id existe
-- Postcondition : Check si un joueur est allongé sur le brancard et si il y en a un , il appelle releaseplayerleanbrancard côté client du joueur allongé et retourne l'id du joueur. Aussi non retourne nil.
function triggerleanplayerleanbrancard(brancard)
    print("Infos brancard ID 9 : 'id' : " ..brancard.. " 'Netid' : " ..NetworkGetNetworkIdFromEntity(brancard))
    local player = TriggerServerCallback("core:tablecheckplayer", NetworkGetNetworkIdFromEntity(brancard))
    
    if player ~= nil then
        print("Player : " ..player)
        wasleanonbrancard = true
        TriggerServerEvent("core:leanoffbrancardserver", player, NetworkGetNetworkIdFromEntity(brancard))
        Wait(20)
        return player
    else 
        print("Player : nil")
    end
    return nil 
end
 
-- Precondition : brancard ~= nil, brancard étant l'id d'une entité "brancard" existant"
-- Postcondition : Relève le joueur du brancard et le déclare comme relevé du brancard côté serveur
function releaseplayerleanbrancard(brancard)
    print("Infos brancard ID 10 : 'id' : " ..brancard.. " 'Netid' : " ..NetworkGetNetworkIdFromEntity(brancard))
    if brancard == nil then
        print("Error brancard ID 5 : le brancard n'existe pas !")
        return -1
    end
    TriggerServerEvent("core:tableremoveplayer", NetworkGetNetworkIdFromEntity(brancard))
    leanonbrancard = false
    DetachEntity(PlayerPedId(), true, true)
    StopAnimTask(p:ped(), 'switch@trevor@annoys_sunbathers', 'trev_annoys_sunbathers_loop_girl', 1.0)
    ClearPedTasks(p:ped())
    brancard = nil
    networkbrancard = nil
end

-- Déclare releaseleanbrancard comme appelable server sided pour bien s'occuper du joueur sur le brancard
RegisterNetEvent("core:releaseleanbrancard")
AddEventHandler('core:releaseleanbrancard', releaseplayerleanbrancard)

RegisterNetEvent("core:reposbrancard")
AddEventHandler('core:reposbrancard', function(model)
    local obj = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.5, GetHashKey("loweredfernocot"), true)
    local obj2 = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.5, GetHashKey("fernocot"), true)
    local obj3 = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.5, GetHashKey("loweredfernocot"))
    local obj4 = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.5, GetHashKey("fernocot"))
    if obj ~= 0 then
        RequestAnimDict("switch@trevor@annoys_sunbathers")
        while not HasAnimDictLoaded("switch@trevor@annoys_sunbathers") do Wait(20) end
        TaskPlayAnim(p:ped(), 'switch@trevor@annoys_sunbathers', "trev_annoys_sunbathers_loop_girl", 8.0, -8.0, -1, 1, 0, false, false, false)
        AttachEntityToEntity(PlayerPedId(), obj, GetPedBoneIndex(obj, 1), -0.00, -0.2, 2.15, 180.0, 165.0, -90.0, false, true, true, true, 2, true)
    end
    if obj2 ~= 0 then
        RequestAnimDict("switch@trevor@annoys_sunbathers")
        while not HasAnimDictLoaded("switch@trevor@annoys_sunbathers") do Wait(20) end
        TaskPlayAnim(p:ped(), 'switch@trevor@annoys_sunbathers', "trev_annoys_sunbathers_loop_girl", 8.0, -8.0, -1, 1, 0, false, false, false)
        AttachEntityToEntity(PlayerPedId(), obj2, GetPedBoneIndex(obj2, 1), -0.00, -0.2, 2.15, 180.0, 165.0, -90.0, false, true, true, true, 2, true)
    end
    if obj3 ~= 0 then
        RequestAnimDict("switch@trevor@annoys_sunbathers")
        while not HasAnimDictLoaded("switch@trevor@annoys_sunbathers") do Wait(20) end
        TaskPlayAnim(p:ped(), 'switch@trevor@annoys_sunbathers', "trev_annoys_sunbathers_loop_girl", 8.0, -8.0, -1, 1, 0, false, false, false)
        AttachEntityToEntity(PlayerPedId(), obj3, GetPedBoneIndex(obj3, 1), -0.00, -0.2, 2.15, 180.0, 165.0, -90.0, false, true, true, true, 2, true)
    end
    if obj4 ~= 0 then
        RequestAnimDict("switch@trevor@annoys_sunbathers")
        while not HasAnimDictLoaded("switch@trevor@annoys_sunbathers") do Wait(20) end
        TaskPlayAnim(p:ped(), 'switch@trevor@annoys_sunbathers', "trev_annoys_sunbathers_loop_girl", 8.0, -8.0, -1, 1, 0, false, false, false)
        AttachEntityToEntity(PlayerPedId(), obj4, GetPedBoneIndex(obj4, 1), -0.00, -0.2, 2.15, 180.0, 165.0, -90.0, false, true, true, true, 2, true)
    end
    local objsend = obj ~= 0 and obj or obj2 ~= 0 and obj2 or obj3 ~= 0 and obj3 and obj4 ~= 0 and obj4
    leanbrancard(objsend, model, "brancardhaut")
end)


-- Precondition : brancard, un brancard valide
-- Postcondition : Le joueur pousse le brancard
function pushbrancard(brancard)
    DetachEntity(brancard, true, true)
    print("Infos brancard ID 11 : 'id' : " ..brancard.. " 'Netid' : " ..NetworkGetNetworkIdFromEntity(brancard))
    NetworkRequestControlOfEntity(brancard)
    RequestAnimDict("anim@heists@box_carry@")
    while not HasAnimDictLoaded("anim@heists@box_carry@") do Wait(20) end
    TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
    AttachEntityToEntity(brancard, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), -0.00, -0.85, -1.4, 180.0, 165.0, -90.0, false, true, true, false, 2, true)
    pushingbrancard = true
    local player = TriggerServerCallback("core:tablecheckplayer", NetworkGetNetworkIdFromEntity(brancard))
    if player ~= nil then
        TriggerServerEvent("core:reposbrancard", player, NetworkGetNetworkIdFromEntity(brancard))
    end
    while pushingbrancard do 
        Wait(1)
        local closestVeh, closestDist = GetClosestVehicle(p:pos())
        local model = GetEntityModel(closestVeh)

        if not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 3) then 
            TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
        end

        local isModelAmbulance = model == GetHashKey("ambulance") and true or model == GetHashKey("ambulance4") and true or model == GetHashKey("lsfd3") and true or false

        if #(p:pos() - GetWorldPositionOfEntityBone(closestVeh, GetEntityBoneIndexByName(closestVeh, "platelight"))) < 3.5 and isModelAmbulance then 
            ShowHelpNotification("~INPUT_PICKUP~ Placer le brancard dans l'ambulance")
            if IsControlJustPressed(0, 38) then 
                DetachEntity(brancard, true, true)
                ClearPedTasks(PlayerPedId())
                pushingbrancard = false
                AttachEntityToEntity(brancard, closestVeh, GetEntityBoneIndexByName(closestVeh, "platelight"), -0.00, 1.5, 0.9, 180.0, 165.0, -90.0, false, true, true, false, 2, true)
            end
        end
    end
end

function SleepOnBrancard(entity)
    local pPed = p:ped()
    local pPos = p:pos()
    local entityCoords = GetEntityCoords(entity)
    local offset = 0.5
    local heading = 180.0
    local rot = GetEntityRotation(entity)
    if entity ~= nil then
        if IsEntityPlayingAnim(pPed, "combat@damage@writheidle_c", "writhe_idle_g") then
            ClearPedTasks(pPed)

            RequestAnimDict("combat@damage@writheidle_c")
            while not HasAnimDictLoaded("combat@damage@writheidle_c") do Wait(1) end

            SetEntityCoords(p:ped(), entityCoords.x, entityCoords.y, entityCoords.z + 0.5)
            SetEntityHeading(p:ped(), (GetEntityHeading(entity) + 180.0))

            TaskPlayAnim(p:ped(), 'combat@damage@writheidle_c', "writhe_idle_g", 8.0, -8.0, -1, 1, 0, false, false, false)
        else
            RequestAnimDict("combat@damage@writheidle_c")
            while not HasAnimDictLoaded("combat@damage@writheidle_c") do Wait(1) end

            SetEntityCoords(p:ped(), entityCoords.x, entityCoords.y, entityCoords.z + 0.5)
            SetEntityHeading(p:ped(), (GetEntityHeading(entity) + 180.0))

            TaskPlayAnim(p:ped(), 'combat@damage@writheidle_c', "writhe_idle_g", 8.0, -8.0, -1, 1, 0, false, false, false)
        end
    end
end

-- Precondition : model, un brancard valide
-- Postcondition : Le joueur lache le brancard
function releasebrancard(brancard)
    print("Infos brancard ID 12 : 'id' : " ..brancard.. " 'Netid' : " ..NetworkGetNetworkIdFromEntity(brancard))
    pushingbrancard = false
    DetachEntity(brancard, true, true)
    PlaceObjectOnGroundProperly(brancard)
    StopAnimTask(p:ped(), 'anim@heists@box_carry@', 'idle', 1.0)
    ClearPedTasks(p:ped())
end

