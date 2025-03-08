local RotationToDirection = function(rotation)
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

local RayCastGamePlayCamera = function(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
	return b, c, e
end

local LiseretColor = { 3, 194, 252 }
local baseX = 0.7
local baseY = 0.05
local baseWidth = 0.15
local baseHeight = 0.03

function renderManagementLegal()
    vAdminManagementLegal.Button(
        "Créer",
        "un point DJ",
        p:getPermission() <= 4,
        "chevron",
        false,
        function()
        end,
        vAdminCreateDJ
    )
    vAdminManagementLegal.Button(
        "Liste",
        "des points DJ",
        p:getPermission() <= 4,
        "chevron",
        false,
        function()
        end,
        vAdminDJSets
    )
    vAdminManagementLegal.Button(
        "Créer",
        "un doorlock",
        p:getPermission() <= 4,
        "chevron",
        false,
        function()
        end,
        vAdminCreateDoorlock
    )
    vAdminManagementLegal.Button(
        "Supprimer",
        "un doorlock",
        p:getPermission() <= 4,
        "chevron",
        false,
        function()
            while true do
                DrawRect(baseX, baseY - 0.017, baseWidth, baseHeight - 0.025, LiseretColor[1], LiseretColor[2], LiseretColor[3], 255)

                DrawRect(baseX, baseY, baseWidth, baseHeight, 28, 28, 28, 170)
                DrawTexts(baseX, baseY - 0.013, "Suppression de Porte", true, 0.35, { 255, 255, 255, 255 }, 6, 0) 

                local _ped = PlayerPedId()
                local _coords = GetEntityCoords(_ped)
                local hit, coords, entity = RayCastGamePlayCamera(500.0)   
                if IsEntityAnObject(entity) then
                    DrawRect(baseX, baseY + (0.016 * 2), baseWidth, baseHeight, 28, 28, 28, 180)
                    DrawTexts(baseX, baseY + (0.016 * 2) - 0.013, "Touche E = Supprimer la porte", true, 0.35, { 255, 255, 255, 255 }, 6, 0) 

                    DrawLine(_coords, coords, 0, 0, 0, 255)
                    if showedEntity ~= entity then
                        SetEntityDrawOutline(showedEntity, false)
                        showedEntity = entity
                    end
                    if IsControlJustPressed(1, 38) then
                        local _doorCoords = GetEntityCoords(entity)
                        local _doorModel = GetEntityModel(entity)
                        local _heading = GetEntityHeading(entity)
                        local _textCoords = coords
                        SetEntityDrawOutline(entity, false)
                        vAdminManagementLegal.close()
                        TriggerServerEvent("core:delete:doorlock", vector4(_doorCoords.x, _doorCoords.y, _doorCoords.z, _heading), _doorModel)
                        break
                    end
                    SetEntityDrawOutline(entity, true)
                else
                    if showedEntity ~= entity then
                        SetEntityDrawOutline(showedEntity, false)
                        showedEntity = entity
                    end
                end
                Wait(5)
            end
        end
    )
    vAdminManagementLegal.Button(
        "Créer",
        "une zone safe",
        p:getPermission() <= 4,
        "chevron",
        false,
        function()
        end,
        vAdminCreateZoneSafe
    )
    vAdminManagementLegal.Button(
        "Liste",
        "des zone safe",
        p:getPermission() <= 4,
        "chevron",
        false,
        function()
        end,
        vAdminZoneSafes
    )
end

-- DJ Sets

local djName = "Aucun"
local jobName = "Aucun"
local crewName = "Aucun"
local distance = 30
local position = nil

vAdminCreateDJ.OnOpen(function()
    vAdminCreateDJ.Separator("NOM", djName, "PORTÉE", distance)
    vAdminCreateDJ.Separator("JOB", jobName, "CREW", crewName)

    vAdminCreateDJ.Button(
        "Nom",
        "du Point DJ",
        nil,
        "chevron",
        false,
        function()
            djName = KeyboardImput("Entrer un nom du point DJ")
            if djName and djName ~= nil and djName ~= "" then
                terName = tostring(djName)
                vAdminCreateDJ.refresh()
            else
                djName = "Aucun"
                vAdminCreateDJ.refresh()
            end
        end
    )

    vAdminCreateDJ.Button(
        "Nom",
        "du Job",
        nil,
        "chevron",
        false,
        function()
            jobName = KeyboardImput("Entrer un nom du job")
            if jobName and jobName ~= nil and jobName ~= "" then
                jobName = tostring(jobName)
                vAdminCreateDJ.refresh()
            else
                jobName = "Aucun"
                vAdminCreateDJ.refresh()
            end
        end
    )

    vAdminCreateDJ.Button(
        "Nom",
        "du Crew",
        nil,
        "chevron",
        false,
        function()
            crewName = KeyboardImput("Entrer un nom du crew")
            if crewName and crewName ~= nil and crewName ~= "" then
                crewName = tostring(crewName)
                vAdminCreateDJ.refresh()
            else 
                crewName = "Aucun"
                vAdminCreateDJ.refresh()
            end
        end
    )

    vAdminCreateDJ.Button(
        "Configurer",
        "la portée",
        nil,
        "chevron",
        false,
        function()
            distance = KeyboardImput("Entrer une distance en mètre")
            if distance and distance ~= nil then
                distance = tonumber(distance)
                vAdminCreateDJ.refresh()
            end
        end
    )

    vAdminCreateDJ.Button(
        "Configurer",
        "l'emplacement",
        nil,
        "chevron",
        false,
        function()
            position = GetEntityCoords(PlayerPedId())
            position = position - vector3(0.0, 0.0, 1.0),
            
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "~c Position configurée"
            })
        end
    )
    
    vAdminCreateDJ.Separator()
    vAdminCreateDJ.Button(
        "Créer",
        "le point DJ",
        nil,
        "chevron",
        false,
        function()
            if djName ~= "Aucun" and djName ~= nil and position ~= nil and distance ~= nil then
                TriggerServerEvent("core:create:dj", djName, position, jobName, crewName, distance)
                Citizen.Wait(200)
                djName = "Aucun"
                jobName = "Aucun"
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "~c Impossible de créer, il manque un titre ou une position"
                })
            end
        end
    )
end)

vAdminDJSets.OnOpen(function()
    for k,v in pairs(DJList) do
        local subtitle = "Publique"
        if v.mixer.jobs then
            subtitle = v.mixer.jobs[1]
        elseif v.mixer.crews then
            subtitle = v.mixer.crews[1]
        end
        
        vAdminDJSets.List(
            k,
            subtitle,
            p:getPermission() <= 4,
            tableDjs,
            IdtblDjs,
            function(index, item)
                if item == "TP" then
                    local coords = vector3(v.mixer.pos.x, v.mixer.pos.y, v.mixer.pos.z)
                    SetEntityCoords(PlayerPedId(), coords)
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        content = "Vous avez été téléporté au point DJ"
                    })
                elseif item == "Supprimer" then
                    local confirmation = ChoiceInput("Êtes vous sur de supprimer ce point DJ ?")
                    if confirmation == true then
                        TriggerServerEvent("core:delete:dj", k)
                        Wait(200)
                        vAdminDJSets.refresh()
                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            content = "Point DJ supprimé avec succès"
                        })
                    end
                end
            end
        )
    end
end)


-- Doorlock

local doorLockStatus = false
local doorJobName = "Aucun"
local doorCrewName = "Aucun"
local doorDistance = 2
local doorPosition = "×"
local doorModel = "×"

vAdminCreateDoorlock.OnOpen(function()
    vAdminCreateDoorlock.Separator("JOB", doorJobName, "CREW", doorCrewName)
    if doorPosition.x ~= nil and doorPosition.y ~= nil and doorPosition.z ~= nil and doorModel ~= nil then
        vAdminCreateDoorlock.Separator("POSITION", doorPosition.x .. " " .. doorPosition.y .. " " .. doorPosition.z, "MODÈLE", doorModel)
    else
        vAdminCreateDoorlock.Separator("POSITION", doorPosition, "MODÈLE", doorModel)
    end

    vAdminCreateDoorlock.Button(
        "Nom",
        "du Job",
        nil,
        "chevron",
        false,
        function()
            doorJobName = KeyboardImput("Entrer un nom du job")
            if doorJobName and doorJobName ~= nil and doorJobName ~= "" then
                doorJobName = tostring(doorJobName)
                vAdminCreateDoorlock.refresh()
            else
                doorJobName = "Aucun"
                vAdminCreateDoorlock.refresh()
            end
        end
    )

    vAdminCreateDoorlock.Button(
        "Nom",
        "du Crew",
        nil,
        "chevron",
        false,
        function()
            doorCrewName = KeyboardImput("Entrer un nom du crew")
            if doorCrewName and doorCrewName ~= nil and doorCrewName ~= "" then
                doorCrewName = tostring(doorCrewName)
                vAdminCreateDoorlock.refresh()
            else 
                doorCrewName = "Aucun"
                vAdminCreateDoorlock.refresh()
            end
        end
    )

    vAdminCreateDoorlock.Checkbox(
        "Porte",
        "vérrouillée",
        false,
        doorLockStatus,
        function(checked)
            doorLockStatus = checked
            print(doorLockStatus)
            if doorLockStatus then
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "~c La porte est désormais fermée par défaut"
                })
            else
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "~c La porte est désormais ouverte par défaut"
                })
            end
        end
    )

    vAdminCreateDoorlock.Button(
        "Configurer",
        "la portée",
        tonumber(doorDistance),
        "chevron",
        false,
        function()
            doorDistance = KeyboardImput("Entrer une distance en mètre")
            if tonumber(doorDistance) >= 7 then
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "~c La distance doit être inférieur à 7 mètres"
                })
                doorDistance = 6
            end
            if doorDistance and doorDistance ~= nil then
                doorDistance = tonumber(doorDistance)
                vAdminCreateDoorlock.refresh()
            end
        end
    )

    vAdminCreateDoorlock.Button(
        "Sélectionner",
        "la porte",
        nil,
        "chevron",
        false,
        function()
            while true do
                DrawRect(baseX, baseY - 0.017, baseWidth, baseHeight - 0.025, LiseretColor[1], LiseretColor[2], LiseretColor[3], 255)

                DrawRect(baseX, baseY, baseWidth, baseHeight, 28, 28, 28, 170)
                DrawTexts(baseX, baseY - 0.013, "Création de porte", true, 0.35, { 255, 255, 255, 255 }, 6, 0)

                local _ped = PlayerPedId()
                local _coords = GetEntityCoords(_ped)
                local hit, coords, entity = RayCastGamePlayCamera(500.0)   
                if IsEntityAnObject(entity) then
                    DrawRect(baseX, baseY + (0.016 * 2), baseWidth, baseHeight, 28, 28, 28, 180)
                    DrawTexts(baseX, baseY + (0.016 * 2) - 0.013, "Touche E = Sélection de la porte", true, 0.35, { 255, 255, 255, 255 }, 6, 0)

                    DrawLine(_coords, coords, 0, 0, 0, 255)
                    if showedEntity ~= entity then
                        SetEntityDrawOutline(showedEntity, false)
                        showedEntity = entity
                    end
                    if IsControlJustPressed(1, 38) then
                        local _doorCoords = GetEntityCoords(entity)
                        local _doorModel = GetEntityModel(entity)
                        local _heading = GetEntityHeading(entity)
                        local _textCoords = coords
                        SetEntityDrawOutline(entity, false)
                        doorPosition = vector4(_doorCoords.x, _doorCoords.y, _doorCoords.z, _heading)
                        doorModel = _doorModel
                        vAdminCreateDoorlock.refresh()
                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            content = "~c Position configurée"
                        })
                        break
                    end
                    SetEntityDrawOutline(entity, true)
                else
                    if showedEntity ~= entity then
                        SetEntityDrawOutline(showedEntity, false)
                        showedEntity = entity
                    end
                end
                Wait(5)
            end
        end
    )
    
    vAdminCreateDoorlock.Separator()
    vAdminCreateDoorlock.Button(
        "Créer",
        "le doorlock",
        nil,
        "chevron",
        false,
        function()
            if doorPosition ~= nil and doorDistance ~= nil and doorModel ~= nil and (doorJobName ~= "Aucun" or doorCrewName ~= "Aucun") then
                TriggerServerEvent("core:create:doorlock", doorPosition, doorJobName, doorCrewName, doorDistance, doorModel, doorLockStatus)
                vAdminCreateDoorlock.close()
                Citizen.Wait(200)
                doorJobName = "Aucun"
                doorCrewName = "Aucun"
                doorDistance = 2
                doorModel = "×"
                doorPosition = "×"
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "~c Impossible de créer, il manque un titre ou une position ou un modèle."
                })
            end
        end
    )
end)

-- Safe Zone

vAdminZoneSafes.OnOpen(function()
    for k,v in pairs(AllSafeZone) do
        vAdminZoneSafes.Button(
            "Supprimer",
            k,
            nil,
            "chevron",
            false,
            function()
                local name = KeyboardImput("Êtes vous sur de supprimer cette zone safe ? (écrivez oui)", "")
                if name and string.lower(name) == "oui" then
                    TriggerServerEvent("core:admin:deleteZoneSafe", k)
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        content = "Zone supprimée avec succès"
                    })
                end
            end
        )
    end
end)

local terName = "Aucun"
local nbPoint = 0
local coords = nil
local showZone = false
local zonePoints = {}

local x1, y1, z1, x2, y2, z2 = nil, nil, nil, nil, nil, nil
local j = 0
vAdminCreateZoneSafe.OnOpen(function()
    vAdminCreateZoneSafe.Separator("      Nom  : "..terName)
    vAdminCreateZoneSafe.Button(
        "Nom",
        "de la zone",
        nil,
        "chevron",
        false,
        function()
            terName = KeyboardImput("Entrer un nom de zone")
            if terName and terName ~= nil then
                terName = tostring(terName)
                vAdminCreateZoneSafe.refresh()
            end
        end
    )


    vAdminCreateZoneSafe.Checkbox(
        "Afficher",
        "la zone",
        false,
        showZone,
        function(checked)
            showZone = checked
            if showZone then
                DrawZoneValue = true
                Citizen.CreateThread(function()
                    while DrawZoneValue do
                        Citizen.Wait(0)
                        for i = 1, #zonePoints do
                            j = i + 1
                            if j > #zonePoints then
                                j = 1
                            end
                    
                            x1, y1, z1 = zonePoints[i].x, zonePoints[i].y, zonePoints[i].z-20.0
                            x2, y2, z2 = zonePoints[j].x, zonePoints[j].y, zonePoints[j].z-20.0
                            DrawWall(x1, y1, z1, x2, y2, z2, 0, 255, 0, 180)
                        end
                    end
                end)
            else
                DrawZoneValue = false
            end
        end
    )

    vAdminCreateZoneSafe.Button(
        "Ajouter",
        "un point",
        nil,
        "chevron",
        false,
        function()
            nbPoint += 1
            coords = GetEntityCoords(PlayerPedId())
            zonePoints[nbPoint] = coords
        end
    )

    vAdminCreateZoneSafe.Button(
        "Supprimer",
        "le dernier point",
        nil,
        "chevron",
        false,
        function()
            zonePoints[nbPoint] = nil
            nbPoint -= 1
            for k,v in pairs(zonePoints) do
                print(k, v)
            end
        end
    )

    
    vAdminCreateZoneSafe.Separator()
    vAdminCreateZoneSafe.Button(
        "Créer",
        "la zone safe",
        nil,
        "chevron",
        false,
        function()
            if terName ~= "Aucun" and #zonePoints >=3 then
                DrawZoneValue = false
                showZone = false
                TriggerServerEvent("core:admin:createZoneSafe", terName, zonePoints)
                Citizen.Wait(200)
                nbPoint = 0
                terName = "Aucun"
                zonePoints = {}
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "~c La zone safe a été créé"
                })
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "~c Impossible de créer, il manque un titre ou des points (minimum 3)"
                })
            end
        end
    )
end)