local wasProximityDisabledFromOverride = false
disableProximityCycle = false
RegisterCommand('setvoiceintent', function(source, args)
	if GetConvarInt('voice_allowSetIntent', 1) == 1 then
		local intent = args[1]
		if intent == 'speech' then
			MumbleSetAudioInputIntent(`speech`)
		elseif intent == 'music' then
			MumbleSetAudioInputIntent(`music`)
		end
		LocalPlayer.state:set('voiceIntent', intent, true)
	end
end)

-- TODO: Better implementation of this?
RegisterCommand('vol', function(_, args)
	if not args[1] then return end
	setVolume(tonumber(args[1]))
end)

exports('setAllowProximityCycleState', function(state)
	type_check({ state, "boolean" })
	disableProximityCycle = state
end)

function ShowNotification(message)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(message)
	DrawNotification(0, 1)
end

function setProximityState(proximityRange, isCustom)
	local voiceModeData = Cfg.voiceModes[mode]
	if mode == 1 then
		-- ShowNotification("Intensité de la voix : ~g~Chuchoter")

		--[[ exports['vNotif']:createNotification({
			type = 'JAUNE',
			duration = 5, -- In seconds, default:  4
			content = "~c Intensité de la voix : ~c ~s Chuchoter ~s"
		}) ]]

		CreateThread(function()
			local size = 3.0 * 3.14
			local time = 1
			while true do 
				Wait(1)
				if mode ~= 1 then 
					break
				end
				time += 1
				if time > 40 then 
					break
				end
				DrawMarker(25, GetEntityCoords(PlayerPedId()) - vector3(0.0, 0.0, 0.9), 0.0, 0.0, 0.0,
					180.0, 0.0, 0.0, size, size, size, 144, 238, 144, 170, false, 1, 0, 0)
			end
		end)
	elseif mode == 2 then
		-- ShowNotification("Intensité de la voix : Parler")

		--[[ exports['vNotif']:createNotification({
			type = 'JAUNE',
			duration = 5, -- In seconds, default:  4
			content = "~c Intensité de la voix : ~c ~s Parler ~s"
		}) ]]

		CreateThread(function()
			local size = 6.0 * 3.14
			local time = 1
			while true do 
				Wait(1)
				if mode ~= 2 then 
					break
				end
				time += 1
				if time > 40 then 
					break
				end
				DrawMarker(25, GetEntityCoords(PlayerPedId()) - vector3(0.0, 0.0, 0.9), 0.0, 0.0, 0.0,
					180.0, 0.0, 0.0, size, size, size, 255, 255, 255, 170, false, 1, 0, 0)
			end
		end)
	elseif mode == 3 then
		-- ShowNotification("Intensité de la voix : ~r~Crier")

		--[[ exports['vNotif']:createNotification({
			type = 'JAUNE',
			duration = 5, -- In seconds, default:  4
			content = "~c Intensité de la voix : ~c ~s Crier ~s"
		}) ]]

		CreateThread(function()
			local size = 16.0 * 3.14
			local time = 1
			while true do 
				Wait(1)
				if mode ~= 3 then 
					break
				end
				time += 1
				if time > 40 then 
					break
				end
				DrawMarker(25, GetEntityCoords(PlayerPedId()) - vector3(0.0, 0.0, 0.9), 0.0, 0.0, 0.0,
					180.0, 0.0, 0.0, size, size, size, 255, 100, 100, 170, false, 1, 0, 0)
			end
		end)
	end
	MumbleSetTalkerProximity(proximityRange + 0.0)
	LocalPlayer.state:set('proximity', {
		index = mode,
		distance = proximityRange,
		mode = isCustom and "Custom" or voiceModeData[2],
	}, true)
	exports["core"]:GetProximity(mode)
	sendUIMessage({
		-- JS expects this value to be - 1, "custom" voice is on the last index
		voiceMode = isCustom and #Cfg.voiceModes or mode - 1
	})
end

exports("overrideProximityRange", function(range, disableCycle)
	type_check({ range, "number" })
	setProximityState(range, true)
	if disableCycle then
		disableProximityCycle = true
		wasProximityDisabledFromOverride = true
	end
end)

exports("clearProximityOverride", function()
	local voiceModeData = Cfg.voiceModes[mode]
	setProximityState(voiceModeData[1], false)
	if wasProximityDisabledFromOverride then
		disableProximityCycle = false
	end
end)

RegisterCommand('cycleproximity', function()
	-- Proximity is either disabled, or manually overwritten.
	if GetConvarInt('voice_enableProximityCycle', 1) ~= 1 or disableProximityCycle then return end
	local newMode = mode + 1
	-- If we're within the range of our voice modes, allow the increase, otherwise reset to the first state
	if newMode <= #Cfg.voiceModes then
		mode = newMode
	else
		mode = 1
	end
	setProximityState(Cfg.voiceModes[mode][1], false)
	TriggerEvent('pma-voice:setTalkingMode', mode)
end, false)
if gameVersion == 'fivem' then
	RegisterKeyMapping('cycleproximity', 'Cycle Proximity', 'keyboard', GetConvar('voice_defaultCycle', 'F11'))
end


RegisterCommand('vsync', function()
--[[ 	local newGrid = getGridZone()
	print(('[vsync] Forcing zone from %s to %s and resetting voice targets.'):format(currentGrid, newGrid))
 ]]	if GetConvar('voice_externalAddress', '') ~= '' and GetConvarInt('voice_externalPort', 0) ~= 0 then
		MumbleSetServerAddress(GetConvar('voice_externalAddress', ''), GetConvarInt('voice_externalPort', 0))
		while not MumbleIsConnected() do
			Wait(250)
		end
	end
--[[ 	NetworkSetVoiceChannel(newGrid + 100) ]]
	-- reset the players voice targets
--[[ 	MumbleSetVoiceTarget(0)
	MumbleClearVoiceTarget(1)
	MumbleSetVoiceTarget(1)
	MumbleClearVoiceTargetPlayers(1) ]]

	handleInitialState()

	print('[Absolute] Synchronisation du vocal effectué...')


--[[ 	local newGrid = getGridZone()
--[[ 	if newGrid ~= currentGrid then
        logger.info('Updating zone from %s to %s and adding nearby grids, was forced: %s.', currentGrid, newGrid, forced)
		currentGrid = newGrid
	end ]]

	TriggerEvent("mumbleConnected")

--[[ 	print(('[vsync] Forcing zone from %s to %s and resetting voice targets.'):format(currentGrid, newGrid))

	currentGrid = newGrid ]]

	-- force a zone update.
--[[ 	updateZone(true) ]]
end)