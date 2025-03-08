local open = falseni
local inAnim = false
local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local malettecuir = false
local malcuirmodel = "prop_ld_case_01"
local malcuir_net = nil

local umbrella = false
local umbmodel = "p_amb_brolly_01"
local umb_net = nil

local trophylaser = false
local trophymodel = "tasertroph1"
local trophy_net = nil

local cig = false
local cigmodel = "prop_cs_ciggy_01"
local cig_net = nil

local cigar = false
local cigarmodel = "lux_prop_cigar_01_luxe"
local cigar_net = nil

local smoking = false
local duration = 0

local desactouches = {1, 2, 24, 69, 70, 140, 141, 257, 263, 264, 142, 18, 322, 106}

--[[ function OpenAnimMenu()
    if not open then
        open = true
        CreateThread(function()
            while open do
                Wait(0)
                for k, v in pairs(desactouches) do
                    DisableControlAction(0, v, open)
                end
            end
        end)
        SetNuiFocusKeepInput(true)
        SetNuiFocus(true, true)
        CreateThread(function()
            SendNUIMessage({
                type = "openWebview",
                name = "animation",
                data = {
                    categories = Animations.category,
                    list = Animations.list,
                }
            })
        end)
    else
        open = false
        SetNuiFocusKeepInput(false)
        EnableControlAction(0, 1, true)
        EnableControlAction(0, 2, true)
        EnableControlAction(0, 142, true)
        EnableControlAction(0, 18, true)
        EnableControlAction(0, 322, true)
        EnableControlAction(0, 106, true)
        SetNuiFocus(false, false)
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
        return
    end
end

Keys.Register("M", "M", "Ouvrir le menu animation", function()
    OpenAnimMenu()
end) ]]

--[[ RegisterNUICallback("animation__callback", function(data, cb)

    if p:isInVeh() then
        return
    end

    if not DoesEntityExist(p:ped()) then
        return
    end

    ClearPedTasks(p:ped())
    if data.category and data.category == "Démarches" then
        p:SetAnimSet(data.anim)
    elseif data.category and data.category == "Signes" then
        p:PlayAnim(data.anim, data.dict, 49)
        inAnim = true
    elseif data.anim then
        p:PlayAnim(data.anim, data.dict, 1)
        inAnim = true
    end
    if data.scen then
        TaskStartScenarioInPlace(p:ped(), data.scen, 0, true)
        inAnim = true
    end
end)

RegisterNUICallback("animation-stop", function()
    if inAnim then
        ClearPedTasksImmediately(p:ped())
        ClearPedTasks(p:ped())
        inAnim = false
    end
end) ]]

RegisterNetEvent('core:UseMaletteCuir')
AddEventHandler('core:UseMaletteCuir', function()
    if IsPlayerDead(p:ped()) then
        return
    end

    if not DoesEntityExist(p:ped()) then
        return
    end
    TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)

    local malcuir_dict = "amb@code_human_wander_purse@female@base"
    local malcuir_anim = "static"
    local player = PlayerPedId()
    local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
    local umbspawned = CreateObject(GetHashKey(malcuirmodel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
    local netid = ObjToNet(umbspawned)

    if not malettecuir then
        if p:isInVeh() then
            return
        end
        loadAnimDict(malcuir_dict)
        RequestModel(GetHashKey(malcuirmodel))
        TaskPlayAnim(player, malcuir_dict, malcuir_anim, 8.0, 1.0, -1, 49, 0, 0, 0, 0)
        Wait(500)
        SetNetworkIdExistsOnAllMachines(netid, true)
        NetworkSetNetworkIdDynamic(netid, true)
        SetNetworkIdCanMigrate(netid, false)
        AttachEntityToEntity(umbspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), 0.0
            , 0.0, -0.08, 0.0, 0.0, 200.0, 1, 1, 0, 1, 0, 1)
        Wait(120)
        RemoveAnimDict("malcuir_dict")
        malcuir_net = netid
        malettecuir = true
    else
        Wait(100)
        SetModelAsNoLongerNeeded(GetHashKey(malcuirmodel))
        ClearPedSecondaryTask(PlayerPedId())
        DetachEntity(NetToObj(malcuir_net), 1, 1)
        DeleteEntity(NetToObj(malcuir_net))
        malettecuir = false
    end
end)


RegisterNetEvent('core:UseUmbrella')
AddEventHandler('core:UseUmbrella', function()
    if IsPlayerDead(p:ped()) then
        return
    end

    if not DoesEntityExist(p:ped()) then
        return
    end
    TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)

    local umb_dict = "amb@code_human_wander_drinking@beer@male@base"
    local umb_anim = "static"
    local player = PlayerPedId()
    local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
    local umbspawned = CreateObject(GetHashKey(umbmodel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
    local netid = ObjToNet(umbspawned)

    if not umbrella then
        if p:isInVeh() then
            return
        end
        loadAnimDict(umb_dict)
        RequestModel(GetHashKey(umbmodel))
        TaskPlayAnim(player, umb_dict, umb_anim, 8.0, 1.0, -1, 49, 0, 0, 0, 0)
        Wait(500)
        SetNetworkIdExistsOnAllMachines(netid, true)
        NetworkSetNetworkIdDynamic(netid, true)
        SetNetworkIdCanMigrate(netid, false)
        AttachEntityToEntity(umbspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), 0.0
            , 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        Wait(120)
        umb_net = netid
        umbrella = true
    else
        Wait(100)
        SetModelAsNoLongerNeeded(GetHashKey(umbmodel))
        ClearPedSecondaryTask(PlayerPedId())
        DetachEntity(NetToObj(umb_net), 1, 1)
        DeleteEntity(NetToObj(umb_net))
        umbrella = false
    end
end)
RegisterNetEvent('core:UseTaserTrophy')
AddEventHandler('core:UseTaserTrophy', function()
    if IsPlayerDead(p:ped()) then
        return
    end

    if not DoesEntityExist(p:ped()) then
        return
    end
    TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)

    local troph_dict = "impexp_int-0"
    local troph_anim = "mp_m_waremech_01_dual-0"
    local player = PlayerPedId()
    local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
    local trophspawned = CreateObject(GetHashKey(trophymodel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
    local netid = ObjToNet(trophspawned)

    if not trophylaser then
        if p:isInVeh() then
            return
        end
        loadAnimDict(troph_dict)
        RequestModel(GetHashKey(trophymodel))
        TaskPlayAnim(player, troph_dict, troph_anim, 8.0, 1.0, -1, 49, 0, 0, 0, 0)
        Wait(500)
        SetNetworkIdExistsOnAllMachines(netid, true)
        NetworkSetNetworkIdDynamic(netid, true)
        SetNetworkIdCanMigrate(netid, false)
        AttachEntityToEntity(trophspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 24817), 
        -0.20, 0.40, -0.02, 195.0, -92.0, 0.0, 1, 1, 0, 1, 0, 1)
        Wait(120)
        trophy_net = netid
        trophylaser = true
    else
        Wait(100)
        SetModelAsNoLongerNeeded(GetHashKey(trophymodel))
        ClearPedSecondaryTask(PlayerPedId())
        DetachEntity(NetToObj(trophy_net), 1, 1)
        DeleteEntity(NetToObj(trophy_net))
        trophylaser = false
    end
end)

RegisterNetEvent("core:wheelchair", function()
    RequestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
    while not HasAnimDictLoaded('anim@amb@clubhouse@tutorial@bkr_tut_ig3@') do
        Wait(0)
    end
    p:PlayAnim('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 1)
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'Progressbar',
        data = {
            text = "Monte la chaisse roulante",
            time = 3,
        }
    }))
    Modules.UI.RealWait(3000)
    ExecuteCommand("e c")
    local pos = vector4(p:pos().x, p:pos().y, p:pos().z, GetEntityHeading(p:ped()))
    local veh = vehicle.create("iak_wheelchair", pos, {})
    TaskWarpPedIntoVehicle(p:ped(), veh, -1)
end)

RegisterNetEvent("core:bike")
AddEventHandler("core:bike", function(props)
    RequestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
        while not HasAnimDictLoaded('anim@amb@clubhouse@tutorial@bkr_tut_ig3@') do
            Wait(0)
        end
    p:PlayAnim('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 1)
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'Progressbar',
        data = {
            text = "Monte le vélo",
            time = 3,
        }
    }))
    Modules.UI.RealWait(3000)
    ExecuteCommand("e c")
    local pos = vector4(p:pos().x, p:pos().y, p:pos().z, GetEntityHeading(p:ped()))
    local veh = vehicle.create(props.name, pos, props.props)
    TaskWarpPedIntoVehicle(p:ped(), veh, -1)
end)

RegisterNetEvent("core:UseCig")
AddEventHandler("core:UseCig", function()
    -- when the player uses weed, do the smoking emote for 2 minutes
    if p:isInVeh() or IsPlayerDead(PlayerPedId()) then
        -- give back the weed
        TriggerSecurGiveEvent("core:addItemToInventory", token, "cig", 1, {})
        return
    end
    TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)

    local umb_dict = "amb@world_human_aa_smoke@male@idle_a"
    local umb_anim = "idle_c"
    local player = PlayerPedId()
    local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
    local cigspawned = CreateObject(GetHashKey(cigmodel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
    local netid = ObjToNet(cigspawned)

    if not cig then
        -- play scenario
        --[[ loadAnimDict(umb_dict)
        RequestModel(GetHashKey(cigmodel)) ]]
        TaskStartScenarioInPlace(p:ped(), "WORLD_HUMAN_SMOKING", 0, true)  
        Wait(500)
        SetNetworkIdExistsOnAllMachines(netid, true)
        NetworkSetNetworkIdDynamic(netid, true)
        SetNetworkIdCanMigrate(netid, false)
        --[[ AttachEntityToEntity(cigspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), 0.0
            , 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1) ]]
        Wait(120)
        cig_net = netid
        cig = true
        while cig and duration < 120000 do
            ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour arrêter de fumer")
            if IsControlJustPressed(0, 38) then
                cig = false
                ClearPedTasks(PlayerPedId())
            end
            duration = duration + 10
            Citizen.Wait(10)
        end
        ClearPedTasks(PlayerPedId())
        cig = false
        duration = 0
    else
        Wait(100)
        SetModelAsNoLongerNeeded(GetHashKey(cigmodel))
        ClearPedSecondaryTask(PlayerPedId())
        DetachEntity(NetToObj(cig_net), 1, 1)
        DeleteEntity(NetToObj(cig_net))
        cig = false
    end
end)


RegisterNetEvent("core:UseCigar")
AddEventHandler("core:UseCigar", function()
    -- when the player uses weed, do the smoking emote for 2 minutes
    if p:isInVeh() or IsPlayerDead(PlayerPedId()) then
        -- give back the weed
        TriggerSecurGiveEvent("core:addItemToInventory", token, "cigar", 1, {})
        return
    end
    TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)

    local umb_dict = "amb@world_human_aa_smoke@male@idle_a"--"amb@world_human_aa_smoke@male@idle_a"
    local umb_anim = "idle_c"--"idle_c"
    local player = PlayerPedId()
    local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
    local cigarspawned = CreateObject(GetHashKey(cigarmodel), plyCoords.x, plyCoords.y, plyCoords.z, 1)
    local netid = ObjToNet(cigarspawned)
    cigar_net = cigarspawned

    if not cigar then
        -- play scenario
        loadAnimDict(umb_dict)
        RequestModel(GetHashKey(cigarmodel))
        TaskPlayAnim(player, umb_dict, umb_anim, 8.0, 1.0, -1, 49, 0, 0, 0, 0)
        Wait(500)
        SetNetworkIdExistsOnAllMachines(netid, true)
        NetworkSetNetworkIdDynamic(netid, true)
        SetNetworkIdCanMigrate(netid, false)
        AttachEntityToEntity(cigarspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), 0.0
            , 0.0, 0.0, 20.0, 90.0, 20.0, 1, 1, 0, 1, 0, 1)
        Wait(120)
        cigar = true
        while cigar and duration < 120000 do
            ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour arrêter de fumer votre cigar")
            if IsControlJustPressed(0, 38) then
                cigar = false
                DetachEntity(cigar_net)
                DeleteEntity(cigar_net)
                StopAnimTask(PlayerPedId(), "amb@world_human_aa_smoke@male@idle_a","idle_c",1.0)
            end
            duration = duration + 10
            Citizen.Wait(10)
        end
        StopAnimTask(PlayerPedId(), "amb@world_human_aa_smoke@male@idle_a","idle_c",1.0)
        cigar = false
        duration = 0
    else
        Wait(100)
        SetModelAsNoLongerNeeded(GetHashKey(cigarmodel))
        ClearPedSecondaryTask(PlayerPedId())
        DetachEntity(cigar_net)
        DeleteEntity(cigar_net)
        cigar = false
    end
end)