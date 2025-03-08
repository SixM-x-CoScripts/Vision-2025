local token = nil
local pedCoords, token, MenuChoose = vector4(-1066.6568603516, -232.7954864502, 37.221008300781, 13.121398925781) , nil, nil
local pedHelCoords = vector4(-1054.6411132812, -241.55702209473, 52.511569976807, 309.78045654297)
local spawnPlaceHel = vector4(-583.39, -930.71, 36.83, 280.489)

local InsideIllegalAnnonce = false
local ToSendTo = "all"

local spawnPlaces = {
    vector4(-1065.45703125, -229.18634033203, 37.180141448975, 51.39045715332),
    vector4(-1061.3795166016, -226.86845397949, 37.186748504639, 62.094303131104),
    vector4(-1053.6165771484, -222.66957092285, 37.092403411865, 68.088958740234),
    vector4(-1057.7303466797, -224.6529083252, 37.155155181885, 65.88591003418),
    vector4(-1050.0007324219, -220.26434326172, 36.942626953125, 50.49100112915),
}



TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

CreateThread(function()
    while zone == nil do Wait(1000) end

    local ped = entity:CreatePedLocal("s_m_m_armoured_02", pedCoords.xyz,  pedCoords.w)
    ped:setFreeze(true)
    SetEntityInvincible(ped.id, true)
    SetEntityAsMissionEntity(ped.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped.id, true)

    local ped2 = entity:CreatePedLocal("s_m_m_armoured_02", pedHelCoords.xyz,  pedHelCoords.w)
    ped2:setFreeze(true)
    SetEntityInvincible(ped2.id, true)
    SetEntityAsMissionEntity(ped2.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped2.id, true)

end)


function LoadLifeInvaderJob()
    if pJob ~= "lifeinvader" then
        return
    end

    local lifeDuty = false
    local weazelPropsPlaced = {}

    local coffrePos = {
        vector3(-1059.4620361328, -234.2596282959, 44.021194458008),
    }

    for k, v in pairs(coffrePos) do
        zone.addZone(
            "casierlife" .. k,
            v,
            "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les casiers",
            function()
                OpenLifeCasier() --TODO: fini le menu society
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
    function OpenLifeCasier()
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
    -- ,
    zone.addZone(
        "society_life",
        vector3(-1068.6296386719, -240.23762512207, 44.021183013916),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les actions d'entreprise",
        function()
            OpenSocietyMenu() --TODO: fini le menu society
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        1.5,
        true,
        "bulleGestion"
    )


    zone.addZone(
        "society_life_delete",
        vector3(-1050.2213134766, -220.39195251465, 37.954277038574),
        "~INPUT_CONTEXT~ Ranger le véhicule",
        function()
            if lifeDuty then
                if IsPedInAnyVehicle(p:ped(), false) then
                    if GetVehicleBodyHealth(p:currentVeh()) / 10 >= 80 or
                        GetVehicleEngineHealth(p:currentVeh()) / 10 >= 80 then
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
            end
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        3.0,
        true,
        "bulleGarage"
    )
    zone.addZone(
        "society_weazel_delete_hel",
        vector3(-1050.3475341797, -235.36192321777, 53.511898040771),
        "~INPUT_CONTEXT~ Ranger le véhicule",
        function()
            if lifeDuty then
                if IsPedInAnyVehicle(p:ped(), false) then
                    local veh = GetVehiclePedIsIn(p:ped(), false)
                    --removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                    TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                    DeleteEntity(veh)
                end
            end
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        3.0,
        true,
        "bulleGarage"
    )

    local lifeVeh = {
        headerImage = 'https://static.wikia.nocookie.net/gtawiki/images/1/1d/Lifeinvader-GTAV.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
        headerIconName = 'VEHICULES',
        callbackName = 'LifeInvMenu',
        elements = {
            {
                id = 1,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/WeazelNews/newsvan.webp',
                label = 'newsvan',
                name = "newsvan"
            },
            {
                id = 2,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/WeazelNews/newsvan2.webp',
                label = 'newsvan2',
                name = "newsvan2"
            },
            {
                id = 3,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/WeazelNews/wzalamo.webp',
                label = 'wzalamo',
                name = "wzalamo"
            },
            {
                id = 4,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/WeazelNews/wztorrence.webp',
                label = 'wztorrence',
                name = "wztorrence"
            },
        }
    }

    function OpenMenuVehLife()
        forceHideRadar()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = lifeVeh
        }))
    end

    zone.addZone("life_spawncars",
        pedCoords.xyz,
        "Appuyer sur ~INPUT_CONTEXT~ pour parler avec le gardien",
        function()
            if lifeDuty then
                MenuChoose = "car"
                OpenMenuVehLife()
            end
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        3.0,
        true,
        "bulleGarage"
    )


    local weazelhel = {
        headerImage = 'https://static.wikia.nocookie.net/gtawiki/images/1/1d/Lifeinvader-GTAV.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
        headerIconName = 'VEHICULES',
        callbackName = 'LifeHelMenu',
        elements = {
            {
                id = 1,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/WeazelNews/newsmav.webp',
                label = 'newsmav',
                name = "newsmav"
            },
        }
    }

    function OpenMenuHelWezel()
        forceHideRadar()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = weazelhel
        }))
    end

    zone.addZone("society_life_hel_spawn",
        pedHelCoords.xyz + vector3(0.0, 0.0, 2.0),
        "~INPUT_CONTEXT~ Sortir le véhicule",
        function()
            OpenMenuHelWezel()
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        3.0,
        true,
        "bulleVehicule"
    )


    zone.addZone(
        "coffre_life",
        vector3(-1051.7551269531, -232.40943908691, 44.020900726318),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le coffre de l'entreprise",
        function()
            OpenInventorySocietyMenu() --TODO: fini le menu society
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        1.5,
        true,
        "bulleCoffre"
    )

    zone.addZone("wz_armory", vector3(-1055.3140869141, -230.93487548828, 44.021003723145),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir l'armurerie", 
        function()
            OpenLIITEMMenu()
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
        headerImage = 'https://static.wikia.nocookie.net/gtawiki/images/1/1d/Lifeinvader-GTAV.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Banners/icon.webp',
        headerIconName = 'CATALOGUE',
        callbackName = 'armoryTakeLI',
        showTurnAroundButtons = false,
        multipleSelection = true,
        elements = {
            {
                id = 1,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/Jumelles.webp",
                price = 0,
                name = "jumelles",
                label = "Jumelles",
            },
            {
                id = 2,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/wzkev.webp",
                price = 0,
                name = "wzkev",
                label = "Kevlar Class C",
            },
            {
                id = 3,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/wzkev.webp",
                price = 0,
                name = "badgep",
                label = "Badge Presse",
            },
            {
                id = 2,
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Armurerie/Items/camerab.webp",
                price = 0,
                name = "camerab",
                label = "Camera",
            },
        }
    }

    function OpenLIITEMMenu()
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

    local openRadial = false

    local holdingCam = false
    local usingCam = false
    local holdingMic = false
    local usingMic = false
    local holdingBmic = false
    local usingBmic = false
    local camModel = "prop_v_cam_01"
    local camanimDict = "missfinale_c2mcs_1"
    local camanimName = "fin_c2_mcs_1_camman"
    local micModel = "p_ing_microphonel_01"
    local micanimDict = "missheistdocksprep1hold_cellphone"
    local micanimName = "hold_cellphone"
    local bmicModel = "prop_v_bmike_01"
    local bmicanimDict = "missfra1"
    local bmicanimName = "mcs2_crew_idle_m_boom"
    local bmic_net = nil
    local mic_net = nil
    local cam_net = nil
    local UI = {
        x = 0.000,
        y = -0.001,
    }
    local fov_max = 70.0
    local fov_min = 5.0
    local zoomspeed = 10.0
    local speed_lr = 8.0
    local speed_ud = 8.0

    local camera = false
    local fov = (fov_max + fov_min) * 0.5

    function ToogleCamWeazel()
        if not holdingCam then
            if lifeDuty then
                RequestModel(GetHashKey(camModel))
                while not HasModelLoaded(GetHashKey(camModel)) do
                    Wait(0)
                end
                TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)

                local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
                local camspawned = CreateObject(GetHashKey(camModel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
                Wait(1000)
                local netid = ObjToNet(camspawned)
                SetNetworkIdExistsOnAllMachines(netid, true)
                NetworkSetNetworkIdDynamic(netid, true)
                SetNetworkIdCanMigrate(netid, false)
                AttachEntityToEntity(camspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), 0.0
                    , 0.0,
                    0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
                TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
                TaskPlayAnim(GetPlayerPed(PlayerId()), camanimDict, camanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
                cam_net = netid
                holdingCam = true
                ShowHelpNotification("Pour Entrer dans la caméra appuyer sur  ~INPUT_PICKUP~ \nPour entrer dans la  Movie Cam appuyer sur ~INPUT_INTERACTION_MENU~")
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Vous devez ~s prendre votre service"
                })
            end
        else
            ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
            SetModelAsNoLongerNeeded(GetHashKey(camModel))
            DetachEntity(NetToObj(cam_net), 1, 1)
            DeleteEntity(NetToObj(cam_net))
            cam_net = nil
            holdingCam = false
            usingCam = false
        end

        Citizen.CreateThread(function()
            while holdingCam do
                Citizen.Wait(500)

                if holdingCam then
                    while not HasAnimDictLoaded(camanimDict) do
                        RequestAnimDict(camanimDict)
                        Citizen.Wait(100)
                    end

                    if not IsEntityPlayingAnim(PlayerPedId(), camanimDict, camanimName, 3) then
                        TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
                        TaskPlayAnim(GetPlayerPed(PlayerId()), camanimDict, camanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
                    end

                    DisablePlayerFiring(PlayerId(), true)
                    DisableControlAction(0, 25, true) -- disable aim
                    DisableControlAction(0, 44, true) -- INPUT_COVER
                    DisableControlAction(0, 37, true) -- INPUT_SELECT_WEAPON
                    SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
                end
            end
        end)



        Citizen.CreateThread(function()
            while holdingCam do
                Citizen.Wait(10)

                local lPed = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(lPed)

                if holdingCam and IsControlJustReleased(1, 311) then
                    movcamera = true

                    SetTimecycleModifier("default")

                    SetTimecycleModifierStrength(0.3)

                    local scaleform = RequestScaleformMovie("security_camera")

                    while not HasScaleformMovieLoaded(scaleform) do
                        Citizen.Wait(10)
                    end


                    local lPed = PlayerPedId()
                    local vehicle = GetVehiclePedIsIn(lPed)
                    local cam1 = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

                    AttachCamToEntity(cam1, lPed, 0.0, 0.0, 1.0, true)
                    SetCamRot(cam1, 2.0, 1.0, GetEntityHeading(lPed))
                    SetCamFov(cam1, fov)
                    RenderScriptCams(true, false, 0, 1, 0)
                    PushScaleformMovieFunction(scaleform, "security_camera")
                    PopScaleformMovieFunctionVoid()

                    while movcamera and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == vehicle) and true do
                        if IsControlJustPressed(0, 177) then
                            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                            movcamera = false
                        end

                        SetEntityRotation(lPed, 0, 0, new_z, 2, true)

                        local zoomvalue = (1.0 / (fov_max - fov_min)) * (fov - fov_min)
                        CheckInputRotation(cam1, zoomvalue)

                        HandleZoom(cam1)
                        HideHUDThisFrame()

                        drawRct(UI.x + 0.0, UI.y + 0.0, 1.0, 0.15, 0, 0, 0, 255) -- Top Bar
                        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
                        drawRct(UI.x + 0.0, UI.y + 0.85, 1.0, 0.16, 0, 0, 0, 255) -- Bottom Bar

                        local camHeading = GetGameplayCamRelativeHeading()
                        local camPitch = GetGameplayCamRelativePitch()
                        if camPitch < -70.0 then
                            camPitch = -70.0
                        elseif camPitch > 42.0 then
                            camPitch = 42.0
                        end
                        camPitch = (camPitch + 70.0) / 112.0

                        if camHeading < -180.0 then
                            camHeading = -180.0
                        elseif camHeading > 180.0 then
                            camHeading = 180.0
                        end
                        camHeading = (camHeading + 180.0) / 360.0

                        Citizen.InvokeNative(0xD5BB4025AE449A4E, PlayerPedId(), "Pitch", camPitch)
                        Citizen.InvokeNative(0xD5BB4025AE449A4E, PlayerPedId(), "Heading", camHeading * -1.0 + 1.0)

                        Citizen.Wait(10)
                    end

                    movcamera = false
                    ClearTimecycleModifier()
                    fov = (fov_max + fov_min) * 0.5
                    RenderScriptCams(false, false, 0, 1, 0)
                    SetScaleformMovieAsNoLongerNeeded(scaleform)
                    DestroyCam(cam1, false)
                    SetNightvision(false)
                    SetSeethrough(false)
                end
            end
        end)

        Citizen.CreateThread(function()
            while holdingCam do

                Citizen.Wait(10)

                local lPed = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(lPed)

                if holdingCam and IsControlJustReleased(1, 38) then
                    newscamera = true

                    SetTimecycleModifier("default")

                    SetTimecycleModifierStrength(0.3)

                    --local scaleform = RequestScaleformMovie("security_camera")
                    --local scaleform2 = RequestScaleformMovie("GTAV_ONLINE")


                    --while not HasScaleformMovieLoaded(scaleform) do
                    --    Citizen.Wait(10)
                    --end
                    --while not HasScaleformMovieLoaded(scaleform2) do
                    --    Citizen.Wait(10)
                    --end


                    local lPed = PlayerPedId()
                    local vehicle = GetVehiclePedIsIn(lPed)
                    local cam2 = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

                    AttachCamToEntity(cam2, lPed, 0.0, 0.0, 1.0, true)
                    SetCamRot(cam2, 2.0, 1.0, GetEntityHeading(lPed))
                    SetCamFov(cam2, fov)
                    RenderScriptCams(true, false, 0, 1, 0)
                    PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
                    --PushScaleformMovieFunction(scaleform2, "GTAV_ONLINE")
                    PopScaleformMovieFunctionVoid()

                    while newscamera and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == vehicle) and true do
                        if IsControlJustPressed(1, 177) then
                            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                            newscamera = false
                        end

                        SetEntityRotation(lPed, 0, 0, new_z, 2, true)

                        local zoomvalue = (1.0 / (fov_max - fov_min)) * (fov - fov_min)
                        CheckInputRotation(cam2, zoomvalue)

                        HandleZoom(cam2)
                        forceHideRadar()

                        --DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
                        --DrawScaleformMovie(scaleform2, 0.5, 0.63, 1.0, 1.0, 255, 255, 255, 255)
                        Breaking("")

                        local camHeading = GetGameplayCamRelativeHeading()
                        local camPitch = GetGameplayCamRelativePitch()
                        if camPitch < -70.0 then
                            camPitch = -70.0
                        elseif camPitch > 42.0 then
                            camPitch = 42.0
                        end
                        camPitch = (camPitch + 70.0) / 112.0

                        if camHeading < -180.0 then
                            camHeading = -180.0
                        elseif camHeading > 180.0 then
                            camHeading = 180.0
                        end
                        camHeading = (camHeading + 180.0) / 360.0

                        Citizen.InvokeNative(0xD5BB4025AE449A4E, PlayerPedId(), "Pitch", camPitch)
                        Citizen.InvokeNative(0xD5BB4025AE449A4E, PlayerPedId(), "Heading", camHeading * -1.0 + 1.0)

                        Citizen.Wait(10)
                    end

                    newscamera = false
                    ClearTimecycleModifier()
                    fov = (fov_max + fov_min) * 0.5
                    RenderScriptCams(false, false, 0, 1, 0)
                    SetScaleformMovieAsNoLongerNeeded(scaleform)
                    DestroyCam(cam2, false)
                    openRadarProperly()
                    SetNightvision(false)
                    SetSeethrough(false)
                end
            end
        end)
    end

    -- Activate camera
    RegisterNetEvent('camera:Activate')
    AddEventHandler('camera:Activate', function()
        camera = not camera
    end)

    --FUNCTIONS--
    function HideHUDThisFrame()
        HideHelpTextThisFrame()
        HideHudAndRadarThisFrame()
        HideHudComponentThisFrame(1)
        HideHudComponentThisFrame(2)
        HideHudComponentThisFrame(3)
        HideHudComponentThisFrame(4)
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(13)
        HideHudComponentThisFrame(11)
        HideHudComponentThisFrame(12)
        HideHudComponentThisFrame(15)
        HideHudComponentThisFrame(18)
        HideHudComponentThisFrame(19)
    end

    function CheckInputRotation(cam, zoomvalue)
        local rightAxisX = GetDisabledControlNormal(0, 220)
        local rightAxisY = GetDisabledControlNormal(0, 221)
        local rotation = GetCamRot(cam, 2)
        if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
            new_z = rotation.z + rightAxisX * -1.0 * (speed_ud) * (zoomvalue + 0.1)
            new_x = math.max(math.min(20.0, rotation.x + rightAxisY * -1.0 * (speed_lr) * (zoomvalue + 0.1)), -89.5)
            SetCamRot(cam, new_x, 0.0, new_z, 2)
        end
    end

    --[[ function HandleZoom(cam)
        local lPed = PlayerPedId()
        if not (IsPedSittingInAnyVehicle(lPed)) then

            if IsControlJustPressed(0, 241) then
                fov = math.max(fov - zoomspeed, fov_min)
            end
            if IsControlJustPressed(0, 242) then
                fov = math.min(fov + zoomspeed, fov_max)
            end
            local current_fov = GetCamFov(cam)
            if math.abs(fov - current_fov) < 0.1 then
                fov = current_fov
            end
            SetCamFov(cam, current_fov + (fov - current_fov) * 0.05)
        else
            if IsControlJustPressed(0, 17) then
                fov = math.max(fov - zoomspeed, fov_min)
            end
            if IsControlJustPressed(0, 16) then
                fov = math.min(fov + zoomspeed, fov_max)
            end
            local current_fov = GetCamFov(cam)
            if math.abs(fov - current_fov) < 0.1 then
                fov = current_fov
            end
            SetCamFov(cam, current_fov + (fov - current_fov) * 0.05)
        end
    end ]]

    ---------------------------------------------------------------------------
    -- Toggling Mic --
    ---------------------------------------------------------------------------
    function TooglemicWeazel()
        if not holdingMic then
            if lifeDuty then
                RequestModel(GetHashKey(micModel))
                while not HasModelLoaded(GetHashKey(micModel)) do
                    Citizen.Wait(0)
                end

                while not HasAnimDictLoaded(micanimDict) do
                    RequestAnimDict(micanimDict)
                    Citizen.Wait(0)
                end
                TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)

                local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
                local micspawned = CreateObject(GetHashKey(micModel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
                Citizen.Wait(1000)
                local netid = ObjToNet(micspawned)
                SetNetworkIdExistsOnAllMachines(netid, true)
                NetworkSetNetworkIdDynamic(netid, true)
                SetNetworkIdCanMigrate(netid, false)
                AttachEntityToEntity(micspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 60309),
                    0.055,
                    0.05, 0.0, 240.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
                TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
                TaskPlayAnim(GetPlayerPed(PlayerId()), micanimDict, micanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
                mic_net = netid
                holdingMic = true
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Vous devez ~s prendre votre service"
                })
            end
        else
            ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
            SetModelAsNoLongerNeeded(GetHashKey(micModel))
            DetachEntity(NetToObj(mic_net), 1, 1)
            DeleteEntity(NetToObj(mic_net))
            mic_net = nil
            holdingMic = false
            usingMic = false
        end
    end

    -- RegisterCommand("mic", function(source, args, raw)
    --     TooglemicWeazel()
    -- end)


    ---------------------------------------------------------------------------
    -- Toggling Boom Mic --
    ---------------------------------------------------------------------------
    function ToogleBmicWeazel()
        if not holdingBmic then
            if lifeDuty then
                RequestModel(GetHashKey(bmicModel))
                while not HasModelLoaded(GetHashKey(bmicModel)) do
                    Citizen.Wait(0)
                end
                TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)

                local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
                local bmicspawned = CreateObject(GetHashKey(bmicModel), plyCoords.x, plyCoords.y, plyCoords.z, true, true, false)
                Citizen.Wait(1000)
                local netid = ObjToNet(bmicspawned)
                SetNetworkIdExistsOnAllMachines(netid, true)
                NetworkSetNetworkIdDynamic(netid, true)
                SetNetworkIdCanMigrate(netid, false)
                AttachEntityToEntity(bmicspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422),
                    -0.08,
                    0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
                TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
                TaskPlayAnim(GetPlayerPed(PlayerId()), bmicanimDict, bmicanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
                bmic_net = netid
                holdingBmic = true
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Vous devez ~s prendre votre service"
                })
            end
        else
            ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
            SetModelAsNoLongerNeeded(GetHashKey(bmicModel))
            DetachEntity(NetToObj(bmic_net), 1, 1)
            DeleteEntity(NetToObj(bmic_net))
            bmic_net = nil
            holdingBmic = false
            usingBmic = false
        end
        Citizen.CreateThread(function()
            while holdingBmic do

                Citizen.Wait(500)
                if holdingBmic then
                    while not HasAnimDictLoaded(bmicanimDict) do
                        RequestAnimDict(bmicanimDict)
                        Citizen.Wait(0)
                    end

                    if not IsEntityPlayingAnim(PlayerPedId(), bmicanimDict, bmicanimName, 3) then
                        TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
                        TaskPlayAnim(GetPlayerPed(PlayerId()), bmicanimDict, bmicanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
                    end

                    DisablePlayerFiring(PlayerId(), true)
                    DisableControlAction(0, 25, true) -- disable aim
                    DisableControlAction(0, 44, true) -- INPUT_COVER
                    DisableControlAction(0, 37, true) -- INPUT_SELECT_WEAPON
                    SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)

                    if (IsPedInAnyVehicle(PlayerPedId(), -1) and GetPedVehicleSeat(PlayerPedId()) == -1) or
                        IsPedCuffed(PlayerPedId()) or holdingMic then
                        ClearPedSecondaryTask(PlayerPedId())
                        DetachEntity(NetToObj(bmic_net), 1, 1)
                        DeleteEntity(NetToObj(bmic_net))
                        bmic_net = nil
                        holdingBmic = false
                        usingBmic = false
                        return
                    end
                end
            end
        end)
    end

    function drawRct(x, y, width, height, r, g, b, a)
        DrawRect(x + width / 2, y + height / 2, width, height, r, g, b, a)
    end

    function Breaking(text)
        SetTextColour(255, 255, 255, 255)
        SetTextFont(8)
        SetTextScale(1.2, 1.2)
        SetTextWrap(0.0, 1.0)
        SetTextCentre(false)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 205)
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(0.2, 0.85)
    end


    function WeazelDuty()
        if lifeDuty then
            TriggerServerEvent('core:DutyOff', p:getJob())
            --  ShowNotification("Vous avez ~r~quitté~s~ votre service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s quitté ~c votre service"
            })
            lifeDuty = false
            Wait(5000)
        else
            TriggerServerEvent('core:DutyOn', p:getJob())
            --  ShowNotification("Vous avez ~r~quitté~s~ votre service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s pris ~c votre service"
            })
            lifeDuty = true
            Wait(5000)
        end
    end

    function FactureWeazel()
        if lifeDuty then
            closeUI()
            TriggerEvent("nuiPapier:client:startCreation", 2)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function ImprimanteWeazel()
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "~s Indisponible ~c pour le moment"
        })
    end

    function OpenRadialWeazel()
        if (not openRadial) and (not openTool) then
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
                function SubRadialAutres()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = { elements = {
                            {
                                name = "OBJETS",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/object.svg",
                                action = "OpenWeazelPropsMenu"
                            },
                            {
                                name = "FACTURE",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/billet.svg",
                                action = "FactureWeazel"
                            },
                            {
                                name = "RETOUR",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                action = "MainOpen"
                            },
                            {
                                name = "IMPRIMANTE",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/imprimante.svg",
                                action = "ImprimanteWeazel"
                            }
                        }, 
                        title = "ACTIONS",
                        }
                    }));
                end
                
                function SubRadialAnnonce()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data = { elements = {
                            {
                                name = "ANNONCE LEGAL",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/megaphone.svg",
                                action = "AnnonceAvance"
                            },
                            {
                                name = "ANNONCE ILLEGAL",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/megaphone.svg",
                                action = "AnnonceAvanceIllegal"
                            },
                            {
                                name = "RETOUR",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                action = "MainOpen"
                            },
                        }, 
                        title = "ACTIONS",
                        }
                    }));
                end

                function SubRadialActions()
                    if lifeDuty then
                        SendNuiMessage(json.encode({
                            type = 'openWebview',
                            name = 'RadialMenu',
                            data = { elements = {
                                {
                                    name = "CAMERA",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/camera.svg",
                                    action = "ToogleCamWeazel"
                                },
                                {
                                    name = "PERCHE",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/micPed.svg",
                                    action = "ToogleBmicWeazel"
                                },
                                {
                                    name = "RETOUR",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                    action = "MainOpen"
                                },
                                {
                                    name = "MICROPHONE",
                                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/mic.svg",
                                    action = "TooglemicWeazel"
                                }
                            }, 
                            title = "AUTRES",
                            }
                        }));
                    else
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            content = "Vous devez ~s prendre votre service"
                        })
                    end
                end
                
                function MainOpen()
                    SendNuiMessage(json.encode({
                        type = 'openWebview',
                        name = 'RadialMenu',
                        data =  {elements = {
                            {
                                name = "ANNONCE",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/megaphone.svg",
                                action = "SubRadialAnnonce"
                            },
                            {
                                name = "AUTRES",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/parameter.svg",
                                action = "SubRadialAutres"
                            },
                            {
                                name = "PRISE DE SERVICE",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/checkmark.svg",
                                action = "WeazelDuty"
                            },
                            {
                                name = "ACTIONS",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/action.svg",
                                action = "SubRadialActions"
                            },
                        },  
                        title = "LIFE INVADER"}
                    }));
                end
                MainOpen()
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
    end

    RegisterNUICallback("focusOut", function(data, cb)
        if openTool or openRadial then
            openTool = false
            openRadial = false
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 142, true)
            EnableControlAction(0, 18, true)
            EnableControlAction(0, 322, true)
            EnableControlAction(0, 106, true)
        end
        exports['vNotif']:clearPreview();
        cb({})
    end)

    function AnnonceAvance()
        if lifeDuty then
            closeUI()
            -- SendNuiMessage(json.encode({
            --     type = 'closeWebview',
            -- }))
            Wait(100)
            InsideIllegalAnnonce = false
            SendNuiMessage(json.encode({
                type = 'openWebview',
                name = 'CreateWeazelNews',
                data = {
                    job = "lifeinvader",
                }
            }))
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous n'êtes ~s pas en service"
            }) 
        end
    end

    function AnnonceAvanceIllegal()
        if lifeDuty then
            closeUI()
            -- SendNuiMessage(json.encode({
            --     type = 'closeWebview',
            -- }))
            Wait(100)
            local orga = KeyboardImput("Type d'org (pf, gang, mc, orga, mafia) Vide = toute le monde", "")
            if orga ~= nil or orga ~= "" then 
                ToSendTo = orga
            else
                ToSendTo = "all"
            end
            InsideIllegalAnnonce = true
            SendNuiMessage(json.encode({
                type = 'openWebview',
                name = 'CreateWeazelNews',
                data = {
                    job = "lifeinvader",
                }
            }))
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous n'êtes ~s pas en service"
            }) 
        end
    end

    local open = false
    local weazelmenu_objects = RageUI.CreateMenu("", "menu", 0.0, 0.0, "vision", "menu_title_weazel_news")
    local weazelmenu_objects_delete = RageUI.CreateSubMenu(weazelmenu_objects, "", "menu", 0.0, 0.0, "vision",
        "menu_title_weazel_news")
    weazelmenu_objects.Closed = function()
        open = false
    end
    local function SpawnObject(obj, name)
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

            ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour placer l'objet\n~INPUT_FRONTEND_LEFT~ ou ~INPUT_FRONTEND_RIGHT~ Pour faire pivoter l'objet")
            if IsControlJustPressed(0, 38) then
                placed = true
            end
            Wait(0)
        end
        SetEntityCollision(objS.id, true, true)
        SetEntityInvincible(objS.id, true)
        objS:setFreeze(true)
        objS:resetAlpha()
        local netId = objS:getNetId()
        if netId == 0 then
            objS:delete()
        end
        SetNetworkIdCanMigrate(netId, true)
        table.insert(weazelPropsPlaced, { nom = name, prop = objS.id })
    end

    function OpenWeazelPropsMenu()
        if lifeDuty then
            if open then
                open = false
                RageUI.Visible(weazelmenu_objects, false)
            else
                open = true
                RageUI.Visible(weazelmenu_objects, true)
                closeUI()

                Citizen.CreateThread(function()
                    while open do
                        RageUI.IsVisible(weazelmenu_objects, function()
                            RageUI.Button("Supprimer mes props", nil, {}, true, {}, weazelmenu_objects_delete)
                            for k, v in pairs(weazel.props) do
                                RageUI.Button(v.nom, nil, {}, true, {
                                    onSelected = function()
                                        SpawnObject(v.prop, v.nom)
                                    end
                                })
                            end
                        end)
                        RageUI.IsVisible(weazelmenu_objects_delete, function()
                            for k, v in pairs(weazelPropsPlaced) do
                                RageUI.Button(v.nom, nil, {}, true, {
                                    onSelected = function()
                                        DeleteObject(v.prop)
                                        table.remove(weazelPropsPlaced, k)
                                    end,
                                    onActive = function()
                                        DrawMarker(20, GetEntityCoords(v.prop) + vector3(0.0, 0.0, 1.0), 0.0, 0.0, 0.0,
                                            180.0, 0.0, 0.0, 0.5, 0.5, 0.5, 92, 173, 29, 255, true, 1, 0, 0)
                                    end
                                })
                            end
                        end)
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

    RegisterJobMenu(OpenRadialWeazel)
end

function UnLoadLifeInvaderJob()
    zone.removeZone("society_life_delete")
    zone.removeZone("vestiare_life")
    zone.removeZone("society_life")
    zone.removeZone("coffre_life")
    zone.removeZone("life_spawncars")
    zone.removeZone("life_spawnhel")
end

local AnnoncesQueue = {}
RegisterNUICallback("CreateLifeInvader", function(data, cb)
    if p:getJob() == "lifeinvader" then
        data.preview = false
        data.author = p:getFirstname() .. " " .. p:getLastname()

        if IsWaypointActive() then
            data.position = vector3(GetWaypointCoords())
        else
            data.position =  GetEntityCoords(PlayerPedId())
        end

        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
        exports['vNotif']:clearPreview();

        Wait(100)
        TriggerServerEvent('lifeInvaderAnnonce:SendDataForAnnonce', token, data, InsideIllegalAnnonce, ToSendTo)
    end
end)

RegisterNUICallback("PreviewLifeInvader", function(data, cb)
    if p:getJob() == "lifeinvader" then
        data.preview = true
        data.author = p:getFirstname() .. " " .. p:getLastname()
        data.position = nil

        TriggerServerEvent('lifeInvaderAnnonce:SendDataForAnnonce', token, data)
    end
end)

RegisterNetEvent("lifeInvaderAnnonce:showAnnonce")
AddEventHandler("lifeInvaderAnnonce:showAnnonce", function(data, typeIllegal, typeCrew)
    if IsEntityDead(PlayerPedId()) then 
        table.insert(AnnoncesQueue, data)
        return 
    end
    local opened = true
    if p:getJob() ~= "lifeinvader" then
        if typeIllegal == true then 
            if p:getCrew() == "None" then 
                return
            end
            if typeCrew and typeCrew ~= "all" and p:getCrew() ~= "None" then 
                if string.lower(typeCrew) ~= p:getCrewType() then 
                    return
                end
            end
        end
    end

    if data.preview then 
        exports['vNotif']:previewNotifications({
            type = 'WEAZEL',
            category = data.type,
            media = data.media,
            media_url = data.media_url,
            buttons = data.buttons,
            preview = data.preview,
        }) 
    else
        exports['vNotif']:createNotification({
            type = 'WEAZEL',
            category = data.type,
            media = data.media,
            media_url = data.media_url,
            buttons = data.buttons,
            preview = data.preview,
        }) 
    end

    --if data.position ~= nil then
    --    exports['vNotif']:createNotification({
    --        type = 'VIOLET',
    --        duration = 10, -- In seconds, default:  4
    --        content = "Appuyer sur ~K E pour vous rendre à ~s l'évènement"
    --    }) 
    --end

    Wait(100)
    if not IsNuiFocused() then
        SetNuiFocusKeepInput(true)
        SetNuiFocus(true, false)
    end
    CreateThread(function()
        while opened do 
            Wait(1)
            if IsDisabledControlJustPressed(0, 194) or IsDisabledControlJustPressed(0, 202) or IsControlJustPressed(0, 194) or IsControlJustPressed(0, 202) then 
                -- SendNuiMessage(json.encode({
                --     type = 'closeWebview',
                -- }))
                opened = false
                break
            end
            if IsControlJustPressed(0, 38) or IsDisabledControlJustPressed(0, 38) and data.position ~= nil then 
                SetNewWaypoint(data.position.x, data.position.y)
                -- ShowNotification("Position de l'annonce ajouté sur votre GPS")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Position de l'annonce ~s ajouté sur votre GPS"
                })
                opened = false
                break
            end
        end
    end)
    Wait(10000)
    if opened then
        opened = false
    end
end)


RegisterNUICallback("LifeInvMenu", function (data, cb)

    vehs = nil

    for k, v in pairs(spawnPlaces) do
        if vehicle.IsSpawnPointClear(vector3(v.x, v.y, v.z), 3.0) then
            vehs = vehicle.create(data.name, vector4(v), {})
            SetVehicleLivery(vehs, 2)
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

RegisterNUICallback("LifeHelMenu", function (data, cb)
    if vehicle.IsSpawnPointClear(vector3(-1050.341796875, -235.44325256348, 52.511859893799), 3.0) then
        vehs = vehicle.create(data.name, vector4(-1050.341796875, -235.44325256348, 52.511859893799, 87.7909), {})
        SetVehicleLivery(vehs, 0)
        local plate = vehicle.getProps(vehs).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
        --createKeys(plate, model)
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
    else
        -- ShowNotification("Il n'y a pas de place pour le véhicule")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Il n'y a ~s pas de place ~c pour le véhicule"
        })
    end
end)

RegisterNUICallback("armoryTakeLI", function(data, cb)
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


RegisterNUICallback("focusOut", function (data, cb)
    TriggerScreenblurFadeOut(0.5)
    DisplayHud(true)
    openRadarProperly()
end)

Citizen.CreateThread(function()
    print("^3[JOBS]: ^7lifeinvader ^3loaded")
end)