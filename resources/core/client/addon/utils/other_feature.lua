PlayerUtils = {}
local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)
PlayerUtils.handsup = false
PlayerUtils.radgoll = false
PlayerUtils.pointing = false
PlayerUtils.forceEquipWeapon = false

Keys.Register("X", "X", "Lever les mains", function()
    if not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 3) then
        if (DoesEntityExist(p:ped())) and not (IsEntityDead(p:ped())) and (IsPedOnFoot(p:ped())) then
            PlayerUtils.handsup = not PlayerUtils.handsup
            if PlayerUtils.handsup then
                local dict = "random@mugging3"
                RequestAnimDict(dict)
                while not HasAnimDictLoaded(dict) do
                    Wait(0)
                end
                p:PlayAnim(dict, "handsup_standing_base", 49)
                RemoveAnimDict("random@mugging3")
            else
                ClearPedSecondaryTask(p:ped())
            end
        end
    end
end)

Keys.Register("J", "J", "Tomber par terre", function()
    if (DoesEntityExist(p:ped())) and not (IsEntityDead(p:ped())) and (IsPedOnFoot(p:ped())) then
        if not IsPedFalling(p:ped()) then
            PlayerUtils.radgoll = not PlayerUtils.radgoll
            if PlayerUtils.radgoll then
                Ragdoll()
            end
        end
    end
end)

function Ragdoll()
    SetPedCanRagdoll(PlayerPedId(), true)
    while PlayerUtils.radgoll do
        SetPedRagdollForceFall(p:ped())
        ResetPedRagdollTimer(p:ped())
        SetPedToRagdoll(p:ped(), 1000, 1000, 3, 0, 0, 0)
        ResetPedRagdollTimer(p:ped())
        ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ ou ~INPUT_JUMP~ pour ~b~vous relever~s~.")
        if PlayerUtils.radgoll and IsControlJustReleased(1, 22) or PlayerUtils.radgoll and IsControlJustReleased(1, 51) then
            PlayerUtils.radgoll = false
            break
        end
        Wait(0)
    end
    --SetPedCanRagdoll(PlayerPedId(), false)
end

local demarche = false
-- fermer les vehicules pnj TODO: opti le code
CreateThread(function()
    while p == nil do
        Wait(1)
    end
    while true do
        Wait(500)
        CreateThread(function()
            if IsPedBeingStunned(p:ped(), true) and not demarche then
                demarche = true
                WalkMenuStart("move_m@drunk@slightlydrunk")
                Modules.UI.RealWait(20000)
                demarche = false
                ResetPedMovementClipset(p:ped(), 0)
            end
        end)

        if DoesEntityExist(GetVehiclePedIsTryingToEnter(p:ped())) then
            local veh = GetVehiclePedIsTryingToEnter(p:ped())
            local lock = GetVehicleDoorLockStatus(veh)
            local model = GetEntityModel(veh)
            if lock ~= 0 and model ~= GetHashKey("bumpercar") and model ~= GetHashKey("bmx")
                and model ~= GetHashKey("cruiser") and model ~= GetHashKey("fixter") and
                model ~= GetHashKey("scorcher") and model ~= GetHashKey("tribike") and
                model ~= GetHashKey("tribike") and model ~= GetHashKey("tribike2") and
                model ~= GetHashKey("tribike3") then
                SetVehicleDoorsLocked(veh, 2)
            elseif model == GetHashKey("bumpercar") then
                SetVehicleDoorsLocked(veh, 0)
            end
            local vPed = GetPedInVehicleSeat(veh, -1)
            if vPed then
                SetPedCanBeDraggedOut(vPed, false)
            end
        end
    end
end)

local mp_pointing = false
local keyPressed = false

local function startPointing()
    local ped = PlayerPedId()
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
    local ped = PlayerPedId()
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

-- TODO: modif le code
local sendNotif = false
local hasWeapon = false
CreateThread(function()
    while p == nil do Wait(1) end
    LoadAnimDict("reaction@intimidation@1h")
    LoadAnimDict("weapons@pistol_1h@gang")
    LoadAnimDict("rcmjosh4")
    LoadAnimDict("reaction@intimidation@cop@unarmed")
    while true do
        local _, hash = GetCurrentPedWeapon(p:ped())
        hasWeapon = false
        if hash ~= GetHashKey("WEAPON_UNARMED") then
            hasWeapon = true
            local contains = false
            for k, v in pairs(throwableWeapons) do
                if GetHashKey(v) == hash then
                    contains = true
                end
            end
            if contains then
                if not IsPedWeaponReadyToShoot(p:ped()) then
                    removed = false
                    for k, v in pairs(p:getInventaire()) do
                        if v.name == "weapon_flare" and hash == GetHashKey("weapon_flare") and not removed then
                            removed = true
                            TriggerServerEvent("core:RemoveItemToInventory", token, v.name, 1, v.metadatas)
                            if v.count <= 1 then
                                SetCurrentPedWeapon(p:ped(), 'WEAPON_UNARMED', true)
                                weaponOut = false
                                for key, value in pairs(Weapons) do
                                    if value.name == "weapon_flare" then
                                        SetCurrentPedWeapon(p:ped(), 'WEAPON_UNARMED', true)
                                        weaponOut = false
                                        RemoveAllPedWeapons(p:ped(), 1)
                                        Weapons[key] = nil
                                    end
                                end
                            end
                        elseif v.name == "weapon_molotov" and hash == GetHashKey("weapon_molotov") and not removed then
                            removed = true
                            TriggerServerEvent("core:RemoveItemToInventory", token, v.name, 1, v.metadatas)
                            if v.count <= 1 then
                                SetCurrentPedWeapon(p:ped(), 'WEAPON_UNARMED', true)
                                weaponOut = false
                                for key, value in pairs(Weapons) do
                                    if value.name == "weapon_molotov" then
                                        SetCurrentPedWeapon(p:ped(), 'WEAPON_UNARMED', true)
                                        weaponOut = false
                                        RemoveAllPedWeapons(p:ped(), 1)
                                        Weapons[key] = nil
                                    end
                                end
                            end
                        elseif v.name == "weapon_ball" and hash == GetHashKey("weapon_ball") and not removed then
                            removed = true
                            TriggerServerEvent("core:RemoveItemToInventory", token, v.name, 1, v.metadatas)
                            if v.count <= 1 then
                                SetCurrentPedWeapon(p:ped(), 'WEAPON_UNARMED', true)
                                weaponOut = false
                                for key, value in pairs(Weapons) do
                                    if value.name == "weapon_ball" then
                                        SetCurrentPedWeapon(p:ped(), 'WEAPON_UNARMED', true)
                                        weaponOut = false
                                        RemoveAllPedWeapons(p:ped(), 1)
                                        Weapons[key] = nil
                                    end
                                end
                            end
                        elseif v.name == "weapon_bzgas" and hash == GetHashKey("weapon_bzgas") and not removed then
                            removed = true
                            TriggerServerEvent("core:RemoveItemToInventory", token, v.name, 1, v.metadatas)
                            if v.count <= 1 then
                                SetCurrentPedWeapon(p:ped(), 'WEAPON_UNARMED', true)
                                weaponOut = false
                                for key, value in pairs(Weapons) do
                                    if value.name == "weapon_bzgas" and value.count <= 1 then
                                        SetCurrentPedWeapon(p:ped(), 'WEAPON_UNARMED', true)
                                        weaponOut = false
                                        RemoveAllPedWeapons(p:ped(), 1)
                                        Weapons[key] = nil
                                    end
                                end
                            end
                        elseif v.name == "weapon_stickybomb" and hash == GetHashKey("weapon_stickybomb") and not removed then
                            TriggerServerEvent("core:RemoveItemToInventory", token, v.name, 1, v.metadatas)
                            removed = true
                            if v.count <= 1 then
                                SetCurrentPedWeapon(p:ped(), 'WEAPON_UNARMED', true)
                                weaponOut = false
                                for key, value in pairs(Weapons) do
                                    if value.name == "weapon_stickybomb" and value.count <= 1 then
                                        SetCurrentPedWeapon(p:ped(), 'WEAPON_UNARMED', true)
                                        weaponOut = false
                                        RemoveAllPedWeapons(p:ped(), 1)
                                        Weapons[key] = nil
                                    end
                                end
                            end
                        elseif v.name == "weapon_grenade" and hash == GetHashKey("weapon_grenade") and not removed then
                            TriggerServerEvent("core:RemoveItemToInventory", token, v.name, 1, v.metadatas)
                            removed = true
                            if v.count <= 1 then
                                SetCurrentPedWeapon(p:ped(), 'WEAPON_UNARMED', true)
                                weaponOut = false
                                for key, value in pairs(Weapons) do
                                    if value.name == "weapon_grenade" then
                                        SetCurrentPedWeapon(p:ped(), 'WEAPON_UNARMED', true)
                                        weaponOut = false
                                        RemoveAllPedWeapons(p:ped(), 1)
                                        Weapons[key] = nil
                                    end
                                end
                            end
                        elseif v.name == "weapon_poxmine" and hash == GetHashKey("weapon_poxmine") and not removed then
                            TriggerServerEvent("core:RemoveItemToInventory", token, v.name, 1, v.metadatas)
                            removed = true
                            if v.count <= 1 then
                                SetCurrentPedWeapon(p:ped(), 'WEAPON_UNARMED', true)
                                weaponOut = false
                                for key, value in pairs(Weapons) do
                                    if value.name == "weapon_poxmine" then
                                        SetCurrentPedWeapon(p:ped(), 'WEAPON_UNARMED', true)
                                        weaponOut = false
                                        RemoveAllPedWeapons(p:ped(), 1)
                                        Weapons[key] = nil
                                    end
                                end
                            end
                        elseif v.name == "weapon_snowball" and hash == GetHashKey("weapon_snowball") and not removed then
                            TriggerServerEvent("core:RemoveItemToInventory", token, v.name, 1, v.metadatas)
                            removed = true
                            if v.count <= 1 then
                                SetCurrentPedWeapon(p:ped(), 'WEAPON_UNARMED', true)
                                weaponOut = false
                                for key, value in pairs(Weapons) do
                                    if value.name == "weapon_snowball" then
                                        SetCurrentPedWeapon(p:ped(), 'WEAPON_UNARMED', true)
                                        weaponOut = false
                                        RemoveAllPedWeapons(p:ped(), 1)
                                        Weapons[key] = nil
                                    end
                                end
                            end
                        elseif v.name == "weapon_canette" and hash == GetHashKey("weapon_canette") and not removed then
                            TriggerServerEvent("core:RemoveItemToInventory", token, v.name, 1, v.metadatas)
                            removed = true
                            if v.count <= 1 then
                                SetCurrentPedWeapon(p:ped(), 'WEAPON_UNARMED', true)
                                weaponOut = false
                                for key, value in pairs(Weapons) do
                                    if value.name == "weapon_canette" then
                                        SetCurrentPedWeapon(p:ped(), 'WEAPON_UNARMED', true)
                                        weaponOut = false
                                        RemoveAllPedWeapons(p:ped(), 1)
                                        Weapons[key] = nil
                                    end
                                end
                            end
                        elseif v.name == "weapon_bouteille" and hash == GetHashKey("weapon_bouteille") and not removed then
                            TriggerServerEvent("core:RemoveItemToInventory", token, v.name, 1, v.metadatas)
                            removed = true
                            if v.count <= 1 then
                                SetCurrentPedWeapon(p:ped(), 'WEAPON_UNARMED', true)
                                weaponOut = false
                                for key, value in pairs(Weapons) do
                                    if value.name == "weapon_bouteille" then
                                        SetCurrentPedWeapon(p:ped(), 'WEAPON_UNARMED', true)
                                        weaponOut = false
                                        RemoveAllPedWeapons(p:ped(), 1)
                                        Weapons[key] = nil
                                    end
                                end
                            end
                        elseif v.name == "weapon_smokelspd" and hash == GetHashKey("weapon_smokelspd") and not removed then
                            TriggerServerEvent("core:RemoveItemToInventory", token, v.name, 1, v.metadatas)
                            removed = true
                            if v.count <= 1 then
                                SetCurrentPedWeapon(p:ped(), 'WEAPON_UNARMED', true)
                                weaponOut = false
                                for key, value in pairs(Weapons) do
                                    if value.name == "weapon_smokelspd" then
                                        SetCurrentPedWeapon(p:ped(), 'WEAPON_UNARMED', true)
                                        weaponOut = false
                                        RemoveAllPedWeapons(p:ped(), 1)
                                        Weapons[key] = nil
                                    end
                                end
                            end
                        end
                    end
                    TriggerServerEvent("core:SetWeaponSave", token, Weapons)
                    Wait(600)
                end
            else
                if IsPedShooting(p:ped()) and not sendNotif and p:getJob() ~= "lspd" and p:getJob() ~= "lsfd" and p:getJob() ~= "usss" and p:getJob() ~= "lssd" and p:getJob() ~= "bp" and p:getJob() ~= "g6" and p:getJob() ~= "usmc" and not hunterservice and
                    hash ~= GetHashKey("weapon_petrolcan") and
                    hash ~= GetHashKey("weapon_nailgun") and
                    hash ~= GetHashKey("weapon_hose") and
                    hash ~= GetHashKey("weapon_fireextinguisher") and hash ~= GetHashKey("weapon_fakemachinepistol") and
                    hash ~= GetHashKey("weapon_stungun") and hash ~= GetHashKey("weapon_fakepistol") and
                    hash ~= GetHashKey("weapon_fakecombatpistol") and hash ~= GetHashKey("weapon_fakespecialcarbine") and
                    hash ~= GetHashKey("weapon_fakesmg") and hash ~= GetHashKey("weapon_fakeshotgun") and
                    hash ~= GetHashKey("weapon_fakeminismg") and hash ~= GetHashKey("weapon_fakemicrosmg") and
                    hash ~= GetHashKey("weapon_fakeak") and hash ~= GetHashKey("weapon_fakeaku") and
                    hash ~= GetHashKey("weapon_fakem4") and hash ~= GetHashKey("weapon_laser") and
                    hash ~= GetHashKey("weapon_paintball") then
                    local instance = TriggerServerCallback("core:CheckInstance", token)
                    if instance then
                        sendNotif = true
                        TriggerSecurEvent('core:makeCall', "lspd", vector3(p:pos().x, p:pos().y, p:pos().z), true,
                            "Coup de feu", false, "illegal")
                        TriggerSecurEvent('core:makeCall', "lssd", vector3(p:pos().x, p:pos().y, p:pos().z), true,
                            "Coup de feu", false, "illegal")
                        TriggerServerEvent('core:testPoudre')
                        Wait(30000)
                        sendNotif = false
                    end
                end
            end
        end
        if hasWeapon then
            Wait(30)
        else
            Wait(1000)
        end
    end
end)

lastFireTime = 0

CreateThread(function()
    while not p do Wait(1) end
    while true do
        Wait(1)
        if IsPedArmed(PlayerPedId(), 4) then
            local _, hash = GetCurrentPedWeapon(p:ped())
            if IsPedShooting(p:ped()) then
                lastFireTime = GetGameTimer()
                if p:getJob() ~= "lspd" and p:getJob() ~= "lsfd" and p:getJob() ~= "usss" and p:getJob() ~= "lssd" and p:getJob() ~= "bp" and not hunterservice and
                    hash ~= GetHashKey("weapon_petrolcan") and
                    hash ~= GetHashKey("weapon_nailgun") and
                    hash ~= GetHashKey("weapon_hose") and
                    hash ~= GetHashKey("weapon_fireextinguisher") and hash ~= GetHashKey("weapon_fakemachinepistol") and
                    hash ~= GetHashKey("weapon_stungun") and hash ~= GetHashKey("weapon_fakepistol") and
                    hash ~= GetHashKey("weapon_fakecombatpistol") and hash ~= GetHashKey("weapon_fakespecialcarbine") and
                    hash ~= GetHashKey("weapon_fakesmg") and hash ~= GetHashKey("weapon_fakeshotgun") and
                    hash ~= GetHashKey("weapon_fakeminismg") and hash ~= GetHashKey("weapon_fakemicrosmg") and
                    hash ~= GetHashKey("weapon_fakeak") and hash ~= GetHashKey("weapon_fakeaku") and
                    hash ~= GetHashKey("weapon_fakem4") and hash ~= GetHashKey("weapon_laser") and
                    hash ~= GetHashKey("weapon_paintball") then
                    TriggerServerEvent('core:testPoudre')
                end
            end
        else
            Wait(500)
        end
    end
end)

RegisterNetEvent("core:useTestPoudre", function()
    local globalTarget = nil
    local closestPlayer = ChoicePlayersInZone(5.0, true)
    if closestPlayer == nil then
        return
    end
    globalTarget = GetPlayerServerId(closestPlayer)
    local check = TriggerServerCallback("core:getTestPoudre", globalTarget)
    exports['vNotif']:createNotification({
        type = check == nil and 'ROUGE' or 'VERT',
        duration = 15,
        content = check == nil and "Résultat du test de poudre :~s Négatif~c" or
        "Résultat du test de poudre : ~sPositif~c (" .. check .. "%)"
    })
end)

RegisterCommand("playanim", function(source, args)
    while (not HasAnimDictLoaded(args[1])) do
        RequestAnimDict(args[1])
        Wait(5)
    end
    --   TaskPlayAnim(PlayerPedId(), args[1], args[2], 1.0, 4.0, -1, 49, 0, 0, 0, 0) -- mouvement
    TaskPlayAnim(PlayerPedId(), args[1], args[2], 8.0, 8.0, -1, 1, 0, false, false, false)     -- aucun mouvement
    local time = GetAnimDuration(args[1], args[2])
end)

local gEquip = false
-- thread to update weapon ammo count every 100ms
Citizen.CreateThread(function()
    while not loaded do
        Wait(100)
    end
    while p == nil do
        Wait(100)
    end
    while true do
        gEquip = false
        local ped = PlayerPedId()
        local hash = GetSelectedPedWeapon(ped)
        if hash ~= -1569615261 then
            gEquip = true
            local ammo = GetAmmoInPedWeapon(ped, hash)
            if ammo ~= 0 then
                for k, v in pairs(Weapons) do
                    if GetHashKey(v.name) == GetSelectedPedWeapon(ped) then
                        if v.metadatas.ammo ~= ammo then -- if ammo count is different
                            Weapons[k].metadatas.ammo = ammo
                            for key, value in pairs(p:getInventaire()) do
                                if value.name == v.name then
                                    value.metadatas.ammo = v.metadatas.ammo
                                end
                            end
                            TriggerServerCallback("core:RefreshInventory", token, p:getInventaire())
                            TriggerServerEvent("core:SetWeaponSave", token, Weapons)
                        end
                    end
                end
            end
        end
        if gEquip then
            Wait(60 * 1000)     -- 1 minute
        else
            Wait(2 * 60 * 1000) -- 2 minutes
        end
    end
end)

Citizen.CreateThread(function()
    while p == nil do
        Wait(1)
    end
    while true do
        Wait(0)

        if IsAimCamActive() then
            DisableControlAction(1, 22, true)
        end
        local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end

        SetPedSuffersCriticalHits(PlayerPedId(), OneShotHeadshot)
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)

        if not keyPressed then
            if IsControlPressed(0, 29) and not mp_pointing and IsPedOnFoot(PlayerPedId()) then
                Wait(200)
                if not IsControlPressed(0, 29) then
                    keyPressed = true
                    startPointing()
                    mp_pointing = true
                else
                    keyPressed = true
                    while IsControlPressed(0, 29) do
                        Wait(50)
                    end
                end
            elseif (IsControlPressed(0, 29) and mp_pointing) or (not IsPedOnFoot(PlayerPedId()) and mp_pointing) then
                keyPressed = true
                mp_pointing = false
                stopPointing()
            end
        end

        if keyPressed then
            if not IsControlPressed(0, 29) then
                keyPressed = false
            end
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) and not mp_pointing then
            stopPointing()
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
            if not IsPedOnFoot(PlayerPedId()) then
                stopPointing()
            else
                local ped = PlayerPedId()
                local camPitch = GetGameplayCamRelativePitch()
                if camPitch < -70.0 then
                    camPitch = -70.0
                elseif camPitch > 42.0 then
                    camPitch = 42.0
                end
                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                local cosCamHeading = Cos(camHeading)
                local sinCamHeading = Sin(camHeading)
                if camHeading < -180.0 then
                    camHeading = -180.0
                elseif camHeading > 180.0 then
                    camHeading = 180.0
                end
                camHeading = (camHeading + 180.0) / 360.0

                local blocked = 0
                local nn = 0

                local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) -
                    (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) +
                    (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y,
                    coords.z + 0.2, 0.4, 95, ped, 7);
                nn, blocked, coords, coords = GetRaycastResult(ray)

                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson",
                    Citizen.InvokeNative(0xEE778F8C7E1142E2,
                        Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)
            end
        end
    end
end)

-- TODO: faire fouiller la personne si main lever ou Ragdoll (touche: k)
local relationshipTypes = { "PLAYER", "CIVMALE", "CIVFEMALE", "COP", "SECURITY_GUARD", "PRIVATE_SECURITY", "FIREMAN",
    "GANG_1", "GANG_2", "GANG_9", "GANG_10", "AMBIENT_GANG_LOST", "AMBIENT_GANG_MEXICAN",
    "AMBIENT_GANG_FAMILY", "AMBIENT_GANG_BALLAS", "AMBIENT_GANG_MARABUNTE", "AMBIENT_GANG_CULT",
    "AMBIENT_GANG_SALVA", "AMBIENT_GANG_WEICHENG", "AMBIENT_GANG_HILLBILLY", "DEALER",
    "HATES_PLAYER", "HEN", -- "WILD_ANIMAL",
    -- "SHARK",
    -- "COUGAR",
    "NO_RELATIONSHIP", "SPECIAL", "MISSION2", "MISSION3", "MISSION4", "MISSION5", "MISSION6", "MISSION7", "MISSION8",
    "ARMY", "GUARD_DOG", "AGGRESSIVE_INVESTIGATE", "MEDIC", "CAT" }
local RELATIONSHIP_HATE = 1

CreateThread(function()
    while p == nil do
        Wait(1)
    end
    AddTextEntry('PM_PANE_CFX', '~HUD_COLOUR_PM_MITEM_HIGHLIGHT~Vision')

    for k, v in pairs(relationshipTypes) do
        SetRelationshipBetweenGroups(RELATIONSHIP_HATE, GetHashKey('PLAYER'), GetHashKey(v))
        SetRelationshipBetweenGroups(RELATIONSHIP_HATE, GetHashKey(v), GetHashKey('PLAYER'))
    end
    SetCanAttackFriendly(PlayerId(), true, false)
    NetworkSetFriendlyFireOption(true)
    SetAudioFlag("PoliceScannerDisabled", true)
    for i = 0, 15 do
        EnableDispatchService(i, false)
    end

    ClearPlayerWantedLevel(PlayerId())
    SetMaxWantedLevel(0)
    SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
end)

local spawnVeh = { "rhino", "hydra", "buzzard", "lazer", "titan", "cargobob", "adder", "zentorno", "blimp", "blimp2",
    "blimp3", "stockade" }

local scenario = { "WORLD_VEHICLE_MILITARY_PLANES_BIG",
    "WORLD_VEHICLE_MILITARY_PLANES_SMALL",
    "Grapeseed_Planes",
    "Senora_Freeway",
    "Farmers_Market",
    "LITTLE_SEOUL_APARTMENTS",
    "Lighthouse",
    "LOS_PUERTA",
    "Facility_Main",
    "Island_Drug_Fields",
    "Grapeseed",
}

local keys = { 157, 158, 160, 164, 165 }
CreateThread(function()
    while p == nil do
        Wait(1)
    end
    SetNuiFocus(false, false)
    openRadarProperly()
    local playerPed = PlayerPedId()
    SetWeaponsNoAutoswap(true)
    while not PlayerId do -- Cause des crash sinon
        Wait(500)
    end
    while not GetPlayerWantedLevel do -- Cause des crash sinon
        Wait(500)
    end
    while not DisablePlayerVehicleRewards do -- Cause des crash sinon
        Wait(500)
    end
    while true do
        Wait(1)
        local playerLocalisation = GetEntityCoords(playerPed)
        if GetPlayerWantedLevel(PlayerId()) ~= 0 then
            SetPlayerWantedLevel(PlayerId(), 0, false)
            SetPlayerWantedLevelNow(PlayerId(), false)
        end

        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped, false) then
            if GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), 0) == ped then
                if GetIsTaskActive(ped, 165) then
                    SetPedIntoVehicle(ped, GetVehiclePedIsIn(ped, false), 0)
                end
            end
        end

        RemoveMultiplayerHudCash()
        RemoveMultiplayerBankCash()
        DisablePlayerVehicleRewards(PlayerId())
        SetEveryoneIgnorePlayer(p:ped(), true)
        SetPedConfigFlag(PlayerPedId(), 35, false) -- Enleve le port du casque obligé sur une moto
        RestorePlayerStamina(PlayerId(), 1.0)
        BlockWeaponWheelThisFrame()
        SetPauseMenuActive(false)
        HudWeaponWheelIgnoreSelection()


        ClearAreaOfPeds(182.13922119141, 1722.5727539063, 226.2946472168, 100.0) -- jsp c nekzerd
        ClearAreaOfPeds(-1389.6741943359, -609.00128173828, 30.647138595581, 20.0)
        ClearAreaOfPeds(1221.5797119141, 2737.2631835938, 37.006572723389, 20.0)
        ClearAreaOfPeds(1706.431640625, 2596.4821777344, 49.044227600098, 65.0)     -- boillingbrouk
        ClearAreaOfVehicles(-276.30349731445, 6047.6010742188, 29.86653137207, 15.0)
        ClearAreaOfVehicles(213.77258300781, 389.35946655273, 105.84759521484, 5.0) -- Auto école
        ClearAreaOfVehicles(161.88876342773, 6606.5727539063, 31.90796661377, 30.0)
        ClearAreaOfVehicles(1223.1137695313, 2711.5505371094, 37.005912780762, 20.0)
        ClearAreaOfVehicles(2554.9033203125, 2609.0249023438, 37.104957580566, 35.0)
        ClearAreaOfCops(playerLocalisation.x, playerLocalisation.y, playerLocalisation.z, 400.0)

        HideHudComponentThisFrame(19)
        HideHudComponentThisFrame(20)
        HideHudComponentThisFrame(17)
        DisableControlAction(0, 37, true)

        DisableControlAction(0, 199, true)
        HudWeaponWheelIgnoreSelection()
    end
end)

CreateThread(function()
    while p == nil do
        Wait(1)
    end
    while true do
        Wait(1)
        for k, v in pairs(keys) do
            if IsDisabledControlJustReleased(0, v) then
                if not p:isInVeh() or PlayerUtils.forceEquipWeapon then
                    if not GlobalBlockWeaponsKeys then
                        EquipWeapon(tostring(k))
                    end
                end
            end
        end
    end
end)

local pVeh = false
-- create loop to check if player is driver in a vehicle and if so, disable shooting
CreateThread(function()
    while p == nil do
        Wait(1)
    end
    while true do
        if p:getPermission() >= 6 then break end
        if p:isInVeh() and GetPedInVehicleSeat(GetVehiclePedIsIn(p:ped(), false), -1) == p:ped() then
            pVeh = true
            DisableControlAction(0, 69, true)
            DisableControlAction(0, 92, true)
        end
        if pVeh and not p:isInVeh() then
            pVeh = false
        end
        if pVeh then
            Wait(1)
        else
            Wait(1000)
        end
    end
end)
-- CreateThread(function()
--     while true do
--         HudForceWeaponWheel(false)
--         BlockWeaponWheelThisFrame()
--         HudWeaponWheelIgnoreControlInput(true)
--         HudWeaponWheelIgnoreSelection()
--         HideHudComponentThisFrame(19)
--         HideHudComponentThisFrame(20)
--         HideHudComponentThisFrame(17)
--         DisableControlAction(1, 37)
--         DisableControlAction(0, 199)
--         Wait(0)
--     end
-- end)

local knocked = false
local wait = 10
local count = 30
local tires = { {
    bone = "wheel_lf",
    index = 0
}, {
    bone = "wheel_rf",
    index = 1
}, {
    bone = "wheel_lm",
    index = 2
}, {
    bone = "wheel_rm",
    index = 3
}, {
    bone = "wheel_lr",
    index = 4
}, {
    bone = "wheel_rr",
    index = 5
}, {
    bone = "wheel_lr",
    index = 45
}, {
    bone = "wheel_rr",
    index = 47
} }


-- Boucle check mais bon a refaire je pense car elle est bancale un peu
CreateThread(function()
    while p == nil do
        Wait(1)
    end
    while true do
        local pNear = false
        if IsPedInAnyVehicle(p:ped(), true) and Bequille then
            UnequipCrutch()
            Bequille = false
        end

        --[[ if IsPedInAnyVehicle(p:ped(), true) then
            exports["rpemotes"]:EmoteCancel()
        end ]]

        if p:isInVeh() then
            local vehicle = GetVehiclePedIsIn(p:ped(), false)
            local tirePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tires[1].bone))
            local tirePos2 = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tires[2].bone))
            local tirePos3 = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tires[3].bone))
            local tirePos4 = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tires[4].bone))
            local tirePos5 = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tires[5].bone))
            local tirePos6 = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tires[6].bone))
            local tirePos7 = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tires[7].bone))
            local tirePos8 = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tires[8].bone))
            local spike = GetClosestObjectOfType(tirePos.x, tirePos.y, tirePos.z, 200.0, GetHashKey("p_ld_stinger_s"))
            local spike2 = GetClosestObjectOfType(tirePos2.x, tirePos2.y, tirePos2.z, 200.0, GetHashKey("p_ld_stinger_s"))
            local spike3 = GetClosestObjectOfType(tirePos5.x, tirePos5.y, tirePos5.z, 200.0, GetHashKey("p_ld_stinger_s"))
            if spike or spike2 or spike3 then
                local spikePos = GetEntityCoords(spike, false)
                if spike then spikePos = GetEntityCoords(spike, false) elseif spike2 then spikePos = GetEntityCoords(
                    spike2, false) elseif spike3 then spikePos = GetEntityCoords(spike3, false) end
                local distance = Vdist(tirePos.x, tirePos.y, tirePos.z, spikePos.x, spikePos.y, spikePos.z)
                local distance2 = Vdist(tirePos2.x, tirePos2.y, tirePos2.z, spikePos.x, spikePos.y, spikePos.z)
                local distance3 = Vdist(tirePos3.x, tirePos3.y, tirePos3.z, spikePos.x, spikePos.y, spikePos.z)
                local distance4 = Vdist(tirePos4.x, tirePos4.y, tirePos4.z, spikePos.x, spikePos.y, spikePos.z)
                local distance5 = Vdist(tirePos5.x, tirePos5.y, tirePos5.z, spikePos.x, spikePos.y, spikePos.z)
                local distance6 = Vdist(tirePos6.x, tirePos6.y, tirePos6.z, spikePos.x, spikePos.y, spikePos.z)
                local distance7 = Vdist(tirePos7.x, tirePos7.y, tirePos7.z, spikePos.x, spikePos.y, spikePos.z)
                local distance8 = Vdist(tirePos8.x, tirePos8.y, tirePos8.z, spikePos.x, spikePos.y, spikePos.z)

                if distance7 < 50.0 and p:isInVeh() then
                    pNear = true
                    if distance7 < 1.8 and p:isInVeh() then
                        if not IsVehicleTyreBurst(vehicle, tires[7].index, true) then
                            SetVehicleTyreBurst(vehicle, tires[7].index, false, 1000.0)
                        end
                        if not IsVehicleTyreBurst(vehicle, tires[7].index, false) then
                            SetVehicleTyreBurst(vehicle, tires[7].index, false, 1000.0)
                        end
                    end
                end
                if distance8 < 50.0 and p:isInVeh() then
                    pNear = true
                    if distance8 < 1.8 then
                        if not IsVehicleTyreBurst(vehicle, tires[8].index, true) then
                            SetVehicleTyreBurst(vehicle, tires[8].index, false, 1000.0)
                        end
                        if not IsVehicleTyreBurst(vehicle, tires[8].index, false) then
                            SetVehicleTyreBurst(vehicle, tires[8].index, false, 1000.0)
                        end
                    end
                end
                if distance < 50.0 and p:isInVeh() then
                    pNear = true
                    if distance < 1.8 then
                        if not IsVehicleTyreBurst(vehicle, tires[1].index, true) then
                            SetVehicleTyreBurst(vehicle, tires[1].index, false, 1000.0)
                        end
                        if not IsVehicleTyreBurst(vehicle, tires[1].index, false) then
                            SetVehicleTyreBurst(vehicle, tires[1].index, false, 1000.0)
                        end
                    end
                end
                if distance2 < 50.0 and p:isInVeh() then
                    pNear = true
                    if distance2 < 1.8 then
                        if not IsVehicleTyreBurst(vehicle, tires[2].index, true) then
                            SetVehicleTyreBurst(vehicle, tires[2].index, false, 1000.0)
                        end
                        if not IsVehicleTyreBurst(vehicle, tires[2].index, false) then
                            SetVehicleTyreBurst(vehicle, tires[2].index, false, 1000.0)
                        end
                    end
                end
                if distance5 < 50.0 and p:isInVeh() then
                    pNear = true
                    if distance5 < 1.8 then
                        if not IsVehicleTyreBurst(vehicle, tires[5].index, true) then
                            SetVehicleTyreBurst(vehicle, tires[5].index, false, 1000.0)
                        end
                        if not IsVehicleTyreBurst(vehicle, tires[5].index, false) then
                            SetVehicleTyreBurst(vehicle, tires[5].index, false, 1000.0)
                        end
                    end
                end
                if distance6 < 50.0 and p:isInVeh() then
                    pNear = true
                    if distance6 < 1.8 then
                        if not IsVehicleTyreBurst(vehicle, tires[6].index, true) then
                            SetVehicleTyreBurst(vehicle, tires[6].index, false, 1000.0)
                        end
                        if not IsVehicleTyreBurst(vehicle, tires[6].index, false) then
                            SetVehicleTyreBurst(vehicle, tires[6].index, false, 1000.0)
                        end
                    end
                end
            end
        end
        if pNear then
            Wait(1)
        else
            Wait(1000)
        end
    end
end)


CreateThread(function()
    while p == nil do
        Wait(1)
    end
    while true do
        Wait(300)

        for k, v in pairs(spawnVeh) do
            SetVehicleModelIsSuppressed(GetHashKey(v), true)
        end
        for k, v in pairs(scenario) do
            SetScenarioGroupEnabled(v, false)
        end
        --[[if IsPedInMeleeCombat(p:ped()) and not knocked then
            if GetEntityHealth(p:ped()) < 115 then
                SetPlayerInvincible(p:ped(), true)
                SetPedToRagdoll(p:ped(), 1000, 1000, 0, 0, 0, 0)
                -- ShowNotification("~r~Vous êtes KO")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Vous êtes KO"
                })

                wait = 3
                knocked = true
                SetEntityHealth(p:ped(), 116)
            end
        end
        if knocked then
            SetPlayerInvincible(p:ped(), true)
            DisablePlayerFiring(p:ped(), true)
            SetPedToRagdoll(p:ped(), 1000, 1000, 0, 0, 0, 0)
            ResetPedRagdollTimer(p:ped())

            if wait >= 0 then
                count = count - 1
                if count == 0 then
                    count = 30
                    wait = wait - 1
                    SetEntityHealth(p:ped(), GetEntityHealth(p:ped()) + 3)
                end
            else
                SetPlayerInvincible(p:ped(), false)
                knocked = false
            end
        end]]
    end
end)

-- REMOVE WEAPON DROPS FROM PEDS
function RemoveWeaponDrops()
    local pickupList = { "PICKUP_AMMO_BULLET_MP", "PICKUP_AMMO_FIREWORK", "PICKUP_AMMO_FLAREGUN",
        "PICKUP_AMMO_GRENADELAUNCHER", "PICKUP_AMMO_GRENADELAUNCHER_MP", "PICKUP_AMMO_HOMINGLAUNCHER", "PICKUP_AMMO_MG",
        "PICKUP_AMMO_MINIGUN", "PICKUP_AMMO_MISSILE_MP", "PICKUP_AMMO_PISTOL", "PICKUP_AMMO_RIFLE", "PICKUP_AMMO_RPG",
        "PICKUP_AMMO_SHOTGUN", "PICKUP_AMMO_SMG", "PICKUP_AMMO_SNIPER", "PICKUP_ARMOUR_STANDARD", "PICKUP_CAMERA",
        "PICKUP_CUSTOM_SCRIPT", "PICKUP_GANG_ATTACK_MONEY", "PICKUP_HEALTH_SNACK", "PICKUP_HEALTH_STANDARD",
        "PICKUP_MONEY_CASE", "PICKUP_MONEY_DEP_BAG", "PICKUP_MONEY_MED_BAG", "PICKUP_MONEY_PAPER_BAG",
        "PICKUP_MONEY_PURSE", "PICKUP_MONEY_SECURITY_CASE", "PICKUP_MONEY_VARIABLE", "PICKUP_MONEY_WALLET",
        "PICKUP_PARACHUTE", "PICKUP_PORTABLE_CRATE_FIXED_INCAR", "PICKUP_PORTABLE_CRATE_UNFIXED",
        "PICKUP_PORTABLE_CRATE_UNFIXED_INCAR", "PICKUP_PORTABLE_CRATE_UNFIXED_INCAR_SMALL",
        "PICKUP_PORTABLE_CRATE_UNFIXED_LOW_GLOW", "PICKUP_PORTABLE_DLC_VEHICLE_PACKAGE", "PICKUP_PORTABLE_PACKAGE",
        "PICKUP_SUBMARINE", "PICKUP_VEHICLE_ARMOUR_STANDARD", "PICKUP_VEHICLE_CUSTOM_SCRIPT",
        "PICKUP_VEHICLE_CUSTOM_SCRIPT_LOW_GLOW", "PICKUP_VEHICLE_HEALTH_STANDARD",
        "PICKUP_VEHICLE_HEALTH_STANDARD_LOW_GLOW", "PICKUP_VEHICLE_MONEY_VARIABLE", "PICKUP_VEHICLE_WEAPON_APPISTOL",
        "PICKUP_VEHICLE_WEAPON_ASSAULTSMG", "PICKUP_VEHICLE_WEAPON_COMBATPISTOL", "PICKUP_VEHICLE_WEAPON_GRENADE",
        "PICKUP_VEHICLE_WEAPON_MICROSMG", "PICKUP_VEHICLE_WEAPON_MOLOTOV", "PICKUP_VEHICLE_WEAPON_PISTOL",
        "PICKUP_VEHICLE_WEAPON_PISTOL50", "PICKUP_VEHICLE_WEAPON_SAWNOFF", "PICKUP_VEHICLE_WEAPON_SMG",
        "PICKUP_VEHICLE_WEAPON_SMOKEGRENADE", "PICKUP_VEHICLE_WEAPON_STICKYBOMB", "PICKUP_WEAPON_ADVANCEDRIFLE",
        "PICKUP_WEAPON_APPISTOL", "PICKUP_WEAPON_ASSAULTRIFLE", "PICKUP_WEAPON_ASSAULTSHOTGUN",
        "PICKUP_WEAPON_ASSAULTSMG", "PICKUP_WEAPON_AUTOSHOTGUN", "PICKUP_WEAPON_BAT", "PICKUP_WEAPON_BATTLEAXE",
        "PICKUP_WEAPON_BOTTLE", "PICKUP_WEAPON_BULLPUPRIFLE", "PICKUP_WEAPON_BULLPUPSHOTGUN",
        "PICKUP_WEAPON_CARBINERIFLE", "PICKUP_WEAPON_COMBATMG", "PICKUP_WEAPON_COMBATPDW", "PICKUP_WEAPON_COMBATPISTOL",
        "PICKUP_WEAPON_COMPACTLAUNCHER", "PICKUP_WEAPON_COMPACTRIFLE", "PICKUP_WEAPON_CROWBAR", "PICKUP_WEAPON_DAGGER",
        "PICKUP_WEAPON_DBSHOTGUN", "PICKUP_WEAPON_FIREWORK", "PICKUP_WEAPON_FLAREGUN", "PICKUP_WEAPON_FLASHLIGHT",
        "PICKUP_WEAPON_GRENADE", "PICKUP_WEAPON_GRENADELAUNCHER", "PICKUP_WEAPON_GUSENBERG", "PICKUP_WEAPON_GOLFCLUB",
        "PICKUP_WEAPON_HAMMER", "PICKUP_WEAPON_HATCHET", "PICKUP_WEAPON_HEAVYPISTOL", "PICKUP_WEAPON_HEAVYSHOTGUN",
        "PICKUP_WEAPON_HEAVYSNIPER", "PICKUP_WEAPON_HOMINGLAUNCHER", "PICKUP_WEAPON_KNIFE", "PICKUP_WEAPON_KNUCKLE",
        "PICKUP_WEAPON_MACHETE", "PICKUP_WEAPON_MACHINEPISTOL", "PICKUP_WEAPON_MARKSMANPISTOL",
        "PICKUP_WEAPON_MARKSMANRIFLE", "PICKUP_WEAPON_MG", "PICKUP_WEAPON_MICROSMG", "PICKUP_WEAPON_MINIGUN",
        "PICKUP_WEAPON_MINISMG", "PICKUP_WEAPON_MOLOTOV", "PICKUP_WEAPON_MUSKET", "PICKUP_WEAPON_NIGHTSTICK",
        "PICKUP_WEAPON_PETROLCAN", "PICKUP_WEAPON_PIPEBOMB", "PICKUP_WEAPON_PISTOL", "PICKUP_WEAPON_PISTOL50",
        "PICKUP_WEAPON_POOLCUE", "PICKUP_WEAPON_PROXMINE", "PICKUP_WEAPON_PUMPSHOTGUN", "PICKUP_WEAPON_RAILGUN",
        "PICKUP_WEAPON_REVOLVER", "PICKUP_WEAPON_SAWNOFFSHOTGUN", "PICKUP_WEAPON_SMG", "PICKUP_WEAPON_SMOKEGRENADE",
        "PICKUP_WEAPON_SNIPERRIFLE", "PICKUP_WEAPON_SNSPISTOL", "PICKUP_WEAPON_SPECIALCARBINE",
        "PICKUP_WEAPON_STICKYBOMB", "PICKUP_WEAPON_STUNGUN", "PICKUP_WEAPON_SWITCHBLADE", "PICKUP_WEAPON_VINTAGEPISTOL",
        "PICKUP_WEAPON_WRENCH", "PICKUP_WEAPON_RAYCARBINE", "PICKUP_WEAPON_RPG" }
    for a = 1, #pickupList do
        N_0x616093ec6b139dd9(PlayerId(), GetHashKey(pickupList[a]), false)
    end
end

Citizen.CreateThread(function()
    RemoveWeaponDrops()
    SetFlashLightKeepOnWhileMoving(true)
end)


-- ne pas toucher merci bien
-- nope
RegisterNUICallback("setTyping", function(data)
    if data.value then
        SetNuiFocusKeepInput(false)
    else
        SetNuiFocusKeepInput(true)
    end
end)


----------------------------------No Shuffle
local disableShuffle = true
function disableSeatShuffle(flag)
    disableShuffle = flag
end

local melee = true
function disableMelee()
    -- if melee is enabled, start a loop that disables melee
    if melee then
        melee = false
        -- ShowNotification("~r~Combat désactivé")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Combat ~s désactivé"
        })

        while not melee do
            Wait(0)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
        end
    else
        -- ShowNotification("~g~Combat activé")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Combat ~s activé"
        })

        melee = true
    end
end

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end

        local enum = { handle = iter, destructor = disposeFunc }
        setmetatable(enum, entityEnumerator)

        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next

        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

local function GetEntity()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function DetachObjet(entity)
    local playerPosition = GetEntityCoords(entity)
    for object in GetEntity() do
        if object and DoesEntityExist(object) and IsEntityAttached(object) and GetDistanceBetweenCoords(GetEntityCoords(object), playerPosition) <= 1.5 then
            DeleteEntity(object)
        end
    end

    local entity = GetEntityAttachedTo(PlayerPedId())
    if entity ~= 0 then
        if IsEntityAttachedToAnyObject(PlayerPedId()) then
            DetachEntity(entity)
            DeleteEntity(entity)
        end
    end
end

function DetachProps(entity)
    ClearAllPedProps(PlayerPedId())
end

CreateThread(function()
    while p == nil do
        Wait(1)
    end
    while not NetworkIsSessionStarted() do
        Wait(1)
    end
    TriggerEvent("core:playerSpawned")
end)

local yLimitation = 1490
function coordsIsInSouth(coords)
    return coords.y < yLimitation
end

RegisterNetEvent("Core:PrintChangeInstance")
AddEventHandler("Core:PrintChangeInstance", function(playerid, instance, reason)
    print("Vous avez change d'instance : " .. reason .. "I Nouvelle instance : " .. instance)
end)

function IsQWERTYKeyboard()
    return GetControlInstructionalButton(2, 32) == 't_W'
end

function IsAZERTYKeyboard()
    return GetControlInstructionalButton(2, 32) == 't_Z'
end
