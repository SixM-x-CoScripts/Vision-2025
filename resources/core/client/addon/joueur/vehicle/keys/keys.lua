local pKeys = {}
local pVehKeys = {}
local pJobVeh = {}
local token = nil
StoredVehsLocation = {}

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function DoesPlayerHaveKey(type)
    if pKeys[type] ~= nil then
        return true
    else
        return false
    end
end

function DoesPlayerHaveVehicleKey(type)
    if pVehKeys[type] ~= nil then
        return true
    else
        return false
    end
end

RegisterNetEvent("core:RefreshPlayerKey")
AddEventHandler("core:RefreshPlayerKey", function(vKeys, keys)
    pVehKeys = vKeys
    pKeys = keys
end)


RegisterNetEvent("core:RefreshPlayerJobCar")
AddEventHandler("core:RefreshPlayerJobCar", function(plates)
    pJobVeh = plates
end)

-- CreateThread(function()
--     local platess = TriggerServerCallback("core:GetPlayerJobCar")
--     pJobVeh = platess
-- end)

-- CreateThread(function()
--     while p == nil do Wait(1) end
--     while true do
--         local vehicle, dist = GetClosestVehicle(p:pos())
--         print(pVehKeys, pKeys)

--         while #(p:pos() - dist) <= 10 do

--             Wait(1)
--         end

--         Wait(500)

--     end
-- end)

local function VehicleLights(vehicle)
    Wait(200)
    SetVehicleLights(vehicle, 2)
    Wait(200)
    SetVehicleLights(vehicle, 0)
    Wait(200)
    SetVehicleLights(vehicle, 2)
    Wait(200)
    SetVehicleLights(vehicle, 0)
    Wait(200)
    SetVehicleLights(vehicle, 2)
    Wait(200)
    SetVehicleLights(vehicle, 0)
end
local antiSpam = false
Keys.Register("U", "U", "Ouvrir/Fermer véhicule", function()
    if antiSpam then
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Attendez 2 secondes !"
        })
    else
        antiSpam = true
        local vehicles, dist = GetClosestVehicle(p:pos())
        if dist <= 10 then
            useKey(vehicles)
        end
        SetTimeout(2000, function()
            antiSpam = false
        end)
    end
end)

function useKey(vehicles)
    local plate = vehicle.getProps(vehicles).plate
    local datas = TriggerServerCallback("core:getInfoKeys", plate)
    local isJobCar = false
    local isOwner = false
    plateOrigin = datas.plateOrigin
    isJobCar = datas.isjob
    isOwner = datas.owner
    --print("isJobCar, isOwner, plateOrigin", isJobCar, isOwner, plateOrigin)
    print("datas", json.encode(datas))
    if plateOrigin == nil then print("erreur avec une plaque ouvrez un ticket pour prestor le bg") end
    local haveKeys = false

    if isOwner then
        for k, v in pairs(p:getInventaire()) do
            if v.name == "keys" then
                if v.metadatas.plate == plateOrigin then haveKeys = true break end
            end
        end
        if next(StoredVehsLocation) then
            for k,v in pairs(StoredVehsLocation) do
                if v == plateOrigin then haveKeys = true break end
            end
        end
    end
    if (haveKeys and isOwner) or (isJobCar) then
        NetworkRequestControlOfEntity(vehicles)
        local timeout = 2000
        while timeout > 0 and not NetworkHasControlOfEntity(vehicles) do
            Wait(100)
            timeout = timeout - 100
        end
        if GetVehicleDoorLockStatus(vehicles) == 2 then
            RequestAnimDict("anim@mp_player_intmenu@key_fob@")
            while not HasAnimDictLoaded("anim@mp_player_intmenu@key_fob@") do
                Wait(1)
            end
            TaskPlayAnim(PlayerPedId(), "anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, 8.0, -1, 48, 1,
                false, false, false)
            SetVehicleDoorsLocked(vehicles, 0)
            PlayVehicleDoorCloseSound(vehicles, 1)
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Véhicule ~s déverrouillé."
            })

            VehicleLights(vehicles)
        elseif GetVehicleDoorLockStatus(vehicles) == 0 then
            RequestAnimDict("anim@mp_player_intmenu@key_fob@")
            while not HasAnimDictLoaded("anim@mp_player_intmenu@key_fob@") do
                Wait(1)
            end
            TaskPlayAnim(PlayerPedId(), "anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, 8.0, -1, 48, 1,
                false, false, false)
            SetVehicleDoorsLocked(vehicles, 2)
            PlayVehicleDoorCloseSound(vehicles, 1)
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Véhicule ~s verrouillé."
            })

            VehicleLights(vehicles)
        end
    else
        if haveKeys and not isOwner then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "~s Vous n'êtes pas proprietaire"
            })
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "~s Vous n'avez pas les clés"
            })
        end
    end
end

-- RegisterCommand('fourriere', function()
--     local veh = TriggerServerCallback("core:GetVehicles")
--     local vehicle, dist = GetClosestVehicle(p:pos())

--     if dist <= 10 then
--         local plates = all_trim(GetVehicleNumberPlateText(vehicle))
--         if pVehKeys[tostring(plates)] ~= nil and pVehKeys[tostring(plates)] == true then
--             TaskStartScenarioInPlace(p:ped(), "WORLD_HUMAN_CLIPBOARD", -1, true)
--             SendNuiMessage(json.encode({
--                 type = 'openWebview',
--                 name = 'Progressbar',
--                 data = {
--                     text = "Mise en fourrière...",
--                     time = 7
--                 }
--             }))
--             Modules.UI.RealWait(7000)
--             ClearPedTasksImmediately(p:ped())
--             TriggerServerEvent("DeleteEntity", token, {VehToNet(vehicle)})
--             TriggerServerEvent("police:SetVehicleInFourriere", token, all_trim(GetVehicleNumberPlateText(vehicle)),
--                 VehToNet(vehicle))

--         else
--             ShowNotification("Ce n'est pas votre véhicule")

                -- New notif
--[[                 exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Ce n'est pas votre véhicule"
                }) ]]

--         end
--     end
-- end)
