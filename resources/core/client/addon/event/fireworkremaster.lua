isFireWork = false
RegisterCommand('fwid', function(source, args, rawCommand)
    if p:getPermission() >= 4  then
        for i = 1, #args, 3 do
            ppos = vector3(tonumber(args[i]),tonumber(args[i+1]),tonumber(args[i+2]))
            TriggerServerEvent("firework:ServerStart", ppos)
        end
	end
end,false)

RegisterNetEvent('firework:ClientStart', function(ppos)
    isFireWork = true
	local pos = ppos
	
	local delay = 800

    local asset1 = "proj_indep_firework"
    RequestNamedPtfxAsset(asset1)
    while not HasNamedPtfxAssetLoaded(asset1) do
        Wait(1)
    end
    local asset2 = "proj_indep_firework_v2"
    RequestNamedPtfxAsset(asset2)
	while not HasNamedPtfxAssetLoaded(asset2) do
        Wait(1)
    end
	local asset3 = "scr_indep_fireworks"
    RequestNamedPtfxAsset(asset3)
	while not HasNamedPtfxAssetLoaded(asset3) do
        Wait(1)
    end

    while isFireWork do
        Wait(delay)
        UseParticleFxAssetNextCall(asset1)
        local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_air_burst", pos[1] + math.random(-100, 100), pos[2] + math.random(-100, 100), pos[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false, false)
        xSound:PlayUrlPos('explo', 'https://youtu.be/T4HNStSRLnk', 0.1, pos)
        xSound:Distance('explo', 1000.0)
        xSound:destroyOnFinish('explo', true)

		Wait(delay)
		UseParticleFxAssetNextCall(asset2)
        local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_spiral_burst_rwb", pos[1] + math.random(-200, 200), pos[2] + math.random(-200, 200), pos[3] + 25 + math.random(100, 200), 0.0, 0.0, 0.0, 5.0, false, false, false, false)
        xSound:PlayUrlPos('explo2', 'https://youtu.be/T4HNStSRLnk', 0.1, pos)
        xSound:Distance('explo2', 1000.0)
        xSound:destroyOnFinish('explo2', true)

		Wait(delay)
		UseParticleFxAssetNextCall(asset2)
        local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_repeat_burst_rwb", pos[1] + math.random(-100, 100), pos[2] + math.random(-100, 100), pos[3] + 25 + math.random(100, 200), 0.0, 0.0, 0.0, 5.0, false, false, false, false)
        xSound:PlayUrlPos('explo3', 'https://youtu.be/T4HNStSRLnk', 0.1, pos)
        xSound:Distance('explo3', 1000.0)
        xSound:destroyOnFinish('explo3', true)
        
		Wait(delay)
		UseParticleFxAssetNextCall(asset3)
        local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos[1] + math.random(-100, 100), pos[2] + math.random(-100, 100), pos[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 5.0, false, false, false, false)
        xSound:PlayUrlPos('explo4', 'https://youtu.be/T4HNStSRLnk', 0.1, pos)
        xSound:Distance('explo4', 1000.0)
        xSound:destroyOnFinish('explo4', true)

		Wait(delay)
		UseParticleFxAssetNextCall(asset3)
        local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", pos[1] + math.random(-100, 100), pos[2] + math.random(-100, 100), pos[3] + 25 + math.random(50, 200), 0.0, 0.0, 0.0, 5.0, false, false, false, false)
        xSound:PlayUrlPos('explo5', 'https://youtu.be/T4HNStSRLnk', 0.1, pos)
        xSound:Distance('explo5', 1000.0)
        xSound:destroyOnFinish('explo5', true)

		Wait(delay)
		UseParticleFxAssetNextCall(asset3)
        local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", pos[1], pos[2], pos[3], 0.0, 0.0, 0.0, 5.0, false, false, false, false)
        xSound:PlayUrlPos('explo6', 'https://youtu.be/T4HNStSRLnk', 0.1, pos)
        xSound:Distance('explo6', 1000.0)
        xSound:destroyOnFinish('explo6', true)
	end
    isFireWork=false
end)

RegisterCommand('stopfwid', function(source, args, rawCommand)
    if p:getPermission() >= 4  then
		TriggerServerEvent("firework:STOP")
	end
end,false)
RegisterNetEvent('firework:STOPcl', function(ppos)
    isFireWork = false
end)