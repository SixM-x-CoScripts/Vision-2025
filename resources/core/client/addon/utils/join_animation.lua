local possiblePos = {
    {
        first = vector3(-598.92852783203, -838.94256591797, 2430.7265625),
        lookAtFirst = vector3(-600.84771728516, -780.69110107422, 2504.2290039062),
        rotationFirst = vector3(33.0, 33.0, 33.0),
        fovFirst = 40.0,

        second = vector3(-598.95916748047, -758.78198242188, 2438.8364257812),
        lookAtSecond = vector3(-599.83544921875, -704.59533691406, 2439.1015625),
        rotationSecond = vector3(-33.0, -33.0, -33.0),

        fovSecond = 30.0,
    },
}

local index = 0
function GetRandomPos()

    index = index + 1
    --if index > #possiblePos then
    --    index = 1
    --end

    return possiblePos[index]
end

function PlayJoinAnimation()
    DoScreenFadeOut(1)
    TriggerMusicEvent("BST_START")
    TriggerEvent("skinchanger:loadSkin", p:getCloths().skin) -- Peut etre cassé ?
    TriggerSWEvent("TREFSDFD5156FD", "AESDAZDS", 5000)

    local planeCoords = vector4(-600.10101318359, -680.83404541016, 2435.1997070312, 0.36822602152824)
    local playerCoords = vector4(-600.11126708984, -700.52423095703, 2438.7297363281, 190.47790527344)

    LoadModel("a_f_m_beach_01")

    local vehicle = entity:CreateVehicleLocal("cargoplane", planeCoords.xyz, planeCoords.w)
    -- local vehicle = CreateVehicle(GetHashKey("cargoplane"), planeCoords, 0, 1)
    local ped = CreatePedInsideVehicle(vehicle:getEntityId(), 1, GetHashKey("a_f_m_beach_01"), -1, 0, 1)

    FreezeEntityPosition(vehicle:getEntityId(), true)
    SetVehicleExtra(vehicle:getEntityId(), 7, false)
    SetVehicleExtra(vehicle:getEntityId(), 8, true)
    SetVehicleDoorOpen(vehicle:getEntityId(), 2, true, 1)
    SetVehicleEngineOn(vehicle:getEntityId(), 1, 1, 1)

    SetEntityCoordsNoOffset(PlayerPedId(), playerCoords.xyz, 0.0, 0.0, 0.0)
    SetEntityHeading(PlayerPedId(), playerCoords.w)
    GiveWeaponToPed(PlayerPedId(), GetHashKey("gadget_parachute"), 255, 0, 1)

    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)
    local cam2 = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)

    SetCamActive(cam, true)
    RenderScriptCams(1, 1, 0, 0, 0)

    SetCamFov(cam, 80.0)
    SetCamShakeAmplitude(cam, 2.0)
    ShakeCam(cam, "HAND_SHAKE", 0.2)

    local camParam = GetRandomPos()
    while index <= #possiblePos do

        DoScreenFadeOut(1000)


        while not IsScreenFadedOut() do Wait(1) end
        SetFocusPosAndVel(camParam.first, 0.0, 0.0, 0.0)

        SetCamActive(cam, true)
        RenderScriptCams(1, 1, 0, 0, 0)

        SetCamActive(cam2, true)

        SetCamCoord(cam, camParam.first)
        SetCamCoord(cam2, camParam.second)
        SetCamFov(cam, camParam.fovFirst)
        SetCamFov(cam2, camParam.fovSecond)
        PointCamAtCoord(cam, camParam.lookAtFirst)
        PointCamAtCoord(cam2, camParam.lookAtSecond)
        SetCamRot(cam, camParam.rotationFirst, 2)
        SetCamRot(cam2, camParam.rotationSecond, 2)
        SetCamActiveWithInterp(cam2, cam, 6000, 1, 1)
        SetCamShakeAmplitude(cam2, 2.0)
        ShakeCam(cam2, "HAND_SHAKE", 0.2)

        Wait(100)
        DoScreenFadeIn(500)


        local timer = GetGameTimer()
        local inCam = true
        while GetGameTimer() <= timer + 5500 do
            Wait(0)
        end

        camParam = GetRandomPos()
    end
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do Wait(1) end
    TriggerMusicEvent("BST_STOP")

    local pPed = PlayerPedId()
    --local pCoords = GetEntityCoords(pPed)
    local pCoords = GetOffsetFromEntityInWorldCoords(pPed, 0.0, 5.0, 0.0)

    SetCamActive(cam, true)
    SetCamCoord(cam, vector3(-598.20141601562, -769.62451171875, 2507.6311035156))

    SetCamCoord(cam2, pCoords.x, pCoords.y, pCoords.z - 50.0)
    SetEntityCoordsNoOffset(PlayerPedId(), -600.01068115234, -721.42242431641, 2436.4655761719, 0.0, 0.0, 0.0)
    PointCamAtEntity(cam, pPed, 1, 1, 1, 1)

    ClearFocus()

    DoScreenFadeIn(1000)

    --RenderScriptCams(false, true, 6000, 0, 0)
    SetCamActiveWithInterp(cam2, cam, 6000, 1, 1)
    --PointCamAtEntity(cam2, pPed, 0, 0, 0, 0)
    PointCamAtCoord(cam2, pCoords.x, pCoords.y, pCoords.z - 300.0)
    Wait(6000)

    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do Wait(1) end

    RenderScriptCams(false, false, 6000, 0, 0)
    RemoveWeaponFromPed(pPed, GetHashKey("gadget_parachute"))
    vehicle:delete()
    DeleteEntity(ped)

    LoadPlayerData(false)
    DoScreenFadeIn(500)
end
