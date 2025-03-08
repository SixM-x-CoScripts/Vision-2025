local json = require("json")
local vehiclesLightbars = {}
local toggleLightbarAudio = {}
local identifiersId = {}

function readActiveJson()
    local activeData = LoadResourceFile(ResourceName, activePath)
    return json.decode(activeData) or {}
end

RegisterServerEvent("vlighbar:server:attackLightbar")
RegisterServerEvent("vlighbar:server:loadLightbars")
RegisterServerEvent("vlighbar:server:getVehicleData")
RegisterServerEvent("vlightbar:server:toggleLightbars")
RegisterServerEvent("vlightbar:server:toggleLightbarAudio")
RegisterServerEvent("vlightbar:server:TogglesirenHorn")
RegisterServerEvent("vlightbar:server:getIdentifier")
RegisterServerEvent("vlightbar:server:getSirenData")
RegisterServerEvent("vlightbar:server:addUserPermission")
RegisterServerEvent("vlightbar:server:spawnLightbarVeh")

AddEventHandler("vlightbar:server:spawnLightbarVeh", function(model, coord, heading, bool, cdata, pdata, realPlate, isNotCreation)
    local src = source
    local vehicle = CreateVehicle(model, coord, heading, true, true)
    while not DoesEntityExist(vehicle) do Citizen.Wait(0) end
    while NetworkGetEntityOwner(vehicle) ~= src do Citizen.Wait(0) end

    TriggerClientEvent("vlightbar:client:spawnLightbarVeh", src, NetworkGetNetworkIdFromEntity(vehicle), model, bool, cdata, pdata)

    if isNotCreation then
        local plate = realPlate
        local activeData = readActiveJson()
        activeData[plate] = true

        SaveResourceFile(ResourceName, activePath, json.encode(activeData), -1)
    end
end)

AddEventHandler("vlighbar:server:attackLightbar", function(mainCarPlate, lightbarData)
    local jsonData = json.decode(LoadResourceFile(ResourceName, jsonPath))
    if vehiclesLightbars[mainCarPlate] == nil then vehiclesLightbars[mainCarPlate] = {} end
    vehiclesLightbars[mainCarPlate] = lightbarData
    jsonData = vehiclesLightbars
    TriggerClientEvent("vlightbar:client:getVehicleData", -1, jsonData)
    SaveResourceFile(ResourceName, jsonPath, json.encode(jsonData), -1)
end)


local function canToggleLightbar(plate)
    local activeData = json.decode(LoadResourceFile(ResourceName, activePath))

    --[[ print(plate) ]]
    if activeData[plate] == true then
        return true
    else 
        return false
    end
end

AddEventHandler("vlightbar:server:toggleLightbars", function(veh, plate, realPlate)
    local isLightBarVehicle = canToggleLightbar(realPlate)
    if isLightBarVehicle then
        if toggleLightbarAudio[plate] == nil then toggleLightbarAudio[plate] = {} end
        if toggleLightbarAudio[plate].lightbar == nil then toggleLightbarAudio[plate].lightbar = false end
        toggleLightbarAudio[plate].lightbar = not toggleLightbarAudio[plate].lightbar
        TriggerClientEvent("vlightbar:client:toggleLightbars", -1, veh, plate, toggleLightbarAudio[plate].lightbar)
        if not toggleLightbarAudio[plate].lightbar and toggleLightbarAudio[plate].siren then
            toggleLightbarAudio[plate].siren = false
            TriggerClientEvent("vlightbar:client:toggleLightbarAudio", -1, veh, plate, false)
        end
    end
end)

AddEventHandler("vlightbar:server:toggleLightbarAudio", function(vehicle, plate, sirenTon, realPlate)
    local isLightBarVehicle = canToggleLightbar(realPlate)
    if isLightBarVehicle then
        if toggleLightbarAudio[plate] == nil then toggleLightbarAudio[plate] = {} end
        if toggleLightbarAudio[plate].lightbar == nil or toggleLightbarAudio[plate].lightbar == false then return end
        if toggleLightbarAudio[plate].siren == nil then toggleLightbarAudio[plate].siren = false end
        toggleLightbarAudio[plate].siren = not toggleLightbarAudio[plate].siren
        toggleLightbarAudio[plate].sirenTon = sirenTon
        TriggerClientEvent("vlightbar:client:toggleLightbarAudio", -1, vehicle, plate, toggleLightbarAudio[plate].siren, sirenTon)
    end
end)

AddEventHandler("vlightbar:server:TogglesirenHorn", function(vehicle, bool, realPlate)
    local isLightBarVehicle = canToggleLightbar(realPlate)
    if isLightBarVehicle then
        TriggerClientEvent("vlightbar:client:TogglesirenHorn", -1, vehicle, bool)
    end
end)

AddEventHandler("vlightbar:server:getIdentifier", function()
    local _src = source
    local identifiers = GetPlayerIdentifiers(_src)
    local perms = json.decode(LoadResourceFile(ResourceName, permPath))
    identifiersId[_src] = identifiers
    TriggerClientEvent("vlightbar:client:getIdentifier", _src, identifiers, perms)
end)

AddEventHandler("vlightbar:server:addUserPermission", function(id, bool)
    if identifiersId[id] == nil then return end
    local permData = json.decode(LoadResourceFile(ResourceName, permPath))
    local ident = identifiersId[id][1]
    local newPerm = {
        identifier = ident,
        admin = (bool == 1) and true or false
    }
    AddValue(permData, newPerm)
    TriggerServerEvent("vlightbar:client:addPermission", id, permData)
    SaveResourceFile(ResourceName, permPath, json.encode(permData), -1)
end)

AddEventHandler("vlightbar:server:getSirenData", function()
    local src = source
    TriggerClientEvent("vlightbar:client:getSirenData", src, toggleLightbarAudio)
end)

Citizen.CreateThread(function()
    local jsonData = json.decode(LoadResourceFile(ResourceName, jsonPath))
    local permData = json.decode(LoadResourceFile(ResourceName, permPath))
    local activeData = json.decode(LoadResourceFile(ResourceName, activePath))
    if jsonData == nil then
        SaveResourceFile(ResourceName, jsonPath, json.encode({}), -1)
        print(('^1[LightBar] ^0 json data created.'))
    else
        print(('^1[LightBar] ^0 json data loaded.'))
        vehiclesLightbars = jsonData
    end
    if permData == nil then
        SaveResourceFile(ResourceName, permPath, json.encode({}), -1)
        print(('^1[LightBar] ^0 permission data created.'))
    end
    if activeData == nil then
        SaveResourceFile(ResourceName, activePath, json.encode({}), -1)
        print(('^1[LightBar] ^0 Active data created.'))
    else
        print(('^1[LightBar] ^0 Active data rested.'))
        SaveResourceFile(ResourceName, activePath, json.encode({}), -1)
    end
    local findIndex = {}
    permData = json.decode(LoadResourceFile(ResourceName, permPath))
    for key, value in pairs(permData) do
        for index, hex in ipairs(vLightbar.adminIdentities) do
            if value.identifier == hex then
                AddValue(findIndex, index)
            end
        end
    end
    for ix, val in ipairs(vLightbar.adminIdentities) do
        if #findIndex > 0 then
            for i, v in ipairs(findIndex) do
                if not ix == v then
                    local newPerm = {
                        identifier = val,
                        admin = true
                    }
                    AddValue(permData, newPerm)
                end
            end
        else
            local newPerm = {
                identifier = val,
                admin = true
            }
            AddValue(permData, newPerm)
        end
    end
    SaveResourceFile(ResourceName, permPath, json.encode(permData), -1)
end)
