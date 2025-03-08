local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local closetDoors = {}
local doorsInRange = {}
local doorList = {}


Citizen.CreateThread(function()
    while not loaded do Wait(1) end
    while p == nil do Wait(1) end
    while true do
        local pCoords = p:pos()

        for k, v in pairs(doorList) do
            local dst = #(v.coords.xyz - pCoords)

            if dst < v.distance then
                closetDoors[k] = v
            else
                if closetDoors[k] ~= nil then
                    closetDoors[k] = nil
                end

                if dst <= 50.0 then
                    doorsInRange[k] = v
                else
                    if doorsInRange[k] ~= nil then
                        doorsInRange[k] = nil
                    end
                end
            end
        end

        Wait(500)
    end
end)

local function IsJobTheSame(job)
    local myjob = p:getJob()
    if type(job) == "string" then
        if myjob == job then
            return true
        end
    elseif type(job) == "table" then
        if job[myjob] then 
            return true
        end
    end
    return false
end

Citizen.CreateThread(function()
    while true do
        local count = 0

        for k, v in pairs(closetDoors) do
            if #(p:pos() - v.coords.xyz) < v.distance then
                DrawLine(p:pos(), vector3(v.coords.x, v.coords.y, v.coords.z + 0.5), 255, 255, 255, 170);
                if v.lockStatus then
                    Modules.UI.Draw3DText(v.coords.x, v.coords.y, v.coords.z + 0.5, "~r~Fermée~s~", 4, 0.03, 0.03)
                else
                    Modules.UI.Draw3DText(v.coords.x, v.coords.y, v.coords.z + 0.5, "~g~Ouvert~s~", 4, 0.03, 0.03)
                end
                if IsControlJustPressed(0, 38) and (IsJobTheSame(v.job) or p:getPermission() > 5) then
                    local players = {}
                    for k,v in pairs(GetActivePlayers()) do 
                        table.insert(players, GetPlayerServerId(v))
                    end
                    TriggerServerEvent("core:ChangeDoorState", token, k, not v.lockStatus, players)
                elseif IsControlJustPressed(0, 38) and (p:getCrew() == v.crew or p:getPermission() > 5) then
                    local players = {}
                    for k,v in pairs(GetActivePlayers()) do 
                        table.insert(players, GetPlayerServerId(v))
                    end
                    TriggerServerEvent("core:ChangeDoorState", token, k, not v.lockStatus, players)
                end
                count = count + 1
            end

        end

        if count ~= 0 then
            Wait(1)
        else
            Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do

        for k, v in pairs(doorsInRange) do
            local entity = GetClosestObjectOfType(v.coords.xyz, 5.0, v.model, false, 0, 0)
            if v.lockStatus then
                SetEntityHeading(entity, v.coords.w)
                FreezeEntityPosition(entity, true)
            else
                FreezeEntityPosition(entity, false)
            end
        end

        Wait(1500)
    end
end)

-- Init doors
Citizen.CreateThread(function()
    doorList = doors
end)

-- Functions

function changeDoorLockStatus(door, state)
    if #(doorList[door].coords.xyz - p:pos()) < 2.5 then

        local entity = GetClosestObjectOfType(doorList[door].coords.xyz, 5.0, doorList[door].model, false, 0, 0)

        if state then
            SetEntityHeading(entity, doorList[door].coords.w)
            FreezeEntityPosition(entity, true)
        else
            FreezeEntityPosition(entity, false)
        end
    end
end

-- Events

RegisterNetEvent("core:ChangeDoorState")
AddEventHandler("core:ChangeDoorState", function(door, state)
    if doorList ~= nil and doorList[door] ~= nil then
        doorList[door].lockStatus = state
        changeDoorLockStatus(door, state)
    end
end)