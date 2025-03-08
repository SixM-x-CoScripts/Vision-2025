RegisterServerEvent("core:createDispatchCallOnMDT")
AddEventHandler("core:createDispatchCallOnMDT", function(service, title, pos)
	local place = TriggerClientCallback(source, "core:getStreetName", pos)

	exports['knid-mdt']:api().dispatch.calls.create(service, "ID", title, place,
	function(cb)
		if cb == 200 then
			print("^2[" .. cb .. "]^0 MDT: Create dispatch call : ^6", service, title, place, "^0")
		else
			print("^8[" .. cb .. "]^0 MDT: Error creating dispatch call : ^6", service, title, place, "^0")
		end
		return
	end)
end)