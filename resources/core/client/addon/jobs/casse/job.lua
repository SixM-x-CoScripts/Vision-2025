local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local openRadial = false
local scraping = false
local posCasse = vector3(2347.45, 3122.796, 47.22214)
Casse = {
    Duty = false
}
local function RotationToDirection(rotation)
	local adjustedRotation = 
	{ 
		x = (math.pi / 180) * rotation.x, 
		y = (math.pi / 180) * rotation.y, 
		z = (math.pi / 180) * rotation.z 
	}
	local direction = 
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

local function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    local direction = RotationToDirection(cameraRotation)
    local destination = 
    { 
        x = cameraCoord.x + direction.x * distance, 
        y = cameraCoord.y + direction.y * distance, 
        z = cameraCoord.z + direction.z * distance 
    }
    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, 2, PlayerPedId(), 1))
    return b, c, e
end

RegisterNetEvent("DisableValidVehicleCasse", function(zoneCasseID)
    zone.removeZone("casse_valid_park_"..zoneCasseID)
end)

RegisterNetEvent("NewVehicleCasse", function(netVeh, zoneCasseID)
    local pos = GetEntityCoords(NetworkGetEntityFromNetworkId(netVeh))
    zone.addZone(
        "casse_valid_park_"..zoneCasseID,
        vec3(pos.x, pos.y, pos.z-0.15),
        "Appuyer sur ~INPUT_CONTEXT~ pour prendre en charge ce vehicule",
        function()
            if Casse.Duty then
                NewVehicleCasse(netVeh, zoneCasseID)
                TriggerServerEvent("AcceptVehicleCasse", zoneCasseID)
            end
            zone.removeZone("casse_valid_park_"..zoneCasseID)
        end,
        true,
        25, -- Id / type du marker
        4.0, -- La taille
        { 51, 204, 255 }, -- RGB
        170,-- Alpha
        4.2
    )
end)

function NewVehicleCasse(netVeh, zoneCasseID)
    local vehicleFinished = false
    local veh = NetworkGetEntityFromNetworkId(netVeh)
    local vehPos = GetEntityCoords(veh)
    local _, sizeMax = GetModelDimensions(GetEntityModel(veh))
    local total = 5
    local nFinish = 0
    local wheel = {
        leftFront = {
            finished = false,
            wheelIndex = 0,
            heading = -90,
            pos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "wheel_lf")) 
        },
        leftRear = {
            finished = false, 
            wheelIndex = 2,
            heading = -90,
            pos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "wheel_lr")) 
        },
        rightFront = {
            finished = false, 
            wheelIndex = 1,
            heading = 90,
            pos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "wheel_rf")) 
        },
        rightRear = {
            finished = false, 
            wheelIndex = 3,
            heading = 90,
            pos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "wheel_rr")) 
        },
    }
    local bike = IsThisModelABike(GetEntityModel(veh))
    if bike then
        total = 3
        wheel = {
            leftFront = {
                finished = false,
                wheelIndex = 1,
                heading = -90,
                pos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "wheel_lf")) 
            },
            leftRear = {
                finished = false, 
                wheelIndex = 0,
                heading = -90,
                pos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "wheel_lr")) 
            }
        }
    end
    local engine = {
        finished = false, 
        pos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "engine")) 
    }
    NetworkRequestControlOfEntity(veh)
    while not NetworkHasControlOfEntity(veh) do Wait(1) end
    
    while not vehicleFinished do
        local hit, endCoords, _ = RayCastGamePlayCamera(10.0)

        if nFinish < total-1 then
            for k, v in pairs(wheel) do
                if not v.finished then
                    if hit and (#(endCoords - v.pos) < 0.5) and (#(GetEntityCoords(PlayerPedId()) - v.pos) < 2.0) then
                        DrawMarker(28, v.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4,
                            0.4, 0, 255, 0, 150, 0, 1, 2, 0, nil, nil, 0)

                        ShowHelpNotification("Appuyer sur ~INPUT_CONTEXT~ pour demonter la roue", true)

                        if (not scraping) and IsControlJustPressed(1, 51) then
                            wheel[k].finished = true
                            scraping = true
                            
                            Citizen.CreateThread(function()
                                local dict = "anim@heists@box_carry@"
                                local anim = "idle"
                                local player = PlayerPedId()
                                local pos = GetEntityCoords(player)
                                local model = GetHashKey("prop_wheel_01")
                                
                                local detachDict = 'mp_car_bomb'

                                RequestAnimDict(dict)
                                RequestAnimDict(detachDict)
                                RequestModel(model)
                                while not HasAnimDictLoaded(dict) do Wait(0) end
                                while not HasAnimDictLoaded(detachDict) do Wait(0) end
                                while not HasModelLoaded(model) do Wait(0) end

                                local heading = GetGameplayCamRot().z
                                FreezeEntityPosition(player, true)
                                SetEntityHeading(player, heading)
                                TaskPlayAnimAdvanced(player, detachDict, 'car_bomb_mechanic', GetEntityCoords(player), 0.0, 0.0, heading, 1.0, 0.5, 2500, 1, 0.0, 1, 1)

                                Wait(2500)
                                TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
                                
                                BreakOffVehicleWheel(veh, v.wheelIndex, true, true, true, false)

                                FreezeEntityPosition(player, false)
                                TaskPlayAnim(PlayerPedId(), dict, anim, 2.0, 2.0, -1, 51, 0, false, false
                                , false)
                                local prop = CreateObject(model, pos.x, pos.y, pos.z + 0.2, true, true, true)
                                AttachEntityToEntity(prop, player, GetPedBoneIndex(player, 28422), -0.0050, -0.1870, -0.1400, 0.0, 0.0, 0.0, true, true, false
                                , true, 1, true)

                                SetModelAsNoLongerNeeded(model)
                                RemoveAnimDict(dict)

                                while scraping do
                                    DrawMarker(25, posCasse, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.2, 1.2,
                                        1.2, 255, 255, 255, 150, 0, 1, 2, 0, nil, nil, 0)

                                    local dist = #(posCasse - GetEntityCoords(player))

                                    if (dist <= 1.5) then
                                        ShowHelpNotification("Appuyer sur ~INPUT_CONTEXT~ pour poser la roue", true)
                                        if IsControlJustPressed(1, 51) then
                                            DeleteEntity(prop)
                                            ClearPedSecondaryTask(player)
                                            scraping = false
                                            nFinish = nFinish + 1
                                        end
                                    else
                                        ShowHelpNotification("Va poser la roue à l'arrière de la casse", true)
                                    end
                                    Wait(0)
                                end
                            end)
                        end
                    else
                        DrawMarker(28, v.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4,
                            0.4, 255, 255, 255, 150, 0, 1, 2, 0, nil, nil, 0)
                    end
                end
            end
        elseif not engine.finished then
            if hit and (#(endCoords - engine.pos) < 0.5) and (#(GetEntityCoords(PlayerPedId()) - engine.pos) < 2.0) then
                DrawMarker(28, engine.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4,
                    0.4, 0, 255, 0, 150, 0, 1, 2, 0, nil, nil, 0)

                ShowHelpNotification("Appuyer sur ~INPUT_CONTEXT~ pour demonter le moteur", true)
                
                if IsControlJustPressed(1, 51) then
                    engine.finished = true
                    scraping = true
                    Citizen.CreateThread(function()
                        local dict = "anim@heists@box_carry@"
                        local anim = "idle"
                        local player = PlayerPedId()
                        local pos = GetEntityCoords(player)
                        local model = GetHashKey("prop_car_engine_01")
                        local detachDict = 'mp_car_bomb'
    
                        RequestAnimDict(dict)
                        RequestModel(model)
                        while not HasAnimDictLoaded(dict) do Wait(0) end
                        while not HasModelLoaded(model) do Wait(0) end
    
                        local heading = GetGameplayCamRot().z
                        FreezeEntityPosition(player, true)
                        SetEntityHeading(player, heading)
                        TaskStartScenarioInPlace(player, "PROP_HUMAN_BUM_BIN", 0, true)
                        if not (GetVehicleDoorAngleRatio(veh, 4) > 0) then
                            SetVehicleDoorOpen(veh, 4, false, false)
                        end
    
                        Wait(10000)

                        FreezeEntityPosition(player, false)
                        ClearPedTasksImmediately(player)
                        nFinish = nFinish + 1
                        TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
    
                        TaskPlayAnim(PlayerPedId(), dict, anim, 2.0, 2.0, -1, 51, 0, false, false
                        , false)
                        local prop = CreateObject(model, pos.x, pos.y, pos.z + 0.2, true, true, true)
                        AttachEntityToEntity(prop, player, GetPedBoneIndex(player, 28422), -0.15, -0.2, -0.1400, 0.0, 0.0, -90.0, true, true, false
                        , true, 1, true)
    
                        SetModelAsNoLongerNeeded(model)
                        RemoveAnimDict(dict)
                        Citizen.CreateThread(function()
                            Wait(1000)
                            local aplpha = 255
                            while aplpha > 200 do
                                aplpha = aplpha - 4
                                SetEntityAlpha(veh, aplpha, false)
                                Wait(150)
                            end
                            TriggerServerEvent("DeleteCasseVeh", token, netVeh)
                        end)
    
                        Citizen.CreateThread(function()
                            while scraping do
                                DrawMarker(25, posCasse, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.2, 1.2,
                                    1.2, 255, 255, 255, 150, 0, 1, 2, 0, nil, nil, 0)
        
                                local dist = #(posCasse - GetEntityCoords(player))
        
                                if (dist <= 1.5) then
                                    ShowHelpNotification("Appuyer sur ~INPUT_CONTEXT~ pour poser le moteur", true)
                                    if IsControlJustPressed(1, 51) then
                                        DeleteEntity(prop)
                                        ClearPedSecondaryTask(player)
                                        scraping = false
                                        TriggerServerEvent("endCasseVehicle", token, zoneCasseID, bike)
                                        vehicleFinished = true
                                    end
                                else
                                    ShowHelpNotification("Va poser le moteur à l'arrière de la casse", true)
                                end
                                Wait(0)
                            end
                        end)
                    end)
                end
            else
                DrawMarker(28, engine.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4,
                0.4, 255, 255, 255, 150, 0, 1, 2, 0, nil, nil, 0)
            end
        end
        
        if DoesEntityExist(veh) then
            Modules.UI.Draw3DText(vehPos.x, vehPos.y, vehPos.z + sizeMax.z + 0.25, "Voiture démantelée à ".. math.floor(nFinish/total*100) .."%", 4, 0.06, 0.06)
        end
        Wait(0)
    end
end

function LoadJobCasse()
    if pJob ~= 'casse' then
        return
    end

    zone.addZone(
        "casse_society",
        vector3(2339.2810058594, 3124.9543457031, 47.20874786377),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir la gestion d'entreprise",
        function()
            OpenSocietyMenu() --TODO: fini le menu society
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        1.5,
        true,
        "bulleGestion"
    )
    zone.addZone(
        "casse_coffre",
        vector3(2355.8703613281, 3144.0180664063, 47.208698272705),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le coffre de l'entreprise",
        function()
            OpenInventorySocietyMenu() --TODO: fini le menu society
        end,
        true,
        25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170-- Alpha
    )

    function SetCasseDuty()
        openRadial = false
        closeUI()
        if not Casse.Duty then
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez ~s pris ~c votre service"
            })
            
            TriggerServerEvent('TakeDutyCasse', token)
            TriggerServerEvent('core:DutyOn', pJob)
            Casse.Duty = true
            Wait(5000)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous avez ~s quitté ~c votre service"
            })
            zone.removeZone("casse_valid_park_1")
            zone.removeZone("casse_valid_park_2")

            TriggerServerEvent('core:DutyOff', pJob)
            Casse.Duty = false
            Wait(5000)
        end
    end

    function CreateAdvert()
        if Casse.Duty then
            openRadial = false
            closeUI()
            CreateJobAnnonce()
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end
    
    function OpenRadialCasse()
        if not openRadial then
            openRadial = true
            CreateThread(function()
                while openRadial do
                    Wait(0)
                    DisableControlAction(0, 1, openRadial)
                    DisableControlAction(0, 2, openRadial)
                    DisableControlAction(0, 142, openRadial)
                    DisableControlAction(0, 18, openRadial)
                    DisableControlAction(0, 322, openRadial)
                    DisableControlAction(0, 106, openRadial)
                    DisableControlAction(0, 24, true) -- disable attack
                    DisableControlAction(0, 25, true) -- disable aim
                    DisableControlAction(0, 263, true) -- disable melee
                    DisableControlAction(0, 264, true) -- disable melee
                    DisableControlAction(0, 257, true) -- disable melee
                    DisableControlAction(0, 140, true) -- disable melee
                    DisableControlAction(0, 141, true) -- disable melee
                    DisableControlAction(0, 142, true) -- disable melee
                    DisableControlAction(0, 143, true) -- disable melee
                end
            end)
            SetNuiFocusKeepInput(true)
            SetNuiFocus(true, true)
            Wait(200)
            CreateThread(function()
                SendNuiMessage(json.encode({
                    type = 'openWebview',
                    name = 'RadialMenu',
                    data = { elements = {
                        {
                            name = "ANNONCE",
                            icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/megaphone.svg",
                            action = "CreateAdvert"
                        },
                        {
                            name = "PRISE DE SERVICE",
                            icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/checkmark.svg",
                            action = "SetCasseDuty"
                        }
                    }, title = "CASSE AUTO" }
                }));
            end)
        else
            openRadial = false
            closeUI()
            return
        end
    end

    RegisterJobMenu(OpenRadialCasse)

    RegisterNUICallback("focusOut", function(data, cb)
        if openRadial then
            openRadial = false
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 142, true)
            EnableControlAction(0, 18, true)
            EnableControlAction(0, 322, true)
            EnableControlAction(0, 106, true)
        end
        cb({})
    end)
end

function UnloadCasseJob()
    zone.removeZone("casse_society")
    zone.removeZone("casse_coffre")
end