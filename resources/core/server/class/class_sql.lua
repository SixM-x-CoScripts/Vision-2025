sql = {
    select = function(table, coloumn, where)
        local result = {}
        local waiting = true
        local query = "SELECT "

        local count = 0
        for k,v in pairs(coloumn) do
            count = count + 1
            if count == 1 then
                query = query .. tostring(table) .. "." .. tostring(v)..""
            else
                query = query .. ", " .. tostring(table) .. ".".. tostring(v) .. ""
            end
        end

        query = query .. " FROM "..tostring(table)
        if where ~= nil then
            query = query .." WHERE "
            local count = 0
            for k,v in pairs(where) do
                count = count + 1
                if count == 1 then
                    query = query .. tostring(table) .. "." .. tostring(v).." "
                else
                    query = query .. "AND " .. tostring(table) .. ".".. tostring(v) .. ""
                end
            end
        end


        MySQL.Async.fetchAll(query, {}, function(results)
            result = results
            waiting = false
        end)

        while waiting do Wait(0) end
        return result
    end,


    update = function(table, sets, where)
        local result = {}
        local waiting = true
        local query = "UPDATE " .. tostring(table) .. " SET "

        local count = 0
        for k,v in pairs(sets) do
            count = count + 1
            if count == 1 then
                query = query .. tostring(table) .. "." .. tostring(v.column).." = '" .. tostring(v.data).."'"
            else
                query = query .. ", " .. tostring(table) .. "." .. tostring(v.column).." = '" .. tostring(v.data).."'"
            end
        end

        if where ~= nil then
            query = query .." WHERE "
            local count = 0
            for k,v in pairs(where) do
                count = count + 1
                if count == 1 then
                    query = query .. tostring(table) .. "." .. tostring(v).." "
                else
                    query = query .. "AND " .. tostring(table) .. ".".. tostring(v) .. ""
                end
            end
        end

        MySQL.Async.fetchAll(query, {}, function(results)
            result = results
            waiting = false
        end)
        while waiting do Wait(0) end

        return result
    end,
}

-- Citizen.CreateThread(function()
--     sql.update("players", {
--         {column = "job", data = "bus"},
--     }, {"license = 'license:859b24c97648ac4a1679c4bc3a7dc1ad7e1dfaeb'"})
-- end)