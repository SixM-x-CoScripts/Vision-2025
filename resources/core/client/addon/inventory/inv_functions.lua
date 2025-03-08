local clothings = {
	["tshirt"] = "torso2",
	["Hauts"] = "torso2",
	["pant"] = "leg",
	["Bas"] = "leg",
	["feet"] = "shoes",
	["Chaussures"] = "shoes",
	["mask"] = "mask",
	["Masque"] = "mask",
	["access"] = "bag",
	["Sac"] = "bag",
	["collier"] = "accessory",

	["hat"] = "hat",
	["Chapeaux"] = "hat",
	["glasses"] = "glasses",
	["Lunettes"] = "glasses",
	["bracelet"] = "bracelet",
	["Bracelet"] = "bracelet",
}


function GetPathType(index)
	local isCloth = {
		["tshirt"] = true,
		["Hauts"] = true,
		["pant"] = true,
		["Bas"] = true,
		["feet"] = true,
		["Chaussures"] = true,
		["mask"] = true,
		["Masque"] = true,
		["access"] = true,
		["collier"] = true,
	
		["hat"] = false,
		["Chapeaux"] = false,
		["glasses"] = false,
		["Lunettes"] = false,
		["bracelet"] = false,
		["Bracelet"] = false,
	}

	return isCloth[index] and "clothing" or "props"
	
end

function GetUrlLinkCloth(itemname, var, idvar)
	print(itemname, var, idvar)

	local url = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/%s/%s/%s/"..tonumber(var).."_".. tonumber(idvar)+1 ..".webp"

	if tonumber(idvar) == -1 then
		url = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/%s/%s/%s/"..tonumber(var)..".webp"
	end

    local playerType = "Homme"
    
	if isPlayerPed() then
        playerType = "ped"    
    elseif p:skin().sex == 0 then
        playerType = "male"
    elseif p:skin().sex == 1 then
        playerType = "female" 
    end

    local Namepath = clothings[itemname]
	local pathType = GetPathType(itemname)

    return Namepath ~= nil and string.format(url, playerType, pathType, Namepath) or nil
end

function FormulateInventory(selecinv)
    local inv = selecinv or p:getInventaire() --addUniqueIdToItemsIfNotExists(selecinv or p:getInventaire())

    local items = {}
    for k, v in pairs(inv) do
        if v.item == "money" then
            v.count = Round(v.count)
        end
        if v.type == "items" or v.type == "weapons" then
            table.insert(items, {
                name = v.name,
                count = Round(v.count),
                label = v.label,
                cols = v.cols,
                rows = v.rows,
                type = v.type,
                metadatas = v.metadatas,
                weight = v.weight,
            })
        elseif v.type == "clothes" then 
            local Namepath = clothings[v.name]

            if Namepath and v.metadatas or v.name == "outfit" and v.metadatas then
                if v.metadatas.variationId or v.metadatas.data then
                    if v.name == "outfit" then
                        if v.metadatas.data["torso_1"] and v.metadatas.data["torso_2"] then
                            table.insert(items, {
                                name = v.name,
                                count = Round(v.count),
                                label = v.label,
                                cols = v.cols,
                                url = GetUrlLinkCloth("Hauts", v.metadatas.data["torso_1"], v.metadatas.data["torso_2"]),
                                rows = v.rows,
                                type = v.type,
                                metadatas = v.metadatas,
                                weight = v.weight
                            })
                        else
                            table.insert(items, {
								name = v.name,
                                count = Round(v.count),
                                label = v.label,
                                cols = v.cols,
                                rows = v.rows,
                                type = v.type,
                                metadatas = v.metadatas,
                                weight = v.weight
                            })
                        end
                    else
                        table.insert(items, {
                            name = v.name,
                            count = Round(v.count),
                            label = v.label,
                            cols = v.cols,
                            url = GetUrlLinkCloth(v.name, v.metadatas.drawableId, v.metadatas.variationId - 1),
                            rows = v.rows,
                            type = v.type,
                            metadatas = v.metadatas,
                            weight = v.weight
                        })
                    end
                else
                    if v.metadatas.drawableTorsoId and v.metadatas.variationTorsoId then
                        table.insert(items, {
                            name = v.name,
                            count = Round(v.count),
                            label = v.label,
                            cols = v.cols,
                            url = GetUrlLinkCloth(v.name, v.metadatas.drawableTorsoId, v.metadatas.variationTorsoId - 1),
                            rows = v.rows,
                            type = v.type,
                            metadatas = v.metadatas,
                            weight = v.weight
                        })
                    else
                        table.insert(items, {
                            name = v.name,
                            count = Round(v.count),
                            label = v.label,
                            cols = v.cols,
                            rows = v.rows,
                            type = v.type,
                            metadatas = v.metadatas,
                            weight = v.weight
                        })
                    end
                end
            else
                table.insert(items, {
                    name = v.name,
                    count = Round(v.count),
                    label = v.label,
                    cols = v.cols,
                    rows = v.rows,
                    type = v.type,
                    metadatas = v.metadatas,
                    weight = v.weight
                })
            end
        end
    end
    return items
end

function addUniqueIdToItemsIfNotExists(items)
    local added = false

    for k, v in pairs(items) do
        if not v.uniqueId then
            local uniqueId = ""
            for i = 1, 5 do
                for j = 1, 4 do
                    uniqueId = uniqueId .. string.char(math.random(65, 90))
                end

                if i ~= 5 then
                    uniqueId = uniqueId .. "-"
                end
            end

            v.uniqueId = uniqueId

            print("Added uniqueId to item: " .. v.name .. " (" .. v.uniqueId .. ")")

            if not added then
                added = true
            end
        end
    end

    if added then
        p:setInventaire(items)
        p:setNeedSave(true)
    end

    return items
end