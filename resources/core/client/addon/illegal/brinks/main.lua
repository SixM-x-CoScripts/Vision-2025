local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local pedBrinks = nil
local ped2Brinks = nil
local VehBrinks = nil
local InsideBrinks = false

stopScript = false

local zoneRadius
local hasallAimed = 0

InsideBracoBrinks = false
local MaxToShow = 1

local list = {
    north = {
        { start = vec4(2703.8308105469, 3453.1413574219, 54.704235076904, 169.90058898926), finish = vec3(-121.25982666016, 6481.7548828125, 30.413507461548) },
        { start = vec4(1202.5378417969, 2725.7817382813, 37.00415802002, 241.12022399902), finish = vec3(-123.36944580078, 6479.7827148438, 30.465406417847) },
        { start = vec4(181.35961914063, 6632.6352539063, 30.572723388672, 177.89540100098), finish = vec3(1210.2327880859, 2721.9318847656, 37.00505065918) }
    },
    south = {
        { start = vec4(-454.91506958008, -2799.6799316406, 4.6070213317871, 45.071636199951), finish = vec3(-2942.8996582031, 477.61706542969, 13.85596370697) },
        --{ start = vec4(-611.90478515625, -1029.9036865234, 20.787540435791, 95.631134033203), finish = vec3(257.25289916992, 277.60943603516, 104.61624145508) },
        --{ start = vec4(976.61071777344, 7.822597026825, 80.041000366211, 146.50180053711), finish = vec3(163.34762573242, -3041.7004394531, 4.9346089363098) },
        --{ start = vec4(-377.68240356445, -1876.3901367188, 19.527839660645, 10.261813163757), finish = vec3(254.5302734375, 278.74893188477, 104.5799331665) },
        --{ start = vec4(256.15197753906, 278.44445800781, 104.59992980957, 71.661918640137), finish = vec3(-1002.194152832, -2413.8823242188, 12.944536209106) }
    }
}

function startHackingBrinks()
    InsideBracoBrinks = true
    local var = GetVariable("heist").brinks
    if GetVariable("heist") and var and var.Players then
        if tonumber(var.Players) > 0 then
            MaxToShow = tonumber(var.Players)
        end
    end
    Bulle.hide("laptopbrinks")
    local plyPed = PlayerPedId()
    local plyPos = GetEntityCoords(plyPed)
    local animDict = "anim@heists@ornate_bank@hack"
    local props = "hei_prop_hst_laptop"

    RequestAnimDict(animDict)
    RequestModel(props)

    while not HasAnimDictLoaded(animDict) or not HasModelLoaded(props) do
        Citizen.Wait(10)
    end

    local targetPosition, targetRotation = vec3(plyPos.x, plyPos.y, plyPos.z+0.5), GetEntityRotation(plyPed)
    
    local animPos = GetAnimInitialOffsetPosition(animDict, "hack_loop", targetPosition, targetRotation, 0, 2)
    
    --FreezeEntityPosition(plyPed, true)

    local laptop = CreateObject(GetHashKey(props), targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(laptop, netScene, animDict, "hack_enter_laptop", 4.0, -8.0, 1)
    
    local netScene = NetworkCreateSynchronisedScene(targetPosition, targetRotation, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(plyPed, netScene, animDict, "hack_loop", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(laptop, netScene, animDict, "hack_loop_laptop", 4.0, -8.0, 1)

    NetworkStartSynchronisedScene(netScene)
    Citizen.Wait(5000)
    
    TriggerEvent("datacrack:start", 4.5, function(output)
        if output == true then
            InsideBracoBrinks = true
            if DlcIllegal then 
                TriggerServerEvent("core:RemoveItemToInventory", token, "laptop", 1, {})
                startBrinksTrackingDLC()
            else
                startBrinksTracking()
            end
        else
            InsideBracoBrinks = false
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous n'avez pas réussie a pirater le terminal"
            })
        end
        setUsingComputer(false)
        NetworkStopSynchronisedScene(netScene)
        --FreezeEntityPosition(plyPed, false)
    end)
    DeleteEntity(laptop)
end

--[[function startBrinksTracking()
    TriggerSWEvent("TREFSDFD5156FD", "ADSFDF", 5000)
    TriggerSWEvent("TREFSDFD5156FD", "AESDAZDS", 5000)
    TriggerSWEvent("TREFSDFD5156FD", "VZEFDSF", 5000)
    Citizen.CreateThread(function()
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            content = "Début de la transmission de la position du transport brinks"
        })

        local route = nil
        local plyPed = PlayerPedId()
        local plyPos = GetEntityCoords(plyPed)
        --local isInSouth = coordsIsInSouth(plyPos)
        --if isInSouth then
        route = list.south[math.random(1, #list.south)]
        --else
        --    route = list.north[math.random(1, #list.north)]
        --end
        
        local ped = entity:CreatePed("mp_s_m_armoured_01", route.start).id
        local ped2 = entity:CreatePed("mp_s_m_armoured_01", route.start).id
        SetEntityAsMissionEntity(ped, true, true)
        SetEntityAsMissionEntity(ped2, true, true)
        SetEntityInvincible(ped, true)
        SetEntityInvincible(ped2, true)
        AddRelationshipGroup("brinks")
        SetPedCombatAttributes(ped, 0, true) 
        SetPedCombatAttributes(ped, 5, true) 
        SetPedCombatAttributes(ped, 46, true)
        SetPedFleeAttributes(ped, 0, true)
        SetPedRelationshipGroupHash(ped, GetHashKey("brinks"))
        GiveWeaponToPed(ped, GetHashKey("weapon_smg"), 255, false, true)
        SetPedCombatAttributes(ped2, 0, true) 
        SetPedCombatAttributes(ped2, 5, true) 
        SetPedCombatAttributes(ped2, 46, true)
        SetPedFleeAttributes(ped2, 0, true)
        SetPedRelationshipGroupHash(ped2, GetHashKey("brinks"))
        GiveWeaponToPed(ped2, GetHashKey("weapon_smg"), 255, false, true)

        SetRelationshipBetweenGroups(4, GetHashKey("brinks"), GetHashKey("PLAYER")) 
        local vehicle = Modules.World.CreateVehicle("stockade", route.start, true)
        NetworkRequestControlOfEntity(vehicle)
        SetEntityAsMissionEntity(vehicle, true, true)
        SetPedIntoVehicle(ped, vehicle, -1)
        SetPedIntoVehicle(ped2, vehicle, 0)

        SetDriverAbility(ped, 1.0)
        SetDriverAggressiveness(ped, 0.0)
        TaskVehicleDriveToCoordLongrange(ped, vehicle, route.finish, 50.0, 427, 5.0);
        SetEntityInvincible(ped, false)
        SetEntityInvincible(ped2, false)
        
        local count = 100
        local alphaBlip = 255
        local alphaZone = 180

        --local blip = AddBlipForCoord(GetEntityCoords(vehicle))
        --SetBlipSprite(blip, 477)
        --SetBlipScale(blip, 0.75)
        --SetBlipColour(blip, 1)
        --SetBlipAsShortRange(blip, false)
        --BeginTextCommandSetBlipName('STRING')
        --AddTextComponentSubstringPlayerName("Camion BRINKS")
        --EndTextCommandSetBlipName(blip)

        zoneRadius = AddBlipForRadius(GetEntityCoords(vehicle), 100.0)
        SetBlipColour(zoneRadius, 1)
        SetBlipAlpha(zoneRadius, alphaZone)

        TriggerServerEvent("brinksSendStart", VehToNet(vehicle))

        while true do
            if count == 0 then
                SetBlipCoords(zoneRadius, GetEntityCoords(vehicle))
                count = 100
                alphaBlip = 255
                alphaZone = 180
            end
            if #(GetEntityCoords(vehicle) - route.finish) < 10.0 then
                DeleteEntity(ped)
                DeleteEntity(ped2)
                DeleteEntity(vehicle)
                RemoveBlip(zoneRadius)
                break
            end 
            --alphaBlip = alphaBlip - 2
            --alphaZone = alphaZone - 1
            --if alphaZone < 20 then
            --    alphaZone = 20
            --end
            SetBlipAlpha(zoneRadius, alphaZone)
            count = count - 1
            Wait(100)
            if (not IsPedInAnyVehicle(ped, false)) or IsEntityDead(ped) then
                local isInSouth = coordsIsInSouth(GetEntityCoords(vehicle))
                if isInSouth then
                    TriggerSecurEvent('core:makeCall', "lspd",
                        GetEntityCoords(vehicle), true,
                        "Appel de renfort d'un convoi brink", false, "illegal")
                    TriggerSecurEvent('core:makeCall', "gcp",
                        GetEntityCoords(vehicle), true,
                        "Appel de renfort d'un convoi brinks", false, "illegal")
                else
                    TriggerSecurEvent('core:makeCall', "lssd",
                        GetEntityCoords(vehicle), true,
                        "Appel de renfort d'un convoi brinks", false, "illegal")
                end
                Wait(5000)
                RemoveBlip(zoneRadius)
                break
            end
        end
    end)
end]]

RegisterCommand("stopScript", function()
    ClearAllBlipRoutes()
    stopScript = true 
    Wait(2000)
    stopScript = false 
    TriggerEvent("stopscript")
    ExecuteCommand("stoplettre")
end)

local Ped1ForceHands = false
local Ped2ForceHands = false

--RegisterCommand("tt", function()
--    startBrinksTrackingDLC()
--end)

function PlayEmoteOnPed(ped, dict, anim, flag, duration)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do Wait(1) end
	TaskPlayAnim(ped, dict, anim, 1.0, 1.0, duration, flag or 32, 1.0, 0, 0, 0)
	RemoveAnimDict(dict)
end

local zoneRadius2
RegisterNetEvent("core:sync:brinks", function(route)
    if zoneRadius2 then 
        RemoveBlip(zoneRadius2)
    end
    if route ~= nil then
        zoneRadius2 = AddBlipForRadius(route, 100.0)
        SetBlipColour(zoneRadius2, 1)
        SetBlipAlpha(zoneRadius2, 180)
    else
        RemoveBlip(zoneRadius2)
    end
end)

local RouteStart = {
    vector4(861.27447509766, -906.59979248047, 24.555858612061, 265.45602416992),
    --vector4(644.72113037109, 274.11782836914, 102.13534545898, 147.66552734375),
}

RegisterNetEvent("core:StartBrinks", function()
    print("yes")
    startBrinksTrackingDLC(true)
end)

RegisterNetEvent("core:brinks:allCrewSpawn", function(vehicle2, start, endPos, ped, ped2, group)
    --print(NotifImageIA[math.random(1, #NotifImageIA)].lien)
    print("group", group)
    if group and group ~= "tout le monde" then
        if p:getCrew() == "None" or string.lower(p:getCrewType()) ~= string.lower(group) then 
            print("not for me")
            return
        end
    end
    while not NetworkDoesEntityExistWithNetworkId(vehicle2) do
        Wait(0)
        --print("not exist")
    end
    while not NetworkDoesEntityExistWithNetworkId(ped) do
        Wait(0)
        --print("not exist")
    end
    while not NetworkDoesEntityExistWithNetworkId(ped2) do
        Wait(0)
        --print("not exist")
    end
    if group and p:getCrewType() == group or p:getCrew() ~= "None" then
        exports['vNotif']:createNotification({
            type = 'ILLEGAL',
            name = "Indic",
            label = "Fourgon Brinks",
            labelColor = "#E81010",
            logo = NotifImageIA[math.random(1, #NotifImageIA)].lien,
            mainMessage = "J'ai apperçu un fourgon de la brinks, je t'ai mis point GPS, va le voler",
            duration = 10,
        })
    end
    print("STARRTTTT")
    InsideBrinks = true
    SetNetworkIdExistsOnAllMachines(vehicle2, true)
    SetNetworkIdExistsOnAllMachines(ped, true)
    SetNetworkIdExistsOnAllMachines(ped2, true)
    vehicle2 = NetworkGetEntityFromNetworkId(vehicle2)
    ped = NetworkGetEntityFromNetworkId(ped)
    ped2 = NetworkGetEntityFromNetworkId(ped2)
    printDev(GetEntityCoords(vehicle2), GetEntityCoords(ped), GetEntityCoords(ped2))
    SetEntityAsMissionEntity(vehicle2, true, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetEntityAsMissionEntity(ped2, true, true)
    print(p:getJob())
    if p:getJob() == "police" or p:getJob() == "lssd" then 
    else
        startBrinksTrackingDLC(true, start, vehicle2, endPos, ped, ped2)
    end
end)

RegisterNetEvent("core:brinks:illegal:finish", function()
    DeleteEntity(pedBrinks)
    DeleteEntity(ped2Brinks)
    InsideBracoBrinks = false
    DeleteEntity(VehBrinks)
    RemoveBlip(zoneRadius)
    pedBrinks = nil
    InsideBrinks = false
    ped2Brinks = nil
    VehBrinks = nil
    zoneRadius = nil
end)

local PublicUpdatedPos = nil 

RegisterNetEvent("core:events:brinks:updatepos", function(pos)
    PublicUpdatedPos = pos
end)

function startBrinksTrackingDLC(randomTra, start, vehicleG, endPos, pedG, ped2G)
    if start then
        PublicUpdatedPos = start.xyz
    end
    InsideBrinks = true
    local hasDrive = false
    TriggerSWEvent("TREFSDFD5156FD", "ADSFDF", 5000)
    TriggerSWEvent("TREFSDFD5156FD", "AESDAZDS", 5000)
    TriggerSWEvent("TREFSDFD5156FD", "VZEFDSF", 5000)
    Citizen.CreateThread(function()
        if not randomTra then
            print("yes2")
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                content = "Début de la transmission de la position du transport brinks"
            })
        end

        local route = nil
        local plyPed = PlayerPedId()
        local plyPos = GetEntityCoords(plyPed)
        if randomTra and not vehicleG then 
            route = {}
            route.start = RouteStart[math.random(1, #RouteStart)]
            route.finish = vector3(-1741.7572021484, -724.54760742188, 9.4439859390259)
        else
            if vehicleG then
                route = {}
                route.start = start
                route.finish = endPos
            else
                route = {}
                route.start = vector3(-454.91506958008, -2799.6799316406, 4.6070213317871)
                route.finish = vec3(-2942.8996582031, 477.61706542969, 13.85596370697)
            end
        end
        
        if route == nil or route.start == nil or route.start == vector3(0.0, 0.0, 0.0) or route.start == vector4(0.0, 0.0, 0.0, 0.0) then 
            route.start = vector4(-454.91506958008, -2799.6799316406, 4.6070213317871, 45.071636199951)
            route.finish = vector3(-1741.7572021484, -724.54760742188, 9.4439859390259)
        end
        
        if not randomTra then TriggerServerEvent("core:brinks:sync", p:getCrew(), route.start) end
        
        printDev("route.start", route.start)
        local ped 
        local ped2
        if not vehicleG then
            ped = entity:CreatePed("mp_s_m_armoured_01", route.start).id
            ped2 = entity:CreatePed("mp_s_m_armoured_01", route.start).id
        else
            ped = pedG
            ped2 = ped2G
        end
        NetworkRequestControlOfEntity(ped)
        NetworkRequestControlOfEntity(ped2)
        while not NetworkHasControlOfEntity(ped) do 
            Wait(1)
        end
        while not NetworkHasControlOfEntity(ped2) do 
            Wait(1)
        end
        pedBrinks = ped
        ped2Brinks = pedG
        SetEntityAsMissionEntity(ped, true, true)
        SetEntityAsMissionEntity(ped2, true, true)
        SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(ped), true)
        SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(ped2), true)
        SetEntityInvincible(ped, true)
        SetEntityInvincible(ped2, true)
        AddRelationshipGroup("brinks")
        SetPedCombatAttributes(ped, 0, true) 
        SetPedCombatAttributes(ped, 5, true) 
        SetPedCombatAttributes(ped, 46, true)
        SetPedFleeAttributes(ped, 0, true)
        SetPedRelationshipGroupHash(ped, GetHashKey("brinks"))
        GiveWeaponToPed(ped, GetHashKey("weapon_smg"), 255, false, true)
        SetPedCombatAttributes(ped2, 0, true) 
        SetPedCombatAttributes(ped2, 5, true) 
        SetPedCombatAttributes(ped2, 46, true)
        SetPedFleeAttributes(ped2, 0, true)
        SetPedRelationshipGroupHash(ped2, GetHashKey("brinks"))
        GiveWeaponToPed(ped2, GetHashKey("weapon_smg"), 255, false, true)

        SetRelationshipBetweenGroups(1, GetHashKey("brinks"), GetHashKey("PLAYER")) 
        local vehicle
        if not vehicleG then
            vehicle = Modules.World.CreateVehicle("stockade", route.start, true)
        else
            vehicle = vehicleG
        end
        NetworkRequestControlOfEntity(vehicle)
        while not NetworkHasControlOfEntity(vehicle) do 
            Wait(1)
        end
        VehBrinks = vehicle
        SetPedIntoVehicle(ped, vehicle, -1)
        SetPedIntoVehicle(ped2, vehicle, 0)

        SetDriverAbility(ped, 1.0)
        SetDriverAggressiveness(ped, 0.0)
        TaskVehicleDriveToCoordLongrange(ped, vehicle, route.finish, 75.0, 447, 2.0)
        SetEntityInvincible(ped, false)
        SetEntityInvincible(ped2, false)

        if not vehicleG then
            TriggerServerEvent("core:brinksPeds", PedToNet(ped), PedToNet(ped2), VehToNet(vehicle))
            print("yes4")
        end
        
        local count = 100
        local alphaBlip = 255
        local alphaZone = 180
        local averti = false

        if not randomTra then 
            if GetEntityCoords(vehicle) == vector3(0.0, 0.0, 0.0) then
                zoneRadius = AddBlipForRadius(route.start.xyz, 100.0)
                SetBlipColour(zoneRadius, 1)
                SetBlipAlpha(zoneRadius, alphaZone)
            else
                zoneRadius = AddBlipForRadius(GetEntityCoords(vehicle), 100.0)
                SetBlipColour(zoneRadius, 1)
                SetBlipAlpha(zoneRadius, alphaZone)
            end
        else
            if vehicleG then
                if PublicUpdatedPos then
                    --print(PublicUpdatedPos)
                    zoneRadius = AddBlipForRadius(PublicUpdatedPos + vector3(math.random(1, 9), math.random(1, 9), 0.0), 250.0)
                    SetBlipColour(zoneRadius, 1)
                    SetBlipAlpha(zoneRadius, alphaZone)
                end
            end
        end

        if not vehicleG then
            TriggerServerEvent("brinksSendStart", VehToNet(vehicle))
        end

        CreateThread(function()
            while true do 
                Wait(2000)
                if IsPlayerFreeAiming(PlayerId()) then
                    hasallAimed = TriggerServerCallback("core:hasallAimedAt", VehToNet(vehicle))
                    if hasallAimed and hasallAimed >= MaxToShow then 
                        TaskLeaveVehicle(ped, vehicle, 1)
                        TaskLeaveVehicle(ped2, vehicle, 1)
                        TaskEveryoneLeaveVehicle(vehicle)
                        RequestAnimDict("random@mugging3")
                        while not HasAnimDictLoaded("random@mugging3") do
                            Wait(0)
                        end
                        NetworkRequestControlOfEntity(ped)
                        NetworkRequestControlOfEntity(ped2)
                        Wait(2000)
                        TaskPlayAnim(ped, "random@mugging3", "handsup_standing_base", 1.0, 1.0, -1, 49, 1.0)
                        Wait(500)
                        TaskPlayAnim(ped2, "random@mugging3", "handsup_standing_base", 1.0, 1.0, -1, 49, 1.0)
                        Wait(200)
                        Ped1ForceHands = true
                        Ped2ForceHands = true
                        RemoveAnimDict("random@mugging3")
                        if IsPedInAnyVehicle(ped) then 
                            TaskLeaveVehicle(ped, vehicle, 1)
                        end
                        if IsPedInAnyVehicle(ped2) then 
                            TaskLeaveVehicle(ped2, vehicle, 1)
                        end
                        TriggerServerEvent("core:brinksPeds", PedToNet(ped), PedToNet(ped2), VehToNet(vehicle))
                        break
                    end
                end
            end
        end)
        
       --CreateThread(function()
       --    while true do 
       --        Wait(5000)
       --        local ped1AimedAt, ped2AimedAt = TriggerServerCallback("core:arepedsAimedAt", PedToNet(ped),PedToNet(ped2))
       --        if ped1AimedAt < 1 then 
       --            TaskSmartFleePed(ped, PlayerPedId(), 999.9, -1)
       --        end
       --        if ped2AimedAt < 1 then 
       --            TaskSmartFleePed(ped2, PlayerPedId(), 999.9, -1)
       --        end
       --    end
       --end)

        while true do

            if stopScript then 
                if not vehicleG then
                    DeleteEntity(ped)
                    DeleteEntity(ped2)
                    DeleteEntity(vehicle)
                end
                InsideBracoBrinks = false
                RemoveBlip(zoneRadius)
                TriggerServerEvent("core:brinks:sync", p:getCrew(), nil)
                if Serveur == "FA" then
                    exports['tuto-fa']:HideStep()
                elseif Serveur == "WL" then
                    exports['tuto-wl']:HideStep()
                end
                break
            end

            if count == 0 then
                if not vehicleG then
                    SetBlipCoords(zoneRadius, GetEntityCoords(vehicle))
                    if not randomTra then TriggerServerEvent("core:brinks:sync", p:getCrew(), GetEntityCoords(vehicle)) end
                    count = 200
                    alphaBlip = 255
                    alphaZone = 180
                else
                    if PublicUpdatedPos then
                        SetBlipCoords(zoneRadius, PublicUpdatedPos + vector3(9.0, 7.0, 0.0))
                    end
                end
            end
            if PublicUpdatedPos then
                SetBlipCoords(zoneRadius, PublicUpdatedPos + vector3(9.0, 7.0, 0.0))
            end
            if #(GetEntityCoords(vehicle) - route.finish) < 10.0 then
                DeleteEntity(ped)
                if Serveur == "FA" then
                    exports['tuto-fa']:HideStep()
                elseif Serveur == "WL" then
                    exports['tuto-wl']:HideStep()
                end
                DeleteEntity(ped2)
                InsideBracoBrinks = false
                DeleteEntity(vehicle)
                RemoveBlip(zoneRadius)
                if not vehicleG then
                    TriggerServerEvent("core:brinks:sync", p:getCrew(), nil)
                else
                    TriggerServerEvent("core:brinks:illegal:finish")
                end
                break
            end 

            if IsVehicleTyreBurst(vehicle, 0) and IsVehicleTyreBurst(vehicle, 1) then -- DEVANT
                --print("devant")
                if IsVehicleTyreBurst(vehicle, 4) and IsVehicleTyreBurst(vehicle, 5) then -- DERRIERE
                    --print("derriere")
                    BringVehicleToHalt(vehicle, 2.0, 2.0)
                    SetVehicleMaxSpeed(vehicle, 0.0)
                    SetVehicleUndriveable(vehicle, true)
                    if not averti2 then 
                        averti2 = true
                        if not vehicleG then
                            if Serveur == "FA" then
                                OpenTutoFAInfo("Braquage de brinks", "Attache les convoyeurs et scie l'arriere du brinks")
                            elseif Serveur == "WL" then
                                OpenTutoWLInfo("Braquage de brinks", "Attache les convoyeurs et scie l'arriere du brinks")
                            end
                        end
                        if randomTra then 
                            local isInSouth = coordsIsInSouth(GetEntityCoords(vehicle))
                            if isInSouth then
                                TriggerSecurEvent('core:makeCall', "lspd",
                                    GetEntityCoords(vehicle), true,
                                    "Braquage de brinks", false, "illegal")                                    
                                TriggerSecurEvent('core:makeCall', "lssd",
                                    GetEntityCoords(vehicle), true,
                                    "Braquage de brinks", false, "illegal")
                            else
                                TriggerSecurEvent('core:makeCall', "lssd",
                                    GetEntityCoords(vehicle), true,
                                    "Braquage de brinks", false, "illegal")
                                TriggerSecurEvent('core:makeCall', "lspd",
                                    GetEntityCoords(vehicle), true,
                                    "Braquage de brinks", false, "illegal") -- FIX_LSSD_LSPD 
                            end
                        end
                    end
                end
            end
            
            if not vehicleG then
                if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle)) > 50.0 and not hided then 
                    hided = true
                    if Serveur == "FA" then
                        exports['tuto-fa']:HideStep()
                    elseif Serveur == "WL" then
                        exports['tuto-wl']:HideStep()
                    end
                end
            end

            if not randomTra then 
                if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle)) < 15.0 then 
                    if not averti then 
                        averti = true
                        --exports['vNotif']:createNotification({
                        --    type = 'JAUNE',
                        --    content = "Détruisez les 4 pneux du transport Gruppe 6."
                        --})
                        if not vehicleG then
                            if Serveur == "FA" then
                                OpenTutoFAInfo("Braquage de brinks", "Creve les pneus du convoi et braque les convoyeurs (Vous devez être ".. GetVariable("heist").brinks.Players ..")")
                            elseif Serveur == "WL" then
                                OpenTutoWLInfo("Braquage de brinks", "Creve les pneus du convoi et braque les convoyeurs (Vous devez être ".. GetVariable("heist").brinks.Players ..")")
                            end
                        end
                        if not vehicleG then
                            --[[ local isInSouth = coordsIsInSouth(GetEntityCoords(vehicle))
                            if isInSouth then
                                TriggerSecurEvent('core:makeCall', "lspd", GetEntityCoords(vehicle), true, "Braquage de brinks", false, "illegal")
                                TriggerSecurEvent('core:makeCall', "lssd", GetEntityCoords(vehicle), true, "Braquage de brinks", false, "illegal") -- FIX_LSSD_LSPD
                            else
                                TriggerSecurEvent('core:makeCall', "lssd", GetEntityCoords(vehicle), true, "Braquage de brinks", false, "illegal")
                                TriggerSecurEvent('core:makeCall', "lspd", GetEntityCoords(vehicle), true, "Braquage de brinks", false, "illegal") -- FIX_LSSD_LSPD
                            end ]]
							local pos = GetEntityCoords(vehicle)

							TriggerSecurEvent('core:makeCall', "lspd", pos, true, "Braquage de brinks", false, "illegal")
							TriggerSecurEvent('core:makeCall', "lssd", pos, true, "Braquage de brinks", false, "illegal") -- FIX_LSSD_LSPD

							TriggerServerEvent('core:createDispatchCallOnMDT', "LSPD", "Braquage de brinks", pos)						
							TriggerServerEvent('core:createDispatchCallOnMDT', "LSSD", "Braquage de brinks", pos)
                        end
                    end
                end
            end
            
            if not randomTra then 
                SetBlipAlpha(zoneRadius, alphaZone)
            end
            if vehicleG then
                SetBlipAlpha(zoneRadius, alphaZone)
            end
            count = count - 1
            Wait(1)
        end
    end)
end

RegisterNetEvent("core:brinksPeds", function(pede,p2ee,vehhhhh)
    local LePedPasMoi = NetToPed(pede)
    local LePed2PasMoi, vehicle = NetToPed(p2ee), NetToVeh(vehhhhh)
    local shown = false
    while true do 
        Wait(1)
        if DoesEntityExist(vehicle) then 
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(vehicle)) < 50.0 then 
                if p:getCrew() ~= "None" then 
                    if not shown then
                        shown = true
                        OpenTutoFAInfo("Braquage de brinks", "Creve les pneus du convoi et braque les convoyeurs (Vous devez être ".. GetVariable("heist").brinks.Players ..")")
                    end
                end
            end
        end
        if LePedPasMoi and LePed2PasMoi then 
            if IsEntityPlayingAnim(LePedPasMoi, "random@mugging3", "handsup_standing_base", 3) then 
                Bulle.remove("pedBrinksLiberer")
                Bulle.create("pedBrinks", GetEntityCoords(LePedPasMoi) + vector3(0.0, 0.0, 1.0), "bulleAttacher")
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(LePedPasMoi)) < 2.0 then 
                    if IsControlJustPressed(0, 38) then 
                        Ped1ForceHands = false
                        p:PlayAnim('mp_arresting', 'a_uncuff', 1)
                        Modules.UI.RealWait(4000)
                        ClearPedTasks(p:ped())
                        ClearPedTasks(LePedPasMoi)
                        PlayEmoteOnPed(LePedPasMoi, "mp_arresting", "idle", 49, -1)
                        TaskGoToCoordAnyMeans(LePedPasMoi, GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "door_dside_r")) + vector3(0.0, 2.0, 0.0), 1.0, 0, 0, 786603, 0)
                        CreateThread(function()
                            Wait(5000)
                            PlayEmoteOnPed(LePedPasMoi, "random@arrests@busted", "idle_a", 1, -1)     
                        end)
                    end
                end
            elseif IsEntityPlayingAnim(LePedPasMoi, "mp_arresting", "idle", 3) then 
                Bulle.remove("pedBrinks")
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(LePedPasMoi)) < 1.0 then 
                    Bulle.create("pedBrinksLiberer", GetEntityCoords(LePedPasMoi) + vector3(0.0, 0.0, 1.0), "bulleLiberer", true)
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(LePedPasMoi)) < 1.0 then 
                        if IsControlJustPressed(0, 38) then 
                            Ped1ForceHands = false
                            p:PlayAnim('mp_arresting', 'a_uncuff', 1)
                            Modules.UI.RealWait(4000)
                            ClearPedTasks(p:ped())
                            ClearPedTasks(LePedPasMoi)
                            TaskSmartFleePed(LePedPasMoi, PlayerPedId(), 999.9, 60.0, true, true)
                            SetEntityAsNoLongerNeeded(LePedPasMoi)
                            Bulle.remove("pedBrinksLiberer")
                        end
                    end
                else
                    Bulle.remove("pedBrinksLiberer")
                end
            end

            if Ped1ForceHands then 
                if not IsEntityPlayingAnim(LePedPasMoi, "random@mugging3", "handsup_standing_base", 3) then 
                    RequestAnimDict("random@mugging3")
                    while not HasAnimDictLoaded("random@mugging3") do
                        Wait(0)
                    end
                    TaskPlayAnim(LePedPasMoi, "random@mugging3", "handsup_standing_base", 1.0, 1.0, -1, 49, 1.0)
                end
            end
            if Ped2ForceHands then 
                if not IsEntityPlayingAnim(LePed2PasMoi, "random@mugging3", "handsup_standing_base", 3) then 
                    RequestAnimDict("random@mugging3")
                    while not HasAnimDictLoaded("random@mugging3") do
                        Wait(0)
                    end
                    TaskPlayAnim(LePed2PasMoi, "random@mugging3", "handsup_standing_base", 1.0, 1.0, -1, 49, 1.0)
                end
            end
            
            --if vehicleG then
            --    if IsEntityPlayingAnim(LePed2PasMoi, "random@arrests@busted", "idle_a", 3) then
            --        if not sentToAll then
            --            TriggerServerEvent("brinksSendStart", VehToNet(vehicleG))
            --            sentToAll = true
            --        end
            --    end
            --end

            if IsEntityPlayingAnim(LePed2PasMoi, "random@mugging3", "handsup_standing_base", 3) then 
                Bulle.remove("pedBrinksLiberer2")
                Bulle.create("pedBrinks2", GetEntityCoords(LePed2PasMoi) + vector3(0.0, 0.0, 1.0), "bulleAttacher")
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(LePed2PasMoi)) < 2.0 then 
                    if IsControlJustPressed(0, 38) then 
                        Ped2ForceHands = false
                        p:PlayAnim('mp_arresting', 'a_uncuff', 1)
                        Modules.UI.RealWait(4000)
                        ClearPedTasks(p:ped())
                        ClearPedTasks(LePed2PasMoi)
                        PlayEmoteOnPed(LePed2PasMoi, "mp_arresting", "idle", 49, -1)
                        TaskGoToCoordAnyMeans(LePed2PasMoi, GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "door_dside_r")) + vector3(0.0, 2.0, 0.0), 1.0, 0, 0, 786603, 0)
                        CreateThread(function()
                            Wait(9000)
                            PlayEmoteOnPed(LePed2PasMoi, "random@arrests@busted", "idle_a", 1, -1)
                        end) 
                        --exports['vNotif']:createNotification({
                        --    type = 'JAUNE',
                        --    content = "Apres avoir attaché les deux convoyeurs, vous pourrez meuler le coffre."
                        --})
                    end
                end
            elseif IsEntityPlayingAnim(LePed2PasMoi, "mp_arresting", "idle", 3) then 
                Bulle.remove("pedBrinks2")
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(LePed2PasMoi)) < 1.0 then 
                    Bulle.create("pedBrinksLiberer2", GetEntityCoords(LePed2PasMoi) + vector3(0.0, 0.0, 1.0), "bulleLiberer", true)
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(LePed2PasMoi)) < 1.0 then 
                        if IsControlJustPressed(0, 38) then 
                            Ped1ForceHands = false
                            p:PlayAnim('mp_arresting', 'a_uncuff', 1)
                            Modules.UI.RealWait(4000)
                            ClearPedTasks(p:ped())
                            TaskSmartFleePed(LePed2PasMoi, PlayerPedId(), 999.9, 60.0, true, true)
                            SetEntityAsNoLongerNeeded(LePed2PasMoi)
                            ClearPedTasks(LePed2PasMoi)                        
                            Bulle.remove("pedBrinksLiberer2")
                        end
                    end
                else
                    Bulle.remove("pedBrinksLiberer2")
                end
            end
        end
    end
end)

local aimedateee = {}
local pedBrinks = {}
CreateThread(function()
    while not p do Wait(1) end
    if not DlcIllegal then return end
    while true do 
        Wait(1)
        if InsideBrinks then 
            local entity = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 30.0, GetHashKey("stockade"), 70)
            local bool = IsPlayerFreeAiming(PlayerId())
            if entity then
                if IsVehicleTyreBurst(entity, 0) and IsVehicleTyreBurst(entity, 1) then -- DEVANT
                    --print("devant")
                    if IsVehicleTyreBurst(entity, 4) and IsVehicleTyreBurst(entity, 5) then -- DERRIERE
                        if bool and GetDistanceBetweenCoords(GetEntityCoords(p:ped()), GetEntityCoords(entity)) < 20.0 then 
                            if not aimedateee[entity] then
                                aimedateee[entity] = true
                                TriggerServerEvent("core:sendInfoBrinksPed", token, VehToNet(entity))
                            end
                        end
                    end
                end
            else
                Wait(500)
            end
        else
            Wait(3000)
        end
    end 
end)

--RegisterCommand("testBrinks", function(source, args)
--    RequestModel(`stockade`)
--    while not HasModelLoaded(`stockade`) do Wait(1) end
--    local brinksVeh = CreateVehicle(`stockade`, p:pos(), 1)
--    local leftCoord = GetWorldPositionOfEntityBone(brinksVeh, GetEntityBoneIndexByName(brinksVeh, "door_dside_r"))
--    local rightCoord = GetWorldPositionOfEntityBone(brinksVeh, GetEntityBoneIndexByName(brinksVeh, "door_pside_r"))
--    local midPos = (leftCoord+rightCoord)/2
--    Bulle.create("meuler", midPos, "bulleOuvrir", false)
--end)

local brinksVeh = nil
RegisterNetEvent("brinksStartAttack", function(netBrinks, fromserver, group)
    brinksVeh = NetToVeh(netBrinks)
    local timer = 0

    if group then 
        if p:getCrew() == "None" then 
            return
        end
        if group ~= "tout le monde" then 
            if p:getCrewType() ~= group then 
                return
            end
        end
    end

    while brinksVeh ~= nil or fromserver do
        local time = 600
        local pos = p:pos()
        local leftCoord = GetWorldPositionOfEntityBone(brinksVeh, GetEntityBoneIndexByName(brinksVeh, "door_dside_r"))
        local rightCoord = GetWorldPositionOfEntityBone(brinksVeh, GetEntityBoneIndexByName(brinksVeh, "door_pside_r"))
        local midPos = (leftCoord+rightCoord)/2 + vec3(0.0, 0.0, 0.25)
        local dst = #(pos - midPos)

        if not brinksVeh then 
            timer += 1
            if timer > 3600 then 
                break
            end
        end
    
        if dst <= 5.0 then
            time = 0
        end
        if dst <= 1.5 then
            Bulle.create("meuler", midPos, "bulleOuvrir", false)

            if IsControlJustPressed(0, 38) then
                local haveMeuleuse = false
                for _, value in pairs(p:getInventaire()) do
                    if value.name == "meuleuse" then
                        haveMeuleuse = true
                        break
                    end
                end

                if not haveMeuleuse then
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        content = "Vous n'avez pas de meuleuse"
                    })
                else
                    local hasbeenmeuled = TriggerServerCallback("core:HasBeenMeuled", NetworkGetNetworkIdFromEntity(brinksVeh))
                    if hasbeenmeuled then
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            content = "Le camion à déjà été dérobé"
                        })
                    else
                        Bulle.hide("meuler")
                        TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
                        FreezeEntityPosition(brinksVeh, true)
                        local pedCo = GetEntityCoords(PlayerPedId())
                        TriggerServerEvent("core:RemoveItemToInventory", token, "meuleuse", 1, {})

                        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), 1)
                        
                        local pos = GetOffsetFromEntityInWorldCoords(brinksVeh, 0, -1.5, 0.25)
                        local trolly = CreateObject(LoadModel("hei_prop_hei_cash_trolly_01"), pos, 0, 0, 0)
                        SetEntityHeading(trolly, GetEntityHeading(brinksVeh)-180)

                        local grinder = CreateObject(LoadModel("tr_prop_tr_grinder_01a"), pedCo, 1, 1, 0)
                        local bag = CreateObject(LoadModel("ch_p_m_bag_var02_arm_s"), pedCo, 1, 1, 0)
                        local animDict = 'anim@scripted@player@mission@tunf_train_ig1_container_p1@male@'

                        SetEntityNoCollisionEntity(trolly, brinksVeh)
                        SetEntityNoCollisionEntity(bag, brinksVeh)
                        SetEntityNoCollisionEntity(grinder, brinksVeh)

                        loadAnimDict(animDict)
                        loadPtfxAsset('scr_tn_tr')

                        local pos = GetOffsetFromEntityInWorldCoords(brinksVeh, 0, -1.65, 0)
                    
                        local scene = NetworkCreateSynchronisedScene(vec3(pos.x, pos.y, GetEntityCoords(PlayerPedId()).z-1), GetEntityRotation(brinksVeh), 2, true, false, 1065353216, 0, 1065353216)

                        NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, animDict, "action", 4.0, -4.0, 1033, 0, 1000.0, 0)
                        NetworkAddEntityToSynchronisedScene(sceneObject, scene, animDict, "action_container", 1.0, -1.0, 1148846080)
                        NetworkAddEntityToSynchronisedScene(lockObject, scene, animDict, "action_lock", 1.0, -1.0, 1148846080)
                        NetworkAddEntityToSynchronisedScene(grinder, scene, animDict, "action_angle_grinder", 1.0, -1.0, 1148846080)
                        NetworkAddEntityToSynchronisedScene(bag, scene, animDict, "action_bag", 1.0, -1.0, 1148846080)

                        SetEntityCoords(PlayerPedId(), GetEntityCoords(sceneObject))
                        NetworkStartSynchronisedScene(scene)
                        Wait(4000)
                        UseParticleFxAssetNextCall('scr_tn_tr')
                        local sparks = StartParticleFxLoopedOnEntity("scr_tn_tr_angle_grinder_sparks", grinder, 0.0, 0.25, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false, 1065353216, 1065353216, 1065353216, 1)
                        Wait(1000)
                        StopParticleFxLooped(sparks, 1)
                        Wait(GetAnimDuration(animDict, 'action') * 1000 - 7500)
                        SetVehicleDoorOpen(brinksVeh, 2, false, false)
                        SetVehicleDoorOpen(brinksVeh, 3, false, false)
                        SetVehicleAlarm(brinksVeh, true)
                        SetVehicleAlarmTimeLeft(brinksVeh, 60000)          
                        Wait(2500)
                        DeleteEntity(grinder)
                        DeleteEntity(bag)

                        Bulle.create("recolteBrinks", GetEntityCoords(brinksVeh) + vector3(0.0, 0.0, 1.30), "bulleRamasser", true)
                        while true do
                            Wait(1)
                            if IsControlJustPressed(0, 38) then 
                                break
                            end
                        end
                        Bulle.remove("recolteBrinks")
                        if Serveur == "FA" then
                            exports['tuto-fa']:HideStep()
                        elseif Serveur == "WL" then
                            exports['tuto-wl']:HideStep()
                        end
                        
                        ActionInTerritoire(p:getCrew(), GetZoneByPlayer(), GetVariable("heist").brinks.influence or 400, 4, coordsIsInSouth(GetEntityCoords(PlayerPedId())))
                        
                        moneyLoot(trolly, { min = GetVariable("heist").brinks.winMin or 300, max = GetVariable("heist").brinks.winMax or 600}, GetEntityCoords(PlayerPedId()), true, true)

                        RemoveBlip(zoneRadius)
                        InsideBrinks = false
                        TriggerServerEvent("core:brinks:sync", p:getCrew(), nil)

                        collectgarbage("collect")
                        brinksVeh = nil
                    end
                end
            end
        end

        Wait(time)
    end
end)

RegisterNetEvent("brinksDoorOpen", function()
    brinksVeh = false
end)