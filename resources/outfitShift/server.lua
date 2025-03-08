-- Toutes les variables à décaler
local Shifts = {
	H = {
		haut = 82, varHaut = 0, -- Good
		sousHaut = 39, varSousHaut = 0, -- Good
		chaine = 11, varChaine = 0, -- Good
		decals = 17, varDecals = 0, -- JSP mdr
		pantalon = 33, varPantalon =0, -- Good
		sac = 0, varSac = 0, -- Good
		gpb = 27, varGpb = 0, -- Good
		chaussures = 19, varChaussures = 0, -- Good
		bras = 0, varBras = 0, -- Good
		mask = 22, varMask = 0, -- Good
		helmet = 27, varHelmet = 0, -- Good
		glasses = 9, varGlasses = 0, -- Good
	},
	F = {
		haut = 92, varHaut = 0, -- Good
		sousHaut = 15, varSousHaut = 0, -- Good
		chaine = 12, varChaine = 0, -- Good
		decals = 41, varDecals = 0, -- Good
		pantalon = 38, varPantalon =0, -- Good
		sac = 0, varSac = 0, -- Good
		gpb = 5, varGpb = 0, -- Good
		chaussures = 23, varChaussures = 0, -- Good
		bras = 0, varBras = 0, -- Good
		mask = 20, varMask = 0, -- Good
		helmet = 27, varHelmet = 0, -- Good
		glasses = 9, varGlasses = 0, -- Good
	}
}

local MaxShift = {
	-- Supérieur à ça alors on décale
	H = {
		--haut = 500, varHaut = 0, -- Good
		haut = 440, varHaut = 0, -- Good
		sousHaut = 225, varSousHaut = 0, -- Good
		chaine = 166, varChaine = 0, -- Good
		decals = 145, varDecals = 0, -- Good
		--pantalon = 223, varPantalon =0, -- Good
		pantalon = 159, varPantalon =0, -- Good
		sac = 110, varSac = 0, -- Good
		gpb = 56, varGpb = 0, -- Good
		chaussures = 125, varChaussures = 0, -- Good
		bras = 209, varBras = 0, -- Good
		mask = 215, varMask = 0, -- Good
		helmet = 186, varHelmet = 0, -- Good
		glasses = 46, varGlasses = 0, -- Good
	},
	F = {
        haut = 441, varHaut = 0, -- Good
        sousHaut = 192, varSousHaut = 0, -- Good
        chaine = 140, varChaine = 0, -- Good
        decals = 145, varDecals = 0, -- Good
        pantalon = 159, varPantalon =0, -- Good
        sac = 110, varSac = 0, -- Good
        gpb = 56, varGpb = 0, -- Good
        chaussures = 160, varChaussures = 0, -- Good
        bras = 209, varBras = 0, -- Good
        mask = 215, varMask = 0, -- Good
        helmet = 186, varHelmet = 0, -- Good
        glasses = 46, varGlasses = 0, -- Good
	}
}

-- RIEN A TOUCHER APRES :) 

-- MDR, je sais pas ce que je fais c'est chatGPT qui a sortie ca ( ͡° ͜ʖ ͡°)
function serializeTable(tbl, indent)
    indent = indent or 0
    local formatting = string.rep("    ", indent) -- 4-space indentation
    local result = "{\n"

    for k, v in pairs(tbl) do
        local key

        -- Check if the key contains spaces or is not a valid Lua identifier
        if type(k) == "string" and k:match("%s") then
            key = string.format("[%q]", k) -- ["key"] for keys with spaces
        elseif type(k) == "string" and not k:match("^[%a_][%w_]*$") then
            key = string.format("[%q]", k) -- ["key"] if it's not a valid Lua identifier
        elseif type(k) == "string" then
            key = k -- plain key for valid identifiers without spaces
        else
            key = "[" .. k .. "]" -- Handles numeric keys or other types
        end

        if type(v) == "table" then
            result = result .. formatting .. key .. " = " .. serializeTable(v, indent + 1) .. ",\n"
        elseif type(v) == "string" then
            result = result .. formatting .. key .. " = " .. string.format("%q", v) .. ",\n"
        else
            result = result .. formatting .. key .. " = " .. tostring(v) .. ",\n"
        end
    end

    result = result .. string.rep("    ", indent - 1) .. "}"
    return result
end

-- Ca aussi, mais en vrai, c'est pas mal
function writeOutfitToFile(outfit, filename)
    local file = io.open(GetResourcePath(GetCurrentResourceName()).."/"..filename, "w") -- Open file in write mode
    if not file then
        error("Failed to open file for writing", file)
    end

    local output = "return " .. serializeTable(outfit) -- Add "return" to make the file a valid Lua script
    file:write(output) -- Write the serialized table to the file
    file:close() -- Close the file
    print("Table successfully written to " .. filename)
end

-- Ca c'est moi par contre. Si ca marche pas, c'est Flimar ( ͡° ͜ʖ ͡°)
function shiftOutfitIDs(outfits, shiftIDs, shiftsMax, sex)
	
	for rank, details in pairs(outfits) do
		print("Grade: " .. rank)
		local outfits = details.tenues
		if not outfits then
			print("No outfits found for grade: " .. rank)
			return
		end

		for outfitName, outfitDetails in pairs(outfits) do
			for id, value in pairs(outfitDetails) do
				if id == "id" then
					goto continue
				end

				local shift = shiftIDs[id]
				local maxShift = shiftsMax[id]
				if not shift then
					print("  No shift for " .. id, "but menfou")
					goto continue
				end
				if shift == 0 then 
					goto continue
				end

				if (id == "sousHaut" and value == 207 and sex == "m") then 
					outfitDetails[id] = value + 10
				else
					if (value > maxShift) or (id == "sousHaut" and value == 215 and sex == "m") then
						outfitDetails[id] = value + shift
					end
				end

				::continue::
			end
		end
	end

end

for k, v in pairs(shiftHomme) do
	shiftOutfitIDs(v, Shifts.H, MaxShift.H, "m")

	writeOutfitToFile(v, "output/H_" .. k .. ".lua")
end

for k, v in pairs(shiftFemme) do
	shiftOutfitIDs(v, Shifts.F, MaxShift.F, "f")

	writeOutfitToFile(v, "output/F_" .. k .. ".lua")
end