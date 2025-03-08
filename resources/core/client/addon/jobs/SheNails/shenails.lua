local NewPlayerChoiceNail = nil 
local inSheNails = false
local InSelection = true
local token = nil
local openRadialShenails = false
local menuOpenShenail = false
local MunucureCam = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local Catalogues = {
    vector3(-776.57659912109, -168.91870117188, 36.482975006104),
    --vector3(-761.30999755859, -164.74096679688, 36.530502319336),
}

CreateThread(function()
    while not zone do Wait(2000) end
    for k,v in pairs(Catalogues) do 
        zone.addZone("cataloguemanucure" ..k,
            v + vector3(0.0, 0.0, 1.0),
            "Appuyer sur ~INPUT_CONTEXT~ pour choisir une personne",
            function()
                OpenCatalogueManucure()
            end,
            false, -- Avoir un marker ou non
            25, -- Id / type du marker
            0.6, -- La taille
            { 51, 204, 255 }, -- RGB
            170,-- Alpha
            1.5,
            true,
            "bulleCatalogue"
        )
    end
end)

local oldSkin = nil
local incatalogue = false

RegisterNUICallback("focusOut", function()
    if inSheNails then
        InSelection = true
        SetNuiFocusKeepInput(false)
        SetCamActive(MunucureCam, false)
        DestroyCam(MunucureCam, 1)
        RenderScriptCams(false, false, 0, 1, 0)
        ClearPedTasks(PlayerPedId())
        MunucureCam = nil
        menuOpenShenail = false
        inSheNails = false
        if NewPlayerChoiceNail then 
            TriggerServerEvent('core:SheNailsRemovePlayerOnSeatSRV', token, GetPlayerServerId(NewPlayerChoiceNail))
        end
    end
    if incatalogue then 
        local Skin = p:skin()
        p:setSkin(Skin)
        incatalogue = false
    end
end)

function LoadSheNails()
    local inService = false
    local actualInmenu = false
    local actionsPos = {
        { 
            actionPoint = vector3(218.44465637207, -1546.3474121094, 29.287536621094),
            sendPlayerPos = vector3(220.02711486816, -1545.4654541016, 29.287889480591),
            chairPos = vector3(220.78141784668, -1545.3865966797, 29.767776489258-1.0),
            chair2Pos = vector3(219.038, -1546.866, 29.76-1.0),
            heading2Place = 329.75,
            headingPlace = 105.11845397949
        },
        { 
            actionPoint = vector3(215.48828125, -1548.1363525391, 29.286882400513),
            sendPlayerPos = vector3(217.45713806152, -1547.7325439453, 29.287214279175),
            chairPos = vector3(217.95, -1547.541, 29.767-1.0),
            chair2Pos = vector3(216.05, -1549.055, 29.767-1.0),
            heading2Place = 314.55,
            headingPlace = 110.87256622314
        },

        { 
            actionPoint = vector3(-773.18402099609, -161.07698059082, 37.512683868408),
            sendPlayerPos = vector3(-772.39215087891, -162.35877990723, 37.512683868408),
            chairPos = vector3(-771.17028808594, -162.69047546387, 38.033519744873-1.0), --Client -771.17028808594, -162.69047546387, 38.033519744873-1.0
            chair2Pos = vector3(-772.76373291016, -159.93795776367, 38.070892333984-1.0), --Esthéticien -772.74279785156, -159.82554626465, 38.976268768311-1.0
            heading2Place = 210.0,
            headingPlace = 30.0 
        },
        { 
            actionPoint = vector3(-769.88146972656, -158.67900085449, 37.482978820801),
            sendPlayerPos = vector3(-768.90954589844, -160.46955871582, 37.482978820801),
            chairPos = vector3(-769.48895263672, -161.62168884277, 38.067741394043-1.0), --Client -769.48895263672, -161.62168884277, 38.067741394043-1.0
            chair2Pos = vector3(-771.02117919922, -158.77284240723, 38.057117462158-1.0), --Esthéticien -771.02117919922, -158.77284240723, 38.057117462158-1.0
            heading2Place = 210.0,
            headingPlace = 30.0
        },
    }

    for k,v in pairs(actionsPos) do
        zone.addZone("manucure_shop" ..k,
            vector3(v.actionPoint.x, v.actionPoint.y, v.actionPoint.z),
            "Appuyer sur ~INPUT_CONTEXT~ pour choisir une personne",
            function()
                if not menuOpenShenail then
                    if InSelection then
                        if inService then
                            OpenManucureShop(v)
                        else
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                content = "Vous n'êtes ~s pas en service"
                            })
                        end
                    end
                end
            end,
            false, -- Avoir un marker ou non
            25, -- Id / type du marker
            0.6, -- La taille
            { 51, 204, 255 }, -- RGB
            170,-- Alpha
            1.5,
            true,
            "bulleManucure"
        )
    end

    local posShenail = {}
    local posGestion = vector3(-773.70025634766, -169.52085876465, 41.593101501465)
    local posCoffre = vector3(-769.81610107422, -155.41693115234, 41.593063354492)
    local posCasier = vector3(-781.97375488281, -174.65293884277, 41.593097686768)

    if p:getJob() == "shenails" then
        posGestion = vector3(211.8873, -1545.34, 28.295)
        posCoffre = vector3(217.39965820313, -1540.4307861328, 28.295)
    else
        posGestion = vector3(-773.70025634766, -169.52085876465, 41.593101501465)
        posCoffre = vector3(-769.81610107422, -155.41693115234, 41.593063354492)
        posCasier = vector3(-781.97375488281, -174.65293884277, 41.593097686768)
    end
    posShenail = {
        { name = "coffre_beauty", pos = posCoffre, bulle = "bulleCoffre",
            action = function()
                if inService then
                    OpenInventorySocietyMenu()
                else
                    -- ShowNotification("~r~Vous n'êtes pas en service")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous n'êtes ~s pas en service"
                    })

                end
            end },
            
        { name = "casier_beauty", pos = posCasier, bulle = "bulleCasiers",
        action = function()
            if inService then
                OpenCasierJobSheNails()
            else
                -- ShowNotification("~r~Vous n'êtes pas en service")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous n'êtes ~s pas en service"
                })

            end
        end },
        { name = "gestion_beauty", pos = posGestion, bulle = "bulleGestion",
            action = function()
                if inService then
                    OpenSocietyMenu()
                else
                    -- ShowNotification("~r~Vous n'êtes pas en service")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous n'êtes ~s pas en service"
                    })

                end
        end },
    }
    
    for key, v in pairs(posShenail) do
        zone.addZone(
            v.name,
            v.pos.xyz,
            "Appuyer sur ~INPUT_CONTEXT~ pour intéragir",
            function()
                v.action()
            end,
            false,
            25, -- Id / type du marker
            0.6, -- La taille
            { 51, 204, 255 }, -- RGB
            170,-- Alpha
            1.5,
            v.bulle and true or false,
            v.bulle and v.bulle or nil,
            true
        )
    end

    local casierOpen = false
    function OpenCasierJobSheNails()
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

    function OpenManucureShop(info)
        InSelection = false
        forceHideRadar()
        local playerSelected = ChoicePlayersInZone(3.0, false)
        SetNuiFocusKeepInput(true)
        if playerSelected ~= nil then
            if GetPlayerServerId(playerSelected) == GetPlayerServerId(PlayerId()) then             
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Vous ne pouvez pas vous faire de manucure sur vous même"
                }) 
                return 
            end
            TriggerServerEvent('core:SheNailsPlacePlayerOnSeatSRV', token ,GetPlayerServerId(playerSelected), info)
            NewPlayerChoiceNail = playerSelected
            DataSendManucure = {
                catalogue = {},
                buttons = {
                    {
                        name = 'Maquillage',
                        width = 'full',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/maquillage.svg',
                        hoverStyle = 'fill-black stroke-black',
                        opacity= true,
                        color1= true,
                        color2= true
                    },
                    {
                        name = 'Rouge à levre',
                        width = 'full',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/rougelevre.svg',
                        hoverStyle = 'fill-black stroke-black',
                        opacity= true,
                        color1= true,
                        color2= true
                    },
                    {
                        name = 'Sourcils',
                        width = 'full',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/eyebrow.svg',
                        hoverStyle = 'fill-black stroke-black',
                        opacity= true,
                        color1= true,
                        color2= true
                    },
                    {
                        name = 'Fard à joue',
                        width = 'full',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/blush.svg',
                        hoverStyle = 'fill-black stroke-black',
                        opacity= true,
                        colorFard= true,
                    },
                    {
                        name = 'Piercing',
                        width = 'half',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/piercing.svg',
                        hoverStyle = 'fill-black stroke-black',
                    },
                    {
                        name = 'Pilosité',
                        width = 'half',
                        image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/pilositetorse.svg',
                        hoverStyle = 'fill-black stroke-black',
                        opacity= true,
                    },
                },
                headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
                headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Manicure/header.webp',
                callbackName = 'Menu_manucure_achat_callback',
                headerIconName = 'HOMME',
                showTurnAroundButtons = false,
                disableSubmit= false
            }
            local plyModel = GetEntityModel(GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(playerSelected))))
            local sex = "Homme"
            if plyModel == `mp_f_freemode_01` then 
                sex = "Femme" 
                DataSendManucure.headerIconName = "FEMME" 
                DataSendManucure.buttons = {}
                table.insert(DataSendManucure.buttons,
                { 
                    name = 'Manucure', 
                    width = 'full', 
                    image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/manucure.svg', 
                    hoverStyle = 'fill-black stroke-black'
                })
                Wait(10)
                table.insert(DataSendManucure.buttons,
                {
                    name = 'Maquillage',
                    width = 'full',
                    image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/maquillage.svg',
                    hoverStyle = 'fill-black stroke-black',
                    opacity= true,
                    color1= true,
                    color2= true
                })
                Wait(10)
                table.insert(DataSendManucure.buttons,
                {
                    name = 'Rouge à levre',
                    width = 'full',
                    image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/rougelevre.svg',
                    hoverStyle = 'fill-black stroke-black',
                    opacity= true,
                    color1= true,
                    color2= true
                })
                Wait(10)
                table.insert(DataSendManucure.buttons,
                {
                    name = 'Sourcils',
                    width = 'full',
                    image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/eyebrow.svg',
                    hoverStyle = 'fill-black stroke-black',
                    opacity= true,
                    color1= true,
                    color2= true
                })
                Wait(10)
                table.insert(DataSendManucure.buttons,
                {
                    name = 'Fard à joue',
                    width = 'full',
                    image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/blush.svg',
                    hoverStyle = 'fill-black stroke-black',
                    opacity= true,
                    colorFard= true,
                })
                Wait(10)
                table.insert(DataSendManucure.buttons,
                {
                    name = 'Piercing',
                    width = 'full',
                    image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/piercing.svg',
                    hoverStyle = 'fill-black stroke-black',
                })
                --Wait(10)
                --table.insert(DataSendManucure.buttons,
                --{
                --    name = 'Pilosité',
                --    width = 'half',
                --    image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/pilositetorse.svg',
                --    hoverStyle = 'fill-black stroke-black',
                --})
            end

            -- fard a joue (blush)
            for i = 0, GetNumHeadOverlayValues(5)-1 do
                local add = i+1
                table.insert(DataSendManucure.catalogue, {id = i, price=20, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..sex.."/Blush/"..add..".webp",
                category="Fard à joue", label = "Fard à joue #" .. i, ownCallbackName= 'Menu_manucure_preview_callback'})
            end

            -- pilosité
            for i = 0, GetNumHeadOverlayValues(10)-1 do
                local add = i+1
                table.insert(DataSendManucure.catalogue, {id = i, price=10, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..sex.."/PilositeTorse/"..add..".webp",
                category="Pilosité", label = "Pilosité #".. i, ownCallbackName= 'Menu_manucure_preview_callback'})
            end

            -- Maquillage
            for i = 0, GetPedHeadOverlayNum(4)-1 do
                local add = i+1
                table.insert(DataSendManucure.catalogue, {id = i, price=20, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..sex.."/Maquillage/"..add..".webp",
                category="Maquillage", label = "Maquillage #".. i, ownCallbackName= 'Menu_manucure_preview_callback'})
            end

            -- Sourcils
            for i = 0, GetNumHeadOverlayValues(2)-1 do 
                local add = i+1
                table.insert(DataSendManucure.catalogue, {id = i, price=20, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..sex.."/Sourcils/"..add..".webp",
                category="Sourcils", label = "Sourcils #" .. i, ownCallbackName= 'Menu_manucure_preview_callback'})
            end

            -- Rouge a levre
            for i = 0, GetPedHeadOverlayNum(8)-1 do
                if i ~= 8 then
                    local add = i+1
                    table.insert(DataSendManucure.catalogue, {id = i, price=20, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..sex.."/RougeLevre/"..add..".webp", 
                    category="Rouge à levre", label = "Rouge à levre #" .. i, ownCallbackName= 'Menu_manucure_preview_callback'})
                end
            end

            -- piercings seulement femme
            if sex == "Femme" then
                for i = 0, GetNumberOfPedDrawableVariations(GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(playerSelected))), 10)-1 do
                    if i > 196 and i < 232 and i ~= 198 and i ~= 200 and i ~= 202 and i ~= 203 and i ~= 204 and i ~= 205 
                        and i ~= 208 and i ~= 214 and i ~= 215 and i ~= 227 and i ~= 230 then
                        for z = 1, GetNumberOfPedTextureVariations(GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(playerSelected))), 10, i) do
                            table.insert(DataSendManucure.catalogue, {id = i, price=25, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..sex.."/Piercing/"..i.."_"..z..".webp", category="Piercing", label="Piercing #" .. i, ownCallbackName= 'Menu_manucure_preview_callback', VariationID = z-1})
                        end
                    end
                end
                -- piercings seulement homme
            elseif sex == "Homme" then 
                for i = 185, 192 do 
                    for z = 1, GetNumberOfPedTextureVariations(GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(playerSelected))), 10, i) do
                        table.insert(DataSendManucure.catalogue, {id = i, price=25, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..sex.."/Piercing/"..i.."_"..z..".webp", category="Piercing", label="Piercing #" .. i, ownCallbackName= 'Menu_manucure_preview_callback', VariationID = z-1})
                    end
                end
            end

            -- ongles seulement femme
            local banonglelist = {197, 199, 201, 203, 206, 207, 234}
            for i = 209, 231, 1 do 
                table.insert(banonglelist, i)
            end
            if sex == "Femme" then
                for i = 0, GetNumberOfPedDrawableVariations(GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(playerSelected))), 10)-1 do
                    if i > 195 and i < 237 then
                        if not tableContains(banonglelist, i) then
                            for z = 1, GetNumberOfPedTextureVariations(GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(playerSelected))), 10, i) do
                                table.insert(DataSendManucure.catalogue, {id = i, price=25, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..sex.."/Ongles/"..i.."_"..z..".webp", category="Manucure", label="Manucure #" .. i, ownCallbackName= 'Menu_manucure_preview_callback', VariationID = z-1})
                            end
                        end
                    end
                end
            end
            SendNuiMessage(json.encode({
                type = 'closeWebview',
            }))    
            Wait(100)
            SetEntityCoords(PlayerPedId(), info.chair2Pos.x+0.5,info.chair2Pos.y,info.chair2Pos.z)
            SetEntityHeading(PlayerPedId(), info.heading2Place)
            Wait(500)
            TaskStartScenarioAtPosition(PlayerPedId(), "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", info.chair2Pos.x, info.chair2Pos.y, info.chair2Pos.z, GetEntityHeading(PlayerPedId()), 0, 1, false)
            menuOpenShenail = true
            inSheNails = true
            SetNuiFocusKeepInput(true)
            CreateThread(function()
                while menuOpenShenail do
                    Wait(1)
                    DisableControlAction(0, 1, true)
                    DisableControlAction(0, 2, true)
                    DisableControlAction(0, 142, true)
                    DisableControlAction(0, 18, true)
                    DisableControlAction(0, 322, true)
                    DisableControlAction(0, 106, true)
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
            Wait(50)
            SendNuiMessage(json.encode({
                type = 'openWebview',
                name = 'MenuGrosCatalogueColor',
                data = DataSendManucure
            }))
        else
            InSelection = true
        end
    end

    function FactureShenails()
        if inService then
            openRadialShenails = false
            closeUI()
            Wait(50)
            TriggerEvent("nuiPapier:client:startCreation", 2)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function SetShenailsDuty()
        openRadialShenails = false
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
            openRadialShenails = false
            closeUI()
            CreateJobAnnonce()
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function OpenRadialShenails()
        if not openRadialShenails then
            openRadialShenails = true
            CreateThread(function()
                while openRadialShenails do
                    Wait(0)
                    DisableControlAction(0, 1, openRadialShenails)
                    DisableControlAction(0, 2, openRadialShenails)
                    DisableControlAction(0, 142, openRadialShenails)
                    DisableControlAction(0, 18, openRadialShenails)
                    DisableControlAction(0, 322, openRadialShenails)
                    DisableControlAction(0, 106, openRadialShenails)
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
                            action = "FactureShenails"
                        },
                        {
                            name = "PRISE DE SERVICE",
                            icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/checkmark.svg",
                            action = "SetShenailsDuty"
                        }
                    }, title = p:getJob() == "shenails" and "SHE NAILS" or "Beauty Bar" }
                }));
            end)
        else
            openRadialShenails = false
            closeUI()
            return
        end
    end

    RegisterJobMenu(OpenRadialShenails)
end

--CreateThread(function()
--    while true do
--        Wait(1)
--        if menuOpenShenail then
--            print("BAAHHHH")
--            DisableControlAction(0, 1, true)
--            DisableControlAction(0, 2, true)
--            DisableControlAction(0, 142, true)
--            DisableControlAction(0, 18, true)
--            DisableControlAction(0, 322, true)
--            DisableControlAction(0, 106, true)
--            DisableControlAction(0, 24, true) -- disable attack
--            DisableControlAction(0, 25, true) -- disable aim
--            DisableControlAction(0, 263, true) -- disable melee
--            DisableControlAction(0, 264, true) -- disable melee
--            DisableControlAction(0, 257, true) -- disable melee
--            DisableControlAction(0, 140, true) -- disable melee
--            DisableControlAction(0, 141, true) -- disable melee
--            DisableControlAction(0, 142, true) -- disable melee
--            DisableControlAction(0, 143, true) -- disable melee
--        else
--            print("ELSE WAIT 1500")
--            Wait(1500)
--        end
--    end
--end)

RegisterNUICallback("Menu_manucure_preview_callback", function(data)
    if not NewPlayerChoiceNail then return end -- catalogue preview
    TriggerServerEvent('core:Menu_manucure_preview_callbackSRV', token ,GetPlayerServerId(NewPlayerChoiceNail), data)
    CreateCameraManucure(GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(NewPlayerChoiceNail))), data.category)
end)

RegisterNUICallback("Menu_manucure_preview_solo", function(data)
    if data == nil or data.category == nil then return end
    if data.category == "Manucure" then 
        data.category = "decals_1"
        if data.VariationID then
            SkinChangeFake("decals_2", data.VariationID, true)
        end
    end
    if data.category == "Fard à joue" then data.category = "blush_1" SkinChangeFake("blush_2", 10, true) end
    if data.category == "Pilosité" then data.category = "chest_1" SkinChangeFake("chest_2", 10, true) end
    if data.category == "Sourcils" then data.category = "eyebrows_1" SkinChangeFake("eyebrows_2", 10, true) end
    if data.category == "Maquillage" then data.category = "makeup_1" SkinChangeFake("makeup_2", 10, true) end
    if data.category == "Piercing" then 
        data.category = "decals_1" 
        if data.VariationID then
            SkinChangeFake("decals_2", data.VariationID, true)
        end
    end
    if data.category == "Rouge à levre" then data.category = "lipstick_1" SkinChangeFake("lipstick_2", 10, true) end
    SkinChangeFake(data.category, data.id, true)
end)

RegisterNUICallback("Menu_manucure_achat_callback", function(data)
    TriggerServerEvent('core:Menu_manucure_achat_callbackSRV', token ,GetPlayerServerId(NewPlayerChoiceNail), data)
    if data.changedData then 
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))  
    end
end)

function CreateCameraManucure(player, typecam)
    if MunucureCam == nil then
        MunucureCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    end
    SetCamActive(MunucureCam, 1)
    local coord = GetEntityCoords(player)
    local formattedcamval = {coord.x, coord.y, coord.z}
    if typecam == "Rouge à levre" or typecam == "Maquillage" or typecam == "Sourcils" or typecam == "Fard à joue" then 
        formattedcamval = {coord.x-1.0, coord.y+1.5, coord.z+0.9, 20, 0.6} --{coord.x-1.0, coord.y, coord.z+0.9, 55, 0.6} Base
    elseif typecam == "Piercing" then 
        formattedcamval = {coord.x-1.0, coord.y+1.5, coord.z+0.9, 35, 0.6}
    elseif typecam == "Pilosité" then 
        formattedcamval = {coord.x-1.0, coord.y, coord.z+0.7, 55, 0.6}
    elseif typecam == "Manucure" then 
        formattedcamval = {coord.x-1.0, coord.y+0.8, coord.z+0.9, 40, -0.15} --{coord.x-1.0, coord.y, coord.z+0.3, 40, -0.1} Base
    end
    SetCamCoord(MunucureCam, formattedcamval[1], formattedcamval[2], formattedcamval[3])
    PointCamAtCoord(MunucureCam, coord.x, coord.y, coord.z + formattedcamval[5])
    SetCamFov(MunucureCam, formattedcamval[4] + 0.1)
    RenderScriptCams(true, 0, 3000, 1, 0)
end


function OpenCatalogueManucure()
    local Skin = p:skin()
    oldSkin = Skin
    ApplySkinFake(Skin)
    DataSendManucure = {
        catalogue = {},
        buttons = {
            {
                name = 'Maquillage',
                width = 'full',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/maquillage.svg',
                hoverStyle = 'fill-black stroke-black',
                opacity= true,
                color1= true,
                color2= true
            },
            {
                name = 'Rouge à levre',
                width = 'full',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/rougelevre.svg',
                hoverStyle = 'fill-black stroke-black',
                opacity= true,
                color1= true,
                color2= true
            },
            {
                name = 'Sourcils',
                width = 'full',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/eyebrow.svg',
                hoverStyle = 'fill-black stroke-black',
                opacity= true,
                color1= true,
                color2= true
            },
            {
                name = 'Fard à joue',
                width = 'full',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/blush.svg',
                hoverStyle = 'fill-black stroke-black',
                opacity= true,
                colorFard= true,
            },
            {
                name = 'Piercing',
                width = 'half',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/piercing.svg',
                hoverStyle = 'fill-black stroke-black',
            },
            {
                name = 'Pilosité',
                width = 'half',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/pilositetorse.svg',
                hoverStyle = 'fill-black stroke-black',
                opacity= true,
            },
        },
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Manicure/header.webp',
        callbackName = 'Menu_manucure_achat_callback',
        headerIconName = 'HOMME',
        showTurnAroundButtons = false,
        disableSubmit= false
    }
    playerSelected = PlayerId()
    local plyModel = GetEntityModel(p:ped())
    local sex = "Homme"
    if plyModel == `mp_f_freemode_01` then 
        sex = "Femme" 
        DataSendManucure.headerIconName = "FEMME" 
        DataSendManucure.buttons = {}
        table.insert(DataSendManucure.buttons,
        { 
            name = 'Manucure', 
            width = 'full', 
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/manucure.svg', 
            hoverStyle = 'fill-black stroke-black'
        })
        Wait(10)
        table.insert(DataSendManucure.buttons,
        {
            name = 'Maquillage',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/maquillage.svg',
            hoverStyle = 'fill-black stroke-black',
            opacity= true,
            color1= true,
            color2= true
        })
        Wait(10)
        table.insert(DataSendManucure.buttons,
        {
            name = 'Rouge à levre',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/rougelevre.svg',
            hoverStyle = 'fill-black stroke-black',
            opacity= true,
            color1= true,
            color2= true
        })
        Wait(10)
        table.insert(DataSendManucure.buttons,
        {
            name = 'Sourcils',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/eyebrow.svg',
            hoverStyle = 'fill-black stroke-black',
            opacity= true,
            color1= true,
            color2= true
        })
        Wait(10)
        table.insert(DataSendManucure.buttons,
        {
            name = 'Fard à joue',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/blush.svg',
            hoverStyle = 'fill-black stroke-black',
            opacity= true,
            colorFard= true,
        })
        Wait(10)
        table.insert(DataSendManucure.buttons,
        {
            name = 'Piercing',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/piercing.svg',
            hoverStyle = 'fill-black stroke-black',
        })
        --Wait(10)
        --table.insert(DataSendManucure.buttons,
        --{
        --    name = 'Pilosité',
        --    width = 'half',
        --    image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/pilositetorse.svg',
        --    hoverStyle = 'fill-black stroke-black',
        --})
    end

    -- fard a joue (blush)
    for i = 0, GetNumHeadOverlayValues(5)-1 do
        local add = i+1
        table.insert(DataSendManucure.catalogue, {id = i, price=20, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..sex.."/Blush/"..add..".webp",
        category="Fard à joue", label = "Fard à joue #" .. i, ownCallbackName= 'Menu_manucure_preview_solo'})
    end

    -- pilosité
    for i = 0, GetNumHeadOverlayValues(10)-1 do
        local add = i+1
        table.insert(DataSendManucure.catalogue, {id = i, price=10, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..sex.."/PilositeTorse/"..add..".webp",
        category="Pilosité", label = "Pilosité #".. i, ownCallbackName= 'Menu_manucure_preview_solo'})
    end

    -- Maquillage
    for i = 0, GetPedHeadOverlayNum(4)-1 do
        local add = i+1
        table.insert(DataSendManucure.catalogue, {id = i, price=20, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..sex.."/Maquillage/"..add..".webp",
        category="Maquillage", label = "Maquillage #".. i, ownCallbackName= 'Menu_manucure_preview_solo'})
    end

    -- Sourcils
    for i = 0, GetNumHeadOverlayValues(2)-1 do 
        local add = i+1
        table.insert(DataSendManucure.catalogue, {id = i, price=20, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..sex.."/Sourcils/"..add..".webp",
        category="Sourcils", label = "Sourcils #" .. i, ownCallbackName= 'Menu_manucure_preview_solo'})
    end

    -- Rouge a levre
    for i = 0, GetPedHeadOverlayNum(8)-1 do
        if i ~= 8 then
            local add = i+1
            table.insert(DataSendManucure.catalogue, {id = i, price=20, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..sex.."/RougeLevre/"..add..".webp", 
            category="Rouge à levre", label = "Rouge à levre #" .. i, ownCallbackName= 'Menu_manucure_preview_solo'})
        end
    end

    -- piercings seulement femme
    if sex == "Femme" then
        for i = 0, GetNumberOfPedDrawableVariations(GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(playerSelected))), 10)-1 do
            if i > 196 and i < 232 and i ~= 198 and i ~= 200 and i ~= 202 and i ~= 203 and i ~= 204 and i ~= 205 
                and i ~= 208 and i ~= 214 and i ~= 215 and i ~= 227 and i ~= 230 then
                for z = 1, GetNumberOfPedTextureVariations(GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(playerSelected))), 10, i) do
                    table.insert(DataSendManucure.catalogue, {id = i, price=25, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..sex.."/Piercing/"..i.."_"..z..".webp", category="Piercing", label="Piercing #" .. i, ownCallbackName= 'Menu_manucure_preview_solo', VariationID = z-1})
                end
            end
        end
        -- piercings seulement homme
    elseif sex == "Homme" then 
        for i = 185, 192 do 
            for z = 1, GetNumberOfPedTextureVariations(GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(playerSelected))), 10, i) do
                table.insert(DataSendManucure.catalogue, {id = i, price=25, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..sex.."/Piercing/"..i.."_"..z..".webp", category="Piercing", label="Piercing #" .. i, ownCallbackName= 'Menu_manucure_preview_solo', VariationID = z-1})
            end
        end
    end

    -- ongles seulement femme
    local banonglelist = {197, 199, 201, 203, 206, 207, 234}
    for i = 209, 231, 1 do 
        table.insert(banonglelist, i)
    end
    if sex == "Femme" then
        for i = 0, GetNumberOfPedDrawableVariations(GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(playerSelected))), 10)-1 do
            if i > 195 and i < 237 then
                if not tableContains(banonglelist, i) then
                    for z = 1, GetNumberOfPedTextureVariations(GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(playerSelected))), 10, i) do
                        table.insert(DataSendManucure.catalogue, {id = i, price=25, image="https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..sex.."/Ongles/"..i.."_"..z..".webp", category="Manucure", label="Manucure #" .. i, ownCallbackName= 'Menu_manucure_preview_solo', VariationID = z-1})
                    end
                end
            end
        end
    end
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
    menuOpenShenail = true
    inSheNails = true
    SetNuiFocusKeepInput(true)
    CreateThread(function()
        while menuOpenShenail do
            Wait(1)
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 18, true)
            DisableControlAction(0, 322, true)
            DisableControlAction(0, 106, true)
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
    Wait(100)
    incatalogue = true
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'MenuGrosCatalogueColor',
        data = DataSendManucure
    }))
end