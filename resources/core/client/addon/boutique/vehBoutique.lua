VehBoutique = nil
local VehOptions = {}
InsideVehBoutique = false
CamBoutiqueVeh = nil
CamAchatBoutiqueVeh = nil

local VehiclesTry = {
    ["vehicles"] = vector4(-991.08, -3140.22, 12.94, 60.4),
    ["bateaux"] = vector4(-713.15710449219, -1341.4193115234, -1.284569144249, 139.61473083496),
    ["yacht"] = vector4(-713.15710449219, -1341.4193115234, -1.284569144249, 139.61473083496),
    ["voiliers"] = vector4(-713.15710449219, -1341.4193115234, -1.284569144249, 139.61473083496),
    ["jetski"] = vector4(-713.15710449219, -1341.4193115234, -1.284569144249, 139.61473083496),
    ["sousmarins"] = vector4(-713.15710449219, -1341.4193115234, -1.284569144249, 139.61473083496),
    ["avion"] = vector4(-1382.1882324219, -2289.2595214844, 13.587691307068, 150.27235412598),
    ["avions"] = vector4(-1382.1882324219, -2289.2595214844, 13.587691307068, 150.27235412598),
    ["dirigeables"] = vector4(-1382.1882324219, -2289.2595214844, 13.587691307068, 150.27235412598),
    ["planeurs"] = vector4(-1382.1882324219, -2289.2595214844, 13.587691307068, 150.27235412598),
    ["heli"] = vector4(-1382.1882324219, -2289.2595214844, 13.587691307068, 150.27235412598),
    ["helicopters"] = vector4(-1382.1882324219, -2289.2595214844, 13.587691307068, 150.27235412598),
}

local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local DefaultVehicle = nil

local DefaultBoutique = { -- Si y'a pas le JSON boutique
    {
        name = "argento",
        label = "Obey Argento",
        marque = "Obey",
        image = "https://sacul.cloud/img/obey_argento.webp",
        model = "Argento",
        price = 7500,
        priceReduc = 5500,
        category = "sport",
        colors = {"#000000", "#FFFFFF", "#1600ff", "#ff0000"},
        performance = {500, 750, 1000, 1200}
    },
    {
        name = "club",
        label = "BF Club",
        marque = "BF",
        image = "https://sacul.cloud/img/club.webp",
        model = "Club",
        price = 500,
        priceReduc = nil,
        category = "sport",
        colors = {"#000000", "#FFFFFF"},
        performance = {250, 500, 750, 1000}
    }
}

local function LoadingPrompt(loadingText, spinnerType)
    if BusyspinnerIsOn() then
        BusyspinnerOff()
    end
    if (loadingText == nil) then
        BeginTextCommandBusyString(nil)
    else
        BeginTextCommandBusyString("STRING");
        AddTextComponentSubstringPlayerName(loadingText);
    end
    EndTextCommandBusyString(spinnerType)
end

local cooldownVeh = 0

function GetVehiculesBoutique()
    -- Faut faire truc pour trouver la catégorie "VehiculesBoutique"
    -- au final flemme 
    return "tête de noeil frère"
end

local lastCategory = nil
OpenMenuVehBoutique = function(veh, data)
	TriggerEvent("sw:allowfrrr", 1)
    -- Véhicules
    --if string.lower(veh) == "adder" then 
    --    data.name = "seasparrow2"
    --    veh = "seasparrow2"
    --    data.category = "heli"
    --    CamBoutiqueVeh = nil
    --end
    --if string.lower(veh) == "furia" then 
    --    data.name = "miljet"
    --    veh = "miljet"
    --    data.category = "avion"
    --    CamBoutiqueVeh = nil
    --end

    Wait(100)

    --print("data.category", json.encode(data, {indent = true}))

    local coordsVehBoutique = vector4(-790.27740478516, -236.19412231445, 36.52907409668, 168.66012573242)
    local camCoords = vector3(-789.22589111328, -240.6661529541, 37.934058380127)
    
    if data.category == "bateaux" or data.category == "yacht" then
       -- local _, groundZ = GetGroundZFor_3dCoord(-900.24768066406, -1356.8062744141, 0.2, false)
       -- print("groundZ", groundZ)
        coordsVehBoutique = vector4(-948.08532714844, -1362.7911376953, -1.080843552947, 180.0)
        camCoords = vector3(-941.67730712891, -1375.9194335938, 5.1820707321167)
    elseif data.category == "avion" or data.category == "avions" then 
        coordsVehBoutique = vector4(-1266.8576660156, -3013.1684570313, -49.490184783936, 40.814487457275)
        camCoords = vector3(-1276.2513427734, -2993.8767089844, -46.687953948975)
        PinInteriorInMemory(GetInteriorAtCoords(-1266.8576660156, -3013.1684570313, -49.490184783936))
        --print("category avion", camCoords)
    elseif data.category == "heli" then 
        coordsVehBoutique = vector4(-1266.8576660156, -3013.1684570313, -49.490184783936, 40.814487457275)
        camCoords = vector3(-1271.4304199219, -3002.7814941406, -46.489810943604)
        PinInteriorInMemory(GetInteriorAtCoords(-1266.8576660156, -3013.1684570313, -49.490184783936))        
    end

    if data.marque == "Hélicoptère" then 
        data.category = "heli"
        coordsVehBoutique = vector4(-1266.8576660156, -3013.1684570313, -49.490184783936, 40.814487457275)
        camCoords = vector3(-1271.4304199219, -3002.7814941406, -46.489810943604)
        PinInteriorInMemory(GetInteriorAtCoords(-1266.8576660156, -3013.1684570313, -49.490184783936))        
        --print("category heli", camCoords)
    end
    
    forceHideRadar()
    --SetFocusPosAndVel(camCoords)
    SetNuiFocusKeepInput(true)

    if not lastCategory or lastCategory ~= data.category then 
        CamBoutiqueVeh = nil
        lastCategory = data.category
        NewLoadSceneStartSphere(camCoords, 50.0, 0)
        StreamvolCreateSphere(camCoords, 50.0)
        SetFocusPosAndVel(camCoords)
    end

    InsideVehBoutique = true

    CreateThread(function()
        while InsideVehBoutique do 
            Wait(1)
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 18, true)
            DisableControlAction(0, 322, true)
            DisableControlAction(0, 106, true)
            DisableControlAction(0, 24, true) 
            DisableControlAction(0, 25, true) 
            DisableControlAction(0, 263, true) 
            DisableControlAction(0, 264, true) 
            DisableControlAction(0, 257, true) 
            DisableControlAction(0, 140, true) 
            DisableControlAction(0, 141, true) 
            DisableControlAction(0, 142, true) 
            DisableControlAction(0, 143, true)
            DisableControlAction(0, 38, true)
            DisableControlAction(0, 44, true)
        end
    end)

    if VehBoutique then 
        DeleteEntity(VehBoutique.id)
    end

    RequestCollisionAtCoord(camCoords)
    RequestAdditionalCollisionAtCoord(camCoords)
    if not vehicle.IsSpawnPointClear(coordsVehBoutique.xyz, 3.0) then
        for k,v in pairs(vehicle.GetVehicleInArea(coordsVehBoutique.xyz, 3.0)) do 
            DeleteEntity(v)
        end
    end
    
    if data and data.category == "heli" or data.category == "avion" then 
        while not IsInteriorReady(GetInteriorAtCoords(-1266.8576660156, -3013.1684570313, -49.490184783936)) do 
            Wait(1)
        end
    end
    Wait(100)
    if GetGameTimer() - cooldownVeh > 1000 then
        cooldownVeh = GetGameTimer()
    else
        while GetGameTimer() - cooldownVeh < 1000 do 
            Wait(1)
            LoadingPrompt("Chargement du véhicule...", 2)
        end
        BusyspinnerOff()
        cooldownVeh = GetGameTimer()
    end
    if not InsideVehBoutique then 
        if VehBoutique then 
            DeleteEntity(VehBoutique.id)
        end
		RenderScriptCams(false, false, 3000, 1, 0, 0)
        DestroyAllCams(true)
        return
    end
    if VehBoutique then 
        DeleteEntity(VehBoutique.id)
    end
    VehBoutique = entity:CreateVehicleLocal(veh, coordsVehBoutique.xyz, coordsVehBoutique.w)
    if data.category ~= "bateaux" then
        VehBoutique:setFreeze(true)
    else
        VehBoutique:setFreeze(false)
    end
    VehOptions.performance = 1
    SetVehicleEngineOn(VehBoutique.id, true, true, false)
    SetVehicleLights(VehBoutique.id, 2)
    SetVehicleLightsMode(VehBoutique.id, 2)

    if not CamBoutiqueVeh then
        SetCamActiveWithInterp(0, 0, 1000, 1, 1)
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(cam, camCoords)
        SetCamFov(cam, 60.0)
        CamBoutiqueVeh = cam
        if data.category == "bateaux" then
            PointCamAtCoord(cam, coordsVehBoutique)
        end
        PointCamAtEntity(cam, VehBoutique.id, 0, 0, 0, true)
        RenderScriptCams(true, 0, 3000, 1, 1)
        if data.category == "avion" or data.category == "avions" or data.category == "bateaux" or data.category == "yacht" or data.category == "heli" then
        else
            cameraDoF(cam)
        end
    end

    while true do 
        Wait(1)
        if not VehBoutique then 
            break
        end
        if IsControlPressed(0,175) or IsDisabledControlPressed(0,175) or IsControlPressed(0,30) or IsDisabledControlPressed(0,30) then -- droite
            SetEntityHeading(VehBoutique.id, GetEntityHeading(VehBoutique.id)+.15)
        end
        if IsControlPressed(0,174) or IsDisabledControlPressed(0,174) or IsControlPressed(0,34) or IsDisabledControlPressed(0,34) then  -- gayuche
            SetEntityHeading(VehBoutique.id, GetEntityHeading(VehBoutique.id)-.15)            
        end
    end
end

function cameraDoF(cam, neardof, fardof, strengthdof) -- Creates a function called cameraDoF and passes the cam variable as an argument
    SetCamUseShallowDofMode(cam, true) -- Sets the camera to use shallow dof mode
    SetCamNearDof(cam, neardof or 0.6) -- Sets the camera's near dof to the value set in the config file
    SetCamFarDof(cam, fardof or 4.0) -- Sets the camera's far dof to the value set in the config file
    SetCamDofStrength(cam, strengthdof or 0.80) -- Sets the camera's dof strength to the value set in the config file
    SetCamActive(cam, true) -- Sets the camera to active
    RenderScriptCams(true, false, 1, true, true) -- Renders the cameracamera to use shallow dof mode
    CreateThread(function()
        while DoesCamExist(cam) do
            SetUseHiDof() -- Sets the camera to use high dof
            Wait(1)
        end
    end)
end

RegisterNUICallback("mouseUp", function(data)
    if not VehBoutique then return end
    SetCamFov(cam, GetCamFov(cam)-1.0)
end)

RegisterNUICallback("mouseDown", function(data)
    if not VehBoutique then return end
    SetCamFov(cam, GetCamFov(cam)+1.0)
end)

RegisterNUICallback("boutiqueVehColor", function(data)
    if not VehBoutique then return end
    if data.rgb then
        print("RGB Color: " .. VehBoutique.id .. " " .. data.rgb[1] .. " " .. data.rgb[2] .. " " .. data.rgb[3])
        SetVehicleCustomPrimaryColour(VehBoutique.id, tonumber(data.rgb[1]), tonumber(data.rgb[2]), tonumber(data.rgb[3]))
        SetVehicleCustomSecondaryColour(VehBoutique.id, tonumber(data.rgb[1]), tonumber(data.rgb[2]), tonumber(data.rgb[3]))
        SetVehicleExtraColours(VehBoutique.id, 0, 0)
        VehOptions.color = {tonumber(data.rgb[1]), tonumber(data.rgb[2]), tonumber(data.rgb[3])}
    else
        print("Color: " .. json.encode(data))
        if data.black then 
            -- couleur avec code
        elseif data.red then 
            -- couleur avec code
        end
    end
end)

RegisterNuiCallback("boutiqueVehPerf", function(data)
    local perf = data
    print("Perf: " .. perf)
    VehOptions.performance = perf
end)

RegisterNUICallback("focusOut", function(data)
    if InsideVehBoutique then
        SetFocusPosAndVel(GetEntityCoords(PlayerPedId()))
        ClearFocus()
        TriggerEvent("sw:allowfrrr", 0)
        DeleteEntity(VehBoutique.id)
        VehBoutique = nil
        DestroyCam(CamBoutiqueVeh)
		RenderScriptCams(false, false, 3000, 1, 0, 0)
        DestroyAllCams(true)
        openRadarProperly()
        CamBoutiqueVeh = nil
        InsideVehBoutique = false
        VehOptions = {}
        ClearFocus()
    end
    InsideVehBoutique = false
end)

RegisterNUICallback("boutiqueVehSelect", function(data)
    if not data then return end
    --print("data", data, json.encode(data, {indent = true}), data.name)
    if data.name then 
        OpenMenuVehBoutique(data.name, data)
    end
end)

local insideAchat = false
RegisterNUICallback("boutiqueVehBuy", function(data)
    -- Je fais le coté serv d'abord
    if not insideAchat then 
        if not data then return end
        insideAchat = true
        printDev(json.encode(data))
        --if string.lower(data.name) == "adder" then 
        --    data.name = "miljet"
        --    data.category = "avion"
        --end

        --if string.lower(data.name) == "adder" then 
        --    data.name = "seasparrow2"
        --    veh = "seasparrow2"
        --    data.category = "heli"
        --end
        --if string.lower(data.name) == "furia" then 
        --    data.name = "miljet"
        --    data.category = "avion"
        --end

        --if VehBoutique and DoesEntityExist(VehBoutique.id) then 
        --    if VehOptions.performance >= 3 then 
        --        print("Sup a trois get max ", VehBoutique.id, DoesEntityExist(VehBoutique.id), VehOptions.performance, GetNumVehicleMods(VehBoutique.id, 11)-1)
        --        VehOptions.performance = GetNumVehicleMods(VehBoutique.id, 11)-1
        --    end
        --end

        DoScreenFadeOut(500)
        Wait(500)
        TriggerServerEvent("core:boutiquevehicule:buyCar", data.name, data.price, VehOptions.performance, VehOptions.color, data.category)
        closeUI()
        Wait(750)
        DoScreenFadeIn(700)
        insideAchat = false
    end
end)

RegisterNUICallback("boutiqueVehTry", function(data)
    printDev("boutiqueVehTry", json.encode(data))
    if not data then return end
    DoScreenFadeOut(500)
    Wait(500)
    TriggerServerEvent("core:boutiquevehicule:tryCar", data.name, data.category, GetEntityCoords(PlayerPedId()), VehOptions.color, VehOptions.performance)
    closeUI()
    Wait(750)
    DoScreenFadeIn(700)
end)

inTryVeh = false
RegisterNetEvent("core:boutiqueveh:try", function(name, category, oldcoords, colors, perf)
    local gcoords = nil
    printDev("Category try ", category, "colors", colors, "perf", perf)
    if not VehiclesTry[category] then 
        gcoords = VehiclesTry["vehicles"]
    else
        gcoords = VehiclesTry[category]
    end
    DoScreenFadeOut(500)
    inTryVeh = true
    SetEntityCoords(PlayerPedId(), gcoords.xyz)
    PinInteriorInMemory(GetInteriorAtCoords(gcoords.xyz))
    RequestCollisionAtCoord(gcoords.xyz)
    RequestAdditionalCollisionAtCoord(gcoords.xyz)
    Wait(100)
    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do 
        Wait(1)
    end
    SetFocusPosAndVel(gcoords.xyz)
    SetEntityCoords(PlayerPedId(), gcoords.xyz)
    local vehicle2 = vehicle.create(name, gcoords,
        {})
    local plate = vehicle.getProps(vehicle2).plate
    local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle2)))
    local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehicle2, VehToNet(vehicle2), p:getJob())
    --createKeys(plate, model)
    local random = math.random(100,999)
    Wait(500)
    tryPlate = "ESSAI" .. random
    SetVehicleNumberPlateText(vehicle2, "ESSAI" .. random)
    TriggerServerEvent("core:GiveVehicleKeyToPlayer", token, "ESSAI" .. random)
    TaskWarpPedIntoVehicle(p:ped(), vehicle2, -1)
    ClearFocus()
    DoScreenFadeIn(500)
    if colors and colors[1] then
        SetVehicleCustomPrimaryColour(vehicle2, tonumber(colors[1]), tonumber(colors[2]), tonumber(colors[3]))
        SetVehicleCustomSecondaryColour(vehicle2, tonumber(colors[1]), tonumber(colors[2]), tonumber(colors[3]))
    end

    if perf then
        SetVehicleMod(vehicle2, 11, perf > 3 and 3 or perf, false)
        SetVehicleMod(vehicle2, 12, perf > 2 and 2 or perf, false)
        SetVehicleMod(vehicle2, 13, perf > 2 and 2 or perf, false)
        if perf == 5 then 
            ToggleVehicleMod(vehicle2, 18, true)
        end
    end
    
    exports['aHUD']:toggleVehicleInTry(true, model)
    local timer = GetGameTimer() + 60000*2
    ClearFocus()
    while inTryVeh do
        --ShowHelpNotification("~INPUT_CELLPHONE_OPTION~ Terminer l'essai")
        if GetGameTimer() > timer then
            local vehicle2 = GetVehiclePedIsIn(p:ped(), false)
            TriggerEvent('persistent-vehicles/forget-vehicle', vehicle2)
            --removeKeys(GetVehicleNumberPlateText(vehicle2), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle2))))
            TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehicle2))
            TriggerServerEvent("core:boutique:finishedtest")
            DeleteEntity(vehicle2)
            SetEntityCoords(PlayerPedId(), oldcoords)

            -- ShowNotification("~r~Le délai a été dépassé")
            exports['aHUD']:toggleVehicleInTry(false, nil)
            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Le délai a été dépassé"
            })

            inTryVeh = false
            TriggerServerEvent('core:unsetTryCar', "boutique")
            return
        elseif IsControlJustPressed(0, 178) then
            -- ShowNotification("~r~Vous avez annulé le test")
            exports['aHUD']:toggleVehicleInTry(false, nil)
            -- New notif
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s annulé ~c le test"
            })
            TriggerServerEvent("core:boutique:finishedtest")

            TriggerEvent('persistent-vehicles/forget-vehicle', vehicle2)
            --removeKeys(GetVehicleNumberPlateText(vehicle2), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle2))))
            TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehicle2))
            DeleteEntity(vehicle2)
            SetEntityCoords(PlayerPedId(), oldcoords)
            inTryVeh = false
            TriggerServerEvent('core:unsetTryCar', "boutique")
            return
        end
        Wait(0)
    end
end)

local VehBoutiqueSpawns = {
    vector4(-826.52880859375, -236.76245117188, 36.082553863525, 210.74383544922),
    vector4(-829.54510498047, -231.72207641602, 36.124488830566, 207.39096069336),
    vector4(-832.4990234375, -226.43653869629, 36.178089141846, 209.27751159668),
    vector4(-835.60681152344, -221.25099182129, 36.226375579834, 212.68315124512),
    vector4(-838.47265625, -216.27589416504, 36.283782958984, 210.01751708984),
    vector4(-850.83874511719, -194.78535461426, 36.474067687988, 210.20367431641),
    vector4(-853.8828125, -189.5463104248, 36.52262878418, 210.20614624023),
    vector4(-856.45178222656, -184.84901428223, 36.63313293457, 209.14874267578),
}

local BateauBoutiqueSpawns = {
    vector4(-873.61743164063, -1369.0006103516, -0.62541460990906, 199.79559326172),
    vector4(-867.38610839844, -1386.2838134766, -0.59623366594315, 200.18618774414),
    vector4(-856.74774169922, -1415.2376708984, -0.61901104450226, 200.18031311035),
    vector4(-843.3525390625, -1451.7061767578, -0.61315381526947, 200.17768859863),
    vector4(-903.48950195313, -1449.0444335938, -0.73565050959587, 289.91802978516),
}

local AvionBoutiqueSpawns = {
    vector4(-1337.5386962891, -2212.8576660156, 12.947897911072, 148.37380981445),
    vector4(-1284.3984375, -2184.9450683594, 12.94455909729, 58.497547149658),
    vector4(-1286.4169921875, -2247.9943847656, 12.947237968445, 326.97308349609),
    vector4(-1368.3571777344, -2389.3212890625, 12.954530715942, 330.03860473633),
    vector4(-1226.3178710938, -2256.2231445313, 12.944529533386, 56.610195159912),
}

local HeliBoutiqueSpawns = {
    vector4(-745.25604248047, -1468.3463134766, 4.0005226135254, 143.12794494629),
    vector4(-724.56091308594, -1444.0493164063, 4.0005226135254, 132.1538848877),

}

function StartBoutiqueCam(entity, fov, category)
    forceHideRadar()
    ClearFocus()
    
    local coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
    local camCoords = (coords + forward * -2.5)
    
    local ecoords, eforward = GetEntityCoords(entity), GetEntityForwardVector(entity)
    local behindcamCoords = (ecoords + vector3(0.0, 0.0, 2.0) + eforward * -3.5)
    
    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camCoords, 0, 0, 0, fov * 1.0)
    CamAchatBoutiqueVeh = cam

    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, false)
    TaskWarpPedIntoVehicle(PlayerPedId(), entity, -1)
    
    local offsetCoords = GetOffsetFromEntityGivenWorldCoords(entity, GetEntityCoords(entity))
    local prochaine = vec3(offsetCoords.x-4.5, offsetCoords.y-3.0, offsetCoords.z+1.5)

    if category == "bateaux" or category == "yacht" then
        SetCamParams(cam, offsetCoords.x+8.5, offsetCoords.y+6.0, offsetCoords.z+2.0, 17.568, -0.0024, 117.87, 50.0, 1, 1, 3, 1)
        AttachCamToEntity(cam, entity, offsetCoords.x+8.5, offsetCoords.y+6.0, offsetCoords.z+2.0, true)
        prochaine = vec3(offsetCoords.x-8.5, offsetCoords.y-6.0, offsetCoords.z+2.0)
    elseif category == "avion" or category == "avions" or category == "heli" then 
        SetCamParams(cam, offsetCoords.x+13.5, offsetCoords.y+8.0, offsetCoords.z+2.0, 17.568, -0.0024, 117.87, 50.0, 1, 1, 3, 1)
        AttachCamToEntity(cam, entity, offsetCoords.x+13.5, offsetCoords.y+8.0, offsetCoords.z+2.0, true)
        prochaine = vec3(offsetCoords.x-13.5, offsetCoords.y-8.0, offsetCoords.z+2.0)
    else
        prochaine = vec3(offsetCoords.x-4.5, offsetCoords.y-3.0, offsetCoords.z+1.5)
        SetCamParams(cam, offsetCoords.x+4.5, offsetCoords.y+3.0, offsetCoords.z+1.5, 17.568, -0.0024, 117.87, 50.0, 1, 1, 3, 1)
        AttachCamToEntity(cam, entity, offsetCoords.x+4.5, offsetCoords.y+3.0, offsetCoords.z+1.5, true)
    end
    PointCamAtEntity(cam, entity)
    Wait(3000)
    DetachCam(cam)
    --AttachCamToEntity(cam, entity, offsetCoords.x-4.5, offsetCoords.y-3.0, offsetCoords.z+1.5, true)
    SetCamParams(cam, prochaine, 17.568, -0.0024, 117.87, 50.0, 300, 1, 3, 1)
    AttachCamToEntity(cam, entity, prochaine, true)
    PointCamAtEntity(cam, entity)
    Wait(3000)
    DetachCam(cam)
    SetCamParams(cam, behindcamCoords, 17.568, -0.0024, 117.87, 50.0, 900, 1, 3, 1)
    --AttachCamToEntity(cam, entity, behindcamCoords, true)
    PointCamAtEntity(cam, entity)
    Wait(600)
    ClearFocus()
    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(CamAchatBoutiqueVeh)
    openRadarProperly()
end

-- local spawnBoutiqueCars = {
--     ["supersportive"] = true,
--     ["suv"] = true,
--     ["muscles"] = true,
--     ["sportclassic"] = true,
--     ["sport"] = true,
--     ["van"] = true,
--     ["toutterrain"] = true,
--     ["compact"] = true,
--     ["sedans"] = true,
--     ["coupe"] = true,
--     ["moto"] = true,
--     ["lore"] = true,
--     ["dlc"] = true,
--     ["addon"] = true,
-- }

RegisterNetEvent("core:spawnboutiqueVehiclePayant")
AddEventHandler("core:spawnboutiqueVehiclePayant", function(model, props, category)
    local Heading = GetEntityHeading(PlayerPedId())
    local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
    local goodCoords = vector4(x,y,z,Heading)
    print("Category", category, VehiclesTry[category])
    if category == "bateaux" or category == "yacht" then VehBoutiqueSpawns = BateauBoutiqueSpawns end
    if category == "avion" or category == "avions" then VehBoutiqueSpawns = AvionBoutiqueSpawns end
    if category == "heli" or category == "helicopters" or category == "planeurs" or category == "dirigeables" then VehBoutiqueSpawns = HeliBoutiqueSpawns end
    for k,v in pairs(VehBoutiqueSpawns) do 
        if vehicle.IsSpawnPointClear(v.xyz, 3.0) then
            goodCoords = v
            break
        end
    end
    --print(json.encode(props, {indent = true}))
    local vec = goodCoords
    local veh = vehicle.create(model, vec, props)
    vehicle.setProps(veh, props)
    TriggerServerEvent("core:SetVehicleOut", string.upper(props.plate), VehToNet(veh), veh)
    TriggerServerEvent("core:SetPropsVeh", token, all_trim(props.plate), vehicle.getProps(veh))
    SetVehicleDoorsLocked(veh, 2)
    SetFocusEntity(veh)
    local timere = 1
    while not veh or not DoesEntityExist(veh) do 
        Wait(1)
        timere += 1
        if timere > 600 then 
            break
        end
    end
    NetworkRequestControlOfEntity(veh)
    while not NetworkHasControlOfEntity(veh) do Wait(1) end
    SetEntityAsMissionEntity(veh, true, true)
    if props and props.modBrakes then 
        if GetNumVehicleMods(veh,11)-1 < props.modEngine then 
            print("New modEngine", props.modEngine, GetNumVehicleMods(veh,11)-1)
            props.modEngine = GetNumVehicleMods(veh,11)-1
        end
        if GetNumVehicleMods(veh,12)-1 < props.modBrakes then 
            print("New modBrakes", props.modBrakes, GetNumVehicleMods(veh,12)-1)
            props.modBrakes = GetNumVehicleMods(veh,12)-1
        end
        if GetNumVehicleMods(veh,13)-1 < props.modTransmission then 
            print("New transmission", props.modTransmission, GetNumVehicleMods(veh,13)-1)
            props.modTransmission = GetNumVehicleMods(veh,13)-1
        end
        SetVehicleMod(veh, 12, props.modBrakes, true)
        SetVehicleMod(veh, 13, props.modTransmission, true)
        SetVehicleMod(veh, 11, props.modEngine, true)
        if props.modTurbo then 
            ToggleVehicleMod(veh, 18, true)
        end
        TriggerServerEvent("core:SetPropsVeh", token, all_trim(GetVehicleNumberPlateText(veh)), vehicle.getProps(veh))
    end
    if timere < 600 then
        SpawnVehBoutique(veh, category)
    else
        exports['vNotif']:createNotification({
            type = 'ILLEGAL',
            name = "Boutique",
            label = "ERREUR ACHAT",
            labelColor = "#7BAFD4",
            logo = "https://cdn.discordapp.com/attachments/1159274660307947572/1189992615005921280/DEVELOPPEURS.webp",
            mainMessage = "Envoyez ce message au staff pour vous faire rembourser : ".. model .. " / ".. props.modEngine .. " !",
            duration = 60,
        })
    end
end)

--RegisterCommand("testVeh", function()
--    TriggerEvent("core:spawnboutiqueVehiclePayant", "addeer", {plate = "555d5", modEngine = 4})
--end)

function SpawnVehBoutique(vehent, category)
    --[[ exports['vNotif']:createNotification({
        type = 'ILLEGAL',
        name = "Boutique",
        label = "ACHAT VEHICULE",
        labelColor = "#F0E68C",
        logo = "https://cdn.sacul.cloud/v2/vision-cdn/icons/logo.webp",
        mainMessage = "Vous venez d'acheter ce véhicule !",
        duration = 10,
    }) ]]
    StartBoutiqueCam(vehent, 40.0, category)
end