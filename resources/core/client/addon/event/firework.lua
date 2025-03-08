local particleDict = "scr_indep_fireworks"
local fireworkOver = false



FireworkLocations = {
    { ["x"] = -1934.69, ["y"] = -1333.48, ["z"] = 20.74, ["Fireworktype"] = "Battery"},
    { ["x"] = -1800.69, ["y"] = -1333.48, ["z"] = 20.74, ["Fireworktype"] = "Rocket"},
    { ["x"] = -1752.13, ["y"] = -1486.68, ["z"] = 20.74, ["Fireworktype"] = "Fountain"},
    { ["x"] = -1896.52, ["y"] = -1491.06, ["z"] = 20.74, ["Fireworktype"] = "Rocket"},
    { ["x"] = -1714.08, ["y"] = -1404.71, ["z"] = 20.74, ["Fireworktype"] = "Battery"},
    { ["x"] = -1635.27, ["y"] = -1574.06, ["z"] = 20.74, ["Fireworktype"] = "Fountain"},
    { ["x"] = -1714.08, ["y"] = -1404.71, ["z"] = 20.74, ["Fireworktype"] = "Battery"},
    { ["x"] = -1661.6, ["y"] = -1477.31, ["z"] = 20.74, ["Fireworktype"] = "Rocket"},
    { ["x"] = -1784.64, ["y"] = -1309.06, ["z"] = 20.74, ["Fireworktype"] = "Fountain"},
    { ["x"] = -1778.74, ["y"] = -1399.71, ["z"] = 20.74, ["Fireworktype"] = "Rocket"},
    { ["x"] = -1826.71, ["y"] = -1523.61, ["z"] = 20.74, ["Fireworktype"] = "Fountain"},
    { ["x"] = -1766.11, ["y"] = -1638.99, ["z"] = 20.74, ["Fireworktype"] = "Rocket"},
    { ["x"] = -1687.31, ["y"] = -1557.52, ["z"] = 20.74, ["Fireworktype"] = "Battery"},
}

RegisterNetEvent("firework:startFireworkShowCheck")
AddEventHandler("firework:startFireworkShowCheck", function()
	if p:getPermission() > 0 then
		TriggerEvent("firework:startFireworkShow")
	end
end)


RegisterNetEvent("firework:startFireworkShow")
AddEventHandler("firework:startFireworkShow", function()

    for i = 1, #FireworkLocations, 1 do
        local fireworkPos = vector3(FireworkLocations[i]["x"], FireworkLocations[i]["y"], FireworkLocations[i]["z"])
        local fireworkType = FireworkLocations[i]["Fireworktype"]

        if fireworkType == "Battery" then
            TriggerServerEvent("firework:battery", fireworkPos)
        elseif fireworkType == "Rocket" then
			TriggerServerEvent("firework:rocket", fireworkPos)
		elseif fireworkType == "Fountain" then
			TriggerServerEvent("firework:fountain", fireworkPos)
		end
    end
end)

RegisterCommand("firework", function()
	if p:getPermission() >= 4  then
		TriggerEvent("firework:itemTrigger")
	end
end)

RegisterNetEvent("firework:itemTrigger")
AddEventHandler("firework:itemTrigger", function()
	local px, py, pz = table.unpack(p:pos()) -- Les coords du joueurs unpack
    local vx, vy , vz = table.unpack(GetEntityForwardVector(p:ped())) -- Le vecteur unitaire de direction du joueur unpack
    local x = px + vx  -- Utilise le vecteur unitaire pour mettre les props à 1 unité de lui grace au vecteur unitaire + ces coords
    local y = py + vy
    local z = pz + vz -0.6
	local fireworkPos = vector3(x, y, z)
	TriggerServerEvent("firework:item", fireworkPos)
end)



RegisterNetEvent("firework:stopFireworkShow")
AddEventHandler("firework:stopFireworkShow", function()
	fireworkOver = true
end)


RegisterNetEvent("firework:battery")
AddEventHandler("firework:battery", function(fireworkPos)
    RequestNamedPtfxAsset(particleDict)
    while not HasNamedPtfxAssetLoaded(particleDict) do
        Wait(1)
	end
	
	UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", fireworkPos, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
	local particle2 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", fireworkPos, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
	local particle3 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", fireworkPos, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
	local particle4 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", fireworkPos, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
	local particle5 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", fireworkPos, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
	local particle6 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", fireworkPos, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
	local particle7 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", fireworkPos, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
	local particle8 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", fireworkPos, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(4000)
	UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
	local particle9 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", fireworkPos, 0.0, 0.0, 0.0, math.random() * 0.5 + 1.8, false, false, false, false)

	if fireworkOver then
		return
	else
		TriggerEvent("firework:battery", fireworkPos)
	end
end)

RegisterNetEvent("firework:rocket")
AddEventHandler("firework:rocket", function(fireworkPos)
	while not HasNamedPtfxAssetLoaded(particleDict) do
        Wait(1)
    end
    UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
    local particle = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 0.0, 0.0, 2.5, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
    local particle2 = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 0.0, 0.0, 2.5, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
    local particle3 = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 0.0, 0.0, 2.5, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
    local particle4 = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 0.0, 0.0, 2.5, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
    local particle5 = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 0.0, 0.0, 2.5, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
    local particle6 = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 0.0, 0.0, 2.5, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
    local particle7 = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 0.0, 0.0, 2.5, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
    local particle8 = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 0.0, 0.0, 2.5, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
    local particle9 = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 0.0, 0.0, 2.5, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
    local particle10 = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 0.0, 0.0, 2.5, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
    local particle11 = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 0.0, 0.0, 2.5, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
    local particle12 = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 0.0, 0.0, 2.5, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
    local particle13 = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 0.0, 0.0, 2.5, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
    local particle14 = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 0.0, 0.0, 2.5, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
    local particle15 = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 0.0, 0.0, 2.5, false, false, false, false)
	Wait(1500)

	if fireworkOver then
		return
	else
		TriggerEvent("firework:rocket", fireworkPos)
	end
end)

RegisterNetEvent("firework:fountain")
AddEventHandler("firework:fountain", function(fireworkPos)
	RequestNamedPtfxAsset(particleDict)
    while not HasNamedPtfxAssetLoaded(particleDict) do
        Wait(1)
	end
	
	UseParticleFxAssetNextCall(particleDict)
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", fireworkPos, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	local particle2 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", fireworkPos, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	local particle3 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", fireworkPos, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	local particle4 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", fireworkPos, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	local particle5 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", fireworkPos, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(2500)
	UseParticleFxAssetNextCall(particleDict)
	local particle6 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", fireworkPos, 0.0, 0.0, 0.0, math.random() * 1.5 + 1.8, false, false, false, false)
	Wait(2500)
	UseParticleFxAssetNextCall(particleDict)
	local particle7 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", fireworkPos, 0.0, 0.0, 0.0, math.random() * 1.5 + 1.8, false, false, false, false)
	Wait(2500)
	UseParticleFxAssetNextCall(particleDict)
	local particle8 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", fireworkPos, 0.0, 0.0, 0.0, math.random() * 1.5 + 1.8, false, false, false, false)

	if fireworkOver then
		return
	else
		TriggerEvent("firework:rocket", fireworkPos)
	end
end)


RegisterNetEvent("firework:item")
AddEventHandler("firework:item", function(fireworkPos)
	sequence(fireworkPos)
end)

function sequence(fireworkPos)
	RequestNamedPtfxAsset("scr_indep_fireworks")
    while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
        Wait(1)
	end

	local prop = "prop_tool_box_05"
	local modelhash = GetHashKey(prop)
	local isNetwork = true

	-- RequestModel(modelhash)
	-- while not HasModelLoaded(modelhash) do
	--   Citizen.Wait(100)
	-- end

	-- local box = CreateObject(modelhash, fireworkPos, isNetwork, false, false)
	-- PlaceObjectOnGroundProperly(box)
    -- FreezeEntityPosition(box, true)
    -- SetModelAsNoLongerNeeded(modelhash)


	Wait(10000)
	local i = 0
	while i < 15 do 
		local choose = math.random(0,5)
		if choose < 2 then
			UseParticleFxAssetNextCall("scr_indep_fireworks")
			local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", fireworkPos, 0.0, 0.0, 0.0, math.random(-2, 1) * 0.5 + 0.8, false, false, false, false)
			UseParticleFxAssetNextCall("scr_indep_fireworks")
			local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 40.0, 0, -80.0, math.random() * 0.5 + 0.8, false, false, false, false)
			Wait(50)
			UseParticleFxAssetNextCall("scr_indep_fireworks")
			local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 40.0, 80.0, math.random() * 0.5 + 0.8, false, false, false, false)
			Wait(300)
			UseParticleFxAssetNextCall("scr_indep_fireworks")
			SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
			local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 0.0, 0.0, math.random() * 1.5 + 0.8, false, false, false, false)
			Wait(3000)
		elseif choose < 3 then
			UseParticleFxAssetNextCall("scr_indep_fireworks")
			local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", fireworkPos, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
			UseParticleFxAssetNextCall("scr_indep_fireworks")
			local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", fireworkPos, 0.0, 0.0, math.random() * 0.2, math.random() * 0.5 + 0.8, false, false, false, false)
			Wait(3000)
		else 
			UseParticleFxAssetNextCall("scr_indep_fireworks")
			local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", fireworkPos, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
			Wait(5000)
		end
		i = i + 1
	end
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", fireworkPos, 0.0, 0.0, 0.0, math.random(-2, 1) * 0.5 + 0.8, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 40.0, 0, -80.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(50)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 40.0, 80.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(300)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 0.0, 0.0, math.random() * 1.5 + 0.8, false, false, false, false)
	Wait(400)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 40.0, 0, -80.0, math.random() * 3.5 + 0.8, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 40.0, 80.0, math.random() * 3.5 + 0.8, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", fireworkPos, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(300)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", fireworkPos, 0.0, 0.0, 0.0, math.random(-2, 1) * 0.5 + 0.8, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 40.0, 0, -80.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(50)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 40.0, 80.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(300)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 0.0, 0.0, math.random() * 1.5 + 0.8, false, false, false, false)
	Wait(400)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 40.0, 0, -80.0, math.random() * 3.5 + 0.8, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 40.0, 80.0, math.random() * 3.5 + 0.8, false, false, false, false)
	Wait(200)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", fireworkPos, 0.0, 0.0, 0.0, math.random(-2, 1) * 0.5 + 0.8, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 40.0, 0, -80.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(50)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 40.0, 80.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(300)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 0.0, 0.0, math.random() * 1.5 + 0.8, false, false, false, false)
	Wait(800)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 40.0, 0, -80.0, math.random() * 3.5 + 0.8, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 40.0, 80.0, math.random() * 3.5 + 0.8, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", fireworkPos, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(5000)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", fireworkPos, 0.0, 0.0, 0.0, math.random(-2, 1) * 0.5 + 0.8, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 40.0, 0, -80.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(50)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 40.0, 80.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(300)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 0.0, 0.0, math.random() * 1.5 + 0.8, false, false, false, false)
	Wait(400)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 40.0, 0, -80.0, math.random() * 3.5 + 0.8, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", fireworkPos, 0.0, 40.0, 80.0, math.random() * 3.5 + 0.8, false, false, false, false)
	DeleteEntity(box)
end