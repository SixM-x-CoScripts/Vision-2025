local inDrugsDeliveries = {}
local deliveryId = {}
local createdVeh
local ped = {}
local dataTablette = {}
local token = nil
local commandData = {}
local propsToSpawn = {}
local items = {}
local ownerName = {}
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)
--local quantity
local blipMission


function GetTableCount(tabl)
    local count = 0
    for k,v in pairs(tabl) do 
        count += 1
    end
    return count
end

local function ClosestDrugWrap()
    local obj = {
        "hei_prop_hei_drug_pack_01b",
        "prop_box_guncase_01a",
        "prop_tool_box_04",
    }
    local objOne = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 5.0, GetHashKey(obj[1]), true)
    local objTwo = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 5.0, GetHashKey(obj[2]), true)
    local objThree = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 5.0, GetHashKey(obj[3]), true)
    local objFour = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 5.0, GetHashKey(obj[1]), false)
    local objFive = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 5.0, GetHashKey(obj[2]), false)
    local objSix = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 5.0, GetHashKey(obj[3]), false)
    closestObject = nil
    if objOne ~= 0 then 
        closestObject = objOne 
    elseif objTwo ~= 0 then 
        closestObject = objTwo 
    elseif objThree ~= 0 then 
        closestObject = objThree 
    elseif objFour ~= 0 then
        closestObject = objFour
    elseif objFive ~= 0 then
        closestObject = objFive
    elseif objSix ~= 0 then
        closestObject = objSix
    end
    return closestObject
end
function StartDrugsDeliveries(actualDeliveryId)
    CreateThread(function()
        inDrugsDeliveries[actualDeliveryId] = true
        local doneObjectAllow = 0
        local objectCreated = false
        local indexItems = 0
        local props = {
            offset = { 0.449, 0.02, -0.041, 3.1, -88.09, 0.0 }
        }
        local isTaken = false
        local takenObj = {}
        print("Start Drugs devlivery", actualDeliveryId)
        while inDrugsDeliveries[actualDeliveryId] do
            local pNear = false
            if #(p:pos() - dataTablette[actualDeliveryId].pos.xyz) <= 50 then
                if not objectCreated then
                    objectCreated = true
                    if dataTablette[actualDeliveryId].objects then
                        for k, v in pairs(dataTablette[actualDeliveryId].objects) do
                            Bulle.create("trailerSell"..v.id .. actualDeliveryId, vector3(v.pos.x, v.pos.y, v.pos.z + 1), "bulleRamasser", true)
                        end
                    end
                end
                pNear = true
                --local vehs = GetAllVehicleInArea(p:pos(), 10.0)
                --for key, veh in pairs(vehs) do
                --    SetVehicleDoorsLocked(veh, 0) -- Unlock all nsm
                --    SetVehicleHasBeenOwnedByPlayer(veh, true)
                --end

                if objectCreated and not isTaken then
                    for k, v in pairs(dataTablette[actualDeliveryId].objects) do
                        if tonumber(doneObjectAllow) < tonumber(GetTableCount(dataTablette[actualDeliveryId].objects)) then 
                            SetNetworkIdCanMigrate(v.netId, false) -- ne pas migrate car l'id peut changer sinon
                            SetNetworkIdExistsOnAllMachines(v.netId, true) -- netid exist pr tt le monde
                            for ke,ve in pairs(GetActivePlayers()) do
                                SetNetworkIdAlwaysExistsForPlayer(v.netId, ve, true) -- pr toujours et pr tt le monde
                            end
                            NetworkUseHighPrecisionBlending(v.netId, true)
                            print("Allow object", v.netId)
                            local objec = NetworkGetEntityFromNetworkId(v.netId)
                            if objec ~= 0 or objec ~= -1 then 
                                if DoesEntityExist(objec) then 
                                    SetEntityAsMissionEntity(objec, true, true)
                                end
                            end
                            doneObjectAllow += 1
                        end
                        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.pos.xyz) < 1.2 then
                            if IsControlJustPressed(0, 38) then
                                --local thisObject = NetworkGetEntityFromNetworkId(v.netId)
                                local obj = {
                                    "hei_prop_hei_drug_pack_01b",
                                    "prop_box_guncase_01a",
                                    "prop_tool_box_04",
                                }
                                local objOne = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.0, GetHashKey(obj[1]), true)
                                local objTwo = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.0, GetHashKey(obj[2]), true)
                                local objThree = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.0, GetHashKey(obj[3]), true)
                                closestObject = nil
                                if objOne ~= 0 then 
                                    closestObject = objOne 
                                elseif objTwo ~= 0 then 
                                    closestObject = objTwo 
                                elseif objThree ~= 0 then 
                                    closestObject = objThree 
                                end
                                thisObject = closestObject
                                if thisObject == nil then thisObject = NetworkGetEntityFromNetworkId(v.netId) end
                                local netId = NetworkGetNetworkIdFromEntity(thisObject)
                                NetworkRequestControlOfEntity(thisObject)
                                SetEntityAsMissionEntity(thisObject, true, true)
                                local timer = 1
                                while (not NetworkHasControlOfEntity(thisObject)) and timer < 100 do 
                                    Wait(1) 
                                    timer += 1
                                end 
                                SetNetworkIdCanMigrate(v.netId, true) -- allow other player to take control of the entity
                                TriggerServerEvent("removeBulle", v.id .. actualDeliveryId)
                                isTaken = true
                                takenObj = v
                                p:PlayAnim("pickup_object", "pickup_low", 0)
                                Wait(1000)
                                AttachEntityToEntity(netId, p:ped(),
                                GetEntityBoneIndexByName(p:ped(), "IK_R_Hand"), props.offset[1], props.offset[2]
                                , props.offset[3], props.offset[4], props.offset[5], props.offset[6], false,
                                false, false, false, 0.0, true)
                                print("check entity attached", GetEntityAttachedTo(thisObject), GetEntityAttachedTo(thisObject) == 0)
                                if GetEntityAttachedTo(thisObject) == 0 then
                                    local obj = {
                                        "hei_prop_hei_drug_pack_01b",
                                        "prop_box_guncase_01a",
                                        "prop_tool_box_04",
                                    }
                                    local objOne = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.0, GetHashKey(obj[1]), true)
                                    local objTwo = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.0, GetHashKey(obj[2]), true)
                                    local objThree = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.0, GetHashKey(obj[3]), true)
                                    closestObject = nil
                                    if objOne ~= 0 then 
                                        closestObject = objOne 
                                    elseif objTwo ~= 0 then 
                                        closestObject = objTwo 
                                    elseif objThree ~= 0 then 
                                        closestObject = objThree 
                                    end
                                    if closestObject then
                                        NetworkRequestControlOfEntity(closestObject)
                                        local timer = 1
                                        while (not NetworkHasControlOfEntity(closestObject)) and timer < 100 do 
                                            Wait(1) 
                                            timer += 1
                                        end 
                                        print("closestObject", closestObject, "hascontrol", NetworkHasControlOfEntity(closestObject))
                                        local validProps = GetHashKey(propsToSpawn[actualDeliveryId])
                                        print("try entity", GetEntityModel(closestObject), validProps)
                                        if validProps == 0 then 
                                            validProps = ClosestDrugWrap()
                                        end
                                        if GetEntityModel(closestObject) == validProps then
                                            AttachEntityToEntity(closestObject, p:ped(),
                                            GetEntityBoneIndexByName(p:ped(), "IK_R_Hand"), props.offset[1], props.offset[2]
                                            , props.offset[3], props.offset[4], props.offset[5], props.offset[6], false,
                                            false, false, false, 0.0, true)
                                        else
                                            isTaken = false
                                        end
                                        Bulle.removeClosestOfType(GetEntityCoords(PlayerPedId()), "bulleRamasser", 1.3)
                                        if GetEntityAttachedTo(closestObject) == 0 then 
                                            TriggerServerEvent("DeleteEntity", token, { ObjToNet(closestObject) })
                                            local lobj = entity:CreateObject(propsToSpawn[actualDeliveryId], GetEntityCoords(PlayerPedId())).id 
                                            AttachEntityToEntity(lobj, p:ped(),
                                                GetEntityBoneIndexByName(p:ped(), "IK_R_Hand"), props.offset[1], props.offset[2]
                                                , props.offset[3], props.offset[4], props.offset[5], props.offset[6], false,
                                                false, false, false, 0.0, true)
                                            isTaken = true
                                        end
                                    end
                                    --TriggerServerEvent("deleteObject", takenObj.id)
                                end
                            end
                        end
                    end
                else
                    local vehs = GetAllVehicleInArea(p:pos(), 10.0)
                    for key, veh in pairs(vehs) do
                        if (GetDistanceBetweenCoords(p:pos(), GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "platelight")), true) < 1.5 or
                            GetDistanceBetweenCoords(p:pos(), GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "boot")), true) < 1.5) then
                            Bulle.create("poserCoffreDrug", GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "platelight")) + vector3(0.0, 0.0, 0.5), "bulleDeposer", true)
                            if IsControlJustReleased(0, 38) and isTaken then
                                isTaken = false
                                indexItems = TriggerServerCallback("drugsDelivery:getIndex", p:getCrew(), actualDeliveryId)
                                print('indexItems', indexItems)
                                local entity = GetEntityAttachedTo(PlayerPedId())
                                SetVehicleDoorOpen(veh, 5, false, false)
                                p:PlayAnim("anim@heists@narcotics@trash", "throw_b", 49)
                                Wait(1000)
                                DetachEntity(NetworkGetEntityFromNetworkId(takenObj.netId))
                                DetachEntity(entity)
                                DetachObjet(PlayerPedId())
                                TriggerServerEvent("deleteObject", takenObj.id, entity)
                                ClearPedTasks(p:ped())
                                SetVehicleDoorShut(veh, 5, false, false)
                                --print("item", json.encode(items))
                                Bulle.remove("poserCoffreDrug")
                                -- if indexItems == "finished" then 
                                --     exports['vNotif']:createNotification({
                                --         type = 'ROUGE',
                                --         content = "Vous avez déjà pris tout les objets de cette livraison."
                                --     })
                                --     return
                                -- end
                                print("items[indexItems]", items[indexItems])
                                if items[indexItems] and type(items[indexItems]) == "table" and items[indexItems].name and items[indexItems].quantity then 
                                    --print("add to coffre", items[indexItems].name, items[indexItems].quantity, GetVehicleNumberPlateText(veh))
                                    TriggerServerEvent("drugsDeliveries:addItemTrunk", token, all_trim(GetVehicleNumberPlateText(veh)), items[indexItems].name, items[indexItems].quantity, actualDeliveryId)
                                end
                                takenObj = {}
                            end
                        end
                    end
                end
            end
            if pNear then
                Wait(1)
            else
                Wait(500)
            end

        end
    end)
end

-- RegisterNetEvent("drugsDeliveries:StartMissionBlips")
-- AddEventHandler("drugsDeliveries:StartMissionBlips", function(dataTablette)
-- end)

local blipsEn = {}
function setEnemyBlip(pos, delId)
    local timeBlips = 5 * 60000
    local random = math.random(100, 300.0)
    local random2 = math.random(1, 4)
    if random2 == 1 then
        pos = vector3(pos.x + random, pos.y + random, pos.z + random)
    elseif random2 == 2 then
        pos = vector3(pos.x + random, pos.y - random, pos.z + random)
    elseif random2 == 3 then
        pos = vector3(pos.x - random, pos.y + random, pos.z + random)
    elseif random2 == 4 then
        pos = vector3(pos.x - random, pos.y - random, pos.z + random)
    end
    blipsEn[delId] = AddBlipForRadius(pos, 500.0)
    SetBlipSprite(blipsEn[delId], 9)
    SetBlipColour(blipsEn[delId], 1)
    SetBlipAlpha(blipsEn[delId], 100)
end

function splitItem(_id)
    items = {}
    local nbr = 0
    local ins = false
    --print("splitItem", #commandData[_id], commandData[_id][1].spawnName, commandData[_id][1].quantity, json.encode(commandData[_id], {indent=true}))
    if commandData[_id][1] == "drugs" then
        if tonumber(commandData[_id][1].quantity) % 2 ~= 0 then 
            commandData[_id][1].quantity += 1
        end
    end
    for i = 1, #commandData[_id] do
        if commandData[_id][i].type == "weapons" then
            ins = true
            items[i] = {}
            if not commandData[_id][i] then 
                commandData[_id][i] = {}
            end
            items[i].name = commandData[_id][i].spawnName
            items[i].quantity = commandData[_id][i].quantity
           -- print(items[i].name, items[i].quantity)
        end
    end
    if ins then
        return
    end
    --print("splitItem", #commandData[_id], commandData[_id][1].spawnName, commandData[_id][1].quantity, json.encode(commandData[_id][1]))
    if #commandData[_id] == 1 and commandData[_id][1].quantity < 4 then
        for i = 1, commandData[_id][1].quantity do
            items[i] = {}
            items[i].name = commandData[_id][1].spawnName
            items[i].quantity = 1
            --print("Item0-1", items[i].name, items[i].quantity)
        end
        return
    end
    if #commandData[_id] == 1 then --if 1 item split in four
        nbr = 0
        for i = 1, 4 do
            items[i] = {}
            items[i].name = commandData[_id][1].spawnName
            items[i].quantity = math.floor(commandData[_id][1].quantity/4)
            --print("Item1", items[i].name, items[i].quantity)
            nbr = nbr + math.floor(commandData[_id][1].quantity/4)
        end
        if nbr < commandData[_id][1].quantity then items[4].quantity = items[4].quantity + (commandData[_id][1].quantity - nbr) end
    elseif #commandData[_id] == 2 then --if 2 items split in 2 by 2
        if commandData[_id][1].quantity < 2 then
            items[1] = {}
            items[1].name = commandData[_id][1].spawnName
            items[1].quantity = 1
            --print("Item2-1", items[1].name, items[1].quantity)
        else
            nbr = 0
            for i = 1, 2 do
                items[i] = {}
                items[i].name = commandData[_id][1].spawnName
                items[i].quantity = math.floor(commandData[_id][1].quantity/2)
                --print("Item2-1", items[i].name, items[i].quantity)
                nbr = nbr + math.floor(commandData[_id][i].quantity/2)
            end
            if nbr < commandData[_id][1].quantity then items[2].quantity = items[2].quantity + (commandData[_id][1].quantity - nbr) end
        end
        if commandData[_id][2].quantity < 2 then
            items[3] = {}
            items[3].name = commandData[_id][1].spawnName
            items[3].quantity = 1
            --print("Item2-1", items[3].name, items[3].quantity)
        else
            nbr = 0
            for i = 1, 2 do
                items[i+2] = {}
                items[i+2].name = commandData[_id][2].spawnName
                items[i+2].quantity = math.floor(commandData[_id][2].quantity/2)
                --print("Item2-2", items[i+2].name, items[i+2].quantity)
                nbr = nbr + math.floor(commandData[_id][2].quantity/2)
            end
            if nbr < commandData[_id][2].quantity then items[4].quantity = items[4].quantity + (commandData[_id][2].quantity - nbr) end
        end
    elseif #commandData[_id] == 3 then --if 3 items split in 2 the bigger en 2 other
        local bigger = 0
        local indexE = 1
        for i = 1, #commandData[_id] do --find the biggest quantity item
            if commandData[_id][i].quantity > bigger then
                bigger = commandData[_id][i].quantity
                indexE = i
            end
        end
        --print("big", bigger, indexE)
        if commandData[_id][indexE].quantity < 2 then
            items[1] = {}
            items[1].name = commandData[_id][indexE].spawnName
            items[1].quantity = 1
            --print("Item3-1", items[1].name, items[1].quantity)
        else
            nbr = 0
            for i = 1, 2 do
                items[i] = {}
                items[i].name = commandData[_id][indexE].spawnName
                items[i].quantity = math.floor(commandData[_id][indexE].quantity/2)
                --print("Item3-1", items[i].name, items[i].quantity)
                nbr = nbr + math.floor(commandData[_id][i].quantity/2)
            end
            if nbr < commandData[_id][indexE].quantity then items[2].quantity = items[2].quantity + (commandData[_id][indexE].quantity - nbr) end
        end
        local j = 3
        for i = 1, #commandData[_id] do --find the biggest quantity item
            if i ~= indexE then
                items[j] = {}
                items[j].name = commandData[_id][i].spawnName
                items[j].quantity = math.floor(commandData[_id][i].quantity)
                --print("Item3-2", items[j].name, items[j].quantity)
                j = j + 1
            end
        end
    else  --if 4 items or more split in 3 plus the other
        for i = 1, 4 do
            items[i] = {}
            items[i].name = commandData[_id][i].spawnName
            items[i].quantity = math.floor(commandData[_id][i].quantity)
            --print("Item4-1", items[i].name, items[i].quantity)
        end
        -- for i = 1, #commandData do --find the biggest quantity item
        --     items[4] = {}
        --     items[4].name = commandData[i].spawnName
        --     items[4].quantity = math.floor(commandData[i].quantity)
        --     print("Item4-2", items[i].name, items[i].quantity)
        -- end
    end
end

-- RegisterNetEvent("drugsDeliveries:removeBulle")
-- AddEventHandler("drugsDeliveries:removeBulle", function(robertoName, crew)
function endDeliveryMessage(crew, thatdeliveryId)
    print("A", crew, ownerName[thatdeliveryId], p:getCrew())
    if ownerName[thatdeliveryId] == true then
        print("B")
        if crew == p:getCrew() then
            print("B")
            exports['vNotif']:createNotification({
                type = 'ILLEGAL',
                name = "Kannan",
                label = "Livraison",
                labelColor = "#F3F049",
                logo = "https://www.grandtheftauto5.fr/images/artworks-officiels/gta5-artwork-25-hd.jpg",
                mainMessage = "Ta commande est finie, échappe toi !",
                duration = 20,
            })
        else
            exports['vNotif']:createNotification({
                type = 'ILLEGAL',
                name = "Kannan",
                label = "Livraison",
                labelColor = "#F3F049",
                logo = "https://www.grandtheftauto5.fr/images/artworks-officiels/gta5-artwork-25-hd.jpg",
                mainMessage = "Une commande vient d'être terminée, poursuis-les !",
                duration = 20,
            })
        end
    else
        if ownerName[thatdeliveryId] == p:getCrew() then
            exports['vNotif']:createNotification({
                type = 'ILLEGAL',
                name = "Kannan",
                label = "Livraison",
                labelColor = "#F3F049",
                logo = "https://www.grandtheftauto5.fr/images/artworks-officiels/gta5-artwork-25-hd.jpg",
                mainMessage = "Tu viens de te faire voler ta livraison, viens la retrouver !",
                duration = 20,
            })
        elseif crew == p:getCrew() then
            exports['vNotif']:createNotification({
                type = 'ILLEGAL',
                name = "Kannan",
                label = "Livraison",
                labelColor = "#F3F049",
                logo = "https://www.grandtheftauto5.fr/images/artworks-officiels/gta5-artwork-25-hd.jpg",
                mainMessage = "Tu as volé une commande, échappe toi !",
                duration = 20,
            })
        else
            exports['vNotif']:createNotification({
                type = 'ILLEGAL',
                name = "Kannan",
                label = "Livraison",
                labelColor = "#F3F049",
                logo = "https://www.grandtheftauto5.fr/images/artworks-officiels/gta5-artwork-25-hd.jpg",
                mainMessage = "Une commande vient d'être volée, poursuis-les !",
                duration = 20,
            })
        end
    end
    RemoveBlip(blipMission)
end

RegisterNetEvent("drugsDeliveries:StartMission")
AddEventHandler("drugsDeliveries:StartMission", function(dataDeliveries, crewName, typeObject, _data, randomtime, _id, crewTypeNeeed)
    -- Jsp comment mais des gens ont la notif alors qu'ils ont pas de crew
    print("Start command ID : ", _id)
    if string.lower(p:getCrew()) == "none" then 
        print("Dont start command because no crew")
        return 
    end
    if crewTypeNeeed then
        if string.lower(p:getCrew()) ~= string.lower(crewName) then
            if string.lower(p:getCrewType()) ~= string.lower(crewTypeNeeed) then
                print("Not the same crew type", p:getCrewType(), crewTypeNeeed)
                return 
            end
        end
    else
        print("No crew type needed")
    end
    deliveryId[_id] = true -- For multiple commands at once
    dataTablette[_id] = _data  -- For multiple commands at once
    commandData[_id] = dataDeliveries
    propsToSpawn[_id] = Drugs.props.ground[typeObject or "drugs"]
    ownerName[_id] = true -- For multiple commands at once
    splitItem(_id)
    if p:getCrew() == crewName then
        print("1")
        inDrugsDeliveries[_id] = true
        --TriggerServerEvent("drugsDeliveries:msg1", vector2(dataTablette.pos.x, dataTablette.pos.y))
        exports['vNotif']:createNotification({
            type = 'ILLEGAL',
            name = "Kannan",
            label = "Livraison",
            labelColor = "#F3F049",
            logo = "https://www.grandtheftauto5.fr/images/artworks-officiels/gta5-artwork-25-hd.jpg",
            mainMessage = "Hey, ta livraison viens d'arriver, va vite la chercher !",
            duration = 20,
        })
        StartDrugsDeliveries(_id)
        if dataTablette[_id].objects then
            local doneee = 0
            for k, v in pairs(dataTablette[_id].objects) do
                if doneee == 0 then
                    doneee = 1
                    if v.pos then
                        blipMission = AddBlipForCoord(v.pos.x, v.pos.y, v.pos.z)
                    end
                end
            end
        else
            blipMission = AddBlipForCoord(dataTablette[_id].pos.x, dataTablette[_id].pos.y, dataTablette[_id].pos.z)
        end
        SetNewWaypoint(dataTablette[_id].pos.x, dataTablette[_id].pos.y)
        --blipMission = AddBlipForCoord(dataTablette.pos.x, dataTablette.pos.y, dataTablette.pos.z)
       -- blipMission = AddBlipForRadius(dataTablette.pos.x, dataTablette.pos.y, dataTablette.pos.z, 40.0)
        SetBlipSprite(blipMission, 478)
        SetBlipScale(blipMission, 0.75)
        SetBlipColour(blipMission, 3)
        SetBlipAsShortRange(blipMission, true)
        SetBlipRoute(blipMission, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName("~r~Livraison")
        EndTextCommandSetBlipName(blipMission)
        CreateThread(function()
            Wait(5*60000)
            RemoveBlip(blipMission)
        end)
    else
        Wait(randomtime and randomtime * 1000 or 10000)
        inDrugsDeliveries[_id] = true
        --TriggerServerEvent("drugsDeliveries:msgEnemy")
        exports['vNotif']:createNotification({
            type = 'ILLEGAL',
            name = "Kannan",
            label = "Livraison",
            labelColor = "#F3F049",
            logo = "https://www.grandtheftauto5.fr/images/artworks-officiels/gta5-artwork-25-hd.jpg",
            mainMessage = "Hey, une livraison viens d'arriver, va vite la voler !",
            duration = 20,
        })
        setEnemyBlip(dataTablette[_id].pos, _id)
        StartDrugsDeliveries(_id)
        CreateThread(function()
            Wait(2*60000)
            RemoveBlip(blipsEn[delId])
        end)
        --elseif p:getCrew() ~= "None" then --todo check in bdd if crew have drugs weapond ect + add other crew on start script too
    end
end)

RegisterNetEvent("core:removeBulleTablet", function(id)
    Bulle.remove("trailerSell"..id)
end)

RegisterNetEvent("core:drugsDeliveries:endDelivery", function(deliveryIde, crew)
    if deliveryId[deliveryIde] then
        inDrugsDeliveries[deliveryIde] = false
        endDeliveryMessage(crew, deliveryIde)
        if dataTablette[deliveryIde] and dataTablette[deliveryIde].objects then
            for k,v in pairs(dataTablette[deliveryIde].objects) do 
                if v and v.x then
                    Bulle.removeClosestOfType(vector3(v.x, v.y, v.z), "bulleRamasser", 1.3)
                end
            end
        end
        Wait(1000)
        deliveryId[deliveryIde] = nil 
    end
end)