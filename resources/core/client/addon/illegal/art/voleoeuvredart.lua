--[[local busy = false
RegisterCommand("voleArt", function()
   -- TriggerEvent("vangelicoheist:client:resetHeist")
   -- Wait(500)
   -- VangelicoSetup()
   -- Wait(500)
    local found = false
    for k, v in pairs(VangelicoHeist['painting']) do
        local dist = #(GetEntityCoords(PlayerPedId()) - v['objectPos'])

        if dist <= 1.5 and not v['loot'] and not busy then
            found = true
            PaintingScene(k)
        end
    end
    if not found then 
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = 'Vous êtes trop loin d\'un tableau'
        })
    end
end)

RegisterCommand("setupArt", function()
    TriggerEvent("vangelicoheist:client:resetHeist")
    Wait(500)
    VangelicoSetup()
end)

RegisterCommand("heatScene", function()
    OverheatScene()
end)

RegisterCommand("resetHeist", function()
    TriggerEvent("vangelicoheist:client:resetHeist")
end)

local StoredItems = {}
RegisterNetEvent('vangelicoheist:client:resetHeist')
AddEventHandler('vangelicoheist:client:resetHeist', function()
    insideLoop = false
    gasLoop = false
    for k, v in pairs(VangelicoHeist['painting']) do
        v['loot'] = false
        object = GetClosestObjectOfType(v['objectPos'], 1.0, GetHashKey(v['object']), 0, 0, 0)
        DeleteObject(object)
    end
    VangelicoHeist['glassCutting']['loot'] = false
    glassObjectDel = GetClosestObjectOfType(-617.4622, -227.4347, 37.057, 1.0, GetHashKey('h4_prop_h4_glass_disp_01a'), 0, 0, 0)
    glassObjectDel2 = GetClosestObjectOfType(-617.4622, -227.4347, 37.057, 1.0, GetHashKey('h4_prop_h4_glass_disp_01b'), 0, 0, 0)
    DeleteObject(glassObjectDel)
    DeleteObject(glassObjectDel2)
    StopParticleFxLooped(ptfx, 1)
    for k,v in pairs(StoredItems) do 
        if v then 
            DeleteObject(v)
        end
    end
end)

local VangelicoHeist2 = {
    ['startPeds'] = {},
    ['painting'] = {},
    ['gasMask'] = false,
    ['globalObject'] = nil,
    ['globalItem'] = nil,
}
local ArtHeist = {
    ['objects'] = {
        'hei_p_m_bag_var22_arm_s',
        'w_me_switchblade'
    },
    ['animations'] = { 
        {"top_left_enter", "top_left_enter_ch_prop_ch_sec_cabinet_02a", "top_left_enter_ch_prop_vault_painting_01a", "top_left_enter_hei_p_m_bag_var22_arm_s", "top_left_enter_w_me_switchblade"},
        {"cutting_top_left_idle", "cutting_top_left_idle_ch_prop_ch_sec_cabinet_02a", "cutting_top_left_idle_ch_prop_vault_painting_01a", "cutting_top_left_idle_hei_p_m_bag_var22_arm_s", "cutting_top_left_idle_w_me_switchblade"},
        {"cutting_top_left_to_right", "cutting_top_left_to_right_ch_prop_ch_sec_cabinet_02a", "cutting_top_left_to_right_ch_prop_vault_painting_01a", "cutting_top_left_to_right_hei_p_m_bag_var22_arm_s", "cutting_top_left_to_right_w_me_switchblade"},
        {"cutting_top_right_idle", "_cutting_top_right_idle_ch_prop_ch_sec_cabinet_02a", "cutting_top_right_idle_ch_prop_vault_painting_01a", "cutting_top_right_idle_hei_p_m_bag_var22_arm_s", "cutting_top_right_idle_w_me_switchblade"},
        {"cutting_right_top_to_bottom", "cutting_right_top_to_bottom_ch_prop_ch_sec_cabinet_02a", "cutting_right_top_to_bottom_ch_prop_vault_painting_01a", "cutting_right_top_to_bottom_hei_p_m_bag_var22_arm_s", "cutting_right_top_to_bottom_w_me_switchblade"},
        {"cutting_bottom_right_idle", "cutting_bottom_right_idle_ch_prop_ch_sec_cabinet_02a", "cutting_bottom_right_idle_ch_prop_vault_painting_01a", "cutting_bottom_right_idle_hei_p_m_bag_var22_arm_s", "cutting_bottom_right_idle_w_me_switchblade"},
        {"cutting_bottom_right_to_left", "cutting_bottom_right_to_left_ch_prop_ch_sec_cabinet_02a", "cutting_bottom_right_to_left_ch_prop_vault_painting_01a", "cutting_bottom_right_to_left_hei_p_m_bag_var22_arm_s", "cutting_bottom_right_to_left_w_me_switchblade"},
        {"cutting_bottom_left_idle", "cutting_bottom_left_idle_ch_prop_ch_sec_cabinet_02a", "cutting_bottom_left_idle_ch_prop_vault_painting_01a", "cutting_bottom_left_idle_hei_p_m_bag_var22_arm_s", "cutting_bottom_left_idle_w_me_switchblade"},
        {"cutting_left_top_to_bottom", "cutting_left_top_to_bottom_ch_prop_ch_sec_cabinet_02a", "cutting_left_top_to_bottom_ch_prop_vault_painting_01a", "cutting_left_top_to_bottom_hei_p_m_bag_var22_arm_s", "cutting_left_top_to_bottom_w_me_switchblade"},
        {"with_painting_exit", "with_painting_exit_ch_prop_ch_sec_cabinet_02a", "with_painting_exit_ch_prop_vault_painting_01a", "with_painting_exit_hei_p_m_bag_var22_arm_s", "with_painting_exit_w_me_switchblade"},
    },
    ['scenes'] = {},
    ['sceneObjects'] = {}
}
local Overheat = {
    ['objects'] = {
        'hei_p_m_bag_var22_arm_s',
        'h4_prop_h4_cutter_01a',
    },
    ['animations'] = {
        {'enter', 'enter_bag', 'enter_cutter', 'enter_glass_display'},
        {'idle', 'idle_bag', 'idle_cutter', 'idle_glass_display'},
        {'cutting_loop', 'cutting_loop_bag', 'cutting_loop_cutter', 'cutting_loop_glass_display'},
        {'overheat_react_01', 'overheat_react_01_bag', 'overheat_react_01_cutter', 'overheat_react_01_glass_display'},
        {'success', 'success_bag', 'success_cutter', 'success_glass_display_cut'},
    },
    ['scenes'] = {},
    ['sceneObjects'] = {},
}

VangelicoHeist = {
    ['glassCutting'] = {
        displayPos = vector3(-617.4622, -227.4347, 37.057),
        displayHeading = -53.06,
        rewardPos = vector3(-617.4622, -227.4347, 38.0861),
        rewardRot = vector3(360.0, 0.0, 70.0),
        rewards = {
            {
                object = {model = 'h4_prop_h4_diamond_01a', rot = -53.06},
                displayObj = {model = 'h4_prop_h4_diamond_disp_01a', rot = vector3(360.0, 0.0, 70.0)},
                item = 'diamant2carats',
                price = 320,
            },
            {
                object = {model = 'h4_prop_h4_art_pant_01a', rot = -53.06},
                displayObj = {model = 'h4_prop_h4_diamond_disp_01a', rot = vector3(360.0, 0.0, 70.0)},
                item = 'diamant2carats',
                price = 320,
            },
            {
                object = {model = 'h4_prop_h4_necklace_01a', rot = -53.06},
                displayObj = {model = 'h4_prop_h4_neck_disp_01a', rot = vector3(360.0, 0.0, -60.0)},
                item = 'diamant2carats',
                price = 320,
            },
            {
                object = {model = 'h4_prop_h4_t_bottle_02b', rot = -53.06},
                displayObj = {model = 'h4_prop_h4_diamond_disp_01a', rot = vector3(360.0, 0.0, 70.0)},
                item = 'diamant2carats',
                price = 320,
            },
        }
    },
    ['painting'] = {
        {
            rewardItem = 'peinture', -- u need add item to database
            paintingPrice = '300', -- price of the reward item for sell
            scenePos = vector3(-626.70, -228.3, 38.06), -- animation coords
            sceneRot = vector3(0.0, 0.0, 90.0), -- animation rotation
            object = 'ch_prop_vault_painting_01g', -- object (https://mwojtasik.dev/tools/gtav/objects/search?name=ch_prop_vault_painting_01)
            objectPos = vector3(-627.20, -228.31, 38.06), -- object spawn coords
            objHeading = 94.75 -- object spawn heading
        },
        {
            rewardItem = 'peinture',
            paintingPrice = '300', 
            scenePos = vector3(-622.97, -225.54, 38.06), 
            sceneRot = vector3(0.0, 0.0, -20.0),
            object = 'ch_prop_vault_painting_01f', 
            objectPos = vector3(-622.80, -225.14, 38.06), 
            objHeading = 345.85
        },
        {
            rewardItem = 'peinture',
            paintingPrice = '300', 
            scenePos = vector3(-617.48, -233.22, 38.06), 
            sceneRot = vector3(0.0, 0.0, -90.0),
            object = 'ch_prop_vault_painting_01h', 
            objectPos = vector3(-617.00, -233.22, 38.06), 
            objHeading = 269.53
        },
        {
            rewardItem = 'peinture',
            paintingPrice = '300', 
            scenePos = vector3(-621.25, -235.78, 38.06), 
            sceneRot = vector3(0.0, 0.0, 160.0),
            object = 'ch_prop_vault_painting_01j', 
            objectPos = vector3(-621.25, -236.38, 38.06), 
            objHeading = 161.22
        },
    }
}

RegisterNetEvent('vangelicoheist:client:lootSync')
AddEventHandler('vangelicoheist:client:lootSync', function(type, index)
    if index then
        VangelicoHeist[type][index]['loot'] = true
    else
        VangelicoHeist[type]['loot'] = true
    end
end)

CreateThread(function()
    VangelicoSetup()
end)

local function loadModel(prop)
    RequestModel(GetHashKey(prop))
    while not HasModelLoaded(GetHashKey(prop)) do 
        Wait(1)
    end
end

function VangelicoSetup()
    local random = math.random(1, 4)
    local glassConfig = VangelicoHeist['glassCutting']
    loadModel(glassConfig['rewards'][random]['object']['model'])
    loadModel(glassConfig['rewards'][random]['displayObj']['model'])
    loadModel('h4_prop_h4_glass_disp_01a')
    local glass = CreateObject(GetHashKey('h4_prop_h4_glass_disp_01a'), -617.4622, -227.4347, 37.057, 1, 1, 0)
    SetEntityHeading(glass, -53.06)
    local reward = CreateObject(GetHashKey(glassConfig['rewards'][random]['object']['model']), glassConfig['rewardPos'].xy, glassConfig['rewardPos'].z + 0.195, 1, 1, 0)
    SetEntityHeading(reward, glassConfig['rewards'][random]['object']['rot'])
    local rewardDisp = CreateObject(GetHashKey(glassConfig['rewards'][random]['displayObj']['model']), glassConfig['rewardPos'], 1, 1, 0)
    SetEntityRotation(rewardDisp, glassConfig['rewards'][random]['displayObj']['rot'])
    table.insert(StoredItems, reward)
    table.insert(StoredItems, rewardDisp)

    for k, v in pairs(VangelicoHeist['painting']) do
        loadModel(v['object'])
        VangelicoHeist2['painting'][k] = CreateObjectNoOffset(GetHashKey(v['object']), v['objectPos'], 1, 0, 0)
        SetEntityRotation(VangelicoHeist2['painting'][k], 0, 0, v['objHeading'], 2, true)
    end
end

function PaintingScene(sceneId)
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    --if weapon == GetHashKey('WEAPON_SWITCHBLADE') or weapon == GetHashKey('weapon_dagger') or weapon == GetHashKey('WEAPON_KNIFE') then 
        TriggerServerEvent('vangelicoheist:server:lootSync', 'painting', sceneId)
        robber = true
        busy = true
        local pedCo, pedRotation = GetEntityCoords(ped), vector3(0.0, 0.0, 0.0)
        local scenes = {false, false, false, false}
        local animDict = "anim_heist@hs3f@ig11_steal_painting@male@"
        scene = VangelicoHeist['painting'][sceneId]
        sceneObject = GetClosestObjectOfType(scene['objectPos'], 1.0, GetHashKey(scene['object']), 0, 0, 0)
        scenePos = scene['scenePos']
        sceneRot = scene['sceneRot']
        loadAnimDict(animDict)
        
        for k, v in pairs(ArtHeist['objects']) do
            loadModel(v)
            ArtHeist['sceneObjects'][k] = CreateObject(GetHashKey(v), pedCo, 1, 1, 0)
        end
        
        for i = 1, 10 do
            ArtHeist['scenes'][i] = NetworkCreateSynchronisedScene(scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 2, true, false, 1065353216, 0, 1065353216)
            NetworkAddPedToSynchronisedScene(ped, ArtHeist['scenes'][i], animDict, 'ver_01_' .. ArtHeist['animations'][i][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
            NetworkAddEntityToSynchronisedScene(sceneObject, ArtHeist['scenes'][i], animDict, 'ver_01_' .. ArtHeist['animations'][i][3], 1.0, -1.0, 1148846080)
            NetworkAddEntityToSynchronisedScene(ArtHeist['sceneObjects'][1], ArtHeist['scenes'][i], animDict, 'ver_01_' .. ArtHeist['animations'][i][4], 1.0, -1.0, 1148846080)
            NetworkAddEntityToSynchronisedScene(ArtHeist['sceneObjects'][2], ArtHeist['scenes'][i], animDict, 'ver_01_' .. ArtHeist['animations'][i][5], 1.0, -1.0, 1148846080)
        end

        cam = CreateCam("DEFAULT_ANIMATED_CAMERA", true)
        SetCamActive(cam, true)
        RenderScriptCams(true, 0, 3000, 1, 0)
        
        ArtHeist['cuting'] = true
        FreezeEntityPosition(ped, true)
        NetworkStartSynchronisedScene(ArtHeist['scenes'][1])
        PlayCamAnim(cam, 'ver_01_top_left_enter_cam_ble', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
        Wait(3000)
        NetworkStartSynchronisedScene(ArtHeist['scenes'][2])
        PlayCamAnim(cam, 'ver_01_cutting_top_left_idle_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
        repeat
            ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour couper vers la droite")
            if IsControlJustPressed(0, 38) then
                scenes[1] = true
            end
            Wait(1)
        until scenes[1] == true
        NetworkStartSynchronisedScene(ArtHeist['scenes'][3])
        PlayCamAnim(cam, 'ver_01_cutting_top_left_to_right_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
        Wait(3000)
        NetworkStartSynchronisedScene(ArtHeist['scenes'][4])
        PlayCamAnim(cam, 'ver_01_cutting_top_right_idle_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
        repeat
            ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour couper vers le bas")
            if IsControlJustPressed(0, 38) then
                scenes[2] = true
            end
            Wait(1)
        until scenes[2] == true
        NetworkStartSynchronisedScene(ArtHeist['scenes'][5])
        PlayCamAnim(cam, 'ver_01_cutting_right_top_to_bottom_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
        Wait(3000)
        NetworkStartSynchronisedScene(ArtHeist['scenes'][6])
        PlayCamAnim(cam, 'ver_01_cutting_bottom_right_idle_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
        repeat
            ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour couper vers la gauche")
            if IsControlJustPressed(0, 38) then
                scenes[3] = true
            end
            Wait(1)
        until scenes[3] == true
        NetworkStartSynchronisedScene(ArtHeist['scenes'][7])
        PlayCamAnim(cam, 'ver_01_cutting_bottom_right_to_left_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
        Wait(3000)
        repeat
            ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour couper vers le bas")
            if IsControlJustPressed(0, 38) then
                scenes[4] = true
            end
            Wait(1)
        until scenes[4] == true
        NetworkStartSynchronisedScene(ArtHeist['scenes'][9])
        PlayCamAnim(cam, 'ver_01_cutting_left_top_to_bottom_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
        Wait(1500)
        NetworkStartSynchronisedScene(ArtHeist['scenes'][10])
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        Wait(7500)
        TriggerServerEvent('vangelicoheist:server:rewardItem', scene['rewardItem'])
        ClearPedTasks(ped)
        FreezeEntityPosition(ped, false)
        RemoveAnimDict(animDict)
        for k, v in pairs(ArtHeist['sceneObjects']) do
            DeleteObject(v)
        end
        DeleteObject(sceneObject)
        DeleteEntity(sceneObject)
        ArtHeist['sceneObjects'] = {}
        ArtHeist['scenes'] = {}
        scenes = {false, false, false, false}
        busy = false        
    --else
    --    exports['vNotif']:createNotification({
    --        type = 'ROUGE',
    --        -- duration = 5, -- In seconds, default:  4
    --        content = 'Vous avez besoin d\'un couteau'
    --    })
    --    return
    --end
end

function loadModel(model)
    if type(model) == 'number' then
        model = model
    else
        model = GetHashKey(model)
    end
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(0)
    end
end

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(50)
    end
end
function loadPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        RequestNamedPtfxAsset(dict)
        Wait(50)
    end
end


function OverheatScene()
    TriggerServerEvent('vangelicoheist:server:lootSync', 'glassCutting')
    robber = true
    busy = true
    local ped = PlayerPedId()
    local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
    local animDict = 'anim@scripted@heist@ig16_glass_cut@male@'
    sceneObject = GetClosestObjectOfType(-617.4622, -227.4347, 37.057, 1.0, GetHashKey('h4_prop_h4_glass_disp_01a'), 0, 0, 0)
    scenePos = GetEntityCoords(sceneObject)
    sceneRot = GetEntityRotation(sceneObject)
    globalObj = GetClosestObjectOfType(-617.4622, -227.4347, 37.057, 5.0, GetHashKey(VangelicoHeist['globalObject']), 0, 0, 0)
    loadAnimDict(animDict)
    RequestScriptAudioBank('DLC_HEI4/DLCHEI4_GENERIC_01', -1)

    for k, v in pairs(Overheat['objects']) do
        loadModel(v)
        Overheat['sceneObjects'][k] = CreateObject(GetHashKey(v), pedCo, 1, 1, 0)
    end

    cam = CreateCam("DEFAULT_ANIMATED_CAMERA", true)
    SetCamActive(cam, true)
    RenderScriptCams(true, 0, 3000, 1, 0)

    local newObj = CreateObject(GetHashKey('h4_prop_h4_glass_disp_01b'), GetEntityCoords(sceneObject), 1, 1, 0)
    SetEntityHeading(newObj, GetEntityHeading(sceneObject))

    for i = 1, #Overheat['animations'] do
        Overheat['scenes'][i] = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, true, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, Overheat['scenes'][i], animDict, Overheat['animations'][i][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
        NetworkAddEntityToSynchronisedScene(Overheat['sceneObjects'][1], Overheat['scenes'][i], animDict, Overheat['animations'][i][2], 1.0, -1.0, 1148846080)
        NetworkAddEntityToSynchronisedScene(Overheat['sceneObjects'][2], Overheat['scenes'][i], animDict, Overheat['animations'][i][3], 1.0, -1.0, 1148846080)
        if i ~= 5 then
            NetworkAddEntityToSynchronisedScene(sceneObject, Overheat['scenes'][i], animDict, Overheat['animations'][i][4], 1.0, -1.0, 1148846080)
        else
            NetworkAddEntityToSynchronisedScene(newObj, Overheat['scenes'][i], animDict, Overheat['animations'][i][4], 1.0, -1.0, 1148846080)
        end
    end

    local sound1 = GetSoundId()
    local sound2 = GetSoundId()

    NetworkStartSynchronisedScene(Overheat['scenes'][1])
    PlayCamAnim(cam, 'enter_cam', animDict, scenePos, sceneRot, 0, 2)
    Wait(GetAnimDuration(animDict, 'enter') * 1000)

    NetworkStartSynchronisedScene(Overheat['scenes'][2])
    PlayCamAnim(cam, 'idle_cam', animDict, scenePos, sceneRot, 0, 2)
    Wait(GetAnimDuration(animDict, 'idle') * 1000)

    NetworkStartSynchronisedScene(Overheat['scenes'][3])
    PlaySoundFromEntity(sound1, "StartCutting", Overheat['sceneObjects'][2], 'DLC_H4_anims_glass_cutter_Sounds', true, 80)
    loadPtfxAsset('scr_ih_fin')
    UseParticleFxAssetNextCall('scr_ih_fin')
    fire1 = StartParticleFxLoopedOnEntity('scr_ih_fin_glass_cutter_cut', Overheat['sceneObjects'][2], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1065353216, 0.0, 0.0, 0.0, 1065353216, 1065353216, 1065353216, 0)
    PlayCamAnim(cam, 'cutting_loop_cam', animDict, scenePos, sceneRot, 0, 2)
    Wait(GetAnimDuration(animDict, 'cutting_loop') * 1000)
    StopSound(sound1)
    StopParticleFxLooped(fire1)

    NetworkStartSynchronisedScene(Overheat['scenes'][4])
    PlaySoundFromEntity(sound2, "Overheated", Overheat['sceneObjects'][2], 'DLC_H4_anims_glass_cutter_Sounds', true, 80)
    UseParticleFxAssetNextCall('scr_ih_fin')
    fire2 = StartParticleFxLoopedOnEntity('scr_ih_fin_glass_cutter_overheat', Overheat['sceneObjects'][2], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1065353216, 0.0, 0.0, 0.0)
    PlayCamAnim(cam, 'overheat_react_01_cam', animDict, scenePos, sceneRot, 0, 2)
    Wait(GetAnimDuration(animDict, 'overheat_react_01') * 1000)
    StopSound(sound2)
    StopParticleFxLooped(fire2)

    DeleteObject(sceneObject)
    NetworkStartSynchronisedScene(Overheat['scenes'][5])
    Wait(2000)
    for k,v in pairs(StoredItems) do 
        DeleteObject(v)
    end
   -- DeleteObject(globalObj)
    StoredItems = {}
    PlayCamAnim(cam, 'success_cam', animDict, scenePos, sceneRot, 0, 2)
    Wait(GetAnimDuration(animDict, 'success') * 1000 - 2000)
    DeleteObject(Overheat['sceneObjects'][1])
    DeleteObject(Overheat['sceneObjects'][2])
    ClearPedTasks(ped)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    busy = false
end]]