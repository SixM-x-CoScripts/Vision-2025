local flare_models = {
    [GetHashKey("mogul")] = true,
    [GetHashKey("rogue")] = true,
    --[GetHashKey("starling")] = true,
    --[GetHashKey("seabreeze")] = true,
    [GetHashKey("tula")] = true,
    [GetHashKey("bombushka")] = true,
    [GetHashKey("hunter")] = true,
    [GetHashKey("akula")] = true,
    [GetHashKey("nokota")] = true,
    [GetHashKey("pyro")] = true,
    [GetHashKey("titan")] = true,
    [GetHashKey("oppressor")] = true,
    [GetHashKey("oppressor2")] = true,
    --[GetHashKey("molotok")] = true,
    --[GetHashKey("havok")] = true,
    --[GetHashKey("alphaz1")] = true,
    --[GetHashKey("microlight")] = true,
    --[GetHashKey("howard")] = true,
    [GetHashKey("avenger")] = true,
    --[GetHashKey("thruster")] = true,
    [GetHashKey("volatol")] = true,
    [GetHashKey("strikeforce")] = true,
    [GetHashKey("mh6")] = true,
    [GetHashKey("mh6swat")] = true,
}

local bomb_plane_models = {
    [GetHashKey("cuban800")] = false,
    [GetHashKey("mogul")] = true,
    [GetHashKey("rogue")] = true,
    [GetHashKey("starling")] = true,
    [GetHashKey("seabreeze")] = false,
    [GetHashKey("tula")] = true,
    [GetHashKey("bombushka")] = true,
    [GetHashKey("hunter")] = true,
    [GetHashKey("avenger")] = true,
    [GetHashKey("akula")] = true,
    [GetHashKey("volatol")] = true,
}

local bomb_plane_models_cam_offset = {
    [GetHashKey("cuban800")] = vector3(0.0, 0.2, 1.0),
    [GetHashKey("mogul")] = vector3(0.0, 0.2, 0.97),
    [GetHashKey("rogue")] = vector3(0.0, 0.3, 1.10),
    [GetHashKey("starling")] = vector3(0.0, 0.25, 0.55),
    [GetHashKey("seabreeze")] = vector3(0.0, 0.2, 0.4),
    [GetHashKey("tula")] = vector3(0.0, 0.0, 1.0),
    [GetHashKey("bombushka")] = vector3(0.0, 0.3, 0.8),
    [GetHashKey("hunter")] = vector3(0.0, 0.0, 1.0),
    [GetHashKey("avenger")] = vector3(0.0, 0.0, 0.5),
    [GetHashKey("akula")] = vector3(0.0, 0.0, 0.8),
    [GetHashKey("volatol")] = vector3(0.0, 0.0, 2.0),
}

local unk_offsets = {
    [GetHashKey("cuban800")] = 0.5,
    [GetHashKey("mogul")] = 0.45,
    [GetHashKey("rogue")] = 0.46,
    [GetHashKey("starling")] = 0.55,
    [GetHashKey("seabreeze")] = 0.5,
    [GetHashKey("tula")] = 0.6,
    [GetHashKey("bombushka")] = 0.43,
    [GetHashKey("hunter")] = 0.5,
    [GetHashKey("avenger")] = 0.36,
    [GetHashKey("akula")] = 0.4,
    [GetHashKey("volatol")] = 0.54,
}

local GetOffsetFromEntityInWorldCoords <const> = GetOffsetFromEntityInWorldCoords
local ShootSingleBulletBetweenCoordsWithExtraParams <const> = ShootSingleBulletBetweenCoordsWithExtraParams
local GetEntityCoords <const> = GetEntityCoords

local function AreBombBayDoorsOpen(veh)
    return Citizen.InvokeNative(0xD0917A423314BBA8, veh) == 1
end

local _cam = 0
local function GetBombCamera()
    if not DoesCamExist(cam) then
        -- _cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
        _cam = CreateCameraWithParams(26379945, 0.0, 0.0, 0.0, -90.0, 0.0, GetEntityHeading(PlayerPedId()), 65.0, 1, 2)
    end
    return _cam
end

local function CanDropBomb(vehicle)
    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
        local model = GetEntityModel(vehicle)
        if bomb_plane_models[model] then
            --if GetVehicleMod(vehicle, 9) > -1 then
                return true
            --end
        end
    end
    return false
end

local function CanShootFlares(vehicle)
    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
        local modelVehF = GetEntityModel(vehicle)
        if flare_models[modelVehF] then
			return true
        end
    end
    return false
end

local bomb_models = {
    [1] = 1794615063, -- fire explosion
    [2] = 1430300958, -- gas explosion
    [3] = 220773539, -- cluster explosion
}

local function func_5789(veh)
    return unk_offsets[GetEntityModel(veh)]
end

local function func_5791(fParam0, fParam1, fParam2, fParam3, fParam4)
    return ((((fParam1 - fParam0) / (fParam3 - fParam2)) * (fParam4 or 0.0 - fParam2)) + fParam0)
end

local function func_5790(vParam0, vParam1, fParam2, fParam3, fParam4)
    return vector3(func_5791(vParam0.x, vParam1.x, fParam2, fParam3, fParam4), func_5791(vParam0.y, vParam1.y, fParam2, fParam3, fParam4), func_5791(vParam0.z, vParam1.z, fParam2, fParam3, fParam4))
end

local function DropBomb(pos, offset, veh)
    local bomb_model = 0
    local veh_model = GetEntityModel(veh)
    local mod_bomb_id = GetVehicleMod(veh, 9)
    if mod_bomb_id == 0 then
        if veh_model == GetHashKey("volatol") then
            bomb_model = 1856325840
        else
            bomb_model = -1695500020
        end
    elseif mod_bomb_id > 0 and mod_bomb_id < 4 then
        bomb_model = bomb_models[mod_bomb_id]
    end
    RequestModel(bomb_model)
    RequestWeaponAsset(bomb_model, 31, 26)
    while not HasWeaponAssetLoaded(bomb_model) do
        Citizen.Wait(1)
    end
    
    ShootSingleBulletBetweenCoordsWithExtraParams(pos, offset, 0, true, bomb_model, PlayerPedId(), true, true, -4.0, veh, false, false, false, true, true, false)
    PlaySoundFromEntity(-1, "bomb_deployed", veh, "DLC_SM_Bomb_Bay_Bombs_Sounds", true)
end

local function GetBombPosition(veh)
    local dimensionPos1, dimensionPos2 = GetModelDimensions(GetEntityModel(veh))
    local vVar0 = GetOffsetFromEntityInWorldCoords(veh, dimensionPos1.x, dimensionPos2.y, dimensionPos1.z)
    local vVar1 = GetOffsetFromEntityInWorldCoords(veh, dimensionPos2.x, dimensionPos2.y, dimensionPos1.z)
    local vVar2 = GetOffsetFromEntityInWorldCoords(veh, dimensionPos1.x, dimensionPos1.y, dimensionPos1.z)
    local vVar3 = GetOffsetFromEntityInWorldCoords(veh, dimensionPos2.x, dimensionPos1.y, dimensionPos1.z)
    
    local vVar4 = func_5790(vVar0, vVar1, 0.0, 1.0, 0.5)
    local vVar5 = func_5790(vVar2, vVar3, 0.0, 1.0, 0.5)
    
    vVar4 = vVar4 + vector3(0.0, 0.0, 0.4)
    vVar5 = vVar5 + vector3(0.0, 0.0, 0.4)
    
    local vVar6 = func_5790(vVar4, vVar5, 0.0, 1.0, func_5789(veh))
    
    vVar4 = vVar4 - vector3(0.0, 0.0, 0.2)
    vVar5 = vVar5 - vector3(0.0, 0.0, 0.2)
    
    local vVar7 = func_5790(vVar4, vVar5, 0.0, 1.0, (func_5789(veh) or 0.0) - 0.0001)
    
    local pos = vVar6
    local offset = vVar7
    return pos, offset
end

local sound_name <const> = "flares_released"
local sound_name2 <const> = "flares_empty"
local sound_dict <const> = "DLC_SM_Countermeasures_Sounds"
local flare_hash <const> = GetHashKey("weapon_flaregun")
local timerFlares = 1

local flaresG, BombsB = false, false
CreateThread(function()
    while true do
        Wait(1)
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local entity = GetVehiclePedIsIn(PlayerPedId(), false)
            if CanShootFlares(entity) then   
                flaresG = true             
                RequestScriptAudioBank(sound_dict)
                RequestModel(flare_hash)
                RequestWeaponAsset(flare_hash, 31, 26)
				if timerFlares == 1 then           
					if IsControlJustReleased(0, 355) then
						local pos = GetEntityCoords(entity)
						local offset1 = GetOffsetFromEntityInWorldCoords(entity, -6.0, -4.0, -0.2)
						local offset2 = GetOffsetFromEntityInWorldCoords(entity, -3.0, -4.0, -0.2)
						local offset3 = GetOffsetFromEntityInWorldCoords(entity, 6.0, -4.0, -0.2)
						local offset4 = GetOffsetFromEntityInWorldCoords(entity, 3.0, -4.0, -0.2)
						PlaySoundFromEntity(-1, sound_name, entity, sound_dict, true)
						ShootSingleBulletBetweenCoordsWithExtraParams(GetEntityCoords(entity), offset1, 0, true, flare_hash, PlayerPedId(), true, true, -4.0, entity, false, false, false, true, true, false)
						ShootSingleBulletBetweenCoordsWithExtraParams(GetEntityCoords(entity), offset2, 0, true, flare_hash, PlayerPedId(), true, true, -4.0, entity, false, false, false, true, true, false)
						ShootSingleBulletBetweenCoordsWithExtraParams(GetEntityCoords(entity), offset3, 0, true, flare_hash, PlayerPedId(), true, true, -4.0, entity, false, false, false, true, true, false)
						ShootSingleBulletBetweenCoordsWithExtraParams(GetEntityCoords(entity), offset4, 0, true, flare_hash, PlayerPedId(), true, true, -4.0, entity, false, false, false, true, true, false)
						Wait(200)
						ShootSingleBulletBetweenCoordsWithExtraParams(GetEntityCoords(entity), GetOffsetFromEntityInWorldCoords(entity, -3.0, -4.0, -0.2), 0, true, flare_hash, PlayerPedId(), true, true, -4.0, entity, false, false, false, true, true, false)
						ShootSingleBulletBetweenCoordsWithExtraParams(GetEntityCoords(entity), GetOffsetFromEntityInWorldCoords(entity, -3.0, -4.0, -0.2), 0, true, flare_hash, PlayerPedId(), true, true, -4.0, entity, false, false, false, true, true, false)
						ShootSingleBulletBetweenCoordsWithExtraParams(GetEntityCoords(entity), GetOffsetFromEntityInWorldCoords(entity, 6.0, -4.0, -0.2), 0, true, flare_hash, PlayerPedId(), true, true, -4.0, entity, false, false, false, true, true, false)
						ShootSingleBulletBetweenCoordsWithExtraParams(GetEntityCoords(entity), GetOffsetFromEntityInWorldCoords(entity, 3.0, -4.0, -0.2), 0, true, flare_hash, PlayerPedId(), true, true, -4.0, entity, false, false, false, true, true, false)
						Wait(200)
						ShootSingleBulletBetweenCoordsWithExtraParams(GetEntityCoords(entity), GetOffsetFromEntityInWorldCoords(entity, -3.0, -4.0, -0.2), 0, true, flare_hash, PlayerPedId(), true, true, -4.0, entity, false, false, false, true, true, false)
						ShootSingleBulletBetweenCoordsWithExtraParams(GetEntityCoords(entity), GetOffsetFromEntityInWorldCoords(entity, -3.0, -4.0, -0.2), 0, true, flare_hash, PlayerPedId(), true, true, -4.0, entity, false, false, false, true, true, false)
						ShootSingleBulletBetweenCoordsWithExtraParams(GetEntityCoords(entity), GetOffsetFromEntityInWorldCoords(entity, 6.0, -4.0, -0.2), 0, true, flare_hash, PlayerPedId(), true, true, -4.0, entity, false, false, false, true, true, false)
						ShootSingleBulletBetweenCoordsWithExtraParams(GetEntityCoords(entity), GetOffsetFromEntityInWorldCoords(entity, 3.0, -4.0, -0.2), 0, true, flare_hash, PlayerPedId(), true, true, -4.0, entity, false, false, false, true, true, false)
						timerFlares = 2
						Wait(10000)
						timerFlares = 1
					end
				end
            else
                flaresG = false
            end
            if CanDropBomb(entity) then
                SetVehicleMod(entity, 9, 1)
                BombsB = true
                RequestScriptAudioBank(sound_dict)
                local veh = entity
                if IsControlPressed(0, 83) then
                    local toggle = true
                    local timer = GetGameTimer()
                    if toggle then
                        if AreBombBayDoorsOpen(veh) then
                            CloseBombBayDoors(veh)
                            
                            ClearPedTasks(PlayerPedId())
                            
                            StopAudioScene("DLC_SM_Bomb_Bay_View_Scene")
                            
                            SetCamActive(GetBombCamera(), false)
                            RenderScriptCams(false, false, 0, false, false)
                            DestroyCam(GetBombCamera(), false)
                            DestroyAllCams(true)
                        else
                            OpenBombBayDoors(veh)
                            
                            SetCamActive(GetBombCamera(), true)
                            local p = GetBombPosition(veh)
                            local pOff = GetOffsetFromEntityGivenWorldCoords(veh, p.x, p.y, p.z) + bomb_plane_models_cam_offset[GetEntityModel(veh)]
                            AttachCamToEntity(GetBombCamera(), veh, pOff, true)
                            
                            RenderScriptCams(true, false, 0, false, false)
                            local target_pos = GetOffsetFromEntityInWorldCoords(veh, 0.0, 10000.0, 0.0)
                            if IsThisModelAPlane(GetEntityModel(veh)) then
                                TaskPlaneMission(PlayerPedId(), veh, 0, 0, target_pos, 4, 30.0, 0.1, GetEntityHeading(veh), 30.0, 20.0)
                            end
                            StartAudioScene("DLC_SM_Bomb_Bay_View_Scene")
                            N_0xad2d28a1afdff131(veh, 0.0) -- SetPlaneTurbulenceMultiplier()
                            -- BRAIN::TASK_PLANE_MISSION(PLAYER::PLAYER_PED_ID(), iParam0, 0, 0, vLocal_12678.x, vLocal_12678.y, vVar1.z, 4, 50f, 0.1f, -1f, 30, 20, 1);
                        end
                    end
                end
                while IsControlPressed(0, 83) do
                    Citizen.Wait(0)
                end
                if AreBombBayDoorsOpen(veh) then
                    DisableControlAction(0, 114)
                    if IsControlJustReleased(0, 255) then
                        local pos, offset = GetBombPosition(veh)
                        DropBomb(pos, offset, veh)
                        local tmp_timer = GetGameTimer()
                        while GetGameTimer() - tmp_timer < 300 do
                            Citizen.Wait(0)
                            DisableControlAction(0, 114)
                            if IsControlJustReleased(0, 255) then
                                PlaySoundFromEntity(-1, "chaff_cooldown", veh, "DLC_SM_Countermeasures_Sounds", true)
                            end
                        end
                    end
                else
                    if not IsGameplayCamRendering() then
                        SetCamActive(GetBombCamera(), false)
                        RenderScriptCams(false, false, 0, false, false)
                        DestroyCam(GetBombCamera(), false)
                        DestroyAllCams(true)
                        ClearFocus()
                    end
                end
            else
                BombsB = false
            end
            if not flaresG and not BombsB then
                Wait(5000)
                HelpShown = false
                if HasModelLoaded(flare_hash) then
                    SetModelAsNoLongerNeeded(flare_hash)
                end
            end
        else
			Wait(5000)
            if HasModelLoaded(flare_hash) then
                SetModelAsNoLongerNeeded(flare_hash)
            end
        end
    end
end)
