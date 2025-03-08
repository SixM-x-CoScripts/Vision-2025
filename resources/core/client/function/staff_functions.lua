local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

RegisterCommand("stopload", function()
    RemoveLoadingPrompt()
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
end)

function GotoMarker()
    local wInfo = GetFirstBlipInfoId(8)
    if DoesBlipExist(wInfo) then
        local wPos = GetBlipInfoIdCoord(wInfo)

        local foundGround, zCoords, zPos = false, -500.0, 0.0

        while not foundGround do
            zCoords = zCoords + 10.0
            RequestCollisionAtCoord(wPos.x, wPos.y, zCoords)
            Citizen.Wait(0)
            foundGround, zPos = GetGroundZFor_3dCoord(wPos.x, wPos.y, zCoords)

            if not foundGround and zCoords >= 2000.0 then
                foundGround = true
            end
        end

        SetPedCoordsKeepVehicle(PlayerPedId(), wPos.x, wPos.y, zPos)
    end
end

function AnnonceZone(radius, message, coords)
    if p:getPermission() >= 5 then
        local zoneCoords = coords or p:pos()

        local radius = tonumber(radius) or 100

        if not radius then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "~sRayon invalide !"
            })
            return
        end

        if radius > 750 then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "~sRayon trop grand !"
            })
            return
        end

        if not message or message == "" then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "~sMessage invalide !"
            })
            return
        end

        local players = GetAllPlayersInArea(zoneCoords, radius)

        for _, player in pairs(players) do
            local targetID = GetPlayerServerId(player)
            TriggerServerEvent("core:createvNotifAlert", token, tonumber(targetID), "Annonce Zone", message)
        end

        exports['vNotif']:createNotification({
            type = 'VERT',
            content = "Annonce envoyée à tous les joueurs dans un rayon de ~s" .. radius .. "~c mètres."
        })
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "~sPermission insuffisante !"
        })
    end
end

function TreatZone(radius, coords)
    if p:getPermission() >= 5 then
        local zoneCoords = coords or p:pos()

        local radius = tonumber(radius) or 100

        if not radius then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "~sRayon invalide !"
            })
            return
        end

        if radius > 750 then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "~sRayon trop grand !"
            })
            return
        end

        local countRevive = 0
        local countHeal = 0

        local players = GetAllPlayersInArea(zoneCoords, radius)

        for _, player in pairs(players) do
            local targetID = GetPlayerServerId(player)
            local targetPed = GetPlayerPed(player)

            local health = GetEntityHealth(targetPed)
            local isDead = IsEntityDead(targetPed)
            if isDead then
                TriggerServerEvent("core:RevivePlayer", token, targetID, true)
                TriggerServerEvent("core:createvNotif", token, tonumber(targetID), 'VERT', "La zone a été réanimée par un membre du staff.", 5)
                countRevive = countRevive + 1
            elseif health < 200 then
                TriggerServerEvent("core:HealthPlayer", token, targetID)
                TriggerServerEvent("core:createvNotif", token, tonumber(targetID), 'VERT', "La zone a été soignée par un membre du staff.", 5)
                countHeal = countHeal + 1
            end
        end

        exports['vNotif']:createNotification({
            type = 'VERT',
            content = "Tous les joueurs dans un rayon de ~s" .. radius .. "~c mètres ont été ~srevive~c et ~ssoignés~c."
        })
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            content = "~s" .. countRevive .. "~c joueurs ont été ~srevive~c."
        })
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            content = "~s" .. countHeal .. "~c joueurs ont été ~ssoignés~c."
        })
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "~sPermission insuffisante !"
        })
    end
end

function openPlayerOnAdminMenu(id)
    if p:getPermission() >= 2 then
        if id == nil then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Impossible d'ouvrir le menu du joueur, ID invalide"
            })
            return
        end
        Citizen.CreateThread(function()
            local playerData = TriggerServerCallback("core:GetAllPlayerInfoforMenu", token, tonumber(id))
            while playerData == nil do
                Wait(1)
            end
            if not playerData or playerData == nil then
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Impossible d'ouvrir le menu du joueur, ID invalide"
                })
                return
            end
            Admindata = nil
            Admindata = playerData
            Admindata.id = tonumber(id)
            vAdminPlayer.open()
        end)
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Vous n'avez pas la permission d'ouvrir ce menu"
        })
    end
end

function deleteEntityAdmin(entity)
    if p:getPermission() >= 3 then
        NetworkRequestControlOfEntity(entity)
        SetEntityAsMissionEntity(entity, true, true)
        if IsEntityAVehicle(entity) then
            TriggerServerEvent("police:SetVehicleInFourriere", token, all_trim(GetVehicleNumberPlateText(entity)),
                VehToNet(entity))
            TriggerEvent('persistent-vehicles/forget-vehicle', entity)
        end
        if DoesEntityExist(entity) then
            if IsEntityAnObject(entity) then
                TriggerServerEvent("DeleteEntity", token, { ObjToNet(entity) })
            end
            if IsEntityAVehicle(entity) then                             
                TriggerServerEvent("DeleteEntity", token, { VehToNet(entity) })
            end
            if IsEntityAPed(entity) then                             
                TriggerServerEvent("DeleteEntity", token, { PedToNet(entity) })
            end
        end
        DeleteEntity(entity)
        SetEntityCoordsNoOffset(entity, 90000.0, 0.0, -500.0, 0.0, 0.0, 0.0)
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Vous n'avez pas la permission de supprimer cette entité"
        })
    end
end

function SpawnCar(modelName)
    local model = nil
    if not type(modelName) == "number" then
        model = GetHashKey(modelName)
    else
        model = modelName
    end
    if IsModelInCdimage(model) then
        LoadModel(modelName)
        local pPed = PlayerPedId()
        local vehicle = CreateVehicle(model, GetEntityCoords(pPed), GetEntityHeading(pPed), 1, 0)
        local handle = GetVehiclePedIsIn(PlayerPedId(), false)
        NetworkRequestControlOfEntity(handle)
        SetEntityHealth(handle, 100)
        SetEntityAsMissionEntity(handle, true, true)
        SetEntityAsNoLongerNeeded(handle)
        TriggerEvent('persistent-vehicles/forget-vehicle', handle)
        DeleteEntity(handle)
        SetVehicleModKit(vehicle, 0)
        local random_plate = string.upper(GetRandomNumber(4) .. "" .. GetRandomLetter(4))
        SetVehicleNumberPlateText(vehicle, random_plate)
        SetPedIntoVehicle(playerPed, vehicle, -1)
        SetEntityAsMissionEntity(vehicle, 1, 1)
        TaskWarpPedIntoVehicle(pPed, vehicle, -1)
        SetVehicleEngineOn(vehicle, true, true, false)
        SetVehicleNeedsToBeHotwired(vehicle, false)
        SetVehicleDirtLevel(vehicle, 0.0)
        SetVehicleFuelLevel(vehicle, GetVehicleHandlingFloat(vehicle, "CHandlingData", "fPetrolTankVolume"))
        SetVehicleDoorsLocked(vehicle, 0)
        for i = 1, 9 do
            SetVehicleExtra(vehicle, i, false)
        end
        SetVehicleDoorsLocked(vehicle, 0)
        SetModelAsNoLongerNeeded(modelName)
    else
        -- ShowNotification("Modèle inconnu (" .. modelName .. ")")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Modèle inconnu ( ~c" .. modelName .. "~s )"
        })

    end
end

local NumberCharset = {}
local Charset = {}

for i = 48, 57 do table.insert(NumberCharset, string.char(i)) end

for i = 65, 90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GetRandomLetter(length)
    Citizen.Wait(0)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomLetter(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
    else
        return ''
    end
end

function GetRandomNumber(length)
    Citizen.Wait(0)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomNumber(length - 1) .. Charset[math.random(1, #Charset)]
    else
        return ''
    end
end

local speconmod = false
local targetped = nil
local targetid = nil

local idInstructionalButtons = {
    [1] = generateUniqueID(),
    [2] = generateUniqueID()
}

function ToogleNoClip()
    if inNoClip then
        TriggerServerEvent("core:staffActionLog", token, "Stop noclip", "X", "X")
        local pPed = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)
        local pVeh = GetVehiclePedIsIn(pPed, false)
        
        if IsEntityAttached(pPed) and speconmod then
            local postion = GetEntityCoords(pPed)
            NetworkSetInSpectatorMode(false, targetped)
            SetEntityNoCollisionEntity(pPed, targetped, true)
            DetachEntity(pPed, true, true)
            SetEntityCoords(pPed, postion.x + 0.5, postion.y + 0.5, postion.z + 0.5)
            speconmod, targetped, targetid = false, nil, nil
        end

        inNoClip = false
        SetEnabled(false)

        SetNoClipAttributes(pPed, pVeh, false)
        instructionalButtons[idInstructionalButtons[1]] = {}
        instructionalButtons[idInstructionalButtons[2]] = {}
        local get, z = GetGroundZFor_3dCoord(pCoords.x, pCoords.y, pCoords.z, true, 0)
        if get then
            if pVeh ~= 0 then
                SetEntityCoordsNoOffset(pVeh, pCoords.x, pCoords.y, z + 1.0, 0.0, 0.0, 0.0)
            else
                SetEntityCoordsNoOffset(pPed, pCoords.x, pCoords.y, z + 1.0, 0.0, 0.0, 0.0)
            end
        end
        return
    else
        TriggerServerEvent("core:staffActionLog", token, "Start noclip", "X", "X")
        inNoClip = true
        SetEnabled(true)
        Citizen.CreateThread(function()
            while inNoClip do
                local ped = PlayerPedId()
                CameraLoop()
                SetNoClipAttributes(ped, GetVehiclePedIsIn(ped, false), true)
                Wait(1)
            end
        end)
    end
end

------------------------------------------------------------------------------
------------------------------------------------------------------------------
--------------------------------Noclip----------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------

--noclip


function SetNoClipAttributes(ped, veh, status)
    if status then
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetEntityCollision(ped, false, false)
        SetEntityVisible(ped, false, false)

        if DoesEntityExist(veh) then
            SetEntityInvincible(veh, true)
            FreezeEntityPosition(veh, true)
            SetEntityCollision(veh, false, false)
            SetEntityVisible(veh, false, false)
        end
    else
        SetEntityInvincible(ped, false)
        FreezeEntityPosition(ped, false)
        SetEntityCollision(ped, true, true)
        SetEntityVisible(ped, true, true)

        if DoesEntityExist(veh) then
            SetEntityInvincible(veh, false)
            FreezeEntityPosition(veh, false)
            SetEntityCollision(veh, true, true)
            SetEntityVisible(veh, true, true)
        end
    end
end

local INPUT_SPRINT = 21
local INPUT_CHARACTER_WHEEL = 19
local INPUT_LOOK_LR = 1
local INPUT_LOOK_UD = 2
local INPUT_COVER = 44
local INPUT_MULTIPLAYER_INFO = 20
local INPUT_MOVE_UD = 31
local INPUT_MOVE_LR = 30

--------------------------------------------------------------------------------

_internal_camera = nil
local _internal_isFrozen = false

local _internal_pos = nil
local _internal_rot = nil
local _internal_fov = nil
local _internal_vecX = nil
local _internal_vecY = nil
local _internal_vecZ = nil

--------------------------------------------------------------------------------

local settings = {
    --Camera
    fov = 45.0,
    -- Mouse
    mouseSensitivityX = 5,
    mouseSensitivityY = 5,
    -- Movement
    normalMoveMultiplier = 1,
    fastMoveMultiplier = 10,
    slowMoveMultiplier = 0.1,
    -- On enable/disable
    enableEasing = false,
    easingDuration = 1000
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

local function RayCastGamePlayCamera(distance, ignoreEntity)
    if ignoreEntity == nil then ignoreEntity = -1 end
    local cameraRotation = GetCamRot(_internal_camera, 2)
    local cameraCoord = GetCamCoord(_internal_camera)
    local direction = RotationToDirection(cameraRotation)
    local destination =
    {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x
        , destination.y, destination.z, -1, ignoreEntity, 1))
    return b, c, e
end

local function DrawTexts(x, y, text, center, scale, rgb, font, justify)
    SetTextFont(font)
    SetTextScale(scale, scale)

    SetTextColour(rgb[1], rgb[2], rgb[3], rgb[4])
    SetTextEntry("STRING")
    --SetTextJustification(justify)
    --SetTextRightJustify(justify)
    SetTextCentre(center)
    AddTextComponentString(text)
    EndTextCommandDisplayText(x, y)
end



local showMarker = false
function UpdateEntityLooking()
    local hit, pos, entity = RayCastGamePlayCamera(3000, PlayerPedId())

    if hit then
        local pos = GetEntityCoords(entity)
        local entityType = GetEntityType(entity)

        local LiseretColor = { 3, 194, 252 }
        local baseX = 0.85 -- gauche / droite ( plus grand = droite )
        local baseY = 0.15 -- Hauteur ( Plus petit = plus haut )
        local baseWidth = 0.15 -- Longueur
        local baseHeight = 0.03 -- Epaisseur

        if showMarker then
            DrawMarker(0, pos.xyz, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 50.0, 255, 255, 255, 200, 0, 1, 2, 0, nil, nil, 0)
            DrawRect(baseX, baseY - 0.017, baseWidth, baseHeight - 0.025, LiseretColor[1], LiseretColor[2], LiseretColor[3], 255) -- Liseret
            DrawRect(baseX, baseY, baseWidth, baseHeight, 28, 28, 28, 170) -- Bannière
        end


        if IsControlJustPressed(0, 47) then
            showMarker = not showMarker
        end

        if entityType == 0 then
            instructionalButtons[idInstructionalButtons[2]] = {}
            if showMarker then
                DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~b~Aucune / Non connue", true, 0.35, { 255, 255, 255, 255 }, 6, 0) -- title
            end
        else
            local model = GetEntityModel(entity)
            local entity = entity
            local haveDeleteEntity = false
            local heading = GetEntityHeading(entity)
            local entName = GetEntityArchetypeName(entity) or ""
            local coords = GetEntityCoords(entity)

            if entityType == 1 then
                if IsPedAPlayer(entity) then
                    instructionalButtons[idInstructionalButtons[2]] = {}
                    if showMarker then
                        DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~b~Player", true, 0.35, { 255, 255, 255, 255 }, 6, 0) -- title
                    end
                else
                    if showMarker then
                        DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~b~Ped", true, 0.35, { 255, 255, 255, 255 }, 6, 0) -- title
                    end
                    haveDeleteEntity = true
                end
            elseif entityType == 2 then
                if showMarker then
                    DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~b~Vehicule", true, 0.35, { 255, 255, 255, 255 }, 6, 0) -- title
                end
                haveDeleteEntity = true
            elseif entityType == 3 then
                if showMarker then
                    DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~b~Object", true, 0.35, { 255, 255, 255, 255 }, 6, 0) -- title
                end
                haveDeleteEntity = true
            end

            if haveDeleteEntity then
                instructionalButtons[idInstructionalButtons[2]] = {
                    { control = 73, label = "Supprimer l'entité" },
                    { control = 38, label = "Copier l'entité" }
                }

                if showMarker then
                    DrawRect(baseX, baseY + 0.032, baseWidth, baseHeight, 28, 28, 28, 180)
                    DrawTexts(baseX, baseY + 0.032 - 0.013, "Modele: " .. model .. " ("..entName..")", true, 0.35, { 255, 255, 255, 255 }, 6, 0) -- level
    
                    DrawRect(baseX, baseY + 0.0635, baseWidth, baseHeight, 28, 28, 28, 180)
                    DrawTexts(baseX, baseY + 0.0635 - 0.013, "Heading: " .. heading, true, 0.35, { 255, 255, 255, 255 }, 6, 0) -- level
    
                    DrawRect(baseX, baseY + 0.095, baseWidth, baseHeight, 28, 28, 28, 180)
                    DrawTexts(baseX, baseY + 0.095 - 0.013, "Pos: " .. tostring(coords), true, 0.35, { 255, 255, 255, 255 }, 6, 0) -- level
                end
                
                if IsControlJustReleased(0, 73) then
                    NetworkRequestControlOfEntity(entity)
                    SetEntityAsMissionEntity(entity, true, true)
                    if IsEntityAVehicle(entity) then
                        TriggerServerEvent("police:SetVehicleInFourriere", token, all_trim(GetVehicleNumberPlateText(entity)),
                            VehToNet(entity))
                        TriggerEvent('persistent-vehicles/forget-vehicle', entity)
                    end
                    if DoesEntityExist(entity) then
                        if IsEntityAnObject(entity) then
                            TriggerServerEvent("DeleteEntity", token, { ObjToNet(entity) })
                        end
                        if IsEntityAVehicle(entity) then                             
                            TriggerServerEvent("DeleteEntity", token, { VehToNet(entity) })
                        end
                        if IsEntityAPed(entity) then                             
                            TriggerServerEvent("DeleteEntity", token, { PedToNet(entity) })
                        end
                    end
                    DeleteEntity(entity)
                    SetEntityCoordsNoOffset(entity, 90000.0, 0.0, -500.0, 0.0, 0.0, 0.0)
                end

                if IsControlJustPressed(0, 38) then
                    TriggerEvent("addToCopy", "{hash = " .. model .. ", name = "..entName..", pos = vector4(" .. coords.x .. ", " .. coords.y .. ", " .. coords.z .. ", " .. heading .. ")},")
                end
            end
        end


    end

end

-- Citizen.CreateThread(function()
-- 	while true do

-- 		local entityType = 1
-- 		local entity = 154
-- 		local haveDeleteEntity = false

-- 		local LiseretColor = {3, 194, 252}
-- 		local baseX = 0.85 -- gauche / droite ( plus grand = droite )
-- 		local baseY = 0.15 -- Hauteur ( Plus petit = plus haut )
-- 		local baseWidth = 0.15 -- Longueur
-- 		local baseHeight = 0.03 -- Epaisseur

-- 		DrawRect(baseX, baseY - 0.017, baseWidth, baseHeight - 0.025, LiseretColor[1], LiseretColor[2], LiseretColor[3], 255) -- Liseret
-- 		DrawRect(baseX, baseY, baseWidth, baseHeight, 28, 28, 28, 170) -- Bannière
-- 		if entityType == 0 then
-- 			DrawTexts(baseX, baseY - (0.018) - 0.013, "Type d'entité: ~b~Aucune", true, 0.35, {255, 255, 255, 255}, 6, 0) -- title
-- 		elseif entityType == 1 then
-- 			if IsPedAPlayer(entity) then
-- 				DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~b~Player", true, 0.35, {255, 255, 255, 255}, 6, 0) -- title
-- 			else
-- 				DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~b~Ped", true, 0.35, {255, 255, 255, 255}, 6, 0) -- title
-- 				haveDeleteEntity = true
-- 			end
-- 		elseif entityType == 2 then
-- 			DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~b~Vehicule", true, 0.35, {255, 255, 255, 255}, 6, 0) -- title
-- 			haveDeleteEntity = true
-- 		elseif entityType == 3 then
-- 			DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~b~Object", true, 0.35, {255, 255, 255, 255}, 6, 0) -- title
-- 			haveDeleteEntity = true
-- 		end

-- 		if haveDeleteEntity then
-- 			DrawRect(baseX, baseY + (0.018 * 2), baseWidth, baseHeight, 28, 28, 28, 180)
-- 			DrawTexts(baseX, baseY + (0.018 * 2) - 0.013, "Touche X = Delete entité", true, 0.35, {255, 255, 255, 255}, 6, 0) -- level

-- 			if IsControlJustReleased(0, 73) then
-- 				TriggerServerEvent("DeleteEntity", {NetworkGetNetworkIdFromEntity(entity)})
-- 			end
-- 		end

-- 		Wait(1)
-- 	end
-- end)

--------------------------------------------------------------------------------

local function IsFreecamFrozen()
    return _internal_isFrozen
end

local function SetFreecamFrozen(frozen)
    local frozen = frozen == true
    _internal_isFrozen = frozen
end

--------------------------------------------------------------------------------

local function GetFreecamPosition()
    return _internal_pos
end

local function SetFreecamPosition(x, y, z)
    local pos = vector3(x, y, z)
    SetCamCoord(_internal_camera, pos)

    _internal_pos = pos
end

--------------------------------------------------------------------------------

local function GetFreecamRotation()
    return _internal_rot
end

local function SetFreecamRotation(x, y, z)
    local x = Clamp(x, -90.0, 90.0)
    local y = y % 360
    local z = z % 360
    local rot = vector3(x, y, z)
    local vecX, vecY, vecZ = EulerToMatrix(x, y, z)

    LockMinimapAngle(math.floor(z))
    SetCamRot(_internal_camera, rot)

    _internal_rot = rot
    _internal_vecX = vecX
    _internal_vecY = vecY
    _internal_vecZ = vecZ
end

--------------------------------------------------------------------------------

local function GetFreecamFov()
    return _internal_fov
end

local function SetFreecamFov(fov)
    local fov = Clamp(fov, 0.0, 90.0)
    SetCamFov(_internal_camera, fov)
    _internal_fov = fov
end

--------------------------------------------------------------------------------

local function GetFreecamMatrix()
    return _internal_vecX, _internal_vecY, _internal_vecZ, _internal_pos
end

local function GetFreecamTarget(distance)
    local target = _internal_pos + (_internal_vecY * distance)
    return target
end

--------------------------------------------------------------------------------

local function IsFreecamEnabled()
    return IsCamActive(_internal_camera) == 1
end

local controls = { 12, 13, 14, 15, 16, 17, 18, 19, 50, 85, 96, 97, 99, 115, 180, 181, 198, 261, 262 }
local function LockControls()
    for k, v in pairs(controls) do
        DisableControlAction(0, v, true)
    end
    EnableControlAction(0, 166, true)
end

local function SetFreecamEnabled(enable)
    if enable == IsFreecamEnabled() then
        return
    end

    if enable then
        local pos = GetGameplayCamCoord()
        local rot = GetGameplayCamRot()

        _internal_camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

        SetFreecamFov(settings.fov)
        SetFreecamPosition(pos.x, pos.y, pos.z)
        SetFreecamRotation(rot.x, rot.y, rot.z)
    else
        DestroyCam(_internal_camera)
        ClearFocus()
        UnlockMinimapPosition()
        UnlockMinimapAngle()
    end
    --SetPlayerControl(PlayerId(), not enable)
    RenderScriptCams(enable, settings.enableEasing, settings.easingDuration)
end

--------------------------------------------------------------------------------
function SetEnabled(enable)
    return SetFreecamEnabled(enable)
end

function IsFrozen()
    return IsFreecamFrozen()
end

--------------------------------------------------------------------------------
function GetPlayerServerIdInDirection(range)
    local maxRange = range or 75.0
    local ped = PlayerPedId()
    local playerPos = GetEntityCoords(ped)
    local playerForward = GetEntityForwardVector(ped)

    local closestPlayer = nil
    local minDistance = maxRange

    for _, v in pairs(GetActivePlayers()) do
        local otherPed = GetPlayerPed(v)
        if otherPed ~= ped and IsEntityVisible(otherPed) then
            local otherPedPos = GetEntityCoords(otherPed)
            local distance = #(playerPos - otherPedPos)
            if distance <= maxRange then
                local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(otherPedPos.x, otherPedPos.y, otherPedPos.z)
                if onScreen then
                    local screenDistance = math.sqrt((screenX - 0.5) ^ 2 + (screenY - 0.5) ^ 2)
                    if screenDistance < 0.125 and distance < minDistance then
                        closestPlayer = v
                        minDistance = distance
                    end
                end
            end
        end
    end

    return closestPlayer ~= nil and GetPlayerServerId(closestPlayer) or nil
end

local NoClipSpeedCount = 1.0
local NoClipSpeed = 1.0

function CameraLoop()
    if (not IsFreecamEnabled() and not speconmod) or IsPauseMenuActive() then
        return
    end
    if not IsFreecamFrozen() then
        if not speconmod then
            local vecX, vecY = GetFreecamMatrix()
            local vecZ = vector3(0, 0, 1)
            local pos = GetFreecamPosition()
            local rot = GetFreecamRotation()
            -- Get mouse input
            local mouseX = GetDisabledControlNormal(0, INPUT_LOOK_LR)
            local mouseY = GetDisabledControlNormal(0, INPUT_LOOK_UD)
            -- Calculate new rotation.
            local rotX = rot.x + (-mouseY * settings.mouseSensitivityY)
            local rotZ = rot.z + (-mouseX * settings.mouseSensitivityX)
            local rotY = 0.0

            if #(pos - GetEntityCoords(PlayerPedId())) > 20.0 then
                pos = GetEntityCoords(PlayerPedId())
            end

            if IsControlPressed(1, 241) then
                if NoClipSpeed < 1 then
                    NoClipSpeed = math.min(NoClipSpeed + 0.1, 1)
                elseif NoClipSpeed < 5 then
                    NoClipSpeed = math.min(NoClipSpeed + 0.5, 5)
                elseif NoClipSpeed < 10 then
                    NoClipSpeed = math.min(NoClipSpeed + 0.75, 10)
                elseif NoClipSpeed < 20 then
                    NoClipSpeed = math.min(NoClipSpeed + 1.0, 20)
                else
                    NoClipSpeed = math.min(NoClipSpeed + 1.25, 40)
                end
                NoClipSpeedCount = NoClipSpeed
            end
            
            if IsControlPressed(1, 242) then
                if NoClipSpeed > 20 then
                    NoClipSpeed = math.max(NoClipSpeed - 1.25, 20)
                elseif NoClipSpeed > 10 then
                    NoClipSpeed = math.max(NoClipSpeed - 1.0, 5)
                elseif NoClipSpeed > 5 then
                    NoClipSpeed = math.max(NoClipSpeed - 0.75, 1)
                elseif NoClipSpeed > 1 then
                    NoClipSpeed = math.max(NoClipSpeed - 0.5, 0.5)
                else
                    NoClipSpeed = math.max(NoClipSpeed - 0.1, 0.1)
                end
                NoClipSpeedCount = NoClipSpeed
            end

            if IsControlPressed(1, 132) then
                NoClipSpeed = 0.1
            end

            if IsControlPressed(1, 131) then
                NoClipSpeed = 45.0
            end

            if IsControlJustReleased(1, 132) then
                NoClipSpeed = NoClipSpeedCount
            end

            if IsControlJustReleased(1, 131) then
                NoClipSpeed = NoClipSpeedCount
            end

            if IsControlPressed(1, 44) then
                pos = pos + (vecZ * NoClipSpeed)
            end

            if IsControlPressed(1, 20) then
                pos = pos - (vecZ * NoClipSpeed)
            end

            if IsControlPressed(1, 31) then
                pos = pos - (vecY * NoClipSpeed)
            end

            if IsControlPressed(1, 32) then
                pos = pos + (vecY * NoClipSpeed)
            end

            if IsControlPressed(1, 34) then
                pos = pos - (vecX * NoClipSpeed)
            end

            if IsControlPressed(1, 35) then
                pos = pos + (vecX * NoClipSpeed)
            end

            -- Adjust new rotation
            rot = vector3(rotX, rotY, rotZ)
            -- Update camera

            if vAdmin.isInDevMode and vAdmin.PrintPropsAndEntities then 
                UpdateEntityLooking()
            end 

            if vAdmin.isInDevMode and showMarker then
                instructionalButtons[idInstructionalButtons[1]] = {
                    { control = 25, label = "Ouvrir le profil du joueur" }, 
                    { control = 24, label = "Lock le joueur" },
                    { control = 47, label = "Masquer le marker" }
                }
            elseif vAdmin.isInDevMode then
                instructionalButtons[idInstructionalButtons[1]] = {
                    { control = 25, label = "Ouvrir le profil du joueur" }, 
                    { control = 24, label = "Lock le joueur" },
                    { control = 47, label = "Afficher le marker" }                    
                }
            else
                instructionalButtons[idInstructionalButtons[1]] = {
                    { control = 25, label = "Ouvrir le profil du joueur"},
                    { control = 24, label = "Lock le joueur" }
                }
            end

            SetFreecamPosition(pos.x, pos.y, pos.z)
            SetFreecamRotation(rot.x, rot.y, rot.z)

            LockControls()
            --SetEntityCoordsNoOffset(PlayerPedId(), pos.x, pos.y, pos.z, 0.0, 0.0, 0.0)
            SetPedCoordsKeepVehicle(PlayerPedId(), pos.x, pos.y, pos.z)
            if IsControlJustReleased(0,24) then
                targetid = GetPlayerServerIdInDirection()
                targetped = GetPlayerPed(GetPlayerFromServerId(targetid))
                if targetid ~= nil and targetped ~= PlayerPedId() and targetped ~= nil and IsPedAPlayer(targetped) then
                    NetworkSetInSpectatorMode(true, targetped)
                    AttachEntityToEntity(PlayerPedId(), targetped, 31086, 0.0, 0, 50.0, 0, 0, 0, true, true, false, true, 1, false)
                    SetEnabled(false)
                    speconmod = true
                end
            end  
            if IsControlJustReleased(0,25) then
                targetid = GetPlayerServerIdInDirection()
                if targetid ~= nil then
                    ExecuteCommand("openplayer "..targetid)
                end
            end
        else 
            instructionalButtons[idInstructionalButtons[2]] = {}
            instructionalButtons[idInstructionalButtons[1]] = {
                { control = 24, label = "Unlock le joueur" },
                { control = 38, label = "Ouvrir le profil du joueur" }
            }
            if targetid == nil or targetped == nil or not IsPedAPlayer(targetped) then
                local postion = GetEntityCoords(PlayerPedId())
                NetworkSetInSpectatorMode(false, targetped)
                SetEntityNoCollisionEntity(PlayerPedId(), targetped, true)
                DetachEntity(PlayerPedId(), true, true)
                SetEntityCoords(PlayerPedId(), postion.x + 0.5, postion.y + 0.5, postion.z + 0.5)
                targetped = nil
                targetid = nil
                SetEnabled(true)
                speconmod = false
                return
            end      
            if IsControlJustReleased(0, 38) or IsControlJustReleased(0, 25) then
                ExecuteCommand("openplayer "..targetid)
            end
            if IsControlJustReleased(0, 24) then
                if IsEntityAttached(PlayerPedId()) then
                    local targetPosition = GetEntityCoords(targetped)
                    NetworkSetInSpectatorMode(false, targetped)
                    SetEntityNoCollisionEntity(PlayerPedId(), targetped, true)
                    DetachEntity(PlayerPedId(), true, true)
                    SetEntityCoords(PlayerPedId(), targetPosition.x + 0.5, targetPosition.y + 0.5, targetPosition.z + 0.5)
                    targetped = nil
                    targetid = nil
                    SetEnabled(true)
                    speconmod = false
                end
            end
        end
    end
end

function Clamp(x, min, max)
    return math.min(math.max(x, min), max)
end

function GetDisabledControlNormalBetween(inputGroup, control1, control2)
    local normal1 = GetDisabledControlNormal(inputGroup, control1)
    local normal2 = GetDisabledControlNormal(inputGroup, control2)
    return normal1 - normal2
end

function EulerToMatrix(rotX, rotY, rotZ)
    local radX = math.rad(rotX)
    local radY = math.rad(rotY)
    local radZ = math.rad(rotZ)

    local sinX = math.sin(radX)
    local sinY = math.sin(radY)
    local sinZ = math.sin(radZ)
    local cosX = math.cos(radX)
    local cosY = math.cos(radY)
    local cosZ = math.cos(radZ)

    local vecX = {}
    local vecY = {}
    local vecZ = {}

    vecX.x = cosY * cosZ
    vecX.y = cosY * sinZ
    vecX.z = -sinY

    vecY.x = cosZ * sinX * sinY - cosX * sinZ
    vecY.y = cosX * cosZ - sinX * sinY * sinZ
    vecY.z = cosY * sinX

    vecZ.x = -cosX * cosZ * sinY + sinX * sinZ
    vecZ.y = -cosZ * sinX + cosX * sinY * sinZ
    vecZ.z = cosX * cosY

    vecX = vector3(vecX.x, vecX.y, vecX.z)
    vecY = vector3(vecY.x, vecY.y, vecY.z)
    vecZ = vector3(vecZ.x, vecZ.y, vecZ.z)

    return vecX, vecY, vecZ
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
----------------------------------Fin Noclip------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local displayBlips = false
local blips = {}
function DisplayPlayersBlips()
    if displayBlips then
        displayBlips = false
        for k, v in pairs(blips) do
            RemoveBlip(v)
        end
        blips = {}
    else
        displayBlips = true

        Citizen.CreateThread(function()
            while displayBlips do

                for k, v in pairs(GetActivePlayers()) do
                    local pPed = GetPlayerPed(v)

                    if blips[v] == nil then
                        local blip = AddBlipForEntity(pPed)
                        SetBlipScale(blip, 0.75)
                        SetBlipCategory(blip, 2)
                        blips[v] = blip
                    else
                        local blip = GetBlipFromEntity(pPed)
                        RemoveBlip(blip)
                        RemoveBlip(blips[v])
                        local blip = AddBlipForEntity(pPed)
                        SetBlipScale(blip, 0.75)
                        SetBlipCategory(blip, 2)
                        blips[v] = blip
                    end
                    SetBlipNameToPlayerName(blips[v], v)
                    SetBlipSprite(blips[v], 1)
                    SetBlipRotation(blips[v], math.ceil(GetEntityHeading(pPed)))


                    if IsPedInAnyVehicle(pPed, false) then
                        ShowHeadingIndicatorOnBlip(blips[v], false)
                        local pVeh = GetVehiclePedIsIn(pPed, false)
                        SetBlipRotation(blips[v], math.ceil(GetEntityHeading(pVeh)))


                        if DecorExistOn(pVeh, "esc_siren_enabled") or IsPedInAnyPoliceVehicle(pPed) then
                            --if IsPedInAnyPoliceVehicle(pPed) then
                            SetBlipSprite(blips[v], 56)
                            SetBlipColour(blips[v], 68)
                        else
                            SetBlipSprite(blips[v], 227)
                            SetBlipColour(blips[v], 0)
                        end
                    else
                        ShowHeadingIndicatorOnBlip(blips[v], true)
                        HideNumberOnBlip(blips[v])
                    end

                end
                Wait(500)
            end
        end)
    end
end

RegisterCommand("noclip", function(source, args, rawCommand)
    if p:getPermission() >= 2 then 
        ToogleNoClip()
    end
end, false)