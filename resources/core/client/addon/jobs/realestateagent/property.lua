local token = nil
local properties = {}
local selectedProperty = nil
local loaded_vehicles = {}
in_garage = false
local just_outed_of_garage = false
local current_time = nil
IsInGarage = in_garage

currentVeh = nil
AllPropBulles = {}

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

-- Only the connecting player receives it
RegisterNetEvent("core:property:client:getProperties")
AddEventHandler("core:property:client:getProperties", function(properties2)

    properties = properties2

    print("Loaded properties", properties)
    LoadProperties(properties)

    -- if player is in a property, load it
    local last_property = TriggerServerCallback("core:getPlayerLastProperty", token)
    if (last_property ~= nil) then
        for _, property in pairs(properties) do
            if property.id == last_property.id then
                selectedProperty = last_property
                TriggerServerEvent("core:InstancePlayer", token, selectedProperty.id, "Property : Ligne 25")
                TriggerServerEvent("core:AddPlayerInHouse", token, selectedProperty.id)
                if selectedProperty.data.type == "garage" then
                    GarageInterior(FindInterior(selectedProperty))
                else
                    AppartementInterior(FindInterior(selectedProperty))
                end
                break
            end
        end
    end
end)

function GetAllProperties()
    return properties
end


CreateThread(function()
    current_time = GlobalState.OsTime
end)

-- Everyone receives it
RegisterNetEvent("core:property:new")
AddEventHandler("core:property:new", function(new_property)
    table.insert(properties, new_property)
    Wait(1000)
    LoadProperty(new_property)
end)

-- Only the new co owner receives it
RegisterNetEvent("core:property:addCoOwner")
AddEventHandler("core:property:addCoOwner", function(propertyId, target)

    for i, property in pairs(properties) do
        if property.id == propertyId then
            table.insert(property.co_owner, target)
            selectedProperty.co_owner = property.co_owner
            break
        end
    end

    -- Update selected property if the player is in it
    if selectedProperty ~= nil and selectedProperty.id == propertyId then
        if selectedProperty.data and selectedProperty.data.type == "garage" or GetPropertyInteriorType(selectedProperty.id) == "garage" then
            GarageInterior(FindInterior(selectedProperty))
        else
            AppartementInterior(FindInterior(selectedProperty))
        end
    end
end)

-- Only the new co owner receives it
RegisterNetEvent("core:property:removeCoOwner")
AddEventHandler("core:property:removeCoOwner", function(propertyId, target)
    for i, property in pairs(properties) do
        if property.id == propertyId then
            for k, co_owner in pairs(property.co_owner) do
                if co_owner == target then
                    table.remove(property.co_owner, k)
                    selectedProperty.co_owner = property.co_owner
                    break
                end
            end
            break
        end
    end

    -- if player is in the property, remove markers
    if selectedProperty ~= nil and selectedProperty.id == propertyId then
        zone.removeZone("property_leave")
        zone.removeZone("property_gestion")
        if (selectedProperty.data and selectedProperty.data.type ~= "garage") or (GetPropertyInteriorType(selectedProperty.id) ~= "garage") then
            zone.removeZone("property_coffre")
        end
    end
end)

-- Everyone receives it
RegisterNetEvent("core:property:delete")
AddEventHandler("core:property:delete", function(propertyId)
    -- Check if the player is in the property
    -- If so, leave it
    if selectedProperty ~= nil and selectedProperty.id == propertyId then
        LeaveProperty()
        selectedProperty = nil
        in_garage = false
    end
    -- Rebuild the properties table
    local newProperties = {}
    for i, property in pairs(properties) do
        if property.id ~= propertyId then
            table.insert(newProperties, property)
        end
    end
    properties = newProperties

    -- Remove the property from the zone
    zone.removeZone("property " .. propertyId)
    zone.removeBulle("property " .. propertyId)
end)

-- Only players in the property receive it
RegisterNetEvent("core:property:updateVehicles")
AddEventHandler("core:property:updateVehicles", function(propertyId)
    if selectedProperty ~= nil and selectedProperty.id == propertyId then

        -- Delete all vehicles
        for i, j in pairs(loaded_vehicles) do
            if DoesEntityExist(j.entity) then
                DeleteEntity(j.entity)
            end
        end

        -- Load new ones
        GarageInterior(FindInterior(selectedProperty))

    end
end)

-- Only players in the property receive it
RegisterNetEvent("core:property:refreshInventory")
AddEventHandler("core:property:refreshInventory", function(propertyId, inventory)

    if selectedProperty ~= nil and selectedProperty.id == propertyId then
        local propertyName = GetPropertyName(selectedProperty.id)

        selectedProperty.inventory = inventory
        pInv = FormulateInventory(TriggerServerCallback("core:GetInventory", token))
        SendNUIMessage({
            type = "updateInventory",
            data = {
                items = pInv,
                clothes = {},
                weapons = {},
                target = {
                    items = inventory,
                    maxWeight = tonumber(TriggerServerCallback("core:properties:getWeight", propertyId)) or 0,
                    name = "Propriété " .. (propertyName or "Inconnu")
                }
            }
        })
    end
end)

-- Only player who ring the doorbell receive it
RegisterNetEvent("core:property:enterByDoorbell")
AddEventHandler("core:property:enterByDoorbell", function(propertyId)
    selectedProperty = TriggerServerCallback("core:property:getPropertyOpti", token, propertyId)
    TriggerServerEvent("core:InstancePlayer", token, propertyId, "Property : Ligne 289")
    TriggerServerEvent("core:AddPlayerInHouse", token, propertyId)
    EnterProperty(selectedProperty)
end)


CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do Wait(100) end
    Wait(5000)
    DoScreenFadeIn(800)
    TriggerServerEvent("core:property:getProperties")
    while true do
        if in_garage then
            for i, j in pairs(loaded_vehicles) do
                SetEntityCoordsNoOffset(j.entity, j.pos.xyz, 0.0, 0.0, 0.0)
                SetEntityHeading(j.entity, j.pos.w)
                SetVehicleOnGroundProperly(j.entity)
            end
        end
        Wait(1000)
    end
end)

CreateThread(function()
    local current_plate
    local currentveh = nil
    while true do
        if in_garage then
            if p:isInVeh() and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
                --ShowHelpNotification("~INPUT_CONTEXT~ Sortir")
                local x,y,z = table.unpack(GetEntityCoords(GetVehiclePedIsIn(PlayerPedId())))
                Bulle.create("propertySortir", x,y,z, "bulleSortir", true)
                if IsControlJustPressed(0, 38) then
                    in_garage = false
                    Bulle.hide("propertySortir")
                    Bulle.remove("propertySortir")
                    current_plate = vehicle.getPlate(p:currentVeh())
                    for i, j in pairs(loaded_vehicles) do
                        if DoesEntityExist(j.entity) then
                            DeleteEntity(j.entity)
                        end
                        -- find the vehicle player is in
                        if j.plate == current_plate then
                            currentVeh = j
                        end
                    end
                    LeaveGarage(currentVeh)
                    loaded_vehicles = {}
                end

            end
            Wait(1)
        else
            Wait(500)
        end
    end
end)

function DrawBlip(_type, name, pos)
    local blip = AddBlipForCoord(pos.x, pos.y, pos.z)
    SetBlipSprite(blip, _type)
    if _type == 40 then
        SetBlipColour(blip, 2)
    else
        SetBlipColour(blip, 29)
    end
    SetBlipScale(blip, 0.75)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
end

-- Arg 1: The properties list
-- Load all properties in the world (blip and marker)
function LoadProperties(props)
    local timer = 1
    while current_time == nil and timer < 300 do Wait(1) timer += 1 end
    if current_time == nil then
        current_time = GlobalState.OsTime
    end

    for i, property in pairs(props) do
        LoadProperty(property)
    end
end

function LoadProperty(property)
    local blip, marker, bulleT = 40, 25, "bulleHabitation"

    if (property.data and property.data.type == "garage") or (property.typeint or GetPropertyInteriorType(property.id)) == "garage" then
        blip, marker, bulleT = 357, 36, "bulleGarage"
    elseif (property.data and property.data.type == "stockage") or (property.typeint or GetPropertyInteriorType(property.id)) == "stockage" then
        blip, marker, bulleT = 473, 25, "bulleStockage"
    end

    local propertyName = (property.name or GetPropertyName(property.id))

    -- If the player has access to the property, set the blip color to green
    if PlayerHasAccessToProperty(property, false, true) then
        -- Create the blip
        DrawBlip(blip, (propertyName or "Habitation"), vector3(property.enter_pos.x, property.enter_pos.y, property.enter_pos.z))
    end

    -- Create the marker
    table.insert(AllPropBulles, {id = "property " .. property.id, x = property.enter_pos.x, y = property.enter_pos.y, z = property.enter_pos.z})
    zone.addZone(
        "property " .. property.id,
        vector3(property.enter_pos.x, property.enter_pos.y, property.enter_pos.z),
        "~INPUT_CONTEXT~ Accéder à la propriété",
        function()
            if not useCrochet then
                if not inHeist then
                    selectedProperty = TriggerServerCallback("core:property:getPropertyOpti", token, property.id)
                    if p:isInVeh() and GetPedInVehicleSeat(GetVehiclePedIsIn(p:ped()), -1) == PlayerPedId() then
                        if not IsPedInAnyHeli(PlayerPedId()) or not IsPedInAnyPlane(PlayerPedId()) then
                            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), property.enter_pos.x, property.enter_pos.y, property.enter_pos.z) > 1.6 then
                                return
                            end
                        end
                        if just_outed_of_garage then return end
                        if not PlayerHasAccessToProperty(property) then
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                content = "~s Vous n'avez pas accès à cette propriété"
                            })
                            return
                        end
                        if GetPropertyInteriorType(property.id) == "garage" then
                            local selectedGarage = TriggerServerCallback("core:property:getVehiclesInGarage", token, property.id)
                            local veh = p:currentVeh()
                            local plate = vehicle.getPlate(veh)
                            local props = vehicle.getProps(veh)

                            -- If garage is full
                            if #selectedGarage >= GetGarageVehCount(property) then
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    content = "~s Le garage est plein"
                                })
                                return
                            end
                            if inTryVeh then
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    content = "Essaie pas de duppli"
                                })
                                return
                            end
                            TriggerServerEvent("core:SetPropsVeh", token, all_trim(plate), props)
                            DoScreenFadeOut(800)
                            Wait(400)
                            -- Delete the vehicle
                            TriggerServerEvent("core:SetVehicleIn", all_trim(plate))

                            -- Remove vehicle from persistent-vehicles
                            TriggerEvent('persistent-vehicles/forget-vehicle', p:currentVeh())
                            DeleteEntity(veh)

                            -- Set the vehicle in the garage
                            TriggerServerEvent("core:property:addVehicle", token, property.id, props)

                            -- Wait for the vehicle to be saved
                            Wait(400)

                            -- Set player in the property
                            TriggerServerEvent("core:InstancePlayer", token, property.id, "Property : Ligne 289")
                            TriggerServerEvent("core:AddPlayerInHouse", token, property.id)

                            -- Enter the property
                            EnterProperty(property)

                        else
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                content = "~s Vous ne pouvez pas entrer en véhicule dans cette propriété"
                            })
                        end
                    else
                        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), property.enter_pos.x, property.enter_pos.y, property.enter_pos.z) < 1.6 then
                            local mailbox = TriggerServerCallback("core:property:getMailbox", token, property.id)
                            local locked = IsPropertyLocked(property, true)
                            local owner_fullname = (property.name or GetPropertyOwnerFullname(property.id)) or "Inconnu"
                            printDev("Property locked", locked)
                            SendNuiMessage(json.encode({
                                type = 'openWebview',
                                name = 'MenuProprieteAlt',
                                data =   {
                                    boiteWeight = computeInventoryWeight(mailbox),
                                    isLocked    = locked,
                                    name        = propertyName or "Propriété",
                                    canPerqui   = false,
                                    owner       = (GetPropertyInteriorType(property.id) == "stockage" and "Stockage Privé") or (owner_fullname)
                                }
                            }))
                        end
                    end
                end
            end
        end,
        false,
        marker,             -- Id / type du marker
        0.6,                -- La taille
        { 51, 204, 255 },   -- RGB
        170,                 -- Alpha
        5.0,
        true,
        bulleT or "bulleHabitation"
    )
end

function UnloadProperty(property)
    zone.removeZone("property " .. property.id)
end

function IsPropertyLocked(property, shouldshow)
    if GlobalState["propertyDoorState_"..property.id] == true then
        return false
    elseif PlayerHasAccessToProperty(property, shouldshow) then
        return false
    else
        return true
    end
end

function GetPropertyOwner(property)
    return (property.owner and property.owner) or (GetCachedPropertyOwner(property.id))
end

function GetPropertyCoOwners(property)
    if property and property.co_owner then
        return property.co_owner
    else
        return {}
    end
end

function GetPropertyRentalEnd(property)
    if not property then return 0 end
    property.rentalEnd = GetPropertyRentalEndCache(property.id)
    return property.rentalEnd
end

function PlayerHasAccessToProperty(property, shouldshow, init)
    -- If the player is the owner, return true
    while not p do Wait(1) end
    if not current_time then
        current_time = GlobalState.OsTime
    end
    -- if property.rentalEnd is outdated, return false
    printDev("Property ID", property.id)
    if not init then
        local rental = property.rentalEnd or GetPropertyRentalEnd(property)
        property.rentalEnd = rental
        if property.rentalEnd ~= nil and tonumber(property.rentalEnd) < current_time then
            if shouldshow then
                local count = tonumber(math.floor(((tonumber(property.rentalEnd) - current_time)/86400)+5))
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = 'Appelez un agent immobilier pour renouveler le bail. '.. ((type(count) == "number" and count > 0 and count or 0) or count) ..' jours restants'
                })
                print("Jours restants", count)
            end
            return false
        end
    end

    if tonumber(GetPropertyOwner(property)) == p:getId() then
        printDev("Im a owner")
        return true
    end
    -- If the player is the one of the co-owners, return true
    for k, v in pairs(GetPropertyCoOwners(property)) do
        if tonumber(v) == p:getId() then
            printDev("Im a coowner")
            return true
        end
    end

    -- If the player is in the crew/job, return true
    local proptype = (property.type or GetPropertyType(property.id))
    local propcrew = (property.crew or GetPropertyCrew(property.id))
    -- put a string to lower
    printDev("proptype", proptype, "propcrew", propcrew)
    if proptype and propcrew then
        if string.lower(proptype) == "entreprise" and propcrew == p:getJob() and string.lower(propcrew) ~= "aucun" then
            return true
        end
        if string.lower(proptype) == "crew" and propcrew == p:getCrew() and string.lower(propcrew) ~= "none" then
            return true
        end
    end

    -- Else, player can't enter without ringing
    return false
end

function PlayerCanSearchInProperty(property)
    if p:getJob() == "gcp" or (p:getJob() == "realestateagent" and dutyproperty) or p:getJob() == "justice" then
        return true
    end
    if p:getJob() == "lspd" or p:getJob() == "lssd" or p:getJob() == "usss" then
        if p:getJobGrade() > 3 then
            return true
        else
            return false
        end
    end
    if p:getPermission() >= 3 then
        return true
    end
    return false
end

function PlayerCanOpenPropertyCoffre()
    if PlayerHasAccessToProperty(selectedProperty) then
        return true
    end
    if p:getJob() == "lspd" or p:getJob() == "lssd" or p:getJob() == "usss" or p:getJob() == "gcp" or p:getJob() == "justice" then
        return true
    end
    if p:getJobGrade() >= 3 then
        return true
    end
    return false
end

function computeInventoryWeight(inventory)
    if not inventory then return 0 end
    local weight = 0
    for k, v in pairs(inventory) do
        weight = weight + (v.weight * v.count)
    end
    return weight
end

function GetGarageVehCount(property)
    return #FindInterior(property).vehPos
end

function FindInterior(property)
    printDev("FindInterior, propertyId", property.id)
    local proptype = GetPropertyInteriorType(property.id)
    if proptype == "habitation" then
        proptype = "Appartement"
    end

    if proptype == "stockage" then
        proptype = "Entrepot"
    end

    if proptype == "garage" then
        proptype = "Garage"
    end

    local interiorprop = GetPropertyInterior(property.id)
    for k, v in pairs(Property) do
        for i = 1, #Property[k].data do
            RemoveIpl(Property[k].data[i].ipl)
        end
        if k == proptype then
            for _, data in pairs(v.data) do
                if data.name == interiorprop then
                    table.insert(Utils.GlobalCache, {type = "property", value = GetInteriorAtCoords(data.pos)})
                    PinInteriorInMemory(int)
                    if data.ipl ~= "" then
                        EnableIpl(data.ipl, true)
                        while not IsIplActive(data.ipl) do
                            Wait(25)
                        end
                    end
                    return data
                end
            end
        end
    end
end

function EnterProperty(propertyData)
    CreateThread(function()
        DoScreenFadeOut(800)

        while not IsScreenFadedOut() do
            Wait(20)
        end

        bypassAntiTeleport = true
        local interior = FindInterior(propertyData)
        local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), interior.pos)
        Wait(50)
        SetEntityCoords(PlayerPedId(), interior.pos)
        Wait(50)
        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do Wait(1) end
        SetEntityCoords(PlayerPedId(), interior.pos)
        if string.lower(GetPropertyInteriorType(propertyData.id)) == "garage" then
            GarageInterior(interior)
        else
            AppartementInterior(interior)
        end
        -- Save the last property
        TriggerServerEvent("core:updateLastProperty", token, json.encode({
            id = propertyData.id,
            type = "property"
        }))
        if distance > 2000 then -- deload auto de gta donc on wait
            Wait(1000)
            SetEntityCoords(PlayerPedId(), interior.pos)
            Wait(500)
        end
        Wait(700)
        TriggerServerEvent("core:enterDecorationProperty", token, propertyData, true)
        DoScreenFadeIn(1000)
        bypassAntiTeleport = false
    end)
end

function LeaveProperty()
    DoScreenFadeOut(800)
    setBypassAntiTeleport(true)
    while not IsScreenFadedOut() do
        Wait(20)
    end
    local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), selectedProperty.enter_pos.x, selectedProperty.enter_pos.y, selectedProperty.enter_pos.z)

    Wait(50)
    TriggerServerEvent("core:rmvPlayerInHouse", token, GetPlayerServerId(PlayerId()), selectedProperty.id)
    TriggerServerEvent("core:InstancePlayer", token, 0, "Property : Ligne 465")
    TriggerServerEvent('core:leaveDecorationProperty', token, selectedProperty, false)
    SetEntityCoords(PlayerPedId(), selectedProperty.enter_pos.x, selectedProperty.enter_pos.y, selectedProperty.enter_pos.z)

    zone.removeZone("property_leave")
    zone.removeZone("property_coffre")
    zone.removeZone("property_gestion")
    TriggerServerEvent("core:updateLastProperty", token, json.encode({}))
    Wait(50)
    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do Wait(1) end
    SetEntityCoords(PlayerPedId(), selectedProperty.enter_pos.x, selectedProperty.enter_pos.y, selectedProperty.enter_pos.z)
    if distance > 2000 then -- deload auto de gta donc on wait
        Wait(1000)
        SetEntityCoords(PlayerPedId(), selectedProperty.enter_pos.x, selectedProperty.enter_pos.y, selectedProperty.enter_pos.z)
        Wait(500)
    end
    selectedProperty = nil
    in_garage = false
    DoScreenFadeIn(800)
    for k,v in pairs(Utils.GlobalCache) do
        if v.type == "property" then
            UnpinInterior(v.value)
            table.remove(Utils.GlobalCache, k)
        end
    end
    setBypassAntiTeleport(false)
end

function LeaveGarage(veh)
    DoScreenFadeOut(800)

    while not IsScreenFadedOut() do
        Wait(20)
    end

    -- Remove the player from the house
    TriggerServerEvent("core:rmvPlayerInHouse", token, GetPlayerServerId(PlayerId()), selectedProperty.id)
    TriggerServerEvent("core:InstancePlayer", token, 0, "Property : Ligne 495")

    -- Remove markers
    zone.removeZone("property_leave")
    zone.removeZone("property_gestion")

    -- Save the last property
    TriggerServerEvent("core:updateLastProperty", token, json.encode({}))
    Wait(50)
    setBypassAntiTeleport(true)
    -- Teleport the player outside
    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do Wait(1) end
    SetEntityCoords(PlayerPedId(), selectedProperty.enter_pos.x, selectedProperty.enter_pos.y, selectedProperty.enter_pos.z)

    -- If player is in a vehicle, spawn it outside
    if veh then
        TriggerServerEvent("core:property:removeVehicle", token, selectedProperty.id, veh.plate)
        Wait(400)
        local leaveVeh = vehicle.create(
            veh.model,
            vector4(selectedProperty.enter_pos.x, selectedProperty.enter_pos.y, selectedProperty.enter_pos.z, selectedProperty.enter_pos.w and selectedProperty.enter_pos.w or 0.0),
            veh.props,
            true
        )
        SetVehicleNumberPlateText(leaveVeh, veh.plate)
        TriggerServerEvent("core:SetVehicleOut", string.upper(vehicle.getPlate(leaveVeh)), VehToNet(leaveVeh), leaveVeh)
        TaskWarpPedIntoVehicle(p:ped(), leaveVeh, -1)

        just_outed_of_garage = true
    end
    currentVeh = nil
    selectedProperty = nil
    in_garage = false

    DoScreenFadeIn(800)

    Wait(1000)
    setBypassAntiTeleport(false)
    just_outed_of_garage = false
end

function EnableIpl(ipl, value)
    if type(ipl) == "table" then
        for k, v in pairs(ipl) do
            EnableIpl(v, value)
        end
    else
        if value then
            if not IsIplActive(ipl) then
                RequestIpl(ipl)
            end
        else
            if IsIplActive(ipl) then
                RemoveIpl(ipl)
            end
        end
    end
end

function ParseInventory(inventory)

    -- if inventory is empty, return empty table
    if not inventory then return {} end

    -- if inventory is not empty, parse it
    local parsed = {}
    for k, v in pairs(inventory) do
        if v.type == "items" or v.type == "weapons" or v.type == "clothes" then
            table.insert(parsed, {
                name = v.name,
                count = v.count,
                label = v.label,
                cols = v.cols,
                rows = v.rows,
                type = v.type,
                metadatas = v.metadatas,
                weight = v.weight,
                url = v.url or nil
            })
        end
    end
    return parsed
end

function OpenPropertyGestion(data)
    local remainingDaysOfLocation = math.floor(((GetPropertyRentalEnd(selectedProperty) or 0) - (current_time or 0)) / 86400)

    if remainingDaysOfLocation < 0 then
        remainingDaysOfLocation = 0
    end

    local propertyName = GetPropertyName(selectedProperty.id)

    if p:getJob() == "realestateagent" and dutyproperty then
        forceHideRadar()
        SetNuiFocusKeepInput(false)
        SetNuiFocus(true, false)
        Wait(100)
        local valueHide = false

        -- if data.rentalEnd is in more than 300 days, set valueHide to true
        -- rentalEnd is a timestamp, so we need to convert it to a table
        local acces = 'ouvert'
        if remainingDaysOfLocation > 300 then
            valueHide = true
        end
        
        if GlobalState["propertyDoorState_"..selectedProperty.id] == false then
            acces = 'fermer'
        end

        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'gestionpropriete',
            data = {
                hideDuration    = valueHide,
                timeLeft        = remainingDaysOfLocation,
                acces           = acces,
                type            = GetPropertyType(selectedProperty.id),
                haveAccess      = GetPropertyCoOwners(selectedProperty),
                maxDuration     = 15
            }
        }))
    else
        forceHideRadar()
        SetNuiFocusKeepInput(false)
        SetNuiFocus(true, false)
        Wait(100)
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'Menu_propriete',
            data = {
                data_boite      = ParseInventory(TriggerServerCallback('core:property:getMailbox', token, selectedProperty.id)),
                number_day      = remainingDaysOfLocation,
                name            = propertyName or "Propriété",
                advancedPerm    = false
            }
        }));
    end
end

-- Functions for the interiors

function AppartementInterior(property)

    if PlayerHasAccessToProperty(selectedProperty) or PlayerCanSearchInProperty(selectedProperty) then
        -- Draw gestion marker
        zone.addZone(
            "property_gestion",
            vector3(property.gestion.x, property.gestion.y, property.gestion.z),
            "~INPUT_CONTEXT~ Gestion de la propriété",
            function()
                OpenPropertyGestion(property)
            end,
            false,
            marker,             -- Id / type du marker
            0.6,                -- La taille
            { 51, 204, 255 },   -- RGB
            170,                 -- Alpha
            1.5,
            true,
            "bulleInformation"
        )

        if PlayerCanOpenPropertyCoffre() and property.coffre then
            -- Draw coffre marker
            zone.addZone(
                "property_coffre",
                vector3(property.coffre.x, property.coffre.y, property.coffre.z),
                "~INPUT_CONTEXT~ Coffre de la propriété",
                function()
                    OpenInventoryProperty(
                        selectedProperty,   -- La propriété
                        ParseInventory(TriggerServerCallback("core:property:getPropertyInventory", token, selectedProperty.id)), -- L'inventaire de la propriété (formaté)
                        ParseInventory(FormulateInventory())    -- L'inventaire du joueur (formaté)
                    )
                end,
                false,
                marker,             -- Id / type du marker
                0.6,                -- La taille
                { 51, 204, 255 },   -- RGB
                170,                 -- Alpha
                1.5,
                true,
                "bulleCoffre"
            )

            -- if property.penderie then
            --     zone.addZone(
            --         "property_penderie",
            --         vector3(property.penderie.x, property.penderie.y, property.penderie.z),
            --         "~INPUT_CONTEXT~ Penderie de la propriété",
            --         function()
            --             OpenCasierProperty()
            --         end,
            --         false,
            --         marker,             -- Id / type du marker
            --         0.6,                -- La taille
            --         { 51, 204, 255 },   -- RGB
            --         170,                 -- Alpha
            --         1.5,
            --         true,
            --         "bulleCoffre"
            --     )
            -- end
        end
    end

    -- Draw leave marker
    zone.addZone(
        "property_leave",
        vector3(property.leave.x, property.leave.y, property.leave.z),
        "~INPUT_CONTEXT~ Sortir de la propriété",
        function()
            LeaveProperty(property)
        end,
        false,
        marker,             -- Id / type du marker
        0.6,                -- La taille
        { 51, 204, 255 },   -- RGB
        170,                 -- Alpha
        1.5,
        true,
        "bulleSortir"
    )

end

function HasAlreadySpawnedVeh(name, plate)
    local spawned = false
    for k,v in pairs(loaded_vehicles) do
        if v.name == name and v.plate == plate then
            spawned = true
        end
    end
    return spawned
end

local VUI = exports["VUI"]
local main = VUI:CreateMenu("Garage", "default", true)
local SelectedVehicles = {}
function OpenVehiclesProperty(vehicles)
    SelectedVehicles = vehicles
    main.open()
end

function renderMainMenuVeh()
    for k,v in pairs(SelectedVehicles) do
        main.Button(
            type(v.name) == "number" and GetDisplayNameFromVehicleModel(v.name) or v.name,
            v.plate,
            nil,
            "chevron",
            false,
            function()
                main.close()
                LeaveGarage({plate = v.plate, model = v.name, props = v.props})
            end
        )
    end
end

main.OnOpen(function()
    renderMainMenuVeh()
end)

function GarageInterior(property)
    local vehicles = TriggerServerCallback("core:property:getVehiclesInGarage", token, selectedProperty.id)

    if PlayerHasAccessToProperty(selectedProperty) or PlayerCanSearchInProperty(selectedProperty) then

        in_garage = true
        -- Draw gestion marker
        zone.addZone(
            "property_gestion",
            vector3(property.gestion.x, property.gestion.y, property.gestion.z),
            "~INPUT_CONTEXT~ Gestion de la propriété",
            function()
                OpenPropertyGestion(property)
            end,
            false,
            marker,             -- Id / type du marker
            0.6,                -- La taille
            { 51, 204, 255 },   -- RGB
            170,                 -- Alpha
            1.5,
            true,
            "bulleInformation"
        )

        if PlayerCanOpenPropertyCoffre() then
            zone.addZone(
                "property_key",
                vector3(property.key.x, property.key.y, property.key.z + 1.0),
                "~INPUT_CONTEXT~ Accéder au coffre de clés de la propriété",
                function()
                    OpenInventoryProperty(
                        selectedProperty,   -- La propriété
                        ParseInventory(TriggerServerCallback("core:property:getPropertyInventory", token, selectedProperty.id)), -- L'inventaire de la propriété (formaté)
                        ParseInventory(p:getInventaire()),    -- L'inventaire du joueur (formaté)
                        "keys"
                    )
                end,
                false,
                marker,             -- Id / type du marker
                0.6,                -- La taille
                { 51, 204, 255 },   -- RGB
                170,                 -- Alpha
                1.5,
                true,
                "bulleCoffre"
            )
            if property.vehicle then
                zone.addZone(
                    "property_vehicle",
                    vector3(property.vehicle.x, property.vehicle.y, property.vehicle.z + 1.0),
                    "~INPUT_CONTEXT~ Accéder au coffre de clés de la propriété",
                    function()
                        OpenVehiclesProperty(vehicles)
                    end,
                    false,
                    marker,             -- Id / type du marker
                    0.6,                -- La taille
                    { 51, 204, 255 },   -- RGB
                    170,                 -- Alpha
                    1.5,
                    true,
                    "bulleVehicule"
                )
            end
        end
    end
    zone.addZone(
        "property_leave",
        vector3(property.leave.x, property.leave.y, property.leave.z),
        "~INPUT_CONTEXT~ Sortir",
        function()
            for k, v in pairs(loaded_vehicles) do
                if DoesEntityExist(v.entity) then
                    DeleteEntity(v.entity)
                end
            end
            loaded_vehicles = {}
            in_garage = false
            LeaveGarage()
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        1.5,
        true,
        "bulleSortir"
    )

    --print("PROEPRTY VEH POSITION", property.vehPos)
    -- Spawn the vehicles
    for k, _veh in pairs(vehicles) do
        if k > #property.vehPos or property.vehPos[k] == nil then break end
        --print("not break", _veh.name, property.vehPos[k])
        if _veh.name and IsModelInCdimage(GetHashKey(_veh.name)) and IsModelAVehicle(GetHashKey(_veh.name)) then
            if not HasAlreadySpawnedVeh(_veh.name, _veh.plate) then
                local veh = vehicle.createLocal(_veh.name, property.vehPos[k], _veh.props)
                if veh ~= nil then
                    SetVehicleOnGroundProperly(veh)
                    SetVehicleDoorsLocked(veh, 0)
                    FreezeEntityPosition(veh, true)
                    SetVehicleDirtLevel(veh, 0.0)
                    SetVehicleNumberPlateText(veh, _veh.plate)
                    table.insert(loaded_vehicles, {
                        props = _veh.props,
                        pos = property.vehPos[k],
                        entity = veh,
                        model = _veh.name,
                        plate = _veh.plate
                    })
                end
            end
        end
    end
end

-- NUI Callbacks

RegisterNUICallback("MenuProprieteAlt", function (data, cb)
    if data.type == "entrer" then
        -- Enter to the property
        if PlayerHasAccessToProperty(selectedProperty) or not IsPropertyLocked(selectedProperty) then
            TriggerServerEvent("core:InstancePlayer", token, selectedProperty.id, "Property : Ligne 775")
            TriggerServerEvent("core:AddPlayerInHouse", token, selectedProperty.id)
            EnterProperty(selectedProperty)
        else
            -- Notify the player that he can't enter
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "~s Vous n'avez pas le droit de rentrer !"
            })
        end
    elseif data.type == "perquisitionner" then
        if PlayerCanSearchInProperty(property) then
            TriggerServerEvent("core:InstancePlayer", token, selectedProperty.id, "Property : Ligne 787")
            EnterProperty(selectedProperty)
        else
            -- Notify the player that he can't enter
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "~s Vous n'avez pas le droit de perquisitionner !"
            })
        end
    elseif data.type == "sonner" then
        TriggerServerEvent("core:property:ring", token, selectedProperty.id)
    elseif data.button == "addToBoite" then
        closeUI()
        Wait(100)
        OpenMailBoxProperty(
            selectedProperty,                                                                               -- La propriété
            ParseInventory(TriggerServerCallback("core:property:getMailbox", token, selectedProperty.id)),  -- L'inventaire de la propriété (formaté)
            ParseInventory(p:getInventaire())                                                               -- L'inventaire du joueur (formaté)
        )
        -- This return prevent the UI to close after the mailbox is opened
        return
    end
    closeUI()
end)

RegisterNUICallback("MenuPropriete", function (data, cb)
    if data.type == "access" then
        -- data.value = "ouvert" | "fermer" | "sonnette"
        if data.value == "sonnette" then
            TriggerServerEvent("core:property:enterByDoorbell", token, selectedProperty.id)
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez ouvert la porte aux personnes qui sonnent"
            })
        else
            TriggerServerEvent("core:property:updateDoorState", token, selectedProperty.id, data.value == "ouvert")
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez ".. data.value .. " la porte"
            })
        end
    elseif data.type == "set_double" then
        -- Create a double to nearest player
        local nearestPlayer = ChoicePlayersInZone(3.0, p:getPermission() > 3 and true or false)
        if nearestPlayer ~= nil then
            TriggerSecurEvent("core:property:addCoOwner", token, selectedProperty.id, GetPlayerServerId(nearestPlayer))
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez donné un double à ".. GetPlayerServerId(nearestPlayer)
            })
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "~s Aucun joueur à proximité !"
            })
        end
    elseif data.type == "revoke_access" then
        -- Remove access to nearest player
        local nearestPlayer = ChoicePlayersInZone(3.0, false)
        if nearestPlayer ~= nil then
            TriggerServerEvent("core:property:removeCoOwner", token, selectedProperty.id, GetPlayerServerId(nearestPlayer))
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez retiré l'accès à ".. GetPlayerServerId(nearestPlayer)
            })
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "~s Aucun joueur à proximité !"
            })
        end
    elseif data.type == "give_property" then
        local nearestPlayer = ChoicePlayersInZone(3.0, false)
        if nearestPlayer ~= nil then
            TriggerServerEvent("core:property:give", token, selectedProperty.id, GetPlayerServerId(nearestPlayer))
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez donné la propriété à ".. GetPlayerServerId(nearestPlayer)
            })
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "~s Aucun joueur à proximité !"
            })
        end
    elseif data.type == "delete_property" then
        if dutyproperty or p:getPermission() >= 3 then
            TriggerServerEvent("core:property:delete", token, selectedProperty.id)
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez supprimé la propriété"
            })
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous n'avez pas la permission de faire ça !"
            })
        end
    elseif data.type == "emptyMailbox" then
        TriggerServerEvent("core:property:emptyMailbox", token, selectedProperty.id)
        exports['vNotif']:createNotification({
            type = 'VERT',
            content = "Vous avez vidé la boîte aux lettres"
        })
    elseif data.rename then
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "~s Cette action n'est plus disponible actuellement."
        })
    end
    closeUI()
end)

RegisterNUICallback("GestionPropriete", function (data, cb)
    if data.button then
        if data.button == "sell" then
            -- sell (the owner will buy the property to the real estate agency)
            TriggerServerEvent("core:property:updateRentDuration", token, selectedProperty.id, 3600)
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez vendu la propriété"
            })
        elseif data.button == "delete" then
            TriggerServerEvent("core:property:delete", token, selectedProperty.id)
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez supprimé la propriété"
            })
        elseif data.button == "giveDouble" then
            -- Create a double to nearest player
            local nearestPlayer = ChoicePlayersInZone(3.0, p:getPermission() > 3 and true or false)
            if nearestPlayer ~= nil then
                TriggerSecurEvent("core:property:addCoOwner", token, selectedProperty.id, GetPlayerServerId(nearestPlayer))
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "Vous avez donné un double à ".. GetPlayerServerId(nearestPlayer)
                })
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "~s Aucun joueur à proximité !"
                })
            end
        end
    elseif data.submit then
        if data.submit.type then
            -- Update access type (entreprise, crew, "[]" as perso)
            if data.submit.type == "[]" then data.submit.type = "individuel" end
            TriggerServerEvent("core:updatePropType", token, selectedProperty.id, data.submit.type)
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez défini le type d'accès à ".. data.submit.type
            })
        end
        if data.submit.acces then
            if data.submit.acces == "ouvert" then
                TriggerServerEvent("core:property:updateDoorState", token, selectedProperty.id, true)
            else
                TriggerServerEvent("core:property:updateDoorState", token, selectedProperty.id, false)
            end
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez ".. data.submit.acces .." la porte"
            })
        end
        if data.submit.prolongation then
            TriggerServerEvent("core:property:updateRentDuration", token, selectedProperty.id, data.submit.prolongation)
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez prolongé la location de".. data.submit.prolongation .."jours"
            })
        end
    end
    exports['vNotif']:createNotification({
        type = 'VERT',
        content = "Mise à jour effectuée"
    })
    closeUI()
end)
