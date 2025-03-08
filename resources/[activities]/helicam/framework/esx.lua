if GetResourceState('es_extended') ~= 'started' then return end

ESX = exports.es_extended:getSharedObject()

function JobCheck()
    if Config.WhitelistedJobs == false then
        return true, nil
    end

    local PlayerData = ESX.GetPlayerData()
    if Config.WhitelistedJobs[PlayerData.job.name] then
        if PlayerData.job.grade >= Config.WhitelistedJobs[PlayerData.job.name] then
            return true, nil
        else
            return false, (Config.ShowMessageIfWrongJob and 'JobGrade') or nil
        end
    else
        return false, (Config.ShowMessageIfWrongJob and 'JobNotWhitelisted') or nil
    end
end
