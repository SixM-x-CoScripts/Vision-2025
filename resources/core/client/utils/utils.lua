local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = { handle = iter, destructor = disposeFunc }
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
	return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

function GetVehicles()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

function GetClosestVehicle(coords)
	local vehicles = GetVehicles()
	local closestDistance = -1
	local closestVehicle = -1
	local playerPed = PlayerPedId()
	local coords = coords
	if coords == nil then
		coords = GetEntityCoords(playerPed)
	end

	for k, v in pairs(vehicles) do
		local vehicleCoords = GetEntityCoords(v)
		local distance = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)
		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = v
			closestDistance = distance
		end
	end

	return closestVehicle, closestDistance
end

function GetClosestVehicleOfType(coords, model)
	local vehicles = GetVehicles()
	local closestDistance = -1
	local closestVehicle = -1
	local playerPed = PlayerPedId()
	local coords = coords
	if coords == nil then
		coords = GetEntityCoords(playerPed)
	end

	for k, v in pairs(vehicles) do
		local vehicleCoords = GetEntityCoords(v)
		local distance = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)
		if closestDistance == -1 or closestDistance > distance then
			if GetEntityModel(v) == model then
				closestVehicle  = v
				closestDistance = distance
			end
		end
	end

	return closestVehicle, closestDistance
end


function GetClosestVehicleNoCoords()
	local vehicles = GetVehicles()
	local closestDistance = -1
	local closestVehicle = -1
	local playerPed = PlayerPedId()
	local coords = coords
	if coords == nil then
		coords = GetEntityCoords(playerPed)
	end

	for k, v in pairs(vehicles) do
		local vehicleCoords = GetEntityCoords(v)
		local distance = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)
		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = v
			closestDistance = distance
		end
	end

	return closestVehicle, closestDistance
end

function GetClosestPlayer()
	local pPed = PlayerPedId()
	local players = GetActivePlayers()
	local coords = GetEntityCoords(pPed)
	local pCloset = nil
	local pClosetPos = nil
	local pClosetDst = nil
	for k, v in pairs(players) do
		if GetPlayerPed(v) ~= pPed then
			local oPed = GetPlayerPed(v)
			local oCoords = GetEntityCoords(oPed)
			local dst = GetDistanceBetweenCoords(oCoords, coords, true)
			if pCloset == nil then
				pCloset = v
				pClosetPos = oCoords
				pClosetDst = dst
			else
				if dst < pClosetDst then
					pCloset = v
					pClosetPos = oCoords
					pClosetDst = dst
				end
			end
		end
	end

	return pCloset, pClosetDst
end

function GetAllPlayersIdsInArea(coords, zone)
	local playersInArea = {}
	if zone == nil then
		zone = 150.0
	end
	for k, v in pairs(GetActivePlayers()) do
		local pPed = GetPlayerPed(v)
		local pCoords = GetEntityCoords(pPed)
		if GetDistanceBetweenCoords(pCoords, coords, false) <= zone then
			table.insert(playersInArea, GetPlayerServerId(v))
		end
	end
	return playersInArea
end

function GetAllPlayersInArea(coords, zone)
	local playersInArea = {}
	if zone == nil then
		zone = 150.0
	end
	for k, v in pairs(GetActivePlayers()) do
		local pPed = GetPlayerPed(v)
		local pCoords = GetEntityCoords(pPed)
		if GetDistanceBetweenCoords(pCoords, coords, false) <= zone then
			table.insert(playersInArea, v)
		end
	end
	return playersInArea
end

function GetAllVehicleInArea(coords, zone)
	local playersInArea = {}
	if zone == nil then
		zone = 150.0
	end
	for k, v in pairs(GetVehicles()) do
		local pCoords = GetEntityCoords(v)
		if GetDistanceBetweenCoords(pCoords, coords, false) <= zone then
			table.insert(playersInArea, v)
		end
	end
	return playersInArea
end

function closeUI()
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
end

local inChoice = false
function ChoicePlayersInZone(range, choiceSelfPlayer)
	-- ShowNotification("Appuyer sur ~g~E~s~ pour valider\nAppuyer sur ~b~L~s~ pour changer de cible\nAppuyer sur ~r~X~s~ pour annuler")

	if inChoice then return end
	inChoice = true
	if choiceSelfPlayer == nil then
		choiceSelfPlayer = true
	end
	local timer = GetGameTimer() + 10000
	local selectedPlayer = 1

	local players = GetAllPlayersInArea(p:pos(), range)
	if choiceSelfPlayer == false then
		for k, v in pairs(players) do
			if v == PlayerId() then
				table.remove(players, k)
			end
		end
	end
	if #players == 0 then
		-- New notif
		exports['vNotif']:createNotification({
			type = 'ROUGE',
			-- duration = 5, -- In seconds, default:  4
        	content = "~c Aucun joueur ~s dans la zone"
		})

		inChoice = false
		return nil
	else
		--[[ -- New notif
		exports['vNotif']:createNotification({
			type = 'VERT',
			duration = 10, -- In seconds, default:  4
			content = "Appuyer sur ~K E pour ~s valider"
		})

		exports['vNotif']:createNotification({
			type = 'JAUNE',
			duration = 10, -- In seconds, default:  4
			content = "Appuyer sur ~K L pour ~s changer de cible"
		})

		exports['vNotif']:createNotification({
			type = 'ROUGE',
			duration = 10, -- In seconds, default:  4
			content = "Appuyez sur ~K X pour ~s annuler"
		}) ]]

		exports['aHUD']:toggleHotkeys(true)
	end

	while inChoice do
		local players = GetAllPlayersInArea(p:pos(), range)
		if choiceSelfPlayer == false then
			for k, v in pairs(players) do
				if v == PlayerId() then
					table.remove(players, k)
				end
			end
		end
		if #players == 0 then
			-- ShowNotification("~r~Aucun joueur dans la zone")

			-- New notif
			exports['vNotif']:createNotification({
				type = 'ROUGE',
				-- duration = 5, -- In seconds, default:  4
        		content = "~c Aucun joueur ~s dans la zone"
			})
			exports['aHUD']:toggleHotkeys(false)
			inChoice = false
			return nil
		end
		local mCoors = GetEntityCoords(GetPlayerPed(players[selectedPlayer]))
		DrawMarker(20, mCoors.x, mCoors.y, mCoors.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255 , 120, 0, 1, 2, 0, nil, nil, 0)
		if GetGameTimer() > timer then
			-- ShowNotification("~r~Le délai est dépassé")

			-- New notif
			exports['vNotif']:createNotification({
				type = 'ROUGE',
				-- duration = 5, -- In seconds, default:  4
				content = "Le délai est dépassé"
			})
			exports['aHUD']:toggleHotkeys(false)
			inChoice = false
			return nil
		elseif IsControlJustPressed(0, 51) then -- E
			exports['aHUD']:toggleHotkeys(false)
			inChoice = false
			return players[selectedPlayer]
		elseif IsControlJustPressed(0, 182) then -- L
			timer = GetGameTimer() + 10000
			selectedPlayer = selectedPlayer + 1
		elseif IsControlJustPressed(0, 73) then -- X

			-- ShowNotification("~r~Vous avez annulé")

			-- New notif
			exports['vNotif']:createNotification({
				type = 'JAUNE',
				-- duration = 5, -- In seconds, default:  4
				content = "Vous avez ~s annulé"
			})

			exports['aHUD']:toggleHotkeys(false)
			inChoice = false
			return nil
		elseif selectedPlayer > #players then
			selectedPlayer = 1
		end
		Wait(0)
	end
	inChoice = false
end

function DisplayClosetVeh()
	local pCloset = GetClosestVehicle()
	if pCloset ~= -1 then
		local cCoords = GetEntityCoords(pCloset)
		DrawMarker(20, cCoords.x, cCoords.y, cCoords.z + 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 0, 1
			, 2, 0, nil, nil, 0)
	end
end

function DisplayClosetPlayer()
	local pPed = PlayerPedId()
	local pCoords = GetEntityCoords(pPed)
	local pCloset = GetClosestPlayer()
	if pCloset ~= -1 then
		local cCoords = GetEntityCoords(GetPlayerPed(pCloset))
		DrawMarker(20, cCoords.x, cCoords.y, cCoords.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 0, 1
			, 2, 0, nil, nil, 0)
	end
end

GlobalBlockWeaponsKeys = false

local kbd_input = nil;
function KeyboardImput(text, defaultValue)
	kbd_input = nil
	SendNUIMessage({
		type = 'openWebview',
		name = 'KeyboardInput',
		data = {
			title = text,
			defaultValue = defaultValue,
		}
	})
	while kbd_input == nil do Wait(100) end
	if kbd_input == "KBD_CANCEL" then
		return ""
	end
	return kbd_input
end

RegisterNUICallback('KeyboardInputResponse', function(data, cb)
	if data.value == nil then
		kbd_input = "KBD_CANCEL"
	else
		kbd_input = data.value
	end
	closeUI()
	cb('ok')
end)

local choice_input = nil;
function ChoiceInput(action)
	choice_input = nil
	SetNuiFocus(true)
	SendNUIMessage({
		type = 'openWebview',
		name = 'ChoiceInput',
		data = {
			action = action,
		}
	})
	while choice_input == nil do Wait(100) end
	SetNuiFocus(false)
	return choice_input
end

RegisterNUICallback('ChoiceInputResponse', function(data, cb)
	if data.value == nil then
		choice_input = false
	else
		choice_input = data.value
	end
	closeUI()
	cb('ok')
end)

local wipe_confirm = nil;
function WipeConfirm(id, firstname, lastname)
	wipe_confirm = nil
	SetNuiFocus(true)
	SendNUIMessage({
		type = 'openWebview',
		name = 'WipeConfirm',
		data = {
			id = id,
			firstname = firstname,
			lastname = lastname,
		}
	})
	while wipe_confirm == nil do Wait(100) end
	SetNuiFocus(false)
	return wipe_confirm
end

RegisterNUICallback('WipeConfirmResponse', function(data, cb)
	if data.value == nil then
		wipe_confirm = false
	else
		wipe_confirm = data.value
	end
	closeUI()
	cb('ok')
end)

function DrawText3D(coords, text, size, font)
	coords = vector3(coords.x, coords.y, coords.z)

	local camCoords = GetGameplayCamCoords()
	local distance = #(coords - camCoords)

	if not size then size = 1 end
	if not font then font = 0 end

	local scale = (size / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	scale = scale * fov

	SetTextScale(0.0 * scale, 0.55 * scale)
	SetTextFont(font)
	SetTextColour(255, 255, 255, 210)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	SetDrawOrigin(coords, 0)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.0, 0.0)
	ClearDrawOrigin()
end

function LoadModel(model)
	local models
	if models == model then
		models = model
	else
		models = type(model) == "string" and GetHashKey(model) or model
	end

	if IsModelInCdimage(model) then
		RequestModel(model)
		while not HasModelLoaded(model) do Wait(1) end
	end
	SetModelAsNoLongerNeeded(model)
	return models
end

function LoadModelVehicle(model)
	local models
	if models == model then
		models = model
	else
		models = type(model) == "string" and GetHashKey(model) or model
	end

	if IsModelInCdimage(model) and IsModelAVehicle(model) then
		RequestModel(model)
		local timer = 1
		while not HasModelLoaded(model) and timer < 400 do Wait(1) timer += 1 end
	end
	SetModelAsNoLongerNeeded(model)
	return models
end

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

function RayCastGamePlayCamera(distance)
	local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x,
		destination.y, destination.z, 1, p:ped(), 1))
	return b, c, e
end

function RayCastGamePlayCameraEntity(distance)
	local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x,
		destination.y, destination.z, -1, p:ped(), 0))
	return b, c, e
end

function ShowNotification(text)
	text = text:gsub("^%l", string.upper)
	AddTextEntry('core:notif', text)
	BeginTextCommandThefeedPost('core:notif')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandThefeedPostTicker(true, true)
end

function ShowHelpNotification(msg, beep)
	local beep = beep
	if beep == nil then
		beep = false
	end
	AddTextEntry('core:HelpNotif', msg)
	BeginTextCommandDisplayHelp('core:HelpNotif')
	EndTextCommandDisplayHelp(0, false, false, 1)
end
exports("ShowNotification", function (msg)
	ShowNotification(msg)
end)
exports("ShowHelpNotification", function (msg)
	ShowHelpNotification(msg)
end)
function ShowAdvancedNotification(title, subtitle, msg, img1, img2)
	AddTextEntry('core:AdvancedNotif', msg)
	BeginTextCommandThefeedPost('core:AdvancedNotif')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandThefeedPostMessagetext(img1, img2, 1, 0, title, subtitle)
	EndTextCommandThefeedPostTicker(false, true)
end

function TeleportPlayer(coords)
	local pPed = PlayerPedId()
	local x, y, z = coords.x, coords.y, coords.z or coords.z + 1.0

	RequestCollisionAtCoord(x, y, z)
	NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)

	local sceneLoadTimer = GetGameTimer()
	while not IsNewLoadSceneLoaded() do
		if GetGameTimer() - sceneLoadTimer > 2000 then
			break
		end

		Citizen.Wait(0)
	end

	SetEntityCoordsNoOffset(pPed, x, y, z)
	sceneLoadTimer = GetGameTimer()

	while not HasCollisionLoadedAroundEntity(pPed) do
		if GetGameTimer() - sceneLoadTimer > 2000 then
			break
		end

		Citizen.Wait(0)
	end

	local foundNewZ, newZ = GetGroundZFor_3dCoord(x, y, z, 0, 0)
	if foundNewZ and newZ > 0 then
		z = newZ
	end

	SetEntityCoordsNoOffset(pPed, x, y, z)
	NewLoadSceneStop()

	return true
end

function Round(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10 ^ numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

-- credit http://richard.warburton.it
function GroupDigits(value)
	local left, num, right = string.match(value, '^([^%d]*%d)(%d*)(.-)$')

	return left .. (num:reverse():gsub('(%d%d%d)', '%1' .. _U('locale_digit_grouping_symbol')):reverse()) .. right
end

function Trim(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

function LoadDict(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do Wait(1) end
end

-- Events

RegisterNetEvent("core:ShowNotification")
AddEventHandler("core:ShowNotification", function(text)
	ShowNotification(text)
end)

RegisterNetEvent("core:ShowAdvancedNotification")
AddEventHandler("core:ShowAdvancedNotification", function(title, subtitle, msg, img1, img2)
	ShowAdvancedNotification(title, subtitle, msg, img1, img2)
end)

-- Loops

Citizen.CreateThread(function()
	LoadMpDlcMaps()
	SetInstancePriorityMode(true)
	OnEnterMp()
end)

local islandVec = vector3(4840.571, -5174.425, 2.0)
local isOnIsland = false
Citizen.CreateThread(function()
	while true do
		local pCoords = GetEntityCoords(PlayerPedId())
		local distance1 = #(pCoords - islandVec)
		if distance1 < 2000.0 then
			Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", true) -- load the map and removes the city
			Citizen.InvokeNative("0x5E1460624D194A38", true) -- load the minimap/pause map and removes the city minimap/pause map

			Citizen.InvokeNative(0xF74B1FFA4A15FBEA, true)
			Citizen.InvokeNative(0x53797676AD34A9AA, false)
			SetScenarioGroupEnabled('Heist_Island_Peds', true)

			SetAudioFlag('PlayerOnDLCHeist4Island', true)
			SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', true, true)
			SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', false, true)
			SetZoneEnabled(59, false)
			isOnIsland = true

		else
			--if isOnIsland then
			Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", false)
			Citizen.InvokeNative("0x5E1460624D194A38", false)

			Citizen.InvokeNative(0xF74B1FFA4A15FBEA, false)
			Citizen.InvokeNative(0x53797676AD34A9AA, true)
			SetScenarioGroupEnabled('Heist_Island_Peds', false)

			SetAudioFlag('PlayerOnDLCHeist4Island', false)
			SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', false, false)
			SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', true, false)
			isOnIsland = false
			--end
		end
		Citizen.Wait(1000)
	end
end)

-- CreateThread(function()
-- 	while p == nil do Wait(100) end
-- 	while true do
-- 		Wait(500)
-- 		if p:isInVeh() then
-- 			SetVehicleHandlingFloat(p:currentVeh(), "CHandlingData", "fLowSpeedTractionLossMult", 0.0)
-- 		else
-- 			Wait(1500)
-- 		end
-- 	end
-- end)

function RequestAndWaitDict(dictName)
	if dictName and DoesAnimDictExist(dictName) and not HasAnimDictLoaded(dictName) then
		RequestAnimDict(dictName)
		while not HasAnimDictLoaded(dictName) do Citizen.Wait(100) end
	end
end

function DrawTexts(x, y, text, center, scale, rgb, font)
	SetTextFont(font)
	SetTextScale(scale, scale)

	SetTextColour(rgb[1], rgb[2], rgb[3], rgb[4])
	SetTextEntry("STRING")
	SetTextCentre(center)
	AddTextComponentString(text)
	EndTextCommandDisplayText(x, y)
end

function PlayEmote(dict, anim, flag, duration)
	--[[
		FLAGS
		0 = NORMAL
		1 = REPEAT
		2 = STOP LAST FRAME
		16 = UPPERBODY
		32 = ENABLE PLAYER CONTROL
		120 = CANCELABLE
	]]
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do Wait(1) end
	TaskPlayAnim(PlayerPedId(), dict, anim, 1.0, 1.0, duration, flag or 32, 1.0, 0, 0, 0)
	RemoveAnimDict(dict)
end

function PlayEmoteOnPed(ped, dict, anim, flag, duration)
	--[[
		FLAGS
		0 = NORMAL
		1 = REPEAT
		2 = STOP LAST FRAME
		16 = UPPERBODY
		32 = ENABLE PLAYER CONTROL
		120 = CANCELABLE
	]]
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do Wait(1) end
	TaskPlayAnim(ped, dict, anim, 1.0, 1.0, duration, flag or 32, 1.0, 0, 0, 0)
	RemoveAnimDict(dict)
end

----loadStreamTexture

-- function LoadStreamTexture()
-- 	local Texture = {"4life","ui_market", "ui_concess", "ui_autoecole", "ui_armurerie"}
-- 	Citizen.CreateThread(function()
-- 		for k,v in pairs(Texture) do while not HasStreamedTextureDictLoaded(v)  do Wait(100) RequestStreamedTextureDict(v, true) print(v) end end
-- 	end)
-- end

-- LoadStreamTexture()


-- function isMouseOnButton(position, buttonPos, widthandheight)

-- 	return position.x >= buttonPos.x and position.y >= buttonPos.y and position.x < buttonPos.x + widthandheight.width and position.y < buttonPos.y + widthandheight.height

-- end


function LoadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(0)
	end
end

function SecondsToClock(ms)
	local seconds = math.floor(ms / 1000)
	local mseconds = math.fmod(ms, 1000);

	if seconds <= 0 then
		return "00:00:00";
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600));
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)));
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60));
		local msecs = string.format("%02.f", math.floor(mseconds));
		return mins, secs, msecs
	end
end

-- TriggerEvent("core:printDev", "test")
RegisterNetEvent('core:printDev')
AddEventHandler('core:printDev', function(...)
	printDev(...)
end)

DevPrint = false
function printDev(msg, ...)
	if DevPrint and msg then
		print("[Dev Mode] " .. msg, ...)
	end
end

function addChatSuggestion(perm, cmd, desc, params)
	while not p do Wait(1000) end
	while not GetResourceState("chat") == "started" do Wait(1000) end
	if p:getPermission() > perm then
		TriggerEvent('chat:addSuggestion', '/' .. cmd, desc, params or {})
	else
		TriggerEvent('chat:addSuggestion', '/' .. cmd, "Vous n'avez pas la permission d'utiliser cette commande", {})
	end
end

function CompareMetadatas(t1, t2)
    -- Compare each entry of table t1 with the same entry of table t2
    -- If entry is a table, recursively call this function
    -- If t1 entry is not the same as t2 entry, return false
    -- If tables are not exactly the same, return false

	printDev(json.encode(t1))
	printDev(json.encode(t2))
    if type(t1) ~= "table" or type(t2) ~= "table" then
        return false
    end

    for k,v in pairs(t1) do
        if type(v) == "table" then
            if not CompareMetadatas(v, t2[k]) then
                return false
            end
        else
			if v ~= t2[k] then
				if k == "ammo" then
					return true
				else
					return false
				end
			end
        end
    end
	return true
end

--[[local function getEntityMatrix(element)
    local rot = GetEntityRotation(element) -- ZXY
    local rx, ry, rz = rot.x, rot.y, rot.z
    rx, ry, rz = math.rad(rx), math.rad(ry), math.rad(rz)
    local matrix = {}
    matrix[1] = {}
    matrix[1][1] = math.cos(rz)*math.cos(ry) - math.sin(rz)*math.sin(rx)*math.sin(ry)
    matrix[1][2] = math.cos(ry)*math.sin(rz) + math.cos(rz)*math.sin(rx)*math.sin(ry)
    matrix[1][3] = -math.cos(rx)*math.sin(ry)
    matrix[1][4] = 1

    matrix[2] = {}
    matrix[2][1] = -math.cos(rx)*math.sin(rz)
    matrix[2][2] = math.cos(rz)*math.cos(rx)
    matrix[2][3] = math.sin(rx)
    matrix[2][4] = 1

    matrix[3] = {}
    matrix[3][1] = math.cos(rz)*math.sin(ry) + math.cos(ry)*math.sin(rz)*math.sin(rx)
    matrix[3][2] = math.sin(rz)*math.sin(ry) - math.cos(rz)*math.cos(ry)*math.sin(rx)
    matrix[3][3] = math.cos(rx)*math.cos(ry)
    matrix[3][4] = 1

    matrix[4] = {}
    local pos = GetEntityCoords(element)
    matrix[4][1], matrix[4][2], matrix[4][3] = pos.x, pos.y, pos.z - 1.0
    matrix[4][4] = 1

    return matrix
end

function GetOffsetFromEntityInWorldCoords(entity, offX, offY, offZ)
    local m = getEntityMatrix(entity)
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return vector3(x, y, z)
end
]]
function RealRandom(x, y)
	math.randomseed(GetGameTimer())
	return math.random(x, y)
end

-- @params bool: type string or boolean
-- @return true or false or nil if bool is not good type
function convertStringToBoolean(bool)
	if type(bool) == "boolean" then return bool
	else
		if type(bool) == "string" then
			if bool == "true" then return true
			elseif bool == "false" then return false end
			return nil
		else
			return nil
		end
	end
end

local VehicleBones = {
	"chassis",
	"chassis_lowlod",
	"chassis_dummy",
	"seat_dside_f",
	"seat_dside_r",
	"seat_dside_r1",
	"seat_dside_r2",
	"seat_dside_r3",
	"seat_dside_r4",
	"seat_dside_r5",
	"seat_dside_r6",
	"seat_dside_r7",
	"seat_pside_f",
	"seat_pside_r",
	"seat_pside_r1",
	"seat_pside_r2",
	"seat_pside_r3",
	"seat_pside_r4",
	"seat_pside_r5",
	"seat_pside_r6",
	"seat_pside_r7",
	"window_lf1",
	"window_lf2",
	"window_lf3",
	"window_rf1",
	"window_rf2",
	"window_rf3",
	"window_lr1",
	"window_lr2",
	"window_lr3",
	"window_rr1",
	"window_rr2",
	"window_rr3",
	"door_dside_f",
	"door_dside_r",
	"door_pside_f",
	"door_pside_r",
	"handle_dside_f",
	"handle_dside_r",
	"handle_pside_f",
	"handle_pside_r",
	"wheel_lf",
	"wheel_rf",
	"wheel_lm1",
	"wheel_rm1",
	"wheel_lm2",
	"wheel_rm2",
	"wheel_lm3",
	"wheel_rm3",
	"wheel_lr",
	"wheel_rr",
	"suspension_lf",
	"suspension_rf",
	"suspension_lm",
	"suspension_rm",
	"suspension_lr",
	"suspension_rr",
	"spring_rf",
	"spring_lf",
	"spring_rr",
	"spring_lr",
	"transmission_f",
	"transmission_m",
	"transmission_r",
	"hub_lf",
	"hub_rf",
	"hub_lm1",
	"hub_rm1",
	"hub_lm2",
	"hub_rm2",
	"hub_lm3",
	"hub_rm3",
	"hub_lr",
	"hub_rr",
	"windscreen",
	"windscreen_r",
	"window_lf",
	"window_rf",
	"window_lr",
	"window_rr",
	"window_lm",
	"window_rm",
	"bodyshell",
	"bumper_f",
	"bumper_r",
	"wing_rf",
	"wing_lf",
	"bonnet",
	"boot",
	"exhaust",
	"exhaust_2",
	"exhaust_3",
	"exhaust_4",
	"exhaust_5",
	"exhaust_6",
	"exhaust_7",
	"exhaust_8",
	"exhaust_9",
	"exhaust_10",
	"exhaust_11",
	"exhaust_12",
	"exhaust_13",
	"exhaust_14",
	"exhaust_15",
	"exhaust_16",
	"engine",
	"overheat",
	"overheat_2",
	"petrolcap",
	"petroltank",
	"petroltank_l",
	"petroltank_r",
	"steering",
	"hbgrip_l",
	"hbgrip_r",
	"headlight_l",
	"headlight_r",
	"taillight_l",
	"taillight_r",
	"indicator_lf",
	"indicator_rf",
	"indicator_lr",
	"indicator_rr",
	"brakelight_l",
	"brakelight_r",
	"brakelight_m",
	"reversinglight_l",
	"reversinglight_r",
	"extralight_1",
	"extralight_2",
	"extralight_3",
	"extralight_4",
	"numberplate",
	"interiorlight",
	"siren1",
	"siren2",
	"siren3",
	"siren4",
	"siren5",
	"siren6",
	"siren7",
	"siren8",
	"siren9",
	"siren10",
	"siren11",
	"siren12",
	"siren13",
	"siren14",
	"siren15",
	"siren16",
	"siren17",
	"siren18",
	"siren19",
	"siren20",
	"siren_glass1",
	"siren_glass2",
	"siren_glass3",
	"siren_glass4",
	"siren_glass5",
	"siren_glass6",
	"siren_glass7",
	"siren_glass8",
	"siren_glass9",
	"siren_glass10",
	"siren_glass11",
	"siren_glass12",
	"siren_glass13",
	"siren_glass14",
	"siren_glass15",
	"siren_glass16",
	"siren_glass17",
	"siren_glass18",
	"siren_glass19",
	"siren_glass20",
	"spoiler",
	"struts",
	"misc_a",
	"misc_b",
	"misc_c",
	"misc_d",
	"misc_e",
	"misc_f",
	"misc_g",
	"misc_h",
	"misc_i",
	"misc_j",
	"misc_k",
	"misc_l",
	"misc_m",
	"misc_n",
	"misc_o",
	"misc_p",
	"misc_q",
	"misc_r",
	"misc_s",
	"misc_t",
	"misc_u",
	"misc_v",
	"misc_w",
	"misc_x",
	"misc_y",
	"misc_z",
	"misc_1",
	"misc_2",
	"weapon_1a",
	"weapon_1b",
	"weapon_1c",
	"weapon_1d",
	"weapon_1a_rot",
	"weapon_1b_rot",
	"weapon_1c_rot",
	"weapon_1d_rot",
	"weapon_2a",
	"weapon_2b",
	"weapon_2c",
	"weapon_2d",
	"weapon_2a_rot",
	"weapon_2b_rot",
	"weapon_2c_rot",
	"weapon_2d_rot",
	"weapon_3a",
	"weapon_3b",
	"weapon_3c",
	"weapon_3d",
	"weapon_3a_rot",
	"weapon_3b_rot",
	"weapon_3c_rot",
	"weapon_3d_rot",
	"weapon_4a",
	"weapon_4b",
	"weapon_4c",
	"weapon_4d",
	"weapon_4a_rot",
	"weapon_4b_rot",
	"weapon_4c_rot",
	"weapon_4d_rot",
	"turret_1base",
	"turret_1barrel",
	"turret_2base",
	"turret_2barrel",
	"turret_3base",
	"turret_3barrel",
	"ammobelt",
	"searchlight_base",
	"searchlight_light",
	"attach_female",
	"roof",
	"roof2",
	"soft_1",
	"soft_2",
	"soft_3",
	"soft_4",
	"soft_5",
	"soft_6",
	"soft_7",
	"soft_8",
	"soft_9",
	"soft_10",
	"soft_11",
	"soft_12",
	"soft_13",
	"forks",
	"mast",
	"carriage",
	"fork_l",
	"fork_r",
	"forks_attach",
	"frame_1",
	"frame_2",
	"frame_3",
	"frame_pickup_1",
	"frame_pickup_2",
	"frame_pickup_3",
	"frame_pickup_4",
	"freight_cont",
	"freight_bogey",
	"freightgrain_slidedoor",
	"door_hatch_r",
	"door_hatch_l",
	"tow_arm",
	"tow_mount_a",
	"tow_mount_b",
	"tipper",
	"combine_reel",
	"combine_auger",
	"slipstream_l",
	"slipstream_r",
	"arm_1",
	"arm_2",
	"arm_3",
	"arm_4",
	"scoop",
	"boom",
	"stick",
	"bucket",
	"shovel_2",
	"shovel_3",
	"Lookat_UpprPiston_head",
	"Lookat_LowrPiston_boom",
	"Boom_Driver",
	"cutter_driver",
	"vehicle_blocker",
	"extra_1",
	"extra_2",
	"extra_3",
	"extra_4",
	"extra_5",
	"extra_6",
	"extra_7",
	"extra_8",
	"extra_9",
	"extra_ten",
	"extra_11",
	"extra_12",
	"break_extra_1",
	"break_extra_2",
	"break_extra_3",
	"break_extra_4",
	"break_extra_5",
	"break_extra_6",
	"break_extra_7",
	"break_extra_8",
	"break_extra_9",
	"break_extra_10",
	"mod_col_1",
	"mod_col_2",
	"mod_col_3",
	"mod_col_4",
	"mod_col_5",
	"handlebars",
	"forks_u",
	"forks_l",
	"wheel_f",
	"swingarm",
	"wheel_r",
	"crank",
	"pedal_r",
	"pedal_l",
	"static_prop",
	"moving_prop",
	"static_prop2",
	"moving_prop2",
	"rudder",
	"rudder2",
	"wheel_rf1_dummy",
	"wheel_rf2_dummy",
	"wheel_rf3_dummy",
	"wheel_rb1_dummy",
	"wheel_rb2_dummy",
	"wheel_rb3_dummy",
	"wheel_lf1_dummy",
	"wheel_lf2_dummy",
	"wheel_lf3_dummy",
	"wheel_lb1_dummy",
	"wheel_lb2_dummy",
	"wheel_lb3_dummy",
	"bogie_front",
	"bogie_rear",
	"rotor_main",
	"rotor_rear",
	"rotor_main_2",
	"rotor_rear_2",
	"elevators",
	"tail",
	"outriggers_l",
	"outriggers_r",
	"rope_attach_a",
	"rope_attach_b",
	"prop_1",
	"prop_2",
	"elevator_l",
	"elevator_r",
	"rudder_l",
	"rudder_r",
	"prop_3",
	"prop_4",
	"prop_5",
	"prop_6",
	"prop_7",
	"prop_8",
	"rudder_2",
	"aileron_l",
	"aileron_r",
	"airbrake_l",
	"airbrake_r",
	"wing_l",
	"wing_r",
	"wing_lr",
	"wing_rr",
	"engine_l",
	"engine_r",
	"nozzles_f",
	"nozzles_r",
	"afterburner",
	"wingtip_1",
	"wingtip_2",
	"gear_door_fl",
	"gear_door_fr",
	"gear_door_rl1",
	"gear_door_rr1",
	"gear_door_rl2",
	"gear_door_rr2",
	"gear_door_rml",
	"gear_door_rmr",
	"gear_f",
	"gear_rl",
	"gear_lm1",
	"gear_rr",
	"gear_rm1",
	"gear_rm",
	"prop_left",
	"prop_right",
	"legs",
	"attach_male",
	"draft_animal_attach_lr",
	"draft_animal_attach_rr",
	"draft_animal_attach_lm",
	"draft_animal_attach_rm",
	"draft_animal_attach_lf",
	"draft_animal_attach_rf",
	"wheelcover_l",
	"wheelcover_r",
	"barracks",
	"pontoon_l",
	"pontoon_r",
	"no_ped_col_step_l",
	"no_ped_col_strut_1_l",
	"no_ped_col_strut_2_l",
	"no_ped_col_step_r",
	"no_ped_col_strut_1_r",
	"no_ped_col_strut_2_r",
	"light_cover",
	"emissives",
	"neon_l",
	"neon_r",
	"neon_f",
	"neon_b",
	"dashglow",
	"doorlight_lf",
	"doorlight_rf",
	"doorlight_lr",
	"doorlight_rr",
	"unknown_id",
	"dials",
	"engineblock",
	"bobble_head",
	"bobble_base",
	"bobble_hand",
	"chassis_Control",
}

function ShowVehicleBones(veh)
	while true do
		Wait(1)
		for k,v in pairs(VehicleBones) do
			if GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, v)) and GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, v)) ~= vector3(0.0, 0.0, 0.0) then
				local x,y,z = table.unpack(GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, v)))
				World.DrawText3D(x,y,z, v)
			end
		end
	end
end

CaseBuilderOpen = false
function OpenCaseMenu(dataN)
	if not CaseBuilderOpen then
		SetNuiFocusKeepInput(true)
		SetNuiFocus(true, true)
		CaseBuilderOpen = true
		SendNuiMessage(json.encode({
			type = 'openWebview',
			name = 'RightCaseBuilder',
			data = dataN
		}))
		CreateThread(function()
			while CaseBuilderOpen do
				Wait(1)
				if IsNuiFocused() then
					DisableControlAction(0, 1, true)
					DisableControlAction(0, 2, true)
					DisableControlAction(0, 4, true)
					DisableControlAction(0, 6, true)
					DisableControlAction(0, 24, true)
					DisableControlAction(0, 69, true)
					DisableControlAction(0, 70, true)
					DisableControlAction(0, 141, true)
					DisableControlAction(0, 140, true)
					DisableControlAction(0, 142, true)
					DisableControlAction(0, 257, true)
					DisableControlAction(0, 263, true)
					if IsControlJustPressed(0, 322) then
						closeUI()
						CaseBuilderOpen = false
					end
				else
					EnableAllControlActions(0)
				end
			end
		end)
	else
		closeUI()
		CaseBuilderOpen = false
	end
end

RegisterNUICallback("RCBI", function(data)
	print("RCBI", data)
	if not InsideAnimalerie then
		if data == true then
			SetNuiFocus(false, false)
		else
			SetNuiFocus(true, true)
		end
	else
		if data == false then
			SetNuiFocus(false, false)
		else
			SetNuiFocus(true, true)
		end
	end
end)


--- @return string the vehicle name from the model or the model if the name is not found
RegisterClientCallback('core:getVehicleNameFromModel', function(model)
	local name = GetLabelText(GetDisplayNameFromVehicleModel(model))

	if name == "CARNOTFOUND" then
		return name
	end

	return name
end)

--- @return string The streetname, crossroad of the player
RegisterClientCallback("core:getStreetName", function (pos)
	local x, y, z = table.unpack(pos)

	local streetNameH, crossingRoadH = GetStreetNameAtCoord(x, y, z)
	local streetName = GetStreetNameFromHashKey(streetNameH)
	local crossingRoad = GetStreetNameFromHashKey(crossingRoadH)
	local place = streetName

	if (crossingRoad ~= "") then
		place = streetName .. ", " .. crossingRoad
	end

	return place
end)


OpenTutoFAInfo = function(Title, subtitle)
	exports['tuto-fa']:OpenStepCustom(Title, subtitle)
	SetTimeout(7500, function()
		exports['tuto-fa']:HideStep()
	end)
end

OpenTutoWLInfo = function(Title, subtitle)
	exports['tuto-wl']:OpenStepCustom(Title, subtitle)
	SetTimeout(7500, function()
		exports['tuto-wl']:HideStep()
	end)
end