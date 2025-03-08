local TimeBlock = 900
local lastvehicle = nil
local AllVehsToBlock = {}
local FirstSpawn = false
local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

CreateThread(function()
    while true do 
        Wait(1000)
        if FirstSpawn then
            TimeBlock = TimeBlock - 1
            if TimeBlock < 0 then 
                FirstSpawn = false
            end
        else
            Wait(5000)
        end
    end
end)

CreateThread(function()
    while true do 
        Wait(20000 + math.random(1111, 9999))
        if FirstSpawn then
            TriggerServerEvent("core:antiTroll:saveTime", token, TimeBlock)
        else
            Wait(60000)
        end
    end
end)

ItsMyFirstSpawn = function()
	if p:getPermission() == 0 then
        FirstSpawn = true
    end
end

GetItsMyFirstSpawn = function()
    return FirstSpawn
end

RegisterNetEvent("core:antiTroll:storeVeh", function(veh)
    table.insert(AllVehsToBlock, NetToVeh(veh))
end)

RegisterNetEvent("core:antiTroll:storeAllVeh", function(vehs)
    for k,v in pairs(vehs) do 
        if v then 
            table.insert(AllVehsToBlock, NetToVeh(v))
        end
    end
end)

CreateThread(function()
    while not p do Wait(1) end
    while not NetworkIsSessionStarted() do Wait(1) end
    local time = TriggerServerCallback("core:antiTroll:getMyTime")
    TimeBlock = time ~= nil and time or TimeBlock
    while true do 
        Wait(500)
        if IsPedOnFoot(PlayerPedId()) then
            for k,v in pairs(AllVehsToBlock) do 
                local vehicles, dist = GetClosestVehicle(p:pos())
                if vehicles == v and dist < 10.0 then 
                    SetEntityNoCollisionEntity(vehicles, PlayerPedId())
                end
            end
        else
            Wait(1000)
        end
    end
end)

CreateThread(function()
    if FirstSpawn then
        exports['aHUD']:toggleLimitedActions(true)
    end

    while true do 
        Wait(1)
        if FirstSpawn then
            --DrawSpecialText("Actions limitées", tostring(disp_time(TimeBlock)), 1, 0.025)
            --DisableControlAction(0, 24, true) -- ça désactive le menu contextuel (²)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            if IsPedInAnyVehicle(PlayerPedId()) then 
                --local player, dst = GetClosestPlayer()
                --if dst ~= nil and dst <= 10.0 then
                --    SetEntityNoCollisionEntity(GetPlayerPed(player), GetVehiclePedIsIn(PlayerPedId()), true)
                --end
                if IsEntityAMissionEntity(GetVehiclePedIsIn(PlayerPedId())) then
                    if GetVehiclePedIsIn(PlayerPedId()) ~= lastvehicle then 
                        lastvehicle = GetVehiclePedIsIn(PlayerPedId())
                        if lastvehicle and IsEntityAMissionEntity(lastvehicle) and NetworkGetEntityIsNetworked(lastvehicle) then -- exist for everyone ? and networked ?
                            TriggerServerEvent("core:antiTroll:storeVeh", VehToNet(lastvehicle))
                        end
                    end
                end
            end
        else
            Wait(10000)
        end
    end
end)

function disp_time(time)
    local hours = math.floor(math.fmod(time, 86400)/3600)
    local minutes = math.floor(math.fmod(time,3600)/60)
    local seconds = math.floor(math.fmod(time,60))
    return hours .. ":" .. minutes .. ":" .. seconds
end

function DrawSpecialText(title, barPosition, addLeft)
    if not addLeft then addLeft = 0; end
    RequestStreamedTextureDict("timerbars");
    if not HasStreamedTextureDictLoaded("timerbars") then return; end
    local x = 1.0 - (1.0 - GetSafeZoneSize()) * 0.5 - 0.180 / 2;
    local y = 1.0 - (1.0 - GetSafeZoneSize()) * 0.5 - 0.045 / 2 - (barPosition - 1) * (0.045 + 0);
    DrawSprite("timerbars", "all_black_bg", x, y, 0.180, 0.045, 0.0, 255, 255, 255, 160);
    showText({msg = title, font = 0, size = 0.36, posx = 0.840, posy = y/1.014, shadow = false});
    -- showText({msg = title, font = 0, size = 0.32, posx = 0.830, posy = y/1.014, shadow = false});
    -- showText({msg = textreight, font = 0, size = 0.5, posx = 0.950-addLeft, posy = y/1.020, shadow = false});
end
function showText(args)
    args.shadow = args.shadow or true;
    args.font = args.font or 6;
    args.size = args.size or 0.50;
    args.posx = args.posx or 0.5;
    args.posy = args.posy or 0.4;
    args.msg = args.msg or "";

    SetTextFont(args.font) 
    SetTextProportional(0) 
    SetTextScale(args.size, args.size) 
    if args.shadow == true then
        SetTextDropShadow(0, 0, 0, 0,255) 
        SetTextEdge(1, 0, 0, 0, 255)
    end
    SetTextEntry("STRING") 
    AddTextComponentString(args.msg);
    DrawText(args.posx, args.posy);
end