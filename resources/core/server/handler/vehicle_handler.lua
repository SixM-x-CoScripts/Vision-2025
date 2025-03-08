local vehiculesTmp = {}

local function LoadAllVehicle() -- done

    MySQL.Async.fetchAll('SELECT * FROM vehicles', {}, function(result)
        for k, v in pairs(result) do
            if v.props then 
                local prop = json.decode(v.props)
                if prop and (prop.premium == true or prop.premium == "true") then 
                    v.premium = 1
                end
            end
            local veh = vehicle:new(v)
            --vehicles[v.plate] = veh
            --print(json.encode(veh))
        end
    end)
    CorePrint("Tous les vehicules de la bdd ont été load.")
end

MySQL.ready(function()
    Wait(1000)
    LoadAllVehicle()
end)

local function carIsInGarage(plate) -- done
    local propertyListPlate = AllPropertiesPlate()
    for k, v in pairs(propertyListPlate) do
        if v == plate then return true end
    end
    return false
end

function MarkVehicleAsNotSaved(source, plate) -- done
    local veh = GetVehicle(plate)
    if veh == nil then return end
    veh:setNeedSave(true)
end

function getAllVehicleFromId(id, crew, job) -- done replace of GetVehicleIndexFromPlate
    local vehList = {}
    local jobVehicles = getAllVehFromJob(job)
    local crewVehicles = getAllVehFromCrew(crew)
    local ownerVehicles = getAllVehFromOwner(id)
    local coownerVehicles = getAllVehFromCoOwner(id)
    -- store all table inside vehList
    if jobVehicles then 
        for k, v in pairs(jobVehicles) do
            table.insert(vehList, v)
        end
    end
    if crewVehicles then 
        for k, v in pairs(crewVehicles) do
            table.insert(vehList, v)
        end
    end
    if ownerVehicles then 
        for k, v in pairs(ownerVehicles) do
            table.insert(vehList, v)
        end
    end
    if coownerVehicles then 
        for k, v in pairs(coownerVehicles) do
            table.insert(vehList, v)
        end
    end
    return vehList

    -- Old
    --local vehicles = GetAllVehiclesClass()
    --for k, v in pairs(vehicles) do
    --    if v.owner == id or v.vente == crew or v.job == job then
    --        table.insert(vehList, v)
    --    else
    --        for kk, vv in ipairs(v.coowner) do
    --            if vv == id then
    --                table.insert(vehList, v)
    --                break
    --            end
    --        end
    --    end
    --end
    --return vehList
end

RegisterCommand("getAllVehsFromPlayer", function(source, args)
    if source == 0 then
        local id = tonumber(args[1])
        local ply = GetPlayer(id)
        local idbdd = ply:getId()
        local crew = ply:getCrew()
        local job = ply:getJob()
        local vehList = getAllVehicleFromId(idbdd, crew, job)
        for k,v in pairs(vehList) do 
            print(v.name, v.plate)
        end
    end
end)

RegisterCommand("getAllPlateFromPlayer", function(source, args)
    if source == 0 then
        local id = tonumber(args[1])
        local ply = GetPlayer(id)
        local idbdd = ply:getId()
        local crew = ply:getCrew()
        local job = ply:getJob()
        local vehList = getAllVehiclePlateFromId(idbdd, crew, job)
        for k,v in pairs(vehList) do 
            print(v)
        end
    end
end)

function getAllVehiclePlateFromId(id, crew, job)
    local vehList = {}
    local jobVehicles = getAllVehFromJob(job)
    local crewVehicles = getAllVehFromCrew(crew)
    local ownerVehicles = getAllVehFromOwner(id)
    local coownerVehicles = getAllVehFromCoOwner(id)
    -- store all table inside vehList
    if jobVehicles then 
        for k, v in pairs(jobVehicles) do
            table.insert(vehList, v.plate)
        end
    end
    if crewVehicles then 
        for k, v in pairs(crewVehicles) do
            table.insert(vehList, v.plate)
        end
    end
    if ownerVehicles then 
        for k, v in pairs(ownerVehicles) do
            table.insert(vehList, v.plate)
        end
    end
    if coownerVehicles then 
        for k, v in pairs(coownerVehicles) do
            table.insert(vehList, v.plate)
        end
    end
    return vehList

    -- local vehList = {}
    -- local vehicles = GetAllVehiclesClass()
    -- for k, v in pairs(vehicles) do
    --     if v.owner == id or v.vente == crew or v.job == job then
    --         table.insert(vehList, v.plate)
    --     else
    --         for kk, vv in ipairs(v.coowner) do
    --             if vv == id then
    --                 table.insert(vehList, v.plate)
    --                 break
    --             end
    --         end
    --     end
    -- end
    -- return vehList
end

RegisterCommand("getAllVehsFromJob", function(source, args)
    if source == 0 then
        local job = args[1]
        local vehList = getAllVehiclePlateFromJob(job)
        for k,v in pairs(vehList) do 
            print(v)
        end
    end
end)

function getAllVehiclePlateFromJob(job)
    local jobVehicles = getAllVehFromJob(job)
    local vehList = {}
    if jobVehicles then 
        for k, v in pairs(jobVehicles) do
            table.insert(vehList, v.plate)
        end
    end
    return vehList

    --local vehList = {}
    --local vehicles = GetAllVehiclesClass()
    --for k, v in pairs(vehicles) do
    --    if v.job == job then
    --        table.insert(vehList, v.plate)
    --    end
    --end
    --return vehList
end

RegisterCommand("getAllCrewVehicle", function(source, args)
    if source == 0 then
        local crew = args[1]
        local vehList = getAllCrewVehicle(crew)
        for k,v in pairs(vehList) do 
            print(v.name, v.plate)
        end
    end
end)

function getAllCrewVehicle(crew)
    local vehicles = getAllVehFromCrew(crew)
    local vehList = {}
    if vehicles then 
        for k, v in pairs(vehicles) do
            table.insert(vehList, v)
        end
    end
    return vehList

    --local vehList = {}
    --local vehicles = GetAllVehiclesClass()
    --for k, v in pairs(vehicles) do
    --    if v.vente == crew then
    --        table.insert(vehList, v)
    --    end
    --end
    --return vehList
end

function getAllVehicleFromIdPounder(id, crew, job, needAll)
    -- print("playersvehs", #playersvehs)
    -- print("crewsvehs", #crewsvehs)
    -- print("jobsvehs", #jobsvehs)
    -- print("coownersvehs", #coownersvehs)
    local vehList = {}
    local ownerVehs = getAllVehFromOwner(id)
    local crewVehs = getAllVehFromCrew(crew)
    local jobVehs = getAllVehFromJob(job)
    local coownerVehs = getAllVehFromCoOwner(id)
    if ownerVehs then 
        for k,v in pairs(ownerVehs) do 
            if v.stored and v.stored == 2 then
                table.insert(vehList, {name = v.name, currentPlate = v.currentPlate, job = v.job, stored = v.stored, vente = v.vente})
            end
        end
    end
    if crewVehs then 
        for k,v in pairs(crewVehs) do 
            if v.stored and v.stored == 2 then
                table.insert(vehList, {name = v.name, currentPlate = v.currentPlate, job = v.job, stored = v.stored, vente = v.vente})
            end
        end
    end
    if jobVehs then 
        for k,v in pairs(jobVehs) do 
            if v.stored and v.stored == 2 then
                table.insert(vehList, {name = v.name, currentPlate = v.currentPlate, job = v.job, stored = v.stored, vente = v.vente})
            end
        end
    end
    if coownerVehs then 
        for k,v in pairs(coownerVehs) do 
            if v.stored and v.stored == 2 then
                table.insert(vehList, {name = v.name, currentPlate = v.currentPlate, job = v.job, stored = v.stored, vente = v.vente})
            end
        end
    end
    --print("vehList", #vehList)
    return vehList
end

function getAllVehicleOwner(id) -- done replace of GetVehicleIndexFromPlate
    local vehOwner = getAllVehFromOwner(id)
    local vehList = {}
    if vehOwner then 
        for k, v in pairs(vehOwner) do
            table.insert(vehList, v)
        end
    end
    return vehList
    
    --local vehList = {}
    --local vehicles = GetAllVehiclesClass()
    --for k, v in pairs(vehicles) do
    --    if v.owner == id then
    --        table.insert(vehList, v)
    --    end
    --end
    --return vehList
end

-- function givekeytmp(id, crew, job, src) -- done to delete after 1week
--     CheckColumn()
--     Wait(1000)
--     local id = GetPlayer(src):getId()
--     MySQL.Async.fetchAll('SELECT hasvoted FROM players WHERE id = ? LIMIT 1', { id }, function(result)
--         if result[1].hasvoted == 0 then
--             local vehicles = GetAllVehiclesClass()
--             local grade = GetPlayer(src):getJobGrade()
--             for k, v in pairs(vehicles) do
--                 if v.job == job then
--                     if grade >= 4 then
--                         TriggerClientEvent('core:createKeys', v.plate, v.name)
--                     end
--                 elseif v.owner == id or v.vente == crew then
--                     TriggerClientEvent('core:createKeys', src, v.plate, v.name)
--                 else
--                     for kk, vv in ipairs(v.coowner) do
--                         if vv == id then
--                             TriggerClientEvent('core:createKeys', src, v.plate, v.name)
--                             break
--                         end
--                     end
--                 end
--             end
--             MySQL.Async.execute('UPDATE players SET hasvoted = ? WHERE id = ?', { 1, id }, function() end)
--             TriggerClientEvent("core:givekeyret", src, "VERT", "Vous avez recus vos clées!")
--         else
--             --TriggerClientEvent("core:givekeyret", src, "ROUGE", "Vous avez deja recus vos clées!")
--         end
--     end)
-- end

function SetVehicleInPounder(plate) -- done
    local veh = GetVehicle(plate)
    if veh == nil then return end
    veh:setVehiclePound(2)
end

function SetVehicleProps(plate, props) -- done
    local veh = GetVehicle(plate)
    if veh == nil then return end
    veh:setVehiclePropsClass(props)
end

function SendItemToVehicle(source, item, amount, plate, metadatas, coffresize) -- done
    local veh = GetVehicle(plate)
    local var, isfull = AddItemToInventoryVehicle(plate, item, tonumber(amount), metadatas, coffresize)
    veh:setNeedSave(true)
    MarkPlayerDataAsNonSaved(source)
    return var, isfull
end

function SendItemToVehicleStaff(source, item, amount, plate, metadatas) -- done
    local veh = GetVehicle(plate)
    AddItemToInventoryVehicleStaff(plate, item, tonumber(amount), metadatas)
    veh:setNeedSave(true)
    MarkPlayerDataAsNonSaved(source)
end

function RemoveItemFromVehicle(source, item, amount, plate, metadatas) -- done
    local result = nil
    local veh = GetVehicle(plate)
    if not veh then return false end
    if item == "bike" then
        result = RemoveItemToVehicleBike(plate, item, tonumber(amount), metadatas)
    elseif item == "identitycard" then
        result = RemoveItemToVehicleIdentity(plate, item, tonumber(amount), metadatas)
    else
        result = RemoveItemToVehicle(plate, item, tonumber(amount), metadatas)
    end
    veh:setNeedSave(true)
    MarkPlayerDataAsNonSaved(source)
    return result
end

function newVeh(plate, model, entity, netId, tmp, trunk)
    local veh = {}
    veh.plate = plate
    veh.owner = nil
    veh.name = model
    veh.props = json.encode({})
    veh.garage = nil
    veh.stored = nil
    veh.vente = nil
    veh.coowner = json.encode({})
    veh.job = nil
    if trunk then
        veh.inventory = json.encode(trunk)
    else
        if model and coffre[GetHashKey(model)] ~= nil and coffre[GetHashKey(model)] / 1000 ~= nil then
            veh.inventory = json.encode({item={}, cloths={}, weapons={}, weight={max=coffre[GetHashKey(model)] / 1000, current=0}})
        else
            veh.inventory = json.encode({item={}, cloths={}, weapons={}, weight={max=100, current=0}})
        end
    end
    veh.mileage = nil
    veh.fuel = nil
    veh.body = json.encode({})
    veh.currentPlate = plate
    veh.needSave = false
    veh.netId = netId
    veh.entity = entity
    veh.usedTrunk = nil
    veh.tmpVeh = tmp
    return vehicle:new(veh, tmp)
end

function carDealerCreateCar(data)
    return vehicle:new(data)
end

function parkingPublicIsFull(isPremium, id)
    
    local max = isPremium == 1 and 3 or isPremium == 2 and 5 or 1
    for k, v in pairs(getAllVehicleOwner(id)) do
        if v.stored == 3 then 
            max = max - 1
        end
    end
    return max <= 0 and true or false
end

Citizen.CreateThread(function()
    while RegisterServerCallback == nil do
        Wait(1000)
    end

    RegisterServerCallback("core:NewVehJob", function(source, plate, model, entity, netId, job) -- done
        local veh = {}
        veh.plate = plate
        veh.owner = job == nil and GetPlayer(source):GetId() or nil
        veh.name = model
        veh.props = json.encode({})
        veh.garage = nil
        veh.stored = nil
        veh.vente = nil
        veh.coowner = json.encode({})
        veh.job = job
        if coffre[GetHashKey(model)] ~= nil and coffre[GetHashKey(model)] / 1000 ~= nil then
            veh.inventory = json.encode({item={}, cloths={}, weapons={}, weight={max=coffre[GetHashKey(model)] / 1000, current=0}})
        else
            veh.inventory = json.encode({item={}, cloths={}, weapons={}, weight={max=100, current=0}})
        end        
        veh.mileage = nil
        veh.fuel = nil
        veh.body = json.encode({})
        veh.currentPlate = plate
        veh.needSave = false
        veh.netId = netId
        veh.entity = entity
        veh.usedTrunk = nil
        veh.tmpVeh = true
    
        return vehicle:new(veh, true)
    end)

    RegisterServerCallback("core:GetVehicleInventory", function(source, plate, model, entity, netId) -- done
        if (GetVehicle(plate) == nil) then
            newVeh(plate, model, entity, netId, true)
        end
        return GetVehicle(plate) and GetVehicle(plate):getInventory().item or {}
    end)

    RegisterServerCallback("core:setTmpVehOut", function(source, plate, model, entity, netId, trunk) -- done
        newVeh(plate, model, entity, netId, true, trunk)
        return true
    end)

    RegisterServerCallback('core:GetVehicles', function(source) -- done
        local id = GetPlayer(source):getId()
        local crew = GetPlayer(source):getCrew()
        local job = GetPlayer(source):getJob()
        return getAllVehicleFromId(id, crew, job)
    end)

    RegisterServerCallback('core:IsOwnerOfCar', function(source, plateOrigin) -- done
        local id, crew, job = GetPlayer(source):getId(), GetPlayer(source):getCrew(), GetPlayer(source):getJob()
        for k, v in pairs(getAllVehiclePlateFromId(id, crew, job)) do
            if v == plateOrigin then
                return true
            end
        end
        return false
    end)

    RegisterServerCallback('core:GetCarJob', function(source, plate)
        local veh = GetVehicle(plate)
        if veh == nil then return nil end
        return veh.job
    end)

    RegisterServerCallback('core:IsCarJob', function(source, plate, job) -- done
        local job = GetPlayer(source):getJob()
        for k, v in pairs(getAllVehiclePlateFromJob(job)) do
            if v == plate then
                return true
            end
        end
        return false
    end)

    RegisterServerCallback('core:GetVehiclesParking', function(source) -- done
        local id = GetPlayer(source):getId()
        return getAllVehicleOwner(id)
    end)

    RegisterServerCallback("core:getVehProps", function(source, plate)
        return GetVehicle(plate) and GetVehicle(plate).props or {}
    end)

    -- GetVehicleInPound
    RegisterServerCallback('core:GetVehiclesInPound', function(source) -- done
        local id = GetPlayer(source):getId()
        local crew = GetPlayer(source):getCrew()
        local job = GetPlayer(source):getJob()
        return getAllVehicleFromIdPounder(id, crew, job, needAll)
    end)

    RegisterServerCallback('core:getOriginPlate', function(source, plate) -- done
        -- Tested, good
        return getOriginalPlate(all_trim(plate))
        --local vehicles = GetAllVehiclesClass()
        --for k, v in pairs(vehicles) do
        --    if v.currentPlate == plate then
        --        return v.plate
        --    end
        --end
        --return nil
    end)

    RegisterServerCallback('core:getInfoKeys', function(source, plate) -- done
        local ply = GetPlayer(source)
        local job = ply:getJob()
        local datas = {}
        local plateOrigin = getOriginalPlate(all_trim(plate))
        datas["plateOrigin"] = plateOrigin
        for k, v in pairs(getAllVehiclePlateFromJob(job)) do
            if v == plate then
                datas["isjob"] = true
                --print("isjob", true)
                break
            end
        end
        local id, crew = ply:getId(), ply:getCrew()
        for k, v in pairs(getAllVehiclePlateFromId(id, crew, job)) do
            if v == plateOrigin then
                datas["owner"] = true
                --print("owner", true)
                break
            end
        end

        --print(json.encode(datas))
        return datas
    end)

    -- Semble pas utilisé ? a voir si non il faut delete
    RegisterServerCallback('core:AllGetVehicles', function(source) -- done
        return {} --GetAllVehiclesClass() -- return any
    end)

    RegisterServerCallback('core:GetAllVehPounder', function(source, target, needAll) -- done
        if target == nil or not GetPlayer(target) then 
            return {}
        end
        local id = GetPlayer(target):getId()
        local crew = GetPlayer(target):getCrew()
        local job = GetPlayer(target):getJob()
        return getAllVehicleFromIdPounder(id, crew, job, needAll)
    end)

    RegisterServerCallback('core:vAdmin:GetAllVehicle', function(source, target)
        local vehs = {
            ["owned"] = {},
            ["coowned"] = {},
            ["job"] = {},
            ["crew"] = {}
        }

        local id = GetPlayer(target):getId()
        local crew = GetPlayer(target):getCrew()
        local job = GetPlayer(target):getJob()

        local owned = getAllVehFromOwner(id)
        local coowned = getAllVehFromCoOwner(id)
        local job = getAllVehFromJob(job)
        local crew = getAllVehFromCrew(crew)

        -- owned
        if owned then 
            for k, v in pairs(owned) do
                table.insert(vehs.owned, {plate = v.plate, currentPlate = v.currentPlate, name = v.name, stored = v.stored, job = v.job, vente = v.vente})
            end
        end

        -- coowned
        if coowned then 
            for k, v in pairs(coowned) do
                table.insert(vehs.coowned, {plate = v.plate, currentPlate = v.currentPlate, name = v.name, stored = v.stored, job = v.job, vente = v.vente})
            end
        end

        -- job
        if job then 
            for k, v in pairs(job) do
                table.insert(vehs.job, {plate = v.plate, currentPlate = v.currentPlate, name = v.name, stored = v.stored, job = v.job, vente = v.vente})
            end
        end

        -- crew
        if crew then 
            for k, v in pairs(crew) do
                table.insert(vehs.crew, {plate = v.plate, currentPlate = v.currentPlate, name = v.name, stored = v.stored, job = v.job, vente = v.vente})
            end
        end

        return vehs
    end)

    RegisterServerCallback('core:SetVehicleIn', function(plate) -- done
        local veh = GetVehicle(plate)
        if veh == nil then
            return false
        end
        veh:setVehicleIn()
        return true
    end)

    RegisterServerCallback('core:ChangePlateVeh', function(source, plate, newPlate, model) -- done
        local source = source
        local veh = GetVehicle(plate)

        if veh == nil then return false end

        veh:changePlate(newPlate)

        SendDiscordLog("plate", source, string.sub(GetDiscord(source), 9, -1), GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(), model, plate, newPlate)

        return true
    end)

    RegisterServerCallback("core:AddItemToVehicle", function(source, token, item, amount, plate, metadatas, model) -- done
        local source = source
        if CheckPlayerToken(source, token) then
            local itemWeight = GetItemWeightWithCount(item, amount)
            local veh = GetVehicle(plate)
            if coffre[model] == nil then
                TriggerClientEvent("core:noCarCoffre", source, model)
            else
                if getInventoryWeightVehicle(plate) + itemWeight <= coffre[model] then
                    local bool, isfull = SendItemToVehicle(source, item, amount, plate, metadatas, coffre[model]/1000)
                    if isfull then 
                        -- TriggerClientEvent("core:ShowNotification", source, "Le coffre du véhicule est ~r~plein~s~.") 

                        TriggerClientEvent("__atoshi::createNotification", source, {
                            type = 'ROUGE',
                            -- duration = 5, -- In seconds, default:  4
                            content = "~c Le coffre du véhicule est ~s plein "
                        })
                    end
                    return bool
                end
            end
            return false
        end
        return false
    end)

    RegisterServerCallback('core:vehicle:getCrewVeh', function(source, crew) -- done
        return getAllCrewVehicle(crew) -- return any
    end)

    RegisterServerCallback('core:vehicle:setPublic', function(source, plate) -- done
        local veh = GetVehicle(plate)
        local isPremium = GetPlayer(source):getSubscription()
        local id = GetPlayer(source):getId()
        if veh == nil then
            return "Le vehicule ne vous appartient pas"
        end
        if parkingPublicIsFull(isPremium, id) then
            return "Le garage publique est complet"
        else
            veh:setVehiclePublic()
            return true
        end
    end)

    RegisterServerCallback('core:vehicle:deleteVehFromBddForSaculBecauseHeAskForTodayAndHeDontWantToBreakAllTheServer', function(source, currentPlate)
        local veh = GetVehicle(currentPlate)
        if veh == nil then return false end
        local ret = true
        result = MySQL.Async.execute("DELETE FROM vehicles WHERE currentPlate = @currentPlate"
            , {
            ['@currentPlate'] = currentPlate,
        }, function(rowsChanged)
            if rowsChanged == 0 then
                ret = false
            end
        end)
        if ret then RemoveVehicle(currentPlate) end
        return ret
    end)

    RegisterServerCallback("core:vAdmin:DevTools:GetVehicleOwner", function(source, token, plate)
        if CheckPlayerToken(source, token) then
            local veh = GetVehicle(plate)
            if veh == nil then return {
                source = 0,
                id = 0,
                firstname = "None",
                lastname = "(PNJ)"
            } end
            
            local owner = GetPlayerById(veh.owner)

            if owner then
                return {
                    source = owner.source,
                    id = owner.id,
                    firstname = owner.firstname,
                    lastname = owner.lastname
                }
            else 
                return {
                    source = 0,
                    id = veh.owner,
                    firstname = "Unknown",
                    lastname = ""
                }
            end
        end
    end)
end)

RegisterNetEvent("core:vehicle:setPublic")
AddEventHandler("core:vehicle:setPublic", function(plate) -- delete useless
    local veh = GetVehicle(plate)
    if veh == nil then
        return false
    end
    veh:setVehiclePublic()
    return true
end)

RegisterNetEvent("core:SetPropsVeh")
AddEventHandler("core:SetPropsVeh", function(token, plate, props) -- done
    if CheckPlayerToken(source, token) then
        SetVehicleProps(plate, props)
    end
end)

RegisterNetEvent("core:AddItemToVehicle")
AddEventHandler("core:AddItemToVehicle", function(time, secu, token, item, amount, plate, metadatas, model) -- done
    local source = source
    if CheckTrigger(source, time, secu, "core:AddItemToVehicle") then
        if CheckPlayerToken(source, token) then
            local itemWeight = GetItemWeightWithCount(item, amount)
            if getInventoryWeightVehicle(plate) + itemWeight <= coffre[model] then
                SendItemToVehicle(source, item, amount, plate, metadatas, coffre[model]/1000)
            end
        end
    end
end)

RegisterNetEvent("core:AddStuffToVehicle")
AddEventHandler("core:AddStuffToVehicle", function(token, stuff, plate) -- done
    local source = source
    if CheckPlayerToken(source, token) then
        for k, v in pairs(stuff) do
            local quantity = math.random(v.qMin, v.qMax)
            if quantity > 0 then SendItemToVehicleStaff(source, v.item, quantity, plate, v.metadatas) end
        end
    end
end)

-- RegisterNetEvent("core:AddItemToVehicleStaff")
-- AddEventHandler("core:AddItemToVehicleStaff", function(token, item, amount, plate, metadatas) -- done
--     local source = source
--     if CheckPlayerToken(source, token) then
--         SendItemToVehicleStaff(source, item, amount, plate, metadatas)
--     end
-- end)

RegisterNetEvent("core:RemoveItemFromVehicle")
AddEventHandler("core:RemoveItemFromVehicle", function(token, item, amount, plate, name) -- done
    if CheckPlayerToken(source, token) then
        local itemWeight = GetItemWeightWithCount(item, amount)
        if getInventoryWeight(source) + itemWeight <= items.maxWeight or item == "money" then
            RemoveItemFromVehicle(source, item, amount, plate, name)
        end
    end
end)

RegisterNetEvent("core:SetVehicleOut")
AddEventHandler("core:SetVehicleOut", function(plate, netId, entity) -- done
    local veh = GetVehicle(plate)
    if veh == nil then
        return
    end
    veh:setVehicleOut(netId, entity)
    SetCoffreOpenable(plate)
end)

RegisterNetEvent("core:removeVeh")
AddEventHandler("core:removeVeh", function(plate) -- done
    local veh = GetVehicle(plate)
    if veh == nil then
        return
    end
    RemoveVehicle(plate)
end)

RegisterNetEvent("core:SetVehicleIn")
AddEventHandler("core:SetVehicleIn", function(plate) -- done
    local veh = GetVehicle(plate)
    if veh == nil then
        return false
    end
    veh:setVehicleIn()
    SetCoffreOpenable(plate)
    return true
end)

-- @Loops

Citizen.CreateThread(function()  -- done
    local vehicles
    while true do
        Wait(2 * 60000) -- 5min
        vehicles = GetAllVehiclesClass()
        for k, v in pairs(vehicles) do
            if v.needSave then
                v:saveVehicle()
                Wait(1000)
            end
        end
    end
end)

-- Clear abandoned cars
Citizen.CreateThread(function()
    local checkedForDel = {}
    Wait(10000)
    while true do 
        Wait(7 * 60000) -- 7 min pour faire que toutes les ~15 min ça del les veh mort
        --Wait(20000)
        for k, v in pairs(GetAllVehicles()) do
            if (GetVehicleEngineHealth(v) < 250.0) and (GetPedInVehicleSeat(v,-1) == 0) then 
                local plate = GetVehicleNumberPlateText(v)
                if plate then
                    if not checkedForDel[plate] then 
                        checkedForDel[plate] = true
                    else
                        local veh = GetVehicle(plate)
                        if veh then 
                            veh:setVehiclePound(2)
                        end
                        DeleteEntity(v)
                        checkedForDel[plate] = nil
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()  -- done
    local veh
    local vehicles
    Wait(1 * 60000) -- 1min
    while true do
        vehicles = GetAllVehiclesClass()
        for k, v in pairs(vehicles) do
            Wait(1000)
            veh = GetVehicle(v.currentPlate)
            if veh ~= nil then
                if veh.tmpVeh == false then
                    if not DoesEntityExist(NetworkGetEntityFromNetworkId(veh:getNetId())) and v.stored ~= 3 then
                        local isInGarage = carIsInGarage(veh:getPlate())
                        if v.stored == 1 then
                            if isInGarage == false then
                                veh:setVehiclePound(2)
                            end
                        elseif v.stored == 2 then
                            if isInGarage == true then
                                veh:setVehiclePound(1)
                            end
                        end
                    end
                else
                    if not DoesEntityExist(NetworkGetEntityFromNetworkId(veh:getNetId())) then
                        local isInGarage = carIsInGarage(veh:getPlate())
                        if isInGarage == false then
                            RemoveVehicle(v.currentPlate)
                        end
                    end
                end
            end
        end
        Wait(12 * 60000) -- 12min
    end
end)

local InsideCoffre = {}

RegisterNetEvent("core:joinedcoffre")
AddEventHandler("core:joinedcoffre", function(plate, bool)
    local source = source
    if bool then 
        if not InsideCoffre[plate] then 
            InsideCoffre[plate] = {}
        end
        table.insert(InsideCoffre[plate], source)
    else
        if not InsideCoffre[plate] then 
            InsideCoffre[plate] = {}
        end
        for k,v in pairs(InsideCoffre[plate]) do 
            if v == source then 
                table.remove(InsideCoffre[plate], k)
                --return 
                -- Possiblement plusieurs fois car quand on met un item ça réouvre le coffre (et flemme de faire un condition + c'est pas opti)
            end
        end
    end
end)


RegisterNetEvent("core:SyncInvVeh")
AddEventHandler("core:SyncInvVeh", function(token, Plate, model)  -- rework with class + -1 to change
    if CheckPlayerToken(source, token) then
        TriggerClientEvents("core:SyncInvVeh", InsideCoffre[Plate], Plate, model)
    end
end)

RegisterServerCallback('core:plateExist', function(source, plate)  -- done
    --local vehicles = GetAllVehiclesClass()
    --for k, v in pairs(vehicles) do
    --    if string.lower(v.currentPlate) == string.lower(plate) or string.lower(v.plate) == string.lower(plate) then
    --        return true
    --    end
    --end
    -- Tested, good
    return plateExists(all_trim(plate))
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        CorePrint("Resource stopping, saving vehicles.")
        local vehicles
        vehicles = GetAllVehiclesClass()
        for k, v in pairs(vehicles) do
            if v.tmpVeh == false then
                v:saveVehicle()
            end
        end
    end
end)

exports('WinVeh', function(source, vehicleProps)
    local model = vehicleProps.model
    local plate = GenerateNotOwnedPlate()
    local newPlayer = GetPlayer(source):getId()
    vehicleProps.plate = plate
    crew = nil
    job = nil

    MySQL.Async.execute("INSERT INTO vehicles (owner, plate, name, props, inventory, garage, vente, job) VALUES (@1, @2, @3, @4, @5, @6, @7, @8)"
        , {
            ["1"] = newPlayer,
            ["2"] = vehicleProps.plate,
            ["3"] = tostring(model),
            ["4"] = json.encode(vehicleProps),
            ["5"] = json.encode({}),
            ["6"] = "central",
            ["7"] = crew,
            ["8"] = job
        }, function(affectedRows)
        if affectedRows ~= 0 then
             local inv
            if coffre[GetHashKey(model)] ~= nil and coffre[GetHashKey(model)] / 1000 ~= nil then
                inv = json.encode({ item = {}, cloths = {}, weapons = {}, weight = { max = coffre[GetHashKey(model)] / 1000, current = 0 } })
            else
                inv = json.encode({ item = {}, cloths = {}, weapons = {}, weight = { max = 100, current = 0 } })
            end
			
            local veh = carDealerCreateCar({
                plate = vehicleProps.plate,
                owner = newPlayer,
                name = model,
                props = json.encode(vehicleProps),
                garage = nil,
                stored = 1,
                vente = crew,
                coowner = json.encode({}),
                job = job,
                inventory = json.encode(inv),
                mileage = 0,
                fuel = 100,
                body = json.encode({}),
                currentPlate = vehicleProps.plate
            })

            TriggerClientEvent('core:createKeys', source, vehicleProps.plate, tostring(model))

			local vehName = TriggerClientCallback(source, "core:getVehicleNameFromModel", model)

			if vehName ~= "NULL" then
				local params = {
					plate = props.plate,
					model = vehName,
				}

				exports['knid-mdt']:api().people.vehicles.create(newPlayer, params,
					function(cb)
						if cb == 201 then
							print("^2[" .. cb .. "]^0 MDT: (WIN VEH) Vehicle created : ^6", owner, json.encode(params), "^0")
						else
							print("^8[" .. cb .. "]^0 MDT: (WIN VEH) Error creating vehicle : ^6", owner, json.encode(params), "^0")
						end
					end)
			end
        else
            --[[TriggerClientEvent('core:ShowNotification', player, "~r~Erreur lors de l'achat du véhicule")]]
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Erreur lors de l'achat du véhicule"
            })
        end
    end)
    TriggerClientEvent('core:casinoCar', source, vehicleProps)
    return true
end)