local token = nil 
TriggerEvent('core:RequestTokenAcces', 'core', function(newToken)
    token = newToken
end)

local premReturn = false
RegisterCommand("deco", function(source, args, raw)
 	exports['vNotif']:createNotification({
 		type = 'ROUGE',
 		content = "La décoration d'intérieur est désactivée temporairement pour des raisons d'optimisation"
 	})
    -- if args[1] == "prem" and p:getPermission() > 0 then premReturn = true end
	-- if p and p:getSubscription() >= 1 then
	-- 	if canOpenDeco then		
    --         OpenCaseMenu({
	-- 			headerName= "Décoration d'intérieur",
	-- 			headerIcon= "https://cdn.sacul.cloud/v2/vision-cdn/deco/info.webp",
	-- 			items= {
	-- 				{
	-- 					icon= "https://cdn.sacul.cloud/v2/vision-cdn/deco/creation.webp",
	-- 					title= "Création",
	-- 					action= "creation",
	-- 				},
	-- 				{
	-- 					icon= "https://cdn.sacul.cloud/v2/vision-cdn/deco/edition.webp",
	-- 					title= "Edition",
	-- 					action= "edition",
	-- 				},
	-- 				{
	-- 					icon= "https://cdn.sacul.cloud/v2/vision-cdn/deco/suppression.webp",
	-- 					title= "Suppression",
	-- 					action= "suppression",
	-- 				},
	-- 			},
	-- 		})
	-- 	else
	-- 		exports['vNotif']:createNotification({
	-- 			type = 'ROUGE',
	-- 			content = "~sVous ne pouvez décorer uniquement dans une propriété vide"
	-- 		})
    --         if premReturn == true then
    --             openCb()
    --             premReturn = false
    --             return
    --         end
	-- 	end
	-- else
	-- 	exports['vNotif']:createNotification({
	-- 		type = 'ROUGE',
	-- 		-- duration = 5, -- In seconds, default:  4
	-- 		content = "~c Vous devez avoir le premium pour pouvoir utiliser la décoration d'interieur"
	-- 	})
	-- end
end)


RegisterNUICallback("RCB", function(data)
    if data.action then 
        --CaseBuilderOpen = false
        if data.action == "creation" then 
            closeUI()
            OpenDecorationMenu(true)
        elseif data.action == "edition" then 
            closeUI()
            OpenEditDeco()
        elseif data.action == "suppression" then 
            closeUI()
            OpenDeleteDeco()
        end
    end
end)

RegisterNUICallback("spawnItemDecoration", function(data)
    if data and IsModelInCdimage(GetHashKey(data)) then
        SpawnDecoration(data)
    end
end)

RegisterNUICallback("deco_delete", function(data)
    OpenDeleteDeco()
end)

function OpenDecoUI()
    -- Open l'ui de gami
    OpenCaseMenu({
        headerName= "Décoration d'intérieur",
        headerIcon= "https://cdn.sacul.cloud/v2/vision-cdn/deco/info.webp",
        items= {
            {
                icon= "https://cdn.sacul.cloud/v2/vision-cdn/deco/creation.webp",
                title= "Création",
                action= "creation",
            },
            {
                icon= "https://cdn.sacul.cloud/v2/vision-cdn/deco/edition.webp",
                title= "Edition",
                action= "edition",
            },
            {
                icon= "https://cdn.sacul.cloud/v2/vision-cdn/deco/suppression.webp",
                title= "Suppression",
                action= "suppression",
            },
        },
    })
end

function HideDecoUI()
    -- Hide l'ui de gami

end

local function DegToRad(degrees)
    return (degrees * 3.14) / 180.0
end

local function ScreenToWorld(screenPosition, maxDistance)
    local pos = GetGameplayCamCoord()
    local rot = GetGameplayCamRot(0)
    local fov = GetGameplayCamFov()
    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, fov, 0, 2)
    local camRight, camForward, camUp, camPos = GetCamMatrix(cam)
    DestroyCam(cam, true)

    local screenPos = vector2(screenPosition.x - 0.5, screenPosition.y - 0.5) * 2.0

    local fovRadians = DegToRad(fov)
    local to = camPos + camForward + (camRight * screenPos.x * fovRadians * 0.95) -
        (camUp * screenPos.y * fovRadians * 0.53)

    local direction = (to - camPos) * maxDistance
    local endPoint = camPos + direction

    local rayHandle = StartShapeTestRay(camPos.x, camPos.y, camPos.z, endPoint.x, endPoint.y, endPoint.z, -1, nil, 0)
    local _, hit, worldPosition, normalDirection, entity = GetShapeTestResult(rayHandle)


    if GetEntityType(entity) == 0 then
        local player, dst = GetClosestPlayer()
        --print(dst)
        if dst ~= nil and dst <= 3.0 then
            entity = GetPlayerPed(player)
        else
            entity = 0
        end
    end

    if (hit == 1) then
        return true, worldPosition, normalDirection, entity
    else
        return false, vector3(0, 0, 0), vector3(0, 0, 0), nil
    end
end

local raycastLength = 20
local SelectedObj = nil
function OpenDeleteDeco()
    HideDecoUI()
    SetCursorLocation(0.5, 0.5)
    while true do 
        Wait(1)
        DisableControlAction(0, 1, true) -- LookLeftRight
        DisableControlAction(0, 2, true) -- LookUpDown
        DisableControlAction(0, 142, true) -- MeleeAttackAlternate
        DisableControlAction(0, 18, true) -- Enter
        DisableControlAction(0, 322, true) -- ESC
        DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
        SetMouseCursorActiveThisFrame()
        SetCursorSprite(1)
        local screenPosition = { x = GetControlNormal(0, 239), y = GetControlNormal(0, 240) }
        local hit, endCoords, normalDir, entityHit = ScreenToWorld(screenPosition, raycastLength)
        for k,v in pairs(Editor.AllObjects) do 
            if entityHit == v.id or entityHit == v.object then 
                if SelectedObj then 
                    ResetEntityAlpha(SelectedObj)
                end
                SetEntityDrawOutline(entityHit, true)
                SetEntityDrawOutlineShader(1)
                if IsDisabledControlJustPressed(0, 142) then 
                    SetEntityDrawOutlineColor(255, 0, 0, 255)
                    SetEntityAlpha(entityHit, 170)
                    SelectedObj = entityHit
                end
                if not SelectedObj then 
                    SetEntityDrawOutlineColor(255, 0, 0, 75)
                else
                    SetEntityDrawOutlineColor(255, 0, 0, 255)
                end
            else
                SetEntityDrawOutline(entityHit, false)
                SetEntityDrawOutlineColor(255, 0, 0, 0)
            end
        end
        if SelectedObj then 
            ShowHelpNotification("~INPUT_CELLPHONE_OPTION~ Supprimer")
            if IsControlJustPressed(0, 178) then 
                DeleteEntity(SelectedObj)
                for k,v in pairs(Editor.AllObjects) do 
                    if SelectedObj == v.id then 
                        table.remove(Editor.AllObjects, k)
                        break
                    end
                end
                SetEntityDrawOutline(entityHit, false)
                SetEntityDrawOutlineColor(255, 0, 0, 0)
                Editor.Object = nil
                break
            end
        end
        if IsControlJustPressed(0, 194) then 
            if SelectedObj then 
                SetEntityDrawOutline(SelectedObj, false)
                ResetEntityAlpha(SelectedObj)
            end
            break
        end
    end
    OpenDecoUI()
end

local BlockCamera = false
local PressedEdit = false
local SelectedObjData = {}
function OpenEditDeco()
    HideDecoUI()
    SetCursorLocation(0.5, 0.5)
    DecoModule.Start()
    while true do 
        Wait(1)
        if BlockCamera then
            DisableControlAction(0, 1, true) -- LookLeftRight
            DisableControlAction(0, 2, true) -- LookUpDown
        end
        DisableControlAction(0, 142, true) -- MeleeAttackAlternate
        DisableControlAction(0, 18, true) -- Enter
        DisableControlAction(0, 45, true)
        DisableControlAction(0, 140, true)
        DisableControlAction(0, 80, true)
        DisableControlAction(0, 322, true) -- ESC
        DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
        if not PressedEdit then
            SetMouseCursorActiveThisFrame()
        end
        if IsControlJustPressed(0, 246) or IsDisabledControlJustPressed(0, 140) then 
            PressedEdit = not PressedEdit
        end
        local screenPosition = { x = GetControlNormal(0, 239), y = GetControlNormal(0, 240) }
        local hit, endCoords, normalDir, entityHit = ScreenToWorld(screenPosition, raycastLength)
        for k,v in pairs(Editor.AllObjects) do 
            if entityHit == v.id or entityHit == v.object then 
                BlockCamera = true
                SetEntityDrawOutline(entityHit, true)
                SetEntityDrawOutlineShader(1)
                SetCursorSprite(3)
                if IsDisabledControlJustPressed(0, 142) then 
                    SetEntityDrawOutlineColor(0, 100, 255, 255)
                    SetEntityAlpha(entityHit, 170)
					DecoModule.Use(entityHit, "wAllah jsp")
                    SelectedObj = entityHit
                    SelectedObjData = v
                end
                if not SelectedObj then 
                    SetEntityDrawOutlineColor(0, 100, 255, 75)
                else
                    SetEntityDrawOutlineColor(0, 100, 255, 255)
                end
            else
                BlockCamera = true
                SetCursorSprite(1)
                SetEntityDrawOutline(entityHit, false)
                SetEntityDrawOutlineColor(0, 100, 255, 0)
            end
        end
        if SelectedObj then 
            ShowHelpNotification("~INPUT_FRONTEND_RRIGHT~ Mode Editeur\n\n~INPUT_MP_TEXT_CHAT_TEAM~ Position\n~INPUT_RELOAD~ Rotation\n~INPUT_FRONTEND_RDOWN~ Valider\n\n~INPUT_DETONATE~ Bloquer la caméra")	
            if IsControlJustPressed(0, 47) or IsDisabledControlJustPressed(0, 47) then 
                BlockCamera = not BlockCamera
            end            
            if IsControlJustPressed(0, 191) then  -- SAUVEGARDE
                if next(SelectedObjData) then 
                    for k,v in pairs(Editor.AllObjects) do 
                        if v.id == SelectedObjData.id and v.prop == SelectedObjData.prop then 
                            v.coords = GetEntityCoords(SelectedObj)
                            v.heading = GetEntityHeading(SelectedObj)
                            break
                        end
                    end
                end
                TriggerServerEvent('core:updateDecorationProperty', token, Editor.AllObjects, propertyIdDeco)
                OpenDecoUI()	
                if SelectedObj then 
                    DecoModule.Cancel()
                    SetEntityDrawOutline(SelectedObj, false)
                    ResetEntityAlpha(SelectedObj)
                    BlockCamera = false
                    PressedEdit = false
                end
                break
            end
        end
        if IsControlJustPressed(0, 194) then 
            if SelectedObj then 
                DecoModule.Cancel()
                SetEntityDrawOutline(SelectedObj, false)
                ResetEntityAlpha(SelectedObj)
                BlockCamera = false
                PressedEdit = false
            end
            break
        end
    end
end

RegisterNUICallback("focusOut", function(data)
    if premReturn == true then
        openCb()
        premReturn = false
        return
    end
end)