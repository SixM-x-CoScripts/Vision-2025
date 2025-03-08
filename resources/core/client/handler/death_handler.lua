Death = {}
Death.GetAllDamagePed = {}
Death.GetBonesType = {
    ["Dos"] = { 0, 23553, 56604, 57597 },
    ["Crâne"] = { 1356, 11174, 12844, 17188, 17719, 19336, 20178, 20279, 20623, 21550, 25260, 27474, 29868, 31086,
        35731, 43536, 45750, 46240, 47419, 47495, 49979, 58331, 61839, 39317 },
    ["Coude droit"] = { 2992 },
    ["Coude gauche"] = { 22711 },
    ["Main gauche"] = { 4089, 4090, 4137, 4138, 4153, 4154, 4169, 4170, 4185, 4186, 18905, 26610, 26611, 26612, 26613,
        26614, 60309 },
    ["Main droite"] = { 6286, 28422, 57005, 58866, 58867, 58868, 58869, 58870, 64016, 64017, 64064, 64065, 64080, 64081,
        64096, 64097, 64112, 64113 },
    ["Bras gauche"] = { 5232, 45509, 61007, 61163 },
    ["Bras droit"] = { 28252, 40269, 43810 },
    ["Jambe droite"] = { 6442, 16335, 51826, 36864 },
    ["Jambe gauche"] = { 23639, 46078, 58271, 63931 },
    ["Pied droit"] = { 20781, 24806, 35502, 52301 },
    ["Pied gauche"] = { 2108, 14201, 57717, 65245 },
    ["Poîtrine"] = { 10706, 64729, 24816, 24817, 24818 },
    ["Ventre"] = { 11816 }
}

Death.deatCause = {
    [GetHashKey('WEAPON_UNARMED')] = { 'Tabassé', 'Sans armes' },
    [GetHashKey('WEAPON_CROWBAR')] = { 'Tabassé', 'Crowbar' },
    [GetHashKey('WEAPON_BAT')] = { 'Tabassé', 'Bat' },
    [GetHashKey('WEAPON_GOLFCLUB')] = { 'Tabassé', 'Golfclub' },
    [GetHashKey('WEAPON_HAMMER')] = { 'Tabassé', 'Hammer' },
    [GetHashKey('WEAPON_NIGHTSTICK')] = { 'Tabassé', 'Nightstick' },

    [GetHashKey('WEAPON_MOLOTOV')] = { 'Brulé', 'Molotov' },
    [GetHashKey('WEAPON_FLAREGUN')] = { 'Brulé', 'Flaregun' },

    [GetHashKey('WEAPON_DAGGER')] = { 'Stabbed', 'Dagger' },
    [GetHashKey('WEAPON_KNIFE')] = { 'Stabbed', 'Knife' },
    [GetHashKey('WEAPON_SWITCHBLADE')] = { 'Stabbed', 'Switchblade' },
    [GetHashKey('WEAPON_HATCHET')] = { 'Stabbed', 'Hatchet' },
    [GetHashKey('WEAPON_BOTTLE')] = { 'Stabbed', 'Bottle' },

    [GetHashKey('WEAPON_SNSPISTOL')] = { 'Pistolled', 'SNS Pistol' },
    [GetHashKey('WEAPON_HEAVYPISTOL')] = { 'Pistolled', 'Heavy Pistol' },
    [GetHashKey('WEAPON_VINTAGEPISTOL')] = { 'Pistolled', 'Vintage Pistol' },
    [GetHashKey('WEAPON_PISTOL')] = { 'Pistolled', 'Postol' },
    [GetHashKey('WEAPON_APPISTOL')] = { 'Pistolled', 'AP Pistol' },
    [GetHashKey('WEAPON_COMBATPISTOL')] = { 'Pistolled', 'Combat Pistol' },

    [GetHashKey('WEAPON_MICROSMG')] = { 'Riddled', 'Micro SMG' },
    [GetHashKey('WEAPON_SMG')] = { 'Riddled', 'SMG' },

    [GetHashKey('WEAPON_CARBINERIFLE')] = { 'Rifled', 'Carbine Rifle' },
    [GetHashKey('WEAPON_HEAVYRIFLE')] = { 'Rifled', 'Heavy Rifle' },
    [GetHashKey('WEAPON_TACTICALRIFLE')] = { 'Rifled', 'Tactical Rifle' },
    [GetHashKey('WEAPON_MILITARYRIFLE')] = { 'Rifled', 'Military Rifle' },
    [GetHashKey('WEAPON_MUSKET')] = { 'Rifled', 'Musket' },
    [GetHashKey('WEAPON_ADVANCEDRIFLE')] = { 'Rifled', 'Advanced Rifle' },
    [GetHashKey('WEAPON_ASSAULTRIFLE')] = { 'Rifled', 'Assult Rifle' },
    [GetHashKey('WEAPON_SPECIALCARBINE')] = { 'Rifled', 'Special Carbine' },
    [GetHashKey('WEAPON_COMPACTRIFLE')] = { 'Rifled', 'Compact Rifle' },
    [GetHashKey('WEAPON_BULLPUPRIFLE')] = { 'Rifled', 'Bullpup Rifle' },

    [GetHashKey('WEAPON_MG')] = { 'Machine Gunned', 'MG' },
    [GetHashKey('WEAPON_COMBATMG')] = { 'Machine Gunned', 'Combat MG' },

    [GetHashKey('WEAPON_BULLPUPSHOTGUN')] = { 'Pulverized', 'Bullpup Shotgun' },
    [GetHashKey('WEAPON_ASSAULTSHOTGUN')] = { 'Pulverized', 'Assult Shotgun' },
    [GetHashKey('WEAPON_DBSHOTGUN')] = { 'Pulverized', 'Double Barrel Shotgun' },
    [GetHashKey('WEAPON_PUMPSHOTGUN')] = { 'Pulverized', 'Pump Shotgun' },
    [GetHashKey('WEAPON_HEAVYSHOTGUN')] = { 'Pulverized', 'Heavy Shotgun' },
    [GetHashKey('WEAPON_SAWNOFFSHOTGUN')] = { 'Pulverized', 'Sawnoff Shotgun' },

    [GetHashKey('WEAPON_MARKSMANRIFLE')] = { 'Sniped', 'Marksman Rifle' },
    [GetHashKey('WEAPON_SNIPERRIFLE')] = { 'Sniped', 'Sniper Rifle' },
    [GetHashKey('WEAPON_HEAVYSNIPER')] = { 'Sniped', 'Heavy Sniper' },
    [GetHashKey('WEAPON_ASSAULTSNIPER')] = { 'Sniped', 'Assult Sniper' },
    [GetHashKey('WEAPON_REMOTESNIPER')] = { 'Sniped', 'Remote Sniper' },

    [GetHashKey('WEAPON_GRENADELAUNCHER')] = { 'Obliterated', 'Grenate Launcher' },
    [GetHashKey('WEAPON_RPG')] = { 'Obliterated', 'RPG' },
    [GetHashKey('WEAPON_MINIGUN')] = { 'Obliterated', 'Minigun' },
    [GetHashKey('WEAPON_HOMINGLAUNCHER')] = { 'Obliterated', 'Homming Launcher' },
    [GetHashKey('WEAPON_FIREWORK')] = { 'Obliterated', 'Firework Launcher' },
    [GetHashKey('VEHICLE_WEAPON_TANK')] = { 'Obliterated', 'Tank Shell' },

    [GetHashKey('WEAPON_MINIGUN')] = { 'Shredded', 'Minigun' },

    [GetHashKey('WEAPON_GRENADE')] = { 'Bombed', 'Grenade' },
    [GetHashKey('WEAPON_PROXMINE')] = { 'Bombed', 'Proximity Mine' },
    [GetHashKey('WEAPON_EXPLOSION')] = { 'Bombed', 'Explosion' },
    [GetHashKey('WEAPON_STICKYBOMB')] = { 'Bombed', 'Sticky Bomb' },
    [GetHashKey('WEAPON_PIPEBOMB')] = { 'Bombed', 'Pipe Bomb' },

    [GetHashKey('VEHICLE_WEAPON_ROTORS')] = { 'Découpé', 'Helicopter Rotors' },

    [GetHashKey('WEAPON_RUN_OVER_BY_CAR')] = { 'Carkill', 'Vehicle' },
    [GetHashKey('WEAPON_RAMMED_BY_CAR')] = { 'Carkill', 'Vehicle' },

    --[-842959696] = {'Ecrasé', 'Tombé du ciel'}
}

Death.GetDeathType = { "Non-Identifiée", "Dégâts de mêlée", "Blessure par balle", "Chute", "Dégâts explosifs",
    "Feu", "Chute", "Éléctrique", "Écorchure", "Gaz", "Gaz", "Eau" }

Death.GetValueWithTable = function(value, table, number)
    if not value or not table or type(value) ~= "table" then
        return
    end
    for k, v in pairs(value) do
        if number and v[number] == table or v == table then
            return true, k
        end
    end
end

local meleeWeapon = {
    GetHashKey("weapon_flashlight"),
    GetHashKey("weapon_bat"),
    GetHashKey("weapon_bottle"),
    GetHashKey("weapon_crowbar"),
    GetHashKey("weapon_golfclub"),
    GetHashKey("weapon_hatchet"),
    GetHashKey("weapon_knuckle"),
    GetHashKey("weapon_machete"),
    GetHashKey("weapon_nightstick"),
    GetHashKey("weapon_wrench"),
    GetHashKey("weapon_knife"),
    GetHashKey("weapon_switchblade"),
    GetHashKey("weapon_battleaxe"),
    GetHashKey("weapon_poolcue"),
    GetHashKey("weapon_molotov"),
    GetHashKey("weapon_snowball"),
    GetHashKey("weapon_ball"),
    GetHashKey("weapon_petrolcan"),
    GetHashKey("weapon_fireextinguisher"),
    GetHashKey("gadget_parachute"),
    GetHashKey("weapon_dagger"),
    GetHashKey("weapon_canette"),
    GetHashKey("weapon_bouteille"),
    GetHashKey("weapon_pelle"),
    GetHashKey("weapon_pickaxe"),
    GetHashKey("weapon_sledgehammer"),
    GetHashKey("weapon_katana"),
    GetHashKey("weapon_nailgun"),
    GetHashKey("weapon_beambag"),
}

local function CEventNetworkEntityDamage(victim, victimDied)
    if not IsPedAPlayer(victim) then return end
    local player = PlayerId()
    local killer, killerWeapon = NetworkGetEntityKillerOfPlayer(player)
    local playerPed = PlayerPedId()
    if victimDied and NetworkGetPlayerIndexFromPed(victim) == player and (IsPedDeadOrDying(victim, true) or IsPedFatallyInjured(victim)) then
        local killerEntity = GetPedSourceOfDeath(playerPed)
        local killerServerId = NetworkGetPlayerIndexFromPed(killerEntity)
        local DeathCause = Death.deatCause[GetPedCauseOfDeath(playerPed)]
        if killerEntity ~= playerPed and killerServerId > 0 then
            PlayerKilledByPlayer(GetPlayerServerId(killerServerId), killerServerId, killerWeapon)
        else
            if DeathCause and DeathCause[1] then
                print("DeathCause and DeathCause[1]")
                local kPed = GetPedSourceOfDeath(playerPed)
                local kPlayer = NetworkGetPlayerIndexFromPed(kPed)
                print(kPed, kPlayer, GetPlayerServerId(kPlayer))
                PlayerKilledByPlayer(GetPlayerServerId(kPlayer), kPlayer, DeathCause[2])
            else
                PlayerKilled()
            end
        end
    end
end

local checked = false
CreateThread(function()
    while true do
        Wait(500)
        if IsEntityDead(PlayerPedId()) then
            if not checked then
                checked = true
                --print("check")
                local player = PlayerId()
                local killer, killerWeapon = NetworkGetEntityKillerOfPlayer(player)
                local playerPed = PlayerPedId()
                local killerEntity = GetPedSourceOfDeath(playerPed)
                local killerServerId = NetworkGetPlayerIndexFromPed(killerEntity)
                local DeathCause = Death.deatCause[GetPedCauseOfDeath(playerPed)]
                --print("DeathCause", killerEntity, playerPed, killerServerId)
                if killerEntity ~= playerPed and killerServerId > 0 then
                    --print("send 1")
                    PlayerKilledByPlayer(GetPlayerServerId(killerServerId), killerServerId, killerWeapon)
                else
                    --print("else", DeathCause, DeathCause and DeathCause[1] or nil)
                    if DeathCause and DeathCause[1] then
                        --print("DeathCause and DeathCause[1]")
                        local kPed = GetPedSourceOfDeath(playerPed)
                        if IsEntityAVehicle(kPed) then
                            --print("CEST UN VEHICULE")
                            if IsEntityAPed(GetPedInVehicleSeat(kPed, -1)) and IsPedAPlayer(GetPedInVehicleSeat(kPed, -1)) then
                                --print("YA UN JOUEUR")
                                killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(kPed, -1))
                                -- print("eeeee", killer, GetPlayerServerId(killer), DeathCause[2])
                                PlayerKilledByPlayer(GetPlayerServerId(killer), killer, DeathCause[2])
                            end
                        else
                            local kPlayer = NetworkGetPlayerIndexFromPed(kPed)
                            --print("ddddd", kPed, kPlayer, GetPlayerServerId(kPlayer))
                            PlayerKilledByPlayer(GetPlayerServerId(kPlayer), kPlayer, DeathCause[2])
                        end
                    else
                        PlayerKilled()
                    end
                end
            end
        else
            checked = false
        end
    end
end)

AddEventHandler('gameEventTriggered', function(event, data)
    if event ~= 'CEventNetworkEntityDamage' then return end
    --print("CEventNetworkEntityDamage")
    --CEventNetworkEntityDamage(data[1], data[4])
end)

function PlayerKilledByPlayer(killerServerId, killerClientId, killerWeapon)
    local knockout = false
    local victimCoords = GetEntityCoords(PlayerPedId())
    local killerCoords = GetEntityCoords(GetPlayerPed(killerClientId))
    local distance = GetDistanceBetweenCoords(victimCoords, killerCoords, true)

    local data = {
        victimCoords = {
            x = math.round(victimCoords.x, 1),
            y = math.round(victimCoords.y, 1),
            z = math.round(victimCoords.z, 1)
        },
        killerCoords = {
            x = math.round(killerCoords.x, 1),
            y = math.round(killerCoords.y, 1),
            z = math.round(killerCoords.z, 1)
        },
        causeDeath = table.pack(p:GetAllCauseOfDeath()),
        killedByPlayer = true,
        deathCause = GetEntityModel(killerWeapon),
        distance = math.round(distance, 1),

        killerServerId = killerServerId,
        killerClientId = killerClientId
    }
    for k, v in pairs(meleeWeapon) do
        if killerWeapon == v and p:getPermission() <= 4 then
            knockout = true
            break
        end
    end
    print("killerServerId", killerServerId)
    if killerServerId then 
        EventHalloweenDiedByPlayer(killerServerId)
    end
    if not knockout then
        TriggerEvent('core:onPlayerDeath', data)
        TriggerServerEvent('core:onPlayerDeath', data)
    else
        SetPedCanRagdoll(PlayerPedId(), true)
        p:setHealth(20)
        SetPlayerInvincible(p:ped(), true)
        SetPedToRagdoll(p:ped(), 1000, 1000, 0, 0, 0, 0)
        -- ShowNotification("~r~Vous êtes KO")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Vous êtes KO"
        })

        Modules.UI.RealWait(15 * 1000)
        SetPedCanRagdoll(PlayerPedId(), false)
        SetPlayerInvincible(p:ped(), false)
    end
end

function PlayerKilled()
    while not p do Wait(100) end
    local playerPed = p:ped()
    local victimCoords = p:pos()

    local data = {
        victimCoords = {
            x = math.round(victimCoords.x, 1),
            y = math.round(victimCoords.y, 1),
            z = math.round(victimCoords.z, 1)
        },

        killedByPlayer = false,
        deathCause = GetPedCauseOfDeath(playerPed)
    }

    TriggerEvent('core:onPlayerDeath', data)
    TriggerServerEvent('core:onPlayerDeath', data)
end

AddEventHandler('baseevents:onPlayerKilled', function(event, data)
    if event ~= 'CEventNetworkEntityDamage' then return end
    --print("CEventNetworkEntityDamage")
    CEventNetworkEntityDamage(data[1], data[4])
end)
