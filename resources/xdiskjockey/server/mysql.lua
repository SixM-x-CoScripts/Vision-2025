function IsResourceOnServer(resourceName)
    if GetResourceState(resourceName) == "started" or GetResourceState(resourceName) == "starting" then
        return true
    end
    return false
end

if Config == nil then
    Config = {}
end

if Config.MysqlType == nil then
    if IsResourceOnServer("oxmysql") then
        local OxMySQLVersion = GetResourceMetadata("oxmysql", "version"):gsub("%D+", "")
        OxMySQLVersion = tonumber(OxMySQLVersion)

        if OxMySQLVersion <= 189 then
            -- is older than 2.0.0 version we're going to
            -- switch to old exports to make sure
            Config.MysqlType = 0
        else
            -- is newest we will trust the bridge for mysql-async will work on their part.
            Config.MysqlType = 2
        end

    elseif IsResourceOnServer("mysql-async") then
        Config.MysqlType = 2
    end

    if IsResourceOnServer("ghmattimysql") then
        Config.MysqlType = 1
    end
end

if Config.MysqlType == 0 then
    MySQL = {}
    MySQL.Sync = {}
    MySQL.Async = {}

    function MySQL.Sync.fetchAll(query, table_, cb)
        return exports['oxmysql']:executeSync(query, table_, cb)
    end

    function MySQL.Async.fetchAll(query, table_, cb)
        return exports['oxmysql']:execute(query, table_, cb)
    end

    ---
    -- sync / async
    function MySQL.Sync.execute(query, table_, cb)
        return exports['oxmysql']:executeSync(query, table_, cb)
    end

    function MySQL.Async.execute(query, table_, cb)
        return exports['oxmysql']:execute(query, table_, cb)
    end

    -- sync / async
    function MySQL.Sync.insert(query, table_, cb)
        return exports['oxmysql']:insert(query, table_, cb)
    end

    function MySQL.Async.insert(query, table_, cb)
        return exports['oxmysql']:insert_async(query, table_, cb)
    end
end

if Config.MysqlType == 1 then
    MySQL = {}
    MySQL.Sync = {}
    MySQL.Async = {}

    MySQL.Async.fetchAll = function(query, table_, cb)
        return exports['ghmattimysql']:execute(query, table_, cb)
    end

    MySQL.Sync.fetchAll = function(query, table_, cb)
        return exports['ghmattimysql']:executeSync(query, table_, cb)
    end

    MySQL.Async.execute = function(query, table_, cb)
        return exports['ghmattimysql']:execute(query, table_, cb)
    end

    MySQL.Sync.execute = function(query, table_, cb)
        return exports['ghmattimysql']:executeSync(query, table_, cb)
    end

    MySQL.Async.fetchScalar = function(query, table_, cb)
        return exports['ghmattimysql']:scalar(query, table_, cb)
    end

    MySQL.Sync.fetchScalar = function(query, table_, cb)
        return exports['ghmattimysql']:scalarSync(query, table_, cb)
    end
end