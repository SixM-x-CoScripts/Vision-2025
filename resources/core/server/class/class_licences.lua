license = {
    GetAllLicensePlayer = function(playerid)
        local id = GetPlayer(playerid):getId()
        if id ~= nil then
            local result = MySQL.Sync.fetchAll("SELECT license_type FROM license WHERE license.id_player = @id"
                , {
                ['@id'] = id
            })
            return result
        end
    end,
    GetLicenseInPlayer = function(playerid, licenseType)
        local id = GetPlayer(playerid):getId()
        if id ~= nil then
            local result = MySQL.Sync.fetchAll("SELECT license_type FROM license WHERE license.id_player = @id AND license.license_type = @license"
                , {
                ['@id'] = id,
                ['@license'] = license.GetIdLicense(licenseType)
            })

            if json.encode(result) ~= "[]" then
                return true
            else
                return false
            end
        end
    end,
    GetNameLicense = function(license_type)
        if license_type ~= nil then
            local result = MySQL.Sync.fetchAll("SELECT name FROM license_type WHERE license_type.id = @license_type"
                , {
                ['@license_type'] = license_type
            })
            return result[1].name
        else
            print("L'argument license_type est nil")
        end
    end,
    GetIdLicense = function(license_name)
        if license_name ~= nil then
            local result = MySQL.Sync.fetchAll("SELECT id FROM license_type WHERE license_type.name = @license_name"
                , {
                ['@license_name'] = license_name
            })
            return result[1].id
        else
            print("L'argument license_name est nil")
        end
    end,
    AddNewLicense = function(playerid, license_type)
        if license.GetLicenseInPlayer(playerid, license_type) then
            return false
        else
            local id = GetPlayer(playerid):getId()
            local license_type = license.GetIdLicense(license_type)

            if id ~= nil and license_type ~= nil then
                MySQL.Async.execute("INSERT INTO license (id_player, license_type) VALUES (@playerid, @licence_type)",
                    {
                        ['@playerid'] = id,
                        ['@licence_type'] = license_type
                    },
                    function(affectedRows)
                        print("Ajout licence " .. license_type .. " à l'id n° " .. id .. " mis a jour")

						local licenseTypes = {
							[2] = "voiture",
							[3] = "moto",
							[5] = "bateau",
							[6] = "hélicoptère",
                        }
						
                        local license = licenseTypes[license_type]

                        if license ~= nil then
							exports['knid-mdt']:api().people.licenses.create(id, license,
								function(cb)
									if cb == 201 then
										print("^2[" .. cb .. "]^0 MDT: License created : ^6", id, license, "^0")
									else
										print("^8[" .. cb .. "]^0 MDT: Error creating license : ^6", id, license, "^0")
									end
								end)
						end

                    end)
                return true
            else 
                print("L'argument id ou license_type est nil")
            end
        end
    end,

    RemoveLicense = function(playerid, license_type)
        if not license.GetLicenseInPlayer(playerid, license_type) then
            return false
        else
			local id = GetPlayer(playerid):getId()

            MySQL.Async.execute("DELETE FROM license WHERE license.id_player = @playerid AND license.license_type = @licence_type",
                {
                    ['@playerid'] = id,
                    ['@licence_type'] = license.GetIdLicense(license_type)
                },
                function(affectedRows)
                    print("Supression licence " .. license_type .. " à l'id n° " .. id .. " mis a jour")
					
					local licenseTypes = {
						[2] = "voiture",
						[3] = "moto",
						[5] = "bateau",
						[6] = "hélicoptère",
					}
					
					local l = licenseTypes[license.GetIdLicense(license_type)]
					
					if l ~= nil then
						exports['knid-mdt']:api().people.licenses.delete(id, l,
							function(cb)
								if cb == 200 then
									print("^2[" .. cb .. "]^0 MDT: License deleted : ^6", id, l, "^0")
								else
									print("^8[" .. cb .. "]^0 MDT: Error deleting license : ^6", id, l, "^0")
								end
							end)
					end
                end)
            return true
        end
    end,
}
