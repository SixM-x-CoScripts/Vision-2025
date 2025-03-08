local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local tenue = {
    male = {
        ['tshirt_1'] = 11,
        ['tshirt_2'] = 0,
        ['torso_1'] = 551,
        ['torso_2'] = 4,
        ['arms'] = 14,
    },

    female = {
        ['tshirt_1'] = 39,
        ['tshirt_2'] = 0,
        ['torso_1'] = 506,
        ['torso_2'] = 17,
        ['arms'] = 7,
    }
}




boiDuty = false
function LoadBOI()

    zone.addZone(
        "casier_boi",
        vector3(2515.197265625, -344.70718383789, 101.89349365234),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les casiers",
        function()
            if boiDuty then
                OpenboiCasier() 
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Vous n'êtes ~s pas en service"
                }) 
            end
        end, false,
        27,
        1.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleCasiers"
    )

    zone.addZone("boi_vestiaire", vector3(2517.5407714844, -341.55487060547, 100.89337158203),
            "Appuyer sur ~INPUT_CONTEXT~ pour prendre la veste",
            function ()
                BOIVestiaireDev()
            end,
            true,
        25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170-- Alpha
        )

    local casierOpen = false
    function OpenboiCasier()
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


    zone.addZone("boi_item", vector3(2527.1987304688, -338.88265991211, 101.89337158203),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir l'armurerie ", 
        function()
            OpenboiITEMMenu()
        end,
        false, -- Avoir un marker ou non
        29, -- Id / type du marker
        1.0, -- La taille
        {50, 168, 82}, -- RGB
        170, -- Alpha
        2.0,
        true,
        "bulleArmurerie"
    )

    local items = {
        headerImage = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Banners/LSPD.webp",
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Banners/icon.webp',
        headerIconName = 'CATALOGUE',
        callbackName = 'armoryTakeboi',
        multipleSelection = true,
        showTurnAroundButtons = false,
        elements = {            
            {            
               price = 0,
               id = 1,
               image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Radio.webp",
               name = "radio",
               label = "Radio",
            },            
            {            
                price = 0,
                id = 2,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Bouclier_anti_emeute.webp",
                name = "shield",
                label = "Bouclier anti-émeute",
            },
            {           
                price = 0,
                id = 3,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Fumigene.webp",
                name = "weapon_smokelspd",
                label = "Fumigene",
            },
            {            
                price = 0,
                id = 4,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Fusee_detresse.webp",
                name = "weapon_flare",
                label = "Fusée de détresse",
            },
            {            
                price = 0,
                id = 5,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Gaz_bz.webp",
                name = "weapon_bzgas",
                label = "GAZ BZ",
            },
            {           
               price = 0,
               id = 7,
               image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/herse.webp",
               name = "herse",
               label = "Herses",
            },            
            {            
               price = 0,
               id = 8,
               image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/weapon_nightstick.webp",           
               name = "weapon_nightstick",
               label = "Matraque",
            },            
            {            
                price = 0,
                id = 6,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Taser.webp",
                name = "weapon_stungun_mp",
                label = "Taser",
            },            
                {            
                price = 0,
                id = 10,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Boite_cartouches.webp",
                name = "ammo30",
                label = "Boite de munitions",
                },            
            {            
                price = 0,
                id = 11,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/weapon_pistol.webp",           
                name = "weapon_pistol",
                label = "Beretta 92 FS",
            },            
            {            
                price = 0,
                id = 12,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/weapon_pistolcombat.webp",           
                name = "weapon_combatpistol",
                label = "Glock 17",
            },            
            {            
                price = 0,
                id = 13,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/weapon_heavypistol.webp",           
                name = "weapon_heavypistol",
                label = "Colt M45A1",
            },
            {            
                price = 0,
                id = 7,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/weapon_beambag.webp",           
                name = "weapon_beambag",
                label = "Fusil Beambag",
            },
           {            
               price = 0,
               id = 15,
               image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/weapon_pumpshotgun.webp",           
               name = "weapon_pumpshotgun",
               label = "Remington 870E",
           },
           {            
               price = 0,
               id = 16,
               image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/weapon_carbinerifle.webp",           
               name = "weapon_carbinerifle",
               label = "M4A1",
           },
           {            
               price = 0,
               id = 17,
               image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/weapon_smg.webp",           
               name = "weapon_smg",
               label = "H&K MP5A5",
           },
           {            
            price = 0,
            id = 18,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/boikev.webp",           
            name = "boikev",
            label = "BOI - Kevlar",
            },
        },
    }

    function OpenboiITEMMenu()
        FreezeEntityPosition(PlayerPedId(), true)
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogueAchat',
            data = items
        }));

        RegisterNUICallback("focusOut", function (data, cb)
            TriggerScreenblurFadeOut(0.5)
            openRadarProperly()
            RenderScriptCams(false, false, 0, 1, 0)
            DestroyCam(cam, false)
            FreezeEntityPosition(PlayerPedId(), false)
        end)
    end

    Keys.Register("F2", "F2", "Faire un appel de renfort", function()
        makeRenfortCallboi()
    end)

    function Convocationboi()
        if boiDuty then
            openRadial = false
            closeUI()
            TriggerEvent("nuiPapier:client:startCreation", 5)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function Factureboi()
        if boiDuty then
            openRadial = false
            closeUI()
            TriggerEvent("nuiPapier:client:startCreation",2)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function Depositionboi()
        if boiDuty then
            openRadial = false
            closeUI()
            TriggerEvent("nuiPapier:client:startCreation",4)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function CreateAdvert()
        if boiDuty then
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

    function makeRenfortCallboi()
        if boiDuty then
            TriggerSecurEvent('core:makeCall', "boi", p:pos(), false, "Appel de renfort (" .. p:getLastname() .. " " .. p:getFirstname() .. ")") 
            ExecuteCommand("me fait un appel de renfort")
            --p:PlayAnim('amb@code_human_police_investigate@idle_a', 'idle_b', 51)
            openRadial = false
            closeUI()
            --Modules.UI.RealWait(10000)
            --ClearPedTasks(p:ped())
        else
            -- ShowNotification("~r~Vous n'êtes pas en service")
                    
            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous n'êtes ~s pas en service"
            }) 
        end
    end

    function OpenRadialboiMenu()
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
                function OpenSubRadialPapiers()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = { elements = {
                            {
                                name = "CONVOCATION",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/top_paper.svg",
                                action = "Convocationboi"
                            },
                            {
                                name = "FACTURE",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/billet.svg",
                                action = "Factureboi"
                            },
                            {
                                name = "RETOUR",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                action = "OpenMainRadialboi"
                            },
                            {
                                name = "DEPOSITION",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/paper.svg",
                                action = "Depositionboi"
                            }
                        }, 
                        title = "PAPIERS",
                        }
                    }));
                end

                function OpenSubRadialActions()
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
                                name = "CIRCULATION",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/road.svg",
                                action = "openTraficMenu"
                            },
                            {
                                name = "RETOUR",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                action = "OpenMainRadialboi"
                            },
                            {
                                name = "OBJETS",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/object.svg",
                                action = "OpenPropsMenuboi"
                            }
                        }, 
                        title = "ACTIONS",
                        }
                    }));
                end

                function OpenMainRadialboi()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = { elements = {
                            {
                                name = "APPEL DE RENFORT",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/police_logo.svg",
                                action = "makeRenfortCallboi"
                            }, 
                            --[[ {
                                name = "CODE 99",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/police_logo.svg",
                                action = "makeCode99Callboi"
                            },  ]]
                            {
                                name = "PAPIERS",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/paper.svg",
                                action = "OpenSubRadialPapiers"
                            },
                            {
                                name = "PRISE DE SERVICE",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/checkmark.svg",
                                action = "SetboiDuty"
                            },
                            {
                                name = "ACTIONS",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/police.svg",
                                action = "OpenSubRadialActions"
                            }
                        }, title = "B.O.I"}
                    }));
                end

                OpenMainRadialboi()
            end)
        else
            openRadial = false
            SetNuiFocusKeepInput(false)
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 142, true)
            EnableControlAction(0, 18, true)
            EnableControlAction(0, 322, true)
            EnableControlAction(0, 106, true)
            SetNuiFocus(false, false)
            SendNuiMessage(json.encode({
                type = 'closeWebview'
            }))
            return
        end
    end

    function BOIVestiaireDev()
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            content = "Vous venez de récupérer votre veste"
        })

        if p:isMale() then
            TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1, {renamed = "Veste BOI Homme", data = tenue.male})
        else
            TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1, {renamed = "Veste BOI Femme", data = tenue.female})
        end
    end

    local open = false
    local boimenu_objects = RageUI.CreateMenu("", "boi", 0.0, 0.0, "vision", "menu_tittle_boi")
    local boimenu_traffic = RageUI.CreateMenu("", "boi", 0.0, 0.0, "vision", "menu_tittle_boi")
    local boimenu_traffic_view = RageUI.CreateSubMenu(boimenu_traffic, "", "boi", 0.0, 0.0, "vision",
        "menu_tittle_boi")
    local boimenu_traffic_add = RageUI.CreateSubMenu(boimenu_traffic, "", "B.O.I", 0.0, 0.0, "vision",
        "menu_tittle_boi")
    local boimenu_objects_delete = RageUI.CreateSubMenu(boimenu_objects, "", "B.O.I", 0.0, 0.0, "vision",
        "menu_tittle_boi")
    boimenu_objects.Closed = function()
        open = false
    end
    boimenu_traffic.Closed = function()
        open = false
        speed = 0.0
        radius = 0.0
        show = false
        zoneName = ""
    end

    
    local traficList = {}
    local speed = 0.0
    local radius = 0.0
    local show = false
    local zoneName = ""
    local zonePos = vector3(0, 0, 0)

    function openTraficMenu()
        if boiDuty then
            -- open a menu with 2 buttons : one to add a new zone and one to view my zones
            if open then
                open = false
                RageUI.Visible(boimenu_traffic, false)
            else
                open = true
                RageUI.Visible(boimenu_traffic, true)

                Citizen.CreateThread(function()
                    while open do
                        RageUI.IsVisible(boimenu_traffic, function()
                            -- for the first button to add a new zone, it opens a menu where i can set the speed in the zone and the radius of the zone, another checkbox to show it on my client and a last button to add the zone
                            RageUI.Button("Ajouter une zone", nil, { RightLabel = ">" }, true, {
                                onSelected = function()
                                    zonePos = p:pos()
                                end
                            }, boimenu_traffic_add)
                            -- for the second button to view my zones, it opens a menu where i can see all my zones and delete them
                            RageUI.Button("Voir les zones", nil, { RightLabel = ">" }, true, {
                                onSelected = function()
                                    traficList = TriggerServerCallback("lspd:traffic:get")
                                end
                            }, boimenu_traffic_view)
                        end)
                        RageUI.IsVisible(boimenu_traffic_add, function()
                            -- for the speed and radius button, prompt a keyboard to enter the value
                            RageUI.Button("Vitesse", nil, { RightLabel = speed .. " km/h" }, true, {
                                onSelected = function()
                                    speed = tonumber(KeyboardImput("Vitesse")) + .0
                                    if speed == nil then
                                        speed = 0.0
                                    end
                                end
                            })
                            RageUI.Button("Rayon", nil, { RightLabel = radius .. " m" }, true, {
                                onSelected = function()
                                    radius = tonumber(KeyboardImput("Rayon")) + .0
                                    if radius == nil then
                                        radius = 0.0
                                    end
                                end
                            })
                            RageUI.Checkbox("Afficher", nil, show, {}, {
                                onChecked = function()
                                    show = true
                                end,
                                onUnChecked = function()
                                    show = false
                                end
                            })
                            RageUI.Button("Nom de la zone", nil, { RightLabel = zoneName }, true, {
                                onSelected = function()
                                    zoneName = KeyboardImput("Nom de la zone")
                                end
                            })
                            RageUI.Button("Ajouter la zone", nil, {}, true, {
                                onSelected = function()
                                    if radius ~= 0 and zoneName ~= "" then
                                        local id = AddRoadNodeSpeedZone(zonePos, radius, speed, true)
                                        local newZone = {
                                            zoneName = zoneName,
                                            zonePos = zonePos,
                                            zoneRadius = radius,
                                            zoneSpeed = speed,
                                            zoneId = id 
                                        }
                                        show = false
                                        TriggerServerEvent("lspd:traffic:add", newZone)
                                        -- ShowNotification("~g~Zone ajoutée")

                                        -- New notif
                                        exports['vNotif']:createNotification({
                                            type = 'VERT',
                                            -- duration = 5, -- In seconds, default:  4
                                            content = "~s Zone ajoutée"
                                        })
                                        open = false
                                        RageUI.CloseAll()
                                    else
                                        -- ShowNotification("~r~Veuillez remplir tous les champs")

                                        -- New notif
                                        exports['vNotif']:createNotification({
                                            type = 'ROUGE',
                                            -- duration = 5, -- In seconds, default:  4
                                            content = "~s Veuillez remplir tous les champs"
                                        })
                                    end
                                end
                            })
                        end)
                        RageUI.IsVisible(boimenu_traffic_view, function()
                            for k, v in pairs(traficList) do
                                RageUI.Button(v.zoneId .. " | " .. v.zoneName, nil, { RightLabel = "~r~ Supprimer" }, true,
                                    {
                                        onSelected = function()
                                            RemoveRoadNodeSpeedZone(v.zoneId)
                                            TriggerServerEvent("lspd:traffic:remove", v.zoneId)
                                           -- ShowNotification("~r~Zone supprimée")

                                            -- New notif
                                            exports['vNotif']:createNotification({
                                                type = 'VERT',
                                                -- duration = 5, -- In seconds, default:  4
                                                content = "~s Zone supprimée"
                                            })
                                            RageUI.GoBack()
                                        end,
                                        onActive = function()
                                            local distance = v.zoneRadius + .0
                                            DrawMarker(1, v.zonePos + vector3(0.0, 0.0, -1000.0), 0.0, 0.0, 0.0, 0.0, 0.0, .0
                                                , distance + .0, distance + .0, 10000.0, 20, 192, 255, 70, 0, 0, 2
                                                , 0, 0, 0, 0)
                                        end
                                    })
                            end
                        end)
                        if show then
                            -- draw circle around player with the radius of the zone
                            local distance = radius + .0
                            DrawMarker(1, p:pos() + vector3(0.0, 0.0, -1000.0), 0.0, 0.0, 0.0, 0.0, 0.0, .0, distance + .0,
                                distance + .0, 10000.0, 20, 192, 255, 70, 0, 0, 2, 0, 0, 0, 0)
                        end
                        Wait(1)
                    end
                end)
            end
        else
            -- ShowNotification("~r~Vous n'êtes pas en service")
                    
            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous n'êtes ~s pas en service"
            }) 
        end
    end

    RegisterNUICallback("focusOut", function(data, cb)
        if openRadial then
            openRadial = false
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 142, true)
            EnableControlAction(0, 18, true)
            EnableControlAction(0, 322, true)
            EnableControlAction(0, 106, true)
        end
        cb({})
    end)

    function SetboiDuty()
        if boiDuty then
            TriggerServerEvent('core:DutyOff', 'boi')
            --  ShowNotification("Vous avez ~r~quitté~s~ votre service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s quitté ~c votre service"
            })
            boiDuty = false
            Wait(5000)
        else
            TriggerServerEvent('core:DutyOn', 'boi')
            --  ShowNotification("Vous avez ~r~quitté~s~ votre service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s pris ~c votre service"
            })
            boiDuty = true
            Wait(5000)
        end
    end

    RegisterJobMenu(OpenRadialboiMenu)

    zone.addZone("boi_spawn_nord", vector3(2515.1740722656, -455.37252807617, 94.098167419434),
        "~INPUT_CONTEXT~ Garage", function()
            menuChoose = 'car'
            OpenMenuVehboi()
        end, false,
        27,
        1.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleGarage"
    )

    zone.addZone("boi_delete_nord", vector3(2521.2126464844, -459.68649291992, 91.992950439453),
        "~INPUT_CONTEXT~ Ranger le véhicule", function()
            if IsPedInAnyVehicle(p:ped(), false) then
                local veh = GetVehiclePedIsIn(p:ped(), false)
                --removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                DeleteEntity(veh)

            end
        end, false, 36, 0.5, { 255, 0, 0 }, 255
    )


    local open = false
    local main = RageUI.CreateMenu("", "Action Disponible", 0.0, 0.0, "vision", "menu_tittle_boi")

    local vehs = nil
    ---OpenVeh

    zone.addZone("society_boi", vector3(2474.2104492188, -364.30023193359, 81.694007873535),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les actions d'entreprise", function()
            OpenSocietyMenu()
        end, false, 25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170-- Alpha
    )

   
    RegisterNUICallback("focusOut", function (data, cb)
        TriggerScreenblurFadeOut(0.5)
        DisplayHud(true)
        openRadarProperly()
    end)

    local oldSkin = {}
    local open = false
    local outfitmenu = RageUI.CreateMenu("", "boi", 0.0, 0.0, "vision", "menu_tittle_boi")
    local outfitmenu_list = RageUI.CreateSubMenu(outfitmenu, "", "boi", 0.0, 0.0, "vision", "menu_tittle_boi")
    outfitmenu.Closed = function()
        local playerSkin = p:skin()
        ApplySkin(oldSkin)
        open = false
    end

    local selected_table = {}
    
end

function UnloadBOI()
    zone.removeZone("casier_boi")
    zone.removeZone("boi_vestiaire")
    zone.removeZone("boi_item")
    zone.removeZone("boi_spawn_nord")
    zone.removeZone("boi_delete_nord")
    zone.removeZone("society_boi")
    boiDuty = false
end

RegisterNUICallback("Menu_boi_vehicule_callback", function (data, cb)
    if vehicle.IsSpawnPointClear(vector3(2521.0789, -459.4331, 92.9929), 5.0) then
        vehs = vehicle.create(data.name, vector4(2521.0789, -459.4331, 92.9929, 187.0411), {})
        local plate = vehicle.getProps(vehs).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
        --createKeys(plate, model)
        SetVehicleMod(vehs, 11, 1, false)
        SetVehicleMod(vehs, 12, 1, false)
        SetVehicleMod(vehs, 13, 1, false)
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Il n'y a ~s pas de place ~c pour le véhicule"
        })
    end
end)


    -- MENU PROPS
    local boiPropsPlaced = {}

    local function SpawnPropsBOI(obj, name)
        local coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
        local objCoords = (coords + forward * 2.5)
        local placed = false
        local heading = p:heading()
        TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)

        local objS = entity:CreateObject(obj, objCoords)
        objS:setPos(objCoords)
        objS:setHeading(heading)
        PlaceObjectOnGroundProperly(objS.id)

        while not placed do
            coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
            objCoords = (coords + forward * 2.5)
            objS:setPos(objCoords)
            PlaceObjectOnGroundProperly(objS.id)
            objS:setAlpha(170)
            SetEntityCollision(objS.id, false, true)

            if IsControlPressed(0, 190) then
                heading = heading + 0.5
            elseif IsControlPressed(0, 189) then
                heading = heading - 0.5
            end

            SetEntityHeading(objS.id, heading)

            ShowHelpNotification(
                "Appuyez sur ~INPUT_CONTEXT~ pour placer l'objet\n~INPUT_FRONTEND_LEFT~ ou ~INPUT_FRONTEND_RIGHT~ Pour faire pivoter l'objet") -- \n ~INPUT_VEH_FLY_DUCK~ Pour annuler
            if IsControlJustPressed(0, 38) then
                placed = true

                OpenPropsMenuboi()
            end
            
            Wait(0)
        end
        SetEntityCollision(objS.id, true, true)
        -- SetEntityInvincible(objS.id, true)
        -- objS:setFreeze(true)
        objS:resetAlpha()
        local netId = objS:getNetId()
        if netId == 0 then
            objS:delete()
        end
        SetNetworkIdCanMigrate(netId, true)
        table.insert(boiPropsPlaced, {
            nom = name,
            prop = objS.id
        })
    end

       
    PropsMenu = {
        cam = nil,
        open = false,
    }
    
    RegisterNUICallback("focusOut", function()
        if PropsMenu.open then
            PropsMenu.open = false 
        end
    end)
    
    DataSendPropsboi = {
        items = {
            {   
                name = 'main',
                type = 'buttons',
                elements = {
                    {
                        name = 'Cones',
                        width = 'full',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/cones.svg',
                        hoverStyle = ' stroke-black'
                    },
                    {
                        name = 'Panneaux',
                        width = 'full',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/roadsign.svg',
                        hoverStyle = ' stroke-black'
                    },
                    {
                        name = 'Barrières',
                        width = 'full',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/barriere.svg',
                        hoverStyle = ' stroke-black'
                    },
                    {
                        name = 'Lumières',
                        width = 'full',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/light.svg',
                        hoverStyle = ' stroke-black'
                    },
                    {
                        name = 'Tables',
                        width = 'full',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/table.svg',
                        hoverStyle = ' stroke-black'
                    },
                    {
                        name = 'Drogues',
                        width = 'full',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/drogues.svg',
                        hoverStyle = ' stroke-black'
                    },
                    {
                        name = 'Divers',
                        width = 'full',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/divers.svg',
                        hoverStyle = ' stroke-black'
                    },
                    {
                        name = 'Cibles Tir',
                        width = 'full',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/ciblestir.svg',
                        hoverStyle = ' stroke-black'
                    },
                    {
                        name = 'Sacs',
                        width = 'full',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/sacs.svg',
                        hoverStyle = ' stroke-black'
                    },
                },
            },
            {
                name = 'Cones',
                type = 'elements',
                elements = {},
            },
            {
                name = 'Panneaux',
                type = 'elements',
                elements = {},
            },
            {
                name = 'Barrières',
                type = 'elements',
                elements = {},
            },
            {
                name = 'Lumières',
                type = 'elements',
                elements = {},
            },
            {
                name = 'Tables',
                type = 'elements',
                elements = {},
            },
            {
                name = 'Drogues',
                type = 'elements',
                elements = {},
            },
            {
                name = 'Divers',
                type = 'elements',
                elements = {},
            },
            {
                name = 'Cibles Tir',
                type = 'elements',
                elements = {},
            },
            {
                name = 'Sacs',
                type = 'elements',
                elements = {},
            },
        },
    
    
        -- headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
        -- headerIconName = 'Cones',
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/usss/header_boi.webp',
        callbackName = 'MenuObjetsServicesPublicsboi',
        headerTitle = "OBJETS SERVICES PUBLICS",
        showTurnAroundButtons = false,
    }
    
    local firstart = false


local cones_models = {
    ['#1']     = "prop_air_conelight",
    ['#2']     = "prop_barrier_wat_03b",
    ['#3']     = "prop_mp_cone_03",
    ['#4']     = "prop_mp_cone_04",
    ['#5']     = "prop_roadcone02a",
    ['#6']     = "prop_roadcone02b",
    ['#7']     = "prop_roadpole_01a",
    ['#8']     = "prop_roadpole_01b",
    ['#9']     = "prop_trafficdiv_01",
    ['#10']     = "prop_trafficdiv_02",
}

local panneaux_models = {
    ['#1']     = "prop_consign_01b",
    ['#2']     = "prop_consign_02a",
    ['#3']     = "prop_sign_road_01a",
    ['#4']     = "prop_sign_road_03a",
    ['#5']     = "prop_sign_road_06a",
    ['#6']     = "prop_sign_road_06f",
    ['#7']     = "prop_sign_road_06q",
    ['#8']     = "prop_sign_road_06r",
}

local barriere_models = {
    ['#1']     = "prop_barier_conc_05c",
    ['#2']     = "prop_barrier_work01a",
    ['#3']     = "prop_barrier_work01b",
    ['#4']     = "prop_barrier_work02a",
    ['#5']     = "prop_barrier_work06b",
    ['#6']     = "prop_fncsec_04a",
    ['#7']     = "prop_mp_arrow_barrier_01",
    ['#8']     = "prop_mp_barrier_02b",
    ['#9']     = "prop_plas_barier_01a",
    ['#10']     = "prop_barrier_work05",
    ['#11']     = "prop_barrier_work06a",
}

local lumiere_models = {
    ['#1']     = "prop_generator_03b",
    ['#2']     = "prop_worklight_01a",
    ['#3']     = "prop_worklight_03b",
    ['#4']     = "prop_worklight_04a",
    ['#5']     = "prop_worklight_04b",
}

local tables_models = {
    ['#1']     = "bkr_prop_weed_table_01b",
    ['#2']     = "prop_ven_market_table1",
}

local drogues_models = {
    ['#1']     = "bkr_prop_bkr_cashpile_01",
    ['#2']     = "bkr_prop_meth_openbag_02",
    ['#3']     = "bkr_prop_meth_smallbag_01a",
    ['#4']     = "bkr_prop_moneypack_03a",
    ['#5']     = "bkr_prop_weed_smallbag_01a",
    ['#6']     = "ex_office_swag_drugbag2",
    ['#7']     = "imp_prop_impexp_boxcoke_01",
    ['#8']     = "imp_prop_impexp_coke_pile",
}

local divers_models = {
    ['#1']     = "gr_prop_gr_laptop_01c",
    ['#2']     = "prop_rad_waste_barrel_01",
    ['#3']     = "prop_gazebo_02",
}

local sacs_models = {
    ['#1']     = "xm_prop_x17_bag_01c",
    ['#2']     = "xm_prop_x17_bag_med_01a",
}

local cibletir_models = {
    ['#1']     = "gr_prop_gr_target_05a",
    ['#2']     = "gr_prop_gr_target_05b",
}

RegisterNUICallback("MenuObjetsServicesPublicsboi", function(data, cb)
    -- if data == nil or data.category == nil then return end
    -- PropsMenu.choice = data.category

    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))

    if data.category == "Cones" then 
        SpawnPropsBOI(cones_models[data.label], data.label)
    end
    
    if data.category == "Panneaux" then 
        SpawnPropsBOI(panneaux_models[data.label], data.label)
    end

    if data.category == "Barrières" then 
        SpawnPropsBOI(barriere_models[data.label], data.label)
    end

    if data.category == "Lumières" then 
        SpawnPropsBOI(lumiere_models[data.label], data.label)
    end

    if data.category == "Tables" then 
        SpawnPropsBOI(tables_models[data.label], data.label)
    end

    if data.category == "Drogues" then 
        SpawnPropsBOI(drogues_models[data.label], data.label)
    end

    if data.category == "Divers" then 
        SpawnPropsBOI(divers_models[data.label], data.label)
    end

    if data.category == "Cibles Tir" then 
        SpawnPropsBOI(cibletir_models[data.label], data.label)
    end

    if data.category == "Sacs" then 
        SpawnPropsBOI(sacs_models[data.label], data.label)
    end

end)

function OpenPropsMenuboi()
    if firstart == false then
        firstart = true 
        local bool = GetDatasPropsboi()
        while not bool do 
            Wait(1)
        end
    end
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
    Wait(50)
    PropsMenu.open = true
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'MenuObjetsServicesPublics',
        data = DataSendPropsboi
    }))
end

function GetDatasPropsboi()
    -- DataSendPropsboi.items.elements = {}

    playerJobs = p:getJob()

    -- Cones
    for i = 1, 10 do
        table.insert(DataSendPropsboi.items[2].elements, {
            id = i,
            image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Cones/"..i..".webp",
            category="Cones", 
            label = "#"..i
        })
    end


   -- Panneaux
    for i = 1, 8 do
        table.insert(DataSendPropsboi.items[3].elements, {
            id = i,
            image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Panneaux/"..i..".webp",
            category="Panneaux",
            label = "#"..i
        })
    end

    -- Barrière
    for i = 1, 11 do
        table.insert(DataSendPropsboi.items[4].elements, {
            id = i,
            image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Barrieres/"..i..".webp",
            category="Barrières",
            label = "#"..i
        })
    end

    -- Lumières
    for i = 1, 5 do
        table.insert(DataSendPropsboi.items[5].elements, {
            id = i,
            image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Lumieres/"..i..".webp",
            category="Lumières",
            label = "#"..i
        })
    end

    -- Tables
    for i = 1, 2 do
        table.insert(DataSendPropsboi.items[6].elements, {
            id = i,
            image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Tables/"..i..".webp",
            category="Tables",
            label = "#"..i
        })
    end

    -- Drogues
    for i = 1, 8 do
        table.insert(DataSendPropsboi.items[7].elements, {
            id = i,
            image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Drogues/"..i..".webp",
            category="Drogues",
            label = "#"..i
        })
    end

    -- Divers
    for i = 1, 3 do
        table.insert(DataSendPropsboi.items[8].elements, {
            id = i,
            image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Divers/"..i..".webp",
            category="Divers",
            label = "#"..i
        })
    end

    -- Cible Tir
    for i = 1, 2 do
        table.insert(DataSendPropsboi.items[9].elements, {
            id = i,
            image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/CiblesTir/"..i..".webp",
            category="Cibles Tir",
            label = "#"..i
        })
    end

    -- Sacs
    for i = 1, 2 do
        table.insert(DataSendPropsboi.items[10].elements, {
            id = i,
            image="https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/"..playerJobs.."/Sacs/"..i..".webp",
            category="Sacs",
            label = "#"..i
        })
    end


    DataSendPropsboi.disableSubmit = true

    return true
end


RegisterNUICallback("armoryTakeboi", function(data, cb)
    for k, v in pairs(data) do
        TriggerSecurGiveEvent("core:addItemToInventory", token, v.name, 1, {})
        exports['vNotif']:createNotification({
            type = 'DOLLAR',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous venez de récupérer ~s un(e) ".. v.label
        })
    end
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
end)

local listVehboi = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/LSPD/header.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/LSPD/logo_vehicule.webp',
    headerIconName = 'VEHICULE',
    callbackName= 'Menu_boi_vehicule_callback',
    elements = {
        {
            label = 'Oracle',
            name = 'fbi',
            image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/lspd/fbi.webp",
            category= 'Autres'
        },
        {
            label = 'Granger',
            name = 'fbi2',
            image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/lspd/fbi2.webp",
            category= 'Autres'
        },
        {
            label = 'Stanier',
            name = 'police4',
            image="https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/lspd/police4.webp",
            category= 'Autres'
        },
    },
}

function OpenMenuVehboi()
    forceHideRadar()
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'MenuCatalogue',
        data = listVehboi
    }))
end

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7boi ^3loaded")
end)