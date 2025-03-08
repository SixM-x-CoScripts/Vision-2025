if GetResourceState('qb-core') ~= 'started' then return end

QBCore = exports['qb-core']:GetCoreObject()

function JobCheck()
    if Config.WhitelistedJobs == false then
        return true, nil
    end

    local PlayerData = QBCore.Functions.GetPlayerData()
    if Config.WhitelistedJobs[PlayerData.job.name] then
        if PlayerData.job.grade.level >= Config.WhitelistedJobs[PlayerData.job.name] then
            return true, nil
        else
            return false, (Config.ShowMessageIfWrongJob and 'JobGrade') or nil
        end
    else
        return false, (Config.ShowMessageIfWrongJob and 'JobNotWhitelisted') or nil
    end
end
