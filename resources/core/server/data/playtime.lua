-- ALTER TABLE `players` 
-- ADD COLUMN IF NOT EXISTS `playtime` VARCHAR(8) NOT NULL DEFAULT '00:00:00';
-- ALTER TABLE `players_unique` 
-- ADD COLUMN IF NOT EXISTS `total_playtime` VARCHAR(8) NOT NULL DEFAULT '00:00:00';

local playersTable = {}

local function split(str, sep)
    if not str then return "" end
    if type(str) ~= "string" then return "" end
    local _sep = sep or ":"
    local _fields = {}
    local _pattern = string.format("([^%s]+)", _sep)
    str:gsub(_pattern, function(c) _fields[#_fields + 1] = c end)
    return _fields
end

local function timeFormatToSeconds(time)
    local timeParts = split(time, ':')
    local hours = tonumber(timeParts[1])
    local minutes = tonumber(timeParts[2])
    local seconds = tonumber(timeParts[3])
    return (hours * 3600) + (minutes * 60) + seconds
end

local function secondsToTimeFormat(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local seconds = math.floor(seconds % 60)
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

RegisterNetEvent('core:playerTimer:start')
AddEventHandler('core:playerTimer:start', function(idbdd)
    playersTable[idbdd] = os.time()
end)

RegisterNetEvent('core:playerTimer:stop')
AddEventHandler('core:playerTimer:stop', function(license, idbdd)
    local startTime = playersTable[idbdd]

    if not startTime then return end

    local endTime = os.time()
    local elapsedTime = endTime - startTime
    playersTable[idbdd] = nil

    MySQL.Async.fetchAll([[SELECT p.playtime, pu.total_playtime, pu.global_playtime FROM players p JOIN players_unique pu ON pu.license = @license WHERE p.id = @idbdd]], {
        ['@idbdd'] = idbdd,
        ['@license'] = license
    }, function(result)
        if result[1] then
            local oldPlaytime = result[1].playtime
            local oldTotalPlaytime = result[1].total_playtime
            local oldGlobalPlaytime = result[1].global_playtime

            local combinedPlaytime = secondsToTimeFormat(timeFormatToSeconds(oldPlaytime) + elapsedTime)
            local combinedTotalPlaytime = secondsToTimeFormat(timeFormatToSeconds(oldTotalPlaytime) + elapsedTime)
            local combinedGlobalPlaytime = secondsToTimeFormat(timeFormatToSeconds(oldGlobalPlaytime) + elapsedTime)

            MySQL.Async.execute([[UPDATE players p JOIN players_unique pu ON pu.license = @license SET p.playtime = @playtime, pu.total_playtime = @total_playtime, pu.global_playtime = @global_playtime WHERE p.id = @idbdd]], {
                ['@playtime'] = combinedPlaytime,
                ['@total_playtime'] = combinedTotalPlaytime,
                ['@global_playtime'] = combinedGlobalPlaytime,
                ['@idbdd'] = idbdd,
                ['@license'] = license
            })
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        local currentTime = os.date("*t")

        if currentTime.wday == 2 and currentTime.hour == 0 and currentTime.min == 0 then
            local currentTime = os.time()
            for k, v in pairs(playersTable) do
                playersTable[k] = currentTime
            end
        end

        Citizen.Wait(60000)
    end
end)