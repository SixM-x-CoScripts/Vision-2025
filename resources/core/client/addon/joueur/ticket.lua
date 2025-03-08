local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

RegisterNetEvent("core:ticket:useTicketGratter", function(amount)
    if not IsPedInAnyVehicle(PlayerPedId()) then
        TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_PARKING_METER", 0, true)
    end
	nuiOpenTicket(amount)
end)

local inMenu = false

function nuiOpenTicket(wonAmount)
    if inMenu then return end
    SendNUIMessage({
        type = 'openWebview',
        name = 'ScratchingTicket',
        data = {
            money = wonAmount ~= nil and wonAmount or 500,
			primaryColor = "#EC1C22",
			secondaryColor = "#F55056",
        }
    })
    inMenu = true
	SetTimeout(9000, function()
		closeUI()
		-- notif 
		if wonAmount ~= 0 then
			exports['vNotif']:createNotification({
				type = 'VERT',
				content = "Vous avez reçu " .. wonAmount .. "$"
			})
		else
			exports['vNotif']:createNotification({
				type = 'ROUGE',
				content = "Vous avez perdu"
			})
		end
	end)
end

RegisterNUICallback('nuiCloseCard', function(data)
    closeUI()
    if IsPedUsingScenario(PlayerPedId(), "PROP_HUMAN_PARKING_METER") then
        ClearPedTasks(PlayerPedId())
    end
    inMenu = false
end)

RegisterNUICallback("focusOut", function(data)
  	if inMenu then
      	inMenu = false 
      	if IsPedUsingScenario(PlayerPedId(), "PROP_HUMAN_PARKING_METER") then
			ClearPedTasks(PlayerPedId())
      	end
  	end
end)