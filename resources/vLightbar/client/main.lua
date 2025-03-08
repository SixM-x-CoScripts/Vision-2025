SirenCar, Veh, MainVehiclePlate = 0, 0, ""
Xrot, Yrot, Zrot = 0.0, 0.0, 0.0
XCoord, YCoord, ZCoord = 0, 0, 0
LightbarVehicles, CurrentVehicleLightBars, ToggleLightbarAudio, Identifiers, VehiclesSoundId = {}, {}, {}, {}, {}
local SelectLightBar

local vehHasLightBar = false

RegisterNetEvent('vlightbar:client:getVehicleData')
RegisterNetEvent('vlightbar:client:toggleLightbars')
RegisterNetEvent('vlightbar:client:toggleLightbarAudio')
RegisterNetEvent('vlightbar:client:TogglesirenHorn')
RegisterNetEvent('vlightbar:client:getIdentifier')
RegisterNetEvent('vlightbar:client:addPermission')
RegisterNetEvent('vlightbar:client:getSirenData')
RegisterNetEvent('vlightbar:client:spawnLightbarVeh')

AddEventHandler('vlightbar:client:getVehicleData', function(data)
    LightbarVehicles = data
end)

AddEventHandler('vlightbar:client:spawnLightbarVeh', function(veh, model, isloads, cdata, pdata)
--[[     print("Spawning vehicle")
    print(veh)
    print(model)
    print(isloads)
    print(json.encode(cdata))
    print(json.encode(pdata)) ]]
    spawnLightbarVeh(veh, model, isloads, cdata, pdata)
end)

AddEventHandler('vlightbar:client:getIdentifier', function(data, perms)
    Identifiers = data
    PermData = perms
end)

AddEventHandler('vlightbar:client:toggleLightbars', function(veh, plate, bool)
    if ToggleLightbarAudio[plate] ~= nil then
        ToggleLightbarAudio[plate].lightbar = bool
    end
    setSirenStatus(veh, plate, bool)
end)

AddEventHandler('vlightbar:client:toggleLightbarAudio', function(vehicle, plate, bool, sirenTon)
    if ToggleLightbarAudio[plate] ~= nil then
        ToggleLightbarAudio[plate].siren = bool
        ToggleLightbarAudio[plate].sirenTon = sirenTon
    end
    setSirenAudioStatus(vehicle, plate, bool)
end)

AddEventHandler('vlightbar:client:TogglesirenHorn', function(vehicle, bool)
    setSirenHorn(vehicle, bool)
end)

AddEventHandler('vlightbar:client:addPermission', function(data)
    PermData = data
end)

AddEventHandler('vlightbar:client:getSirenData', function(data)
    ToggleLightbarAudio = data
end)

RegisterNUICallback("addLightbar", function(data, cb)
    local lModel = data.modelName
    createLightbarCar(lModel)
end)

RegisterNUICallback("selectLightbar", function(data, cb)
    SelectLightBar = NetToVeh(tonumber(data.lightbar))
    Coord, Rotation = vector3(0, 0, 0), vector3(0.0, 0.0, 0.0)
    for key, value in pairs(CurrentVehicleLightBars) do
        if NetToVeh(value.lbEntity) == SelectLightBar then
            local coord = (value.coordData.coord)
            local rotation = (value.coordData.rotation)
            Xrot, Yrot, Zrot = rotation.x, rotation.y, rotation.z
            XCoord, YCoord, ZCoord = coord.x, coord.y, coord.z
            break
        end
    end
end)

RegisterNUICallback("clickButton", function(data, cb)
    local typ = data.typ
    local speed = data.speed
    local dt = data.dt
    if speed ~= nil then
        moveLightbar(SelectLightBar, speed, typ, dt)
    elseif typ == "save" then
        saveNewLightbars()
        displayNui(false)
    elseif typ == "cancel" then
        deleteNewLightbars()
        displayNui(false)
    elseif typ == "delete" then
        deleteLightbar(data.lightbarId)
    end
end)

Citizen.CreateThread(function()
    local jsonData = json.decode(LoadResourceFile(ResourceName, jsonPath))
    if jsonData ~= nil then
        LightbarVehicles = jsonData
    end
    TriggerServerEvent("vlightbar:server:getIdentifier")
    TriggerServerEvent("vlightbar:server:getSirenData")
    while true do
        for plate, value in pairs(LightbarVehicles) do
            if ToggleLightbarAudio[plate] == nil then ToggleLightbarAudio[plate] = {} end
            if ToggleLightbarAudio[plate].siren and ToggleLightbarAudio[plate].lightbar then
                if NetworkDoesNetworkIdExist(value[1].vehicle) then
                    local vehicle = NetToVeh(value[1].vehicle)
                    local pl = GetEntityModel(vehicle)
                    if plate == pl then
                        if (HasSoundFinished(VehiclesSoundId[plate]) or VehiclesSoundId[plate] == nil) and
                            DoesEntityExist(vehicle) then
                            if VehiclesSoundId[plate] == nil then VehiclesSoundId[plate] = GetSoundId() end
                            if ToggleLightbarAudio[plate].sirenTon == nil then ToggleLightbarAudio[plate].sirenTon = "VEHICLES_HORNS_SIREN_1" end
                            PlaySoundFromEntity(VehiclesSoundId[plate], ToggleLightbarAudio[plate].sirenTon,
                                vehicle, 0, 0, 0)
                        elseif IsEntityDead(vehicle) or not IsVehicleSirenOn(NetToVeh(value[1].lbEntity)) then
                            ToggleLightbarAudio[plate].siren = false
                            ToggleLightbarAudio[plate].lightbar = false
                            setSirenAudioStatus(vehicle, plate, false)
                        end
                    end
                end
            end
        end
        Citizen.Wait(500)
    end
end)
