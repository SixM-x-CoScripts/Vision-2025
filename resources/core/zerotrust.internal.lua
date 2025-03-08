originSetEntityCoords = SetEntityCoords
originSetPedIntoVehicle = SetPedIntoVehicle
originTaskWarpPedIntoVehicle = TaskWarpPedIntoVehicle
originSetEntityCoordsNoOffset = SetEntityCoordsNoOffset
originNetworkResurrectLocalPlayer = NetworkResurrectLocalPlayer
originTaskVehicleTempAction = TaskVehicleTempAction

bypassAntiTeleport = false
function setBypassAntiTeleport(active)
    bypassAntiTeleport = active
end

function SetEntityCoords(ped, ...)
    if ped == PlayerPedId() then
        setBypassAntiTeleport(true)
        SetTimeout(3*1000, function()
            setBypassAntiTeleport(false)
        end)
        Wait(50)
    end
    return originSetEntityCoords(ped, ...)
end

function SetEntityCoordsNoOffset(ped, ...)
    if ped == PlayerPedId() then
        setBypassAntiTeleport(true)
        SetTimeout(3*1000, function()
            setBypassAntiTeleport(false)
        end)
        Wait(50)
    end
    return originSetEntityCoordsNoOffset(ped, ...)
end

function TaskVehicleTempAction(...)
    if not bypassAntiTeleport then
        setBypassAntiTeleport(true)
        SetTimeout(3*1000, function()
            setBypassAntiTeleport(false)
        end)
        Wait(50)
    end
    return originTaskVehicleTempAction(...)
end

function SetPedIntoVehicle(ped, vehicle, ...)
    if ped == PlayerPedId() then
        setBypassAntiTeleport(true)
        SetTimeout(3*1000, function()
            setBypassAntiTeleport(false)
        end)
        Wait(50)
    end
    return originSetPedIntoVehicle(ped, vehicle, ...)
end

function NetworkResurrectLocalPlayer(...)
    setBypassAntiTeleport(true)
    SetTimeout(3*1000, function()
        setBypassAntiTeleport(false)
    end)
    Wait(50)
    return originNetworkResurrectLocalPlayer(...)
end

function TaskWarpPedIntoVehicle(ped, vehicle, ...)
    if ped == PlayerPedId() then
        setBypassAntiTeleport(true)
        SetTimeout(3*1000, function()
            setBypassAntiTeleport(false)
        end)
        Wait(50)
    end
    return originTaskWarpPedIntoVehicle(ped, vehicle, ...)
end

function IsPedInParachute(playerPed)
    return GetPedParachuteState(playerPed) ~= -1
end

local sentToDisc = {}

local lastPlayerCoords2 = nil
-- Citizen.CreateThread(function()
--     while not p do Wait(1) end
--     Wait(5*1000)
--     while true do
--         local playerPed = PlayerPedId()
--         local currentCoords = GetEntityCoords(playerPed)

--         if p:getPermission() < 1 then
--             if lastPlayerCoords2 then
--                 if not IsCutsceneActive() then
--                     if (not IsScreenFadedOut()) and (not IsScreenFadingOut()) and (not IsScreenFadedIn()) and (not IsScreenFadingOut()) then
--                         if not bypassAntiTeleport then
--                             if (#(lastPlayerCoords2 - currentCoords) > 2.60) and (not IsPedInAnyVehicle(playerPed)) and (not IsPedRagdoll(playerPed)) and (not IsPedFalling(playerPed)) and (not IsPedInParachute(playerPed)) then
--                                 local bypassServer = LocalPlayer.state.bAT or false
                                
--                                 if not bypassServer then
--                                     originSetEntityCoords(playerPed, lastPlayerCoords2.x, lastPlayerCoords2.y, lastPlayerCoords2.z-1.0)
--                                     --if not sentToDisc["setEntity"] then 
--                                     --    sentToDisc["setEntity"] = true
--                                     --    TriggerServerEvent("zt:detectkick", "Detected Teleport", "AntiSpeedhack")
--                                     --end
--                                     goto skip
--                                 end
--                             --elseif (IsPedInAnyVehicle(playerPed)) and (#(lastPlayerCoords2 - currentCoords) > 15.0) and (NetworkGetEntityOwner(GetVehiclePedIsIn(playerPed)) == PlayerId()) and (GetPedInVehicleSeat(GetVehiclePedIsIn(playerPed), -1) == PlayerPedId()) then
--                             --    local bypassServer = LocalPlayer.state.bAT or false
--                             --    
--                             --    if not bypassServer then
--                             --        originSetPedIntoVehicle(playerPed, GetVehiclePedIsIn(playerPed), -1)
--                             --        originSetEntityCoords(GetVehiclePedIsIn(playerPed), lastPlayerCoords2.x, lastPlayerCoords2.y, lastPlayerCoords2.z-1.0)
--                             --        if not sentToDisc["setVehi"] then 
--                             --            sentToDisc["setVehi"] = true
--                             --            TriggerServerEvent("zt:detectkick", "Detected Teleport in vehicle", "AntiSpeedhack")
--                             --        end
--                             --        goto skip
--                             --    end
--                             end
--                         end
--                         lastPlayerCoords2 = currentCoords
--                     end
--                 end
--             else
--                 lastPlayerCoords2 = currentCoords
--             end
--         end
--         ::skip::
--         Wait(1)
--     end
-- end)

function SetPedCoords(ped, ...)
    if ped == PlayerPedId() then
        setBypassAntiTeleport(true)
        SetTimeout(3*1000, function()
            setBypassAntiTeleport(false)
        end)
        Wait(50)
    end
    return SetEntityCoords(ped, ...)
end

exports("SetPedCoords", SetPedCoords)