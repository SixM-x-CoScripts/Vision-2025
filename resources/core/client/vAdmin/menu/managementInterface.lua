local insideTablette = false
RegisterNUICallback("focusOut", function()
    if insideTablette then 
        insideTablette = false 
        openRadarProperly()
        SetNuiFocus(false, false)
    end
end)

function renderManagementInterface()
    vAdminManagementInterface.Button(
        "Variables",
        "",
        nil,
        "chevron",
        false,
        function()
            openVariablesInterface()
        end
    ) 
end

function openVariablesInterface()
    insideTablette = true
    vAdminManagementInterface.close()

    forceHideRadar()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'openWebview',
        name = 'GestionVariables',
        data = {
            firstname = p:getFirstname(),
            lastname = p:getLastname(),
            source = PlayerPedId(),
            permission = p:getPermission(),
            variables = vAdminVariables
        }
    })
    while insideTablette do
        Wait(1)
        DisableAllControlActions(0)
    end
end

RegisterNUICallback("core:getPedCoords", function(data)
    SendNUIMessage({
        type = 'openWebview',
        name = 'GestionVariables',
        data = {
            coords = GetEntityCoords(PlayerPedId())
        }
    })
end)

RegisterNUICallback("core:getPedCoordsH", function(data)
    SendNUIMessage({
        type = 'openWebview',
        name = 'GestionVariables',
        data = {
            coords = vector3(GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z, GetEntityHeading(PlayerPedId()))
        }
    })
end)

RegisterNUICallback("core:updateAllVariables", function(data)
    print("data", data)
    if not data then return end
    if not data.data then return end
    print("data", data.data)
    print(json.encode(data.data))
    TriggerServerEvent("core:updateVariables", data.data)
end)