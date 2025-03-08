local BoucleActive = false
local PlateauPosHaut = 3.8
local PlateauPosBas = 8.1
local Rope
local ModelCrochet = `prop_rope_hook_01`
local Crochet
local TowRope
local PreviousLength = 0
local ClosestTow
local MaxLengthRope = 19.0
local VehAttachee = {}
local Notif = {}
local me = PlayerPedId()

RegisterNetEvent('core:VehAttachee')
AddEventHandler('core:VehAttachee', function(list)
    VehAttachee = list
end)

local Key = {
    Plateau_dep = false,
    Plateau_treuil = false
}
RegisterKeyMapping('Plateau_dep', 'Dépanneuse plateau~', 'keyboard', 'j')
RegisterKeyMapping('Plateau_treuil', 'Dépanneuse treuil~', 'keyboard', 'h')

RegisterCommand('Plateau_dep', function()
    Key['Plateau_dep'] = true
end)

RegisterCommand('Plateau_treuil', function()
    Key['Plateau_treuil'] = true
end)

Citizen.CreateThread(function()
    local veh, plateau, vehTow = nil, nil
    local BoucleLent = 1000
    local BoucleRapide = 5
    local TempsBoucle = BoucleRapide
    local MovePlateau = {distance = 4.8,rotation = 13}
    local vitesse = {deplacement = 0.015,rotation = .5}
    local HelpMessage = {}
    
    TriggerServerEvent('core:GetVehAttachee')
    while true do
        HelpMessage = {}
        TempsBoucle = BoucleLent
        if IsPedInAnyVehicle(me,false) then
            DisableControlAction(0,60,true)
            if IsPedInModel(me,`flatbed3`) then
                if GetEntitySpeed(me) < 0.5 then
                    TempsBoucle = BoucleRapide
                    veh = GetVehiclePedIsIn(me,true)
                    pos = GetEntityCoords(veh)
                    local BodyBone = GetWorldPositionOfEntityBone(veh,GetEntityBoneIndexByName(veh,'bodyshell'))
                    local PlateauBone = GetWorldPositionOfEntityBone(veh,GetEntityBoneIndexByName(veh,'misc_a'))
                    local libelle = "remonter le plateau"
                    if Vdist(BodyBone,PlateauBone) < PlateauPosHaut then
                        libelle = "descendre le plateau"
                    end
                    table.insert(HelpMessage,'Pressez ~INPUT_6BBAD9AD~ pour '..libelle )
                    if Key['Plateau_dep'] then
                        if Rope then
                            --TriggerEvent('hud:NotifColor','Vous devez ranger le crochet avant de bouger le plateau',6)  
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                -- duration = 5, -- In seconds, default:  4
                                content = "Vous devez ranger le crochet avant de bouger le plateau"
                            })
                        else
                            if Vdist(BodyBone,PlateauBone) < PlateauPosHaut then
                                --Descendre le plateau
                                while Vdist(BodyBone,PlateauBone) < PlateauPosBas and IsPedInAnyVehicle(me,false) do
                                    SetControlNormal(1,60,-0.3)
                                    BodyBone = GetWorldPositionOfEntityBone(veh,GetEntityBoneIndexByName(veh,'bodyshell'))
                                    PlateauBone = GetWorldPositionOfEntityBone(veh,GetEntityBoneIndexByName(veh,'misc_a'))
                                    Wait(0)
                                end
                                FreezeEntityPosition(veh,true)
                            else
                                --Monter le plateau
                                FreezeEntityPosition(veh,false)
                                while Vdist(BodyBone,PlateauBone) > 3.8 and IsPedInAnyVehicle(me,false) do
                                    SetControlNormal(1,60,0.3)
                                    BodyBone = GetWorldPositionOfEntityBone(veh,GetEntityBoneIndexByName(veh,'bodyshell'))
                                    PlateauBone = GetWorldPositionOfEntityBone(veh,GetEntityBoneIndexByName(veh,'misc_a'))
                                    Wait(0)
                                end
                            end
                        end
                        Key['Plateau_dep'] = false
                    end
                end
            end
        else
            local ClosestVeh = GetClosestVehicleFromPlayer(2.5)
            if ClosestVeh ~= 0 then
                if IsVehicleModel(ClosestVeh,`flatbed3`) then
                    ClosestTow = ClosestVeh
                    local RopePosition = GetWorldPositionOfEntityBone(ClosestTow,GetEntityBoneIndexByName(ClosestTow,'misc_s'))
                    RopePosition = vector3(RopePosition.x,RopePosition.y,RopePosition.z -1.0)
                    CoordPlayer = GetEntityCoords(me)
                    if Vdist(CoordPlayer,RopePosition) <= 1.5 then
                        TempsBoucle = BoucleRapide
                        if Rope and IsEntityAttachedToEntity(Crochet,me) then
                            TempsBoucle = BoucleRapide
                            table.insert(HelpMessage,'Pressez ~INPUT_CONTEXT~ pour ranger le cable')
                            if IsControlJustPressed(1,51) then
                                local BodyBone = GetWorldPositionOfEntityBone(ClosestTow,GetEntityBoneIndexByName(ClosestTow,'bodyshell'))
                                local PlateauBone = GetWorldPositionOfEntityBone(ClosestTow,GetEntityBoneIndexByName(ClosestTow,'misc_a'))
                                if Vdist(BodyBone,PlateauBone) < PlateauPosBas then
                                    FreezeEntityPosition(ClosestTow,false)
                                end
                                TaskPlayAnim(me, "pickup_object", "pickup_low", 8.0, -8.0, -1, 0, 0, false, false, false)
                                Wait(800)
                                RopeUnloadTextures()
                                DeleteRope(Rope)
                                DeleteEntity(Crochet)
                                Rope = nil
                                Crochet = nil
                            end
                        else
                            table.insert(HelpMessage,'Pressez ~INPUT_CONTEXT~ pour prendre le cable')
                            if IsControlJustPressed(1,51) then
                                FreezeEntityPosition(ClosestTow,true)
                                RequestModel(ModelCrochet)
                                while not HasModelLoaded(ModelCrochet) do
                                    Wait(1)
                                end
                                TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
                                while not HasAnimDictLoaded('pickup_object') do
                                    RequestAnimDict('pickup_object')
                                    Wait(0)
                                end
                                TaskPlayAnim(me, "pickup_object", "pickup_low", 8.0, -8.0, -1, 0, 0, false, false, false)
                                Wait(800)
                                Crochet = CreateObject(ModelCrochet, 1.0, 1.0, 1.0, 1, 1, 0)
                                while not DoesEntityExist(Crochet) do
                                    Wait(0)
                                end
                                SetEntityCollision(Crochet,false,true)
                                AttachEntityToEntity(Crochet, me, GetPedBoneIndex(me, 28422), 0.08, 0.0, -0.04, -90.0, 0.0, 180.0, 1, 1, 0, 0, 2, 1)
                                local HandPos =  GetOffsetFromEntityInWorldCoords(Crochet,0.0,0.0,0.13)
                                local OriginRope = GetOriginCableTow(ClosestTow)
                                local length = #(HandPos-OriginRope)
                                if length < 1 then
                                    length = 1.0
                                end
                                RopeLoadTextures()
                                Rope = AddRope(OriginRope.x, OriginRope.y, OriginRope.z, 0.0, 0.0, 0.0, MaxLengthRope, 4, length, 0.05, 1.0, 0, 0, 0, true, 0, 0)
                                AttachEntitiesToRope(Rope, Crochet, ClosestTow, HandPos.x, HandPos.y, HandPos.z, OriginRope.x, OriginRope.y, OriginRope.z, length, false, false,   GetPedBoneIndex(me, 28422),GetEntityBoneIndexByName(ClosestTow,'misc_b'))
                                ActivatePhysics(Rope)
                                SetModelAsNoLongerNeeded(ModelCrochet)
                                Wait(5)
                                StartRopeUnwindingFront(Rope)
                            end
                        end
                    else
                        if NearRoue(ClosestTow) then
                            TempsBoucle = BoucleRapide
                            local BodyBone = GetWorldPositionOfEntityBone(ClosestTow,GetEntityBoneIndexByName(ClosestTow,'bodyshell'))
                            local PlateauBone = GetWorldPositionOfEntityBone(ClosestTow,GetEntityBoneIndexByName(ClosestTow,'misc_a'))
                            if Vdist(BodyBone,PlateauBone) > PlateauPosBas then
                                TempsBoucle = BoucleRapide
                                CoordPlayer = GetEntityCoords(me)
                                local AttachedCar = VehAttachee[NetworkGetNetworkIdFromEntity(ClosestTow)]
                                if AttachedCar ~= nil then
                                    AttachedCar = NetworkGetEntityFromNetworkId(AttachedCar)
                                end
                                local libelle = "décrocher le véhicule"
                                if not DoesEntityExist(AttachedCar) then
                                    AttachedCar = 0
                                    libelle = "accrocher le véhicule"
                                end
                                table.insert(HelpMessage,'Pressez ~INPUT_CONTEXT~ pour '..libelle)
                                if IsControlJustPressed(1,51) then
                                    --Attachage du véhicule
                                    if AttachedCar > 0 then
                                        DetachEntity(AttachedCar,true,true)
                                        --TriggerEvent('hud:NotifColor',"Véhicule décroché",141) 
                                        exports['vNotif']:createNotification({
                                            type = 'VERT',
                                            -- duration = 5, -- In seconds, default:  4
                                            content = "Le véhicule est décroché."
                                        })
                                        TriggerServerEvent('core:DeleteVehAttachee',NetworkGetNetworkIdFromEntity(ClosestTow))
                                        VehAttachee[NetworkGetNetworkIdFromEntity(ClosestTow)] = nil
                                    else
                                        if Crochet then
                                            DeleteRope(Rope)
                                            DeleteEntity(Crochet)
                                            RopeUnloadTextures()
                                            Rope = nil
                                            Crochet = nil
                                        end
                                        --Accroche
                                        local NewCoord = GetOffsetFromEntityInWorldCoords(ClosestTow,0.0,-7.0,1.0)
                                        local TowedCar = GetVehicleInCoord(NewCoord,3.0)
                                        if TowedCar == ClosestTow then
                                            --TriggerEvent('hud:NotifColor','Aucun véhicule sur le plateau',6) 
                                            exports['vNotif']:createNotification({
                                                type = 'JAUNE',
                                                -- duration = 5, -- In seconds, default:  4
                                                content = "Aucun véhicule sur le plateau"
                                            })
                                        else
                                            local CoordsBone = GetWorldPositionOfEntityBone(ClosestTow,GetEntityBoneIndexByName(ClosestTow,'misc_s'))
                                            local Rotation = GetWorldRotationOfEntityBone(ClosestTow,GetEntityBoneIndexByName(ClosestTow,'misc_s'))
                                            local CoordsCar = GetWorldPositionOfEntityBone(TowedCar,GetEntityBoneIndexByName(TowedCar,'bodyshell'))
                                            local hauteur = CoordsBone.z - CoordsCar.z
                                            local Longueur = #(CoordsCar-CoordsBone)
                                            local alpha = math.sin(hauteur/Longueur)
                                            local beta = alpha - math.rad(1.0*Rotation.x)
                                            local z = math.sin(beta)*Longueur + 0.25
                                            local y = math.cos(beta)*Longueur
                                            AttachEntityToEntity(TowedCar, ClosestTow,GetEntityBoneIndexByName(ClosestTow,'misc_s'),0.0, -y,-z, 0, 0, 0, true, false, true, true, 0, true)
                                            --TriggerEvent('hud:NotifColor',"",141)
                                            exports['vNotif']:createNotification({
                                                type = 'VERT',
                                                -- duration = 5, -- In seconds, default:  4
                                                content = "Le véhicule est accroché."
                                            })
                                            TriggerServerEvent('core:AddVehAttachee',NetworkGetNetworkIdFromEntity(ClosestTow),NetworkGetNetworkIdFromEntity(TowedCar))
                                            VehAttachee[NetworkGetNetworkIdFromEntity(ClosestTow)] = NetworkGetNetworkIdFromEntity(TowedCar)
                                        end
                                    end
                                end
                            end
                            if Rope and not IsEntityAttachedToEntity(Crochet,me) then
                                table.insert(HelpMessage,'Maintenez ~INPUT_72A49F59~ pour enrouler le treuil')
                                if Key['Plateau_treuil'] then
                                    local length = RopeGetDistanceBetweenEnds(Rope)
                                    StartRopeWinding(Rope)
                                    RopeForceLength(Rope,length)
                                    --TriggerServerEvent('InteractSound:PlayFromCoord',GetOriginCableTow(ClosestTow),5.0,'treuil_start', 0.3)
                                    Wait(100)
                                    --TriggerServerEvent('InteractSound:PlayFromCoord',GetOriginCableTow(ClosestTow),5.0,'treuil_loop', 0.3)
                                    local StartSound = GetGameTimer()
                                    while IsControlPressed(1,74) do
                                        Wait(0)
                                        if StartSound+1500<GetGameTimer() then
                                            --TriggerServerEvent('InteractSound:PlayFromCoord',GetOriginCableTow(ClosestTow),5.0,'treuil_loop', 0.3)
                                            StartSound = GetGameTimer()
                                        end
                                    end
                                    --TriggerServerEvent('InteractSound:PlayFromCoord',GetOriginCableTow(ClosestTow),5.0,'treuil_end', 0.3)
                                    StopRopeWinding(Rope)
                                    Key['Plateau_treuil'] = false
                                end
                            end
                        end
                    end
                elseif Rope and IsEntityAttachedToEntity(Crochet,me) then
                    table.insert(HelpMessage,'Pressez ~INPUT_CONTEXT~ pour accrocher le crochet au véhicule')
                    if IsControlJustPressed(1,51) then
                        local Dimension = GetModelDimensions(ClosestVeh)
                        TaskPlayAnim(me, "pickup_object", "pickup_low", 8.0, -8.0, -1, 0, 0, false, false, false)
                        Wait(800)
                        local ClosestBone = GetClosestBoneVeh(ClosestVeh)
                        DetachEntity(Crochet)
                        AttachEntityToEntity(Crochet, ClosestVeh, ClosestBone, -0.1, 0.0, -0.05, 90.0, 180.0, 0.0, 1, 1, 0, 0, 2, 1)
                        local OriginRope = GetOriginCableTow(ClosestTow)
                        local CarPos = GetWorldPositionOfEntityBone(ClosestVeh,ClosestBone)
                        local length = #(OriginRope - CarPos)
                        AttachEntitiesToRope(Rope, ClosestVeh, ClosestTow, CarPos.x,CarPos.y,CarPos.z, OriginRope.x, OriginRope.y, OriginRope.z, length, false, false,  ClosestBone,GetEntityBoneIndexByName(ClosestTow,'misc_b'))
                        ActivatePhysics(Rope)
                    end
                end
            end
            if Rope then
                TempsBoucle = BoucleRapide
                if IsEntityAttachedToEntity(Crochet,me) then
                    if RopeGetDistanceBetweenEnds(Rope) > MaxLengthRope + 1.0 then
                        --TriggerEvent('hud:NotifColor','Cable déroulé au maximum',6)
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            -- duration = 5, -- In seconds, default:  4
                            content = "Le treuil est déroulé au maximum."
                        })
                        DetachEntity(Crochet)
                    end
                    table.insert(HelpMessage,'Pressez ~INPUT_72A49F59~ pour lacher le crochet')
                    if Key['Plateau_treuil'] then
                        DetachEntity(Crochet)
                        Key['Plateau_treuil'] = false
                    end
                else
                    if Vdist(GetEntityCoords(Crochet),CoordPlayer) < 2.0 then
                        table.insert(HelpMessage,'Pressez ~INPUT_72A49F59~ pour reprendre le crochet')
                        if Key['Plateau_treuil'] then
                            TaskPlayAnim(me, "pickup_object", "pickup_low", 8.0, -8.0, -1, 0, 0, false, false, false)
                            Wait(800)
                            AttachEntityToEntity(Crochet, me, GetPedBoneIndex(me, 28422), 0.08, 0.0, -0.04, -90.0, 0.0, 180.0, 1, 1, 0, 0, 2, 1)
                            local HandPos = GetOffsetFromEntityInWorldCoords(Crochet,0.0,0.0,0.13)
                            local OriginRope = GetOriginCableTow(ClosestTow)
                            AttachEntitiesToRope(Rope, Crochet, ClosestTow, HandPos.x, HandPos.y, HandPos.z, OriginRope.x, OriginRope.y, OriginRope.z, length, false, false,   GetPedBoneIndex(me, 28422),GetEntityBoneIndexByName(ClosestTow,'misc_b'))
                            Key['Plateau_treuil'] = false
                        end
                    end
                end
            end
        end
        if HelpMessage[1] ~= nil then
            DisplayHelp(HelpMessage)
        end
        Wait(TempsBoucle)
    end
end)

function GetVehicleInCoord(coord,taille)
    local rayHandle = Citizen.InvokeNative(0x28579D1B8F8AAC80,coord.x, coord.y, coord.z -.5, coord.x, coord.y, coord.z +.5, taille, 10, PlayerPedId(), 0)
	local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end

function GetClosestVehicleFromPlayer(distance)
    local coordA = GetEntityCoords(me, 1)
    local coordB = GetOffsetFromEntityInWorldCoords(me, 0.0, distance, 0.0)
	local rayHandle = Citizen.InvokeNative(0x28579D1B8F8AAC80,coordA.x, coordA.y, coordA.z, coordB.x, coordB.y, coordB.z, distance/2, 10, me, 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)

    if(GetEntityType(vehicle) == 2) then
        return vehicle
    else
        return 0
    end
end


function GetClosestBoneVeh(veh)
    listbones = {'neon_f','bumper_f','neon_l','neon_r','neon_b','bumper_r','engine'}
    local dist
    local ClosBone
    CoordPlayer = GetEntityCoords(me)
    for _,bone in pairs (listbones) do
        if GetEntityBoneIndexByName(veh,bone) ~= -1 then
            local Calculdist = Vdist(CoordPlayer,GetWorldPositionOfEntityBone(veh,GetEntityBoneIndexByName(veh,bone)))
            if ClosBone == nil then
                ClosBone = bone
                dist = Calculdist
            else
                if dist > Calculdist then
                    ClosBone = bone
                    dist = Calculdist
                end
            end
        end
    end
    return GetEntityBoneIndexByName(veh,ClosBone)
end

function NearRoue(veh)
    if Vdist(CoordPlayer, GetWorldPositionOfEntityBone(veh,GetEntityBoneIndexByName(veh,'wheel_lr'))) < 2.0 then
        return true
    end
    if Vdist(CoordPlayer, GetWorldPositionOfEntityBone(veh,GetEntityBoneIndexByName(veh,'wheel_rr'))) < 2.0 then
        return true
    end
    return false
end

function GetOriginCableTow(tow)
    local OriginRope = GetWorldPositionOfEntityBone(tow,GetEntityBoneIndexByName(tow,'misc_b'))
    local distance = 0.3
    local heading = GetEntityHeading(tow)
    local rad = math.pi/2+math.rad(heading + 90)
    local OriginRope = vector3(
            OriginRope.x+distance*math.cos(rad),
            OriginRope.y+distance*math.sin(rad),
            OriginRope.z +0.3
        )
    return OriginRope
end

function DisplayHelp(strs)
    local length = 0
    local IsTable = false
    local texte = ""
    if type(strs) == 'table' then
        for i,str in pairs (strs) do
            if i > 1 then
                texte = texte .. "~n~"
            end
            texte = texte .. str
        end
    else
        texte = strs
    end

    length = string.len(texte)
    local Type = "STRING"
    if length <= 90 then
        Type = "STRING"
    elseif length <= 90 * 2 then
        Type = "TWOSTRINGS"
    elseif length <= 90 * 3 then
        Type = "THREESTRINGS"
    else
        return
    end

    BeginTextCommandDisplayHelp(Type)

    local CaracterePrint = 0
    while CaracterePrint < length do
        local fin = 90
        if length - CaracterePrint - fin > 0 then
            while string.sub(texte,CaracterePrint + fin,CaracterePrint + fin) ~= " " do
                fin = fin -1
                if fin < 0 then
                    break
                end
            end
            fin = fin - 1
        end
        AddTextComponentSubstringPlayerName(string.sub(texte,CaracterePrint,CaracterePrint + fin))
        CaracterePrint = CaracterePrint + fin + 2
    end
    EndTextCommandDisplayHelp(0, false, false, 0)
end

RegisterNetEvent('hud:NotifColor')
AddEventHandler('hud:NotifColor', function(txt,color)
    txt=tostring(txt)
	length = string.len(txt)
    local Type = "STRING"
    if length <= 90 then
        Type = "STRING"
    elseif length <= 90 * 2 then
        Type = "THREESTRINGS"
    elseif length <= 90 * 3 then
        Type = "THREESTRINGS"
    end
    SetNotificationTextEntry(Type)
    Citizen.InvokeNative(0x92F0DA1E27DB96DC , color)
    AddTextComponentString(txt)
    local Notification = DrawNotification(false, false)
	table.insert(Notif,Notification)
end)

RegisterNetEvent('InteractSound:PlayFromCoord_CL')
AddEventHandler('InteractSound:PlayFromCoord_CL',function(coord,maxDistance,soundFile,soundVolume)
    local CoordJoueur = GetEntityCoords(PlayerPedId())
    local distance = Vdist(coord.x,coord.y,coord.z,CoordJoueur.x,CoordJoueur.y,CoordJoueur.z)
    if distance < maxDistance then
        local Volume = (1-distance/maxDistance)*soundVolume
        SendNUIMessage({
            transactionType     = 'playSound',
            transactionFile     = soundFile,
            transactionVolume   = Volume
        })
    end
end)