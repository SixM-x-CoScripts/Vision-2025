if GetResourceState('es_extended') == 'started' or GetResourceState('qb-core') == 'started' then return end

function JobCheck()
    if Config.WhitelistedJobs ~= false then
        print(GetCurrentResourceName().."/frameworks/standalone.lua: Jobs check failed, none of the supported frameworks are running, please set Config.WhitelistedJobs to false or make code adjustments.")
    end

    return true, nil
end
