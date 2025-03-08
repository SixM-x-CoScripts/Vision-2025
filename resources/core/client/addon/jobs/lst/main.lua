local open = false
local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

--Keys.Register("F2", "F2", "Ouvrir les portes du véhicule", function()
--    OpenDoor()
--end)

CreateThread(function()
    while zone == nil do Wait(1)end

    local ped = entity:CreatePedLocal("s_m_m_lsmetro_01", vector3(474.65893554688, -576.822265625, 27.499736785889),  175.5)
    ped:setFreeze(true)
    SetEntityInvincible(ped.id, true)
    SetEntityAsMissionEntity(ped.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped.id, true)

    local ped2 = entity:CreatePedLocal("s_m_m_lsmetro_01", vector3(452.22833251953, -544.83587646484, 27.511262893677),  233.47)
    ped2:setFreeze(true)
    SetEntityInvincible(ped2.id, true)
    SetEntityAsMissionEntity(ped2.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped2.id, true) 

    local ped3 = entity:CreatePedLocal("s_m_m_lsmetro_01", vector3(457.76260375977, -537.58660888672, 27.543020248413),  231.45)
    ped3:setFreeze(true)
    SetEntityInvincible(ped3.id, true)
    SetEntityAsMissionEntity(ped3.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped3.id, true) 

end)

local coffrePos = {
    vector3(457.97897338867, -537.98291015625, 31.803611755371),
}

local spawnPlaces = {
    vector4(471.50521850586, -587.3916015625, 27.499620437622, 165.11094665527),
    vector4(464.96069335938, -586.83941650391, 27.499742507935, 157.00857543945),
    vector4(453.97158813477, -578.98297119141, 27.499807357788, 245.98419189453),
    vector4(451.98123168945, -586.10583496094, 27.49981880188, 253.75805664063),
}

lstDuty = false

local main = RageUI.CreateMenu("", "Action disponible", 0.0, 0.0, "shopui_title_carmod", "shopui_title_carmod")
local liveries = RageUI.CreateSubMenu(main, "", "Action disponible")
local stickers = RageUI.CreateSubMenu(main, "", "Action disponible")
local extra = RageUI.CreateSubMenu(main, "", "Action disponible")
local colors = RageUI.CreateSubMenu(main, "", "Changer la couleur")
local open = false
main.Closed = function()
    RageUI.Visible(main, false)
    RageUI.Visible(liveries, false)
    RageUI.Visible(stickers, false)
    RageUI.Visible(extra, false)
    RageUI.Visible(colors, false)
    open = false
end

function extraVeh(veh)
    if open then
        open = false
        RageUI.Visible(main, false)
        RageUI.Visible(liveries, false)
        RageUI.Visible(stickers, false)
        RageUI.Visible(extra, false)
        RageUI.Visible(colors, false)
        return
    else
        open = true
        RageUI.Visible(main, true)
        Citizen.CreateThread(function()
            while open do
                RageUI.IsVisible(main, function()
                    RageUI.Button("Motif", false, { RightLabel = ">" }, true, {
                        onSelected = function()
                        end
                    }, liveries)
                    RageUI.Button("Stickers", false, { RightLabel = ">" }, true, {
                        onSelected = function()
                        end
                    }, stickers)
                    RageUI.Button("extra", false, { RightLabel = ">" }, true, {
                        onSelected = function()
                        end
                    }, extra)
                    RageUI.Button("Couleur", false, { RightLabel = ">" }, true, {
                        onSelected = function()
                        end
                    }, colors)
                end)
                RageUI.IsVisible(liveries, function()
                    if GetNumVehicleMods(veh, 48) == 0 then
                        RageUI.Separator("Pas de modification disponible")
                    else
                        for i = 1, GetNumVehicleMods(veh, 48) do
                            local name = GetLabelText(GetModTextLabel(veh, 48, i))
                            if name == "NULL" then
                                name = "Original"
                            end
                            if index == i then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end

                            RageUI.Button(name, false, { RightBadge = Rightbadge }, true, {
                                onActive = function()
                                    SetVehicleMod(veh, 48, i, 0)
                                end,
                                onSelected = function()
                                    index = i
                                    SetVehicleMod(veh, 48, i, 0)
                                end
                            }, nil)
                        end
                    end
                end)
                RageUI.IsVisible(stickers, function()
                    if GetVehicleLiveryCount(veh) == -1 then
                        RageUI.Separator("Pas de modification disponible")
                    else
                        for i = 1, GetVehicleLiveryCount(veh) do
                            local name = GetLabelText(GetLiveryName(veh, i))
                            if name == "NULL" then
                                name = "Original"
                            end
                            if index == i then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end

                            RageUI.Button(name, false, { RightBadge = Rightbadge }, true, {
                                onActive = function()
                                    SetVehicleLivery(veh, i)
                                end,
                                onSelected = function()
                                    index = i
                                    SetVehicleLivery(veh, i)
                                end
                            }, nil)

                        end
                    end
                end)
                RageUI.IsVisible(extra, function()
                    local veh = p:currentVeh()
                    local availableExtras = {}
                    extrasExist = false
                    for extra = 0, 20 do
                        if DoesExtraExist(veh, extra) then
                            availableExtras[extra] = extra
                            extrasExist = true
                        end
                    end
                    
                    if not extrasExist then
                        RageUI.Separator("Pas de modification disponible")
                    else
                        for i in pairs(availableExtras) do
                            name = 'ORIGINAL'
                            if index == i then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end
                            RageUI.Button(name, false, { RightBadge = Rightbadge }, true, {

                                onSelected = function()
                                    if IsVehicleExtraTurnedOn(veh, i) then
                                        SetVehicleExtra(veh, i, 1)
                                    else
                                        index = i
                                        SetVehicleExtra(veh, i, 0)
                                    end
                                end
                            }, nil)
                        end
                    end
                end)
                                RageUI.IsVisible(colors, function()
                    local colorOptions = {
                        {name = "Noir", color = 0},
                        {name = "Argent Ombré", color = 7},
                        {name = "Rouge", color = 27},
                        {name = "Bleu", color = 75},
                        {name = "Vert", color = 49},
                        {name = "Brun clair", color = 98},
                    }

                    for _, colorData in pairs(colorOptions) do
                        local name = colorData.name
                        local color = colorData.color

                        if index == color then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end

                        RageUI.Button(name, false, { RightBadge = Rightbadge }, true, {
                            onSelected = function()
                                index = color
                                SetVehicleColours(veh, color, color)
                            end
                        }, nil)
                    end
                end)
                Wait(0)
            end
        end)
    end
end

function LoadLstJob()
    
    local openRadial = false
    --Zone: San Andreas
    zone.addZone("society_lst_vestiaire", vector3(452.22833251953, -544.83587646484, 28.511262893677),
        "Appuyer sur ~INPUT_CONTEXT~ pour prendre une tenue", 
        function()
            LSTVestiaireDev()
        end, false,
        27,
        0.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleVetement"
    )

    zone.addZone(
        "society_lst_custom",
        vector3(455.55838012695, -562.26947021484, 27.799909591675),
        "Appuyer sur ~INPUT_CONTEXT~ pour éditer votre vehicule",
        function()
            local veh = p:currentVeh()
            extraVeh(veh)
        end,
        true,
        39, -- Id / type du marker
        0.5, -- La taille
        { 203, 75, 0 }, -- RGB
        170-- Alpha
    )
    zone.addZone(
        "society_lst_delete",
        vector3(471.50521850586, -587.3916015625, 28.0),
        "~INPUT_CONTEXT~ Ranger le véhicule",
        function()
            if IsPedInAnyVehicle(p:ped(), false) then
                if GetVehicleBodyHealth(p:currentVeh()) / 10 >= 80 or GetVehicleEngineHealth(p:currentVeh()) / 10 >= 80 then
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
        end,
        true,
        39, 0.5, { 255, 0, 0 }, 255
    )
    zone.addZone(
        "society_lst_spawn",
        vector3(474.65893554688, -576.822265625, 27.499736785889),
        "~INPUT_CONTEXT~ Sortir le véhicule",
        function()
            if lstDuty then
                OpenMenuVehLst() --TODO: fini le menu society
            else
                -- ShowNotification("Vous n'êtes pas en service")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous n'êtes ~s pas en service"
                })
            end
        end,
        false,
        25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170-- Alpha
    )

    zone.addZone(
        "society_lst_giveCard", vector3(457.76260375977, -537.58660888672, 27.543020248413),
        "Appuyer sur ~INPUT_CONTEXT~ pour récupérer votre carte et votre radio",
        function()
            if lstDuty then
                OpenMenuItemsLst()
            else
                -- ShowNotification("Vous n'êtes pas en service")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous n'êtes ~s pas en service"
                })
            end
        end,
        false,
        25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170-- Alpha
    )

    for k, v in pairs(coffrePos) do
        zone.addZone(
            "casier_lst" .. k,
            v,
            "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les casiers",
            function()
                OpenlstCasier() --TODO: fini le menu society
            end, false,
            27,
            1.5,
            { 255, 255, 255 },
            170,
            2.0,
            true,
            "bulleCasiers"
        )
    end

    local casierOpen = false
    function OpenlstCasier()
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

    local listVeh = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_lst.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
        headerIconName = 'VEHICULES',
        callbackName = 'vehMenuLST',
        elements = {
            {
                id = 1,
                image = 'https://i.imgur.com/g5Wzbg3.webp',
                label = 'Bus N°1',
                spawnName = "bus"
            },
            {
                id = 2,
                image = 'https://i.imgur.com/g5Wzbg3.webp',
                label = 'Bus N°2',
                spawnName = "bus4"
            },
            {
                id = 3,
                image = 'https://i.imgur.com/g5Wzbg3.webp',
                label = 'Bison',
                spawnName = "bisonutil"
            },
        }
    }

    function OpenMenuVehLst()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listVeh
        }))
    end

    RegisterNUICallback("focusOut", function (data, cb)
        TriggerScreenblurFadeOut(0.5)
        DisplayHud(true)
        openRadarProperly()
    end)

    local listItems = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_lst.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/interact/Fouiller.webp',
        headerIconName = 'CATALOGUE',
        callbackName = 'itemsMenuLST',
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
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/items/lstcard.webp",
                name = "lstcard",
                label = "Carte Pro",
            },
        },
    }

    function OpenMenuItemsLst()
        FreezeEntityPosition(PlayerPedId(), true)
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogueAchat',
            data = listItems
        }));

        RegisterNUICallback("focusOut", function (data, cb)
            TriggerScreenblurFadeOut(0.5)
            openRadarProperly()
            RenderScriptCams(false, false, 0, 1, 0)
            DestroyCam(cam, false)
            FreezeEntityPosition(PlayerPedId(), false)
        end)
    end


    function FactureLstNews(entity)
        if lstDuty then
            local billing_price = 0
            local billing_reason = ""
            local price = KeyboardImput("Entrez le prix")
            if price and type(tonumber(price)) == "number" then
                billing_price = tonumber(price)
            else
                -- ShowNotification("Veuillez entrer un nombre")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Veuillez entrer un nombre"
                })

            end
            local reason = KeyboardImput("Entrez la raison")
            if reason ~= nil then
                billing_reason = tostring(reason)
            end

            local closestPlayer, closestDistance = GetClosestPlayer()
            if closestPlayer ~= nil and closestDistance < 3.0 then
                TriggerServerEvent('core:sendbilling', token, GetPlayerServerId(closestPlayer),
                    p:getJob(), billing_price, billing_reason)
            else
                -- ShowNotification("Aucun joueur dans la zone")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Aucun joueur dans la zone"
                })

            end
        else
            -- ShowNotification("Vous n'êtes pas en service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous n'êtes ~s pas en service"
            })
        end
    end

    function LstDuty()
        openRadial = false
        closeUI()
        if lstDuty then
            TriggerServerEvent('core:DutyOff', 'lst')
            --  ShowNotification("Vous avez ~r~quitté~s~ votre service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s quitté ~c votre service"
            })

            lstDuty = false
            Wait(5000)
        else
            TriggerServerEvent('core:DutyOn', 'lst')
            --  ShowNotification("Vous avez ~r~quitté~s~ votre service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s pris ~c votre service"
            })
            lstDuty = true
            Wait(5000)
        end

    end

    function FactureLst()
        if lstDuty then
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

    function CreateAdvert()
        if lstDuty then
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

    function CoursesLst()
        if lstDuty then
            openRadial = false
            closeUI()
            MissionPnjLst()
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function OpenRadialLstMenu()
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
                end
            end)
            SetNuiFocusKeepInput(true)
            SetNuiFocus(true, true)
            Wait(200)
            CreateThread(function()
                function OpenSubLineALST()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = { elements = {
                            {
                                name = "Red",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/lst/lstRed.svg",
                                action = "AactionLineR"
                            },
                            {
                                name = "Green",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/lst/lstGreen.svg",
                                action = "AactionLineG"
                            },
                            {
                                name = "Blue",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/lst/lstBlue.svg",
                                action = "AactionLineB"
                            },
                            {
                                name = "Retour",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                action = "OpenSubChoiceLineLST"
                            }
                        }, title = "Choix de la ligne A"
                        }
                    }));
                end

                function OpenSubLineBLST()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = { elements = {
                            {
                                name = "Red",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/lst/lstRed.svg",
                                action = "BactionLineR"
                            },
                            {
                                name = "Green",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/lst/lstGreen.svg",
                                action = "BactionLineG"
                            },
                            {
                                name = "Blue",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/lst/lstBlue.svg",
                                action = "BactionLineB"
                            },
                            {
                                name = "Retour",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                action = "OpenSubChoiceLineLST"
                            }
                        }, title = "Choix de la ligne B"
                        }
                    }));
                end

                function OpenSubChoiceLineLST()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = { elements = {
                            {
                                name = "A",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/icons/right.svg",
                                action = "OpenSubLineALST"
                            },
                            {
                                name = "Annuler la ligne",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/icons/x.svg",
                                action = "CancelLineLST"
                            },
                            {
                                name = "B",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/icons/left.svg",
                                action = "OpenSubLineBLST"
                            },
                            {
                                name = "Retour",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                action = "OpenMainRadialLST"
                            }
                        }, title = "Choix du sens"
                        }
                    }));
                end

                function OpenMainRadialLST()
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
                                action = "FactureLst"
                            },
                            {
                                name = "PRISE DE SERVICE",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/checkmark.svg",
                                action = "LstDuty"
                            },
                            {
                                name = "Lignes",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/lst/lstcar.svg",
                                action = "OpenSubChoiceLineLST"
                            }
                        }, title = "LS Transit"
                        }
                    }));
                end

                OpenMainRadialLST()
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
                type = 'closeWebview',
            }))
            return
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

    end

    RegisterJobMenu(OpenRadialLstMenu)
end

function UnLoadLstJob()
    zone.removeZone("society_lst")
    zone.removeZone("society_lst_delete")
    zone.removeZone("society_lst_spawn")
    zone.removeZone("coffre_plst")
    zone.removeZone("casier_lst")
end

RegisterNUICallback("vehMenuLST", function (data, cb)
    for k, v in pairs(spawnPlaces) do
        if vehicle.IsSpawnPointClear(vector3(v.x, v.y, v.z), 3.0) then
            if DoesEntityExist(vehs) then
                TriggerEvent('persistent-vehicles/forget-vehicle', vehs)
                --removeKeys(GetVehicleNumberPlateText(vehs), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehs))
                DeleteEntity(vehs)
            end
            vehs = vehicle.create(data.spawnName, vector4(v), {})
           local plate = vehicle.getProps(vehs).plate
            local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
            local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
            --createKeys(plate, model)
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
    end
end)

RegisterNUICallback("itemsMenuLST", function(data, cb)
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