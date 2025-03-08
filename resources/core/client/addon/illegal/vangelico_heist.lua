--local token = nil
--TriggerEvent("core:RequestTokenAcces", "core", function(t)
--    token = t
--end)

--TODO: add les items

hasAlreadyTaken = false
local vangelicoHeist = {
    ["globalObj"] = nil,
    ['globalItem'] = nil,
}
local alarmeOff = false
local insideLoop = false
local busy = false
local prevAnim = ''
local hasfondu = false
local blip = {}
local blip2 = {}
local VangelicoHeist2 = {
    ['startPeds'] = {},
    ['painting'] = {},
    ['gasMask'] = false,
    ['globalObject'] = nil,
    ['globalItem'] = nil,
}

local reward = nil
local glass = nil
local rewardDisp = nil
local glassConfig = vangelico_config["glassCutting"]
local HasBraqued = false

function StartVangelicoHeist()
    HasBraqued = false
    --while not next(vAdminVariables) do Wait(1) print("Waiting Variables") end
    --print("GetVariable(heist)", GetVariable("heist"))
    local varVang = GetVariable("heist").vangelico
    --local varVang = {active ="true", cops = 0, xp = 10, CaisseWinMin = 200, CaisseWinMax = 500}
    local isBraqued = TriggerServerCallback("core:getIfAlrdyRobbed")
    if not varVang.active == "true" then return end
    if not isBraqued and not alarmeOff then
        local policeMans = tonumber(getNumberOfCopsInDuty())
        --local policeMans = 0
        if policeMans >= (tonumber(varVang.cops) or 3) then
            if p:haveItem("laptop") then
                Bulle.hide("vangelico_heist")
                local bool = HackAnimation()
                while bool == nil do 
                    Wait(1)
                end
                if bool == true then
                    if Serveur == "FA" then
                        OpenTutoFAInfo("Braquage Vangelico", "Brise les vitres, vole la caisse et les tableaux")
                    elseif Serveur == "WL" then
                        OpenTutoWLInfo("Braquage Vangelico", "Brise les vitres, vole la caisse et les tableaux")
                    end
                    TriggerServerEvent("core:RemoveItemToInventory", token, "laptop", 1, {})

                    Bulle.hide("vangelico_heist")
                    TriggerSecurEvent('core:makeCall', "lspd",
                        vector3(-633.33001708984, -238.84931945801, 38.069793701172), true,
                        "Braquage de bijouterie")
                    TriggerSecurEvent('core:makeCall', "lssd",
                        vector3(-633.33001708984, -238.84931945801, 38.069793701172), true,
                        "Braquage de bijouterie")
                    -- ShowNotification("~r~L'alarme a été déclenchée, la police arrive !")
                    alarmeOff = true
                    TriggerSecurEvent("core:crew:updateXp", token, tonumber(varVang.xp), "add", p:getCrew(), "vangelico heist")

                    local randoeem = 1
                    loadModel(glassConfig.rewards[randoeem].object.model)
                    loadModel(glassConfig.rewards[randoeem].displayObj.model)
                    loadModel('h4_prop_h4_glass_disp_01a')

                    glass = CreateObject(GetHashKey('h4_prop_h4_glass_disp_01a'), -617.4622, -227.4347, 37.057, 1, 1
                        , 0)
                    SetEntityHeading(glass, -53.06)
                    for k, v in pairs(vangelico_config['painting']) do
                        loadModel(v['object'])
                        VangelicoHeist2['painting'][k] = CreateObjectNoOffset(GetHashKey(v['object']), v['objectPos'], 1, 0, 0)
                        SetEntityRotation(VangelicoHeist2['painting'][k], 0, 0, v['objHeading'], 2, true)
                    end
                    reward = CreateObject(GetHashKey(glassConfig.rewards[randoeem].object.model),
                        glassConfig.rewardPos.xy, glassConfig.rewardPos.z + 0.195, 1, 1, 0)
                    SetEntityHeading(reward, glassConfig['rewards'][randoeem]['object']['rot'])
                    rewardDisp = CreateObject(GetHashKey(glassConfig.rewards[randoeem].displayObj.model),
                        glassConfig.rewardPos, 1, 1, 0)
                    SetEntityRotation(rewardDisp, glassConfig.rewards[randoeem].displayObj.rot)
                    TriggerServerEvent('core:globalObject', glassConfig.rewards[randoeem].object.model, randoeem)
                    TriggerServerEvent('core:insideLoop')
                else
                    Bulle.show("vangelico_heist")
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        content = "Vous n'avez pas réussie a pirater le terminal"
                    })
                end
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Vous n'avez pas d'ordinateur"
                })
            end
        else
            -- ShowNotification("Reviens plus tard !")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Reviens plus tard !"
            })
            
        end
    else
        -- ShowNotification("La boutique a deja été vandalisée")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s La boutique a deja été vandalisée !"
        })

    end
end

RegisterNetEvent("core:globalObjectStock")
AddEventHandler("core:globalObjectStock", function(obj, random)
    vangelicoHeist['globalObj'] = obj
    vangelicoHeist['globalItem'] = vangelico_config["glassCutting"].rewards[random].item
end)

local looted = 0
local looted2 = 0
local hasGotAll = false
AllTableau = false
AllVitres = false
local sentone = false
RegisterNetEvent("core:playerInsideLoop")
AddEventHandler("core:playerInsideLoop", function()
    hasBraquerVangelico = true
    Bulle.hide("vangelico_heist")
    loadAnimDict('missheist_jewel')
    loadAnimDict('anim@scripted@heist@ig16_glass_cut@male@')
    loadPtfxAsset('scr_ih_fin')
    insideLoop = true
    for k, v in pairs(vangelico_config['smashScenes']) do
        if not DoesBlipExist(blip[k]) then
            blip[k] = AddBlipForCoord(v.objPos)
            SetBlipScale(blip[k], 0.2)
            SetBlipColour(blip[k], 3)
        end
    end
    for k, v in pairs(vangelico_config['painting']) do
        if not DoesBlipExist(blip2[k]) then
            blip2[k] = AddBlipForCoord(v.objectPos)
            SetBlipScale(blip2[k], 0.2)
            SetBlipColour(blip2[k], 5)
        end
    end
    blip[21] = AddBlipForCoord(vector3(-617.4622, -227.4347, 37.057))
    SetBlipScale(blip[21], 0.2)
    SetBlipColour(blip[21], 3)
    for k, v in pairs(vangelico_config['painting']) do
        Bulle.create("volerTableau" .. k, v['objectPos'], "bulleVolerTableau", true)
    end
    Citizen.CreateThread(function()
        for k, v in pairs(bijouterie_pos) do
            Bulle.hide("bijouterie_shop" .. k)
        end
        while insideLoop do
            local sleep = 1000
            local dst = #(p:pos() - vector3(-617.4622, -227.4347, 37.057))

            if dst <= 4.5 and not busy and not vangelico_config["glassCutting"].loot then
                sleep = 1
                --TODO: get si le mec a l'item pour casser la vitre
                --ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour casser la vitre")
                if dst <= 1.5 then
                    if not hasFondu then
                        --if AllTableau and AllVitres then 
                            Bulle.create("FondreVitre", vector3(-617.4622, -227.4347, 38.52), "bulleFondre", true)
                            if IsControlJustPressed(0, 38) and not hasAlreadyTaken then
                                if Serveur == "FA" then
                                    exports['tuto-fa']:HideStep()
                                elseif Serveur == "WL" then
                                    exports['tuto-wl']:HideStep()
                                end
                                exports['vNotif']:createNotification({
                                    type = 'JAUNE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "L'alarme a été déclanchée, fais vite !"
                                })
                                if not sentone then
                                    local tablee = {}
                                    for k, v in pairs(GetActivePlayers()) do
                                        table.insert(tablee, GetPlayerServerId(v))
                                    end
                                    TriggerServerEvent("core:startAlarm", "vangelico", true, tablee)
                                    sentone = true
                                end
                                OverHeatScene()
                                Bulle.remove("FondreVitre")
                                hasFondu = true
                                Bulle.remove("FondreVitre")
                            end
                        --end
                    end
                end
            end

            if AllTableau and AllVitres and not hasGotAll then 
                hasGotAll = true
                if not hasfondu then
                    if Serveur == "FA" then
                        OpenTutoFAInfo("Braquage Vangelico", "Vous pouvez désormais fondre la vitre et récupérez le diamant")
                    elseif Serveur == "WL" then
                        OpenTutoWLInfo("Braquage Vangelico", "Vous pouvez désormais fondre la vitre et récupérez le diamant")
                    end
                end
            end

            local distCaisse = #(p:pos() - vec3(-621.78, -229.59, 37.99))
            if distCaisse <= 1.0 and not busy and not hasvolercaisse then 
                Bulle.create("volerCaisse", vector3(-621.78, -229.59, 37.99), "bulleVolerCaisse", true)
                if IsControlJustPressed(0, 38) then 
                    busy = true
                    hasvolercaisse = true
                    Bulle.remove("volerCaisse")
                    SetEntityCoords(PlayerPedId(), -622.25360107422, -229.94079589844, 37.057006835938)
                    SetCurrentPedWeapon(PlayerPedId(), "weapon_unarmed", true)
                    SetEntityHeading(PlayerPedId(), 303.90)
                    local moneyprop = GetHashKey("bkr_prop_money_sorted_01")
                    RequestModel(moneyprop)
                    while not HasModelLoaded(moneyprop) do Wait(1) end
                    local moneyProps = CreateObject(moneyprop, 1.0, 1.0, 1.0, 1, 1, 0)
                    local bone = GetPedBoneIndex(PlayerPedId(), 28422)
                    AttachEntityToEntity(moneyProps, PlayerPedId(), bone, 0.0, 0.0, 90.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
                    p:PlayAnim('oddjobs@shop_robbery@rob_till','loop',1)
                    Wait(10000)
                    busy = false
                    DeleteEntity(moneyProps)
                    ClearPedTasks(PlayerPedId())
                    if GetVariable("heist") and GetVariable("heist").vangelico and GetVariable("heist").vangelico.CaisseWinMin and GetVariable("heist").vangelico.CaisseWinMax then 
                        local rand = math.random(GetVariable("heist").vangelico.CaisseWinMin, GetVariable("heist").vangelico.CaisseWinMax)
                        p:AddItem("money", rand, {})
                        exports['vNotif']:createNotification({
                            type = 'JAUNE',
                            -- duration = 5, -- In seconds, default:  4
                            content = "Vous avez récupéré " .. rand .. "$"
                        })
                    else
                        local rand = math.random(100, 500)
                        p:AddItem("money", rand, {})
                        exports['vNotif']:createNotification({
                            type = 'JAUNE',
                            -- duration = 5, -- In seconds, default:  4
                            content = "Vous avez récupéré " .. rand .. "$"
                        })
                    end
                    --p:AddItem("money", math.random(100, 200), {})
                end
            end

            for k, v in pairs(vangelico_config['painting']) do
                local dist = #(GetEntityCoords(PlayerPedId()) - v['objectPos'])
        
                if dist <= 1.5 and not v.loot and not busy then
                    if IsControlJustPressed(0, 38) then
                        HasBraqued = true
                        looted2 += 1
                        if looted2 == #vangelico_config['painting'] then 
                            AllTableau = true
                        end
                        if Serveur == "FA" then
                            exports['tuto-fa']:HideStep()
                        elseif Serveur == "WL" then
                            exports['tuto-wl']:HideStep()
                        end
                        Bulle.hide("volerTableau" .. k)
                        PaintingScene(k)
                    end
                end
            end

            if dst >= 40.0 then
                Bulle.remove("briserVitre")
                hasfondu = false
                HasBraqued = false
                Outside()
                break
            end

            for k, v in pairs(vangelico_config["smashScenes"]) do
                local dst = #(p:pos() - v.objPos)

                if dst <= 1.3 and not v.loot and not busy then
                    sleep = 1
                    Bulle.create("briserVitre", v.objPos + vector3(0.0, 0.0, 0.25), "bulleBriser", true)
                    --ShowHelpNotification("Appuyer sur ~INPUT_CONTEXT~ pour casser la vitre")
                    if IsControlJustPressed(0, 38) then
                        if IsPedArmed(p:ped(), 4) then
                            looted += 1
                            if looted == #vangelico_config["smashScenes"] then 
                                AllVitres = true
                            end
                            Bulle.remove("briserVitre")
                            SmashScene(k)
                            if looted == 4 then 
                                OpenTutoFAInfo("Braquage Vangelico", "Lorsque vous avez fini de casser toutes les vitres, utilisez votre couteau pour voler les oeuvres d'arts")
                            end
                        else
                            -- ShowNotification("Tu as besoin d'une arme pour casser la vitre")

                            -- New notif
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                -- duration = 5, -- In seconds, default:  4
                                content = "Tu as ~s besoin d'une arme ~c pour casser la vitre"
                            })

                        end
                    end
                end

            end
            Wait(1)
        end
        
        for k, v in pairs(bijouterie_pos) do
            Bulle.show("bijouterie_shop" .. k)
        end
    end)
end)

RegisterNetEvent("core:sync:vangelicoheat", function()
    hasAlreadyTaken = true
end)

function OverHeatScene()
    local reusite = math.random(0, 100)
    busy = true
    TriggerServerEvent("core:sync:vangelicoheat")
    Bulle.hide("FondreVitre")
    local animDict = 'anim@scripted@heist@ig16_glass_cut@male@'
    sceneObject = GetClosestObjectOfType(-617.4622, -227.4347, 37.057, 1.0, GetHashKey('h4_prop_h4_glass_disp_01a'), 0, 0
        , 0)
    scenePos = GetEntityCoords(sceneObject)
    sceneRot = GetEntityRotation(sceneObject)
    globalObj = GetClosestObjectOfType(-617.4622, -227.4347, 37.057, 5.0, GetHashKey(vangelicoHeist['globalObj']), 0, 0,
        0)
    loadAnimDict(animDict)
    RequestScriptAudioBank('DLC_HEI4/DLCHEI4_GENERIC_01', -1)

    cam = CreateCam("DEFAULT_ANIMATED_CAMERA", true)
    SetCamActive(cam, true)
    RenderScriptCams(true, 0, 3000, 1, 0)

    for k, v in pairs(vangelico_config.Overheat['objects']) do
        loadModel(v)
        vangelico_config.Overheat['sceneObjects'][k] = CreateObject(GetHashKey(v), p:pos(), 1, 1, 0)
    end

    local newObj = CreateObject(GetHashKey('h4_prop_h4_glass_disp_01b'), GetEntityCoords(sceneObject), 1, 1, 0)
    SetEntityHeading(newObj, GetEntityHeading(sceneObject))

    for i = 1, #vangelico_config.Overheat['animations'] do
        vangelico_config.Overheat['scenes'][i] = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, true, false,
            1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(p:ped(), vangelico_config.Overheat['scenes'][i], animDict,
            vangelico_config.Overheat['animations'][i][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
        NetworkAddEntityToSynchronisedScene(vangelico_config.Overheat['sceneObjects'][1],
            vangelico_config.Overheat['scenes'][i], animDict, vangelico_config.Overheat['animations'][i][2], 1.0, -1.0,
            1148846080)
        NetworkAddEntityToSynchronisedScene(vangelico_config.Overheat['sceneObjects'][2],
            vangelico_config.Overheat['scenes'][i], animDict, vangelico_config.Overheat['animations'][i][3], 1.0, -1.0,
            1148846080)
        if i ~= 5 then
            NetworkAddEntityToSynchronisedScene(sceneObject, vangelico_config.Overheat['scenes'][i], animDict,
                vangelico_config.Overheat['animations'][i][4], 1.0, -1.0, 1148846080)
        else
            NetworkAddEntityToSynchronisedScene(newObj, vangelico_config.Overheat['scenes'][i], animDict,
                vangelico_config.Overheat['animations'][i][4], 1.0, -1.0, 1148846080)
        end
    end

    local sound1 = GetSoundId()
    local sound2 = GetSoundId()

    NetworkStartSynchronisedScene(vangelico_config.Overheat['scenes'][1])
    PlayCamAnim(cam, 'enter_cam', animDict, scenePos, sceneRot, 0, 2)
    Wait(GetAnimDuration(animDict, 'enter') * 1000 - 1000)

    NetworkStartSynchronisedScene(vangelico_config.Overheat['scenes'][2])
    PlayCamAnim(cam, 'idle_cam', animDict, scenePos, sceneRot, 0, 2)
    Wait(GetAnimDuration(animDict, 'idle') * 1000 - 1500)

    NetworkStartSynchronisedScene(vangelico_config.Overheat['scenes'][3])
    PlaySoundFromEntity(sound1, "StartCutting", vangelico_config.Overheat['sceneObjects'][2],
        'DLC_H4_anims_glass_cutter_Sounds', true, 80)
    loadPtfxAsset('scr_ih_fin')
    UseParticleFxAssetNextCall('scr_ih_fin')
    fire1 = StartParticleFxLoopedOnEntity('scr_ih_fin_glass_cutter_cut', vangelico_config.Overheat['sceneObjects'][2],
        0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1065353216, 0.0, 0.0, 0.0, 1065353216, 1065353216, 1065353216, 0)
    PlayCamAnim(cam, 'cutting_loop_cam', animDict, scenePos, sceneRot, 0, 2)
    Wait(GetAnimDuration(animDict, 'cutting_loop') * 1000)
    StopSound(sound1)
    StopParticleFxLooped(fire1)

    if reusite < 60 then
        -- ShowNotification("Vous avez récupéré le diamant !")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez ~s récupéré le diamant !"
        })

        TriggerServerEvent('core:lootSync', 'glassCutting')
        DeleteObject(sceneObject)
        NetworkStartSynchronisedScene(vangelico_config.Overheat['scenes'][5])
        Wait(2000)
        DeleteObject(globalObj)
        PlayCamAnim(cam, 'success_cam', animDict, scenePos, sceneRot, 0, 2)
        Wait(GetAnimDuration(animDict, 'success') * 1000 - 2000)
        DeleteObject(vangelico_config.Overheat['sceneObjects'][1])
        DeleteObject(vangelico_config.Overheat['sceneObjects'][2])
        ClearPedTasks(p:ped())
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        TriggerSecurGiveEvent("core:addItemToInventory", token, "diamond", 1, {})
        busy = false
        TriggerServerEvent('core:vangelico_removeBlips', blip[21])
    else
        -- ShowNotification("Vous avez échoué, prenez la fuite !")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez ~s échoué,~c prenez la fuite !"
        })

        vangelico_config['glassCutting'].loot = true
        NetworkStartSynchronisedScene(vangelico_config.Overheat['scenes'][4])
        PlaySoundFromEntity(sound2, "Overheated", vangelico_config.Overheat['sceneObjects'][2],
            'DLC_H4_anims_glass_cutter_Sounds', true, 80)
        UseParticleFxAssetNextCall('scr_ih_fin')
        fire2 = StartParticleFxLoopedOnEntity('scr_ih_fin_glass_cutter_overheat',
            vangelico_config.Overheat['sceneObjects'][2], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1065353216, 0.0, 0.0, 0.0)
        PlayCamAnim(cam, 'overheat_react_01_cam', animDict, scenePos, sceneRot, 0, 2)
        Wait(GetAnimDuration(animDict, 'overheat_react_01') * 1000)
        StopSound(sound2)
        StopParticleFxLooped(fire2)

        DeleteObject(sceneObject)
        NetworkStartSynchronisedScene(vangelico_config.Overheat['scenes'][6])
        DeleteObject(globalObj)
        PlayCamAnim(cam, 'exit_cam', animDict, scenePos, sceneRot, 0, 2)
        Wait(GetAnimDuration(animDict, 'exit') * 1000)
        DeleteObject(vangelico_config.Overheat['sceneObjects'][1])
        DeleteObject(vangelico_config.Overheat['sceneObjects'][2])
        ClearPedTasks(p:ped())
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        busy = false
    end
    hasfondu = true
    Bulle.show("FondreVitre")
end

local senttwo = false
function Outside()
    insideLoop = false
    for i = 1, #blip, 1 do
        if DoesBlipExist(blip[i]) then
            RemoveBlip(blip[i])
        end
    end
    for i = 1, #blip2, 1 do
        if DoesBlipExist(blip2[i]) then
            RemoveBlip(blip2[i])
        end
    end
    blip = {}
    blip2 = {}
    hasBraquerVangelico = false
    for k, v in pairs(vangelico_config['smashScenes']) do
        v.loot = false
    end
    if not senttwo then
        senttwo = true
        local tablee = {}
        for k, v in pairs(GetActivePlayers()) do
            table.insert(tablee, GetPlayerServerId(v))
        end
        TriggerServerEvent("core:startAlarm", "vangelico", false, tablee)
    end
    vangelico_config['glassCutting'].loot = false
    local glassObjectDel = GetClosestObjectOfType(-617.4622, -227.4347, 37.057, 1.0,
        GetHashKey('h4_prop_h4_glass_disp_01a'), 0, 0, 0)
    local glassObjectDel2 = GetClosestObjectOfType(-617.4622, -227.4347, 37.057, 1.0,
        GetHashKey('h4_prop_h4_glass_disp_01b'), 0, 0, 0)
    SetModelAsNoLongerNeeded(GetHashKey('h4_prop_h4_glass_disp_01a'))
    SetModelAsNoLongerNeeded(GetHashKey('h4_prop_h4_glass_disp_01b'))
    SetModelAsNoLongerNeeded(GetHashKey(glassConfig.rewards[1].object.model))
    SetModelAsNoLongerNeeded(GetHashKey(glassConfig.rewards[1].displayObj.model))
    DeleteObject(glassObjectDel)
    DeleteObject(glassObjectDel2)
    if Serveur == "FA" then
        exports['tuto-fa']:HideStep()
    elseif Serveur == "WL" then
        exports['tuto-wl']:HideStep()
    end
    Bulle.show("vangelico_heist")
    DeleteObject(glass)
    DeleteObject(reward)
    DeleteObject(rewardDisp)
end

function SmashScene(index)
    --if GetSelectedPedWeapon(p:ped()) then
    busy = true
    TriggerServerEvent('core:lootSync', 'smashScenes', index)
    local animDict = 'missheist_jewel'
    local ptfxAsset = "scr_jewelheist"
    local particleFx = "scr_jewel_cab_smash"
    loadAnimDict(animDict)
    loadPtfxAsset(ptfxAsset)
    local sceneCfg = vangelico_config['smashScenes'][index]
    SetEntityCoords(p:ped(), sceneCfg.scenePos)
    local anims = {
        { 'smash_case_necklace', 300 },
        { 'smash_case_d', 300 },
        { 'smash_case_e', 300 },
        { 'smash_case_f', 300 }
    }
    local selected = ""
    repeat
        selected = anims[math.random(1, #anims)]
    until selected ~= prevAnim
    prevAnim = selected

    if index == 4 or index == 10 or index == 14 or index == 8 then
        selected = { 'smash_case_necklace_skull', 300 }
    end

    cam = CreateCam("DEFAULT_ANIMATED_CAMERA", true)
    SetCamActive(cam, true)
    RenderScriptCams(true, 0, 0, 0, 0)

    scene = NetworkCreateSynchronisedScene(sceneCfg['scenePos'], sceneCfg['sceneRot'], 2, true, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(p:ped(), scene, animDict, selected[1], 2.0, 4.0, 1, 0, 1148846080, 0)
    NetworkStartSynchronisedScene(scene)

    PlayCamAnim(cam, 'cam_' .. selected[1], animDict, sceneCfg['scenePos'], sceneCfg['sceneRot'], 0, 2)

    Wait(300)

    TriggerServerEvent('core:smashSync', sceneCfg)
    for i = 1, 5 do
        PlaySoundFromCoord(-1, "Glass_Smash", sceneCfg['objPos'], 0, 0, 0)
    end
    SetPtfxAssetNextCall(ptfxAsset)
    StartNetworkedParticleFxNonLoopedAtCoord(particleFx, sceneCfg['objPos'], 0.0, 0.0, 0.0, 2.0, 0, 0, 0)
    Wait(GetAnimDuration(animDict, selected[1]) * 1000 - 1000)
    ClearPedTasks(p:ped())
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    TriggerServerEvent('core:vangelico_removeBlips', blip[index])
    TriggerSecurGiveEvent("core:addItemToInventory", token, "jewel", 1, {})
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        -- duration = 5, -- In seconds, default:  4
        content = 'Vous avez récupéré un bijou.'
    })
    busy = false
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

RegisterNetEvent('vangelicoheist:client:lootSync')
AddEventHandler('vangelicoheist:client:lootSync', function(_type, _index)
    if _index then
        vangelico_config[_type][_index].loot = true
    else
        vangelico_config[_type].loot = true
    end
    
    Bulle.hide("volerTableau" .. _index)
    Bulle.remove("volerTableau" .. _index)
end)

function PaintingScene(sceneId)
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    if weapon == GetHashKey('WEAPON_SWITCHBLADE') or weapon == GetHashKey('weapon_dagger') or weapon == GetHashKey('WEAPON_KNIFE') then 
        TriggerServerEvent('vangelicoheist:server:lootSync', 'painting', sceneId)
        robber = true
        busy = true
        local pedCo, pedRotation = GetEntityCoords(ped), vector3(0.0, 0.0, 0.0)
        local scenes = {false, false, false, false}
        local animDict = "anim_heist@hs3f@ig11_steal_painting@male@"
        scene = vangelico_config['painting'][sceneId]
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
        --repeat
        --    ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour couper vers la droite")
        --    if IsControlJustPressed(0, 38) then
        --        scenes[1] = true
        --    end
        --    Wait(1)
        --until scenes[1] == true
        NetworkStartSynchronisedScene(ArtHeist['scenes'][3])
        PlayCamAnim(cam, 'ver_01_cutting_top_left_to_right_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
        Wait(3000)
        NetworkStartSynchronisedScene(ArtHeist['scenes'][4])
        PlayCamAnim(cam, 'ver_01_cutting_top_right_idle_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
        --repeat
        --    ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour couper vers le bas")
        --    if IsControlJustPressed(0, 38) then
        --        scenes[2] = true
        --    end
        --    Wait(1)
        --until scenes[2] == true
        NetworkStartSynchronisedScene(ArtHeist['scenes'][5])
        PlayCamAnim(cam, 'ver_01_cutting_right_top_to_bottom_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
        Wait(3000)
        NetworkStartSynchronisedScene(ArtHeist['scenes'][6])
        PlayCamAnim(cam, 'ver_01_cutting_bottom_right_idle_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
        --repeat
        --    ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour couper vers la gauche")
        --    if IsControlJustPressed(0, 38) then
        --        scenes[3] = true
        --    end
        --    Wait(1)
        --until scenes[3] == true
        NetworkStartSynchronisedScene(ArtHeist['scenes'][7])
        PlayCamAnim(cam, 'ver_01_cutting_bottom_right_to_left_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
        Wait(3000)
        --repeat
        --    ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour couper vers le bas")
        --    if IsControlJustPressed(0, 38) then
        --        scenes[4] = true
        --    end
        --    Wait(1)
        --until scenes[4] == true
        NetworkStartSynchronisedScene(ArtHeist['scenes'][9])
        PlayCamAnim(cam, 'ver_01_cutting_left_top_to_bottom_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
        Wait(1500)
        NetworkStartSynchronisedScene(ArtHeist['scenes'][10])
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        Wait(7500)
        --TriggerServerEvent('vangelicoheist:server:rewardItem', scene['rewardItem'])
        local mathran = math.random(1,3)
        if mathran == 1 then 
            p:AddItem("tabc", 1, {})
        elseif mathran == 2 then 
            p:AddItem("tabpc", 1, {})
        else
            p:AddItem("tabr", 1, {})
        end
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
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Tu as ~s besoin d'un couteau en main ~c pour voler le tableau"
        })
        return
    end
end

RegisterNetEvent("core:lootSyncObj")
AddEventHandler("core:lootSyncObj", function(_type, index)
    if index then
        vangelico_config[_type][index].loot = true
    else
        vangelico_config[_type].loot = true
    end
end)

RegisterNetEvent("core:smashSyncObj")
AddEventHandler("core:smashSyncObj", function(sceneCfg)
    CreateModelSwap(sceneCfg.objPos, 0.3, GetHashKey(sceneCfg['oldModel']), GetHashKey('newModel'), 1)
end)

RegisterNetEvent("core:playerVangelico_removeBlips")
AddEventHandler("core:playerVangelico_removeBlips", function(blip)
    RemoveBlip(blip)
    blip = nil
end)

RegisterNetEvent("core:startAlarm", function(typee, bool, tablee)
    PrepareAlarm("JEWEL_STORE_HEIST_ALARMS")
    while not PrepareAlarm("JEWEL_STORE_HEIST_ALARMS") do 
        Wait(1)
    end
    if bool then 
        StartAlarm("JEWEL_STORE_HEIST_ALARMS", 1)
    else
        StopAllAlarms(true)
        StopAlarm("JEWEL_STORE_HEIST_ALARMS", 1)
    end
end)