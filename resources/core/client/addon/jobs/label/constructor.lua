function LoadLabel()
    if pJob ~= "rockford" and pJob ~= "records" and pJob ~= "emperium" then
        return
    end
    local inService = false
    local openRadial = false
    local jobName = p:getJob()
    local posCoffre, posGestion, posCasier = vec3(0,0,0), vec3(0,0,0), vec3(0,0,0)

    if pJob == "records" then
        posCoffre = vec3(0, 0, 0)
        posGestion = vec3(0, 0, 0)
    elseif pJob == "rockford" then
        posCoffre = vec3(-996.52142333984, -307.82968139648, 43.797317504883)
        posGestion = vec3(-1007.7181396484, -264.82049560547, 43.795902252197)
    elseif pJob == "emperium" then
        posCasier = vec3(240.83424377441, -20.682563781738, 74.884498596191)
        posCoffre = vec3(220.4581451416, -14.664839744568, 74.909271240234)
        posGestion = vec3(207.58081054688, -10.305171012878, 75.007125854492)
    else
        posCoffre = vec3(0, 0, 0)
        posGestion = vec3(0, 0, 0)
    end

    local pos = {
        {
            name = "Coffre_"..jobName, pos = posCoffre, bulle = "bulleCoffre",
            action = function()
                if inService then
                    OpenInventorySocietyMenu()
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        content = "Vous n'êtes ~s pas en service"
                    }) 
                end
            end
        },
        {
            name = "Gestion_"..jobName, pos = posGestion, bulle = "bulleGestion",
            action = function()
                if inService then
                    OpenSocietyMenu()
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        content = "Vous n'êtes ~s pas en service"
                    }) 
                end
            end 
        },
        {
            name = "Casier_"..jobName, pos = posCasier, bulle = "bulleCasiers",
            action = function()
                if inService then
                    OpenConstrCasier()
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        content = "Vous n'êtes ~s pas en service"
                    }) 
                end
            end 
        }
    }

    for key, v in pairs(pos) do
        zone.addZone(
            v.name,
            v.pos.xyz,
            "~INPUT_CONTEXT~ Intéragir",
            function()
                v.action()
            end,
            false, -- Avoir un marker ou non
            -1, -- Id / type du marker
            0.6, -- La taille
            { 0, 0, 0 }, -- RGB
            0, -- Alpha
            1.9,
            true,
            v.bulle
        )
    end

    function FactureLabel()
        if inService then
            openRadial = false
            closeUI()
            TriggerEvent("nuiPapier:client:startCreation", 2)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    local casierOpen = false
    function OpenConstrCasier()
        if not casierOpen then
            casierOpen = true

            CreateThread(function()
                while casierOpen do
                    Wait(0)
                    DisableControlAction(0, 1, casierOpen)
                    DisableControlAction(0, 2, casierOpen)
                    DisableControlAction(0, 142, casierOpen)
                    DisableControlAction(0, 18, casierOpen)
                    DisableControlAction(0, 322, casierOpen)
                    DisableControlAction(0, 106, casierOpen)
                    DisableControlAction(0, 24, true) -- disable attack
                    DisableControlAction(0, 25, true) -- disable aim
                    DisableControlAction(0, 263, true) -- disable melee
                    DisableControlAction(0, 264, true) -- disable melee
                    DisableControlAction(0, 257, true) -- disable melee
                    DisableControlAction(0, 140, true) -- disable melee
                    DisableControlAction(0, 141, true) -- disable melee
                    DisableControlAction(0, 142, true) -- disable melee
                    DisableControlAction(0, 143, true) -- disable melee
                end
            end)
            SetNuiFocusKeepInput(true)
            SetNuiFocus(true, true)
            Citizen.CreateThread(function()
                SendNUIMessage({
                    type = "openWebview",
                    name = "Casiers",
                    data = {
                        count = 60,
                    },
                })
            end)
        else
            casierOpen = false
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

    RegisterNUICallback("focusOut", function(data, cb)
        if casierOpen then
            TriggerScreenblurFadeOut(0.5)
            casierOpen = false
            SetNuiFocusKeepInput(false)
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 142, true)
            EnableControlAction(0, 18, true)
            EnableControlAction(0, 322, true)
            EnableControlAction(0, 106, true)
            SetNuiFocus(false, false)
            openRadarProperly()
            DisplayHud(true)
            cb({})
        end
    end)

    RegisterNUICallback("casier__callback", function(data)
        OpenInventoryCasier(p:getJob(), data.numero)
    end)    

    function SetLabelDuty()
        openRadial = false
        closeUI()
        if not inService then
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez ~s pris ~c votre service"
            })

            TriggerServerEvent('core:DutyOn', p:getJob())
            inService = true
            Wait(5000)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous avez ~s quitté ~c votre service"
            })

            TriggerServerEvent('core:DutyOff', p:getJob())
            inService = false
            Wait(5000)
        end
    end

    function CreateAdvert()
        if inService then
            openRadial = false
            closeUI()
            CreateJobAnnonce()
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function ContratLabel()
        if inService then
            openRadial = false
            closeUI()
            TriggerEvent("nuiPapier:client:startCreation", 3)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end
    
    function OpenRadialLabel()
        if not openRadial then
            openRadial = true
            CreateThread(function()
                while openRadial do
                    Wait(0)
                    DisableControlAction(0, 1, openRadial)
                    DisableControlAction(0, 2, openRadial)
                    DisableControlAction(0, 142, openRadial)
                    DisableControlAction(0, 18, openRadial)
                    DisableControlAction(0, 322, openRadial)
                    DisableControlAction(0, 106, openRadial)
                    DisableControlAction(0, 24, true) -- disable attack
                    DisableControlAction(0, 25, true) -- disable aim
                    DisableControlAction(0, 263, true) -- disable melee
                    DisableControlAction(0, 264, true) -- disable melee
                    DisableControlAction(0, 257, true) -- disable melee
                    DisableControlAction(0, 140, true) -- disable melee
                    DisableControlAction(0, 141, true) -- disable melee
                    DisableControlAction(0, 142, true) -- disable melee
                    DisableControlAction(0, 143, true) -- disable melee
                end
            end)
            SetNuiFocusKeepInput(true)
            SetNuiFocus(true, true)
            Wait(200)
            CreateThread(function()
                SendNuiMessage(json.encode({
                    type = 'openWebview',
                    name = 'RadialMenu',
                    data = { elements = {
                        {
                            name = "ANNONCE",
                            icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/megaphone.svg",
                            action = "CreateAdvert"
                        }, 
                        {
                            name = "FACTURE",
                            icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/billet.svg",
                            action = "FactureLabel"
                        },
                        {
                            name = "PRISE DE SERVICE",
                            icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/checkmark.svg",
                            action = "SetLabelDuty"
                        },
                        {
                            name = "CONTRAT",
                            icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/paper.svg",
                            action = "ContratLabel"
                        }
                    }, title = string.upper(p:getJob()) }
                }));
            end)
        else
            openRadial = false
            closeUI()
            return
        end
    end

    RegisterJobMenu(OpenRadialLabel)

    function UnLoadLabel()
        for key, v in pairs(pos) do
            zone.removeZone(v.name)
        end
        zone.removeZone(jobName.."_delete")
    end
end

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7label ^3loaded")
end)