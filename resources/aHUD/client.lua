local minimap = RequestScaleformMovie("minimap")
local toghud, posX, posY, width, height = true, -0.0045, 0.002, 0.150, 0.188888

RegisterNetEvent('hud:toggleui')
AddEventHandler('hud:toggleui', function(show)
    if show == true then
       toghud = true
    else
        toghud = false
    end
end)

CreateThread(function()
    while true do
        local player = PlayerPedId()
        local health = (GetEntityHealth(player) - 100)
		local armour = GetPedArmour(player)

        SendNUIMessage({
            action = 'updateStatusHud',
            show = toghud,
            health = health,
			armour = armour,
        })
        Wait(200)
    end
end)

--[[ CreateThread(function()
	RequestStreamedTextureDict("circlemap", false)
	while not HasStreamedTextureDictLoaded("circlemap") do
		Wait(100)
	end
	AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")
	SetMinimapClipType(1)
	SetMinimapComponentPosition('minimap', 'L', 'B', posX, posY, width, height)
	SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.021, 0.032, 0.1112, 0.159)
	--SetMinimapComponentPosition('minimap_mask', 'L', 'B', posX, posY, width, height)
	SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.0005, 0.008, 0.199999, 0.272)
    SetRadarBigmapEnabled(false, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
    while true do
        Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end) ]]

local uiHidden = false
CreateThread(function()
	while true do
		Wait(0)
		if IsBigmapActive() or IsRadarHidden() then
			if not uiHidden then
				SendNUIMessage({
					action = "hideUI"
				})
				uiHidden = true
			end
		elseif uiHidden then
			SendNUIMessage({
				action = "displayUI"
			})
			uiHidden = false
		end
	end
end)

-- Create afunction to update the admin overlay
function updateAdminOverlay(show, activeReports, activePlayers)
	SendNUIMessage({
		action = 'updateAdminOverlay',
		show = show,
		activeReports = activeReports,
		activePlayers = activePlayers
	})
end

-- Create afunction to update the admin overlay
function updateJobOverlay(show, data)
	SendNUIMessage({
		action = 'updateJobOverlay',
		show = show,
		data = data
	})
end

function dislpayWeazelAnnouncement(message)
	SendNUIMessage({
		action = 'displayWeazelAnnounce',
		content = message
	})
end

function toggleHotkeys(state)
	SendNUIMessage({
		action = 'toggleHotkeys',
		state = state
	})
end

function toggleSafeZoneIndicator(state)
	SendNUIMessage({
		action = 'toggleSafeZoneIndicator',
		state = state
	})
end

function toggleScreamer()
	SendNUIMessage({
		action = 'toggleScreamer'
	})
end

function ambiantHalloween()
	SendNUIMessage({
		action = 'ambiantHalloween'
	})
end

function toggleVehicleInTry(state, model)
	SendNUIMessage({
		action = 'toggleVehicleInTry',
		state = state,
		model = model
	})
end

function toggleElections(candidate_1, candidate_2)
	SendNUIMessage({
		action = 'toggleElections',
		candidate_1 = candidate_1,
		candidate_2 = candidate_2
	})
end

function toggleLimitedActions(state)
	SendNUIMessage({
		action = 'toggleLimitedActions',
		state = state
	})
end

exports('updateAdminOverlay', updateAdminOverlay)
exports('updateJobOverlay', updateJobOverlay)
exports('dislpayWeazelAnnouncement', dislpayWeazelAnnouncement)
exports('toggleHotkeys', toggleHotkeys)
exports('toggleSafeZoneIndicator', toggleSafeZoneIndicator)
exports('toggleScreamer', toggleScreamer)
exports('ambiantHalloween', ambiantHalloween)
exports('toggleVehicleInTry', toggleVehicleInTry)
exports('toggleElections', toggleElections)
exports('toggleLimitedActions', toggleLimitedActions)