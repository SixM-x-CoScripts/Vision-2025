if Config.HouseScript ~= "qs-housing" then
    return
end

local waitKeysPromise, waitKeysHouse

RegisterNUICallback("Home", function(data, cb)
    local action, houseData = data.action, data.houseData

    if action == "getHomes" then
        lib.TriggerCallback("phone:home:getOwnedHouses", cb)
    elseif action == "removeKeyholder" then
        -- if waitKeysPromise then
        --     return cb(false)
        -- end

        -- waitKeysHouse = houseData.uniqueId
        -- waitKeysPromise = promise.new()

        -- TriggerServerEvent("housing:server:removeHouseKey", houseData.uniqueId, {
        --     firstname = "?",
        --     lastname = "?",
        --     identifier = data.identifier
        -- })

        -- Citizen.Await(waitKeysPromise)

        -- lib.TriggerCallback("phone:home:getKeyholders", cb, houseData.uniqueId)

        lib.TriggerCallback("phone:home:removeKeyholder", cb, houseData.uniqueId, data.identifier)
    elseif action == "addKeyholder" then
        -- if waitKeysPromise then
        --     return cb(false)
        -- end

        -- waitKeysHouse = houseData.uniqueId
        -- waitKeysPromise = promise.new()

        -- TriggerServerEvent("housing:server:giveHouseKey", data.source, houseData.uniqueId)

        -- Citizen.Await(waitKeysPromise)

        -- lib.TriggerCallback("phone:home:getKeyholders", cb, houseData.uniqueId)

        -- lib.TriggerCallback("phone:home:addKeyholder", cb, houseData.uniqueId, data.source)

        lib.TriggerCallback("phone:home:addKeyholder", cb, houseData.uniqueId, data.identifier)
    elseif action == "setWaypoint" then
        cb("ok")

        local coords = (houseData.coords and json.decode(houseData.coords) or {})?.enter
        if not coords then
            return
        end

        SetNewWaypoint(coords.x, coords.y)
    end
end)

RegisterNetEvent("housing:client:updateKeyData", function(house)
    if waitKeysHouse == house and waitKeysPromise then
        waitKeysPromise:resolve()
        waitKeysPromise = nil
    end
end)
