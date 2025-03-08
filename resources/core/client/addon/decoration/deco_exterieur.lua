local function SpawnObjectDeco(obj)
    local tabl = TriggerServerCallback("core:canPlaceProp")
    if not tabl or tabl < 5 then
        TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
        local coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
        local objCoords = (coords + forward * 2.5)
        local placed = false
        local heading = p:heading()

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
                "~INPUT_CONTEXT~ Valider\n~INPUT_FRONTEND_LEFT~ ou ~INPUT_FRONTEND_RIGHT~ Pivoter")
            if IsControlJustPressed(0, 38) then
                placed = true
            end
            Wait(0)
        end
        SetEntityCollision(objS.id, true, true)
        objS:resetAlpha()
        local netId = objS:getNetId()
        if netId == 0 then
            objS:delete()
        end
        SetNetworkIdCanMigrate(netId, true)
        InsertContextObjectHandler(objS.id, {
            { icon = "ramasser", label = "Ramasser", action = "ramasserPropsDeco" }
        })
        exports['vNotif']:createNotification({
            type = 'VERT',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez placé l'objet"
        })   
        OpenPropMenu()
        TriggerServerEvent("core:premium:placedProp", obj, ObjToNet(objS.id))
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous ne pouvez plus placer d'objets"
        })   
    end
end

function ramasserPropsDeco(entity)
    p:PlayAnim("pickup_object", "pickup_low", 0.5)
    Wait(1000)
    ClearPedTasks(p:ped())
    DeleteEntity(entity)
    TriggerServerEvent("core:premium:removeProp", ObjToNet(entity))
end

local DataSendPropsExt = {
    items = {{
        name = 'main',
        type = 'buttons',
        elements = {{
            name = 'Chaise',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/Chaise.svg',
            hoverStyle = ' stroke-black'
        }, {
            name = 'Decoration',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/Decoration.svg',
            hoverStyle = ' stroke-black'
        }, {
            name = 'Electronique',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/light.svg',
            hoverStyle = ' stroke-black'
        }, {
            name = 'Exterieur',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/barriere.svg',
            hoverStyle = ' stroke-black'
        }, {
            name = 'Illegal',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/Illegal.svg',
            hoverStyle = ' stroke-black'
        }, {
            name = 'Lumières',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/light.svg',
            hoverStyle = ' stroke-black'
        }, {
            name = 'Nourriture',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/Nourriture.svg',
            hoverStyle = ' stroke-black'
        }, {
            name = 'Outils',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/ciblestir.svg',
            hoverStyle = ' stroke-black'
        }, {
            name = 'Sport',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/Sport.svg',
            hoverStyle = ' stroke-black'
        }, {
            name = 'Tables',
            width = 'full',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/table.svg',
            hoverStyle = ' stroke-black'
        }}
    }, {
        name = 'Chaise',
        type = 'elements',
        elements = {}
    }, {
        name = 'Decoration',
        type = 'elements',
        elements = {}
    }, {
        name = 'Electronique',
        type = 'elements',
        elements = {}
    }, {
        name = 'Exterieur',
        type = 'elements',
        elements = {}
    }, {
        name = 'Illegal',
        type = 'elements',
        elements = {}
    }, {
        name = 'Lumières',
        type = 'elements',
        elements = {}
    }, {
        name = 'Nourriture',
        type = 'elements',
        elements = {}
    }, {
        name = 'Outils',
        type = 'elements',
        elements = {}
    }, {
        name = 'Sport',
        type = 'elements',
        elements = {}
    }, {
        name = "Tables",
        type = 'elements',
        elements = {}
    }},
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_props.webp',
    headerTitle = "OBJETS PREMIUM",
    callbackName = 'MenuObjetsDecoExt',
    showTurnAroundButtons = false
}

local premReturn = false
RegisterCommand("props", function(source, args, raw)
    if args[1] == "prem" and p:getPermission() > 0 then premReturn = true end
    if p:getSubscription() >= 1 then 
        OpenPropMenu()
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Ce menu est réservé au premium"
        })
    end
end)

local function GetDatasProps()

    -- Chaise
    for k,v in pairs(DecoExtData.Chaise) do
        table.insert(DataSendPropsExt.items[2].elements, {
            id = k,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/premium/" .. k .. ".webp",
            category = "Chaise",
            label = v,
            name = k,
        })
    end

    -- Decoration
    for k,v in pairs(DecoExtData.Decoration) do
        table.insert(DataSendPropsExt.items[3].elements, {
            id = k,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/premium/" .. k .. ".webp",
            category = "Decoration",
            label = v,
            name = k,
        })
    end

    -- Electronique
    for k,v in pairs(DecoExtData.Electronique) do
        table.insert(DataSendPropsExt.items[4].elements, {
            id = k,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/premium/" .. k .. ".webp",
            category = "Electronique",
            label = v,
            name = k,
        })
    end

    -- Exterieur
    for k,v in pairs(DecoExtData.Exterieur) do
        table.insert(DataSendPropsExt.items[5].elements, {
            id = k,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/premium/" .. k .. ".webp",
            category = "Exterieur",
            label = v,
            name = k,
        })
    end

    -- Illegal
    for k,v in pairs(DecoExtData.Illegal) do
        table.insert(DataSendPropsExt.items[6].elements, {
            id = i,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/premium/" .. k .. ".webp",
            category = "Illegal",
            label = v,
            name = k,
        })
    end

    -- Lumières
    for k,v in pairs(DecoExtData.Light) do
        table.insert(DataSendPropsExt.items[7].elements, {
            id = i,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/premium/" .. k .. ".webp",
            category = "Lumières",
            label = v,
            name = k,
        })
    end

    -- Divers
    for k,v in pairs(DecoExtData.Nourriture) do
        table.insert(DataSendPropsExt.items[8].elements, {
            id = k,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/premium/" .. k .. ".webp",
            category = "Divers",
            label = v,
            name = k,
        })
    end

    -- Outils
    for k,v in pairs(DecoExtData.Outils) do
        table.insert(DataSendPropsExt.items[9].elements, {
            id = k,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/premium/" .. k .. ".webp",
            category = "Outils",
            label = v,
            name = k,
        })
    end

    -- Sport
    for k,v in pairs(DecoExtData.Sport) do
        table.insert(DataSendPropsExt.items[10].elements, {
            id = k,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/premium/" .. k .. ".webp",
            category = "Sport",
            label = v,
            name = k,
        })
    end

    -- Tables
    for k,v in pairs(DecoExtData.Tables) do
        table.insert(DataSendPropsExt.items[11].elements, {
            id = k,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/PropsMenu/premium/" .. k .. ".webp",
            category = "Tables",
            label = v,
            name = k,
        })
    end

    DataSendPropsExt.disableSubmit = true

    return true
end

local hasGotdata = false
function OpenPropMenu()
    if not hasGotdata then
        hasGotdata = true
        GetDatasProps()
    end
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'MenuObjetsServicesPublics',
        data = DataSendPropsExt
    }))
end


RegisterNUICallback("MenuObjetsDecoExt", function(data, cb)
    SendNuiMessage(json.encode({
        type = 'closeWebview'
    }))

    print(json.encode(data, {indent = true}))
    if data.category == "Chaise" then
        SpawnObjectDeco(data.name)
    end

    if data.category == "Decoration" then
        SpawnObjectDeco(data.name)
    end

    if data.category == "Electronique" then
        SpawnObjectDeco(data.name)
    end

    if data.category == "Exterieur" then
        SpawnObjectDeco(data.name)
    end

    if data.category == "Illegal" then
        SpawnObjectDeco(data.name)
    end

    if data.category == "Lumières" then
        SpawnObjectDeco(data.name)
    end

    if data.category == "Nourriture" then
        SpawnObjectDeco(data.name)
    end

    if data.category == "Outils" then
        SpawnObjectDeco(data.name)
    end

    if data.category == "Sport" then
        SpawnObjectDeco(data.name)
    end

    if data.category == "Tables" then
        SpawnObjectDeco(data.name)
    end
end)

RegisterNUICallback("focusOut", function(data)
    if premReturn == true then
        openCb()
        premReturn = false
        return
    end
end)