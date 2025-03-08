------------------------------------------------------------------
-- Need to be changed to your framework, for now default is ESX --
------------------------------------------------------------------
-- ESX
if Config.FrameWork == 1 then
    PlayerData = {}
    ESX = nil

    CreateThread(function()
        ESX = GetEsxObject()

        if ESX.IsPlayerLoaded() then
            PlayerData = ESX.GetPlayerData()
        end
    end)

    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(xPlayer)
        PlayerData = xPlayer
    end)

    RegisterNetEvent('esx:setJob')
    AddEventHandler('esx:setJob', function(job)
        PlayerData.job = job
    end)

    function isAtJob(name)
        return PlayerData.job.name == name or PlayerData.job.identifier == name
    end
end

-- QBCORE
if Config.FrameWork == 2  then
    local PlayerData = {}
    local QBCore
    function UpdatePlayerDataForQBCore()
        local pData = QBCore.Functions.GetPlayerData()

        local jobName = "none"
        local gradeName = "none"

        if pData.job then
            jobName = pData.job.name or "none"

            if pData.job.grade then
                gradeName = pData.job.grade.name
            end
        end

        PlayerData = {
            job = {
                name = jobName,
                grade_name = gradeName,
            }
        }
    end

    CreateThread(function()
        QBCore = Config.GetQBCoreObject()

        if QBCore and QBCore.Functions.GetPlayerData() then
            UpdatePlayerDataForQBCore()
        end
    end)

    -- Will load player job + update markers
    RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
        UpdatePlayerDataForQBCore()
    end)

    -- Will load player job + update markers
    RegisterNetEvent("QBCore:Client:OnJobUpdate", function()
        UpdatePlayerDataForQBCore()
    end)

    function isAtJob(name)
        return PlayerData.job.name == name
    end
end

-- Standalone
if Config.FrameWork == 0  then
    function isAtJob(name)
        return true
    end
end
------------------------
-- Optional to change --
------------------------
function showNotification(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(0, 1)
end

-- display custom marker/Text whatever
--- @pos vector3
--- @name string
-- Will be called every tick if close.
function DisplayMarker(pos, name)
    DrawMarker(31, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 100, false, true, 2, false, false, false, false)
    DrawMarker(20, pos.x, pos.y, pos.z - 0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 100, false, true, 2, true, false, false, false)
    DrawMarker(25, pos.x, pos.y, pos.z - 0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
end

-- cache markers
CreateThread(function()
    while true do
        Wait(0)
        if not NearMarker then
            Wait(1000)
        else
            for _, value in pairs(CachedMarkers) do
                DisplayMarker(value.pos, value.name)
            end
        end
    end
end)