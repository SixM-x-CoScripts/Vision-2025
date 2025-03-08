local PropertyCache = {}

function GetPropertyInterior(propID)
    if PropertyCache[propID] and PropertyCache[propID].interior then
        return PropertyCache[propID].interior
    else
        if not PropertyCache[propID] then PropertyCache[propID] = {} end 
        print("Requesting interior for propID: " .. propID)
        PropertyCache[propID].interior = TriggerServerCallback("core:property:getInterior", propID)
    end
    return PropertyCache[propID].interior
end

function GetPropertyInteriorType(propID)
    if PropertyCache[propID] and PropertyCache[propID].typeint then
        return PropertyCache[propID].typeint
    else
        if not PropertyCache[propID] then PropertyCache[propID] = {} end 
        print("Requesting interior type for propID: " .. propID)
        PropertyCache[propID].typeint = TriggerServerCallback("core:property:getInteriorType", propID)
    end
    return PropertyCache[propID].typeint
end

function GetCachedPropertyOwner(propID)
    if PropertyCache[propID] and PropertyCache[propID].owner then
        return PropertyCache[propID].owner
    else
        if not PropertyCache[propID] then PropertyCache[propID] = {} end 
        print("Requesting owner for propID: " .. propID)
        PropertyCache[propID].owner = TriggerServerCallback("core:property:getOwner", propID)
    end
    return PropertyCache[propID].owner
end

function GetPropertyType(propID)
    if PropertyCache[propID] and PropertyCache[propID].type then
        return PropertyCache[propID].type
    else
        if not PropertyCache[propID] then PropertyCache[propID] = {} end 
        print("Requesting type for propID: " .. propID)
        PropertyCache[propID].type = TriggerServerCallback("core:property:getType", propID)
    end
    return PropertyCache[propID].type
end

--GetPropertyCrew
function GetPropertyCrew(propID)
    if PropertyCache[propID] and PropertyCache[propID].crew then
        return PropertyCache[propID].crew
    else
        if not PropertyCache[propID] then PropertyCache[propID] = {} end 
        print("Requesting crew for propID: " .. propID)
        PropertyCache[propID].crew = TriggerServerCallback("core:property:getCrew", propID)
    end
    return PropertyCache[propID].crew
end 

-- GetPropertyOwnerFullname
function GetPropertyOwnerFullname(propID)
    if PropertyCache[propID] and PropertyCache[propID].ownerFullname then
        return PropertyCache[propID].ownerFullname
    else
        if not PropertyCache[propID] then PropertyCache[propID] = {} end 
        print("Requesting owner fullname for propID: " .. propID)
        PropertyCache[propID].ownerFullname = TriggerServerCallback("core:property:getOwnerFullname", propID)
    end
    return PropertyCache[propID].ownerFullname
end

--GetPropertyRentalEnd
function GetPropertyRentalEndCache(propID)
    if PropertyCache[propID] and PropertyCache[propID].rentalEnd then
        return PropertyCache[propID].rentalEnd
    else
        if not PropertyCache[propID] then PropertyCache[propID] = {} end 
        print("Requesting rental end for propID: " .. propID)
        PropertyCache[propID].rentalEnd = TriggerServerCallback("core:property:getRentalEnd", propID)
    end
    return PropertyCache[propID].rentalEnd
end

-- GetPropertyName
function GetPropertyName(propID)
    if PropertyCache[propID] and PropertyCache[propID].name then
        return PropertyCache[propID].name
    else
        if not PropertyCache[propID] then PropertyCache[propID] = {} end 
        print("Requesting name for propID: " .. propID)
        PropertyCache[propID].name = TriggerServerCallback("core:property:getName", propID)
    end
    return PropertyCache[propID].name
end