-- Au cas ou un jour 
local ChichaPos = vector3(-1177.9136962891, -179.33055114746, 74.766883850098)
local ChichaPosCayo = vector3(4903.5463867188, -4945.076171875, 2.3947477340698)
local ChichaModel = 4037417364

local TableChicha = {
    {
        model = -516909923, -- Table Cayo
        offset = vector3(0.0, 0.0, 0.5)
    }
}

local MyChicha
local TubeObj

local function ChichaAnimCarry()
	local ped = PlayerPedId()
	local ad = "anim@heists@humane_labs@finale@keycards"
	local anim = "ped_a_enter_loop"
	while (not HasAnimDictLoaded(ad)) do
		RequestAnimDict(ad)
	    Wait(1)
	end
	TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)
end

RegisterNetEvent("core:usechciha", function()
    if not MyChicha then
        RequestModel(ChichaModel)
        while not HasModelLoaded(ChichaModel) do Wait(1) end
        local obj = entity:CreateObject(ChichaModel, GetEntityCoords(PlayerPedId())).id
        SetEntityAsMissionEntity(obj, true, true)
        NetworkRegisterEntityAsNetworked(obj)
        SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(obj), true)
        SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(obj), true)
        FreezeEntityPosition(obj, true)
        MyChicha = obj
        AttachEntityToEntity(obj, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 24818), -0.15, 0.2, 0.18, 0.0, 90.0, 0.0, true, true, false, true, 1, true)
        ChichaAnimCarry()
        Wait(100)
    else
        ClearPedTasks(PlayerPedId())
        DeleteEntity(MyChicha)
        MyChicha = nil
    end
end)

CreateThread(function()
    while not p do Wait(1) end
    local closeToTable = false
    while true do 
        Wait(1)
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), ChichaPos) < 75.5 or GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), ChichaPosCayo) < 30.5 then 
            if p and p:getJob() == "skyblue" then 
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), ChichaPos) < 2.5 or GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), ChichaPosCayo) < 2.5 then
                    if not MyChicha then
                        ShowHelpNotification("~INPUT_PICKUP~ Prendre une chicha")
                    else
                        ShowHelpNotification("~INPUT_PICKUP~ Ranger la chicha")
                    end
                    if IsControlJustPressed(0,38) then 
                        if not MyChicha then
                            RequestModel(ChichaModel)
                            while not HasModelLoaded(ChichaModel) do Wait(1) end
                            local obj = entity:CreateObject(ChichaModel, GetEntityCoords(PlayerPedId())).id
                            SetEntityAsMissionEntity(obj, true, true)
                            NetworkRegisterEntityAsNetworked(obj)
                            SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(obj), true)
                            SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(obj), true)
                            FreezeEntityPosition(obj, true)
                            MyChicha = obj
                            AttachEntityToEntity(obj, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 24818), -0.15, 0.2, 0.18, 0.0, 90.0, 0.0, true, true, false, true, 1, true)
                            ChichaAnimCarry()
                            Wait(100)
                        else
                            ClearPedTasks(PlayerPedId())
                            DeleteEntity(MyChicha)
                            MyChicha = nil
                            Wait(100)
                        end
                    end
                end
            end

            if MyChicha then 
                for k,v in pairs(Masalar) do 
                    local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.coords)
                    if dist < 2.0 then 
                        ShowHelpNotification("~INPUT_PICKUP~ Mettre la chicha sur la table")
                        if IsControlJustPressed(0, 38) then
                            PoseLaChichaTable(v.coords)
                            Wait(300)
                        end
                    end
                end
                for k,v in pairs(TableChicha) do 
                    local TableOjb = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 2.0, v.model, true)
                    local coordsTable = GetEntityCoords(TableOjb) + v.offset
                    if TableOjb ~= 0 then 
                        ShowHelpNotification("~INPUT_PICKUP~ Mettre la chicha sur la table")
                        if IsControlJustPressed(0, 38) then
                            PoseLaChichaTable(coordsTable)
                            Wait(300)
                        end
                    end
                end
            end

            local closestChicha = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.9, ChichaModel, true)
            if closestChicha ~= 0 then 
                -- Car si attaché on fume pas lol
                if not IsEntityAttached(closestChicha) then 
                    -- Donc la chicha est posé sur la table logiquement
                    if p:getJob() == "skyblue" then
                        ShowHelpNotification("~INPUT_PICKUP~ Prendre la chicha\n~INPUT_ENTER~ Fumer")
                        -- Prendre la chicha
                        if IsControlJustReleased(0, 38) then
                            TakeChichaFromTable(closestChicha)
                        end
                    else
                        ShowHelpNotification("~INPUT_ENTER~ Fumer")
                    end
                    -- Fumer
                    if IsControlJustReleased(0, 23) then
                        ChichaAnimCarry()
                        local playerPed  = PlayerPedId()
                        local coords     = GetEntityCoords(playerPed)
                        local boneIndex  = GetPedBoneIndex(playerPed, 12844)
                        local boneIndex2 = GetPedBoneIndex(playerPed, 24818)
                        local model      = GetHashKey('v_corp_lngestoolfd')
                        RequestModel(model)
                        while not HasModelLoaded(model) do
                            Wait(100)
                        end
                        TubeObj = entity:CreateObject(model, vector3(coords.x+0.5, coords.y+0.1, coords.z+0.4)).id
                        SetEntityAsMissionEntity(TubeObj, true, true)
                        AttachEntityToEntity(TubeObj, playerPed, boneIndex2, -0.43, 0.68, 0.18, 0.0, 90.0, 90.0, true, true, false, true, 1, true)
                        Wait(700)
                        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
                        TriggerServerEvent("hookah_smokes", PedToNet(PlayerPedId()), x,y,z)   
                        Wait(2000)
                        if TubeObj then 
                            --ClearPedTasks(PlayerPedId())
                            local ad = "anim@heists@humane_labs@finale@keycards"
                            local anim = "ped_a_enter_loop"
                            StopAnimTask(PlayerPedId(), ad, anim, 1.0)
                            DeleteEntity(TubeObj)
                            TubeObj = nil
                        end
                    end
                end
            end
        else
            for k,v in pairs(TableChicha) do 
                local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.coords)
                if dist < 9.0 then 
                    closeToTable = true
                end
            end
            if not closeToTable then
                Wait(1500)
            end
        end
    end
end)

function TakeChichaFromTable(closestChicha)
    NetworkRequestControlOfEntity(closestChicha)
    while not NetworkHasControlOfEntity(closestChicha) do Wait(1) end
    DeleteEntity(closestChicha)
    RequestModel(ChichaModel)
    while not HasModelLoaded(ChichaModel) do Wait(1) end
    local obj = entity:CreateObject(ChichaModel, GetEntityCoords(PlayerPedId())).id
    SetEntityAsMissionEntity(obj, true, true)
    NetworkRegisterEntityAsNetworked(obj)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(obj), true)
    SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(obj), true)
    FreezeEntityPosition(obj, true)
    local boneIndex2 = GetPedBoneIndex(PlayerPedId(), 24818)
    MyChicha = obj
    ChichaAnimCarry()
    AttachEntityToEntity(obj, PlayerPedId(), boneIndex2, -0.15, 0.2, 0.18, 0.0, 90.0, 0.0, true, true, false, true, 1, true)
    if TubeObj then 
        DeleteEntity(TubeObj)
        TubeObj = nil
    end
end

function PoseLaChichaTable(coord)
    DetachEntity(MyChicha, true)
    DeleteEntity(MyChicha)
    MyChicha = nil 
    local obj = entity:CreateObject(ChichaModel, coord).id
    SetEntityAsMissionEntity(obj, true, true)
    NetworkRegisterEntityAsNetworked(obj)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(obj), true)
    SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(obj), true)
	FreezeEntityPosition(obj, true)
    ClearPedTasks(PlayerPedId())
end


function showLoopParticle(dict, particleName, coords, scale, time)
	RequestNamedPtfxAsset(dict)
	while not HasNamedPtfxAssetLoaded(dict) do
		Citizen.Wait(0)
	end
	UseParticleFxAssetNextCall(dict)
	local particleHandle = StartParticleFxLoopedAtCoord(particleName, coords, 0.0, 0.0, 0.0, scale, false, false, false)
	SetParticleFxLoopedColour(particleHandle, 0, 255, 0 ,0)
	Citizen.Wait(time)
	StopParticleFxLooped(particleHandle, false)
	return particleHandle
end

RegisterNetEvent("c_hookah_smokes")
AddEventHandler("c_hookah_smokes", function(c_ped, x,y,z)
	local p_smoke_location = {
		20279,
	}
	local p_smoke_particle_asset = "scr_agencyheistb" 
	local p_smoke_particle = "scr_agency3b_elec_box"

	for _,bones in pairs(p_smoke_location) do
		if DoesEntityExist(NetToPed(c_ped)) and not IsEntityDead(NetToPed(c_ped)) then
			--createdSmoke = UseParticleFxAssetNextCall(p_smoke_particle_asset)
			--createdPart = StartNetworkedParticleFxLoopedOnEntityBone(p_smoke_particle, NetToPed(c_ped), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(NetToPed(c_ped), bones), 5.0, 0.0, 0.0, 0.0)
            --local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
            craetedSmoke = showLoopParticle(p_smoke_particle_asset, p_smoke_particle, vector3(x,y,z+0.9), 3.5, 5000)            
            --Wait(1000)
			----Wait(250)
			--Wait(1000)
            --SetParticleFxLoopedScale(createdPart, 0.5)
            --SetParticleFxLoopedAlpha(createdPart, 155)
			--Wait(1000)
            --SetParticleFxLoopedScale(createdPart, 0.2)
            --SetParticleFxLoopedAlpha(createdPart, 90)
			--Wait(250)
            --SetParticleFxLoopedAlpha(createdPart, 40)
			--Wait(250)
            Wait(5000)
			StopParticleFxLooped(createdSmoke, 1)
			RemoveParticleFxFromEntity(NetToPed(c_ped))
			break
		end
	end
end)