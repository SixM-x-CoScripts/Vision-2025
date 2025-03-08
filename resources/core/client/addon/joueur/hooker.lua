local hookers = {
    GetHashKey("s_f_y_hooker_01"),
    GetHashKey("s_f_y_hooker_02"),
    GetHashKey("s_f_y_hooker_03"),
    GetHashKey("mp_f_deadhooker")
}

local function tableHasValue(tbl, value, k)
	if not tbl or not value or type(tbl) ~= "table" then return end
	for _,v in pairs(tbl) do
		if k and v[k] == value or v == value then return true, _ end
	end
end
local function LoadAnim(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(110)
    end
    return true
end

local sefaissucer = false

local function CumEffect()
    AnimpostfxPlay("DrugsMichaelAliensFightIn", 100000, true)
    Wait(2000)
    DoScreenFadeOut(500)
    Wait(800)
    AnimpostfxPlay('DrugsMichaelAliensFightOut',1000,true)
    Wait(1000)
    AnimpostfxStop("DrugsMichaelAliensFightIn")
    Wait(100)
    DoScreenFadeIn(500)
end

local function DoFuncHook(ped)
    while true do 
        Wait(1)
        if IsPedInAnyVehicle(PlayerPedId()) then
            if GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) < 5.0 then 
                if IsPedInAnyVehicle(ped) then
                    if not sefaissucer then
                        ShowHelpNotification("~INPUT_DETONATE~ Vous faire sucer (~g~200$~s~)\n~INPUT_RELOAD~ Terminer avec la prostitué")
                    else
                        ShowHelpNotification("~INPUT_DETONATE~ Vous faire sucer (~g~200$~s~)\n~INPUT_SPECIAL_ABILITY_SECONDARY~ Arreter de se faire sucer")
                    end
                    if IsControlJustPressed(0, 45) then 
                        TaskLeaveVehicle(ped, GetVehiclePedIsIn(PlayerPedId()), 0)
                    -- SetBlockingOfNonTemporaryEvents(ped, false)
                        SetEntityAsNoLongerNeeded(ped)
                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            -- duration = 5, -- In seconds, default:  4
                            content = "La prostitué s'en va"
                        })  
                        break
                    end
                    if IsControlJustPressed(0, 47) then 
                        if p:pay(200) then
                            sefaissucer = true
                            LoadAnim('oddjobs@towing')
                            TaskPlayAnim(PlayerPedId(), "oddjobs@towing", "m_blow_job_loop", 8.0, 8.0, -1, 1, 1, false, false, false)
                            TaskPlayAnim(ped, "oddjobs@towing", "f_blow_job_loop", 8.0, 8.0, -1, 1, 1, false, false, false)
                            Wait(math.random(10000, 60000))
                            CumEffect()
                            exports['vNotif']:createNotification({
                                type = 'VERT',
                                -- duration = 5, -- In seconds, default:  4
                                content = math.random(1,5) == 2 and "Vous avez joui" or "Vous avez apprecié votre moment"
                            })  
                            ClearPedTasks(PlayerPedId())
                            ClearPedTasks(ped)
                            sefaissucer = false
                        end
                    end
                end
            else
                ShowHelpNotification("Allez dans un coin discret")
            end
        else
            TaskLeaveVehicle(ped, GetVehiclePedIsIn(PlayerPedId()), 0)
           -- SetBlockingOfNonTemporaryEvents(ped, false)
            SetEntityAsNoLongerNeeded(ped)
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "La prostitué s'en va"
            })  
            break
        end
    end
end

CreateThread(function()
    while true do 
        Wait(1)
        local hour = GetClockHours()
        if hour >= 0 and hour < 6 then 
            if IsPedInAnyVehicle(PlayerPedId()) then 
                local handle, ped = FindFirstPed()
                repeat
                    success, ped = FindNextPed(handle)
                    local entitymodel = GetEntityModel(ped)
                    if tableHasValue(hookers, entitymodel) then
                        local pos = GetEntityCoords(ped)
                        local PlyPos = GetEntityCoords(PlayerPedId())
                        local distance = Vdist2(pos.x, pos.y, pos.z, PlyPos.x, PlyPos.y, PlyPos.z)
                        if distance < 7.0 and not IsPedInAnyVehicle(ped) then
                            if IsHornActive(GetVehiclePedIsIn(PlayerPedId())) then 
                                NetworkRegisterEntityAsNetworked(ObjToNet(ped))
                                NetworkRequestControlOfEntity(ped)
                                Wait(300)
                                SetBlockingOfNonTemporaryEvents(ped, true)
                                TaskEnterVehicle(ped, GetVehiclePedIsIn(PlayerPedId()), 1.5, 0, 1.0, 1, 0)
                                DoFuncHook(ped)
                            end
                        end
                    end
                until not success
                EndFindPed(handle)
            else
                Wait(2000)
            end
        else
            Wait(5000)
        end
    end
end)