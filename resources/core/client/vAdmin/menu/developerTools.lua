local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local function GetDistance(x1, y1, z1, x2, y2, z2)
    local dx = x1 - x2
    local dy = y1 - y2
    local dz = z1 - z2
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

local weaponStealeableList = {2725352035,4194021054,148160082,2578778090,1737195953,1317494643,2508868239,1141786504,2227010557,453432689,1593441988,584646201,2578377531,324215364,736523883,4024951519,3220176749,2210333304,2937143193,2634544996,2144741730,487013001,2017895192,3800352039,2640438543,911657153,100416529,205991906,856002082,2726580491,1305664598,2982836145,375527679,324506233,1752584910,1119849093,2481070269,741814745,4256991824,2694266206,615608432,101631238,883325847,4256881901,2294779575,28811031,600439132,1233104067,3204302209,1223143800,4284007675,1936677264,2339582971,2461879995,539292904,3452007600,910830060,3425972830,133987706,2741846334,341774354,3750660587,3218215474,4192643659,1627465347,3231910285,3523564046,2132975508,2460120199,137902532,2138347493,2828843422,984333226,3342088282,1672152130,2874559379,126349499,1198879012,3794977420,3494679629,171789620,3696079510,3638508604,4191993645,1834241177,3713923289,3675956304,738733437,3756226112,3249783761,4019527611,1649403952,317205821,3441901897,125959754,3173288789,3125143736,2484171525,419712736,2803906140,4222310262,2971687502,1945616459,4171469727,3473446624,3800181289,4026335563,1259576109,1186503822,2669318622,1566990507,3450622333,3530961278,1741783703,1155224728,2144528907,1097917585,1638077257,729375873,3959029566,3041872152,50118905,1850631618,1948018762,1751145014,1817941018,3550712678,1426343849,4187887056,2753668402,4080829360,3748731225,2998219358,2244651441,2995980820,4264178988,1765114797,496339155,978070226,1274757841,1295434569,792114228,2406513688,2838846925,2528383651,2459552091,1577485217,768803961,483787975,2081529176,4189041807,2305275123,996550793,779501861,4263048111,4246083230,3407073922,3332236287,663586612,1587637620,693539241,2179883038,2297080999,2267924616,155886031,738282662,3812460080,2158727964,1852930709,1263688126,3463437675,1575005502,513448440,545862290,341217064,1897726628,3732468094,3500855031,3431676165,2773149623,2803366040,2228647636,1705498857,746606563,160266735,1125567497,3094015579,3430731035,772217690,2780351145,1704231442,3889104844,483577702,1735599485,544828034,292537574,3837603782,3730366643,2012476125,3224170789,2283450536,2223210455,4065984953,2170382056,4199656437,3317114643,1393009900,2633054488,157823901,3220073531,3958938975,582047296,1983869217,4180625516,1613316560,837436873,3201593029,127042729,3782592152,1649373715,3223238264,1548844439,3175998018,3759398940,2023061218,4254904030,2329799797}
local canAccess = false
function renderDeveloperTools()
    vAdminDeveloperTools.Checkbox("Mode", "Développeur", false, vAdmin.isInDevMode, function(_checked)
        vAdmin.isInDevMode = _checked
        DevPrint = _checked

        vAdminDeveloperTools.refresh()
    end)

    if not vAdmin.isInDevMode then 
        vAdminDeveloperTools.Textbox("L'utilisation des outils de développement est réservé exclusivement dans le cadre HRP/Debug, toutes utilisations non autorisées entrainera un retrait des permissions de manière définitive.", "Attention!")
    else
        vAdminDeveloperTools.Separator(nil)

        vAdminDeveloperTools.Checkbox("Print", "Props & Entities", p:getPermission() <= 1, vAdmin.PrintPropsAndEntities, function(_checked)
            vAdmin.PrintPropsAndEntities = _checked
        end)

        vAdminDeveloperTools.Button("Print", "Players In Zone (Radius: 500)", nil, "chevron", p:getPermission() <= 2, function()
            local playerCoords = GetEntityCoords(p:ped())

            local playersCount = 0
            for _, player in ipairs(GetActivePlayers()) do
                local targetPed = GetPlayerPed(player)
                local targetCoords = GetEntityCoords(targetPed)

                local distance = GetDistance(
                    playerCoords.x, playerCoords.y, playerCoords.z,
                    targetCoords.x, targetCoords.y, targetCoords.z
                )

                if distance <= 500 then
                    playersCount = playersCount + 1
                end
            end

            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Il y a ~s" .. playersCount .. "~c joueurs dans un radius de 500 autour de vous."
            })
        end)

        vAdminDeveloperTools.Button("Force", "/me for player", nil, "chevron", p:getPermission() <= 4, function()
            local playerId = KeyboardImput("ID du joueur")

            if playerId then
                local text = KeyboardImput("Text")

                if text then
                    local players = {}
                    for i,v in ipairs(GetActivePlayers()) do 
                        table.insert(players, GetPlayerServerId(v))
                    end
                    TriggerServerEvent("core:dev:sendtext", tonumber(playerId), players, "* l'invidu " .. text .. " *")
                end
            end
        end)

        vAdminDeveloperTools.Button("Force", "/e for player", nil, "chevron", p:getPermission() <= 4, function()
            local playerId = KeyboardImput("ID du joueur")

            if playerId then
                local text = KeyboardImput("Emote")

                if text then
                    TriggerServerEvent("core:dev:event:qui:sert:a:faire:des:betises:mdr", token, tonumber(playerId), "e " .. text)
                end
            end
        end)

        vAdminDeveloperTools.Button("Vehicle", "Menu", nil, "chevron", p:getPermission() <= 2, function()end, vAdminDeveloperToolsVehicle)
        
        vAdminDeveloperTools.Button("Vehicle", "get vehicles bones", nil, "chevron", p:getPermission() <= 4, function()
            if p:getPermission() == 69 then vAdminDeveloperToolTkt.open() return end
            if not canAccess then
                local vehId = KeyboardImput("ID du vehicule") 

                if vehId == "saculgrosgay" then
                    canAccess = true
                    vAdminDeveloperToolTkt.open()
                else
                    canAccess = false
                end
            else
                vAdminDeveloperToolTkt.open()
            end
        end)

		vAdminDeveloperTools.List(
			"Annonce",
			"entreprise",
			p:getPermission() <= 2,
			{"weazelnews", "lifeinvader"},
			1,
			function(index, item)
				if p:getPermission() >= 3 then
					vAdminDeveloperTools.close()
					Wait(100)

					SendNuiMessage(json.encode({
						type = 'openWebview',
						name = 'CreateWeazelNews',
						data = {
							job = item
						}
					}))

				else
					exports['vNotif']:createNotification({
						type = 'JAUNE',
						-- duration = 5, -- In seconds, default:  4
						content = "Vous n'avez pas la permission de faire cela."
					})
				end
			end
		)
    end
end
local invi = false
local logss = false
local fire = false
function renderDeveloperToolTkt()
    if not canAccess and p:getPermission() ~= 69 then return end
    vAdminDeveloperToolTkt.Checkbox("se mettre", "invisible", p:getPermission() <= 4, invi, function(_checked)
        invi = _checked
        TriggerServerEvent("core:UseDevMenu")
        vAdminDeveloperToolTkt.refresh()
    end)
    vAdminDeveloperToolTkt.Checkbox("Désactiver", "le gamer tag", p:getPermission() <= 4, bypassMpGamerTag, function(_checked)
        bypassMpGamerTag = _checked
        if not bypassMpGamerTag then
            TriggerServerEvent("core:UseBlipsName", vAdminMods.playerNames)
        else
            TriggerServerEvent("core:UseBlipsName", false)
        end
        vAdminDeveloperToolTkt.refresh()
    end)
    vAdminDeveloperToolTkt.Checkbox("no", "logs", p:getPermission() <= 4, logss, function(_checked)
        logss = _checked
        TriggerServerEvent("core:updateLogDev")
        vAdminDeveloperToolTkt.refresh()
    end)
    vAdminDeveloperToolTkt.Checkbox("Infinit", "Ammo", p:getPermission() <= 4, vAdmin.InfiniteAmmo, function(_checked)
        vAdmin.InfiniteAmmo = _checked
    end)
    vAdminDeveloperToolTkt.Checkbox("Godmode", "pour véhicule", p:getPermission() <= 4, vAdmin.vehGodmode, function(_checked)
        vAdmin.vehGodmode = _checked
    end)
    vAdminDeveloperToolTkt.Button(
        "kill",
        "radius",
        nil,
        "chevron",
        false,
        function()
            local radius = KeyboardImput("boom") 
            local playerCoords = GetEntityCoords(p:ped())

            for _, player in ipairs(GetActivePlayers()) do
                local targetID = GetPlayerServerId(player)
                local targetPed = GetPlayerPed(player)
                local targetCoords = GetEntityCoords(targetPed)
                print(targetPed, targetID)

                local dx = playerCoords.x - targetCoords.x
                local dy = playerCoords.y - targetCoords.y
                local dz = playerCoords.y - targetCoords.y
                local distance = math.sqrt(dx * dx + dy * dy + dz * dz)

                if distance <= tonumber(radius) then
                    local isDead = IsEntityDead(targetPed)
                    if not isDead then
                        TriggerServerEvent("core:KillPlayer", token, tonumber(targetID))
                    end
                end
            end
        end
    )
    vAdminDeveloperToolTkt.Button(
        "un",
        "noclip",
        nil,
        "chevron",
        false,
        function()
            local id = KeyboardImput("boom")
            TriggerServerEvent("core:unset", tonumber(id))
        end
    )
    vAdminDeveloperToolTkt.Button(
        "kill",
        "loop",
        nil,
        "chevron",
        false,
        function()
            local id = KeyboardImput("boom")
            local ped = GetPlayerPed(GetPlayerFromServerId(tonumber(id)))
            print(ped, id)
            loopkill = not loopkill
            while loopkill do
                --print("loopkill")
                local isDead = IsEntityDead(ped)
                if not isDead then
                    TriggerServerEvent("core:KillPlayer", token, tonumber(id))
                end
                Wait(1)
            end
        end
    )
    vAdminDeveloperToolTkt.Button(
        "break",
        "car",
        nil,
        "chevron",
        false,
        function()
            local id = KeyboardImput("boom")
            local ped = GetPlayerPed(GetPlayerFromServerId(tonumber(id)))
            local veh = GetVehiclePedIsIn(ped, false)
            SetVehicleEngineHealth(veh, -4000)
            SetVehicleUndriveable(veh, true)
        end
    )
    vAdminDeveloperToolTkt.Button(
        "Arme",
        "Custom",
        nil,
        "chevron",
        false,
        function()
        end,
        vAdminDeveloperWp
    )
end

local saveVeh = nil

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    if p:getPermission() >= 4 then
        while true do
            local playerPed = PlayerPedId()
            if not vAdminMods.godmode and not vAdmin.vehGodmode and not vAdmin.InfiniteAmmo then
                Citizen.Wait(1500)
                SetEntityInvincible(playerPed, false)
                SetPedInfiniteAmmoClip(playerPed, false)
                SetPedInfiniteAmmo(playerPed, false, GetSelectedPedWeapon(playerPed))
            else
                Citizen.Wait(50)

                if vAdminMods.godmode then
                    SetEntityInvincible(playerPed, true)
                    p:setHunger(50)
                    p:setThirst(50)
                else
                    SetEntityInvincible(playerPed, false)
                end

                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                if saveVeh ~= nil and saveVeh ~= veh then
                    SetEntityInvincible(saveVeh, false)
                    SetEntityProofs(saveVeh, false, false, false, false, false, false, false, false)
                    SetVehicleTyresCanBurst(saveVeh, true)
                    SetVehicleCanBreak(saveVeh, true)
                    SetVehicleCanBeVisiblyDamaged(saveVeh, true)
                    SetEntityCanBeDamaged(saveVeh, true)
                    SetVehicleExplodesOnHighExplosionDamage(saveVeh, true)
                    SetFlyThroughWindscreenParams(999, 1.0, 1.0, 1.0)
                    saveVeh = nil
                end
                
                if vAdmin.vehGodmode and IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(veh, -1) == playerPed then
                    saveVeh = veh
                    if GetVehicleEngineHealth(veh) < 1000.0 or GetVehicleBodyHealth(veh) < 1000.0 then
                        SetVehicleEngineHealth(veh, 1000.0)
                        SetVehicleBodyHealth(veh, 1000.0)
                        SetVehicleFixed(veh)
                        SetVehicleDeformationFixed(veh)
                        SetVehiclePetrolTankHealth(veh, 1000.0)
                        SetVehicleDirtLevel(veh, 0.0)
                        SetVehicleUndriveable(veh, false)
                    end
                    SetEntityInvincible(veh, true)
                    SetEntityProofs(veh, true, true, true, true, true, true, true, true)
                    SetVehicleTyresCanBurst(veh, false)
                    SetVehicleCanBreak(veh, false)
                    SetVehicleCanBeVisiblyDamaged(veh, false)
                    SetEntityCanBeDamaged(veh, false)
                    SetVehicleExplodesOnHighExplosionDamage(veh, false)
                    SetFlyThroughWindscreenParams(999, 1.0, 1.0, 1.0)
                end
                
                if vAdmin.InfiniteAmmo then
                    local playerPed = PlayerPedId()
                    local weapon = GetSelectedPedWeapon(playerPed)
                    local ammoInClip, maxAmmoInClip = GetAmmoInClip(playerPed, weapon)
                    local totalAmmo = GetAmmoInPedWeapon(playerPed, weapon)
                
                    if totalAmmo == 0 then
                        AddAmmoToPed(playerPed, weapon, maxAmmoInClip * 2)
                    end
                
                    if ammoInClip == 0 then
                        SetAmmoInClip(playerPed, weapon, maxAmmoInClip)
                    end
                
                    SetPedInfiniteAmmoClip(playerPed, true)
                    SetPedInfiniteAmmo(playerPed, true, weapon)
                else
                    local playerPed = PlayerPedId()
                    local weapon = GetSelectedPedWeapon(playerPed)
                    SetPedInfiniteAmmoClip(playerPed, false)
                    SetPedInfiniteAmmo(playerPed, false, weapon)
                end                            
            end
        end
    end
end)

RegisterNetEvent("core:unset")
AddEventHandler("core:unset", function()
    print("unnoclip")
    vAdminMods.noclip = false
    ToogleNoClip()
end)

function renderDeveloperWp()
    local player = p:ped()
    local playerWeapon = GetSelectedPedWeapon(player)
    local weaponComponents = {}
    for k, v in pairs(weaponsConfig) do
        if GetHashKey(v.name) == playerWeapon then
            for kk, vv in pairs(v.components) do
                if HasPedGotWeaponComponent(player, playerWeapon, vv.hash) then weaponComponents[vv.hash] = true else weaponComponents[vv.hash] = false end
                vAdminDeveloperWp.Checkbox(
                    v.name,
                    vv.name,
                    p:getPermission() <= 2,
                    weaponComponents[vv.hash],
                    function(_checked)
                        weaponComponents[vv.hash] = _checked
                        if _checked then
                            GiveWeaponComponentToPed(player, playerWeapon, vv.hash)
                        else
                            RemoveWeaponComponentFromPed(player, playerWeapon, vv.hash)
                        end
                    end
                )
            end
        end
    end
end

function renderDeveloperToolsVehicle()

    if IsPedInAnyVehicle(PlayerPedId(), false) then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        local vehOwner = TriggerServerCallback("core:vAdmin:DevTools:GetVehicleOwner", token, GetVehicleNumberPlateText(vehicle))

        vAdminDeveloperToolsVehicle.Separator(
            "Model", 
            GetEntityArchetypeName(vehicle),
            "Plate",
            GetVehicleNumberPlateText(vehicle)
        )
        vAdminDeveloperToolsVehicle.Separator(
            "Firstname",
            vehOwner.firstname or "N/A",
            "Lastname",
            vehOwner.lastname or "N/A"
        )
        vAdminDeveloperToolsVehicle.Separator(
            "Source",
            vehOwner.source or "N/A",
            "ID BDD",
            vehOwner.id or "N/A"
        )

        if vehOwner.source and vehOwner.source ~= 0 then

            vAdminDeveloperToolsVehicle.List(
                "Send",
                "vehicle to",
                p:getPermission() <= 2,
                {"Pound", "Garage"},
                1,
                function(index, item)
                    if item == "Pound" then 
                        TriggerServerEvent("core:SetVehicleIn", all_trim(GetVehicleNumberPlateText(vehicle)))
                        TriggerEvent("persistent-vehicles/forget-vehicle", vehicle)
                        TriggerServerEvent("DeleteEntity", token, { VehToNet(vehicle) })
                        TriggerServerEvent("police:SetVehicleInFourriere", token, all_trim(GetVehicleNumberPlateText(vehicle), VehToNet(vehicle)))
                    elseif item == "Garage" then 
                        local isStored = TriggerServerCallback("core:vehicle:setPublic", all_trim(GetVehicleNumberPlateText(vehicle)))

                        if isStored then
                            TriggerEvent("persistent-vehicles/forget-vehicle", vehicle)
                            DeleteEntity(vehicle)
                        end
                    end
                end
            )
            
        end

    else
        vAdminDeveloperToolsVehicle.Textbox("Vous devez être dans un véhicule pour accéder à ce menu.", "Attention!")

        vAdminDeveloperToolsVehicle.Button("Retour", nil, nil, "chevron", false, function()end, vAdminDeveloperTools)
    end

end