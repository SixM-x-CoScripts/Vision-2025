local Config = {
    devMode = false,
	verbose = false,
    actions = {
		characters = true,
		vehicles = true,
		licenses = true,
    },
	limit = 3000,
	batchSize = 100,
}

local p = promise.new()
if Config.actions.characters then
	print("PROCESSING CHARACTERS")
	local processed = 0
	local errors = 0

	MySQL.Async.fetchAll(
		"SELECT p.id as 'identifier', p.firstname, p.lastname, p.age, p.sex, p.job FROM players p JOIN players_unique pu ON p.license = pu.license WHERE p.firstname != '' AND p.lastname != '' ORDER BY p.id DESC LIMIT " .. (Config.limit or 3000),
		{},
		function(results)
            for _, c in ipairs(results) do
                local params = {
                    identifier = c.identifier,
                    name = (Config.devMode and "[DEV] " or "") ..
                    (string.capitalize(c.firstname) .. " " .. string.upper(c.lastname) .. " (" .. c.sex .. ")"),
                    birthdate = c.age,
                    job = c.job,
                }

                exports['knid-mdt']:api().people.create(params,
                    function(cb)
                        if cb == 201 and Config.verbose then
                            print("^2[" .. cb .. "]^0 MDT: Citizen created : ^6", json.encode(params), "^0")
                            processed = processed + 1
						end

						if cb ~= 201 then
                            print("^8[" .. cb .. "]^0 MDT: Error creating citizen : ^6", json.encode(params), "^0")
                            errors = errors + 1
                        end

                        -- Print progress
                        if (processed ~= 0 and processed % Config.batchSize == 0) or processed == #results then
                            print("Processed ^1" .. processed .. "/" .. #results .. "^0 characters. Errors: ^1" .. errors .. "^0")
                        end
                    end)

                Wait(5)
            end
			p:resolve()
		end)
end
Citizen.Await(p)

local pd = promise.new()
if Config.actions.vehicles then
	print("PROCESSING VEHICLES")
	local processed = 0
	local errors = 0

	MySQL.Async.fetchAll(
		"SELECT v.owner, v.plate, v.`name` AS 'model' FROM vehicles v JOIN (SELECT p.id FROM players p ORDER BY p.id DESC LIMIT " .. (Config.limit or 3000) .. ") subquery ON v.owner = subquery.id;",
		{},
		function(results)
            for _, v in ipairs(results) do
                local params = {
                    plate = (Config.devMode and "[DEV] " or "") .. v.plate,
                    model = v.model,
                }

                exports['knid-mdt']:api().people.vehicles.create(v.owner, params,
                    function(cb)
                        if cb == 201 and Config.verbose then
                            print("^2[" .. cb .. "]^0 MDT: Vehicle created : ^6", v.owner, json.encode(params), "^0")
                            processed = processed + 1
						end

						if cb ~= 201 then
                            print("^8[" .. cb .. "]^0 MDT: Error creating vehicle : ^6", v.owner, json.encode(params), "^0")
                            errors = errors + 1
                        end

                        -- Print progress
                        if (processed ~= 0 and processed % Config.batchSize == 0) or processed == #results then
                            print("Processed ^1" .. processed .. "/" .. #results .. "^0 vehicles. Errors: ^1" .. errors .. "^0")
                        end
                    end)

                Wait(100)
            end
			pd:resolve()
		end)
end
Citizen.Await(pd)

local p3 = promise.new()
if Config.actions.licenses then
	print("PROCESSING LICENSES")
	local processed = 0
	local errors = 0

	local licenseTypes = {
		[2] = "voiture",
		[3] = "moto",
		[5] = "bateau",
		[6] = "hélicoptère",
	}

	MySQL.Async.fetchAll(
		"SELECT l.id_player AS 'owner', license_type FROM license l JOIN (SELECT p.id FROM players p ORDER BY p.id DESC LIMIT " .. (Config.limit or 3000) ..  ") subquery ON l.id_player = subquery.id WHERE l.license_type IN (2,3,5,6);",
		{},
		function(results)
            for _, l in ipairs(results) do
                local license = licenseTypes[l.license_type]

                exports['knid-mdt']:api().people.licenses.create(l.owner, license,
                    function(cb)
                        if cb == 201 and Config.verbose then
                            print("^2[" .. cb .. "]^0 MDT: License created : ^6", json.encode({ owner = l.owner, license = license }), "^0")
                            processed = processed + 1
						end

						if cb ~= 201 then
                            print("^8[" .. cb .. "]^0 MDT: Error creating license : ^6", json.encode({ owner = l.owner, license = license }), "^0")
                            errors = errors + 1
                        end

                        if (processed ~= 0 and processed % Config.batchSize == 0) or processed == #results then
                            print("Processed ^1" .. processed .. "/" .. #results .. "^0 licenses. Errors: ^1" .. errors .. "^0")
                        end
                    end)

                Wait(100)
            end
			p3:resolve()
		end)
end
Citizen.Await(p3)