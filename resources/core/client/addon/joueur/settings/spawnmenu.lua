AllPersonnages = nil 
NumberOfPlayerSelected = nil 
local ActivePlayers = 0
local PersoToSend2 = {}

RegisterNetEvent("core:SpawnMenu")
AddEventHandler("core:SpawnMenu",function(numberPlayers)
	--TriggerEvent("sw:allowfrrr", 1)
    --ShutdownLoadingScreenNui()
    --AllPersonnages = TriggerServerCallback("core:GetAllPersoFromPlayer") -- CAll deux fois le perso vu qu'il passe par GetPlayerData() côté serveur ( j'ai pas le temps pour l'opti on sort le server demain)
    --while AllPersonnages == nil do Wait(10) end
    --SpawnedPed = {}
    --local PersoToSend = {}
    --closeUI()
    --Wait(1000)
    --forceHideRadar()
    --ActivePlayers = numberPlayers
--
    --Cam.create("spwan_cam")
    --Cam.setPos("spwan_cam", vector3(-1668.7401123047, -1228.6154785156, 32.216426849365))
    --Cam.setFov("spwan_cam", 40.0)
    --Cam.lookAtCoords("spwan_cam", vector3(-1670.3375244141, -1204.9924316406, 28.980255126953))
--
    --Cam.render("spwan_cam", true, false, 0)
    

    --if #AllPersonnages ~= 0 then
    --    for i=1, #AllPersonnages do
    --        print(jobs[AllPersonnages[i]["job"]])
    --        local jobName = "aucun"
    --        if jobs[AllPersonnages[i]["job"]] ~= nil then
    --            jobName = jobs[AllPersonnages[i]["job"]].label 
    --            print("2", job)
    --        end
    --        table.insert(PersoToSend, {
    --            name = AllPersonnages[i]["firstname"] .. " " .. AllPersonnages[i]["lastname"] ,
    --            job = jobName,
    --            balance = AllPersonnages[i]["balance"]
    --        })
    --    end
    --    local habit= json.decode(AllPersonnages[1]["cloths"]).skin
    --    if habit.sex == 0 then
    --        SpawnedPed[1] = entity:CreatePedLocal("mp_m_freemode_01", vector3(-1669.182, -1222.828, 31.12), 170.0)
    --        SpawnedPed[1]:setFreeze(true)
    --        ApplySkinOnAPed(SpawnedPed[1].id, habit, nil, false)
    --    elseif habit.sex == 1 then
    --        SpawnedPed[1] = entity:CreatePedLocal("mp_f_freemode_01", vector3(-1669.182, -1222.828, 31.12), 180.0)
    --        SpawnedPed[1]:setFreeze(true)
    --        ApplySkinOnAPed(SpawnedPed[1].id, habit, nil, false)
    --    else
    --        SpawnedPed[1] = entity:CreatePedLocal(PedsCharCreator[habit.sex-1], vector3(-1669.182, -1222.828, 31.12), 180.0)
    --        SpawnedPed[1]:setFreeze(true)
    --    end
    --end
    --PersoToSend2 = PersoToSend
    --SendNuiMessage(json.encode({
    --    type = 'openWebview',
    --    name = "MenuConnexion",
    --    data = {
    --        personnages = PersoToSend,
    --        players = tonumber(numberPlayers) or 0,
    --        currentSubscription = 0, -- A FAIRE
    --        maxCharacter = 2,
    --    }
    --}))
    for key, value in pairs(AllPersonnages) do
        if value.active == 1 then NumberOfPlayerSelected = key break end
    end
    if NumberOfPlayerSelected == nil then NumberOfPlayerSelected = 1 end
    --Cam.delete("spwan_cam")
    --for i=1, #SpawnedPed do
    --    DeleteEntity(SpawnedPed[i]:getEntityId())
    --end
    --closeUI()
    --TriggerServerEvent("core:PersonnageSelected", NumberOfPlayerSelected)
    --openRadarProperly()
end)

RegisterCommand("spawnmenu", function()
    if NumberOfPlayerSelected == nil then NumberOfPlayerSelected = 1 end
    Cam.delete("spwan_cam")
    for i=1, #SpawnedPed do
        DeleteEntity(SpawnedPed[i]:getEntityId())
    end
    closeUI()
    TriggerServerEvent("core:PersonnageSelected", NumberOfPlayerSelected)
    openRadarProperly()
	TriggerEvent("sw:allowfrrr", 0)
end)

-- RegisterNUICallback("openBoutique", function(data)  --- Le cb existe deja 
--     -- TriggerScreenblurFadeOut(2000)
-- end)
RegisterNUICallback("openCreationPersonnage", function(data)
    CreateThread(function()
        if NumberOfPlayerSelected == nil then NumberOfPlayerSelected = 1 end
        Cam.delete("spwan_cam")
        closeUI()
        TriggerServerEvent("core:PersonnageSelected", NumberOfPlayerSelected)
        Wait(3000)
        TriggerServerEvent("core:NewPersonnage")
        Wait(3000)
        TriggerEvent("playerSpawned")
        TriggerEvent("sw:allowfrrr", 0)
    end)
end)

RegisterNUICallback("openPatchNote", function(data)

end)

RegisterNUICallback("play", function(data)
    if NumberOfPlayerSelected == nil then NumberOfPlayerSelected = 1 end
    Cam.delete("spwan_cam")
    for i=1, #SpawnedPed do
        DeleteEntity(SpawnedPed[i]:getEntityId())
    end
    closeUI()
    TriggerServerEvent("core:PersonnageSelected", NumberOfPlayerSelected)
    openRadarProperly()
	TriggerEvent("sw:allowfrrr", 0)
end)

RegisterNUICallback("goToCharacterList", function(data)
    
    DeleteEntity(SpawnedPed[1]:getEntityId())
    
    if #AllPersonnages == 2 then
        local PosFor2 = {
            {x= -1670.390, y= -1222.778, z= 31.10},
            {x= -1668.042, y= -1222.778, z= 31.10}
        }
        for i=1, #AllPersonnages do
            local habit= json.decode(AllPersonnages[i]["cloths"]).skin
            if habit.sex == 0 then
                SpawnedPed[i] = entity:CreatePedLocal("mp_m_freemode_01", vector3(PosFor2[i].x, PosFor2[i].y, PosFor2[i].z), 180.0)
                SpawnedPed[i]:setFreeze(true)
                ApplySkinOnAPed(SpawnedPed[i].id, habit, nil, false)
            elseif habit.sex == 1 then
                SpawnedPed[i] = entity:CreatePedLocal("mp_f_freemode_01", vector3(PosFor2[i].x, PosFor2[i].y, PosFor2[i].z), 180.0)
                SpawnedPed[i]:setFreeze(true)
                ApplySkinOnAPed(SpawnedPed[i].id, habit, nil, false)
            else
                SpawnedPed[i] = entity:CreatePedLocal(PedsCharCreator[habit.sex-1], vector3(PosFor2[i].x, PosFor2[i].y, PosFor2[i].z), 180.0)
                SpawnedPed[i]:setFreeze(true)
            end
        end
    elseif #AllPersonnages == 1 then
        local habit= json.decode(AllPersonnages[1]["cloths"]).skin
        if habit.sex == 0 then
            SpawnedPed[1] = entity:CreatePedLocal("mp_m_freemode_01", vector3(-1670.390, -1222.778, 31.10), 180.0)
            SpawnedPed[1]:setFreeze(true)
            ApplySkinOnAPed(SpawnedPed[1].id, habit, nil, false)
        elseif habit.sex == 1 then
            SpawnedPed[1] = entity:CreatePedLocal("mp_f_freemode_01", vector3(-1670.390, -1222.778, 31.10), 180.0)
            SpawnedPed[1]:setFreeze(true)
            ApplySkinOnAPed(SpawnedPed[1].id, habit, nil, false)
        else
            SpawnedPed[1] = entity:CreatePedLocal(PedsCharCreator[habit.sex-1], vector3(-1670.390, -1222.778, 31.10), 180.0)
            SpawnedPed[1]:setFreeze(true)
        end
    end
end)

RegisterNUICallback("selectedCharacter", function(data)
    if #AllPersonnages ~= 0 then
        for i=1, #AllPersonnages do
            DeleteEntity(SpawnedPed[i]:getEntityId())
        end
        for i=1, #AllPersonnages do
            local name = AllPersonnages[i]["firstname"] .. " " .. AllPersonnages[i]["lastname"]
            if tostring(data.name) == tostring(name) then
                NumberOfPlayerSelected = i
                break
            end
        end
        local habit= json.decode(AllPersonnages[NumberOfPlayerSelected]["cloths"]).skin
        if habit.sex == 0 then
            SpawnedPed[1] = entity:CreatePedLocal("mp_m_freemode_01", vector3(-1669.182, -1222.828, 31.12), 180.0)
            SpawnedPed[1]:setFreeze(true)
            ApplySkinOnAPed(SpawnedPed[1].id, habit, nil, false)
        elseif habit.sex == 1 then
            SpawnedPed[1] = entity:CreatePedLocal("mp_f_freemode_01", vector3(-1669.182, -1222.828, 31.12), 180.0)
            SpawnedPed[1]:setFreeze(true)
            ApplySkinOnAPed(SpawnedPed[1].id, habit, nil, false)
        else
            SpawnedPed[1] = entity:CreatePedLocal(PedsCharCreator[habit.sex-1], vector3(-1669.182, -1222.828, 31.12), 180.0)
            SpawnedPed[1]:setFreeze(true)
        end
    end
end)

