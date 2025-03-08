local vKeys = {}
local Keys = {}
local jobVeh = {}
local AllKeys = {}

local function InitPlayerKeys(source)
    local id = GetPlayer(source):getId()
    if vKeys[tostring(id)] == nil then
        vKeys[tostring(id)] = {}

    end
    if Keys[tostring(id)] == nil then
        Keys[tostring(id)] = {}
    end
end

function GetPlayerKeys(source)
    local id = GetPlayer(source):getId()
    return vKeys[tostring(id)], Keys[tostring(id)]
end

function RefreshPlayerKeys(source)
    InitPlayerKeys(source)
    local vKeys, Keys = GetPlayerKeys(source)
    TriggerClientEvent("core:RefreshPlayerKey", source, vKeys, Keys)
end

function AddPlayerKey(source, type)
    InitPlayerKeys(source)
    local id = GetPlayer(source):getId()
    Keys[tostring(id)][type] = true
    RefreshPlayerKeys(source)
end

function AddPlayerVehKey(source, type)
    InitPlayerKeys(source)
    local id = GetPlayer(source):getId()
    vKeys[tostring(id)][tostring(type)] = true
    RefreshPlayerKeys(source)
end

function InitJob(job)
    if jobVeh[job] == nil then
        jobVeh[job] = {}
    end
end

CreateThread(function()
	local keysData = LoadResourceFile(GetCurrentResourceName(), 'server/addon/keys.json')
	AllKeys = keysData and json.decode(keysData) or {}
    Wait(5000)
    if AllKeys and next(AllKeys) then
        for k,v in pairs(AllKeys) do
            InitJob(v.job)
            Wait(50)
            jobVeh[v.job][v.plaque] = true
        end
    end
    while true do
        Wait(60000)
	    SaveResourceFile(GetCurrentResourceName(), 'server/addon/keys.json', json.encode(AllKeys))
    end
end)

function RefreshCarJob(source, job)
    InitJob(job)
    TriggerClientEvent("core:RefreshPlayerJobCar", source, jobVeh[job])
end

-- RegisterServerCallback("core:GetPlayerJobCar", function(source)
--     local src = source
--     local player = GetPlayer(src);
--     if not player then return end
--     local jobz = GetPlayer(src):getJob()
--     return jobVeh[jobz]
-- end)

function AddCarJob(source, type, job)
    InitJob(job)
    jobVeh[job][type] = true
    table.insert(AllKeys, {job = job, plaque = type})
    RefreshCarJob(source, job)
end

function RemoveCarJob(source, type, job)
    InitJob(job)
    jobVeh[job][type] = false
    RefreshCarJob(source, job)
end

function RemovePlayerVehKey(source, type)
    InitPlayerKeys(source)
    local id = GetPlayer(source):getId()
    vKeys[id][tostring(type)] = false
    RefreshPlayerKeys(source)
end

RegisterNetEvent("core:GiveAccesKeyToPlayer")
AddEventHandler("core:GiveAccesKeyToPlayer", function(token, type)
    if CheckPlayerToken(source, token) then
        AddPlayerKey(source, type)
    else
        -- TODO: AC detection
    end
end)

RegisterNetEvent("core:GiveVehicleKeyToPlayer")
AddEventHandler("core:GiveVehicleKeyToPlayer", function(token, type)
    if CheckPlayerToken(source, token) then
        AddPlayerVehKey(source, type)
    else
        -- TODO: AC detection
    end
end)

RegisterNetEvent("core:AddCarToJob")
AddEventHandler("core:AddCarToJob", function(token, type, job)
    if not type then return end
    if CheckPlayerToken(source, token) then
        AddCarJob(source, string.upper(type), job)
    else
        -- TODO: AC detection
    end
end)

RegisterNetEvent("core:RemoveVehJob")
AddEventHandler("core:RemoveVehJob", function(token, type, job)
    if CheckPlayerToken(source, token) then
        RemoveCarJob(source, string.upper(type), job)
    else
        -- TODO: AC detection
    end
end)
