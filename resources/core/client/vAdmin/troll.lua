function RoundNumberAucasou(n)
	n = n + 0.00000
	return n
end
InsideOrbitalCannon,oc_manual,oc_automatic,oc_surveillance = false,false,false,true
local oc_speed = RoundNumberAucasou(8)
local oc_pos = vector3(0,0,0)
local cam = nil
local oc_height = RoundNumberAucasou(1000)
local oc_target = nil
local oc_countdown = false
local oc_countdown_text = 3

local function DrawTextXY(text, settings)
	if settings == nil then
		settings = {}
	end
	if settings.rgba == nil then
		settings.rgba = {255,255,255,255}
	end
	SetTextFont(settings.font or 4)
	SetTextProportional(0)
	SetTextScale(settings.scale or 0.4, settings.scale or 0.4)
	if settings.right then
		SetTextRightJustify(1)
		SetTextWrap(0.0,settings.x or 0.5)
	end
	SetTextColour(settings.rgba[1] or 255, settings.rgba[2] or 255, settings.rgba[3] or 255, settings.rgba[4] or 255)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(settings.centre or 0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(settings.x or 0.5 , settings.y or 0.5)	
end

local function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function FireOrbitalCannon(lock,var)
	if lock then
		Citizen.CreateThread(function()
			oc_countdown = true
			oc_countdown_text = 3
			Citizen.Wait(1000)
			oc_countdown_text = 2
			Citizen.Wait(1000)
			oc_countdown_text = 1
			Citizen.Wait(1000)
			oc_countdown = false
			local ped = var
			local pos = GetEntityCoords(ped)
			local heading = GetEntityHeading(ped)
			if not HasWeaponAssetLoaded(GetHashKey("WEAPON_VEHICLE_ROCKET")) then
				RequestWeaponAsset(GetHashKey("WEAPON_VEHICLE_ROCKET"), 31, 0)
				while not HasWeaponAssetLoaded(GetHashKey("WEAPON_VEHICLE_ROCKET")) do
					Citizen.Wait(0)
				end
			end
			
			local offset = GetObjectOffsetFromCoords(pos.x,pos.y,pos.z,heading,0,0,0)
			RequestCollisionAtCoord(offset)
			offset = GetObjectOffsetFromCoords(pos.x,pos.y,pos.z,heading,0,0,0)
			ShootSingleBulletBetweenCoords(offset+vector3(0,0,5), offset, 5000, 0, GetHashKey("WEAPON_VEHICLE_ROCKET"), PlayerPedId(), 1, 0, RoundNumberAucasou(9000))
			offset = GetObjectOffsetFromCoords(pos.x,pos.y,pos.z,heading,RoundNumberAucasou(-3),0,0)
			ShootSingleBulletBetweenCoords(offset+vector3(0,0,5), offset, 5000, 0, GetHashKey("WEAPON_VEHICLE_ROCKET"), PlayerPedId(), 1, 0, RoundNumberAucasou(9000))
			offset = GetObjectOffsetFromCoords(pos.x,pos.y,pos.z,heading,RoundNumberAucasou(3),0,0)
			ShootSingleBulletBetweenCoords(offset+vector3(0,0,5), offset, 5000, 0, GetHashKey("WEAPON_VEHICLE_ROCKET"), PlayerPedId(), 1, 0, RoundNumberAucasou(9000))
			offset = GetObjectOffsetFromCoords(pos.x,pos.y,pos.z,heading,0,RoundNumberAucasou(-3),0)
			ShootSingleBulletBetweenCoords(offset+vector3(0,0,5), offset, 5000, 0, GetHashKey("WEAPON_VEHICLE_ROCKET"), PlayerPedId(), 1, 0, RoundNumberAucasou(9000))
			offset = GetObjectOffsetFromCoords(pos.x,pos.y,pos.z,heading,0,RoundNumberAucasou(3),0)
			ShootSingleBulletBetweenCoords(offset+vector3(0,0,5), offset, 5000, 0, GetHashKey("WEAPON_VEHICLE_ROCKET"), PlayerPedId(), 1, 0, RoundNumberAucasou(9000))
			Citizen.Wait(1000)
		end)
	else
		Citizen.CreateThread(function()
			oc_countdown = true
			oc_countdown_text = 3
			Citizen.Wait(1000)
			oc_countdown_text = 2
			Citizen.Wait(1000)
			oc_countdown_text = 1
			Citizen.Wait(1000)
			oc_countdown = false
			local pos = oc_pos
			local heading = 0
			SetFocusArea(pos, 0, 0, 0)
			if not HasWeaponAssetLoaded(GetHashKey("WEAPON_VEHICLE_ROCKET")) then
				RequestWeaponAsset(GetHashKey("WEAPON_VEHICLE_ROCKET"), 31, 0)
				while not HasWeaponAssetLoaded(GetHashKey("WEAPON_VEHICLE_ROCKET")) do
					Citizen.Wait(0)
				end
			end
			local offset = GetObjectOffsetFromCoords(pos.x,pos.y,pos.z,heading,0,0,0)
			RequestCollisionAtCoord(offset)
			offset = GetObjectOffsetFromCoords(pos.x,pos.y,pos.z,heading,0,0,0)
			ShootSingleBulletBetweenCoords(offset+vector3(0,0,5), offset, 5000, 0, GetHashKey("WEAPON_VEHICLE_ROCKET"), PlayerPedId(), 1, 0, RoundNumberAucasou(9000))
			offset = GetObjectOffsetFromCoords(pos.x,pos.y,pos.z,heading,RoundNumberAucasou(-3),0,0)
			ShootSingleBulletBetweenCoords(offset+vector3(0,0,5), offset, 5000, 0, GetHashKey("WEAPON_VEHICLE_ROCKET"), PlayerPedId(), 1, 0, RoundNumberAucasou(9000))
			offset = GetObjectOffsetFromCoords(pos.x,pos.y,pos.z,heading,RoundNumberAucasou(3),0,0)
			ShootSingleBulletBetweenCoords(offset+vector3(0,0,5), offset, 5000, 0, GetHashKey("WEAPON_VEHICLE_ROCKET"), PlayerPedId(), 1, 0, RoundNumberAucasou(9000))
			offset = GetObjectOffsetFromCoords(pos.x,pos.y,pos.z,heading,0,RoundNumberAucasou(-3),0)
			ShootSingleBulletBetweenCoords(offset+vector3(0,0,5), offset, 5000, 0, GetHashKey("WEAPON_VEHICLE_ROCKET"), PlayerPedId(), 1, 0, RoundNumberAucasou(9000))
			offset = GetObjectOffsetFromCoords(pos.x,pos.y,pos.z,heading,0,RoundNumberAucasou(3),0)
			ShootSingleBulletBetweenCoords(offset+vector3(0,0,5), offset, 5000, 0, GetHashKey("WEAPON_VEHICLE_ROCKET"), PlayerPedId(), 1, 0, RoundNumberAucasou(9000))
		end)
	end
end



local instrucOC = {
    [1] = generateUniqueID(),
    [2] = generateUniqueID()
}

function StartOrbital()
    local rx,ry,rz = 0,0,0
    instructionalButtons[instrucOC[1]] = {
        { control = 202, label = "Retour" },
        { control = 15, label = "Zoom" },
        { control = 16, label = "Zoom" },
        --{ control = 201, label = "Tirer" },
    }
    InsideOrbitalCannon = true
    local antispam = false
    forceHideRadar()
	while true do
		Citizen.Wait(0)
		--if EisPressed == true then
			--if PlayerData.job ~= nil and PlayerData.job.name == 'militar' then
			if InsideOrbitalCannon then
				--OCmenu:Open()
                if not antispam then
                    antispam = true
                    local ped = PlayerPedId()
                    local pos = GetEntityCoords(ped)
                    FreezeEntityPosition(ped, true)
                    SetEntityCollision(ped, false, 0)
                    SetEntityInvincible(ped, true)
                    SetPedDiesInWater(ped, 0)
                    if not DoesCamExist(cam) then
                        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA",false)
                        SetCamCoord(cam,vector3(pos.x,pos.y,oc_height))
                        SetCamRot(cam,-RoundNumberAucasou(90),RoundNumberAucasou(0),RoundNumberAucasou(0),2)
                        SetCamActive(cam,true)
                        StopCamPointing(cam)
                        RenderScriptCams(true,true,0,0,0,0)
                    else
                        --SetCamCoord(cam,vector3(pos.x,pos.y,oc_height))
                        SetCamRot(cam,-RoundNumberAucasou(90),RoundNumberAucasou(0),RoundNumberAucasou(0),2)
                        SetCamActive(cam,true)
                        StopCamPointing(cam)
                        RenderScriptCams(true,true,0,0,0,0)
                    end
                    --oc_manual = false
                    --oc_automatic = false
                    forceHideRadar()
                    StartScreenEffect("DeathFailNeutralIn",0,true)
                end
			else
				StopScreenEffect("DeathFailNeutralIn")
				--OCmenu:Close()
				local ped = PlayerPedId()
				FreezeEntityPosition(ped, false)
				SetEntityCollision(ped, true, 1)
				SetEntityInvincible(ped, false)
				SetPedDiesInWater(ped, 1)
				SetCamActive(cam,false)
				StopCamPointing(cam)
				RenderScriptCams(0,0,0,0,0,0)
				openRadarProperly()
				SetFocusEntity(ped)
			end
		--end
		if InsideOrbitalCannon then
			if IsEntityDead(PlayerPedId()) then
				StopScreenEffect("DeathFailNeutralIn")
				--OCmenu:Close()
				local ped = PlayerPedId()
				FreezeEntityPosition(ped, false)
				SetEntityCollision(ped, true, 1)
				SetEntityInvincible(ped, false)
				SetPedDiesInWater(ped, 1)
				SetCamActive(cam,false)
				StopCamPointing(cam)
				RenderScriptCams(0,0,0,0,0,0)
				openRadarProperly()
				SetFocusEntity(ped)
                break
			end
			DisableControlAction(2, 26, true)
			DisableControlAction(2, 16, true)
			DisableControlAction(2, 17, true)
			if not HasStreamedTextureDictLoaded("helicopterhud") then
				RequestStreamedTextureDict("helicopterhud")
				while not HasStreamedTextureDictLoaded("helicopterhud") do
					Citizen.Wait(0)
                    print("lod")
				end
			end
			if not HasStreamedTextureDictLoaded("securitycam") then
				RequestStreamedTextureDict("securitycam")
				while not HasStreamedTextureDictLoaded("securitycam") do
					Citizen.Wait(0)
                    print("lod2")
				end
			end
			if not HasStreamedTextureDictLoaded("crosstheline") then
				RequestStreamedTextureDict("crosstheline")
				while not HasStreamedTextureDictLoaded("crosstheline") do
					Citizen.Wait(0)
                    print("lod3")
				end
			end
            if oc_countdown then
                DrawTextXY('~r~TIR DANS',{ centre= 1,x = 0.5, y = 0.3, scale = 0.85})
                DrawTextXY('~r~'..oc_countdown_text,{ centre= 1,x = 0.5, y = 0.36, scale = 0.85})
            end
            if oc_automatic or oc_manual or oc_surveillance then
                DrawSprite("helicopterhud", "hud_corner", RoundNumberAucasou(0.1), RoundNumberAucasou(0.1), RoundNumberAucasou(0.015), RoundNumberAucasou(0.02), RoundNumberAucasou(0.0), 255, 255, 255, 255)
                DrawSprite("helicopterhud", "hud_corner", RoundNumberAucasou(0.9), RoundNumberAucasou(0.1), RoundNumberAucasou(0.015), RoundNumberAucasou(0.02), RoundNumberAucasou(90), 255, 255, 255, 255)
                DrawSprite("helicopterhud", "hud_corner", RoundNumberAucasou(0.1), RoundNumberAucasou(0.9), RoundNumberAucasou(0.015), RoundNumberAucasou(0.02), RoundNumberAucasou(270), 255, 255, 255, 255)
                DrawSprite("helicopterhud", "hud_corner", RoundNumberAucasou(0.9), RoundNumberAucasou(0.9), RoundNumberAucasou(0.015), RoundNumberAucasou(0.02), RoundNumberAucasou(180), 255, 255, 255, 255)
                DrawSprite("crosstheline", "timer_largecross_32", RoundNumberAucasou(0.5), RoundNumberAucasou(0.5), RoundNumberAucasou(0.025), RoundNumberAucasou(0.04), RoundNumberAucasou(0.0), 255, 255, 255, 255)
                if not oc_surveillance then
                    if oc_target ~= nil then
                        DrawSprite("helicopterhud", "hud_lock", RoundNumberAucasou(0.5), RoundNumberAucasou(0.5), RoundNumberAucasou(0.06), RoundNumberAucasou(0.09), RoundNumberAucasou(0.0), 255, 0, 0, 255)
                    else
                        DrawSprite("helicopterhud", "hud_lock", RoundNumberAucasou(0.5), RoundNumberAucasou(0.5), RoundNumberAucasou(0.06), RoundNumberAucasou(0.09), RoundNumberAucasou(0.0), 255, 255, 255, 255)
                    end
                end
                for k,i in pairs(GetActivePlayers()) do
                    if NetworkIsPlayerActive(i) and (IsEntityDead(GetPlayerPed(i)) == false) and (IsEntityVisible(GetPlayerPed(i))) then
                        local pos = GetEntityCoords(GetPlayerPed(i))
                        local b,x,y = GetHudScreenPositionFromWorldPosition(pos.x,pos.y,pos.z)
                        if i == PlayerId() then
                            if not b then
                                DrawTextXY('~b~VOUS',{x = x, y = y-0.04, centre = 1})
                                DrawSprite("helicopterhud", "hud_lock", RoundNumberAucasou(x), RoundNumberAucasou(y), RoundNumberAucasou(0.025), RoundNumberAucasou(0.035), RoundNumberAucasou(0.0), 50, 155, 255, 255)
                            else
                                DrawSprite("helicopterhud", "hudarrow", RoundNumberAucasou(x), RoundNumberAucasou(y), RoundNumberAucasou(0.015), RoundNumberAucasou(0.025), RoundNumberAucasou(0.0), 50, 155, 255, 255)
                            end
                        else
                            if oc_target == i then
                                DrawSprite("helicopterhud", "hud_lock", RoundNumberAucasou(x), RoundNumberAucasou(y), RoundNumberAucasou(0.025), RoundNumberAucasou(0.035), RoundNumberAucasou(0.0), 255, 100, 100, 255)
                            else
                                if not b then
                                    DrawSprite("helicopterhud", "hud_lock", RoundNumberAucasou(x), RoundNumberAucasou(y), RoundNumberAucasou(0.025), RoundNumberAucasou(0.035), RoundNumberAucasou(0.0), 100, 255, 100, 255)
                                else
                                    DrawSprite("helicopterhud", "hudarrow", RoundNumberAucasou(x), RoundNumberAucasou(y), RoundNumberAucasou(0.015), RoundNumberAucasou(0.025), RoundNumberAucasou(0.0), 100, 255, 100, 255)
                                end
                            end
                        end
                    end
                end
            end
            if IsControlJustPressed(0,202) or IsDisabledControlJustPressed(0,202) then
                InsideOrbitalCannon = false 
                StopScreenEffect("DeathFailNeutralIn")
                local ped = PlayerPedId()
                FreezeEntityPosition(ped, false)
                SetEntityCollision(ped, true, 1)
                SetEntityInvincible(ped, false)
                SetPedDiesInWater(ped, 1)
                SetCamActive(cam,false)
                StopCamPointing(cam)
                RenderScriptCams(0,0,0,0,0,0)
                openRadarProperly()
                SetFocusEntity(ped)
                StopScreenEffect("DeathFailNeutralIn")
                instructionalButtons[instrucOC[1]] = {}
                break
            end
            if oc_manual or oc_surveillance then
                if IsPauseMenuActive() == false then
                    local rotation = GetCamRot(cam,2)
                    local position = GetCamCoord(cam)
                    local heading = rotation.z
                    local g = Citizen.InvokeNative(0xC906A7DAB05C8D2B,position,Citizen.PointerValueFloat(),0)
                    SetFocusArea(position.x,position.y,g, 0, 0, 0)
                    if IsDisabledControlPressed(2,15) or IsControlPressed(2,15) then -- WHEEL UP
                        if oc_height > 50 then
                            oc_height = oc_height - oc_speed*2
                            SetCamCoord(cam,vector3(position.x,position.y,oc_height))
                            RenderScriptCams(1, 1, 0, 0, 0)
                        end
                    end
                    if IsDisabledControlPressed(2,16) or IsControlPressed(2,16) then -- WHEEL DOWN
                        if oc_height < 2000 then
                            oc_height = oc_height + oc_speed*2
                            SetCamCoord(cam,vector3(position.x,position.y,oc_height))
                            RenderScriptCams(1, 1, 0, 0, 0)
                        end
                    end
                    if IsDisabledControlPressed(2,33) then
                        SetCamCoord(cam,GetObjectOffsetFromCoords(position.x,position.y,position.z,heading, 0,-oc_speed,0))
                    end
                    --s
                    if IsDisabledControlPressed(2,32) then
                        SetCamCoord(cam,GetObjectOffsetFromCoords(position.x,position.y,position.z,heading, 0,oc_speed,0))
                    end
                    --a
                    if IsDisabledControlPressed(2,34) then
                        SetCamCoord(cam,GetObjectOffsetFromCoords(position.x,position.y,position.z,heading, -oc_speed,0,0))
                    end
                    --d
                    if IsDisabledControlPressed(2,35) then
                        SetCamCoord(cam,GetObjectOffsetFromCoords(position.x,position.y,position.z,heading, oc_speed,0,0))
                    end
                    rightAxisX = GetDisabledControlNormal(0, 270)
                    rightAxisY = GetDisabledControlNormal(0, 272)
                    if (rightAxisX ~= 0 and rightAxisY ~= 0) then
                        newY = position.y - rightAxisY * RoundNumberAucasou(10)*oc_speed
                        newX = position.x + rightAxisX * RoundNumberAucasou(10)*oc_speed
                        SetCamCoord(cam,newX, newY, position.z,2)
                    end
                    if oc_manual then
                        oc_pos = vector3(position.x,position.y,g)
                        if IsDisabledControlJustPressed(2,201) or IsDisabledControlJustPressed(2,24) then
                            if oc_countdown == false then
                                FireOrbitalCannon(false)
                            end
                        end
                    end
                end
            elseif oc_automatic then
                local ped = GetPlayerPed(oc_target)
                local position = GetEntityCoords(ped)
                local heading = GetEntityHeading(ped)
                SetCamCoord(cam,vector3(position.x,position.y,position.z+ 250))
                oc_height = position.z+ 250
                SetFocusArea(position, 0, 0, 0)
            end
			--else
				
			--end
		end
	end
end

RegisterCommand("orbital", function()
    if p:getPermission() ~= 69 then return end
    StartOrbital()
end)

devVehBoostActive = false
local boostKey = 20
local brakeKey = 72
local boostAmount = 0.5
local brakeAndTractionDuration = 5000
local downwardForce = -500.0

local vehicleState = {
    isBoosting = false,
    boostSessionId = 0,
    vehicle = nil,
    brakeBoost = false
}

local function createVariableWatcher(table, callback)
    local proxy = {}
    local mt = {
        __index = table,
        __newindex = function(t, key, value)
            local oldValue = table[key]
            table[key] = value
            if json.encode(oldValue) ~= json.encode(value) then
                callback(key, oldValue, value)
            end
        end
    }
    setmetatable(proxy, mt)
    return proxy
end

while p == nil do Wait(1) end

if p:getPermission() > 5 then
    vehicleState = createVariableWatcher(vehicleState, function(key, oldValue, newValue)
        if key == "isBoosting" and newValue then
            vehicleState.boostSessionId = vehicleState.boostSessionId + 1
            local currentSessionId = vehicleState.boostSessionId

            Citizen.CreateThread(function()
                while vehicleState.isBoosting and vehicleState.boostSessionId == currentSessionId do
                    Citizen.Wait(0)
                    ApplyForceToEntityCenterOfMass(vehicleState.vehicle, 0, 0.0, 0.0, downwardForce, true, true, true, true)
                end
            end)

            Citizen.SetTimeout(brakeAndTractionDuration, function()
                if vehicleState.boostSessionId == currentSessionId then
                    vehicleState.brakeBoost = false
                end
            end)
        end
    end)

    Citizen.CreateThread(function()
        while true do
            if devVehBoostActive then
                Citizen.Wait(5)
                if IsPedInAnyVehicle(p:ped(), false) then
                    local vehicle = GetVehiclePedIsIn(p:ped(), false)
                    vehicleState.vehicle = vehicle

                    if IsControlPressed(1, boostKey) then
                        if not vehicleState.isBoosting then
                            vehicleState.isBoosting = true
                        end

                        SetVehicleForwardSpeed(vehicle, GetEntitySpeed(vehicle) + boostAmount)
                        vehicleState.brakeBoost = true
                    else
                        if vehicleState.isBoosting then
                            vehicleState.isBoosting = false
                        end
                    end

                    local currentSpeed = GetEntitySpeed(vehicle)
                    if currentSpeed > 1 and vehicleState.brakeBoost then
                        if IsControlPressed(1, brakeKey) then
                            local newSpeed = currentSpeed - (0.07 * currentSpeed/10) 
                            SetVehicleForwardSpeed(vehicle, newSpeed)
                        end
                    elseif currentSpeed < 1 and vehicleState.brakeBoost then
                        vehicleState.brakeBoost = false
                    end
                else
                    if vehicleState.isBoosting then
                        vehicleState.isBoosting = false
                    end
                end
            else 
                Citizen.Wait(2000)
            end
        end
    end)

    RegisterCommand('setboost', function(source, args, rawCommand)
        if p:getPermission() > 5 then
            local newBoostAmount = tonumber(args[1])
            if newBoostAmount then
                boostAmount = newBoostAmount
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "~g La puissance du boost a été modifiée à " .. newBoostAmount
                })
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "~c Veuillez entrer un nombre valide."
                })
            end
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "~c Vous n'avez pas la permission d'utiliser cette commande."
            })
        end
    end, false)
end


--------------------------------------------------------------
----------------------- CUSTOM VEHICLE -----------------------
-------------------------------------------------------------- 

local open = false
local status = false
local redIndex = 1
local blueIndex = 1
local greenIndex = 1
local redIndex2 = 1
local blueIndex2 = 1
local greenIndex2 = 1
local main = RageUI.CreateMenu("", "Action disponible", 0.0, 0.0, "shopui_title_carmod", "shopui_title_carmod")
local aesthetic = RageUI.CreateSubMenu(main, "", "Action disponible")
local perf = RageUI.CreateSubMenu(main, "", "Action disponible")
local perflist = RageUI.CreateSubMenu(perf, "", "Action disponible")
local aestheticlist = RageUI.CreateSubMenu(aesthetic, "", "Action disponible")

---Color

local color = RageUI.CreateSubMenu(aesthetic, "", "Action disponible")
local primaryColor = RageUI.CreateSubMenu(color, "", "Action disponible")
local primaryColorList = RageUI.CreateSubMenu(primaryColor, "", "Action disponible")
local secondaryColor = RageUI.CreateSubMenu(color, "", "Action disponible")
local secondaryColorList = RageUI.CreateSubMenu(secondaryColor, "", "Action disponible")
local customColor = RageUI.CreateSubMenu(color, "", "Action disponible")
local customColor2 = RageUI.CreateSubMenu(color, "", "Action disponible")
local interiorColor = RageUI.CreateSubMenu(color, "", "Action disponible")
local light = RageUI.CreateSubMenu(aesthetic, "", "Action disponible")
local xenonColor = RageUI.CreateSubMenu(light, "", "Action disponible")
local liveries = RageUI.CreateSubMenu(color, "", "Action disponible")
local stickers = RageUI.CreateSubMenu(color, "", "Action disponible")
local neonKit = RageUI.CreateSubMenu(light, "", "Action disponible")
local neonColor = RageUI.CreateSubMenu(neonKit, "", "Action disponible")
-- wheel
local wheel = RageUI.CreateSubMenu(aesthetic, "", "Action disponible")
local wheelList = RageUI.CreateSubMenu(wheel, "", "Action disponible")
local wheelBack = RageUI.CreateSubMenu(wheel, "", "Action disponible")
local wheelFront = RageUI.CreateSubMenu(wheel, "", "Action disponible")
local typeWheel = RageUI.CreateSubMenu(wheelList, "", "Action disponible")
local combinaisonColor = RageUI.CreateSubMenu(color, "", "Action disponible")
local colorWheel = RageUI.CreateSubMenu(color, "", "Action disponible")
local windowTint = RageUI.CreateSubMenu(aesthetic, "", "Action disponible")
local hornList = RageUI.CreateSubMenu(aesthetic, "", "Action disponible")
local smokeTyreColor = RageUI.CreateSubMenu(color, "", "Action disponible")
local interior = RageUI.CreateSubMenu(aesthetic, "", "Action disponible")
local interiorList = RageUI.CreateSubMenu(interior, "", "Action disponible")
local plaque = RageUI.CreateSubMenu(aesthetic, "", "Action disponible")
local plaqueList = RageUI.CreateSubMenu(plaque, "", "Action disponible")
local extra = RageUI.CreateSubMenu(aesthetic, "", "Action disponible")
local phareType = RageUI.CreateSubMenu(light, "", "Action disponible")
local xenon = false
local interiorIndex = 1
local dashbordColorIndex = 1
local index = 1
local extraValue = {
    {value = false},
    {value = false},
    {value = false},
    {value = false},
    {value = false},
    {value = false},
    {value = false},
    {value = false},
    {value = false},
    {value = false},
    {value = false},
    {value = false},
    {value = false},
}
local noExtra = true
local dataIndex = 0
local dataName
local list = {}
local listcustom = {}
local turbo = false
local veh
local neon = {
    left = false,
    right = false,
    front = false,
    back = false
}
local dataColor = {}
local headlightColors = { {
    name = "Origine",
    id = -1
}, {
    name = "Blanc",
    id = 0
}, {
    name = "Bleu",
    id = 1
}, {
    name = "Bleu électrique",
    id = 2
}, {
    name = "Vert menthe",
    id = 3
}, {
    name = "Vert citron",
    id = 4
}, {
    name = "Jaune",
    id = 5
}, {
    name = "Or jaune",
    id = 6
}, {
    name = "Orange",
    id = 7
}, {
    name = "Rouge",
    id = 8
}, {
    name = "Rose poney",
    id = 9
}, {
    name = "Rose vif",
    id = 10
}, {
    name = "Violet",
    id = 11
}, {
    name = "Lumière noire",
    id = 12
} }
CustomPos = {}
local saveVeh = nil


local category_custom = {}

main.Closed = function()
    RageUI.Visible(main, false)
    RageUI.Visible(aesthetic, false)
    RageUI.Visible(perf, false)
    RageUI.Visible(perflist, false)
    RageUI.Visible(aestheticlist, false)
    RageUI.Visible(color, false)
    RageUI.Visible(primaryColor, false)
    RageUI.Visible(primaryColorList, false)
    RageUI.Visible(secondaryColor, false)
    RageUI.Visible(secondaryColorList, false)
    RageUI.Visible(customColor, false)
    RageUI.Visible(customColor2, false)
    RageUI.Visible(interiorColor, false)
    RageUI.Visible(light, false)
    RageUI.Visible(liveries, false)
    RageUI.Visible(stickers, false)
    RageUI.Visible(xenonColor, false)
    RageUI.Visible(neonColor, false)
    RageUI.Visible(neonKit, false)
    RageUI.Visible(wheel, false)
    RageUI.Visible(wheelList, false)
    RageUI.Visible(wheelBack, false)
    RageUI.Visible(wheelFront, false)
    RageUI.Visible(typeWheel, false)
    RageUI.Visible(combinaisonColor, false)
    RageUI.Visible(colorWheel, false)
    RageUI.Visible(windowTint, false)
    RageUI.Visible(hornList, false)
    RageUI.Visible(smokeTyreColor, false)
    RageUI.Visible(interior, false)
    RageUI.Visible(interiorList, false)
    RageUI.Visible(plaque, false)
    RageUI.Visible(plaqueList, false)
    RageUI.Visible(extra, false)
    RageUI.Visible(phareType, false)
    TriggerServerEvent("core:SetPropsVeh", nil, all_trim(GetVehicleNumberPlateText(p:currentVeh())), vehicle.getProps(p:currentVeh()))
    open = false
end

local function OpenCustomMenu()
    if open then
        RageUI.Visible(main, false)
        RageUI.Visible(aesthetic, false)
        RageUI.Visible(perf, false)
        RageUI.Visible(perflist, false)
        RageUI.Visible(aestheticlist, false)
        RageUI.Visible(color, false)
        RageUI.Visible(primaryColor, false)
        RageUI.Visible(primaryColorList, false)
        RageUI.Visible(secondaryColor, false)
        RageUI.Visible(secondaryColorList, false)
        RageUI.Visible(customColor, false)
        RageUI.Visible(customColor2, false)
        RageUI.Visible(interiorColor, false)
        RageUI.Visible(light, false)
        RageUI.Visible(liveries, false)
        RageUI.Visible(stickers, false)
        RageUI.Visible(xenonColor, false)
        RageUI.Visible(neonColor, false)
        RageUI.Visible(neonKit, false)
        RageUI.Visible(wheel, false)
        RageUI.Visible(wheelList, false)
        RageUI.Visible(wheelBack, false)
        RageUI.Visible(wheelFront, false)
        RageUI.Visible(typeWheel, false)
        RageUI.Visible(combinaisonColor, false)
        RageUI.Visible(colorWheel, false)
        RageUI.Visible(windowTint, false)
        RageUI.Visible(hornList, false)
        RageUI.Visible(smokeTyreColor, false)
        RageUI.Visible(interior, false)
        RageUI.Visible(interiorList, false)
        RageUI.Visible(plaque, false)
        RageUI.Visible(plaqueList, false) 
        RageUI.Visible(extra, false)
        RageUI.Visible(phareType, false)
        TriggerServerEvent("core:SetPropsVeh", nil, all_trim(GetVehicleNumberPlateText(p:currentVeh())), vehicle.getProps(p:currentVeh()))
        open = false
        return
    else
        Visual.Subtitle("Appuyez sur Espace pour ouvrir les portes", 8000)
        status = false
        for i = 0, 7 do
            if IsVehicleDoorFullyOpen(veh, i) then
                status = true
            end
        end
        open = true
        veh = p:currentVeh()
        neon = {
            left = false,
            right = false,
            front = false,
            back = false
        }
        TriggerServerEvent("core:SetPropsVeh", nil, all_trim(GetVehicleNumberPlateText(p:currentVeh())), vehicle.getProps(p:currentVeh()))
        RageUI.Visible(main, true)
        SetVehicleModKit(veh, 0)
        if IsToggleModOn(veh, 18) then
            turbo = true
        else
            turbo = false
        end
        Citizen.CreateThread(function()
            while open do
                -- if the player presses space, open all doors
                if IsControlJustPressed(0, 22) then
                    if not status then
                        for i = 0, 7 do
                            SetVehicleDoorOpen(veh, i, false, false)
                            status = true
                        end
                    else
                        for i = 0, 7 do
                            SetVehicleDoorShut(veh, i, false)
                            status = false
                        end
                    end
                end
                RageUI.IsVisible(main, function()
                    RageUI.Button("Performance", false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                        end
                    }, perf)
                    RageUI.Button("Esthetique", false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                        end
                    }, aesthetic)
                end)

                RageUI.IsVisible(perf, function()
                    for k, v in pairs(Custom.perf) do
                        RageUI.Button(v.name, false, {
                            RightLabel = ">"
                        }, true, {
                            onSelected = function()
                                dataName = v.name
                                dataIndex = v.label
                                index = GetVehicleMod(veh, v.label)
                            end
                        }, perflist)
                    end
                end)

                RageUI.IsVisible(aesthetic, function()
                    for k, v in pairs(Custom.aesthetic) do
                        if GetNumVehicleMods(veh, v.label) >= 1 then
                            RageUI.Button(v.name, false, {
                                RightLabel = ">"
                            }, true, {
                                onSelected = function()
                                    dataName = v.name
                                    dataIndex = v.label
                                    index = GetVehicleMod(veh, v.label)
                                end
                            }, aestheticlist)
                        end
                    end
                    RageUI.Button('Klaxon', false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                        end
                    }, hornList)
                    RageUI.Button('Peinture', false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                            list = {}
                            for i = 1, 161 do
                                table.insert(list, i)
                            end
                            listcustom = {}
                            for i = 1, 256 do
                                table.insert(listcustom, i)
                            end
                        end
                    }, color)
                    RageUI.Button('Phares', false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                        end
                    }, light)
                    RageUI.Button('Roue', false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                            ToggleVehicleMod(veh, 20)
                        end
                    }, wheel)
                    RageUI.Button('Vitre', false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                        end
                    }, windowTint)
                    RageUI.Button('Interieur', false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                        end
                    }, interior)
                    RageUI.Button('Plaque', false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                        end
                    }, plaque)
                    RageUI.Button('extra', false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                        end
                    }, extra)
                end)


                
                RageUI.IsVisible(interior, function()
                    for k, v in pairs(Custom.interior) do
                        RageUI.Button(v.name, false, {
                            RightLabel = ">"
                        }, true, {
                            onSelected = function()
                                dataName = v.name
                                dataIndex = v.id
                                index = GetVehicleMod(veh, v.id)
                            end
                        }, interiorList)
                    end
                end)
                RageUI.IsVisible(plaque, function()
                    for k, v in pairs(Custom.plaque) do
                        RageUI.Button(v.name, false, {
                            RightLabel = ">"
                        }, true, {
                            onSelected = function()
                                dataName = v.name
                                dataIndex = v.id
                                index = GetVehicleMod(veh, v.id)
                            end
                        }, plaqueList)
                    end
                end)
                RageUI.IsVisible(plaqueList, function()
                    if dataIndex == 26 then
                        RageUI.Button("Bleu sur blanc", false, {
                        }, true, {
                            onActive = function()
                                SetVehicleNumberPlateTextIndex(veh, 0)
                            end,
                            onSelected = function()
                                index = 1
                                SetVehicleNumberPlateTextIndex(veh, 0)
                            end
                        }, nil)
                        RageUI.Button("Bleu sur blanc 2", false, {
                        }, true, {
                            onActive = function()
                                SetVehicleNumberPlateTextIndex(veh, 3)

                            end,
                            onSelected = function()
                                index = 1
                                SetVehicleNumberPlateTextIndex(veh, 3)

                            end
                        }, nil)
                        RageUI.Button("Bleu sur blanc 3", false, {
                        }, true, {
                            onActive = function()
                                SetVehicleNumberPlateTextIndex(veh, 4)

                            end,
                            onSelected = function()
                                index = 1
                                SetVehicleNumberPlateTextIndex(veh, 4)

                            end
                        }, nil)
                        RageUI.Button("Jaune sur noir", false, {
                        }, true, {
                            onActive = function()
                                SetVehicleNumberPlateTextIndex(veh, 1)

                            end,
                            onSelected = function()
                                index = 1
                                SetVehicleNumberPlateTextIndex(veh, 1)

                            end
                        }, nil)
                        RageUI.Button("Jaune sur bleu", false, {
                        }, true, {
                            onActive = function()
                                SetVehicleNumberPlateTextIndex(veh, 2)
                                -- SetVehicleMod(veh, 25, 2)
                                -- SetVehicleMod(veh, 26, 2)
                            end,
                            onSelected = function()
                                index = 1
                                SetVehicleNumberPlateTextIndex(veh, 2)
                                -- SetVehicleMod(veh, 25, 2)
                                -- SetVehicleMod(veh, 26, 2)
                            end
                        }, nil)
                    end
                    if GetNumVehicleMods(veh, dataIndex) == 0 and dataIndex ~= 26 then
                        RageUI.Separator("Pas de modification disponible")
                    else

                        for i = 1, GetNumVehicleMods(veh, dataIndex) do
                            local name = GetLabelText(GetModTextLabel(veh, dataIndex, i))
                            if name == "NULL" then
                                name = "Original"
                            end
                            if index == i then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end

                            RageUI.Button(name, false, {
                                RightBadge = Rightbadge
                            }, true, {
                                onActive = function()
                                    SetVehicleMod(veh, dataIndex, i, 0)
                                end,
                                onSelected = function()
                                    index = i
                                    SetVehicleMod(veh, dataIndex, i, 0)
                                end
                            }, nil)

                        end
                    end
                end)

                RageUI.IsVisible(extra, function()
                    for k, v in pairs(extraValue) do
                        if DoesExtraExist(veh, k) then
                            noExtra = false
                            RageUI.Checkbox('extra '..k, false, v.value, {}, {
                                onChecked = function()
                                    SetVehicleExtra(veh, k, 1)
                                    v.value = true
                                end,
                                onUnChecked = function()
                                    SetVehicleExtra(veh, k, 0)
                                    v.value = false
                                end
                            })
                        end
                       
                    end 
                    if noExtra then
                        RageUI.Separator("Pas de modification disponible")
                    end
                end)
                
                RageUI.IsVisible(interiorList, function()
                    if GetNumVehicleMods(veh, dataIndex) == 0 then
                        RageUI.Separator("Pas de modification disponible")
                    else
                        for i = 1, GetNumVehicleMods(veh, dataIndex) do
                            local name = GetLabelText(GetModTextLabel(veh, dataIndex, i))
                            if name == "NULL" then
                                name = "Original"
                            end
                            if index == i then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end

                            RageUI.Button(name, false, {
                                RightBadge = Rightbadge
                            }, true, {
                                onActive = function()
                                    SetVehicleMod(veh, dataIndex, i, 0)
                                end,
                                onSelected = function()
                                    index = i
                                    SetVehicleMod(veh, dataIndex, i, 0)
                                end
                            }, nil)

                        end
                    end
                end)
                RageUI.IsVisible(hornList, function()
                    for i = 1, GetNumVehicleMods(veh, 14) do
                        if index == i then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end

                        RageUI.Button("Klaxon n°" .. i, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                SetVehicleMod(veh, 14, i, 0)
                                if IsHornActive(veh) then
                                    DisableControlAction(0, 38, true) 
                                end
                                DisableControlAction(0, 38, false) 
                            end,
                            onSelected = function()
                                index = i
                                SetVehicleMod(veh, 14, i, 0)
                            end
                        }, nil)

                    end
                end)

                RageUI.IsVisible(windowTint, function()
                    for k, v in pairs(Custom.windowTint) do
                        if index == v.id then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end
                        RageUI.Button(v.name, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                SetVehicleWindowTint(veh, v.id)
                            end,
                            onSelected = function()
                                SetVehicleWindowTint(veh, v.id)
                                index = GetVehicleWindowTint(veh)
                            end
                        }, nil)
                    end
                end)
                RageUI.IsVisible(wheel, function()

                    RageUI.Button("Type de roue", false, {
                        RightLabel = ">"
                    }, true, {}, typeWheel)
                    RageUI.Button("Couleur des jantes", false, {
                        RightLabel = ">"
                    }, true, {}, colorWheel)
                    RageUI.Button("Fumée de pneu", false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                        end
                    }, smokeTyreColor)

                end)
                RageUI.IsVisible(colorWheel, function()
                    for k, v in pairs(Custom.nacrageColor) do
                        if index == k then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end
                        RageUI.Button(v.name, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(veh)

                                SetVehicleExtraColours(veh, pearlescentColor, v.id)
                            end,
                            onSelected = function()
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(veh)
                                index = k
                                SetVehicleExtraColours(veh, pearlescentColor, v.id)
                            end
                        }, nil)
                    end

                end)
                RageUI.IsVisible(typeWheel, function()
                    if IsThisModelABike(GetEntityModel(veh)) then
                        RageUI.Button("Roue avant", false, {
                            RightLabel = ">"
                        }, true, {
                            onSelected = function()
                                dataIndex = 23
                                index = GetVehicleMod(veh, 23)
                            end
                        }, wheelFront)
                        RageUI.Button("Roue arrière", false, {
                            RightLabel = ">"
                        }, true, {
                            onSelected = function()
                                dataIndex = 24
                                index = GetVehicleMod(veh, 24)
                            end
                        }, wheelBack)
                    else
                        for k, v in pairs(Custom.wheels) do
                            RageUI.Button(v.name, false, {
                                RightLabel = ">"
                            }, true, {
                                onSelected = function()
                                    dataName = v.name
                                    dataIndex = 23
                                    SetVehicleWheelType(veh, v.id)
                                    index = GetVehicleMod(veh, 23)
                                end
                            }, wheelList)
                        end
                    end
                end)
                RageUI.IsVisible(wheelList, function()

                    for i = 1, GetNumVehicleMods(veh, 23) do
                        local name = GetLabelText(GetModTextLabel(veh, 23, i)) -- Change seulement la roue AV sur les moto
                        if name == "NULL" then
                            name = "Original"
                        end
                        if index == i then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end

                        RageUI.Button(name, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                SetVehicleMod(veh, 23, i, 0)
                            end,
                            onSelected = function()
                                index = i
                                SetVehicleMod(veh, 23, i, 0)
                            end
                        }, nil)
                    end
                end)

                RageUI.IsVisible(wheelFront, function()
                    for i = 1, GetNumVehicleMods(veh, 23) do
                        local name = GetLabelText(GetModTextLabel(veh, 23, i))
                        if name == "NULL" then
                            name = "Original"
                        end
                        if index == i then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end

                        RageUI.Button(name, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                SetVehicleMod(veh, 23, i, 0)
                            end,
                            onSelected = function()
                                index = i
                                SetVehicleMod(veh, 23, i, 0)
                            end
                        }, nil)
                    end
                end)

                RageUI.IsVisible(wheelBack, function()
                    for i = 1, GetNumVehicleMods(veh, 24) do
                        local name = GetLabelText(GetModTextLabel(veh, 24, i))
                        if name == "NULL" then
                            name = "Original"
                        end
                        if index == i then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end

                        RageUI.Button(name, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                SetVehicleMod(veh, 24, i, 0)
                            end,
                            onSelected = function()
                                index = i
                                SetVehicleMod(veh, 24, i, 0)
                            end
                        }, nil)
                    end
                end)

                ---color
                RageUI.IsVisible(light, function()
                    RageUI.Checkbox('Phare xénon', false, xenon, {}, {
                        onChecked = function()
                            xenon = true
                            ToggleVehicleMod(veh, 22, true)
                        end,
                        onUnChecked = function()
                            xenon = false
                            ToggleVehicleMod(veh, 22, false)
                        end
                    })

                    if xenon then
                        RageUI.Button("Couleur des phares", false, {
                            RightLabel = ">"
                        }, true, {
                            onSelected = function()
                                index = GetVehicleXenonLightsColor(veh)
                            end
                        }, xenonColor)
                    end
                    RageUI.Button('Kits néon', false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()

                        end
                    }, neonKit)
                    RageUI.Button('Position des phares', false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()

                        end
                    }, phareType)
                end)
                RageUI.IsVisible(phareType, function()
                    for i = 1, GetNumVehicleMods(veh, 42) do
                        local name = GetLabelText(GetModTextLabel(veh, dataIndex, i))
                        if name == "NULL" then
                            name = "Original"
                        end
                        if index == i then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end

                        RageUI.Button(name, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                SetVehicleMod(veh, 42, i, 0)
                            end,
                            onSelected = function()
                                index = i
                                SetVehicleMod(veh, 42, i, 0)
                            end
                        }, nil)

                    end
                end)
                RageUI.IsVisible(neonKit, function()
                    RageUI.Checkbox('Néon gauche', false, neon.left, {}, {
                        onChecked = function()
                            neon.left = true
                            SetVehicleNeonLightEnabled(veh, 0, true)
                        end,
                        onUnChecked = function()
                            neon.left = false
                            SetVehicleNeonLightEnabled(veh, 0, false)
                        end
                    })
                    RageUI.Checkbox('Néon droit', false, neon.right, {}, {
                        onChecked = function()
                            neon.right = true
                            SetVehicleNeonLightEnabled(veh, 1, true)
                        end,
                        onUnChecked = function()
                            neon.right = false
                            SetVehicleNeonLightEnabled(veh, 1, false)
                        end
                    })
                    RageUI.Checkbox('Néon avant', false, neon.front, {}, {
                        onChecked = function()
                            neon.front = true
                            SetVehicleNeonLightEnabled(veh, 2, true)
                        end,
                        onUnChecked = function()
                            neon.front = false
                            SetVehicleNeonLightEnabled(veh, 2, false)
                        end
                    })
                    RageUI.Checkbox('Néon arrière', false, neon.back, {}, {
                        onChecked = function()
                            neon.back = true
                            SetVehicleNeonLightEnabled(veh, 3, true)
                        end,
                        onUnChecked = function()
                            neon.back = false
                            SetVehicleNeonLightEnabled(veh, 3, false)
                        end
                    })
                    RageUI.Button("Couleur néon", false, {}, true, {}, neonColor)
                end)

                RageUI.IsVisible(smokeTyreColor, function()
                    for k, v in pairs(Custom.neon) do
                        if index == k then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end
                        RageUI.Button(v.name, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                ToggleVehicleMod(veh, 20, true)
                                SetVehicleTyreSmokeColor(veh, v.rgb[1], v.rgb[2], v.rgb[3])
                            end,
                            onSelected = function()
                                ToggleVehicleMod(veh, 20, true)
                                index = k
                                SetVehicleTyreSmokeColor(veh, v.rgb[1], v.rgb[2], v.rgb[3])
                            end
                        }, nil)
                    end

                end)
                RageUI.IsVisible(neonColor, function()
                    for k, v in pairs(Custom.neon) do
                        if index == k then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end
                        RageUI.Button(v.name, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                SetVehicleNeonLightsColour(veh, v.rgb[1], v.rgb[2], v.rgb[3])
                            end,
                            onSelected = function()
                                index = k
                                SetVehicleNeonLightsColour(veh, v.rgb[1], v.rgb[2], v.rgb[3])
                            end
                        }, nil)
                    end

                end)
                RageUI.IsVisible(xenonColor, function()
                    for k, v in pairs(headlightColors) do
                        if index == v.id then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end
                        RageUI.Button(v.name, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                SetVehicleXenonLightsColor(veh, v.id)
                            end,
                            onSelected = function()
                                index = v.id
                                SetVehicleXenonLightsColor(veh, v.id)
                            end
                        }, nil)
                    end

                end)

                RageUI.IsVisible(color, function()
                    RageUI.Button("Couleur principale", false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                            ClearVehicleCustomPrimaryColour(GetVehiclePedIsIn(PlayerPedId()))
                            ClearVehicleCustomSecondaryColour(GetVehiclePedIsIn(PlayerPedId()))
                        end
                    }, primaryColor)
                    RageUI.Button("Couleur secondaire", false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                            ClearVehicleCustomPrimaryColour(GetVehiclePedIsIn(PlayerPedId()))
                            ClearVehicleCustomSecondaryColour(GetVehiclePedIsIn(PlayerPedId()))
                        end
                    }, secondaryColor)
                    RageUI.Button("Nacrage", false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                            local pearlescentColor, wheelColor = GetVehicleExtraColours(veh)

                            index = pearlescentColor
                        end
                    }, combinaisonColor)
                    RageUI.Button("Motif", false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                        end
                    }, liveries)
                    RageUI.Button("Stickers", false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                        end
                    }, stickers)
                    -- for k, v in pairs(Custom.primaryColor) do
                    --     RageUI.Button(v.name, false, { RightLabel = ">" }, true, {
                    --         onSelected = function()
                    --             dataName = v.name
                    --             dataIndex = v.label
                    --             index = GetVehicleMod(veh, v.label)
                    --         end
                    --     }, perflist)
                    RageUI.List("Couleur intérieur", list, interiorIndex, false, {}, true, {
                        onListChange = function(Index)
                            interiorIndex = Index
                            SetVehicleInteriorColor(veh, interiorIndex)
                        end
                    }, nil)
                    RageUI.List("Couleur tableau de bord", list, dashbordColorIndex, false, {}, true, {
                        onListChange = function(Index)
                            dashbordColorIndex = Index
                            SetVehicleDashboardColor(veh, dashbordColorIndex)
                        end
                    }, nil)

                    -- end
                end)

                RageUI.IsVisible(interiorColor, function()
                    for i = 1, 161 do
                        if i < 161 then
                            local name = ""
                            for k, v in pairs(Custom.color[1].color) do
                                if v.id == i then
                                    name = v.name
                                end
                            end

                            if index == i then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end

                            RageUI.Button(name .. i, false, {
                                RightBadge = Rightbadge
                            }, true, {
                                onActive = function()
                                    SetVehicleInteriorColor(veh, i)
                                end,
                                onSelected = function()
                                    index = i
                                    SetVehicleInteriorColor(veh, i)
                                end
                            }, nil)
                        end

                    end
                end)

                RageUI.IsVisible(liveries, function()
                    for i = 1, GetNumVehicleMods(veh, 48) do
                        local name = GetLabelText(GetModTextLabel(veh, 48, i))
                        if name == "NULL" then
                            name = "Original"
                        end
                        if index == i then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end

                        RageUI.Button(name, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                SetVehicleMod(veh, 48, i, 0)
                            end,
                            onSelected = function()
                                index = i
                                SetVehicleMod(veh, 48, i, 0)
                            end
                        }, nil)

                    end
                end)
                RageUI.IsVisible(stickers, function()
                    if GetVehicleLiveryCount(veh) == -1 then
                        RageUI.Separator("Pas de modification disponible")
                    else
                        for i = 1, GetVehicleLiveryCount(veh) do
                            local name = GetLabelText(GetLiveryName(veh, i))
                            if name == "NULL" then
                                name = "Original"
                            end
                            if index == i then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end

                            RageUI.Button(name, false, {
                                RightBadge = Rightbadge
                            }, true, {
                                onActive = function()
                                    SetVehicleLivery(veh, i)
                                end,
                                onSelected = function()
                                    index = i
                                    SetVehicleLivery(veh, i)
                                end
                            }, nil)

                        end
                    end
                end)
                RageUI.IsVisible(primaryColor, function()
                    for k, v in pairs(Custom.color) do
                        RageUI.Button(v.name, false, {
                            RightLabel = ">"
                        }, true, {
                            onSelected = function()
                                dataName = v.name
                                dataIndex = v.label
                                if v.color ~= nil then
                                    dataColor = v.color
                                end
                                index = GetNumModColors(veh)
                            end
                        }, primaryColorList)
                    end
                end)
                RageUI.IsVisible(combinaisonColor, function()
                    for k, v in pairs(Custom.nacrageColor) do
                        if index == k then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end
                        RageUI.Button(v.name, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(veh)

                                SetVehicleExtraColours(veh, v.id, wheelColor)
                            end,
                            onSelected = function()
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(veh)
                                index = k
                                SetVehicleExtraColours(veh, v.id, wheelColor)
                            end
                        }, nil)
                    end

                end)

                RageUI.IsVisible(secondaryColor, function()
                    for k, v in pairs(Custom.color) do
                        RageUI.Button(v.name, false, {
                            RightLabel = ">"
                        }, true, {
                            onSelected = function()
                                dataName = v.name
                                dataIndex = v.label
                                if v.color ~= nil then
                                    dataColor = v.color
                                end
                                index = GetNumModColors(veh)
                            end
                        }, secondaryColorList)
                    end
                end)
                RageUI.IsVisible(primaryColorList, function()
                    for i = 1, GetNumModColors(dataIndex, true) do
                        if i < GetNumModColors(dataIndex, true) then
                            local name = ""
                            for k, v in pairs(dataColor) do
                                if v.id == i then
                                    name = v.name
                                end
                            end

                            if index == i then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end

                            RageUI.Button(name, false, {
                                RightBadge = Rightbadge
                            }, true, {
                                onActive = function()
                                    SetVehicleModColor_1(veh, dataIndex, i, 0)
                                end,
                                onSelected = function()
                                    index = i
                                    SetVehicleModColor_1(veh, dataIndex, i, 0)
                                end
                            }, nil)
                        end

                    end
                end)
                RageUI.IsVisible(secondaryColorList, function()
                    for i = 1, GetNumModColors(dataIndex, true) do
                        if i < GetNumModColors(dataIndex, true) then
                            local name = ""
                            for k, v in pairs(dataColor) do
                                if v.id == i then
                                    name = v.name
                                end
                            end

                            if index == i then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end

                            RageUI.Button(name, false, {
                                RightBadge = Rightbadge
                            }, true, {
                                onActive = function()
                                    SetVehicleModColor_2(veh, dataIndex, i, 0)
                                end,
                                onSelected = function()
                                    index = i
                                    SetVehicleModColor_2(veh, dataIndex, i, 0)

                                end
                            }, nil)
                        end

                    end
                end)

                RageUI.IsVisible(perflist, function()
                    if GetNumVehicleMods(veh, dataIndex) == 0 and dataIndex ~= 18 then
                        RageUI.Separator("Pas de modification disponible")
                    elseif dataIndex == 18 then

                        if turbo then
                            Rightbadges = RageUI.BadgeStyle.Car
                        else
                            Rightbadges = nil
                        end

                        RageUI.Button("Turbo", false, {
                            RightBadge = Rightbadges
                        }, true, {
                            onActive = function()
                            end,
                            onSelected = function()
                                if turbo then
                                    turbo = false
                                    ToggleVehicleMod(veh, 18, false)
                                else
                                    turbo = true
                                    ToggleVehicleMod(veh, 18, true)
                                end
                            end
                        }, nil)
                    end


                    if GetNumVehicleMods(veh, dataIndex) >= 1 then
                        if index == 4 then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end
                        RageUI.Button(dataName .. " - Niveau n°" .. 0, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                SetVehicleMod(veh, dataIndex, 4, false)
                            end,
                            onSelected = function()
                                index = 4
                                SetVehicleMod(veh, dataIndex, 4, true)
                            end
                        }, nil)
                        for i = 0, GetNumVehicleMods(veh, dataIndex) do

                            if i < GetNumVehicleMods(veh, dataIndex) then
                                if index == i then
                                    Rightbadge = RageUI.BadgeStyle.Car
                                else
                                    Rightbadge = nil
                                end
                                RageUI.Button(dataName .. " - Niveau n°" .. i + 1, false, {
                                    RightBadge = Rightbadge
                                }, true, {
                                    onActive = function()
                                        SetVehicleMod(veh, dataIndex, i, false)
                                    end,
                                    onSelected = function()
                                        index = i
                                        SetVehicleMod(veh, dataIndex, i, true)
                                    end
                                }, nil)
                            end
                        end
                    end
                    RageUI.StatisticPanel((GetVehicleEstimatedMaxSpeed(veh) / 100) * 2, "Vitesse de pointe", i)
                    RageUI.StatisticPanel(GetVehicleAcceleration(veh), "Accéleration", i)
                    RageUI.StatisticPanel((GetVehicleMaxBraking(veh) / 10) * 5, "Freinage", i)
                    RageUI.StatisticPanel((GetVehicleMaxTraction(veh) / 10) * 2, "Tenue de route", i)

                end)

                RageUI.IsVisible(aestheticlist, function()
                    if GetNumVehicleMods(veh, dataIndex) == 0 then
                        RageUI.Separator("Pas de modification disponible")
                    else
                        for i = 0, GetNumVehicleMods(veh, dataIndex) do
                            local name = GetLabelText(GetModTextLabel(veh, dataIndex, i))
                            if name == "NULL" then
                                name = "Original"
                            end
                            if index == i then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end
                            RageUI.Button(name, false, {
                                RightBadge = Rightbadge
                            }, true, {
                                onActive = function()
                                    SetVehicleMod(veh, dataIndex, i, true)
                                end,
                                onSelected = function()
                                    index = i
                                end
                            }, nil)
                        end
                        RageUI.StatisticPanel((GetVehicleEstimatedMaxSpeed(veh) / 100) * 2, "Vitesse de pointe", i)
                        RageUI.StatisticPanel(GetVehicleAcceleration(veh), "Accéleration", i)
                        RageUI.StatisticPanel((GetVehicleMaxBraking(veh) / 10) * 5, "Freinage", i)
                        RageUI.StatisticPanel((GetVehicleMaxTraction(veh) / 10) * 2, "Tenue de route", i)
                    end
                end)

                Wait(1)
            end
        end)
    end
end

RegisterCommand("custom", function()
	if p:getPermission() > 5 then
		OpenCustomMenu()
	end
end)
addChatSuggestion(5, "custom", "Ouvrir le menu de customisation de véhicule")

RegisterCommand("saveVehProps", function()
	if p:getPermission() > 4 then
        TriggerServerEvent("core:SetPropsVeh", nil, all_trim(GetVehicleNumberPlateText(p:currentVeh())), vehicle.getProps(p:currentVeh()))
	end
end)
addChatSuggestion(4, "saveVehProps", "Sauvegarder les props du véhicule")