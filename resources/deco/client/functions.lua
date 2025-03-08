Functions = {}

Functions.Gizmo = {}
Functions.Gizmo.Inside = false
Functions.Gizmo.Pos = 0.0
Functions.Gizmo.Rot = 0.0
Functions.Gizmo.Use = function (entity, model)
    print("Gizmo Use")
    print("Entity, Model: ", entity, model)
    print("position, rotation: ", GetEntityCoords(entity), GetEntityRotation(entity))
    SendNUIMessage({
        action = 'setGizmoEntity',
        data = {
            name = model,
            handle = entity,
            position = GetEntityCoords(entity),
            rotation = GetEntityRotation(entity),
        }
    })

    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)
    gizmoEntity = entity
end

Functions.Gizmo.Cancel = function()
    if gizmoEntity then
        gizmoEntity = nil
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        SendNUIMessage({
            action = 'setGizmoEntity',
            data = {}
        })
    end
end

Functions.Gizmo.StartCamera = function()
    CreateThread(function()
        SetEntityDrawOutlineShader(1)
        SetEntityDrawOutlineColor(255, 0, 0, 180)
    
        while true do
            if Functions.Gizmo.Inside then
                if gizmoEntity then
                    SendNUIMessage({
                        action = 'setCameraPosition',
                        data = {
                            position = Functions.Gizmo.Pos or GetFinalRenderedCamCoord(),
                            rotation = Functions.Gizmo.Rot or GetFinalRenderedCamRot()
                        }
                    })
                    --DisableControlAction(0, 0, true) -- Next Camera
                    --DisableControlAction(0, 1, true) -- Look Left/Right
                    --DisableControlAction(0, 2, true) -- Look up/Down
                    --DisableControlAction(0, 24, true) -- Attack
                    --DisableControlAction(0, 25, true) -- Aim
                    --DisableControlAction(0, 257, true) -- Attack 2
                    --DisableControlAction(0,263,true) -- disable melee
                    --DisableControlAction(0,264,true) -- disable melee
                    --DisableControlAction(0,257,true) -- disable melee
                    --DisableControlAction(0,140,true) -- disable melee
                    --DisableControlAction(0,141,true) -- disable melee
                    --DisableControlAction(0,142,true) -- disable melee
                    --DisableControlAction(0,143,true) -- disable melee
                else
                    Wait(500)
                end
            else
                break
            end
            Wait(0)
        end
    end)
end

Functions.Gizmo.UpdatePosRot = function(pos,rot)
    Functions.Gizmo.Pos = pos
    Functions.Gizmo.Rot = rot
end

Functions.Gizmo.Start = function(pos,rot)
    Functions.Gizmo.Inside = true 
    Functions.Gizmo.Pos = pos
    Functions.Gizmo.Rot = rot
    Functions.Gizmo.StartCamera()
end

DecoModule = function()
    return Functions.Gizmo
end

Functions.Menu = {}
Functions.Menu.Draw = function(Menu)
    if Menu == nil then return end
    for _, Item in pairs(Menu.Items) do
        if Item.Style == nil then Item.Style = {} end
        if Item.Type == "Button" then
            RageUI.Button(Item.Name, Item.Description, Item.Style, Item.Enabled, Item.Callback, Item.SubMenuLink)
        elseif Item.Type == "List" then
            RageUI.List(Item.Name, Item.List, Item.Index, Item.Description, Item.Style, Item.Enabled, Item.Callback)
        elseif Item.Type == "Separator" then
            RageUI.Separator(Item.Name)
        end
    end
end