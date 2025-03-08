local JobPositions = {
    ["lsevent"] = {
        posCoffre = vec3(-262.88452148438, -725.68884277344, 124.47330474854),
        posGestion = vec3(-263.83935546875, -728.16949462891, 124.47330474854),
        posCasier = vec3(-285.93630981445, -735.05187988281, 124.49096679688),
        posVehicule = vec3(-317.77603149414, -712.56866455078, 31.884227752686),
        posSpawnVehicule = vec4(-324.23690795898, -701.40246582031, 31.958278656006, 353.17034912109),
        posDeleteVehicule = vec3(-318.30902099609, -705.75500488281, 31.950428009033),
        Vehicles = {
            "felon",
            "monkey",
        },
        banner = nil
    }
}

function LoadJobConstruc()
    local inService = false
    local openRadial = false
    local jobName = p:getJob()
    local posCoffre, posGestion, posCasier = JobPositions[p:getJob()].posCoffre, JobPositions[p:getJob()].posGestion, JobPositions[p:getJob()].posCasier
    local posVehicule, posSpawnVehicule, posDeleteVehicule = JobPositions[p:getJob()].posVehicule, JobPositions[p:getJob()].posSpawnVehicule, JobPositions[p:getJob()].posDeleteVehicule

    local pose = {
        {
            name = "Coffre_"..jobName, pos = posCoffre, interact = "Ouvrir le coffre",
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
            name = "Gestion_"..jobName, pos = posGestion, interact = "Ouvrir la gestion patron",
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
            name = "Casier_"..jobName, pos = posCasier, interact = "Ouvrir les casiers",
            action = function()
                if inService then
                    OpenCasierJobConsr()
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        content = "Vous n'êtes ~s pas en service"
                    }) 
                end
            end 
        },
        {
            name = "Vehicle_"..jobName, pos = posVehicule, interact = "Véhicules",
            action = function()
                if inService then
                    OpenMenuVehMyJob()
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        content = "Vous n'êtes ~s pas en service"
                    }) 
                end
            end 
        },
        {
            name = "DeleteVehicle_"..jobName, pos = posDeleteVehicule, interact = "Ranger le véhicule",
            action = function()
                if inService then
                    if IsPedInAnyVehicle(p:ped(), false) then
                        if GetVehicleBodyHealth(p:currentVeh()) / 10 >= 80 or
                            GetVehicleEngineHealth(p:currentVeh()) / 10 >= 80 then
                            local veh = GetVehiclePedIsIn(p:ped(), false)
                            --removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                            TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                            TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                            DeleteEntity(veh)
                        else
                            -- ShowNotification("~r~Votre véhicule est trop abimé")
    
                            -- New notif
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                -- duration = 5, -- In seconds, default:  4
                                content = "~s Votre véhicule est trop abimé"
                            })
                        end
                    end
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        content = "Vous n'êtes ~s pas en service"
                    }) 
                end
            end 
        },
    }

    for key, v in pairs(pose) do
        zone.addZone(
            v.name,
            v.pos.xyz,
            "~INPUT_CONTEXT~ " .. v.interact,
            function()
                v.action()
            end,
            true,
            25, -- Id / type du marker
            0.6, -- La taille
            { 51, 204, 255 }, -- RGB
            170-- Alpha
        )
    end

    local myJobVehs = {
        headerImage = JobPositions[p:getJob()].banner or 'https://cdn.sacul.cloud/v2/vision-cdn/Location/header.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
        headerIconName = 'VEHICULES',
        callbackName = 'myJobVehCallback',
        elements = {}
    }

    for k,v in pairs(JobPositions[p:getJob()].Vehicles) do 
        table.insert(myJobVehs.elements, {
            id = k,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Voiture/"..v..".webp",
            label = GetLabelText(v),
            name = v,
        })
    end

    function OpenMenuVehMyJob()
        forceHideRadar()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = myJobVehs
        }))
    end

    function FactureMyJob()
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
    function OpenCasierJobConsr()
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
            casierOpen = false
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 142, true)
            EnableControlAction(0, 18, true)
            EnableControlAction(0, 322, true)
            EnableControlAction(0, 106, true)
            openRadarProperly()
        end
        cb({})
    end)

    RegisterNUICallback("casier__callback", function(data)
        OpenInventoryCasier(p:getJob(), data.numero)
    end)

    function SetMyJobDuty()
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

    function ContratMyJob()
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
    
    function OpenRadialMyJob()
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
                            action = "FactureMyJob"
                        },
                        {
                            name = "PRISE DE SERVICE",
                            icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/checkmark.svg",
                            action = "SetMyJobDuty"
                        },
                        --{
                        --    name = "CONTRAT",
                        --    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/paper.svg",
                        --    action = "ContratMyJob"
                        --}
                    }, title = string.upper(p:getJob()) }
                }));
            end)
        else
            openRadial = false
            closeUI()
            return
        end
    end

    RegisterJobMenu(OpenRadialMyJob)

    function UnLoadJobConstruc()
        for key, v in pairs(pose) do
            zone.removeZone(v.name)
        end
        zone.removeZone(jobName.."_delete")
    end
end

CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7Job constructor ^3loaded")
end)

RegisterNUICallback("myJobVehCallback", function (data, cb)
    vehs = nil
    if vehicle.IsSpawnPointClear(JobPositions[p:getJob()].posSpawnVehicule.xyz, 3.0) then
        vehs = vehicle.create(data.name, JobPositions[p:getJob()].posSpawnVehicule, {})
        SetVehicleLivery(vehs, 2)
        local plate = vehicle.getProps(vehs).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
        --createKeys(plate, model)
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
        return
    else
        -- ShowNotification("Il n'y a pas de place pour le véhicule")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Il n'y a ~s pas de place ~c pour le véhicule"
        })
    end    
end)