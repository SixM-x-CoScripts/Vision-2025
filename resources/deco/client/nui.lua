RegisterNUICallback('moveEntity', function(data, cb)
    cb(1)
    if data.handle then
        if DoesEntityExist(data.handle) then
            SetEntityCoords(data.handle, data.position.x, data.position.y, data.position.z)
            SetEntityRotation(data.handle, data.rotation.x, data.rotation.y, data.rotation.z)
        end
    end
end)

RegisterNUICallback("setGizmoEntity", function (data, cb)
    cb(1)
    Functions.Gizmo.Use(data.entity.id, data.entity.model)
end)

RegisterNetEvent("props:placeObject")
AddEventHandler("props:placeObject", function (model, coords)
    local name = Objects.GetModelNameFromHash(model);
    local i
    if not IsModelInCdimage(model) then
        print("Model not found")
        return
    end

    RequestModel(model)
    i = 0
    while not HasModelLoaded(model) do
        i = i + 1
        Wait(50)
        if i > 10 then
            print("Model not loaded")
            break
        end
    end

    local obj = CreateObject(model, coords.x, coords.y, coords.z)

    Wait(50)
    if not DoesEntityExist(obj) then
        print("Object not created")
        return
    end

    FreezeEntityPosition(obj, true)

    table.insert(props_list, {
        handle = obj,
        name = name,
    })
    Functions.Gizmo.Use(obj, name)
end)

RegisterNetEvent("props:gizmoEntity")
AddEventHandler("props:gizmoEntity", function (entity)
    Functions.Gizmo.Use(entity, GetEntityModel(entity))
end)

RegisterNetEvent("props:deleteEntity")
AddEventHandler("props:deleteEntity", function (entity)
    SetEntityAsMissionEntity(entity, false, false)
    DeleteObject(entity)
    for i, v in ipairs(props_list) do
        if v.handle == entity then
            table.remove(props_list, i)
            break
        end
    end
end)