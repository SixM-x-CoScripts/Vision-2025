--[[local TrainHeist = {
    ['startPeds'] = {},
    ['guardPeds'] = {},
    ['containers'] = {},
    ['collisions'] = {},
    ['locks'] = {},
    ['desks'] = {},
    ['attachments'] = {}
}
local TrainShared = {}

local PosHack = vector3(2329.1687011719, 2951.091796875, 47.159133911133)

TrainShared['TrainHeist'] = {
    ['requiredPoliceCount'] = 8, -- required police count for start heists
    ['nextRob'] = 3600, -- seconds for next heist (1h - 3600) (2h - 7200)
    ['reward'] = {
        itemName = 'gold-bar', -- gold item name
        grabCount = 25, -- gold grab count
        sellPrice = 150 -- buyer sell price
    },
    ['startHeist'] ={ -- heist start coords
        pos = vector3(-687.82, -2417.1, 13.9445),
        peds = {
            {pos = vector3(-686.43, -2417.5, 13.8945), heading = 23.22, ped = 's_m_m_highsec_01'},
            {pos = vector3(-687.82, -2417.1, 13.8945), heading = 320.78, ped = 's_m_m_highsec_02'},
        }
    },
    ['guardPeds'] = { -- guard ped list (you can add new)
            { coords = vector3(2850.67, 4535.49, 45.3924), heading = 270.87, model = 's_m_y_blackops_01'},
            { coords = vector3(2856.28, 4544.12, 45.3354), heading = 177.93, model = 's_m_y_blackops_01'},
            { coords = vector3(2869.90, 4530.26, 47.7877), heading = 354.93, model = 's_m_y_blackops_01'},
            { coords = vector3(2859.08, 4519.85, 47.9145), heading = 177.88, model = 's_m_y_blackops_01'},
            { coords = vector3(2843.78, 4521.66, 47.4138), heading = 268.28, model = 's_m_y_blackops_01'},
            { coords = vector3(2856.90, 4526.85, 48.6552), heading = 268.3, model = 's_m_y_blackops_01'},
    },
    ['finishHeist'] = { -- finish heist coords
        buyerPos = vector3(-1690.6, -916.19, 6.78323)
    },
    ['MaxAttachmentsOnTable'] = 5, -- Maximum attachments on 1 table.
    ['setupTrain'] = { -- train and containers coords
        pos = vector3(2872.028, 4544.253, 47.758),
        part = vector3(2883.305, 4557.646, 47.758),
        heading = 140.0,
        ['containers'] = {
            {
                pos = vector3(2885.97, 4560.83, 48.0551), 
                heading = 320.0, 
                lock = {pos = vector3(2884.76, 4559.38, 49.22561), taken = false},
                table = vector3(2886.55, 4561.53, 48.23),
                attachments = {
                    {object = "w_at_pi_supp", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2886.05, 4561.93, 49.13)},
                    {object = "w_at_pi_supp_2", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2887.05, 4561.13, 49.14)},
                    {object = "w_pi_sns_pistol_mag2", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2886.576, 4561.482, 49.13465)},
                    {object = "w_at_pi_flsh", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2886.621, 4561.051, 49.13465)},
                    {object = "w_at_pi_flsh_2", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2886.823, 4561.056, 49.13465)},
                    {object = "w_at_pi_snsmk2_flsh_1", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2887.008, 4561.533, 49.13465)},
                    {object = "w_at_pi_comp_1", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2887.032, 4560.707, 49.13465)},
                    {object = "w_at_pi_rail_1", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2885.78, 4561.994, 49.13465)},
                    {object = "w_at_pi_rail_2", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2887.447, 4561.104, 49.13465)},
                    {object = "w_at_ar_supp_02", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2886.417, 4561.833, 49.13465)},
                    {object = "w_at_pi_flsh_2", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2886.235, 4561.533, 49.13465)},
                    {object = "w_at_pi_supp_2", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2885.841, 4561.708, 49.13465)},
                    --{object = "w_sr_sniperrifle_luxe", rot = {90.0, -80.0, 120.0}, forcedrop = true, pos = vector3(2885.983, 4562.438, 49.26496)},
                },
            },
            {
                pos = vector3(2880.97, 4554.83, 48.0551), 
                heading = 140.0, 
                lock = {pos = vector3(2882.15, 4556.26, 49.22561), taken = false},
                table = vector3(2880.45, 4554.23, 48.23),
                attachments = {
                    {object = "w_pi_sns_pistolmk2_mag2", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2881.05, 4553.93, 49.14)},
                    {object = "w_at_pi_supp", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2880.25, 4554.63, 49.14)},
                    {object = "w_at_pi_supp", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2881.009, 4553.39, 49.13465)},
                    {object = "w_at_pi_supp", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2881.33, 4553.79, 49.13465)},
                    {object = "w_at_pi_supp", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2880.436, 4554.06, 49.13465)},
                    {object = "w_at_pi_supp", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2880.586, 4554.582, 49.13465)},
                    {object = "w_at_pi_supp", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2879.663, 4554.394, 49.13465)},
                    {object = "w_at_pi_supp", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2879.852, 4554.992, 49.13465)},
                    {object = "w_at_pi_supp", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2880.209, 4554.168, 49.13465)},
                    {object = "w_at_pi_supp", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2880.84, 4554.273, 49.13465)},
                    {object = "w_at_pi_supp", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2880.675, 4553.61, 49.13465)},
                    {object = "w_at_pi_supp", rot = {90.0, 0.0, 120.0}, forcedrop = true, pos = vector3(2879.871, 4554.674, 49.13465)},
                } 
            }
        }
    },
    ['AttachmentModels'] = {
        'w_at_pi_supp',
        'w_at_pi_supp_2',
        'w_pi_sns_pistol_mag2',
        'w_at_pi_flsh',
        'w_at_pi_flsh_2',
        'w_at_pi_snsmk2_flsh_1',
        'w_at_pi_comp_1',
        'w_at_pi_rail_1',
        'w_at_pi_rail_2',
        'w_at_ar_supp_02'
    }
}

TrainAnimation = {
    ['objects'] = {
        'tr_prop_tr_grinder_01a',
        'ch_p_m_bag_var02_arm_s'
    },
    ['animations'] = {
        {'action', 'action_container', 'action_lock', 'action_angle_grinder', 'action_bag'}
    },
    ['scenes'] = {},
    ['sceneObjects'] = {}
}

RegisterCommand("resetTrain", function()
    for k, v in pairs(TrainShared['TrainHeist']['setupTrain']['containers']) do
        DeleteEntity(TrainHeist['containers'][k])
        DeleteEntity(TrainHeist['collisions'][k])
        DeleteEntity(TrainHeist['locks'][k])
        DeleteEntity(TrainHeist['desks'][k])
        TriggerEvent('persistent-vehicles/forget-vehicle', mainTrain)
        TriggerEvent('persistent-vehicles/forget-vehicle', trainPart)
        DeleteVehicle(mainTrain)
        DeleteVehicle(trainPart)
        ClearArea(2885.97, 4560.83, 48.0551, 50.0)
    end
end)

CreateThread(function()
    if not DlcIllegal then return end
    while not zone do Wait(1) end 
    zone.addZone(
        "trainhack", -- Nom
        PosHack, -- Position
        "~INPUT_CONTEXT~ Catalogue", -- Text afficher
        function()
            StartTrainHeist()
        end,
        false, -- Avoir un marker ou non
        25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170,-- Alpha
        1.5,
        true,
        "bulleHacker"
    )
end)

local function SpawnGuards()
    local ped = PlayerPedId()
    TriggerSWEvent("TREFSDFD5156FD", "ADSFDF", 10000)
    Wait(2000)

    SetPedRelationshipGroupHash(ped, GetHashKey('PLAYER'))
    AddRelationshipGroup('GuardPeds')

    for k, v in pairs(TrainShared['TrainHeist']['guardPeds']) do
        loadModel(v['model'])
        TrainHeist['guardPeds'][k] = CreatePed(26, GetHashKey(v['model']), v['coords'], v['heading'], true, true)
        NetworkRegisterEntityAsNetworked(TrainHeist['guardPeds'][k])
        networkID = NetworkGetNetworkIdFromEntity(TrainHeist['guardPeds'][k])
        SetNetworkIdCanMigrate(networkID, true)
        SetNetworkIdExistsOnAllMachines(networkID, true)
        SetPedRandomComponentVariation(TrainHeist['guardPeds'][k], 0)
        SetPedRandomProps(TrainHeist['guardPeds'][k])
        SetEntityAsMissionEntity(TrainHeist['guardPeds'][k])
        SetEntityVisible(TrainHeist['guardPeds'][k], true)
        SetPedRelationshipGroupHash(TrainHeist['guardPeds'][k], GetHashKey("GuardPeds"))
        SetPedAccuracy(TrainHeist['guardPeds'][k], 80)
        --SetPedArmour(TrainHeist['guardPeds'][k], 100)
        SetPedCanSwitchWeapon(TrainHeist['guardPeds'][k], true)
        SetPedDropsWeaponsWhenDead(TrainHeist['guardPeds'][k], false)
        SetPedFleeAttributes(TrainHeist['guardPeds'][k], 0, false)
        GiveWeaponToPed(TrainHeist['guardPeds'][k], GetHashKey('WEAPON_CARBINERIFLE_MK2'), 255, false, false)
        SetPedCanRagdoll(TrainHeist['guardPeds'][k], false)
        SetPedSuffersCriticalHits(TrainHeist['guardPeds'][k], false)
        local random = math.random(1, 2)
        if random == 2 then
            TaskGuardCurrentPosition(TrainHeist['guardPeds'][k], 10.0, 10.0, 1)
        end
    end

    --CreatePedInsideVehicle(mainTrain, 4, GetHashKey("s_m_m_highsec_01"), )

    --SetMissionTrainCoords(mainTrain, TrainShared['TrainHeist']['setupTrain']['pos'])

    SetRelationshipBetweenGroups(0, GetHashKey("GuardPeds"), GetHashKey("GuardPeds"))
	SetRelationshipBetweenGroups(4, GetHashKey("GuardPeds"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(4, GetHashKey("PLAYER"), GetHashKey("GuardPeds"))
end

function loadTrainModels()
    local trainsAndCarriages = {
        'freight', 'metrotrain', 'freightcont1', 'freightcar', 
        'freightcar2', 'freightcont2', 'tankercar', 'freightgrain'
    }

    for _, vehicleName in ipairs(trainsAndCarriages) do
        local modelHashKey = GetHashKey(vehicleName)
        RequestModel(modelHashKey) -- load the model
        -- wait for the model to load
        while not HasModelLoaded(modelHashKey) do
            Citizen.Wait(500)
        end
    end
end

loadTrainModels()

function SetupTrain()
    local HasBraqued = false
    TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
    TriggerSWEvent("TREFSDFD5156FD", "VZEFDSF", 5000)
    loadModel('freight')
    loadModel('freightcar')
    loadModel('tr_prop_tr_container_01a')
    loadModel('prop_ld_container')
    loadModel('tr_prop_tr_lock_01a')
    loadModel('xm_prop_lab_desk_02')
    Wait(500)
    mainTrain = CreateMissionTrain(24, 1438.98, 6405.92, 34.19, true, false,false)
    --mainTrain = CreateMissionTrain(24, 2872.028, 4544.253, 47.758, true, true, true)
    RequestModel(GetHashKey("s_m_m_security_01"))
    while not HasModelLoaded(GetHashKey("s_m_m_security_01")) do Wait(1) end
    local conducteur = CreatePedInsideVehicle(mainTrain, 4, GetHashKey("s_m_m_security_01"), -1, 0, 1)
    FreezeEntityPosition(mainTrain, true)

    local blip = AddBlipForEntity(mainTrain)
    SetBlipSprite(blip, 795)
    SetBlipColour(blip, 5)
    SetBlipAsFriendly(blip, false)
    SetBlipDisplay(blip, 4)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName("Train")

    --for k, v in pairs(TrainShared['TrainHeist']['setupTrain']['containers']) do
    --    TrainHeist['containers'][k] = CreateObject(GetHashKey('tr_prop_tr_container_01a'), v['pos'], 1, 1, 0)
    --    SetEntityHeading(TrainHeist['containers'][k], v['heading'])
    --    FreezeEntityPosition(TrainHeist['containers'][k], true)
    --    Wait(math.random(100, 500))
    --    TrainHeist['collisions'][k] = CreateObject(GetHashKey('prop_ld_container'), v['pos'], 1, 1, 0)
    --    SetEntityHeading(TrainHeist['collisions'][k], v['heading'])
    --    SetEntityVisible(TrainHeist['collisions'][k], false)
    --    FreezeEntityPosition(TrainHeist['collisions'][k], true)
    --    Wait(math.random(100, 500))
    --    TrainHeist['locks'][k] = CreateObject(GetHashKey('tr_prop_tr_lock_01a'), v['lock']['pos'], 1, 1, 0)
    --    SetEntityHeading(TrainHeist['locks'][k], v['heading'])
    --    TrainHeist['desks'][k] = CreateObject(GetHashKey('xm_prop_lab_desk_02'), v['table'], 1, 1, 0)
    --    SetEntityHeading(TrainHeist['desks'][k], v['heading'])
    --    Wait(math.random(1000, 2000))
    --end

    while true do 
        Wait(1)
        if not HasBraqued then 
            if IsPedArmed(PlayerPedId()) then 
                if IsPlayerFreeAimingAtEntity(PlayerPedId(), conducteur) then 
                    PlayPain(conducteur, 6)
                    HasBraqued = true
                end
            end
        else

        end
    end

    --trainPart = CreateVehicle(GetHashKey('freightcar'), TrainShared['TrainHeist']['setupTrain']['part'], TrainShared['TrainHeist']['setupTrain']['heading'], 1, 0)
    --FreezeEntityPosition(mainTrain, true)
    --FreezeEntityPosition(trainPart, true)
    --for k, v in pairs(TrainShared['TrainHeist']['setupTrain']['containers']) do
    --    local tableattachments = 0
    --    for x, y in pairs(v['attachments']) do
    --        if math.random(1,2) == 1 and tableattachments < TrainShared['TrainHeist']['MaxAttachmentsOnTable'] then
    --            tableattachments = tableattachments + 1
    --            local model = TrainShared['TrainHeist']['AttachmentModels'][math.random(1, #TrainShared['TrainHeist']['AttachmentModels'])]
    --            loadModel(model) -- y['object']
    --            TrainHeist['attachments'][k..x] = CreateObject(GetHashKey(model), y['pos'], 1, 1, 0)
    --            SetEntityRotation(TrainHeist['attachments'][k..x], y['rot'][1], y['rot'][2], y['rot'][3])
    --            if y['forcedrop'] then
    --                ApplyForceToEntity(TrainHeist['attachments'][k..x])
    --            else
    --                PlaceObjectOnGroundProperly(TrainHeist['attachments'][k..x])
    --            end
    --            Wait(250)
    --            local objCoords = GetEntityCoords(TrainHeist['attachments'][k..x])
    --            local objHeading = GetEntityHeading(TrainHeist['attachments'][k..x])
    --            local data = {
    --                name = 'Trianloot'..k..x,
    --                objCoords = objCoords,
    --                objHeading = objHeading,
    --                object = model,
    --            }
    --         --   TriggerServerEvent("trainheist:server:spawn:attachment", data)
    --        end
    --    end
    --end
end

function StartTrainHeist()
    if p:haveItem("laptop") then
        HackAnimation()
        ambushBlip = addBlip(TrainShared['TrainHeist']['setupTrain']['pos'], 795, 1, "Cible : Train")
        repeat
            local ped = PlayerPedId()
            local pedCo = GetEntityCoords(ped)
            local dist = #(pedCo - TrainShared['TrainHeist']['setupTrain']['pos'])
            Wait(1)
        until dist <= 150.0
        SetupTrain()
        SpawnGuards()
        TriggerEvent("trainheist:client:trainLoop")
        SetNewWaypoint(TrainShared['TrainHeist']['setupTrain']['pos'].x, TrainShared['TrainHeist']['setupTrain']['pos'].y)
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Vous n'avez pas d'ordinateur"
        })
    end
end

RegisterNetEvent('trainheist:client:trainLoop')
AddEventHandler('trainheist:client:trainLoop', function()
    trainLoop = true
    robber = false
    while trainLoop do
        local ped = PlayerPedId()
        local pedCo = GetEntityCoords(ped)

        if robber then
            local trainDist = #(pedCo - TrainShared['TrainHeist']['setupTrain']['pos'])
            if trainDist >= 50.0 then
                TriggerServerEvent('trainheist:server:resetHeist')
                FinishHeist()
                break
            end
        end

        if IsEntityDead(ped) then
            break
        end

        for k, v in pairs(TrainShared['TrainHeist']['setupTrain']['containers']) do
            local dist = #(pedCo - v['lock']['pos'])
            if dist <= 1.5 and not v['lock']['taken'] then
                ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour ouvrir le conteneur")
                if IsControlJustPressed(0, 38) then
                    --if CurrentCops >= TrainShared['TrainHeist']['requiredPoliceCount'] then
                       OpenContainer(k) 
                    --else
                    --    Framework.Functions.Notify("Май, вече няма куки", "info")
                    --end
                end
            end
        end
        Wait(1)
    end
end)

function FinishHeist()
    RemoveBlip(ambushBlip)
    TriggerEvent('persistent-vehicles/forget-vehicle', mainTrain)
    TriggerEvent('persistent-vehicles/forget-vehicle', trainPart)
    DeleteVehicle(mainTrain)
    DeleteVehicle(trainPart)
    DeleteObject(TrainHeist['desks'][1])
    DeleteObject(TrainHeist['desks'][2])
    DeleteObject(TrainHeist['containers'][1])
    DeleteObject(TrainHeist['containers'][2])
    DeleteObject(TrainHeist['locks'][1])
    DeleteObject(TrainHeist['locks'][2])
    TriggerServerEvent('nocore-train:finish')
end

RegisterNetEvent('trainheist:client:resetHeist')
AddEventHandler('trainheist:client:resetHeist', function() 
    DeleteObject(clientContainer)
    DeleteObject(clientLock)
    DeleteObject(clientContainer2)
    DeleteObject(clientLock2)
    clientContainer, clientContainer2, clientLock, clientLock2 = nil, nil, nil, nil
    ClearArea(2885.97, 4560.83, 48.0551, 50.0)
    trainLoop = false
    RemoveBlip(ambushBlip)
    DeleteVehicle(mainTrain)
    DeleteVehicle(trainPart)
    DeleteObject(TrainHeist['desks'][1])
    DeleteObject(TrainHeist['desks'][2])
    DeleteObject(TrainHeist['containers'][1])
    DeleteObject(TrainHeist['containers'][2])
    DeleteObject(TrainHeist['locks'][1])
    DeleteObject(TrainHeist['locks'][2])
    TriggerServerEvent('nocore-train:finish')
end)


function OpenContainer(index)
    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)
    local pedRotation = GetEntityRotation(ped)
    local animDict = 'anim@scripted@player@mission@tunf_train_ig1_container_p1@male@'
    loadAnimDict(animDict)
    loadPtfxAsset('scr_tn_tr')
    TriggerServerEvent('trainheist:server:lockSync', index)
    
    for i = 1, #TrainAnimation['objects'] do
        loadModel(TrainAnimation['objects'][i])
        TrainAnimation['sceneObjects'][i] = CreateObject(GetHashKey(TrainAnimation['objects'][i]), pedCo, 1, 1, 0)
    end

    sceneObject = GetClosestObjectOfType(pedCo, 2.5, GetHashKey('tr_prop_tr_container_01a'), 0, 0, 0)
    lockObject = GetClosestObjectOfType(pedCo, 2.5, GetHashKey('tr_prop_tr_lock_01a'), 0, 0, 0)
    NetworkRegisterEntityAsNetworked(sceneObject)
    NetworkRegisterEntityAsNetworked(lockObject)

    scene = NetworkCreateSynchronisedScene(GetEntityCoords(sceneObject), GetEntityRotation(sceneObject), 2, true, false, 1065353216, 0, 1065353216)

    NetworkAddPedToSynchronisedScene(ped, scene, animDict, TrainAnimation['animations'][1][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(sceneObject, scene, animDict, TrainAnimation['animations'][1][2], 1.0, -1.0, 1148846080)
    NetworkAddEntityToSynchronisedScene(lockObject, scene, animDict, TrainAnimation['animations'][1][3], 1.0, -1.0, 1148846080)
    NetworkAddEntityToSynchronisedScene(TrainAnimation['sceneObjects'][1], scene, animDict, TrainAnimation['animations'][1][4], 1.0, -1.0, 1148846080)
    NetworkAddEntityToSynchronisedScene(TrainAnimation['sceneObjects'][2], scene, animDict, TrainAnimation['animations'][1][5], 1.0, -1.0, 1148846080)

    SetEntityCoords(ped, GetEntityCoords(sceneObject))
    NetworkStartSynchronisedScene(scene)
    Wait(4000)
    UseParticleFxAssetNextCall('scr_tn_tr')
    sparks = StartParticleFxLoopedOnEntity("scr_tn_tr_angle_grinder_sparks", TrainAnimation['sceneObjects'][1], 0.0, 0.25, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false, 1065353216, 1065353216, 1065353216, 1)
    Wait(1000)
    StopParticleFxLooped(sparks, 1)
    Wait(GetAnimDuration(animDict, 'action') * 1000 - 5000)
    --TriggerServerEvent('trainheist:server:containerSync', GetEntityCoords(sceneObject), GetEntityRotation(sceneObject))
    --TriggerServerEvent('trainheist:server:objectSync', NetworkGetNetworkIdFromEntity(sceneObject))
    --TriggerServerEvent('trainheist:server:objectSync', NetworkGetNetworkIdFromEntity(lockObject))
    DeleteObject(TrainAnimation['sceneObjects'][1])
    DeleteObject(TrainAnimation['sceneObjects'][2])
    ClearPedTasks(ped)
end

function playerAnim()
	RequestAnimDict( "pickup_object" )
    while not HasAnimDictLoaded("pickup_object") do Wait(1) end
    TaskPlayAnim( PlayerPedId(), "pickup_object", "putdown_low", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
end

RegisterNetEvent('trainheist:client:spawn:attachment')
AddEventHandler('trainheist:client:spawn:attachment', function(data)
    exports['nocore-eye']:AddBoxZone(data.name, vector3(data.objCoords.x, data.objCoords.y, data.objCoords.z), 0.2, 0.2, {
        name = data.name,
        heading = data.objHeading,
        debugPoly = false,
        minZ = data.objCoords.z - 0.2,
        maxZ = data.objCoords.z + 0.2
    }, {
        options = {
          {
            event = "trainheist:client:get:attachment",
            icon = "fas fa-handshake",
            object = data.object,
            name = data.name,
            objCoords = data.objCoords,
            objHeading = data.objHeading,
            label = "Вземи"
          }
        },
        distance = 2.5
    })
end)


RegisterNetEvent('trainheist:client:get:attachment')
AddEventHandler('trainheist:client:get:attachment', function(data)
    local Data = data
    TriggerServerEvent('trainheist:server:remove:attachment', data.name)
    playerAnim()
    Framework.Functions.Progressbar('pickup', 'Взимате предмета..', math.random(1000, 3000), false, false, {
     disableMovement = true,
     disableCarMovement = true,
     disableMouse = false,
     disableCombat = true,
     disableInventory = true,
    }, {}, {}, {}, function() -- Done
        local entity = GetClosestObjectOfType(data.objCoords.x, data.objCoords.y, data.objCoords.z, 1.0, GetHashKey(data.object))
        if entity == 0 then print('Prop does not exist') return end
        Framework.Functions.TriggerCallback('trainheist:server:GetRreward', function(cb)
            if cb then
                NetworkRequestControlOfEntity(entity)
                while not NetworkHasControlOfEntity(entity) do Citizen.Wait(1) end
                DeleteEntity(entity)
                robber = true
            else
                TriggerServerEvent("trainheist:server:spawn:attachment", Data)
                Framework.Functions.Notify('Нямате достатъчно място.', 'error', 5000, 'Error')
            end
        end, data.object)
    end, function() -- Cancel
    end)
end)

RegisterNetEvent('trainheist:client:remove:attachment')
AddEventHandler('trainheist:client:remove:attachment', function(name)
    exports['nocore-eye']:RemoveZone(name)
end)

RegisterNetEvent('trainheist:client:lockSync')
AddEventHandler('trainheist:client:lockSync', function(index)
    TrainShared['TrainHeist']['setupTrain']['containers'][index]['lock']['taken'] = not TrainShared['TrainHeist']['setupTrain']['containers'][index]['lock']['taken']
end)

RegisterNetEvent('trainheist:client:objectSync')
AddEventHandler('trainheist:client:objectSync', function(e)
    local entity = NetworkGetEntityFromNetworkId(e)
    DeleteEntity(entity)
    DeleteObject(entity)
end)

RegisterNetEvent('trainheist:client:containerSync')
AddEventHandler('trainheist:client:containerSync', function(coords, rotation)
    animDict = 'anim@scripted@player@mission@tunf_train_ig1_container_p1@male@'
    exports['nocore-assets']:RequestAnimationDict(animDict)

    if clientContainer and clientLock then
        clientContainer2 = CreateObject(GetHashKey('tr_prop_tr_container_01a'), coords, 0, 0, 0)
        clientLock2 = CreateObject(GetHashKey('tr_prop_tr_lock_01a'), coords, 0, 0, 0)
        
        clientScene = CreateSynchronizedScene(coords, rotation, 2, true, false, 1065353216, 0, 1065353216)
        PlaySynchronizedEntityAnim(clientContainer2, clientScene, TrainAnimation['animations'][1][2], animDict, 1.0, -1.0, 0, 1148846080)
        ForceEntityAiAndAnimationUpdate(clientContainer2)
        PlaySynchronizedEntityAnim(clientLock2, clientScene, TrainAnimation['animations'][1][3], animDict, 1.0, -1.0, 0, 1148846080)
        ForceEntityAiAndAnimationUpdate(clientLock2)

        SetSynchronizedScenePhase(clientScene, 0.99)
        SetEntityCollision(clientContainer2, false, true)
        FreezeEntityPosition(clientContainer2, true)
    else
        clientContainer = CreateObject(GetHashKey('tr_prop_tr_container_01a'), coords, 0, 0, 0)
        clientLock = CreateObject(GetHashKey('tr_prop_tr_lock_01a'), coords, 0, 0, 0)
        
        clientScene = CreateSynchronizedScene(coords, rotation, 2, true, false, 1065353216, 0, 1065353216)
        PlaySynchronizedEntityAnim(clientContainer, clientScene, TrainAnimation['animations'][1][2], animDict, 1.0, -1.0, 0, 1148846080)
        ForceEntityAiAndAnimationUpdate(clientContainer)
        PlaySynchronizedEntityAnim(clientLock, clientScene, TrainAnimation['animations'][1][3], animDict, 1.0, -1.0, 0, 1148846080)
        ForceEntityAiAndAnimationUpdate(clientLock)

        SetSynchronizedScenePhase(clientScene, 0.99)
        SetEntityCollision(clientContainer, false, true)
        FreezeEntityPosition(clientContainer, true)
    end
end)

function addBlip(coords, sprite, colour, text)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.8)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
    return blip
end

function loadPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        RequestNamedPtfxAsset(dict)
        Citizen.Wait(50)
	end
end

function loadModel(model)
    if type(model) ~= 'number' then
        model = GetHashKey(model)
    end
    
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
end

RegisterNetEvent('trainheist:client:showNotification')
AddEventHandler('trainheist:client:showNotification', function(str)
    ShowNotification(str)
end)

function FinishTrauub(coords)
    if coords then
        local tripped = false
        repeat
            Wait(0)
            if (timer and (GetCutsceneTime() > timer))then
                DoScreenFadeOut(250)
                tripped = true
            end
            if (GetCutsceneTotalDuration() - GetCutsceneTime() <= 250) then
            DoScreenFadeOut(250)
            tripped = true
            end
        until not IsCutscenePlaying()
        if (not tripped) then
            DoScreenFadeOut(100)
            Wait(150)
        end
        return
    else
        Wait(18500)
        StopCutsceneImmediately()
    end
end

AddEventHandler('onResourceStop', function (resource)
    if resource == GetCurrentResourceName() then
        TriggerEvent('persistent-vehicles/forget-vehicle', mainTrain)
        TriggerEvent('persistent-vehicles/forget-vehicle', trainPart)
        DeleteVehicle(mainTrain)
        DeleteVehicle(trainPart)
        ClearArea(2885.97, 4560.83, 48.0551, 50.0)
    end
end)]]