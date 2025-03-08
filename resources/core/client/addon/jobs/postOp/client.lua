local NUI_CALLBACK_NAME = 'PostOp'

local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local zonePostOP = {
    {
        position = vector3(-423.86474609375, -2810.2680664063, 5.9949440956116),
        blip = vector3(-423.86474609375, -2810.2680664063, 5.9949440956116)
    }
}

local spawnPlaces = {
    vector4(-434.74700927734, -2818.580078125, 4.9949440956116, 224.38349914551),
    vector4(-420.62274169922, -2812.048828125, 5.2201108932495, 315.02099609375),
}


local PostOPShop = {
    open = false,
    cam = nil,    
}

local function closeWebViewAndRemoveFocus() 
    SetNuiFocus(false, false)
    SendNuiMessage(json.encode({
        type = 'closeWebview'
    }))
end

function LoadPostOP()

    if pJob ~= "postop" then
        return
    end

    local openRadial = false

    for k, v in pairs(zonePostOP) do
        zone.addZone(
            "PostOP_Stock", -- Nom
            v.position,-- Position
            "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le stock",  -- Text afficher
            function() -- Action qui seras fait
                if not PostOPShop.open then
                    OpenPostOPUI() -- Ouvrir le menu
                end
            end, false, 25,       -- Id / type du marker
            0.6,                  -- La taille
            { 51, 204, 255 },     -- RGB
            170,
            2.0,
            true,
            "bulleStock"
        )
    end

    zone.addZone("PostOP_DelVeh", vector3(-428.5358581543, -2809.1782226563, 4.9949436187744),
    "Appuyer sur ~INPUT_CONTEXT~ pour ranger le véhicule", function()
        if IsPedInAnyVehicle(p:ped(), false) then
            if GetVehicleBodyHealth(p:currentVeh()) / 10 >= 80 or
                GetVehicleEngineHealth(p:currentVeh()) / 10 >=
                80 then
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
    end, true, 36, 0.5, { 255, 0, 0 }, 255)

    local postoplVeh = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_postop.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
        headerIconName = 'VEHICULES',
        callbackName = 'postopVehicle',
        elements = {
            {
                id = 1,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/PostOP/boxville7.webp',
                label = 'Boxville',
                name = "boxville7"
            },
            {
                id = 2,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/PostOP/nspeedo.webp',
                label = 'NSpeedo',
                name = "nspeedo"
            },
            {
                id = 3,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/PostOP/pounder3.webp',
                label = 'Pounder',
                name = "pounder3"
            },
            {
                id = 4,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/PostOP/trailers2.webp',
                label = 'Juggernaut',
                name = "juggernaut"
            },
        }
    }

    function OpenMenuVehPostOP()
        forceHideRadar()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = postoplVeh
        }))
    end

    zone.addZone("PostOP_Veh",
        vector3(-434.71591186523, -2803.107421875, 6.9949421882629),
        "~INPUT_CONTEXT~ Garage",
        function()
            if PostOP.Duty then
                MenuChoose = "car"
                OpenMenuVehPostOP()
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Vous devez ~s prendre votre service"
                })
            end
        end, false,
        27,
        1.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleGarage"
    )

    zone.addZone(
        "coffre_PostOP", vector3(-430.00161743164, -2830.9484863281, 5.0003228187561),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le coffre de l'entreprise",
        function()
            OpenInventorySocietyMenu() --TODO: fini le menu society
        end,
        true,
        25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170-- Alpha
    )

    --for k, v in pairs(-431.0583190918, -2802.6081542969, 7.2779030799866) do
        zone.addZone(
            "casierpostop",
            vector3(-433.81948852539, -2793.419921875, 5.5285129547119),
            "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les casiers",
            function()
                OpenPostopCasier() --TODO: fini le menu society
            end, false,
            27,
            1.5,
            { 255, 255, 255 },
            170,
            2.0,
            true,
            "bulleCasiers"
        )
    --end
    local casierOpen = false
    function OpenPostopCasier()
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

    function CreateAdvert()
        if PostOP.Duty then
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

    function SetPostOPDuty()
        openRadial = false
        closeUI()
        if not PostOP.Duty then
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez ~s pris ~c votre service"
            })

            TriggerServerEvent('core:DutyOn', pJob)
            PostOP.Duty = true
            Wait(5000)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous avez ~s quitté ~c votre service"
            })

            TriggerServerEvent('core:DutyOff', pJob)
            PostOP.Duty = false
            Wait(5000)
        end
    end



    local openRadial = false

    function OpenRadialPostOP()
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

                function OpenMainRadialPostOP()
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
                                action = "OpenRadialPostOPFacture"
                            },
                            {
                                name = "PRISE DE SERVICE",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/checkmark.svg",
                                action = "SetPostOPDuty"
                            },
                            {
                                name = "COMMANDES",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/paper.svg",
                                action = "handleOpenMenu"
                            }
                        }, title = "PostOP" }
                    }));
                end

                function OpenRadialPostOPFacture()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = { elements = {
                            {
                                name = "Civil",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/billet.svg",
                                action = "FacturePostOPCivil"
                            },
                            {
                                name = "Entreprise",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/billet.svg",
                                action = "FacturePostOPEntreprise"
                            },
                            {
                                name = "RETOUR",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                action = "OpenMainRadialPostOP"
                            },
                        }, title = "PostOP" }
                    }));
                end

                OpenMainRadialPostOP()

            end)
        else
            openRadial = false
            closeUI()
            return
        end
    end

    RegisterJobMenu(OpenRadialPostOP)

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



function UnLoadPostOP()
    -- body
    zone.removeZone("PostOP_DelVeh")
    zone.removeZone("PostOP_Stock")
    zone.removeZone("PostOP_Veh")
    zone.removeZone("coffre_PostOP")
end


RegisterNUICallback("postopVehicle", function (data, cb)

    vehs = nil

    for k, v in pairs(spawnPlaces) do
        if vehicle.IsSpawnPointClear(vector3(v.x, v.y, v.z), 3.0) then
            vehs = vehicle.create(data.name, vector4(v), {})
            
            if data.name == 'boxville7' then
                SetVehicleLivery(vehs, 1)
            elseif data.name == 'nspeedo' then
                SetVehicleLivery(vehs, 4)
            elseif data.name == 'pounder3' then
                SetVehicleLivery(vehs, 0)
            elseif data.name == 'juggernaut' then
                SetVehicleLivery(vehs, 0)
            end

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
    end
    
end)

function handleOpenMenu()
    local playerJob = p:getJob()
    if(playerJob == 'postop' or playerJob == 'domaine' ) then
        openRadial = false
        closeUI()
        TriggerServerEvent(PostOpEvents.GET_ALL_COMMANDS)
    end
end 



RegisterNetEvent('core:postop:getcommands')
AddEventHandler('core:postop:getcommands', function(commands)
    

    local commandsToSend = {
        orders = {}
    }

    if p:getJob() == 'postop' then
        commandsToSend.headerImage = "https://cdn.sacul.cloud/v2/vision-cdn/MenuPostOp/header.webp"
    else
        commandsToSend.headerImage = "https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_vignoble.webp"
    end

    for k, v in pairs(commands) do
        local formatedItemsWithName = {}

        local CMDdecoded = json.decode(v.items)

        for i=1, #CMDdecoded do

            table.insert(formatedItemsWithName, {
                quantity = CMDdecoded[i].quantity,
                name = CMDdecoded[i].label,
                id = CMDdecoded[i].id
            })

        end

        -- print("----------")

        -- print(formatedItemsWithName .. "TEST PRINT CLIENT SIDE TO SERVER SIDE")

        -- TriggerServerEvent('PostOP::PrintClientSide', formatedItemsWithName)


        table.insert(commandsToSend.orders, {
            id = v.id,
            state = v.state,
            from = v.society,
            phone = v.phone,
            icon = v.icon or 'https://cdn.sacul.cloud/v2/vision-cdn/MenuPostOp/food.webp',
            totalprice = v.total,
            content = formatedItemsWithName
        })
    end


     SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'MenuPostOp',
        data = commandsToSend
    }))
end)

local function getPlayerJobData(name)
    return SocietysStockage[name]
end

RegisterNetEvent('__resWithSocietyStorageAndOpenStockMenu')
AddEventHandler('__resWithSocietyStorageAndOpenStockMenu', function(storage)
    local playerJob = p:getJob()
    local playerJobData = getPlayerJobData(playerJob)
    local _headerImage = playerJobData.headerImage
    local _headerIcon = playerJobData.headerIcon
    local _headerIconName = playerJobData.headerIconName
    local _callbackName = PostOpEvents.VALIDATE_MENU_COMMAND


    local generateStorage = true
    if storage and storage.items then generateStorage = false end

    local itemsStorage = {}

    if generateStorage then
        for i=1, #playerJobData.elements do
            table.insert(itemsStorage, {
                id = playerJobData.elements[i].id,
                label = playerJobData.elements[i].label,
                image = playerJobData.elements[i].image,
                quantity = 0
            })
        end
    else
        itemsStorage = storage.items
    end


    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'MenuStockEntreprise',
        data = {
            headerImage = _headerImage,
            elements = playerJobData.elements,
            stocks = itemsStorage,
            headerIcon = _headerIcon,
            headerIconName = _headerIconName,
            callbackName = _callbackName
        }
    }))
end)


function handleOpenCommandMenu()
    local playerJob = p:getJob()
    local playerJobData = getPlayerJobData(playerJob)
    if not playerJobData then 
        return print(("Could not open the command menu. Invalid job [%s]. You must specify the job data in `stocks.lua`."):format(playerJob))
    end
    closeWebViewAndRemoveFocus()
    TriggerServerEvent('__getSocietyStorageAndOpenStockMenu', playerJob)
end


local function getItemById(society, id)
    for _, item in ipairs(SocietysStockage[society].elements) do
        if item.id == id then
            return item
        end
    end
    return nil
end

RegisterNUICallback(PostOpEvents.VALIDATE_MENU_COMMAND, function(data, cb)
    if not data then return end

    -- items
    -- type: 'commande' | 'gestion'
    local playerJob = p:getJob()
    local playerJobData = getPlayerJobData(playerJob)

    if not playerJobData then 
        return print(("Invalid job: [%s]."):format(playerJob))
    end

    local fullNamePlayerJob = jobs[p:getJob()].label

    local dataToSend = {
        items = {},
        itemsAlcool = {},
        society = fullNamePlayerJob,
    }

    if(data.type == 'commande') then 

        local totalprice = 0

        local AlcoolTotalPrice = 0
    
        for k, v in pairs(data.items) do
            local item = getItemById(playerJob, v.id)

            if item then

                if v.ItemCategory == 'Alcool' then
                    table.insert(dataToSend.itemsAlcool, {
                        quantity = v.quantity,
                        id = v.id,
                        image = v.image,
                        label = v.label,
                        ItemCategory = v.ItemCategory,
                        price = v.price,
    
                    })
                elseif v.ItemCategory ~= 'Alcool' then

                    table.insert(dataToSend.items, {
                        quantity = v.quantity,
                        id = v.id,
                        image = v.image,
                        label = v.label,
                        ItemCategory = v.ItemCategory,
                        price = v.price,

                    })
                end

                -- Affiche les prix de chaque items commandé total
--[[                 print(v.label .. " : ".. v.price*v.quantity)

                print("-----------------------------------") ]]

                totalprice = totalprice + v.price*v.quantity

                if v.ItemCategory == "Alcool" then
                    AlcoolTotalPrice = AlcoolTotalPrice + v.price*v.quantity
                end

--[[ 
                print('----------------------------------------------------------------------')

                print('totalprice : '..totalprice)

                print('AlcoolTotalPrice : '..AlcoolTotalPrice) ]]

                local totalpostop = totalprice - AlcoolTotalPrice

--[[                 print('totalpostop : '..totalpostop)



                print('Calcul : \n Total commande : '..totalprice..'\nTotal Domaine : '..AlcoolTotalPrice..'\nTotal PostOP : '.. totalpostop)

                print('----------------------------------------------------------------------') ]]



                
                if v.ItemCategory == "Nourritures" then
                    dataToSend.fournisseur = "postop"
                    dataToSend.totalcmd = totalpostop or 'Erreur sur le calcul'

                elseif v.ItemCategory == "Boissons" then
                    dataToSend.fournisseur = "postop"
                    dataToSend.totalcmd = totalpostop or 'Erreur sur le calcul'

                elseif v.ItemCategory == "Alcool" then
                    dataToSend.fournisseur = "domaine"
                    dataToSend.totalcmdalcool = AlcoolTotalPrice or 'Erreur sur le calcul'

                elseif v.ItemCategory == "Utilitaires" then
                    dataToSend.fournisseur = "postop"
                    dataToSend.totalcmd = totalpostop or 'Erreur sur le calcul'
                end


            end
        end

        dataToSend.phone = TriggerServerCallback("core:GetPhoneNumber") or 'Pas de téléphone'

        for k, v in pairs(dataToSend.items) do
            print('----------------------------------------------------')
            print('Items : ' .. v.label .. ' Categorie : ' .. v.ItemCategory)
        end

        for k, v in pairs(dataToSend.itemsAlcool) do
            print('----------------------------------------------------')
            print('Items : ' .. v.label .. ' Categorie : ' .. v.ItemCategory)
        end


    
        TriggerServerEvent(PostOpEvents.ADD_COMMAND_TO_DB, dataToSend)

        exports['vNotif']:createNotification({
            type = 'VERT',
            -- duration = 5, -- In seconds, default:  4
            content = 'Votre commande viens d\'être passé auprès du PostOp, elle sera bientôt livré'
        })

    end

    if(data.type == 'gestion') then 
        -- 
        for k, v in pairs(data.items) do
            table.insert(dataToSend.items, {
                image = v.image,
                label = v.label,
                price = v.price,
                quantity = v.quantity,
                id = v.id 
            })
        end
    

        TriggerServerEvent(PostOpEvents.SET_SOCIETY_STORAGE, dataToSend)
    end

    closeWebViewAndRemoveFocus()
    cb(true)
end)


RegisterNUICallback(PostOpEvents.SAVE_SOCIETY_STORAGE, function(data, cb)
    if not data then return end

    TriggerServerEvent(PostOpEvents.SAVE_SOCIETY_STORAGE, {
        items = data,
        society = p:getJob()
    })

    cb(true)
end)



RegisterNUICallback(NUI_CALLBACK_NAME, function(data, cb)
    if not data then return end

    if (data.type == 'orderDelivered') then
        TriggerServerEvent(PostOpEvents.APPROVE_ORDER, data.order)
    elseif (data.type == 'orderCanceled') then
        TriggerServerEvent(PostOpEvents.CANCEL_ORDER, data.order)
    end

end)

local function uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

-- AddEventHandler(PostOpEvents.OPEN_POSTOP_MENU, handleOpenMenu)
AddEventHandler(PostOpEvents.OPEN_COMMAND_MENU, handleOpenCommandMenu)
--[[Keys.Register("F1", "F1", "Ouvrir le menu de commandes", function()
    handleOpenMenu()
end)]]--



-- ! ONLY FOR DEBUG

--[[ local function makeDebugRadial()
    local radial = {
        title = 'Burger Shot',
        elements = {
            {
                name = 'Annoce',
                icon = 'https://cdn.sacul.cloud/v2/vision-cdn/RadialMenus/billet.svg',
                action = '___'
            },
            {
                name = 'Facture',
                icon = 'https://cdn.sacul.cloud/v2/vision-cdn/RadialMenus/billet.svg',
                action = '___'
            },
            {
                name = 'Prise de service',
                icon = 'https://cdn.sacul.cloud/v2/vision-cdn/RadialMenus/billet.svg',
                action = '___'
            },
            {
                name = 'Commande',
                icon = 'https://cdn.sacul.cloud/v2/vision-cdn/RadialMenus/billet.svg',
                action = 'openCommandMenu'
            }
        }
    }

    SendNUIMessage({
        type = 'openWebview',
        name = 'RadialMenu',
        data = radial
    })
end ]]

-- Citizen.CreateThread(function()
--     print('Hello world')
--     exports['vNotif']:createNotification({
--         type = 'SUCCESS',
--         -- duration = 5, -- In seconds, default:  4
--         content = 'Hello world'
--     })
-- end)
-- Citizen.CreateThread(function()
--     SetTimeout(5000, function()
--         makeDebugRadial()
--     end)
-- end)

CreateThread(function()
    local ent2 = entity:CreateObjectLocal("prop_atm_01", vector3(-427.268494, -2800.785645, 5.042938)).id
    SetEntityHeading(ent2, 45.272289)
end)

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7postop ^3loaded")
end)